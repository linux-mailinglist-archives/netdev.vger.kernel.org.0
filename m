Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA41917CB
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgCXRid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:38:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33330 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:38:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id j1so6959357pfe.0;
        Tue, 24 Mar 2020 10:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=WTCXwSsC7t7WD/G15nSkk8o9lACVYGriK/Rn9p7mHlU=;
        b=jcRPSsTe/WZcuTmKN4MYnoTlHFXwRyHO9DqWyWulPfh6a3l2/YRtos0+RidwjG0ity
         5U7lH1aY/qYlTh39+4jjE/uRagto+L1CD+DXO2x04LIj6uuN2C5uGsXsqvrRkuc3gBuo
         oJ1KPMS/wombzA2w9ZP07On1QNw7MOQ6kn7AAR+ONyr9GdjCmrssyiRoCR33QSvBEgKx
         gC0FggQl2yRFXOOP5d5WcMJ99JZso6X0zRSAoFk1v3czJ6QT85daC3Q6z1UCK7t1K9gP
         B3R8m7UbKjbTy51wvfZtEAZwo0+/aQQaaUyMAhgM3MrxqNVPlmUGzo54cvJA/sPz/rhC
         eL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WTCXwSsC7t7WD/G15nSkk8o9lACVYGriK/Rn9p7mHlU=;
        b=o0kMqRjflqCzkm6aXqM9wF0UiwrmUSLwenQHlAij5Xp/YBZB3kYpNIynBTCNL+nnyk
         xFsGOTdT3+N67OqLVr8TAAOTAqOV53O4/zUgZtsGDuXSCIMWQhnWBZ5Nhhqw4tiZ0Cqb
         VPMYnKjDKwbfxgKxmJ7nnLhPF5nZPu3T2lKGE4BqHEIm5saWzhjFHUamRbiOHMZxWPVt
         2GZlznoNyWLg28kY58JHHgZ+u0YPs3roA1jxEiDozOS1JrLOcGELYmQdR/plSlLz1I7x
         kCmxvCLrAydhMaOXuXQKvrQ5iCkvb8td8dlO6BxK7oU9yaSdsCjXNwtU77Q14ZaCV2KL
         iDLQ==
X-Gm-Message-State: ANhLgQ2gDgydhNCErBaCGXV9SIZNnyt7iDqmztzOvlaBpkTovPUyHK2k
        8G17nDArCXjPHoXlqX5RUQU=
X-Google-Smtp-Source: ADFU+vumqVtp5NBvhKclo4L0rSd0BhbIGzAwPKqIFkRnQtytflvMomAGdljmo2X5B+VDCeySdigfwA==
X-Received: by 2002:a62:7911:: with SMTP id u17mr29809666pfc.305.1585071509518;
        Tue, 24 Mar 2020 10:38:29 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c207sm16445517pfb.47.2020.03.24.10.38.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:38:29 -0700 (PDT)
Subject: [bpf-next PATCH 02/10] bpf: verifer,
 refactor adjust_scalar_min_max_vals
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:38:15 -0700
Message-ID: <158507149518.15666.15672349629329072411.stgit@john-Precision-5820-Tower>
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

