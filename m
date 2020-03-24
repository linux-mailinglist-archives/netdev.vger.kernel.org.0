Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968451917CF
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgCXRjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:39:15 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:33249 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:39:15 -0400
Received: by mail-pg1-f171.google.com with SMTP id d17so8815688pgo.0;
        Tue, 24 Mar 2020 10:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=jItT7Nr1JJco5aKU04freRkWjt6Ug9JL7zP7uQIdSsw=;
        b=dx8uKD1LfsV/A0/hCtcbX0zE4/aHJj7+l80SOwtXINXDy3d16vG/Aih80GslnOkLWi
         IGfXFYveZ/U2jc4UjgjEy2kU+Q/G/iU7vWFVQjoxGs4qQizGPvU6OI2/ifFhKP9XYnu9
         7OOlZ01Le4FE7AtZdAXPCUvqwl6REqkIDxp+W1RoekL67s0owEGgBeQECnPPa+5rpuZC
         F+tZ29zFyWqqrhup3rysqsqk2c+hmAP+H1rzBxXi7JQw0QTPqMNGVZbvKNIMBBl05Kx4
         YsB+Rl+gBZysrOt52IKs31V9IQC8jKBPfSsv8Sdl9/gG/DNtl2fmo3uyyeKmg6QkAFxM
         hZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jItT7Nr1JJco5aKU04freRkWjt6Ug9JL7zP7uQIdSsw=;
        b=VWkLvvnqz2ZXjMNrB2xkKoQnw+gTpoX9hS2gYDbhUwYGiguNX2FN/j+o7sheo6P1Jc
         ZM18tqc0VVsidd1VduaK1hKxt3h+bh6EkzWqjrNIGSbp5v9KBtb0c0yJNUF3ByoaxAAr
         oCzPvWEAnQCgQ/jouaw+YM2VQJn8Okj+5wgkwUEDjLsky8KjKqzgqsLF5iMWZGwb8vrK
         xG/gluGUHYYCz40qa7yiZq3ug3R7wYzJY9T/mYywdr4a0/OLJPVNUv238cWXFbOS9DgP
         PYEU7jdAiadSLkbxMHTz9FZUEXVU6SQq1trmshJWg1BSFFcpLGEUlHcSBpSUEagaHrcY
         Vb+w==
X-Gm-Message-State: ANhLgQ0yqGrjJEcOwsA1MtuPKx5nTmT/e4vp5WBJs93q+YXwWbzSx3qY
        iJ33QmmoTL47Nq8hpMJn5zE=
X-Google-Smtp-Source: ADFU+vuLX/XIOrrmkgae9SCw9Ns3nehL5HpShfeRKAHLs9EOeUWoYqysReznWiZDTd3P4duZ+jmhsw==
X-Received: by 2002:a62:1513:: with SMTP id 19mr30392702pfv.85.1585071550526;
        Tue, 24 Mar 2020 10:39:10 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m11sm2813878pjl.18.2020.03.24.10.39.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:39:10 -0700 (PDT)
Subject: [bpf-next PATCH 04/10] bpf: verifier,
 do explicit ALU32 bounds tracking
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:38:56 -0700
Message-ID: <158507153582.15666.3091405867682349273.stgit@john-Precision-5820-Tower>
In-Reply-To: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not possible for the current verifier to track ALU32 and JMP ops
correctly. This can result in the verifier aborting with errors even though
the program should be verifiable. BPF codes that hit this can work around
it by changin int variables to 64-bit types, marking variables volatile,
etc. But this is all very ugly so it would be better to avoid these tricks.

But, the main reason to address this now is do_refine_retval_range() was
assuming return values could not be negative. Once we fixed this code that
was previously working will no longer work. See do_refine_retval_range()
patch for details. And we don't want to suddenly cause programs that used
to work to fail.

The simplest example code snippet that illustrates the problem is likely
this,

 53: w8 = w0                    // r8 <- [0, S32_MAX],
                                // w8 <- [-S32_MIN, X]
 54: w8 <s 0                    // r8 <- [0, U32_MAX]
                                // w8 <- [0, X]

The expected 64-bit and 32-bit bounds after each line are shown on the
right. The current issue is without the w* bounds we are forced to use
the worst case bound of [0, U32_MAX]. To resolve this type of case,
jmp32 creating divergent 32-bit bounds from 64-bit bounds, we add explicit
32-bit register bounds s32_{min|max}_value and u32_{min|max}_value. Then
from branch_taken logic creating new bounds we can track 32-bit bounds
explicitly.

The next case we observed is ALU ops after the jmp32,

 53: w8 = w0                    // r8 <- [0, S32_MAX],
                                // w8 <- [-S32_MIN, X]
 54: w8 <s 0                    // r8 <- [0, U32_MAX]
                                // w8 <- [0, X]
 55: w8 += 1                    // r8 <- [0, U32_MAX+1]
                                // w8 <- [0, X+1]

In order to keep the bounds accurate at this point we also need to track
ALU32 ops. To do this we add explicit ALU32 logic for each of the ALU
ops, mov, add, sub, etc.

Finally there is a question of how and when to merge bounds. The cases
enumerate here,

1. MOV ALU32   - zext 32-bit -> 64-bit
2. MOV ALU64   - copy 64-bit -> 32-bit
3. op  ALU32   - zext 32-bit -> 64-bit
4. op  ALU64   - n/a
5. jmp ALU32   - 64-bit: var32_off | upper_32_bits(var64_off)
6. jmp ALU64   - 32-bit: (>> (<< var64_off))

Details for each case,

For "MOV ALU32" BPF arch zero extends so we simply copy the bounds
from 32-bit into 64-bit ensuring we truncate var_off and 64-bit
bounds correctly. See zext_32_to_64.

For "MOV ALU64" copy all bounds including 32-bit into new register. If
the src register had 32-bit bounds the dst register will as well.

For "op ALU32" zero extend 32-bit into 64-bit the same as move,
see zext_32_to_64.

For "op ALU64" calculate both 32-bit and 64-bit bounds no merging
is done here. Except we have a special case. When RSH or ARSH is
done we can't simply ignore shifting bits from 64-bit reg into the
32-bit subreg. So currently just push bounds from 64-bit into 32-bit.
This will be correct in the sense that they will represent a valid
state of the register. However we could lose some accuracy if an
ARSH is following a jmp32 operation. We can handle this special
case in a follow up series.

For "jmp ALU32" mark 64-bit reg unknown and recalculate 64-bit bounds
from tnum by setting var_off to ((<<(>>var_off)) | var32_off). We
special case if 64-bit bounds has zero'd upper 32bits at which point
we can simply copy 32-bit bounds into 64-bit register. This catches
a common compiler trick where upper 32-bits are zeroed and then
32-bit ops are used followed by a 64-bit compare or 64-bit op on
a pointer. See __reg_combine_64_into_32().

For "jmp ALU64" cast the bounds of the 64bit to their 32-bit
counterpart. For example s32_min_value = (s32)reg->smin_value. For
tnum use only the lower 32bits via, (>>(<<var_off)). See
__reg_combine_64_into_32().

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/bpf_verifier.h |    4 
 include/linux/limits.h       |    1 
 include/linux/tnum.h         |   12 
 kernel/bpf/tnum.c            |   15 +
 kernel/bpf/verifier.c        | 1162 ++++++++++++++++++++++++++++++++----------
 5 files changed, 908 insertions(+), 286 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 5406e6e..6abd5a7 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -123,6 +123,10 @@ struct bpf_reg_state {
 	s64 smax_value; /* maximum possible (s64)value */
 	u64 umin_value; /* minimum possible (u64)value */
 	u64 umax_value; /* maximum possible (u64)value */
+	s32 s32_min_value; /* minimum possible (s32)value */
+	s32 s32_max_value; /* maximum possible (s32)value */
+	u32 u32_min_value; /* minimum possible (u32)value */
+	u32 u32_max_value; /* maximum possible (u32)value */
 	/* parentage chain for liveness checking */
 	struct bpf_reg_state *parent;
 	/* Inside the callee two registers can be both PTR_TO_STACK like
diff --git a/include/linux/limits.h b/include/linux/limits.h
index 76afcd2..0d3de82 100644
--- a/include/linux/limits.h
+++ b/include/linux/limits.h
@@ -27,6 +27,7 @@
 #define S16_MAX		((s16)(U16_MAX >> 1))
 #define S16_MIN		((s16)(-S16_MAX - 1))
 #define U32_MAX		((u32)~0U)
+#define U32_MIN		((u32)0)
 #define S32_MAX		((s32)(U32_MAX >> 1))
 #define S32_MIN		((s32)(-S32_MAX - 1))
 #define U64_MAX		((u64)~0ULL)
diff --git a/include/linux/tnum.h b/include/linux/tnum.h
index ea627d1..498dbce 100644
--- a/include/linux/tnum.h
+++ b/include/linux/tnum.h
@@ -86,4 +86,16 @@ int tnum_strn(char *str, size_t size, struct tnum a);
 /* Format a tnum as tristate binary expansion */
 int tnum_sbin(char *str, size_t size, struct tnum a);
 
+/* Returns the 32-bit subreg */
+struct tnum tnum_subreg(struct tnum a);
+/* Returns the tnum with the lower 32-bit subreg cleared */
+struct tnum tnum_clear_subreg(struct tnum a);
+/* Returns the tnum with the lower 32-bit subreg set to value */
+struct tnum tnum_const_subreg(struct tnum a, u32 value);
+/* Returns true if 32-bit subreg @a is a known constant*/
+static inline bool tnum_subreg_is_const(struct tnum a)
+{
+	return !(tnum_subreg(a)).mask;
+}
+
 #endif /* _LINUX_TNUM_H */
diff --git a/kernel/bpf/tnum.c b/kernel/bpf/tnum.c
index d4f335a..ceac528 100644
--- a/kernel/bpf/tnum.c
+++ b/kernel/bpf/tnum.c
@@ -194,3 +194,18 @@ int tnum_sbin(char *str, size_t size, struct tnum a)
 	str[min(size - 1, (size_t)64)] = 0;
 	return 64;
 }
