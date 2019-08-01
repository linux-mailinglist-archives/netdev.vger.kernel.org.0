Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF8C7D5C5
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 08:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbfHAGsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 02:48:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6026 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730412AbfHAGsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 02:48:30 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x716ibL8027029
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 23:48:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=ZQ+raIrs4D8jBUprYrDiBMFlYf6lnHcE6sPIhj3felY=;
 b=YAab16SM4Bx2kV4xI7PfYmXt+2yhpCxvagRv1tYSO6dxidrBB1ZCq2u76V0v3SIkFahs
 jO190Lsv5aetrRjspnL0FCxVd+ElQTeSIJNZfuuCuCvBQQQZ6gF5Y2fAm97ESVWfJLdW
 XaQuKXu5BwPs8w/sUm0kQ1p75t1flj4tIUQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u3h7whug7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 23:48:29 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 23:48:28 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id A03EF861665; Wed, 31 Jul 2019 23:48:27 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>, <songliubraving@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 07/12] selftests/bpf: add CO-RE relocs array tests
Date:   Wed, 31 Jul 2019 23:47:58 -0700
Message-ID: <20190801064803.2519675-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190801064803.2519675-1-andriin@fb.com>
References: <20190801064803.2519675-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-01_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=67 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=673 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908010067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for various array handling/relocation scenarios.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 41 ++++++++++
 .../bpf/progs/btf__core_reloc_arrays.c        |  3 +
 .../btf__core_reloc_arrays___diff_arr_dim.c   |  3 +
 ...btf__core_reloc_arrays___diff_arr_val_sz.c |  3 +
 .../btf__core_reloc_arrays___err_non_array.c  |  3 +
 ...btf__core_reloc_arrays___err_too_shallow.c |  3 +
 .../btf__core_reloc_arrays___err_too_small.c  |  3 +
 ..._core_reloc_arrays___err_wrong_val_type1.c |  3 +
 ..._core_reloc_arrays___err_wrong_val_type2.c |  3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 81 +++++++++++++++++++
 .../bpf/progs/test_core_reloc_arrays.c        | 55 +++++++++++++
 11 files changed, 201 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_dim.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_val_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_non_array.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_shallow.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_small.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 226c5af28d6b..13e1aaeb1c99 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -51,6 +51,36 @@
 	.fails = true,							\
 }
 
+#define ARRAYS_DATA(struct_name) STRUCT_TO_CHAR_PTR(struct_name) {	\
+	.a = { [2] = 1 },						\
+	.b = { [1] = { [2] = { [3] = 2 } } },				\
+	.c = { [1] = { .c =  3 } },					\
+	.d = { [0] = { [0] = { .d = 4 } } },				\
+}
+
+#define ARRAYS_CASE_COMMON(name)					\
+	.case_name = #name,						\
+	.bpf_obj_file = "test_core_reloc_arrays.o",			\
+	.btf_src_file = "btf__core_reloc_" #name ".o"
+
+#define ARRAYS_CASE(name) {						\
+	ARRAYS_CASE_COMMON(name),					\
+	.input = ARRAYS_DATA(core_reloc_##name),			\
+	.input_len = sizeof(struct core_reloc_##name),			\
+	.output = STRUCT_TO_CHAR_PTR(core_reloc_arrays_output) {	\
+		.a2   = 1,						\
+		.b123 = 2,						\
+		.c1c  = 3,						\
+		.d00d = 4,						\
+	},								\
+	.output_len = sizeof(struct core_reloc_arrays_output)		\
+}
+
+#define ARRAYS_ERR_CASE(name) {						\
+	ARRAYS_CASE_COMMON(name),					\
+	.fails = true,							\
+}
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -96,6 +126,17 @@ static struct core_reloc_test_case test_cases[] = {
 	NESTING_ERR_CASE(nesting___err_dup_incompat_types),
 	NESTING_ERR_CASE(nesting___err_partial_match_dups),
 	NESTING_ERR_CASE(nesting___err_too_deep),
+
+	/* various array access relocation scenarios */
+	ARRAYS_CASE(arrays),
+	ARRAYS_CASE(arrays___diff_arr_dim),
+	ARRAYS_CASE(arrays___diff_arr_val_sz),
+
+	ARRAYS_ERR_CASE(arrays___err_too_small),
+	ARRAYS_ERR_CASE(arrays___err_too_shallow),
+	ARRAYS_ERR_CASE(arrays___err_non_array),
+	ARRAYS_ERR_CASE(arrays___err_wrong_val_type1),
+	ARRAYS_ERR_CASE(arrays___err_wrong_val_type2),
 };
 
 struct data {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays.c
new file mode 100644
index 000000000000..018ed7fbba3a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_dim.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_dim.c
new file mode 100644
index 000000000000..13d662c57014
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_dim.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___diff_arr_dim x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_val_sz.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_val_sz.c
new file mode 100644
index 000000000000..a351f418c85d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_val_sz.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___diff_arr_val_sz x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_non_array.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_non_array.c
new file mode 100644
index 000000000000..a8735009becc
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_non_array.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___err_non_array x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_shallow.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_shallow.c
new file mode 100644
index 000000000000..2a67c28b1e75
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_shallow.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___err_too_shallow x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_small.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_small.c
new file mode 100644
index 000000000000..1142c08c925f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_small.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___err_too_small x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
new file mode 100644
index 000000000000..795a5b729176
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___err_wrong_val_type1 x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
new file mode 100644
index 000000000000..3af74b837c4d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_arrays___err_wrong_val_type2 x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 340ee2bcd463..45de7986ea2e 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -306,3 +306,84 @@ struct core_reloc_nesting___err_too_deep {
 		} b;
 	} b;
 };
