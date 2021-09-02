Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D51C3FF384
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 20:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347177AbhIBSxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347176AbhIBSxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 14:53:41 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D8EC061764
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 11:52:42 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id eb14so4406956edb.8
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 11:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nE4L7SCA8H7SOBnLiyBgtiYsx2dtPb7TUHIiSwZHotQ=;
        b=n8okcIWQml1czDjIa8qJUpob0v9JEasisejvBfpuR+vYtgfWUuyEpAp1CZO7kc/H+K
         TyYTTSID2tPU0bTKNnCUm/WDaemT74/Y7ctNGRp34PDM/TMQsNObYJ1C2Jf4UNU6PH3R
         vvc7ARIr/X8b08xqvIbGyQTKadLBvhLL/xtnBtWxzJM4pRbG/s4DZTAnVIdADMWuZzeo
         akD7sRPL/O5KFQZwbFxIcF1KUCTUWb9l/D5K+mSAzeGURkX4UwbZQk40xqlsL9EKJPvk
         xKI2YIyeHkjpW6W/oLch/xfhA27+WrRJYMpg6/OAKGfLmodJ9f5aUUFQY+OfzZ1EeXvD
         tMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nE4L7SCA8H7SOBnLiyBgtiYsx2dtPb7TUHIiSwZHotQ=;
        b=FkpkT23SqB8b0y2qDbCsf3D+csIJrwCfn2yGRNtU3XGgV2Wr24rDwWJyy1BRtnFqdf
         bNEfNkMcNLpLeHRvfr9hvX+6CMLz/nBdxKepGQoXKzO9cBM2Enw+U6r8G/BvECs2eX0c
         wTwkAnwZwdrSEla3ilsB8gwB4jcix3QwASMeWaRLZCrFjysR6IKdtAH5kwuECeUojoP7
         T5Fdws6EkKx5VVYft1owYKdF61k8rt98aZ7xWM65SE6bjlHODQe7WJFFt1AYgMXX4FDG
         g5gX/ioJ/l+YXL7UvdbQvizjAgocpHoz5pdpRWBcgiuKkVewZ1fAANJxH+SEjEHSIecv
         8DAA==
X-Gm-Message-State: AOAM533VetSGz+vtZWA6fWYDmFfuPkLTaj3CEkcezGL8iSIlcz9HSlpZ
        SZ1CHGQtAHxsnV+EHzr6x0bVkA==
X-Google-Smtp-Source: ABdhPJwVKKdRLQNHk9w2wWQnRj+Fyyrwc0KaTfS9/ipEUWPcMJdc09FAmEtHaTWdpm0s5LrxCU08xg==
X-Received: by 2002:a05:6402:714:: with SMTP id w20mr4965089edx.62.1630608760799;
        Thu, 02 Sep 2021 11:52:40 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id mb14sm1592235ejb.81.2021.09.02.11.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 11:52:40 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        iii@linux.ibm.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 03/13] bpf/tests: Add exhaustive tests of ALU shift values
Date:   Thu,  2 Sep 2021 20:52:19 +0200
Message-Id: <20210902185229.1840281-4-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
References: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
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
 lib/test_bpf.c | 257 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 257 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index f0651dc6450b..69f8d4c1df33 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -497,6 +497,165 @@ static int bpf_fill_long_jmp(struct bpf_test *self)
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
+	int len = (2 + 8 * bits) * ARRAY_SIZE(regs) + 2;
+	struct bpf_insn *insn;
+	int imm, k;
+	int i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
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
+			/* Load reference */
+			i += __bpf_ld_imm64(&insn[i], R4, val);
+
+			/* For diagnostic purposes */
+			insn[i++] = BPF_ALU64_IMM(BPF_MOV, R0, i);
+
+			/* Check result */
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
@@ -8414,6 +8573,104 @@ static struct bpf_test tests[] = {
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