Pull per op ALU logic into individual functions. We are about to add
u32 versions of each of these by pull them out the code gets a bit
more readable here and nicer in the next patch.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/verifier.c |  403 +++++++++++++++++++++++++++++--------------------
 1 file changed, 239 insertions(+), 164 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 57d3351..f7a34b1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4846,6 +4846,237 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static void scalar_min_max_add(struct bpf_reg_state *dst_reg,
+			       struct bpf_reg_state *src_reg)
+{
+	s64 smin_val = src_reg->smin_value;
+	s64 smax_val = src_reg->smax_value;
+	u64 umin_val = src_reg->umin_value;
+	u64 umax_val = src_reg->umax_value;
+
+	if (signed_add_overflows(dst_reg->smin_value, smin_val) ||
+	    signed_add_overflows(dst_reg->smax_value, smax_val)) {
+		dst_reg->smin_value = S64_MIN;
+		dst_reg->smax_value = S64_MAX;
+	} else {
+		dst_reg->smin_value += smin_val;
+		dst_reg->smax_value += smax_val;
+	}
+	if (dst_reg->umin_value + umin_val < umin_val ||
+	    dst_reg->umax_value + umax_val < umax_val) {
+		dst_reg->umin_value = 0;
+		dst_reg->umax_value = U64_MAX;
+	} else {
+		dst_reg->umin_value += umin_val;
+		dst_reg->umax_value += umax_val;
+	}
+	dst_reg->var_off = tnum_add(dst_reg->var_off, src_reg->var_off);
+}
+
+static void scalar_min_max_sub(struct bpf_reg_state *dst_reg,
+			       struct bpf_reg_state *src_reg)
+{
+	s64 smin_val = src_reg->smin_value;
+	s64 smax_val = src_reg->smax_value;
+	u64 umin_val = src_reg->umin_value;
+	u64 umax_val = src_reg->umax_value;
+
+	if (signed_sub_overflows(dst_reg->smin_value, smax_val) ||
+	    signed_sub_overflows(dst_reg->smax_value, smin_val)) {
+		/* Overflow possible, we know nothing */
+		dst_reg->smin_value = S64_MIN;
+		dst_reg->smax_value = S64_MAX;
+	} else {
+		dst_reg->smin_value -= smax_val;
+		dst_reg->smax_value -= smin_val;
+	}
+	if (dst_reg->umin_value < umax_val) {
+		/* Overflow possible, we know nothing */
+		dst_reg->umin_value = 0;
+		dst_reg->umax_value = U64_MAX;
+	} else {
+		/* Cannot overflow (as long as bounds are consistent) */
+		dst_reg->umin_value -= umax_val;
+		dst_reg->umax_value -= umin_val;
+	}
+	dst_reg->var_off = tnum_sub(dst_reg->var_off, src_reg->var_off);
+}
+
+static void scalar_min_max_mul(struct bpf_reg_state *dst_reg,
+			       struct bpf_reg_state *src_reg)
+{
+	s64 smin_val = src_reg->smin_value;
+	u64 umin_val = src_reg->umin_value;
+	u64 umax_val = src_reg->umax_value;
+
+	dst_reg->var_off = tnum_mul(dst_reg->var_off, src_reg->var_off);
+	if (smin_val < 0 || dst_reg->smin_value < 0) {
+		/* Ain't nobody got time to multiply that sign */
+		__mark_reg_unbounded(dst_reg);
+		__update_reg_bounds(dst_reg);
+		return;
+	}
+	/* Both values are positive, so we can work with unsigned and
+	 * copy the result to signed (unless it exceeds S64_MAX).
+	 */
+	if (umax_val > U32_MAX || dst_reg->umax_value > U32_MAX) {
+		/* Potential overflow, we know nothing */
+		__mark_reg_unbounded(dst_reg);
+		/* (except what we can learn from the var_off) */
+		__update_reg_bounds(dst_reg);
+		return;
+	}
+	dst_reg->umin_value *= umin_val;
+	dst_reg->umax_value *= umax_val;
+	if (dst_reg->umax_value > S64_MAX) {
+		/* Overflow possible, we know nothing */
+		dst_reg->smin_value = S64_MIN;
+		dst_reg->smax_value = S64_MAX;
+	} else {
+		dst_reg->smin_value = dst_reg->umin_value;
+		dst_reg->smax_value = dst_reg->umax_value;
+	}
+}
+
+static void scalar_min_max_and(struct bpf_reg_state *dst_reg,
+			       struct bpf_reg_state *src_reg)
+{
+	s64 smin_val = src_reg->smin_value;
+	u64 umax_val = src_reg->umax_value;
+
+	/* We get our minimum from the var_off, since that's inherently
+	 * bitwise.  Our maximum is the minimum of the operands' maxima.
+	 */
+	dst_reg->var_off = tnum_and(dst_reg->var_off, src_reg->var_off);
+	dst_reg->umin_value = dst_reg->var_off.value;
+	dst_reg->umax_value = min(dst_reg->umax_value, umax_val);
+	if (dst_reg->smin_value < 0 || smin_val < 0) {
+		/* Lose signed bounds when ANDing negative numbers,
+		 * ain't nobody got time for that.
+		 */
+		dst_reg->smin_value = S64_MIN;
+		dst_reg->smax_value = S64_MAX;
+	} else {
+		/* ANDing two positives gives a positive, so safe to
+		 * cast result into s64.
+		 */
+		dst_reg->smin_value = dst_reg->umin_value;
+		dst_reg->smax_value = dst_reg->umax_value;
+	}
+	/* We may learn something more from the var_off */
+	__update_reg_bounds(dst_reg);
+}
+
+static void scalar_min_max_or(struct bpf_reg_state *dst_reg,
+			      struct bpf_reg_state *src_reg)
+{
+	s64 smin_val = src_reg->smin_value;
+	u64 umin_val = src_reg->umin_value;
+
+	/* We get our maximum from the var_off, and our minimum is the
+	 * maximum of the operands' minima
+	 */
+	dst_reg->var_off = tnum_or(dst_reg->var_off, src_reg->var_off);
+	dst_reg->umin_value = max(dst_reg->umin_value, umin_val);
+	dst_reg->umax_value = dst_reg->var_off.value | dst_reg->var_off.mask;
+	if (dst_reg->smin_value < 0 || smin_val < 0) {
+		/* Lose signed bounds when ORing negative numbers,
+		 * ain't nobody got time for that.
+		 */
+		dst_reg->smin_value = S64_MIN;
+		dst_reg->smax_value = S64_MAX;
+	} else {
+		/* ORing two positives gives a positive, so safe to
+		 * cast result into s64.
+		 */
+		dst_reg->smin_value = dst_reg->umin_value;
+		dst_reg->smax_value = dst_reg->umax_value;
+	}
+	/* We may learn something more from the var_off */
+	__update_reg_bounds(dst_reg);
+}
+
+static void scalar_min_max_lsh(struct bpf_reg_state *dst_reg,
+			       struct bpf_reg_state *src_reg)
+{
+	u64 umax_val = src_reg->umax_value;
+	u64 umin_val = src_reg->umin_value;
+
+	/* We lose all sign bit information (except what we can pick
+	 * up from var_off)
+	 */
+	dst_reg->smin_value = S64_MIN;
+	dst_reg->smax_value = S64_MAX;
+	/* If we might shift our top bit out, then we know nothing */
+	if (dst_reg->umax_value > 1ULL << (63 - umax_val)) {
+		dst_reg->umin_value = 0;
+		dst_reg->umax_value = U64_MAX;
+	} else {
+		dst_reg->umin_value <<= umin_val;
+		dst_reg->umax_value <<= umax_val;
+	}
+	dst_reg->var_off = tnum_lshift(dst_reg->var_off, umin_val);
+	/* We may learn something more from the var_off */
+	__update_reg_bounds(dst_reg);
+}
+
+static void scalar_min_max_rsh(struct bpf_reg_state *dst_reg,
+			       struct bpf_reg_state *src_reg)
+{
+	u64 umax_val = src_reg->umax_value;
+	u64 umin_val = src_reg->umin_value;
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
+	dst_reg->smin_value = S64_MIN;
+	dst_reg->smax_value = S64_MAX;
+	dst_reg->var_off = tnum_rshift(dst_reg->var_off, umin_val);
+	dst_reg->umin_value >>= umax_val;
+	dst_reg->umax_value >>= umin_val;
+	/* We may learn something more from the var_off */
+	__update_reg_bounds(dst_reg);
+}
+
+static void scalar_min_max_arsh(struct bpf_reg_state *dst_reg,
+			        struct bpf_reg_state *src_reg,
+				u64 insn_bitness)
+{
+	u64 umin_val = src_reg->umin_value;
+
+	/* Upon reaching here, src_known is true and
+	 * umax_val is equal to umin_val.
+	 */
+	if (insn_bitness == 32) {
+		dst_reg->smin_value = (u32)(((s32)dst_reg->smin_value) >> umin_val);
+		dst_reg->smax_value = (u32)(((s32)dst_reg->smax_value) >> umin_val);
+	} else {
+		dst_reg->smin_value >>= umin_val;
+		dst_reg->smax_value >>= umin_val;
+	}
+
+	dst_reg->var_off = tnum_arshift(dst_reg->var_off, umin_val,
+					insn_bitness);
+
+	/* blow away the dst_reg umin_value/umax_value and rely on
+	 * dst_reg var_off to refine the result.
+	 */
+	dst_reg->umin_value = 0;
+	dst_reg->umax_value = U64_MAX;
+	__update_reg_bounds(dst_reg);
+}
+
 /* WARNING: This function does calculations on 64-bit values, but the actual
  * execution may occur on 32-bit values. Therefore, things like bitshifts
  * need extra checks in the 32-bit case.
@@ -4902,23 +5133,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 			verbose(env, "R%d tried to add from different pointers or scalars\n", dst);
 			return ret;
 		}
-		if (signed_add_overflows(dst_reg->smin_value, smin_val) ||
-		    signed_add_overflows(dst_reg->smax_value, smax_val)) {
-			dst_reg->smin_value = S64_MIN;
-			dst_reg->smax_value = S64_MAX;
-		} else {
-			dst_reg->smin_value += smin_val;
-			dst_reg->smax_value += smax_val;
-		}
-		if (dst_reg->umin_value + umin_val < umin_val ||
-		    dst_reg->umax_value + umax_val < umax_val) {
-			dst_reg->umin_value = 0;
-			dst_reg->umax_value = U64_MAX;
-		} else {
-			dst_reg->umin_value += umin_val;
-			dst_reg->umax_value += umax_val;
-		}
-		dst_reg->var_off = tnum_add(dst_reg->var_off, src_reg.var_off);
+		scalar_min_max_add(dst_reg, &src_reg);
 		break;
 	case BPF_SUB:
 		ret = sanitize_val_alu(env, insn);
@@ -4926,54 +5141,10 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 			verbose(env, "R%d tried to sub from different pointers or scalars\n", dst);
 			return ret;
 		}
-		if (signed_sub_overflows(dst_reg->smin_value, smax_val) ||
-		    signed_sub_overflows(dst_reg->smax_value, smin_val)) {
-			/* Overflow possible, we know nothing */
-			dst_reg->smin_value = S64_MIN;
-			dst_reg->smax_value = S64_MAX;
-		} else {
-			dst_reg->smin_value -= smax_val;
-			dst_reg->smax_value -= smin_val;
-		}
-		if (dst_reg->umin_value < umax_val) {
-			/* Overflow possible, we know nothing */
-			dst_reg->umin_value = 0;
-			dst_reg->umax_value = U64_MAX;
-		} else {
-			/* Cannot overflow (as long as bounds are consistent) */
-			dst_reg->umin_value -= umax_val;
-			dst_reg->umax_value -= umin_val;
-		}
-		dst_reg->var_off = tnum_sub(dst_reg->var_off, src_reg.var_off);
+		scalar_min_max_sub(dst_reg, &src_reg);
 		break;
 	case BPF_MUL:
