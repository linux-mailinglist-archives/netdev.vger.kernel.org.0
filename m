Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243D13E4270
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhHIJTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbhHIJTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:19:17 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE61EC0617A0
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:18:56 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id e19so27714089ejs.9
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EdVLRDkMsSihNRWoYYCmTwrwwdtZDcRtRQ01vQHU6vo=;
        b=brQIVFOxxm9Z5pCa/O5KAIffh7DOvaqsVOQNiOEVuiybI11MsI5uvZZH+hFj+c8ldc
         YVViDzolaU8/VdDX7osvYKeyETUgil0MSXjUqSO6wWCIv1yriTlFw4dYR8CZIbgRxA9O
         vhabyL9lKLKtBOMzHje0SFZJpmW5yPtr2f3ZKekQxvFSLvcAxDzpk7qf0aJpr98Q9hYe
         OOZ+FIjvqnt0niANEtuYbUl6HHg3D+/P8X7JPIUO1ct+LsjG/PWo+H7DD0LOX0Da77cH
         vFRbN0SI8FvhtySyz6bjI5xKTuxak+jbo2EIgrI2QtaiiZG87VlMm2Jt5W2TE41f+PHU
         TZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EdVLRDkMsSihNRWoYYCmTwrwwdtZDcRtRQ01vQHU6vo=;
        b=XijB075UVIxvxddShES1y+YQqU/et9JozgZuXj54v8rwEUvVARw3gr6nVW50W4arJ8
         yxPb2F3SgWsXR8aJKqa2t/wcoOO5m+9jYM75K01EGUo/EYP2tJbxdzc7n1KxL+UKnBm8
         Si9vMmNpwT6tvyOQWf3womWlhTKGTKycsleO6l+4nwd7MJDczUDVRaUtKFQ5GsxRkcHn
         G9xEkhWE6wKt8pSbfsdl13SKRNm+n8jqFVTSXM2m6KUWgTObozzAB3+1EiocqeUs60Dk
         kbOJLwJxZKIvWkhYSEmMGxW6aWgazL8J4x3cQ7TpOC+SHVDB6y/nvnkqsDBCenVqvPN7
         7ixg==
X-Gm-Message-State: AOAM530UvtGIke3+StxKWk6FdvUWQI2ZAn4HPEWGzWmDI9uNEzBQwujy
        nM+mLqSYRfGghGlFLUZr+y8e6Q==
X-Google-Smtp-Source: ABdhPJxkNycue+F/q0KoFKpyO69zTU+qaFc0ESg512169xw02k44oVWUuEkxdFPPY0t7IioSjwkeYQ==
X-Received: by 2002:a17:907:2cf0:: with SMTP id hz16mr8877998ejc.466.1628500735235;
        Mon, 09 Aug 2021 02:18:55 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id dg24sm1234250edb.6.2021.08.09.02.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:18:54 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 13/14] bpf/tests: Add tests for BPF_CMPXCHG
Date:   Mon,  9 Aug 2021 11:18:28 +0200
Message-Id: <20210809091829.810076-14-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
References: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tests for BPF_CMPXCHG with both word and double word operands. As with
the tests for other atomic operations, these tests only check the result
of the arithmetic operation. The atomicity of the operations is not tested.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 lib/test_bpf.c | 166 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 166 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 855f64093ca7..d05fe7b4a9cb 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -5690,6 +5690,172 @@ static struct bpf_test tests[] = {
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

