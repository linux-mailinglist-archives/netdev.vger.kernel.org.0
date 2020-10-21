Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347B829521B
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504013AbgJUSUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503991AbgJUSUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 14:20:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710B9C0613CE;
        Wed, 21 Oct 2020 11:20:20 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a17so1591964pju.1;
        Wed, 21 Oct 2020 11:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DuW+ZJ7V0jmdNv0h6ocl0HA+XhmKiKl5KtvsemfeKbg=;
        b=nm+z7io4EjpKYTd+xgnD0eqOZMy8B76SkkHGfxEuYD7x5tLbqP6QSqIVxN3a/C0Azt
         FgmD9AgqPuSUg9z93/etdYkZ3ppFFJTtvns4RQH+p5zowoTy5BAL7iOqLUg/F3VBxIRy
         OAm/lHfK0OjaJBn54RJqfWWlsR95z1pJEWC/00pUHYQ2T3Tdt6ZN3Sq07jz10pJ5u3JY
         Jp4Qh5Fe+8DycWAeRy4MufdCdyOy/4994jNRHpbkgJHu4nWvpr4+Z1bzfwk7rDcdqyij
         hgBoSjiu3x4f7c19MIoKr5qNHAapNZqBtJBimHLlmc/jP3xwZacGRgWh55SrtUyfkz0b
         yZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DuW+ZJ7V0jmdNv0h6ocl0HA+XhmKiKl5KtvsemfeKbg=;
        b=I1Mts597/plsEzmflhETo32NIz0AShyHjWg78RM+A5BCQ61wX9CJ3x+yDak8eRx5Eo
         xmBLvVsYDpuD42iltjFsChEVlZYw50rjjfzoEMSk/oJPSV30r7qBdm0B9CD82K5o2IJi
         wKiSETMkqnqDSslr0tU8PjrzXzUcV4HuRf3mbZzSgloUd43+JTOt4knf8JefFETZOwNP
         4/ZsDTQfImG9czCRVCX0Ju9vfLbcc76ajR9R242rps4obfVNcB87T06ZRdbdLJcJm74q
         KTTZQCT+gHj96W381YW+Miu8BuwLb3ggIlc3QWpY+3gdI9HRs4jibxwXB3N+onErr1g1
         yAHQ==
X-Gm-Message-State: AOAM530xBu1cMUfzVwGETQUYcMdf8kuNqMghh2M/zimSKfIJyVPK/fIn
        zt0wTyMfiPov7zK/9L5RZzs=
X-Google-Smtp-Source: ABdhPJxHS/urP7j9OahNP9rNEDVW/D4MBYb2peAAcQAqA2pT9/Qj0TJK4T+NEkMY+X+N6ygsRztdvA==
X-Received: by 2002:a17:90a:3f82:: with SMTP id m2mr4416256pjc.222.1603304419999;
        Wed, 21 Oct 2020 11:20:19 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id v3sm2618672pfu.165.2020.10.21.11.20.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2020 11:20:19 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 1/3] bpf: Support for pointers beyond pkt_end.
Date:   Wed, 21 Oct 2020 11:20:13 -0700
Message-Id: <20201021182015.39000-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20201021182015.39000-1-alexei.starovoitov@gmail.com>
References: <20201021182015.39000-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

This patch adds the verifier support to recognize inlined branch conditions.
The LLVM knows that the branch evaluates to the same value, but the verifier
couldn't track it. Hence causing valid programs to be rejected.
The potential LLVM workaround: https://reviews.llvm.org/D87428
can have undesired side effects, since LLVM doesn't know that
skb->data/data_end are being compared. LLVM has to introduce extra boolean
variable and use inline_asm trick to force easier for the verifier assembly.

