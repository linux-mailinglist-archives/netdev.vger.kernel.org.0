Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCDC249466
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 07:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgHSF27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 01:28:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26650 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgHSF26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 01:28:58 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J5QCXj009168
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 22:28:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QhMBCc81+spf++HDKY/+o/f1TLF83YYBxbwpRpmWKXs=;
 b=CAv8yki6I1G+xeKVfrqr9TZQ9tfeIDjAADLa8BVtzeI66gwgAqU70M+y1hjlVoOjniBr
 vyTyMxRltO4C252nZzZugfGJmpWw9OeXij4td/T67xk94AUfW1coTXZOvpiBBrc4Uafe
 rXNXSPhr4meiwzbg7ms1Zce6golYmWzz1b8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304prpupg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 22:28:55 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 22:28:55 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 744B22EC5C14; Tue, 18 Aug 2020 22:28:54 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/5] libbpf: implement type-based CO-RE relocations support
Date:   Tue, 18 Aug 2020 22:28:45 -0700
Message-ID: <20200819052849.336700-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200819052849.336700-1-andriin@fb.com>
References: <20200819052849.336700-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_03:2020-08-18,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 suspectscore=8 clxscore=1015 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for TYPE_EXISTS/TYPE_SIZE/TYPE_ID_LOCAL/TYPE_ID_REMOTE
relocations. These are examples of type-based relocations, as opposed to
field-based relocations supported already. The difference is that they ar=
e
calculating relocation values based on the type itself, not a field withi=
n
a struct/union.

Type-based relos have slightly different semantics when matching local ty=
pes
to kernel target types, see comments in bpf_core_types_are_compat() for
details. Their behavior on failure to find target type in kernel BTF also
differs. Instead of "poisoning" relocatable instruction and failing load
subsequently in kernel, they return 0 (which is rarely a valid return res=
ult,
so user BPF code can use that to detect success/failure of the relocation=
 and
deal with it without extra "guarding" relocations). Also, it's always pos=
sible
to check existence of the type in target kernel with TYPE_EXISTS relocati=
on,
similarly to a field-based FIELD_EXISTS.

TYPE_ID_LOCAL relocation is a bit special in that it always succeeds (bar=
ring
any libbpf/Clang bugs) and resolved to BTF ID using **local** BTF info of=
 BPF
program itself. Tests in subsequent patches demonstrate the usage and
semantics of new relocations.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_core_read.h   |  52 ++++++-
 tools/lib/bpf/libbpf.c          | 231 ++++++++++++++++++++++++++++----
 tools/lib/bpf/libbpf_internal.h |   4 +
 3 files changed, 263 insertions(+), 24 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.=
h
index 03152cb143b7..684bfb86361a 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -19,6 +19,18 @@ enum bpf_field_info_kind {
 	BPF_FIELD_RSHIFT_U64 =3D 5,
 };
=20
+/* second argument to __builtin_btf_type_id() built-in */
+enum bpf_type_id_kind {
+	BPF_TYPE_ID_LOCAL =3D 0,		/* BTF type ID in local program */
+	BPF_TYPE_ID_TARGET =3D 1,		/* BTF type ID in target kernel */
+};
+
+/* second argument to __builtin_preserve_type_info() built-in */
+enum bpf_type_info_kind {
+	BPF_TYPE_EXISTS =3D 0,		/* type existence in target kernel */
+	BPF_TYPE_SIZE =3D 1,		/* type size in target kernel */
+};
+
 #define __CORE_RELO(src, field, info)					      \
 	__builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
