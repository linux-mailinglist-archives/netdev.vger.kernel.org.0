Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F40287FD1
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 03:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgJIBMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 21:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgJIBMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 21:12:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE78AC0613D4;
        Thu,  8 Oct 2020 18:12:45 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id i2so5802507pgh.7;
        Thu, 08 Oct 2020 18:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qFdqq8lP5aSPzSkV+TcsX2u6XMW80qboJO0m7fWlyjQ=;
        b=DDIbd5HYXIMCchRir25Iuii9TphaxDxXH2Nkd0IAI6Y+fJB044tpoD9hSLC2CLH386
         jDuR/sN2m8FiC726h7VQ2+pMOEvC+4lM8Fzve2q1Og50tzRZRlj2C5RYY08H4MCx+tQu
         fzAAkeuUh2uUm53chrp4MNOra3AdYDSLV8/lUgoKaeQBMW5kGqHen+nyWBByUEfE1B4+
         ngJXFyOgCi9TvZ/SDqYP2IxUwYv+oHsjNaUaEfOam+JVKB2CgTSzlIAWkBlA1MOf+e1E
         O2F4f5JKWD1RJCZYTM8qnoq//KyYmFY3/IzBaoIU+0a2OsNI+8YRJ2wYy7JBSP1jrkn+
         BcbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qFdqq8lP5aSPzSkV+TcsX2u6XMW80qboJO0m7fWlyjQ=;
        b=Pjpc800MqTjd7bH3DBLgS1r07ZkIX59mxtxsQXhOwjBoB1wxh2cV8xiBRjR8kxc1+9
         wSlemwgvouUMnu3jHnFbC0Dj7bH63HrewuGCLZh0KOiSA/UMrcjmceejNh09oL42aNUX
         v7YmMYRWRFNhOpcCORLKDnioQ/hh7uS+jbFS69p/2LMtyXkVUjpOC5OwczfEEmQaWO3c
         gAczUX1a/AkQ0IAEMhE0ynTMvBXnDy8Q8/0YU8V8sFGZDtyW5CRwaxv/52BPrblxCYOL
         r8GLNVST1Py+9/7jNxmSAn9Dw89/tlg5lbNqW1tQ7NcJUt2Swt0JiFqf+iaXOyNJ8nZV
         85qA==
X-Gm-Message-State: AOAM533iyyeBlcaCmBth6aHaMjcVN5OBYcJ4Sua/AXzYxRX3gImSohJj
        ECShSEkb6YEw25zYELJJb+4=
X-Google-Smtp-Source: ABdhPJz5EIyoAHaZ78qP9O5crCYRojtrVD16g8Y7jT/4UBqcSvB+i+Q+FdN7Px46rCnrgHxEKDKc5Q==
X-Received: by 2002:a65:63ca:: with SMTP id n10mr1391856pgv.271.1602205965422;
        Thu, 08 Oct 2020 18:12:45 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id k15sm8275822pfp.217.2020.10.08.18.12.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 18:12:44 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 1/4] bpf: Propagate scalar ranges through register assignments.
Date:   Thu,  8 Oct 2020 18:12:37 -0700
Message-Id: <20201009011240.48506-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

The llvm register allocator may use two different registers representing the
same virtual register. In such case the following pattern can be observed:
1047: (bf) r9 = r6
1048: (a5) if r6 < 0x1000 goto pc+1
1050: ...
1051: (a5) if r9 < 0x2 goto pc+66
1052: ...
1053: (bf) r2 = r9 /* r2 needs to have upper and lower bounds */

This is normal behavior of greedy register allocator.
The slides 137+ explain why regalloc introduces such register copy:
http://llvm.org/devmtg/2018-04/slides/Yatsina-LLVM%20Greedy%20Register%20Allocator.pdf
There is no way to tell llvm 'not to do this'.
Hence the verifier has to recognize such patterns.

In order to track this information without backtracking allocate ID
for scalars in a similar way as it's done for find_good_pkt_pointers().

When the verifier encounters r9 = r6 assignment it will assign the same ID
to both registers. Later if either register range is narrowed via conditional
jump propagate the register state into the other register.

Clear register ID in adjust_reg_min_max_vals() for any alu instruction. The
register ID is ignored for scalars in regsafe() and doesn't affect state
pruning. mark_reg_unknown() clears the ID. It's used to process call, endian
and other instructions. Hence ID is explicitly cleared only in
adjust_reg_min_max_vals() and in 32-bit mov.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/bpf/verifier.c                         | 50 +++++++++++++++++++
 .../testing/selftests/bpf/prog_tests/align.c  | 16 +++---
 .../bpf/verifier/direct_packet_access.c       |  2 +-
 3 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 62b804651a48..ba96f7e9bbc0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6436,6 +6436,11 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 	src_reg = NULL;
 	if (dst_reg->type != SCALAR_VALUE)
 		ptr_reg = dst_reg;
