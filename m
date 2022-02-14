Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303544B4DAE
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350790AbiBNLSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:18:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350610AbiBNLSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:18:20 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0018B66222;
        Mon, 14 Feb 2022 02:51:32 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Jy1Cd0X3Sz8wZJ;
        Mon, 14 Feb 2022 18:48:13 +0800 (CST)
Received: from huawei.com (10.175.112.60) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 14 Feb
 2022 18:51:29 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next v2 3/3] selftests/bpf: add benchmark for string-key hash table
Date:   Mon, 14 Feb 2022 19:13:37 +0800
Message-ID: <20220214111337.3539-4-houtao1@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20220214111337.3539-1-houtao1@huawei.com>
References: <20220214111337.3539-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.60]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three different key types are defined to representate the typical
use cases for string-key hash table:

(1) string-only key (str/byte)
(2) integer + string key (int-str/int-byte)
(3) integer + two strings key (int-strs/int-bytes)

It supports these three key types by using normal hash table and
string-key hash table and compares the lookup performance between normal
hash table and string-key hash table respectively.

Because string-key hash table depends on btf, and have not figured out
a way to setup btf for map key type dynamically, so in the benchmark
the max size of string is fixed as 252 (multiplier of 12 for jhash()).

The performance win comes from two aspect: (1) use full_name_hash()
for string content instead of jhash(). The former calculate hash in long
granularity and has better hash-distribution for string. (2) compare the
string hash and length firstly before compare the string content.

The win is about 180% and 170% under x86-64 and arm64 when key_size is
252 and increase to 280% and 270% when key_size is greater than 512.

The detailed results follows.

  N-{byte|int-byte|int-bytes}: lookup on normal hash table with three
  	different key type and N-bytes as max string size.
  N-{str|int-str|int-strs}: lookup on string-key hash table with three
  	different key type and N-bytes as max string size.

Under x86-64:

132-htab-byte-lookup       11.946 ± 0.005M/s (drops 0.000 ± 0.000M/s)
132-htab-str-lookup        23.762 ± 0.028M/s (drops 0.000 ± 0.000M/s)
132-htab-int-byte-lookup   11.510 ± 0.012M/s (drops 0.000 ± 0.000M/s)
132-htab-int-str-lookup    19.885 ± 0.020M/s (drops 0.000 ± 0.000M/s)
132-htab-int-bytes-lookup  11.464 ± 0.009M/s (drops 0.000 ± 0.000M/s)
132-htab-int-strs-lookup   18.183 ± 0.020M/s (drops 0.000 ± 0.000M/s)

252-htab-byte-lookup       7.092 ± 0.003M/s (drops 0.000 ± 0.000M/s)
252-htab-str-lookup        20.126 ± 0.017M/s (drops 0.000 ± 0.000M/s)
252-htab-int-byte-lookup   6.949 ± 0.002M/s (drops 0.000 ± 0.000M/s)
252-htab-int-str-lookup    17.173 ± 0.019M/s (drops 0.000 ± 0.000M/s)
252-htab-int-bytes-lookup  6.878 ± 0.001M/s (drops 0.000 ± 0.000M/s)
252-htab-int-strs-lookup   15.153 ± 0.006M/s (drops 0.000 ± 0.000M/s)

516-htab-byte-lookup       3.719 ± 0.001M/s (drops 0.000 ± 0.000M/s)
516-htab-str-lookup        14.185 ± 0.004M/s (drops 0.000 ± 0.000M/s)
516-htab-int-byte-lookup   3.675 ± 0.002M/s (drops 0.000 ± 0.000M/s)
516-htab-int-str-lookup    12.354 ± 0.005M/s (drops 0.000 ± 0.000M/s)
516-htab-int-bytes-lookup  3.673 ± 0.001M/s (drops 0.000 ± 0.000M/s)
516-htab-int-strs-lookup   11.328 ± 0.004M/s (drops 0.000 ± 0.000M/s)

Under arm64:

132-htab-byte-lookup       8.680 ± 0.003M/s (drops 0.009 ± 0.000M/s)
132-htab-str-lookup        18.736 ± 0.010M/s (drops 0.000 ± 0.000M/s)
132-htab-int-byte-lookup   8.239 ± 0.004M/s (drops 0.000 ± 0.000M/s)
132-htab-int-str-lookup    16.395 ± 0.049M/s (drops 0.000 ± 0.000M/s)
132-htab-int-bytes-lookup  8.199 ± 0.008M/s (drops 0.000 ± 0.000M/s)
132-htab-int-strs-lookup   13.047 ± 0.006M/s (drops 0.000 ± 0.000M/s)

