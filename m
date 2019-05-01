Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEA710948
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfEAOoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:17 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45017 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfEAOoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id c5so24797174wrs.11
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AolVoaAuOvOvsrvr4OyM+u2owgmpZDHuJ7+nFlzEPh0=;
        b=DKFdMGNrz10G8DBQNRyqMy/BeEq4i4RbXF/+gbJPv7JBeDz7R9OqWT1EHcF6Te8Hgm
         s7oq8eNe0ye0Csdu/mBD4yka6r6SknoyS2exJF4dRNrBlCCZc2HC5/LAeDqaBPFc3sh3
         aRBYL+ikVQvkO8MJwYXRCjn8/b25v0QiZUF6PHJThrpRkqnfMjMgcyiYFmMO9nh/PuGS
         TPQbC6GFHUPoyGZOlSSlCyX/aLyBgf3yP8862FBZ87rTnLdy1KhQjYpaHP3e+GDhiTxZ
         4x3ji2oIaaJK3HceRNtY5xAuXSlUzozpRe65p0gE6Ne42Zap8k72lj8remekiXXC8oc4
         Cgcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AolVoaAuOvOvsrvr4OyM+u2owgmpZDHuJ7+nFlzEPh0=;
        b=fYYWI9bygnkgQhmVt+4LtEgABJRePm1bys05T/sAG8CFtjVJzRZj+bso2AOf9bUU4l
         RsxWosBvrMwSBPG1oZTZMmR4zb6wsMrjY+Kw+qfcnqz/uyNRtf8Hg+Y6IlCvOJ7OwS/X
         uy3FPtMTr2S/xCaCDR3eGUef7v6f9itgbOtWOUJmH58GRxKC4mNUsmiYV97FwgYhxz2u
         hahlchEJB+mAyWtnmVtOCYqek0U1ZDeRAJLaUeYrej/0bBx806t0fLSP3tsPhtL9+x8J
         L2HwmrPh7UzipNnqQjyFjUeFcrxDBXXQl8D99b/clJYFF1xxdsZPi/vFpj/aDm1kXP3D
         4GIQ==
X-Gm-Message-State: APjAAAXaC9lr9spqdjMgSA6MtqNwl6WpsczhLVwuAUGL0YcYRYF1tqPj
        98UfgMSKilTagWjBhvPig/jhRg==
X-Google-Smtp-Source: APXvYqzHKrEHu8eagueRRwaUYNZkkLLd3NUzjQTQoBnQKelz9g1XtzhHd/C03/8pS2XCdZPXb19KVw==
X-Received: by 2002:adf:dc8c:: with SMTP id r12mr1992681wrj.139.1556721852188;
        Wed, 01 May 2019 07:44:12 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:10 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v5 bpf-next 02/17] bpf: verifier: mark verified-insn with sub-register zext flag
Date:   Wed,  1 May 2019 15:43:47 +0100
Message-Id: <1556721842-29836-3-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eBPF ISA specification requires high 32-bit cleared when low 32-bit
sub-register is written. This applies to destination register of ALU32 etc.
JIT back-ends must guarantee this semantic when doing code-gen.

x86-64 and arm64 ISA has the same semantic, so the corresponding JIT
back-end doesn't need to do extra work. However, 32-bit arches (arm, nfp
etc.) and some other 64-bit arches (powerpc, sparc etc), need explicit zero
extension sequence to meet such semantic.

This is important, because for code the following:

  u64_value = (u64) u32_value
  ... other uses of u64_value

compiler could exploit the semantic described above and save those zero
extensions for extending u32_value to u64_value. Hardware, runtime, or BPF
JIT back-ends, are responsible for guaranteeing this. Some benchmarks show
~40% sub-register writes out of total insns, meaning ~40% extra code-gen (
could go up to more for some arches which requires two shifts for zero
extension) because JIT back-end needs to do extra code-gen for all such
instructions.

However this is not always necessary in case u32_value is never cast into
a u64, which is quite normal in real life program. So, it would be really
good if we could identify those places where such type cast happened, and
only do zero extensions for them, not for the others. This could save a lot
of BPF code-gen.

