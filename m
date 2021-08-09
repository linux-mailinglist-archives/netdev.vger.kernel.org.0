Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9C83E4271
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhHIJTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234386AbhHIJTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:19:16 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBE1C06179E
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:18:55 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id c25so13862146ejb.3
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+YEY+KfnyxiS2i6H1cgAPFR1ad7rvrlCPVokGNnH+r0=;
        b=dq5j9KDCvkUANmrXblDfakY/YwoJ60u8wCGsOq7JkC/+MHS3jmO7+rxIPDlsxjWUtk
         LGnOZzpBPjVPzW+JYpoJYqHFcq0Zv2sN0DCVqRRZsNGdP+jNJKX0rMB0k39SKlZPrum2
         eI2tgCDHC8I0MVLz5HN3t3raKkqJtShHSlNmQG/tR7JLxAXEm40FSg3Jv8bMlqTBqFKT
         vwLdPzabozAKSNDflF3yw9hqCH/h4gIfzmuX/zLGUyNmtKCD5Tw361s2rv1SlLHO9dL/
         EfT/KjIYLixreIXU8oOVCaQLOI6UEQ+pGzhgJAX35jMWFPeJaN9pn/s6vuuqIkQv+8RQ
         v+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+YEY+KfnyxiS2i6H1cgAPFR1ad7rvrlCPVokGNnH+r0=;
        b=AQrwUOaoVd9y2+3zjdAOopzRXRnVPc8QB/uJUF2KvmHakM5c+LE/a//xMwVWSFuNK5
         rX9HVHQyOs/qnbhhiiUx4l+QrnR+bs+VoZ+GLSnSL4u0QYnoHbaFx7PPkng24goRS5Ct
         KkrNqDKBXGTZKzJi3krdxDMRGvTyhjGmizNCgXUsvlETBQsZf/CZC2qS1m9DkNh+rrrI
         r51tqmvpPMWbwXerRNlsunKH1G4UDv4057n0vlsuaXSJbEQCthWnGCBy4GFIcq4V/xi7
         cE6kBjypmAfQ4MI7mc2qkY0fnZh9s49ysgEK/9lMmcPfKwqe6P5HkAlBKTP/Yr0ElrqE
         Js/A==
X-Gm-Message-State: AOAM530WaG8srJ9WBuIQaUJlsIeBAT7mHJJiHqQweC8y1FgrTb2Owhqv
        SaCSqvpTf1RnItRHY/Hk5apBmA==
X-Google-Smtp-Source: ABdhPJzx+2GtJOnG9MdUFhovO6cDvwIoTkJLbyiH3mxNjqfww4QooRpCD5NVcETlEnr/enXzLw2H1g==
X-Received: by 2002:a17:906:5d06:: with SMTP id g6mr21244109ejt.96.1628500734140;
        Mon, 09 Aug 2021 02:18:54 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id dg24sm1234250edb.6.2021.08.09.02.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:18:53 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 12/14] bpf/tests: Add tests for atomic operations
Date:   Mon,  9 Aug 2021 11:18:27 +0200
Message-Id: <20210809091829.810076-13-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
References: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tests for each atomic arithmetic operation and BPF_XCHG, derived from
old BPF_XADD tests. The tests include BPF_W/DW and BPF_FETCH variants.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 lib/test_bpf.c | 252 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 166 insertions(+), 86 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index fcfaf45ae58a..855f64093ca7 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -5508,49 +5508,6 @@ static struct bpf_test tests[] = {
 		.stack_depth = 40,
 	},
 	/* BPF_STX | BPF_ATOMIC | BPF_W/DW */
