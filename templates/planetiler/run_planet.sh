#!/usr/bin/env bash

DATE=$(date +"%Y%m%d_%H%M%S")

RUN_FOLDER="/data/planetiler/runs/$DATE"

mkdir -p "$RUN_FOLDER"
cd "$RUN_FOLDER" || exit

java -Xmx20g \
  -jar /data/planetiler/bin/planetiler.jar \
  `# Download the latest planet.osm.pbf from s3://osm-pds bucket` \
  --area=planet --bounds=planet --download \
  `# Accelerate the download by fetching the 10 1GB chunks at a time in parallel` \
  --download-threads=10 --download-chunk-size-mb=1000 \
  `# Also download name translations from wikidata` \
  --fetch-wikidata \
  --output=output.mbtiles \
  `# Store temporary node locations at fixed positions in a memory-mapped file` \
  --nodemap-type=array --storage=mmap \
  > "output_$DATE.log"
