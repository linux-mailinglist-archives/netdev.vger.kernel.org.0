Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECCE41EE3B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhJANHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354011AbhJANGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:06:51 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C856C061783
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:04:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v10so34840250edj.10
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZpFHmDqOoyhA3jAK5s9z4k6+KE4kULIDGqlgShg+6uQ=;
        b=L4vDK+ih8jWxlpASn6qUuBl5+sEwkSFACj0AGmdvkq2Kve4JP7zQT8e2Ma+JuPR/ST
         B55u84/BjxgodDg99H0Cjv4y5W6ocP/VSqzMFHGe/EnERNmZlCEdF3gmiCyRkGxLGBZi
         H+SBoJMyJiV50Hr3DewCsr1/leGJ/YqT5k9FLiBDDDo18uwFHPhm+Z+ASrJDN340Uacm
         EA6j93FFBXwoz4rhKgOZLgFMigJeV/UD4pLpnUD80yc7H4auJYGBF7mqiYZ1eaB/pUeh
         x3sPci9qKVAHWYOm8Bh5MXmMQHbFDZaSPO6bKUAe4pTlYAPjQEmoy6j4ZwRnf/+cL27z
         vHkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZpFHmDqOoyhA3jAK5s9z4k6+KE4kULIDGqlgShg+6uQ=;
        b=XvpWG3++RdcEDkbek4L00pfHPqBLZcpISLlietufoqjOcKVsJGlH8y7U6ya9mh65/1
         zP3/XfUKoygd8/UmBMh0h8p4vKnRIWGNR7I1nlw/xCRCGZRkEAdEPExVml6pYraWPovI
         YAGnsYdCStCoK7fP1qn91MCKg7Nb8ZzgfptFW6/NgnAkWbFL0483iLgxBqNJyHZbjr7R
         Tm8/65H7oWcAhMfBDVYUio4xbxeCsgszmAZaQ7FX1wC0gEFpyzQsjYfFLN9LCgdxmeUz
         GEbvepzBnUJcbC+t+xaSf+RCWiLxXCuRGwJmyTpHf+/74xqh/PzHGwLB1vUGIJtr9mUG
         PYPg==
X-Gm-Message-State: AOAM531gx3bquZLxz25s0QN9yrV6VMMKXLwk1j5BtfRjYl48uxGC0Xq/
        WvaCwOMLnAd/ftNxFFlqM5nX9w==
X-Google-Smtp-Source: ABdhPJxcEfLmyOyLtCXDlOSGa86W59p/xC3GMO/nSeijab3YMNHaWotVUKxIj7xl+htVS0qa/XfKOw==
X-Received: by 2002:a17:906:3fd7:: with SMTP id k23mr6102451ejj.176.1633093446347;
        Fri, 01 Oct 2021 06:04:06 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id p22sm2920279ejl.90.2021.10.01.06.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:04:06 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 07/10] bpf/tests: Add exhaustive tests of ALU register combinations
Date:   Fri,  1 Oct 2021 15:03:45 +0200
Message-Id: <20211001130348.3670534-8-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
References: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the current register combination test with new
exhaustive tests. Before, only a subset of register combinations was
tested for ALU64 DIV. Now, all combinatons of operand registers are
tested, including the case when they are the same, and for all ALU32
and ALU64 operations.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 834 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 763 insertions(+), 71 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 919323a3b69f..924bf4c9783c 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -1130,6 +1130,381 @@ static int bpf_fill_alu32_mod_reg(struct bpf_test *self)
 	return __bpf_fill_alu32_reg(self, BPF_MOD);
 }
 