+
+struct tnum tnum_subreg(struct tnum a)
+{
+	return tnum_cast(a, 4);
+}
+
+struct tnum tnum_clear_subreg(struct tnum a)
+{
+	return tnum_lshift(tnum_rshift(a, 32), 32);
+}
+
+struct tnum tnum_const_subreg(struct tnum a, u32 value)
+{
+	return tnum_or(tnum_clear_subreg(a), tnum_const(value));
+}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fea9725..6372fa4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -549,6 +549,22 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 					tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
 					verbose(env, ",var_off=%s", tn_buf);
 				}
+				if (reg->s32_min_value != reg->smin_value &&
+				    reg->s32_min_value != S32_MIN)
+					verbose(env, ",s32_min_value=%d",
+						(int)(reg->s32_min_value));
+				if (reg->s32_max_value != reg->smax_value &&
+				    reg->s32_max_value != S32_MAX)
+					verbose(env, ",s32_max_value=%d",
+						(int)(reg->s32_max_value));
+				if (reg->u32_min_value != reg->umin_value &&
+				    reg->u32_min_value != U32_MIN)
+					verbose(env, ",u32_min_value=%d",
+						(int)(reg->u32_min_value));
+				if (reg->u32_max_value != reg->umax_value &&
+				    reg->u32_max_value != U32_MAX)
+					verbose(env, ",u32_max_value=%d",
+						(int)(reg->u32_max_value));
 			}
 			verbose(env, ")");
 		}
@@ -923,6 +939,20 @@ static void __mark_reg_known(struct bpf_reg_state *reg, u64 imm)
 	reg->smax_value = (s64)imm;
 	reg->umin_value = imm;
 	reg->umax_value = imm;
+
+	reg->s32_min_value = (s32)imm;
+	reg->s32_max_value = (s32)imm;
+	reg->u32_min_value = (u32)imm;
+	reg->u32_max_value = (u32)imm;
+}
+
+static void __mark_reg32_known(struct bpf_reg_state *reg, u64 imm)
+{
+	reg->var_off = tnum_const_subreg(reg->var_off, imm);
+	reg->s32_min_value = (s32)imm;
+	reg->s32_max_value = (s32)imm;
+	reg->u32_min_value = (u32)imm;
+	reg->u32_max_value = (u32)imm;
 }
 
 /* Mark the 'variable offset' part of a register as zero.  This should be
@@ -977,8 +1007,52 @@ static bool reg_is_init_pkt_pointer(const struct bpf_reg_state *reg,
 	       tnum_equals_const(reg->var_off, 0);
 }
 
-/* Attempts to improve min/max values based on var_off information */
-static void __update_reg_bounds(struct bpf_reg_state *reg)
+/* Reset the min/max bounds of a register */
+static void __mark_reg_unbounded(struct bpf_reg_state *reg)
+{
+	reg->smin_value = S64_MIN;
+	reg->smax_value = S64_MAX;
+	reg->umin_value = 0;
+	reg->umax_value = U64_MAX;
+
+	reg->s32_min_value = S32_MIN;
+	reg->s32_max_value = S32_MAX;
+	reg->u32_min_value = 0;
+	reg->u32_max_value = U32_MAX;
+}
+
+static void __mark_reg64_unbounded(struct bpf_reg_state *reg)
+{
+	reg->smin_value = S64_MIN;
+	reg->smax_value = S64_MAX;
+	reg->umin_value = 0;
+	reg->umax_value = U64_MAX;
+}
+
+static void __mark_reg32_unbounded(struct bpf_reg_state *reg)
+{
+	reg->s32_min_value = S32_MIN;
+	reg->s32_max_value = S32_MAX;
+	reg->u32_min_value = 0;
+	reg->u32_max_value = U32_MAX;
+}
+
+static void __update_reg32_bounds(struct bpf_reg_state *reg)
+{
+	struct tnum var32_off = tnum_subreg(reg->var_off);
+
+	/* min signed is max(sign bit) | min(other bits) */
+	reg->s32_min_value = max_t(s32, reg->s32_min_value,
+			var32_off.value | (var32_off.mask & S32_MIN));
+	/* max signed is min(sign bit) | max(other bits) */
+	reg->s32_max_value = min_t(s32, reg->s32_max_value,
+			var32_off.value | (var32_off.mask & S32_MAX));
+	reg->u32_min_value = max(reg->u32_min_value, (u32)var32_off.value);
+	reg->u32_max_value = min(reg->u32_max_value,
+				 (u32)(var32_off.value | var32_off.mask));
+}
+
+static void __update_reg64_bounds(struct bpf_reg_state *reg)
 {
 	/* min signed is max(sign bit) | min(other bits) */
 	reg->smin_value = max_t(s64, reg->smin_value,
@@ -991,8 +1065,48 @@ static void __update_reg_bounds(struct bpf_reg_state *reg)
 			      reg->var_off.value | reg->var_off.mask);
 }
 
+static void __update_reg_bounds(struct bpf_reg_state *reg)
+{
+	__update_reg32_bounds(reg);
+	__update_reg64_bounds(reg);
+}
+
 /* Uses signed min/max values to inform unsigned, and vice-versa */
-static void __reg_deduce_bounds(struct bpf_reg_state *reg)
+static void __reg32_deduce_bounds(struct bpf_reg_state *reg)
+{
+	/* Learn sign from signed bounds.
+	 * If we cannot cross the sign boundary, then signed and unsigned bounds
+	 * are the same, so combine.  This works even in the negative case, e.g.
+	 * -3 s<= x s<= -1 implies 0xf...fd u<= x u<= 0xf...ff.
+	 */
+	if (reg->s32_min_value >= 0 || reg->s32_max_value < 0) {
+		reg->s32_min_value = reg->u32_min_value =
+			max_t(u32, reg->s32_min_value, reg->u32_min_value);
+		reg->s32_max_value = reg->u32_max_value =
+			min_t(u32, reg->s32_max_value, reg->u32_max_value);
+		return;
+	}
+	/* Learn sign from unsigned bounds.  Signed bounds cross the sign
+	 * boundary, so we must be careful.
+	 */
+	if ((s32)reg->u32_max_value >= 0) {
+		/* Positive.  We can't learn anything from the smin, but smax
+		 * is positive, hence safe.
+		 */
+		reg->s32_min_value = reg->u32_min_value;
+		reg->s32_max_value = reg->u32_max_value =
+			min_t(u32, reg->s32_max_value, reg->u32_max_value);
+	} else if ((s32)reg->u32_min_value < 0) {
+		/* Negative.  We can't learn anything from the smax, but smin
+		 * is negative, hence safe.
+		 */
+		reg->s32_min_value = reg->u32_min_value =
+			max_t(u32, reg->s32_min_value, reg->u32_min_value);
+		reg->s32_max_value = reg->u32_max_value;
+	}
+}
+
+static void __reg64_deduce_bounds(struct bpf_reg_state *reg)
 {
 	/* Learn sign from signed bounds.
 	 * If we cannot cross the sign boundary, then signed and unsigned bounds
@@ -1026,32 +1140,91 @@ static void __reg_deduce_bounds(struct bpf_reg_state *reg)
 	}
 }
 
+static void __reg_deduce_bounds(struct bpf_reg_state *reg)
+{
+	__reg32_deduce_bounds(reg);
+	__reg64_deduce_bounds(reg);
+}
+
 /* Attempts to improve var_off based on unsigned min/max information */
 static void __reg_bound_offset(struct bpf_reg_state *reg)
 {
-	reg->var_off = tnum_intersect(reg->var_off,
-				      tnum_range(reg->umin_value,
-						 reg->umax_value));
+	struct tnum var64_off = tnum_intersect(reg->var_off,
+					       tnum_range(reg->umin_value,
+							  reg->umax_value));
+	struct tnum var32_off = tnum_intersect(tnum_subreg(reg->var_off),
+						tnum_range(reg->u32_min_value,
+							   reg->u32_max_value));
+
+	reg->var_off = tnum_or(tnum_clear_subreg(var64_off), var32_off);
 }
 
-static void __reg_bound_offset32(struct bpf_reg_state *reg)
+static void __reg_combine_32_into_64(struct bpf_reg_state *reg)
 {
-	u64 mask = 0xffffFFFF;
-	struct tnum range = tnum_range(reg->umin_value & mask,
-				       reg->umax_value & mask);
-	struct tnum lo32 = tnum_cast(reg->var_off, 4);
-	struct tnum hi32 = tnum_lshift(tnum_rshift(reg->var_off, 32), 32);
+	/* special case when 64-bit register has upper 32-bit register
+	 * zeroed. Typically happens after zext or <<32, >>32 sequence
+	 * allowing us to use 32-bit bounds directly,
+	 */
+	if (tnum_equals_const(tnum_clear_subreg(reg->var_off), 0)) {
+		reg->umin_value = reg->u32_min_value;
+		reg->umax_value = reg->u32_max_value;
+		reg->smin_value = reg->s32_min_value;
+		reg->smax_value = reg->s32_max_value;
+	} else {
+		/* Otherwise the best we can do is push lower 32bit known and
+		 * unknown bits into register (var_off set from jmp logic)
+		 * then learn as much as possible from the 64-bit tnum
+		 * known and unknown bits. The previous smin/smax bounds are
+		 * invalid here because of jmp32 compare so mark them unknown
+		 * so they do not impact tnum bounds calculation.
+		 */
+		__mark_reg64_unbounded(reg);
+		__update_reg_bounds(reg);
+	}
 
-	reg->var_off = tnum_or(hi32, tnum_intersect(lo32, range));
+	/* Intersecting with the old var_off might have improved our bounds
+	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
+	 * then new var_off is (0; 0x7f...fc) which improves our umax.
+	 */
+	__reg_deduce_bounds(reg);
+	__reg_bound_offset(reg);
+	__update_reg_bounds(reg);
 }
 
-/* Reset the min/max bounds of a register */
-static void __mark_reg_unbounded(struct bpf_reg_state *reg)
+static bool __reg64_bound_s32(s64 a)
 {
-	reg->smin_value = S64_MIN;
-	reg->smax_value = S64_MAX;
-	reg->umin_value = 0;
-	reg->umax_value = U64_MAX;
+	if (a > S32_MIN && a < S32_MAX)
+		return true;
+	return false;
+}
+
+static bool __reg64_bound_u32(u64 a)
+{
+	if (a > U32_MIN && a < U32_MAX)
+		return true;
+	return false;
+}
+
+static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
+{
+	__mark_reg32_unbounded(reg);
+
+	if (__reg64_bound_s32(reg->smin_value))
+		reg->s32_min_value = (s32)reg->smin_value;
+	if (__reg64_bound_s32(reg->smax_value))
+		reg->s32_max_value = (s32)reg->smax_value;
+	if (__reg64_bound_u32(reg->umin_value))
+		reg->u32_min_value = (u32)reg->umin_value;
+	if (__reg64_bound_u32(reg->umax_value))
+		reg->u32_max_value = (u32)reg->umax_value;
+
+	/* Intersecting with the old var_off might have improved our bounds
+	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
+	 * then new var_off is (0; 0x7f...fc) which improves our umax.
+	 */
+	__reg_deduce_bounds(reg);
+	__reg_bound_offset(reg);
+	__update_reg_bounds(reg);
 }
 
 /* Mark a register as having a completely unknown (scalar) value. */
@@ -2784,6 +2957,25 @@ static int check_tp_buffer_access(struct bpf_verifier_env *env,
 	return 0;
 }
 
+/* BPF architecture zero extends alu32 ops into 64-bit registesr */
+static void zext_32_to_64(struct bpf_reg_state *reg)
+{
+	reg->var_off = tnum_subreg(reg->var_off);
+	reg->umin_value = reg->u32_min_value;
+	reg->umax_value = reg->u32_max_value;
+	/* Attempt to pull 32-bit signed bounds into 64-bit bounds
+	 * but must be positive otherwise set to worse case bounds
+	 * and refine later from tnum.
+	 */
+	if (reg->s32_min_value > 0)
+		reg->smin_value = reg->s32_min_value;
+	else
+		reg->smin_value = 0;
+	if (reg->s32_max_value > 0)
+		reg->smax_value = reg->s32_max_value;
+	else
+		reg->smax_value = U32_MAX;
+}
 
 /* truncate register to smaller size (in bytes)
  * must be called with size < BPF_REG_SIZE
@@ -2806,6 +2998,15 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
 	}
 	reg->smin_value = reg->umin_value;
 	reg->smax_value = reg->umax_value;
+
+	/* If size is smaller than 32bit register the 32bit register
+	 * values are also truncated so we push 64-bit bounds into
+	 * 32-bit bounds. Above were truncated < 32-bits already.
+	 */
+	if (size >= 4) {
+		return;
+	}
+	__reg_combine_64_into_32(reg);
 }
 
 static bool bpf_map_is_rdonly(const struct bpf_map *map)
