Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80DD13CE34
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgAOUrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:47:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:40974 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729263AbgAOUro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:47:44 -0500
Received: from 11.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.11] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1irpZk-0003Pi-J0; Wed, 15 Jan 2020 21:47:40 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anatoly.trosinenko@gmail.com, yhs@fb.com,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf] bpf: Fix incorrect verifier simulation of ARSH under ALU32
Date:   Wed, 15 Jan 2020 21:47:33 +0100
Message-Id: <20200115204733.16648-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25696/Wed Jan 15 14:34:23 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 include/linux/tnum.h  |  2 +-
 kernel/bpf/tnum.c     |  9 +++++++--
 kernel/bpf/verifier.c | 13 ++++++++++---
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/linux/tnum.h b/include/linux/tnum.h
index c17af77f3fae..ea627d1ab7e3 100644
--- a/include/linux/tnum.h
+++ b/include/linux/tnum.h
@@ -30,7 +30,7 @@ struct tnum tnum_lshift(struct tnum a, u8 shift);
 /* Shift (rsh) a tnum right (by a fixed shift) */
 struct tnum tnum_rshift(struct tnum a, u8 shift);
 /* Shift (arsh) a tnum right (by a fixed min_shift) */
-struct tnum tnum_arshift(struct tnum a, u8 min_shift);
+struct tnum tnum_arshift(struct tnum a, u8 min_shift, u8 insn_bitness);
 /* Add two tnums, return @a + @b */
 struct tnum tnum_add(struct tnum a, struct tnum b);
 /* Subtract two tnums, return @a - @b */
diff --git a/kernel/bpf/tnum.c b/kernel/bpf/tnum.c
index ca52b9642943..d4f335a9a899 100644
--- a/kernel/bpf/tnum.c
+++ b/kernel/bpf/tnum.c
@@ -44,14 +44,19 @@ struct tnum tnum_rshift(struct tnum a, u8 shift)
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
index ce85e7041f0c..7d530ce8719d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5049,9 +5049,16 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
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

