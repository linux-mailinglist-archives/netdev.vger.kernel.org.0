Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE8E24A720
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHSTpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:45:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60812 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726983AbgHSTpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:45:35 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07JJgBVj032052
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 12:45:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=RH26o4qdZFUxlQBXJQnDRhxnCi87MbljLR120dLRdkA=;
 b=G8n3/zY8P80AyXPeEasRJudkWLupVG+QSNupr7gsaE8vJzS6WNFvITn8L0pZnf62PSqy
 LD7YDGXlVs569avm7OrMTAij0CDaJJiGqAHr8DF5q4eVSPBwK9hzx8izRtyp478G2GF4
 RdiAcfCDI7dvfkY6BMMYpy5c79Uyghkq+es= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3304jjaayc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 12:45:34 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 12:45:32 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2E94D2EC5DF2; Wed, 19 Aug 2020 12:45:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/5] selftests/bpf: add CO-RE relo test for TYPE_ID_LOCAL/TYPE_ID_TARGET
Date:   Wed, 19 Aug 2020 12:45:17 -0700
Message-ID: <20200819194519.3375898-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200819194519.3375898-1-andriin@fb.com>
References: <20200819194519.3375898-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=25
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for BTF type ID relocations. To allow testing this, enhance
core_relo.c test runner to allow dynamic initialization of test inputs.
If Clang doesn't have necessary support for new functionality, test is
skipped.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 168 +++++++++++++++++-
 .../bpf/progs/btf__core_reloc_type_id.c       |   3 +
 ...tf__core_reloc_type_id___missing_targets.c |   3 +
 .../selftests/bpf/progs/core_reloc_types.h    |  41 +++++
 .../bpf/progs/test_core_reloc_type_based.c    |  14 --
 .../bpf/progs/test_core_reloc_type_id.c       | 113 ++++++++++++
 6 files changed, 323 insertions(+), 19 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_id.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_id___missing_targets.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_typ=
e_id.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/=
testing/selftests/bpf/prog_tests/core_reloc.c
index b775ce0ede41..ad550510ef69 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -3,6 +3,9 @@
 #include "progs/core_reloc_types.h"
 #include <sys/mman.h>
 #include <sys/syscall.h>
+#include <bpf/btf.h>
+
+static int duration =3D 0;
=20
 #define STRUCT_TO_CHAR_PTR(struct_name) (const char *)&(struct struct_na=
me)
=20
@@ -269,6 +272,27 @@
 	.fails =3D true,							\
 }