Algo:
 - Split read flags into READ32 and READ64.

 - Record indices of instructions that do sub-register def (write). And
   these indices need to stay with reg state so path pruning and bpf
   to bpf function call could be handled properly.

   These indices are kept up to date while doing insn walk.

 - A full register read on an active sub-register def marks the def insn as
   needing zero extension on dst register.

 - A new sub-register write overrides the old one.

   A new full register write makes the register free of zero extension on
   dst register.

 - When propagating read64 during path pruning, also marks def insns whose
   defs are hanging active sub-register.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 include/linux/bpf_verifier.h |  14 ++-
 kernel/bpf/verifier.c        | 213 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 211 insertions(+), 16 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 1305ccb..6a0b12c 100644
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
+	bool zext_dst; /* this insn zero extend dst reg */
 	u8 alu_state; /* used in combination with alu_limit */
 	unsigned int orig_idx; /* original instruction index */
 };
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 07ab563..6e62cc8 100644
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
@@ -1173,12 +1184,146 @@ static int mark_reg_read(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static bool helper_call_arg64(struct bpf_verifier_env *env, int func_id,
+			      u32 regno)
+{
+	/* get_func_proto must succeed, other it should have been rejected
+	 * early inside check_helper_call.
+	 */
+	const struct bpf_func_proto *fn =
+		env->ops->get_func_proto(func_id, env->prog);
+	enum bpf_arg_type arg_type;
+
+	switch (regno) {
+	case BPF_REG_1:
+		arg_type = fn->arg1_type;
+		break;
+	case BPF_REG_2:
+		arg_type = fn->arg2_type;
+		break;
+	case BPF_REG_3:
+		arg_type = fn->arg3_type;
+		break;
+	case BPF_REG_4:
+		arg_type = fn->arg4_type;
+		break;
+	case BPF_REG_5:
+		arg_type = fn->arg5_type;
+		break;
+	default:
+		arg_type = ARG_DONTCARE;
+	}
+
+	return arg_type != ARG_CONST_SIZE32 &&
+	       arg_type != ARG_CONST_SIZE32_OR_ZERO &&
+	       arg_type != ARG_ANYTHING32;
+}
+
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
+			 * check.
+			 */
+			if (t == SRC_OP)
+				return helper_call_arg64(env, insn->imm, regno);
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
@@ -1186,6 +1331,7 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
 	}
 
 	reg = &regs[regno];
+	rw64 = is_reg64(env, insn, regno, reg, t);
 	if (t == SRC_OP) {
 		/* check whether register used as source operand can be read */
 		if (reg->type == NOT_INIT) {
@@ -1196,7 +1342,11 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
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
@@ -1204,6 +1354,7 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
 			return -EACCES;
 		}
 		reg->live |= REG_LIVE_WRITTEN;
+		reg->subreg_def = rw64 ? DEF_NOT_SUBREG : env->insn_idx;
 		if (t == DST_OP)
 			mark_reg_unknown(env, regs, regno);
 	}
@@ -1383,7 +1534,8 @@ static int check_stack_read(struct bpf_verifier_env *env,
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
 		}
 		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
-			      reg_state->stack[spi].spilled_ptr.parent);
+			      reg_state->stack[spi].spilled_ptr.parent,
+			      REG_LIVE_READ64);
 		return 0;
 	} else {
 		int zeros = 0;
@@ -1400,7 +1552,9 @@ static int check_stack_read(struct bpf_verifier_env *env,
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
@@ -2109,6 +2263,12 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
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
@@ -2368,7 +2528,9 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
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
@@ -3337,10 +3499,16 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 		check_reg_arg(env, caller_saved[i], DST_OP_NO_MARK);
 	}
 
+	/* assume helper call has returned 64-bit value. */
+	regs[BPF_REG_0].subreg_def = DEF_NOT_SUBREG;
+
 	/* update return register (already marked as written above) */
 	if (fn->ret_type == RET_INTEGER || fn->ret_type == RET_INTEGER64) {
 		/* sets type to SCALAR_VALUE */
 		mark_reg_unknown(env, regs, BPF_REG_0);
+		/* RET_INTEGER returns sub-register. */
+		if (fn->ret_type == RET_INTEGER)
+			regs[BPF_REG_0].subreg_def = insn_idx;
 	} else if (fn->ret_type == RET_VOID) {
 		regs[BPF_REG_0].type = NOT_INIT;
 	} else if (fn->ret_type == RET_PTR_TO_MAP_VALUE_OR_NULL ||
@@ -4268,6 +4436,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				 */
 				*dst_reg = *src_reg;
 				dst_reg->live |= REG_LIVE_WRITTEN;
+				dst_reg->subreg_def = DEF_NOT_SUBREG;
 			} else {
 				/* R1 = (u32) R2 */
 				if (is_pointer_value(env, insn->src_reg)) {
@@ -4278,6 +4447,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				} else if (src_reg->type == SCALAR_VALUE) {
 					*dst_reg = *src_reg;
 					dst_reg->live |= REG_LIVE_WRITTEN;
+					dst_reg->subreg_def = env->insn_idx;
 				} else {
 					mark_reg_unknown(env, regs,
 							 insn->dst_reg);
@@ -5341,6 +5511,8 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	 * Already marked as written above.
 	 */
 	mark_reg_unknown(env, regs, BPF_REG_0);
+	/* ld_abs load up to 32-bit skb data. */
+	regs[BPF_REG_0].subreg_def = env->insn_idx;
 	return 0;
 }
 
@@ -6281,20 +6453,33 @@ static bool states_equal(struct bpf_verifier_env *env,
 	return true;
 }
 
+/* Return 0 if no propagation happened. Return negative error code if error
+ * happened. Otherwise, return the propagated bits.
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
@@ -6328,8 +6513,10 @@ static int propagate_liveness(struct bpf_verifier_env *env,
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
@@ -6339,11 +6526,11 @@ static int propagate_liveness(struct bpf_verifier_env *env,
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

