Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94DD249112
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgHRWkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:40:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9272 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727041AbgHRWjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:39:48 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IMDO6A006390
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:39:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zSUc97m9IZl/6oCDfwCbM61usr+UJ8U7YU5jA0q0jp0=;
 b=Ml1wrQBBeWcdnVsPwV4CP3c4lmTwlnXoRUeOQa9qA+vhQVAx0T+M+nf9RCrOL7Tjg35f
 jb+6A1Ni6tJ/X9XexHkVkisaRQWJsdopAd967iG7t6bR3AQ4WKjAP3oGXrLwYZOt4v4B
 ODf8ulMmZEKyZY5zTBUCio3IvqeFm/kvLqY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m2wgcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:39:45 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 15:39:44 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BC51D2EC5EB9; Tue, 18 Aug 2020 15:39:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/9] libbpf: clean up and improve CO-RE reloc logging
Date:   Tue, 18 Aug 2020 15:39:14 -0700
Message-ID: <20200818223921.2911963-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818223921.2911963-1-andriin@fb.com>
References: <20200818223921.2911963-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=2 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add logging of local/target type kind (struct/union/typedef/etc). Preserv=
e
unresolved root type ID (for cases of typedef). Improve the format of CO-=
RE
reloc spec output format to contain only relevant and succinct info.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf.c             |  17 ++--
 tools/lib/bpf/btf.h             |  38 --------
 tools/lib/bpf/libbpf.c          | 165 ++++++++++++++++++++------------
 tools/lib/bpf/libbpf_internal.h |  78 +++++++++++----
 4 files changed, 169 insertions(+), 129 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 7dfca7016aaa..1deedbd19c6c 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1131,14 +1131,14 @@ static int btf_ext_setup_line_info(struct btf_ext=
 *btf_ext)
 	return btf_ext_setup_info(btf_ext, &param);
 }
