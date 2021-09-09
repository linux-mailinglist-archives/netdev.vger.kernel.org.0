Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A442405986
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344398AbhIIOqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344874AbhIIOqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:46:04 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E74C05BD33
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 07:33:26 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id e21so4005918ejz.12
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 07:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+tVwcYYoISq7MFEiZUlH6wSoyP/GdeKabJlrQIhydTY=;
        b=YQ1l4lruNhTTFHhBXSBtlKPE72VJ8W/+fiwLz7ssf8x09f0IaIuJQgcM36u1xDy2a+
         Pori0FZr0qlw+NlJXT+cJ9/Nwg+mr3Sf5yqtY4XlDAGv0oCR5a4itlx1NpRBDPQNcnpn
         FaR6CGFJPMZu59yFemD7/siaKeJBAqsnHJ8yUHeVBVnDsBaKM2G287QmNG0b5ZqboQwx
         fCWjKcaIKDiCqaOqEi9W1rSw7ZvTI+jicSkxnqJHrelc/BBD50736F5tQHOMnbU9Zx5w
         8QnWZL/6MGviXhNOG7EBzOlioinj1DU3ZWa3Sy74V7SFEUqN2/ssnzdUGFjdCeTJ3/Cd
         nSTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+tVwcYYoISq7MFEiZUlH6wSoyP/GdeKabJlrQIhydTY=;
        b=JzYO/riYlxHU60upjCE4ek2SMU5r51kV6JQApFftWHW2edYoFtJDHuZbpNVB+KRpRN
         xBHWbSjibz/9NBucxaYjChe9JUxpnZf8FW53paF/dRV9mGgjc1hv/l6ZnPoS51UGjSPi
         HztcUc2qmv8WoS0Oe3njGD2uLTzpRhnTIE8/tjbs6GGQu6w3328uISaBLtEhGtFuiuaQ
         8OUZA2GUhTdhS/rjXMAVjdIMJU49sZGA20c/qsMs3jzYR3mcDN3TE1/fNMMDFKNCiVRu
         M6ibSbCPAg4fkPnd8EcBmtQ2FUJrFAYosExylrTozovOpepuR1kjadmS+2DqhTSRApc2
         MI0g==
X-Gm-Message-State: AOAM531wwtHmXqVenxT0Jl88iN+6d2XnfdyGvvSJrp51/imz+c5qvDuI
        AyhpYTWYBHsItYylkIXJNu+DQQ==
X-Google-Smtp-Source: ABdhPJxADZyjXKKNM6WzGsQ+QjHf42i9h/UpbxTbWaTV2z11wwgSAC6usrg+vmOb5UUwWNCM7Wq2rw==
X-Received: by 2002:a17:907:1b02:: with SMTP id mp2mr3784652ejc.196.1631198005106;
        Thu, 09 Sep 2021 07:33:25 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bj10sm1030909ejb.17.2021.09.09.07.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 07:33:24 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v3 11/13] bpf/tests: Expand branch conversion JIT test
Date:   Thu,  9 Sep 2021 16:33:01 +0200
Message-Id: <20210909143303.811171-12-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
References: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch expands the branch conversion test introduced by 66e5eb84
("bpf, tests: Add branch conversion JIT test"). The test now includes
a JMP with maximum eBPF offset. This triggers branch conversion for the
64-bit MIPS JIT. Additional variants are also added for cases when the
branch is taken or not taken.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 143 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 100 insertions(+), 43 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ae261667ca0a..a515f9b670c9 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -463,41 +463,6 @@ static int bpf_fill_stxdw(struct bpf_test *self)
 	return __bpf_fill_stxdw(self, BPF_DW);
 }
 
-static int bpf_fill_long_jmp(struct bpf_test *self)
-{
-	unsigned int len = BPF_MAXINSNS;
-	struct bpf_insn *insn;
-	int i;
-
-	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
-	if (!insn)
-		return -ENOMEM;
-
-	insn[0] = BPF_ALU64_IMM(BPF_MOV, R0, 1);
-	insn[1] = BPF_JMP_IMM(BPF_JEQ, R0, 1, len - 2 - 1);
-
-	/*
-	 * Fill with a complex 64-bit operation that expands to a lot of
-	 * instructions on 32-bit JITs. The large jump offset can then
-	 * overflow the conditional branch field size, triggering a branch
-	 * conversion mechanism in some JITs.
-	 *
-	 * Note: BPF_MAXINSNS of ALU64 MUL is enough to trigger such branch
-	 * conversion on the 32-bit MIPS JIT. For other JITs, the instruction
-	 * count and/or operation may need to be modified to trigger the
-	 * branch conversion.
-	 */
-	for (i = 2; i < len - 1; i++)
-		insn[i] = BPF_ALU64_IMM(BPF_MUL, R0, (i << 16) + i);
-
-	insn[len - 1] = BPF_EXIT_INSN();
-
-	self->u.ptr.insns = insn;
-	self->u.ptr.len = len;
-
-	return 0;
-}
-
 static int __bpf_ld_imm64(struct bpf_insn insns[2], u8 reg, s64 imm64)
 {
 	struct bpf_insn tmp[] = {BPF_LD_IMM64(reg, imm64)};
@@ -506,6 +471,73 @@ static int __bpf_ld_imm64(struct bpf_insn insns[2], u8 reg, s64 imm64)
 	return 2;
 }
 
