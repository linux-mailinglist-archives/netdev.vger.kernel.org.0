Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5696941EE36
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhJANHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354077AbhJANGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:06:51 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD76C061787
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:04:09 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id dj4so35547390edb.5
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ERLGDhV2pBfoTQi2z5jcvKZZQA7s+VbF/uLzKflc344=;
        b=aAstHToN9+sA+adJ1X952a4pZ4qmf3+gkfbgZIILdNhAGgi2a5/T/snvVfjcC+nXsL
         +SAgQ+mH7K1erqJG5tssiQhpSTKV6lgvnAo1K5DD69lchLyV56HyieCgExvv3otQEkDD
         9v22d9r4nrfGBXbJ2YmfTh5tFbK5mOW0sv6gA/FhpcJQVeeUSnUiaguljFZnRNJry9ce
         oweXiAtbJiTcf6uN4jpHFaPMy8hvhEF8qtuGt3vCr8jPUEKDkt+Ao6BIhPznWwHJdwns
         KDge8yU4kgvVKT4kJpFecW4M+6B6NJIJiCcd48vCT67n995c0YwCG6cixwka41o2yFYx
         dZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ERLGDhV2pBfoTQi2z5jcvKZZQA7s+VbF/uLzKflc344=;
        b=cHv1ExcaK2mTPgBt/Iz+WbrbdkxCmnX9+Qnr+zvFLZJxOJly4A3UJ/TlXzxjTyvkrn
         9IlY+FCxQOlrGm+3VzHE7DCVbM25agXkA81iI7bwQq9vha8kZqj6Od0KY50K8FX3NTwz
         JtTRN7hzWuUBm/fhA/rUvGSBWiUYppQdv8ImwPs4f8LaI880k0Qpil+jLb1bX8ZOsqGG
         +MXqTSCDGGMggnsYhQjpGTk22vUmuQBYWw13Za+AMA+tL1nm8TkUR+8MWMe7+FXIt1B3
         q8ZJ3KGdzD4qpvDx6sMXffcmcWDCFajUmdylXrM3SSGE9mP6jP137FOSqJAnBUpuwwLu
         05QA==
X-Gm-Message-State: AOAM530w4Xe0djyUqKbq0Y5wcy3grBnLAFFMCNp1lv695uiboHZ2FAiL
        fidyFiSMHk79IrZPmQiwYvThug==
X-Google-Smtp-Source: ABdhPJyGVFnd8U3qrHZwUay8HgFmSidD3IJKVnC0zV5GSx37zcmn6/e2W3oRssJdmSRsNXPG/15NNA==
X-Received: by 2002:a17:906:4c4a:: with SMTP id d10mr6264672ejw.391.1633093447628;
        Fri, 01 Oct 2021 06:04:07 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id p22sm2920279ejl.90.2021.10.01.06.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:04:07 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 08/10] bpf/tests: Add exhaustive tests of BPF_ATOMIC register combinations
Date:   Fri,  1 Oct 2021 15:03:46 +0200
Message-Id: <20211001130348.3670534-9-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
References: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests of all register combinations for BPF_ATOMIC
operations on both BPF_W and BPF_DW sizes.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 422 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 422 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 924bf4c9783c..40db4cee4f51 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -1805,6 +1805,246 @@ static int bpf_fill_cmpxchg32(struct bpf_test *self)
 				  &__bpf_emit_cmpxchg32);
 }
 
