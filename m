Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEFA12AECF
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfLZVTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:19:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45382 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbfLZVTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:19:13 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBQLHULp011737
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:19:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=xrWag5ptm8VTUu3lPHQoHI7kSkNcGG6RbhRZze+jT2Q=;
 b=WA0F2pUZPelXmi8VR17c7aauqm/XVSKtuPkpvWTAQYvM6PHy6K+3d/4LS6V23FIjCooN
 38I9c44Rva8yMkNGrNqB2Gl4fVW6UY4p7C4Ynf+s/nHeW1LdkPDiFO9fMYKRcr1Lrh+x
 VP6dzQbnewrBFmcBakq0XrVL8Dk9NcdEeoo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2x3mexfwvh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:19:08 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 26 Dec 2019 13:19:06 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7F9652EC1C37; Thu, 26 Dec 2019 13:19:04 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>, <kafai@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: add BPF_HANDLER, BPF_KPROBE, and BPF_KRETPROBE macros
Date:   Thu, 26 Dec 2019 13:18:55 -0800
Message-ID: <20191226211855.3190765-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-26_05:2019-12-24,2019-12-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 priorityscore=1501 suspectscore=8 bulkscore=0
 impostorscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912260189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Streamline BPF_TRACE_x macro by moving out return type and section attribute
definition out of macro itself. That makes those function look in source code
similar to other BPF programs. Additionally, simplify its usage by determining
number of arguments automatically (so just single BPF_TRACE vs a family of
BPF_TRACE_1, BPF_TRACE_2, etc). Also, allow more natural function argument
syntax without commas inbetween argument type and name.

Given this helper is useful not only for tracing tp_btf/fenty/fexit programs,
but could be used for LSM programs and others following the same pattern,
rename BPF_TRACE macro into more generic BPF_HANDLER. Existing BPF_TRACE_x
usages in selftests are converted to new BPF_HANDLER macro.

Following the same pattern, define BPF_KPROBE and BPF_KRETPROBE macros for
nicer usage of kprobe/kretprobe arguments, respectively. BPF_KRETPROBE, adopts
same convention used by fexit programs, that last defined argument is probed
function's return result.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../testing/selftests/bpf/bpf_trace_helpers.h | 130 +++++++++++-------
 .../testing/selftests/bpf/progs/fentry_test.c |  21 +--
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |   8 +-
 .../bpf/progs/fexit_bpf2bpf_simple.c          |   5 +-
 .../testing/selftests/bpf/progs/fexit_test.c  |  24 ++--
 tools/testing/selftests/bpf/progs/kfree_skb.c |  17 +--
 .../selftests/bpf/progs/test_overhead.c       |  32 +++--
 .../selftests/bpf/progs/test_perf_buffer.c    |   3 +-
 .../selftests/bpf/progs/test_probe_user.c     |   3 +-
 9 files changed, 145 insertions(+), 98 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_trace_helpers.h b/tools/testing/selftests/bpf/bpf_trace_helpers.h
index c76a214a53b0..023b6565d663 100644
--- a/tools/testing/selftests/bpf/bpf_trace_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_trace_helpers.h
@@ -4,55 +4,85 @@
 
 #include "bpf_helpers.h"
 