252-htab-byte-lookup       5.092 ± 0.008M/s (drops 0.000 ± 0.000M/s)
252-htab-str-lookup        14.065 ± 0.179M/s (drops 0.000 ± 0.000M/s)
252-htab-int-byte-lookup   4.939 ± 0.002M/s (drops 0.000 ± 0.000M/s)
252-htab-int-str-lookup    13.612 ± 0.009M/s (drops 0.000 ± 0.000M/s)
252-htab-int-bytes-lookup  4.953 ± 0.007M/s (drops 0.000 ± 0.000M/s)
252-htab-int-strs-lookup   11.228 ± 0.004M/s (drops 0.000 ± 0.000M/s)

516-htab-byte-lookup       2.661 ± 0.002M/s (drops 0.000 ± 0.000M/s)
516-htab-str-lookup        9.857 ± 0.012M/s (drops 0.000 ± 0.000M/s)
516-htab-int-byte-lookup   2.616 ± 0.001M/s (drops 0.000 ± 0.000M/s)
516-htab-int-str-lookup    9.143 ± 0.001M/s (drops 0.000 ± 0.000M/s)
516-htab-int-bytes-lookup  2.615 ± 0.000M/s (drops 0.000 ± 0.000M/s)
516-htab-int-strs-lookup   7.456 ± 0.002M/s (drops 0.000 ± 0.000M/s)

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/bench.c           |  14 +
 .../selftests/bpf/benchs/bench_str_htab.c     | 449 ++++++++++++++++++
 .../testing/selftests/bpf/benchs/run_htab.sh  |  11 +
 .../selftests/bpf/progs/str_htab_bench.c      | 224 +++++++++
 5 files changed, 701 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_str_htab.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_htab.sh
 create mode 100644 tools/testing/selftests/bpf/progs/str_htab_bench.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 91ea729990da..df174cfad8dd 100644
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
index f973320e6dbf..ba241d34b0ec 100644
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
 
@@ -397,6 +399,12 @@ extern const struct bench bench_hashmap_with_bloom;
 extern const struct bench bench_bpf_loop;
 extern const struct bench bench_strncmp_no_helper;
 extern const struct bench bench_strncmp_helper;
