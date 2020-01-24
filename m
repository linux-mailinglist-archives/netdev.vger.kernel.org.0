Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A10D14885B
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390882AbgAXO2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:28:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405181AbgAXOVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF9720661;
        Fri, 24 Jan 2020 14:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875665;
        bh=CNKg/pLuTau6fYvz5t/alsgoLgxLSHaevzjZhA0Lny8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fASuUyN5RBvRAgSL8Yo9j/SyzIpz+w54RSp8tLnW3bzeyWytsdKSQYmskRzhikaNY
         ooO2oNofzk1teB3OG+zY9UE83HQOSWtX+24XTgEaNAegMRSlk20EUz+YKuc9GxLRIf
         H0Jjry2NDzvrAybNHqSMl9wsiDseGtmFSRcq4JO4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Anatoly Trosinenko <anatoly.trosinenko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 45/56] bpf: Fix incorrect verifier simulation of ARSH under ALU32
Date:   Fri, 24 Jan 2020 09:20:01 -0500
Message-Id: <20200124142012.29752-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 0af2ffc93a4b50948f9dad2786b7f1bd253bf0b9 ]

Anatoly has been fuzzing with kBdysch harness and reported a hang in one
of the outcomes:

  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (85) call bpf_get_socket_cookie#46
  1: R0_w=invP(id=0) R10=fp0
  1: (57) r0 &= 808464432
  2: R0_w=invP(id=0,umax_value=808464432,var_off=(0x0; 0x30303030)) R10=fp0
  2: (14) w0 -= 810299440
  3: R0_w=invP(id=0,umax_value=4294967295,var_off=(0xcf800000; 0x3077fff0)) R10=fp0
  3: (c4) w0 s>>= 1
  4: R0_w=invP(id=0,umin_value=1740636160,umax_value=2147221496,var_off=(0x67c00000; 0x183bfff8)) R10=fp0
  4: (76) if w0 s>= 0x30303030 goto pc+216
  221: R0_w=invP(id=0,umin_value=1740636160,umax_value=2147221496,var_off=(0x67c00000; 0x183bfff8)) R10=fp0
  221: (95) exit
  processed 6 insns (limit 1000000) [...]

Taking a closer look, the program was xlated as follows:

  # ./bpftool p d x i 12
  0: (85) call bpf_get_socket_cookie#7800896
  1: (bf) r6 = r0
  2: (57) r6 &= 808464432
  3: (14) w6 -= 810299440
  4: (c4) w6 s>>= 1
  5: (76) if w6 s>= 0x30303030 goto pc+216
  6: (05) goto pc-1
  7: (05) goto pc-1
  8: (05) goto pc-1
  [...]
  220: (05) goto pc-1
  221: (05) goto pc-1
  222: (95) exit

