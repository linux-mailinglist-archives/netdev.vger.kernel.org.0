Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2455CECB5E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfKAW2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:28:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44666 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726986AbfKAW2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:28:24 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA1MOAoY025478
        for <netdev@vger.kernel.org>; Fri, 1 Nov 2019 15:28:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=NZVX+lLyLq9ggIbPXHYea54S5c9naGkF2naOuQedEWU=;
 b=ivNIj03VMho0yD6jgnGAwJXXf3Nvism7OP8vOIOSh9r3ctgA6VDd3W6pm6JDTr8XEq8n
 kKCnF4Pph48qqCKdu/AgUK5iqcomNoVRuKCOJafHKezvH5oeJyGBsTzyjnlzeuvfpcE/
 /+rl7ej3uk8vcYZknQzeLch5X7BHPzMsRTU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w0wdpr1ac-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 15:28:20 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 1 Nov 2019 15:28:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 06BFD2EC1B43; Fri,  1 Nov 2019 15:28:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/5] libbpf: add support for relocatable bitfields
Date:   Fri, 1 Nov 2019 15:28:07 -0700
Message-ID: <20191101222810.1246166-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191101222810.1246166-1-andriin@fb.com>
References: <20191101222810.1246166-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_08:2019-11-01,2019-11-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=8 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1911010207
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the new field relocation kinds, necessary to support
relocatable bitfield reads. Provide macro for abstracting necessary code doing
full relocatable bitfield extraction into u64 value. Two separate macros are
provided:
- BPF_CORE_READ_BITFIELD macro for direct memory read-enabled BPF programs
(e.g., typed raw tracepoints). It uses direct memory dereference to extract
bitfield backing integer value.
- BPF_CORE_READ_BITFIELD_PROBED macro for cases where bpf_probe_read() needs
to be used to extract same backing integer value.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/bpf_core_read.h   |  72 +++++++++++
 tools/lib/bpf/libbpf.c          | 211 +++++++++++++++++++++++---------
 tools/lib/bpf/libbpf_internal.h |   4 +
 3 files changed, 227 insertions(+), 60 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index a273df3784f4..0935cd68e7de 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -12,9 +12,81 @@
  */
 enum bpf_field_info_kind {
 	BPF_FIELD_BYTE_OFFSET = 0,	/* field byte offset */
+	BPF_FIELD_BYTE_SIZE = 1,
 	BPF_FIELD_EXISTS = 2,		/* field existence in target kernel */
+	BPF_FIELD_SIGNED = 3,
+	BPF_FIELD_LSHIFT_U64 = 4,
+	BPF_FIELD_RSHIFT_U64 = 5,
 };
 
+#define __CORE_RELO(src, field, info)					      \
+	__builtin_preserve_field_info((src)->field, BPF_FIELD_##info)
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define __CORE_BITFIELD_PROBE_READ(dst, src, fld)			      \
+	bpf_probe_read((void *)dst,					      \
+		       __CORE_RELO(src, fld, BYTE_SIZE),		      \
+		       (const void *)src + __CORE_RELO(src, fld, BYTE_OFFSET))
+#else
+/* semantics of LSHIFT_64 assumes loading values into low-ordered bytes, so
+ * for big-endian we need to adjust destination pointer accordingly, based on
+ * field byte size
+ */
+#define __CORE_BITFIELD_PROBE_READ(dst, src, fld)			      \
+	bpf_probe_read((void *)dst + (8 - __CORE_RELO(src, fld, BYTE_SIZE)),  \
+		       __CORE_RELO(src, fld, BYTE_SIZE),		      \
+		       (const void *)src + __CORE_RELO(src, fld, BYTE_OFFSET))
+#endif
+
+/*
+ * Extract bitfield, identified by src->field, and put its value into u64
+ * *res. All this is done in relocatable manner, so bitfield changes such as
+ * signedness, bit size, offset changes, this will be handled automatically.
+ * This version of macro is using bpf_probe_read() to read underlying integer
+ * storage. Macro functions as an expression and its return type is
+ * bpf_probe_read()'s return value: 0, on success, <0 on error.
+ */
+#define BPF_CORE_READ_BITFIELD_PROBED(src, field, res) ({		      \
+	unsigned long long val;						      \
+									      \
+	*res = 0;							      \
+	val = __CORE_BITFIELD_PROBE_READ(res, src, field);		      \
+	if (!val) {							      \
+		*res <<= __CORE_RELO(src, field, LSHIFT_U64);		      \
+		val = __CORE_RELO(src, field, RSHIFT_U64);		      \
+		if (__CORE_RELO(src, field, SIGNED))			      \
+			*res = ((long long)*res) >> val;		      \
+		else							      \
+			*res = ((unsigned long long)*res) >> val;	      \
+		val = 0;						      \
+	}								      \
+	val;								      \
+})
+
+/*
+ * Extract bitfield, identified by src->field, and return its value as u64.
+ * This version of macro is using direct memory reads and should be used from
+ * BPF program types that support such functionality (e.g., typed raw
+ * tracepoints).
+ */
+#define BPF_CORE_READ_BITFIELD(s, field) ({				      \
+	const void *p = (const void *)s + __CORE_RELO(s, field, BYTE_OFFSET); \
+	unsigned long long val;						      \
+									      \
+	switch (__CORE_RELO(s, field, BYTE_SIZE)) {			      \
+	case 1: val = *(const unsigned char *)p;			      \
+	case 2: val = *(const unsigned short *)p;			      \
+	case 4: val = *(const unsigned int *)p;				      \
+	case 8: val = *(const unsigned long long *)p;			      \
+	}								      \
+	val <<= __CORE_RELO(s, field, LSHIFT_U64);			      \
+	if (__CORE_RELO(s, field, SIGNED))				      \
+		val = ((long long)val) >> __CORE_RELO(s, field, RSHIFT_U64);  \
+	else								      \
+		val = val >> __CORE_RELO(s, field, RSHIFT_U64);		      \
+	val;								      \
+})
+
 /*
  * Convenience macro to check that field actually exists in target kernel's.
  * Returns:
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c80f316f1320..f1a01ed93c4a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2335,8 +2335,8 @@ struct bpf_core_spec {
 	int raw_spec[BPF_CORE_SPEC_MAX_LEN];
 	/* raw spec length */
 	int raw_len;
