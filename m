Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29CA5D6257
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 14:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbfJNMVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 08:21:30 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59566 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726169AbfJNMVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 08:21:30 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 24CA7D7B711912EB37B1;
        Mon, 14 Oct 2019 20:21:28 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 14 Oct 2019
 20:21:23 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     <linux-block@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <axboe@kernel.dk>, <ast@kernel.org>
CC:     <hare@suse.com>, <osandov@fb.com>, <ming.lei@redhat.com>,
        <damien.lemoal@wdc.com>, <bvanassche@acm.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>
Subject: [RFC PATCH 2/2] selftests/bpf: add test program for redirecting IO completion CPU
Date:   Mon, 14 Oct 2019 20:28:33 +0800
Message-ID: <20191014122833.64908-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191014122833.64908-1-houtao1@huawei.com>
References: <20191014122833.64908-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A simple round-robin strategy is implemented to redirect the IO
completion handling to all online CPUs or specific CPU set cyclically.

Using the following command to distribute the IO completion of vda
to all online CPUs:

	./test_blkdev_ccpu -d /dev/vda

And the following command to distribute the IO completion of nvme0n1
to a specific CPU set:
	./test_blkdev_ccpu -d /dev/nvme0n1 -s 4,8,10-13

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tools/include/uapi/linux/bpf.h                |   2 +
 tools/lib/bpf/libbpf.c                        |   1 +
 tools/lib/bpf/libbpf_probes.c                 |   1 +
 tools/testing/selftests/bpf/Makefile          |   1 +
 .../selftests/bpf/progs/blkdev_ccpu_rr.c      |  66 +++++
 .../testing/selftests/bpf/test_blkdev_ccpu.c  | 246 ++++++++++++++++++
 6 files changed, 317 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/blkdev_ccpu_rr.c
 create mode 100644 tools/testing/selftests/bpf/test_blkdev_ccpu.c

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 77c6be96d676..36aa35e29be2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -173,6 +173,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	BPF_PROG_TYPE_BLKDEV,
 };
 
 enum bpf_attach_type {
@@ -199,6 +200,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_UDP6_RECVMSG,
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
+	BPF_BLKDEV_IOC_CPU,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e0276520171b..5a849d6d30be 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3579,6 +3579,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_BLKDEV:
 		return false;
 	case BPF_PROG_TYPE_KPROBE:
 	default:
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 4b0b0364f5fc..311e13e778a3 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -102,6 +102,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_BLKDEV:
 	default:
 		break;
 	}
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6889c19a628c..6a36234adfea 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -30,6 +30,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_btf_dump test_cgroup_attach xdping
+TEST_GEN_PROGS += test_blkdev_ccpu
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
diff --git a/tools/testing/selftests/bpf/progs/blkdev_ccpu_rr.c b/tools/testing/selftests/bpf/progs/blkdev_ccpu_rr.c
new file mode 100644
index 000000000000..6f66d51fe6af
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/blkdev_ccpu_rr.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Hou Tao <houtao1@huawei.com>
+ */
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+/* Index to CPU set */
+struct bpf_map_def SEC("maps") idx_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32),
+	.max_entries = 1,
+};
+BPF_ANNOTATE_KV_PAIR(idx_map, __u32, __u32);
+
+/* Size of CPU set */
+struct bpf_map_def SEC("maps") cnt_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32),
+	.max_entries = 1,
+};
+BPF_ANNOTATE_KV_PAIR(cnt_map, __u32, __u32);
+
+/* CPU set */
+struct bpf_map_def SEC("maps") cpu_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32),
+	.max_entries = 256,
+};
+BPF_ANNOTATE_KV_PAIR(cpu_map, __u32, __u32);
+
+SEC("ccpu_demo")
+int customized_round_robin_ccpu(void *ctx)
+{
+	__u32 key = 0;
+	__u32 *idx_ptr;
+	__u32 *cnt_ptr;
+	__u32 *cpu_ptr;
+	__u32 idx;
+	__u32 cnt;
+
+	idx_ptr = bpf_map_lookup_elem(&idx_map, &key);
+	if (!idx_ptr)
+		return -1;
+	idx = (*idx_ptr)++;
+
+	cnt_ptr = bpf_map_lookup_elem(&cnt_map, &key);
+	if (!cnt_ptr)
+		return -1;
+	cnt = *cnt_ptr;
+	if (!cnt)
+		return -1;
+
+	idx %= cnt;
+	cpu_ptr = bpf_map_lookup_elem(&cpu_map, &idx);
+	if (!cpu_ptr)
+		return -1;
+
+	return *cpu_ptr;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/test_blkdev_ccpu.c b/tools/testing/selftests/bpf/test_blkdev_ccpu.c
new file mode 100644
index 000000000000..ec5981e7e2ed
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_blkdev_ccpu.c
@@ -0,0 +1,246 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Hou Tao <houtao1@huawei.com>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <assert.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "bpf_util.h"
+#include "bpf_rlimit.h"
+
+static int
+print_all_levels(enum libbpf_print_level level,
+		 const char *format, va_list args)
+{
+	return vfprintf(stderr, format, args);
+}
+
+static void sig_handler(int num)
+{
+}
+
+static int parse_cpu_set(const char *str, const unsigned int **cpus,
+	int *cpu_nr)
+{
+	int total;
+	unsigned int *set;
+	int err;
+	int idx;
+	const char *from;
+
+	total = libbpf_num_possible_cpus();
+	if (total <= 0)
+		return -1;
+
+	set = calloc(total, sizeof(*set));
+	if (!set) {
+		printf("Failed to alloc cpuset (cpu nr: %d)\n", total);
+		return -1;
+	}
+
+	if (!str) {
+		for (idx = 0; idx < total; idx++)
+			set[idx] = idx;
+		*cpus = set;
+		*cpu_nr = total;
+
+		return 0;
+	}
+
+	err = 0;
+	idx = 0;
+	from = str;
+	while (1) {
+		char *endptr;
+		int start;
+		int end;
+
+		start = strtol(from, &endptr, 10);
+		if (*endptr != '-' && *endptr != ',' &&
+			(*endptr != '\0' || endptr == from)) {
+			err = -1;
+			break;
+		}
+		if (*endptr == '\0' || *endptr == ',') {
+			printf("add cpu %d\n", start);
+			set[idx++] = start;
+			if (*endptr == '\0')
+				break;
+		}
+		from = endptr + 1;
+		if (*endptr == ',')
+			continue;
+
+		end = strtol(from, &endptr, 10);
+		if (*endptr != ',' && (*endptr != '\0' || endptr == from)) {
+			err = -1;
+			break;
+		}
+		for (; start <= end; start++) {
+			printf("add cpu %d\n", start);
+			set[idx++] = start;
+		}
+		if (*endptr == '\0')
+			break;
+		from = endptr + 1;
+	}
+
+	if (err) {
+		printf("invalid cpu set spec '%s'\n", from);
+		free(set);
+		return -1;
+	}
+
+	*cpus = set;
+	*cpu_nr = idx;
+
+	return 0;
+}
+
+static int load_cpu_set(struct bpf_object *obj, const unsigned int *cpus,
+	int cnt)
+{
+	const char *name;
+	struct bpf_map *map;
+	int fd;
+	int idx;
+
+	name = "cpu_map";
+	map = bpf_object__find_map_by_name(obj, name);
+	if (!map) {
+		printf("no map %s\n", name);
+		return -1;
+	}
+
+	fd = bpf_map__fd(map);
+	if (fd < 0) {
+		printf("invalid fd for map %s\n", name);
+		return -1;
+	}
+
+	for (idx = 0; idx < cnt; idx++) {
+		if (bpf_map_update_elem(fd, &idx, &cpus[idx], 0)) {
+			printf("%s[%u] = %u error %s\n",
+					name, idx, cpus[idx], strerror(errno));
+			return -1;
+		}
+		printf("%s[%u] = %u\n", name, idx, cpus[idx]);
+	}
+
+	name = "cnt_map";
+	map = bpf_object__find_map_by_name(obj, name);
+	if (!map) {
+		printf("no map %s\n", name);
+		return -1;
+	}
+
+	fd = bpf_map__fd(map);
+	if (fd < 0) {
+		printf("invalid fd for map %s\n", name);
+		return -1;
+	}
+
+	idx = 0;
+	if (bpf_map_update_elem(fd, &idx, &cnt, 0)) {
+		printf("%s[%u] = %u error %s\n",
+				name, idx, cnt, strerror(errno));
+		return -1;
+	}
+	printf("%s[%u] = %u\n", name, idx, cnt);
+
+	return 0;
+}
+
+static void usage(const char *cmd)
+{
+	printf("Usage: %s -d blk_device [-s cpu_set]\n"
+			"  round-robin all CPUs: %s -d /dev/sda\n"
+			"  round-robin specific CPUs: %s -d /dev/sda -s 4-7,12-15\n",
+			cmd, cmd, cmd);
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	int opt;
+	const char *prog = "./blkdev_ccpu_rr.o";
+	const char *bdev;
+	const char *cpu_set_str = NULL;
+	const unsigned int *cpus;
+	int cpu_nr;
+	struct bpf_object *obj;
+	int prog_fd;
+	int bdev_fd;
+
+	while ((opt = getopt(argc, argv, "d:s:h")) != -1) {
+		switch (opt) {
+		case 'd':
+			bdev = optarg;
+			break;
+		case 's':
+			cpu_set_str = optarg;
+			break;
+		case 'h':
+			usage(argv[0]);
+			break;
+		}
+	}
+
+	if (!bdev)
+		usage(argv[0]);
+
+	printf("blk device %s, cpu set %s\n", bdev, cpu_set_str);
+
+	signal(SIGINT, sig_handler);
+	signal(SIGQUIT, sig_handler);
+
+	libbpf_set_print(print_all_levels);
+
+	if (parse_cpu_set(cpu_set_str, &cpus, &cpu_nr))
+		goto out;
+
+	if (bpf_prog_load(prog, BPF_PROG_TYPE_BLKDEV, &obj, &prog_fd)) {
+		printf("Failed to load %s\n", prog);
+		goto out;
+	}
+
+	if (load_cpu_set(obj, cpus, cpu_nr))
+		goto out;
+
+	bdev_fd = open(bdev, O_RDWR);
+	if (bdev_fd < 0) {
+		printf("Failed to open %s %s\n", bdev, strerror(errno));
+		goto out;
+	}
+
+	/* Attach bpf program */
+	if (bpf_prog_attach(prog_fd, bdev_fd, BPF_BLKDEV_IOC_CPU, 0)) {
+		printf("Failed to attach %s %s\n", prog, strerror(errno));
+		goto out;
+	}
+
+	printf("Attached, use Ctrl-C to detach\n\n");
+
+	pause();
+
+	if (bpf_prog_detach(bdev_fd, BPF_BLKDEV_IOC_CPU)) {
+		printf("Failed to detach %s %s\n", prog, strerror(errno));
+		goto out;
+	}
+
+	return 0;
+out:
+	return 1;
+}
-- 
2.22.0

