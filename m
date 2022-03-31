Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24154ED93E
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 14:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiCaMGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 08:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235501AbiCaMGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 08:06:00 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33513EA9F;
        Thu, 31 Mar 2022 05:04:10 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KThm628SRz1GDK7;
        Thu, 31 Mar 2022 20:03:50 +0800 (CST)
Received: from huawei.com (10.175.112.60) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 31 Mar
 2022 20:04:08 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next] selftests/bpf: add benchmark for ternary search tree map
Date:   Thu, 31 Mar 2022 20:28:22 +0800
Message-ID: <20220331122822.14283-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220331122822.14283-1-houtao1@huawei.com>
References: <20220331122822.14283-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.60]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a benchmark for ternary search tree map to compare lookup
performance and memory usage with hash table for string key.

To test the space efficiency of tst for string key with common prefix
(hierarchical key), the benchmark constructs a string key up to 256
bytes: up to 64 bytes base name and up to 191 bytes prefix. So the
space saving is about 2~3 fold and it can be confirmed from data of
tst-N-hk-dl section or tst-N-hk-sl section below.

It also tests the space saving when there are differences between string
length: the max length is 255 bytes and min length is 16. And there are
about 0.5~0.8 space saving in tst compared with htab as data of
tst-N-fk-dl section shows.

When the length of string key is the same and there are very few common
prefixes between these key, the space usage of tearnary will be greater
than hash table and it is about 3%~30% more space usage compared with
hash table as shown in tst-N-fk-sl section.

For the hierarchical key case, the lookup performance of tst is about
x2~x3 slower compared with hash table when the number of elements is
less than 1M. And the performance gap decreases when the number of
element increases.

The following are the detailed outputs of benchmark:

Notations:

* hk: hierarchical string key
* fk: flat string key (non-hierarchical string key)
* dl: the lengths of string keys are different
* sl: the lengths of string key are the same
* N: the number of string key

Details:

tst-1000-hk-dl            2.398 ± 0.000M/s (drops 0.000 ± 0.000M/s, mem 0.144 MiB)
tst-10000-hk-dl           2.458 ± 0.001M/s (drops 0.000 ± 0.000M/s, mem 1.479 MiB)
tst-100000-hk-dl          2.744 ± 0.006M/s (drops 0.000 ± 0.000M/s, mem 12.566 MiB)
tst-1000000-hk-dl         2.364 ± 0.007M/s (drops 0.000 ± 0.000M/s, mem 120.862 MiB)
tst-10000000-hk-dl        2.467 ± 0.032M/s (drops 0.000 ± 0.000M/s, mem 1204.017 MiB)

htab-1000-hk-dl           5.930 ± 0.006M/s (drops 0.000 ± 0.000M/s, mem 0.496 MiB)
htab-10000-hk-dl          5.070 ± 0.005M/s (drops 0.000 ± 0.000M/s, mem 4.960 MiB)
htab-100000-hk-dl         2.765 ± 0.022M/s (drops 0.000 ± 0.000M/s, mem 49.591 MiB)
htab-1000000-hk-dl        1.870 ± 0.032M/s (drops 0.000 ± 0.000M/s, mem 495.911 MiB)
htab-10000000-hk-dl       1.854 ± 0.104M/s (drops 0.000 ± 0.000M/s, mem 4959.095 MiB)

tst-1000-hk-sl            0.172 ± 0.384M/s (drops 0.000 ± 0.000M/s, mem 0.184 MiB)
tst-10000-hk-sl           1.831 ± 0.000M/s (drops 0.000 ± 0.000M/s, mem 1.821 MiB)
tst-100000-hk-sl          1.724 ± 0.002M/s (drops 0.000 ± 0.000M/s, mem 15.161 MiB)
tst-1000000-hk-sl         1.611 ± 0.005M/s (drops 0.000 ± 0.000M/s, mem 148.276 MiB)
tst-10000000-hk-sl        1.608 ± 0.007M/s (drops 0.000 ± 0.000M/s, mem 1480.046 MiB)

htab-1000-hk-sl           5.913 ± 0.001M/s (drops 0.000 ± 0.000M/s, mem 0.496 MiB)
htab-10000-hk-sl          5.067 ± 0.003M/s (drops 0.000 ± 0.000M/s, mem 4.960 MiB)
htab-100000-hk-sl         2.816 ± 0.015M/s (drops 0.000 ± 0.000M/s, mem 49.592 MiB)
htab-1000000-hk-sl        1.841 ± 0.026M/s (drops 0.000 ± 0.000M/s, mem 495.911 MiB)
htab-10000000-hk-sl       1.847 ± 0.102M/s (drops 0.000 ± 0.000M/s, mem 4959.107 MiB)

