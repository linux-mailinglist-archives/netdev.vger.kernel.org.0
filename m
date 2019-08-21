Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19219880A
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfHUXoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:44:38 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:37477 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728737AbfHUXog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 19:44:36 -0400
Received: by mail-pg1-f202.google.com with SMTP id n9so2123178pgq.4
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 16:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DBJDJ4hOmJUTAPluYTIq4Z82yk1aO+v8AMfGvdqYuuI=;
        b=D/NkIeA8D/rOpsE71PJlhJ4h53IEUL4qkkhPIVESL0fwKoaPG4BTCIxBe0RhlUNvRd
         3X7zV8TXwdK/Duwfx4nrUGapUS5d/l02kMg4wY0ibclxxItvszUjzglsCRcTgvuospS5
         QS22RSVsD514WcI8hK/ZyneZv1ozMvO/nIzX6ht6u4l2bDwRq4dVUVeGytNkPD5QHpDL
         dme4gQY2kpOxPXcvPZrTXAawku9W+oHglMqFg4d/BaWZCDnzDdQBNNAjoTp7ix0TQ2DG
         EKms50tZYJuBdwENMceGnnTF11UFc7V/c+62JYzP9R+M86dmoq3SKYUgmHNJXWboL4S8
         VQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DBJDJ4hOmJUTAPluYTIq4Z82yk1aO+v8AMfGvdqYuuI=;
        b=KOBSkhKBCLxNtOI86M/g/ZjFylWia4snmId40DyBxkjC8SSB3lL5bOuBGn5y3A2B1x
         o+cfR8gDNWXrmIjaHOyDfbunXcFFmXrrKhDcj6XDP3O94jyQDWrkULzLIWpkF8/llFb+
         bnC1wQc6Ph4FBbLwk46zO1WsR+/rLWBOfiONV0QXa/5EYczYSAtRlzOZMvT+/68VBcFi
         3Ydbe1KKp0wvEbGyMnp1MEAVlLxOicyhhfU2CXg39hWEcl0uyq+DYSu3KqIk1hd7XXNj
         FP44tSqu9UgE4/hwJy/D99dI0x9JkOlg0DnybbR2409AIp97Le4Ju/+K/Ojq2oR/0b7L
         O/KQ==
X-Gm-Message-State: APjAAAVex1TrvlokZHzsXujf/Y3re11Y39yNVyAi9GQFI654BFmf2Nsl
        85Nfn+CafDQr9iOnbutBMZ5XMpVwIBnLJlU/qDIdfXvZw8Y3U00OOoAzHr0UCRC5NXqJf1d4owu
        WCUwKjIN2bLr8nRGqOOy02uZjgQLb78x6fg2grCXtNy4C8gPFWc3T3A==
X-Google-Smtp-Source: APXvYqyFz8Bea+X0NGRExHN6k8Kn9fISXyyFg0ZLjjqEABYpIprO2U0bsJSPhTBDCAVSrhIZ9CzkRF4=
X-Received: by 2002:a63:b555:: with SMTP id u21mr31678936pgo.222.1566431075088;
 Wed, 21 Aug 2019 16:44:35 -0700 (PDT)
Date:   Wed, 21 Aug 2019 16:44:25 -0700
In-Reply-To: <20190821234427.179886-1-sdf@google.com>
Message-Id: <20190821234427.179886-3-sdf@google.com>
Mime-Version: 1.0
References: <20190821234427.179886-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH bpf-next v3 2/4] selftests/bpf: test_progs: remove global
 fail/success counts
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a global per-test/per-environment state, there
is no longer need to have global fail/success counters (and there
is no need to save/get the diff before/after the test).

Introduce CHECK_FAIL macro (suggested by Andrii) and covert existing tests
to it. CHECK_FAIL uses new test__fail() to record the failure.