-		dst_reg->var_off = tnum_mul(dst_reg->var_off, src_reg.var_off);
-		if (smin_val < 0 || dst_reg->smin_value < 0) {
-			/* Ain't nobody got time to multiply that sign */
-			__mark_reg_unbounded(dst_reg);
-			__update_reg_bounds(dst_reg);
-			break;
-		}
-		/* Both values are positive, so we can work with unsigned and
-		 * copy the result to signed (unless it exceeds S64_MAX).
-		 */
-		if (umax_val > U32_MAX || dst_reg->umax_value > U32_MAX) {
-			/* Potential overflow, we know nothing */
-			__mark_reg_unbounded(dst_reg);
-			/* (except what we can learn from the var_off) */
-			__update_reg_bounds(dst_reg);
-			break;
-		}
-		dst_reg->umin_value *= umin_val;
-		dst_reg->umax_value *= umax_val;
-		if (dst_reg->umax_value > S64_MAX) {
-			/* Overflow possible, we know nothing */
-			dst_reg->smin_value = S64_MIN;
-			dst_reg->smax_value = S64_MAX;
-		} else {
-			dst_reg->smin_value = dst_reg->umin_value;
-			dst_reg->smax_value = dst_reg->umax_value;
-		}
+		scalar_min_max_mul(dst_reg, &src_reg);
 		break;
 	case BPF_AND:
 		if (src_known && dst_known) {
@@ -4981,27 +5152,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 						  src_reg.var_off.value);
 			break;
 		}
