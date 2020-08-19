Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C3F24A71F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHSTpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:45:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45400 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727046AbgHSTpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:45:40 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JJeMnZ002236
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 12:45:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xYsrBgKIKJEWWbBnblsbVIlkBfnGvFzfEWU8SqmwQy0=;
 b=pw2IFErxjWvam5t+r9WdyCYSg4e5cHZMv62XSpSpbVcW3rfnk+l+jJPoask/LwxAdh7Z
 KD9y3Te7uqtIgxWlEH2U77mNMOFwZI5jRGVuH1HdZlRs7PvuYWcKUssheAZ7Fvw6RQ1O
 JV10TcNZ6bR/Vl4/h24rZ9Aq4F4LdB0Ac0M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304prte6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 12:45:38 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 12:45:37 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5B5872EC5E08; Wed, 19 Aug 2020 12:45:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 4/5] libbpf: implement enum value-based CO-RE relocations
Date:   Wed, 19 Aug 2020 12:45:18 -0700
Message-ID: <20200819194519.3375898-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200819194519.3375898-1-andriin@fb.com>
References: <20200819194519.3375898-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 suspectscore=8 clxscore=1015 mlxlogscore=913 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement two relocations of a new enumerator value-based CO-RE relocatio=
n
kind: ENUMVAL_EXISTS and ENUMVAL_VALUE.

First, ENUMVAL_EXISTS, allows to detect the presence of a named enumerato=
r
value in the target (kernel) BTF. This is useful to do BPF helper/map/pro=
gram
type support detection from BPF program side. bpf_core_enum_value_exists(=
)
macro helper is provided to simplify built-in usage.

Second, ENUMVAL_VALUE, allows to capture enumerator integer value and rel=
ocate
it according to the target BTF, if it changes. This is useful to have
a guarantee against intentional or accidental re-ordering/re-numbering of=
 some
of the internal (non-UAPI) enumerations, where kernel developers don't ca=
re
about UAPI backwards compatiblity concerns. bpf_core_enum_value() allows =
to
capture this succinctly and use correct enum values in code.

LLVM uses ldimm64 instruction to capture enumerator value-based relocatio=
ns,
so add support for ldimm64 instruction patching as well.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_core_read.h   |  28 ++++++
 tools/lib/bpf/libbpf.c          | 145 ++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf_internal.h |   2 +
 3 files changed, 170 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.=
h
index 684bfb86361a..bbcefb3ff5a5 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -31,6 +31,12 @@ enum bpf_type_info_kind {
 	BPF_TYPE_SIZE =3D 1,		/* type size in target kernel */
 };
=20
+/* second argument to __builtin_preserve_enum_value() built-in */
+enum bpf_enum_value_kind {
+	BPF_ENUMVAL_EXISTS =3D 0,		/* enum value existence in kernel */
+	BPF_ENUMVAL_VALUE =3D 1,		/* enum value value relocation */
+};
+
 #define __CORE_RELO(src, field, info)					      \
 	__builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