=20
-static int btf_ext_setup_field_reloc(struct btf_ext *btf_ext)
+static int btf_ext_setup_core_relos(struct btf_ext *btf_ext)
 {
 	struct btf_ext_sec_setup_param param =3D {
-		.off =3D btf_ext->hdr->field_reloc_off,
-		.len =3D btf_ext->hdr->field_reloc_len,
-		.min_rec_size =3D sizeof(struct bpf_field_reloc),
-		.ext_info =3D &btf_ext->field_reloc_info,
-		.desc =3D "field_reloc",
+		.off =3D btf_ext->hdr->core_relo_off,
+		.len =3D btf_ext->hdr->core_relo_len,
+		.min_rec_size =3D sizeof(struct bpf_core_relo),
+		.ext_info =3D &btf_ext->core_relo_info,
+		.desc =3D "core_relo",
 	};
=20
 	return btf_ext_setup_info(btf_ext, &param);
@@ -1217,10 +1217,9 @@ struct btf_ext *btf_ext__new(__u8 *data, __u32 siz=
e)
 	if (err)
 		goto done;
=20
-	if (btf_ext->hdr->hdr_len <
-	    offsetofend(struct btf_ext_header, field_reloc_len))
+	if (btf_ext->hdr->hdr_len < offsetofend(struct btf_ext_header, core_rel=
o_len))
 		goto done;
-	err =3D btf_ext_setup_field_reloc(btf_ext);
+	err =3D btf_ext_setup_core_relos(btf_ext);
 	if (err)
 		goto done;
=20
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 1ca14448df4c..91f0ad0e0325 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -24,44 +24,6 @@ struct btf_type;
=20
 struct bpf_object;
=20
-/*
- * The .BTF.ext ELF section layout defined as
- *   struct btf_ext_header
- *   func_info subsection
- *
- * The func_info subsection layout:
- *   record size for struct bpf_func_info in the func_info subsection
- *   struct btf_sec_func_info for section #1
- *   a list of bpf_func_info records for section #1
- *     where struct bpf_func_info mimics one in include/uapi/linux/bpf.h
- *     but may not be identical
- *   struct btf_sec_func_info for section #2
- *   a list of bpf_func_info records for section #2
- *   ......
- *
- * Note that the bpf_func_info record size in .BTF.ext may not
- * be the same as the one defined in include/uapi/linux/bpf.h.
- * The loader should ensure that record_size meets minimum
- * requirement and pass the record as is to the kernel. The
- * kernel will handle the func_info properly based on its contents.
- */
-struct btf_ext_header {
-	__u16	magic;
-	__u8	version;
-	__u8	flags;
-	__u32	hdr_len;
-
-	/* All offsets are in bytes relative to the end of this header */
-	__u32	func_info_off;
-	__u32	func_info_len;
-	__u32	line_info_off;
-	__u32	line_info_len;
-
-	/* optional part of .BTF.ext header */
-	__u32	field_reloc_off;
-	__u32	field_reloc_len;
-};
-
 LIBBPF_API void btf__free(struct btf *btf);
 LIBBPF_API struct btf *btf__new(const void *data, __u32 size);
 LIBBPF_API struct btf *btf__parse(const char *path, struct btf_ext **btf=
_ext);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ddc6ae184dc2..2047e4ed0076 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2524,7 +2524,7 @@ static int bpf_object__load_vmlinux_btf(struct bpf_=
object *obj)
 	int err;
=20
 	/* CO-RE relocations need kernel BTF */
-	if (obj->btf_ext && obj->btf_ext->field_reloc_info.len)
+	if (obj->btf_ext && obj->btf_ext->core_relo_info.len)
 		need_vmlinux_btf =3D true;
=20
 	bpf_object__for_each_program(prog, obj) {
@@ -4074,6 +4074,10 @@ struct bpf_core_spec {
 	const struct btf *btf;
 	/* high-level spec: named fields and array indices only */
 	struct bpf_core_accessor spec[BPF_CORE_SPEC_MAX_LEN];
+	/* original unresolved (no skip_mods_or_typedefs) root type ID */
+	__u32 root_type_id;
+	/* CO-RE relocation kind */
+	enum bpf_core_relo_kind relo_kind;
 	/* high-level spec length */
 	int len;
 	/* raw, low-level spec: 1-to-1 with accessor spec string */
@@ -4104,8 +4108,36 @@ static bool is_flex_arr(const struct btf *btf,
 	return acc->idx =3D=3D btf_vlen(t) - 1;
 }
=20
+static const char *core_relo_kind_str(enum bpf_core_relo_kind kind)
+{
+	switch (kind) {
+	case BPF_FIELD_BYTE_OFFSET: return "byte_off";
+	case BPF_FIELD_BYTE_SIZE: return "byte_sz";
+	case BPF_FIELD_EXISTS: return "field_exists";
+	case BPF_FIELD_SIGNED: return "signed";
+	case BPF_FIELD_LSHIFT_U64: return "lshift_u64";
+	case BPF_FIELD_RSHIFT_U64: return "rshift_u64";
+	default: return "unknown";
+	}
+}
+
+static bool core_relo_is_field_based(enum bpf_core_relo_kind kind)
+{
+	switch (kind) {
+	case BPF_FIELD_BYTE_OFFSET:
+	case BPF_FIELD_BYTE_SIZE:
+	case BPF_FIELD_EXISTS:
+	case BPF_FIELD_SIGNED:
+	case BPF_FIELD_LSHIFT_U64:
+	case BPF_FIELD_RSHIFT_U64:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
- * Turn bpf_field_reloc into a low- and high-level spec representation,
+ * Turn bpf_core_relo into a low- and high-level spec representation,
  * validating correctness along the way, as well as calculating resultin=
g
  * field bit offset, specified by accessor string. Low-level spec captur=
es
  * every single level of nestedness, including traversing anonymous
@@ -4135,9 +4167,10 @@ static bool is_flex_arr(const struct btf *btf,
  *   - array element #3 access (corresponds to '3' in low-level spec).
  *
  */
-static int bpf_core_spec_parse(const struct btf *btf,
+static int bpf_core_parse_spec(const struct btf *btf,
 			       __u32 type_id,
 			       const char *spec_str,
+			       enum bpf_core_relo_kind relo_kind,
 			       struct bpf_core_spec *spec)
 {
 	int access_idx, parsed_len, i;
@@ -4152,6 +4185,8 @@ static int bpf_core_spec_parse(const struct btf *bt=
f,
=20
 	memset(spec, 0, sizeof(*spec));
 	spec->btf =3D btf;
+	spec->root_type_id =3D type_id;
+	spec->relo_kind =3D relo_kind;
=20
 	/* parse spec_str=3D"0:1:2:3:4" into array raw_spec=3D[0, 1, 2, 3, 4] *=
/
 	while (*spec_str) {
@@ -4178,6 +4213,9 @@ static int bpf_core_spec_parse(const struct btf *bt=
f,
 	spec->spec[0].idx =3D access_idx;
 	spec->len++;
=20
+	if (!core_relo_is_field_based(relo_kind))
+		return -EINVAL;
+
 	sz =3D btf__resolve_size(btf, id);
 	if (sz < 0)
 		return sz;
@@ -4285,17 +4323,17 @@ static struct ids_vec *bpf_core_find_cands(const =
struct btf *local_btf,
 					   const struct btf *targ_btf)
 {
 	size_t local_essent_len, targ_essent_len;
-	const char *local_name, *targ_name;
-	const struct btf_type *t;
+	const char *local_name, *targ_name, *targ_kind;
+	const struct btf_type *t, *local_t;
 	struct ids_vec *cand_ids;
 	__u32 *new_ids;
 	int i, err, n;
=20
-	t =3D btf__type_by_id(local_btf, local_type_id);
-	if (!t)
+	local_t =3D btf__type_by_id(local_btf, local_type_id);
+	if (!local_t)
 		return ERR_PTR(-EINVAL);
=20
-	local_name =3D btf__name_by_offset(local_btf, t->name_off);
+	local_name =3D btf__name_by_offset(local_btf, local_t->name_off);
 	if (str_is_empty(local_name))
 		return ERR_PTR(-EINVAL);
 	local_essent_len =3D bpf_core_essential_name_len(local_name);
@@ -4310,6 +4348,7 @@ static struct ids_vec *bpf_core_find_cands(const st=
ruct btf *local_btf,
 		targ_name =3D btf__name_by_offset(targ_btf, t->name_off);
 		if (str_is_empty(targ_name))
 			continue;
+		targ_kind =3D btf_kind_str(t);
=20
 		t =3D skip_mods_and_typedefs(targ_btf, i, NULL);
 		if (!btf_is_composite(t) && !btf_is_array(t))
@@ -4320,8 +4359,9 @@ static struct ids_vec *bpf_core_find_cands(const st=
ruct btf *local_btf,
 			continue;
=20
 		if (strncmp(local_name, targ_name, local_essent_len) =3D=3D 0) {
-			pr_debug("[%d] %s: found candidate [%d] %s\n",
-				 local_type_id, local_name, i, targ_name);
+			pr_debug("CO-RE relocating [%d] %s %s: found target candidate [%d] %s=
 %s\n",
+				 local_type_id, btf_kind_str(local_t),
+				 local_name, i, targ_kind, targ_name);
 			new_ids =3D reallocarray(cand_ids->data,
 					       cand_ids->len + 1,
 					       sizeof(*cand_ids->data));
@@ -4510,6 +4550,8 @@ static int bpf_core_spec_match(struct bpf_core_spec=
 *local_spec,
=20
 	memset(targ_spec, 0, sizeof(*targ_spec));
 	targ_spec->btf =3D targ_btf;
+	targ_spec->root_type_id =3D targ_id;
+	targ_spec->relo_kind =3D local_spec->relo_kind;
=20
 	local_acc =3D &local_spec->spec[0];
 	targ_acc =3D &targ_spec->spec[0];
@@ -4570,7 +4612,7 @@ static int bpf_core_spec_match(struct bpf_core_spec=
 *local_spec,
 }
=20
 static int bpf_core_calc_field_relo(const struct bpf_program *prog,
-				    const struct bpf_field_reloc *relo,
+				    const struct bpf_core_relo *relo,
 				    const struct bpf_core_spec *spec,
 				    __u32 *val, bool *validate)
 {
@@ -4691,7 +4733,7 @@ static int bpf_core_calc_field_relo(const struct bp=
f_program *prog,
  * 2. rX +=3D <imm> (arithmetic operations with immediate operand);
  */
 static int bpf_core_reloc_insn(struct bpf_program *prog,
-			       const struct bpf_field_reloc *relo,
+			       const struct bpf_core_relo *relo,
 			       int relo_idx,
 			       const struct bpf_core_spec *local_spec,
 			       const struct bpf_core_spec *targ_spec)
@@ -4795,25 +4837,30 @@ static void bpf_core_dump_spec(int level, const s=
truct bpf_core_spec *spec)
 	__u32 type_id;
 	int i;
=20
-	type_id =3D spec->spec[0].type_id;
+	type_id =3D spec->root_type_id;
 	t =3D btf__type_by_id(spec->btf, type_id);
 	s =3D btf__name_by_offset(spec->btf, t->name_off);
-	libbpf_print(level, "[%u] %s + ", type_id, s);
=20
-	for (i =3D 0; i < spec->raw_len; i++)
-		libbpf_print(level, "%d%s", spec->raw_spec[i],
-			     i =3D=3D spec->raw_len - 1 ? " =3D> " : ":");
+	libbpf_print(level, "[%u] %s %s", type_id, btf_kind_str(t), str_is_empt=
y(s) ? "<anon>" : s);
+
+	if (core_relo_is_field_based(spec->relo_kind)) {
+		for (i =3D 0; i < spec->len; i++) {
+			if (spec->spec[i].name)
+				libbpf_print(level, ".%s", spec->spec[i].name);
+			else if (i > 0 || spec->spec[i].idx > 0)
+				libbpf_print(level, "[%u]", spec->spec[i].idx);
+		}
=20
-	libbpf_print(level, "%u.%u @ &x",
-		     spec->bit_offset / 8, spec->bit_offset % 8);
+		libbpf_print(level, " (");
+		for (i =3D 0; i < spec->raw_len; i++)
+			libbpf_print(level, "%s%d", i =3D=3D 0 ? "" : ":", spec->raw_spec[i])=
;
=20
-	for (i =3D 0; i < spec->len; i++) {
-		if (spec->spec[i].name)
-			libbpf_print(level, ".%s", spec->spec[i].name);
+		if (spec->bit_offset % 8)
+			libbpf_print(level, " @ offset %u.%u)",
+				     spec->bit_offset / 8, spec->bit_offset % 8);
 		else
-			libbpf_print(level, "[%u]", spec->spec[i].idx);
+			libbpf_print(level, " @ offset %u)", spec->bit_offset / 8);
 	}
-
 }
=20
 static size_t bpf_core_hash_fn(const void *key, void *ctx)
@@ -4877,12 +4924,12 @@ static void *u32_as_hash_key(__u32 x)
  *    CPU-wise compared to prebuilding a map from all local type names t=
o
  *    a list of candidate type names. It's also sped up by caching resol=
ved
  *    list of matching candidates per each local "root" type ID, that ha=
s at
- *    least one bpf_field_reloc associated with it. This list is shared
+ *    least one bpf_core_relo associated with it. This list is shared
  *    between multiple relocations for the same type ID and is updated a=
s some
  *    of the candidates are pruned due to structural incompatibility.
  */
 static int bpf_core_reloc_field(struct bpf_program *prog,
-				 const struct bpf_field_reloc *relo,
+				 const struct bpf_core_relo *relo,
 				 int relo_idx,
 				 const struct btf *local_btf,
 				 const struct btf *targ_btf,
@@ -4891,8 +4938,8 @@ static int bpf_core_reloc_field(struct bpf_program =
*prog,
 	const char *prog_name =3D bpf_program__title(prog, false);
 	struct bpf_core_spec local_spec, cand_spec, targ_spec;
 	const void *type_key =3D u32_as_hash_key(relo->type_id);
-	const struct btf_type *local_type, *cand_type;
-	const char *local_name, *cand_name;
+	const struct btf_type *local_type;
+	const char *local_name;
 	struct ids_vec *cand_ids;
 	__u32 local_id, cand_id;
 	const char *spec_str;
@@ -4911,24 +4958,24 @@ static int bpf_core_reloc_field(struct bpf_progra=
m *prog,
 	if (str_is_empty(spec_str))
 		return -EINVAL;
=20
-	err =3D bpf_core_spec_parse(local_btf, local_id, spec_str, &local_spec)=
;
+	err =3D bpf_core_parse_spec(local_btf, local_id, spec_str, relo->kind, =
&local_spec);
 	if (err) {
-		pr_warn("prog '%s': relo #%d: parsing [%d] %s + %s failed: %d\n",
-			prog_name, relo_idx, local_id, local_name, spec_str,
-			err);
+		pr_warn("prog '%s': relo #%d: parsing [%d] %s %s + %s failed: %d\n",
+			prog_name, relo_idx, local_id, btf_kind_str(local_type),
+			local_name, spec_str, err);
 		return -EINVAL;
 	}
=20
-	pr_debug("prog '%s': relo #%d: kind %d, spec is ", prog_name, relo_idx,
-		 relo->kind);
+	pr_debug("prog '%s': relo #%d: kind <%s> (%d), spec is ", prog_name,
+		 relo_idx, core_relo_kind_str(relo->kind), relo->kind);
 	bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
 	libbpf_print(LIBBPF_DEBUG, "\n");
=20
 	if (!hashmap__find(cand_cache, type_key, (void **)&cand_ids)) {
 		cand_ids =3D bpf_core_find_cands(local_btf, local_id, targ_btf);
 		if (IS_ERR(cand_ids)) {
-			pr_warn("prog '%s': relo #%d: target candidate search failed for [%d]=
 %s: %ld",
-				prog_name, relo_idx, local_id, local_name,
+			pr_warn("prog '%s': relo #%d: target candidate search failed for [%d]=
 %s %s: %ld",
+				prog_name, relo_idx, local_id, btf_kind_str(local_type), local_name,
 				PTR_ERR(cand_ids));
 			return PTR_ERR(cand_ids);
 		}
@@ -4941,20 +4988,20 @@ static int bpf_core_reloc_field(struct bpf_progra=
m *prog,
=20
 	for (i =3D 0, j =3D 0; i < cand_ids->len; i++) {
 		cand_id =3D cand_ids->data[i];
-		cand_type =3D btf__type_by_id(targ_btf, cand_id);
-		cand_name =3D btf__name_by_offset(targ_btf, cand_type->name_off);
-
-		err =3D bpf_core_spec_match(&local_spec, targ_btf,
-					  cand_id, &cand_spec);
-		pr_debug("prog '%s': relo #%d: matching candidate #%d %s against spec =
",
-			 prog_name, relo_idx, i, cand_name);
-		bpf_core_dump_spec(LIBBPF_DEBUG, &cand_spec);
-		libbpf_print(LIBBPF_DEBUG, ": %d\n", err);
+		err =3D bpf_core_spec_match(&local_spec, targ_btf, cand_id, &cand_spec=
);
 		if (err < 0) {
-			pr_warn("prog '%s': relo #%d: matching error: %d\n",
-				prog_name, relo_idx, err);
+			pr_warn("prog '%s': relo #%d: error matching candidate #%d ",
+				prog_name, relo_idx, i);
+			bpf_core_dump_spec(LIBBPF_WARN, &cand_spec);
+			libbpf_print(LIBBPF_WARN, ": %d\n", err);
 			return err;
 		}
+
+		pr_debug("prog '%s': relo #%d: %s candidate #%d ", prog_name,
+			 relo_idx, err =3D=3D 0 ? "non-matching" : "matching", i);
+		bpf_core_dump_spec(LIBBPF_DEBUG, &cand_spec);
+		libbpf_print(LIBBPF_DEBUG, "\n");
+
 		if (err =3D=3D 0)
 			continue;
=20
@@ -4996,8 +5043,8 @@ static int bpf_core_reloc_field(struct bpf_program =
*prog,
 	 * to a specific instruction number in its log.
 	 */
 	if (j =3D=3D 0)
-		pr_debug("prog '%s': relo #%d: no matching targets found for [%d] %s +=
 %s\n",
-			 prog_name, relo_idx, local_id, local_name, spec_str);
+		pr_debug("prog '%s': relo #%d: no matching targets found\n",
+			 prog_name, relo_idx);
=20
 	/* bpf_core_reloc_insn should know how to handle missing targ_spec */
 	err =3D bpf_core_reloc_insn(prog, relo, relo_idx, &local_spec,
@@ -5012,10 +5059,10 @@ static int bpf_core_reloc_field(struct bpf_progra=
m *prog,
 }
=20
 static int
-bpf_core_reloc_fields(struct bpf_object *obj, const char *targ_btf_path)
+bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_p=
ath)
 {
 	const struct btf_ext_info_sec *sec;
-	const struct bpf_field_reloc *rec;
+	const struct bpf_core_relo *rec;
 	const struct btf_ext_info *seg;
 	struct hashmap_entry *entry;
 	struct hashmap *cand_cache =3D NULL;
@@ -5024,6 +5071,9 @@ bpf_core_reloc_fields(struct bpf_object *obj, const=
 char *targ_btf_path)
 	const char *sec_name;
 	int i, err =3D 0;
=20
+	if (obj->btf_ext->core_relo_info.len =3D=3D 0)
+		return 0;
+
 	if (targ_btf_path)
 		targ_btf =3D btf__parse_elf(targ_btf_path, NULL);
 	else
@@ -5039,7 +5089,7 @@ bpf_core_reloc_fields(struct bpf_object *obj, const=
 char *targ_btf_path)
 		goto out;
 	}
=20
-	seg =3D &obj->btf_ext->field_reloc_info;
+	seg =3D &obj->btf_ext->core_relo_info;
 	for_each_btf_ext_sec(seg, sec) {
 		sec_name =3D btf__name_by_offset(obj->btf, sec->sec_name_off);
 		if (str_is_empty(sec_name)) {
@@ -5087,17 +5137,6 @@ bpf_core_reloc_fields(struct bpf_object *obj, cons=
t char *targ_btf_path)
 	return err;
 }
=20
-static int
-bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_p=
ath)
-{
-	int err =3D 0;
-
-	if (obj->btf_ext->field_reloc_info.len)
-		err =3D bpf_core_reloc_fields(obj, targ_btf_path);
-
-	return err;
-}
-
 static int
 bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj=
,
 			struct reloc_desc *relo)
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index 50d70e90d5f1..b776a7125c92 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -138,6 +138,44 @@ struct btf_ext_info {
 	     i < (sec)->num_info;					\
 	     i++, rec =3D (void *)rec + (seg)->rec_size)
=20
+/*
+ * The .BTF.ext ELF section layout defined as
+ *   struct btf_ext_header
+ *   func_info subsection
+ *
+ * The func_info subsection layout:
+ *   record size for struct bpf_func_info in the func_info subsection
+ *   struct btf_sec_func_info for section #1
+ *   a list of bpf_func_info records for section #1
+ *     where struct bpf_func_info mimics one in include/uapi/linux/bpf.h
+ *     but may not be identical
+ *   struct btf_sec_func_info for section #2
+ *   a list of bpf_func_info records for section #2
+ *   ......
+ *
+ * Note that the bpf_func_info record size in .BTF.ext may not
+ * be the same as the one defined in include/uapi/linux/bpf.h.
+ * The loader should ensure that record_size meets minimum
+ * requirement and pass the record as is to the kernel. The
+ * kernel will handle the func_info properly based on its contents.
+ */
+struct btf_ext_header {
+	__u16	magic;
+	__u8	version;
+	__u8	flags;
+	__u32	hdr_len;
+
+	/* All offsets are in bytes relative to the end of this header */
+	__u32	func_info_off;
+	__u32	func_info_len;
+	__u32	line_info_off;
+	__u32	line_info_len;
+
+	/* optional part of .BTF.ext header */
+	__u32	core_relo_off;
+	__u32	core_relo_len;
+};
+
 struct btf_ext {
 	union {
 		struct btf_ext_header *hdr;
@@ -145,7 +183,7 @@ struct btf_ext {
 	};
 	struct btf_ext_info func_info;
 	struct btf_ext_info line_info;
-	struct btf_ext_info field_reloc_info;
+	struct btf_ext_info core_relo_info;
 	__u32 data_size;
 };
=20
@@ -170,32 +208,34 @@ struct bpf_line_info_min {
 	__u32	line_col;
 };
=20
-/* bpf_field_info_kind encodes which aspect of captured field has to be
- * adjusted by relocations. Currently supported values are:
- *   - BPF_FIELD_BYTE_OFFSET: field offset (in bytes);
- *   - BPF_FIELD_EXISTS: field existence (1, if field exists; 0, otherwi=
se);
+/* bpf_core_relo_kind encodes which aspect of captured field/type/enum v=
alue
+ * has to be adjusted by relocations.
  */
-enum bpf_field_info_kind {
+enum bpf_core_relo_kind {
 	BPF_FIELD_BYTE_OFFSET =3D 0,	/* field byte offset */
-	BPF_FIELD_BYTE_SIZE =3D 1,
+	BPF_FIELD_BYTE_SIZE =3D 1,	/* field size in bytes */
 	BPF_FIELD_EXISTS =3D 2,		/* field existence in target kernel */
-	BPF_FIELD_SIGNED =3D 3,
-	BPF_FIELD_LSHIFT_U64 =3D 4,
-	BPF_FIELD_RSHIFT_U64 =3D 5,
+	BPF_FIELD_SIGNED =3D 3,		/* field signedness (0 - unsigned, 1 - signed)=
 */
+	BPF_FIELD_LSHIFT_U64 =3D 4,	/* bitfield-specific left bitshift */
+	BPF_FIELD_RSHIFT_U64 =3D 5,	/* bitfield-specific right bitshift */
 };
=20
-/* The minimum bpf_field_reloc checked by the loader
+/* The minimum bpf_core_relo checked by the loader
  *
- * Field relocation captures the following data:
+ * CO-RE relocation captures the following data:
  * - insn_off - instruction offset (in bytes) within a BPF program that =
needs
  *   its insn->imm field to be relocated with actual field info;
  * - type_id - BTF type ID of the "root" (containing) entity of a reloca=
table
- *   field;
+ *   type or field;
  * - access_str_off - offset into corresponding .BTF string section. Str=
ing
- *   itself encodes an accessed field using a sequence of field and arra=
y
- *   indicies, separated by colon (:). It's conceptually very close to L=
LVM's
- *   getelementptr ([0]) instruction's arguments for identifying offset =
to=20
- *   a field.
+ *   interpretation depends on specific relocation kind:
+ *     - for field-based relocations, string encodes an accessed field u=
sing
+ *     a sequence of field and array indices, separated by colon (:). It=
's
+ *     conceptually very close to LLVM's getelementptr ([0]) instruction=
's
+ *     arguments for identifying offset to a field.
+ *     - for type-based relocations, strings is expected to be just "0";
+ *     - for enum value-based relocations, string contains an index of e=
num
+ *     value within its enum type;
  *
  * Example to provide a better feel.
  *
@@ -226,11 +266,11 @@ enum bpf_field_info_kind {
  *
  *   [0] https://llvm.org/docs/LangRef.html#getelementptr-instruction
  */
-struct bpf_field_reloc {
+struct bpf_core_relo {
 	__u32   insn_off;
 	__u32   type_id;
 	__u32   access_str_off;
-	enum bpf_field_info_kind kind;
+	enum bpf_core_relo_kind kind;
 };
=20
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
--=20
2.24.1

