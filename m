Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA8D4030FB
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 00:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349403AbhIGWZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 18:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347837AbhIGWZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 18:25:09 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979C0C0617AF
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 15:24:01 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bt14so47112ejb.3
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 15:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SvTqgiVuJ0nzlvet/gavj4LBDX8bzgVniFImt4+vvyQ=;
        b=wMo8I2L+lMHTY5GG18FUPBa1WRzriHGfrYeMN2UY2MRyIwwwdcBXTlalUUAkDx15wI
         lWOh2h1zXREgWK7MXVcBCFHIQf7GqLVstgX6jMQbQTccPa6Cqm/2CTz71UudnVF61qp0
         4Z/g4ikDyLe+5rsoardJiHG2jUGyZt4H4rv9ZCPIN1P8eJX4hYdRX8poHSlTzi8dVod5
         c9w84oRcvQga0AN3yBtCpqL4smoIyJWO2XOOfkcZPa55YwPys5eSmH1MQ5X2banmCTul
         VMmsXuBRUOHzXIjecER4b5HXbmtCFPb2U/pMTBcMXSQoANFFurl/9tB+fsal3FkH+azF
         5OTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SvTqgiVuJ0nzlvet/gavj4LBDX8bzgVniFImt4+vvyQ=;
        b=Kh9NCjBWiS54RttwEKoa4Evxp0OjSls91MKR+88SuQl7m6nAJybfpo8sHqhi/8QKlB
         gLqqHPaXIcVo4Bj+vjT20vutxS2LXqTxFrPj5YvtnAWzKkjJ299BqUlA6Kt+TKWMDJ+V
         CwddWd8TUe6KvbqisFvj86kusVckZOxujJX+MZZskqMcmE7VGi0xPGAAEeyRFVdDlBIB
         wQxS/1Ep9YtR9ToywMvcgJeK7Lt9bRJyFWCXVA+Z5I5Nib7LAfYTS2xWb3AdSICBtsLj
         jNSx9TTCfYvNAeSoBVyEDqweMoT83TQNC/aaEmpEGfiRoPGY/weTmDsPnBuX/vPbwEn7
         7E8w==
X-Gm-Message-State: AOAM5316tjFu4esergtwYCiCBcxjeTEppt1QB7OY2iWMCSIXoA9mCozl
        0o6ELxjLjjyEOlo78pEaQ/P5NQ==
X-Google-Smtp-Source: ABdhPJxseIs2s4Yw1wtPttxCYRq9K9WkFcR+11LvHe16CrOSubQjHngL/ZCxB+FEq1pmjGtEvV32WA==
X-Received: by 2002:a17:906:160a:: with SMTP id m10mr659897ejd.67.1631053440097;
        Tue, 07 Sep 2021 15:24:00 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id gb24sm71772ejc.53.2021.09.07.15.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 15:23:59 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 11/13] bpf/tests: Expand branch conversion JIT test
Date:   Wed,  8 Sep 2021 00:23:37 +0200
Message-Id: <20210907222339.4130924-12-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
References: <20210907222339.4130924-1-johan.almbladh@anyfinetworks.com>
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
2.25.1

