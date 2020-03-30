Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A483A19806C
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbgC3QDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:03:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:56136 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbgC3QDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:03:40 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIwt1-00074S-39; Mon, 30 Mar 2020 18:03:39 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     jannh@google.com, yhs@fb.com, john.fastabend@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 3/3] bpf: Simplify reg_set_min_max_inv handling
Date:   Mon, 30 Mar 2020 18:03:24 +0200
Message-Id: <20200330160324.15259-4-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200330160324.15259-1-daniel@iogearbox.net>
References: <20200330160324.15259-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25767/Mon Mar 30 15:08:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jann Horn <jannh@google.com>

reg_set_min_max_inv() contains exactly the same logic as reg_set_min_max(),
just flipped around. While this makes sense in a cBPF verifier (where ALU
operations are not symmetric), it does not make sense for eBPF.

Replace reg_set_min_max_inv() with a helper that flips the opcode around,
then lets reg_set_min_max() do the complicated work.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 kernel/bpf/verifier.c | 108 +++++++++---------------------------------
 1 file changed, 22 insertions(+), 86 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6fce6f096c16..b55842033073 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5836,7 +5836,7 @@ static void reg_set_min_max(struct bpf_reg_state *true_reg,
 		break;
 	}
 	default:
-		break;
+		return;
 	}
 
 	__reg_deduce_bounds(false_reg);
@@ -5859,92 +5859,28 @@ static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
 				struct bpf_reg_state *false_reg, u64 val,
 				u8 opcode, bool is_jmp32)
 {
-	s64 sval;
-
-	if (__is_pointer_value(false, false_reg))
-		return;
-
-	val = is_jmp32 ? (u32)val : val;
-	sval = is_jmp32 ? (s64)(s32)val : (s64)val;
-
-	switch (opcode) {
-	case BPF_JEQ:
-	case BPF_JNE:
-	{
-		struct bpf_reg_state *reg =
-			opcode == BPF_JEQ ? true_reg : false_reg;
-
-		if (is_jmp32) {
-			u64 old_v = reg->var_off.value;
-			u64 hi_mask = ~0xffffffffULL;
-
-			reg->var_off.value = (old_v & hi_mask) | val;
-			reg->var_off.mask &= hi_mask;
-		} else {
-			__mark_reg_known(reg, val);
-		}
-		break;
-	}
-	case BPF_JSET:
-		false_reg->var_off = tnum_and(false_reg->var_off,
-					      tnum_const(~val));
-		if (is_power_of_2(val))
-			true_reg->var_off = tnum_or(true_reg->var_off,
-						    tnum_const(val));
-		break;
-	case BPF_JGE:
-	case BPF_JGT:
-	{
-		set_lower_bound(false_reg, val, is_jmp32, opcode == BPF_JGE);
-		set_upper_bound(true_reg, val, is_jmp32, opcode == BPF_JGT);
-		break;
-	}
-	case BPF_JSGE:
-	case BPF_JSGT:
-	{
-		s64 false_smin = opcode == BPF_JSGT ? sval    : sval + 1;
-		s64 true_smax = opcode == BPF_JSGT ? sval - 1 : sval;
-
-		if (is_jmp32 && !cmp_val_with_extended_s64(sval, false_reg))
-			break;
-		false_reg->smin_value = max(false_reg->smin_value, false_smin);
-		true_reg->smax_value = min(true_reg->smax_value, true_smax);
-		break;
-	}
-	case BPF_JLE:
-	case BPF_JLT:
-	{
-		set_upper_bound(false_reg, val, is_jmp32, opcode == BPF_JLE);
-		set_lower_bound(true_reg, val, is_jmp32, opcode == BPF_JLT);
-		break;
-	}
-	case BPF_JSLE:
-	case BPF_JSLT:
-	{
-		s64 false_smax = opcode == BPF_JSLT ? sval    : sval - 1;
-		s64 true_smin = opcode == BPF_JSLT ? sval + 1 : sval;
-
-		if (is_jmp32 && !cmp_val_with_extended_s64(sval, false_reg))
-			break;
-		false_reg->smax_value = min(false_reg->smax_value, false_smax);
-		true_reg->smin_value = max(true_reg->smin_value, true_smin);
-		break;
-	}
-	default:
-		break;
-	}
-
-	__reg_deduce_bounds(false_reg);
-	__reg_deduce_bounds(true_reg);
-	/* We might have learned some bits from the bounds. */
-	__reg_bound_offset(false_reg);
-	__reg_bound_offset(true_reg);
-	/* Intersecting with the old var_off might have improved our bounds
-	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
-	 * then new var_off is (0; 0x7f...fc) which improves our umax.
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
+	opcode = opcode_flip[opcode >> 4];
+	/* This uses zero as "not present in table"; luckily the zero opcode,
+	 * BPF_JA, can't get here.
 	 */
-	__update_reg_bounds(false_reg);
-	__update_reg_bounds(true_reg);
+	if (opcode)
+		reg_set_min_max(true_reg, false_reg, val, opcode, is_jmp32);
 }
 
 /* Regs are known to be equal, so intersect their min/max/var_off */
-- 
2.20.1