=20
+#define TYPE_ID_CASE_COMMON(name)					\
+	.case_name =3D #name,						\
+	.bpf_obj_file =3D "test_core_reloc_type_id.o",			\
+	.btf_src_file =3D "btf__core_reloc_" #name ".o"			\
+
+#define TYPE_ID_CASE(name, setup_fn) {					\
+	TYPE_ID_CASE_COMMON(name),					\
+	.output =3D STRUCT_TO_CHAR_PTR(core_reloc_type_id_output) {},	\
+	.output_len =3D sizeof(struct core_reloc_type_id_output),		\
+	.setup =3D setup_fn,						\
+}
+
+#define TYPE_ID_ERR_CASE(name) {					\
+	TYPE_ID_CASE_COMMON(name),					\
+	.fails =3D true,							\
+}
+
+struct core_reloc_test_case;
+
+typedef int (*setup_test_fn)(struct core_reloc_test_case *test);
+
 struct core_reloc_test_case {
 	const char *case_name;
 	const char *bpf_obj_file;
@@ -280,8 +304,136 @@ struct core_reloc_test_case {
 	bool fails;
 	bool relaxed_core_relocs;
 	bool direct_raw_tp;
+	setup_test_fn setup;
 };
=20
+static int find_btf_type(const struct btf *btf, const char *name, __u32 =
kind)
+{
+	int id;
+
+	id =3D btf__find_by_name_kind(btf, name, kind);
+	if (CHECK(id <=3D 0, "find_type_id", "failed to find '%s', kind %d: %d\=
n", name, kind, id))
+		return -1;
+
+	return id;
+}
+
+static int setup_type_id_case_local(struct core_reloc_test_case *test)
+{
+	struct core_reloc_type_id_output *exp =3D (void *)test->output;
+	struct btf *local_btf =3D btf__parse(test->bpf_obj_file, NULL);
+	struct btf *targ_btf =3D btf__parse(test->btf_src_file, NULL);
+	const struct btf_type *t;
+	const char *name;
+	int i;
+
+	if (CHECK(IS_ERR(local_btf), "local_btf", "failed: %ld\n", PTR_ERR(loca=
l_btf)) ||
+	    CHECK(IS_ERR(targ_btf), "targ_btf", "failed: %ld\n", PTR_ERR(targ_b=
tf))) {
+		btf__free(local_btf);
+		btf__free(targ_btf);
+		return -EINVAL;
+	}
+
+	exp->local_anon_struct =3D -1;
+	exp->local_anon_union =3D -1;
+	exp->local_anon_enum =3D -1;
+	exp->local_anon_func_proto_ptr =3D -1;
+	exp->local_anon_void_ptr =3D -1;
+	exp->local_anon_arr =3D -1;
+
+	for (i =3D 1; i <=3D btf__get_nr_types(local_btf); i++)
+	{
+		t =3D btf__type_by_id(local_btf, i);
+		/* we are interested only in anonymous types */
+		if (t->name_off)
+			continue;
+
+		if (btf_is_struct(t) && btf_vlen(t) &&
+		    (name =3D btf__name_by_offset(local_btf, btf_members(t)[0].name_of=
f)) &&
+		    strcmp(name, "marker_field") =3D=3D 0) {
+			exp->local_anon_struct =3D i;
+		} else if (btf_is_union(t) && btf_vlen(t) &&
+			 (name =3D btf__name_by_offset(local_btf, btf_members(t)[0].name_off)=
) &&
+			 strcmp(name, "marker_field") =3D=3D 0) {
+			exp->local_anon_union =3D i;
+		} else if (btf_is_enum(t) && btf_vlen(t) &&
+			 (name =3D btf__name_by_offset(local_btf, btf_enum(t)[0].name_off)) &=
&
+			 strcmp(name, "MARKER_ENUM_VAL") =3D=3D 0) {
+			exp->local_anon_enum =3D i;
+		} else if (btf_is_ptr(t) && (t =3D btf__type_by_id(local_btf, t->type)=
)) {
+			if (btf_is_func_proto(t) && (t =3D btf__type_by_id(local_btf, t->type=
)) &&
+			    btf_is_int(t) && (name =3D btf__name_by_offset(local_btf, t->name=
_off)) &&
+			    strcmp(name, "_Bool") =3D=3D 0) {
+				/* ptr -> func_proto -> _Bool */
+				exp->local_anon_func_proto_ptr =3D i;
+			} else if (btf_is_void(t)) {
+				/* ptr -> void */
+				exp->local_anon_void_ptr =3D i;
+			}
+		} else if (btf_is_array(t) && (t =3D btf__type_by_id(local_btf, btf_ar=
ray(t)->type)) &&
+			   btf_is_int(t) && (name =3D btf__name_by_offset(local_btf, t->name_=
off)) &&
+			   strcmp(name, "_Bool") =3D=3D 0) {
+			/* _Bool[] */
+			exp->local_anon_arr =3D i;
+		}
+	}
+
+	exp->local_struct =3D find_btf_type(local_btf, "a_struct", BTF_KIND_STR=
UCT);
+	exp->local_union =3D find_btf_type(local_btf, "a_union", BTF_KIND_UNION=
);
+	exp->local_enum =3D find_btf_type(local_btf, "an_enum", BTF_KIND_ENUM);
+	exp->local_int =3D find_btf_type(local_btf, "int", BTF_KIND_INT);
+	exp->local_struct_typedef =3D find_btf_type(local_btf, "named_struct_ty=
pedef", BTF_KIND_TYPEDEF);
+	exp->local_func_proto_typedef =3D find_btf_type(local_btf, "func_proto_=
typedef", BTF_KIND_TYPEDEF);
+	exp->local_arr_typedef =3D find_btf_type(local_btf, "arr_typedef", BTF_=
KIND_TYPEDEF);
+
+	btf__free(local_btf);
+	btf__free(targ_btf);
+	return 0;
+}
+
+static int setup_type_id_case_success(struct core_reloc_test_case *test)=
 {
+	struct core_reloc_type_id_output *exp =3D (void *)test->output;
+	struct btf *targ_btf =3D btf__parse(test->btf_src_file, NULL);
+	int err;
+
+	err =3D setup_type_id_case_local(test);
+	if (err)
+		return err;
+
+	targ_btf =3D btf__parse(test->btf_src_file, NULL);
+
+	exp->targ_struct =3D find_btf_type(targ_btf, "a_struct", BTF_KIND_STRUC=
T);
+	exp->targ_union =3D find_btf_type(targ_btf, "a_union", BTF_KIND_UNION);
+	exp->targ_enum =3D find_btf_type(targ_btf, "an_enum", BTF_KIND_ENUM);
+	exp->targ_int =3D find_btf_type(targ_btf, "int", BTF_KIND_INT);
+	exp->targ_struct_typedef =3D find_btf_type(targ_btf, "named_struct_type=
def", BTF_KIND_TYPEDEF);
+	exp->targ_func_proto_typedef =3D find_btf_type(targ_btf, "func_proto_ty=
pedef", BTF_KIND_TYPEDEF);
+	exp->targ_arr_typedef =3D find_btf_type(targ_btf, "arr_typedef", BTF_KI=
ND_TYPEDEF);
+
+	btf__free(targ_btf);
+	return 0;
+}
+
+static int setup_type_id_case_failure(struct core_reloc_test_case *test)
+{
+	struct core_reloc_type_id_output *exp =3D (void *)test->output;
+	int err;
+
+	err =3D setup_type_id_case_local(test);
+	if (err)
+		return err;
+
+	exp->targ_struct =3D 0;
+	exp->targ_union =3D 0;
+	exp->targ_enum =3D 0;
+	exp->targ_int =3D 0;
+	exp->targ_struct_typedef =3D 0;
+	exp->targ_func_proto_typedef =3D 0;
+	exp->targ_arr_typedef =3D 0;
+
+	return 0;
+}
+
 static struct core_reloc_test_case test_cases[] =3D {
 	/* validate we can find kernel image and use its BTF for relocs */
 	{
@@ -530,6 +682,10 @@ static struct core_reloc_test_case test_cases[] =3D =
{
 		.struct_exists =3D 1,
 		.struct_sz =3D sizeof(struct a_struct),
 	}),
+
+	/* BTF_TYPE_ID_LOCAL/BTF_TYPE_ID_TARGET tests */
+	TYPE_ID_CASE(type_id, setup_type_id_case_success),
+	TYPE_ID_CASE(type_id___missing_targets, setup_type_id_case_failure),
 };
=20
 struct data {
@@ -551,7 +707,7 @@ void test_core_reloc(void)
 	struct bpf_object_load_attr load_attr =3D {};
 	struct core_reloc_test_case *test_case;
 	const char *tp_name, *probe_name;
-	int err, duration =3D 0, i, equal;
+	int err, i, equal;
 	struct bpf_link *link =3D NULL;
 	struct bpf_map *data_map;
 	struct bpf_program *prog;
@@ -567,11 +723,13 @@ void test_core_reloc(void)
 		if (!test__start_subtest(test_case->case_name))
 			continue;
=20
-		DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
-			.relaxed_core_relocs =3D test_case->relaxed_core_relocs,
-		);
+		if (test_case->setup) {
+			err =3D test_case->setup(test_case);
+			if (CHECK(err, "test_setup", "test #%d setup failed: %d\n", i, err))
+				continue;
+		}
=20
-		obj =3D bpf_object__open_file(test_case->bpf_obj_file, &opts);
+		obj =3D bpf_object__open_file(test_case->bpf_obj_file, NULL);
 		if (CHECK(IS_ERR(obj), "obj_open", "failed to open '%s': %ld\n",
 			  test_case->bpf_obj_file, PTR_ERR(obj)))
 			continue;
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_type_id.c =
b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_id.c
new file mode 100644
index 000000000000..abbe5bddcefd
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_id.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_type_id x) {}
diff --git a/tools/testing/selftests/bpf/progs/btf__core_reloc_type_id___=
missing_targets.c b/tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_id___missing_targets.c
new file mode 100644
index 000000000000..24e7caf4f013
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/btf__core_reloc_type_id___missing=
_targets.c
@@ -0,0 +1,3 @@
+#include "core_reloc_types.h"
+
+void f(struct core_reloc_type_id___missing_targets x) {}
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools=
/testing/selftests/bpf/progs/core_reloc_types.h
index d998537867a2..10afcc5f219f 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -1034,3 +1034,44 @@ struct core_reloc_type_based___fn_wrong_args {
 	func_proto_typedef___fn_wrong_arg_cnt1 f6;
 	func_proto_typedef___fn_wrong_arg_cnt2 f7;
 };
+
+/*
+ * TYPE ID MAPPING (LOCAL AND TARGET)
+ */
+struct core_reloc_type_id_output {
+	int local_anon_struct;
+	int local_anon_union;
+	int local_anon_enum;
+	int local_anon_func_proto_ptr;
+	int local_anon_void_ptr;
+	int local_anon_arr;
+
+	int local_struct;
+	int local_union;
+	int local_enum;
+	int local_int;
+	int local_struct_typedef;
+	int local_func_proto_typedef;
+	int local_arr_typedef;
+
+	int targ_struct;
+	int targ_union;
+	int targ_enum;
+	int targ_int;
+	int targ_struct_typedef;
+	int targ_func_proto_typedef;
+	int targ_arr_typedef;
+};
+
+struct core_reloc_type_id {
+	struct a_struct f1;
+	union a_union f2;
+	enum an_enum f3;
+	named_struct_typedef f4;
+	func_proto_typedef f5;
+	arr_typedef f6;
+};
+
+struct core_reloc_type_id___missing_targets {
+	/* nothing */
+};
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_type_based=
.c b/tools/testing/selftests/bpf/progs/test_core_reloc_type_based.c
index 6ab259d02dc0..fb60f8195c53 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_type_based.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_type_based.c
@@ -48,20 +48,6 @@ typedef int (*func_proto_typedef)(long);
=20
 typedef char arr_typedef[20];
=20
-struct core_reloc_type_based {
-	struct a_struct f1;
-	union a_union f2;
-	enum an_enum f3;
-	named_struct_typedef f4;
-	anon_struct_typedef f5;
-	struct_ptr_typedef f6;
-	int_typedef f7;
-	enum_typedef f8;
-	void_ptr_typedef f9;
-	func_proto_typedef f10;
-	arr_typedef f11;
-};
-
 struct core_reloc_type_based_output {
 	bool struct_exists;
 	bool union_exists;
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c =
b/tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c
new file mode 100644
index 000000000000..23e6e6bf276c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_type_id.c
@@ -0,0 +1,113 @@
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
+	bool skip;
+} data =3D {};
+
+/* some types are shared with test_core_reloc_type_based.c */
+struct a_struct {
+	int x;
+};
+
+union a_union {
+	int y;
+	int z;
+};
+
+enum an_enum {
+	AN_ENUM_VAL1 =3D 1,
+	AN_ENUM_VAL2 =3D 2,
+	AN_ENUM_VAL3 =3D 3,
+};
+
+typedef struct a_struct named_struct_typedef;
+
+typedef int (*func_proto_typedef)(long);
+
+typedef char arr_typedef[20];
+
+struct core_reloc_type_id_output {
+	int local_anon_struct;
+	int local_anon_union;
+	int local_anon_enum;
+	int local_anon_func_proto_ptr;
+	int local_anon_void_ptr;
+	int local_anon_arr;
+
+	int local_struct;
+	int local_union;
+	int local_enum;
+	int local_int;
+	int local_struct_typedef;
+	int local_func_proto_typedef;
+	int local_arr_typedef;
+
+	int targ_struct;
+	int targ_union;
+	int targ_enum;
+	int targ_int;
+	int targ_struct_typedef;
+	int targ_func_proto_typedef;
+	int targ_arr_typedef;
+};
+
+/* preserve types even if Clang doesn't support built-in */
+struct a_struct t1 =3D {};
+union a_union t2 =3D {};
+enum an_enum t3 =3D 0;
+named_struct_typedef t4 =3D {};
+func_proto_typedef t5 =3D 0;
+arr_typedef t6 =3D {};
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_type_id(void *ctx)
+{
+	/* We use __builtin_btf_type_id() in this tests, but up until the time
+	 * __builtin_preserve_type_info() was added it contained a bug that
+	 * would make this test fail. The bug was fixed with addition of
+	 * __builtin_preserve_type_info(), though, so that's what we are using
+	 * to detect whether this test has to be executed, however strange
+	 * that might look like.
+	 */
+#if __has_builtin(__builtin_preserve_type_info)
+	struct core_reloc_type_id_output *out =3D (void *)&data.out;
+
+	out->local_anon_struct =3D bpf_core_type_id_local(struct { int marker_f=
ield; });
+	out->local_anon_union =3D bpf_core_type_id_local(union { int marker_fie=
ld; });
+	out->local_anon_enum =3D bpf_core_type_id_local(enum { MARKER_ENUM_VAL =
=3D 123 });
+	out->local_anon_func_proto_ptr =3D bpf_core_type_id_local(_Bool(*)(int)=
);
+	out->local_anon_void_ptr =3D bpf_core_type_id_local(void *);
+	out->local_anon_arr =3D bpf_core_type_id_local(_Bool[47]);
+
+	out->local_struct =3D bpf_core_type_id_local(struct a_struct);
+	out->local_union =3D bpf_core_type_id_local(union a_union);
+	out->local_enum =3D bpf_core_type_id_local(enum an_enum);
+	out->local_int =3D bpf_core_type_id_local(int);
+	out->local_struct_typedef =3D bpf_core_type_id_local(named_struct_typed=
ef);
+	out->local_func_proto_typedef =3D bpf_core_type_id_local(func_proto_typ=
edef);
+	out->local_arr_typedef =3D bpf_core_type_id_local(arr_typedef);
+
+	out->targ_struct =3D bpf_core_type_id_kernel(struct a_struct);
+	out->targ_union =3D bpf_core_type_id_kernel(union a_union);
+	out->targ_enum =3D bpf_core_type_id_kernel(enum an_enum);
+	out->targ_int =3D bpf_core_type_id_kernel(int);
+	out->targ_struct_typedef =3D bpf_core_type_id_kernel(named_struct_typed=
ef);
+	out->targ_func_proto_typedef =3D bpf_core_type_id_kernel(func_proto_typ=
edef);
+	out->targ_arr_typedef =3D bpf_core_type_id_kernel(arr_typedef);
+#else
+	data.skip =3D true;
+#endif
+
+	return 0;
+}
--=20
2.24.1

