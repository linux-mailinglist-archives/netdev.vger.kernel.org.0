Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A054108057
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKWUZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:25:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14234 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbfKWUZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:25:12 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xANKNYYM012663
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:25:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=1iLNjHqXVcjyTX2eeNsJdBrwnNrZcZeK3oQWC8g9GP4=;
 b=gjwhJUsX+n1XSyBHke8tAcph7p2Po+gmrQYb1jJQbFmBhYrhZAuayXleXwSJTqhdD18g
 RniHZVpzwJDwul73U2Ha7OP8nZHi79cNYb6FB/tDwa7JKAv9xKW7ZqFEbnde41qmDBi7
 WUYFkeOcU2io7voNV2xJJui7QGBVq7huyuw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wf4xw9cwu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:25:09 -0800
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 23 Nov 2019 12:25:08 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id DF35B2941B3F; Sat, 23 Nov 2019 12:25:04 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: Introduce BPF_TRACE_x helper for the tracing tests
Date:   Sat, 23 Nov 2019 12:25:04 -0800
Message-ID: <20191123202504.1502696-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-23_05:2019-11-21,2019-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=13
 lowpriorityscore=0 mlxlogscore=810 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911230173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For BPF_PROG_TYPE_TRACING, the bpf_prog's ctx is an array of u64.
This patch borrows the idea from BPF_CALL_x in filter.h to
convert a u64 to the arg type of the traced function.

The new BPF_TRACE_x has an arg to specify the return type of a bpf_prog.
It will be used in the future TCP-ops bpf_prog that may return "void".

The new macros are defined in the new header file "bpf_trace_helpers.h".
It is under selftests/bpf/ for now.  It could be moved to libbpf later
after seeing more upcoming non-tracing use cases.

The tests are changed to use these new macros also.  Hence,
the k[s]u8/16/32/64 are no longer needed and they are removed
from the bpf_helpers.h.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/bpf_helpers.h                   | 13 ---
 .../testing/selftests/bpf/bpf_trace_helpers.h | 58 +++++++++++++
 .../testing/selftests/bpf/progs/fentry_test.c | 72 ++++------------
 .../selftests/bpf/progs/fexit_bpf2bpf.c       | 27 ++----
 .../testing/selftests/bpf/progs/fexit_test.c  | 83 +++++--------------
 tools/testing/selftests/bpf/progs/kfree_skb.c | 43 +++-------
 .../selftests/bpf/progs/test_overhead.c       | 16 ++--
 7 files changed, 125 insertions(+), 187 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_trace_helpers.h

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index c63ab1add126..0c7d28292898 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -44,17 +44,4 @@ enum libbpf_pin_type {
 	LIBBPF_PIN_BY_NAME,
 };
 
-/* The following types should be used by BPF_PROG_TYPE_TRACING program to
- * access kernel function arguments. BPF trampoline and raw tracepoints
- * typecast arguments to 'unsigned long long'.
- */
-typedef int __attribute__((aligned(8))) ks32;
-typedef char __attribute__((aligned(8))) ks8;
-typedef short __attribute__((aligned(8))) ks16;
-typedef long long __attribute__((aligned(8))) ks64;
-typedef unsigned int __attribute__((aligned(8))) ku32;
-typedef unsigned char __attribute__((aligned(8))) ku8;
-typedef unsigned short __attribute__((aligned(8))) ku16;
-typedef unsigned long long __attribute__((aligned(8))) ku64;
-
 #endif