Meaning, the visible effect is very similar to f54c7898ed1c ("bpf: Fix
precision tracking for unbounded scalars"), that is, the fall-through
branch in the instruction 5 is considered to be never taken given the
conclusion from the min/max bounds tracking in w6, and therefore the
dead-code sanitation rewrites it as goto pc-1. However, real-life input
disagrees with verification analysis since a soft-lockup was observed.

The bug sits in the analysis of the ARSH. The definition is that we shift
the target register value right by K bits through shifting in copies of
its sign bit. In adjust_scalar_min_max_vals(), we do first coerce the
register into 32 bit mode, same happens after simulating the operation.
However, for the case of simulating the actual ARSH, we don't take the
mode into account and act as if it's always 64 bit, but location of sign
bit is different:

  dst_reg->smin_value >>= umin_val;
  dst_reg->smax_value >>= umin_val;
  dst_reg->var_off = tnum_arshift(dst_reg->var_off, umin_val);

Consider an unknown R0 where bpf_get_socket_cookie() (or others) would
for example return 0xffff. With the above ARSH simulation, we'd see the
following results:

  [...]
  1: R1=ctx(id=0,off=0,imm=0) R2_w=invP65535 R10=fp0
  1: (85) call bpf_get_socket_cookie#46
  2: R0_w=invP(id=0) R10=fp0
  2: (57) r0 &= 808464432
    -> R0_runtime = 0x3030
  3: R0_w=invP(id=0,umax_value=808464432,var_off=(0x0; 0x30303030)) R10=fp0
  3: (14) w0 -= 810299440
    -> R0_runtime = 0xcfb40000
  4: R0_w=invP(id=0,umax_value=4294967295,var_off=(0xcf800000; 0x3077fff0)) R10=fp0
                              (0xffffffff)
  4: (c4) w0 s>>= 1
    -> R0_runtime = 0xe7da0000
  5: R0_w=invP(id=0,umin_value=1740636160,umax_value=2147221496,var_off=(0x67c00000; 0x183bfff8)) R10=fp0
                              (0x67c00000)           (0x7ffbfff8)
  [...]

In insn 3, we have a runtime value of 0xcfb40000, which is '1100 1111 1011
0100 0000 0000 0000 0000', the result after the shift has 0xe7da0000 that
is '1110 0111 1101 1010 0000 0000 0000 0000', where the sign bit is correctly
retained in 32 bit mode. In insn4, the umax was 0xffffffff, and changed into
0x7ffbfff8 after the shift, that is, '0111 1111 1111 1011 1111 1111 1111 1000'
and means here that the simulation didn't retain the sign bit. With above
logic, the updates happen on the 64 bit min/max bounds and given we coerced
the register, the sign bits of the bounds are cleared as well, meaning, we
need to force the simulation into s32 space for 32 bit alu mode.

Verification after the fix below. We're first analyzing the fall-through branch
on 32 bit signed >= test eventually leading to rejection of the program in this
specific case:

  0: R1=ctx(id=0,off=0,imm=0) R10=fp0
  0: (b7) r2 = 808464432
  1: R1=ctx(id=0,off=0,imm=0) R2_w=invP808464432 R10=fp0
  1: (85) call bpf_get_socket_cookie#46
  2: R0_w=invP(id=0) R10=fp0
  2: (bf) r6 = r0
  3: R0_w=invP(id=0) R6_w=invP(id=0) R10=fp0
  3: (57) r6 &= 808464432
  4: R0_w=invP(id=0) R6_w=invP(id=0,umax_value=808464432,var_off=(0x0; 0x30303030)) R10=fp0
  4: (14) w6 -= 810299440
  5: R0_w=invP(id=0) R6_w=invP(id=0,umax_value=4294967295,var_off=(0xcf800000; 0x3077fff0)) R10=fp0
  5: (c4) w6 s>>= 1
  6: R0_w=invP(id=0) R6_w=invP(id=0,umin_value=3888119808,umax_value=4294705144,var_off=(0xe7c00000; 0x183bfff8)) R10=fp0
                                              (0x67c00000)          (0xfffbfff8)
  6: (76) if w6 s>= 0x30303030 goto pc+216
  7: R0_w=invP(id=0) R6_w=invP(id=0,umin_value=3888119808,umax_value=4294705144,var_off=(0xe7c00000; 0x183bfff8)) R10=fp0
  7: (30) r0 = *(u8 *)skb[808464432]
  BPF_LD_[ABS|IND] uses reserved fields
  processed 8 insns (limit 1000000) [...]

Fixes: 9cbe1f5a32dc ("bpf/verifier: improve register value range tracking with ARSH")
Reported-by: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200115204733.16648-1-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tnum.h  |  2 +-
 kernel/bpf/tnum.c     |  9 +++++++--
 kernel/bpf/verifier.c | 13 ++++++++++---
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/linux/tnum.h b/include/linux/tnum.h
index c7dc2b5902c05..06b9c20cc77ee 100644
--- a/include/linux/tnum.h
+++ b/include/linux/tnum.h
@@ -26,7 +26,7 @@ struct tnum tnum_lshift(struct tnum a, u8 shift);
 /* Shift (rsh) a tnum right (by a fixed shift) */
 struct tnum tnum_rshift(struct tnum a, u8 shift);
 /* Shift (arsh) a tnum right (by a fixed min_shift) */
-struct tnum tnum_arshift(struct tnum a, u8 min_shift);
+struct tnum tnum_arshift(struct tnum a, u8 min_shift, u8 insn_bitness);
 /* Add two tnums, return @a + @b */
 struct tnum tnum_add(struct tnum a, struct tnum b);
 /* Subtract two tnums, return @a - @b */
diff --git a/kernel/bpf/tnum.c b/kernel/bpf/tnum.c
index 938d41211be70..84984c0fc3d35 100644
--- a/kernel/bpf/tnum.c
+++ b/kernel/bpf/tnum.c
@@ -43,14 +43,19 @@ struct tnum tnum_rshift(struct tnum a, u8 shift)
 	return TNUM(a.value >> shift, a.mask >> shift);
 }
 
-struct tnum tnum_arshift(struct tnum a, u8 min_shift)
+struct tnum tnum_arshift(struct tnum a, u8 min_shift, u8 insn_bitness)
 {
 	/* if a.value is negative, arithmetic shifting by minimum shift
 	 * will have larger negative offset compared to more shifting.
 	 * If a.value is nonnegative, arithmetic shifting by minimum shift
 	 * will have larger positive offset compare to more shifting.
 	 */
-	return TNUM((s64)a.value >> min_shift, (s64)a.mask >> min_shift);
+	if (insn_bitness == 32)
+		return TNUM((u32)(((s32)a.value) >> min_shift),
+			    (u32)(((s32)a.mask)  >> min_shift));
+	else
+		return TNUM((s64)a.value >> min_shift,
+			    (s64)a.mask  >> min_shift);
 }
 
 struct tnum tnum_add(struct tnum a, struct tnum b)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9e72b2f8c3dd3..9bbfb1ff4ac94 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3309,9 +3309,16 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		/* Upon reaching here, src_known is true and
 		 * umax_val is equal to umin_val.
 		 */
-		dst_reg->smin_value >>= umin_val;
-		dst_reg->smax_value >>= umin_val;
-		dst_reg->var_off = tnum_arshift(dst_reg->var_off, umin_val);
+		if (insn_bitness == 32) {
+			dst_reg->smin_value = (u32)(((s32)dst_reg->smin_value) >> umin_val);
+			dst_reg->smax_value = (u32)(((s32)dst_reg->smax_value) >> umin_val);
+		} else {
+			dst_reg->smin_value >>= umin_val;
+			dst_reg->smax_value >>= umin_val;
+		}
+
+		dst_reg->var_off = tnum_arshift(dst_reg->var_off, umin_val,
+						insn_bitness);
 
 		/* blow away the dst_reg umin_value/umax_value and rely on
 		 * dst_reg var_off to refine the result.
-- 
2.20.1

