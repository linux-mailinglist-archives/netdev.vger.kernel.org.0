Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE5E40AA95
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 11:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhINJUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 05:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhINJUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 05:20:25 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644B5C061764
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 02:19:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z94so12600773ede.8
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 02:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=06j++P1xYoE5S+BhCDt2k7rQrI8ilHLOz1L418XLdG4=;
        b=rbKy3Oz6gvO7km6Of3tAfOSJxa7xhoqoUw0pos2BwR/t+cjAY+yxFjdgLtneiWwfol
         jjgxV5Hf/xWqDYKV2QvEsrCXw2AAXV4wVDKJWtCx0h73taS9nrawdbxn+pYPuYSTdx95
         foHaH0bu890+NGnbY7RR6Pb1mkDjq89N9TYdnWuhsxeLhMJkQuCU8oOK0PkfH8Qv+Wd1
         gTdTfeMbZywTIABLN2RNaPoIjhiXmk/4iFN8+gYfOX+DH2OVIMpyv4oTGnIDHjTAlWZU
         Aq+jX4yZquXq/R3F6paa6i7214t5mzGohswBxv9mMBetkj2gb+cIOSo3AotclWUXpSz9
         X1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=06j++P1xYoE5S+BhCDt2k7rQrI8ilHLOz1L418XLdG4=;
        b=ylSLwXP9/m0EJlCwSBVZeRFNrIP81k51OlZ6zGAba4OljOM2rphdLSS1TBP/dvJLf8
         Lvh4+cXctXHkQ7wIrLZjBawXYOngsExe5BqTgvb60Nn9DSEK+HQFmiLuBM417JTn5LkN
         wh/tTwEFB5fF0DfYukAmSCyUwBWzH63GkeiaCcdvkanRmhOxeDEeJGGisI9vm9VAX5cq
         wQc/SD80Ii2KQTA5xh7XiU+lIUArlCWlrou4GXxoEQBT9roJBtumTkP+Vdi2LzG59sWO
         Szx6sroszTrnWEKxZMO8cYmJuAp4IJfQiG7VJbwI7up7aAWtJOor8ng+uRn9ujlh3aHa
         BAYQ==
X-Gm-Message-State: AOAM531Na3mTz7Yd3OawQ8Zm+2rc38lQ8ZR81/oRtJkXbmZIUG9E44cF
        3xaJOh4A0NUgAhTIZ+Nm95SVtw==
X-Google-Smtp-Source: ABdhPJyIFD5AhFPQpvU6BM0MDbHeU50au+pmM9k5oCQVTUOc2RyxfZSS3syIPsag6E5tNJPdA6yIeA==
X-Received: by 2002:a05:6402:19a:: with SMTP id r26mr18421269edv.230.1631611146931;
        Tue, 14 Sep 2021 02:19:06 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id h10sm4615915ede.28.2021.09.14.02.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 02:19:06 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf v4 03/14] bpf/tests: Add exhaustive tests of ALU shift values
Date:   Tue, 14 Sep 2021 11:18:31 +0200
Message-Id: <20210914091842.4186267-4-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
References: <20210914091842.4186267-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a set of tests for ALU64 and ALU32 shift operations to
verify correctness for all possible values of the shift value. Mainly
intended for JIT testing.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 260 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 260 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index f0651dc6450b..f76472c050a7 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -497,6 +497,168 @@ static int bpf_fill_long_jmp(struct bpf_test *self)
 	return 0;
 }
 