tst-1000-fk-dl            0.180 ± 0.402M/s (drops 0.000 ± 0.000M/s, mem 0.329 MiB)
tst-10000-fk-dl           2.546 ± 0.001M/s (drops 0.000 ± 0.000M/s, mem 3.211 MiB)
tst-100000-fk-dl          1.702 ± 0.003M/s (drops 0.000 ± 0.000M/s, mem 27.835 MiB)
tst-1000000-fk-dl         0.941 ± 0.006M/s (drops 0.000 ± 0.000M/s, mem 262.322 MiB)
tst-10000000-fk-dl        0.658 ± 0.039M/s (drops 0.000 ± 0.000M/s, mem 2618.858 MiB)

htab-1000-fk-dl           5.903 ± 0.002M/s (drops 0.000 ± 0.000M/s, mem 0.496 MiB)
htab-10000-fk-dl          5.057 ± 0.004M/s (drops 0.000 ± 0.000M/s, mem 4.960 MiB)
htab-100000-fk-dl         2.748 ± 0.019M/s (drops 0.000 ± 0.000M/s, mem 49.595 MiB)
htab-1000000-fk-dl        1.857 ± 0.029M/s (drops 0.000 ± 0.000M/s, mem 495.911 MiB)
htab-10000000-fk-dl       1.853 ± 0.103M/s (drops 0.000 ± 0.000M/s, mem 4959.107 MiB)

tst-1000-fk-sl            0.094 ± 0.210M/s (drops 0.000 ± 0.000M/s, mem 0.640 MiB)
tst-10000-fk-sl           1.656 ± 0.000M/s (drops 0.000 ± 0.000M/s, mem 6.251 MiB)
tst-100000-fk-sl          1.088 ± 0.005M/s (drops 0.000 ± 0.000M/s, mem 53.708 MiB)
tst-1000000-fk-sl         0.732 ± 0.020M/s (drops 0.000 ± 0.000M/s, mem 513.421 MiB)
tst-10000000-fk-sl        0.581 ± 0.031M/s (drops 0.000 ± 0.000M/s, mem 5139.383 MiB)

htab-1000-fk-sl           5.861 ± 0.004M/s (drops 0.000 ± 0.000M/s, mem 0.496 MiB)
htab-10000-fk-sl          5.077 ± 0.006M/s (drops 0.000 ± 0.000M/s, mem 4.959 MiB)
htab-100000-fk-sl         2.771 ± 0.020M/s (drops 0.000 ± 0.000M/s, mem 49.592 MiB)
htab-1000000-fk-sl        1.833 ± 0.029M/s (drops 0.000 ± 0.000M/s, mem 495.911 MiB)
htab-10000000-fk-sl       1.828 ± 0.099M/s (drops 0.000 ± 0.000M/s, mem 4959.107 MiB)

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bench.c           |   6 +
 .../selftests/bpf/benchs/bench_tst_map.c      | 415 ++++++++++++++++++
 .../selftests/bpf/benchs/run_bench_tst.sh     |  54 +++
 tools/testing/selftests/bpf/progs/tst_bench.c |  70 +++
 5 files changed, 549 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_tst_map.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_tst.sh
 create mode 100644 tools/testing/selftests/bpf/progs/tst_bench.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e14636d82c6b..625805ba410f 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -538,18 +538,21 @@ $(OUTPUT)/bench_ringbufs.o: $(OUTPUT)/ringbuf_bench.skel.h \
 $(OUTPUT)/bench_bloom_filter_map.o: $(OUTPUT)/bloom_filter_bench.skel.h
 $(OUTPUT)/bench_bpf_loop.o: $(OUTPUT)/bpf_loop_bench.skel.h
 $(OUTPUT)/bench_strncmp.o: $(OUTPUT)/strncmp_bench.skel.h
+$(OUTPUT)/bench_tst_map.o: $(OUTPUT)/tst_bench.skel.h
 $(OUTPUT)/bench.o: bench.h testing_helpers.h $(BPFOBJ)
 $(OUTPUT)/bench: LDLIBS += -lm
 $(OUTPUT)/bench: $(OUTPUT)/bench.o \
 		 $(TESTING_HELPERS) \
 		 $(TRACE_HELPERS) \
