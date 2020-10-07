Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B3286912
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgJGUaG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Oct 2020 16:30:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50162 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728499AbgJGUaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 16:30:04 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097KTv8L004460
        for <netdev@vger.kernel.org>; Wed, 7 Oct 2020 13:30:03 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3418t9kqf5-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 13:30:02 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 7 Oct 2020 13:29:54 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4AB502EC7B90; Wed,  7 Oct 2020 13:29:52 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 2/4] libbpf: support safe subset of load/store instruction resizing with CO-RE
Date:   Wed, 7 Oct 2020 13:29:44 -0700
Message-ID: <20201007202946.3684483-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201007202946.3684483-1-andrii@kernel.org>
References: <20201007202946.3684483-1-andrii@kernel.org>
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=8 clxscore=1015 adultscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

Add support for patching instructions of the following form:
  - rX = *(T *)(rY + <off>);
  - *(T *)(rX + <off>) = rY;
  - *(T *)(rX + <off>) = <imm>, where T is one of {u8, u16, u32, u64}.

For such instructions, if the actual kernel field recorded in CO-RE relocation
has a different size than the one recorded locally (e.g., from vmlinux.h),
then libbpf will adjust T to an appropriate 1-, 2-, 4-, or 8-byte loads.

In general, such transformation is not always correct and could lead to
invalid final value being loaded or stored. But two classes of cases are
always safe:
  - if both local and target (kernel) types are unsigned integers, but of
  different sizes, then it's OK to adjust load/store instruction according to
  the necessary memory size. Zero-extending nature of such instructions and
  unsignedness make sure that the final value is always correct;
  - pointer size mismatch between BPF target architecture (which is always
  64-bit) and 32-bit host kernel architecture can be similarly resolved
  automatically, because pointer is essentially an unsigned integer. Loading
  32-bit pointer into 64-bit BPF register with zero extension will leave
  correct pointer in the register.

Both cases are necessary to support CO-RE on 32-bit kernels, as `unsigned
long` in vmlinux.h generated from 32-bit kernel is 32-bit, but when compiled
with BPF program for BPF target it will be treated by compiler as 64-bit
integer. Similarly, pointers in vmlinux.h are 32-bit for kernel, but treated
as 64-bit values by compiler for BPF target. Both problems are now resolved by
libbpf for direct memory reads.

But similar transformations are useful in general when kernel fields are
"resized" from, e.g., unsigned int to unsigned long (or vice versa).

Now, similar transformations for signed integers are not safe to perform as
they will result in incorrect sign extension of the value. If such situation
is detected, libbpf will emit helpful message and will poison the instruction.
Not failing immediately means that it's possible to guard the instruction
based on kernel version (or other conditions) and make sure it's not
reachable.

If there is a need to read signed integers that change sizes between different
kernels, it's possible to use BPF_CORE_READ_BITFIELD() macro, which works both
with bitfields and non-bitfield integers of any signedness and handles
sign-extension properly. Also, bpf_core_read() with proper size and/or use of
bpf_core_field_size() relocation could allow to deal with such complicated
situations explicitly, if not so conventiently as direct memory reads.

Selftests added in a separate patch in progs/test_core_autosize.c demonstrate
both direct memory and probed use cases.

