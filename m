Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C27A249111
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgHRWj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:39:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43542 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727045AbgHRWjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:39:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IMGO3l002547
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:39:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zJ1E2oTCI9Kp9ovdSrlw9BD1OoqgPzWep1+MuQDpBW4=;
 b=UPG5DCrB5Sb0ey3ckTPw0VMXr2wS3awntnLebr6/LhZDs+ILJIaPrNKLZY8TgRUSHT4u
 DKs5kOBGx1nR6GZhWGRinTKdEAqBjxjeI4IqIDEGeYjfBX7gGnz73E9BTQ1ljBz+g+OZ
 5epDWKXx5JhuU9PpSXTPYFcQ/xHjT1rdr58= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304pawdsd-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:39:45 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 15:39:42 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7F7A62EC5EB9; Tue, 18 Aug 2020 15:39:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 6/9] selftests/bpf: test TYPE_EXISTS and TYPE_SIZE CO-RE relocations
Date:   Tue, 18 Aug 2020 15:39:18 -0700
Message-ID: <20200818223921.2911963-7-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818223921.2911963-1-andriin@fb.com>
References: <20200818223921.2911963-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=8 clxscore=1015
 mlxlogscore=876 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests for TYPE_EXISTS and TYPE_SIZE relocations, testing correctn=
ess
of relocations and handling of type compatiblity/incompatibility.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 103 +++++++--
 .../bpf/progs/btf__core_reloc_type_based.c    |   3 +
 ...btf__core_reloc_type_based___all_missing.c |   3 +
 .../btf__core_reloc_type_based___diff_sz.c    |   3 +
 ...f__core_reloc_type_based___fn_wrong_args.c |   3 +
 .../btf__core_reloc_type_based___incompat.c   |   3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 203 +++++++++++++++++-
 .../bpf/progs/test_core_reloc_type_based.c    | 121 +++++++++++
 8 files changed, 428 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_based.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_based___all_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_based___diff_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_based___fn_wrong_args.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_based___incompat.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_typ=
e_based.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/=
testing/selftests/bpf/prog_tests/core_reloc.c
index 4d650e99be28..04b691cc55c4 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -177,14 +177,13 @@
 	.fails =3D true,							\
 }
=20
-#define EXISTENCE_CASE_COMMON(name)					\
+#define FIELD_EXISTS_CASE_COMMON(name)					\
 	.case_name =3D #name,						\
 	.bpf_obj_file =3D "test_core_reloc_existence.o",			\
-	.btf_src_file =3D "btf__core_reloc_" #name ".o",			\
-	.relaxed_core_relocs =3D true
+	.btf_src_file =3D "btf__core_reloc_" #name ".o"			\
=20
-#define EXISTENCE_ERR_CASE(name) {					\
-	EXISTENCE_CASE_COMMON(name),					\
+#define FIELD_EXISTS_ERR_CASE(name) {					\
+	FIELD_EXISTS_CASE_COMMON(name),					\
 	.fails =3D true,							\
 }
=20
@@ -253,6 +252,23 @@
 	.fails =3D true,							\
 }