+		 $(CGROUP_HELPERS) \
 		 $(OUTPUT)/bench_count.o \
 		 $(OUTPUT)/bench_rename.o \
 		 $(OUTPUT)/bench_trigger.o \
 		 $(OUTPUT)/bench_ringbufs.o \
 		 $(OUTPUT)/bench_bloom_filter_map.o \
 		 $(OUTPUT)/bench_bpf_loop.o \
-		 $(OUTPUT)/bench_strncmp.o
+		 $(OUTPUT)/bench_strncmp.o \
+		 $(OUTPUT)/bench_tst_map.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.a %.o,$^) $(LDLIBS) -o $@
 
diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index f973320e6dbf..5414ca0fcd65 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -190,12 +190,14 @@ extern struct argp bench_ringbufs_argp;
 extern struct argp bench_bloom_map_argp;
 extern struct argp bench_bpf_loop_argp;
 extern struct argp bench_strncmp_argp;
+extern struct argp bench_tst_argp;
 
 static const struct argp_child bench_parsers[] = {
 	{ &bench_ringbufs_argp, 0, "Ring buffers benchmark", 0 },
 	{ &bench_bloom_map_argp, 0, "Bloom filter map benchmark", 0 },
 	{ &bench_bpf_loop_argp, 0, "bpf_loop helper benchmark", 0 },
 	{ &bench_strncmp_argp, 0, "bpf_strncmp helper benchmark", 0 },
+	{ &bench_tst_argp, 0, "tst map benchmark", 0 },
 	{},
 };
 
@@ -397,6 +399,8 @@ extern const struct bench bench_hashmap_with_bloom;
 extern const struct bench bench_bpf_loop;
 extern const struct bench bench_strncmp_no_helper;
 extern const struct bench bench_strncmp_helper;
