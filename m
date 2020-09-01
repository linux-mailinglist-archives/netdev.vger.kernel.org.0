Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B419725856C
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgIABut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:50:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60834 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727020AbgIABum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:50:42 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0811oCHu014938
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=MZYTgs054aI2pdvN4mKlp7nhrK0YtMrGQo2HYohZC90=;
 b=A3QIqTRl8ED9p7kFe5dM3BwBCBXor9IT4lLmjSk4j6YdG1vfzpjocP04bl9bDzaLDoxQ
 fy/kAeux/DqyRX3+jrK72ywnot/buGW4LsW9HmRbYbi1U7NjUTVP5E7nXO4R+HfJZKmA
 prMaYGKHinFNxsvPNvENm8VTI02vUlCMts8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 337jh03be9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:37 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 18:50:36 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 32D0B2EC663B; Mon, 31 Aug 2020 18:50:26 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 10/14] libbpf: deprecate notion of BPF program "title" in favor of "section name"
Date:   Mon, 31 Aug 2020 18:49:59 -0700
Message-ID: <20200901015003.2871861-11-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200901015003.2871861-1-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_01:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 phishscore=0 suspectscore=29 impostorscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF program title is ambigious and misleading term. It is ELF section nam=
e, so
let's just call it that and deprecate bpf_program__title() API in favor o=
f
bpf_program__section_name().

Additionally, using bpf_object__find_program_by_title() is now inherently
dangerous and ambiguous, as multiple BPF program can have the same sectio=
n
name. So deprecate this API as well and recommend to switch to non-ambigu=
ous
bpf_object__find_program_by_name().

