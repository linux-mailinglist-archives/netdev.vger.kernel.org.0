Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A0024910A
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgHRWjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:39:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726967AbgHRWji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:39:38 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IMGPOI002574
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:39:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ujQ+cWhFvwQxx/8+H6IqcdGca6Gtplu5eVO6tqP0ldA=;
 b=mhhBfdjGtaagf+oq0Vra24nmOHRbzMs1dcX8P6eDC7NxxBCqRK5KoqQCNjaN2BC2TwDF
 qDILyId+hYPhDvNJtzF5Nvg5L8OB8CfdYsqlqn0MZr/HsirnXWl1BACvI+WmU1SPYpud
 yoRnszSu/Xux8Yk7hk8hfB5nk5snnXOQ2yI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304pawdrp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:39:37 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 15:39:36 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E3F5C2EC5EB9; Tue, 18 Aug 2020 15:39:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/9] libbpf: improve relocation ambiguity detection
Date:   Tue, 18 Aug 2020 15:39:15 -0700
Message-ID: <20200818223921.2911963-4-andriin@fb.com>
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
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the instruction patching logic into relocation value calculation an=
d
application of relocation to instruction. Using this, evaluate relocation
against each matching candidate and validate that all candidates agree on
relocated value. If not, report ambiguity and fail load.

