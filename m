Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A02D129030
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 23:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfLVWhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 17:37:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:41570 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfLVWhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 17:37:45 -0500
Received: from [185.105.41.14] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ij9r4-0007aB-3a; Sun, 22 Dec 2019 23:37:42 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anatoly.trosinenko@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf] bpf: Fix precision tracking for unbounded scalars
Date:   Sun, 22 Dec 2019 23:37:40 +0100
Message-Id: <20191222223740.25297-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25671/Sun Dec 22 10:58:12 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Anatoly has been fuzzing with kBdysch harness and reported a hang in one
of the outcomes. Upon closer analysis, it turns out that precise scalar
value tracking is missing a few precision markings for unknown scalars:

  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (b7) r0 = 0
  1: R0_w=invP0 R1=ctx(id=0,off=0,imm=0) R10=fp0
  1: (35) if r0 >= 0xf72e goto pc+0
  --> only follow fallthrough
  2: R0_w=invP0 R1=ctx(id=0,off=0,imm=0) R10=fp0
  2: (35) if r0 >= 0x80fe0000 goto pc+0
  --> only follow fallthrough
  3: R0_w=invP0 R1=ctx(id=0,off=0,imm=0) R10=fp0
  3: (14) w0 -= -536870912
  4: R0_w=invP536870912 R1=ctx(id=0,off=0,imm=0) R10=fp0
  4: (0f) r1 += r0
  5: R0_w=invP536870912 R1_w=inv(id=0) R10=fp0
  5: (55) if r1 != 0x104c1500 goto pc+0
  --> push other branch for later analysis
  R0_w=invP536870912 R1_w=inv273421568 R10=fp0
  6: R0_w=invP536870912 R1_w=inv273421568 R10=fp0
  6: (b7) r0 = 0
  7: R0=invP0 R1=inv273421568 R10=fp0
  7: (76) if w1 s>= 0xffffff00 goto pc+3
  --> only follow goto
  11: R0=invP0 R1=inv273421568 R10=fp0
  11: (95) exit
  6: R0_w=invP536870912 R1_w=inv(id=0) R10=fp0
  6: (b7) r0 = 0
  propagating r0
  7: safe
  processed 11 insns [...]

In the analysis of the second path coming after the successful exit above,
the path is being pruned at line 7. Pruning analysis found that both r0 are
precise P0 and both R1 are non-precise scalars and given prior path with
R1 as non-precise scalar succeeded, this one is therefore safe as well.

However, problem is that given condition at insn 7 in the first run, we only
followed goto and didn't push the other branch for later analysis, we've
never walked the few insns in there and therefore dead-code sanitation
rewrites it as goto pc-1, causing the hang depending on the skb address
hitting these conditions. The issue is that R1 should have been marked as
precise as well such that pruning enforces range check and conluded that new
R1 is not in range of old R1. In insn 4, we mark R1 (skb) as unknown scalar
via __mark_reg_unbounded() but not mark_reg_unbounded() and therefore
regs->precise remains as false.

