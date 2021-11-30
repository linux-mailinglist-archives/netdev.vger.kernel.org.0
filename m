Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50AB46361F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242030AbhK3OKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:10:31 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27321 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236521AbhK3OKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:10:21 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J3PCx4RWKzbjDF;
        Tue, 30 Nov 2021 22:06:53 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 30 Nov
 2021 22:06:59 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 3/5] selftests/bpf: factor out common helpers for benchmarks
Date:   Tue, 30 Nov 2021 22:22:13 +0800
Message-ID: <20211130142215.1237217-4-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211130142215.1237217-1-houtao1@huawei.com>
References: <20211130142215.1237217-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Five helpers are factored out to reduce boilerplate for
benchmark tests: do_getpgid(), getpgid_loop_producer(),
assert_single_consumer(), assert_single_producer() and
noop_consumer().

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tools/testing/selftests/bpf/bench.c           | 13 +++++
 tools/testing/selftests/bpf/bench.h           | 25 +++++++++
 .../bpf/benchs/bench_bloom_filter_map.c       | 44 ++++-----------
 .../selftests/bpf/benchs/bench_count.c        | 14 +----
 .../selftests/bpf/benchs/bench_rename.c       | 27 +++------
 .../selftests/bpf/benchs/bench_ringbufs.c     |  7 +--
 .../selftests/bpf/benchs/bench_trigger.c      | 55 +++++++------------
 7 files changed, 81 insertions(+), 104 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index ffb589b885c5..681db8175fe1 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -134,6 +134,19 @@ void hits_drops_report_final(struct bench_res res[], int res_cnt)
 	       total_ops_mean, total_ops_stddev);
 }
 
+void *getpgid_loop_producer(void *ctx)
+{
+	while (true)
+		do_getpgid();
+
+	return NULL;
+}
+
+void *noop_consumer(void *ctx)
+{
+	return NULL;
+}
+
 const char *argp_program_version = "benchmark";
 const char *argp_program_bug_address = "<bpf@vger.kernel.org>";
 const char argp_program_doc[] =
diff --git a/tools/testing/selftests/bpf/bench.h b/tools/testing/selftests/bpf/bench.h
index 3fb8401b7314..79913082b469 100644
--- a/tools/testing/selftests/bpf/bench.h
+++ b/tools/testing/selftests/bpf/bench.h
@@ -59,6 +59,8 @@ void hits_drops_report_progress(int iter, struct bench_res *res, long delta_ns);
 void hits_drops_report_final(struct bench_res res[], int res_cnt);
 void false_hits_report_progress(int iter, struct bench_res *res, long delta_ns);
 void false_hits_report_final(struct bench_res res[], int res_cnt);