+
+/*
+ * ARRAYS
+ */
+struct core_reloc_arrays_output {
+	int a2;
+	char b123;
+	int c1c;
+	int d00d;
+};
+
+struct core_reloc_arrays_substruct {
+	int c;
+	int d;
+};
+
+struct core_reloc_arrays {
+	int a[5];
+	char b[2][3][4];
+	struct core_reloc_arrays_substruct c[3];
+	struct core_reloc_arrays_substruct d[1][2];
+};
+
+/* bigger array dimensions */
+struct core_reloc_arrays___diff_arr_dim {
+	int a[7];
+	char b[3][4][5];
+	struct core_reloc_arrays_substruct c[4];
+	struct core_reloc_arrays_substruct d[2][3];
+};
+
+/* different size of array's value (struct) */
+struct core_reloc_arrays___diff_arr_val_sz {
+	int a[5];
+	char b[2][3][4];
+	struct {
+		int __padding1;
+		int c;
+		int __padding2;
+	} c[3];
+	struct {
+		int __padding1;
+		int d;
+		int __padding2;
+	} d[1][2];
+};
+
+struct core_reloc_arrays___err_too_small {
+	int a[2]; /* this one is too small */
+	char b[2][3][4];
+	struct core_reloc_arrays_substruct c[3];
+	struct core_reloc_arrays_substruct d[1][2];
+};
+
+struct core_reloc_arrays___err_too_shallow {
+	int a[5];
+	char b[2][3]; /* this one lacks one dimension */
+	struct core_reloc_arrays_substruct c[3];
+	struct core_reloc_arrays_substruct d[1][2];
+};
+
+struct core_reloc_arrays___err_non_array {
+	int a; /* not an array */
+	char b[2][3][4];
+	struct core_reloc_arrays_substruct c[3];
+	struct core_reloc_arrays_substruct d[1][2];
+};
+
+struct core_reloc_arrays___err_wrong_val_type1 {
+	char a[5]; /* char instead of int */
+	char b[2][3][4];
+	struct core_reloc_arrays_substruct c[3];
+	struct core_reloc_arrays_substruct d[1][2];
+};
+
+struct core_reloc_arrays___err_wrong_val_type2 {
+	int a[5];
+	char b[2][3][4];
+	int c[3]; /* value is not a struct */
+	struct core_reloc_arrays_substruct d[1][2];
+};
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
new file mode 100644
index 000000000000..bf67f0fdf743
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+
+static volatile struct data {
+	char in[256];
+	char out[256];
+} data;
+
+struct core_reloc_arrays_output {
+	int a2;
+	char b123;
+	int c1c;
+	int d00d;
+};
+
+struct core_reloc_arrays_substruct {
+	int c;
+	int d;
+};
+
+struct core_reloc_arrays {
+	int a[5];
+	char b[2][3][4];
+	struct core_reloc_arrays_substruct c[3];
+	struct core_reloc_arrays_substruct d[1][2];
+};
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_arrays(void *ctx)
+{
+	struct core_reloc_arrays *in = (void *)&data.in;
+	struct core_reloc_arrays_output *out = (void *)&data.out;
+
+	/* in->a[2] */
+	if (BPF_CORE_READ(&out->a2, &in->a[2]))
+		return 1;
+	/* in->b[1][2][3] */
+	if (BPF_CORE_READ(&out->b123, &in->b[1][2][3]))
+		return 1;
+	/* in->c[1].c */
+	if (BPF_CORE_READ(&out->c1c, &in->c[1].c))
+		return 1;
+	/* in->d[0][0].d */
+	if (BPF_CORE_READ(&out->d00d, &in->d[0][0].d))
+		return 1;
+
+	return 0;
+}
+
-- 
2.17.1

