Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073D43FF397
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 20:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347251AbhIBSym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347230AbhIBSxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 14:53:50 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54984C0617A8
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 11:52:50 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id jg16so3555896ejc.1
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 11:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IDB9BM4i2Xff5v/pf6BqElozWGGje719ZnXhwBDoSyo=;
        b=QWx0aZegfr20sXl80iIiJxgV782f9yRpyZD3SlApoVY65yj6evZsulbYHYhQ2W9EZA
         Zty3Cogk0zPY6TWMrDIbHDcVvhhYD8auW3+XIOufdLtyXKQ8HByfd/nFpn2A2ZOxrGGf
         dyEZoTDe6O4YVpXav0sJwoYSKnp5gg6LdoPwUgFLt/xnI6FFmJPNcQKnH0ioMmZNNmSY
         3urzjMXuyv5V6VWj+jCDqxIQbfkXWaiQBzhX1w00oHM7vIYwiJciDrkwGTG/IvbjWJqi
         hWczQ0NsCoDDE68E7hSJxyIjnDNyKF6+nVL4DaFjlwbshykaXw3HHFuW6xf3PSiFFI1S
         C0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IDB9BM4i2Xff5v/pf6BqElozWGGje719ZnXhwBDoSyo=;
        b=dOHtoZigHN2PznS7NqlqxLrAcia4eU9bH1xOPWYgZw7H+bqM2Un7PYIq+m3pcuJkBV
         vZx0tGtWedfaQCnVl8aQDhDGIeTIjXaYyxRWCDY2Q3elCwHZEJXn3x8ruJKdqqPi2cwz
         MT9T59AHO8MzQJ4Xkx/wxSRYmt6JKPZGg5iJl+C2EyZ/0787vIR6SrLofqPbZk0sdX4a
         fu1QGX1uIxM/p7uIDQL8TnLfpJHkskAZjOsK9Zxzf3OiTrzJF5Y8luE54+VgwoNv+yKV
         Rr/+2Pk8ZOaiE2KsYN93QbpLIxzTOHuheIHNE4qSenMEvktnYsFQrXO/V8bf5KW0My1a
         /vBg==
X-Gm-Message-State: AOAM533pxR0faYi7lQjs/KUp8doq64v8tAJdbpgWYeatZSd3xwwgJcCY
        Fp01E0l5KcOLb4ubjcrpGeIq8w==
X-Google-Smtp-Source: ABdhPJxQmUaVvKmuRhEPkcLva+gOT1aQE/BfzkgIX0q23G8HZy0vBWSqFho7mnppwlZPYXJ6dx6ygg==
X-Received: by 2002:a17:906:a044:: with SMTP id bg4mr5335570ejb.312.1630608768947;
        Thu, 02 Sep 2021 11:52:48 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id mb14sm1592235ejb.81.2021.09.02.11.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 11:52:48 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        iii@linux.ibm.com
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 11/13] bpf/tests: Expand branch conversion JIT test
Date:   Thu,  2 Sep 2021 20:52:27 +0200
Message-Id: <20210902185229.1840281-12-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
References: <20210902185229.1840281-1-johan.almbladh@anyfinetworks.com>
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
index b28cd815b6b7..3eb25d4b58af 100644
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
@@ -8651,14 +8683,6 @@ static struct bpf_test tests[] = {
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
@@ -11007,6 +11031,39 @@ static struct bpf_test tests[] = {
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