@@ -4437,7 +4638,17 @@ static bool signed_add_overflows(s64 a, s64 b)
 	return res < a;
 }
 
-static bool signed_sub_overflows(s64 a, s64 b)
+static bool signed_add32_overflows(s64 a, s64 b)
+{
+	/* Do the add in u32, where overflow is well-defined */
+	s32 res = (s32)((u32)a + (u32)b);
+
+	if (b < 0)
+		return res > a;
+	return res < a;
+}
+
+static bool signed_sub_overflows(s32 a, s32 b)
 {
 	/* Do the sub in u64, where overflow is well-defined */
 	s64 res = (s64)((u64)a - (u64)b);
@@ -4447,6 +4658,16 @@ static bool signed_sub_overflows(s64 a, s64 b)
 	return res > a;
 }
 
+static bool signed_sub32_overflows(s32 a, s32 b)
+{
+	/* Do the sub in u64, where overflow is well-defined */
+	s32 res = (s32)((u32)a - (u32)b);
+
+	if (b < 0)
+		return res < a;
+	return res > a;
+}
+
 static bool check_reg_sane_offset(struct bpf_verifier_env *env,
 				  const struct bpf_reg_state *reg,
 				  enum bpf_reg_type type)
@@ -4683,6 +4904,9 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	    !check_reg_sane_offset(env, ptr_reg, ptr_reg->type))
 		return -EINVAL;
 