Internally, clean up usage and mis-usage of BPF program section name for
denoting BPF program name. Shorten the field name to prog->sec_name to be
consistent with all other prog->sec_* variables.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 215 ++++++++++++++++++---------------------
 tools/lib/bpf/libbpf.h   |   5 +-
 tools/lib/bpf/libbpf.map |   1 +
 3 files changed, 101 insertions(+), 120 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1485e562ec32..f65502d2963d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -217,7 +217,7 @@ struct bpf_sec_def {
  */
 struct bpf_program {
 	const struct bpf_sec_def *sec_def;
-	char *section_name;
+	char *sec_name;
 	size_t sec_idx;
 	/* this program's instruction offset (in number of instructions)
 	 * within its containing ELF section
@@ -239,7 +239,7 @@ struct bpf_program {
 	size_t sub_insn_off;
=20
 	char *name;
-	/* section_name with / replaced by _; makes recursive pinning
+	/* sec_name with / replaced by _; makes recursive pinning
 	 * in bpf_object__pin_programs easier
 	 */
 	char *pin_name;
@@ -515,7 +515,7 @@ static void bpf_program__exit(struct bpf_program *pro=
g)
=20
 	bpf_program__unload(prog);
 	zfree(&prog->name);
-	zfree(&prog->section_name);
+	zfree(&prog->sec_name);
 	zfree(&prog->pin_name);
 	zfree(&prog->insns);
 	zfree(&prog->reloc_desc);
@@ -529,7 +529,7 @@ static char *__bpf_program__pin_name(struct bpf_progr=
am *prog)
 {
 	char *name, *p;
=20
-	name =3D p =3D strdup(prog->section_name);
+	name =3D p =3D strdup(prog->sec_name);
 	while ((p =3D strchr(p, '/')))
 		*p =3D '_';
=20
@@ -574,8 +574,8 @@ bpf_object__init_prog(struct bpf_object *obj, struct =
bpf_program *prog,
 	prog->instances.fds =3D NULL;
 	prog->instances.nr =3D -1;
=20
-	prog->section_name =3D strdup(sec_name);
-	if (!prog->section_name)
+	prog->sec_name =3D strdup(sec_name);
+	if (!prog->sec_name)
 		goto errout;
=20
 	prog->name =3D strdup(name);
@@ -3254,7 +3254,7 @@ bpf_object__find_program_by_title(const struct bpf_=
object *obj,
 	struct bpf_program *pos;
=20
 	bpf_object__for_each_program(pos, obj) {
-		if (pos->section_name && !strcmp(pos->section_name, title))
+		if (pos->sec_name && !strcmp(pos->sec_name, title))
 			return pos;
 	}
 	return NULL;
@@ -4994,8 +4994,7 @@ static int bpf_core_calc_field_relo(const struct bp=
f_program *prog,
 			*val =3D sz;
 		} else {
 			pr_warn("prog '%s': relo %d at insn #%d can't be applied to array acc=
ess\n",
-				bpf_program__title(prog, false),
-				relo->kind, relo->insn_off / 8);
+				prog->name, relo->kind, relo->insn_off / 8);
 			return -EINVAL;
 		}
 		if (validate)
@@ -5017,8 +5016,7 @@ static int bpf_core_calc_field_relo(const struct bp=
f_program *prog,
 			if (byte_sz >=3D 8) {
 				/* bitfield can't be read with 64-bit read */
 				pr_warn("prog '%s': relo %d at insn #%d can't be satisfied for bitfi=
eld\n",
-					bpf_program__title(prog, false),
-					relo->kind, relo->insn_off / 8);
+					prog->name, relo->kind, relo->insn_off / 8);
 				return -E2BIG;
 			}
 			byte_sz *=3D 2;
@@ -5183,8 +5181,8 @@ static int bpf_core_calc_relo(const struct bpf_prog=
ram *prog,
 	} else if (err =3D=3D -EOPNOTSUPP) {
 		/* EOPNOTSUPP means unknown/unsupported relocation */
 		pr_warn("prog '%s': relo #%d: unrecognized CO-RE relocation %s (%d) at=
 insn #%d\n",
-			bpf_program__title(prog, false), relo_idx,
-			core_relo_kind_str(relo->kind), relo->kind, relo->insn_off / 8);
+			prog->name, relo_idx, core_relo_kind_str(relo->kind),
+			relo->kind, relo->insn_off / 8);
 	}
=20
 	return err;
@@ -5198,7 +5196,7 @@ static void bpf_core_poison_insn(struct bpf_program=
 *prog, int relo_idx,
 				 int insn_idx, struct bpf_insn *insn)
 {
 	pr_debug("prog '%s': relo #%d: substituting insn #%d w/ invalid insn\n"=
,
-		 bpf_program__title(prog, false), relo_idx, insn_idx);
+		 prog->name, relo_idx, insn_idx);
 	insn->code =3D BPF_JMP | BPF_CALL;
 	insn->dst_reg =3D 0;
 	insn->src_reg =3D 0;
@@ -5270,14 +5268,14 @@ static int bpf_core_patch_insn(struct bpf_program=
 *prog,
 			return -EINVAL;
 		if (res->validate && insn->imm !=3D orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (ALU/ALU64) value: =
got %u, exp %u -> %u\n",
-				bpf_program__title(prog, false), relo_idx,
+				prog->name, relo_idx,
 				insn_idx, insn->imm, orig_val, new_val);
 			return -EINVAL;
 		}
 		orig_val =3D insn->imm;
 		insn->imm =3D new_val;
 		pr_debug("prog '%s': relo #%d: patched insn #%d (ALU/ALU64) imm %u -> =
%u\n",
-			 bpf_program__title(prog, false), relo_idx, insn_idx,
+			 prog->name, relo_idx, insn_idx,
 			 orig_val, new_val);
 		break;
 	case BPF_LDX:
@@ -5285,21 +5283,18 @@ static int bpf_core_patch_insn(struct bpf_program=
 *prog,
 	case BPF_STX:
 		if (res->validate && insn->off !=3D orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDX/ST/STX) value:=
 got %u, exp %u -> %u\n",
-				bpf_program__title(prog, false), relo_idx,
-				insn_idx, insn->off, orig_val, new_val);
+				prog->name, relo_idx, insn_idx, insn->off, orig_val, new_val);
 			return -EINVAL;
 		}
 		if (new_val > SHRT_MAX) {
 			pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) value too big: %u=
\n",
-				bpf_program__title(prog, false), relo_idx,
-				insn_idx, new_val);
+				prog->name, relo_idx, insn_idx, new_val);
 			return -ERANGE;
 		}
 		orig_val =3D insn->off;
 		insn->off =3D new_val;
 		pr_debug("prog '%s': relo #%d: patched insn #%d (LDX/ST/STX) off %u ->=
 %u\n",
-			 bpf_program__title(prog, false), relo_idx, insn_idx,
-			 orig_val, new_val);
+			 prog->name, relo_idx, insn_idx, orig_val, new_val);
 		break;
 	case BPF_LD: {
 		__u64 imm;
@@ -5310,14 +5305,14 @@ static int bpf_core_patch_insn(struct bpf_program=
 *prog,
 		    insn[1].code !=3D 0 || insn[1].dst_reg !=3D 0 ||
 		    insn[1].src_reg !=3D 0 || insn[1].off !=3D 0) {
 			pr_warn("prog '%s': relo #%d: insn #%d (LDIMM64) has unexpected form\=
n",
-				bpf_program__title(prog, false), relo_idx, insn_idx);
+				prog->name, relo_idx, insn_idx);
 			return -EINVAL;
 		}
=20
 		imm =3D insn[0].imm + ((__u64)insn[1].imm << 32);
 		if (res->validate && imm !=3D orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDIMM64) value: go=
t %llu, exp %u -> %u\n",
-				bpf_program__title(prog, false), relo_idx,
+				prog->name, relo_idx,
 				insn_idx, (unsigned long long)imm,
 				orig_val, new_val);
 			return -EINVAL;
