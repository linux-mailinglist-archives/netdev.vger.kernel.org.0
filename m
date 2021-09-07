Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792BB4030F1
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348869AbhIGWZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347970AbhIGWZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:25:01 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A809CC06179A
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:23:53 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id q3so76606edt.5
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LkH/sO56VAlmNRIplGiQQoew4M/S2hYPzrsnrhPWCOU=;
        b=tQve5sZ+7lgtm+hWfWn9aZIDi3EB95iR99D8qW7UA/Hw9g4RJvfKzuGUWoOSaGtOWV
         hyPvYkO6Ct/xqirTUJhgF1al19rndV5IwSow3NmwjN8GPZGtMQN38uqJsoDc+P5x/da4
         1jzmJ51vvaWJpUmRVCI86yYYWZf6A0YBVRdxhZO+3hwlLNA2oe9+rJdxAn3wN2gj6DK6
         k9TV9g7eMKySrwjwejw+WFX9tSxfDNvNajHy3HFpkHLJueDbmydLB0Zh9ElnCiZDsjQK
         KAqy2jV7wJnn/1Dvs80gpXavvWm4SLcPwIPQKOeR0eCRV2bbQAV5hCZo1vMVUmONE7Zf
         jY7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LkH/sO56VAlmNRIplGiQQoew4M/S2hYPzrsnrhPWCOU=;
        b=MjhWX4RHZcxI02KnrTRLaKbY24/eu2kedyMmLYPEUBdZH5GZON1TvOsY0MKhCqHXiH
         kKVeqYGIsS1WDxQO/Q9rpOoORoYIorghF0SoNlpbB6E69K3RE2rm2BYu+hi7KQg48tY8
         y/OJ/kvFINMaSD80KtncxaU/uVCYUKN4hw42IhljHREqXbqmlzT6PG+H5UXc3SGr4ZUL
         h4T1S53k08+16/ED4qxzOyWZSbyAkKvAs68MlEySvnVb2KOpVSMb/qKjVK34pIdFTeRj
         COuaYSNfhEAgPuac5V5/oOzyumNtQ1IDD8oFLUHMvS3ekLcnjlUsaeQC6NgKKI9NAo2H
         5A0A==
X-Gm-Message-State: AOAM530/Fh1T2UCNcAYmvbUUWA4eL28/655TFzzm6ndcrPIvZFnX2MdV
        S+XzPPecPbfE04CPTWAQlOp4hA==
X-Google-Smtp-Source: ABdhPJx62kWnqtc7039/ABnoKyGbW56/yla4SNzWfnBXj0QXEBAGiY04V91svwVLs3sVlT0uKRxYlw==
X-Received: by 2002:a05:6402:350d:: with SMTP id b13mr529314edd.1.1631053431973;
        Tue, 07 Sep 2021 15:23:51 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:23:51 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 03/13] bpf/tests: Add exhaustive tests of ALU shift values
Date:   Wed,  8 Sep 2021 00:23:29 +0200
Message-Id: <20210907222339.4130924-4-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
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
2.25.1