Cc: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/bpf_obj_id.c     |  3 +--
 .../bpf/prog_tests/bpf_verif_scale.c          |  9 +-------
 .../selftests/bpf/prog_tests/flow_dissector.c |  4 +---
 .../bpf/prog_tests/get_stack_raw_tp.c         |  3 ---
 .../selftests/bpf/prog_tests/global_data.c    | 20 +++++-------------
 .../selftests/bpf/prog_tests/l4lb_all.c       |  9 +++-----
 .../selftests/bpf/prog_tests/map_lock.c       | 17 ++++++---------
 .../selftests/bpf/prog_tests/pkt_access.c     |  4 +---
 .../selftests/bpf/prog_tests/pkt_md_access.c  |  4 +---
 .../bpf/prog_tests/queue_stack_map.c          |  8 ++-----
 .../bpf/prog_tests/reference_tracking.c       |  4 +---
 .../selftests/bpf/prog_tests/spinlock.c       |  6 ++----
 .../selftests/bpf/prog_tests/stacktrace_map.c | 17 +++++++--------
 .../bpf/prog_tests/stacktrace_map_raw_tp.c    |  9 +++-----
 .../bpf/prog_tests/task_fd_query_rawtp.c      |  3 ---
 .../bpf/prog_tests/task_fd_query_tp.c         |  5 -----
 .../selftests/bpf/prog_tests/tcp_estats.c     |  4 +---
 tools/testing/selftests/bpf/prog_tests/xdp.c  |  4 +---
 .../bpf/prog_tests/xdp_adjust_tail.c          |  4 +---
 .../selftests/bpf/prog_tests/xdp_noinline.c   |  8 +++----
 tools/testing/selftests/bpf/test_progs.c      | 21 ++++++++-----------
 tools/testing/selftests/bpf/test_progs.h      | 17 +++++++++------
 22 files changed, 60 insertions(+), 123 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
index fb5840a62548..5dd6ca1255d0 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
@@ -48,8 +48,7 @@ void test_bpf_obj_id(void)
 		/* test_obj_id.o is a dumb prog. It should never fail
 		 * to load.
 		 */
-		if (err)
-			error_cnt++;
+		CHECK_FAIL(err);
 		assert(!err);
 
 		/* Insert a magic value to the map */
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index 1a1eae356f81..1c01ee2600a9 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -28,8 +28,6 @@ static int check_load(const char *file, enum bpf_prog_type type)
 	attr.prog_flags = BPF_F_TEST_RND_HI32;
 	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
 	bpf_object__close(obj);
-	if (err)
-		error_cnt++;
 	return err;
 }
 
@@ -105,12 +103,7 @@ void test_bpf_verif_scale(void)
 			continue;
 
 		err = check_load(test->file, test->attach_type);
-		if (test->fails) { /* expected to fail */
-			if (err)
-				error_cnt--;
-			else
-				error_cnt++;
-		}
+		CHECK_FAIL(err && !test->fails);
 	}
 
 	if (env.verifier_stats)
diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index 6892b88ae065..aee0cda7870b 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -452,10 +452,8 @@ void test_flow_dissector(void)
 
 	err = bpf_flow_load(&obj, "./bpf_flow.o", "flow_dissector",
 			    "jmp_table", "last_dissection", &prog_fd, &keys_fd);
-	if (err) {
-		error_cnt++;
+	if (CHECK_FAIL(err))
 		return;
-	}
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		struct bpf_flow_keys flow_keys;
diff --git a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
index 3d59b3c841fe..eba9a970703b 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
@@ -135,10 +135,7 @@ void test_get_stack_raw_tp(void)
 		exp_cnt -= err;
 	}
 
-	goto close_prog_noerr;
 close_prog:
-	error_cnt++;
-close_prog_noerr:
 	if (!IS_ERR_OR_NULL(link))
 		bpf_link__destroy(link);
 	if (!IS_ERR_OR_NULL(pb))
diff --git a/tools/testing/selftests/bpf/prog_tests/global_data.c b/tools/testing/selftests/bpf/prog_tests/global_data.c
index d011079fb0bf..c680926fce73 100644
--- a/tools/testing/selftests/bpf/prog_tests/global_data.c
+++ b/tools/testing/selftests/bpf/prog_tests/global_data.c
@@ -7,10 +7,8 @@ static void test_global_data_number(struct bpf_object *obj, __u32 duration)
 	uint64_t num;
 
 	map_fd = bpf_find_map(__func__, obj, "result_number");
