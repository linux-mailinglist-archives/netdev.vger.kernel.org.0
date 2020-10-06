Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C5B2852E8
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgJFUKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFUKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 16:10:02 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B45C061755;
        Tue,  6 Oct 2020 13:10:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y14so6431986pfp.13;
        Tue, 06 Oct 2020 13:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BG5oKpuWCLTqTPpdpcq8avuBNhranEDskqumBaW6wrw=;
        b=ubVZTdt7nuUG3vekjcchyhXe9qNcBxzllGMKn6yWIzpZ4dHjcXXJJqcTvaKOlRG62j
         8mpPEmNQFU9qpkDZaEvBa/E/YbHFfE4HHJraE65Y4L/FVFmswt1X0FIZxXSmbzVkTsY6
         jp3nnKDcNd5n9PRDc15+1BS7ELFDl3WVZq8kfyDzYIcLEW68G4oAV9LYbEHl0FutaKaQ
         ed625Rq81wT5jKEWQUM5tU5W8YeIRXUfR9YlrEFufRCLsTEzDpoKNT1d3QTAhWh0wtH/
         Op26rVQKCjcsR0X8YRdYoKV2NMLDYOFMevHnLNaJjb+/d9/DBXUyfZwEd3S/bNsxae06
         UhAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BG5oKpuWCLTqTPpdpcq8avuBNhranEDskqumBaW6wrw=;
        b=B8iuXZff0LBBOQR9G04VWb2yBfwHVnK3lqY6rkin+NXqnlfgOql759kGEleMhOhcTz
         vqDgu4MYSYVHUoAu3I3oAyyxJYQSpqknDhmx6DqDE+RZs33n+YuIEJESzi7/aQH3BOoQ
         WHEFrkyddNsZ9e71I7AWNSGK+DgiYCzDo50VzbK7Tyj7qrT3ybsCDmDZms2Z9reVT1wk
         dKsBqkYBDQKGZMfgXXQUWXI1Iy77GsIORNlVNbVEikiFGjQ/YoDcjgWKj5Xf2pF3Rurm
         Q7vj/bxaDrGpnNmwIBpcF9i5IIS2YCAkwEJ/rvU6c86Yx0VHbReOncwkrNPytTooo7XC
         OaRA==
X-Gm-Message-State: AOAM533NBFsl114r5R9BBjozPtACbFputvJCPT3HClASSm7qTyHaAKyo
        //q7gdzjslOuBAbZ2CD+qaI=
X-Google-Smtp-Source: ABdhPJx6asfEWtpsYhlfvc9OCxhzd8telRS2gqPV4PKxI/FFon5NIQyOI5BJbMQtG+rgewxMDKKOig==
X-Received: by 2002:a63:5349:: with SMTP id t9mr5649975pgl.62.1602015000473;
        Tue, 06 Oct 2020 13:10:00 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u18sm4358162pgk.18.2020.10.06.13.09.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2020 13:09:59 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through register assignments.
Date:   Tue,  6 Oct 2020 13:09:53 -0700
Message-Id: <20201006200955.12350-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
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

In order to track this information without backtracking allocate ID
for scalars in a similar way as it's done for find_good_pkt_pointers().

When the verifier encounters r9 = r6 assignment it will assign the same ID
to both registers. Later if either register range is narrowed via conditional
jump propagate the register state into the other register.

Clear register ID in adjust_reg_min_max_vals() for any alu instruction.

Newly allocated register ID is ignored for scalars in regsafe() and doesn't
affect state pruning. mark_reg_unknown() also clears the ID.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c                         | 38 +++++++++++++++++++
 .../testing/selftests/bpf/prog_tests/align.c  | 16 ++++----
 .../bpf/verifier/direct_packet_access.c       |  2 +-
 3 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 01120acab09a..09e17b483b0b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6432,6 +6432,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 	src_reg = NULL;
 	if (dst_reg->type != SCALAR_VALUE)
 		ptr_reg = dst_reg;
+	else
+		dst_reg->id = 0;
 	if (BPF_SRC(insn->code) == BPF_X) {
 		src_reg = &regs[insn->src_reg];
 		if (src_reg->type != SCALAR_VALUE) {
@@ -6565,6 +6567,8 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				/* case: R1 = R2
 				 * copy register state to dest reg
 				 */
+				if (src_reg->type == SCALAR_VALUE)
+					src_reg->id = ++env->id_gen;
 				*dst_reg = *src_reg;
 				dst_reg->live |= REG_LIVE_WRITTEN;
 				dst_reg->subreg_def = DEF_NOT_SUBREG;
@@ -7365,6 +7369,30 @@ static bool try_match_pkt_pointers(const struct bpf_insn *insn,
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
@@ -7493,6 +7521,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
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
@@ -7500,6 +7533,11 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
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
index c548aded6585..56a414ce5504 100644
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
+			{10, "R4_w=inv(id=2,umax_value=255,var_off=(0x0; 0xff))"},
 			{11, "R4_w=inv(id=0,umax_value=510,var_off=(0x0; 0x1fe))"},
-			{12, "R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))"},
+			{12, "R4_w=inv(id=3,umax_value=255,var_off=(0x0; 0xff))"},
 			{13, "R4_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
-			{14, "R4_w=inv(id=0,umax_value=255,var_off=(0x0; 0xff))"},
+			{14, "R4_w=inv(id=4,umax_value=255,var_off=(0x0; 0xff))"},
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