=20
@@ -150,6 +156,28 @@ enum bpf_type_info_kind {
 #define bpf_core_type_size(type)					    \
 	__builtin_preserve_type_info(*(typeof(type) *)0, BPF_TYPE_SIZE)
=20
+/*
+ * Convenience macro to check that provided enumerator value is defined =
in
+ * a target kernel.
+ * Returns:
+ *    1, if specified enum type and its enumerator value are present in =
target
+ *    kernel's BTF;
+ *    0, if no matching enum and/or enum value within that enum is found=
.
+ */
+#define bpf_core_enum_value_exists(enum_type, enum_value)		    \
+	__builtin_preserve_enum_value(*(typeof(enum_type) *)enum_value, BPF_ENU=
MVAL_EXISTS)
+
+/*
+ * Convenience macro to get the integer value of an enumerator value in
+ * a target kernel.
+ * Returns:
+ *    64-bit value, if specified enum type and its enumerator value are
+ *    present in target kernel's BTF;
+ *    0, if no matching enum and/or enum value within that enum is found=
.
+ */
+#define bpf_core_enum_value(enum_type, enum_value)			    \
+	__builtin_preserve_enum_value(*(typeof(enum_type) *)enum_value, BPF_ENU=
MVAL_VALUE)
+
 /*
  * bpf_core_read() abstracts away bpf_probe_read_kernel() call and captu=
res
  * offset relocation for source address using __builtin_preserve_access_=
index()
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 882759dfc33e..77d420c02094 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4115,6 +4115,8 @@ static const char *core_relo_kind_str(enum bpf_core=
_relo_kind kind)
 	case BPF_TYPE_ID_TARGET: return "target_type_id";
 	case BPF_TYPE_EXISTS: return "type_exists";
 	case BPF_TYPE_SIZE: return "type_size";
+	case BPF_ENUMVAL_EXISTS: return "enumval_exists";
+	case BPF_ENUMVAL_VALUE: return "enumval_value";
 	default: return "unknown";
 	}
 }
@@ -4147,6 +4149,17 @@ static bool core_relo_is_type_based(enum bpf_core_=
relo_kind kind)
 	}
 }
=20
+static bool core_relo_is_enumval_based(enum bpf_core_relo_kind kind)
+{
+	switch (kind) {
+	case BPF_ENUMVAL_EXISTS:
+	case BPF_ENUMVAL_VALUE:
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
@@ -4180,6 +4193,9 @@ static bool core_relo_is_type_based(enum bpf_core_r=
elo_kind kind)
  * Type-based relocations (TYPE_EXISTS/TYPE_SIZE,
  * TYPE_ID_LOCAL/TYPE_ID_TARGET) don't capture any field information. Th=
eir
  * spec and raw_spec are kept empty.
+ *
+ * Enum value-based relocations (ENUMVAL_EXISTS/ENUMVAL_VALUE) use acces=
s
+ * string to specify enumerator's value index that need to be relocated.
  */
 static int bpf_core_parse_spec(const struct btf *btf,
 			       __u32 type_id,
@@ -4224,16 +4240,25 @@ static int bpf_core_parse_spec(const struct btf *=
btf,
 	if (spec->raw_len =3D=3D 0)
 		return -EINVAL;
=20
-	/* first spec value is always reloc type array index */
 	t =3D skip_mods_and_typedefs(btf, type_id, &id);
 	if (!t)
 		return -EINVAL;
=20
 	access_idx =3D spec->raw_spec[0];
-	spec->spec[0].type_id =3D id;
-	spec->spec[0].idx =3D access_idx;
+	acc =3D &spec->spec[0];
+	acc->type_id =3D id;
+	acc->idx =3D access_idx;
 	spec->len++;
=20
+	if (core_relo_is_enumval_based(relo_kind)) {
+		if (!btf_is_enum(t) || spec->raw_len > 1 || access_idx >=3D btf_vlen(t=
))
+			return -EINVAL;
+
+		/* record enumerator name in a first accessor */
+		acc->name =3D btf__name_by_offset(btf, btf_enum(t)[access_idx].name_of=
f);
+		return 0;
+	}
+
 	if (!core_relo_is_field_based(relo_kind))
 		return -EINVAL;
=20
@@ -4676,6 +4701,39 @@ static int bpf_core_spec_match(struct bpf_core_spe=
c *local_spec,
 	local_acc =3D &local_spec->spec[0];
 	targ_acc =3D &targ_spec->spec[0];
=20
+	if (core_relo_is_enumval_based(local_spec->relo_kind)) {
+		size_t local_essent_len, targ_essent_len;
+		const struct btf_enum *e;
+		const char *targ_name;
+
+		/* has to resolve to an enum */
+		targ_type =3D skip_mods_and_typedefs(targ_spec->btf, targ_id, &targ_id=
);
+		if (!btf_is_enum(targ_type))
+			return 0;
+
+		local_essent_len =3D bpf_core_essential_name_len(local_acc->name);
+
+		for (i =3D 0, e =3D btf_enum(targ_type); i < btf_vlen(targ_type); i++,=
 e++) {
+			targ_name =3D btf__name_by_offset(targ_spec->btf, e->name_off);
+			targ_essent_len =3D bpf_core_essential_name_len(targ_name);
+			if (targ_essent_len !=3D local_essent_len)
+				continue;
+			if (strncmp(local_acc->name, targ_name, local_essent_len) =3D=3D 0) {
+				targ_acc->type_id =3D targ_id;
+				targ_acc->idx =3D i;
+				targ_acc->name =3D targ_name;
+				targ_spec->len++;
+				targ_spec->raw_spec[targ_spec->raw_len] =3D targ_acc->idx;
+				targ_spec->raw_len++;
+				return 1;
+			}
+		}
+		return 0;
+	}
+
+	if (!core_relo_is_field_based(local_spec->relo_kind))
+		return -EINVAL;
+
 	for (i =3D 0; i < local_spec->len; i++, local_acc++, targ_acc++) {
 		targ_type =3D skip_mods_and_typedefs(targ_spec->btf, targ_id,
 						   &targ_id);
@@ -4880,6 +4938,31 @@ static int bpf_core_calc_type_relo(const struct bp=
f_core_relo *relo,
 	return 0;
 }
=20
+static int bpf_core_calc_enumval_relo(const struct bpf_core_relo *relo,
+				      const struct bpf_core_spec *spec,
+				      __u32 *val)
+{
+	const struct btf_type *t;
+	const struct btf_enum *e;
+
+	switch (relo->kind) {
+	case BPF_ENUMVAL_EXISTS:
+		*val =3D spec ? 1 : 0;
+		break;
+	case BPF_ENUMVAL_VALUE:
+		if (!spec)
+			return -EUCLEAN; /* request instruction poisoning */
+		t =3D btf__type_by_id(spec->btf, spec->spec[0].type_id);
+		e =3D btf_enum(t) + spec->spec[0].idx;
+		*val =3D e->val;
+		break;
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
@@ -4918,6 +5001,9 @@ static int bpf_core_calc_relo(const struct bpf_prog=
ram *prog,
 	} else if (core_relo_is_type_based(relo->kind)) {
 		err =3D bpf_core_calc_type_relo(relo, local_spec, &res->orig_val);
 		err =3D err ?: bpf_core_calc_type_relo(relo, targ_spec, &res->new_val)=
;
+	} else if (core_relo_is_enumval_based(relo->kind)) {
+		err =3D bpf_core_calc_enumval_relo(relo, local_spec, &res->orig_val);
+		err =3D err ?: bpf_core_calc_enumval_relo(relo, targ_spec, &res->new_v=
al);
 	}
=20
 	if (err =3D=3D -EUCLEAN) {
@@ -4954,6 +5040,11 @@ static void bpf_core_poison_insn(struct bpf_progra=
m *prog, int relo_idx,
 	insn->imm =3D 195896080; /* =3D> 0xbad2310 =3D> "bad relo" */
 }
=20
+static bool is_ldimm64(struct bpf_insn *insn)
+{
+	return insn->code =3D=3D (BPF_LD | BPF_IMM | BPF_DW);
+}
+
 /*
  * Patch relocatable BPF instruction.
  *
@@ -4966,6 +5057,7 @@ static void bpf_core_poison_insn(struct bpf_program=
 *prog, int relo_idx,
  * Currently three kinds of BPF instructions are supported:
  * 1. rX =3D <imm> (assignment with immediate operand);
  * 2. rX +=3D <imm> (arithmetic operations with immediate operand);
+ * 3. rX =3D <imm64> (load with 64-bit immediate value).
  */
 static int bpf_core_patch_insn(struct bpf_program *prog,
 			       const struct bpf_core_relo *relo,
@@ -4984,6 +5076,11 @@ static int bpf_core_patch_insn(struct bpf_program =
*prog,
 	class =3D BPF_CLASS(insn->code);
=20
 	if (res->poison) {
+		/* poison second part of ldimm64 to avoid confusing error from
+		 * verifier about "unknown opcode 00"
+		 */
+		if (is_ldimm64(insn))
+			bpf_core_poison_insn(prog, relo_idx, insn_idx + 1, insn + 1);
 		bpf_core_poison_insn(prog, relo_idx, insn_idx, insn);
 		return 0;
 	}
@@ -5012,7 +5109,7 @@ static int bpf_core_patch_insn(struct bpf_program *=
prog,
 	case BPF_ST:
 	case BPF_STX:
 		if (res->validate && insn->off !=3D orig_val) {
-			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LD/LDX/ST/STX) val=
ue: got %u, exp %u -> %u\n",
+			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDX/ST/STX) value:=
 got %u, exp %u -> %u\n",
 				bpf_program__title(prog, false), relo_idx,
 				insn_idx, insn->off, orig_val, new_val);
 			return -EINVAL;
@@ -5029,8 +5126,36 @@ static int bpf_core_patch_insn(struct bpf_program =
*prog,
 			 bpf_program__title(prog, false), relo_idx, insn_idx,
 			 orig_val, new_val);
 		break;
+	case BPF_LD: {
+		__u64 imm;
+
+		if (!is_ldimm64(insn) ||
+		    insn[0].src_reg !=3D 0 || insn[0].off !=3D 0 ||
+		    insn_idx + 1 >=3D prog->insns_cnt ||
+		    insn[1].code !=3D 0 || insn[1].dst_reg !=3D 0 ||
+		    insn[1].src_reg !=3D 0 || insn[1].off !=3D 0) {
+			pr_warn("prog '%s': relo #%d: insn #%d (LDIMM64) has unexpected form\=
n",
+				bpf_program__title(prog, false), relo_idx, insn_idx);
+			return -EINVAL;
+		}
+
+		imm =3D insn[0].imm + ((__u64)insn[1].imm << 32);
+		if (res->validate && imm !=3D orig_val) {
+			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDIMM64) value: go=
t %llu, exp %u -> %u\n",
+				bpf_program__title(prog, false), relo_idx,
+				insn_idx, imm, orig_val, new_val);
+			return -EINVAL;
+		}
+
+		insn[0].imm =3D new_val;
+		insn[1].imm =3D 0; /* currently only 32-bit values are supported */
+		pr_debug("prog '%s': relo #%d: patched insn #%d (LDIMM64) imm64 %llu -=
> %u\n",
+			 bpf_program__title(prog, false), relo_idx, insn_idx,
+			 imm, new_val);
+		break;
+	}
 	default:
-		pr_warn("prog '%s': relo #%d: trying to relocate unrecognized insn #%d=
, code:%x, src:%x, dst:%x, off:%x, imm:%x\n",
+		pr_warn("prog '%s': relo #%d: trying to relocate unrecognized insn #%d=
, code:0x%x, src:0x%x, dst:0x%x, off:0x%x, imm:0x%x\n",
 			bpf_program__title(prog, false), relo_idx,
 			insn_idx, insn->code, insn->src_reg, insn->dst_reg,
 			insn->off, insn->imm);
@@ -5047,6 +5172,7 @@ static int bpf_core_patch_insn(struct bpf_program *=
prog,
 static void bpf_core_dump_spec(int level, const struct bpf_core_spec *sp=
ec)
 {
 	const struct btf_type *t;
+	const struct btf_enum *e;
 	const char *s;
 	__u32 type_id;
 	int i;
@@ -5060,6 +5186,15 @@ static void bpf_core_dump_spec(int level, const st=
ruct bpf_core_spec *spec)
 	if (core_relo_is_type_based(spec->relo_kind))
 		return;
=20
+	if (core_relo_is_enumval_based(spec->relo_kind)) {
+		t =3D skip_mods_and_typedefs(spec->btf, type_id, NULL);
+		e =3D btf_enum(t) + spec->raw_spec[0];
+		s =3D btf__name_by_offset(spec->btf, e->name_off);
+
+		libbpf_print(level, "::%s =3D %u", s, e->val);
+		return;
+	}
+
 	if (core_relo_is_field_based(spec->relo_kind)) {
 		for (i =3D 0; i < spec->len; i++) {
 			if (spec->spec[i].name)
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index edd3511aa242..61dff515a2f0 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -242,6 +242,8 @@ enum bpf_core_relo_kind {
 	BPF_TYPE_ID_TARGET =3D 7,		/* type ID in target kernel */
 	BPF_TYPE_EXISTS =3D 8,		/* type existence in target kernel */
 	BPF_TYPE_SIZE =3D 9,		/* type size in bytes */
+	BPF_ENUMVAL_EXISTS =3D 10,	/* enum value existence in target kernel */
+	BPF_ENUMVAL_VALUE =3D 11,		/* enum value integer value */
 };
=20
 /* The minimum bpf_core_relo checked by the loader
--=20
2.24.1

