#!/bin/bash

#Update Images
for IMAGE in $(docker images -q); do
	REPO=$(docker inspect --format "{{.RepoTags}}" $IMAGE | sed "s/\[//g" | sed "s/\]//g");
	REPO_NAME=$(echo $REPO | cut -d':' -f1);
    REPO_TAG=$(echo $REPO | cut -d':' -f2);
	docker pull $REPO_NAME:$REPO_TAG > /dev/null 2>&1 ;
done

for CONTAINER in $(docker ps -qa); do
    NAME=$(docker inspect --format {{'.Name'}} $CONTAINER | sed "s/\///g");
    REPO=$(docker inspect --format {{'.Config.Image'}} $CONTAINER);
   
    IMG_RUNNING=$(docker inspect --format {{'.Image'}} $CONTAINER);
    IMG_LATEST=$(docker images -aq --no-trunc $REPO);

    if [ "$IMG_RUNNING" == "$IMG_LATEST" ]; then
        UPDATED="true";
    else
        UPDATED="false";
    fi

    echo $NAME $UPDATED
done