+static int __bpf_ld_imm64(struct bpf_insn insns[2], u8 reg, s64 imm64)
+{
+	struct bpf_insn tmp[] = {BPF_LD_IMM64(reg, imm64)};
+
+	memcpy(insns, tmp, sizeof(tmp));
+	return 2;
+}
+
+/* Test an ALU shift operation for all valid shift values */
+static int __bpf_fill_alu_shift(struct bpf_test *self, u8 op,
+				u8 mode, bool alu32)
+{
+	static const s64 regs[] = {
+		0x0123456789abcdefLL, /* dword > 0, word < 0 */
+		0xfedcba9876543210LL, /* dowrd < 0, word > 0 */
+		0xfedcba0198765432LL, /* dowrd < 0, word < 0 */
+		0x0123458967abcdefLL, /* dword > 0, word > 0 */
+	};
+	int bits = alu32 ? 32 : 64;
+	int len = (2 + 7 * bits) * ARRAY_SIZE(regs) + 3;
+	struct bpf_insn *insn;
+	int imm, k;
+	int i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	insn[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 0);
+
+	for (k = 0; k < ARRAY_SIZE(regs); k++) {
+		s64 reg = regs[k];
+
+		i += __bpf_ld_imm64(&insn[i], R3, reg);
+
+		for (imm = 0; imm < bits; imm++) {
+			u64 val;
+
+			/* Perform operation */
+			insn[i++] = BPF_ALU64_REG(BPF_MOV, R1, R3);
+			insn[i++] = BPF_ALU64_IMM(BPF_MOV, R2, imm);
+			if (alu32) {
+				if (mode == BPF_K)
+					insn[i++] = BPF_ALU32_IMM(op, R1, imm);
+				else
+					insn[i++] = BPF_ALU32_REG(op, R1, R2);
+				switch (op) {
+				case BPF_LSH:
+					val = (u32)reg << imm;
+					break;
+				case BPF_RSH:
+					val = (u32)reg >> imm;
+					break;
+				case BPF_ARSH:
+					val = (u32)reg >> imm;
+					if (imm > 0 && (reg & 0x80000000))
+						val |= ~(u32)0 << (32 - imm);
+					break;
+				}
+			} else {
+				if (mode == BPF_K)
+					insn[i++] = BPF_ALU64_IMM(op, R1, imm);
+				else
+					insn[i++] = BPF_ALU64_REG(op, R1, R2);
+				switch (op) {
+				case BPF_LSH:
+					val = (u64)reg << imm;
+					break;
+				case BPF_RSH:
+					val = (u64)reg >> imm;
+					break;
+				case BPF_ARSH:
+					val = (u64)reg >> imm;
+					if (imm > 0 && reg < 0)
+						val |= ~(u64)0 << (64 - imm);
+					break;
+				}
+			}
+
+			/*
+			 * When debugging a JIT that fails this test, one
+			 * can write the immediate value to R0 here to find
+			 * out which operand values that fail.
+			 */
+
+			/* Load reference and check the result */
+			i += __bpf_ld_imm64(&insn[i], R4, val);
+			insn[i++] = BPF_JMP_REG(BPF_JEQ, R1, R4, 1);
+			insn[i++] = BPF_EXIT_INSN();
+		}
+	}
+
+	insn[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 1);
+	insn[i++] = BPF_EXIT_INSN();
+
+	self->u.ptr.insns = insn;
+	self->u.ptr.len = len;
+	BUG_ON(i > len);
+
+	return 0;
+}
+
+static int bpf_fill_alu_lsh_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_LSH, BPF_K, false);
+}
+
+static int bpf_fill_alu_rsh_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_RSH, BPF_K, false);
+}
+
+static int bpf_fill_alu_arsh_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_ARSH, BPF_K, false);
+}
+
+static int bpf_fill_alu_lsh_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_LSH, BPF_X, false);
+}
+
+static int bpf_fill_alu_rsh_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_RSH, BPF_X, false);
+}
+
+static int bpf_fill_alu_arsh_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_ARSH, BPF_X, false);
+}
+
+static int bpf_fill_alu32_lsh_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_LSH, BPF_K, true);
+}
+
+static int bpf_fill_alu32_rsh_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_RSH, BPF_K, true);
+}
+
+static int bpf_fill_alu32_arsh_imm(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_ARSH, BPF_K, true);
+}
+
+static int bpf_fill_alu32_lsh_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_LSH, BPF_X, true);
+}
+
+static int bpf_fill_alu32_rsh_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_RSH, BPF_X, true);
+}
+
+static int bpf_fill_alu32_arsh_reg(struct bpf_test *self)
+{
+	return __bpf_fill_alu_shift(self, BPF_ARSH, BPF_X, true);
+}
+
 static struct bpf_test tests[] = {
 	{
 		"TAX",
@@ -8414,6 +8576,104 @@ static struct bpf_test tests[] = {
 		{},
 		{ { 0, 2 } },
 	},
+	/* Exhaustive test of ALU64 shift operations */
+	{
+		"ALU64_LSH_K: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu_lsh_imm,
+	},
+	{
+		"ALU64_RSH_K: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu_rsh_imm,
+	},
+	{
+		"ALU64_ARSH_K: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu_arsh_imm,
+	},
+	{
+		"ALU64_LSH_X: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu_lsh_reg,
+	},
+	{
+		"ALU64_RSH_X: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu_rsh_reg,
+	},
+	{
+		"ALU64_ARSH_X: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu_arsh_reg,
+	},
+	/* Exhaustive test of ALU32 shift operations */
+	{
+		"ALU32_LSH_K: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_lsh_imm,
+	},
+	{
+		"ALU32_RSH_K: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_rsh_imm,
+	},
+	{
+		"ALU32_ARSH_K: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_arsh_imm,
+	},
+	{
+		"ALU32_LSH_X: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_lsh_reg,
+	},
+	{
+		"ALU32_RSH_X: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_rsh_reg,
+	},
+	{
+		"ALU32_ARSH_X: all shift values",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_alu32_arsh_reg,
+	},
 };
 
 static struct net_device dev;
-- 
2.30.2

