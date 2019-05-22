Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA74626A30
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfEVSzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:55:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40526 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbfEVSzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:55:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id f10so3477295wre.7
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ylM0eiK+f6u9dDT4b6ift01mFCcPqaYM+YreEfeTiCY=;
        b=sxeg/q16qFKFUzSqiGd/wQHVE3dqrutoXs97LLLyGUQwxB95Z8lVe5NL4UCcyFvJyp
         XExTgp6s2BEd63Jg6ND/I5KNes8DfLOo1Eu2AKNe5gm17ilaDY26CjEviwC+qMtQUi5K
         fzvfIPOLgX7if6Hao6STYbbJ5DfuJ3qJ05+/O1BC5ZjS8pbOMv5iRvh2ntNnEP3anqZl
         oO+5EOwEM6t0cUMjydWEoaUXCSYShG827YOWbcbkl0AgNZ0S7kAxHvzHQx37V5tFGRKn
         1uvvaJILXBnafUJfb5BtegwSKvgbou9qyvRn2dKzv+YsF5SCMK2L8vZeDx/FqTN1dMjI
         j/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ylM0eiK+f6u9dDT4b6ift01mFCcPqaYM+YreEfeTiCY=;
        b=jiHS5ZmVL8KSFEUxz6wY+aRzzYgeDqaGahBMXpBxMhUAevITIEUSOLCDZIehKM37Lb
         8g7m8W5HLU6MNXXBOqYGFsy4BOgGcG1FGZn6Qt6mZXOylinFVKFbbOQ/4EvXj2mNLelQ
         ZNpQEID+kkvMxraD8+70sCIK1Ts6wzluIe3r5jvNjTe/p7DMMBkxojB4WycZMSZd33Wm
         v0udcL38KUi6H7hB24tpXTrOzs9zhRz6PN6PmoaqXaCnOH36RJCg+2A8pGxqVryYwr5o
         y7r69SEqQzZs5U8YhmipBmTC3TWxI5kFavHiQlOcARmJ+fvb2okKTiEZ446JwvLf+48B
         ZgeA==
X-Gm-Message-State: APjAAAVm9WtYc7Y7FH+k3mAYkqKedWA+BYUbXUgvvMDwEqonL0fOYyF4
        NIrfycDAtIA2dzdieCJ3kvY5fQ==
X-Google-Smtp-Source: APXvYqyO0faNiVkWxjddZ6FR1CCdQhnQGBd7Eb3/mQPx4J5VXRihJWgtmXEMvvpv+Y5Oqt0nsugMNw==
X-Received: by 2002:adf:cc8b:: with SMTP id p11mr40883085wrj.13.1558551350085;
        Wed, 22 May 2019 11:55:50 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t12sm16328801wro.2.2019.05.22.11.55.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 11:55:49 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v7 bpf-next 01/16] bpf: verifier: mark verified-insn with sub-register zext flag
Date:   Wed, 22 May 2019 19:54:57 +0100
Message-Id: <1558551312-17081-2-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eBPF ISA specification requires high 32-bit cleared when low 32-bit
sub-register is written. This applies to destination register of ALU32 etc.
JIT back-ends must guarantee this semantic when doing code-gen. x86_64 and
AArch64 ISA has the same semantics, so the corresponding JIT back-end
doesn't need to do extra work.

However, 32-bit arches (arm, x86, nfp etc.) and some other 64-bit arches
(PowerPC, SPARC etc) need to do explicit zero extension to meet this
requirement, otherwise code like the following will fail.

  u64_value = (u64) u32_value
  ... other uses of u64_value

This is because compiler could exploit the semantic described above and
save those zero extensions for extending u32_value to u64_value, these JIT
back-ends are expected to guarantee this through inserting extra zero
extensions which however could be a significant increase on the code size.
Some benchmarks show there could be ~40% sub-register writes out of total
insns, meaning at least ~40% extra code-gen.

