Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811F7369D7C
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244271AbhDWXib convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 19:38:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12394 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244214AbhDWXg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:36:58 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NNYwVb020108
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 16:36:21 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383nvs5kn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 16:36:21 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 16:36:20 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B9FA42ED5CF6; Fri, 23 Apr 2021 16:36:17 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 4/5] selftests/bpf: fix field existence CO-RE reloc tests
Date:   Fri, 23 Apr 2021 16:30:57 -0700
Message-ID: <20210423233058.3386115-5-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423233058.3386115-1-andrii@kernel.org>
References: <20210423233058.3386115-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 19MKxWxsPHLmHeci4jKOwdzjxdNnE4bO
X-Proofpoint-ORIG-GUID: 19MKxWxsPHLmHeci4jKOwdzjxdNnE4bO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230159
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Negative field existence cases for have a broken assumption that FIELD_EXISTS
CO-RE relo will fail for fields that match the name but have incompatible type
signature. That's not how CO-RE relocations generally behave. Types and fields
that match by name but not by expected type are treated as non-matching
candidates and are skipped. Error later is reported if no matching candidate
was found. That's what happens for most relocations, but existence relocations
(FIELD_EXISTS and TYPE_EXISTS) are more permissive and they are designed to
return 0 or 1, depending if a match is found. This allows to handle
name-conflicting but incompatible types in BPF code easily. Combined with
___flavor suffixes, it's possible to handle pretty much any structural type
changes in kernel within the compiled once BPF source code.

So, long story short, negative field existence test cases are invalid in their
assumptions, so this patch reworks them into a single consolidated positive
case that doesn't match any of the fields.

Fixes: c7566a69695c ("selftests/bpf: Add field existence CO-RE relocs tests")
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 31 ++++++++++++-------
 ...ore_reloc_existence___err_wrong_arr_kind.c |  3 --
 ...loc_existence___err_wrong_arr_value_type.c |  3 --
 ...ore_reloc_existence___err_wrong_int_kind.c |  3 --
 ..._core_reloc_existence___err_wrong_int_sz.c |  3 --
 ...ore_reloc_existence___err_wrong_int_type.c |  3 --
 ..._reloc_existence___err_wrong_struct_type.c |  3 --
 ..._core_reloc_existence___wrong_field_defs.c |  3 ++
 .../selftests/bpf/progs/core_reloc_types.h    | 20 ++----------
 9 files changed, 24 insertions(+), 48 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index d94dcead72e6..385fd7696a2e 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -210,11 +210,6 @@ static int duration = 0;
 	.bpf_obj_file = "test_core_reloc_existence.o",			\
 	.btf_src_file = "btf__core_reloc_" #name ".o"			\
 
-#define FIELD_EXISTS_ERR_CASE(name) {					\
-	FIELD_EXISTS_CASE_COMMON(name),					\
-	.fails = true,							\
-}
-
 #define BITFIELDS_CASE_COMMON(objfile, test_name_prefix,  name)		\
 	.case_name = test_name_prefix#name,				\
 	.bpf_obj_file = objfile,					\
@@ -643,13 +638,25 @@ static struct core_reloc_test_case test_cases[] = {
 		},
 		.output_len = sizeof(struct core_reloc_existence_output),
 	},
-
-	FIELD_EXISTS_ERR_CASE(existence__err_int_sz),
-	FIELD_EXISTS_ERR_CASE(existence__err_int_type),
-	FIELD_EXISTS_ERR_CASE(existence__err_int_kind),
-	FIELD_EXISTS_ERR_CASE(existence__err_arr_kind),
-	FIELD_EXISTS_ERR_CASE(existence__err_arr_value_type),
-	FIELD_EXISTS_ERR_CASE(existence__err_struct_type),
+	{
+		FIELD_EXISTS_CASE_COMMON(existence___wrong_field_defs),
+		.input = STRUCT_TO_CHAR_PTR(core_reloc_existence___wrong_field_defs) {
+		},
+		.input_len = sizeof(struct core_reloc_existence___wrong_field_defs),
+		.output = STRUCT_TO_CHAR_PTR(core_reloc_existence_output) {
+			.a_exists = 0,
+			.b_exists = 0,
+			.c_exists = 0,
+			.arr_exists = 0,
+			.s_exists = 0,
+			.a_value = 0xff000001u,
+			.b_value = 0xff000002u,
+			.c_value = 0xff000003u,
+			.arr_value = 0xff000004u,
+			.s_value = 0xff000005u,
+		},
+		.output_len = sizeof(struct core_reloc_existence_output),
+	},
 
 	/* bitfield relocation checks */
 	BITFIELDS_CASE(bitfields, {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
deleted file mode 100644
index dd0ffa518f36..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_arr_kind x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
deleted file mode 100644
index bc83372088ad..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_arr_value_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
deleted file mode 100644
index 917bec41be08..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_int_kind x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
deleted file mode 100644
index 6ec7e6ec1c91..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_int_sz x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
deleted file mode 100644
index 7bbcacf2b0d1..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_int_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
deleted file mode 100644
index f384dd38ec70..000000000000
--- a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
+++ /dev/null
@@ -1,3 +0,0 @@
-#include "core_reloc_types.h"
-
-void f(struct core_reloc_existence___err_wrong_struct_type x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c
new file mode 100644
index 000000000000..d14b496190c3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_existence___wrong_field_defs x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 9982eb969048..c95c0cabe951 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -700,27 +700,11 @@ struct core_reloc_existence___minimal {
 	int a;
 };
 
-struct core_reloc_existence___err_wrong_int_sz {
-	short a;
-};
-
-struct core_reloc_existence___err_wrong_int_type {
+struct core_reloc_existence___wrong_field_defs {
+	void *a;
 	int b[1];
-};
-
-struct core_reloc_existence___err_wrong_int_kind {
 	struct{ int x; } c;
-};
-
-struct core_reloc_existence___err_wrong_arr_kind {
 	int arr;
-};
-
-struct core_reloc_existence___err_wrong_arr_value_type {
-	short arr[1];
-};
-
-struct core_reloc_existence___err_wrong_struct_type {
 	int s;
 };
 
-- 
2.30.2

