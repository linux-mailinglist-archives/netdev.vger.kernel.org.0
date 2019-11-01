Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09EBEC8C6
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 19:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfKAS7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 14:59:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24520 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727655AbfKAS7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 14:59:39 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1Ix7Tt000525
        for <netdev@vger.kernel.org>; Fri, 1 Nov 2019 11:59:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=aSGcfh6ex9njTDFpSX49uNDWYR2KB1ucdKt2ZQGPr9w=;
 b=Htg9uvJz+9BhiQdo575jh4fUHV4slLzLkzBK4W2S4ol73857yRoKOI+DJ4KMesSfjTW1
 sp6qqFj3eDinoenwclweQUGjQTkA7iB8dDfU9kg3Ckce6oECE8prr+Vpa6GEpkf4WmqC
 SnOuvcuCi4jJtViwgTeXPkYrskd3D8cZ+1o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vyw33rkn7-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 11:59:38 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 1 Nov 2019 11:59:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 97C2B2EC1A58; Fri,  1 Nov 2019 11:59:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 5/5] selftests/bpf: add field size relocation tests
Date:   Fri, 1 Nov 2019 11:59:11 -0700
Message-ID: <20191101185912.594925-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191101185912.594925-1-andriin@fb.com>
References: <20191101185912.594925-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_07:2019-11-01,2019-11-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=67 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1911010172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test verifying correctness and logic of field size relocation support in
libbpf.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 39 ++++++++++++--
 .../bpf/progs/btf__core_reloc_size.c          |  3 ++
 .../progs/btf__core_reloc_size___diff_sz.c    |  3 ++
 .../selftests/bpf/progs/core_reloc_types.h    | 31 +++++++++++
 .../bpf/progs/test_core_reloc_size.c          | 51 +++++++++++++++++++
 5 files changed, 122 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_size.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_size___diff_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_size.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 8b934085c9fd..7a2e2c35738f 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -174,15 +174,11 @@
 	.fails = true,							\
 }
 
-#define EXISTENCE_DATA(struct_name) STRUCT_TO_CHAR_PTR(struct_name) {	\
-	.a = 42,							\
-}
-
 #define EXISTENCE_CASE_COMMON(name)					\
 	.case_name = #name,						\
 	.bpf_obj_file = "test_core_reloc_existence.o",			\
 	.btf_src_file = "btf__core_reloc_" #name ".o",			\
-	.relaxed_core_relocs = true					\
+	.relaxed_core_relocs = true
 
 #define EXISTENCE_ERR_CASE(name) {					\
 	EXISTENCE_CASE_COMMON(name),					\
@@ -208,6 +204,35 @@
 	.fails = true,							\
 }
 
+#define SIZE_CASE_COMMON(name)						\
+	.case_name = #name,						\
+	.bpf_obj_file = "test_core_reloc_size.o",			\
+	.btf_src_file = "btf__core_reloc_" #name ".o",			\
+	.relaxed_core_relocs = true
+
+#define SIZE_OUTPUT_DATA(type)						\
+	STRUCT_TO_CHAR_PTR(core_reloc_size_output) {			\
+		.int_sz = sizeof(((type *)0)->int_field),		\
+		.struct_sz = sizeof(((type *)0)->struct_field),		\
+		.union_sz = sizeof(((type *)0)->union_field),		\
+		.arr_sz = sizeof(((type *)0)->arr_field),		\
+		.arr_elem_sz = sizeof(((type *)0)->arr_field[0]),	\
+		.ptr_sz = sizeof(((type *)0)->ptr_field),		\
+		.enum_sz = sizeof(((type *)0)->enum_field),	\
+	}
+
+#define SIZE_CASE(name) {						\
+	SIZE_CASE_COMMON(name),						\
+	.input_len = 0,							\
+	.output = SIZE_OUTPUT_DATA(struct core_reloc_##name),		\
+	.output_len = sizeof(struct core_reloc_size_output),		\
+}
+
+#define SIZE_ERR_CASE(name) {						\
+	SIZE_CASE_COMMON(name),						\
+	.fails = true,							\
+}
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -405,6 +430,10 @@ static struct core_reloc_test_case test_cases[] = {
 		.ub2 = 0x0812345678FEDCBA,
 	}),
 	BITFIELDS_ERR_CASE(bitfields___err_too_big_bitfield),
+
+	/* size relocation checks */
+	SIZE_CASE(size),
+	SIZE_CASE(size___diff_sz),
 };
 
 struct data {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_size.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_size.c
new file mode 100644
index 000000000000..3c80903da5a4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_size.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_size x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_size___diff_sz.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_size___diff_sz.c
new file mode 100644
index 000000000000..6dbd14436b52
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_size___diff_sz.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_size___diff_sz x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index a5ba3643696b..448199ff9eb8 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -734,3 +734,34 @@ struct core_reloc_bitfields___err_too_big_bitfield {
 	uint32_t	u32;
 	uint32_t	s32;
 } __attribute__((packed)) ;
+
+/*
+ * SIZE
+ */
+struct core_reloc_size_output {
+	int int_sz;
+	int struct_sz;
+	int union_sz;
+	int arr_sz;
+	int arr_elem_sz;
+	int ptr_sz;
+	int enum_sz;
+};
+
+struct core_reloc_size {
+	int int_field;
+	struct { int x; } struct_field;
+	union { int x; } union_field;
+	int arr_field[4];
+	void *ptr_field;
+	enum { VALUE = 123 } enum_field;
+};
+
+struct core_reloc_size___diff_sz {
+	uint64_t int_field;
+	struct { int x; int y; int z; } struct_field;
+	union { int x; char bla[123]; } union_field;
+	char arr_field[10];
+	void *ptr_field;
+	enum { OTHER_VALUE = 0xFFFFFFFFFFFFFFFF } enum_field;
+};
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_size.c b/tools/testing/selftests/bpf/progs/test_core_reloc_size.c
new file mode 100644
index 000000000000..9a92998d9107
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_size.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
+#include "bpf_core_read.h"
+
+char _license[] SEC("license") = "GPL";
+
+static volatile struct data {
+	char in[256];
+	char out[256];
+} data;
+
+struct core_reloc_size_output {
+	int int_sz;
+	int struct_sz;
+	int union_sz;
+	int arr_sz;
+	int arr_elem_sz;
+	int ptr_sz;
+	int enum_sz;
+};
+
+struct core_reloc_size {
+	int int_field;
+	struct { int x; } struct_field;
+	union { int x; } union_field;
+	int arr_field[4];
+	void *ptr_field;
+	enum { VALUE = 123 } enum_field;
+};
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_size(void *ctx)
+{
+	struct core_reloc_size *in = (void *)&data.in;
+	struct core_reloc_size_output *out = (void *)&data.out;
+
+	out->int_sz = bpf_core_field_size(in->int_field);
+	out->struct_sz = bpf_core_field_size(in->struct_field);
+	out->union_sz = bpf_core_field_size(in->union_field);
+	out->arr_sz = bpf_core_field_size(in->arr_field);
+	out->arr_elem_sz = bpf_core_field_size(in->arr_field[0]);
+	out->ptr_sz = bpf_core_field_size(in->ptr_field);
+	out->enum_sz = bpf_core_field_size(in->enum_field);
+
+	return 0;
+}
+
-- 
2.17.1