diff --git a/tools/testing/selftests/bpf/bpf_trace_helpers.h b/tools/testing/selftests/bpf/bpf_trace_helpers.h
new file mode 100644
index 000000000000..c76a214a53b0
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_trace_helpers.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __BPF_TRACE_HELPERS_H
+#define __BPF_TRACE_HELPERS_H
+
+#include "bpf_helpers.h"
+
+#define __BPF_MAP_0(i, m, v, ...) v
+#define __BPF_MAP_1(i, m, v, t, a, ...) m(t, a, ctx[i])
+#define __BPF_MAP_2(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_1(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP_3(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_2(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP_4(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_3(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP_5(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_4(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP_6(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_5(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP_7(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_6(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP_8(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_7(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP_9(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_8(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP_10(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_9(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP_11(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_10(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP_12(i, m, v, t, a, ...) m(t, a, ctx[i]), __BPF_MAP_11(i+1, m, v, __VA_ARGS__)
+#define __BPF_MAP(n, ...) __BPF_MAP_##n(0, __VA_ARGS__)
+
+/* BPF sizeof(void *) is always 8, so no need to cast to long first
+ * for ptr to avoid compiler warning.
+ */
+#define __BPF_CAST(t, a, ctx) (t) ctx
+#define __BPF_V void
+#define __BPF_N
+
+#define __BPF_DECL_ARGS(t, a, ctx) t a
+
+#define BPF_TRACE_x(x, sec_name, fname, ret_type, ...)			\
+static __always_inline ret_type						\
+____##fname(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__));	\
+									\
+SEC(sec_name)								\
+ret_type fname(__u64 *ctx)						\
+{									\
+	return ____##fname(__BPF_MAP(x, __BPF_CAST, __BPF_N, __VA_ARGS__));\
+}									\
+									\
+static __always_inline							\
+ret_type ____##fname(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__))
+
+#define BPF_TRACE_0(sec, fname, ...)  BPF_TRACE_x(0, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_1(sec, fname, ...)  BPF_TRACE_x(1, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_2(sec, fname, ...)  BPF_TRACE_x(2, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_3(sec, fname, ...)  BPF_TRACE_x(3, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_4(sec, fname, ...)  BPF_TRACE_x(4, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_5(sec, fname, ...)  BPF_TRACE_x(5, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_6(sec, fname, ...)  BPF_TRACE_x(6, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_7(sec, fname, ...)  BPF_TRACE_x(7, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_8(sec, fname, ...)  BPF_TRACE_x(8, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_9(sec, fname, ...)  BPF_TRACE_x(9, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_10(sec, fname, ...)  BPF_TRACE_x(10, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_11(sec, fname, ...)  BPF_TRACE_x(11, sec, fname, int, __VA_ARGS__)
+#define BPF_TRACE_12(sec, fname, ...)  BPF_TRACE_x(12, sec, fname, int, __VA_ARGS__)
+
+#endif
diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
index 545788bf8d50..d2af9f039df5 100644
--- a/tools/testing/selftests/bpf/progs/fentry_test.c
+++ b/tools/testing/selftests/bpf/progs/fentry_test.c
@@ -2,89 +2,53 @@
 /* Copyright (c) 2019 Facebook */
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_trace_helpers.h"
 
 char _license[] SEC("license") = "GPL";
 
-struct test1 {
-	ks32 a;
-};
 static volatile __u64 test1_result;
-SEC("fentry/bpf_fentry_test1")
-int test1(struct test1 *ctx)
+BPF_TRACE_1("fentry/bpf_fentry_test1", test1, int, a)
 {
-	test1_result = ctx->a == 1;
+	test1_result = a == 1;
 	return 0;
 }
 
-struct test2 {
-	ks32 a;
-	ku64 b;
-};
 static volatile __u64 test2_result;
-SEC("fentry/bpf_fentry_test2")
-int test2(struct test2 *ctx)
+BPF_TRACE_2("fentry/bpf_fentry_test2", test2, int, a, __u64, b)
 {
-	test2_result = ctx->a == 2 && ctx->b == 3;
+	test2_result = a == 2 && b == 3;
 	return 0;
 }
 
-struct test3 {
-	ks8 a;
-	ks32 b;
-	ku64 c;
-};
 static volatile __u64 test3_result;
-SEC("fentry/bpf_fentry_test3")
-int test3(struct test3 *ctx)
+BPF_TRACE_3("fentry/bpf_fentry_test3", test3, char, a, int, b, __u64, c)
 {
-	test3_result = ctx->a == 4 && ctx->b == 5 && ctx->c == 6;
+	test3_result = a == 4 && b == 5 && c == 6;
 	return 0;
 }
 
-struct test4 {
-	void *a;
-	ks8 b;
-	ks32 c;
-	ku64 d;
-};
 static volatile __u64 test4_result;
-SEC("fentry/bpf_fentry_test4")
-int test4(struct test4 *ctx)
+BPF_TRACE_4("fentry/bpf_fentry_test4", test4,
+	    void *, a, char, b, int, c, __u64, d)
 {
-	test4_result = ctx->a == (void *)7 && ctx->b == 8 && ctx->c == 9 &&
-		ctx->d == 10;
+	test4_result = a == (void *)7 && b == 8 && c == 9 && d == 10;
 	return 0;
 }
 
