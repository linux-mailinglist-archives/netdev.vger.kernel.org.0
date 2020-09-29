Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751B527DCA8
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgI2X3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:29:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54638 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726637AbgI2X27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 19:28:59 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TNQ8oj032203
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:28:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=GX/3tg/v1BjMCEHaokzfrO3MinlDSVm40QL5bJN67aU=;
 b=TTfdHMLJOeq6vMgBEIpLlIbya4jsK0afIy5AHYFSm1d+uwgEhre2AUFanfgqAFbWVMUr
 cAlqg2GKoTxPz9Xe83YsSgpENGGI1GBYwBPwwS6GFSIbKjuWqYgZ0Y11B0P2qMnXSKt1
 jGVeHaNu0YxoqJ5YfAb/E9wPO5QTJ6OKxUU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33v6v42p77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:28:57 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 16:28:57 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D585F2EC77D1; Tue, 29 Sep 2020 16:28:51 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 3/4] selftests/bpf: add checking of raw type dump in BTF writer APIs selftests
Date:   Tue, 29 Sep 2020 16:28:42 -0700
Message-ID: <20200929232843.1249318-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200929232843.1249318-1-andriin@fb.com>
References: <20200929232843.1249318-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 suspectscore=25 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009290198
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cross-validate raw BTF dump and writable BTF in a single selftest. Raw ty=
pe
dump checks also serve as a good self-documentation.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/btf_write.c      | 67 ++++++++++++++++++-
 1 file changed, 64 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_write.c b/tools/t=
esting/selftests/bpf/prog_tests/btf_write.c
index 314e1e7c36df..bbf842fc8f48 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_write.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_write.c
@@ -1,22 +1,49 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2020 Facebook */
+#define _GNU_SOURCE
 #include <test_progs.h>
 #include <bpf/btf.h>
=20
 static int duration =3D 0;