-	if (map_fd < 0) {
-		error_cnt++;
+	if (CHECK_FAIL(map_fd < 0))
 		return;
-	}
 
 	struct {
 		char *name;
@@ -44,10 +42,8 @@ static void test_global_data_string(struct bpf_object *obj, __u32 duration)
 	char str[32];
 
 	map_fd = bpf_find_map(__func__, obj, "result_string");
-	if (map_fd < 0) {
-		error_cnt++;
+	if (CHECK_FAIL(map_fd < 0))
 		return;
-	}
 
 	struct {
 		char *name;
@@ -81,10 +77,8 @@ static void test_global_data_struct(struct bpf_object *obj, __u32 duration)
 	struct foo val;
 
 	map_fd = bpf_find_map(__func__, obj, "result_struct");
-	if (map_fd < 0) {
-		error_cnt++;
+	if (CHECK_FAIL(map_fd < 0))
 		return;
-	}
 
 	struct {
 		char *name;
@@ -112,16 +106,12 @@ static void test_global_data_rdonly(struct bpf_object *obj, __u32 duration)
 	__u8 *buff;
 
 	map = bpf_object__find_map_by_name(obj, "test_glo.rodata");
-	if (!map || !bpf_map__is_internal(map)) {
-		error_cnt++;
+	if (CHECK_FAIL(!map || !bpf_map__is_internal(map)))
 		return;
-	}
 
 	map_fd = bpf_map__fd(map);
-	if (map_fd < 0) {
-		error_cnt++;
+	if (CHECK_FAIL(map_fd < 0))
 		return;
-	}
 
 	buff = malloc(bpf_map__def(map)->value_size);
 	if (buff)
diff --git a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
index 20ddca830e68..eaf64595be88 100644
--- a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
+++ b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
@@ -30,10 +30,8 @@ static void test_l4lb(const char *file)
 	u32 *magic = (u32 *)buf;
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
-	if (err) {
-		error_cnt++;
+	if (CHECK_FAIL(err))
 		return;
-	}
 
 	map_fd = bpf_find_map(__func__, obj, "vip_map");
 	if (map_fd < 0)
@@ -72,10 +70,9 @@ static void test_l4lb(const char *file)
 		bytes += stats[i].bytes;
 		pkts += stats[i].pkts;
 	}
-	if (bytes != MAGIC_BYTES * NUM_ITER * 2 || pkts != NUM_ITER * 2) {
-		error_cnt++;
+	if (CHECK_FAIL(bytes != MAGIC_BYTES * NUM_ITER * 2 ||
+		       pkts != NUM_ITER * 2))
 		printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
-	}
 out:
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
index ee99368c595c..15993b6a194b 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
@@ -8,14 +8,12 @@ static void *parallel_map_access(void *arg)
 
 	for (i = 0; i < 10000; i++) {
 		err = bpf_map_lookup_elem_flags(map_fd, &key, vars, BPF_F_LOCK);
-		if (err) {
+		if (CHECK_FAIL(err)) {
 			printf("lookup failed\n");
-			error_cnt++;
 			goto out;
 		}
-		if (vars[0] != 0) {
+		if (CHECK_FAIL(vars[0] != 0)) {
 			printf("lookup #%d var[0]=%d\n", i, vars[0]);
-			error_cnt++;
 			goto out;
 		}
 		rnd = vars[1];
@@ -24,7 +22,7 @@ static void *parallel_map_access(void *arg)
 				continue;
 			printf("lookup #%d var[1]=%d var[%d]=%d\n",
 			       i, rnd, j, vars[j]);
-			error_cnt++;
+			CHECK_FAIL(vars[j] != rnd);
 			goto out;
 		}
 	}
@@ -42,15 +40,15 @@ void test_map_lock(void)
 	void *ret;
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);
-	if (err) {
+	if (CHECK_FAIL(err)) {
 		printf("test_map_lock:bpf_prog_load errno %d\n", errno);
 		goto close_prog;
 	}
 	map_fd[0] = bpf_find_map(__func__, obj, "hash_map");
-	if (map_fd[0] < 0)
+	if (CHECK_FAIL(map_fd[0] < 0))
 		goto close_prog;
 	map_fd[1] = bpf_find_map(__func__, obj, "array_map");
-	if (map_fd[1] < 0)
+	if (CHECK_FAIL(map_fd[1] < 0))
 		goto close_prog;
 
 	bpf_map_update_elem(map_fd[0], &key, vars, BPF_F_LOCK);
@@ -67,9 +65,6 @@ void test_map_lock(void)
 	for (i = 4; i < 6; i++)
 		assert(pthread_join(thread_id[i], &ret) == 0 &&
 		       ret == (void *)&map_fd[i - 4]);
-	goto close_prog_noerr;
 close_prog:
-	error_cnt++;
-close_prog_noerr:
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/pkt_access.c b/tools/testing/selftests/bpf/prog_tests/pkt_access.c
index 4ecfd721a044..a2537dfa899c 100644
--- a/tools/testing/selftests/bpf/prog_tests/pkt_access.c
+++ b/tools/testing/selftests/bpf/prog_tests/pkt_access.c
@@ -9,10 +9,8 @@ void test_pkt_access(void)
 	int err, prog_fd;
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
-	if (err) {
-		error_cnt++;
+	if (CHECK_FAIL(err))
 		return;
-	}
 
 	err = bpf_prog_test_run(prog_fd, 100000, &pkt_v4, sizeof(pkt_v4),
 				NULL, NULL, &retval, &duration);
diff --git a/tools/testing/selftests/bpf/prog_tests/pkt_md_access.c b/tools/testing/selftests/bpf/prog_tests/pkt_md_access.c
index ac0d43435806..5f7aea605019 100644
--- a/tools/testing/selftests/bpf/prog_tests/pkt_md_access.c
+++ b/tools/testing/selftests/bpf/prog_tests/pkt_md_access.c
@@ -9,10 +9,8 @@ void test_pkt_md_access(void)
 	int err, prog_fd;
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
-	if (err) {
-		error_cnt++;
+	if (CHECK_FAIL(err))
 		return;
-	}
 
 	err = bpf_prog_test_run(prog_fd, 10, &pkt_v4, sizeof(pkt_v4),
 				NULL, NULL, &retval, &duration);
diff --git a/tools/testing/selftests/bpf/prog_tests/queue_stack_map.c b/tools/testing/selftests/bpf/prog_tests/queue_stack_map.c
index e60cd5ff1f55..faccc66f4e39 100644
--- a/tools/testing/selftests/bpf/prog_tests/queue_stack_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/queue_stack_map.c
@@ -27,10 +27,8 @@ static void test_queue_stack_map_by_type(int type)
 		return;
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
-	if (err) {
-		error_cnt++;
+	if (CHECK_FAIL(err))
 		return;
-	}
 
 	map_in_fd = bpf_find_map(__func__, obj, "map_in");
 	if (map_in_fd < 0)
@@ -43,10 +41,8 @@ static void test_queue_stack_map_by_type(int type)
 	/* Push 32 elements to the input map */
 	for (i = 0; i < MAP_SIZE; i++) {
 		err = bpf_map_update_elem(map_in_fd, NULL, &vals[i], 0);
-		if (err) {
-			error_cnt++;
+		if (CHECK_FAIL(err))
 			goto out;
-		}
 	}
 
 	/* The eBPF program pushes iph.saddr in the output map,
diff --git a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
index 4a4f428d1a78..5c78e2b5a917 100644
--- a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
+++ b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
@@ -10,10 +10,8 @@ void test_reference_tracking(void)
 	int err = 0;
 
 	obj = bpf_object__open(file);
-	if (IS_ERR(obj)) {
-		error_cnt++;
+	if (CHECK_FAIL(IS_ERR(obj)))
 		return;
-	}
 
 	bpf_object__for_each_program(prog, obj) {
 		const char *title;
diff --git a/tools/testing/selftests/bpf/prog_tests/spinlock.c b/tools/testing/selftests/bpf/prog_tests/spinlock.c
index 114ebe6a438e..d71fb3dda376 100644
--- a/tools/testing/selftests/bpf/prog_tests/spinlock.c
+++ b/tools/testing/selftests/bpf/prog_tests/spinlock.c
@@ -11,7 +11,7 @@ void test_spinlock(void)
 	void *ret;
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);
-	if (err) {
+	if (CHECK_FAIL(err)) {
 		printf("test_spin_lock:bpf_prog_load errno %d\n", errno);
 		goto close_prog;
 	}
@@ -21,9 +21,7 @@ void test_spinlock(void)
 	for (i = 0; i < 4; i++)
 		assert(pthread_join(thread_id[i], &ret) == 0 &&
 		       ret == (void *)&prog_fd);
-	goto close_prog_noerr;
+
 close_prog:
-	error_cnt++;
-close_prog_noerr:
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
index fc539335c5b3..37269d23df93 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
@@ -26,19 +26,19 @@ void test_stacktrace_map(void)
 
 	/* find map fds */
 	control_map_fd = bpf_find_map(__func__, obj, "control_map");
-	if (control_map_fd < 0)
+	if (CHECK_FAIL(control_map_fd < 0))
 		goto disable_pmu;
 
 	stackid_hmap_fd = bpf_find_map(__func__, obj, "stackid_hmap");
-	if (stackid_hmap_fd < 0)
+	if (CHECK_FAIL(stackid_hmap_fd < 0))
 		goto disable_pmu;
 
 	stackmap_fd = bpf_find_map(__func__, obj, "stackmap");
-	if (stackmap_fd < 0)
+	if (CHECK_FAIL(stackmap_fd < 0))
 		goto disable_pmu;
 
 	stack_amap_fd = bpf_find_map(__func__, obj, "stack_amap");
-	if (stack_amap_fd < 0)
+	if (CHECK_FAIL(stack_amap_fd < 0))
 		goto disable_pmu;
 
 	/* give some time for bpf program run */
@@ -55,23 +55,20 @@ void test_stacktrace_map(void)
 	err = compare_map_keys(stackid_hmap_fd, stackmap_fd);
 	if (CHECK(err, "compare_map_keys stackid_hmap vs. stackmap",
 		  "err %d errno %d\n", err, errno))
-		goto disable_pmu_noerr;
+		goto disable_pmu;
 
 	err = compare_map_keys(stackmap_fd, stackid_hmap_fd);
 	if (CHECK(err, "compare_map_keys stackmap vs. stackid_hmap",
 		  "err %d errno %d\n", err, errno))
-		goto disable_pmu_noerr;
+		goto disable_pmu;
 
 	stack_trace_len = PERF_MAX_STACK_DEPTH * sizeof(__u64);
 	err = compare_stack_ips(stackmap_fd, stack_amap_fd, stack_trace_len);
 	if (CHECK(err, "compare_stack_ips stackmap vs. stack_amap",
 		  "err %d errno %d\n", err, errno))
-		goto disable_pmu_noerr;
+		goto disable_pmu;
 
-	goto disable_pmu_noerr;
 disable_pmu:
-	error_cnt++;
-disable_pmu_noerr:
 	bpf_link__destroy(link);
 close_prog:
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
index fbfa8e76cf63..404a5498e1a3 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
@@ -26,15 +26,15 @@ void test_stacktrace_map_raw_tp(void)
 
 	/* find map fds */
 	control_map_fd = bpf_find_map(__func__, obj, "control_map");
-	if (control_map_fd < 0)
+	if (CHECK_FAIL(control_map_fd < 0))
 		goto close_prog;
 
 	stackid_hmap_fd = bpf_find_map(__func__, obj, "stackid_hmap");
-	if (stackid_hmap_fd < 0)
+	if (CHECK_FAIL(stackid_hmap_fd < 0))
 		goto close_prog;
 
 	stackmap_fd = bpf_find_map(__func__, obj, "stackmap");
-	if (stackmap_fd < 0)
+	if (CHECK_FAIL(stackmap_fd < 0))
 		goto close_prog;
 
 	/* give some time for bpf program run */
@@ -58,10 +58,7 @@ void test_stacktrace_map_raw_tp(void)
 		  "err %d errno %d\n", err, errno))
 		goto close_prog;
 
-	goto close_prog_noerr;
 close_prog:
-	error_cnt++;
-close_prog_noerr:
 	if (!IS_ERR_OR_NULL(link))
 		bpf_link__destroy(link);
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c b/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c
index 958a3d88de99..1bdc1d86a50c 100644
--- a/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c
+++ b/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c
@@ -70,9 +70,6 @@ void test_task_fd_query_rawtp(void)
 	if (CHECK(!err, "check_results", "fd_type %d len %u\n", fd_type, len))
 		goto close_prog;
 
-	goto close_prog_noerr;
 close_prog:
-	error_cnt++;
-close_prog_noerr:
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c b/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c
index f9b70e81682b..3f131b8fe328 100644
--- a/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c
@@ -62,14 +62,9 @@ static void test_task_fd_query_tp_core(const char *probe_name,
 		  fd_type, buf))
 		goto close_pmu;
 