-struct test5 {
-	ku64 a;
-	void *b;
-	ks16 c;
-	ks32 d;
-	ku64 e;
-};
 static volatile __u64 test5_result;
-SEC("fentry/bpf_fentry_test5")
-int test5(struct test5 *ctx)
+BPF_TRACE_5("fentry/bpf_fentry_test5", test5,
+	    __u64, a, void *, b, short, c, int, d, __u64, e)
 {
-	test5_result = ctx->a == 11 && ctx->b == (void *)12 && ctx->c == 13 &&
-		ctx->d == 14 && ctx->e == 15;
+	test5_result = a == 11 && b == (void *)12 && c == 13 && d == 14 &&
+		e == 15;
 	return 0;
 }
 
-struct test6 {
-	ku64 a;
-	void *b;
-	ks16 c;
-	ks32 d;
-	void *e;
-	ks64 f;
-};
 static volatile __u64 test6_result;
-SEC("fentry/bpf_fentry_test6")
-int test6(struct test6 *ctx)
+BPF_TRACE_6("fentry/bpf_fentry_test6", test6,
+	    __u64, a, void *, b, short, c, int, d, void *, e, __u64, f)
 {
-	test6_result = ctx->a == 16 && ctx->b == (void *)17 && ctx->c == 18 &&
-		ctx->d == 19 && ctx->e == (void *)20 && ctx->f == 21;
+	test6_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21;
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
index 981f0474da5a..525d47d7b589 100644
--- a/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
@@ -2,46 +2,37 @@
 /* Copyright (c) 2019 Facebook */
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_trace_helpers.h"
 
 struct sk_buff {
 	unsigned int len;
 };
 
-struct args {
-	struct sk_buff *skb;
-	ks32 ret;
-};
 static volatile __u64 test_result;
-SEC("fexit/test_pkt_access")
-int test_main(struct args *ctx)
+BPF_TRACE_2("fexit/test_pkt_access", test_main,
+	    struct sk_buff *, skb, int, ret)
 {
-	struct sk_buff *skb = ctx->skb;
 	int len;
 
 	__builtin_preserve_access_index(({
 		len = skb->len;
 	}));
-	if (len != 74 || ctx->ret != 0)
+	if (len != 74 || ret != 0)
 		return 0;
 	test_result = 1;
 	return 0;
 }
 
-struct args_subprog1 {
-	struct sk_buff *skb;
-	ks32 ret;
-};
 static volatile __u64 test_result_subprog1;
-SEC("fexit/test_pkt_access_subprog1")
-int test_subprog1(struct args_subprog1 *ctx)
+BPF_TRACE_2("fexit/test_pkt_access_subprog1", test_subprog1,
+	    struct sk_buff *, skb, int, ret)
 {
-	struct sk_buff *skb = ctx->skb;
 	int len;
 
 	__builtin_preserve_access_index(({
 		len = skb->len;
 	}));
-	if (len != 74 || ctx->ret != 148)
+	if (len != 74 || ret != 148)
 		return 0;
 	test_result_subprog1 = 1;
 	return 0;
@@ -62,8 +53,8 @@ int test_subprog1(struct args_subprog1 *ctx)
  * instead of accurate types.
  */
 struct args_subprog2 {
-	ku64 args[5];
-	ku64 ret;
+	__u64 args[5];
+	__u64 ret;
 };
 static volatile __u64 test_result_subprog2;
 SEC("fexit/test_pkt_access_subprog2")
diff --git a/tools/testing/selftests/bpf/progs/fexit_test.c b/tools/testing/selftests/bpf/progs/fexit_test.c
index 8b98b1a51784..2487e98edb34 100644
--- a/tools/testing/selftests/bpf/progs/fexit_test.c
+++ b/tools/testing/selftests/bpf/progs/fexit_test.c
@@ -2,97 +2,56 @@
 /* Copyright (c) 2019 Facebook */
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
+#include "bpf_trace_helpers.h"
 
 char _license[] SEC("license") = "GPL";
 
-struct test1 {
-	ks32 a;
-	ks32 ret;
-};
 static volatile __u64 test1_result;
-SEC("fexit/bpf_fentry_test1")
-int test1(struct test1 *ctx)
+BPF_TRACE_2("fexit/bpf_fentry_test1", test1, int, a, int, ret)
 {
-	test1_result = ctx->a == 1 && ctx->ret == 2;
+	test1_result = a == 1 && ret == 2;
 	return 0;
 }
 
-struct test2 {
-	ks32 a;
-	ku64 b;
-	ks32 ret;
-};
 static volatile __u64 test2_result;
-SEC("fexit/bpf_fentry_test2")
-int test2(struct test2 *ctx)
+BPF_TRACE_3("fexit/bpf_fentry_test2", test2, int, a, __u64, b, int, ret)
 {
-	test2_result = ctx->a == 2 && ctx->b == 3 && ctx->ret == 5;
+	test2_result = a == 2 && b == 3 && ret == 5;
 	return 0;
 }
 
-struct test3 {
-	ks8 a;
-	ks32 b;
-	ku64 c;
-	ks32 ret;
-};
 static volatile __u64 test3_result;
-SEC("fexit/bpf_fentry_test3")
-int test3(struct test3 *ctx)
+BPF_TRACE_4("fexit/bpf_fentry_test3", test3, char, a, int, b, __u64, c, int, ret)
 {
-	test3_result = ctx->a == 4 && ctx->b == 5 && ctx->c == 6 &&
-		ctx->ret == 15;
+	test3_result = a == 4 && b == 5 && c == 6 && ret == 15;
 	return 0;
 }
 
-struct test4 {
-	void *a;
-	ks8 b;
-	ks32 c;
-	ku64 d;
-	ks32 ret;
-};
 static volatile __u64 test4_result;
-SEC("fexit/bpf_fentry_test4")
-int test4(struct test4 *ctx)
+BPF_TRACE_5("fexit/bpf_fentry_test4", test4,
+	    void *, a, char, b, int, c, __u64, d, int, ret)
 {
-	test4_result = ctx->a == (void *)7 && ctx->b == 8 && ctx->c == 9 &&
-		ctx->d == 10 && ctx->ret == 34;
+
+	test4_result = a == (void *)7 && b == 8 && c == 9 && d == 10 &&
+		ret == 34;
 	return 0;
 }
 
-struct test5 {
-	ku64 a;
-	void *b;
-	ks16 c;
-	ks32 d;
-	ku64 e;
-	ks32 ret;
-};
 static volatile __u64 test5_result;
-SEC("fexit/bpf_fentry_test5")
-int test5(struct test5 *ctx)
+BPF_TRACE_6("fexit/bpf_fentry_test5", test5,
+	    __u64, a, void *, b, short, c, int, d, __u64, e, int, ret)
 {
-	test5_result = ctx->a == 11 && ctx->b == (void *)12 && ctx->c == 13 &&
-		ctx->d == 14 && ctx->e == 15 && ctx->ret == 65;
+	test5_result = a == 11 && b == (void *)12 && c == 13 && d == 14 &&
+		e == 15 && ret == 65;
 	return 0;
 }
 
-struct test6 {
-	ku64 a;
-	void *b;
-	ks16 c;
-	ks32 d;
-	void *e;
-	ks64 f;
-	ks32 ret;
-};
 static volatile __u64 test6_result;
-SEC("fexit/bpf_fentry_test6")
-int test6(struct test6 *ctx)
+BPF_TRACE_7("fexit/bpf_fentry_test6", test6,
+	    __u64, a, void *, b, short, c, int, d, void *, e, __u64, f,
+	    int, ret)
 {
-	test6_result = ctx->a == 16 && ctx->b == (void *)17 && ctx->c == 18 &&
-		ctx->d == 19 && ctx->e == (void *)20 && ctx->f == 21 &&
-		ctx->ret == 111;
+	test6_result = a == 16 && b == (void *)17 && c == 18 && d == 19 &&
+		e == (void *)20 && f == 21 && ret == 111;
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/selftests/bpf/progs/kfree_skb.c
index dcc9feac8338..974d6f3bb319 100644
--- a/tools/testing/selftests/bpf/progs/kfree_skb.c
+++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
@@ -4,6 +4,7 @@
 #include <stdbool.h>
 #include "bpf_helpers.h"
 #include "bpf_endian.h"
+#include "bpf_trace_helpers.h"
 
 char _license[] SEC("license") = "GPL";
 struct {
@@ -47,28 +48,18 @@ struct sk_buff {
 	char cb[48];
 };
 
-/* copy arguments from
- * include/trace/events/skb.h:
- * TRACE_EVENT(kfree_skb,
- *         TP_PROTO(struct sk_buff *skb, void *location),
- *
- * into struct below:
- */
-struct trace_kfree_skb {
-	struct sk_buff *skb;
-	void *location;
-};
-
 struct meta {
 	int ifindex;
 	__u32 cb32_0;
 	__u8 cb8_0;
 };
 
-SEC("tp_btf/kfree_skb")
-int trace_kfree_skb(struct trace_kfree_skb *ctx)
+/* TRACE_EVENT(kfree_skb,
+ *         TP_PROTO(struct sk_buff *skb, void *location),
+ */
+BPF_TRACE_2("tp_btf/kfree_skb", trace_kfree_skb,
+	    struct sk_buff *, skb, void *, location)
 {
-	struct sk_buff *skb = ctx->skb;
 	struct net_device *dev;
 	struct callback_head *ptr;
 	void *func;
@@ -123,17 +114,10 @@ static volatile struct {
 	bool fexit_test_ok;
 } result;
 
-struct eth_type_trans_args {
-	struct sk_buff *skb;
-	struct net_device *dev;
-	unsigned short protocol; /* return value available to fexit progs */
-};
-
-SEC("fentry/eth_type_trans")
-int fentry_eth_type_trans(struct eth_type_trans_args *ctx)
+BPF_TRACE_3("fentry/eth_type_trans", fentry_eth_type_trans,
+	    struct sk_buff *, skb, struct net_device *, dev,
+	    unsigned short, protocol)
 {
-	struct sk_buff *skb = ctx->skb;
-	struct net_device *dev = ctx->dev;
 	int len, ifindex;
 
 	__builtin_preserve_access_index(({
@@ -148,11 +132,10 @@ int fentry_eth_type_trans(struct eth_type_trans_args *ctx)
 	return 0;
 }
 
-SEC("fexit/eth_type_trans")
-int fexit_eth_type_trans(struct eth_type_trans_args *ctx)
+BPF_TRACE_3("fexit/eth_type_trans", fexit_eth_type_trans,
+	    struct sk_buff *, skb, struct net_device *, dev,
+	    unsigned short, protocol)
 {
-	struct sk_buff *skb = ctx->skb;
-	struct net_device *dev = ctx->dev;
 	int len, ifindex;
 
 	__builtin_preserve_access_index(({
@@ -163,7 +146,7 @@ int fexit_eth_type_trans(struct eth_type_trans_args *ctx)
 	/* fexit sees packet without L2 header that eth_type_trans should have
 	 * consumed.
 	 */
-	if (len != 60 || ctx->protocol != bpf_htons(0x86dd) || ifindex != 1)
+	if (len != 60 || protocol != bpf_htons(0x86dd) || ifindex != 1)
 		return 0;
 	result.fexit_test_ok = true;
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/test_overhead.c b/tools/testing/selftests/bpf/progs/test_overhead.c
index ef06b2693f96..96c0124a04ba 100644
--- a/tools/testing/selftests/bpf/progs/test_overhead.c
+++ b/tools/testing/selftests/bpf/progs/test_overhead.c
@@ -3,6 +3,7 @@
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
 #include "bpf_tracing.h"
+#include "bpf_trace_helpers.h"
 
 SEC("kprobe/__set_task_comm")
 int prog1(struct pt_regs *ctx)
@@ -22,20 +23,15 @@ int prog3(struct bpf_raw_tracepoint_args *ctx)
 	return 0;
 }
 
-struct __set_task_comm_args {
-	struct task_struct *tsk;
-	const char *buf;
-	ku8 exec;
-};
-
-SEC("fentry/__set_task_comm")
-int prog4(struct __set_task_comm_args *ctx)
+struct task_struct;
+BPF_TRACE_3("fentry/__set_task_comm", prog4,
+	    struct task_struct *, tsk, const char *, buf, __u8, exec)
 {
 	return 0;
 }
 
-SEC("fexit/__set_task_comm")
-int prog5(struct __set_task_comm_args *ctx)
+BPF_TRACE_3("fexit/__set_task_comm", prog5,
+	    struct task_struct *, tsk, const char *, buf, __u8, exec)
 {
 	return 0;
 }
-- 
2.17.1