+/*
+ * Test JITs that implement ATOMIC operations as function calls or
+ * other primitives, and must re-arrange operands for argument passing.
+ */
+static int __bpf_fill_atomic_reg_pairs(struct bpf_test *self, u8 width, u8 op)
+{
+	struct bpf_insn *insn;
+	int len = 2 + 34 * 10 * 10;
+	u64 mem, upd, res;
+	int rd, rs, i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	/* Operand and memory values */
+	if (width == BPF_DW) {
+		mem = 0x0123456789abcdefULL;
+		upd = 0xfedcba9876543210ULL;
+	} else { /* BPF_W */
+		mem = 0x01234567U;
+		upd = 0x76543210U;
+	}
+
+	/* Memory updated according to operation */
+	switch (op) {
+	case BPF_XCHG:
+		res = upd;
+		break;
+	case BPF_CMPXCHG:
+		res = mem;
+		break;
+	default:
+		__bpf_alu_result(&res, mem, upd, BPF_OP(op));
+	}
+
+	/* Test all operand registers */
+	for (rd = R0; rd <= R9; rd++) {
+		for (rs = R0; rs <= R9; rs++) {
+			u64 cmp, src;
+
+			/* Initialize value in memory */
+			i += __bpf_ld_imm64(&insn[i], R0, mem);
+			insn[i++] = BPF_STX_MEM(width, R10, R0, -8);
+
+			/* Initialize registers in order */
+			i += __bpf_ld_imm64(&insn[i], R0, ~mem);
+			i += __bpf_ld_imm64(&insn[i], rs, upd);
+			insn[i++] = BPF_MOV64_REG(rd, R10);
+
+			/* Perform atomic operation */
+			insn[i++] = BPF_ATOMIC_OP(width, op, rd, rs, -8);
+			if (op == BPF_CMPXCHG && width == BPF_W)
+				insn[i++] = BPF_ZEXT_REG(R0);
+
+			/* Check R0 register value */
+			if (op == BPF_CMPXCHG)
+				cmp = mem;  /* Expect value from memory */
+			else if (R0 == rd || R0 == rs)
+				cmp = 0;    /* Aliased, checked below */
+			else
+				cmp = ~mem; /* Expect value to be preserved */
+			if (cmp) {
+				insn[i++] = BPF_JMP32_IMM(BPF_JEQ, R0,
+							   (u32)cmp, 2);
+				insn[i++] = BPF_MOV32_IMM(R0, __LINE__);
+				insn[i++] = BPF_EXIT_INSN();
+				insn[i++] = BPF_ALU64_IMM(BPF_RSH, R0, 32);
+				insn[i++] = BPF_JMP32_IMM(BPF_JEQ, R0,
+							   cmp >> 32, 2);
+				insn[i++] = BPF_MOV32_IMM(R0, __LINE__);
+				insn[i++] = BPF_EXIT_INSN();
+			}
+
+			/* Check source register value */
+			if (rs == R0 && op == BPF_CMPXCHG)
+				src = 0;   /* Aliased with R0, checked above */
+			else if (rs == rd && (op == BPF_CMPXCHG ||
+					      !(op & BPF_FETCH)))
+				src = 0;   /* Aliased with rd, checked below */
+			else if (op == BPF_CMPXCHG)
+				src = upd; /* Expect value to be preserved */
+			else if (op & BPF_FETCH)
+				src = mem; /* Expect fetched value from mem */
+			else /* no fetch */
+				src = upd; /* Expect value to be preserved */
+			if (src) {
+				insn[i++] = BPF_JMP32_IMM(BPF_JEQ, rs,
+							   (u32)src, 2);
+				insn[i++] = BPF_MOV32_IMM(R0, __LINE__);
+				insn[i++] = BPF_EXIT_INSN();
+				insn[i++] = BPF_ALU64_IMM(BPF_RSH, rs, 32);
+				insn[i++] = BPF_JMP32_IMM(BPF_JEQ, rs,
+							   src >> 32, 2);
+				insn[i++] = BPF_MOV32_IMM(R0, __LINE__);
+				insn[i++] = BPF_EXIT_INSN();
+			}
+
+			/* Check destination register value */
+			if (!(rd == R0 && op == BPF_CMPXCHG) &&
+			    !(rd == rs && (op & BPF_FETCH))) {
+				insn[i++] = BPF_JMP_REG(BPF_JEQ, rd, R10, 2);
+				insn[i++] = BPF_MOV32_IMM(R0, __LINE__);
+				insn[i++] = BPF_EXIT_INSN();
+			}
+
+			/* Check value in memory */
+			if (rs != rd) {                  /* No aliasing */
+				i += __bpf_ld_imm64(&insn[i], R1, res);
+			} else if (op == BPF_XCHG) {     /* Aliased, XCHG */
+				insn[i++] = BPF_MOV64_REG(R1, R10);
+			} else if (op == BPF_CMPXCHG) {  /* Aliased, CMPXCHG */
+				i += __bpf_ld_imm64(&insn[i], R1, mem);
+			} else {                        /* Aliased, ALU oper */
+				i += __bpf_ld_imm64(&insn[i], R1, mem);
+				insn[i++] = BPF_ALU64_REG(BPF_OP(op), R1, R10);
+			}
+
+			insn[i++] = BPF_LDX_MEM(width, R0, R10, -8);
+			if (width == BPF_DW)
+				insn[i++] = BPF_JMP_REG(BPF_JEQ, R0, R1, 2);
+			else /* width == BPF_W */
+				insn[i++] = BPF_JMP32_REG(BPF_JEQ, R0, R1, 2);
+			insn[i++] = BPF_MOV32_IMM(R0, __LINE__);
+			insn[i++] = BPF_EXIT_INSN();
+		}
+	}
+
+	insn[i++] = BPF_MOV64_IMM(R0, 1);
+	insn[i++] = BPF_EXIT_INSN();
+
+	self->u.ptr.insns = insn;
+	self->u.ptr.len = i;
+	BUG_ON(i > len);
+
+	return 0;
+}
+
+/* 64-bit atomic register tests */
+static int bpf_fill_atomic64_add_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_DW, BPF_ADD);
+}
+
+static int bpf_fill_atomic64_and_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_DW, BPF_AND);
+}
+
+static int bpf_fill_atomic64_or_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_DW, BPF_OR);
+}
+
+static int bpf_fill_atomic64_xor_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_DW, BPF_XOR);
+}
+
+static int bpf_fill_atomic64_add_fetch_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_DW, BPF_ADD | BPF_FETCH);
+}
+
+static int bpf_fill_atomic64_and_fetch_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_DW, BPF_AND | BPF_FETCH);
+}
+
+static int bpf_fill_atomic64_or_fetch_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_DW, BPF_OR | BPF_FETCH);
+}
+
+static int bpf_fill_atomic64_xor_fetch_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_DW, BPF_XOR | BPF_FETCH);
+}
+
+static int bpf_fill_atomic64_xchg_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_DW, BPF_XCHG);
+}
+
+static int bpf_fill_atomic64_cmpxchg_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_DW, BPF_CMPXCHG);
+}
+
+/* 32-bit atomic register tests */
+static int bpf_fill_atomic32_add_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_W, BPF_ADD);
+}
+
+static int bpf_fill_atomic32_and_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_W, BPF_AND);
+}
+
+static int bpf_fill_atomic32_or_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_W, BPF_OR);
+}
+
+static int bpf_fill_atomic32_xor_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_W, BPF_XOR);
+}
+
+static int bpf_fill_atomic32_add_fetch_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_W, BPF_ADD | BPF_FETCH);
+}
+
+static int bpf_fill_atomic32_and_fetch_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_W, BPF_AND | BPF_FETCH);
+}
+
+static int bpf_fill_atomic32_or_fetch_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_W, BPF_OR | BPF_FETCH);
+}
+
+static int bpf_fill_atomic32_xor_fetch_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_W, BPF_XOR | BPF_FETCH);
+}
+
+static int bpf_fill_atomic32_xchg_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_W, BPF_XCHG);
+}
+
+static int bpf_fill_atomic32_cmpxchg_reg_pairs(struct bpf_test *self)
+{
+	return __bpf_fill_atomic_reg_pairs(self, BPF_W, BPF_CMPXCHG);
+}
+
 /*
  * Test the two-instruction 64-bit immediate load operation for all
  * power-of-two magnitudes of the immediate operand. For each MSB, a block
@@ -11976,6 +12216,188 @@ static struct bpf_test tests[] = {
 		{ { 0, 1 } },
 		.fill_helper = bpf_fill_ld_imm64,
 	},
+	/* 64-bit ATOMIC register combinations */
+	{
+		"ATOMIC_DW_ADD: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_add_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_DW_AND: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_and_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_DW_OR: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_or_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_DW_XOR: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_xor_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_DW_ADD_FETCH: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_add_fetch_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_DW_AND_FETCH: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_and_fetch_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_DW_OR_FETCH: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_or_fetch_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_DW_XOR_FETCH: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_xor_fetch_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_DW_XCHG: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_xchg_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_DW_CMPXCHG: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic64_cmpxchg_reg_pairs,
+		.stack_depth = 8,
+	},
+	/* 32-bit ATOMIC register combinations */
+	{
+		"ATOMIC_W_ADD: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_add_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_W_AND: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_and_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_W_OR: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_or_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_W_XOR: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_xor_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_W_ADD_FETCH: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_add_fetch_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_W_AND_FETCH: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_and_fetch_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_W_OR_FETCH: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_or_fetch_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_W_XOR_FETCH: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_xor_fetch_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_W_XCHG: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_xchg_reg_pairs,
+		.stack_depth = 8,
+	},
+	{
+		"ATOMIC_W_CMPXCHG: register combinations",
+		{ },
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+		.fill_helper = bpf_fill_atomic32_cmpxchg_reg_pairs,
+		.stack_depth = 8,
+	},
 	/* 64-bit ATOMIC magnitudes */
 	{
 		"ATOMIC_DW_ADD: all operand magnitudes",
-- 
2.30.2