@@ -5326,15 +5321,14 @@ static int bpf_core_patch_insn(struct bpf_program=
 *prog,
 		insn[0].imm =3D new_val;
 		insn[1].imm =3D 0; /* currently only 32-bit values are supported */
 		pr_debug("prog '%s': relo #%d: patched insn #%d (LDIMM64) imm64 %llu -=
> %u\n",
-			 bpf_program__title(prog, false), relo_idx, insn_idx,
+			 prog->name, relo_idx, insn_idx,
 			 (unsigned long long)imm, new_val);
 		break;
 	}
 	default:
 		pr_warn("prog '%s': relo #%d: trying to relocate unrecognized insn #%d=
, code:0x%x, src:0x%x, dst:0x%x, off:0x%x, imm:0x%x\n",
-			bpf_program__title(prog, false), relo_idx,
-			insn_idx, insn->code, insn->src_reg, insn->dst_reg,
-			insn->off, insn->imm);
+			prog->name, relo_idx, insn_idx, insn->code,
+			insn->src_reg, insn->dst_reg, insn->off, insn->imm);
 		return -EINVAL;
 	}
=20
@@ -5464,7 +5458,6 @@ static int bpf_core_apply_relo(struct bpf_program *=
prog,
 			       const struct btf *targ_btf,
 			       struct hashmap *cand_cache)
 {
-	const char *prog_name =3D bpf_program__title(prog, false);
 	struct bpf_core_spec local_spec, cand_spec, targ_spec =3D {};
 	const void *type_key =3D u32_as_hash_key(relo->type_id);
 	struct bpf_core_relo_res cand_res, targ_res;
@@ -5491,13 +5484,13 @@ static int bpf_core_apply_relo(struct bpf_program=
 *prog,
 	err =3D bpf_core_parse_spec(local_btf, local_id, spec_str, relo->kind, =
&local_spec);
 	if (err) {
 		pr_warn("prog '%s': relo #%d: parsing [%d] %s %s + %s failed: %d\n",
-			prog_name, relo_idx, local_id, btf_kind_str(local_type),
+			prog->name, relo_idx, local_id, btf_kind_str(local_type),
 			str_is_empty(local_name) ? "<anon>" : local_name,
 			spec_str, err);
 		return -EINVAL;
 	}
=20
-	pr_debug("prog '%s': relo #%d: kind <%s> (%d), spec is ", prog_name,
+	pr_debug("prog '%s': relo #%d: kind <%s> (%d), spec is ", prog->name,
 		 relo_idx, core_relo_kind_str(relo->kind), relo->kind);
 	bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
 	libbpf_print(LIBBPF_DEBUG, "\n");
@@ -5514,7 +5507,7 @@ static int bpf_core_apply_relo(struct bpf_program *=
prog,
 	/* libbpf doesn't support candidate search for anonymous types */
 	if (str_is_empty(spec_str)) {
 		pr_warn("prog '%s': relo #%d: <%s> (%d) relocation doesn't support ano=
nymous types\n",
-			prog_name, relo_idx, core_relo_kind_str(relo->kind), relo->kind);
+			prog->name, relo_idx, core_relo_kind_str(relo->kind), relo->kind);
 		return -EOPNOTSUPP;
 	}
=20
@@ -5522,7 +5515,7 @@ static int bpf_core_apply_relo(struct bpf_program *=
prog,
 		cand_ids =3D bpf_core_find_cands(local_btf, local_id, targ_btf);
 		if (IS_ERR(cand_ids)) {
 			pr_warn("prog '%s': relo #%d: target candidate search failed for [%d]=
 %s %s: %ld",
-				prog_name, relo_idx, local_id, btf_kind_str(local_type),
+				prog->name, relo_idx, local_id, btf_kind_str(local_type),
 				local_name, PTR_ERR(cand_ids));
 			return PTR_ERR(cand_ids);
 		}
@@ -5538,13 +5531,13 @@ static int bpf_core_apply_relo(struct bpf_program=
 *prog,
 		err =3D bpf_core_spec_match(&local_spec, targ_btf, cand_id, &cand_spec=
);
 		if (err < 0) {
 			pr_warn("prog '%s': relo #%d: error matching candidate #%d ",
-				prog_name, relo_idx, i);
+				prog->name, relo_idx, i);
 			bpf_core_dump_spec(LIBBPF_WARN, &cand_spec);
 			libbpf_print(LIBBPF_WARN, ": %d\n", err);
 			return err;
 		}
=20
-		pr_debug("prog '%s': relo #%d: %s candidate #%d ", prog_name,
+		pr_debug("prog '%s': relo #%d: %s candidate #%d ", prog->name,
 			 relo_idx, err =3D=3D 0 ? "non-matching" : "matching", i);
 		bpf_core_dump_spec(LIBBPF_DEBUG, &cand_spec);
 		libbpf_print(LIBBPF_DEBUG, "\n");
@@ -5564,7 +5557,7 @@ static int bpf_core_apply_relo(struct bpf_program *=
prog,
 			 * should all resolve to the same bit offset
 			 */
 			pr_warn("prog '%s': relo #%d: field offset ambiguity: %u !=3D %u\n",
-				prog_name, relo_idx, cand_spec.bit_offset,
+				prog->name, relo_idx, cand_spec.bit_offset,
 				targ_spec.bit_offset);
 			return -EINVAL;
 		} else if (cand_res.poison !=3D targ_res.poison || cand_res.new_val !=3D=
 targ_res.new_val) {
@@ -5573,7 +5566,7 @@ static int bpf_core_apply_relo(struct bpf_program *=
prog,
 			 * proceed due to ambiguity
 			 */
 			pr_warn("prog '%s': relo #%d: relocation decision ambiguity: %s %u !=3D=
 %s %u\n",
-				prog_name, relo_idx,
+				prog->name, relo_idx,
 				cand_res.poison ? "failure" : "success", cand_res.new_val,
 				targ_res.poison ? "failure" : "success", targ_res.new_val);
 			return -EINVAL;
@@ -5606,7 +5599,7 @@ static int bpf_core_apply_relo(struct bpf_program *=
prog,
 	 */
 	if (j =3D=3D 0) {
 		pr_debug("prog '%s': relo #%d: no matching targets found\n",
-			 prog_name, relo_idx);
+			 prog->name, relo_idx);
=20
 		/* calculate single target relo result explicitly */
 		err =3D bpf_core_calc_relo(prog, relo, relo_idx, &local_spec, NULL, &t=
arg_res);
@@ -5619,7 +5612,7 @@ static int bpf_core_apply_relo(struct bpf_program *=
prog,
 	err =3D bpf_core_patch_insn(prog, relo, relo_idx, &targ_res);
 	if (err) {
 		pr_warn("prog '%s': relo #%d: failed to patch insn at offset %d: %d\n"=
,
-			prog_name, relo_idx, relo->insn_off, err);
+			prog->name, relo_idx, relo->insn_off, err);
 		return -EINVAL;
 	}
=20
@@ -5673,7 +5666,7 @@ bpf_object__relocate_core(struct bpf_object *obj, c=
onst char *targ_btf_path)
 		prog =3D NULL;
 		for (i =3D 0; i < obj->nr_programs; i++) {
 			prog =3D &obj->programs[i];
-			if (strcmp(prog->section_name, sec_name) =3D=3D 0)
+			if (strcmp(prog->sec_name, sec_name) =3D=3D 0)
 				break;
 		}
 		if (!prog) {
@@ -5787,7 +5780,7 @@ static int adjust_prog_btf_ext_info(const struct bp=
f_object *obj,
 		sec_name =3D btf__name_by_offset(obj->btf, sec->sec_name_off);
 		if (!sec_name)
 			return -EINVAL;
-		if (strcmp(sec_name, prog->section_name) !=3D 0)
+		if (strcmp(sec_name, prog->sec_name) !=3D 0)
 			continue;
=20
 		for_each_btf_ext_rec(ext_info, sec, i, rec) {
@@ -6438,8 +6431,7 @@ int bpf_program__load(struct bpf_program *prog, cha=
r *license, __u32 kern_ver)
 	int err =3D 0, fd, i, btf_id;
=20
 	if (prog->obj->loaded) {
-		pr_warn("prog '%s'('%s'): can't load after object was loaded\n",
-			prog->name, prog->section_name);
+		pr_warn("prog '%s': can't load after object was loaded\n", prog->name)=
;
 		return -EINVAL;
 	}
=20
@@ -6455,7 +6447,7 @@ int bpf_program__load(struct bpf_program *prog, cha=
r *license, __u32 kern_ver)
 	if (prog->instances.nr < 0 || !prog->instances.fds) {
 		if (prog->preprocessor) {
 			pr_warn("Internal error: can't load program '%s'\n",
-				prog->section_name);
+				prog->name);
 			return -LIBBPF_ERRNO__INTERNAL;
 		}
=20
@@ -6470,8 +6462,8 @@ int bpf_program__load(struct bpf_program *prog, cha=
r *license, __u32 kern_ver)
=20
 	if (!prog->preprocessor) {
 		if (prog->instances.nr !=3D 1) {
-			pr_warn("Program '%s' is inconsistent: nr(%d) !=3D 1\n",
-				prog->section_name, prog->instances.nr);
+			pr_warn("prog '%s': inconsistent nr(%d) !=3D 1\n",
+				prog->name, prog->instances.nr);
 		}
 		err =3D load_program(prog, prog->insns, prog->insns_cnt,
 				   license, kern_ver, &fd);
@@ -6489,13 +6481,13 @@ int bpf_program__load(struct bpf_program *prog, c=
har *license, __u32 kern_ver)
 				   prog->insns_cnt, &result);
 		if (err) {
 			pr_warn("Preprocessing the %dth instance of program '%s' failed\n",
-				i, prog->section_name);
+				i, prog->name);
 			goto out;
 		}
=20
 		if (!result.new_insn_ptr || !result.new_insn_cnt) {
 			pr_debug("Skip loading the %dth instance of program '%s'\n",
-				 i, prog->section_name);
+				 i, prog->name);
 			prog->instances.fds[i] =3D -1;
 			if (result.pfd)
 				*result.pfd =3D -1;
@@ -6506,7 +6498,7 @@ int bpf_program__load(struct bpf_program *prog, cha=
r *license, __u32 kern_ver)
 				   result.new_insn_cnt, license, kern_ver, &fd);
 		if (err) {
 			pr_warn("Loading the %dth instance of program '%s' failed\n",
-				i, prog->section_name);
+				i, prog->name);
 			goto out;
 		}
=20
@@ -6516,7 +6508,7 @@ int bpf_program__load(struct bpf_program *prog, cha=
r *license, __u32 kern_ver)
 	}
 out:
 	if (err)
-		pr_warn("failed to load program '%s'\n", prog->section_name);
+		pr_warn("failed to load program '%s'\n", prog->name);
 	zfree(&prog->insns);
 	prog->insns_cnt =3D 0;
 	return err;
@@ -6608,7 +6600,7 @@ __bpf_object__open(const char *path, const void *ob=
j_buf, size_t obj_buf_sz,
 	bpf_object__elf_finish(obj);
=20
 	bpf_object__for_each_program(prog, obj) {
-		prog->sec_def =3D find_sec_def(prog->section_name);
+		prog->sec_def =3D find_sec_def(prog->sec_name);
 		if (!prog->sec_def)
 			/* couldn't guess, but user might manually specify */
 			continue;
@@ -6989,7 +6981,7 @@ int bpf_program__pin_instance(struct bpf_program *p=
rog, const char *path,
=20
 	if (instance < 0 || instance >=3D prog->instances.nr) {
 		pr_warn("invalid prog instance %d of prog %s (max %d)\n",
-			instance, prog->section_name, prog->instances.nr);
+			instance, prog->name, prog->instances.nr);
 		return -EINVAL;
 	}
=20
@@ -7020,7 +7012,7 @@ int bpf_program__unpin_instance(struct bpf_program =
*prog, const char *path,
=20
 	if (instance < 0 || instance >=3D prog->instances.nr) {
 		pr_warn("invalid prog instance %d of prog %s (max %d)\n",
-			instance, prog->section_name, prog->instances.nr);
+			instance, prog->name, prog->instances.nr);
 		return -EINVAL;
 	}
=20
@@ -7050,8 +7042,7 @@ int bpf_program__pin(struct bpf_program *prog, cons=
t char *path)
 	}
=20
 	if (prog->instances.nr <=3D 0) {
-		pr_warn("no instances of prog %s to pin\n",
-			   prog->section_name);
+		pr_warn("no instances of prog %s to pin\n", prog->name);
 		return -EINVAL;
 	}
=20
@@ -7113,8 +7104,7 @@ int bpf_program__unpin(struct bpf_program *prog, co=
nst char *path)
 	}
=20
 	if (prog->instances.nr <=3D 0) {
-		pr_warn("no instances of prog %s to pin\n",
-			   prog->section_name);
+		pr_warn("no instances of prog %s to pin\n", prog->name);
 		return -EINVAL;
 	}
=20
@@ -7649,11 +7639,16 @@ const char *bpf_program__name(const struct bpf_pr=
ogram *prog)
 	return prog->name;
 }
=20
+const char *bpf_program__section_name(const struct bpf_program *prog)
+{
+	return prog->sec_name;
+}
+
 const char *bpf_program__title(const struct bpf_program *prog, bool need=
s_copy)
 {
 	const char *title;
=20
-	title =3D prog->section_name;
+	title =3D prog->sec_name;
 	if (needs_copy) {
 		title =3D strdup(title);
 		if (!title) {
@@ -7726,14 +7721,14 @@ int bpf_program__nth_fd(const struct bpf_program =
*prog, int n)
=20
 	if (n >=3D prog->instances.nr || n < 0) {
 		pr_warn("Can't get the %dth fd from program %s: only %d instances\n",
-			n, prog->section_name, prog->instances.nr);
+			n, prog->name, prog->instances.nr);
 		return -EINVAL;
 	}
=20
 	fd =3D prog->instances.fds[n];
 	if (fd < 0) {
 		pr_warn("%dth instance of program '%s' is invalid\n",
-			n, prog->section_name);
+			n, prog->name);
 		return -ENOENT;
 	}
=20
@@ -8170,7 +8165,7 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
 		if (prog->type =3D=3D BPF_PROG_TYPE_UNSPEC) {
 			const struct bpf_sec_def *sec_def;
=20
-			sec_def =3D find_sec_def(prog->section_name);
+			sec_def =3D find_sec_def(prog->sec_name);
 			if (sec_def &&
 			    sec_def->prog_type !=3D BPF_PROG_TYPE_STRUCT_OPS) {
 				/* for pr_warn */
@@ -8193,7 +8188,7 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
=20
 invalid_prog:
 	pr_warn("struct_ops reloc %s: cannot use prog %s in sec %s with type %u=
 attach_btf_id %u expected_attach_type %u for func ptr %s\n",
-		map->name, prog->name, prog->section_name, prog->type,
+		map->name, prog->name, prog->sec_name, prog->type,
 		prog->attach_btf_id, prog->expected_attach_type, name);
 	return -EINVAL;
 }
@@ -8297,7 +8292,7 @@ static int libbpf_find_attach_btf_id(struct bpf_pro=
gram *prog)
 {
 	enum bpf_attach_type attach_type =3D prog->expected_attach_type;
 	__u32 attach_prog_fd =3D prog->attach_prog_fd;
-	const char *name =3D prog->section_name;
+	const char *name =3D prog->sec_name;
 	int i, err;
=20
 	if (!name)
@@ -8824,14 +8819,14 @@ struct bpf_link *bpf_program__attach_perf_event(s=
truct bpf_program *prog,
 	int prog_fd, err;
=20
 	if (pfd < 0) {
-		pr_warn("program '%s': invalid perf event FD %d\n",
-			bpf_program__title(prog, false), pfd);
+		pr_warn("prog '%s': invalid perf event FD %d\n",
+			prog->name, pfd);
 		return ERR_PTR(-EINVAL);
 	}
 	prog_fd =3D bpf_program__fd(prog);
 	if (prog_fd < 0) {
-		pr_warn("program '%s': can't attach BPF program w/o FD (did you load i=
t?)\n",
-			bpf_program__title(prog, false));
+		pr_warn("prog '%s': can't attach BPF program w/o FD (did you load it?)=
\n",
+			prog->name);
 		return ERR_PTR(-EINVAL);
 	}
=20
@@ -8844,20 +8839,18 @@ struct bpf_link *bpf_program__attach_perf_event(s=
truct bpf_program *prog,
 	if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, prog_fd) < 0) {
 		err =3D -errno;
 		free(link);
-		pr_warn("program '%s': failed to attach to pfd %d: %s\n",
-			bpf_program__title(prog, false), pfd,
-			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		pr_warn("prog '%s': failed to attach to pfd %d: %s\n",
+			prog->name, pfd, libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
 		if (err =3D=3D -EPROTO)
-			pr_warn("program '%s': try add PERF_SAMPLE_CALLCHAIN to or remove exc=
lude_callchain_[kernel|user] from pfd %d\n",
-				bpf_program__title(prog, false), pfd);
+			pr_warn("prog '%s': try add PERF_SAMPLE_CALLCHAIN to or remove exclud=
e_callchain_[kernel|user] from pfd %d\n",
+				prog->name, pfd);
 		return ERR_PTR(err);
 	}
 	if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
 		err =3D -errno;
 		free(link);
-		pr_warn("program '%s': failed to enable pfd %d: %s\n",
-			bpf_program__title(prog, false), pfd,
-			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
+		pr_warn("prog '%s': failed to enable pfd %d: %s\n",
+			prog->name, pfd, libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
 		return ERR_PTR(err);
 	}
 	return link;
@@ -8979,9 +8972,8 @@ struct bpf_link *bpf_program__attach_kprobe(struct =
bpf_program *prog,
 	pfd =3D perf_event_open_probe(false /* uprobe */, retprobe, func_name,
 				    0 /* offset */, -1 /* pid */);
 	if (pfd < 0) {
-		pr_warn("program '%s': failed to create %s '%s' perf event: %s\n",
-			bpf_program__title(prog, false),
-			retprobe ? "kretprobe" : "kprobe", func_name,
+		pr_warn("prog '%s': failed to create %s '%s' perf event: %s\n",
+			prog->name, retprobe ? "kretprobe" : "kprobe", func_name,
 			libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
 		return ERR_PTR(pfd);
 	}
@@ -8989,9 +8981,8 @@ struct bpf_link *bpf_program__attach_kprobe(struct =
bpf_program *prog,
 	if (IS_ERR(link)) {
 		close(pfd);
 		err =3D PTR_ERR(link);
-		pr_warn("program '%s': failed to attach to %s '%s': %s\n",
-			bpf_program__title(prog, false),
-			retprobe ? "kretprobe" : "kprobe", func_name,
+		pr_warn("prog '%s': failed to attach to %s '%s': %s\n",
+			prog->name, retprobe ? "kretprobe" : "kprobe", func_name,
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
 		return link;
 	}
@@ -9004,7 +8995,7 @@ static struct bpf_link *attach_kprobe(const struct =
bpf_sec_def *sec,
 	const char *func_name;
 	bool retprobe;
=20
-	func_name =3D bpf_program__title(prog, false) + sec->len;
+	func_name =3D prog->sec_name + sec->len;
 	retprobe =3D strcmp(sec->sec, "kretprobe/") =3D=3D 0;
=20
 	return bpf_program__attach_kprobe(prog, retprobe, func_name);
@@ -9022,9 +9013,8 @@ struct bpf_link *bpf_program__attach_uprobe(struct =
bpf_program *prog,
 	pfd =3D perf_event_open_probe(true /* uprobe */, retprobe,
 				    binary_path, func_offset, pid);
 	if (pfd < 0) {
-		pr_warn("program '%s': failed to create %s '%s:0x%zx' perf event: %s\n=
",
-			bpf_program__title(prog, false),
-			retprobe ? "uretprobe" : "uprobe",
+		pr_warn("prog '%s': failed to create %s '%s:0x%zx' perf event: %s\n",
+			prog->name, retprobe ? "uretprobe" : "uprobe",
 			binary_path, func_offset,
 			libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
 		return ERR_PTR(pfd);
@@ -9033,9 +9023,8 @@ struct bpf_link *bpf_program__attach_uprobe(struct =
bpf_program *prog,
 	if (IS_ERR(link)) {
 		close(pfd);
 		err =3D PTR_ERR(link);
-		pr_warn("program '%s': failed to attach to %s '%s:0x%zx': %s\n",
-			bpf_program__title(prog, false),
-			retprobe ? "uretprobe" : "uprobe",
+		pr_warn("prog '%s': failed to attach to %s '%s:0x%zx': %s\n",
+			prog->name, retprobe ? "uretprobe" : "uprobe",
 			binary_path, func_offset,
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
 		return link;
@@ -9103,9 +9092,8 @@ struct bpf_link *bpf_program__attach_tracepoint(str=
uct bpf_program *prog,
=20
 	pfd =3D perf_event_open_tracepoint(tp_category, tp_name);
 	if (pfd < 0) {
-		pr_warn("program '%s': failed to create tracepoint '%s/%s' perf event:=
 %s\n",
-			bpf_program__title(prog, false),
-			tp_category, tp_name,
+		pr_warn("prog '%s': failed to create tracepoint '%s/%s' perf event: %s=
\n",
+			prog->name, tp_category, tp_name,
 			libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
 		return ERR_PTR(pfd);
 	}
@@ -9113,9 +9101,8 @@ struct bpf_link *bpf_program__attach_tracepoint(str=
uct bpf_program *prog,
 	if (IS_ERR(link)) {
 		close(pfd);
 		err =3D PTR_ERR(link);
-		pr_warn("program '%s': failed to attach to tracepoint '%s/%s': %s\n",
-			bpf_program__title(prog, false),
-			tp_category, tp_name,
+		pr_warn("prog '%s': failed to attach to tracepoint '%s/%s': %s\n",
+			prog->name, tp_category, tp_name,
 			libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
 		return link;
 	}
@@ -9128,7 +9115,7 @@ static struct bpf_link *attach_tp(const struct bpf_=
sec_def *sec,
 	char *sec_name, *tp_cat, *tp_name;
 	struct bpf_link *link;
=20
-	sec_name =3D strdup(bpf_program__title(prog, false));
+	sec_name =3D strdup(prog->sec_name);
 	if (!sec_name)
 		return ERR_PTR(-ENOMEM);
=20
@@ -9157,8 +9144,7 @@ struct bpf_link *bpf_program__attach_raw_tracepoint=
(struct bpf_program *prog,
=20
 	prog_fd =3D bpf_program__fd(prog);
 	if (prog_fd < 0) {
-		pr_warn("program '%s': can't attach before loaded\n",
-			bpf_program__title(prog, false));
+		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
 		return ERR_PTR(-EINVAL);
 	}
=20
@@ -9171,9 +9157,8 @@ struct bpf_link *bpf_program__attach_raw_tracepoint=
(struct bpf_program *prog,
 	if (pfd < 0) {
 		pfd =3D -errno;
 		free(link);
-		pr_warn("program '%s': failed to attach to raw tracepoint '%s': %s\n",
-			bpf_program__title(prog, false), tp_name,
-			libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
+		pr_warn("prog '%s': failed to attach to raw tracepoint '%s': %s\n",
+			prog->name, tp_name, libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
 		return ERR_PTR(pfd);
 	}
 	link->fd =3D pfd;
@@ -9183,7 +9168,7 @@ struct bpf_link *bpf_program__attach_raw_tracepoint=
(struct bpf_program *prog,
 static struct bpf_link *attach_raw_tp(const struct bpf_sec_def *sec,
 				      struct bpf_program *prog)
 {
-	const char *tp_name =3D bpf_program__title(prog, false) + sec->len;
+	const char *tp_name =3D prog->sec_name + sec->len;
=20
 	return bpf_program__attach_raw_tracepoint(prog, tp_name);
 }
@@ -9197,8 +9182,7 @@ static struct bpf_link *bpf_program__attach_btf_id(=
struct bpf_program *prog)
=20
 	prog_fd =3D bpf_program__fd(prog);
 	if (prog_fd < 0) {
-		pr_warn("program '%s': can't attach before loaded\n",
-			bpf_program__title(prog, false));
+		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
 		return ERR_PTR(-EINVAL);
 	}
=20
@@ -9211,9 +9195,8 @@ static struct bpf_link *bpf_program__attach_btf_id(=
struct bpf_program *prog)
 	if (pfd < 0) {
 		pfd =3D -errno;
 		free(link);
-		pr_warn("program '%s': failed to attach: %s\n",
-			bpf_program__title(prog, false),
-			libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
+		pr_warn("prog '%s': failed to attach: %s\n",
+			prog->name, libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
 		return ERR_PTR(pfd);
 	}
 	link->fd =3D pfd;
@@ -9259,8 +9242,7 @@ bpf_program__attach_fd(struct bpf_program *prog, in=
t target_fd,
=20
 	prog_fd =3D bpf_program__fd(prog);
 	if (prog_fd < 0) {
-		pr_warn("program '%s': can't attach before loaded\n",
-			bpf_program__title(prog, false));
+		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
 		return ERR_PTR(-EINVAL);
 	}
=20
@@ -9274,8 +9256,8 @@ bpf_program__attach_fd(struct bpf_program *prog, in=
t target_fd,
 	if (link_fd < 0) {
 		link_fd =3D -errno;
 		free(link);
-		pr_warn("program '%s': failed to attach to %s: %s\n",
-			bpf_program__title(prog, false), target_name,
+		pr_warn("prog '%s': failed to attach to %s: %s\n",
+			prog->name, target_name,
 			libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
 		return ERR_PTR(link_fd);
 	}
@@ -9319,8 +9301,7 @@ bpf_program__attach_iter(struct bpf_program *prog,
=20
 	prog_fd =3D bpf_program__fd(prog);
 	if (prog_fd < 0) {
-		pr_warn("program '%s': can't attach before loaded\n",
-			bpf_program__title(prog, false));
+		pr_warn("prog '%s': can't attach before loaded\n", prog->name);
 		return ERR_PTR(-EINVAL);
 	}
=20
@@ -9334,9 +9315,8 @@ bpf_program__attach_iter(struct bpf_program *prog,
 	if (link_fd < 0) {
 		link_fd =3D -errno;
 		free(link);
-		pr_warn("program '%s': failed to attach to iterator: %s\n",
-			bpf_program__title(prog, false),
-			libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
+		pr_warn("prog '%s': failed to attach to iterator: %s\n",
+			prog->name, libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
 		return ERR_PTR(link_fd);
 	}
 	link->fd =3D link_fd;
@@ -9347,7 +9327,7 @@ struct bpf_link *bpf_program__attach(struct bpf_pro=
gram *prog)
 {
 	const struct bpf_sec_def *sec_def;
=20
-	sec_def =3D find_sec_def(bpf_program__title(prog, false));
+	sec_def =3D find_sec_def(prog->sec_name);
 	if (!sec_def || !sec_def->attach_fn)
 		return ERR_PTR(-ESRCH);
=20
@@ -10417,12 +10397,11 @@ int bpf_object__attach_skeleton(struct bpf_obje=
ct_skeleton *s)
 		struct bpf_program *prog =3D *s->progs[i].prog;
 		struct bpf_link **link =3D s->progs[i].link;
 		const struct bpf_sec_def *sec_def;
-		const char *sec_name =3D bpf_program__title(prog, false);
=20
 		if (!prog->load)
 			continue;
=20
-		sec_def =3D find_sec_def(sec_name);
+		sec_def =3D find_sec_def(prog->sec_name);
 		if (!sec_def || !sec_def->attach_fn)
 			continue;
=20
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 308e0ded8f14..a750f67a23f6 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -198,8 +198,9 @@ LIBBPF_API void bpf_program__set_ifindex(struct bpf_p=
rogram *prog,
 					 __u32 ifindex);
=20
 LIBBPF_API const char *bpf_program__name(const struct bpf_program *prog)=
;
-LIBBPF_API const char *bpf_program__title(const struct bpf_program *prog=
,
-					  bool needs_copy);
+LIBBPF_API const char *bpf_program__section_name(const struct bpf_progra=
m *prog);
+LIBBPF_API LIBBPF_DEPRECATED("BPF program title is confusing term; pleas=
e use bpf_program__section_name() instead")
+const char *bpf_program__title(const struct bpf_program *prog, bool need=
s_copy);
 LIBBPF_API bool bpf_program__autoload(const struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_autoload(struct bpf_program *prog, bool =
autoload);
=20
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 3fedcdc4ae2f..92ceb48a5ca2 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -302,6 +302,7 @@ LIBBPF_0.1.0 {
=20
 LIBBPF_0.2.0 {
 	global:
+		bpf_program__section_name;
 		perf_buffer__buffer_cnt;
 		perf_buffer__buffer_fd;
 		perf_buffer__epoll_fd;
--=20
2.24.1