One observation is these extra zero extensions are not always necessary.
Take above code snippet for example, it is possible u32_value will never be
casted into a u64, the value of high 32-bit of u32_value then could be
ignored and extra zero extension could be eliminated.

This patch implements this idea, insns defining sub-registers will be
marked when the high 32-bit of the defined sub-register matters. For
those unmarked insns, it is safe to eliminate high 32-bit clearnace for
them.

Algo:
 - Split read flags into READ32 and READ64.

 - Record index of insn that does sub-register write. Keep the index inside
   reg state and update it during verifier insn walking.

 - A full register read on a sub-register marks its definition insn as
   needing zero extension on dst register.

   A new sub-register write overrides the old one.

 - When propagating read64 during path pruning, also mark any insn defining
   a sub-register that is read in the pruned path as full-register.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 include/linux/bpf_verifier.h |  14 +++-
 kernel/bpf/verifier.c        | 175 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 173 insertions(+), 16 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 1305ccb..60fb54e 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -36,9 +36,11 @@
  */
 enum bpf_reg_liveness {
 	REG_LIVE_NONE = 0, /* reg hasn't been read or written this branch */
-	REG_LIVE_READ, /* reg was read, so we're sensitive to initial value */
-	REG_LIVE_WRITTEN, /* reg was written first, screening off later reads */
-	REG_LIVE_DONE = 4, /* liveness won't be updating this register anymore */
+	REG_LIVE_READ32 = 0x1, /* reg was read, so we're sensitive to initial value */
+	REG_LIVE_READ64 = 0x2, /* likewise, but full 64-bit content matters */
+	REG_LIVE_READ = REG_LIVE_READ32 | REG_LIVE_READ64,
+	REG_LIVE_WRITTEN = 0x4, /* reg was written first, screening off later reads */
+	REG_LIVE_DONE = 0x8, /* liveness won't be updating this register anymore */
 };
 
 struct bpf_reg_state {
@@ -131,6 +133,11 @@ struct bpf_reg_state {
 	 * pointing to bpf_func_state.
 	 */
 	u32 frameno;
+	/* Tracks subreg definition. The stored value is the insn_idx of the
+	 * writing insn. This is safe because subreg_def is used before any insn
+	 * patching which only happens after main verification finished.
+	 */
+	s32 subreg_def;
 	enum bpf_reg_liveness live;
 };
 
@@ -232,6 +239,7 @@ struct bpf_insn_aux_data {
 	int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
 	int sanitize_stack_off; /* stack slot to be cleared */
 	bool seen; /* this insn was processed by the verifier */
+	bool zext_dst; /* this insn zero extends dst reg */
 	u8 alu_state; /* used in combination with alu_limit */
 	unsigned int orig_idx; /* original instruction index */
 };
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 95f93544..0efccf8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -981,6 +981,7 @@ static void mark_reg_not_init(struct bpf_verifier_env *env,
 	__mark_reg_not_init(regs + regno);
 }
 
+#define DEF_NOT_SUBREG	(-1)
 static void init_reg_state(struct bpf_verifier_env *env,
 			   struct bpf_func_state *state)
 {
@@ -991,6 +992,7 @@ static void init_reg_state(struct bpf_verifier_env *env,
 		mark_reg_not_init(env, regs, i);
 		regs[i].live = REG_LIVE_NONE;
 		regs[i].parent = NULL;
+		regs[i].subreg_def = DEF_NOT_SUBREG;
 	}
 
 	/* frame pointer */
@@ -1136,7 +1138,7 @@ static int check_subprogs(struct bpf_verifier_env *env)
  */
 static int mark_reg_read(struct bpf_verifier_env *env,
 			 const struct bpf_reg_state *state,
-			 struct bpf_reg_state *parent)
+			 struct bpf_reg_state *parent, u8 flag)
 {
 	bool writes = parent == state->parent; /* Observe write marks */
 	int cnt = 0;
@@ -1151,17 +1153,26 @@ static int mark_reg_read(struct bpf_verifier_env *env,
 				parent->var_off.value, parent->off);
 			return -EFAULT;
 		}
-		if (parent->live & REG_LIVE_READ)
+		/* The first condition is more likely to be true than the
+		 * second, checked it first.
+		 */
+		if ((parent->live & REG_LIVE_READ) == flag ||
+		    parent->live & REG_LIVE_READ64)
 			/* The parentage chain never changes and
 			 * this parent was already marked as LIVE_READ.
 			 * There is no need to keep walking the chain again and
 			 * keep re-marking all parents as LIVE_READ.
 			 * This case happens when the same register is read
 			 * multiple times without writes into it in-between.
+			 * Also, if parent has the stronger REG_LIVE_READ64 set,
+			 * then no need to set the weak REG_LIVE_READ32.
 			 */
 			break;
 		/* ... then we depend on parent's value */
-		parent->live |= REG_LIVE_READ;
+		parent->live |= flag;
+		/* REG_LIVE_READ64 overrides REG_LIVE_READ32. */
+		if (flag == REG_LIVE_READ64)
+			parent->live &= ~REG_LIVE_READ32;
 		state = parent;
 		parent = state->parent;
 		writes = true;
@@ -1173,12 +1184,111 @@ static int mark_reg_read(struct bpf_verifier_env *env,
 	return 0;
 }
 
+/* This function is supposed to be used by the following 32-bit optimization
+ * code only. It returns TRUE if the source or destination register operates
+ * on 64-bit, otherwise return FALSE.
+ */
+static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
+		     u32 regno, struct bpf_reg_state *reg, enum reg_arg_type t)
+{
+	u8 code, class, op;
+
+	code = insn->code;
+	class = BPF_CLASS(code);
+	op = BPF_OP(code);
+	if (class == BPF_JMP) {
+		/* BPF_EXIT for "main" will reach here. Return TRUE
+		 * conservatively.
+		 */
+		if (op == BPF_EXIT)
+			return true;
+		if (op == BPF_CALL) {
+			/* BPF to BPF call will reach here because of marking
+			 * caller saved clobber with DST_OP_NO_MARK for which we
+			 * don't care the register def because they are anyway
+			 * marked as NOT_INIT already.
+			 */
+			if (insn->src_reg == BPF_PSEUDO_CALL)
+				return false;
+			/* Helper call will reach here because of arg type
+			 * check, conservatively return TRUE.
+			 */
+			if (t == SRC_OP)
+				return true;
+
+			return false;
+		}
+	}
+
+	if (class == BPF_ALU64 || class == BPF_JMP ||
+	    /* BPF_END always use BPF_ALU class. */
+	    (class == BPF_ALU && op == BPF_END && insn->imm == 64))
+		return true;
+
+	if (class == BPF_ALU || class == BPF_JMP32)
+		return false;
+
+	if (class == BPF_LDX) {
+		if (t != SRC_OP)
+			return BPF_SIZE(code) == BPF_DW;
+		/* LDX source must be ptr. */
+		return true;
+	}
+
+	if (class == BPF_STX) {
+		if (reg->type != SCALAR_VALUE)
+			return true;
+		return BPF_SIZE(code) == BPF_DW;
+	}
+
+	if (class == BPF_LD) {
+		u8 mode = BPF_MODE(code);
+
+		/* LD_IMM64 */
+		if (mode == BPF_IMM)
+			return true;
+
+		/* Both LD_IND and LD_ABS return 32-bit data. */
+		if (t != SRC_OP)
+			return  false;
+
+		/* Implicit ctx ptr. */
+		if (regno == BPF_REG_6)
+			return true;
+
+		/* Explicit source could be any width. */
+		return true;
+	}
+
+	if (class == BPF_ST)
+		/* The only source register for BPF_ST is a ptr. */
+		return true;
+
+	/* Conservatively return true at default. */
+	return true;
+}
+
+static void mark_insn_zext(struct bpf_verifier_env *env,
+			   struct bpf_reg_state *reg)
+{
+	s32 def_idx = reg->subreg_def;
+
+	if (def_idx == DEF_NOT_SUBREG)
+		return;
+
+	env->insn_aux_data[def_idx].zext_dst = true;
+	/* The dst will be zero extended, so won't be sub-register anymore. */
+	reg->subreg_def = DEF_NOT_SUBREG;
+}
+
 static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
 			 enum reg_arg_type t)
 {
 	struct bpf_verifier_state *vstate = env->cur_state;
 	struct bpf_func_state *state = vstate->frame[vstate->curframe];
+	struct bpf_insn *insn = env->prog->insnsi + env->insn_idx;
 	struct bpf_reg_state *reg, *regs = state->regs;
+	bool rw64;
 
 	if (regno >= MAX_BPF_REG) {
 		verbose(env, "R%d is invalid\n", regno);
@@ -1186,6 +1296,7 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
 	}
 
 	reg = &regs[regno];
+	rw64 = is_reg64(env, insn, regno, reg, t);
 	if (t == SRC_OP) {
 		/* check whether register used as source operand can be read */
 		if (reg->type == NOT_INIT) {
@@ -1196,7 +1307,11 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
 		if (regno == BPF_REG_FP)
 			return 0;
 
-		return mark_reg_read(env, reg, reg->parent);
+		if (rw64)
+			mark_insn_zext(env, reg);
+
+		return mark_reg_read(env, reg, reg->parent,
+				     rw64 ? REG_LIVE_READ64 : REG_LIVE_READ32);
 	} else {
 		/* check whether register used as dest operand can be written to */
 		if (regno == BPF_REG_FP) {
@@ -1204,6 +1319,7 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
 			return -EACCES;
 		}
 		reg->live |= REG_LIVE_WRITTEN;
+		reg->subreg_def = rw64 ? DEF_NOT_SUBREG : env->insn_idx;
 		if (t == DST_OP)
 			mark_reg_unknown(env, regs, regno);
 	}
@@ -1383,7 +1499,8 @@ static int check_stack_read(struct bpf_verifier_env *env,
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
 		}
 		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
-			      reg_state->stack[spi].spilled_ptr.parent);
+			      reg_state->stack[spi].spilled_ptr.parent,
+			      REG_LIVE_READ64);
 		return 0;
 	} else {
 		int zeros = 0;
@@ -1400,7 +1517,9 @@ static int check_stack_read(struct bpf_verifier_env *env,
 			return -EACCES;
 		}
 		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
-			      reg_state->stack[spi].spilled_ptr.parent);
+			      reg_state->stack[spi].spilled_ptr.parent,
+			      size == BPF_REG_SIZE
+			      ? REG_LIVE_READ64 : REG_LIVE_READ32);
 		if (value_regno >= 0) {
 			if (zeros == size) {
 				/* any size read into register is zero extended,
@@ -2109,6 +2228,12 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 						    value_regno);
 				if (reg_type_may_be_null(reg_type))
 					regs[value_regno].id = ++env->id_gen;
+				/* A load of ctx field could have different
+				 * actual load size with the one encoded in the
+				 * insn. When the dst is PTR, it is for sure not
+				 * a sub-register.
+				 */
+				regs[value_regno].subreg_def = DEF_NOT_SUBREG;
 			}
 			regs[value_regno].type = reg_type;
 		}
