Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2731D3D5561
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhGZHiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbhGZHiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:38:13 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A899C061765
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:42 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id j2so8559059edp.11
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SCz4BfV77LsGB5K+NjXSEmHrCK2TrOrZWrE8e15FO7w=;
        b=PJKAKslg+FUhNFjUl/u5DQzcrH8YluGq8XcNMUs8Sy2masPjFoxCGJ29asgFyUWxHV
         dOng/kKdOKW4WRurXzsWn7eeM716ThUqqia172jepuHbccNdLtSYP6VeQkYlaiyFySCs
         UXII162NLh7XTRLFVDnBvH3oDdgnp9KM1NQdC3nDOKrKi2w4MKk5sNkywCTuNIzFb4c4
         y6KOl4bzguqO6/MrCHycC1r3ca9naEdoaIKuJEaD2lkSciXJC4+XkYk1HEDKkk/g1Vki
         9YPx+ALgh2Al1CIvvO9lk5H0L+yIThXDaKhQYXFStVEcKrtIecIC/UP5hodIVefO2xiH
         totg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SCz4BfV77LsGB5K+NjXSEmHrCK2TrOrZWrE8e15FO7w=;
        b=OD+Kv90KYtq8FJVNubuRuSo0oLq0ODdV8tVVmWXztmTLf59C+b7tbo9OQFtxi0YGgY
         hua5Zo7h+Gj+gXtQKywurRzptovO2+XbrUnmQW4PKgntmiRfCFUq/XagHoYDjw9dglO6
         0027PK3l10+QiJ4OS4HC42LPa3nMZ0RnlqxHoIdAOPC6Ni+vbsFGpIzs+RbNj3U+14yA
         0aBJHLjl8n2373xqf+9M9Ta7Vp6aWiYYzEJ2GoWlwYUzu8GQzuIxpSD4xSumPaFR9o//
         ybKrFJloYPa21Iz2oyEg8QXvnWVmdYqxVK1Kr33F0mkZ58lhrQwUmksJ/5hvZ0c4mxyQ
         exag==
X-Gm-Message-State: AOAM53083NCEU77twUbyndKPSHkYNl0txJs3Xc0Ri/THGZD8asyyEuYU
        HyNqXqCoxXDLUrQmD+J0Uld6Xg==
X-Google-Smtp-Source: ABdhPJwpZjWht7jGlTLjwNDzbuR2iPhkHL5YUjo0PamcrUAc5U0RZIW3j1L7yKyFIXcIXElGUw2a0Q==
X-Received: by 2002:aa7:cfcf:: with SMTP id r15mr19858420edy.161.1627287521215;
        Mon, 26 Jul 2021 01:18:41 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id q9sm13937539ejf.70.2021.07.26.01.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:18:40 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 13/14] bpf/tests: add tests for BPF_CMPXCHG