+/*
+ * Test JITs that implement complex ALU operations as function
+ * calls, and must re-arrange operands for argument passing.
+ */
+static int __bpf_fill_alu_imm_regs(struct bpf_test *self, u8 op, bool alu32)
+{
+	int len = 2 + 10 * 10;
+	struct bpf_insn *insns;
+	u64 dst, res;
+	int i = 0;
+	u32 imm;
+	int rd;
+
+	insns = kmalloc_array(len, sizeof(*insns), GFP_KERNEL);
+	if (!insns)
+		return -ENOMEM;
+
+	/* Operand and result values according to operation */
+	if (alu32)
+		dst = 0x76543210U;
+	else
+		dst = 0x7edcba9876543210ULL;
+	imm = 0x01234567U;
+
+	if (op == BPF_LSH || op == BPF_RSH || op == BPF_ARSH)
+		imm &= 31;
+
+	__bpf_alu_result(&res, dst, imm, op);
+
+	if (alu32)
+		res = (u32)res;
+
+	/* Check all operand registers */
+	for (rd = R0; rd <= R9; rd++) {
+		i += __bpf_ld_imm64(&insns[i], rd, dst);
+
+		if (alu32)
+			insns[i++] = BPF_ALU32_IMM(op, rd, imm);
+		else
+			insns[i++] = BPF_ALU64_IMM(op, rd, imm);
+
+		insns[i++] = BPF_JMP32_IMM(BPF_JEQ, rd, res, 2);
+		insns[i++] = BPF_MOV64_IMM(R0, __LINE__);
+		insns[i++] = BPF_EXIT_INSN();
+
+		insns[i++] = BPF_ALU64_IMM(BPF_RSH, rd, 32);
+		insns[i++] = BPF_JMP32_IMM(BPF_JEQ, rd, res >> 32, 2);
+		insns[i++] = BPF_MOV64_IMM(R0, __LINE__);
+		insns[i++] = BPF_EXIT_INSN();
+	}
+
+	insns[i++] = BPF_MOV64_IMM(R0, 1);
+	insns[i++] = BPF_EXIT_INSN();
+
+	self->u.ptr.insns = insns;
+	self->u.ptr.len = len;
+	BUG_ON(i != len);
+
+	return 0;
+}
+
+/* ALU64 K registers */
+static int bpf_fill_alu64_mov_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_MOV, false);
+}
+
+static int bpf_fill_alu64_and_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_AND, false);
+}
+
+static int bpf_fill_alu64_or_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_OR, false);
+}
+
+static int bpf_fill_alu64_xor_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_XOR, false);
+}
+
+static int bpf_fill_alu64_lsh_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_LSH, false);
+}
+
+static int bpf_fill_alu64_rsh_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_RSH, false);
+}
+
+static int bpf_fill_alu64_arsh_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_ARSH, false);
+}
+
+static int bpf_fill_alu64_add_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_ADD, false);
+}
+
+static int bpf_fill_alu64_sub_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_SUB, false);
+}
+
+static int bpf_fill_alu64_mul_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_MUL, false);
+}
+
+static int bpf_fill_alu64_div_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_DIV, false);
+}
+
+static int bpf_fill_alu64_mod_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_MOD, false);
+}
+
+/* ALU32 K registers */
+static int bpf_fill_alu32_mov_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_MOV, true);
+}
+
+static int bpf_fill_alu32_and_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_AND, true);
+}
+
+static int bpf_fill_alu32_or_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_OR, true);
+}
+
+static int bpf_fill_alu32_xor_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_XOR, true);
+}
+
+static int bpf_fill_alu32_lsh_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_LSH, true);
+}
+
+static int bpf_fill_alu32_rsh_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_RSH, true);
+}
+
+static int bpf_fill_alu32_arsh_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_ARSH, true);
+}
+
+static int bpf_fill_alu32_add_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_ADD, true);
+}
+
+static int bpf_fill_alu32_sub_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_SUB, true);
+}
+
+static int bpf_fill_alu32_mul_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_MUL, true);
+}
+
+static int bpf_fill_alu32_div_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_DIV, true);
+}
+
+static int bpf_fill_alu32_mod_imm_regs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_imm_regs(self, BPF_MOD, true);
+}
+
+/*
+ * Test JITs that implement complex ALU operations as function
+ * calls, and must re-arrange operands for argument passing.
+ */
+static int __bpf_fill_alu_reg_pairs(struct bpf_test *self, u8 op, bool alu32)
+{
+	int len = 2 + 10 * 10 * 12;
+	u64 dst, src, res, same;
+	struct bpf_insn *insns;
+	int rd, rs;
+	int i = 0;
+
+	insns = kmalloc_array(len, sizeof(*insns), GFP_KERNEL);
+	if (!insns)
+		return -ENOMEM;
+
+	/* Operand and result values according to operation */
+	if (alu32) {
+		dst = 0x76543210U;
+		src = 0x01234567U;
+	} else {
+		dst = 0x7edcba9876543210ULL;
+		src = 0x0123456789abcdefULL;
+	}
+
+	if (op == BPF_LSH || op == BPF_RSH || op == BPF_ARSH)
+		src &= 31;
+
+	__bpf_alu_result(&res, dst, src, op);
+	__bpf_alu_result(&same, src, src, op);
+
+	if (alu32) {
+		res = (u32)res;
+		same = (u32)same;
+	}
+
+	/* Check all combinations of operand registers */
+	for (rd = R0; rd <= R9; rd++) {
+		for (rs = R0; rs <= R9; rs++) {
+			u64 val = rd == rs ? same : res;
+
+			i += __bpf_ld_imm64(&insns[i], rd, dst);
+			i += __bpf_ld_imm64(&insns[i], rs, src);
+
+			if (alu32)
+				insns[i++] = BPF_ALU32_REG(op, rd, rs);
+			else
+				insns[i++] = BPF_ALU64_REG(op, rd, rs);
+
+			insns[i++] = BPF_JMP32_IMM(BPF_JEQ, rd, val, 2);
+			insns[i++] = BPF_MOV64_IMM(R0, __LINE__);
+			insns[i++] = BPF_EXIT_INSN();
+
+			insns[i++] = BPF_ALU64_IMM(BPF_RSH, rd, 32);
+			insns[i++] = BPF_JMP32_IMM(BPF_JEQ, rd, val >> 32, 2);
+			insns[i++] = BPF_MOV64_IMM(R0, __LINE__);
+			insns[i++] = BPF_EXIT_INSN();
+		}
+	}
+
+	insns[i++] = BPF_MOV64_IMM(R0, 1);
+	insns[i++] = BPF_EXIT_INSN();
+
+	self->u.ptr.insns = insns;
+	self->u.ptr.len = len;
+	BUG_ON(i != len);
+
+	return 0;
+}
+
+/* ALU64 X register combinations */
+static int bpf_fill_alu64_mov_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_MOV, false);
+}
+
+static int bpf_fill_alu64_and_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_AND, false);
+}
+
+static int bpf_fill_alu64_or_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_OR, false);
+}
+
+static int bpf_fill_alu64_xor_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_XOR, false);
+}
+
+static int bpf_fill_alu64_lsh_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_LSH, false);
+}
+
+static int bpf_fill_alu64_rsh_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_RSH, false);
+}
+
+static int bpf_fill_alu64_arsh_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_ARSH, false);
+}
+
+static int bpf_fill_alu64_add_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_ADD, false);
+}
+
+static int bpf_fill_alu64_sub_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_SUB, false);
+}
+
+static int bpf_fill_alu64_mul_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_MUL, false);
+}
+
+static int bpf_fill_alu64_div_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_DIV, false);
+}
+
+static int bpf_fill_alu64_mod_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_MOD, false);
+}
+
+/* ALU32 X register combinations */
+static int bpf_fill_alu32_mov_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_MOV, true);
+}
+
+static int bpf_fill_alu32_and_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_AND, true);
+}
+
+static int bpf_fill_alu32_or_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_OR, true);
+}
+
+static int bpf_fill_alu32_xor_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_XOR, true);
+}
+
+static int bpf_fill_alu32_lsh_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_LSH, true);
+}
+
+static int bpf_fill_alu32_rsh_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_RSH, true);
+}
+
+static int bpf_fill_alu32_arsh_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_ARSH, true);
+}
+
+static int bpf_fill_alu32_add_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_ADD, true);
+}
+
+static int bpf_fill_alu32_sub_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_SUB, true);
+}
+
+static int bpf_fill_alu32_mul_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_MUL, true);
+}
+
+static int bpf_fill_alu32_div_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_DIV, true);
+}
+
+static int bpf_fill_alu32_mod_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_alu_reg_pairs(self, BPF_MOD, true);
+}
+
 /*
  * Exhaustive tests of atomic operations for all power-of-two operand
  * magnitudes, both for positive and negative values.
@@ -3737,77 +4112,6 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, -1 } }
 	},
-	{
-		/*
-		 * Test 32-bit JITs that implement complex ALU64 operations as
-		 * function calls R0 = f(R1, R2), and must re-arrange operands.
-		 */
-#define NUMER 0xfedcba9876543210ULL
-#define DENOM 0x0123456789abcdefULL
-		"ALU64_DIV X: Operand register permutations",
-		.u.insns_int = {
-			/* R0 / R2 */
-			BPF_LD_IMM64(R0, NUMER),
-			BPF_LD_IMM64(R2, DENOM),
-			BPF_ALU64_REG(BPF_DIV, R0, R2),
-			BPF_JMP_IMM(BPF_JEQ, R0, NUMER / DENOM, 1),
-			BPF_EXIT_INSN(),
-			/* R1 / R0 */
-			BPF_LD_IMM64(R1, NUMER),
-			BPF_LD_IMM64(R0, DENOM),
-			BPF_ALU64_REG(BPF_DIV, R1, R0),
-			BPF_JMP_IMM(BPF_JEQ, R1, NUMER / DENOM, 1),
-			BPF_EXIT_INSN(),
-			/* R0 / R1 */
-			BPF_LD_IMM64(R0, NUMER),
-			BPF_LD_IMM64(R1, DENOM),
-			BPF_ALU64_REG(BPF_DIV, R0, R1),
-			BPF_JMP_IMM(BPF_JEQ, R0, NUMER / DENOM, 1),
-			BPF_EXIT_INSN(),
-			/* R2 / R0 */
-			BPF_LD_IMM64(R2, NUMER),
-			BPF_LD_IMM64(R0, DENOM),
-			BPF_ALU64_REG(BPF_DIV, R2, R0),
-			BPF_JMP_IMM(BPF_JEQ, R2, NUMER / DENOM, 1),
-			BPF_EXIT_INSN(),
-			/* R2 / R1 */
-			BPF_LD_IMM64(R2, NUMER),
-			BPF_LD_IMM64(R1, DENOM),
-			BPF_ALU64_REG(BPF_DIV, R2, R1),
-			BPF_JMP_IMM(BPF_JEQ, R2, NUMER / DENOM, 1),
-			BPF_EXIT_INSN(),
-			/* R1 / R2 */
-			BPF_LD_IMM64(R1, NUMER),
-			BPF_LD_IMM64(R2, DENOM),
-			BPF_ALU64_REG(BPF_DIV, R1, R2),
-			BPF_JMP_IMM(BPF_JEQ, R1, NUMER / DENOM, 1),
-			BPF_EXIT_INSN(),
-			/* R1 / R1 */
-			BPF_LD_IMM64(R1, NUMER),
-			BPF_ALU64_REG(BPF_DIV, R1, R1),
-			BPF_JMP_IMM(BPF_JEQ, R1, 1, 1),
-			BPF_EXIT_INSN(),
-			/* R2 / R2 */
-			BPF_LD_IMM64(R2, DENOM),
-			BPF_ALU64_REG(BPF_DIV, R2, R2),
-			BPF_JMP_IMM(BPF_JEQ, R2, 1, 1),
-			BPF_EXIT_INSN(),
-			/* R3 / R4 */
-			BPF_LD_IMM64(R3, NUMER),
-			BPF_LD_IMM64(R4, DENOM),
-			BPF_ALU64_REG(BPF_DIV, R3, R4),
-			BPF_JMP_IMM(BPF_JEQ, R3, NUMER / DENOM, 1),
-			BPF_EXIT_INSN(),
-			/* Successful return */
-			BPF_LD_IMM64(R0, 1),
-			BPF_EXIT_INSN(),
-		},
-		INTERNAL,
-		{ },
-		{ { 0, 1 } },
-#undef NUMER
-#undef DENOM
-	},
 #ifdef CONFIG_32BIT
 	{
 		"INT: 32-bit context pointer word order and zero-extension",
@@ -10849,6 +11153,394 @@ static struct bpf_test tests[] = {
 	BPF_JMP32_REG_ZEXT(JSLT),
 	BPF_JMP32_REG_ZEXT(JSLE),
 #undef BPF_JMP2_REG_ZEXT
+	/* ALU64 K register combinations */
+	{
+		"ALU64_MOV_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mov_imm_regs,
+	},
+	{
+		"ALU64_AND_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_and_imm_regs,
+	},
+	{
+		"ALU64_OR_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_or_imm_regs,
+	},
+	{
+		"ALU64_XOR_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_xor_imm_regs,
+	},
+	{
+		"ALU64_LSH_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_lsh_imm_regs,
+	},
+	{
+		"ALU64_RSH_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_rsh_imm_regs,
+	},
+	{
+		"ALU64_ARSH_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_arsh_imm_regs,
+	},
+	{
+		"ALU64_ADD_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_add_imm_regs,
+	},
+	{
+		"ALU64_SUB_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_sub_imm_regs,
+	},
+	{
+		"ALU64_MUL_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mul_imm_regs,
+	},
+	{
+		"ALU64_DIV_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_div_imm_regs,
+	},
+	{
+		"ALU64_MOD_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mod_imm_regs,
+	},
+	/* ALU32 K registers */
+	{
+		"ALU32_MOV_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mov_imm_regs,
+	},
+	{
+		"ALU32_AND_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_and_imm_regs,
+	},
+	{
+		"ALU32_OR_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_or_imm_regs,
+	},
+	{
+		"ALU32_XOR_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_xor_imm_regs,
+	},
+	{
+		"ALU32_LSH_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_lsh_imm_regs,
+	},
+	{
+		"ALU32_RSH_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_rsh_imm_regs,
+	},
+	{
+		"ALU32_ARSH_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_arsh_imm_regs,
+	},
+	{
+		"ALU32_ADD_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_add_imm_regs,
+	},
+	{
+		"ALU32_SUB_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_sub_imm_regs,
+	},
+	{
+		"ALU32_MUL_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mul_imm_regs,
+	},
+	{
+		"ALU32_DIV_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_div_imm_regs,
+	},
+	{
+		"ALU32_MOD_K: registers",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mod_imm_regs,
+	},
+	/* ALU64 X register combinations */
+	{
+		"ALU64_MOV_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mov_reg_pairs,
+	},
+	{
+		"ALU64_AND_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_and_reg_pairs,
+	},
+	{
+		"ALU64_OR_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_or_reg_pairs,
+	},
+	{
+		"ALU64_XOR_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_xor_reg_pairs,
+	},
+	{
+		"ALU64_LSH_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_lsh_reg_pairs,
+	},
+	{
+		"ALU64_RSH_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_rsh_reg_pairs,
+	},
+	{
+		"ALU64_ARSH_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_arsh_reg_pairs,
+	},
+	{
+		"ALU64_ADD_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_add_reg_pairs,
+	},
+	{
+		"ALU64_SUB_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_sub_reg_pairs,
+	},
+	{
+		"ALU64_MUL_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mul_reg_pairs,
+	},
+	{
+		"ALU64_DIV_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_div_reg_pairs,
+	},
+	{
+		"ALU64_MOD_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu64_mod_reg_pairs,
+	},
+	/* ALU32 X register combinations */
+	{
+		"ALU32_MOV_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mov_reg_pairs,
+	},
+	{
+		"ALU32_AND_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_and_reg_pairs,
+	},
+	{
+		"ALU32_OR_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_or_reg_pairs,
+	},
+	{
+		"ALU32_XOR_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_xor_reg_pairs,
+	},
+	{
+		"ALU32_LSH_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_lsh_reg_pairs,
+	},
+	{
+		"ALU32_RSH_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_rsh_reg_pairs,
+	},
+	{
+		"ALU32_ARSH_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_arsh_reg_pairs,
+	},
+	{
+		"ALU32_ADD_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_add_reg_pairs,
+	},
+	{
+		"ALU32_SUB_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_sub_reg_pairs,
+	},
+	{
+		"ALU32_MUL_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mul_reg_pairs,
+	},
+	{
+		"ALU32_DIV_X: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_div_reg_pairs,
+	},
+	{
+		"ALU32_MOD_X register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_mod_reg_pairs,
+	},
 	/* Exhaustive test of ALU64 shift operations */
 	{
 		"ALU64_LSH_K: all shift values",
-- 
2.30.2

