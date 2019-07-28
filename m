Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A8877D87
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 05:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfG1D0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 23:26:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46130 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726208AbfG1DZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 23:25:58 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6S3Nv58014748
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 20:25:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Zi86r6bZqy1xzwiwO3krDZZ1PLSrcCopHuE0DVDaQeU=;
 b=NQousGkN6aK06dDh22ZyhtIcqWInkBQ58spju8ueR6m2GAzBu2ebppLl/IDxn+6nXB//
 h6+8idxdE+p5lHlWCkFCG/5N2ictEWTJt80evVOXJnJLNaJEwtmxTCZF9U0cBmzRWFdP
 WEgKyeDEZU5kzJBZEw3iS3OgY8LSANt5dis= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0m4ej2b4-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 20:25:56 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 27 Jul 2019 20:25:55 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C37208615B1; Sat, 27 Jul 2019 20:25:48 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@fomichev.me>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 6/9] selftests/bpf: abstract away test log output
Date:   Sat, 27 Jul 2019 20:25:28 -0700
Message-ID: <20190728032531.2358749-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190728032531.2358749-1-andriin@fb.com>
References: <20190728032531.2358749-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-28_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=25 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907280042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes how test output is printed out. By default, if test
had no errors, the only output will be a single line with test number,
name, and verdict at the end, e.g.:

  #31 xdp:OK

If test had any errors, all log output captured during test execution
will be output after test completes.

It's possible to force output of log with `-v` (`--verbose`) option, in
which case output won't be buffered and will be output immediately.

To support this, individual tests are required to use helper methods for
logging: `test__printf()` and `test__vprintf()`.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_obj_id.c     |   6 +-
 .../bpf/prog_tests/bpf_verif_scale.c          |  31 ++--
 .../bpf/prog_tests/get_stack_raw_tp.c         |   4 +-
 .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +-
 .../selftests/bpf/prog_tests/map_lock.c       |  10 +-
 .../selftests/bpf/prog_tests/send_signal.c    |   8 +-
 .../selftests/bpf/prog_tests/spinlock.c       |   2 +-
 .../bpf/prog_tests/stacktrace_build_id.c      |   4 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   4 +-
 .../selftests/bpf/prog_tests/xdp_noinline.c   |   3 +-
 tools/testing/selftests/bpf/test_progs.c      | 145 ++++++++++++++----
 tools/testing/selftests/bpf/test_progs.h      |  37 ++++-
 12 files changed, 183 insertions(+), 73 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