+	/* pointer types do not carry 32-bit bounds at the moment. */
+	__mark_reg32_unbounded(dst_reg);
+
 	switch (opcode) {
 	case BPF_ADD:
 		ret = sanitize_ptr_alu(env, insn, ptr_reg, dst_reg, smin_val < 0);
@@ -4846,6 +5070,32 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static void scalar32_min_max_add(struct bpf_reg_state *dst_reg,
+				 struct bpf_reg_state *src_reg)
+{
+	s32 smin_val = src_reg->s32_min_value;
+	s32 smax_val = src_reg->s32_max_value;
+	u32 umin_val = src_reg->u32_min_value;
+	u32 umax_val = src_reg->u32_max_value;
+
+	if (signed_add32_overflows(dst_reg->s32_min_value, smin_val) ||
+	    signed_add32_overflows(dst_reg->s32_max_value, smax_val)) {
+		dst_reg->s32_min_value = S32_MIN;
+		dst_reg->s32_max_value = S32_MAX;
+	} else {
+		dst_reg->s32_min_value += smin_val;
+		dst_reg->s32_max_value += smax_val;
+	}
+	if (dst_reg->u32_min_value + umin_val < umin_val ||
+	    dst_reg->u32_max_value + umax_val < umax_val) {
+		dst_reg->u32_min_value = 0;
+		dst_reg->u32_max_value = U32_MAX;
+	} else {
+		dst_reg->u32_min_value += umin_val;
+		dst_reg->u32_max_value += umax_val;
+	}
+}
+
 static void scalar_min_max_add(struct bpf_reg_state *dst_reg,
 			       struct bpf_reg_state *src_reg)
 {
@@ -4870,7 +5120,34 @@ static void scalar_min_max_add(struct bpf_reg_state *dst_reg,
 		dst_reg->umin_value += umin_val;
 		dst_reg->umax_value += umax_val;
 	}
-	dst_reg->var_off = tnum_add(dst_reg->var_off, src_reg->var_off);
+}
+
+static void scalar32_min_max_sub(struct bpf_reg_state *dst_reg,
+				 struct bpf_reg_state *src_reg)
+{
+	s32 smin_val = src_reg->s32_min_value;
+	s32 smax_val = src_reg->s32_max_value;
+	u32 umin_val = src_reg->u32_min_value;
+	u32 umax_val = src_reg->u32_max_value;
+
+	if (signed_sub32_overflows(dst_reg->s32_min_value, smax_val) ||
+	    signed_sub32_overflows(dst_reg->s32_max_value, smin_val)) {
+		/* Overflow possible, we know nothing */
+		dst_reg->s32_min_value = S32_MIN;
+		dst_reg->s32_max_value = S32_MAX;
+	} else {
+		dst_reg->s32_min_value -= smax_val;
+		dst_reg->s32_max_value -= smin_val;
+	}
+	if (dst_reg->u32_min_value < umax_val) {
+		/* Overflow possible, we know nothing */
+		dst_reg->u32_min_value = 0;
+		dst_reg->u32_max_value = U32_MAX;
+	} else {
+		/* Cannot overflow (as long as bounds are consistent) */
+		dst_reg->u32_min_value -= umax_val;
+		dst_reg->u32_max_value -= umin_val;
+	}
 }
 
 static void scalar_min_max_sub(struct bpf_reg_state *dst_reg,
@@ -4899,7 +5176,38 @@ static void scalar_min_max_sub(struct bpf_reg_state *dst_reg,
 		dst_reg->umin_value -= umax_val;
 		dst_reg->umax_value -= umin_val;
 	}
-	dst_reg->var_off = tnum_sub(dst_reg->var_off, src_reg->var_off);
+}
+
+static void scalar32_min_max_mul(struct bpf_reg_state *dst_reg,
+				 struct bpf_reg_state *src_reg)
+{
+	s32 smin_val = src_reg->s32_min_value;
+	u32 umin_val = src_reg->u32_min_value;
+	u32 umax_val = src_reg->u32_max_value;
+
+	if (smin_val < 0 || dst_reg->s32_min_value < 0) {
+		/* Ain't nobody got time to multiply that sign */
+		__mark_reg32_unbounded(dst_reg);
+		return;
+	}
+	/* Both values are positive, so we can work with unsigned and
+	 * copy the result to signed (unless it exceeds S32_MAX).
+	 */
+	if (umax_val > U16_MAX || dst_reg->u32_max_value > U16_MAX) {
+		/* Potential overflow, we know nothing */
+		__mark_reg32_unbounded(dst_reg);
+		return;
+	}
+	dst_reg->u32_min_value *= umin_val;
+	dst_reg->u32_max_value *= umax_val;
+	if (dst_reg->u32_max_value > S32_MAX) {
+		/* Overflow possible, we know nothing */
+		dst_reg->s32_min_value = S32_MIN;
+		dst_reg->s32_max_value = S32_MAX;
+	} else {
+		dst_reg->s32_min_value = dst_reg->u32_min_value;
+		dst_reg->s32_max_value = dst_reg->u32_max_value;
+	}
 }
 
 static void scalar_min_max_mul(struct bpf_reg_state *dst_reg,
@@ -4909,11 +5217,9 @@ static void scalar_min_max_mul(struct bpf_reg_state *dst_reg,
 	u64 umin_val = src_reg->umin_value;
 	u64 umax_val = src_reg->umax_value;
 
-	dst_reg->var_off = tnum_mul(dst_reg->var_off, src_reg->var_off);
 	if (smin_val < 0 || dst_reg->smin_value < 0) {
 		/* Ain't nobody got time to multiply that sign */
-		__mark_reg_unbounded(dst_reg);
-		__update_reg_bounds(dst_reg);
+		__mark_reg64_unbounded(dst_reg);
 		return;
 	}
 	/* Both values are positive, so we can work with unsigned and
@@ -4921,9 +5227,7 @@ static void scalar_min_max_mul(struct bpf_reg_state *dst_reg,
 	 */
 	if (umax_val > U32_MAX || dst_reg->umax_value > U32_MAX) {
 		/* Potential overflow, we know nothing */
-		__mark_reg_unbounded(dst_reg);
-		/* (except what we can learn from the var_off) */
-		__update_reg_bounds(dst_reg);
+		__mark_reg64_unbounded(dst_reg);
 		return;
 	}
 	dst_reg->umin_value *= umin_val;
@@ -4938,16 +5242,59 @@ static void scalar_min_max_mul(struct bpf_reg_state *dst_reg,
 	}
 }
 
+static void scalar32_min_max_and(struct bpf_reg_state *dst_reg,
+				 struct bpf_reg_state *src_reg)
+{
+	bool src_known = tnum_subreg_is_const(src_reg->var_off);
+	bool dst_known = tnum_subreg_is_const(dst_reg->var_off);
+	struct tnum var32_off = tnum_subreg(dst_reg->var_off);
+	s32 smin_val = src_reg->s32_min_value;
+	u32 umax_val = src_reg->u32_max_value;
+
+	/* Assuming scalar64_min_max_and will be called so its safe
+	 * to skip updating register for known 32-bit case.
+	 */
+	if (src_known && dst_known)
+		return;
+
+	/* We get our minimum from the var_off, since that's inherently
+	 * bitwise.  Our maximum is the minimum of the operands' maxima.
+	 */
+	dst_reg->u32_min_value = var32_off.value;
+	dst_reg->u32_max_value = min(dst_reg->u32_max_value, umax_val);
+	if (dst_reg->s32_min_value < 0 || smin_val < 0) {
+		/* Lose signed bounds when ANDing negative numbers,
+		 * ain't nobody got time for that.
+		 */
+		dst_reg->s32_min_value = S32_MIN;
+		dst_reg->s32_max_value = S32_MAX;
+	} else {
+		/* ANDing two positives gives a positive, so safe to
+		 * cast result into s64.
+		 */
+		dst_reg->s32_min_value = dst_reg->u32_min_value;
+		dst_reg->s32_max_value = dst_reg->u32_max_value;
+	}
+
+}
+
 static void scalar_min_max_and(struct bpf_reg_state *dst_reg,
 			       struct bpf_reg_state *src_reg)
 {
+	bool src_known = tnum_is_const(src_reg->var_off);
+	bool dst_known = tnum_is_const(dst_reg->var_off);
 	s64 smin_val = src_reg->smin_value;
 	u64 umax_val = src_reg->umax_value;
 
+	if (src_known && dst_known) {
+		__mark_reg_known(dst_reg, dst_reg->var_off.value &
+					  src_reg->var_off.value);
+		return;
+	}
+
 	/* We get our minimum from the var_off, since that's inherently
 	 * bitwise.  Our maximum is the minimum of the operands' maxima.
 	 */
-	dst_reg->var_off = tnum_and(dst_reg->var_off, src_reg->var_off);
 	dst_reg->umin_value = dst_reg->var_off.value;
 	dst_reg->umax_value = min(dst_reg->umax_value, umax_val);
 	if (dst_reg->smin_value < 0 || smin_val < 0) {
@@ -4967,16 +5314,58 @@ static void scalar_min_max_and(struct bpf_reg_state *dst_reg,
 	__update_reg_bounds(dst_reg);
 }
 
+static void scalar32_min_max_or(struct bpf_reg_state *dst_reg,
+				struct bpf_reg_state *src_reg)
+{
+	bool src_known = tnum_subreg_is_const(src_reg->var_off);
+	bool dst_known = tnum_subreg_is_const(dst_reg->var_off);
+	struct tnum var32_off = tnum_subreg(dst_reg->var_off);
+	s32 smin_val = src_reg->smin_value;
+	u32 umin_val = src_reg->umin_value;
+
+	/* Assuming scalar64_min_max_or will be called so it is safe
+	 * to skip updating register for known case.
+	 */
+	if (src_known && dst_known)
+		return;
+
+	/* We get our maximum from the var_off, and our minimum is the
+	 * maximum of the operands' minima
+	 */
+	dst_reg->u32_min_value = max(dst_reg->u32_min_value, umin_val);
+	dst_reg->u32_max_value = var32_off.value | var32_off.mask;
+	if (dst_reg->s32_min_value < 0 || smin_val < 0) {
+		/* Lose signed bounds when ORing negative numbers,
+		 * ain't nobody got time for that.
+		 */
+		dst_reg->s32_min_value = S32_MIN;
+		dst_reg->s32_max_value = S32_MAX;
+	} else {
+		/* ORing two positives gives a positive, so safe to
+		 * cast result into s64.
+		 */
+		dst_reg->s32_min_value = dst_reg->umin_value;
+		dst_reg->s32_max_value = dst_reg->umax_value;
+	}
+}
+
 static void scalar_min_max_or(struct bpf_reg_state *dst_reg,
 			      struct bpf_reg_state *src_reg)
 {
+	bool src_known = tnum_is_const(src_reg->var_off);
+	bool dst_known = tnum_is_const(dst_reg->var_off);
 	s64 smin_val = src_reg->smin_value;
 	u64 umin_val = src_reg->umin_value;
 
+	if (src_known && dst_known) {
+		__mark_reg_known(dst_reg, dst_reg->var_off.value |
+					  src_reg->var_off.value);
+		return;
+	}
+
 	/* We get our maximum from the var_off, and our minimum is the
 	 * maximum of the operands' minima
 	 */
-	dst_reg->var_off = tnum_or(dst_reg->var_off, src_reg->var_off);
 	dst_reg->umin_value = max(dst_reg->umin_value, umin_val);
 	dst_reg->umax_value = dst_reg->var_off.value | dst_reg->var_off.mask;
 	if (dst_reg->smin_value < 0 || smin_val < 0) {
@@ -4996,12 +5385,45 @@ static void scalar_min_max_or(struct bpf_reg_state *dst_reg,
 	__update_reg_bounds(dst_reg);
 }
 
-static void scalar_min_max_lsh(struct bpf_reg_state *dst_reg,
-			       struct bpf_reg_state *src_reg)
+static void __scalar32_min_max_lsh(struct bpf_reg_state *dst_reg,
+				   u64 umin_val, u64 umax_val)
 {
-	u64 umax_val = src_reg->umax_value;
-	u64 umin_val = src_reg->umin_value;
+	/* We lose all sign bit information (except what we can pick
+	 * up from var_off)
+	 */
+	dst_reg->s32_min_value = S32_MIN;
+	dst_reg->s32_max_value = S32_MAX;
+	/* If we might shift our top bit out, then we know nothing */
+	if (umax_val > 31 || dst_reg->u32_max_value > 1ULL << (31 - umax_val)) {
+		dst_reg->u32_min_value = 0;
+		dst_reg->u32_max_value = U32_MAX;
+	} else {
+		dst_reg->u32_min_value <<= umin_val;
+		dst_reg->u32_max_value <<= umax_val;
+	}
+}
 
+static void scalar32_min_max_lsh(struct bpf_reg_state *dst_reg,
+				 struct bpf_reg_state *src_reg)
+{
+	u32 umax_val = src_reg->u32_max_value;
+	u32 umin_val = src_reg->u32_min_value;
+	/* u32 alu operation will zext upper bits */
+	struct tnum subreg = tnum_subreg(dst_reg->var_off);
+
+	__scalar32_min_max_lsh(dst_reg, umin_val, umax_val);
+	dst_reg->var_off = tnum_subreg(tnum_lshift(subreg, umin_val));
+	/* Not required but being careful mark reg64 bounds as unknown so
+	 * that we are forced to pick them up from tnum and zext later and
+	 * if some path skips this step we are still safe.
+	 */
+	__mark_reg64_unbounded(dst_reg);
+	__update_reg32_bounds(dst_reg);
+}
+
+static void __scalar64_min_max_lsh(struct bpf_reg_state *dst_reg,
+				   u64 umin_val, u64 umax_val)
+{
 	/* We lose all sign bit information (except what we can pick
 	 * up from var_off)
 	 */
@@ -5015,11 +5437,55 @@ static void scalar_min_max_lsh(struct bpf_reg_state *dst_reg,
 		dst_reg->umin_value <<= umin_val;
 		dst_reg->umax_value <<= umax_val;
 	}
+}
+
+static void scalar_min_max_lsh(struct bpf_reg_state *dst_reg,
+			       struct bpf_reg_state *src_reg)
+{
+	u64 umax_val = src_reg->umax_value;
+	u64 umin_val = src_reg->umin_value;
+
+
+	__scalar32_min_max_lsh(dst_reg, umin_val, umax_val);
+	__scalar64_min_max_lsh(dst_reg, umin_val, umax_val);
+
 	dst_reg->var_off = tnum_lshift(dst_reg->var_off, umin_val);
 	/* We may learn something more from the var_off */
 	__update_reg_bounds(dst_reg);
 }
 
+static void scalar32_min_max_rsh(struct bpf_reg_state *dst_reg,
+				 struct bpf_reg_state *src_reg)
+{
+	struct tnum subreg = tnum_subreg(dst_reg->var_off);
+	u32 umax_val = src_reg->u32_max_value;
+	u32 umin_val = src_reg->u32_min_value;
+
+	/* BPF_RSH is an unsigned shift.  If the value in dst_reg might
+	 * be negative, then either:
+	 * 1) src_reg might be zero, so the sign bit of the result is
+	 *    unknown, so we lose our signed bounds
+	 * 2) it's known negative, thus the unsigned bounds capture the
+	 *    signed bounds
+	 * 3) the signed bounds cross zero, so they tell us nothing
+	 *    about the result
+	 * If the value in dst_reg is known nonnegative, then again the
+	 * unsigned bounts capture the signed bounds.
+	 * Thus, in all cases it suffices to blow away our signed bounds
+	 * and rely on inferring new ones from the unsigned bounds and
+	 * var_off of the result.
+	 */
+	dst_reg->s32_min_value = S32_MIN;
+	dst_reg->s32_max_value = S32_MAX;
+
+	dst_reg->var_off = tnum_rshift(subreg, umin_val);
+	dst_reg->u32_min_value >>= umax_val;
+	dst_reg->u32_max_value >>= umin_val;
+
+	__mark_reg64_unbounded(dst_reg);
+	__update_reg32_bounds(dst_reg);
+}
+
 static void scalar_min_max_rsh(struct bpf_reg_state *dst_reg,
 			       struct bpf_reg_state *src_reg)
 {
@@ -5045,35 +5511,62 @@ static void scalar_min_max_rsh(struct bpf_reg_state *dst_reg,
 	dst_reg->var_off = tnum_rshift(dst_reg->var_off, umin_val);
 	dst_reg->umin_value >>= umax_val;
 	dst_reg->umax_value >>= umin_val;
-	/* We may learn something more from the var_off */
+
+	/* Its not easy to operate on alu32 bounds here because it depends
+	 * on bits being shifted in. Take easy way out and mark unbounded
+	 * so we can recalculate later from tnum.
+	 */
+	__mark_reg32_unbounded(dst_reg);
 	__update_reg_bounds(dst_reg);
 }
 
-static void scalar_min_max_arsh(struct bpf_reg_state *dst_reg,
-			        struct bpf_reg_state *src_reg,
-				u64 insn_bitness)
+static void scalar32_min_max_arsh(struct bpf_reg_state *dst_reg,
+				  struct bpf_reg_state *src_reg)
 {
-	u64 umin_val = src_reg->umin_value;
+	u64 umin_val = src_reg->u32_min_value;
 
 	/* Upon reaching here, src_known is true and
 	 * umax_val is equal to umin_val.
 	 */
-	if (insn_bitness == 32) {
-		dst_reg->smin_value = (u32)(((s32)dst_reg->smin_value) >> umin_val);
-		dst_reg->smax_value = (u32)(((s32)dst_reg->smax_value) >> umin_val);
-	} else {
-		dst_reg->smin_value >>= umin_val;
-		dst_reg->smax_value >>= umin_val;
-	}
+	dst_reg->s32_min_value = (u32)(((s32)dst_reg->s32_min_value) >> umin_val);
+	dst_reg->s32_max_value = (u32)(((s32)dst_reg->s32_max_value) >> umin_val);
 
-	dst_reg->var_off = tnum_arshift(dst_reg->var_off, umin_val,
-					insn_bitness);
+	dst_reg->var_off = tnum_arshift(tnum_subreg(dst_reg->var_off), umin_val, 32);
+
+	/* blow away the dst_reg umin_value/umax_value and rely on
+	 * dst_reg var_off to refine the result.
+	 */
+	dst_reg->u32_min_value = 0;
+	dst_reg->u32_max_value = U32_MAX;
+
+	__mark_reg64_unbounded(dst_reg);
+	__update_reg32_bounds(dst_reg);
+}
+
+static void scalar_min_max_arsh(struct bpf_reg_state *dst_reg,
+			        struct bpf_reg_state *src_reg)
+{
+	u64 umin_val = src_reg->umin_value;
+
+	/* Upon reaching here, src_known is true and umax_val is equal
+	 * to umin_val.
+	 */
+	dst_reg->smin_value >>= umin_val;
+	dst_reg->smax_value >>= umin_val;
+
+	dst_reg->var_off = tnum_arshift(dst_reg->var_off, umin_val, 64);
 
 	/* blow away the dst_reg umin_value/umax_value and rely on
 	 * dst_reg var_off to refine the result.
 	 */
 	dst_reg->umin_value = 0;
 	dst_reg->umax_value = U64_MAX;
+
+	/* Its not easy to operate on alu32 bounds here because it depends
+	 * on bits being shifted in from upper 32-bits. Take easy way out
+	 * and mark unbounded so we can recalculate later from tnum.
+	 */
+	__mark_reg32_unbounded(dst_reg);
 	__update_reg_bounds(dst_reg);
 }
 
@@ -5091,33 +5584,47 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 	bool src_known, dst_known;
 	s64 smin_val, smax_val;
 	u64 umin_val, umax_val;
+	s32 s32_min_val, s32_max_val;
+	u32 u32_min_val, u32_max_val;
 	u64 insn_bitness = (BPF_CLASS(insn->code) == BPF_ALU64) ? 64 : 32;
 	u32 dst = insn->dst_reg;
 	int ret;
-
-	if (insn_bitness == 32) {
-		/* Relevant for 32-bit RSH: Information can propagate towards
-		 * LSB, so it isn't sufficient to only truncate the output to
-		 * 32 bits.
-		 */
-		coerce_reg_to_size(dst_reg, 4);
-		coerce_reg_to_size(&src_reg, 4);
-	}
+	bool alu32 = (BPF_CLASS(insn->code) != BPF_ALU64);
 
 	smin_val = src_reg.smin_value;
 	smax_val = src_reg.smax_value;
 	umin_val = src_reg.umin_value;
 	umax_val = src_reg.umax_value;
-	src_known = tnum_is_const(src_reg.var_off);
-	dst_known = tnum_is_const(dst_reg->var_off);
 
-	if ((src_known && (smin_val != smax_val || umin_val != umax_val)) ||
-	    smin_val > smax_val || umin_val > umax_val) {
-		/* Taint dst register if offset had invalid bounds derived from
-		 * e.g. dead branches.
-		 */
-		__mark_reg_unknown(env, dst_reg);
-		return 0;
+	s32_min_val = src_reg.s32_min_value;
+	s32_max_val = src_reg.s32_max_value;
+	u32_min_val = src_reg.u32_min_value;
+	u32_max_val = src_reg.u32_max_value;
+
+	if (alu32) {
+		src_known = tnum_subreg_is_const(src_reg.var_off);
+		dst_known = tnum_subreg_is_const(dst_reg->var_off);
+		if ((src_known &&
+		     (s32_min_val != s32_max_val || u32_min_val != u32_max_val)) ||
+		    s32_min_val > s32_max_val || u32_min_val > u32_max_val) {
+			/* Taint dst register if offset had invalid bounds derived from
+			 * e.g. dead branches.
+			 */
+			__mark_reg_unknown(env, dst_reg);
+			return 0;
+		}
+	} else {
+		src_known = tnum_is_const(src_reg.var_off);
+		dst_known = tnum_is_const(dst_reg->var_off);
+		if ((src_known &&
+		     (smin_val != smax_val || umin_val != umax_val)) ||
+		    smin_val > smax_val || umin_val > umax_val) {
+			/* Taint dst register if offset had invalid bounds derived from
+			 * e.g. dead branches.
+			 */
+			__mark_reg_unknown(env, dst_reg);
+			return 0;
+		}
 	}
 
 	if (!src_known &&
@@ -5126,6 +5633,20 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		return 0;
 	}
 
+	/* Calculate sign/unsigned bounds and tnum for alu32 and alu64 bit ops.
+	 * There are two classes of instructions: The first class we track both
+	 * alu32 and alu64 sign/unsigned bounds independently this provides the
+	 * greatest amount of precision when alu operations are mixed with jmp32
+	 * operations. These operations are BPF_ADD, BPF_SUB, BPF_MUL, BPF_ADD,
+	 * and BPF_OR. This is possible because these ops have fairly easy to
+	 * understand and calculate behavior in both 32-bit and 64-bit alu ops.
+	 * See alu32 verifier tests for examples. The second class of operations,
+	 * BPF_LSH, BPF_RSH, and BPF_ARSH, however are not so easy with regards
+	 * to tracking sign/unsigned bounds because the bits may cross subreg
+	 * boundaries in the alu64 case. When this happens we mark the reg
+	 * unbounded in the subreg bound space and use the resulting tnum to
+	 * calculate an approximation of the sign/unsigned bounds.
+	 */
 	switch (opcode) {
 	case BPF_ADD:
 		ret = sanitize_val_alu(env, insn);
@@ -5133,7 +5654,9 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 			verbose(env, "R%d tried to add from different pointers or scalars\n", dst);
 			return ret;
 		}
+		scalar32_min_max_add(dst_reg, &src_reg);
 		scalar_min_max_add(dst_reg, &src_reg);
+		dst_reg->var_off = tnum_add(dst_reg->var_off, src_reg.var_off);
 		break;
 	case BPF_SUB:
 		ret = sanitize_val_alu(env, insn);
@@ -5141,25 +5664,23 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 			verbose(env, "R%d tried to sub from different pointers or scalars\n", dst);
 			return ret;
 		}
+		scalar32_min_max_sub(dst_reg, &src_reg);
 		scalar_min_max_sub(dst_reg, &src_reg);
+		dst_reg->var_off = tnum_sub(dst_reg->var_off, src_reg.var_off);
 		break;
 	case BPF_MUL:
+		dst_reg->var_off = tnum_mul(dst_reg->var_off, src_reg.var_off);
+		scalar32_min_max_mul(dst_reg, &src_reg);
 		scalar_min_max_mul(dst_reg, &src_reg);
 		break;
 	case BPF_AND:
-		if (src_known && dst_known) {
-			__mark_reg_known(dst_reg, dst_reg->var_off.value &
-						  src_reg.var_off.value);
-			break;
-		}
+		dst_reg->var_off = tnum_and(dst_reg->var_off, src_reg.var_off);
+		scalar32_min_max_and(dst_reg, &src_reg);
 		scalar_min_max_and(dst_reg, &src_reg);
 		break;
 	case BPF_OR:
-		if (src_known && dst_known) {
-			__mark_reg_known(dst_reg, dst_reg->var_off.value |
-						  src_reg.var_off.value);
-			break;
-		}
+		dst_reg->var_off = tnum_or(dst_reg->var_off, src_reg.var_off);
+		scalar32_min_max_or(dst_reg, &src_reg);
 		scalar_min_max_or(dst_reg, &src_reg);
 		break;
 	case BPF_LSH:
@@ -5170,7 +5691,10 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 			mark_reg_unknown(env, regs, insn->dst_reg);
 			break;
 		}
-		scalar_min_max_lsh(dst_reg, &src_reg);
+		if (alu32)
+			scalar32_min_max_lsh(dst_reg, &src_reg);
+		else
+			scalar_min_max_lsh(dst_reg, &src_reg);
 		break;
 	case BPF_RSH:
 		if (umax_val >= insn_bitness) {
@@ -5180,7 +5704,10 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 			mark_reg_unknown(env, regs, insn->dst_reg);
 			break;
 		}
-		scalar_min_max_rsh(dst_reg, &src_reg);
+		if (alu32)
+			scalar32_min_max_rsh(dst_reg, &src_reg);
+		else
+			scalar_min_max_rsh(dst_reg, &src_reg);
 		break;
 	case BPF_ARSH:
 		if (umax_val >= insn_bitness) {
@@ -5190,17 +5717,19 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 			mark_reg_unknown(env, regs, insn->dst_reg);
 			break;
 		}
-		scalar_min_max_arsh(dst_reg, &src_reg, insn_bitness);
+		if (alu32)
+			scalar32_min_max_arsh(dst_reg, &src_reg);
+		else
+			scalar_min_max_arsh(dst_reg, &src_reg);
 		break;
 	default:
 		mark_reg_unknown(env, regs, insn->dst_reg);
 		break;
 	}
 
-	if (BPF_CLASS(insn->code) != BPF_ALU64) {
-		/* 32-bit ALU ops are (32,32)->32 */
-		coerce_reg_to_size(dst_reg, 4);
-	}
+	/* ALU32 ops are zero extended into 64bit register */
+	if (alu32)
+		zext_32_to_64(dst_reg);
 
 	__update_reg_bounds(dst_reg);
 	__reg_deduce_bounds(dst_reg);
@@ -5376,7 +5905,7 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 					mark_reg_unknown(env, regs,
 							 insn->dst_reg);
 				}
-				coerce_reg_to_size(dst_reg, 4);
+				zext_32_to_64(dst_reg);
 			}
 		} else {
 			/* case: R = imm
@@ -5546,55 +6075,83 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 					 new_range);
 }
 
-/* compute branch direction of the expression "if (reg opcode val) goto target;"
- * and return:
- *  1 - branch will be taken and "goto target" will be executed
- *  0 - branch will not be taken and fall-through to next insn
- * -1 - unknown. Example: "if (reg < 5)" is unknown when register value range [0,10]
- */
-static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
-			   bool is_jmp32)
+static int is_branch32_taken(struct bpf_reg_state *reg, u32 val, u8 opcode)
 {
-	struct bpf_reg_state reg_lo;
-	s64 sval;
+	struct tnum subreg = tnum_subreg(reg->var_off);
+	s32 sval = (s32)val;
 
-	if (__is_pointer_value(false, reg))
-		return -1;
+	switch (opcode) {
+	case BPF_JEQ:
+		if (tnum_is_const(subreg))
+			return !!tnum_equals_const(subreg, val);
+		break;
+	case BPF_JNE:
+		if (tnum_is_const(subreg))
+			return !tnum_equals_const(subreg, val);
+		break;
+	case BPF_JSET:
+		if ((~subreg.mask & subreg.value) & val)
+			return 1;
+		if (!((subreg.mask | subreg.value) & val))
+			return 0;
+		break;
+	case BPF_JGT:
+		if (reg->u32_min_value > val)
+			return 1;
+		else if (reg->u32_max_value <= val)
+			return 0;
+		break;
+	case BPF_JSGT:
+		if (reg->s32_min_value > sval)
+			return 1;
+		else if (reg->s32_max_value < sval)
+			return 0;
+		break;
+	case BPF_JLT:
+		if (reg->u32_max_value < val)
+			return 1;
+		else if (reg->u32_min_value >= val)
+			return 0;
+		break;
+	case BPF_JSLT:
+		if (reg->s32_max_value < sval)
+			return 1;
+		else if (reg->s32_min_value >= sval)
+			return 0;
+		break;
+	case BPF_JGE:
+		if (reg->u32_min_value >= val)
+			return 1;
+		else if (reg->u32_max_value < val)
+			return 0;
+		break;
+	case BPF_JSGE:
+		if (reg->s32_min_value >= sval)
+			return 1;
+		else if (reg->s32_max_value < sval)
+			return 0;
+		break;
+	case BPF_JLE:
+		if (reg->u32_max_value <= val)
+			return 1;
+		else if (reg->u32_min_value > val)
+			return 0;
+		break;
+	case BPF_JSLE:
+		if (reg->s32_max_value <= sval)
+			return 1;
+		else if (reg->s32_min_value > sval)
+			return 0;
+		break;
+	}
 
-	if (is_jmp32) {
-		reg_lo = *reg;
-		reg = &reg_lo;
-		/* For JMP32, only low 32 bits are compared, coerce_reg_to_size
-		 * could truncate high bits and update umin/umax according to
-		 * information of low bits.
-		 */
-		coerce_reg_to_size(reg, 4);
-		/* smin/smax need special handling. For example, after coerce,
-		 * if smin_value is 0x00000000ffffffffLL, the value is -1 when
-		 * used as operand to JMP32. It is a negative number from s32's
-		 * point of view, while it is a positive number when seen as
-		 * s64. The smin/smax are kept as s64, therefore, when used with
-		 * JMP32, they need to be transformed into s32, then sign
-		 * extended back to s64.
-		 *
-		 * Also, smin/smax were copied from umin/umax. If umin/umax has
-		 * different sign bit, then min/max relationship doesn't
-		 * maintain after casting into s32, for this case, set smin/smax
-		 * to safest range.
-		 */
-		if ((reg->umax_value ^ reg->umin_value) &
-		    (1ULL << 31)) {
-			reg->smin_value = S32_MIN;
-			reg->smax_value = S32_MAX;
-		}
-		reg->smin_value = (s64)(s32)reg->smin_value;
-		reg->smax_value = (s64)(s32)reg->smax_value;
+	return -1;
+}
 
-		val = (u32)val;
-		sval = (s64)(s32)val;
-	} else {
-		sval = (s64)val;
-	}
+
+static int is_branch64_taken(struct bpf_reg_state *reg, u64 val, u8 opcode)
+{
+	s64 sval = (s64)val;
 
 	switch (opcode) {
 	case BPF_JEQ:
@@ -5664,27 +6221,21 @@ static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
 	return -1;
 }
 
-/* Generate min value of the high 32-bit from TNUM info. */
-static u64 gen_hi_min(struct tnum var)
-{
-	return var.value & ~0xffffffffULL;
-}
-
-/* Generate max value of the high 32-bit from TNUM info. */
-static u64 gen_hi_max(struct tnum var)
-{
-	return (var.value | var.mask) & ~0xffffffffULL;
-}
-
-/* Return true if VAL is compared with a s64 sign extended from s32, and they
- * are with the same signedness.
+/* compute branch direction of the expression "if (reg opcode val) goto target;"
+ * and return:
+ *  1 - branch will be taken and "goto target" will be executed
+ *  0 - branch will not be taken and fall-through to next insn
+ * -1 - unknown. Example: "if (reg < 5)" is unknown when register value range [0,10]
  */
-static bool cmp_val_with_extended_s64(s64 sval, struct bpf_reg_state *reg)
+static int is_branch_taken(struct bpf_reg_state *reg, u64 val, u8 opcode,
+			   bool is_jmp32)
 {
-	return ((s32)sval >= 0 &&
-		reg->smin_value >= 0 && reg->smax_value <= S32_MAX) ||
-	       ((s32)sval < 0 &&
-		reg->smax_value <= 0 && reg->smin_value >= S32_MIN);
+	if (__is_pointer_value(false, reg))
+		return -1;
+
+	if (is_jmp32)
+		return is_branch32_taken(reg, val, opcode);
+	return is_branch64_taken(reg, val, opcode);
 }
 
 /* Adjusts the register min/max values in the case that the dst_reg is the
@@ -5693,10 +6244,16 @@ static bool cmp_val_with_extended_s64(s64 sval, struct bpf_reg_state *reg)
  * In JEQ/JNE cases we also adjust the var_off values.
  */
 static void reg_set_min_max(struct bpf_reg_state *true_reg,
-			    struct bpf_reg_state *false_reg, u64 val,
+			    struct bpf_reg_state *false_reg,
+			    u64 val, u32 val32,
 			    u8 opcode, bool is_jmp32)
 {
-	s64 sval;
+	struct tnum false_32off = tnum_subreg(false_reg->var_off);
+	struct tnum false_64off = false_reg->var_off;
+	struct tnum true_32off = tnum_subreg(true_reg->var_off);
+	struct tnum true_64off = true_reg->var_off;
+	s64 sval = (s64)val;
+	s32 sval32 = (s32)val32;
 
 	/* If the dst_reg is a pointer, we can't learn anything about its
 	 * variable offset from the compare (unless src_reg were a pointer into
@@ -5707,9 +6264,6 @@ static void reg_set_min_max(struct bpf_reg_state *true_reg,
 	if (__is_pointer_value(false, false_reg))
 		return;
 
-	val = is_jmp32 ? (u32)val : val;
-	sval = is_jmp32 ? (s64)(s32)val : (s64)val;
-
 	switch (opcode) {
 	case BPF_JEQ:
 	case BPF_JNE:
@@ -5721,115 +6275,138 @@ static void reg_set_min_max(struct bpf_reg_state *true_reg,
 		 * if it is true we know the value for sure. Likewise for
 		 * BPF_JNE.
 		 */
-		if (is_jmp32) {
-			u64 old_v = reg->var_off.value;
-			u64 hi_mask = ~0xffffffffULL;
-
-			reg->var_off.value = (old_v & hi_mask) | val;
-			reg->var_off.mask &= hi_mask;
-		} else {
+		if (is_jmp32)
+			__mark_reg32_known(reg, val32);
+		else
 			__mark_reg_known(reg, val);
-		}
 		break;
 	}
 	case BPF_JSET:
-		false_reg->var_off = tnum_and(false_reg->var_off,
-					      tnum_const(~val));
-		if (is_power_of_2(val))
-			true_reg->var_off = tnum_or(true_reg->var_off,
-						    tnum_const(val));
+		if (is_jmp32) {
+			false_32off = tnum_and(false_32off, tnum_const(~val32));
+			if (is_power_of_2(val32))
+				true_32off = tnum_or(true_32off,
+						     tnum_const(val32));
+		} else {
+			false_64off = tnum_and(false_64off, tnum_const(~val));
+			if (is_power_of_2(val))
+				true_64off = tnum_or(true_64off,
+						     tnum_const(val));
+		}
 		break;
 	case BPF_JGE:
 	case BPF_JGT:
 	{
-		u64 false_umax = opcode == BPF_JGT ? val    : val - 1;
-		u64 true_umin = opcode == BPF_JGT ? val + 1 : val;
-
 		if (is_jmp32) {
-			false_umax += gen_hi_max(false_reg->var_off);
-			true_umin += gen_hi_min(true_reg->var_off);
+			u32 false_umax = opcode == BPF_JGT ? val32  : val32 - 1;
+			u32 true_umin = opcode == BPF_JGT ? val32 + 1 : val32;
+
+			false_reg->u32_max_value = min(false_reg->u32_max_value,
+						       false_umax);
+			true_reg->u32_min_value = max(true_reg->u32_min_value,
+						      true_umin);
+		} else {
+			u64 false_umax = opcode == BPF_JGT ? val    : val - 1;
+			u64 true_umin = opcode == BPF_JGT ? val + 1 : val;
+
+			false_reg->umax_value = min(false_reg->umax_value, false_umax);
+			true_reg->umin_value = max(true_reg->umin_value, true_umin);
 		}
-		false_reg->umax_value = min(false_reg->umax_value, false_umax);
-		true_reg->umin_value = max(true_reg->umin_value, true_umin);
 		break;
 	}
 	case BPF_JSGE:
 	case BPF_JSGT:
 	{
-		s64 false_smax = opcode == BPF_JSGT ? sval    : sval - 1;
-		s64 true_smin = opcode == BPF_JSGT ? sval + 1 : sval;
+		if (is_jmp32) {
+			s32 false_smax = opcode == BPF_JSGT ? sval32    : sval32 - 1;
+			s32 true_smin = opcode == BPF_JSGT ? sval32 + 1 : sval32;
 
-		/* If the full s64 was not sign-extended from s32 then don't
-		 * deduct further info.
-		 */
-		if (is_jmp32 && !cmp_val_with_extended_s64(sval, false_reg))
-			break;
-		false_reg->smax_value = min(false_reg->smax_value, false_smax);
-		true_reg->smin_value = max(true_reg->smin_value, true_smin);
+			false_reg->s32_max_value = min(false_reg->s32_max_value, false_smax);
+			true_reg->s32_min_value = max(true_reg->s32_min_value, true_smin);
+		} else {
+			s64 false_smax = opcode == BPF_JSGT ? sval    : sval - 1;
+			s64 true_smin = opcode == BPF_JSGT ? sval + 1 : sval;
+
+			false_reg->smax_value = min(false_reg->smax_value, false_smax);
+			true_reg->smin_value = max(true_reg->smin_value, true_smin);
+		}
 		break;
 	}
 	case BPF_JLE:
 	case BPF_JLT:
 	{
-		u64 false_umin = opcode == BPF_JLT ? val    : val + 1;
-		u64 true_umax = opcode == BPF_JLT ? val - 1 : val;
-
 		if (is_jmp32) {
-			false_umin += gen_hi_min(false_reg->var_off);
-			true_umax += gen_hi_max(true_reg->var_off);
+			u32 false_umin = opcode == BPF_JLT ? val32  : val32 + 1;
+			u32 true_umax = opcode == BPF_JLT ? val32 - 1 : val32;
+
+			false_reg->u32_min_value = max(false_reg->u32_min_value,
+						       false_umin);
+			true_reg->u32_max_value = min(true_reg->u32_max_value,
+						      true_umax);
+		} else {
+			u64 false_umin = opcode == BPF_JLT ? val    : val + 1;
+			u64 true_umax = opcode == BPF_JLT ? val - 1 : val;
+
+			false_reg->umin_value = max(false_reg->umin_value, false_umin);
+			true_reg->umax_value = min(true_reg->umax_value, true_umax);
 		}
-		false_reg->umin_value = max(false_reg->umin_value, false_umin);
-		true_reg->umax_value = min(true_reg->umax_value, true_umax);
 		break;
 	}
 	case BPF_JSLE:
 	case BPF_JSLT:
 	{
-		s64 false_smin = opcode == BPF_JSLT ? sval    : sval + 1;
-		s64 true_smax = opcode == BPF_JSLT ? sval - 1 : sval;
+		if (is_jmp32) {
+			s32 false_smin = opcode == BPF_JSLT ? sval32    : sval32 + 1;
+			s32 true_smax = opcode == BPF_JSLT ? sval32 - 1 : sval32;
 
-		if (is_jmp32 && !cmp_val_with_extended_s64(sval, false_reg))
-			break;
-		false_reg->smin_value = max(false_reg->smin_value, false_smin);
-		true_reg->smax_value = min(true_reg->smax_value, true_smax);
+			false_reg->s32_min_value = max(false_reg->s32_min_value, false_smin);
+			true_reg->s32_max_value = min(true_reg->s32_max_value, true_smax);
+		} else {
+			s64 false_smin = opcode == BPF_JSLT ? sval    : sval + 1;
+			s64 true_smax = opcode == BPF_JSLT ? sval - 1 : sval;
+
+			false_reg->smin_value = max(false_reg->smin_value, false_smin);
+			true_reg->smax_value = min(true_reg->smax_value, true_smax);
+		}
 		break;
 	}
 	default:
 		break;
 	}
 
-	__reg_deduce_bounds(false_reg);
-	__reg_deduce_bounds(true_reg);
-	/* We might have learned some bits from the bounds. */
-	__reg_bound_offset(false_reg);
-	__reg_bound_offset(true_reg);
 	if (is_jmp32) {
-		__reg_bound_offset32(false_reg);
-		__reg_bound_offset32(true_reg);
+		false_reg->var_off = tnum_or(tnum_clear_subreg(false_64off),
+					     tnum_subreg(false_32off));
+		true_reg->var_off = tnum_or(tnum_clear_subreg(true_64off),
+					    tnum_subreg(true_32off));
+		__reg_combine_32_into_64(false_reg);
+		__reg_combine_32_into_64(true_reg);
+	} else {
+		false_reg->var_off = false_64off;
+		true_reg->var_off = true_64off;
+		__reg_combine_64_into_32(false_reg);
+		__reg_combine_64_into_32(true_reg);
 	}
-	/* Intersecting with the old var_off might have improved our bounds
-	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
-	 * then new var_off is (0; 0x7f...fc) which improves our umax.
-	 */
-	__update_reg_bounds(false_reg);
-	__update_reg_bounds(true_reg);
 }
 
 /* Same as above, but for the case that dst_reg holds a constant and src_reg is
  * the variable reg.
  */
 static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
-				struct bpf_reg_state *false_reg, u64 val,
+				struct bpf_reg_state *false_reg,
+				u64 val, u32 val32,
 				u8 opcode, bool is_jmp32)
 {
-	s64 sval;
+	struct tnum false_32off = tnum_subreg(false_reg->var_off);
+	struct tnum false_64off = false_reg->var_off;
+	struct tnum true_32off = tnum_subreg(true_reg->var_off);
+	struct tnum true_64off = true_reg->var_off;
+	s64 sval = (s64)val;
+	s32 sval32 = (s32)val32;
 
 	if (__is_pointer_value(false, false_reg))
 		return;
 
-	val = is_jmp32 ? (u32)val : val;
-	sval = is_jmp32 ? (s64)(s32)val : (s64)val;
-
 	switch (opcode) {
 	case BPF_JEQ:
 	case BPF_JNE:
@@ -5838,94 +6415,115 @@ static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
 			opcode == BPF_JEQ ? true_reg : false_reg;
 
 		if (is_jmp32) {
-			u64 old_v = reg->var_off.value;
-			u64 hi_mask = ~0xffffffffULL;
-
-			reg->var_off.value = (old_v & hi_mask) | val;
-			reg->var_off.mask &= hi_mask;
+			__mark_reg32_known(reg, val);
 		} else {
 			__mark_reg_known(reg, val);
 		}
 		break;
 	}
 	case BPF_JSET:
-		false_reg->var_off = tnum_and(false_reg->var_off,
-					      tnum_const(~val));
-		if (is_power_of_2(val))
-			true_reg->var_off = tnum_or(true_reg->var_off,
-						    tnum_const(val));
+		if (is_jmp32) {
+			false_32off = tnum_and(false_32off, tnum_const(~val32));
+			if (is_power_of_2(val32))
+				true_32off = tnum_or(true_32off,
+						     tnum_const(val32));
+		} else {
+			false_32off = tnum_and(false_32off,
+					       tnum_const(~val));
+			if (is_power_of_2(val))
+				true_32off = tnum_or(true_32off,
+						     tnum_const(val));
+		}
 		break;
 	case BPF_JGE:
 	case BPF_JGT:
 	{
-		u64 false_umin = opcode == BPF_JGT ? val    : val + 1;
-		u64 true_umax = opcode == BPF_JGT ? val - 1 : val;
-
 		if (is_jmp32) {
-			false_umin += gen_hi_min(false_reg->var_off);
-			true_umax += gen_hi_max(true_reg->var_off);
+			u32 false_umin = opcode == BPF_JGT ? val32  : val32 + 1;
+			u32 true_umax = opcode == BPF_JGT ? val32 - 1 : val32;
+
+			false_reg->u32_min_value = max(false_reg->u32_min_value, false_umin);
+			true_reg->u32_max_value = min(true_reg->u32_max_value, true_umax);
+		} else {
+			u64 false_umin = opcode == BPF_JGT ? val    : val + 1;
+			u64 true_umax = opcode == BPF_JGT ? val - 1 : val;
+
+			false_reg->umin_value = max(false_reg->umin_value, false_umin);
+			true_reg->umax_value = min(true_reg->umax_value, true_umax);
 		}
-		false_reg->umin_value = max(false_reg->umin_value, false_umin);
-		true_reg->umax_value = min(true_reg->umax_value, true_umax);
 		break;
 	}
 	case BPF_JSGE:
 	case BPF_JSGT:
 	{
-		s64 false_smin = opcode == BPF_JSGT ? sval    : sval + 1;
-		s64 true_smax = opcode == BPF_JSGT ? sval - 1 : sval;
+		if (is_jmp32) {
+			s32 false_smin = opcode == BPF_JSGT ? sval32    : sval32 + 1;
+			s32 true_smax = opcode == BPF_JSGT ? sval32 - 1 : sval32;
 
-		if (is_jmp32 && !cmp_val_with_extended_s64(sval, false_reg))
-			break;
-		false_reg->smin_value = max(false_reg->smin_value, false_smin);
-		true_reg->smax_value = min(true_reg->smax_value, true_smax);
+			false_reg->s32_min_value = max(false_reg->s32_min_value, false_smin);
+			true_reg->s32_max_value = min(true_reg->s32_max_value, true_smax);
+		} else {
+			s64 false_smin = opcode == BPF_JSGT ? sval    : sval + 1;
+			s64 true_smax = opcode == BPF_JSGT ? sval - 1 : sval;
+
+			false_reg->smin_value = max(false_reg->smin_value, false_smin);
+			true_reg->smax_value = min(true_reg->smax_value, true_smax);
+		}
 		break;
 	}
 	case BPF_JLE:
 	case BPF_JLT:
 	{
-		u64 false_umax = opcode == BPF_JLT ? val    : val - 1;
-		u64 true_umin = opcode == BPF_JLT ? val + 1 : val;
-
 		if (is_jmp32) {
-			false_umax += gen_hi_max(false_reg->var_off);
-			true_umin += gen_hi_min(true_reg->var_off);
+			u32 false_umax = opcode == BPF_JLT ? val32  : val32 - 1;
+			u32 true_umin = opcode == BPF_JLT ? val32 + 1 : val32;
+
+			false_reg->u32_max_value = min(false_reg->u32_max_value, false_umax);
+			true_reg->u32_min_value = max(true_reg->u32_min_value, true_umin);
+		} else {
+			u64 false_umax = opcode == BPF_JLT ? val    : val - 1;
+			u64 true_umin = opcode == BPF_JLT ? val + 1 : val;
+
+			false_reg->umax_value = min(false_reg->umax_value, false_umax);
+			true_reg->umin_value = max(true_reg->umin_value, true_umin);
 		}
-		false_reg->umax_value = min(false_reg->umax_value, false_umax);
-		true_reg->umin_value = max(true_reg->umin_value, true_umin);
 		break;
 	}
 	case BPF_JSLE:
 	case BPF_JSLT:
 	{
-		s64 false_smax = opcode == BPF_JSLT ? sval    : sval - 1;
-		s64 true_smin = opcode == BPF_JSLT ? sval + 1 : sval;
+		if (is_jmp32) {
+			s32 false_smax = opcode == BPF_JSLT ? sval32    : sval32 - 1;
+			s32 true_smin = opcode == BPF_JSLT ? sval32 + 1 : sval32;
 
-		if (is_jmp32 && !cmp_val_with_extended_s64(sval, false_reg))
-			break;
-		false_reg->smax_value = min(false_reg->smax_value, false_smax);
-		true_reg->smin_value = max(true_reg->smin_value, true_smin);
+			false_reg->s32_max_value = min(false_reg->s32_max_value, false_smax);
+			true_reg->s32_min_value = max(true_reg->s32_min_value, true_smin);
+		} else {
+			s64 false_smax = opcode == BPF_JSLT ? sval    : sval - 1;
+			s64 true_smin = opcode == BPF_JSLT ? sval + 1 : sval;
+
+			false_reg->smax_value = min(false_reg->smax_value, false_smax);
+			true_reg->smin_value = max(true_reg->smin_value, true_smin);
+		}
 		break;
 	}
 	default:
 		break;
 	}
 
