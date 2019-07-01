Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C062A145
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404406AbfEXW10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:26 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37578 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404343AbfEXW1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:27:24 -0400
Received: by mail-wm1-f68.google.com with SMTP id 7so10578979wmo.2
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uHrcfOo9lsfEtZ7v8VUqdKo1tWiTELSWY+OibZLuYSQ=;
        b=ulyfONMbFjnn2hpOx5iVA/ZK1BndsEfd8kXMNgAzPMHl32J8x3R0bErbicEEH4lYoo
         gpV75Z8fTx7CeXxt8rRJV57iFfue++WnuZ0KKnNLXk06Qj6nC8CKRmKAJHUyj5Z/P+G6
         uaeiXKvI0sbBmnAR4CrOoSULLUm7H/0VEvJj29LoTJ++Ma/DLt87UVD0/TyP2YOScCPp
         PdtlIeA7LreNGVCWtF9S/WIXog9mgEWCK6F+tJ/pft6/kzWFNJBKO44zNjKaSZc2eA5u
         BbTixvXw2Sc8LfMcXfIddZbWAmpHLU/sCcFfO1LMtH/slZcWOhtqeEIsYSmjnQjnVsg5
         jQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uHrcfOo9lsfEtZ7v8VUqdKo1tWiTELSWY+OibZLuYSQ=;
        b=tjc93YCj5kFjw51ZusctOBnksdQSGFw9+fR+uILDq5oOdo4G5KjgdRu8L2swz5coif
         IASveKc0Em9PWzW/KuqA0eDjViX3EwjSj6lTsaygI/4mc65Lay9RmNKoFS1rfZjFBCyJ
         nYsOA12HcrJd4ivk5G3qZZFmL14oikVLNlmxkZsaypsT65PSX2kYbwsK65JKq1jIo7yd
         dPn1nCyE3Kyk6KfEMqtuFSUyn+Qr2RWwG1yDvZjuM6LZMGcomMufOrQK4aWQflHkOWzA
         LNIGI12cXqS5YwhGElI+e41Swn6nICRYwPnaYmdULwUQ7gyvaEQqS8hcudX5DxnpgC1d
         IPHQ==
X-Gm-Message-State: APjAAAUZ01eNUgOA3OYqx6eUWcw7JBwowxrCEa+zdQFIM6r9VWI6Oqm8
        E1kY3OaueimZpFYr+sAh+zSFEQ==
X-Google-Smtp-Source: APXvYqyuCSY8Q/tNhn0Lc7cUrEXINPF8fbQW70kkIFBNGZn/AoBcAsAB4svZMqX1ueRwG7KwMCqizQ==
X-Received: by 2002:a1c:9e8e:: with SMTP id h136mr17040837wme.29.1558736841747;
        Fri, 24 May 2019 15:27:21 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y10sm7194961wmg.8.2019.05.24.15.27.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 15:27:20 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v9 bpf-next 01/17] bpf: verifier: mark verified-insn with sub-register zext flag
Date:   Fri, 24 May 2019 23:25:12 +0100
Message-Id: <1558736728-7229-2-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
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
 kernel/bpf/verifier.c        | 173 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 171 insertions(+), 16 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 405b502..704ed79 100644
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
 