BPF_CORE_READ() is not changed and it won't deal with such situations as
automatically as direct memory reads due to the signedness integer
limitations, which are much harder to detect and control with compiler macro
magic. So it's encouraged to utilize direct memory reads as much as possible.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 144 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 136 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 07d62771472f..032cf0049ddb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5040,16 +5040,19 @@ static int bpf_core_spec_match(struct bpf_core_spec *local_spec,
 static int bpf_core_calc_field_relo(const struct bpf_program *prog,
 				    const struct bpf_core_relo *relo,
 				    const struct bpf_core_spec *spec,
-				    __u32 *val, bool *validate)
+				    __u32 *val, __u32 *field_sz, __u32 *type_id,
+				    bool *validate)
 {
 	const struct bpf_core_accessor *acc;
 	const struct btf_type *t;
-	__u32 byte_off, byte_sz, bit_off, bit_sz;
+	__u32 byte_off, byte_sz, bit_off, bit_sz, field_type_id;
 	const struct btf_member *m;
 	const struct btf_type *mt;
 	bool bitfield;
 	__s64 sz;
 
+	*field_sz = 0;
+
 	if (relo->kind == BPF_FIELD_EXISTS) {
 		*val = spec ? 1 : 0;
 		return 0;
@@ -5065,6 +5068,12 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
 	if (!acc->name) {
 		if (relo->kind == BPF_FIELD_BYTE_OFFSET) {
 			*val = spec->bit_offset / 8;
+			/* remember field size for load/store mem size */
+			sz = btf__resolve_size(spec->btf, acc->type_id);
+			if (sz < 0)
+				return -EINVAL;
+			*field_sz = sz;
+			*type_id = acc->type_id;
 		} else if (relo->kind == BPF_FIELD_BYTE_SIZE) {
 			sz = btf__resolve_size(spec->btf, acc->type_id);
 			if (sz < 0)
@@ -5081,7 +5090,7 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
 	}
 
 	m = btf_members(t) + acc->idx;
-	mt = skip_mods_and_typedefs(spec->btf, m->type, NULL);
+	mt = skip_mods_and_typedefs(spec->btf, m->type, &field_type_id);
 	bit_off = spec->bit_offset;
 	bit_sz = btf_member_bitfield_size(t, acc->idx);
 
@@ -5101,7 +5110,7 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
 			byte_off = bit_off / 8 / byte_sz * byte_sz;
 		}
 	} else {
-		sz = btf__resolve_size(spec->btf, m->type);
+		sz = btf__resolve_size(spec->btf, field_type_id);
 		if (sz < 0)
 			return -EINVAL;
 		byte_sz = sz;
@@ -5119,6 +5128,10 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
 	switch (relo->kind) {
 	case BPF_FIELD_BYTE_OFFSET:
 		*val = byte_off;
+		if (!bitfield) {
+			*field_sz = byte_sz;
+			*type_id = field_type_id;
+		}
 		break;
 	case BPF_FIELD_BYTE_SIZE:
 		*val = byte_sz;
@@ -5219,6 +5232,19 @@ struct bpf_core_relo_res
 	bool poison;
 	/* some relocations can't be validated against orig_val */
 	bool validate;
+	/* for field byte offset relocations or the forms:
+	 *     *(T *)(rX + <off>) = rY
+	 *     rX = *(T *)(rY + <off>),
+	 * we remember original and resolved field size to adjust direct
+	 * memory loads of pointers and integers; this is necessary for 32-bit
+	 * host kernel architectures, but also allows to automatically
+	 * relocate fields that were resized from, e.g., u32 to u64, etc.
+	 */
+	bool fail_memsz_adjust;
+	__u32 orig_sz;
+	__u32 orig_type_id;
+	__u32 new_sz;
+	__u32 new_type_id;
 };
 
 /* Calculate original and target relocation values, given local and target
@@ -5240,10 +5266,56 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
 	res->new_val = 0;
 	res->poison = false;
 	res->validate = true;
+	res->fail_memsz_adjust = false;
+	res->orig_sz = res->new_sz = 0;
+	res->orig_type_id = res->new_type_id = 0;
 
 	if (core_relo_is_field_based(relo->kind)) {
-		err = bpf_core_calc_field_relo(prog, relo, local_spec, &res->orig_val, &res->validate);
-		err = err ?: bpf_core_calc_field_relo(prog, relo, targ_spec, &res->new_val, NULL);
+		err = bpf_core_calc_field_relo(prog, relo, local_spec,
+					       &res->orig_val, &res->orig_sz,
+					       &res->orig_type_id, &res->validate);
+		err = err ?: bpf_core_calc_field_relo(prog, relo, targ_spec,
+						      &res->new_val, &res->new_sz,
+						      &res->new_type_id, NULL);
+		if (err)
+			goto done;
+		/* Validate if it's safe to adjust load/store memory size.
+		 * Adjustments are performed only if original and new memory
+		 * sizes differ.
+		 */
+		res->fail_memsz_adjust = false;
+		if (res->orig_sz != res->new_sz) {
+			const struct btf_type *orig_t, *new_t;
+
+			orig_t = btf__type_by_id(local_spec->btf, res->orig_type_id);
+			new_t = btf__type_by_id(targ_spec->btf, res->new_type_id);
+
+			/* There are two use cases in which it's safe to
+			 * adjust load/store's mem size:
+			 *   - reading a 32-bit kernel pointer, while on BPF
+			 *   size pointers are always 64-bit; in this case
+			 *   it's safe to "downsize" instruction size due to
+			 *   pointer being treated as unsigned integer with
+			 *   zero-extended upper 32-bits;
+			 *   - reading unsigned integers, again due to
+			 *   zero-extension is preserving the value correctly.
+			 *
+			 * In all other cases it's incorrect to attempt to
+			 * load/store field because read value will be
+			 * incorrect, so we poison relocated instruction.
+			 */
+			if (btf_is_ptr(orig_t) && btf_is_ptr(new_t))
+				goto done;
+			if (btf_is_int(orig_t) && btf_is_int(new_t) &&
+			    btf_int_encoding(orig_t) != BTF_INT_SIGNED &&
+			    btf_int_encoding(new_t) != BTF_INT_SIGNED)
+				goto done;
+
+			/* mark as invalid mem size adjustment, but this will
+			 * only be checked for LDX/STX/ST insns
+			 */
+			res->fail_memsz_adjust = true;
+		}
 	} else if (core_relo_is_type_based(relo->kind)) {
 		err = bpf_core_calc_type_relo(relo, local_spec, &res->orig_val);
 		err = err ?: bpf_core_calc_type_relo(relo, targ_spec, &res->new_val);
@@ -5252,6 +5324,7 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
 		err = err ?: bpf_core_calc_enumval_relo(relo, targ_spec, &res->new_val);
 	}
 
+done:
 	if (err == -EUCLEAN) {
 		/* EUCLEAN is used to signal instruction poisoning request */
 		res->poison = true;
@@ -5291,6 +5364,28 @@ static bool is_ldimm64(struct bpf_insn *insn)
 	return insn->code == (BPF_LD | BPF_IMM | BPF_DW);
 }
 
+static int insn_bpf_size_to_bytes(struct bpf_insn *insn)
+{
+	switch (BPF_SIZE(insn->code)) {
+	case BPF_DW: return 8;
+	case BPF_W: return 4;
+	case BPF_H: return 2;
+	case BPF_B: return 1;
+	default: return -1;
+	}
+}
+
+static int insn_bytes_to_bpf_size(__u32 sz)
+{
+	switch (sz) {
+	case 8: return BPF_DW;
+	case 4: return BPF_W;
+	case 2: return BPF_H;
+	case 1: return BPF_B;
+	default: return -1;
+	}
+}
+
 /*
  * Patch relocatable BPF instruction.
  *
@@ -5300,10 +5395,13 @@ static bool is_ldimm64(struct bpf_insn *insn)
  * spec, and is checked before patching instruction. If actual insn->imm value
  * is wrong, bail out with error.
  *
- * Currently three kinds of BPF instructions are supported:
+ * Currently supported classes of BPF instruction are:
  * 1. rX = <imm> (assignment with immediate operand);
  * 2. rX += <imm> (arithmetic operations with immediate operand);
- * 3. rX = <imm64> (load with 64-bit immediate value).
+ * 3. rX = <imm64> (load with 64-bit immediate value);
+ * 4. rX = *(T *)(rY + <off>), where T is one of {u8, u16, u32, u64};
+ * 5. *(T *)(rX + <off>) = rY, where T is one of {u8, u16, u32, u64};
+ * 6. *(T *)(rX + <off>) = <imm>, where T is one of {u8, u16, u32, u64}.
  */
 static int bpf_core_patch_insn(struct bpf_program *prog,
 			       const struct bpf_core_relo *relo,
@@ -5327,6 +5425,7 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 	class = BPF_CLASS(insn->code);
 
 	if (res->poison) {
+poison:
 		/* poison second part of ldimm64 to avoid confusing error from
 		 * verifier about "unknown opcode 00"
 		 */
@@ -5369,10 +5468,39 @@ static int bpf_core_patch_insn(struct bpf_program *prog,
 				prog->name, relo_idx, insn_idx, new_val);
 			return -ERANGE;
 		}
+		if (res->fail_memsz_adjust) {
+			pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) accesses field incorrectly. "
+				"Make sure you are accessing pointers, unsigned integers, or fields of matching type and size.\n",
+				prog->name, relo_idx, insn_idx);
+			goto poison;
+		}
+
 		orig_val = insn->off;
 		insn->off = new_val;
 		pr_debug("prog '%s': relo #%d: patched insn #%d (LDX/ST/STX) off %u -> %u\n",
 			 prog->name, relo_idx, insn_idx, orig_val, new_val);
+
+		if (res->new_sz != res->orig_sz) {
+			int insn_bytes_sz, insn_bpf_sz;
+
+			insn_bytes_sz = insn_bpf_size_to_bytes(insn);
+			if (insn_bytes_sz != res->orig_sz) {
+				pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) unexpected mem size: got %d, exp %u\n",
+					prog->name, relo_idx, insn_idx, insn_bytes_sz, res->orig_sz);
+				return -EINVAL;
+			}
+
+			insn_bpf_sz = insn_bytes_to_bpf_size(res->new_sz);
+			if (insn_bpf_sz < 0) {
+				pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) invalid new mem size: %u\n",
+					prog->name, relo_idx, insn_idx, res->new_sz);
+				return -EINVAL;
+			}
+
+			insn->code = BPF_MODE(insn->code) | insn_bpf_sz | BPF_CLASS(insn->code);
+			pr_debug("prog '%s': relo #%d: patched insn #%d (LDX/ST/STX) mem_sz %u -> %u\n",
+				 prog->name, relo_idx, insn_idx, res->orig_sz, res->new_sz);
+		}
 		break;
 	case BPF_LD: {
 		__u64 imm;
-- 
2.24.1