=20
+static char *dump_buf;
+static size_t dump_buf_sz;
+static FILE *dump_buf_file;
+
+static void dump_fn(void *ctx, const char *fmt, va_list args)
+{
+	vfprintf(dump_buf_file, fmt, args);
+}
+
+static void check_type_dump(struct btf_dump *d, int type_id, const char =
*exp)
+{
+	fseek(dump_buf_file, 0, SEEK_SET);
+	btf_dump__dump_type_raw(d, type_id);
+	fflush(dump_buf_file);
+	dump_buf[dump_buf_sz] =3D 0; /* some libc implementations don't do this=
 */
+	ASSERT_STREQ(dump_buf, exp, "type_raw_dump");
+}
+
 void test_btf_write() {
 	const struct btf_var_secinfo *vi;
 	const struct btf_type *t;
 	const struct btf_member *m;
 	const struct btf_enum *v;
 	const struct btf_param *p;
-	struct btf *btf;
+	struct btf *btf =3D NULL;
+	struct btf_dump *d =3D NULL;
 	int id, err, str_off;
=20
+	dump_buf_file =3D open_memstream(&dump_buf, &dump_buf_sz);
+	if (CHECK(!dump_buf_file, "dump_memstream", "failed: %d\n", errno))
+		return;
+
 	btf =3D btf__new_empty();
 	if (CHECK(IS_ERR(btf), "new_empty", "failed: %ld\n", PTR_ERR(btf)))
-		return;
+		goto err_out;
+	d =3D btf_dump__new(btf, NULL, NULL, dump_fn);
+	if (!ASSERT_OK(libbpf_get_error(d), "btf_dump__new"))
+		goto err_out;
=20
 	str_off =3D btf__find_str(btf, "int");
 	ASSERT_EQ(str_off, -ENOENT, "int_str_missing_off");
@@ -39,6 +66,7 @@ void test_btf_write() {
 	ASSERT_EQ(t->size, 4, "int_sz");
 	ASSERT_EQ(btf_int_encoding(t), BTF_INT_SIGNED, "int_enc");
 	ASSERT_EQ(btf_int_bits(t), 32, "int_bits");
+	check_type_dump(d, 1, "[1] INT 'int' size=3D4 bits_offset=3D0 nr_bits=3D=
32 encoding=3DSIGNED");
=20
 	/* invalid int size */
 	id =3D btf__add_int(btf, "bad sz int", 7, 0);
@@ -59,24 +87,28 @@ void test_btf_write() {
 	t =3D btf__type_by_id(btf, 2);
 	ASSERT_EQ(btf_kind(t), BTF_KIND_PTR, "ptr_kind");
 	ASSERT_EQ(t->type, 1, "ptr_type");
+	check_type_dump(d, 2, "[2] PTR '(anon)' type_id=3D1");
=20
 	id =3D btf__add_const(btf, 5); /* points forward to restrict */
 	ASSERT_EQ(id, 3, "const_id");
 	t =3D btf__type_by_id(btf, 3);
 	ASSERT_EQ(btf_kind(t), BTF_KIND_CONST, "const_kind");
 	ASSERT_EQ(t->type, 5, "const_type");
+	check_type_dump(d, 3, "[3] CONST '(anon)' type_id=3D5");
=20
 	id =3D btf__add_volatile(btf, 3);
 	ASSERT_EQ(id, 4, "volatile_id");
 	t =3D btf__type_by_id(btf, 4);
 	ASSERT_EQ(btf_kind(t), BTF_KIND_VOLATILE, "volatile_kind");
 	ASSERT_EQ(t->type, 3, "volatile_type");
+	check_type_dump(d, 4, "[4] VOLATILE '(anon)' type_id=3D3");
=20
 	id =3D btf__add_restrict(btf, 4);
 	ASSERT_EQ(id, 5, "restrict_id");
 	t =3D btf__type_by_id(btf, 5);
 	ASSERT_EQ(btf_kind(t), BTF_KIND_RESTRICT, "restrict_kind");
 	ASSERT_EQ(t->type, 4, "restrict_type");
+	check_type_dump(d, 5, "[5] RESTRICT '(anon)' type_id=3D4");
=20
 	/* ARRAY */
 	id =3D btf__add_array(btf, 1, 2, 10); /* int *[10] */
@@ -86,6 +118,7 @@ void test_btf_write() {
 	ASSERT_EQ(btf_array(t)->index_type, 1, "array_index_type");
 	ASSERT_EQ(btf_array(t)->type, 2, "array_elem_type");
 	ASSERT_EQ(btf_array(t)->nelems, 10, "array_nelems");
+	check_type_dump(d, 6, "[6] ARRAY '(anon)' type_id=3D2 index_type_id=3D1=
 nr_elems=3D10");
=20
 	/* STRUCT */
 	err =3D btf__add_field(btf, "field", 1, 0, 0);
@@ -113,6 +146,10 @@ void test_btf_write() {
 	ASSERT_EQ(m->type, 1, "f2_type");
 	ASSERT_EQ(btf_member_bit_offset(t, 1), 32, "f2_bit_off");
 	ASSERT_EQ(btf_member_bitfield_size(t, 1), 16, "f2_bit_sz");
+	check_type_dump(d, 7,
+			"[7] STRUCT 's1' size=3D8 vlen=3D2\n"
+			"\t'f1' type_id=3D1 bits_offset=3D0\n"
+			"\t'f2' type_id=3D1 bits_offset=3D32 bitfield_size=3D16");
=20
 	/* UNION */
 	id =3D btf__add_union(btf, "u1", 8);
@@ -136,6 +173,9 @@ void test_btf_write() {
 	ASSERT_EQ(m->type, 1, "f1_type");
 	ASSERT_EQ(btf_member_bit_offset(t, 0), 0, "f1_bit_off");
 	ASSERT_EQ(btf_member_bitfield_size(t, 0), 16, "f1_bit_sz");
+	check_type_dump(d, 8,
+			"[8] UNION 'u1' size=3D8 vlen=3D1\n"
+			"\t'f1' type_id=3D1 bits_offset=3D0 bitfield_size=3D16");
=20
 	/* ENUM */
 	id =3D btf__add_enum(btf, "e1", 4);
@@ -156,6 +196,10 @@ void test_btf_write() {
 	v =3D btf_enum(t) + 1;
 	ASSERT_STREQ(btf__str_by_offset(btf, v->name_off), "v2", "v2_name");
 	ASSERT_EQ(v->val, 2, "v2_val");
+	check_type_dump(d, 9,
+			"[9] ENUM 'e1' size=3D4 vlen=3D2\n"
+			"\t'v1' val=3D1\n"
+			"\t'v2' val=3D2");
=20
 	/* FWDs */
 	id =3D btf__add_fwd(btf, "struct_fwd", BTF_FWD_STRUCT);
@@ -164,6 +208,7 @@ void test_btf_write() {
 	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "struct_fwd", "fwd_n=
ame");
 	ASSERT_EQ(btf_kind(t), BTF_KIND_FWD, "fwd_kind");
 	ASSERT_EQ(btf_kflag(t), 0, "fwd_kflag");
+	check_type_dump(d, 10, "[10] FWD 'struct_fwd' fwd_kind=3Dstruct");
=20
 	id =3D btf__add_fwd(btf, "union_fwd", BTF_FWD_UNION);
 	ASSERT_EQ(id, 11, "union_fwd_id");
@@ -171,6 +216,7 @@ void test_btf_write() {
 	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "union_fwd", "fwd_na=
me");
 	ASSERT_EQ(btf_kind(t), BTF_KIND_FWD, "fwd_kind");
 	ASSERT_EQ(btf_kflag(t), 1, "fwd_kflag");
+	check_type_dump(d, 11, "[11] FWD 'union_fwd' fwd_kind=3Dunion");
=20
 	id =3D btf__add_fwd(btf, "enum_fwd", BTF_FWD_ENUM);
 	ASSERT_EQ(id, 12, "enum_fwd_id");
@@ -179,6 +225,7 @@ void test_btf_write() {
 	ASSERT_EQ(btf_kind(t), BTF_KIND_ENUM, "enum_fwd_kind");
 	ASSERT_EQ(btf_vlen(t), 0, "enum_fwd_kind");
 	ASSERT_EQ(t->size, 4, "enum_fwd_sz");
+	check_type_dump(d, 12, "[12] ENUM 'enum_fwd' size=3D4 vlen=3D0");
=20
 	/* TYPEDEF */
 	id =3D btf__add_typedef(btf, "typedef1", 1);
@@ -187,6 +234,7 @@ void test_btf_write() {
 	ASSERT_STREQ(btf__str_by_offset(btf, t->name_off), "typedef1", "typedef=
_name");
 	ASSERT_EQ(btf_kind(t), BTF_KIND_TYPEDEF, "typedef_kind");
 	ASSERT_EQ(t->type, 1, "typedef_type");
+	check_type_dump(d, 13, "[13] TYPEDEF 'typedef1' type_id=3D1");
=20
 	/* FUNC & FUNC_PROTO */
 	id =3D btf__add_func(btf, "func1", BTF_FUNC_GLOBAL, 15);
@@ -196,6 +244,7 @@ void test_btf_write() {
 	ASSERT_EQ(t->type, 15, "func_type");
 	ASSERT_EQ(btf_kind(t), BTF_KIND_FUNC, "func_kind");
 	ASSERT_EQ(btf_vlen(t), BTF_FUNC_GLOBAL, "func_vlen");
+	check_type_dump(d, 14, "[14] FUNC 'func1' type_id=3D15 linkage=3Dglobal=
");
=20
 	id =3D btf__add_func_proto(btf, 1);
 	ASSERT_EQ(id, 15, "func_proto_id");
@@ -214,6 +263,10 @@ void test_btf_write() {
 	p =3D btf_params(t) + 1;
 	ASSERT_STREQ(btf__str_by_offset(btf, p->name_off), "p2", "p2_name");
 	ASSERT_EQ(p->type, 2, "p2_type");
+	check_type_dump(d, 15,
+			"[15] FUNC_PROTO '(anon)' ret_type_id=3D1 vlen=3D2\n"
+			"\t'p1' type_id=3D1\n"
+			"\t'p2' type_id=3D2");
=20
 	/* VAR */
 	id =3D btf__add_var(btf, "var1", BTF_VAR_GLOBAL_ALLOCATED, 1);
@@ -223,6 +276,7 @@ void test_btf_write() {
 	ASSERT_EQ(btf_kind(t), BTF_KIND_VAR, "var_kind");
 	ASSERT_EQ(t->type, 1, "var_type");
 	ASSERT_EQ(btf_var(t)->linkage, BTF_VAR_GLOBAL_ALLOCATED, "var_type");
+	check_type_dump(d, 16, "[16] VAR 'var1' type_id=3D1, linkage=3Dglobal-a=
lloc");
=20
 	/* DATASECT */
 	id =3D btf__add_datasec(btf, "datasec1", 12);
@@ -239,6 +293,13 @@ void test_btf_write() {
 	ASSERT_EQ(vi->type, 1, "v1_type");
 	ASSERT_EQ(vi->offset, 4, "v1_off");
 	ASSERT_EQ(vi->size, 8, "v1_sz");
-
+	check_type_dump(d, 17,
+			"[17] DATASEC 'datasec1' size=3D12 vlen=3D1\n"
+			"\ttype_id=3D1 offset=3D4 size=3D8");
+
+err_out:
+	fclose(dump_buf_file);
+	free(dump_buf);
+	btf_dump__free(d);
 	btf__free(btf);
 }
--=20
2.24.1