-		/* We get our minimum from the var_off, since that's inherently
-		 * bitwise.  Our maximum is the minimum of the operands' maxima.
-		 */
-		dst_reg->var_off = tnum_and(dst_reg->var_off, src_reg.var_off);
-		dst_reg->umin_value = dst_reg->var_off.value;
-		dst_reg->umax_value = min(dst_reg->umax_value, umax_val);
-		if (dst_reg->smin_value < 0 || smin_val < 0) {
-			/* Lose signed bounds when ANDing negative numbers,
-			 * ain't nobody got time for that.
-			 */
-			dst_reg->smin_value = S64_MIN;
-			dst_reg->smax_value = S64_MAX;
-		} else {
-			/* ANDing two positives gives a positive, so safe to
-			 * cast result into s64.
-			 */
-			dst_reg->smin_value = dst_reg->umin_value;
-			dst_reg->smax_value = dst_reg->umax_value;
-		}
-		/* We may learn something more from the var_off */
-		__update_reg_bounds(dst_reg);
+		scalar_min_max_and(dst_reg, &src_reg);
 		break;
 	case BPF_OR:
 		if (src_known && dst_known) {
@@ -5009,28 +5160,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 						  src_reg.var_off.value);
 			break;
 		}
-		/* We get our maximum from the var_off, and our minimum is the
-		 * maximum of the operands' minima
-		 */
-		dst_reg->var_off = tnum_or(dst_reg->var_off, src_reg.var_off);
-		dst_reg->umin_value = max(dst_reg->umin_value, umin_val);
-		dst_reg->umax_value = dst_reg->var_off.value |
-				      dst_reg->var_off.mask;
-		if (dst_reg->smin_value < 0 || smin_val < 0) {
-			/* Lose signed bounds when ORing negative numbers,
-			 * ain't nobody got time for that.
-			 */
-			dst_reg->smin_value = S64_MIN;
-			dst_reg->smax_value = S64_MAX;
-		} else {
-			/* ORing two positives gives a positive, so safe to
-			 * cast result into s64.
-			 */
-			dst_reg->smin_value = dst_reg->umin_value;
-			dst_reg->smax_value = dst_reg->umax_value;
-		}
-		/* We may learn something more from the var_off */
-		__update_reg_bounds(dst_reg);
+		scalar_min_max_or(dst_reg, &src_reg);
 		break;
 	case BPF_LSH:
 		if (umax_val >= insn_bitness) {
@@ -5040,22 +5170,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 			mark_reg_unknown(env, regs, insn->dst_reg);
 			break;
 		}
