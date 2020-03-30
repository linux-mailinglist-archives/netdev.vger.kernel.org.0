Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 678D9198070
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbgC3QDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:03:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:56126 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729994AbgC3QDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:03:41 -0400
Received: from 98.186.195.178.dynamic.wline.res.cust.swisscom.ch ([178.195.186.98] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIwt0-00074I-H5; Mon, 30 Mar 2020 18:03:38 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     jannh@google.com, yhs@fb.com, john.fastabend@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 2/3] bpf: Fix tnum constraints for 32-bit comparisons
Date:   Mon, 30 Mar 2020 18:03:23 +0200
Message-Id: <20200330160324.15259-3-daniel@iogearbox.net>
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

The BPF verifier tried to track values based on 32-bit comparisons by
(ab)using the tnum state via 581738a681b6 ("bpf: Provide better register
bounds after jmp32 instructions"). The idea is that after a check like
this:

    if ((u32)r0 > 3)
      exit

We can't meaningfully constrain the arithmetic-range-based tracking, but
we can update the tnum state to (value=0,mask=0xffff'ffff'0000'0003).
However, the implementation from 581738a681b6 didn't compute the tnum
constraint based on the fixed operand, but instead derives it from the
arithmetic-range-based tracking. This means that after the following
sequence of operations:

    if (r0 >= 0x1'0000'0001)
      exit
    if ((u32)r0 > 7)
      exit

The verifier assumed that the lower half of r0 is in the range (0, 0)
and apply the tnum constraint (value=0,mask=0xffff'ffff'0000'0000) thus
causing the overall tnum to be (value=0,mask=0x1'0000'0000), which was
incorrect. Provide a fixed implementation.

Fixes: 581738a681b6 ("bpf: Provide better register bounds after jmp32 instructions")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 kernel/bpf/verifier.c | 108 ++++++++++++++++++++++++++++--------------
 1 file changed, 72 insertions(+), 36 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2a84f73a93a1..6fce6f096c16 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5678,6 +5678,70 @@ static bool cmp_val_with_extended_s64(s64 sval, struct bpf_reg_state *reg)
 		reg->smax_value <= 0 && reg->smin_value >= S32_MIN);
 }
 
+/* Constrain the possible values of @reg with unsigned upper bound @bound.
+ * If @is_exclusive, @bound is an exclusive limit, otherwise it is inclusive.
+ * If @is_jmp32, @bound is a 32-bit value that only constrains the low 32 bits
+ * of @reg.
+ */
+static void set_upper_bound(struct bpf_reg_state *reg, u64 bound, bool is_jmp32,
+			    bool is_exclusive)
+{
+	if (is_exclusive) {
+		/* There are no values for `reg` that make `reg<0` true. */
+		if (bound == 0)
+			return;
+		bound--;
+	}
+	if (is_jmp32) {
+		/* Constrain the register's value in the tnum representation.
+		 * For 64-bit comparisons this happens later in
+		 * __reg_bound_offset(), but for 32-bit comparisons, we can be
+		 * more precise than what can be derived from the updated
+		 * numeric bounds.
+		 */
+		struct tnum t = tnum_range(0, bound);
+
+		t.mask |= ~0xffffffffULL; /* upper half is unknown */
+		reg->var_off = tnum_intersect(reg->var_off, t);
+
+		/* Compute the 64-bit bound from the 32-bit bound. */
+		bound += gen_hi_max(reg->var_off);
+	}
+	reg->umax_value = min(reg->umax_value, bound);
+}
+
+/* Constrain the possible values of @reg with unsigned lower bound @bound.
+ * If @is_exclusive, @bound is an exclusive limit, otherwise it is inclusive.
+ * If @is_jmp32, @bound is a 32-bit value that only constrains the low 32 bits
+ * of @reg.
+ */
+static void set_lower_bound(struct bpf_reg_state *reg, u64 bound, bool is_jmp32,
+			    bool is_exclusive)
+{
+	if (is_exclusive) {
+		/* There are no values for `reg` that make `reg>MAX` true. */
+		if (bound == (is_jmp32 ? U32_MAX : U64_MAX))
+			return;
+		bound++;
+	}
+	if (is_jmp32) {
+		/* Constrain the register's value in the tnum representation.
+		 * For 64-bit comparisons this happens later in
+		 * __reg_bound_offset(), but for 32-bit comparisons, we can be
+		 * more precise than what can be derived from the updated
+		 * numeric bounds.
+		 */
+		struct tnum t = tnum_range(bound, U32_MAX);
+
+		t.mask |= ~0xffffffffULL; /* upper half is unknown */
+		reg->var_off = tnum_intersect(reg->var_off, t);
+
+		/* Compute the 64-bit bound from the 32-bit bound. */
+		bound += gen_hi_min(reg->var_off);
+	}
+	reg->umin_value = max(reg->umin_value, bound);
+}
+
 /* Adjusts the register min/max values in the case that the dst_reg is the
  * variable register that we are working on, and src_reg is a constant or we're
  * simply doing a BPF_K check.
@@ -5733,15 +5797,8 @@ static void reg_set_min_max(struct bpf_reg_state *true_reg,
 	case BPF_JGE:
 	case BPF_JGT:
 	{
-		u64 false_umax = opcode == BPF_JGT ? val    : val - 1;
-		u64 true_umin = opcode == BPF_JGT ? val + 1 : val;
-
-		if (is_jmp32) {
-			false_umax += gen_hi_max(false_reg->var_off);
-			true_umin += gen_hi_min(true_reg->var_off);
-		}
-		false_reg->umax_value = min(false_reg->umax_value, false_umax);
-		true_reg->umin_value = max(true_reg->umin_value, true_umin);
+		set_upper_bound(false_reg, val, is_jmp32, opcode == BPF_JGE);
+		set_lower_bound(true_reg, val, is_jmp32, opcode == BPF_JGT);
 		break;
 	}
 	case BPF_JSGE:
@@ -5762,15 +5819,8 @@ static void reg_set_min_max(struct bpf_reg_state *true_reg,
 	case BPF_JLE:
 	case BPF_JLT:
 	{
-		u64 false_umin = opcode == BPF_JLT ? val    : val + 1;
-		u64 true_umax = opcode == BPF_JLT ? val - 1 : val;
-
-		if (is_jmp32) {
-			false_umin += gen_hi_min(false_reg->var_off);
-			true_umax += gen_hi_max(true_reg->var_off);
-		}
-		false_reg->umin_value = max(false_reg->umin_value, false_umin);
-		true_reg->umax_value = min(true_reg->umax_value, true_umax);
+		set_lower_bound(false_reg, val, is_jmp32, opcode == BPF_JLE);
+		set_upper_bound(true_reg, val, is_jmp32, opcode == BPF_JLT);
 		break;
 	}
 	case BPF_JSLE:
@@ -5845,15 +5895,8 @@ static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
 	case BPF_JGE:
 	case BPF_JGT:
 	{
-		u64 false_umin = opcode == BPF_JGT ? val    : val + 1;
-		u64 true_umax = opcode == BPF_JGT ? val - 1 : val;
-
-		if (is_jmp32) {
-			false_umin += gen_hi_min(false_reg->var_off);
-			true_umax += gen_hi_max(true_reg->var_off);
-		}
-		false_reg->umin_value = max(false_reg->umin_value, false_umin);
-		true_reg->umax_value = min(true_reg->umax_value, true_umax);
+		set_lower_bound(false_reg, val, is_jmp32, opcode == BPF_JGE);
+		set_upper_bound(true_reg, val, is_jmp32, opcode == BPF_JGT);
 		break;
 	}
 	case BPF_JSGE:
@@ -5871,15 +5914,8 @@ static void reg_set_min_max_inv(struct bpf_reg_state *true_reg,
 	case BPF_JLE:
 	case BPF_JLT:
 	{
-		u64 false_umax = opcode == BPF_JLT ? val    : val - 1;
-		u64 true_umin = opcode == BPF_JLT ? val + 1 : val;
-
-		if (is_jmp32) {
-			false_umax += gen_hi_max(false_reg->var_off);
-			true_umin += gen_hi_min(true_reg->var_off);
-		}
-		false_reg->umax_value = min(false_reg->umax_value, false_umax);
-		true_reg->umin_value = max(true_reg->umin_value, true_umin);
+		set_upper_bound(false_reg, val, is_jmp32, opcode == BPF_JLE);
+		set_lower_bound(true_reg, val, is_jmp32, opcode == BPF_JLT);
 		break;
 	}
 	case BPF_JSLE:
-- 
2.20.1

