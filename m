Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFF5375FCF
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 07:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhEGFml convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 May 2021 01:42:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1270 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233959AbhEGFmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 01:42:38 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1475fKo6004194
        for <netdev@vger.kernel.org>; Thu, 6 May 2021 22:41:39 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38cspy1axr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 22:41:38 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 6 May 2021 22:41:37 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 26A5F2ED7617; Thu,  6 May 2021 22:41:29 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [RFC PATCH bpf-next 3/7] selftests/bpf: stop using static variables for passing data to/from user-space
Date:   Thu, 6 May 2021 22:41:15 -0700
Message-ID: <20210507054119.270888-4-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507054119.270888-1-andrii@kernel.org>
References: <20210507054119.270888-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qHSPDWClqqb08ImBG3zW5HBZQB11cLh8
X-Proofpoint-GUID: qHSPDWClqqb08ImBG3zW5HBZQB11cLh8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_01:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105070042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of skipping emitting static variables in BPF skeletons, switch
all current selftests uses of static variables to pass data between BPF and
user-space to use global variables.

All non-read-only `static volatile` variables become just plain global
variables by dropping `static volatile` part.

Read-only `static volatile const` variables, though, still require `volatile`
modifier, otherwise compiler will ignore whatever values are set from
user-space.

Few static linker tests are using name-conflicting static variables to
validate that static linker still properly handles static variables and
doesn't trip up on name conflicts.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/send_signal.c      | 2 +-
 tools/testing/selftests/bpf/prog_tests/skeleton.c         | 6 ++----
 tools/testing/selftests/bpf/prog_tests/static_linked.c    | 5 -----
 tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c   | 4 ++--
 tools/testing/selftests/bpf/progs/kfree_skb.c             | 4 ++--
 tools/testing/selftests/bpf/progs/tailcall3.c             | 2 +-
 tools/testing/selftests/bpf/progs/tailcall4.c             | 2 +-
 tools/testing/selftests/bpf/progs/tailcall5.c             | 2 +-
 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c     | 2 +-
 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c     | 2 +-
 tools/testing/selftests/bpf/progs/test_check_mtu.c        | 4 ++--
 tools/testing/selftests/bpf/progs/test_cls_redirect.c     | 4 ++--
 tools/testing/selftests/bpf/progs/test_global_func_args.c | 2 +-
 tools/testing/selftests/bpf/progs/test_rdonly_maps.c      | 6 +++---
 tools/testing/selftests/bpf/progs/test_skeleton.c         | 4 ++--
 tools/testing/selftests/bpf/progs/test_snprintf_single.c  | 2 +-
 tools/testing/selftests/bpf/progs/test_sockmap_listen.c   | 4 ++--
 tools/testing/selftests/bpf/progs/test_static_linked1.c   | 8 ++++----
 tools/testing/selftests/bpf/progs/test_static_linked2.c   | 8 ++++----
 19 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
index 7043e6ded0e6..a1eade51d440 100644
--- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -2,7 +2,7 @@
 #include <test_progs.h>
 #include "test_send_signal_kern.skel.h"
 