-	close(pmu_fd);
-	goto close_prog_noerr;
-
 close_pmu:
 	close(pmu_fd);
 close_prog:
-	error_cnt++;
-close_prog_noerr:
 	bpf_object__close(obj);
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_estats.c b/tools/testing/selftests/bpf/prog_tests/tcp_estats.c
index bb8759d69099..594307dffd13 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_estats.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_estats.c
@@ -10,10 +10,8 @@ void test_tcp_estats(void)
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
 	CHECK(err, "", "err %d errno %d\n", err, errno);
-	if (err) {
-		error_cnt++;
+	if (err)
 		return;
-	}
 
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp.c b/tools/testing/selftests/bpf/prog_tests/xdp.c
index a74167289545..dcb5ecac778e 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp.c
@@ -16,10 +16,8 @@ void test_xdp(void)
 	int err, prog_fd, map_fd;
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
-	if (err) {
-		error_cnt++;
+	if (CHECK_FAIL(err))
 		return;
-	}
 
 	map_fd = bpf_find_map(__func__, obj, "vip2tnl");
 	if (map_fd < 0)
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 922aa0a19764..3744196d7cba 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -10,10 +10,8 @@ void test_xdp_adjust_tail(void)
 	int err, prog_fd;
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
-	if (err) {
-		error_cnt++;
+	if (CHECK_FAIL(err))
 		return;
-	}
 
 	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				buf, &size, &retval, &duration);
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
index 15f7c272edb0..c9404e6b226e 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
@@ -31,10 +31,8 @@ void test_xdp_noinline(void)
 	u32 *magic = (u32 *)buf;
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
-	if (err) {
-		error_cnt++;
+	if (CHECK_FAIL(err))
 		return;
-	}
 
 	map_fd = bpf_find_map(__func__, obj, "vip_map");
 	if (map_fd < 0)
