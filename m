Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5542744625
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404324AbfFMQte convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jun 2019 12:49:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59202 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727060AbfFMEU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 00:20:27 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D4EhpI019412
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:20:24 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t38w7151g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:20:24 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Jun 2019 21:20:22 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id B05DB760CD6; Wed, 12 Jun 2019 21:20:21 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <jakub.kicinski@netronome.com>,
        <ecree@solarflare.com>, <john.fastabend@gmail.com>,
        <andriin@fb.com>, <jannh@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 9/9] bpf: precise scalar_value tracking
Date:   Wed, 12 Jun 2019 21:20:03 -0700
Message-ID: <20190613042003.3791852-10-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190613042003.3791852-1-ast@kernel.org>
References: <20190613042003.3791852-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130033
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce precision tracking logic that
helps cilium programs the most:
                  old clang  old clang    new clang  new clang
                          with all patches         with all patches
bpf_lb-DLB_L3.o      1838     2728         1923      2216
bpf_lb-DLB_L4.o      3218     3562         3077      3390
bpf_lb-DUNKNOWN.o    1064     544          1062      543
bpf_lxc-DDROP_ALL.o  26935    15989        166729    15372
bpf_lxc-DUNKNOWN.o   34439    26043        174607    22156
bpf_netdev.o         9721     8062         8407      7312
bpf_overlay.o        6184     6138         5420      5555
bpf_lxc_jit.o        39389    39452        39389     39452

Consider code:
654: (85) call bpf_get_hash_recalc#34
655: (bf) r7 = r0
656: (15) if r8 == 0x0 goto pc+29
657: (bf) r2 = r10
658: (07) r2 += -48
659: (18) r1 = 0xffff8881e41e1b00
661: (85) call bpf_map_lookup_elem#1
662: (15) if r0 == 0x0 goto pc+23
663: (69) r1 = *(u16 *)(r0 +0)
664: (15) if r1 == 0x0 goto pc+21
665: (bf) r8 = r7
666: (57) r8 &= 65535
667: (bf) r2 = r8
668: (3f) r2 /= r1
669: (2f) r2 *= r1
670: (bf) r1 = r8
671: (1f) r1 -= r2
672: (57) r1 &= 255
673: (25) if r1 > 0x1e goto pc+12
 R0=map_value(id=0,off=0,ks=20,vs=64,imm=0) R1_w=inv(id=0,umax_value=30,var_off=(0x0; 0x1f))
674: (67) r1 <<= 1
675: (0f) r0 += r1

At this point the verifier will notice that scalar R1 is used in map pointer adjustment.
R1 has to be precise for later operations on R0 to be validated properly.

The verifier will backtrack the above code in the following way:
last_idx 675 first_idx 664
regs=2 stack=0 before 675: (0f) r0 += r1         // started backtracking R1 regs=2 is a bitmask
regs=2 stack=0 before 674: (67) r1 <<= 1
regs=2 stack=0 before 673: (25) if r1 > 0x1e goto pc+12
regs=2 stack=0 before 672: (57) r1 &= 255
regs=2 stack=0 before 671: (1f) r1 -= r2         // now both R1 and R2 has to be precise -> regs=6 mask
regs=6 stack=0 before 670: (bf) r1 = r8          // after this insn R8 and R2 has to be precise
regs=104 stack=0 before 669: (2f) r2 *= r1       // after this one R8, R2, and R1
regs=106 stack=0 before 668: (3f) r2 /= r1
regs=106 stack=0 before 667: (bf) r2 = r8
regs=102 stack=0 before 666: (57) r8 &= 65535
regs=102 stack=0 before 665: (bf) r8 = r7
regs=82 stack=0 before 664: (15) if r1 == 0x0 goto pc+21
 // this is the end of verifier state. The following regs will be marked precised:
 R1_rw=invP(id=0,umax_value=65535,var_off=(0x0; 0xffff)) R7_rw=invP(id=0)