@@ -2368,7 +2493,9 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		 * the whole slot to be marked as 'read'
 		 */
 		mark_reg_read(env, &state->stack[spi].spilled_ptr,
-			      state->stack[spi].spilled_ptr.parent);
+			      state->stack[spi].spilled_ptr.parent,
+			      access_size == BPF_REG_SIZE
+			      ? REG_LIVE_READ64 : REG_LIVE_READ32);
 	}
 	return update_stack_depth(env, state, min_off);
 }
@@ -3332,6 +3459,9 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		check_reg_arg(env, caller_saved[i], DST_OP_NO_MARK);
 	}
 
+	/* helper call returns 64-bit value. */
+	regs[BPF_REG_0].subreg_def = DEF_NOT_SUBREG;
+
 	/* update return register (already marked as written above) */
 	if (fn->ret_type == RET_INTEGER) {
 		/* sets type to SCALAR_VALUE */
@@ -4263,6 +4393,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				 */
 				*dst_reg = *src_reg;
 				dst_reg->live |= REG_LIVE_WRITTEN;
+				dst_reg->subreg_def = DEF_NOT_SUBREG;
 			} else {
 				/* R1 = (u32) R2 */
 				if (is_pointer_value(env, insn->src_reg)) {
@@ -4273,6 +4404,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				} else if (src_reg->type == SCALAR_VALUE) {
 					*dst_reg = *src_reg;
 					dst_reg->live |= REG_LIVE_WRITTEN;
+					dst_reg->subreg_def = env->insn_idx;
 				} else {
 					mark_reg_unknown(env, regs,
 							 insn->dst_reg);
@@ -5352,6 +5484,8 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	 * Already marked as written above.
 	 */
 	mark_reg_unknown(env, regs, BPF_REG_0);
+	/* ld_abs load up to 32-bit skb data. */
+	regs[BPF_REG_0].subreg_def = env->insn_idx;
 	return 0;
 }
 
@@ -6292,20 +6426,33 @@ static bool states_equal(struct bpf_verifier_env *env,
 	return true;
 }
 
+/* Return 0 if no propagation happened. Return negative error code if error
+ * happened. Otherwise, return the propagated bit.
+ */
 static int propagate_liveness_reg(struct bpf_verifier_env *env,
 				  struct bpf_reg_state *reg,
 				  struct bpf_reg_state *parent_reg)
 {
+	u8 parent_flag = parent_reg->live & REG_LIVE_READ;
+	u8 flag = reg->live & REG_LIVE_READ;
 	int err;
 
-	if (parent_reg->live & REG_LIVE_READ || !(reg->live & REG_LIVE_READ))
+	/* When comes here, read flags of PARENT_REG or REG could be any of
+	 * REG_LIVE_READ64, REG_LIVE_READ32, REG_LIVE_NONE. There is no need
+	 * of propagation if PARENT_REG has strongest REG_LIVE_READ64.
+	 */
+	if (parent_flag == REG_LIVE_READ64 ||
+	    /* Or if there is no read flag from REG. */
+	    !flag ||
+	    /* Or if the read flag from REG is the same as PARENT_REG. */
+	    parent_flag == flag)
 		return 0;
 
-	err = mark_reg_read(env, reg, parent_reg);
+	err = mark_reg_read(env, reg, parent_reg, flag);
 	if (err)
 		return err;
 
-	return 0;
+	return flag;
 }
 
 /* A write screens off any subsequent reads; but write marks come from the
@@ -6339,8 +6486,10 @@ static int propagate_liveness(struct bpf_verifier_env *env,
 		for (i = frame < vstate->curframe ? BPF_REG_6 : 0; i < BPF_REG_FP; i++) {
 			err = propagate_liveness_reg(env, &state_reg[i],
 						     &parent_reg[i]);
-			if (err)
+			if (err < 0)
 				return err;
+			if (err == REG_LIVE_READ64)
+				mark_insn_zext(env, &parent_reg[i]);
 		}
 
 		/* Propagate stack slots. */
@@ -6350,11 +6499,11 @@ static int propagate_liveness(struct bpf_verifier_env *env,
 			state_reg = &state->stack[i].spilled_ptr;
 			err = propagate_liveness_reg(env, state_reg,
 						     parent_reg);
-			if (err)
+			if (err < 0)
 				return err;
 		}
 	}
-	return err;
+	return 0;
 }
 
 static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
-- 
2.7.4