-	__reg_deduce_bounds(false_reg);
-	__reg_deduce_bounds(true_reg);
-	/* We might have learned some bits from the bounds. */
-	__reg_bound_offset(false_reg);
-	__reg_bound_offset(true_reg);
 	if (is_jmp32) {
-		__reg_bound_offset32(false_reg);
-		__reg_bound_offset32(true_reg);
+		false_reg->var_off = tnum_or(tnum_clear_subreg(false_64off),
+					     tnum_subreg(false_32off));
+		true_reg->var_off = tnum_or(tnum_clear_subreg(true_64off),
+					    tnum_subreg(true_32off));
+		__reg_combine_32_into_64(false_reg);
+		__reg_combine_32_into_64(true_reg);
+	} else {
+		false_reg->var_off = false_64off;
+		true_reg->var_off = true_64off;
+		__reg_combine_64_into_32(false_reg);
+		__reg_combine_64_into_32(true_reg);
 	}
-	/* Intersecting with the old var_off might have improved our bounds
-	 * slightly.  e.g. if umax was 0x7f...f and var_off was (0; 0xf...fc),
-	 * then new var_off is (0; 0x7f...fc) which improves our umax.
-	 */
-	__update_reg_bounds(false_reg);
-	__update_reg_bounds(true_reg);
 }
 
 /* Regs are known to be equal, so intersect their min/max/var_off */