+void *getpgid_loop_producer(void *ctx);
+void *noop_consumer(void *ctx);
 
 static inline __u64 get_time_ns(void)
 {
@@ -83,3 +85,26 @@ static inline long atomic_swap(long *value, long n)
 {
 	return __atomic_exchange_n(value, n, __ATOMIC_RELAXED);
 }
+
+static inline void assert_single_consumer(const char *name)
+{
+	if (env.consumer_cnt != 1) {
+		fprintf(stderr, "%s benchmark doesn't support multi-consumer!\n",
+			name);
+		exit(1);
+	}
+}
+
+static inline void assert_single_producer(const char *name)
+{
+	if (env.producer_cnt != 1) {
+		fprintf(stderr, "%s benchmark doesn't support multi-producer!\n",
+			name);
+		exit(1);
+	}
+}
+
+static inline void do_getpgid(void)
+{
+	(void)syscall(__NR_getpgid, 0);
+}
diff --git a/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c b/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
index 5bcb8a8cdeb2..796553a7ab17 100644
--- a/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
+++ b/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
@@ -107,24 +107,7 @@ const struct argp bench_bloom_map_argp = {
 
 static void validate(void)
 {
-	if (env.consumer_cnt != 1) {
-		fprintf(stderr,
-			"The bloom filter benchmarks do not support multi-consumer use\n");
-		exit(1);
-	}
-}
-
-static inline void trigger_bpf_program(void)
-{
-	syscall(__NR_getpgid);
-}
-
-static void *producer(void *input)
-{
-	while (true)
-		trigger_bpf_program();
-
-	return NULL;
+	assert_single_consumer("bloom filter");
 }
 
 static void *map_prepare_thread(void *arg)
@@ -421,17 +404,12 @@ static void measure(struct bench_res *res)
 	last_false_hits = total_false_hits;
 }
 
-static void *consumer(void *input)
-{
-	return NULL;
-}
-
 const struct bench bench_bloom_lookup = {
 	.name = "bloom-lookup",
 	.validate = validate,
 	.setup = bloom_lookup_setup,
-	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -441,8 +419,8 @@ const struct bench bench_bloom_update = {
 	.name = "bloom-update",
 	.validate = validate,
 	.setup = bloom_update_setup,
-	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -452,8 +430,8 @@ const struct bench bench_bloom_false_positive = {
 	.name = "bloom-false-positive",
 	.validate = validate,
 	.setup = false_positive_setup,
-	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = false_hits_report_progress,
 	.report_final = false_hits_report_final,
@@ -463,8 +441,8 @@ const struct bench bench_hashmap_without_bloom = {
 	.name = "hashmap-without-bloom",
 	.validate = validate,
 	.setup = hashmap_no_bloom_setup,
-	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -474,8 +452,8 @@ const struct bench bench_hashmap_with_bloom = {
 	.name = "hashmap-with-bloom",
 	.validate = validate,
 	.setup = hashmap_with_bloom_setup,
-	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
diff --git a/tools/testing/selftests/bpf/benchs/bench_count.c b/tools/testing/selftests/bpf/benchs/bench_count.c
index 078972ce208e..6b4b1cdec8a7 100644
--- a/tools/testing/selftests/bpf/benchs/bench_count.c
+++ b/tools/testing/selftests/bpf/benchs/bench_count.c
@@ -18,11 +18,6 @@ static void *count_global_producer(void *input)
 	return NULL;
 }
 
-static void *count_global_consumer(void *input)
-{
-	return NULL;
-}
-
 static void count_global_measure(struct bench_res *res)
 {
 	struct count_global_ctx *ctx = &count_global_ctx;
@@ -56,11 +51,6 @@ static void *count_local_producer(void *input)
 	return NULL;
 }
 
-static void *count_local_consumer(void *input)
-{
-	return NULL;
-}
-
 static void count_local_measure(struct bench_res *res)
 {
 	struct count_local_ctx *ctx = &count_local_ctx;
@@ -74,7 +64,7 @@ static void count_local_measure(struct bench_res *res)
 const struct bench bench_count_global = {
 	.name = "count-global",
 	.producer_thread = count_global_producer,
-	.consumer_thread = count_global_consumer,
+	.consumer_thread = noop_consumer,
 	.measure = count_global_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -84,7 +74,7 @@ const struct bench bench_count_local = {
 	.name = "count-local",
 	.setup = count_local_setup,
 	.producer_thread = count_local_producer,
-	.consumer_thread = count_local_consumer,
+	.consumer_thread = noop_consumer,
 	.measure = count_local_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/testing/selftests/bpf/benchs/bench_rename.c
index 3c203b6d6a6e..89c2de8dbb4b 100644
--- a/tools/testing/selftests/bpf/benchs/bench_rename.c
+++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
@@ -13,14 +13,8 @@ static struct ctx {
 
 static void validate(void)
 {
-	if (env.producer_cnt != 1) {
-		fprintf(stderr, "benchmark doesn't support multi-producer!\n");
-		exit(1);
-	}
-	if (env.consumer_cnt != 1) {
-		fprintf(stderr, "benchmark doesn't support multi-consumer!\n");
-		exit(1);
-	}
+	assert_single_producer("rename");
+	assert_single_consumer("rename");
 }
 
 static void *producer(void *input)
@@ -106,17 +100,12 @@ static void setup_fexit(void)
 	attach_bpf(ctx.skel->progs.prog5);
 }
 
-static void *consumer(void *input)
-{
-	return NULL;
-}
-
 const struct bench bench_rename_base = {
 	.name = "rename-base",
 	.validate = validate,
 	.setup = setup_base,
 	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -127,7 +116,7 @@ const struct bench bench_rename_kprobe = {
 	.validate = validate,
 	.setup = setup_kprobe,
 	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -138,7 +127,7 @@ const struct bench bench_rename_kretprobe = {
 	.validate = validate,
 	.setup = setup_kretprobe,
 	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -149,7 +138,7 @@ const struct bench bench_rename_rawtp = {
 	.validate = validate,
 	.setup = setup_rawtp,
 	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -160,7 +149,7 @@ const struct bench bench_rename_fentry = {
 	.validate = validate,
 	.setup = setup_fentry,
 	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -171,7 +160,7 @@ const struct bench bench_rename_fexit = {
 	.validate = validate,
 	.setup = setup_fexit,
 	.producer_thread = producer,
-	.consumer_thread = consumer,
+	.consumer_thread = noop_consumer,
 	.measure = measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
diff --git a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
index da8593b3494a..f3cfb643140d 100644
--- a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
+++ b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
@@ -90,15 +90,12 @@ static struct counter buf_hits;
 
 static inline void bufs_trigger_batch(void)
 {
-	(void)syscall(__NR_getpgid);
+	do_getpgid();
 }
 
 static void bufs_validate(void)
 {
-	if (env.consumer_cnt != 1) {
-		fprintf(stderr, "rb-libbpf benchmark doesn't support multi-consumer!\n");
-		exit(1);
-	}
+	assert_single_consumer("rb-libbpf");
 
 	if (args.back2back && env.producer_cnt > 1) {
 		fprintf(stderr, "back-to-back mode makes sense only for single-producer case!\n");
diff --git a/tools/testing/selftests/bpf/benchs/bench_trigger.c b/tools/testing/selftests/bpf/benchs/bench_trigger.c
index 7f957c55a3ca..b3d9dae5f0a1 100644
--- a/tools/testing/selftests/bpf/benchs/bench_trigger.c
+++ b/tools/testing/selftests/bpf/benchs/bench_trigger.c
@@ -13,16 +13,13 @@ static struct counter base_hits;
 
 static void trigger_validate(void)
 {
-	if (env.consumer_cnt != 1) {
-		fprintf(stderr, "benchmark doesn't support multi-consumer!\n");
-		exit(1);
-	}
+	assert_single_consumer("trigger");
 }
 
 static void *trigger_base_producer(void *input)
 {
 	while (true) {
-		(void)syscall(__NR_getpgid);
+		do_getpgid();
 		atomic_inc(&base_hits.value);
 	}
 	return NULL;
@@ -33,13 +30,6 @@ static void trigger_base_measure(struct bench_res *res)
 	res->hits = atomic_swap(&base_hits.value, 0);
 }
 
-static void *trigger_producer(void *input)
-{
-	while (true)
-		(void)syscall(__NR_getpgid);
-	return NULL;
-}
-
 static void trigger_measure(struct bench_res *res)
 {
 	res->hits = atomic_swap(&ctx.skel->bss->hits, 0);
@@ -103,11 +93,6 @@ static void trigger_fmodret_setup(void)
 	attach_bpf(ctx.skel->progs.bench_trigger_fmodret);
 }
 
-static void *trigger_consumer(void *input)
-{
-	return NULL;
-}
-
 /* make sure call is not inlined and not avoided by compiler, so __weak and
  * inline asm volatile in the body of the function
  *
@@ -207,7 +192,7 @@ const struct bench bench_trig_base = {
 	.name = "trig-base",
 	.validate = trigger_validate,
 	.producer_thread = trigger_base_producer,
-	.consumer_thread = trigger_consumer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_base_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -217,8 +202,8 @@ const struct bench bench_trig_tp = {
 	.name = "trig-tp",
 	.validate = trigger_validate,
 	.setup = trigger_tp_setup,
-	.producer_thread = trigger_producer,
-	.consumer_thread = trigger_consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -228,8 +213,8 @@ const struct bench bench_trig_rawtp = {
 	.name = "trig-rawtp",
 	.validate = trigger_validate,
 	.setup = trigger_rawtp_setup,
-	.producer_thread = trigger_producer,
-	.consumer_thread = trigger_consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -239,8 +224,8 @@ const struct bench bench_trig_kprobe = {
 	.name = "trig-kprobe",
 	.validate = trigger_validate,
 	.setup = trigger_kprobe_setup,
-	.producer_thread = trigger_producer,
-	.consumer_thread = trigger_consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -250,8 +235,8 @@ const struct bench bench_trig_fentry = {
 	.name = "trig-fentry",
 	.validate = trigger_validate,
 	.setup = trigger_fentry_setup,
-	.producer_thread = trigger_producer,
-	.consumer_thread = trigger_consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -261,8 +246,8 @@ const struct bench bench_trig_fentry_sleep = {
 	.name = "trig-fentry-sleep",
 	.validate = trigger_validate,
 	.setup = trigger_fentry_sleep_setup,
-	.producer_thread = trigger_producer,
-	.consumer_thread = trigger_consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -272,8 +257,8 @@ const struct bench bench_trig_fmodret = {
 	.name = "trig-fmodret",
 	.validate = trigger_validate,
 	.setup = trigger_fmodret_setup,
-	.producer_thread = trigger_producer,
-	.consumer_thread = trigger_consumer,
+	.producer_thread = getpgid_loop_producer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -283,7 +268,7 @@ const struct bench bench_trig_uprobe_base = {
 	.name = "trig-uprobe-base",
 	.setup = NULL, /* no uprobe/uretprobe is attached */
 	.producer_thread = uprobe_base_producer,
-	.consumer_thread = trigger_consumer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_base_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -293,7 +278,7 @@ const struct bench bench_trig_uprobe_with_nop = {
 	.name = "trig-uprobe-with-nop",
 	.setup = uprobe_setup_with_nop,
 	.producer_thread = uprobe_producer_with_nop,
-	.consumer_thread = trigger_consumer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -303,7 +288,7 @@ const struct bench bench_trig_uretprobe_with_nop = {
 	.name = "trig-uretprobe-with-nop",
 	.setup = uretprobe_setup_with_nop,
 	.producer_thread = uprobe_producer_with_nop,
-	.consumer_thread = trigger_consumer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -313,7 +298,7 @@ const struct bench bench_trig_uprobe_without_nop = {
 	.name = "trig-uprobe-without-nop",
 	.setup = uprobe_setup_without_nop,
 	.producer_thread = uprobe_producer_without_nop,
-	.consumer_thread = trigger_consumer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
@@ -323,7 +308,7 @@ const struct bench bench_trig_uretprobe_without_nop = {
 	.name = "trig-uretprobe-without-nop",
 	.setup = uretprobe_setup_without_nop,
 	.producer_thread = uprobe_producer_without_nop,
-	.consumer_thread = trigger_consumer,
+	.consumer_thread = noop_consumer,
 	.measure = trigger_measure,
 	.report_progress = hits_drops_report_progress,
 	.report_final = hits_drops_report_final,
-- 
2.29.2