Back in b5dc0163d8fd ("bpf: precise scalar_value tracking"), this was not
the case since marking out of __mark_reg_unbounded() had this covered as well.
Once in both are set as precise in 4 as they should have been, we conclude
that given R1 was in prior fall-through path 0x104c1500 and now is completely
unknown, the check at insn 7 concludes that we need to continue walking.
Analysis after the fix:

  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (b7) r0 = 0
  1: R0_w=invP0 R1=ctx(id=0,off=0,imm=0) R10=fp0
  1: (35) if r0 >= 0xf72e goto pc+0
  2: R0_w=invP0 R1=ctx(id=0,off=0,imm=0) R10=fp0
  2: (35) if r0 >= 0x80fe0000 goto pc+0
  3: R0_w=invP0 R1=ctx(id=0,off=0,imm=0) R10=fp0
  3: (14) w0 -= -536870912
  4: R0_w=invP536870912 R1=ctx(id=0,off=0,imm=0) R10=fp0
  4: (0f) r1 += r0
  5: R0_w=invP536870912 R1_w=invP(id=0) R10=fp0
  5: (55) if r1 != 0x104c1500 goto pc+0
  R0_w=invP536870912 R1_w=invP273421568 R10=fp0
  6: R0_w=invP536870912 R1_w=invP273421568 R10=fp0
  6: (b7) r0 = 0
  7: R0=invP0 R1=invP273421568 R10=fp0
  7: (76) if w1 s>= 0xffffff00 goto pc+3
  11: R0=invP0 R1=invP273421568 R10=fp0
  11: (95) exit
  6: R0_w=invP536870912 R1_w=invP(id=0) R10=fp0
  6: (b7) r0 = 0
  7: R0_w=invP0 R1_w=invP(id=0) R10=fp0
  7: (76) if w1 s>= 0xffffff00 goto pc+3
  R0_w=invP0 R1_w=invP(id=0) R10=fp0
  8: R0_w=invP0 R1_w=invP(id=0) R10=fp0
  8: (a5) if r0 < 0x2007002a goto pc+0
  9: R0_w=invP0 R1_w=invP(id=0) R10=fp0
  9: (57) r0 &= -16316416
  10: R0_w=invP0 R1_w=invP(id=0) R10=fp0
  10: (a6) if w0 < 0x1201 goto pc+0
  11: R0_w=invP0 R1_w=invP(id=0) R10=fp0
  11: (95) exit
  11: R0=invP0 R1=invP(id=0) R10=fp0
  11: (95) exit
  processed 16 insns [...]

Fixes: 6754172c208d ("bpf: fix precision tracking in presence of bpf2bpf calls")
Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 kernel/bpf/verifier.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4983940cbdca..6f63ae7a370c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -907,7 +907,8 @@ static const int caller_saved[CALLER_SAVED_REGS] = {
 	BPF_REG_0, BPF_REG_1, BPF_REG_2, BPF_REG_3, BPF_REG_4, BPF_REG_5
 };
 
-static void __mark_reg_not_init(struct bpf_reg_state *reg);
+static void __mark_reg_not_init(const struct bpf_verifier_env *env,
+				struct bpf_reg_state *reg);
 
 /* Mark the unknown part of a register (variable offset or scalar value) as
  * known to have the value @imm.
@@ -945,7 +946,7 @@ static void mark_reg_known_zero(struct bpf_verifier_env *env,
 		verbose(env, "mark_reg_known_zero(regs, %u)\n", regno);
 		/* Something bad happened, let's kill all regs */
 		for (regno = 0; regno < MAX_BPF_REG; regno++)
-			__mark_reg_not_init(regs + regno);
+			__mark_reg_not_init(env, regs + regno);
 		return;
 	}
 	__mark_reg_known_zero(regs + regno);
@@ -1054,7 +1055,8 @@ static void __mark_reg_unbounded(struct bpf_reg_state *reg)
 }
 
 /* Mark a register as having a completely unknown (scalar) value. */
-static void __mark_reg_unknown(struct bpf_reg_state *reg)
+static void __mark_reg_unknown(const struct bpf_verifier_env *env,
+			       struct bpf_reg_state *reg)
 {
 	/*
 	 * Clear type, id, off, and union(map_ptr, range) and
@@ -1064,6 +1066,8 @@ static void __mark_reg_unknown(struct bpf_reg_state *reg)
 	reg->type = SCALAR_VALUE;
 	reg->var_off = tnum_unknown;
 	reg->frameno = 0;
+	reg->precise = env->subprog_cnt > 1 || !env->allow_ptr_leaks ?
+		       true : false;
 	__mark_reg_unbounded(reg);
 }
 
@@ -1074,19 +1078,16 @@ static void mark_reg_unknown(struct bpf_verifier_env *env,
 		verbose(env, "mark_reg_unknown(regs, %u)\n", regno);
 		/* Something bad happened, let's kill all regs except FP */
 		for (regno = 0; regno < BPF_REG_FP; regno++)
-			__mark_reg_not_init(regs + regno);
+			__mark_reg_not_init(env, regs + regno);
 		return;
 	}