+extern const struct bench bench_htab_lookup;
+extern const struct bench bench_tst_lookup;
 
 static const struct bench *benchs[] = {
 	&bench_count_global,
@@ -431,6 +435,8 @@ static const struct bench *benchs[] = {
 	&bench_bpf_loop,
 	&bench_strncmp_no_helper,
 	&bench_strncmp_helper,
+	&bench_htab_lookup,
+	&bench_tst_lookup,
 };
 
 static void setup_benchmark()
diff --git a/tools/testing/selftests/bpf/benchs/bench_tst_map.c b/tools/testing/selftests/bpf/benchs/bench_tst_map.c
new file mode 100644
index 000000000000..a1c1b86fad44
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_tst_map.c
@@ -0,0 +1,415 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022. Huawei Technologies Co., Ltd */
+#include <argp.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include "bench.h"
+#include "bpf_util.h"
+#include "cgroup_helpers.h"
+
+#include "tst_bench.skel.h"
+
+#define MAX_KEY_SIZE 256
+
+#define PATH_LEAF_NR 1000
+#define PATH_MID_LVL_NR 10
+
+struct tst_key_component_desc {
+	unsigned int nr;
+	unsigned int len;
+};
+
+static struct tst_ctx {
+	struct tst_bench *skel;
+	struct tst_key_component_desc *desc;
+	unsigned int nr_desc;
+	char (*keys)[MAX_KEY_SIZE];
+	char tmp[MAX_KEY_SIZE];
+	unsigned int cursor;
+	int cgrp_dfd;
+	unsigned long long map_mem;
+} ctx;
+
+static struct {
+	bool flat_key;
+	bool same_len;
+	__u32 max_entries;
+} args = {
+	.flat_key = false,
+	.same_len = false,
+	.max_entries = 1000,
+};
+
+enum {
+	ARG_TST_ENTRIES = 7001,
+	ARG_FLAT_KEY = 7002,
+	ARG_SAME_LEN = 7003,
+};
+
+static const struct argp_option opts[] = {
+	{ "tst-entries", ARG_TST_ENTRIES, "TST_ENTRIES", 0,
+	  "Set the max entries" },
+	{ "flat-key", ARG_FLAT_KEY, NULL, 0,
+	  "Do not generate hierarchical key" },
+	{ "same-len", ARG_SAME_LEN, NULL, 0,
+	  "Generate the key with the same len" },
+	{},
+};
+
+static error_t tst_parse_arg(int key, char *arg, struct argp_state *state)
+{
+	switch (key) {
+	case ARG_TST_ENTRIES:
+		args.max_entries = strtoul(arg, NULL, 10);
+		if (args.max_entries < PATH_LEAF_NR) {
+			fprintf(stderr, "invalid max entries %u (min %u)\n",
+				args.max_entries, PATH_LEAF_NR);
+			argp_usage(state);
+		}
+		break;
+	case ARG_FLAT_KEY:
+		args.flat_key = true;
+		break;
+	case ARG_SAME_LEN:
+		args.same_len = true;
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+
+	return 0;
+}
+
+const struct argp bench_tst_argp = {
+	.options = opts,
+	.parser = tst_parse_arg,
+};
+
+static void tst_validate(void)
+{
+	if (env.consumer_cnt != 1) {
+		fprintf(stderr, "tst_map benchmark doesn't support multi-consumer!\n");
+		exit(1);
+	}
+}
+
+static char tst_random_c(void)
+{
+	static const char tbl[] = "0123456789abcdefghijklmnopqrstuvwxyz._";
+	return tbl[random() % (sizeof(tbl) - 1)];
+}
+
+static unsigned int tst_calc_hierarchy(unsigned int nr)
+{
+	struct tst_key_component_desc *desc;
+	unsigned int left;
+	unsigned int total;
+	unsigned int depth;
+
+	/* Calculate the depth of hierarchical key */
+	depth = 1;
+	total = PATH_LEAF_NR;
+	left = nr / PATH_LEAF_NR;
+	while (left >= PATH_MID_LVL_NR) {
+		left /= PATH_MID_LVL_NR;
+		total *= PATH_MID_LVL_NR;
+		depth++;
+	}
+	depth++;
+	total *= left;
+
+	desc = calloc(depth, sizeof(*desc));
+	if (!desc) {
+		fprintf(stderr, "failed to alloc mem for desc\n");
+		exit(1);
+	}
+
+	/* Assign number and length for each component */
+	desc[depth - 1].nr = PATH_LEAF_NR;
+	desc[depth - 1].len = MAX_KEY_SIZE / 4;
+
+	desc[0].nr = left;
+	if (depth > 2) {
+		unsigned int avg;
+		unsigned int rem;
+		unsigned int i;
+
+		desc[0].len = MAX_KEY_SIZE / 32;
+
+		/* -1 for the trailing null byte */
+		left = MAX_KEY_SIZE - desc[0].len - desc[depth - 1].len - 1;
+		avg = left / (depth - 2);
+		rem = left - avg * (depth - 2);
+		for (i = 1; i <= depth - 2; i++) {
+			desc[i].nr = PATH_MID_LVL_NR;
+			desc[i].len = avg;
+			if (rem) {
+				desc[i].len += 1;
+				rem--;
+			}
+		}
+	} else {
+		desc[0].len = MAX_KEY_SIZE - desc[depth - 1].len - 1;
+	}
+
+	ctx.desc = desc;
+	ctx.nr_desc = depth;
+
+	return total;
+}
+
+static void tst_init_map_opts(struct tst_bench *skel)
+{
+	bpf_map__set_value_size(skel->maps.array, MAX_KEY_SIZE);
+	bpf_map__set_max_entries(skel->maps.array, args.max_entries);
+
+	bpf_map__set_key_size(skel->maps.htab, MAX_KEY_SIZE);
+	bpf_map__set_max_entries(skel->maps.htab, args.max_entries);
+
+	bpf_map__set_key_size(skel->maps.tst, MAX_KEY_SIZE);
+	bpf_map__set_max_entries(skel->maps.tst, args.max_entries);
+}
+
+static inline unsigned int tst_key_len(unsigned int max_len)
+{
+	unsigned int len;
+
+	if (args.same_len)
+		return max_len;
+
+	/* Make the differences between string length bigger */
+	len = random() % (max_len * 15 / 16 + 1) + max_len / 16;
+	if (len < 2)
+		len = 2;
+	return len;
+}
+
+static void tst_gen_hierarchical_key(unsigned int depth, unsigned int pos)
+{
+	unsigned int i, j, len;
+
+	if (depth >= ctx.nr_desc) {
+		memcpy(ctx.keys[ctx.cursor++], ctx.tmp, pos);
+		return;
+	}
+
+	for (i = 0; i < ctx.desc[depth].nr; i++) {
+		len = tst_key_len(ctx.desc[depth].len);
+
+		ctx.tmp[pos] = '/';
+		for (j = 1; j < len; j++)
+			ctx.tmp[pos + j] = tst_random_c();
+		tst_gen_hierarchical_key(depth + 1, pos + j);
+	}
+}
+
+static void tst_gen_flat_key(void)
+{
+	unsigned int i, j, len;
+
+	for (i = 0; i < args.max_entries; i++) {
+		len = tst_key_len(MAX_KEY_SIZE - 1);
+		for (j = 0; j < len; j++)
+			ctx.keys[i][j] = tst_random_c();
+	}
+}
+
+static void tst_alloc_and_fill_keys(void)
+{
+	ctx.keys = calloc(args.max_entries, sizeof(*ctx.keys));
+	if (!ctx.keys) {
+		fprintf(stderr, "failed to alloc mem for keys\n");
+		exit(1);
+	}
+
+	if (args.flat_key)
+		tst_gen_flat_key();
+	else
+		tst_gen_hierarchical_key(0, 0);
+}
+
+static void tst_setup_key_map(struct bpf_map *map)
+{
+	int fd = bpf_map__fd(map);
+	unsigned int i;
+
+	for (i = 0; i < args.max_entries; i++) {
+		int err;
+
+		err = bpf_map_update_elem(fd, &i, ctx.keys[i], 0);
+		if (err) {
+			fprintf(stderr, "add #%u key (%s) on %s error %d\n",
+				i, ctx.keys[i], bpf_map__name(map), err);
+			exit(1);
+		}
+	}
+}
+
+static unsigned long long tst_get_slab_mem(int dfd)
+{
+	const char *magic = "slab ";
+	const char *name = "memory.stat";
+	int fd;
+	ssize_t nr;
+	char buf[4096];
+	char *from;
+
+	fd = openat(dfd, name, 0);
+	if (fd < 0) {
+		fprintf(stderr, "no %s\n", name);
+		exit(1);
+	}
+
+	memset(buf, 0, sizeof(buf));
+	nr = read(fd, buf, sizeof(buf));
+	if (nr <= 0) {
+		fprintf(stderr, "empty %s ?\n", name);
+		exit(1);
+	}
+
+	close(fd);
+
+	from = strstr(buf, magic);
+	if (!from) {
+		fprintf(stderr, "no slab in %s\n", name);
+		exit(1);
+	}
+
+	return strtoull(from + strlen(magic), NULL, 10);
+}
+
+static void tst_setup_lookup_map(struct bpf_map *map)
+{
+	int fd = bpf_map__fd(map);
+	unsigned int i;
+	unsigned long long before, after;
+
+	before = tst_get_slab_mem(ctx.cgrp_dfd);
+	for (i = 0; i < args.max_entries; i++) {
+		int err;
+
+		err = bpf_map_update_elem(fd, ctx.keys[i], &i, 0);
+		if (err) {
+			fprintf(stderr, "add #%u key (%s) on %s error %d\n",
+				i, ctx.keys[i], bpf_map__name(map), err);
+			exit(1);
+		}
+	}
+	after = tst_get_slab_mem(ctx.cgrp_dfd);
+	ctx.map_mem = after - before;
+}
+
+static void tst_common_setup(void)
+{
+	struct tst_bench *skel;
+	int dfd;
+	int err;
+
+	srandom(time(NULL));
+
+	dfd = cgroup_setup_and_join("/tst");
+	if (dfd < 0) {
+		fprintf(stderr, "failed to setup cgroup env\n");
+		exit(1);
+	}
+	ctx.cgrp_dfd = dfd;
+
+	if (!args.flat_key)
+		args.max_entries = tst_calc_hierarchy(args.max_entries);
+
+	setup_libbpf();
+
+	skel = tst_bench__open();
+	if (!skel) {
+		fprintf(stderr, "failed to open skeleton\n");
+		exit(1);
+	}
+
+	tst_init_map_opts(skel);
+
+	err = tst_bench__load(skel);
+	if (err) {
+		fprintf(stderr, "failed to load skeleton\n");
+		exit(1);
+	}
+
+	tst_alloc_and_fill_keys();
+	tst_setup_key_map(skel->maps.array);
+
+	ctx.skel = skel;
+}
+
+static void tst_attach_prog(struct bpf_program *prog)
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
+static void htab_lookup_setup(void)
+{
+	tst_common_setup();
+	tst_setup_lookup_map(ctx.skel->maps.htab);
+	tst_attach_prog(ctx.skel->progs.htab_lookup);
+}
+
+static void tst_lookup_setup(void)
+{
+	tst_common_setup();
+	tst_setup_lookup_map(ctx.skel->maps.tst);
+	tst_attach_prog(ctx.skel->progs.tst_lookup);
+}
+
+static void *tst_producer(void *ctx)
+{
+	while (true)
+		(void)syscall(__NR_getpgid);
+	return NULL;
+}
+
+static void *tst_consumer(void *ctx)
+{
+	return NULL;
+}
+
+static void tst_measure(struct bench_res *res)
+{
+	res->hits = atomic_swap(&ctx.skel->bss->hits, 0);
+	res->drops = atomic_swap(&ctx.skel->bss->drops, 0);
+}
+
+static void tst_report_final(struct bench_res res[], int res_cnt)
+{
+	close(ctx.cgrp_dfd);
+	cleanup_cgroup_environment();
+
+	fprintf(stdout, "Memory: %.3f MiB\n", (float)ctx.map_mem / 1024 / 1024);
+	hits_drops_report_final(res, res_cnt);
+}
+
+const struct bench bench_htab_lookup = {
+	.name = "htab-lookup",
+	.validate = tst_validate,
+	.setup = htab_lookup_setup,
+	.producer_thread = tst_producer,
+	.consumer_thread = tst_consumer,
+	.measure = tst_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = tst_report_final,
+};
+
+const struct bench bench_tst_lookup = {
+	.name = "tst-lookup",
+	.validate = tst_validate,
+	.setup = tst_lookup_setup,
+	.producer_thread = tst_producer,
+	.consumer_thread = tst_consumer,
+	.measure = tst_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = tst_report_final,
+};
diff --git a/tools/testing/selftests/bpf/benchs/run_bench_tst.sh b/tools/testing/selftests/bpf/benchs/run_bench_tst.sh
new file mode 100755
index 000000000000..8209fd1341b7
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/run_bench_tst.sh
@@ -0,0 +1,54 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2022. Huawei Technologies Co., Ltd
+
+source ./benchs/run_common.sh
+
+set -eufo pipefail
+
+mem()
+{
+	echo "$*" | sed -E "s/.*Memory: ([0-9]+\.[0-9]+ MiB).*/\1/"
+}
+
+run_test()
+{
+	local title=$1
+	local summary
+
+	shift 1
+	summary=$(sudo ./bench -w1 -d4 -a "$@" | grep "Summary\|Memory:")
+	printf "%-25s %s (drops %s, mem %s)\n" "$title" "$(hits $summary)" \
+		"$(drops $summary)" "$(mem $summary)"
+}
+
+run_tests()
+{
+	local name=$1
+	local map
+	local nr
+	local s
+
+	shift 1
+	for map in tst htab
+	do
+		nr=1000
+		for s in $(seq 1 5)
+		do
+			run_test "$map-$nr-$name" $map-lookup --tst-entries $nr $@
+			let "nr *= 10"
+		done
+		echo
+	done
+}
+
+for key in hk fk
+do
+	opts=""
+	[ $key == "fk" ] && opts="--flat-key"
+	for len in dl sl
+	do
+		[ $len == "sl" ] && opts="$opts --same-len"
+		run_tests "$key-$len" "$opts"
+	done
+done
diff --git a/tools/testing/selftests/bpf/progs/tst_bench.c b/tools/testing/selftests/bpf/progs/tst_bench.c
new file mode 100644
index 000000000000..454c1abc6844
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tst_bench.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022. Huawei Technologies Co., Ltd */
+#include <linux/types.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+struct bpf_map;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(key_size, 4);
+} array SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(value_size, 4);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+} htab SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_TST);
+	__uint(value_size, 4);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+} tst SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+long hits = 0;
+long drops = 0;
+
+static int lookup_htab(struct bpf_map *map, __u32 *key, void *value, void *data)
+{
+	__u32 *index;
+
+	index = bpf_map_lookup_elem(&htab, value);
+	if (index && *index == *key)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+static int lookup_tst(struct bpf_map *map, __u32 *key, void *value, void *data)
+{
+	__u32 *index;
+
+	index = bpf_map_lookup_elem(&tst, value);
+	if (index && *index == *key)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int htab_lookup(void *ctx)
+{
+	bpf_for_each_map_elem(&array, lookup_htab, NULL, 0);
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int tst_lookup(void *ctx)
+{
+	bpf_for_each_map_elem(&array, lookup_tst, NULL, 0);
+	return 0;
+}
-- 
2.31.1