index cb827383db4d..fb5840a62548 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_obj_id.c
@@ -106,8 +106,8 @@ void test_bpf_obj_id(void)
 		if (CHECK(err ||
 			  prog_infos[i].type != BPF_PROG_TYPE_SOCKET_FILTER ||
 			  info_len != sizeof(struct bpf_prog_info) ||
-			  (jit_enabled && !prog_infos[i].jited_prog_len) ||
-			  (jit_enabled &&
+			  (env.jit_enabled && !prog_infos[i].jited_prog_len) ||
+			  (env.jit_enabled &&
 			   !memcmp(jited_insns, zeros, sizeof(zeros))) ||
 			  !prog_infos[i].xlated_prog_len ||
 			  !memcmp(xlated_insns, zeros, sizeof(zeros)) ||
@@ -121,7 +121,7 @@ void test_bpf_obj_id(void)
 			  err, errno, i,
 			  prog_infos[i].type, BPF_PROG_TYPE_SOCKET_FILTER,
 			  info_len, sizeof(struct bpf_prog_info),
-			  jit_enabled,
+			  env.jit_enabled,
 			  prog_infos[i].jited_prog_len,
 			  prog_infos[i].xlated_prog_len,
 			  !!memcmp(jited_insns, zeros, sizeof(zeros)),
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index ceddb8cc86f4..b59017279e0b 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -4,12 +4,15 @@
 static int libbpf_debug_print(enum libbpf_print_level level,
 			      const char *format, va_list args)
 {
-	if (level != LIBBPF_DEBUG)
-		return vfprintf(stderr, format, args);
+	if (level != LIBBPF_DEBUG) {
+		test__vprintf(format, args);
+		return 0;
+	}
 
 	if (!strstr(format, "verifier log"))
 		return 0;
-	return vfprintf(stderr, "%s", args);
+	test__vprintf("%s", args);
+	return 0;
 }
 
 static int check_load(const char *file, enum bpf_prog_type type)
@@ -73,32 +76,38 @@ void test_bpf_verif_scale(void)
 	libbpf_print_fn_t old_print_fn = NULL;
 	int err, i;
 
-	if (verifier_stats)
+	if (env.verifier_stats) {
+		test__force_log();
 		old_print_fn = libbpf_set_print(libbpf_debug_print);
+	}
 
 	err = check_load("./loop3.o", BPF_PROG_TYPE_RAW_TRACEPOINT);
-	printf("test_scale:loop3:%s\n", err ? (error_cnt--, "OK") : "FAIL");
+	test__printf("test_scale:loop3:%s\n",
+		     err ? (error_cnt--, "OK") : "FAIL");
 
 	for (i = 0; i < ARRAY_SIZE(sched_cls); i++) {
 		err = check_load(sched_cls[i], BPF_PROG_TYPE_SCHED_CLS);
-		printf("test_scale:%s:%s\n", sched_cls[i], err ? "FAIL" : "OK");
+		test__printf("test_scale:%s:%s\n", sched_cls[i],
+			     err ? "FAIL" : "OK");
 	}
 
 	for (i = 0; i < ARRAY_SIZE(raw_tp); i++) {
 		err = check_load(raw_tp[i], BPF_PROG_TYPE_RAW_TRACEPOINT);
-		printf("test_scale:%s:%s\n", raw_tp[i], err ? "FAIL" : "OK");
+		test__printf("test_scale:%s:%s\n", raw_tp[i],
+			     err ? "FAIL" : "OK");
 	}
 
 	for (i = 0; i < ARRAY_SIZE(cg_sysctl); i++) {
 		err = check_load(cg_sysctl[i], BPF_PROG_TYPE_CGROUP_SYSCTL);
-		printf("test_scale:%s:%s\n", cg_sysctl[i], err ? "FAIL" : "OK");
+		test__printf("test_scale:%s:%s\n", cg_sysctl[i],
+			     err ? "FAIL" : "OK");
 	}
 	err = check_load("./test_xdp_loop.o", BPF_PROG_TYPE_XDP);
-	printf("test_scale:test_xdp_loop:%s\n", err ? "FAIL" : "OK");
+	test__printf("test_scale:test_xdp_loop:%s\n", err ? "FAIL" : "OK");
 
 	err = check_load("./test_seg6_loop.o", BPF_PROG_TYPE_LWT_SEG6LOCAL);
-	printf("test_scale:test_seg6_loop:%s\n", err ? "FAIL" : "OK");
+	test__printf("test_scale:test_seg6_loop:%s\n", err ? "FAIL" : "OK");
 
-	if (verifier_stats)
+	if (env.verifier_stats)
 		libbpf_set_print(old_print_fn);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
index 9d73a8f932ac..3d59b3c841fe 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
@@ -41,7 +41,7 @@ static void get_stack_print_output(void *ctx, int cpu, void *data, __u32 size)
 		 * just assume it is good if the stack is not empty.
 		 * This could be improved in the future.
 		 */
-		if (jit_enabled) {
+		if (env.jit_enabled) {
 			found = num_stack > 0;
 		} else {
 			for (i = 0; i < num_stack; i++) {
@@ -58,7 +58,7 @@ static void get_stack_print_output(void *ctx, int cpu, void *data, __u32 size)
 		}
 	} else {
 		num_stack = e->kern_stack_size / sizeof(__u64);
-		if (jit_enabled) {
+		if (env.jit_enabled) {
 			good_kern_stack = num_stack > 0;
 		} else {
 			for (i = 0; i < num_stack; i++) {
diff --git a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
index 20ddca830e68..5ce572c03a5f 100644
--- a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
+++ b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
@@ -74,7 +74,7 @@ static void test_l4lb(const char *file)
 	}
 	if (bytes != MAGIC_BYTES * NUM_ITER * 2 || pkts != NUM_ITER * 2) {
 		error_cnt++;
-		printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
+		test__printf("test_l4lb:FAIL:stats %lld %lld\n", bytes, pkts);
 	}
 out:
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/prog_tests/map_lock.c b/tools/testing/selftests/bpf/prog_tests/map_lock.c
index ee99368c595c..2e78217ed3fd 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_lock.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_lock.c
@@ -9,12 +9,12 @@ static void *parallel_map_access(void *arg)
 	for (i = 0; i < 10000; i++) {
 		err = bpf_map_lookup_elem_flags(map_fd, &key, vars, BPF_F_LOCK);
 		if (err) {
-			printf("lookup failed\n");
+			test__printf("lookup failed\n");
 			error_cnt++;
 			goto out;
 		}
 		if (vars[0] != 0) {
-			printf("lookup #%d var[0]=%d\n", i, vars[0]);
+			test__printf("lookup #%d var[0]=%d\n", i, vars[0]);
 			error_cnt++;
 			goto out;
 		}
@@ -22,8 +22,8 @@ static void *parallel_map_access(void *arg)
 		for (j = 2; j < 17; j++) {
 			if (vars[j] == rnd)
 				continue;
-			printf("lookup #%d var[1]=%d var[%d]=%d\n",
-			       i, rnd, j, vars[j]);
+			test__printf("lookup #%d var[1]=%d var[%d]=%d\n",
+				     i, rnd, j, vars[j]);
 			error_cnt++;
 			goto out;
 		}
@@ -43,7 +43,7 @@ void test_map_lock(void)
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);
 	if (err) {
-		printf("test_map_lock:bpf_prog_load errno %d\n", errno);
+		test__printf("test_map_lock:bpf_prog_load errno %d\n", errno);
 		goto close_prog;
 	}
 	map_fd[0] = bpf_find_map(__func__, obj, "hash_map");
diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index 54218ee3c004..d950f4558897 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -202,8 +202,8 @@ static int test_send_signal_nmi(void)
 			 -1 /* cpu */, -1 /* group_fd */, 0 /* flags */);
 	if (pmu_fd == -1) {
 		if (errno == ENOENT) {
-			printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
-				__func__);
+			test__printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n",
+				     __func__);
 			return 0;
 		}
 		/* Let the test fail with a more informative message */
@@ -222,8 +222,4 @@ void test_send_signal(void)
 	ret |= test_send_signal_tracepoint();
 	ret |= test_send_signal_perf();
 	ret |= test_send_signal_nmi();
-	if (!ret)
-		printf("test_send_signal:OK\n");
-	else
-		printf("test_send_signal:FAIL\n");
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/spinlock.c b/tools/testing/selftests/bpf/prog_tests/spinlock.c
index 114ebe6a438e..deb2db5b85b0 100644
--- a/tools/testing/selftests/bpf/prog_tests/spinlock.c
+++ b/tools/testing/selftests/bpf/prog_tests/spinlock.c
@@ -12,7 +12,7 @@ void test_spinlock(void)
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);
 	if (err) {
-		printf("test_spin_lock:bpf_prog_load errno %d\n", errno);
+		test__printf("test_spin_lock:bpf_prog_load errno %d\n", errno);
 		goto close_prog;
 	}
 	for (i = 0; i < 4; i++)
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
index ac44fda84833..356d2c017a9c 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
@@ -109,8 +109,8 @@ void test_stacktrace_build_id(void)
 	if (build_id_matches < 1 && retry--) {
 		bpf_link__destroy(link);
 		bpf_object__close(obj);
-		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
-		       __func__);
+		test__printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
+			     __func__);
 		goto retry;
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 9557b7dfb782..f44f2c159714 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -140,8 +140,8 @@ void test_stacktrace_build_id_nmi(void)
 	if (build_id_matches < 1 && retry--) {
 		bpf_link__destroy(link);
 		bpf_object__close(obj);
-		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
-		       __func__);
+		test__printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
+			     __func__);
 		goto retry;
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
index 09e6b46f5515..b5404494b8aa 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
@@ -75,7 +75,8 @@ void test_xdp_noinline(void)
 	}
 	if (bytes != MAGIC_BYTES * NUM_ITER * 2 || pkts != NUM_ITER * 2) {
 		error_cnt++;
-		printf("test_xdp_noinline:FAIL:stats %lld %lld\n", bytes, pkts);
+		test__printf("test_xdp_noinline:FAIL:stats %lld %lld\n",
+			     bytes, pkts);
 	}
 out:
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 94b6951b90b3..1b7470d3da22 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -6,9 +6,85 @@
 #include <argp.h>
 #include <string.h>
 
+/* defined in test_progs.h */
+struct test_env env = {
+	.test_num_selector = -1,
+};
 int error_cnt, pass_cnt;
-bool jit_enabled;
-bool verifier_stats = false;
+
+struct prog_test_def {
+	const char *test_name;
+	int test_num;
+	void (*run_test)(void);
+	bool force_log;
+	int pass_cnt;
+	int error_cnt;
+	bool tested;
+};
+
+void test__force_log() {
+	env.test->force_log = true;
+}
+
+void test__vprintf(const char *fmt, va_list args)
+{
+	size_t rem_sz;
+	int ret = 0;
+
+	if (env.verbose || (env.test && env.test->force_log)) {
+		vfprintf(stderr, fmt, args);
+		return;
+	}
+
+try_again:
+	rem_sz = env.log_cap - env.log_cnt;
+	if (rem_sz) {
+		va_list ap;
+
+		va_copy(ap, args);
+		/* we reserved extra byte for \0 at the end */
+		ret = vsnprintf(env.log_buf + env.log_cnt, rem_sz + 1, fmt, ap);
+		va_end(ap);
+
+		if (ret < 0) {
+			env.log_buf[env.log_cnt] = '\0';
+			fprintf(stderr, "failed to log w/ fmt '%s'\n", fmt);
+			return;
+		}
+	}
+
+	if (!rem_sz || ret > rem_sz) {
+		size_t new_sz = env.log_cap * 3 / 2;
+		char *new_buf;
+
+		if (new_sz < 4096)
+			new_sz = 4096;
+		if (new_sz < ret + env.log_cnt)
+			new_sz = ret + env.log_cnt;
+
+		/* +1 for guaranteed space for terminating \0 */
+		new_buf = realloc(env.log_buf, new_sz + 1);
+		if (!new_buf) {
+			fprintf(stderr, "failed to realloc log buffer: %d\n",
+				errno);
+			return;
+		}
+		env.log_buf = new_buf;
+		env.log_cap = new_sz;
+		goto try_again;
+	}
+
+	env.log_cnt += ret;
+}
+
+void test__printf(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	test__vprintf(fmt, args);
+	va_end(args);
+}
 
 struct ipv4_packet pkt_v4 = {
 	.eth.h_proto = __bpf_constant_htons(ETH_P_IP),
@@ -163,20 +239,15 @@ void *spin_lock_thread(void *arg)
 #include <prog_tests/tests.h>
 #undef DEFINE_TEST
 
-struct prog_test_def {
-	const char *test_name;
-	int test_num;
-	void (*run_test)(void);
-};
-
 static struct prog_test_def prog_test_defs[] = {
-#define DEFINE_TEST(name) {	      \
-	.test_name = #name,	      \
-	.run_test = &test_##name,   \
+#define DEFINE_TEST(name) {		\
+	.test_name = #name,		\
+	.run_test = &test_##name,	\
 },
 #include <prog_tests/tests.h>
 #undef DEFINE_TEST
 };
+const int prog_test_cnt = ARRAY_SIZE(prog_test_defs);
 
 const char *argp_program_version = "test_progs 0.1";
 const char *argp_program_bug_address = "<bpf@vger.kernel.org>";
@@ -186,7 +257,6 @@ enum ARG_KEYS {
 	ARG_TEST_NUM = 'n',
 	ARG_TEST_NAME = 't',
 	ARG_VERIFIER_STATS = 's',
-
 	ARG_VERBOSE = 'v',
 };
 	
@@ -202,24 +272,13 @@ static const struct argp_option opts[] = {
 	{},
 };
 
-struct test_env {
-	int test_num_selector;
-	const char *test_name_selector;
-	bool verifier_stats;
-	bool verbose;
-	bool very_verbose;
-};
-
-static struct test_env env = {
-	.test_num_selector = -1,
-};
-
 static int libbpf_print_fn(enum libbpf_print_level level,
 			   const char *format, va_list args)
 {
 	if (!env.very_verbose && level == LIBBPF_DEBUG)
 		return 0;
-	return vfprintf(stderr, format, args);
+	test__vprintf(format, args);
+	return 0;
 }
 
 static error_t parse_arg(int key, char *arg, struct argp_state *state)
@@ -267,7 +326,6 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
 	return 0;
 }
 