Date:   Mon, 26 Jul 2021 10:17:37 +0200
Message-Id: <20210726081738.1833704-14-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
References: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tests for BPF_CMPXCHG with both word and double word operands. As with
the tests for other atomic operations, these tests only check the result
of the arithmetic operation. The atomicity of the operations is not tested.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 166 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 166 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ac50cb023324..af5758151d0a 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -5682,6 +5682,172 @@ static struct bpf_test tests[] = {
 #undef BPF_ATOMIC_OP_TEST2
 #undef BPF_ATOMIC_OP_TEST3
 #undef BPF_ATOMIC_OP_TEST4
+	/* BPF_ATOMIC | BPF_W, BPF_CMPXCHG */
+	{
+		"BPF_ATOMIC | BPF_W, BPF_CMPXCHG: Test successful return",
+		.u.insns_int = {
+			BPF_ST_MEM(BPF_W, R10, -40, 0x01234567),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0x01234567),
+			BPF_ALU32_IMM(BPF_MOV, R3, 0x89abcdef),
+			BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R3, -40),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x01234567 } },
+		.stack_depth = 40,
+	},
+	{
+		"BPF_ATOMIC | BPF_W, BPF_CMPXCHG: Test successful store",
+		.u.insns_int = {
+			BPF_ST_MEM(BPF_W, R10, -40, 0x01234567),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0x01234567),
+			BPF_ALU32_IMM(BPF_MOV, R3, 0x89abcdef),
+			BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R3, -40),
+			BPF_LDX_MEM(BPF_W, R0, R10, -40),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x89abcdef } },
+		.stack_depth = 40,
+	},
+	{
+		"BPF_ATOMIC | BPF_W, BPF_CMPXCHG: Test failure return",
+		.u.insns_int = {
+			BPF_ST_MEM(BPF_W, R10, -40, 0x01234567),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0x76543210),
+			BPF_ALU32_IMM(BPF_MOV, R3, 0x89abcdef),
+			BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R3, -40),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x01234567 } },
+		.stack_depth = 40,
+	},
+	{
+		"BPF_ATOMIC | BPF_W, BPF_CMPXCHG: Test failure store",
+		.u.insns_int = {
+			BPF_ST_MEM(BPF_W, R10, -40, 0x01234567),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0x76543210),
+			BPF_ALU32_IMM(BPF_MOV, R3, 0x89abcdef),
+			BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R3, -40),
+			BPF_LDX_MEM(BPF_W, R0, R10, -40),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x01234567 } },
+		.stack_depth = 40,
+	},
+	{
+		"BPF_ATOMIC | BPF_W, BPF_CMPXCHG: Test side effects",
+		.u.insns_int = {
+			BPF_ST_MEM(BPF_W, R10, -40, 0x01234567),
+			BPF_ALU32_IMM(BPF_MOV, R0, 0x01234567),
+			BPF_ALU32_IMM(BPF_MOV, R3, 0x89abcdef),
+			BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R3, -40),
+			BPF_ATOMIC_OP(BPF_W, BPF_CMPXCHG, R10, R3, -40),
+			BPF_ALU32_REG(BPF_MOV, R0, R3),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0x89abcdef } },
+		.stack_depth = 40,
+	},
+	/* BPF_ATOMIC | BPF_DW, BPF_CMPXCHG */
+	{
+		"BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test successful return",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x0123456789abcdefULL),
+			BPF_LD_IMM64(R2, 0xfecdba9876543210ULL),
+			BPF_ALU64_REG(BPF_MOV, R0, R1),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, R10, R2, -40),
+			BPF_JMP_REG(BPF_JNE, R0, R1, 1),
+			BPF_ALU64_REG(BPF_SUB, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 40,
+	},
+	{
+		"BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test successful store",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x0123456789abcdefULL),
+			BPF_LD_IMM64(R2, 0xfecdba9876543210ULL),
+			BPF_ALU64_REG(BPF_MOV, R0, R1),
+			BPF_STX_MEM(BPF_DW, R10, R0, -40),
+			BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, R10, R2, -40),
+			BPF_LDX_MEM(BPF_DW, R0, R10, -40),
+			BPF_JMP_REG(BPF_JNE, R0, R2, 1),
+			BPF_ALU64_REG(BPF_SUB, R0, R2),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 40,
+	},
+	{
+		"BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test failure return",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x0123456789abcdefULL),
+			BPF_LD_IMM64(R2, 0xfecdba9876543210ULL),
+			BPF_ALU64_REG(BPF_MOV, R0, R1),
+			BPF_ALU64_IMM(BPF_ADD, R0, 1),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, R10, R2, -40),
+			BPF_JMP_REG(BPF_JNE, R0, R1, 1),
+			BPF_ALU64_REG(BPF_SUB, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 40,
+	},
+	{
+		"BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test failure store",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x0123456789abcdefULL),
+			BPF_LD_IMM64(R2, 0xfecdba9876543210ULL),
+			BPF_ALU64_REG(BPF_MOV, R0, R1),
+			BPF_ALU64_IMM(BPF_ADD, R0, 1),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, R10, R2, -40),
+			BPF_LDX_MEM(BPF_DW, R0, R10, -40),
+			BPF_JMP_REG(BPF_JNE, R0, R1, 1),
+			BPF_ALU64_REG(BPF_SUB, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 40,
+	},
+	{
+		"BPF_ATOMIC | BPF_DW, BPF_CMPXCHG: Test side effects",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x0123456789abcdefULL),
+			BPF_LD_IMM64(R2, 0xfecdba9876543210ULL),
+			BPF_ALU64_REG(BPF_MOV, R0, R1),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_ATOMIC_OP(BPF_DW, BPF_CMPXCHG, R10, R2, -40),
+			BPF_LD_IMM64(R0, 0xfecdba9876543210ULL),
+			BPF_JMP_REG(BPF_JNE, R0, R2, 1),
+			BPF_ALU64_REG(BPF_SUB, R0, R2),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 40,
+	},
 	/* BPF_JMP32 | BPF_JEQ | BPF_K */
 	{
 		"JMP32_JEQ_K: Small immediate",
-- 
2.25.1

