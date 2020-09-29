Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD76A27BAA5
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 04:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgI2CFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 22:05:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49884 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727325AbgI2CFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 22:05:51 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T25aL5001216
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 19:05:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=WpeBaO2TQjXVrOY09tns9QISpIUGmmqBMKrZpDEj08U=;
 b=W/JyZzeq0gGR+0xQKs6SaYTjZGLMWPUToRb2tVOXQerY2xW0VQV05bWTtqvGdB2n6fpB
 NoFz2xzNb3NodbcrbwHff2qxemlE+gUg/8ttMHC1nHgjpC8oIyBK/qrit/ezuB7JXp/B
 B6ivGnLNywPvllDIYO2YRDmsncqEJYo0KHI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33t35n2m6e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 19:05:49 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 28 Sep 2020 19:05:47 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3EF9C2EC773C; Mon, 28 Sep 2020 19:05:43 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH v3 bpf-next 3/3] selftests/bpf: test BTF writing APIs
Date:   Mon, 28 Sep 2020 19:05:32 -0700
Message-ID: <20200929020533.711288-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200929020533.711288-1-andriin@fb.com>
References: <20200929020533.711288-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-28,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 suspectscore=25 impostorscore=0
 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests for BTF writer APIs.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c                           |   8 +-
 .../selftests/bpf/prog_tests/btf_write.c      | 278 ++++++++++++++++++
 2 files changed, 282 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_write.c

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 2d0b1e12f50e..c25f49fad5a6 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -31,10 +31,10 @@ struct btf {
 	__u32 raw_size;
=20
 	/*
-	 * When BTF is loaded from ELF or raw memory it is stored
-	 * in contiguous memory block, pointed to by raw_data pointer, and
-	 * hdr, types_data, and strs_data point inside that memory region to
-	 * respective parts of BTF representation:
+	 * When BTF is loaded from an ELF or raw memory it is stored
+	 * in a contiguous memory block. The hdr, type_data, and, strs_data
+	 * point inside that memory region to their respective parts of BTF
+	 * representation:
 	 *
 	 * +--------------------------------+
 	 * |  Header  |  Types  |  Strings  |
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_write.c b/tools/t=
esting/selftests/bpf/prog_tests/btf_write.c
new file mode 100644
index 000000000000..88dce2cfa79b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/btf_write.c
@@ -0,0 +1,278 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <test_progs.h>
+#include <bpf/btf.h>
+
+#define ASSERT_EQ(actual, expected, name) ({				\
+	typeof(actual) ___act =3D (actual);				\
+	typeof(expected) ___exp =3D (expected);				\
+	bool ___ok =3D ___act =3D=3D ___exp;					\
+	CHECK(!___ok, (name),						\
+	      "unexpected %s: actual %lld !=3D expected %lld\n",		\
+	      (name), (long long)(___act), (long long)(___exp));	\
+	___ok;								\
+})
+
+#define ASSERT_STREQ(actual, expected, name) ({				\
+	const char *___act =3D actual;					\
+	const char *___exp =3D expected;					\
+	bool ___ok =3D strcmp(___act, ___exp) =3D=3D 0;			\
+	CHECK(!___ok, (name),						\
+	      "unexpected %s: actual '%s' !=3D expected '%s'\n",		\
+	      (name), ___act, ___exp);					\
+	___ok;								\
+})
+
+#define ASSERT_OK(res, name) ({						\
+	long long ___res =3D (res);					\
+	bool ___ok =3D ___res =3D=3D 0;					\
+	CHECK(!___ok, (name), "unexpected error: %lld\n", ___res);	\
+	___ok;								\
+})
+
+#define ASSERT_ERR(res, name) ({					\
+	long long ___res =3D (res);					\
+	bool ___ok =3D ___res < 0;					\
+	CHECK(!___ok, (name), "unexpected success: %lld\n", ___res);	\
+	___ok;								\
+})
+
+static int duration =3D 0;
+
+void test_btf_write() {
+	const struct btf_var_secinfo *vi;
+	const struct btf_type *t;
+	const struct btf_member *m;
+	const struct btf_enum *v;
+	const struct btf_param *p;
+	struct btf *btf;
+	int id, err, str_off;
+
+	btf =3D btf__new_empty();
+	if (CHECK(IS_ERR(btf), "new_empty", "failed: %ld\n", PTR_ERR(btf)))
+		return;
+
+	str_off =3D btf__find_str(btf, "int");
+	ASSERT_EQ(str_off, -ENOENT, "int_str_missing_off");
+
+	str_off =3D btf__add_str(btf, "int");
+	ASSERT_EQ(str_off, 1, "int_str_off");
+
+	str_off =3D btf__find_str(btf, "int");
+	ASSERT_EQ(str_off, 1, "int_str_found_off");
+
+	/* BTF_KIND_INT */
+	id =3D btf__add_int(btf, "int", 4,  BTF_INT_SIGNED);
+	ASSERT_EQ(id, 1, "int_id");
+
+	t =3D btf__type_by_id(btf, 1);
+	/* should re-use previously added "int" string */
+	ASSERT_EQ(t->name_off, str_off, "int_name_off");
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "int", "int_name");
+	ASSERT_EQ(btf_kind(t), BTF_KIND_INT, "int_kind");
+	ASSERT_EQ(t->size, 4, "int_sz");
+	ASSERT_EQ(btf_int_encoding(t), BTF_INT_SIGNED, "int_enc");
+	ASSERT_EQ(btf_int_bits(t), 32, "int_bits");
+
+	/* invalid int size */
+	id =3D btf__add_int(btf, "bad sz int", 7, 0);
+	ASSERT_ERR(id, "int_bad_sz");
+	/* invalid encoding */
+	id =3D btf__add_int(btf, "bad enc int", 4, 123);
+	ASSERT_ERR(id, "int_bad_enc");
+	/* NULL name */
+	id =3D btf__add_int(btf, NULL, 4, 0);
+	ASSERT_ERR(id, "int_bad_null_name");
+	/* empty name */
+	id =3D btf__add_int(btf, "", 4, 0);
+	ASSERT_ERR(id, "int_bad_empty_name");
+
+	/* PTR/CONST/VOLATILE/RESTRICT */
+	id =3D btf__add_ptr(btf, 1);
+	ASSERT_EQ(id, 2, "ptr_id");
+	t =3D btf__type_by_id(btf, 2);
+	ASSERT_EQ(btf_kind(t), BTF_KIND_PTR, "ptr_kind");
+	ASSERT_EQ(t->type, 1, "ptr_type");
+
+	id =3D btf__add_const(btf, 5); /* points forward to restrict */
+	ASSERT_EQ(id, 3, "const_id");
+	t =3D btf__type_by_id(btf, 3);
+	ASSERT_EQ(btf_kind(t), BTF_KIND_CONST, "const_kind");
+	ASSERT_EQ(t->type, 5, "const_type");
+
+	id =3D btf__add_volatile(btf, 3);
+	ASSERT_EQ(id, 4, "volatile_id");
+	t =3D btf__type_by_id(btf, 4);
+	ASSERT_EQ(btf_kind(t), BTF_KIND_VOLATILE, "volatile_kind");
+	ASSERT_EQ(t->type, 3, "volatile_type");
+
+	id =3D btf__add_restrict(btf, 4);
+	ASSERT_EQ(id, 5, "restrict_id");
+	t =3D btf__type_by_id(btf, 5);
+	ASSERT_EQ(btf_kind(t), BTF_KIND_RESTRICT, "restrict_kind");
+	ASSERT_EQ(t->type, 4, "restrict_type");
+
+	/* ARRAY */
+	id =3D btf__add_array(btf, 1, 2, 10); /* int *[10] */
+	ASSERT_EQ(id, 6, "array_id");
+	t =3D btf__type_by_id(btf, 6);
+	ASSERT_EQ(btf_kind(t), BTF_KIND_ARRAY, "array_kind");
+	ASSERT_EQ(btf_array(t)->index_type, 1, "array_index_type");
+	ASSERT_EQ(btf_array(t)->type, 2, "array_elem_type");
+	ASSERT_EQ(btf_array(t)->nelems, 10, "array_nelems");
+
+	/* STRUCT */
+	err =3D btf__add_field(btf, "field", 1, 0, 0);
+	ASSERT_ERR(err, "no_struct_field");
+	id =3D btf__add_struct(btf, "s1", 8);
+	ASSERT_EQ(id, 7, "struct_id");
+	err =3D btf__add_field(btf, "f1", 1, 0, 0);
+	ASSERT_OK(err, "f1_res");
+	err =3D btf__add_field(btf, "f2", 1, 32, 16);
+	ASSERT_OK(err, "f2_res");
+
+	t =3D btf__type_by_id(btf, 7);
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "s1", "struct_name")=
;
+	ASSERT_EQ(btf_kind(t), BTF_KIND_STRUCT, "struct_kind");
+	ASSERT_EQ(btf_vlen(t), 2, "struct_vlen");
+	ASSERT_EQ(btf_kflag(t), true, "struct_kflag");
+	ASSERT_EQ(t->size, 8, "struct_sz");
+	m =3D btf_members(t) + 0;
+	ASSERT_STREQ(btf__str_by_offset(btf, m->name_off), "f1", "f1_name");
+	ASSERT_EQ(m->type, 1, "f1_type");
+	ASSERT_EQ(btf_member_bit_offset(t, 0), 0, "f1_bit_off");
+	ASSERT_EQ(btf_member_bitfield_size(t, 0), 0, "f1_bit_sz");
+	m =3D btf_members(t) + 1;
+	ASSERT_STREQ(btf__str_by_offset(btf, m->name_off), "f2", "f2_name");
+	ASSERT_EQ(m->type, 1, "f2_type");
+	ASSERT_EQ(btf_member_bit_offset(t, 1), 32, "f2_bit_off");
+	ASSERT_EQ(btf_member_bitfield_size(t, 1), 16, "f2_bit_sz");
+
+	/* UNION */
+	id =3D btf__add_union(btf, "u1", 8);
+	ASSERT_EQ(id, 8, "union_id");
+
+	/* invalid, non-zero offset */
+	err =3D btf__add_field(btf, "field", 1, 1, 0);
+	ASSERT_ERR(err, "no_struct_field");
+
+	err =3D btf__add_field(btf, "f1", 1, 0, 16);
+	ASSERT_OK(err, "f1_res");
+
+	t =3D btf__type_by_id(btf, 8);
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "u1", "union_name");
+	ASSERT_EQ(btf_kind(t), BTF_KIND_UNION, "union_kind");
+	ASSERT_EQ(btf_vlen(t), 1, "union_vlen");
+	ASSERT_EQ(btf_kflag(t), true, "union_kflag");
+	ASSERT_EQ(t->size, 8, "union_sz");
+	m =3D btf_members(t) + 0;
+	ASSERT_STREQ(btf__str_by_offset(btf, m->name_off), "f1", "f1_name");
+	ASSERT_EQ(m->type, 1, "f1_type");
+	ASSERT_EQ(btf_member_bit_offset(t, 0), 0, "f1_bit_off");
+	ASSERT_EQ(btf_member_bitfield_size(t, 0), 16, "f1_bit_sz");
+
+	/* ENUM */
+	id =3D btf__add_enum(btf, "e1", 4);
+	ASSERT_EQ(id, 9, "enum_id");
+	err =3D btf__add_enum_value(btf, "v1", 1);
+	ASSERT_OK(err, "v1_res");
+	err =3D btf__add_enum_value(btf, "v2", 2);
+	ASSERT_OK(err, "v2_res");
+
+	t =3D btf__type_by_id(btf, 9);
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "e1", "enum_name");
+	ASSERT_EQ(btf_kind(t), BTF_KIND_ENUM, "enum_kind");
+	ASSERT_EQ(btf_vlen(t), 2, "enum_vlen");
+	ASSERT_EQ(t->size, 4, "enum_sz");
+	v =3D btf_enum(t) + 0;
+	ASSERT_STREQ(btf__str_by_offset(btf, v->name_off), "v1", "v1_name");
+	ASSERT_EQ(v->val, 1, "v1_val");
+	v =3D btf_enum(t) + 1;
+	ASSERT_STREQ(btf__str_by_offset(btf, v->name_off), "v2", "v2_name");
+	ASSERT_EQ(v->val, 2, "v2_val");
+
+	/* FWDs */
+	id =3D btf__add_fwd(btf, "struct_fwd", BTF_FWD_STRUCT);
+	ASSERT_EQ(id, 10, "struct_fwd_id");
+	t =3D btf__type_by_id(btf, 10);
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "struct_fwd", "fwd_n=
ame");
+	ASSERT_EQ(btf_kind(t), BTF_KIND_FWD, "fwd_kind");
+	ASSERT_EQ(btf_kflag(t), 0, "fwd_kflag");
+
+	id =3D btf__add_fwd(btf, "union_fwd", BTF_FWD_UNION);
+	ASSERT_EQ(id, 11, "union_fwd_id");
+	t =3D btf__type_by_id(btf, 11);
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "union_fwd", "fwd_na=
me");
+	ASSERT_EQ(btf_kind(t), BTF_KIND_FWD, "fwd_kind");
+	ASSERT_EQ(btf_kflag(t), 1, "fwd_kflag");
+
+	id =3D btf__add_fwd(btf, "enum_fwd", BTF_FWD_ENUM);
+	ASSERT_EQ(id, 12, "enum_fwd_id");
+	t =3D btf__type_by_id(btf, 12);
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "enum_fwd", "fwd_nam=
e");
+	ASSERT_EQ(btf_kind(t), BTF_KIND_ENUM, "enum_fwd_kind");
+	ASSERT_EQ(btf_vlen(t), 0, "enum_fwd_kind");
+	ASSERT_EQ(t->size, 4, "enum_fwd_sz");
+
+	/* TYPEDEF */
+	id =3D btf__add_typedef(btf, "typedef1", 1);
+	ASSERT_EQ(id, 13, "typedef_fwd_id");
+	t =3D btf__type_by_id(btf, 13);
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "typedef1", "typedef=
_name");
+	ASSERT_EQ(btf_kind(t), BTF_KIND_TYPEDEF, "typedef_kind");
+	ASSERT_EQ(t->type, 1, "typedef_type");
+
+	/* FUNC & FUNC_PROTO */
+	id =3D btf__add_func(btf, "func1", BTF_FUNC_GLOBAL, 15);
+	ASSERT_EQ(id, 14, "func_id");
+	t =3D btf__type_by_id(btf, 14);
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "func1", "func_name"=
);
+	ASSERT_EQ(t->type, 15, "func_type");
+	ASSERT_EQ(btf_kind(t), BTF_KIND_FUNC, "func_kind");
+	ASSERT_EQ(btf_vlen(t), BTF_FUNC_GLOBAL, "func_vlen");
+
+	id =3D btf__add_func_proto(btf, 1);
+	ASSERT_EQ(id, 15, "func_proto_id");
+	err =3D btf__add_func_param(btf, "p1", 1);
+	ASSERT_OK(err, "p1_res");
+	err =3D btf__add_func_param(btf, "p2", 2);
+	ASSERT_OK(err, "p2_res");
+
+	t =3D btf__type_by_id(btf, 15);
+	ASSERT_EQ(btf_kind(t), BTF_KIND_FUNC_PROTO, "func_proto_kind");
+	ASSERT_EQ(btf_vlen(t), 2, "func_proto_vlen");
+	ASSERT_EQ(t->type, 1, "func_proto_ret_type");
+	p =3D btf_params(t) + 0;
+	ASSERT_STREQ(btf__str_by_offset(btf, p->name_off), "p1", "p1_name");
+	ASSERT_EQ(p->type, 1, "p1_type");
+	p =3D btf_params(t) + 1;
+	ASSERT_STREQ(btf__str_by_offset(btf, p->name_off), "p2", "p2_name");
+	ASSERT_EQ(p->type, 2, "p2_type");
+
+	/* VAR */
+	id =3D btf__add_var(btf, "var1", BTF_VAR_GLOBAL_ALLOCATED, 1);
+	ASSERT_EQ(id, 16, "var_id");
+	t =3D btf__type_by_id(btf, 16);
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "var1", "var_name");
+	ASSERT_EQ(btf_kind(t), BTF_KIND_VAR, "var_kind");
+	ASSERT_EQ(t->type, 1, "var_type");
+	ASSERT_EQ(btf_var(t)->linkage, BTF_VAR_GLOBAL_ALLOCATED, "var_type");
+
+	/* DATASECT */
+	id =3D btf__add_datasec(btf, "datasec1", 12);
+	ASSERT_EQ(id, 17, "datasec_id");
+	err =3D btf__add_datasec_var_info(btf, 1, 4, 8);
+	ASSERT_OK(err, "v1_res");
+
+	t =3D btf__type_by_id(btf, 17);
+	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "datasec1", "datasec=
_name");
+	ASSERT_EQ(t->size, 12, "datasec_sz");
+	ASSERT_EQ(btf_kind(t), BTF_KIND_DATASEC, "datasec_kind");
+	ASSERT_EQ(btf_vlen(t), 1, "datasec_vlen");
+	vi =3D btf_var_secinfos(t) + 0;
+	ASSERT_EQ(vi->type, 1, "v1_type");
+	ASSERT_EQ(vi->offset, 4, "v1_off");
+	ASSERT_EQ(vi->size, 8, "v1_sz");
+
+	btf__free(btf);
+}
--=20
2.24.1

