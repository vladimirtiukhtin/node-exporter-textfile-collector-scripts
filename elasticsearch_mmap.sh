#!/usr/bin/env bash

# Total mmap count

limit=$(sysctl -n vm.max_map_count)

echo "# HELP node_memory_map_count Memory maps limit"
echo "# TYPE node_memory_map_count gauge"
echo "node_memory_map_count{} ${limit}"

# Elasticsearch process mmap count

echo "# HELP process_memory_map_count Number of memory maps per process"
echo "# TYPE process_memory_map_count gauge"

for pid in $(pgrep -f Elastic); do
  if [ -r "/proc/${pid}/maps" ]; then
    count=$(wc -l < /proc/${pid}/maps)
    echo "process_memory_map_count{pid=\"${pid}\"} ${count}"
  fi
done