-
 int main(int argc, char **argv)
 {
 	static const struct argp argp = {
@@ -275,7 +333,6 @@ int main(int argc, char **argv)
 		.parser = parse_arg,
 		.doc = argp_program_doc,
 	};
-	struct prog_test_def *test;
 	int err, i;
 
 	err = argp_parse(&argp, argc, argv, 0, NULL, &env);
@@ -286,13 +343,14 @@ int main(int argc, char **argv)
 
 	srand(time(NULL));
 
-	jit_enabled = is_jit_enabled();
+	env.jit_enabled = is_jit_enabled();
 
-	verifier_stats = env.verifier_stats;
-
-	for (i = 0; i < ARRAY_SIZE(prog_test_defs); i++) {
-		test = &prog_test_defs[i];
+	for (i = 0; i < prog_test_cnt; i++) {
+		struct prog_test_def *test = &prog_test_defs[i];
+		int old_pass_cnt = pass_cnt;
+		int old_error_cnt = error_cnt;
 
+		env.test = test;
 		test->test_num = i + 1;
 
 		if (env.test_num_selector >= 0 &&
@@ -303,8 +361,29 @@ int main(int argc, char **argv)
 			continue;
 
 		test->run_test();
+		test->tested = true;
+		test->pass_cnt = pass_cnt - old_pass_cnt;
+		test->error_cnt = error_cnt - old_error_cnt;
+		if (test->error_cnt)
+			env.fail_cnt++;
+		else
+			env.succ_cnt++;
+
+		if (env.verbose || test->force_log || test->error_cnt) {
+			if (env.log_cnt) {
+				fprintf(stdout, "%s", env.log_buf);
+				if (env.log_buf[env.log_cnt - 1] != '\n')
+					fprintf(stdout, "\n");
+			}
+		}
+		env.log_cnt = 0;
+
+		printf("#%d %s:%s\n", test->test_num, test->test_name,
+		       test->error_cnt ? "FAIL" : "OK");
 	}
+	printf("Summary: %d PASSED, %d FAILED\n", env.succ_cnt, env.fail_cnt);
+
+	free(env.log_buf);
 
-	printf("Summary: %d PASSED, %d FAILED\n", pass_cnt, error_cnt);
 	return error_cnt ? EXIT_FAILURE : EXIT_SUCCESS;
 }
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 49e0f7d85643..62f55a4231e9 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -38,9 +38,33 @@ typedef __u16 __sum16;
 #include "trace_helpers.h"
 #include "flow_dissector_load.h"
 
-extern int error_cnt, pass_cnt;
-extern bool jit_enabled;
-extern bool verifier_stats;
+struct prog_test_def;
+
+struct test_env {
+	int test_num_selector;
+	const char *test_name_selector;
+	bool verifier_stats;
+	bool verbose;
+	bool very_verbose;
+
+	bool jit_enabled;
+
+	struct prog_test_def *test;
+	char *log_buf;
+	size_t log_cnt;
+	size_t log_cap;
+
+	int succ_cnt;
+	int fail_cnt;
+};
+
+extern int error_cnt;
+extern int pass_cnt;
+extern struct test_env env;
+
+extern void test__printf(const char *fmt, ...);
+extern void test__vprintf(const char *fmt, va_list args);
+extern void test__force_log();
 
 #define MAGIC_BYTES 123
 
@@ -64,11 +88,12 @@ extern struct ipv6_packet pkt_v6;
 	int __ret = !!(condition);					\
 	if (__ret) {							\
 		error_cnt++;						\
-		printf("%s:FAIL:%s ", __func__, tag);			\
-		printf(format);						\
+		test__printf("%s:FAIL:%s ", __func__, tag);		\
+		test__printf(format);					\
 	} else {							\
 		pass_cnt++;						\
-		printf("%s:PASS:%s %d nsec\n", __func__, tag, duration);\
+		test__printf("%s:PASS:%s %d nsec\n",			\
+			      __func__, tag, duration);			\
 	}								\
 	__ret;								\
 })
-- 
2.17.1