@@ -73,8 +71,8 @@ void test_xdp_noinline(void)
 		bytes += stats[i].bytes;
 		pkts += stats[i].pkts;
 	}
-	if (bytes != MAGIC_BYTES * NUM_ITER * 2 || pkts != NUM_ITER * 2) {
-		error_cnt++;
+	if (CHECK_FAIL(bytes != MAGIC_BYTES * NUM_ITER * 2 ||
+		       pkts != NUM_ITER * 2)) {
 		printf("test_xdp_noinline:FAIL:stats %lld %lld\n",
 		       bytes, pkts);
 	}
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index e545dfb55872..e5892cb60eca 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -8,14 +8,12 @@
 
 /* defined in test_progs.h */
 struct test_env env;
-int error_cnt, pass_cnt;
 
 struct prog_test_def {
 	const char *test_name;
 	int test_num;
 	void (*run_test)(void);
 	bool force_log;
-	int pass_cnt;
 	int error_cnt;
 	int skip_cnt;
 	bool tested;
@@ -24,7 +22,6 @@ struct prog_test_def {
 	int subtest_num;
 
 	/* store counts before subtest started */
-	int old_pass_cnt;
 	int old_error_cnt;
 };
 
@@ -68,7 +65,7 @@ static void skip_account(void)
 void test__end_subtest()
 {
 	struct prog_test_def *test = env.test;
-	int sub_error_cnt = error_cnt - test->old_error_cnt;
+	int sub_error_cnt = test->error_cnt - test->old_error_cnt;
 
 	if (sub_error_cnt)
 		env.fail_cnt++;
@@ -105,8 +102,7 @@ bool test__start_subtest(const char *name)
 		return false;
 
 	test->subtest_name = name;
-	env.test->old_pass_cnt = pass_cnt;
-	env.test->old_error_cnt = error_cnt;
+	env.test->old_error_cnt = env.test->error_cnt;
 
 	return true;
 }
@@ -120,6 +116,11 @@ void test__skip(void)
 	env.test->skip_cnt++;
 }
 
+void test__fail(void)
+{
+	env.test->error_cnt++;
+}
+
 struct ipv4_packet pkt_v4 = {
 	.eth.h_proto = __bpf_constant_htons(ETH_P_IP),
 	.iph.ihl = 5,
@@ -144,7 +145,7 @@ int bpf_find_map(const char *test, struct bpf_object *obj, const char *name)
 	map = bpf_object__find_map_by_name(obj, name);
 	if (!map) {
 		printf("%s:FAIL:map '%s' not found\n", test, name);
-		error_cnt++;
+		test__fail();
 		return -1;
 	}
 	return bpf_map__fd(map);
@@ -503,8 +504,6 @@ int main(int argc, char **argv)
 	stdio_hijack();
 	for (i = 0; i < prog_test_cnt; i++) {
 		struct prog_test_def *test = &prog_test_defs[i];
-		int old_pass_cnt = pass_cnt;
-		int old_error_cnt = error_cnt;
 
 		env.test = test;
 		test->test_num = i + 1;
@@ -519,8 +518,6 @@ int main(int argc, char **argv)
 			test__end_subtest();
 
 		test->tested = true;
-		test->pass_cnt = pass_cnt - old_pass_cnt;
-		test->error_cnt = error_cnt - old_error_cnt;
 		if (test->error_cnt)
 			env.fail_cnt++;
 		else
@@ -540,5 +537,5 @@ int main(int argc, char **argv)
 	free(env.test_selector.num_set);
 	free(env.subtest_selector.num_set);
 
-	return error_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
+	return env.fail_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
 }
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 9defd35cb6c0..33da849cb765 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -38,8 +38,6 @@ typedef __u16 __sum16;
 #include "trace_helpers.h"
 #include "flow_dissector_load.h"
 
-struct prog_test_def;
-
 struct test_selector {
 	const char *name;
 	bool *num_set;
@@ -67,13 +65,12 @@ struct test_env {
 	int skip_cnt; /* skipped tests */
 };
 
-extern int error_cnt;
-extern int pass_cnt;
 extern struct test_env env;
 
 extern void test__force_log();
 extern bool test__start_subtest(const char *name);
 extern void test__skip(void);
+extern void test__fail(void);
 
 #define MAGIC_BYTES 123
 
@@ -96,17 +93,25 @@ extern struct ipv6_packet pkt_v6;
 #define _CHECK(condition, tag, duration, format...) ({			\
 	int __ret = !!(condition);					\
 	if (__ret) {							\
-		error_cnt++;						\
+		test__fail();						\
 		printf("%s:FAIL:%s ", __func__, tag);			\
 		printf(format);						\
 	} else {							\
-		pass_cnt++;						\
 		printf("%s:PASS:%s %d nsec\n",				\
 		       __func__, tag, duration);			\
 	}								\
 	__ret;								\
 })
 
+#define CHECK_FAIL(condition) ({					\
+	int __ret = !!(condition);					\
+	if (__ret) {							\
+		test__fail();						\
+		printf("%s:FAIL:%d ", __func__, __LINE__);		\
+	}								\
+	__ret;								\
+})
+
 #define CHECK(condition, tag, format...) \
 	_CHECK(condition, tag, duration, format)
 #define CHECK_ATTR(condition, tag, format...) \
-- 
2.23.0.187.g17f5b7556c-goog

