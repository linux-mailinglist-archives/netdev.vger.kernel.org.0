Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916E5595F1F
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbiHPPd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbiHPPdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:33:43 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0233C5C964
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:33:24 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id w18-20020a170902e89200b0016eff609594so6840910plg.11
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=hWy/bky5ij4Fq019kN/Eoim7rgLKUQHE3Pxq9PEt+N4=;
        b=dZLYGjBsJQEFyvLvwzJi71Lm4aVcp+v9jpcvAepnhj8Mw+nl4m5eOaJk+KmsxT0HEs
         DtC3QJk33/pn7TT65fsc47N/3WN/cBj6hQUPCtDGzxCs4858QPwc4/p+e7qVyYmPhRwq
         tm4mIkLudQ7NrUAjE0ocKQKgtMzW6pCqkJdvJwQhIEEw9mLoIhGT+tZQtbaHgZ8pY/gK
         6UVlQ7kxNjVB7I4o91NUqsO1KNhFARD+dpOk15lsmF26aVAYz9dir4L/b7KsqokdhhPZ
         xrnPvDQGaJjyLmUp8ymm/WoZfIKcCRko/J/cEixrTk3lOxlDipC9Nodz21HMwAH7guhI
         J/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=hWy/bky5ij4Fq019kN/Eoim7rgLKUQHE3Pxq9PEt+N4=;
        b=ttLDEqxEkUwt4zAhSOx6wFvOtKZTGg5cgzAk6DuGYBgq+TnwZ5Ww+rVaaZnsxaQuDx
         SSX+PXpCrw/0rnVUI465FQjQ6oWr31ZGfZ9KSwh9T7pWCPnqGm4fAlQbf1VmZxtFOkVl
         ct0jj8m9klHBMF1iLzh3I4r6fg6idjRwG4e+dgsMsGNachtAW6gc3cVtN/hA+iQOyHrg
         8ykrAIhREH2ZBMi4LS5M8doItdTGj8P3K1KvAsQLMozLCRl58lsRcAlOYTZFB0kJ4tfl
         xzPkLRrdwicOU0S9l4aJomBOz/G0b8azsySlFQx3XKD5K1Uc91etUi1iee0eGFEd05xD
         5fpQ==
X-Gm-Message-State: ACgBeo1CU9DgRDtJO5hgzAs80O7pKlh3m9FV0UEgQFek9HschOLDckxN
        ITYE1j5xUK3V9ksy1Vo45flyXafHfLEHtfnUCrKXuw==
X-Google-Smtp-Source: AA6agR43H1WEzEHDPciCug0nTkf/X0Yq+Oh7uhDDklGKSMamxC7Tb9t/fgB6rbF1dQBaV6phM/wqQAHnPkOJX6M+/fBkMg==
X-Received: from sagarika.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5714])
 (user=sharmasagarika job=sendgmr) by 2002:a17:902:d50a:b0:16e:e1c1:dfa7 with
 SMTP id b10-20020a170902d50a00b0016ee1c1dfa7mr22504683plg.160.1660664004410;
 Tue, 16 Aug 2022 08:33:24 -0700 (PDT)
Date:   Tue, 16 Aug 2022 15:33:19 +0000
Message-Id: <20220816153320.1478209-1-sharmasagarika@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH bpf-next 1/2] Benchmark test added: bench_bpf_htab_batch_ops
From:   Sagarika Sharma <sharmasagarika@google.com>
To:     Brian Vazquez <brianvv@google.com>,
        Sagarika Sharma <sagarikashar@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Sagarika Sharma <sharmasagarika@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The benchmark test is a tool to measure the different methods
of iterating through bpf hashmaps, specifically the function
bpf_map_lookup_batch() and the combination of the two functions
bpf_get_next_key()/bpf_map_lookup_elem(). The test will be
extended to also measure bpf_iter. The shell script
bench_bpf_htab_batch_ops.sh runs the benchmark test with a range
of parameters (e.g. the capacity of the hashmap, the number of
entries put in the map, and the setting of the n_prefetch module
parameter)