This logic is necessary to avoid dangerous (however unlikely) accidental =
match
against two incompatible candidate types. Without this change, libbpf wil=
l
pick a random type as *the* candidate and apply potentially invalid
relocation.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 170 ++++++++++++++++++++++++++++++-----------
 1 file changed, 124 insertions(+), 46 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2047e4ed0076..1ba458140f50 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4616,14 +4616,25 @@ static int bpf_core_calc_field_relo(const struct =
bpf_program *prog,
 				    const struct bpf_core_spec *spec,
 				    __u32 *val, bool *validate)
 {
-	const struct bpf_core_accessor *acc =3D &spec->spec[spec->len - 1];
-	const struct btf_type *t =3D btf__type_by_id(spec->btf, acc->type_id);
+	const struct bpf_core_accessor *acc;
+	const struct btf_type *t;
 	__u32 byte_off, byte_sz, bit_off, bit_sz;
 	const struct btf_member *m;
 	const struct btf_type *mt;
 	bool bitfield;
 	__s64 sz;
=20
+	if (relo->kind =3D=3D BPF_FIELD_EXISTS) {
+		*val =3D spec ? 1 : 0;
+		return 0;
+	}
+
+	if (!spec)
+		return -EUCLEAN; /* request instruction poisoning */
+
+	acc =3D &spec->spec[spec->len - 1];
+	t =3D btf__type_by_id(spec->btf, acc->type_id);
+
 	/* a[n] accessor needs special handling */
 	if (!acc->name) {
 		if (relo->kind =3D=3D BPF_FIELD_BYTE_OFFSET) {
@@ -4709,21 +4720,88 @@ static int bpf_core_calc_field_relo(const struct =
bpf_program *prog,
 		break;
 	case BPF_FIELD_EXISTS:
 	default:
-		pr_warn("prog '%s': unknown relo %d at insn #%d\n",
-			bpf_program__title(prog, false),
-			relo->kind, relo->insn_off / 8);
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
=20
 	return 0;
 }
=20
+struct bpf_core_relo_res
+{
+	/* expected value in the instruction, unless validate =3D=3D false */
+	__u32 orig_val;
+	/* new value that needs to be patched up to */
+	__u32 new_val;
+	/* relocation unsuccessful, poison instruction, but don't fail load */
+	bool poison;
+	/* some relocations can't be validated against orig_val */
+	bool validate;
+};
+
+/* Calculate original and target relocation values, given local and targ=
et
+ * specs and relocation kind. These values are calculated for each candi=
date.
+ * If there are multiple candidates, resulting values should all be cons=
istent
+ * with each other. Otherwise, libbpf will refuse to proceed due to ambi=
guity.
+ * If instruction has to be poisoned, *poison will be set to true.
+ */
+static int bpf_core_calc_relo(const struct bpf_program *prog,
+			      const struct bpf_core_relo *relo,
+			      int relo_idx,
+			      const struct bpf_core_spec *local_spec,
+			      const struct bpf_core_spec *targ_spec,
+			      struct bpf_core_relo_res *res)
+{
+	int err =3D -EOPNOTSUPP;
+
+	res->orig_val =3D 0;
+	res->new_val =3D 0;
+	res->poison =3D false;
+	res->validate =3D true;
+
+	if (core_relo_is_field_based(relo->kind)) {
+		err =3D bpf_core_calc_field_relo(prog, relo, local_spec, &res->orig_va=
l, &res->validate);
+		err =3D err ?: bpf_core_calc_field_relo(prog, relo, targ_spec, &res->n=
ew_val, NULL);
+	}
+
+	if (err =3D=3D -EUCLEAN) {
+		/* EUCLEAN is used to signal instruction poisoning request */
+		res->poison =3D true;
+		err =3D 0;
+	} else if (err =3D=3D -EOPNOTSUPP) {
+		/* EOPNOTSUPP means unknown/unsupported relocation */
+		pr_warn("prog '%s': relo #%d: unrecognized CO-RE relocation %s (%d) at=
 insn #%d\n",
+			bpf_program__title(prog, false), relo_idx,
+			core_relo_kind_str(relo->kind), relo->kind, relo->insn_off / 8);
+	}
+
+	return err;
+}
+
+/*
+ * Turn instruction for which CO_RE relocation failed into invalid one w=
ith
+ * distinct signature.
+ */
+static void bpf_core_poison_insn(struct bpf_program *prog, int relo_idx,
+				 int insn_idx, struct bpf_insn *insn)
+{
+	pr_debug("prog '%s': relo #%d: substituting insn #%d w/ invalid insn\n"=
,
+		 bpf_program__title(prog, false), relo_idx, insn_idx);
+	insn->code =3D BPF_JMP | BPF_CALL;
+	insn->dst_reg =3D 0;
+	insn->src_reg =3D 0;
+	insn->off =3D 0;
+	/* if this instruction is reachable (not a dead code),
+	 * verifier will complain with the following message:
+	 * invalid func unknown#195896080
+	 */
+	insn->imm =3D 195896080; /* =3D> 0xbad2310 =3D> "bad relo" */
+}
+
 /*
  * Patch relocatable BPF instruction.
  *
  * Patched value is determined by relocation kind and target specificati=
on.
- * For field existence relocation target spec will be NULL if field is n=
ot
- * found.
+ * For existence relocations target spec will be NULL if field/type is n=
ot found.
  * Expected insn->imm value is determined using relocation kind and loca=
l
  * spec, and is checked before patching instruction. If actual insn->imm=
 value
  * is wrong, bail out with error.
@@ -4732,16 +4810,14 @@ static int bpf_core_calc_field_relo(const struct =
bpf_program *prog,
  * 1. rX =3D <imm> (assignment with immediate operand);
  * 2. rX +=3D <imm> (arithmetic operations with immediate operand);
  */
-static int bpf_core_reloc_insn(struct bpf_program *prog,
+static int bpf_core_patch_insn(struct bpf_program *prog,
 			       const struct bpf_core_relo *relo,
 			       int relo_idx,
-			       const struct bpf_core_spec *local_spec,
-			       const struct bpf_core_spec *targ_spec)
+			       const struct bpf_core_relo_res *res)
 {
 	__u32 orig_val, new_val;
 	struct bpf_insn *insn;
-	bool validate =3D true;
-	int insn_idx, err;
+	int insn_idx;
 	__u8 class;
=20
 	if (relo->insn_off % sizeof(struct bpf_insn))
@@ -4750,39 +4826,20 @@ static int bpf_core_reloc_insn(struct bpf_program=
 *prog,
 	insn =3D &prog->insns[insn_idx];
 	class =3D BPF_CLASS(insn->code);
=20
-	if (relo->kind =3D=3D BPF_FIELD_EXISTS) {
-		orig_val =3D 1; /* can't generate EXISTS relo w/o local field */
-		new_val =3D targ_spec ? 1 : 0;
-	} else if (!targ_spec) {
-		pr_debug("prog '%s': relo #%d: substituting insn #%d w/ invalid insn\n=
",
-			 bpf_program__title(prog, false), relo_idx, insn_idx);
-		insn->code =3D BPF_JMP | BPF_CALL;
-		insn->dst_reg =3D 0;
-		insn->src_reg =3D 0;
-		insn->off =3D 0;
-		/* if this instruction is reachable (not a dead code),
-		 * verifier will complain with the following message:
-		 * invalid func unknown#195896080
-		 */
-		insn->imm =3D 195896080; /* =3D> 0xbad2310 =3D> "bad relo" */
+	if (res->poison) {
+		bpf_core_poison_insn(prog, relo_idx, insn_idx, insn);
 		return 0;
-	} else {
-		err =3D bpf_core_calc_field_relo(prog, relo, local_spec,
-					       &orig_val, &validate);
-		if (err)
-			return err;
-		err =3D bpf_core_calc_field_relo(prog, relo, targ_spec,
-					       &new_val, NULL);
-		if (err)
-			return err;
 	}
=20
+	orig_val =3D res->orig_val;
+	new_val =3D res->new_val;
+
 	switch (class) {
 	case BPF_ALU:
 	case BPF_ALU64:
 		if (BPF_SRC(insn->code) !=3D BPF_K)
 			return -EINVAL;
-		if (validate && insn->imm !=3D orig_val) {
+		if (res->validate && insn->imm !=3D orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (ALU/ALU64) value: =
got %u, exp %u -> %u\n",
 				bpf_program__title(prog, false), relo_idx,
 				insn_idx, insn->imm, orig_val, new_val);
@@ -4797,7 +4854,7 @@ static int bpf_core_reloc_insn(struct bpf_program *=
prog,
 	case BPF_LDX:
 	case BPF_ST:
 	case BPF_STX:
-		if (validate && insn->off !=3D orig_val) {
+		if (res->validate && insn->off !=3D orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LD/LDX/ST/STX) val=
ue: got %u, exp %u -> %u\n",
 				bpf_program__title(prog, false), relo_idx,
 				insn_idx, insn->off, orig_val, new_val);
@@ -4938,6 +4995,7 @@ static int bpf_core_reloc_field(struct bpf_program =
*prog,
 	const char *prog_name =3D bpf_program__title(prog, false);
 	struct bpf_core_spec local_spec, cand_spec, targ_spec;
 	const void *type_key =3D u32_as_hash_key(relo->type_id);
+	struct bpf_core_relo_res cand_res, targ_res;
 	const struct btf_type *local_type;
 	const char *local_name;
 	struct ids_vec *cand_ids;
@@ -5005,16 +5063,31 @@ static int bpf_core_reloc_field(struct bpf_progra=
m *prog,
 		if (err =3D=3D 0)
 			continue;
=20
+		err =3D bpf_core_calc_relo(prog, relo, relo_idx, &local_spec, &cand_sp=
ec, &cand_res);
+		if (err)
+			return err;
+
 		if (j =3D=3D 0) {
+			targ_res =3D cand_res;
 			targ_spec =3D cand_spec;
 		} else if (cand_spec.bit_offset !=3D targ_spec.bit_offset) {
-			/* if there are many candidates, they should all
-			 * resolve to the same bit offset
+			/* if there are many field relo candidates, they
+			 * should all resolve to the same bit offset
 			 */
-			pr_warn("prog '%s': relo #%d: offset ambiguity: %u !=3D %u\n",
+			pr_warn("prog '%s': relo #%d: field offset ambiguity: %u !=3D %u\n",
 				prog_name, relo_idx, cand_spec.bit_offset,
 				targ_spec.bit_offset);
 			return -EINVAL;
+		} else if (cand_res.poison !=3D targ_res.poison || cand_res.new_val !=3D=
 targ_res.new_val) {
+			/* all candidates should result in the same relocation
+			 * decision and value, otherwise it's dangerous to
+			 * proceed due to ambiguity
+			 */
+			pr_warn("prog '%s': relo #%d: relocation decision ambiguity: %s %u !=3D=
 %s %u\n",
+				prog_name, relo_idx,
+				cand_res.poison ? "failure" : "success", cand_res.new_val,
+				targ_res.poison ? "failure" : "success", targ_res.new_val);
+			return -EINVAL;
 		}
=20
 		cand_ids->data[j++] =3D cand_spec.spec[0].type_id;
@@ -5042,13 +5115,18 @@ static int bpf_core_reloc_field(struct bpf_progra=
m *prog,
 	 * verifier. If it was an error, then verifier will complain and point
 	 * to a specific instruction number in its log.
 	 */
-	if (j =3D=3D 0)
+	if (j =3D=3D 0) {
 		pr_debug("prog '%s': relo #%d: no matching targets found\n",
 			 prog_name, relo_idx);
=20
-	/* bpf_core_reloc_insn should know how to handle missing targ_spec */
-	err =3D bpf_core_reloc_insn(prog, relo, relo_idx, &local_spec,
-				  j ? &targ_spec : NULL);
+		/* calculate single target relo result explicitly */
+		err =3D bpf_core_calc_relo(prog, relo, relo_idx, &local_spec, NULL, &t=
arg_res);
+		if (err)
+			return err;
+	}
+
+	/* bpf_core_patch_insn() should know how to handle missing targ_spec */
+	err =3D bpf_core_patch_insn(prog, relo, relo_idx, &targ_res);
 	if (err) {
 		pr_warn("prog '%s': relo #%d: failed to patch insn at offset %d: %d\n"=
,
 			prog_name, relo_idx, relo->insn_off, err);
--=20
2.24.1