-	regs += regno;
-	__mark_reg_unknown(regs);
-	/* constant backtracking is enabled for root without bpf2bpf calls */
-	regs->precise = env->subprog_cnt > 1 || !env->allow_ptr_leaks ?
-			true : false;
+	__mark_reg_unknown(env, regs + regno);
 }
 
-static void __mark_reg_not_init(struct bpf_reg_state *reg)
+static void __mark_reg_not_init(const struct bpf_verifier_env *env,
+				struct bpf_reg_state *reg)
 {
-	__mark_reg_unknown(reg);
+	__mark_reg_unknown(env, reg);
 	reg->type = NOT_INIT;
 }
 
@@ -1097,10 +1098,10 @@ static void mark_reg_not_init(struct bpf_verifier_env *env,
 		verbose(env, "mark_reg_not_init(regs, %u)\n", regno);
 		/* Something bad happened, let's kill all regs except FP */
 		for (regno = 0; regno < BPF_REG_FP; regno++)
-			__mark_reg_not_init(regs + regno);
+			__mark_reg_not_init(env, regs + regno);
 		return;
 	}
-	__mark_reg_not_init(regs + regno);
+	__mark_reg_not_init(env, regs + regno);
 }
 
 #define DEF_NOT_SUBREG	(0)
@@ -3234,7 +3235,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		}
 		if (state->stack[spi].slot_type[0] == STACK_SPILL &&
 		    state->stack[spi].spilled_ptr.type == SCALAR_VALUE) {
-			__mark_reg_unknown(&state->stack[spi].spilled_ptr);
+			__mark_reg_unknown(env, &state->stack[spi].spilled_ptr);
 			for (j = 0; j < BPF_REG_SIZE; j++)
 				state->stack[spi].slot_type[j] = STACK_MISC;
 			goto mark;
@@ -3892,7 +3893,7 @@ static void __clear_all_pkt_pointers(struct bpf_verifier_env *env,
 		if (!reg)
 			continue;
 		if (reg_is_pkt_pointer_any(reg))
-			__mark_reg_unknown(reg);
+			__mark_reg_unknown(env, reg);
 	}
 }
 
@@ -3920,7 +3921,7 @@ static void release_reg_references(struct bpf_verifier_env *env,
 		if (!reg)
 			continue;
 		if (reg->ref_obj_id == ref_obj_id)
-			__mark_reg_unknown(reg);
+			__mark_reg_unknown(env, reg);
 	}
 }
 
@@ -4582,7 +4583,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		/* Taint dst register if offset had invalid bounds derived from
 		 * e.g. dead branches.
 		 */
-		__mark_reg_unknown(dst_reg);
+		__mark_reg_unknown(env, dst_reg);
 		return 0;
 	}
 
@@ -4834,13 +4835,13 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		/* Taint dst register if offset had invalid bounds derived from
 		 * e.g. dead branches.
 		 */
-		__mark_reg_unknown(dst_reg);
+		__mark_reg_unknown(env, dst_reg);
 		return 0;
 	}
 
 	if (!src_known &&
 	    opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
-		__mark_reg_unknown(dst_reg);
+		__mark_reg_unknown(env, dst_reg);
 		return 0;
 	}
 
@@ -6982,7 +6983,7 @@ static void clean_func_state(struct bpf_verifier_env *env,
 			/* since the register is unused, clear its state
 			 * to make further comparison simpler
 			 */
-			__mark_reg_not_init(&st->regs[i]);
+			__mark_reg_not_init(env, &st->regs[i]);
 	}
 
 	for (i = 0; i < st->allocated_stack / BPF_REG_SIZE; i++) {
@@ -6990,7 +6991,7 @@ static void clean_func_state(struct bpf_verifier_env *env,
 		/* liveness must not touch this stack slot anymore */
 		st->stack[i].spilled_ptr.live |= REG_LIVE_DONE;
 		if (!(live & REG_LIVE_READ)) {
-			__mark_reg_not_init(&st->stack[i].spilled_ptr);
+			__mark_reg_not_init(env, &st->stack[i].spilled_ptr);
 			for (j = 0; j < BPF_REG_SIZE; j++)
 				st->stack[i].slot_type[j] = STACK_INVALID;
 		}
-- 
2.20.1