Instead teach the verifier to recognize that
r1 = skb->data;
r1 += 10;
r2 = skb->data_end;
if (r1 > r2) {
  here r1 points beyond packet_end and
  subsequent
  if (r1 > r2) // always evaluates to "true".
}

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf_verifier.h |   2 +-
 kernel/bpf/verifier.c        | 131 +++++++++++++++++++++++++++++------
 2 files changed, 110 insertions(+), 23 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index e83ef6f6bf43..306869d4743b 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -45,7 +45,7 @@ struct bpf_reg_state {
 	enum bpf_reg_type type;
 	union {
 		/* valid when type == PTR_TO_PACKET */
-		u16 range;
+		int range;
 
 		/* valid when type == CONST_PTR_TO_MAP | PTR_TO_MAP_VALUE |
 		 *   PTR_TO_MAP_VALUE_OR_NULL
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 39d7f44e7c92..303c5fc1701b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2739,7 +2739,9 @@ static int check_packet_access(struct bpf_verifier_env *env, u32 regno, int off,
 			regno);
 		return -EACCES;
 	}
-	err = __check_mem_access(env, regno, off, size, reg->range,
+
+	err = reg->range < 0 ? -EINVAL :
+	      __check_mem_access(env, regno, off, size, reg->range,
 				 zero_size_allowed);
 	if (err) {
 		verbose(env, "R%d offset is outside of the packet\n", regno);
@@ -4687,6 +4689,32 @@ static void clear_all_pkt_pointers(struct bpf_verifier_env *env)
 		__clear_all_pkt_pointers(env, vstate->frame[i]);
 }
 
+enum {
+	AT_PKT_END = -1,
+	BEYOND_PKT_END = -2,
+};
+
+static void mark_pkt_end(struct bpf_verifier_state *vstate, int regn, bool range_open)
+{
+	struct bpf_func_state *state = vstate->frame[vstate->curframe];
+	struct bpf_reg_state *reg = &state->regs[regn];
+
+	if (reg->type != PTR_TO_PACKET)
+		/* PTR_TO_PACKET_META is not supported yet */
+		return;
+
+	/* The 'reg' is pkt > pkt_end or pkt >= pkt_end.
+	 * How far beyond pkt_end it goes is unknown.
+	 * if (!range_open) it's the case of pkt >= pkt_end
+	 * if (range_open) it's the case of pkt > pkt_end
+	 * hence this pointer is at least 1 byte bigger than pkt_end
+	 */
+	if (range_open)
+		reg->range = BEYOND_PKT_END;
+	else
+		reg->range = AT_PKT_END;
+}
+
 static void release_reg_references(struct bpf_verifier_env *env,
 				   struct bpf_func_state *state,
 				   int ref_obj_id)
@@ -6697,7 +6725,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 
 static void __find_good_pkt_pointers(struct bpf_func_state *state,
 				     struct bpf_reg_state *dst_reg,
-				     enum bpf_reg_type type, u16 new_range)
+				     enum bpf_reg_type type, int new_range)
 {
 	struct bpf_reg_state *reg;
 	int i;
@@ -6722,8 +6750,7 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 				   enum bpf_reg_type type,
 				   bool range_right_open)
 {
-	u16 new_range;
-	int i;
+	int new_range, i;
 
 	if (dst_reg->off < 0 ||
 	    (dst_reg->off == 0 && range_right_open))
@@ -6974,6 +7001,69 @@ static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
 	return is_branch64_taken(reg, val, opcode);
 }
 
+static int flip_opcode(u32 opcode)
+{
+	/* How can we transform "a <op> b" into "b <op> a"? */
+	static const u8 opcode_flip[16] = {
+		/* these stay the same */
+		[BPF_JEQ  >> 4] = BPF_JEQ,
+		[BPF_JNE  >> 4] = BPF_JNE,
+		[BPF_JSET >> 4] = BPF_JSET,
+		/* these swap "lesser" and "greater" (L and G in the opcodes) */
+		[BPF_JGE  >> 4] = BPF_JLE,
+		[BPF_JGT  >> 4] = BPF_JLT,
+		[BPF_JLE  >> 4] = BPF_JGE,
+		[BPF_JLT  >> 4] = BPF_JGT,
+		[BPF_JSGE >> 4] = BPF_JSLE,
+		[BPF_JSGT >> 4] = BPF_JSLT,
+		[BPF_JSLE >> 4] = BPF_JSGE,
+		[BPF_JSLT >> 4] = BPF_JSGT
+	};
+	return opcode_flip[opcode >> 4];
+}
+
+static int is_pkt_ptr_branch_taken(struct bpf_reg_state *dst_reg,
+				   struct bpf_reg_state *src_reg,
+				   u8 opcode)
+{
+	struct bpf_reg_state *pkt_end, *pkt;
+
+	if (src_reg->type == PTR_TO_PACKET_END) {
+		pkt_end = src_reg;
+		pkt = dst_reg;
+	} else if (dst_reg->type == PTR_TO_PACKET_END) {
+		pkt_end = dst_reg;
+		pkt = src_reg;
+		opcode = flip_opcode(opcode);
+	} else {
+		return -1;
+	}
+
+	if (pkt->range >= 0)
+		return -1;
+
+	switch (opcode) {
+	case BPF_JLE:
+		/* pkt <= pkt_end */
+		fallthrough;
+	case BPF_JGT:
+		/* pkt > pkt_end */
+		if (pkt->range == BEYOND_PKT_END)
+			/* pkt has at last one extra byte beyond pkt_end */
+			return opcode == BPF_JGT;
+		break;
+	case BPF_JLT:
+		/* pkt < pkt_end */
+		fallthrough;
+	case BPF_JGE:
+		/* pkt >= pkt_end */
+		if (pkt->range == BEYOND_PKT_END || pkt->range == AT_PKT_END)
+			return opcode == BPF_JGE;
+		break;
+	}
+	return -1;
+}
+
 /* Adjusts the register min/max values in the case that the dst_reg is the
  * variable register that we are working on, and src_reg is a constant or we're
  * simply doing a BPF_K check.
@@ -7137,23 +7227,7 @@ static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
 				u64 val, u32 val32,
 				u8 opcode, bool is_jmp32)
 {
-	/* How can we transform "a <op> b" into "b <op> a"? */
-	static const u8 opcode_flip[16] = {
-		/* these stay the same */
-		[BPF_JEQ  >> 4] = BPF_JEQ,
-		[BPF_JNE  >> 4] = BPF_JNE,
-		[BPF_JSET >> 4] = BPF_JSET,
-		/* these swap "lesser" and "greater" (L and G in the opcodes) */
-		[BPF_JGE  >> 4] = BPF_JLE,
-		[BPF_JGT  >> 4] = BPF_JLT,
-		[BPF_JLE  >> 4] = BPF_JGE,
-		[BPF_JLT  >> 4] = BPF_JGT,
-		[BPF_JSGE >> 4] = BPF_JSLE,
-		[BPF_JSGT >> 4] = BPF_JSLT,
-		[BPF_JSLE >> 4] = BPF_JSGE,
-		[BPF_JSLT >> 4] = BPF_JSGT
-	};
-	opcode = opcode_flip[opcode >> 4];
+	opcode = flip_opcode(opcode);
 	/* This uses zero as "not present in table"; luckily the zero opcode,
 	 * BPF_JA, can't get here.
 	 */