-#define __BPF_MAP_0(i, m, v, ...) v
-#define __BPF_MAP_1(i, m, v, t, a, ...) m(t, a, ctx[i])
-#define __BPF_MAP_2(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_1(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP_3(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_2(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP_4(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_3(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP_5(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_4(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP_6(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_5(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP_7(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_6(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP_8(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_7(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP_9(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_8(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP_10(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_9(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP_11(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_10(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP_12(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_11(i+1, m, v, __VA_ARGS__)
-#define __BPF_MAP(n, ...) __BPF_MAP_##n(0, __VA_ARGS__)
-
-/* BPF sizeof(void *) is always 8, so no need to cast to long first
- * for ptr to avoid compiler warning.
- */
-#define __BPF_CAST(t, a, ctx) (t) ctx
-#define __BPF_V void
-#define __BPF_N
-
-#define __BPF_DECL_ARGS(t, a, ctx) t a
-
-#define BPF_TRACE_x(x, sec_name, fname, ret_type, ...)			\
-static __always_inline ret_type						\
-____##fname(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__));	\
-									\
-SEC(sec_name)								\
-ret_type fname(__u64 *ctx)						\
-{									\
-	return ____##fname(__BPF_MAP(x, __BPF_CAST, __BPF_N, __VA_ARGS__));\
-}									\
-									\
-static __always_inline							\
-ret_type ____##fname(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__))
-
-#define BPF_TRACE_0(sec, fname, ...)  BPF_TRACE_x(0, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_1(sec, fname, ...)  BPF_TRACE_x(1, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_2(sec, fname, ...)  BPF_TRACE_x(2, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_3(sec, fname, ...)  BPF_TRACE_x(3, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_4(sec, fname, ...)  BPF_TRACE_x(4, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_5(sec, fname, ...)  BPF_TRACE_x(5, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_6(sec, fname, ...)  BPF_TRACE_x(6, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_7(sec, fname, ...)  BPF_TRACE_x(7, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_8(sec, fname, ...)  BPF_TRACE_x(8, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_9(sec, fname, ...)  BPF_TRACE_x(9, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_10(sec, fname, ...)  BPF_TRACE_x(10, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_11(sec, fname, ...)  BPF_TRACE_x(11, sec, fname, int, __VA_ARGS__)
-#define BPF_TRACE_12(sec, fname, ...)  BPF_TRACE_x(12, sec, fname, int, __VA_ARGS__)
+#define ___bpf_concat(a, b) a ## b
+#define ___bpf_apply(fn, n) ___bpf_concat(fn, n)
+#define ___bpf_nth(_, _1, _2, _3, _4, _5, _6, _7, _8, _9, _a, _b, _c, N, ...) N
+#define ___bpf_narg(...) \
+	___bpf_nth(_, ##__VA_ARGS__, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+#define ___bpf_empty(...) \
+	___bpf_nth(_, ##__VA_ARGS__, N, N, N, N, N, N, N, N, N, N, 0)
 
+#define ___bpf_ctx_cast0()
+#define ___bpf_ctx_cast1(x) (void *)ctx[0]
+#define ___bpf_ctx_cast2(x, args...) ___bpf_ctx_cast1(args), (void *)ctx[1]
+#define ___bpf_ctx_cast3(x, args...) ___bpf_ctx_cast2(args), (void *)ctx[2]
+#define ___bpf_ctx_cast4(x, args...) ___bpf_ctx_cast3(args), (void *)ctx[3]
+#define ___bpf_ctx_cast5(x, args...) ___bpf_ctx_cast4(args), (void *)ctx[4]
+#define ___bpf_ctx_cast6(x, args...) ___bpf_ctx_cast5(args), (void *)ctx[5]
+#define ___bpf_ctx_cast7(x, args...) ___bpf_ctx_cast6(args), (void *)ctx[6]
+#define ___bpf_ctx_cast8(x, args...) ___bpf_ctx_cast7(args), (void *)ctx[7]
+#define ___bpf_ctx_cast9(x, args...) ___bpf_ctx_cast8(args), (void *)ctx[8]
+#define ___bpf_ctx_cast10(x, args...) ___bpf_ctx_cast9(args), (void *)ctx[9]
+#define ___bpf_ctx_cast11(x, args...) ___bpf_ctx_cast10(args), (void *)ctx[10]
+#define ___bpf_ctx_cast12(x, args...) ___bpf_ctx_cast11(args), (void *)ctx[11]
+#define ___bpf_ctx_cast(args...) \
+	___bpf_apply(___bpf_ctx_cast, ___bpf_narg(args))(args)
+
+#define BPF_HANDLER(name, args...)					    \
+name(unsigned long long *ctx);						    \
+static __always_inline typeof(name(0)) ____##name(args);		    \
+typeof(name(0)) name(unsigned long long *ctx)				    \
+{									    \
+	_Pragma("GCC diagnostic push")					    \
+	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	return ____##name(___bpf_ctx_cast(args));			    \
+	_Pragma("GCC diagnostic pop")					    \
+}									    \
+static __always_inline typeof(name(0)) ____##name(args)
+
+struct pt_regs;
+
+#define ___bpf_kprobe_args0() ctx
+#define ___bpf_kprobe_args1(x) \
+	___bpf_kprobe_args0(), (void *)PT_REGS_PARM1(ctx)
+#define ___bpf_kprobe_args2(x, args...) \
+	___bpf_kprobe_args1(args), (void *)PT_REGS_PARM2(ctx)
+#define ___bpf_kprobe_args3(x, args...) \
+	___bpf_kprobe_args2(args), (void *)PT_REGS_PARM3(ctx)
+#define ___bpf_kprobe_args4(x, args...) \
+	___bpf_kprobe_args3(args), (void *)PT_REGS_PARM4(ctx)
+#define ___bpf_kprobe_args5(x, args...) \
+	___bpf_kprobe_args4(args), (void *)PT_REGS_PARM5(ctx)
+#define ___bpf_kprobe_args(args...) \
+	___bpf_apply(___bpf_kprobe_args, ___bpf_narg(args))(args)
+
+#define BPF_KPROBE(name, args...)					    \
+name(struct pt_regs *ctx);						    \
+static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args);\
+typeof(name(0)) name(struct pt_regs *ctx)				    \
+{									    \
+	_Pragma("GCC diagnostic push")					    \
+	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	return ____##name(___bpf_kprobe_args(args));			    \
+	_Pragma("GCC diagnostic pop")					    \
+}									    \
+static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
+
+#define ___bpf_kretprobe_args0() ctx
+#define ___bpf_kretprobe_argsN(x, args...) \
+	___bpf_kprobe_args(args), (void *)PT_REGS_RET(ctx)
+#define ___bpf_kretprobe_args(args...) \
+	___bpf_apply(___bpf_kretprobe_args, ___bpf_empty(args))(args)
+
+#define BPF_KRETPROBE(name, args...)					    \
+name(struct pt_regs *ctx);						    \
+static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args);\
+typeof(name(0)) name(struct pt_regs *ctx)				    \
+{									    \
+	_Pragma("GCC diagnostic push")					    \
+	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")		    \
+	return ____##name(___bpf_kretprobe_args(args));			    \
+	_Pragma("GCC diagnostic pop")					    \
+}									    \
+static __always_inline typeof(name(0)) ____##name(struct pt_regs *ctx, ##args)
 #endif
diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
index 615f7c6bca77..59109a0cd218 100644
--- a/tools/testing/selftests/bpf/progs/fentry_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_test.c
@@ -7,37 +7,40 @@
 char _license[] SEC("license") = "GPL";
 
 __u64 test1_result = 0;
-BPF_TRACE_1("fentry/bpf_fentry_test1", test1, int, a)
+SEC("fentry/bpf_fentry_test1")
+int BPF_HANDLER(test1, int a)
 {
 	test1_result = a == 1;
 	return 0;
 }
 
 __u64 test2_result = 0;
-BPF_TRACE_2("fentry/bpf_fentry_test2", test2, int, a, __u64, b)
+SEC("fentry/bpf_fentry_test2")
+int BPF_HANDLER(test2, int a, __u64 b)
 {
 	test2_result = a == 2 && b == 3;
 	return 0;
 }
 
 __u64 test3_result = 0;
-BPF_TRACE_3("fentry/bpf_fentry_test3", test3, char, a, int, b, __u64, c)
+SEC("fentry/bpf_fentry_test3")
+int BPF_HANDLER(test3, char a, int b, __u64 c)
 {
 	test3_result = a == 4 && b == 5 && c == 6;
 	return 0;
 }
 
 __u64 test4_result = 0;
-BPF_TRACE_4("fentry/bpf_fentry_test4", test4,
-	    void *, a, char, b, int, c, __u64, d)
+SEC("fentry/bpf_fentry_test4")
+int BPF_HANDLER(test4, void *a, char b, int c, __u64 d)
 {
 	test4_result = a == (void *)7 && b == 8 && c == 9 && d == 10;
 	return 0;
 }
 
 __u64 test5_result = 0;
-BPF_TRACE_5("fentry/bpf_fentry_test5", test5,
-	    __u64, a, void *, b, short, c, int, d, __u64, e)
+SEC("fentry/bpf_fentry_test5")
+int BPF_HANDLER(test5, __u64 a, void *b, short c, int d, __u64 e)
 {
 	test5_result = a == 11 && b == (void *)12 && c == 13 && d == 14 &&
 		e == 15;
@@ -45,8 +48,8 @@ BPF_TRACE_5("fentry/bpf_fentry_test5", test5,
 }
 
 __u64 test6_result = 0;
-BPF_TRACE_6("fentry/bpf_fentry_test6", test6,
-	    __u64, a, void *, b, short, c, int, d, void *, e, __u64, f)
+SEC("fentry/bpf_fentry_test6")
+int BPF_HANDLER(test6, __u64 a, void *b, short c, int d, void * e, __u64 f)
 {
 	test6_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
 		e == (void *)20 && f == 21;
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
index 2d211ee98a1c..a23cc22b960c 100644
--- a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
@@ -9,8 +9,8 @@ struct sk_buff {
 };
 
 __u64 test_result = 0;
-BPF_TRACE_2("fexit/test_pkt_access", test_main,
-	    struct sk_buff *, skb, int, ret)
+SEC("fexit/test_pkt_access")
+int BPF_HANDLER(test_main, struct sk_buff *skb, int ret)
 {
 	int len;
 
@@ -24,8 +24,8 @@ BPF_TRACE_2("fexit/test_pkt_access", test_main,
 }
 
 __u64 test_result_subprog1 = 0;
-BPF_TRACE_2("fexit/test_pkt_access_subprog1", test_subprog1,
-	    struct sk_buff *, skb, int, ret)
+SEC("fexit/test_pkt_access_subprog1")
+int BPF_HANDLER(test_subprog1, struct sk_buff *skb, int ret)
 {
 	int len;
 
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf_simple.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf_simple.c
index ebc0ab7f0f5c..381a8a61781d 100644
--- a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf_simple.c
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf_simple.c
@@ -9,8 +9,9 @@ struct sk_buff {
 };
 
 __u64 test_result = 0;
-BPF_TRACE_2("fexit/test_pkt_md_access", test_main2,
-	    struct sk_buff *, skb, int, ret)
+
+SEC("fexit/test_pkt_md_access")
+int BPF_HANDLER(test_main2, struct sk_buff *skb, int ret)
 {
 	int len;
 
diff --git a/tools/testing/selftests/bpf/progs/fexit_test.c b/tools/testing/selftests/bpf/progs/fexit_test.c
index 86db0d60fb6e..ea4091f6dca1 100644
--- a/tools/testing/selftests/bpf/progs/fexit_test.c
+++ b/tools/testing/selftests/bpf/progs/fexit_test.c
@@ -7,39 +7,41 @@
 char _license[] SEC("license") = "GPL";
 
 __u64 test1_result = 0;
-BPF_TRACE_2("fexit/bpf_fentry_test1", test1, int, a, int, ret)
+SEC("fexit/bpf_fentry_test1")
+int BPF_HANDLER(test1, int a, int ret)
 {
 	test1_result = a == 1 && ret == 2;
 	return 0;
 }
 
 __u64 test2_result = 0;
-BPF_TRACE_3("fexit/bpf_fentry_test2", test2, int, a, __u64, b, int, ret)
+SEC("fexit/bpf_fentry_test2")
+int BPF_HANDLER(test2, int a, __u64 b, int ret)
 {
 	test2_result = a == 2 && b == 3 && ret == 5;
 	return 0;
 }
 
 __u64 test3_result = 0;
-BPF_TRACE_4("fexit/bpf_fentry_test3", test3, char, a, int, b, __u64, c, int, ret)
+SEC("fexit/bpf_fentry_test3")
+int BPF_HANDLER(test3, char a, int b, __u64 c, int ret)
 {
 	test3_result = a == 4 && b == 5 && c == 6 && ret == 15;
 	return 0;
 }
 
 __u64 test4_result = 0;
-BPF_TRACE_5("fexit/bpf_fentry_test4", test4,
-	    void *, a, char, b, int, c, __u64, d, int, ret)
+SEC("fexit/bpf_fentry_test4")
+int BPF_HANDLER(test4, void *a, char b, int c, __u64 d, int ret)
 {
-
 	test4_result = a == (void *)7 && b == 8 && c == 9 && d == 10 &&
 		ret == 34;
 	return 0;
 }
 
 __u64 test5_result = 0;
-BPF_TRACE_6("fexit/bpf_fentry_test5", test5,
-	    __u64, a, void *, b, short, c, int, d, __u64, e, int, ret)
+SEC("fexit/bpf_fentry_test5")
+int BPF_HANDLER(test5, __u64 a, void *b, short c, int d, __u64 e, int ret)
 {
 	test5_result = a == 11 && b == (void *)12 && c == 13 && d == 14 &&
 		e == 15 && ret == 65;
@@ -47,9 +49,9 @@ BPF_TRACE_6("fexit/bpf_fentry_test5", test5,
 }
 
 __u64 test6_result = 0;
-BPF_TRACE_7("fexit/bpf_fentry_test6", test6,
-	    __u64, a, void *, b, short, c, int, d, void *, e, __u64, f,
-	    int, ret)
+SEC("fexit/bpf_fentry_test6")
+int BPF_HANDLER(test6, __u64 a, void *b, short c, int d, void *e, __u64 f,
+		       int ret)
 {
 	test6_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
 		e == (void *)20 && f == 21 && ret == 111;
diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/selftests/bpf/progs/kfree_skb.c
index 974d6f3bb319..d36427ae795f 100644
--- a/tools/testing/selftests/bpf/progs/kfree_skb.c
+++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
@@ -57,8 +57,8 @@ struct meta {
 /* TRACE_EVENT(kfree_skb,
  *         TP_PROTO(struct sk_buff *skb, void *location),
  */
-BPF_TRACE_2("tp_btf/kfree_skb", trace_kfree_skb,
-	    struct sk_buff *, skb, void *, location)
+SEC("tp_btf/kfree_skb")
+int BPF_HANDLER(trace_kfree_skb, struct sk_buff *skb, void *location)
 {
 	struct net_device *dev;
 	struct callback_head *ptr;
@@ -114,9 +114,9 @@ static volatile struct {
 	bool fexit_test_ok;
 } result;
 
-BPF_TRACE_3("fentry/eth_type_trans", fentry_eth_type_trans,
-	    struct sk_buff *, skb, struct net_device *, dev,
-	    unsigned short, protocol)
+SEC("fentry/eth_type_trans")
+int BPF_HANDLER(fentry_eth_type_trans, struct sk_buff *skb,
+		struct net_device *dev, unsigned short protocol)
 {
 	int len, ifindex;
 
@@ -132,9 +132,10 @@ BPF_TRACE_3("fentry/eth_type_trans", fentry_eth_type_trans,
 	return 0;
 }
 
-BPF_TRACE_3("fexit/eth_type_trans", fexit_eth_type_trans,
-	    struct sk_buff *, skb, struct net_device *, dev,
-	    unsigned short, protocol)
+SEC("fexit/eth_type_trans")
+int BPF_HANDLER(fexit_eth_type_trans,
+	    struct sk_buff *skb, struct net_device *dev,
+	    unsigned short protocol)
 {
 	int len, ifindex;
 
diff --git a/tools/testing/selftests/bpf/progs/test_overhead.c b/tools/testing/selftests/bpf/progs/test_overhead.c
index 96c0124a04ba..f8599b3937e9 100644
--- a/tools/testing/selftests/bpf/progs/test_overhead.c
+++ b/tools/testing/selftests/bpf/progs/test_overhead.c
@@ -1,39 +1,47 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
+#include <stdbool.h>
+#include <stddef.h>
 #include <linux/bpf.h>
+#include <linux/ptrace.h>
 #include "bpf_helpers.h"
 #include "bpf_tracing.h"
 #include "bpf_trace_helpers.h"
 
+struct task_struct;
+
 SEC("kprobe/__set_task_comm")
-int prog1(struct pt_regs *ctx)
+int BPF_KPROBE(prog1, struct task_struct *tsk, const char *buf, bool exec)
 {
-	return 0;
+	return tsk == NULL;
 }
 
 SEC("kretprobe/__set_task_comm")
-int prog2(struct pt_regs *ctx)
+int BPF_KRETPROBE(prog2,
+		  struct task_struct *tsk, const char *buf, bool exec,
+		  int ret)
 {
-	return 0;
+	return PT_REGS_PARM1(ctx) == 0 && ret != 0;
 }
 
 SEC("raw_tp/task_rename")
 int prog3(struct bpf_raw_tracepoint_args *ctx)
 {
-	return 0;
+	return ctx->args[0] == 0;;
 }
 
-struct task_struct;
-BPF_TRACE_3("fentry/__set_task_comm", prog4,
-	    struct task_struct *, tsk, const char *, buf, __u8, exec)
+SEC("fentry/__set_task_comm")
+int BPF_HANDLER(prog4, struct task_struct *tsk, const char *buf, bool exec)
 {
-	return 0;
+	return tsk == NULL;
 }
 
-BPF_TRACE_3("fexit/__set_task_comm", prog5,
-	    struct task_struct *, tsk, const char *, buf, __u8, exec)
+SEC("fexit/__set_task_comm")
+int BPF_HANDLER(prog5,
+		struct task_struct *tsk, const char *buf, bool exec,
+		int ret)
 {
-	return 0;
+	return tsk == NULL && ret != 0;
 }
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_perf_buffer.c b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
index 07c09ca5546a..1fdc999031ac 100644
--- a/tools/testing/selftests/bpf/progs/test_perf_buffer.c
+++ b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
@@ -4,6 +4,7 @@
 #include <linux/ptrace.h>
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_trace_helpers.h"
 
 struct {
 	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
@@ -12,7 +13,7 @@ struct {
 } perf_buf_map SEC(".maps");
 
 SEC("kprobe/sys_nanosleep")
-int handle_sys_nanosleep_entry(struct pt_regs *ctx)
+int BPF_KPROBE(handle_sys_nanosleep_entry)
 {
 	int cpu = bpf_get_smp_processor_id();
 
diff --git a/tools/testing/selftests/bpf/progs/test_probe_user.c b/tools/testing/selftests/bpf/progs/test_probe_user.c
index 1871e2ece0c4..5b570969e5c5 100644
--- a/tools/testing/selftests/bpf/progs/test_probe_user.c
+++ b/tools/testing/selftests/bpf/progs/test_probe_user.c
@@ -7,11 +7,12 @@
 
 #include "bpf_helpers.h"
 #include "bpf_tracing.h"
+#include "bpf_trace_helpers.h"
 
 static struct sockaddr_in old;
 
 SEC("kprobe/__sys_connect")
-int handle_sys_connect(struct pt_regs *ctx)
+int BPF_KPROBE(handle_sys_connect)
 {
 	void *ptr = (void *)PT_REGS_PARM2(ctx);
 	struct sockaddr_in new;
-- 
2.17.1