Signed-off-by: Sagarika Sharma <sharmasagarika@google.com>
---
 tools/testing/selftests/bpf/Makefile          |   3 +-
 tools/testing/selftests/bpf/bench.c           |  26 +-
 .../bpf/benchs/bench_bpf_htab_batch_ops.c     | 237 ++++++++++++++++++
 .../benchs/run_bench_bpf_htab_batch_ops.sh    |  28 +++
 4 files changed, 292 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_htab_batch_ops.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_htab_batch_ops.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 8d59ec7f4c2d..772d8339c400 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -589,7 +589,8 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o \
 		 $(OUTPUT)/bench_strncmp.o \
 		 $(OUTPUT)/bench_bpf_hashmap_full_update.o \
 		 $(OUTPUT)/bench_local_storage.o \
-		 $(OUTPUT)/bench_local_storage_rcu_tasks_trace.o
+		 $(OUTPUT)/bench_local_storage_rcu_tasks_trace.o \
+		 $(OUTPUT)/bench_bpf_htab_batch_ops.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.a %.o,$^) $(LDLIBS) -o $@
 
diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index c1f20a147462..55714e8071c8 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -12,6 +12,8 @@
 #include "bench.h"
 #include "testing_helpers.h"
 
+#define STK_SIZE (0xfffffff)
+
 struct env env = {
 	.warmup_sec = 1,
 	.duration_sec = 5,
@@ -275,6 +277,7 @@ extern struct argp bench_bpf_loop_argp;
 extern struct argp bench_local_storage_argp;
 extern struct argp bench_local_storage_rcu_tasks_trace_argp;
 extern struct argp bench_strncmp_argp;
+extern struct argp bench_bpf_htab_batch_ops_argp;
 
 static const struct argp_child bench_parsers[] = {
 	{ &bench_ringbufs_argp, 0, "Ring buffers benchmark", 0 },
@@ -284,6 +287,7 @@ static const struct argp_child bench_parsers[] = {
 	{ &bench_strncmp_argp, 0, "bpf_strncmp helper benchmark", 0 },
 	{ &bench_local_storage_rcu_tasks_trace_argp, 0,
 		"local_storage RCU Tasks Trace slowdown benchmark", 0 },
+	{ &bench_bpf_htab_batch_ops_argp, 0, "bpf_htab_ops benchmark", 0},
 	{},
 };
 
@@ -490,6 +494,8 @@ extern const struct bench bench_local_storage_cache_seq_get;
 extern const struct bench bench_local_storage_cache_interleaved_get;
 extern const struct bench bench_local_storage_cache_hashmap_control;
 extern const struct bench bench_local_storage_tasks_trace;
+extern const struct bench bench_bpf_htab_batch_ops;
+extern const struct bench bench_bpf_htab_element_ops;
 
 static const struct bench *benchs[] = {
 	&bench_count_global,
@@ -529,6 +535,8 @@ static const struct bench *benchs[] = {
 	&bench_local_storage_cache_interleaved_get,
 	&bench_local_storage_cache_hashmap_control,
 	&bench_local_storage_tasks_trace,
+	&bench_bpf_htab_batch_ops,
+	&bench_bpf_htab_element_ops,
 };
 
 static void setup_benchmark()
@@ -585,7 +593,23 @@ static void setup_benchmark()
 		env.prod_cpus.next_cpu = env.cons_cpus.next_cpu;
 
 	for (i = 0; i < env.producer_cnt; i++) {
-		err = pthread_create(&state.producers[i], NULL,
+		pthread_attr_t attr_producer;
+
+		err = pthread_attr_init(&attr_producer);
+		if (err) {
+			fprintf(stderr, "failed to initialize pthread attr #%d: %d\n",
+				i, -errno);
+			exit(1);
+		}
+
+		err = pthread_attr_setstacksize(&attr_producer, STK_SIZE);
+		if (err) {
+			fprintf(stderr, "failed to set pthread stacksize #%d: %d\n",
+				i, -errno);
+			exit(1);
+		}
+
+		err = pthread_create(&state.producers[i], &attr_producer,
 				     bench->producer_thread, (void *)(long)i);
 		if (err) {
 			fprintf(stderr, "failed to create producer thread #%d: %d\n",
diff --git a/tools/testing/selftests/bpf/benchs/bench_bpf_htab_batch_ops.c b/tools/testing/selftests/bpf/benchs/bench_bpf_htab_batch_ops.c
new file mode 100644
index 000000000000..ea98c2e97bff
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_bpf_htab_batch_ops.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <errno.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <argp.h>
+#include "bench.h"
+#include <bpf_util.h>
+
+/* A hash table of the size DEFAULT_NUM_ENTRIES
+ * makes evident the effect of optimizing
+ * functions that iterate through the map
+ */
+#define DEFAULT_NUM_ENTRIES 40000
+#define VALUE_SIZE 4
+
+int map_fd, method_flag, hits;
+
+static struct {
+	__u32 capacity;
+	__u32 num_entries;
+} args = {
+	.capacity = DEFAULT_NUM_ENTRIES,
+	.num_entries = DEFAULT_NUM_ENTRIES,
+};
+
+enum {
+	ARG_CAPACITY = 8000,
+	ARG_NUM_ENTRIES = 8001,
+};
+
+static const struct argp_option opts[] = {
+	{ "capacity", ARG_CAPACITY, "capacity", 0,
+		"Set hashtable capacity"},
+	{"num_entries", ARG_NUM_ENTRIES, "num_entries", 0,
+		"Set number of entries in the hashtable"},
+	{}
+};
+
+static error_t parse_arg(int key, char *arg, struct argp_state *state)
+{
+	switch (key) {
+	case ARG_CAPACITY:
+		args.capacity = strtol(arg, NULL, 10);
+		break;
+	case ARG_NUM_ENTRIES:
+		args.num_entries = strtol(arg, NULL, 10);
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+
+	return 0;
+}
+
+const struct argp bench_bpf_htab_batch_ops_argp = {
+	.options = opts,
+	.parser = parse_arg,
+};
+
+static void validate(void)
+{
+	if (args.num_entries > args.capacity) {
+		fprintf(stderr, "num_entries must be less than hash table capacity");
+		exit(1);
+	}
+
+	if (env.producer_cnt != 1) {
+		fprintf(stderr, "benchmark doesn't support multi-producer!\n");
+		exit(1);
+	}
+
+	if (env.consumer_cnt != 1) {
+		fprintf(stderr, "benchmark doesn't support multi-consumer!\n");
+		exit(1);
+	}
+}
+
+static inline void loop_bpf_map_lookup_batch(void)
+{
+	int num_cpus = bpf_num_possible_cpus();
+	typedef struct { int v[VALUE_SIZE]; /* padding */ } __bpf_percpu_val_align value[num_cpus];
+	int offset = 0, out_batch = 0, in_batch = 0;
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, operts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+	value pcpu_values[args.num_entries];
+	__u32 count = args.num_entries;
+	double keys[args.num_entries];
+	int *in_batch_ptr = NULL;
+	int err;
+
+	while (true) {
+		err = bpf_map_lookup_batch(map_fd, in_batch_ptr, &out_batch,
+			keys + offset, pcpu_values + offset, &count, &operts);
+
+		if (err && errno != ENOENT) {
+			fprintf(stderr, "Failed to lookup entries using bpf_map_lookup_batch\n");
+			exit(1);
+		}
+
+		hits += count;
+
+		if (count == args.num_entries) {
+			count = args.num_entries;
+			offset = out_batch = 0;
+			in_batch_ptr = NULL;
+		} else {
+			offset = count;
+			count = args.num_entries - count;
+			in_batch = out_batch;
+			in_batch_ptr = &in_batch;
+		}
+	}
+
+}
+
+static inline void loop_bpf_element_lookup(void)
+{
+	int num_cpus = bpf_num_possible_cpus();
+	typedef struct { int v[VALUE_SIZE]; /* padding */ } __bpf_percpu_val_align value[num_cpus];
+	double prev_key = -1, key;
+	value value_of_key;
+	int err;
+
+	while (true) {
+
+		while (bpf_map_get_next_key(map_fd, &prev_key, &key) == 0) {
+			err = bpf_map_lookup_elem(map_fd, &key, &value_of_key);
+			if (err) {
+				fprintf(stderr, "failed to lookup element using bpf_map_lookup_elem\n");
+				exit(1);
+			}
+			hits += 1;
+			prev_key = key;
+		}
+		prev_key = -1;
+
+	}
+
+}
+
+static void *producer(void *input)
+{
+	switch (method_flag) {
+	case 0:
+		loop_bpf_map_lookup_batch();
+		break;
+	case 1:
+		loop_bpf_element_lookup();
+		break;
+	}
+	return NULL;
+}
+
+static void *consumer(void *input)
+{
+	return NULL;
+}
+
+static void measure(struct bench_res *res)
+{
+	res->hits = hits;
+	hits = 0;
+}
+
+
+static void setup(void)
+{
+
+	typedef struct { int v[VALUE_SIZE]; /* padding */ } __bpf_percpu_val_align value[bpf_num_possible_cpus()];
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, operts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+	value pcpu_values[args.num_entries];
+	__u32 count = args.num_entries;
+	double keys[args.num_entries];
+	int err;
+
+	map_fd = bpf_map_create(BPF_MAP_TYPE_PERCPU_HASH, "hash_map", sizeof(double),
+		(VALUE_SIZE*sizeof(int)), args.capacity, NULL);
+	if (map_fd < 0) {
+		fprintf(stderr, "error creating map using bpf_map_create\n");
+		exit(1);
+	}
+
+	for (double i = 0; i < args.num_entries; i++) {
+		keys[(int)i] = i + 1;
+		for (int j = 0; j < bpf_num_possible_cpus(); j++) {
+			for (int k = 0; k < VALUE_SIZE; k++)
+				bpf_percpu(pcpu_values[(int)i], j)[k] = (int)i + j + k;
+		}
+	}
+
+	err = bpf_map_update_batch(map_fd, keys, pcpu_values, &count, &operts);
+	if (err < 0) {
+		fprintf(stderr, "Failed to populate map using bpf_map_update_batch\n");
+		exit(1);
+	}
+
+}
+
+static void bench_bpf_map_lookup_batch_setup(void)
+{
+	setup();
+	method_flag = 0;
+}
+
+static void bench_element_lookup_setup(void)
+{
+	setup();
+	method_flag = 1;
+}
+
+const struct bench bench_bpf_htab_batch_ops = {
+	.name = "htab-batch-ops",
+	.validate = validate,
+	.setup = bench_bpf_map_lookup_batch_setup,
+	.producer_thread = producer,
+	.consumer_thread = consumer,
+	.measure = measure,
+	.report_progress = ops_report_progress,
+	.report_final = ops_report_final,
+};
+
+const struct bench bench_bpf_htab_element_ops = {
+	.name = "htab-element-ops",
+	.validate = validate,
+	.setup = bench_element_lookup_setup,
+	.producer_thread = producer,
+	.consumer_thread = consumer,
+	.measure = measure,
+	.report_progress = ops_report_progress,
+	.report_final = ops_report_final,
+};
diff --git a/tools/testing/selftests/bpf/benchs/run_bench_bpf_htab_batch_ops.sh b/tools/testing/selftests/bpf/benchs/run_bench_bpf_htab_batch_ops.sh
new file mode 100755
index 000000000000..624f403c1865
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/run_bench_bpf_htab_batch_ops.sh
@@ -0,0 +1,28 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source ./benchs/run_common.sh
+
+set -eufo pipefail
+
+map_capacity=40000
+header "bpf_get_next_key & bpf_map_lookup_elem"
+for t in 40000 10000 2500; do
+subtitle "map capacity: $map_capacity, num_entries: $t"
+        summarize_ops "bpf_element_ops: " \
+                "$($RUN_BENCH -p 1 --num_entries $t htab-element-ops)"
+        printf "\n"
+done
+
+header "bpf_map_lookup_batch with prefetch"
+for t in 40000 10000 2500; do
+for n in {0..20}; do
+#this range of n_prefetch shows the speedup and subsequent
+#deterioration as n_prefetch grows larger
+subtitle "map capacity: $map_capacity, num_entries: $t, n_prefetch: $n"
+        echo $n > /sys/module/hashtab/parameters/n_prefetch
+        summarize_ops "bpf_batch_ops: " \
+                "$($RUN_BENCH -p 1 --num_entries $t htab-batch-ops)"
+        printf "\n"
+done
+done
-- 
2.37.1.595.g718a3a8f04-goog