+	else
+		/* Make sure ID is cleared otherwise dst_reg min/max could be
+		 * incorrectly propagated into other registers by find_equal_scalars()
+		 */
+		dst_reg->id = 0;
 	if (BPF_SRC(insn->code) == BPF_X) {
 		src_reg = &regs[insn->src_reg];
 		if (src_reg->type != SCALAR_VALUE) {
@@ -6569,6 +6574,12 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				/* case: R1 = R2
 				 * copy register state to dest reg
 				 */
+				if (src_reg->type == SCALAR_VALUE && !src_reg->id)
+					/* Assign src and dst registers the same ID
+					 * that will be used by find_equal_scalars()
+					 * to propagate min/max range.
+					 */
+					src_reg->id = ++env->id_gen;
 				*dst_reg = *src_reg;
 				dst_reg->live |= REG_LIVE_WRITTEN;
 				dst_reg->subreg_def = DEF_NOT_SUBREG;
@@ -6581,6 +6592,11 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 					return -EACCES;
 				} else if (src_reg->type == SCALAR_VALUE) {
 					*dst_reg = *src_reg;
+					/* Make sure ID is cleared otherwise
+					 * dst_reg min/max could be incorrectly
+					 * propagated into src_reg by find_equal_scalars()
+					 */
+					dst_reg->id = 0;
 					dst_reg->live |= REG_LIVE_WRITTEN;
 					dst_reg->subreg_def = env->insn_idx + 1;
 				} else {
@@ -7369,6 +7385,30 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
 	return true;
 }
 
+static void find_equal_scalars(struct bpf_verifier_state *vstate,
+			       struct bpf_reg_state *known_reg)
+{
+	struct bpf_func_state *state;
+	struct bpf_reg_state *reg;
+	int i, j;
+
+	for (i = 0; i <= vstate->curframe; i++) {
+		state = vstate->frame[i];
+		for (j = 0; j < MAX_BPF_REG; j++) {
+			reg = &state->regs[j];
+			if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
+				*reg = *known_reg;
+		}
+
+		bpf_for_each_spilled_reg(j, state, reg) {
+			if (!reg)
+				continue;
+			if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)
+				*reg = *known_reg;
+		}
+	}
+}
+
 static int check_cond_jmp_op(struct bpf_verifier_env *env,
 			     struct bpf_insn *insn, int *insn_idx)
 {
@@ -7497,6 +7537,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 				reg_combine_min_max(&other_branch_regs[insn->src_reg],
 						    &other_branch_regs[insn->dst_reg],
 						    src_reg, dst_reg, opcode);
+			if (src_reg->id) {
+				find_equal_scalars(this_branch, src_reg);
+				find_equal_scalars(other_branch, &other_branch_regs[insn->src_reg]);
+			}
+
 		}
 	} else if (dst_reg->type == SCALAR_VALUE) {
 		reg_set_min_max(&other_branch_regs[insn->dst_reg],
@@ -7504,6 +7549,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 					opcode, is_jmp32);
 	}
 
+	if (dst_reg->type == SCALAR_VALUE && dst_reg->id) {
+		find_equal_scalars(this_branch, dst_reg);
+		find_equal_scalars(other_branch, &other_branch_regs[insn->dst_reg]);
+	}
+
 	/* detect if R == 0 where R is returned from bpf_map_lookup_elem().
 	 * NOTE: these optimizations below are related with pointer comparison
 	 *       which will never be JMP32.
diff --git a/tools/testing/selftests/bpf/prog_tests/align.c b/tools/testing/selftests/bpf/prog_tests/align.c
index c548aded6585..52414058a627 100644
--- a/tools/testing/selftests/bpf/prog_tests/align.c
+++ b/tools/testing/selftests/bpf/prog_tests/align.c
@@ -195,13 +195,13 @@ static struct bpf_align_test tests[] = {
 		.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 		.matches = {
 			{7, "R3_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))"},
-			{8, "R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))"},
+			{8, "R4_w=inv(id=1,umax_value=255,var_off=(0x0; 0xff))"},
 			{9, "R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))"},
-			{10, "R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))"},
+			{10, "R4_w=inv(id=1,umax_value=255,var_off=(0x0; 0xff))"},
 			{11, "R4_w=inv(id=0,umax_value=510,var_off=(0x0; 0x1fe))"},
-			{12, "R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))"},
+			{12, "R4_w=inv(id=1,umax_value=255,var_off=(0x0; 0xff))"},
 			{13, "R4_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
-			{14, "R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))"},
+			{14, "R4_w=inv(id=1,umax_value=255,var_off=(0x0; 0xff))"},
 			{15, "R4_w=inv(id=0,umax_value=2040,var_off=(0x0; 0x7f8))"},
 			{16, "R4_w=inv(id=0,umax_value=4080,var_off=(0x0; 0xff0))"},
 		},
@@ -518,7 +518,7 @@ static struct bpf_align_test tests[] = {
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc)"},
+			{20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc)"},
 
 		},
 	},
@@ -561,18 +561,18 @@ static struct bpf_align_test tests[] = {
 			/* Adding 14 makes R6 be (4n+2) */
 			{11, "R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c))"},
 			/* Subtracting from packet pointer overflows ubounds */
-			{13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c)"},
+			{13, "R5_w=pkt(id=2,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c)"},
 			/* New unknown value in R7 is (4n), >= 76 */
 			{15, "R7_w=inv(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc))"},
 			/* Adding it to packet pointer gives nice bounds again */
-			{16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
+			{16, "R5_w=pkt(id=3,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
 			 * which is 2.  Then the variable offset is (4n+2), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
+			{20, "R5=pkt(id=3,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
 		},
 	},
 };
diff --git a/tools/testing/selftests/bpf/verifier/direct_packet_access.c b/tools/testing/selftests/bpf/verifier/direct_packet_access.c
index 2c5fbe7bcd27..ae72536603fe 100644
--- a/tools/testing/selftests/bpf/verifier/direct_packet_access.c
+++ b/tools/testing/selftests/bpf/verifier/direct_packet_access.c
@@ -529,7 +529,7 @@
 	},
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.result = REJECT,
-	.errstr = "invalid access to packet, off=0 size=8, R5(id=1,off=0,r=0)",
+	.errstr = "invalid access to packet, off=0 size=8, R5(id=2,off=0,r=0)",
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
 {
-- 
2.23.0

