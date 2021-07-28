Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864173D93EF
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 19:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhG1RGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 13:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhG1RFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 13:05:47 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6501AC061765
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 10:05:45 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id qk33so5671450ejc.12
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 10:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SCz4BfV77LsGB5K+NjXSEmHrCK2TrOrZWrE8e15FO7w=;
        b=Hqm2Dfldwo+xz6FQB7zW3Iou/38O4xBCBLk5t4TbD/uhF9CftxUqd2TpooJkfflVpN
         TX5IjRmN1UuYRTFLHhNSI1CUTcMJ2CLmssod7aNH7LcS0kH9mDkxwh3Bt+zKfc/10gTd
         WlL9EfP1OL/81ERtN6SwaisNpjWTkpkcCxxJ5pb+aCYXVpqm/OQ7PB3j1ACaWTyVSlF7
         3gPOt8S6ucNLuDnR7pN6xlhG8eS2IYy1fAHLCIZqMip2C6NEOiRHy4Fe4Y/pf8UMTIt2
         l1J5byzCPqQwFNn6v93UT3j+I2qcdML7IJY15oB5zYOTN5Ox3s3E4ugE5SZjU+NIY+Um
         /QHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SCz4BfV77LsGB5K+NjXSEmHrCK2TrOrZWrE8e15FO7w=;
        b=W4UX9xQwszpfsy0rA8btGaUw1Km3bua3S3XuiFqi1VHYVqR0etNdQsdmJ0ULK0DXIF
         Uz6YAGpglhX/bWcqMWKOSO8z6UStjsI6ZMHi+RxqrV2f3+Rw5htpQuQ1PpJ8b0U1DeMh
         FCGsWfiSX616BI7woK7cqhRDl2xmSr2p17QxsJKikiG5DT1z795KQKH2/dyy6YJlzefI
         HPio7M1chXYR9ZYcL/7FSuW0lGrclq9smqYlMltxzW7N19nc/MS5HP795OvZMB3eLhO4
         NzHB1oLg4/rhOyyuBgOZNbu4BlJnfv7Qfhgt7Km8VflSipo3Nx5uqWWPsynxUDBpckH+
         +bYw==
X-Gm-Message-State: AOAM530chBkjym4abuAxQjzSh7pC/3EddjuX4PidsXbvb7dOhpwdVlVy
        VZX5LxIdMRdHLj1dQ+eUp9Ajhw==
X-Google-Smtp-Source: ABdhPJy1jO+cMwuPhrgYXaafirPTBRWDpfzvwxsB4D45rxurRez9QRZaO4uUUKgEmWcP27qNPhUa3g==
X-Received: by 2002:a17:907:1b1b:: with SMTP id mp27mr452790ejc.538.1627491944032;
        Wed, 28 Jul 2021 10:05:44 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bd24sm139349edb.56.2021.07.28.10.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 10:05:43 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH 13/14] bpf/tests: Add tests for BPF_CMPXCHG
Date:   Wed, 28 Jul 2021 19:05:01 +0200
Message-Id: <20210728170502.351010-14-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
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