@@ -6214,13 +6812,14 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	dst_reg = &regs[insn->dst_reg];
 	is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
 
-	if (BPF_SRC(insn->code) == BPF_K)
-		pred = is_branch_taken(dst_reg, insn->imm,
-				       opcode, is_jmp32);
-	else if (src_reg->type == SCALAR_VALUE &&
-		 tnum_is_const(src_reg->var_off))
-		pred = is_branch_taken(dst_reg, src_reg->var_off.value,
-				       opcode, is_jmp32);
+	if (BPF_SRC(insn->code) == BPF_K) {
+		pred = is_branch_taken(dst_reg, insn->imm, opcode, is_jmp32);
+	} else if (src_reg->type == SCALAR_VALUE && is_jmp32 && tnum_is_const(tnum_subreg(src_reg->var_off))) {
+		pred = is_branch_taken(dst_reg, tnum_subreg(src_reg->var_off).value, opcode, is_jmp32);
+	} else if (src_reg->type == SCALAR_VALUE && !is_jmp32 && tnum_is_const(src_reg->var_off)) {
+		pred = is_branch_taken(dst_reg, src_reg->var_off.value, opcode, is_jmp32);
+	}
+
 	if (pred >= 0) {
 		err = mark_chain_precision(env, insn->dst_reg);
 		if (BPF_SRC(insn->code) == BPF_X && !err)
@@ -6254,32 +6853,22 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	 */
 	if (BPF_SRC(insn->code) == BPF_X) {
 		struct bpf_reg_state *src_reg = &regs[insn->src_reg];
-		struct bpf_reg_state lo_reg0 = *dst_reg;
-		struct bpf_reg_state lo_reg1 = *src_reg;
-		struct bpf_reg_state *src_lo, *dst_lo;
-
-		dst_lo = &lo_reg0;
-		src_lo = &lo_reg1;
-		coerce_reg_to_size(dst_lo, 4);
-		coerce_reg_to_size(src_lo, 4);
 
 		if (dst_reg->type == SCALAR_VALUE &&
 		    src_reg->type == SCALAR_VALUE) {
 			if (tnum_is_const(src_reg->var_off) ||
-			    (is_jmp32 && tnum_is_const(src_lo->var_off)))
+			    (is_jmp32 && tnum_is_const(tnum_subreg(src_reg->var_off))))
 				reg_set_min_max(&other_branch_regs[insn->dst_reg],
 						dst_reg,
-						is_jmp32
-						? src_lo->var_off.value
-						: src_reg->var_off.value,
+						src_reg->var_off.value,
+						tnum_subreg(src_reg->var_off).value,
 						opcode, is_jmp32);
 			else if (tnum_is_const(dst_reg->var_off) ||
-				 (is_jmp32 && tnum_is_const(dst_lo->var_off)))
+				 (is_jmp32 && tnum_is_const(tnum_subreg(dst_reg->var_off))))
 				reg_set_min_max_inv(&other_branch_regs[insn->src_reg],
 						    src_reg,
-						    is_jmp32
-						    ? dst_lo->var_off.value
-						    : dst_reg->var_off.value,
+						    dst_reg->var_off.value,
+						    tnum_subreg(dst_reg->var_off).value,
 						    opcode, is_jmp32);
 			else if (!is_jmp32 &&
 				 (opcode == BPF_JEQ || opcode == BPF_JNE))
@@ -6290,7 +6879,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 		}
 	} else if (dst_reg->type == SCALAR_VALUE) {
 		reg_set_min_max(&other_branch_regs[insn->dst_reg],
-					dst_reg, insn->imm, opcode, is_jmp32);
+					dst_reg, insn->imm, (u32)insn->imm,
+					opcode, is_jmp32);
 	}
 
 	/* detect if R == 0 where R is returned from bpf_map_lookup_elem().