=20
+#define TYPE_BASED_CASE_COMMON(name)					\
+	.case_name =3D #name,						\
+	.bpf_obj_file =3D "test_core_reloc_type_based.o",		\
+	.btf_src_file =3D "btf__core_reloc_" #name ".o"			\
+
+#define TYPE_BASED_CASE(name, ...) {					\
+	TYPE_BASED_CASE_COMMON(name),					\
+	.output =3D STRUCT_TO_CHAR_PTR(core_reloc_type_based_output)	\
+			__VA_ARGS__,					\
+	.output_len =3D sizeof(struct core_reloc_type_based_output),	\
+}
+
+#define TYPE_BASED_ERR_CASE(name) {					\
+	TYPE_BASED_CASE_COMMON(name),					\
+	.fails =3D true,							\
+}
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -364,7 +380,7 @@ static struct core_reloc_test_case test_cases[] =3D {
=20
 	/* validate field existence checks */
 	{
-		EXISTENCE_CASE_COMMON(existence),
+		FIELD_EXISTS_CASE_COMMON(existence),
 		.input =3D STRUCT_TO_CHAR_PTR(core_reloc_existence) {
 			.a =3D 1,
 			.b =3D 2,
@@ -388,7 +404,7 @@ static struct core_reloc_test_case test_cases[] =3D {
 		.output_len =3D sizeof(struct core_reloc_existence_output),
 	},
 	{
-		EXISTENCE_CASE_COMMON(existence___minimal),
+		FIELD_EXISTS_CASE_COMMON(existence___minimal),
 		.input =3D STRUCT_TO_CHAR_PTR(core_reloc_existence___minimal) {
 			.a =3D 42,
 		},
@@ -408,12 +424,12 @@ static struct core_reloc_test_case test_cases[] =3D=
 {
 		.output_len =3D sizeof(struct core_reloc_existence_output),
 	},
=20
-	EXISTENCE_ERR_CASE(existence__err_int_sz),
-	EXISTENCE_ERR_CASE(existence__err_int_type),
-	EXISTENCE_ERR_CASE(existence__err_int_kind),
-	EXISTENCE_ERR_CASE(existence__err_arr_kind),
-	EXISTENCE_ERR_CASE(existence__err_arr_value_type),
-	EXISTENCE_ERR_CASE(existence__err_struct_type),
+	FIELD_EXISTS_ERR_CASE(existence__err_int_sz),
+	FIELD_EXISTS_ERR_CASE(existence__err_int_type),
+	FIELD_EXISTS_ERR_CASE(existence__err_int_kind),
+	FIELD_EXISTS_ERR_CASE(existence__err_arr_kind),
+	FIELD_EXISTS_ERR_CASE(existence__err_arr_value_type),
+	FIELD_EXISTS_ERR_CASE(existence__err_struct_type),
=20
 	/* bitfield relocation checks */
 	BITFIELDS_CASE(bitfields, {
@@ -453,6 +469,67 @@ static struct core_reloc_test_case test_cases[] =3D =
{
 	SIZE_CASE(size),
 	SIZE_CASE(size___diff_sz),
 	SIZE_ERR_CASE(size___err_ambiguous),
+
+	/* validate type existence and size relocations */
+	TYPE_BASED_CASE(type_based, {
+		.struct_exists =3D 1,
+		.union_exists =3D 1,
+		.enum_exists =3D 1,
+		.typedef_named_struct_exists =3D 1,
+		.typedef_anon_struct_exists =3D 1,
+		.typedef_struct_ptr_exists =3D 1,
+		.typedef_int_exists =3D 1,
+		.typedef_enum_exists =3D 1,
+		.typedef_void_ptr_exists =3D 1,
+		.typedef_func_proto_exists =3D 1,
+		.typedef_arr_exists =3D 1,
+		.struct_sz =3D sizeof(struct a_struct),
+		.union_sz =3D sizeof(union a_union),
+		.enum_sz =3D sizeof(enum an_enum),
+		.typedef_named_struct_sz =3D sizeof(named_struct_typedef),
+		.typedef_anon_struct_sz =3D sizeof(anon_struct_typedef),
+		.typedef_struct_ptr_sz =3D sizeof(struct_ptr_typedef),
+		.typedef_int_sz =3D sizeof(int_typedef),
+		.typedef_enum_sz =3D sizeof(enum_typedef),
+		.typedef_void_ptr_sz =3D sizeof(void_ptr_typedef),
+		.typedef_func_proto_sz =3D sizeof(func_proto_typedef),
+		.typedef_arr_sz =3D sizeof(arr_typedef),
+	}),
+	TYPE_BASED_CASE(type_based___all_missing, {
+		/* all zeros */
+	}),
+	TYPE_BASED_CASE(type_based___diff_sz, {
+		.struct_exists =3D 1,
+		.union_exists =3D 1,
+		.enum_exists =3D 1,
+		.typedef_named_struct_exists =3D 1,
+		.typedef_anon_struct_exists =3D 1,
+		.typedef_struct_ptr_exists =3D 1,
+		.typedef_int_exists =3D 1,
+		.typedef_enum_exists =3D 1,
+		.typedef_void_ptr_exists =3D 1,
+		.typedef_func_proto_exists =3D 1,
+		.typedef_arr_exists =3D 1,
+		.struct_sz =3D sizeof(struct a_struct___diff_sz),
+		.union_sz =3D sizeof(union a_union___diff_sz),
+		.enum_sz =3D sizeof(enum an_enum___diff_sz),
+		.typedef_named_struct_sz =3D sizeof(named_struct_typedef___diff_sz),
+		.typedef_anon_struct_sz =3D sizeof(anon_struct_typedef___diff_sz),
+		.typedef_struct_ptr_sz =3D sizeof(struct_ptr_typedef___diff_sz),
+		.typedef_int_sz =3D sizeof(int_typedef___diff_sz),
+		.typedef_enum_sz =3D sizeof(enum_typedef___diff_sz),
+		.typedef_void_ptr_sz =3D sizeof(void_ptr_typedef___diff_sz),
+		.typedef_func_proto_sz =3D sizeof(func_proto_typedef___diff_sz),
+		.typedef_arr_sz =3D sizeof(arr_typedef___diff_sz),
+	}),
+	TYPE_BASED_CASE(type_based___incompat, {
+		.enum_exists =3D 1,
+		.enum_sz =3D sizeof(enum an_enum),
+	}),
+	TYPE_BASED_CASE(type_based___fn_wrong_args, {
+		.struct_exists =3D 1,
+		.struct_sz =3D sizeof(struct a_struct),
+	}),
 };
=20
 struct data {
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based=
.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based.c
new file mode 100644
index 000000000000..fc3f69e58c71
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_type_based x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based=
___all_missing.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_type=
_based___all_missing.c
new file mode 100644
index 000000000000..51511648b4ec
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___all_=
missing.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_type_based___all_missing x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based=
___diff_sz.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_bas=
ed___diff_sz.c
new file mode 100644
index 000000000000..67db3dceb279
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___diff=
_sz.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_type_based___diff_sz x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based=
___fn_wrong_args.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_ty=
pe_based___fn_wrong_args.c
new file mode 100644
index 000000000000..b357fc65431d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___fn_w=
rong_args.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_type_based___fn_wrong_args x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based=
___incompat.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_ba=
sed___incompat.c
new file mode 100644
index 000000000000..8ddf20d33d9e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___inco=
mpat.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_type_based___incompat x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools=
/testing/selftests/bpf/progs/core_reloc_types.h
index 3b1126c0bc8f..721c8b2ad6e3 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -652,7 +652,7 @@ struct core_reloc_misc_extensible {
 };
=20
 /*
- * EXISTENCE
+ * FIELD EXISTENCE
  */
 struct core_reloc_existence_output {
 	int a_exists;
@@ -834,3 +834,204 @@ struct core_reloc_size___err_ambiguous2 {
 	void *ptr_field;
 	enum { VALUE___2 =3D 123 } enum_field;
 };
+
+/*
+ * TYPE EXISTENCE & SIZE
+ */
+struct core_reloc_type_based_output {
+	bool struct_exists;
+	bool union_exists;
+	bool enum_exists;
+	bool typedef_named_struct_exists;
+	bool typedef_anon_struct_exists;
+	bool typedef_struct_ptr_exists;
+	bool typedef_int_exists;
+	bool typedef_enum_exists;
+	bool typedef_void_ptr_exists;
+	bool typedef_func_proto_exists;
+	bool typedef_arr_exists;
+
+	int struct_sz;
+	int union_sz;
+	int enum_sz;
+	int typedef_named_struct_sz;
+	int typedef_anon_struct_sz;
+	int typedef_struct_ptr_sz;
+	int typedef_int_sz;
+	int typedef_enum_sz;
+	int typedef_void_ptr_sz;
+	int typedef_func_proto_sz;
+	int typedef_arr_sz;
+};
+
+struct a_struct {
+	int x;
+};
+
+union a_union {
+	int y;
+	int z;
+};
+
+typedef struct a_struct named_struct_typedef;
+
+typedef struct { int x, y, z; } anon_struct_typedef;
+
+typedef struct {
+	int a, b, c;
+} *struct_ptr_typedef;
+
+enum an_enum {
+	AN_ENUM_VAL1 =3D 1,
+	AN_ENUM_VAL2 =3D 2,
+	AN_ENUM_VAL3 =3D 3,
+};
+
+typedef int int_typedef;
+
+typedef enum { TYPEDEF_ENUM_VAL1, TYPEDEF_ENUM_VAL2 } enum_typedef;
+
+typedef void *void_ptr_typedef;
+
+typedef int (*func_proto_typedef)(long);
+
+typedef char arr_typedef[20];
+
+struct core_reloc_type_based {
+	struct a_struct f1;
+	union a_union f2;
+	enum an_enum f3;
+	named_struct_typedef f4;
+	anon_struct_typedef f5;
+	struct_ptr_typedef f6;
+	int_typedef f7;
+	enum_typedef f8;
+	void_ptr_typedef f9;
+	func_proto_typedef f10;
+	arr_typedef f11;
+};
+
+/* no types in target */
+struct core_reloc_type_based___all_missing {
+};
+
+/* different type sizes, extra modifiers, anon vs named enums, etc */
+struct a_struct___diff_sz {
+	long x;
+	int y;
+	char z;
+};
+
+union a_union___diff_sz {
+	char yy;
+	char zz;
+};
+
+typedef struct a_struct___diff_sz named_struct_typedef___diff_sz;
+
+typedef struct { long xx, yy, zzz; } anon_struct_typedef___diff_sz;
+
+typedef struct {
+	char aa[1], bb[2], cc[3];
+} *struct_ptr_typedef___diff_sz;
+
+enum an_enum___diff_sz {
+	AN_ENUM_VAL1___diff_sz =3D 0x123412341234,
+	AN_ENUM_VAL2___diff_sz =3D 2,
+};
+
+typedef unsigned long int_typedef___diff_sz;
+
+typedef enum an_enum___diff_sz enum_typedef___diff_sz;
+
+typedef const void * const void_ptr_typedef___diff_sz;
+
+typedef int_typedef___diff_sz (*func_proto_typedef___diff_sz)(char);
+
+typedef int arr_typedef___diff_sz[2];
+
+struct core_reloc_type_based___diff_sz {
+	struct a_struct___diff_sz f1;
+	union a_union___diff_sz f2;
+	enum an_enum___diff_sz f3;
+	named_struct_typedef___diff_sz f4;
+	anon_struct_typedef___diff_sz f5;
+	struct_ptr_typedef___diff_sz f6;
+	int_typedef___diff_sz f7;
+	enum_typedef___diff_sz f8;
+	void_ptr_typedef___diff_sz f9;
+	func_proto_typedef___diff_sz f10;
+	arr_typedef___diff_sz f11;
+};
+
+/* incompatibilities between target and local types */
+union a_struct___incompat { /* union instead of struct */
+	int x;
+};
+
+struct a_union___incompat { /* struct instead of union */
+	int y;
+	int z;
+};
+
+/* typedef to union, not to struct */
+typedef union a_struct___incompat named_struct_typedef___incompat;
+
+/* typedef to void pointer, instead of struct */
+typedef void *anon_struct_typedef___incompat;
+
+/* extra pointer indirection */
+typedef struct {
+	int a, b, c;
+} **struct_ptr_typedef___incompat;
+
+/* typedef of a struct with int, instead of int */
+typedef struct { int x; } int_typedef___incompat;
+
+/* typedef to func_proto, instead of enum */
+typedef int (*enum_typedef___incompat)(void);
+
+/* pointer to char instead of void */
+typedef char *void_ptr_typedef___incompat;
+
+/* void return type instead of int */
+typedef void (*func_proto_typedef___incompat)(long);
+
+/* multi-dimensional array instead of a single-dimensional */
+typedef int arr_typedef___incompat[20][2];
+
+struct core_reloc_type_based___incompat {
+	union a_struct___incompat f1;
+	struct a_union___incompat f2;
+	/* the only valid one is enum, to check that something still succeeds *=
/
+	enum an_enum f3;
+	named_struct_typedef___incompat f4;
+	anon_struct_typedef___incompat f5;
+	struct_ptr_typedef___incompat f6;
+	int_typedef___incompat f7;
+	enum_typedef___incompat f8;
+	void_ptr_typedef___incompat f9;
+	func_proto_typedef___incompat f10;
+	arr_typedef___incompat f11;
+};
+
+/* func_proto with incompatible signature */
+typedef void (*func_proto_typedef___fn_wrong_ret1)(long);
+typedef int * (*func_proto_typedef___fn_wrong_ret2)(long);
+typedef struct { int x; } int_struct_typedef;
+typedef int_struct_typedef (*func_proto_typedef___fn_wrong_ret3)(long);
+typedef int (*func_proto_typedef___fn_wrong_arg)(void *);
+typedef int (*func_proto_typedef___fn_wrong_arg_cnt1)(long, long);
+typedef int (*func_proto_typedef___fn_wrong_arg_cnt2)(void);
+
+struct core_reloc_type_based___fn_wrong_args {
+	/* one valid type to make sure relos still work */
+	struct a_struct f1;
+	func_proto_typedef___fn_wrong_ret1 f2;
+	func_proto_typedef___fn_wrong_ret2 f3;
+	func_proto_typedef___fn_wrong_ret3 f4;
+	func_proto_typedef___fn_wrong_arg f5;
+	func_proto_typedef___fn_wrong_arg_cnt1 f6;
+	func_proto_typedef___fn_wrong_arg_cnt2 f7;
+};
+
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_type_based=
.c b/tools/testing/selftests/bpf/progs/test_core_reloc_type_based.c
new file mode 100644
index 000000000000..0c0fabcda691
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_type_based.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct {
+	char in[256];
+	char out[256];
+} data =3D {};
+
+struct a_struct {
+	int x;
+};
+
+union a_union {
+	int y;
+	int z;
+};
+
+typedef struct a_struct named_struct_typedef;
+
+typedef struct { int x, y, z; } anon_struct_typedef;
+
+typedef struct {
+	int a, b, c;
+} *struct_ptr_typedef;
+
+enum an_enum {
+	AN_ENUM_VAL1 =3D 1,
+	AN_ENUM_VAL2 =3D 2,
+	AN_ENUM_VAL3 =3D 3,
+};
+
+typedef int int_typedef;
+
+typedef enum { TYPEDEF_ENUM_VAL1, TYPEDEF_ENUM_VAL2 } enum_typedef;
+
+typedef void *void_ptr_typedef;
+
+typedef int (*func_proto_typedef)(long);
+
+typedef char arr_typedef[20];
+
+struct core_reloc_type_based {
+	struct a_struct f1;
+	union a_union f2;
+	enum an_enum f3;
+	named_struct_typedef f4;
+	anon_struct_typedef f5;
+	struct_ptr_typedef f6;
+	int_typedef f7;
+	enum_typedef f8;
+	void_ptr_typedef f9;
+	func_proto_typedef f10;
+	arr_typedef f11;
+};
+
+struct core_reloc_type_based_output {
+	bool struct_exists;
+	bool union_exists;
+	bool enum_exists;
+	bool typedef_named_struct_exists;
+	bool typedef_anon_struct_exists;
+	bool typedef_struct_ptr_exists;
+	bool typedef_int_exists;
+	bool typedef_enum_exists;
+	bool typedef_void_ptr_exists;
+	bool typedef_func_proto_exists;
+	bool typedef_arr_exists;
+
+	int struct_sz;
+	int union_sz;
+	int enum_sz;
+	int typedef_named_struct_sz;
+	int typedef_anon_struct_sz;
+	int typedef_struct_ptr_sz;
+	int typedef_int_sz;
+	int typedef_enum_sz;
+	int typedef_void_ptr_sz;
+	int typedef_func_proto_sz;
+	int typedef_arr_sz;
+};
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_type_based(void *ctx)
+{
+	struct core_reloc_type_based_output *out =3D (void *)&data.out;
+
+	out->struct_exists =3D bpf_core_type_exists(struct a_struct);
+	out->union_exists =3D bpf_core_type_exists(union a_union);
+	out->enum_exists =3D bpf_core_type_exists(enum an_enum);
+	out->typedef_named_struct_exists =3D bpf_core_type_exists(named_struct_=
typedef);
+	out->typedef_anon_struct_exists =3D bpf_core_type_exists(anon_struct_ty=
pedef);
+	out->typedef_struct_ptr_exists =3D bpf_core_type_exists(struct_ptr_type=
def);
+	out->typedef_int_exists =3D bpf_core_type_exists(int_typedef);
+	out->typedef_enum_exists =3D bpf_core_type_exists(enum_typedef);
+	out->typedef_void_ptr_exists =3D bpf_core_type_exists(void_ptr_typedef)=
;
+	out->typedef_func_proto_exists =3D bpf_core_type_exists(func_proto_type=
def);
+	out->typedef_arr_exists =3D bpf_core_type_exists(arr_typedef);
+
+	out->struct_sz =3D bpf_core_type_size(struct a_struct);
+	out->union_sz =3D bpf_core_type_size(union a_union);
+	out->enum_sz =3D bpf_core_type_size(enum an_enum);
+	out->typedef_named_struct_sz =3D bpf_core_type_size(named_struct_typede=
f);
+	out->typedef_anon_struct_sz =3D bpf_core_type_size(anon_struct_typedef)=
;
+	out->typedef_struct_ptr_sz =3D bpf_core_type_size(struct_ptr_typedef);
+	out->typedef_int_sz =3D bpf_core_type_size(int_typedef);
+	out->typedef_enum_sz =3D bpf_core_type_size(enum_typedef);
+	out->typedef_void_ptr_sz =3D bpf_core_type_size(void_ptr_typedef);
+	out->typedef_func_proto_sz =3D bpf_core_type_size(func_proto_typedef);
+	out->typedef_arr_sz =3D bpf_core_type_size(arr_typedef);
+
+	return 0;
+}
+
--=20
2.24.1