-	{
-		"STX_XADD_W: Test: 0x12 + 0x10 = 0x22",
-		.u.insns_int = {
-			BPF_ALU32_IMM(BPF_MOV, R0, 0x12),
-			BPF_ST_MEM(BPF_W, R10, -40, 0x10),
-			BPF_ATOMIC_OP(BPF_W, BPF_ADD, R10, R0, -40),
-			BPF_LDX_MEM(BPF_W, R0, R10, -40),
-			BPF_EXIT_INSN(),
-		},
-		INTERNAL,
-		{ },
-		{ { 0, 0x22 } },
-		.stack_depth = 40,
-	},
-	{
-		"STX_XADD_W: Test side-effects, r10: 0x12 + 0x10 = 0x22",
-		.u.insns_int = {
-			BPF_ALU64_REG(BPF_MOV, R1, R10),
-			BPF_ALU32_IMM(BPF_MOV, R0, 0x12),
-			BPF_ST_MEM(BPF_W, R10, -40, 0x10),
-			BPF_ATOMIC_OP(BPF_W, BPF_ADD, R10, R0, -40),
-			BPF_ALU64_REG(BPF_MOV, R0, R10),
-			BPF_ALU64_REG(BPF_SUB, R0, R1),
-			BPF_EXIT_INSN(),
-		},
-		INTERNAL,
-		{ },
-		{ { 0, 0 } },
-		.stack_depth = 40,
-	},
-	{
-		"STX_XADD_W: Test side-effects, r0: 0x12 + 0x10 = 0x22",
-		.u.insns_int = {
-			BPF_ALU32_IMM(BPF_MOV, R0, 0x12),
-			BPF_ST_MEM(BPF_W, R10, -40, 0x10),
-			BPF_ATOMIC_OP(BPF_W, BPF_ADD, R10, R0, -40),
-			BPF_EXIT_INSN(),
-		},
-		INTERNAL,
-		{ },
-		{ { 0, 0x12 } },
-		.stack_depth = 40,
-	},
 	{
 		"STX_XADD_W: X + 1 + 1 + 1 + ...",
 		{ },
@@ -5559,49 +5516,6 @@ static struct bpf_test tests[] = {
 		{ { 0, 4134 } },
 		.fill_helper = bpf_fill_stxw,
 	},
-	{
-		"STX_XADD_DW: Test: 0x12 + 0x10 = 0x22",
-		.u.insns_int = {
-			BPF_ALU32_IMM(BPF_MOV, R0, 0x12),
-			BPF_ST_MEM(BPF_DW, R10, -40, 0x10),
-			BPF_ATOMIC_OP(BPF_DW, BPF_ADD, R10, R0, -40),
-			BPF_LDX_MEM(BPF_DW, R0, R10, -40),
-			BPF_EXIT_INSN(),
-		},
-		INTERNAL,
-		{ },
-		{ { 0, 0x22 } },
-		.stack_depth = 40,
-	},
-	{
-		"STX_XADD_DW: Test side-effects, r10: 0x12 + 0x10 = 0x22",
-		.u.insns_int = {
-			BPF_ALU64_REG(BPF_MOV, R1, R10),
-			BPF_ALU32_IMM(BPF_MOV, R0, 0x12),
-			BPF_ST_MEM(BPF_DW, R10, -40, 0x10),
-			BPF_ATOMIC_OP(BPF_DW, BPF_ADD, R10, R0, -40),
-			BPF_ALU64_REG(BPF_MOV, R0, R10),
-			BPF_ALU64_REG(BPF_SUB, R0, R1),
-			BPF_EXIT_INSN(),
-		},
-		INTERNAL,
-		{ },
-		{ { 0, 0 } },
-		.stack_depth = 40,
-	},
-	{
-		"STX_XADD_DW: Test side-effects, r0: 0x12 + 0x10 = 0x22",
-		.u.insns_int = {
-			BPF_ALU32_IMM(BPF_MOV, R0, 0x12),
-			BPF_ST_MEM(BPF_DW, R10, -40, 0x10),
-			BPF_ATOMIC_OP(BPF_DW, BPF_ADD, R10, R0, -40),
-			BPF_EXIT_INSN(),
-		},
-		INTERNAL,
-		{ },
-		{ { 0, 0x12 } },
-		.stack_depth = 40,
-	},
 	{
 		"STX_XADD_DW: X + 1 + 1 + 1 + ...",
 		{ },
@@ -5610,6 +5524,172 @@ static struct bpf_test tests[] = {
 		{ { 0, 4134 } },
 		.fill_helper = bpf_fill_stxdw,
 	},
+	/*
+	 * Exhaustive tests of atomic operation variants.
+	 * Individual tests are expanded from template macros for all
+	 * combinations of ALU operation, word size and fetching.
+	 */
+#define BPF_ATOMIC_OP_TEST1(width, op, logic, old, update, result)	\
+{									\
+	"BPF_ATOMIC | " #width ", " #op ": Test: "			\
+		#old " " #logic " " #update " = " #result,		\
+	.u.insns_int = {						\
+		BPF_ALU32_IMM(BPF_MOV, R5, update),			\
+		BPF_ST_MEM(width, R10, -40, old),			\
+		BPF_ATOMIC_OP(width, op, R10, R5, -40),			\
+		BPF_LDX_MEM(width, R0, R10, -40),			\
+		BPF_EXIT_INSN(),					\
+	},								\
+	INTERNAL,							\
+	{ },								\
+	{ { 0, result } },						\
+	.stack_depth = 40,						\
+}
+#define BPF_ATOMIC_OP_TEST2(width, op, logic, old, update, result)	\
+{									\
+	"BPF_ATOMIC | " #width ", " #op ": Test side effects, r10: "	\
+		#old " " #logic " " #update " = " #result,		\
+	.u.insns_int = {						\
+		BPF_ALU64_REG(BPF_MOV, R1, R10),			\
+		BPF_ALU32_IMM(BPF_MOV, R0, update),			\
+		BPF_ST_MEM(BPF_W, R10, -40, old),			\
+		BPF_ATOMIC_OP(width, op, R10, R0, -40),			\
+		BPF_ALU64_REG(BPF_MOV, R0, R10),			\
+		BPF_ALU64_REG(BPF_SUB, R0, R1),				\
+		BPF_EXIT_INSN(),					\
+	},								\
+	INTERNAL,							\
+	{ },								\
+	{ { 0, 0 } },							\
+	.stack_depth = 40,						\
+}
+#define BPF_ATOMIC_OP_TEST3(width, op, logic, old, update, result)	\
+{									\
+	"BPF_ATOMIC | " #width ", " #op ": Test side effects, r0: "	\
+		#old " " #logic " " #update " = " #result,		\
+	.u.insns_int = {						\
+		BPF_ALU64_REG(BPF_MOV, R0, R10),			\
+		BPF_ALU32_IMM(BPF_MOV, R1, update),			\
+		BPF_ST_MEM(width, R10, -40, old),			\
+		BPF_ATOMIC_OP(width, op, R10, R1, -40),			\
+		BPF_ALU64_REG(BPF_SUB, R0, R10),			\
+		BPF_EXIT_INSN(),					\
+	},								\
+	INTERNAL,                                                       \
+	{ },                                                            \
+	{ { 0, 0 } },                                                   \
+	.stack_depth = 40,                                              \
+}
+#define BPF_ATOMIC_OP_TEST4(width, op, logic, old, update, result)	\
+{									\
+	"BPF_ATOMIC | " #width ", " #op ": Test fetch: "		\
+		#old " " #logic " " #update " = " #result,		\
+	.u.insns_int = {						\
+		BPF_ALU32_IMM(BPF_MOV, R3, update),			\
+		BPF_ST_MEM(width, R10, -40, old),			\
+		BPF_ATOMIC_OP(width, op, R10, R3, -40),			\
+		BPF_ALU64_REG(BPF_MOV, R0, R3),                         \
+		BPF_EXIT_INSN(),					\
+	},								\
+	INTERNAL,                                                       \
+	{ },                                                            \
+	{ { 0, (op) & BPF_FETCH ? old : update } },			\
+	.stack_depth = 40,                                              \
+}
+	/* BPF_ATOMIC | BPF_W: BPF_ADD */
+	BPF_ATOMIC_OP_TEST1(BPF_W, BPF_ADD, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST2(BPF_W, BPF_ADD, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST3(BPF_W, BPF_ADD, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST4(BPF_W, BPF_ADD, +, 0x12, 0xab, 0xbd),
+	/* BPF_ATOMIC | BPF_W: BPF_ADD | BPF_FETCH */
+	BPF_ATOMIC_OP_TEST1(BPF_W, BPF_ADD | BPF_FETCH, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST2(BPF_W, BPF_ADD | BPF_FETCH, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST3(BPF_W, BPF_ADD | BPF_FETCH, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST4(BPF_W, BPF_ADD | BPF_FETCH, +, 0x12, 0xab, 0xbd),
+	/* BPF_ATOMIC | BPF_DW: BPF_ADD */
+	BPF_ATOMIC_OP_TEST1(BPF_DW, BPF_ADD, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST2(BPF_DW, BPF_ADD, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST3(BPF_DW, BPF_ADD, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST4(BPF_DW, BPF_ADD, +, 0x12, 0xab, 0xbd),
+	/* BPF_ATOMIC | BPF_DW: BPF_ADD | BPF_FETCH */
+	BPF_ATOMIC_OP_TEST1(BPF_DW, BPF_ADD | BPF_FETCH, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST2(BPF_DW, BPF_ADD | BPF_FETCH, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST3(BPF_DW, BPF_ADD | BPF_FETCH, +, 0x12, 0xab, 0xbd),
+	BPF_ATOMIC_OP_TEST4(BPF_DW, BPF_ADD | BPF_FETCH, +, 0x12, 0xab, 0xbd),
+	/* BPF_ATOMIC | BPF_W: BPF_AND */
+	BPF_ATOMIC_OP_TEST1(BPF_W, BPF_AND, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST2(BPF_W, BPF_AND, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST3(BPF_W, BPF_AND, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST4(BPF_W, BPF_AND, &, 0x12, 0xab, 0x02),
+	/* BPF_ATOMIC | BPF_W: BPF_AND | BPF_FETCH */
+	BPF_ATOMIC_OP_TEST1(BPF_W, BPF_AND | BPF_FETCH, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST2(BPF_W, BPF_AND | BPF_FETCH, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST3(BPF_W, BPF_AND | BPF_FETCH, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST4(BPF_W, BPF_AND | BPF_FETCH, &, 0x12, 0xab, 0x02),
+	/* BPF_ATOMIC | BPF_DW: BPF_AND */
+	BPF_ATOMIC_OP_TEST1(BPF_DW, BPF_AND, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST2(BPF_DW, BPF_AND, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST3(BPF_DW, BPF_AND, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST4(BPF_DW, BPF_AND, &, 0x12, 0xab, 0x02),
+	/* BPF_ATOMIC | BPF_DW: BPF_AND | BPF_FETCH */
+	BPF_ATOMIC_OP_TEST1(BPF_DW, BPF_AND | BPF_FETCH, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST2(BPF_DW, BPF_AND | BPF_FETCH, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST3(BPF_DW, BPF_AND | BPF_FETCH, &, 0x12, 0xab, 0x02),
+	BPF_ATOMIC_OP_TEST4(BPF_DW, BPF_AND | BPF_FETCH, &, 0x12, 0xab, 0x02),
+	/* BPF_ATOMIC | BPF_W: BPF_OR */
+	BPF_ATOMIC_OP_TEST1(BPF_W, BPF_OR, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST2(BPF_W, BPF_OR, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST3(BPF_W, BPF_OR, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST4(BPF_W, BPF_OR, |, 0x12, 0xab, 0xbb),
+	/* BPF_ATOMIC | BPF_W: BPF_OR | BPF_FETCH */
+	BPF_ATOMIC_OP_TEST1(BPF_W, BPF_OR | BPF_FETCH, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST2(BPF_W, BPF_OR | BPF_FETCH, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST3(BPF_W, BPF_OR | BPF_FETCH, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST4(BPF_W, BPF_OR | BPF_FETCH, |, 0x12, 0xab, 0xbb),
+	/* BPF_ATOMIC | BPF_DW: BPF_OR */
+	BPF_ATOMIC_OP_TEST1(BPF_DW, BPF_OR, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST2(BPF_DW, BPF_OR, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST3(BPF_DW, BPF_OR, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST4(BPF_DW, BPF_OR, |, 0x12, 0xab, 0xbb),
+	/* BPF_ATOMIC | BPF_DW: BPF_OR | BPF_FETCH */
+	BPF_ATOMIC_OP_TEST1(BPF_DW, BPF_OR | BPF_FETCH, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST2(BPF_DW, BPF_OR | BPF_FETCH, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST3(BPF_DW, BPF_OR | BPF_FETCH, |, 0x12, 0xab, 0xbb),
+	BPF_ATOMIC_OP_TEST4(BPF_DW, BPF_OR | BPF_FETCH, |, 0x12, 0xab, 0xbb),
+	/* BPF_ATOMIC | BPF_W: BPF_XOR */
+	BPF_ATOMIC_OP_TEST1(BPF_W, BPF_XOR, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST2(BPF_W, BPF_XOR, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST3(BPF_W, BPF_XOR, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST4(BPF_W, BPF_XOR, ^, 0x12, 0xab, 0xb9),
+	/* BPF_ATOMIC | BPF_W: BPF_XOR | BPF_FETCH */
+	BPF_ATOMIC_OP_TEST1(BPF_W, BPF_XOR | BPF_FETCH, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST2(BPF_W, BPF_XOR | BPF_FETCH, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST3(BPF_W, BPF_XOR | BPF_FETCH, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST4(BPF_W, BPF_XOR | BPF_FETCH, ^, 0x12, 0xab, 0xb9),
+	/* BPF_ATOMIC | BPF_DW: BPF_XOR */
+	BPF_ATOMIC_OP_TEST1(BPF_DW, BPF_XOR, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST2(BPF_DW, BPF_XOR, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST3(BPF_DW, BPF_XOR, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST4(BPF_DW, BPF_XOR, ^, 0x12, 0xab, 0xb9),
+	/* BPF_ATOMIC | BPF_DW: BPF_XOR | BPF_FETCH */
+	BPF_ATOMIC_OP_TEST1(BPF_DW, BPF_XOR | BPF_FETCH, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST2(BPF_DW, BPF_XOR | BPF_FETCH, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST3(BPF_DW, BPF_XOR | BPF_FETCH, ^, 0x12, 0xab, 0xb9),
+	BPF_ATOMIC_OP_TEST4(BPF_DW, BPF_XOR | BPF_FETCH, ^, 0x12, 0xab, 0xb9),
+	/* BPF_ATOMIC | BPF_W: BPF_XCHG */
+	BPF_ATOMIC_OP_TEST1(BPF_W, BPF_XCHG, xchg, 0x12, 0xab, 0xab),
+	BPF_ATOMIC_OP_TEST2(BPF_W, BPF_XCHG, xchg, 0x12, 0xab, 0xab),
+	BPF_ATOMIC_OP_TEST3(BPF_W, BPF_XCHG, xchg, 0x12, 0xab, 0xab),
+	BPF_ATOMIC_OP_TEST4(BPF_W, BPF_XCHG, xchg, 0x12, 0xab, 0xab),
+	/* BPF_ATOMIC | BPF_DW: BPF_XCHG */
+	BPF_ATOMIC_OP_TEST1(BPF_DW, BPF_XCHG, xchg, 0x12, 0xab, 0xab),
+	BPF_ATOMIC_OP_TEST2(BPF_DW, BPF_XCHG, xchg, 0x12, 0xab, 0xab),
+	BPF_ATOMIC_OP_TEST3(BPF_DW, BPF_XCHG, xchg, 0x12, 0xab, 0xab),
+	BPF_ATOMIC_OP_TEST4(BPF_DW, BPF_XCHG, xchg, 0x12, 0xab, 0xab),
+#undef BPF_ATOMIC_OP_TEST1
+#undef BPF_ATOMIC_OP_TEST2
+#undef BPF_ATOMIC_OP_TEST3
+#undef BPF_ATOMIC_OP_TEST4
 	/* BPF_JMP32 | BPF_JEQ | BPF_K */
 	{
 		"JMP32_JEQ_K: Small immediate",
-- 
2.25.1