-static volatile int sigusr1_received = 0;
+int sigusr1_received = 0;
 
 static void sigusr1_handler(int signum)
 {
diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
index fe87b77af459..f6f130c99b8c 100644
--- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
+++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
@@ -82,10 +82,8 @@ void test_skeleton(void)
 	CHECK(data->out2 != 2, "res2", "got %lld != exp %d\n", data->out2, 2);
 	CHECK(bss->out3 != 3, "res3", "got %d != exp %d\n", (int)bss->out3, 3);
 	CHECK(bss->out4 != 4, "res4", "got %lld != exp %d\n", bss->out4, 4);
-	CHECK(bss->handler_out5.a != 5, "res5", "got %d != exp %d\n",
-	      bss->handler_out5.a, 5);
-	CHECK(bss->handler_out5.b != 6, "res6", "got %lld != exp %d\n",
-	      bss->handler_out5.b, 6);
+	CHECK(bss->out5.a != 5, "res5", "got %d != exp %d\n", bss->out5.a, 5);
+	CHECK(bss->out5.b != 6, "res6", "got %lld != exp %d\n", bss->out5.b, 6);
 	CHECK(bss->out6 != 14, "res7", "got %d != exp %d\n", bss->out6, 14);
 
 	CHECK(bss->bpf_syscall != kcfg->CONFIG_BPF_SYSCALL, "ext1",
diff --git a/tools/testing/selftests/bpf/prog_tests/static_linked.c b/tools/testing/selftests/bpf/prog_tests/static_linked.c
index 46556976dccc..ab6acbaf9d8c 100644
--- a/tools/testing/selftests/bpf/prog_tests/static_linked.c
+++ b/tools/testing/selftests/bpf/prog_tests/static_linked.c
@@ -14,12 +14,7 @@ void test_static_linked(void)
 		return;
 
 	skel->rodata->rovar1 = 1;
-	skel->bss->static_var1 = 2;
-	skel->bss->static_var11 = 3;
-
 	skel->rodata->rovar2 = 4;
-	skel->bss->static_var2 = 5;
-	skel->bss->static_var22 = 6;
 
 	err = test_static_linked__load(skel);
 	if (!ASSERT_OK(err, "skel_load"))
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
index ee49493dc125..400fdf8d6233 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
@@ -9,8 +9,8 @@ __u32 map1_id = 0, map2_id = 0;
 __u32 map1_accessed = 0, map2_accessed = 0;
 __u64 map1_seqnum = 0, map2_seqnum1 = 0, map2_seqnum2 = 0;
 
-static volatile const __u32 print_len;
-static volatile const __u32 ret1;
+volatile const __u32 print_len;
+volatile const __u32 ret1;
 
 SEC("iter/bpf_map")
 int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/selftests/bpf/progs/kfree_skb.c
index a46a264ce24e..55e283050cab 100644
--- a/tools/testing/selftests/bpf/progs/kfree_skb.c
+++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
@@ -109,10 +109,10 @@ int BPF_PROG(trace_kfree_skb, struct sk_buff *skb, void *location)
 	return 0;
 }
 
-static volatile struct {
+struct {
 	bool fentry_test_ok;
 	bool fexit_test_ok;
-} result;
+} result = {};
 
 SEC("fentry/eth_type_trans")
 int BPF_PROG(fentry_eth_type_trans, struct sk_buff *skb, struct net_device *dev,
diff --git a/tools/testing/selftests/bpf/progs/tailcall3.c b/tools/testing/selftests/bpf/progs/tailcall3.c
index 739dc2a51e74..910858fe078a 100644
--- a/tools/testing/selftests/bpf/progs/tailcall3.c
+++ b/tools/testing/selftests/bpf/progs/tailcall3.c
@@ -10,7 +10,7 @@ struct {
 	__uint(value_size, sizeof(__u32));
 } jmp_table SEC(".maps");
 
-static volatile int count;
+int count = 0;
 
 SEC("classifier/0")
 int bpf_func_0(struct __sk_buff *skb)
diff --git a/tools/testing/selftests/bpf/progs/tailcall4.c b/tools/testing/selftests/bpf/progs/tailcall4.c
index f82075b47d7d..bd4be135c39d 100644
--- a/tools/testing/selftests/bpf/progs/tailcall4.c
+++ b/tools/testing/selftests/bpf/progs/tailcall4.c
@@ -10,7 +10,7 @@ struct {
 	__uint(value_size, sizeof(__u32));
 } jmp_table SEC(".maps");
 
-static volatile int selector;
+int selector = 0;
 
 #define TAIL_FUNC(x)				\
 	SEC("classifier/" #x)			\
diff --git a/tools/testing/selftests/bpf/progs/tailcall5.c b/tools/testing/selftests/bpf/progs/tailcall5.c
index ce5450744fd4..adf30a33064e 100644
--- a/tools/testing/selftests/bpf/progs/tailcall5.c
+++ b/tools/testing/selftests/bpf/progs/tailcall5.c
@@ -10,7 +10,7 @@ struct {
 	__uint(value_size, sizeof(__u32));
 } jmp_table SEC(".maps");
 
-static volatile int selector;
+int selector = 0;
 
 #define TAIL_FUNC(x)				\
 	SEC("classifier/" #x)			\
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
index 7b1c04183824..3cc4c12817b5 100644
--- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
@@ -20,7 +20,7 @@ int subprog_tail(struct __sk_buff *skb)
 	return 1;
 }
 
-static volatile int count;
+int count = 0;
 
 SEC("classifier/0")
 int bpf_func_0(struct __sk_buff *skb)
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
index 9a1b166b7fbe..77df6d4db895 100644
--- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
@@ -9,7 +9,7 @@ struct {
 	__uint(value_size, sizeof(__u32));
 } jmp_table SEC(".maps");
 
-static volatile int count;
+int count = 0;
 
 __noinline
 int subprog_tail_2(struct __sk_buff *skb)
diff --git a/tools/testing/selftests/bpf/progs/test_check_mtu.c b/tools/testing/selftests/bpf/progs/test_check_mtu.c
index c4a9bae96e75..71184af57749 100644
--- a/tools/testing/selftests/bpf/progs/test_check_mtu.c
+++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
@@ -11,8 +11,8 @@
 char _license[] SEC("license") = "GPL";
 
 /* Userspace will update with MTU it can see on device */
-static volatile const int GLOBAL_USER_MTU;
-static volatile const __u32 GLOBAL_USER_IFINDEX;
+volatile const int GLOBAL_USER_MTU;
+volatile const __u32 GLOBAL_USER_IFINDEX;
 
 /* BPF-prog will update these with MTU values it can see */
 __u32 global_bpf_mtu_xdp = 0;
diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
index 3c1e042962e6..e2a5acc4785c 100644
--- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
@@ -39,8 +39,8 @@ char _license[] SEC("license") = "Dual BSD/GPL";
 /**
  * Destination port and IP used for UDP encapsulation.
  */
-static volatile const __be16 ENCAPSULATION_PORT;
-static volatile const __be32 ENCAPSULATION_IP;
+volatile const __be16 ENCAPSULATION_PORT;
+volatile const __be32 ENCAPSULATION_IP;
 
 typedef struct {
 	uint64_t processed_packets_total;
diff --git a/tools/testing/selftests/bpf/progs/test_global_func_args.c b/tools/testing/selftests/bpf/progs/test_global_func_args.c
index cae309538a9e..e712bf77daae 100644
--- a/tools/testing/selftests/bpf/progs/test_global_func_args.c
+++ b/tools/testing/selftests/bpf/progs/test_global_func_args.c
@@ -8,7 +8,7 @@ struct S {
 	int v;
 };
 
-static volatile struct S global_variable;
+struct S global_variable = {};
 
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
diff --git a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
index ecbeea2df259..fc8e8a34a3db 100644
--- a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
+++ b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
@@ -5,7 +5,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
-static volatile const struct {
+const struct {
 	unsigned a[4];
 	/*
 	 * if the struct's size is multiple of 16, compiler will put it into
@@ -15,11 +15,11 @@ static volatile const struct {
 	char _y;
 } rdonly_values = { .a = {2, 3, 4, 5} };
 
-static volatile struct {
+struct {
 	unsigned did_run;
 	unsigned iters;
 	unsigned sum;
-} res;
+} res = {};
 
 SEC("raw_tracepoint/sys_enter:skip_loop")
 int skip_loop(struct pt_regs *ctx)
diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/testing/selftests/bpf/progs/test_skeleton.c
index 374ccef704e1..441fa1c552c8 100644
--- a/tools/testing/selftests/bpf/progs/test_skeleton.c
+++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
@@ -38,11 +38,11 @@ extern int LINUX_KERNEL_VERSION __kconfig;
 bool bpf_syscall = 0;
 int kern_ver = 0;
 
+struct s out5 = {};
+
 SEC("raw_tp/sys_enter")
 int handler(const void *ctx)
 {
-	static volatile struct s out5;
-
 	out1 = in1;
 	out2 = in2;
 	out3 = in3;
diff --git a/tools/testing/selftests/bpf/progs/test_snprintf_single.c b/tools/testing/selftests/bpf/progs/test_snprintf_single.c
index 402adaf344f9..3095837334d3 100644
--- a/tools/testing/selftests/bpf/progs/test_snprintf_single.c
+++ b/tools/testing/selftests/bpf/progs/test_snprintf_single.c
@@ -5,7 +5,7 @@
 #include <bpf/bpf_helpers.h>
 
 /* The format string is filled from the userspace such that loading fails */
-static const char fmt[10];
+const char fmt[10];
 
 SEC("raw_tp/sys_enter")
 int handler(const void *ctx)
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
index a39eba9f5201..a1cc58b10c7c 100644
--- a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
@@ -28,8 +28,8 @@ struct {
 	__type(value, unsigned int);
 } verdict_map SEC(".maps");
 
-static volatile bool test_sockmap; /* toggled by user-space */
-static volatile bool test_ingress; /* toggled by user-space */
+bool test_sockmap = false; /* toggled by user-space */
+bool test_ingress = false; /* toggled by user-space */
 
 SEC("sk_skb/stream_parser")
 int prog_stream_parser(struct __sk_buff *skb)
diff --git a/tools/testing/selftests/bpf/progs/test_static_linked1.c b/tools/testing/selftests/bpf/progs/test_static_linked1.c
index ea1a6c4c7172..cae304045d9c 100644
--- a/tools/testing/selftests/bpf/progs/test_static_linked1.c
+++ b/tools/testing/selftests/bpf/progs/test_static_linked1.c
@@ -4,9 +4,9 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
-/* 8-byte aligned .bss */
-static volatile long static_var1;
-static volatile int static_var11;
+/* 8-byte aligned .data */
+static volatile long static_var1 = 2;
+static volatile int static_var2 = 3;
 int var1 = 0;
 /* 4-byte aligned .rodata */
 const volatile int rovar1;
@@ -21,7 +21,7 @@ static __noinline int subprog(int x)
 SEC("raw_tp/sys_enter")
 int handler1(const void *ctx)
 {
-	var1 = subprog(rovar1) + static_var1 + static_var11;
+	var1 = subprog(rovar1) + static_var1 + static_var2;
 
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/test_static_linked2.c b/tools/testing/selftests/bpf/progs/test_static_linked2.c
index 54d8d1ab577c..c54c4e865ed8 100644
--- a/tools/testing/selftests/bpf/progs/test_static_linked2.c
+++ b/tools/testing/selftests/bpf/progs/test_static_linked2.c
@@ -4,9 +4,9 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
-/* 4-byte aligned .bss */
-static volatile int static_var2;
-static volatile int static_var22;
+/* 4-byte aligned .data */
+static volatile int static_var1 = 5;
+static volatile int static_var2 = 6;
 int var2 = 0;
 /* 8-byte aligned .rodata */
 const volatile long rovar2;
@@ -21,7 +21,7 @@ static __noinline int subprog(int x)
 SEC("raw_tp/sys_enter")
 int handler2(const void *ctx)
 {
-	var2 = subprog(rovar2) + static_var2 + static_var22;
+	var2 = subprog(rovar2) + static_var1 + static_var2;
 
 	return 0;
 }
-- 
2.30.2

