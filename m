Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B986D479F3E
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 06:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhLSFHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 00:07:35 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:33871 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhLSFHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 00:07:33 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JGrLQ6WqWzcbs8;
        Sun, 19 Dec 2021 13:07:10 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Sun, 19 Dec
 2021 13:07:31 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>,
        <yunbo.xufeng@linux.alibaba.com>
Subject: [RFC PATCH bpf-next 3/3] selftests/bpf: add benchmark for string-key hash-table
Date:   Sun, 19 Dec 2021 13:22:45 +0800
Message-ID: <20211219052245.791605-4-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211219052245.791605-1-houtao1@huawei.com>
References: <20211219052245.791605-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It defines two hash-tables: one with fixed-size bytes as key and another
with string key. The content and the length of strings are constructed
by using random().

Four benchmarks are added to compare the lookup and update performances
on bytes-hash and string-hash respectively. The performance win is about
16% and 106% under x86-64 and arm64 when key_size is 256 and increase to
45% and 161% when key_size is greater than 1024. The detailed results
follows.

  N-bytes-lookup|update: lookup/update on normal htab with N-bytes key
  N-str-lookup|update: lookup/update on string htab with N-bytes key

Under x86-64:

64-bytes-lookup      13.738 ± 0.018M/s (drops 0.000 ± 0.000M/s)
64-bytes-update      7.313 ± 0.011M/s (drops 0.000 ± 0.000M/s)
64-str-lookup        11.417 ± 0.334M/s (drops 0.000 ± 0.000M/s)
64-str-update        6.866 ± 0.004M/s (drops 0.000 ± 0.000M/s)

128-bytes-lookup     9.051 ± 0.005M/s (drops 0.000 ± 0.000M/s)
128-bytes-update     5.713 ± 0.006M/s (drops 0.000 ± 0.000M/s)
128-str-lookup       9.134 ± 0.002M/s (drops 0.000 ± 0.000M/s)
128-str-update       5.719 ± 0.003M/s (drops 0.000 ± 0.000M/s)

256-bytes-lookup     5.445 ± 0.002M/s (drops 0.000 ± 0.000M/s)
256-bytes-update     4.052 ± 0.002M/s (drops 0.000 ± 0.000M/s)
256-str-lookup       6.356 ± 0.020M/s (drops 0.000 ± 0.000M/s)
256-str-update       4.504 ± 0.002M/s (drops 0.000 ± 0.000M/s)

512-bytes-lookup     3.114 ± 0.001M/s (drops 0.000 ± 0.000M/s)
512-bytes-update     2.579 ± 0.000M/s (drops 0.000 ± 0.000M/s)
512-str-lookup       4.046 ± 0.001M/s (drops 0.000 ± 0.000M/s)
512-str-update       3.149 ± 0.001M/s (drops 0.000 ± 0.000M/s)

1024-bytes-lookup    1.639 ± 0.002M/s (drops 0.000 ± 0.000M/s)
1024-bytes-update    1.467 ± 0.001M/s (drops 0.000 ± 0.000M/s)
1024-str-lookup      2.386 ± 0.001M/s (drops 0.000 ± 0.000M/s)
1024-str-update      1.980 ± 0.001M/s (drops 0.000 ± 0.000M/s)

2048-bytes-lookup    0.863 ± 0.001M/s (drops 0.000 ± 0.000M/s)
2048-bytes-update    0.798 ± 0.000M/s (drops 0.000 ± 0.000M/s)
2048-str-lookup      1.246 ± 0.001M/s (drops 0.000 ± 0.000M/s)
2048-str-update      1.116 ± 0.000M/s (drops 0.000 ± 0.000M/s)

4096-bytes-lookup    0.451 ± 0.000M/s (drops 0.000 ± 0.000M/s)
4096-bytes-update    0.424 ± 0.000M/s (drops 0.000 ± 0.000M/s)
4096-str-lookup      0.653 ± 0.000M/s (drops 0.000 ± 0.000M/s)
4096-str-update      0.622 ± 0.000M/s (drops 0.000 ± 0.000M/s)

Under arm64:

64-bytes-lookup      13.393 ± 0.021M/s (drops 0.000 ± 0.000M/s)
64-bytes-update      4.174 ± 0.014M/s (drops 0.000 ± 0.000M/s)
64-str-lookup        17.005 ± 0.016M/s (drops 0.000 ± 0.000M/s)
64-str-update        4.357 ± 0.035M/s (drops 0.000 ± 0.000M/s)

128-bytes-lookup     6.528 ± 0.014M/s (drops 0.000 ± 0.000M/s)
128-bytes-update     3.335 ± 0.022M/s (drops 0.000 ± 0.000M/s)
128-str-lookup       10.138 ± 0.092M/s (drops 0.000 ± 0.000M/s)
128-str-update       4.034 ± 0.028M/s (drops 0.000 ± 0.000M/s)

256-bytes-lookup     3.575 ± 0.019M/s (drops 0.000 ± 0.000M/s)
256-bytes-update     2.286 ± 0.012M/s (drops 0.000 ± 0.000M/s)
256-str-lookup       7.387 ± 0.010M/s (drops 0.000 ± 0.000M/s)
256-str-update       3.348 ± 0.016M/s (drops 0.000 ± 0.000M/s)

512-bytes-lookup     2.134 ± 0.003M/s (drops 0.000 ± 0.000M/s)
512-bytes-update     1.668 ± 0.007M/s (drops 0.000 ± 0.000M/s)
512-str-lookup       4.814 ± 0.002M/s (drops 0.000 ± 0.000M/s)
512-str-update       2.715 ± 0.025M/s (drops 0.000 ± 0.000M/s)

1024-bytes-lookup    1.119 ± 0.001M/s (drops 0.000 ± 0.000M/s)
1024-bytes-update    0.920 ± 0.002M/s (drops 0.000 ± 0.000M/s)
1024-str-lookup      2.928 ± 0.001M/s (drops 0.000 ± 0.000M/s)
1024-str-update      1.878 ± 0.037M/s (drops 0.000 ± 0.000M/s)

4096-bytes-lookup    0.312 ± 0.000M/s (drops 0.000 ± 0.000M/s)
4096-bytes-update    0.269 ± 0.001M/s (drops 0.000 ± 0.000M/s)
4096-str-lookup      1.010 ± 0.000M/s (drops 0.000 ± 0.000M/s)
4096-str-update      0.670 ± 0.005M/s (drops 0.000 ± 0.000M/s)

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/bench.c           |  10 +
 .../selftests/bpf/benchs/bench_str_htab.c     | 255 ++++++++++++++++++
 .../testing/selftests/bpf/benchs/run_htab.sh  |  14 +
 .../selftests/bpf/progs/str_htab_bench.c      | 123 +++++++++
 5 files changed, 405 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_str_htab.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_htab.sh
 create mode 100644 tools/testing/selftests/bpf/progs/str_htab_bench.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index d46ed4dab0ab..f55d647ba091 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -538,6 +538,7 @@ $(OUTPUT)/bench_ringbufs.o: $(OUTPUT)/ringbuf_bench.skel.h \
 $(OUTPUT)/bench_bloom_filter_map.o: $(OUTPUT)/bloom_filter_bench.skel.h
 $(OUTPUT)/bench_bpf_loop.o: $(OUTPUT)/bpf_loop_bench.skel.h
 $(OUTPUT)/bench_strncmp.o: $(OUTPUT)/strncmp_bench.skel.h
+$(OUTPUT)/bench_str_htab.o: $(OUTPUT)/str_htab_bench.skel.h
 $(OUTPUT)/bench.o: bench.h testing_helpers.h $(BPFOBJ)
 $(OUTPUT)/bench: LDLIBS += -lm
 $(OUTPUT)/bench: $(OUTPUT)/bench.o \
@@ -549,7 +550,8 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o \
 		 $(OUTPUT)/bench_ringbufs.o \
 		 $(OUTPUT)/bench_bloom_filter_map.o \
 		 $(OUTPUT)/bench_bpf_loop.o \
-		 $(OUTPUT)/bench_strncmp.o
+		 $(OUTPUT)/bench_strncmp.o \
+		 $(OUTPUT)/bench_str_htab.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.a %.o,$^) $(LDLIBS) -o $@
 
diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index f973320e6dbf..86164ac86776 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -190,12 +190,14 @@ extern struct argp bench_ringbufs_argp;
 extern struct argp bench_bloom_map_argp;
 extern struct argp bench_bpf_loop_argp;
 extern struct argp bench_strncmp_argp;