=20
@@ -94,12 +106,50 @@ enum bpf_field_info_kind {
 	__builtin_preserve_field_info(field, BPF_FIELD_EXISTS)
=20
 /*
- * Convenience macro to get byte size of a field. Works for integers,
+ * Convenience macro to get the byte size of a field. Works for integers=
,
  * struct/unions, pointers, arrays, and enums.
  */
 #define bpf_core_field_size(field)					    \
 	__builtin_preserve_field_info(field, BPF_FIELD_BYTE_SIZE)
=20
+/*
+ * Convenience macro to get BTF type ID of a specified type, using a loc=
al BTF
+ * information. Return 32-bit unsigned integer with type ID from program=
's own
+ * BTF. Always succeeds.
+ */
+#define bpf_core_type_id_local(type)					    \
+	__builtin_btf_type_id(*(typeof(type) *)0, BPF_TYPE_ID_LOCAL)
+
+/*
+ * Convenience macro to get BTF type ID of a target kernel's type that m=
atches
+ * specified local type.
+ * Returns:
+ *    - valid 32-bit unsigned type ID in kernel BTF;
+ *    - 0, if no matching type was found in a target kernel BTF.
+ */
+#define bpf_core_type_id_kernel(type)					    \
+	__builtin_btf_type_id(*(typeof(type) *)0, BPF_TYPE_ID_TARGET)
+
+/*
+ * Convenience macro to check that provided named type
+ * (struct/union/enum/typedef) exists in a target kernel.
+ * Returns:
+ *    1, if such type is present in target kernel's BTF;
+ *    0, if no matching type is found.
+ */
+#define bpf_core_type_exists(type)					    \
+	__builtin_preserve_type_info(*(typeof(type) *)0, BPF_TYPE_EXISTS)
+
+/*
+ * Convenience macro to get the byte size of a provided named type
+ * (struct/union/enum/typedef) in a target kernel.
+ * Returns:
+ *    >=3D 0 size (in bytes), if type is present in target kernel's BTF;
+ *    0, if no matching type is found.
+ */
+#define bpf_core_type_size(type)					    \
+	__builtin_preserve_type_info(*(typeof(type) *)0, BPF_TYPE_SIZE)
+
 /*
  * bpf_core_read() abstracts away bpf_probe_read_kernel() call and captu=
res
  * offset relocation for source address using __builtin_preserve_access_=
index()
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4a81c6b2d21b..882759dfc33e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4111,6 +4111,10 @@ static const char *core_relo_kind_str(enum bpf_cor=
e_relo_kind kind)
 	case BPF_FIELD_SIGNED: return "signed";
 	case BPF_FIELD_LSHIFT_U64: return "lshift_u64";
 	case BPF_FIELD_RSHIFT_U64: return "rshift_u64";
+	case BPF_TYPE_ID_LOCAL: return "local_type_id";
+	case BPF_TYPE_ID_TARGET: return "target_type_id";
+	case BPF_TYPE_EXISTS: return "type_exists";
+	case BPF_TYPE_SIZE: return "type_size";
 	default: return "unknown";
 	}
 }
@@ -4130,6 +4134,19 @@ static bool core_relo_is_field_based(enum bpf_core=
_relo_kind kind)
 	}
 }
=20
+static bool core_relo_is_type_based(enum bpf_core_relo_kind kind)
+{
+	switch (kind) {
+	case BPF_TYPE_ID_LOCAL:
+	case BPF_TYPE_ID_TARGET:
+	case BPF_TYPE_EXISTS:
+	case BPF_TYPE_SIZE:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * Turn bpf_core_relo into a low- and high-level spec representation,
  * validating correctness along the way, as well as calculating resultin=
g
@@ -4160,6 +4177,9 @@ static bool core_relo_is_field_based(enum bpf_core_=
relo_kind kind)
  *   - field 'a' access (corresponds to '2' in low-level spec);
  *   - array element #3 access (corresponds to '3' in low-level spec).
  *
+ * Type-based relocations (TYPE_EXISTS/TYPE_SIZE,
+ * TYPE_ID_LOCAL/TYPE_ID_TARGET) don't capture any field information. Th=
eir
+ * spec and raw_spec are kept empty.
  */
 static int bpf_core_parse_spec(const struct btf *btf,
 			       __u32 type_id,
@@ -4182,6 +4202,13 @@ static int bpf_core_parse_spec(const struct btf *b=
tf,
 	spec->root_type_id =3D type_id;
 	spec->relo_kind =3D relo_kind;
=20
+	/* type-based relocations don't have a field access string */
+	if (core_relo_is_type_based(relo_kind)) {
+		if (strcmp(spec_str, "0"))
+			return -EINVAL;
+		return 0;
+	}
+
 	/* parse spec_str=3D"0:1:2:3:4" into array raw_spec=3D[0, 1, 2, 3, 4] *=
/
 	while (*spec_str) {
 		if (*spec_str =3D=3D ':')
@@ -4317,7 +4344,7 @@ static struct ids_vec *bpf_core_find_cands(const st=
ruct btf *local_btf,
 					   const struct btf *targ_btf)
 {
 	size_t local_essent_len, targ_essent_len;
-	const char *local_name, *targ_name, *targ_kind;
+	const char *local_name, *targ_name;
 	const struct btf_type *t, *local_t;
 	struct ids_vec *cand_ids;
 	__u32 *new_ids;
@@ -4339,13 +4366,11 @@ static struct ids_vec *bpf_core_find_cands(const =
struct btf *local_btf,
 	n =3D btf__get_nr_types(targ_btf);
 	for (i =3D 1; i <=3D n; i++) {
 		t =3D btf__type_by_id(targ_btf, i);
-		targ_name =3D btf__name_by_offset(targ_btf, t->name_off);
-		if (str_is_empty(targ_name))
+		if (btf_kind(t) !=3D btf_kind(local_t))
 			continue;
-		targ_kind =3D btf_kind_str(t);
=20
-		t =3D skip_mods_and_typedefs(targ_btf, i, NULL);
-		if (!btf_is_composite(t) && !btf_is_array(t))
+		targ_name =3D btf__name_by_offset(targ_btf, t->name_off);
+		if (str_is_empty(targ_name))
 			continue;
=20
 		targ_essent_len =3D bpf_core_essential_name_len(targ_name);
@@ -4355,7 +4380,7 @@ static struct ids_vec *bpf_core_find_cands(const st=
ruct btf *local_btf,
 		if (strncmp(local_name, targ_name, local_essent_len) =3D=3D 0) {
 			pr_debug("CO-RE relocating [%d] %s %s: found target candidate [%d] %s=
 %s\n",
 				 local_type_id, btf_kind_str(local_t),
-				 local_name, i, targ_kind, targ_name);
+				 local_name, i, btf_kind_str(t), targ_name);
 			new_ids =3D libbpf_reallocarray(cand_ids->data,
 						      cand_ids->len + 1,
 						      sizeof(*cand_ids->data));
@@ -4373,8 +4398,9 @@ static struct ids_vec *bpf_core_find_cands(const st=
ruct btf *local_btf,
 	return ERR_PTR(err);
 }
=20
-/* Check two types for compatibility, skipping const/volatile/restrict a=
nd
- * typedefs, to ensure we are relocating compatible entities:
+/* Check two types for compatibility for the purpose of field access
+ * relocation. const/volatile/restrict and typedefs are skipped to ensur=
e we
+ * are relocating semantically compatible entities:
  *   - any two STRUCTs/UNIONs are compatible and can be mixed;
  *   - any two FWDs are compatible, if their names match (modulo flavor =
suffix);
  *   - any two PTRs are always compatible;
@@ -4529,6 +4555,100 @@ static int bpf_core_match_member(const struct btf=
 *local_btf,
 	return 0;
 }
=20
+/* Check local and target types for compatibility. This check is used fo=
r
+ * type-based CO-RE relocations and follow slightly different rules than
+ * field-based relocations. This function assumes that root types were a=
lready
+ * checked for name match. Beyond that initial root-level name check, na=
mes
+ * are completely ignored. Compatibility rules are as follows:
+ *   - any two STRUCTs/UNIONs/FWDs/ENUMs/INTs are considered compatible,=
 but
+ *     kind should match for local and target types (i.e., STRUCT is not
+ *     compatible with UNION);
+ *   - for ENUMs, the size is ignored;
+ *   - for INT, size and signedness are ignored;
+ *   - for ARRAY, dimensionality is ignored, element types are checked f=
or
+ *     compatibility recursively;
+ *   - CONST/VOLATILE/RESTRICT modifiers are ignored;
+ *   - TYPEDEFs/PTRs are compatible if types they pointing to are compat=
ible;
+ *   - FUNC_PROTOs are compatible if they have compatible signature: sam=
e
+ *     number of input args and compatible return and argument types.
+ * These rules are not set in stone and probably will be adjusted as we =
get
+ * more experience with using BPF CO-RE relocations.
+ */
+static int bpf_core_types_are_compat(const struct btf *local_btf, __u32 =
local_id,
+				     const struct btf *targ_btf, __u32 targ_id)
+{
+	const struct btf_type *local_type, *targ_type;
+	int depth =3D 32; /* max recursion depth */
+
+	/* caller made sure that names match (ignoring flavor suffix) */
+	local_type =3D btf__type_by_id(local_btf, local_id);
+	targ_type =3D btf__type_by_id(local_btf, local_id);
+	if (btf_kind(local_type) !=3D btf_kind(targ_type))
+		return 0;
+
+recur:
+	depth--;
+	if (depth < 0)
+		return -EINVAL;
+
+	local_type =3D skip_mods_and_typedefs(local_btf, local_id, &local_id);
+	targ_type =3D skip_mods_and_typedefs(targ_btf, targ_id, &targ_id);
+	if (!local_type || !targ_type)
+		return -EINVAL;
+
+	if (btf_kind(local_type) !=3D btf_kind(targ_type))
+		return 0;
+
+	switch (btf_kind(local_type)) {
+	case BTF_KIND_UNKN:
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+	case BTF_KIND_ENUM:
+	case BTF_KIND_FWD:
+		return 1;
+	case BTF_KIND_INT:
+		/* just reject deprecated bitfield-like integers; all other
+		 * integers are by default compatible between each other
+		 */
+		return btf_int_offset(local_type) =3D=3D 0 && btf_int_offset(targ_type=
) =3D=3D 0;
+	case BTF_KIND_PTR:
+		local_id =3D local_type->type;
+		targ_id =3D targ_type->type;
+		goto recur;
+	case BTF_KIND_ARRAY:
+		local_id =3D btf_array(local_type)->type;
+		targ_id =3D btf_array(targ_type)->type;
+		goto recur;
+	case BTF_KIND_FUNC_PROTO: {
+		struct btf_param *local_p =3D btf_params(local_type);
+		struct btf_param *targ_p =3D btf_params(targ_type);
+		__u16 local_vlen =3D btf_vlen(local_type);
+		__u16 targ_vlen =3D btf_vlen(targ_type);
+		int i, err;
+
+		if (local_vlen !=3D targ_vlen)
+			return 0;
+
+		for (i =3D 0; i < local_vlen; i++, local_p++, targ_p++) {
+			skip_mods_and_typedefs(local_btf, local_p->type, &local_id);
+			skip_mods_and_typedefs(targ_btf, targ_p->type, &targ_id);
+			err =3D bpf_core_types_are_compat(local_btf, local_id, targ_btf, targ=
_id);
+			if (err <=3D 0)
+				return err;
+		}
+
+		/* tail recurse for return type check */
+		skip_mods_and_typedefs(local_btf, local_type->type, &local_id);
+		skip_mods_and_typedefs(targ_btf, targ_type->type, &targ_id);
+		goto recur;
+	}
+	default:
+		pr_warn("unexpected kind %s relocated, local [%d], target [%d]\n",
+			btf_kind_str(local_type), local_id, targ_id);
+		return 0;
+	}
+}
+
 /*
  * Try to match local spec to a target type and, if successful, produce =
full
  * target spec (high-level, low-level + bit offset).
@@ -4547,6 +4667,12 @@ static int bpf_core_spec_match(struct bpf_core_spe=
c *local_spec,
 	targ_spec->root_type_id =3D targ_id;
 	targ_spec->relo_kind =3D local_spec->relo_kind;
=20
+	if (core_relo_is_type_based(local_spec->relo_kind)) {
+		return bpf_core_types_are_compat(local_spec->btf,
+						 local_spec->root_type_id,
+						 targ_btf, targ_id);
+	}
+
 	local_acc =3D &local_spec->spec[0];
 	targ_acc =3D &targ_spec->spec[0];
=20
@@ -4720,6 +4846,40 @@ static int bpf_core_calc_field_relo(const struct b=
pf_program *prog,
 	return 0;
 }
=20
+static int bpf_core_calc_type_relo(const struct bpf_core_relo *relo,
+				   const struct bpf_core_spec *spec,
+				   __u32 *val)
+{
+	__s64 sz;
+
+	/* type-based relos return zero when target type is not found */
+	if (!spec) {
+		*val =3D 0;
+		return 0;
+	}
+
+	switch (relo->kind) {
+	case BPF_TYPE_ID_TARGET:
+		*val =3D spec->root_type_id;
+		break;
+	case BPF_TYPE_EXISTS:
+		*val =3D 1;
+		break;
+	case BPF_TYPE_SIZE:
+		sz =3D btf__resolve_size(spec->btf, spec->root_type_id);
+		if (sz < 0)
+			return -EINVAL;
+		*val =3D sz;
+		break;
+	case BPF_TYPE_ID_LOCAL:
+	/* BPF_TYPE_ID_LOCAL is handled specially and shouldn't get here */
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 struct bpf_core_relo_res
 {
 	/* expected value in the instruction, unless validate =3D=3D false */
@@ -4755,6 +4915,9 @@ static int bpf_core_calc_relo(const struct bpf_prog=
ram *prog,
 	if (core_relo_is_field_based(relo->kind)) {
 		err =3D bpf_core_calc_field_relo(prog, relo, local_spec, &res->orig_va=
l, &res->validate);
 		err =3D err ?: bpf_core_calc_field_relo(prog, relo, targ_spec, &res->n=
ew_val, NULL);
+	} else if (core_relo_is_type_based(relo->kind)) {
+		err =3D bpf_core_calc_type_relo(relo, local_spec, &res->orig_val);
+		err =3D err ?: bpf_core_calc_type_relo(relo, targ_spec, &res->new_val)=
;
 	}
=20
 	if (err =3D=3D -EUCLEAN) {
@@ -4894,6 +5057,9 @@ static void bpf_core_dump_spec(int level, const str=
uct bpf_core_spec *spec)
=20
 	libbpf_print(level, "[%u] %s %s", type_id, btf_kind_str(t), str_is_empt=
y(s) ? "<anon>" : s);
=20
+	if (core_relo_is_type_based(spec->relo_kind))
+		return;
+
 	if (core_relo_is_field_based(spec->relo_kind)) {
 		for (i =3D 0; i < spec->len; i++) {
 			if (spec->spec[i].name)
@@ -4911,6 +5077,7 @@ static void bpf_core_dump_spec(int level, const str=
uct bpf_core_spec *spec)
 				     spec->bit_offset / 8, spec->bit_offset % 8);
 		else
 			libbpf_print(level, " @ offset %u)", spec->bit_offset / 8);
+		return;
 	}
 }
=20
@@ -4979,12 +5146,12 @@ static void *u32_as_hash_key(__u32 x)
  *    between multiple relocations for the same type ID and is updated a=
s some
  *    of the candidates are pruned due to structural incompatibility.
  */
-static int bpf_core_reloc_field(struct bpf_program *prog,
-				 const struct bpf_core_relo *relo,
-				 int relo_idx,
-				 const struct btf *local_btf,
-				 const struct btf *targ_btf,
-				 struct hashmap *cand_cache)
+static int bpf_core_apply_relo(struct bpf_program *prog,
+			       const struct bpf_core_relo *relo,
+			       int relo_idx,
+			       const struct btf *local_btf,
+			       const struct btf *targ_btf,
+			       struct hashmap *cand_cache)
 {
 	const char *prog_name =3D bpf_program__title(prog, false);
 	struct bpf_core_spec local_spec, cand_spec, targ_spec;
@@ -5003,7 +5170,7 @@ static int bpf_core_reloc_field(struct bpf_program =
*prog,
 		return -EINVAL;
=20
 	local_name =3D btf__name_by_offset(local_btf, local_type->name_off);
-	if (str_is_empty(local_name))
+	if (!local_name)
 		return -EINVAL;
=20
 	spec_str =3D btf__name_by_offset(local_btf, relo->access_str_off);
@@ -5014,7 +5181,8 @@ static int bpf_core_reloc_field(struct bpf_program =
*prog,
 	if (err) {
 		pr_warn("prog '%s': relo #%d: parsing [%d] %s %s + %s failed: %d\n",
 			prog_name, relo_idx, local_id, btf_kind_str(local_type),
-			local_name, spec_str, err);
+			str_is_empty(local_name) ? "<anon>" : local_name,
+			spec_str, err);
 		return -EINVAL;
 	}
=20
@@ -5023,12 +5191,28 @@ static int bpf_core_reloc_field(struct bpf_progra=
m *prog,
 	bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
 	libbpf_print(LIBBPF_DEBUG, "\n");
=20
+	/* TYPE_ID_LOCAL relo is special and doesn't need candidate search */
+	if (relo->kind =3D=3D BPF_TYPE_ID_LOCAL) {
+		targ_res.validate =3D true;
+		targ_res.poison =3D false;
+		targ_res.orig_val =3D local_spec.root_type_id;
+		targ_res.new_val =3D local_spec.root_type_id;
+		goto patch_insn;
+	}
+
+	/* libbpf doesn't support candidate search for anonymous types */
+	if (str_is_empty(spec_str)) {
+		pr_warn("prog '%s': relo #%d: <%s> (%d) relocation doesn't support ano=
nymous types\n",
+			prog_name, relo_idx, core_relo_kind_str(relo->kind), relo->kind);
+		return -EOPNOTSUPP;
+	}
+
 	if (!hashmap__find(cand_cache, type_key, (void **)&cand_ids)) {
 		cand_ids =3D bpf_core_find_cands(local_btf, local_id, targ_btf);
 		if (IS_ERR(cand_ids)) {
 			pr_warn("prog '%s': relo #%d: target candidate search failed for [%d]=
 %s %s: %ld",
-				prog_name, relo_idx, local_id, btf_kind_str(local_type), local_name,
-				PTR_ERR(cand_ids));
+				prog_name, relo_idx, local_id, btf_kind_str(local_type),
+				local_name, PTR_ERR(cand_ids));
 			return PTR_ERR(cand_ids);
 		}
 		err =3D hashmap__set(cand_cache, type_key, cand_ids, NULL, NULL);
@@ -5084,7 +5268,7 @@ static int bpf_core_reloc_field(struct bpf_program =
*prog,
 			return -EINVAL;
 		}
=20
-		cand_ids->data[j++] =3D cand_spec.spec[0].type_id;
+		cand_ids->data[j++] =3D cand_spec.root_type_id;
 	}
=20
 	/*
@@ -5103,7 +5287,7 @@ static int bpf_core_reloc_field(struct bpf_program =
*prog,
 	 * as well as expected case, depending whether instruction w/
 	 * relocation is guarded in some way that makes it unreachable (dead
 	 * code) if relocation can't be resolved. This is handled in
-	 * bpf_core_reloc_insn() uniformly by replacing that instruction with
+	 * bpf_core_patch_insn() uniformly by replacing that instruction with
 	 * BPF helper call insn (using invalid helper ID). If that instruction
 	 * is indeed unreachable, then it will be ignored and eliminated by
 	 * verifier. If it was an error, then verifier will complain and point
@@ -5119,6 +5303,7 @@ static int bpf_core_reloc_field(struct bpf_program =
*prog,
 			return err;
 	}
=20
+patch_insn:
 	/* bpf_core_patch_insn() should know how to handle missing targ_spec */
 	err =3D bpf_core_patch_insn(prog, relo, relo_idx, &targ_res);
 	if (err) {
@@ -5186,8 +5371,8 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
 			 sec_name, sec->num_info);
=20
 		for_each_btf_ext_rec(seg, sec, i, rec) {
-			err =3D bpf_core_reloc_field(prog, rec, i, obj->btf,
-						   targ_btf, cand_cache);
+			err =3D bpf_core_apply_relo(prog, rec, i, obj->btf,
+						  targ_btf, cand_cache);
 			if (err) {
 				pr_warn("prog '%s': relo #%d: failed to relocate: %d\n",
 					sec_name, i, err);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index c8ed352671d5..edd3511aa242 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -238,6 +238,10 @@ enum bpf_core_relo_kind {
 	BPF_FIELD_SIGNED =3D 3,		/* field signedness (0 - unsigned, 1 - signed)=
 */
 	BPF_FIELD_LSHIFT_U64 =3D 4,	/* bitfield-specific left bitshift */
 	BPF_FIELD_RSHIFT_U64 =3D 5,	/* bitfield-specific right bitshift */
+	BPF_TYPE_ID_LOCAL =3D 6,		/* type ID in local BPF object */
+	BPF_TYPE_ID_TARGET =3D 7,		/* type ID in target kernel */
+	BPF_TYPE_EXISTS =3D 8,		/* type existence in target kernel */
+	BPF_TYPE_SIZE =3D 9,		/* type size in bytes */
 };
=20
 /* The minimum bpf_core_relo checked by the loader
--=20
2.24.1