parent didn't have regs=82 stack=0 marks         // so backtracking continues into parent state
last_idx 663 first_idx 655
regs=82 stack=0 before 663: (69) r1 = *(u16 *)(r0 +0)   // R1 was assigned no need to track it further
regs=80 stack=0 before 662: (15) if r0 == 0x0 goto pc+23    // keep tracking R7
regs=80 stack=0 before 661: (85) call bpf_map_lookup_elem#1  // keep tracking R7
regs=80 stack=0 before 659: (18) r1 = 0xffff8881e41e1b00
regs=80 stack=0 before 658: (07) r2 += -48
regs=80 stack=0 before 657: (bf) r2 = r10
regs=80 stack=0 before 656: (15) if r8 == 0x0 goto pc+29
regs=80 stack=0 before 655: (bf) r7 = r0                // here the assignment into R7
 // mark R0 to be precise:
 R0_rw=invP(id=0)
parent didn't have regs=1 stack=0 marks                 // regs=1 -> tracking R0
last_idx 654 first_idx 644
regs=1 stack=0 before 654: (85) call bpf_get_hash_recalc#34 // and in the parent frame it was a return value
  // nothing further to backtrack

Two scalar registers not marked precise are equivalent from state pruning point of view.
More details in the patch comments.

It doesn't support bpf2bpf calls yet and enabled for root only.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf_verifier.h |  18 ++
 kernel/bpf/verifier.c        | 461 ++++++++++++++++++++++++++++++++++-
 2 files changed, 469 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 03037373b447..19393b0964a8 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -139,6 +139,8 @@ struct bpf_reg_state {
 	 */
 	s32 subreg_def;
 	enum bpf_reg_liveness live;
+	/* if (!precise && SCALAR_VALUE) min/max/tnum don't affect safety */
+	bool precise;
 };
 
 enum bpf_stack_slot_type {
@@ -190,6 +192,11 @@ struct bpf_func_state {
 	struct bpf_stack_state *stack;
 };
 
+struct bpf_idx_pair {
+	u32 prev_idx;
+	u32 idx;
+};
+
 #define MAX_CALL_FRAMES 8
 struct bpf_verifier_state {
 	/* call stack tracking */
@@ -245,6 +252,17 @@ struct bpf_verifier_state {
 	u32 curframe;
 	u32 active_spin_lock;
 	bool speculative;
+
+	/* first and last insn idx of this verifier state */
+	u32 first_insn_idx;
+	u32 last_insn_idx;
+	/* jmp history recorded from first to last.
+	 * backtracking is using it to go from last to first.
+	 * For most states jmp_history_cnt is [0-3].
+	 * For loops can go up to ~40.
+	 */
+	struct bpf_idx_pair *jmp_history;
+	u32 jmp_history_cnt;
 };
 
 #define bpf_get_spilled_reg(slot, frame)				\
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ef2b69b7bc01..41b41d39c295 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -455,12 +455,12 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 		verbose(env, " R%d", i);
 		print_liveness(env, reg->live);
 		verbose(env, "=%s", reg_type_str[t]);
+		if (t == SCALAR_VALUE && reg->precise)
+			verbose(env, "P");
 		if ((t == SCALAR_VALUE || t == PTR_TO_STACK) &&
 		    tnum_is_const(reg->var_off)) {
 			/* reg->off should be 0 for SCALAR_VALUE */
 			verbose(env, "%lld", reg->var_off.value + reg->off);
-			if (t == PTR_TO_STACK)
-				verbose(env, ",call_%d", func(env, reg)->callsite);
 		} else {
 			verbose(env, "(id=%d", reg->id);
 			if (reg_type_may_be_refcounted_or_null(t))
@@ -522,11 +522,17 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 			continue;
 		verbose(env, " fp%d", (-i - 1) * BPF_REG_SIZE);
 		print_liveness(env, state->stack[i].spilled_ptr.live);
-		if (state->stack[i].slot_type[0] == STACK_SPILL)
-			verbose(env, "=%s",
-				reg_type_str[state->stack[i].spilled_ptr.type]);
-		else
+		if (state->stack[i].slot_type[0] == STACK_SPILL) {
+			reg = &state->stack[i].spilled_ptr;
+			t = reg->type;
+			verbose(env, "=%s", reg_type_str[t]);
+			if (t == SCALAR_VALUE && reg->precise)
+				verbose(env, "P");
+			if (t == SCALAR_VALUE && tnum_is_const(reg->var_off))
+				verbose(env, "%lld", reg->var_off.value + reg->off);
+		} else {
 			verbose(env, "=%s", types_buf);
+		}
 	}
 	if (state->acquired_refs && state->refs[0].id) {
 		verbose(env, " refs=%d", state->refs[0].id);
@@ -675,6 +681,13 @@ static void free_func_state(struct bpf_func_state *state)
 	kfree(state);
 }
 
+static void clear_jmp_history(struct bpf_verifier_state *state)
+{
+	kfree(state->jmp_history);
+	state->jmp_history = NULL;
+	state->jmp_history_cnt = 0;
+}
+
 static void free_verifier_state(struct bpf_verifier_state *state,
 				bool free_self)
 {
@@ -684,6 +697,7 @@ static void free_verifier_state(struct bpf_verifier_state *state,
 		free_func_state(state->frame[i]);
 		state->frame[i] = NULL;
 	}
+	clear_jmp_history(state);
 	if (free_self)
 		kfree(state);
 }
@@ -711,8 +725,17 @@ static int copy_verifier_state(struct bpf_verifier_state *dst_state,
 			       const struct bpf_verifier_state *src)
 {
 	struct bpf_func_state *dst;
+	u32 jmp_sz = sizeof(struct bpf_idx_pair) * src->jmp_history_cnt;
 	int i, err;
 
+	if (dst_state->jmp_history_cnt < src->jmp_history_cnt) {
+		kfree(dst_state->jmp_history);
+		if (!(dst_state->jmp_history = kmalloc(jmp_sz, GFP_USER)))
+			return -ENOMEM;
+	}
+	memcpy(dst_state->jmp_history, src->jmp_history, jmp_sz);
+	dst_state->jmp_history_cnt = src->jmp_history_cnt;
+
 	/* if dst has more stack frames then src frame, free them */
 	for (i = src->curframe + 1; i <= dst_state->curframe; i++) {
 		free_func_state(dst_state->frame[i]);
@@ -723,6 +746,8 @@ static int copy_verifier_state(struct bpf_verifier_state *dst_state,
 	dst_state->active_spin_lock = src->active_spin_lock;
 	dst_state->branches = src->branches;
 	dst_state->parent = src->parent;
+	dst_state->first_insn_idx = src->first_insn_idx;
+	dst_state->last_insn_idx = src->last_insn_idx;
 	for (i = 0; i <= src->curframe; i++) {
 		dst = dst_state->frame[i];
 		if (!dst) {
@@ -958,6 +983,17 @@ static void __reg_bound_offset(struct bpf_reg_state *reg)
 	reg->var_off = tnum_intersect(reg->var_off,
 				      tnum_range(reg->umin_value,
 						 reg->umax_value));
+	/* if register became known constant after a sequence of comparisons
+	 * or arithmetic operations mark it precise now, since backtracking
+	 * cannot follow such logic.
+	 * Example:
+	 * r0 = get_random();
+	 * if (r0 < 1) goto ..
+	 * if (r0 > 1) goto ..
+	 * r0 is const here
+	 */
+	if (tnum_is_const(reg->var_off))
+		reg->precise = true;
 }
 
 /* Reset the min/max bounds of a register */
@@ -967,6 +1003,9 @@ static void __mark_reg_unbounded(struct bpf_reg_state *reg)
 	reg->smax_value = S64_MAX;
 	reg->umin_value = 0;
 	reg->umax_value = U64_MAX;
+
+	/* constant backtracking is enabled for root only for now */
+	reg->precise = capable(CAP_SYS_ADMIN) ? false : true;
 }
 
 /* Mark a register as having a completely unknown (scalar) value. */
@@ -1445,6 +1484,9 @@ static int check_stack_write(struct bpf_verifier_env *env,
 
 	if (reg && size == BPF_REG_SIZE && register_is_const(reg) &&
 	    !tnum_equals_const(reg->var_off, 0)) {
+		if (env->prog->insnsi[insn_idx].dst_reg != BPF_REG_FP)
+			/* backtracking logic can only recognize explicit [fp-X] */
+			reg->precise = true;
 		goto save_reg_state;
 	} else if (reg && is_spillable_regtype(reg->type)) {
 		/* register containing pointer is being spilled into stack */
@@ -1607,6 +1649,10 @@ static int check_stack_read(struct bpf_verifier_env *env,
 				 * so the whole register == const_zero
 				 */
 				__mark_reg_const_zero(&state->regs[value_regno]);
+				/* backtracking doesn't support STACK_ZERO yet,
+				 * so conservatively mark it precise
+				 */
+				state->regs[value_regno].precise = true;
 			} else {
 				/* have read misc data from the stack */
 				mark_reg_unknown(env, state->regs, value_regno);
@@ -2732,6 +2778,369 @@ static int int_ptr_type_to_size(enum bpf_arg_type type)
 	return -EINVAL;
 }
 
+/* for any branch, call, exit record the history of jmps in the given state */
+static int push_jmp_history(struct bpf_verifier_env *env,
+			    struct bpf_verifier_state *cur)
+{
+	struct bpf_idx_pair *p;
+	u32 cnt = cur->jmp_history_cnt;
+
+	cnt++;
+	p = krealloc(cur->jmp_history, cnt * sizeof(*p), GFP_USER);
+	if (!p)
+		return -ENOMEM;
+	p[cnt - 1].idx = env->insn_idx;
+	p[cnt - 1].prev_idx = env->prev_insn_idx;
+	cur->jmp_history = p;
+	cur->jmp_history_cnt = cnt;
+	return 0;
+}
+
+/* Backtrack one insn at a time. If idx is not at the top of recorded
+ * history then previous instruction came from straight line execution.
+ */
+static int pop_and_get_prev_idx(struct bpf_verifier_state *st, int i)
+{
+	u32 cnt = st->jmp_history_cnt;
+
+	if (cnt && st->jmp_history[cnt - 1].idx == i) {
+		i = st->jmp_history[cnt - 1].prev_idx;
+		st->jmp_history_cnt--;
+	} else {
+		i--;
+	}
+	return i;
+}
+
+/* For given verifier state backtrack_insn() is called from the last insn to
+ * the first insn. Its purpose is to compute a bitmask of registers and
+ * stack slots that needs precision in the parent verifier state.
+ */
+static int backtrack_insn(struct bpf_verifier_env *env, int idx,
+			  u32 *reg_mask, u64 *stack_mask)
+{
+	const struct bpf_insn_cbs cbs = {
+		.cb_print	= verbose,
+		.private_data	= env,
+	};
+	struct bpf_insn *insn = env->prog->insnsi + idx;
+	u8 class = BPF_CLASS(insn->code);
+	u8 opcode = BPF_OP(insn->code);
+	u8 mode = BPF_MODE(insn->code);
+	u32 dreg = 1u << insn->dst_reg;
+	u32 sreg = 1u << insn->src_reg;
+	u32 spi;
+
+	if (insn->code == 0)
+		return 0;
+	if (env->log.level & BPF_LOG_LEVEL) {
+		verbose(env, "regs=%x stack=%llx before ", *reg_mask, *stack_mask);
+		verbose(env, "%d: ", idx);
+		print_bpf_insn(&cbs, insn, env->allow_ptr_leaks);
+	}
+
+	if (class == BPF_ALU || class == BPF_ALU64) {
+		if (!(*reg_mask & dreg))
+			return 0;
+		if (opcode == BPF_MOV) {
+			if (BPF_SRC(insn->code) == BPF_X) {
+				/* dreg = sreg
+				 * dreg needs precision after this insn
+				 * sreg needs precision before this insn
+				 */
+				*reg_mask &= ~dreg;
+				*reg_mask |= sreg;
+			} else {
+				/* dreg = K
+				 * dreg needs precision after this insn.
+				 * Corresponding register is already marked
+				 * as precise=true in this verifier state.
+				 * No further markings in parent are necessary
+				 */
+				*reg_mask &= ~dreg;
+			}
+		} else {
+			if (BPF_SRC(insn->code) == BPF_X) {
+				/* dreg += sreg
+				 * both dreg and sreg need precision
+				 * before this insn
+				 */
+				*reg_mask |= sreg;
+			} /* else dreg += K
+			   * dreg still needs precision before this insn
+			   */
+		}
+	} else if (class == BPF_LDX) {
+		if (!(*reg_mask & dreg))
+			return 0;
+		*reg_mask &= ~dreg;
+
+		/* scalars can only be spilled into stack w/o losing precision.
+		 * Load from any other memory can be zero extended.
+		 * The desire to keep that precision is already indicated
+		 * by 'precise' mark in corresponding register of this state.
+		 * No further tracking necessary.
+		 */
+		if (insn->src_reg != BPF_REG_FP)
+			return 0;
+		if (BPF_SIZE(insn->code) != BPF_DW)
+			return 0;
+
+		/* dreg = *(u64 *)[fp - off] was a fill from the stack.
+		 * that [fp - off] slot contains scalar that needs to be
+		 * tracked with precision
+		 */
+		spi = (-insn->off - 1) / BPF_REG_SIZE;
+		if (spi >= 64) {
+			verbose(env, "BUG spi %d\n", spi);
+			WARN_ONCE(1, "verifier backtracking bug");
+			return -EFAULT;
+		}
+		*stack_mask |= 1ull << spi;
+	} else if (class == BPF_STX) {
+		if (*reg_mask & dreg)
+			/* stx shouldn't be using _scalar_ dst_reg
+			 * to access memory. It means backtracking
+			 * encountered a case of pointer subtraction.
+			 */
+			return -ENOTSUPP;
+		/* scalars can only be spilled into stack */
+		if (insn->dst_reg != BPF_REG_FP)
+			return 0;
+		if (BPF_SIZE(insn->code) != BPF_DW)
+			return 0;
+		spi = (-insn->off - 1) / BPF_REG_SIZE;
+		if (spi >= 64) {
+			verbose(env, "BUG spi %d\n", spi);
+			WARN_ONCE(1, "verifier backtracking bug");
+			return -EFAULT;
+		}
+		if (!(*stack_mask & (1ull << spi)))
+			return 0;
+		*stack_mask &= ~(1ull << spi);
+		*reg_mask |= sreg;
+	} else if (class == BPF_JMP || class == BPF_JMP32) {
+		if (opcode == BPF_CALL) {
+			if (insn->src_reg == BPF_PSEUDO_CALL)
+				return -ENOTSUPP;
+			else
+				/* regular helper call sets R0 */
+				*reg_mask &= ~1;
+		} else if (opcode == BPF_EXIT) {
+			return -ENOTSUPP;
+		}
+	} else if (class == BPF_LD) {
+		if (!(*reg_mask & dreg))
+			return 0;
+		*reg_mask &= ~dreg;
+		/* It's ld_imm64 or ld_abs or ld_ind.
+		 * For ld_imm64 no further tracking of precision
+		 * into parent is necessary
+		 */
+		if (mode == BPF_IND || mode == BPF_ABS)
+			/* to be analyzed */
+			return -ENOTSUPP;
+	} else if (class == BPF_ST) {
+		if (*reg_mask & dreg) {
+			/* likely pointer subtraction */
+			return -ENOTSUPP;
+		}
+	}
+	return 0;
+}
+
+/* the scalar precision tracking algorithm:
+ * . at the start all registers have precise=false.
+ * . scalar ranges are tracked as normal through alu and jmp insns.
+ * . once precise value of the scalar register is used in:
+ *   .  ptr + scalar alu
+ *   . if (scalar cond K|scalar)
+ *   .  helper_call(.., scalar, ...) where ARG_CONST is expected
+ *   backtrack through the verifier states and mark all registers and
+ *   stack slots with spilled constants that these scalar regisers
+ *   should be precise.
+ * . during state pruning two registers (or spilled stack slots)
+ *   are equivalent if both are not precise.
+ *
+ * Note the verifier cannot simply walk register parentage chain,
+ * since many different registers and stack slots could have been
+ * used to compute single precise scalar.
+ *
+ * It's not safe to start with precise=true and backtrack
+ * when passing scalar register into a helper that takes ARG_ANYTHING.
+ *
+ * It's ok to walk single parentage chain of the verifier states.
+ * It's possible that this backtracking will go all the way till 1st insn.
+ * All other branches will be explored for needing precision later.
+ *
+ * The backtracking needs to deal with cases like:
+ *   R8=map_value(id=0,off=0,ks=4,vs=1952,imm=0) R9_w=map_value(id=0,off=40,ks=4,vs=1952,imm=0)
+ * r9 -= r8
+ * r5 = r9
+ * if r5 > 0x79f goto pc+7
+ *    R5_w=inv(id=0,umax_value=1951,var_off=(0x0; 0x7ff))
+ * r5 += 1
+ * ...
+ * call bpf_perf_event_output#25
+ *   where .arg5_type = ARG_CONST_SIZE_OR_ZERO
+ *
+ * and this case:
+ * r6 = 1
+ * call foo // uses callee's r6 inside to compute r0
+ * r0 += r6
+ * if r0 == 0 goto
+ *
+ * to track above reg_mask/stack_mask needs to be independent for each frame.
+ *
+ * Alslo if parent's curframe > frame where backtracking started,
+ * the verifier need to mark registers in both frames, otherwise callees
+ * may incorrectly prune callers. This is similar to
+ * commit 7640ead93924 ("bpf: verifier: make sure callees don't prune with caller differences")
+ *
+ * For now backtracking falls back into conservative marking.
+ */
+static void mark_all_scalars_precise(struct bpf_verifier_env *env,
+				     struct bpf_verifier_state *st)
+{
+	struct bpf_func_state *func;
+	struct bpf_reg_state *reg;
+	int i, j;
+
+	/* big hammer: mark all scalars precise in this path.
+	 * pop_stack may still get !precise scalars.
+	 */
+	for (; st; st = st->parent)
+		for (i = 0; i <= st->curframe; i++) {
+			func = st->frame[i];
+			for (j = 0; j < BPF_REG_FP; j++) {
+				reg = &func->regs[j];
+				if (reg->type != SCALAR_VALUE)
+					continue;
+				reg->precise = true;
+			}
+			for (j = 0; j < func->allocated_stack / BPF_REG_SIZE; j++) {
+				if (func->stack[j].slot_type[0] != STACK_SPILL)
+					continue;
+				reg = &func->stack[j].spilled_ptr;
+				if (reg->type != SCALAR_VALUE)
+					continue;
+				reg->precise = true;
+			}
+		}
+}
+
+static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
+{
+	struct bpf_verifier_state *st = env->cur_state, *parent = st->parent;
+	int last_idx = env->insn_idx;
+	int first_idx = st->first_insn_idx;
+	struct bpf_func_state *func;
+	struct bpf_reg_state *reg;
+	u32 reg_mask = 1u << regno;
+	u64 stack_mask = 0;
+	int i, err;
+
+	func = st->frame[st->curframe];
+	reg = &func->regs[regno];
+	if (reg->type != SCALAR_VALUE) {
+		WARN_ONCE(1, "backtracing misuse");
+		return -EFAULT;
+	}
+	if (reg->precise)
+		return 0;
+	func->regs[regno].precise = true;
+
+	for (;;) {
+		DECLARE_BITMAP(mask, 64);
+		bool new_marks = false;
+
+		if (env->log.level & BPF_LOG_LEVEL)
+			verbose(env, "last_idx %d first_idx %d\n", last_idx, first_idx);
+		for (i = last_idx;;) {
+			err = backtrack_insn(env, i, &reg_mask, &stack_mask);
+			if (err == -ENOTSUPP) {
+				mark_all_scalars_precise(env, st);
+				return 0;
+			} else if (err) {
+				return err;
+			}
+			if (!reg_mask && !stack_mask)
+				/* Found assignment(s) into tracked register in this state.
+				 * Since this state is already marked, just return.
+				 * Nothing to be tracked further in the parent state.
+				 */
+				return 0;
+			if (i == first_idx)
+				break;
+			i = pop_and_get_prev_idx(st, i);
+			if (i >= env->prog->len) {
+				/* This can happen if backtracking reached insn 0
+				 * and there are still reg_mask or stack_mask
+				 * to backtrack.
+				 * It means the backtracking missed the spot where
+				 * particular register was initialized with a constant.
+				 */
+				verbose(env, "BUG backtracking idx %d\n", i);
+				WARN_ONCE(1, "verifier backtracking bug");
+				return -EFAULT;
+			}
+		}
+		st = parent;
+		if (!st)
+			break;
+
+		func = st->frame[st->curframe];
+		bitmap_from_u64(mask, reg_mask);
+		for_each_set_bit(i, mask, 32) {
+			reg = &func->regs[i];
+			if (reg->type != SCALAR_VALUE)
+				continue;
+			if (!reg->precise)
+				new_marks = true;
+			reg->precise = true;
+		}
+
+		bitmap_from_u64(mask, stack_mask);
+		for_each_set_bit(i, mask, 64) {
+			if (i >= func->allocated_stack / BPF_REG_SIZE) {
+				/* This can happen if backtracking
+				 * is propagating stack precision where
+				 * caller has larger stack frame
+				 * than callee, but backtrack_insn() should
+				 * have returned -ENOTSUPP.
+				 */
+				verbose(env, "BUG spi %d stack_size %d\n",
+					i, func->allocated_stack);
+				WARN_ONCE(1, "verifier backtracking bug");
+				return -EFAULT;
+			}
+
+			if (func->stack[i].slot_type[0] != STACK_SPILL)
+				continue;
+			reg = &func->stack[i].spilled_ptr;
+			if (reg->type != SCALAR_VALUE)
+				continue;
+			if (!reg->precise)
+				new_marks = true;
+			reg->precise = true;
+		}
+		if (env->log.level & BPF_LOG_LEVEL) {
+			print_verifier_state(env, func);
+			verbose(env, "parent %s regs=%x stack=%llx marks\n",
+				new_marks ? "didn't have" : "already had",
+				reg_mask, stack_mask);
+		}
+
+		if (!new_marks)
+			break;
+
+		parent = st->parent;
+		last_idx = st->last_insn_idx;
+		first_idx = st->first_insn_idx;
+	}
+	return 0;
+}
+
 static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 			  enum bpf_arg_type arg_type,
 			  struct bpf_call_arg_meta *meta)
@@ -2922,6 +3331,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 		err = check_helper_mem_access(env, regno - 1,
 					      reg->umax_value,
 					      zero_size_allowed, meta);
+		if (!err)
+			err = mark_chain_precision(env, regno);
 	} else if (arg_type_is_int_ptr(arg_type)) {
 		int size = int_ptr_type_to_size(arg_type);
 
@@ -4117,6 +4528,9 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		return 0;
 	}
 
+	if (src_reg.precise)
+		dst_reg->precise = true;
+
 	switch (opcode) {
 	case BPF_ADD:
 		ret = sanitize_val_alu(env, insn);
@@ -4358,6 +4772,7 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 	struct bpf_reg_state *regs = state->regs, *dst_reg, *src_reg;
 	struct bpf_reg_state *ptr_reg = NULL, off_reg = {0};
 	u8 opcode = BPF_OP(insn->code);
+	int err;
 
 	dst_reg = &regs[insn->dst_reg];
 	src_reg = NULL;
@@ -4384,11 +4799,17 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 				 * This is legal, but we have to reverse our
 				 * src/dest handling in computing the range
 				 */
+				err = mark_chain_precision(env, insn->dst_reg);
+				if (err)
+					return err;
 				return adjust_ptr_min_max_vals(env, insn,
 							       src_reg, dst_reg);
 			}
 		} else if (ptr_reg) {
 			/* pointer += scalar */
+			err = mark_chain_precision(env, insn->src_reg);
+			if (err)
+				return err;
 			return adjust_ptr_min_max_vals(env, insn,
 						       dst_reg, src_reg);
 		}
@@ -5345,6 +5766,13 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 check_taken:
 		pred = is_branch_taken(dst_reg, cond_val, opcode, is_jmp32);
 
+		if (pred >= 0) {
+			err = mark_chain_precision(env, insn->dst_reg);
+			if (BPF_SRC(insn->code) == BPF_X && !err)
+				err = mark_chain_precision(env, insn->src_reg);
+			if (err)
+				return err;
+		}
 		if (pred == 1) {
 			 /* only follow the goto, ignore fall-through */
 			*insn_idx += insn->off;
@@ -5828,6 +6256,11 @@ static int check_cfg(struct bpf_verifier_env *env)
 				goto peek_stack;
 			else if (ret < 0)
 				goto err_free;
+			/* unconditional jmp is not a good pruning point,
+			 * but it's marked, since backtracking needs
+			 * to record jmp history in is_state_visited().
+			 */
+			init_explored_state(env, t + insns[t].off + 1);
 			/* tell verifier to check for equivalent states
 			 * after every call and jump
 			 */
@@ -6328,6 +6761,8 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 	switch (rold->type) {
 	case SCALAR_VALUE:
 		if (rcur->type == SCALAR_VALUE) {
+			if (!rold->precise && !rcur->precise)
+				return true;
 			/* new val must satisfy old val knowledge */
 			return range_within(rold, rcur) &&
 			       tnum_in(rold->var_off, rcur->var_off);
@@ -6678,6 +7113,7 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	int i, j, err, states_cnt = 0;
 	bool add_new_state = false;
 
+	cur->last_insn_idx = env->prev_insn_idx;
 	if (!env->insn_aux_data[insn_idx].prune_point)
 		/* this 'insn_idx' instruction wasn't marked, so we will not
 		 * be doing state search here
@@ -6794,10 +7230,10 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 		env->max_states_per_insn = states_cnt;
 
 	if (!env->allow_ptr_leaks && states_cnt > BPF_COMPLEXITY_LIMIT_STATES)
-		return 0;
+		return push_jmp_history(env, cur);
 
 	if (!add_new_state)
-		return 0;
+		return push_jmp_history(env, cur);
 
 	/* there were no equivalent states, remember current one.
 	 * technically the current state is not proven to be safe yet,
@@ -6825,7 +7261,10 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	new->insn_idx = insn_idx;
 	WARN_ONCE(new->branches != 1,
 		  "BUG is_state_visited:branches_to_explore=%d insn %d\n", new->branches, insn_idx);
+
 	cur->parent = new;
+	cur->first_insn_idx = insn_idx;
+	clear_jmp_history(cur);
 	new_sl->next = *explored_state(env, insn_idx);
 	*explored_state(env, insn_idx) = new_sl;
 	/* connect new state to parentage chain. Current frame needs all
@@ -6905,6 +7344,7 @@ static int do_check(struct bpf_verifier_env *env)
 	struct bpf_reg_state *regs;
 	int insn_cnt = env->prog->len;
 	bool do_print_state = false;
+	int prev_insn_idx = -1;
 
 	env->prev_linfo = NULL;
 
@@ -6930,6 +7370,7 @@ static int do_check(struct bpf_verifier_env *env)
 		u8 class;
 		int err;
 
+		env->prev_insn_idx = prev_insn_idx;
 		if (env->insn_idx >= insn_cnt) {
 			verbose(env, "invalid insn idx %d insn_cnt %d\n",
 				env->insn_idx, insn_cnt);
@@ -7002,6 +7443,7 @@ static int do_check(struct bpf_verifier_env *env)
 
 		regs = cur_regs(env);
 		env->insn_aux_data[env->insn_idx].seen = true;
+		prev_insn_idx = env->insn_idx;
 
 		if (class == BPF_ALU || class == BPF_ALU64) {
 			err = check_alu_op(env, insn);
@@ -7175,7 +7617,6 @@ static int do_check(struct bpf_verifier_env *env)
 
 				if (state->curframe) {
 					/* exit from nested function */
-					env->prev_insn_idx = env->insn_idx;
 					err = prepare_func_exit(env, &env->insn_idx);
 					if (err)
 						return err;
@@ -7207,7 +7648,7 @@ static int do_check(struct bpf_verifier_env *env)
 					return err;
 process_bpf_exit:
 				update_branch_counts(env, env->cur_state);
-				err = pop_stack(env, &env->prev_insn_idx,
+				err = pop_stack(env, &prev_insn_idx,
 						&env->insn_idx);
 				if (err < 0) {
 					if (err != -ENOENT)
-- 
2.20.0