+extern const struct bench bench_htab_byte_lookup;
+extern const struct bench bench_htab_str_lookup;
+extern const struct bench bench_htab_int_byte_lookup;
+extern const struct bench bench_htab_int_str_lookup;
+extern const struct bench bench_htab_int_bytes_lookup;
+extern const struct bench bench_htab_int_strs_lookup;
 
 static const struct bench *benchs[] = {
 	&bench_count_global,
@@ -431,6 +439,12 @@ static const struct bench *benchs[] = {
 	&bench_bpf_loop,
 	&bench_strncmp_no_helper,
 	&bench_strncmp_helper,
+	&bench_htab_byte_lookup,
+	&bench_htab_str_lookup,
+	&bench_htab_int_byte_lookup,
+	&bench_htab_int_str_lookup,
+	&bench_htab_int_bytes_lookup,
+	&bench_htab_int_strs_lookup,
 };
 
 static void setup_benchmark()
diff --git a/tools/testing/selftests/bpf/benchs/bench_str_htab.c b/tools/testing/selftests/bpf/benchs/bench_str_htab.c
new file mode 100644
index 000000000000..6fee5701821b
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_str_htab.c
@@ -0,0 +1,449 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022. Huawei Technologies Co., Ltd */
+#include <argp.h>
+#include "bench.h"
+#include "bpf_util.h"
+
+#define DFT_STR_KEY_SIZE 252
+
+struct htab_byte_key {
+	char name[DFT_STR_KEY_SIZE];
+};
+
+struct htab_str_key {
+	struct bpf_str_key_stor name;
+	char raw[DFT_STR_KEY_SIZE];
+};
+
+struct htab_int_byte_key {
+        int cookie;
+        char name[DFT_STR_KEY_SIZE];
+};
+
+struct htab_int_str_key {
+        int cookie;
+        struct bpf_str_key_stor name;
+        char raw[DFT_STR_KEY_SIZE];
+};
+
+struct htab_int_bytes_key {
+        int cookie;
+        char name[DFT_STR_KEY_SIZE / 2];
+        char addr[DFT_STR_KEY_SIZE / 2];
+};
+
+struct htab_int_strs_key {
+        int cookie;
+        struct bpf_str_key_desc name;
+        struct bpf_str_key_desc addr;
+        struct bpf_str_key_stor stor;
+        char raw[DFT_STR_KEY_SIZE];
+};
+
+#include "str_htab_bench.skel.h"
+
+typedef void *(*get_nth_key)(struct str_htab_bench *skel, unsigned int i);
+typedef void (*set_key)(void *key);
+
+static const char strs[] =
+"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!\"#$%&'()*+,-./:;<=>?@[]^_`{|}~ ";
+
+static struct str_htab_ctx {
+	struct str_htab_bench *skel;
+} ctx;
+
+static struct {
+	bool same_len;
+	__u32 max_entries;
+} args = {
+	.same_len = false,
+	.max_entries = 1000,
+};
+
+enum {
+	ARG_SAME_LEN = 6000,
+	ARG_MAX_ENTRIES = 6001,
+};
+
+static const struct argp_option opts[] = {
+	{ "same-len", ARG_SAME_LEN, NULL, 0,
+	  "Use the same length for string keys" },
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
+	if (!args.max_entries ||
+	    args.max_entries > ARRAY_SIZE(ctx.skel->bss->byte_keys)) {
+		fprintf(stderr, "invalid max entries (max %zu)\n",
+			ARRAY_SIZE(ctx.skel->bss->byte_keys));
+		exit(1);
+	}
+}
+
+static void setup_max_entries(struct str_htab_bench *skel, unsigned int nr)
+{
+	bpf_map__set_max_entries(skel->maps.byte_htab, nr);
+	bpf_map__set_max_entries(skel->maps.str_htab, nr);
+	bpf_map__set_max_entries(skel->maps.int_byte_htab, nr);
+	bpf_map__set_max_entries(skel->maps.int_str_htab, nr);
+	bpf_map__set_max_entries(skel->maps.int_bytes_htab, nr);
+	bpf_map__set_max_entries(skel->maps.int_strs_htab, nr);
+}
+
+static void random_fill_str(char *str, unsigned int max_sz, unsigned int *sz)
+{
+	unsigned int len;
+	unsigned int i;
+
+	if (args.same_len)
+		len = max_sz - 1;
+	else
+		len = random() % (max_sz - 1) + 1;
+	if (sz)
+		*sz = len + 1;
+
+	/* Generate in byte-granularity to avoid zero byte */
+	for (i = 0; i < len; i++)
+		str[i] = strs[random() % (sizeof(strs) - 1)];
+	str[i] = 0;
+}
+
+static void setup_keys(struct str_htab_bench *skel, get_nth_key getter, set_key setter)
+{
+	unsigned int i;
+
+	for (i = 0; i < args.max_entries; i++) {
+		void *key = getter(skel, i);
+
+		setter(key);
+	}
+}
+
+static void setup_htab(struct str_htab_bench *skel, struct bpf_map *map,
+		       get_nth_key getter)
+{
+	int fd = bpf_map__fd(map);
+	unsigned int value;
+	unsigned int i;
+	void *key;
+
+	for (i = 0; i < args.max_entries; i++) {
+		int err;
+
+		key = getter(skel, i);
+		value = i;
+		err = bpf_map_update_elem(fd, key, &value, 0);
+		if (err) {
+			fprintf(stderr, "add #%u key on %s error %d\n",
+				i, bpf_map__name(map), err);
+			exit(1);
+		}
+	}
+}
+
+static void *byte_get_nth_key(struct str_htab_bench *skel, unsigned int i)
+{
+	return &skel->bss->byte_keys[i];
+}
+
+static void byte_set_key(void *key)
+{
+	struct htab_byte_key *cur = key;
+
+	random_fill_str(cur->name, sizeof(cur->name), NULL);
+}
+
+static void *int_byte_get_nth_key(struct str_htab_bench *skel, unsigned int i)
+{
+	return &skel->bss->int_byte_keys[i];
+}
+
+static void int_byte_set_key(void *key)
+{
+	struct htab_int_byte_key *cur = key;
+
+	cur->cookie = random();
+	random_fill_str(cur->name, sizeof(cur->name), NULL);
+}
+
+static void *int_bytes_get_nth_key(struct str_htab_bench *skel, unsigned int i)
+{
+	return &skel->bss->int_bytes_keys[i];
+}
+
+static void int_bytes_set_key(void *key)
+{
+	struct htab_int_bytes_key *cur = key;
+
+	cur->cookie = random();
+	random_fill_str(cur->name, sizeof(cur->name), NULL);
+	random_fill_str(cur->addr, sizeof(cur->addr), NULL);
+}
+
+static void *str_get_nth_key(struct str_htab_bench *skel, unsigned int i)
+{
+	return &skel->bss->str_keys[i];
+}
+
+static void str_set_key(void *key)
+{
+	struct htab_str_key *cur = key;
+
+	cur->name.hash = 0;
+	random_fill_str(cur->raw, sizeof(cur->raw), &cur->name.len);
+}
+
+static void *int_str_get_nth_key(struct str_htab_bench *skel, unsigned int i)
+{
+	return &skel->bss->int_str_keys[i];
+}
+
+static void int_str_set_key(void *key)
+{
+	struct htab_int_str_key *cur = key;
+
+	cur->cookie = random();
+	cur->name.hash = 0;
+	random_fill_str(cur->raw, sizeof(cur->raw), &cur->name.len);
+}
+
+static void *int_strs_get_nth_key(struct str_htab_bench *skel, unsigned int i)
+{
+	return &skel->bss->int_strs_keys[i];
+}
+
+static void int_strs_set_key(void *key)
+{
+	struct htab_int_strs_key *cur = key;
+	unsigned int max_sz = sizeof(cur->raw) / 2;
+
+	cur->cookie = random();
+
+	cur->name.offset = cur->raw - (char *)&cur->name;
+	random_fill_str(cur->raw, max_sz, &cur->name.len);
+
+	cur->addr.offset = cur->raw + cur->name.len - (char *)&cur->addr;
+	random_fill_str(cur->raw + cur->name.len, max_sz, &cur->addr.len);
+
+	cur->stor.hash = 0;
+	cur->stor.len = cur->name.len + cur->addr.len;
+}
+
+static void str_htab_common_setup(void)
+{
+	struct str_htab_bench *skel;
+	int err;
+
+	srandom(time(NULL));
+
+	setup_libbpf();
+
+	skel = str_htab_bench__open();
+	if (!skel) {
+		fprintf(stderr, "failed to open skeleton\n");
+		exit(1);
+	}
+
+	setup_max_entries(skel, args.max_entries);
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
+static void str_htab_byte_lookup_setup(void)
+{
+	str_htab_common_setup();
+
+	setup_keys(ctx.skel, byte_get_nth_key, byte_set_key);
+	setup_htab(ctx.skel, ctx.skel->maps.byte_htab, byte_get_nth_key);
+
+	ctx.skel->bss->key_type = 0;
+	str_htab_attach_prog(ctx.skel->progs.htab_byte_lookup);
+}
+
+static void str_htab_int_byte_lookup_setup(void)
+{
+	str_htab_common_setup();
+
+	setup_keys(ctx.skel, int_byte_get_nth_key, int_byte_set_key);
+	setup_htab(ctx.skel, ctx.skel->maps.int_byte_htab, int_byte_get_nth_key);
+
+	ctx.skel->bss->key_type = 1;
+	str_htab_attach_prog(ctx.skel->progs.htab_byte_lookup);
+}
+
+static void str_htab_int_bytes_lookup_setup(void)
+{
+	str_htab_common_setup();
+
+	setup_keys(ctx.skel, int_bytes_get_nth_key, int_bytes_set_key);
+	setup_htab(ctx.skel, ctx.skel->maps.int_bytes_htab, int_bytes_get_nth_key);
+
+	ctx.skel->bss->key_type = 2;
+	str_htab_attach_prog(ctx.skel->progs.htab_byte_lookup);
+}
+
+static void str_htab_str_lookup_setup(void)
+{
+	str_htab_common_setup();
+
+	setup_keys(ctx.skel, str_get_nth_key, str_set_key);
+	setup_htab(ctx.skel, ctx.skel->maps.str_htab, str_get_nth_key);
+
+	ctx.skel->bss->key_type = 0;
+	str_htab_attach_prog(ctx.skel->progs.htab_str_lookup);
+}
+
+static void str_htab_int_str_lookup_setup(void)
+{
+	str_htab_common_setup();
+
+	setup_keys(ctx.skel, int_str_get_nth_key, int_str_set_key);
+	setup_htab(ctx.skel, ctx.skel->maps.int_str_htab, int_str_get_nth_key);
+
+	ctx.skel->bss->key_type = 1;
+	str_htab_attach_prog(ctx.skel->progs.htab_str_lookup);
+}
+
+static void str_htab_int_strs_lookup_setup(void)
+{
+	str_htab_common_setup();
+
+	setup_keys(ctx.skel, int_strs_get_nth_key, int_strs_set_key);
+	setup_htab(ctx.skel, ctx.skel->maps.int_strs_htab, int_strs_get_nth_key);
+
+	ctx.skel->bss->key_type = 2;
+	str_htab_attach_prog(ctx.skel->progs.htab_str_lookup);
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
+const struct bench bench_htab_byte_lookup = {
+	.name = "htab-byte-lookup",
+	.validate = str_htab_validate,
+	.setup = str_htab_byte_lookup_setup,
+	.producer_thread = str_htab_producer,
+	.consumer_thread = str_htab_consumer,
+	.measure = str_htab_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = hits_drops_report_final,
+};
+
+const struct bench bench_htab_int_byte_lookup = {
+	.name = "htab-int-byte-lookup",
+	.validate = str_htab_validate,
+	.setup = str_htab_int_byte_lookup_setup,
+	.producer_thread = str_htab_producer,
+	.consumer_thread = str_htab_consumer,
+	.measure = str_htab_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = hits_drops_report_final,
+};
+
+const struct bench bench_htab_int_bytes_lookup = {
+	.name = "htab-int-bytes-lookup",
+	.validate = str_htab_validate,
+	.setup = str_htab_int_bytes_lookup_setup,
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
+const struct bench bench_htab_int_str_lookup = {
+	.name = "htab-int-str-lookup",
+	.validate = str_htab_validate,
+	.setup = str_htab_int_str_lookup_setup,
+	.producer_thread = str_htab_producer,
+	.consumer_thread = str_htab_consumer,
+	.measure = str_htab_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = hits_drops_report_final,
+};
+
+const struct bench bench_htab_int_strs_lookup = {
+	.name = "htab-int-strs-lookup",
+	.validate = str_htab_validate,
+	.setup = str_htab_int_strs_lookup_setup,
+	.producer_thread = str_htab_producer,
+	.consumer_thread = str_htab_consumer,
+	.measure = str_htab_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = hits_drops_report_final,
+};
diff --git a/tools/testing/selftests/bpf/benchs/run_htab.sh b/tools/testing/selftests/bpf/benchs/run_htab.sh
new file mode 100755
index 000000000000..c848324dd256
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/run_htab.sh
@@ -0,0 +1,11 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source ./benchs/run_common.sh
+
+set -eufo pipefail
+
+for tp in byte str int-byte int-str int-bytes int-strs; do
+	name=htab-${tp}-lookup
+	summarize ${name} "$($RUN_BENCH ${name})"
+done
diff --git a/tools/testing/selftests/bpf/progs/str_htab_bench.c b/tools/testing/selftests/bpf/progs/str_htab_bench.c
new file mode 100644
index 000000000000..008c654e85cb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/str_htab_bench.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022. Huawei Technologies Co., Ltd */
+#include <linux/types.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define MAX_ENTRY_NR 1000
+#define DFT_STR_KEY_SIZE 252
+
+struct htab_byte_key {
+	char name[DFT_STR_KEY_SIZE];
+};
+
+struct htab_str_key {
+	struct bpf_str_key_stor name;
+	char raw[DFT_STR_KEY_SIZE];
+};
+
+struct htab_int_byte_key {
+	int cookie;
+	char name[DFT_STR_KEY_SIZE];
+};
+
+struct htab_int_str_key {
+	int cookie;
+	struct bpf_str_key_stor name;
+	char raw[DFT_STR_KEY_SIZE];
+};
+
+struct htab_int_bytes_key {
+	int cookie;
+	char name[DFT_STR_KEY_SIZE / 2];
+	char addr[DFT_STR_KEY_SIZE / 2];
+};
+
+struct htab_int_strs_key {
+	int cookie;
+	struct bpf_str_key_desc name;
+	struct bpf_str_key_desc addr;
+	struct bpf_str_key_stor stor;
+	char raw[DFT_STR_KEY_SIZE];
+};
+
+/* max_entries will be set by htab benchmark */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct htab_byte_key);
+	__uint(value_size, 4);
+	__type(value, __u32);
+} byte_htab SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct htab_int_byte_key);
+	__type(value, __u32);
+} int_byte_htab SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct htab_int_bytes_key);
+	__type(value, __u32);
+} int_bytes_htab SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct htab_str_key);
+	__type(value, __u32);
+	__uint(map_flags, BPF_F_STR_IN_KEY);
+} str_htab SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct htab_int_str_key);
+	__type(value, __u32);
+	__uint(map_flags, BPF_F_STR_IN_KEY);
+} int_str_htab SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, struct htab_int_strs_key);
+	__type(value, __u32);
+	__uint(map_flags, BPF_F_STR_IN_KEY);
+} int_strs_htab SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+struct htab_byte_key byte_keys[MAX_ENTRY_NR];
+struct htab_str_key str_keys[MAX_ENTRY_NR];
+struct htab_int_byte_key int_byte_keys[MAX_ENTRY_NR];
+struct htab_int_str_key int_str_keys[MAX_ENTRY_NR];
+struct htab_int_bytes_key int_bytes_keys[MAX_ENTRY_NR];
+struct htab_int_strs_key int_strs_keys[MAX_ENTRY_NR];
+
+unsigned int loops = 0;
+unsigned int key_type = 0;
+long hits = 0;
+long drops = 0;
+
+static int lookup_byte(__u32 index, void *data)
+{
+	unsigned int *value;
+
+	if (index >= MAX_ENTRY_NR)
+		return 1;
+
+	value = bpf_map_lookup_elem(&byte_htab, &byte_keys[index]);
+	if (value && *value == index)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+static int lookup_int_byte(__u32 index, void *data)
+{
+	unsigned int *value;
+
+	if (index >= MAX_ENTRY_NR)
+		return 1;
+
+	value = bpf_map_lookup_elem(&int_byte_htab, &int_byte_keys[index]);
+	if (value && *value == index)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+static int lookup_int_bytes(__u32 index, void *data)
+{
+	unsigned int *value;
+
+	if (index >= MAX_ENTRY_NR)
+		return 1;
+
+	value = bpf_map_lookup_elem(&int_bytes_htab, &int_bytes_keys[index]);
+	if (value && *value == index)
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
+	/* Clear the hash value from previous lookup */
+	str_keys[index].name.hash = 0;
+	value = bpf_map_lookup_elem(&str_htab, &str_keys[index]);
+	if (value && *value == index)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+static int lookup_int_str(__u32 index, void *data)
+{
+	unsigned int *value;
+
+	if (index >= MAX_ENTRY_NR)
+		return 1;
+
+	int_str_keys[index].name.hash = 0;
+	value = bpf_map_lookup_elem(&int_str_htab, &int_str_keys[index]);
+	if (value && *value == index)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+static int lookup_int_strs(__u32 index, void *data)
+{
+	unsigned int *value;
+
+	if (index >= MAX_ENTRY_NR)
+		return 1;
+
+	int_strs_keys[index].stor.hash = 0;
+	value = bpf_map_lookup_elem(&int_strs_htab, &int_strs_keys[index]);
+	if (value && *value == index)
+		__sync_add_and_fetch(&hits, 1);
+	else
+		__sync_add_and_fetch(&drops, 1);
+
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int htab_byte_lookup(void *ctx)
+{
+	if (!key_type)
+		bpf_loop(loops, lookup_byte, NULL, 0);
+	else if (key_type == 1)
+		bpf_loop(loops, lookup_int_byte, NULL, 0);
+	else
+		bpf_loop(loops, lookup_int_bytes, NULL, 0);
+
+	return 0;
+}
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int htab_str_lookup(void *ctx)
+{
+	if (!key_type)
+		bpf_loop(loops, lookup_str, NULL, 0);
+	else if (key_type == 1)
+		bpf_loop(loops, lookup_int_str, NULL, 0);
+	else
+		bpf_loop(loops, lookup_int_strs, NULL, 0);
+
+	return 0;
+}
-- 
2.25.4