@@ -7334,6 +7408,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' > pkt_end, pkt_meta' > pkt_data */
 			find_good_pkt_pointers(this_branch, dst_reg,
 					       dst_reg->type, false);
+			mark_pkt_end(other_branch, insn->dst_reg, true);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7341,6 +7416,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end > pkt_data', pkt_data > pkt_meta' */
 			find_good_pkt_pointers(other_branch, src_reg,
 					       src_reg->type, true);
+			mark_pkt_end(this_branch, insn->src_reg, false);
 		} else {
 			return false;
 		}
@@ -7353,6 +7429,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' < pkt_end, pkt_meta' < pkt_data */
 			find_good_pkt_pointers(other_branch, dst_reg,
 					       dst_reg->type, true);
+			mark_pkt_end(this_branch, insn->dst_reg, false);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7360,6 +7437,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end < pkt_data', pkt_data > pkt_meta' */
 			find_good_pkt_pointers(this_branch, src_reg,
 					       src_reg->type, false);
+			mark_pkt_end(other_branch, insn->src_reg, true);
 		} else {
 			return false;
 		}
@@ -7372,6 +7450,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' >= pkt_end, pkt_meta' >= pkt_data */
 			find_good_pkt_pointers(this_branch, dst_reg,
 					       dst_reg->type, true);
+			mark_pkt_end(other_branch, insn->dst_reg, false);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7379,6 +7458,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end >= pkt_data', pkt_data >= pkt_meta' */
 			find_good_pkt_pointers(other_branch, src_reg,
 					       src_reg->type, false);
+			mark_pkt_end(this_branch, insn->src_reg, true);
 		} else {
 			return false;
 		}
@@ -7391,6 +7471,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_data' <= pkt_end, pkt_meta' <= pkt_data */
 			find_good_pkt_pointers(other_branch, dst_reg,
 					       dst_reg->type, false);
+			mark_pkt_end(this_branch, insn->dst_reg, true);
 		} else if ((dst_reg->type == PTR_TO_PACKET_END &&
 			    src_reg->type == PTR_TO_PACKET) ||
 			   (reg_is_init_pkt_pointer(dst_reg, PTR_TO_PACKET) &&
@@ -7398,6 +7479,7 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 			/* pkt_end <= pkt_data', pkt_data <= pkt_meta' */
 			find_good_pkt_pointers(this_branch, src_reg,
 					       src_reg->type, true);
+			mark_pkt_end(other_branch, insn->src_reg, false);
 		} else {
 			return false;
 		}
@@ -7497,6 +7579,10 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 				       src_reg->var_off.value,
 				       opcode,
 				       is_jmp32);
+	} else if (reg_is_pkt_pointer_any(dst_reg) &&
+		   reg_is_pkt_pointer_any(src_reg) &&
+		   !is_jmp32) {
+		pred = is_pkt_ptr_branch_taken(dst_reg, src_reg, opcode);
 	}
 
 	if (pred >= 0) {
@@ -7505,7 +7591,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 		 */
 		if (!__is_pointer_value(false, dst_reg))
 			err = mark_chain_precision(env, insn->dst_reg);
-		if (BPF_SRC(insn->code) == BPF_X && !err)
+		if (BPF_SRC(insn->code) == BPF_X && !err &&
+		    !__is_pointer_value(false, src_reg))
 			err = mark_chain_precision(env, insn->src_reg);
 		if (err)
 			return err;
-- 
2.23.0