-	/* field byte offset represented by spec */
-	__u32 offset;
+	/* field bit offset represented by spec */
+	__u32 bit_offset;
 };
 
 static bool str_is_empty(const char *s)
@@ -2347,8 +2347,8 @@ static bool str_is_empty(const char *s)
 /*
  * Turn bpf_field_reloc into a low- and high-level spec representation,
  * validating correctness along the way, as well as calculating resulting
- * field offset (in bytes), specified by accessor string. Low-level spec
- * captures every single level of nestedness, including traversing anonymous
+ * field bit offset, specified by accessor string. Low-level spec captures
+ * every single level of nestedness, including traversing anonymous
  * struct/union members. High-level one only captures semantically meaningful
  * "turning points": named fields and array indicies.
  * E.g., for this case:
@@ -2420,7 +2420,7 @@ static int bpf_core_spec_parse(const struct btf *btf,
 	sz = btf__resolve_size(btf, id);
 	if (sz < 0)
 		return sz;
-	spec->offset = access_idx * sz;
+	spec->bit_offset = access_idx * sz * 8;
 
 	for (i = 1; i < spec->raw_len; i++) {
 		t = skip_mods_and_typedefs(btf, id, &id);
@@ -2431,17 +2431,13 @@ static int bpf_core_spec_parse(const struct btf *btf,
 
 		if (btf_is_composite(t)) {
 			const struct btf_member *m;
-			__u32 offset;
+			__u32 bit_offset;
 
 			if (access_idx >= btf_vlen(t))
 				return -EINVAL;
-			if (btf_member_bitfield_size(t, access_idx))
-				return -EINVAL;
 
-			offset = btf_member_bit_offset(t, access_idx);
-			if (offset % 8)
-				return -EINVAL;
-			spec->offset += offset / 8;
+			bit_offset = btf_member_bit_offset(t, access_idx);
+			spec->bit_offset += bit_offset;
 
 			m = btf_members(t) + access_idx;
 			if (m->name_off) {
@@ -2470,7 +2466,7 @@ static int bpf_core_spec_parse(const struct btf *btf,
 			sz = btf__resolve_size(btf, id);
 			if (sz < 0)
 				return sz;
-			spec->offset += access_idx * sz;
+			spec->bit_offset += access_idx * sz * 8;
 		} else {
 			pr_warn("relo for [%u] %s (at idx %d) captures type [%d] of unexpected kind %d\n",
 				type_id, spec_str, i, id, btf_kind(t));
@@ -2571,12 +2567,12 @@ static struct ids_vec *bpf_core_find_cands(const struct btf *local_btf,
 }
 
 /* Check two types for compatibility, skipping const/volatile/restrict and
- * typedefs, to ensure we are relocating offset to the compatible entities:
+ * typedefs, to ensure we are relocating compatible entities:
  *   - any two STRUCTs/UNIONs are compatible and can be mixed;
  *   - any two FWDs are compatible;
  *   - any two PTRs are always compatible;
  *   - for ENUMs, check sizes, names are ignored;
- *   - for INT, size and bitness should match, signedness is ignored;
+ *   - for INT, size and signedness are ignored;
  *   - for ARRAY, dimensionality is ignored, element types are checked for
  *     compatibility recursively;
  *   - everything else shouldn't be ever a target of relocation.
@@ -2608,10 +2604,11 @@ static int bpf_core_fields_are_compat(const struct btf *local_btf,
 	case BTF_KIND_ENUM:
 		return local_type->size == targ_type->size;
 	case BTF_KIND_INT:
+		/* just reject deprecated bitfield-like integers; all other
+		 * integers are by default compatible between each other
+		 */
 		return btf_int_offset(local_type) == 0 &&