+/*
+ * Branch conversion tests. Complex operations can expand to a lot
+ * of instructions when JITed. This in turn may cause jump offsets
+ * to overflow the field size of the native instruction, triggering
+ * a branch conversion mechanism in some JITs.
+ */
+static int __bpf_fill_max_jmp(struct bpf_test *self, int jmp, int imm)
+{
+	struct bpf_insn *insns;
+	int len = S16_MAX + 5;
+	int i;
+
+	insns = kmalloc_array(len, sizeof(*insns), GFP_KERNEL);
+	if (!insns)
+		return -ENOMEM;
+
+	i = __bpf_ld_imm64(insns, R1, 0x0123456789abcdefULL);
+	insns[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 1);
+	insns[i++] = BPF_JMP_IMM(jmp, R0, imm, S16_MAX);
+	insns[i++] = BPF_ALU64_IMM(BPF_MOV, R0, 2);
+	insns[i++] = BPF_EXIT_INSN();
+
+	while (i < len - 1) {
+		static const int ops[] = {
+			BPF_LSH, BPF_RSH, BPF_ARSH, BPF_ADD,
+			BPF_SUB, BPF_MUL, BPF_DIV, BPF_MOD,
+		};
+		int op = ops[(i >> 1) % ARRAY_SIZE(ops)];
+
+		if (i & 1)
+			insns[i++] = BPF_ALU32_REG(op, R0, R1);
+		else
+			insns[i++] = BPF_ALU64_REG(op, R0, R1);
+	}
+
+	insns[i++] = BPF_EXIT_INSN();
+	self->u.ptr.insns = insns;
+	self->u.ptr.len = len;
+	BUG_ON(i != len);
+
+	return 0;
+}
+
+/* Branch taken by runtime decision */
+static int bpf_fill_max_jmp_taken(struct bpf_test *self)
+{
+	return __bpf_fill_max_jmp(self, BPF_JEQ, 1);
+}
+
+/* Branch not taken by runtime decision */
+static int bpf_fill_max_jmp_not_taken(struct bpf_test *self)
+{
+	return __bpf_fill_max_jmp(self, BPF_JEQ, 0);
+}
+
+/* Branch always taken, known at JIT time */
+static int bpf_fill_max_jmp_always_taken(struct bpf_test *self)
+{
+	return __bpf_fill_max_jmp(self, BPF_JGE, 0);
+}
+
+/* Branch never taken, known at JIT time */
+static int bpf_fill_max_jmp_never_taken(struct bpf_test *self)
+{
+	return __bpf_fill_max_jmp(self, BPF_JLT, 0);
+}
+
 /* Test an ALU shift operation for all valid shift values */
 static int __bpf_fill_alu_shift(struct bpf_test *self, u8 op,
 				u8 mode, bool alu32)
@@ -8653,14 +8685,6 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 1 } },
 	},
-	{	/* Mainly checking JIT here. */
-		"BPF_MAXINSNS: Very long conditional jump",
-		{ },
-		INTERNAL | FLAG_NO_DATA,
-		{ },
-		{ { 0, 1 } },
-		.fill_helper = bpf_fill_long_jmp,
-	},
 	{
 		"JMP_JA: Jump, gap, jump, ...",
 		{ },
@@ -11009,6 +11033,39 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, 0 } },
 	},
+	/* Conditional branch conversions */
+	{
+		"Long conditional jump: taken at runtime",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_max_jmp_taken,
+	},
+	{
+		"Long conditional jump: not taken at runtime",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 2 } },
+		.fill_helper = bpf_fill_max_jmp_not_taken,
+	},
+	{
+		"Long conditional jump: always taken, known at JIT time",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_max_jmp_always_taken,
+	},
+	{
+		"Long conditional jump: never taken, known at JIT time",
+		{ },
+		INTERNAL | FLAG_NO_DATA,
+		{ },
+		{ { 0, 2 } },
+		.fill_helper = bpf_fill_max_jmp_never_taken,
+	},
 	/* Staggered jump sequences, immediate */
 	{
 		"Staggered jumps: JMP_JA",
-- 
2.30.2