@@ -233,6 +240,7 @@ struct bpf_insn_aux_data {
 	int ctx_field_size; /* the ctx field size for load insn, maybe 0 */
 	int sanitize_stack_off; /* stack slot to be cleared */
 	bool seen; /* this insn was processed by the verifier */
+	bool zext_dst; /* this insn zero extends dst reg */
 	u8 alu_state; /* used in combination with alu_limit */
 	bool prune_point;
 	unsigned int orig_idx; /* original instruction index */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 550091c..f6b4c71 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -982,6 +982,7 @@ static void mark_reg_not_init(struct bpf_verifier_env *env,
 	__mark_reg_not_init(regs + regno);
 }
 
+#define DEF_NOT_SUBREG	(0)
 static void init_reg_state(struct bpf_verifier_env *env,
 			   struct bpf_func_state *state)
 {
@@ -992,6 +993,7 @@ static void init_reg_state(struct bpf_verifier_env *env,
 		mark_reg_not_init(env, regs, i);
 		regs[i].live = REG_LIVE_NONE;
 		regs[i].parent = NULL;
+		regs[i].subreg_def = DEF_NOT_SUBREG;
 	}
 
 	/* frame pointer */
@@ -1137,7 +1139,7 @@ static int check_subprogs(struct bpf_verifier_env *env)
  */
 static int mark_reg_read(struct bpf_verifier_env *env,
 			 const struct bpf_reg_state *state,
-			 struct bpf_reg_state *parent)
+			 struct bpf_reg_state *parent, u8 flag)
 {
 	bool writes = parent == state->parent; /* Observe write marks */
 	int cnt = 0;
@@ -1152,17 +1154,26 @@ static int mark_reg_read(struct bpf_verifier_env *env,
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
@@ -1174,12 +1185,111 @@ static int mark_reg_read(struct bpf_verifier_env *env,
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
+	env->insn_aux_data[def_idx - 1].zext_dst = true;
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
@@ -1187,6 +1297,7 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
 	}
 
 	reg = &regs[regno];
+	rw64 = is_reg64(env, insn, regno, reg, t);
 	if (t == SRC_OP) {
 		/* check whether register used as source operand can be read */
 		if (reg->type == NOT_INIT) {
@@ -1197,7 +1308,11 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
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
@@ -1205,6 +1320,7 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
 			return -EACCES;
 		}
 		reg->live |= REG_LIVE_WRITTEN;
+		reg->subreg_def = rw64 ? DEF_NOT_SUBREG : env->insn_idx + 1;
 		if (t == DST_OP)
 			mark_reg_unknown(env, regs, regno);
 	}
@@ -1384,7 +1500,8 @@ static int check_stack_read(struct bpf_verifier_env *env,
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
 		}
 		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
-			      reg_state->stack[spi].spilled_ptr.parent);
+			      reg_state->stack[spi].spilled_ptr.parent,
+			      REG_LIVE_READ64);
 		return 0;
 	} else {
 		int zeros = 0;
@@ -1401,7 +1518,8 @@ static int check_stack_read(struct bpf_verifier_env *env,
 			return -EACCES;
 		}
 		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
-			      reg_state->stack[spi].spilled_ptr.parent);
+			      reg_state->stack[spi].spilled_ptr.parent,
+			      REG_LIVE_READ64);
 		if (value_regno >= 0) {
 			if (zeros == size) {
 				/* any size read into register is zero extended,
@@ -2110,6 +2228,12 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
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
@@ -2369,7 +2493,8 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		 * the whole slot to be marked as 'read'
 		 */
 		mark_reg_read(env, &state->stack[spi].spilled_ptr,
-			      state->stack[spi].spilled_ptr.parent);
+			      state->stack[spi].spilled_ptr.parent,
+			      REG_LIVE_READ64);
 	}
 	return update_stack_depth(env, state, min_off);
 }
@@ -3333,6 +3458,9 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		check_reg_arg(env, caller_saved[i], DST_OP_NO_MARK);
 	}
 
+	/* helper call returns 64-bit value. */
+	regs[BPF_REG_0].subreg_def = DEF_NOT_SUBREG;
+
 	/* update return register (already marked as written above) */
 	if (fn->ret_type == RET_INTEGER) {
 		/* sets type to SCALAR_VALUE */
@@ -4264,6 +4392,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				 */
 				*dst_reg = *src_reg;
 				dst_reg->live |= REG_LIVE_WRITTEN;
+				dst_reg->subreg_def = DEF_NOT_SUBREG;
 			} else {
 				/* R1 = (u32) R2 */
 				if (is_pointer_value(env, insn->src_reg)) {
@@ -4274,6 +4403,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				} else if (src_reg->type == SCALAR_VALUE) {
 					*dst_reg = *src_reg;
 					dst_reg->live |= REG_LIVE_WRITTEN;
+					dst_reg->subreg_def = env->insn_idx + 1;
 				} else {
 					mark_reg_unknown(env, regs,
 							 insn->dst_reg);
@@ -5353,6 +5483,8 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	 * Already marked as written above.
 	 */
 	mark_reg_unknown(env, regs, BPF_REG_0);
+	/* ld_abs load up to 32-bit skb data. */
+	regs[BPF_REG_0].subreg_def = env->insn_idx + 1;
 	return 0;
 }
 
@@ -6309,20 +6441,33 @@ static bool states_equal(struct bpf_verifier_env *env,
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
@@ -6356,8 +6501,10 @@ static int propagate_liveness(struct bpf_verifier_env *env,
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
@@ -6367,11 +6514,11 @@ static int propagate_liveness(struct bpf_verifier_env *env,
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