-		       btf_int_offset(targ_type) == 0 &&
-		       local_type->size == targ_type->size &&
-		       btf_int_bits(local_type) == btf_int_bits(targ_type);
+		       btf_int_offset(targ_type) == 0;
 	case BTF_KIND_ARRAY:
 		local_id = btf_array(local_type)->type;
 		targ_id = btf_array(targ_type)->type;
@@ -2627,7 +2624,7 @@ static int bpf_core_fields_are_compat(const struct btf *local_btf,
  * Given single high-level named field accessor in local type, find
  * corresponding high-level accessor for a target type. Along the way,
  * maintain low-level spec for target as well. Also keep updating target
- * offset.
+ * bit offset.
  *
  * Searching is performed through recursive exhaustive enumeration of all
  * fields of a struct/union. If there are any anonymous (embedded)
@@ -2666,21 +2663,16 @@ static int bpf_core_match_member(const struct btf *local_btf,
 	n = btf_vlen(targ_type);
 	m = btf_members(targ_type);
 	for (i = 0; i < n; i++, m++) {
-		__u32 offset;
+		__u32 bit_offset;
 
-		/* bitfield relocations not supported */
-		if (btf_member_bitfield_size(targ_type, i))
-			continue;
-		offset = btf_member_bit_offset(targ_type, i);
-		if (offset % 8)
-			continue;
+		bit_offset = btf_member_bit_offset(targ_type, i);
 
 		/* too deep struct/union/array nesting */
 		if (spec->raw_len == BPF_CORE_SPEC_MAX_LEN)
 			return -E2BIG;
 
 		/* speculate this member will be the good one */
-		spec->offset += offset / 8;
+		spec->bit_offset += bit_offset;
 		spec->raw_spec[spec->raw_len++] = i;
 
 		targ_name = btf__name_by_offset(targ_btf, m->name_off);
@@ -2709,7 +2701,7 @@ static int bpf_core_match_member(const struct btf *local_btf,
 			return found;
 		}
 		/* member turned out not to be what we looked for */
-		spec->offset -= offset / 8;
+		spec->bit_offset -= bit_offset;
 		spec->raw_len--;
 	}
 
@@ -2718,7 +2710,7 @@ static int bpf_core_match_member(const struct btf *local_btf,
 
 /*
  * Try to match local spec to a target type and, if successful, produce full
- * target spec (high-level, low-level + offset).
+ * target spec (high-level, low-level + bit offset).
  */
 static int bpf_core_spec_match(struct bpf_core_spec *local_spec,
 			       const struct btf *targ_btf, __u32 targ_id,
@@ -2781,13 +2773,110 @@ static int bpf_core_spec_match(struct bpf_core_spec *local_spec,
 			sz = btf__resolve_size(targ_btf, targ_id);
 			if (sz < 0)
 				return sz;
-			targ_spec->offset += local_acc->idx * sz;
+			targ_spec->bit_offset += local_acc->idx * sz * 8;
 		}
 	}
 
 	return 1;
 }
 
+static int bpf_core_calc_field_relo(const struct bpf_program *prog,
+				    const struct bpf_field_reloc *relo,
+				    const struct bpf_core_spec *spec,
+				    __u32 *val, bool *validate)
+{
+	const struct bpf_core_accessor *acc = &spec->spec[spec->len - 1];
+	const struct btf_type *t = btf__type_by_id(spec->btf, acc->type_id);
+	__u32 byte_off, byte_sz, bit_off, bit_sz;
+	const struct btf_member *m;
+	const struct btf_type *mt;
+	bool bitfield;
+
+	/* a[n] accessor needs special handling */
+	if (!acc->name) {
+		if (relo->kind != BPF_FIELD_BYTE_OFFSET) {
+			pr_warn("prog '%s': relo %d at insn #%d can't be applied to array access'\n",
+				bpf_program__title(prog, false),
+				relo->kind, relo->insn_off / 8);
+			return -EINVAL;
+		}
+		*val = spec->bit_offset / 8;
+		if (validate)
+			*validate = true;
+		return 0;
+	}
+
+	m = btf_members(t) + acc->idx;
+	mt = skip_mods_and_typedefs(spec->btf, m->type, NULL);
+	bit_off = spec->bit_offset;
+	bit_sz = btf_member_bitfield_size(t, acc->idx);
+
+	bitfield = bit_sz > 0;
+	if (bitfield) {
+		byte_sz = mt->size;
+		byte_off = bit_off / 8 / byte_sz * byte_sz;
+		/* figure out smallest int size necessary for bitfield load */
+		while (bit_off + bit_sz - byte_off * 8 > byte_sz * 8) {
+			if (byte_sz >= 8) {
+				/* bitfield can't be read with 64-bit read */
+				pr_warn("prog '%s': relo %d at insn #%d can't be satisfied for bitfield\n",
+					bpf_program__title(prog, false),
+					relo->kind, relo->insn_off / 8);
+				return -E2BIG;
+			}
+			byte_sz *= 2;
+			byte_off = bit_off / 8 / byte_sz * byte_sz;
+		}
+	} else {
+		byte_sz = mt->size;
+		byte_off = spec->bit_offset / 8;
+		bit_sz = byte_sz * 8;
+	}
+
+	/* for bitfields, all the relocatable aspects are ambiguous and we
+	 * might disagree with compiler, so turn off validation of expected
+	 * value, except for signedness
+	 */
+	if (validate)
+		*validate = !bitfield;
+
+	switch (relo->kind) {
+	case BPF_FIELD_BYTE_OFFSET:
+		*val = byte_off;
+		break;
+	case BPF_FIELD_BYTE_SIZE:
+		*val = byte_sz;
+		break;
+	case BPF_FIELD_SIGNED:
+		/* enums will be assumed unsigned */
+		*val = btf_is_enum(mt) ||
+		       (btf_int_encoding(mt) & BTF_INT_SIGNED);
+		if (validate)
+			*validate = true; /* signedness is never ambiguous */
+		break;
+	case BPF_FIELD_LSHIFT_U64:
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+		*val = 64 - (bit_off + bit_sz - byte_off  * 8);
+#else
+		*val = (8 - byte_sz) * 8 + (bit_off - byte_off * 8);
+#endif
+		break;
+	case BPF_FIELD_RSHIFT_U64:
+		*val = 64 - bit_sz;
+		if (validate)
+			*validate = true; /* right shift is never ambiguous */
+		break;
+	case BPF_FIELD_EXISTS:
+	default:
+		pr_warn("prog '%s': unknown relo %d at insn #%d\n",
+			bpf_program__title(prog, false),
+			relo->kind, relo->insn_off / 8);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * Patch relocatable BPF instruction.
  *
@@ -2807,36 +2896,31 @@ static int bpf_core_reloc_insn(struct bpf_program *prog,
 			       const struct bpf_core_spec *local_spec,
 			       const struct bpf_core_spec *targ_spec)
 {
+	bool failed = false, validate = true;
 	__u32 orig_val, new_val;
 	struct bpf_insn *insn;
-	int insn_idx;
+	int insn_idx, err;
 	__u8 class;
 
 	if (relo->insn_off % sizeof(struct bpf_insn))
 		return -EINVAL;
 	insn_idx = relo->insn_off / sizeof(struct bpf_insn);
 
-	switch (relo->kind) {
-	case BPF_FIELD_BYTE_OFFSET:
-		orig_val = local_spec->offset;
-		if (targ_spec) {
-			new_val = targ_spec->offset;
-		} else {
-			pr_warn("prog '%s': patching insn #%d w/ failed reloc, imm %d -> %d\n",
-				bpf_program__title(prog, false), insn_idx,
-				orig_val, -1);
-			new_val = (__u32)-1;
-		}
-		break;
-	case BPF_FIELD_EXISTS:
+	if (relo->kind == BPF_FIELD_EXISTS) {
 		orig_val = 1; /* can't generate EXISTS relo w/o local field */
 		new_val = targ_spec ? 1 : 0;
-		break;
-	default:
-		pr_warn("prog '%s': unknown relo %d at insn #%d'\n",
-			bpf_program__title(prog, false),
-			relo->kind, insn_idx);
-		return -EINVAL;
+	} else if (!targ_spec) {
+		failed = true;
+		new_val = (__u32)-1;
+	} else {
+		err = bpf_core_calc_field_relo(prog, relo, local_spec,
+					       &orig_val, &validate);
+		if (err)
+			return err;
+		err = bpf_core_calc_field_relo(prog, relo, targ_spec,
+					       &new_val, NULL);
+		if (err)
+			return err;
 	}
 
 	insn = &prog->insns[insn_idx];
@@ -2845,12 +2929,17 @@ static int bpf_core_reloc_insn(struct bpf_program *prog,
 	if (class == BPF_ALU || class == BPF_ALU64) {
 		if (BPF_SRC(insn->code) != BPF_K)
 			return -EINVAL;
-		if (insn->imm != orig_val)
+		if (!failed && validate && insn->imm != orig_val) {
+			pr_warn("prog '%s': unexpected insn #%d value: got %u, exp %u -> %u\n",
+				bpf_program__title(prog, false), insn_idx,
+				insn->imm, orig_val, new_val);
 			return -EINVAL;
+		}
+		orig_val = insn->imm;
 		insn->imm = new_val;
-		pr_debug("prog '%s': patched insn #%d (ALU/ALU64) imm %d -> %d\n",
-			 bpf_program__title(prog, false),
-			 insn_idx, orig_val, new_val);
+		pr_debug("prog '%s': patched insn #%d (ALU/ALU64)%s imm %u -> %u\n",
+			 bpf_program__title(prog, false), insn_idx,
+			 failed ? " w/ failed reloc" : "", orig_val, new_val);
 	} else {
 		pr_warn("prog '%s': trying to relocate unrecognized insn #%d, code:%x, src:%x, dst:%x, off:%x, imm:%x\n",
 			bpf_program__title(prog, false),
@@ -2968,7 +3057,8 @@ static void bpf_core_dump_spec(int level, const struct bpf_core_spec *spec)
 		libbpf_print(level, "%d%s", spec->raw_spec[i],
 			     i == spec->raw_len - 1 ? " => " : ":");
 
-	libbpf_print(level, "%u @ &x", spec->offset);
+	libbpf_print(level, "%u.%u @ &x",
+		     spec->bit_offset / 8, spec->bit_offset % 8);
 
 	for (i = 0; i < spec->len; i++) {
 		if (spec->spec[i].name)
@@ -3082,7 +3172,8 @@ static int bpf_core_reloc_field(struct bpf_program *prog,
 		return -EINVAL;
 	}
 
-	pr_debug("prog '%s': relo #%d: spec is ", prog_name, relo_idx);
+	pr_debug("prog '%s': relo #%d: kind %d, spec is ", prog_name, relo_idx,
+		 relo->kind);
 	bpf_core_dump_spec(LIBBPF_DEBUG, &local_spec);
 	libbpf_print(LIBBPF_DEBUG, "\n");
 
@@ -3122,13 +3213,13 @@ static int bpf_core_reloc_field(struct bpf_program *prog,
 
 		if (j == 0) {
 			targ_spec = cand_spec;
-		} else if (cand_spec.offset != targ_spec.offset) {
+		} else if (cand_spec.bit_offset != targ_spec.bit_offset) {
 			/* if there are many candidates, they should all
-			 * resolve to the same offset
+			 * resolve to the same bit offset
 			 */
 			pr_warn("prog '%s': relo #%d: offset ambiguity: %u != %u\n",
-				prog_name, relo_idx, cand_spec.offset,
-				targ_spec.offset);
+				prog_name, relo_idx, cand_spec.bit_offset,
+				targ_spec.bit_offset);
 			return -EINVAL;
 		}
 
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index bd6f48ea407b..97ac17a64a58 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -158,7 +158,11 @@ struct bpf_line_info_min {
  */
 enum bpf_field_info_kind {
 	BPF_FIELD_BYTE_OFFSET = 0,	/* field byte offset */
+	BPF_FIELD_BYTE_SIZE = 1,
 	BPF_FIELD_EXISTS = 2,		/* field existence in target kernel */
+	BPF_FIELD_SIGNED = 3,
+	BPF_FIELD_LSHIFT_U64 = 4,
+	BPF_FIELD_RSHIFT_U64 = 5,
 };
 
 /* The minimum bpf_field_reloc checked by the loader
-- 
2.17.1