+extern struct argp bench_str_htab_argp;
 
 static const struct argp_child bench_parsers[] = {
 	{ &bench_ringbufs_argp, 0, "Ring buffers benchmark", 0 },
 	{ &bench_bloom_map_argp, 0, "Bloom filter map benchmark", 0 },
 	{ &bench_bpf_loop_argp, 0, "bpf_loop helper benchmark", 0 },
 	{ &bench_strncmp_argp, 0, "bpf_strncmp helper benchmark", 0 },
+	{ &bench_str_htab_argp, 0, "string htab benchmark", 0 },
 	{},
 };
 
@@ -397,6 +399,10 @@ extern const struct bench bench_hashmap_with_bloom;
 extern const struct bench bench_bpf_loop;
 extern const struct bench bench_strncmp_no_helper;
 extern const struct bench bench_strncmp_helper;
+extern const struct bench bench_htab_bytes_lookup;
+extern const struct bench bench_htab_str_lookup;
+extern const struct bench bench_htab_bytes_update;
+extern const struct bench bench_htab_str_update;
 
 static const struct bench *benchs[] = {
 	&bench_count_global,
@@ -431,6 +437,10 @@ static const struct bench *benchs[] = {
 	&bench_bpf_loop,
 	&bench_strncmp_no_helper,
 	&bench_strncmp_helper,
+	&bench_htab_bytes_lookup,
+	&bench_htab_str_lookup,
+	&bench_htab_bytes_update,
+	&bench_htab_str_update,
 };
 
 static void setup_benchmark()
diff --git a/tools/testing/selftests/bpf/benchs/bench_str_htab.c b/tools/testing/selftests/bpf/benchs/bench_str_htab.c
new file mode 100644
index 000000000000..719d45cebb2b
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_str_htab.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <argp.h>
+#include <sys/random.h>
+#include "bench.h"
+#include "bpf_util.h"
+#include "str_htab_bench.skel.h"
+
+static struct str_htab_ctx {
+	struct str_htab_bench *skel;
+} ctx;
+
+static struct {
+	bool same_len;
+	__u32 key_size;
+	__u32 max_entries;
+} args = {
+	.same_len = false,
+	.key_size = 256,
+	.max_entries = 1000,
+};
+
+enum {
+	ARG_SAME_LEN = 6000,
+	ARG_KEY_SIZE = 6001,
+	ARG_MAX_ENTRIES = 6002,
+};
+
+static const struct argp_option opts[] = {
+	{ "same-len", ARG_SAME_LEN, NULL, 0,
+	  "Use the same length for string keys" },
+	{ "key-size", ARG_KEY_SIZE, "KEY_SIZE", 0,
+	  "Set the key size" },
+	{ "max-entries", ARG_MAX_ENTRIES, "MAX_ENTRIES", 0,
+	  "Set the max entries" },
+	{},
+};
+
+static error_t str_htab_parse_arg(int key, char *arg, struct argp_state *state)
+{
+	switch (key) {
+	case ARG_SAME_LEN:
+		args.same_len = true;
+		break;
+	case ARG_KEY_SIZE:
+		args.key_size = strtoul(arg, NULL, 10);
+		break;
+	case ARG_MAX_ENTRIES:
+		args.max_entries = strtoul(arg, NULL, 10);
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+
+	return 0;
+}
+
+const struct argp bench_str_htab_argp = {
+	.options = opts,
+	.parser = str_htab_parse_arg,
+};
+
+static void str_htab_validate(void)
+{
+	if (env.consumer_cnt != 1) {
+		fprintf(stderr, "str_htab benchmark doesn't support multi-consumer!\n");
+		exit(1);
+	}
+
+	if (args.key_size < 2 ||
+	    args.key_size > sizeof(ctx.skel->rodata->keys[0])) {
+		fprintf(stderr, "invalid key size (max %zu)\n",
+			sizeof(ctx.skel->rodata->keys[0]));
+		exit(1);
+	}
+
+	if (!args.max_entries ||
+	    args.max_entries > ARRAY_SIZE(ctx.skel->rodata->keys)) {
+		fprintf(stderr, "invalid max entries (max %zu)\n",
+			ARRAY_SIZE(ctx.skel->rodata->keys));
+		exit(1);
+	}
+}
+
+static void str_htab_fill_map(struct str_htab_bench *skel, struct bpf_map *map,
+			      unsigned int nr)
+{
+	int fd = bpf_map__fd(map);
+	unsigned int value = 1;
+	unsigned int i = 0;
+
+	for (; i < nr; i++) {
+		int err;
+
+		err = bpf_map_update_elem(fd, skel->rodata->keys[i], &value, 0);
+		if (err) {
+			fprintf(stderr, "add #%u key on %s error %d\n",
+				i, bpf_map__name(map), err);
+			exit(1);
+		}
+	}
+}
+
+static void setup_keys(struct str_htab_bench *skel, u32 key_size)
+{
+	size_t i;
+
+	/* Generate in byte-granularity to avoid zero byte */
+	srandom(time(NULL));
+	for (i = 0; i < ARRAY_SIZE(skel->rodata->keys); i++) {
+		unsigned int len;
+		unsigned int j;
+
+		if (args.same_len)
+			len = key_size - 1;
+		else
+			len = random() % (key_size - 1) + 1;
+		for (j = 0; j < len; j++)
+			skel->rodata->keys[i][j] = random() % 255 + 1;
+		skel->rodata->keys[i][j] = 0;
+	}
+}
+
+static void str_htab_setup(void)
+{
+	struct str_htab_bench *skel;
+	int err;
+
+	setup_libbpf();
+
+	skel = str_htab_bench__open();
+	if (!skel) {
+		fprintf(stderr, "failed to open skeleton\n");
+		exit(1);
+	}
+
+	setup_keys(skel, args.key_size);
+
+	bpf_map__set_key_size(skel->maps.bytes_htab, args.key_size);
+	bpf_map__set_key_size(skel->maps.str_htab, args.key_size);
+
+	bpf_map__set_max_entries(skel->maps.bytes_htab, args.max_entries);
+	bpf_map__set_max_entries(skel->maps.str_htab, args.max_entries);
+
+	skel->bss->loops = args.max_entries;
+
+	err = str_htab_bench__load(skel);
+	if (err) {
+		fprintf(stderr, "failed to load skeleton\n");
+		str_htab_bench__destroy(skel);
+		exit(1);
+	}
+
+	str_htab_fill_map(skel, skel->maps.bytes_htab, args.max_entries);
+	str_htab_fill_map(skel, skel->maps.str_htab, args.max_entries);
+
+	ctx.skel = skel;
+}
+
+static void str_htab_attach_prog(struct bpf_program *prog)
+{
+	struct bpf_link *link;
+
+	link = bpf_program__attach(prog);
+	if (!link) {
+		fprintf(stderr, "failed to attach program!\n");
+		exit(1);
+	}
+}
+
+static void str_htab_bytes_lookup_setup(void)
+{
+	str_htab_setup();
+	str_htab_attach_prog(ctx.skel->progs.htab_bytes_lookup);
+}
+
+static void str_htab_str_lookup_setup(void)
+{
+	str_htab_setup();
+	str_htab_attach_prog(ctx.skel->progs.htab_str_lookup);
+}
+
+static void str_htab_bytes_update_setup(void)
+{
+	str_htab_setup();
+	str_htab_attach_prog(ctx.skel->progs.htab_bytes_update);
+}
+
+static void str_htab_str_update_setup(void)
+{
+	str_htab_setup();
+	str_htab_attach_prog(ctx.skel->progs.htab_str_update);
+}
+
+static void *str_htab_producer(void *ctx)
+{
+	while (true)
+		(void)syscall(__NR_getpgid);
+	return NULL;
+}
+
+static void *str_htab_consumer(void *ctx)
+{
+	return NULL;
+}
+
+static void str_htab_measure(struct bench_res *res)
+{
+	res->hits = atomic_swap(&ctx.skel->bss->hits, 0);
+	res->drops = atomic_swap(&ctx.skel->bss->drops, 0);
+}
+
+const struct bench bench_htab_bytes_lookup = {
+	.name = "htab-bytes-lookup",
+	.validate = str_htab_validate,
+	.setup = str_htab_bytes_lookup_setup,
+	.producer_thread = str_htab_producer,
+	.consumer_thread = str_htab_consumer,
+	.measure = str_htab_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = hits_drops_report_final,
+};
+
+const struct bench bench_htab_str_lookup = {
+	.name = "htab-str-lookup",
+	.validate = str_htab_validate,
+	.setup = str_htab_str_lookup_setup,
+	.producer_thread = str_htab_producer,
+	.consumer_thread = str_htab_consumer,
+	.measure = str_htab_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = hits_drops_report_final,
+};
+
+const struct bench bench_htab_bytes_update = {
+	.name = "htab-bytes-update",
+	.validate = str_htab_validate,
+	.setup = str_htab_bytes_update_setup,
+	.producer_thread = str_htab_producer,
+	.consumer_thread = str_htab_consumer,
+	.measure = str_htab_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = hits_drops_report_final,
+};
+
+const struct bench bench_htab_str_update = {
+	.name = "htab-str-update",
+	.validate = str_htab_validate,
+	.setup = str_htab_str_update_setup,
+	.producer_thread = str_htab_producer,
+	.consumer_thread = str_htab_consumer,
+	.measure = str_htab_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = hits_drops_report_final,
+};
diff --git a/tools/testing/selftests/bpf/benchs/run_htab.sh b/tools/testing/selftests/bpf/benchs/run_htab.sh
new file mode 100755
index 000000000000..0a0bf98a05ab
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/run_htab.sh
@@ -0,0 +1,14 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source ./benchs/run_common.sh
+
+set -eufo pipefail
+
+for ks in 64 128 256 512 1024 2048 4096; do
+	for tp in bytes str; do
+		for op in lookup update; do
+			summarize ${ks}-${tp}-${op} "$($RUN_BENCH --key-size=$ks htab-${tp}-${op})"
+		done
+	done
+done
diff --git a/tools/testing/selftests/bpf/progs/str_htab_bench.c b/tools/testing/selftests/bpf/progs/str_htab_bench.c
new file mode 100644
index 000000000000..c97070c648be
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/str_htab_bench.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021. Huawei Technologies Co., Ltd */
+#include <linux/types.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define MAX_STR_KEY_SIZE 4096
+#define MAX_ENTRY_NR 1000
+
+/* key_size and max_entries will be set by htab benchmark */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(value_size, sizeof(__u32));
+} bytes_htab SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(value_size, sizeof(__u32));
+	__uint(map_flags, BPF_F_STR_KEY);
+} str_htab SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+const char keys[MAX_ENTRY_NR][MAX_STR_KEY_SIZE];
+
+unsigned int loops = 0;
+long hits = 0;
+long drops = 0;
+
+static int lookup_bytes(__u32 index, void *data)
+{
+	unsigned int *value;
+
+	if (index >= MAX_ENTRY_NR)
+		return 1;
+
+	value = bpf_map_lookup_elem(&bytes_htab, keys[index]);
+	if (value)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+static int lookup_str(__u32 index, void *data)
+{
+	unsigned int *value;
+
+	if (index >= MAX_ENTRY_NR)
+		return 1;
+
+	value = bpf_map_lookup_elem(&str_htab, keys[index]);
+	if (value)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+static int update_bytes(__u32 index, void *data)
+{
+	unsigned int value = 2;
+	int err;
+
+	if (index >= MAX_ENTRY_NR)
+		return 1;
+
+	err = bpf_map_update_elem(&bytes_htab, keys[index], &value, BPF_EXIST);
+	if (!err)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+static int update_str(__u32 index, void *data)
+{
+	unsigned int value = 0;
+	int err;
+
+	if (index >= MAX_ENTRY_NR)
+		return 1;
+
+	err = bpf_map_update_elem(&str_htab, keys[index], &value, BPF_EXIST);
+	if (!err)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int htab_bytes_lookup(void *ctx)
+{
+	bpf_loop(loops, lookup_bytes, NULL, 0);
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int htab_str_lookup(void *ctx)
+{
+	bpf_loop(loops, lookup_str, NULL, 0);
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int htab_bytes_update(void *ctx)
+{
+	bpf_loop(loops, update_bytes, NULL, 0);
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int htab_str_update(void *ctx)
+{
+	bpf_loop(loops, update_str, NULL, 0);
+	return 0;
+}
-- 
2.29.2