-		/* We lose all sign bit information (except what we can pick
-		 * up from var_off)
-		 */
-		dst_reg->smin_value = S64_MIN;
-		dst_reg->smax_value = S64_MAX;
-		/* If we might shift our top bit out, then we know nothing */
-		if (dst_reg->umax_value > 1ULL << (63 - umax_val)) {
-			dst_reg->umin_value = 0;
-			dst_reg->umax_value = U64_MAX;
-		} else {
-			dst_reg->umin_value <<= umin_val;
-			dst_reg->umax_value <<= umax_val;
-		}
-		dst_reg->var_off = tnum_lshift(dst_reg->var_off, umin_val);
-		/* We may learn something more from the var_off */
-		__update_reg_bounds(dst_reg);
+		scalar_min_max_lsh(dst_reg, &src_reg);
 		break;
 	case BPF_RSH:
 		if (umax_val >= insn_bitness) {
@@ -5065,27 +5180,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 			mark_reg_unknown(env, regs, insn->dst_reg);
 			break;
 		}
-		/* BPF_RSH is an unsigned shift.  If the value in dst_reg might
-		 * be negative, then either:
-		 * 1) src_reg might be zero, so the sign bit of the result is
-		 *    unknown, so we lose our signed bounds
-		 * 2) it's known negative, thus the unsigned bounds capture the
-		 *    signed bounds
-		 * 3) the signed bounds cross zero, so they tell us nothing
-		 *    about the result
-		 * If the value in dst_reg is known nonnegative, then again the
-		 * unsigned bounts capture the signed bounds.
-		 * Thus, in all cases it suffices to blow away our signed bounds
-		 * and rely on inferring new ones from the unsigned bounds and
-		 * var_off of the result.
-		 */
-		dst_reg->smin_value = S64_MIN;
-		dst_reg->smax_value = S64_MAX;
-		dst_reg->var_off = tnum_rshift(dst_reg->var_off, umin_val);
-		dst_reg->umin_value >>= umax_val;
-		dst_reg->umax_value >>= umin_val;
-		/* We may learn something more from the var_off */
-		__update_reg_bounds(dst_reg);
+		scalar_min_max_rsh(dst_reg, &src_reg);
 		break;
 	case BPF_ARSH:
 		if (umax_val >= insn_bitness) {
@@ -5095,27 +5190,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 			mark_reg_unknown(env, regs, insn->dst_reg);
 			break;
 		}
-
-		/* Upon reaching here, src_known is true and
-		 * umax_val is equal to umin_val.
-		 */
-		if (insn_bitness == 32) {
-			dst_reg->smin_value = (u32)(((s32)dst_reg->smin_value) >> umin_val);
-			dst_reg->smax_value = (u32)(((s32)dst_reg->smax_value) >> umin_val);
-		} else {
-			dst_reg->smin_value >>= umin_val;
-			dst_reg->smax_value >>= umin_val;
-		}
-
-		dst_reg->var_off = tnum_arshift(dst_reg->var_off, umin_val,
-						insn_bitness);
-
-		/* blow away the dst_reg umin_value/umax_value and rely on
-		 * dst_reg var_off to refine the result.
-		 */
-		dst_reg->umin_value = 0;
-		dst_reg->umax_value = U64_MAX;
-		__update_reg_bounds(dst_reg);
+		scalar_min_max_arsh(dst_reg, &src_reg, insn_bitness);
 		break;
 	default:
 		mark_reg_unknown(env, regs, insn->dst_reg);

