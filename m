Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9DC41EE34
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354526AbhJANHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354229AbhJANGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:06:30 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA8FC0613EF
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:04:06 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id l7so10820926edq.3
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ABm10r1Yh2rzBKJDa5tee3k/Wciy5nB8H1vIAr4hqY=;
        b=Go0Lse7ZkShi1iDtfcAk3Ni+1Fp4LvrrcQ4yz0hKVXsr42ctrWcLvCvUOpmP4U7XAV
         rKtakcfp5AK/N4V/7oV81q0Jn0aXj8/7NvBxB2Fl+7UmDRJ6igm0CP5UYEfkGPwL9kV/
         Z/K6Yh+vE/K8tChMFQGfWERX5YnJhvCV8pTwnq4PdDurenC9+kaRroOnNGB6wwfjPJCO
         l9i1tSiWTCdNXeVW//MnoYSHwnMwRjnBSb90AJVXzbsTA9da6oUIwIqMQPP8VhMp356m
         3IPd0ap2v2K7/BHfTM/VNIR5czAku6LUTHuo7v/6XrquVFjkqtn5fiDQ8n9SZr/zNOep
         r68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ABm10r1Yh2rzBKJDa5tee3k/Wciy5nB8H1vIAr4hqY=;
        b=SlDluxGU/DptL7evZhp9LoQz7aAN5JNk75mI1jnF5QVzEnwCmA5d0tlQbaLjbYCHQH
         8A3Q/DHFHvL84WJuMtzweUZWJ91EiBtWVI+PDy54zlBPz0a51jBlUR716jMhAkLBhWYr
         BFJTkPyM/+BgQ7bSG2YVp6mTo6zIFSJosOFxOOEjljZjWmEWg5JvC2/uk8Wqq7KmDMIL
         8Qcovq1ToRYmXKJSoPddDvLy1GJak3WszNAOlg1atvlCHQvFOfatg45xIaQ+tnumPPt1
         /koAl2qAkR7/OcYziAedoy0rmd818SWsd+rISVJ8PDOR5sAPYwDfLunsKbUKQnsGiQbQ
         GZqA==
X-Gm-Message-State: AOAM532VZfm1RrIDfgjZPf9HzF/dubNjQRFT03rvbB2csr5jUwR69juQ
        f8aCE8XWRlkO6AXOrrN42Frr4A==
X-Google-Smtp-Source: ABdhPJxBY9RYRv2IioAS6zefS2xzamHZq3ToYGEV1xY8YBvKp6T04UmtntIutH7668rW09+B2VtQEA==
X-Received: by 2002:a17:906:2bc3:: with SMTP id n3mr6083938ejg.548.1633093443753;
        Fri, 01 Oct 2021 06:04:03 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id p22sm2920279ejl.90.2021.10.01.06.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:04:03 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 05/10] bpf/tests: Add more tests for ALU and ATOMIC register clobbering
Date:   Fri,  1 Oct 2021 15:03:43 +0200
Message-Id: <20211001130348.3670534-6-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
References: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch expands the register-clobbering-during-function-call tests
to cover more all ALU32/64 MUL, DIV and MOD operations and all ATOMIC
operations. In short, if a JIT implements a complex operation with
a call to an external function, it must make sure to save and restore
all its caller-saved registers that may be clobbered by the call.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 267 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 197 insertions(+), 70 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index c7db90112ef0..201f34060eef 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -3744,76 +3744,6 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, -1 } }
 	},
-	{
-		/*
-		 * Register (non-)clobbering test, in the case where a 32-bit
-		 * JIT implements complex ALU64 operations via function calls.
-		 * If so, the function call must be invisible in the eBPF
-		 * registers. The JIT must then save and restore relevant
-		 * registers during the call. The following tests check that
-		 * the eBPF registers retain their values after such a call.
-		 */
-		"INT: Register clobbering, R1 updated",
-		.u.insns_int = {
-			BPF_ALU32_IMM(BPF_MOV, R0, 0),
-			BPF_ALU32_IMM(BPF_MOV, R1, 123456789),
-			BPF_ALU32_IMM(BPF_MOV, R2, 2),
-			BPF_ALU32_IMM(BPF_MOV, R3, 3),
-			BPF_ALU32_IMM(BPF_MOV, R4, 4),
-			BPF_ALU32_IMM(BPF_MOV, R5, 5),
-			BPF_ALU32_IMM(BPF_MOV, R6, 6),
-			BPF_ALU32_IMM(BPF_MOV, R7, 7),
-			BPF_ALU32_IMM(BPF_MOV, R8, 8),
-			BPF_ALU32_IMM(BPF_MOV, R9, 9),
-			BPF_ALU64_IMM(BPF_DIV, R1, 123456789),
-			BPF_JMP_IMM(BPF_JNE, R0, 0, 10),
-			BPF_JMP_IMM(BPF_JNE, R1, 1, 9),
-			BPF_JMP_IMM(BPF_JNE, R2, 2, 8),
-			BPF_JMP_IMM(BPF_JNE, R3, 3, 7),
-			BPF_JMP_IMM(BPF_JNE, R4, 4, 6),
-			BPF_JMP_IMM(BPF_JNE, R5, 5, 5),
-			BPF_JMP_IMM(BPF_JNE, R6, 6, 4),
-			BPF_JMP_IMM(BPF_JNE, R7, 7, 3),
-			BPF_JMP_IMM(BPF_JNE, R8, 8, 2),
-			BPF_JMP_IMM(BPF_JNE, R9, 9, 1),
-			BPF_ALU32_IMM(BPF_MOV, R0, 1),
-			BPF_EXIT_INSN(),
-		},
-		INTERNAL,
-		{ },
-		{ { 0, 1 } }
-	},
-	{
-		"INT: Register clobbering, R2 updated",
-		.u.insns_int = {
-			BPF_ALU32_IMM(BPF_MOV, R0, 0),
-			BPF_ALU32_IMM(BPF_MOV, R1, 1),
-			BPF_ALU32_IMM(BPF_MOV, R2, 2 * 123456789),
-			BPF_ALU32_IMM(BPF_MOV, R3, 3),
-			BPF_ALU32_IMM(BPF_MOV, R4, 4),
-			BPF_ALU32_IMM(BPF_MOV, R5, 5),
-			BPF_ALU32_IMM(BPF_MOV, R6, 6),
-			BPF_ALU32_IMM(BPF_MOV, R7, 7),
-			BPF_ALU32_IMM(BPF_MOV, R8, 8),
-			BPF_ALU32_IMM(BPF_MOV, R9, 9),
-			BPF_ALU64_IMM(BPF_DIV, R2, 123456789),
-			BPF_JMP_IMM(BPF_JNE, R0, 0, 10),
-			BPF_JMP_IMM(BPF_JNE, R1, 1, 9),
-			BPF_JMP_IMM(BPF_JNE, R2, 2, 8),
-			BPF_JMP_IMM(BPF_JNE, R3, 3, 7),
-			BPF_JMP_IMM(BPF_JNE, R4, 4, 6),
-			BPF_JMP_IMM(BPF_JNE, R5, 5, 5),
-			BPF_JMP_IMM(BPF_JNE, R6, 6, 4),
-			BPF_JMP_IMM(BPF_JNE, R7, 7, 3),
-			BPF_JMP_IMM(BPF_JNE, R8, 8, 2),
-			BPF_JMP_IMM(BPF_JNE, R9, 9, 1),
-			BPF_ALU32_IMM(BPF_MOV, R0, 1),
-			BPF_EXIT_INSN(),
-		},
-		INTERNAL,
-		{ },
-		{ { 0, 1 } }
-	},
 	{
 		/*
 		 * Test 32-bit JITs that implement complex ALU64 operations as
@@ -10586,6 +10516,203 @@ static struct bpf_test tests[] = {
 		{},
 		{ { 0, 2 } },
 	},
+	/*
+	 * Register (non-)clobbering tests for the case where a JIT implements
+	 * complex ALU or ATOMIC operations via function calls. If so, the
+	 * function call must be transparent to the eBPF registers. The JIT
+	 * must therefore save and restore relevant registers across the call.
+	 * The following tests check that the eBPF registers retain their
+	 * values after such an operation. Mainly intended for complex ALU
+	 * and atomic operation, but we run it for all. You never know...
+	 *
+	 * Note that each operations should be tested twice with different
+	 * destinations, to check preservation for all registers.
+	 */
+#define BPF_TEST_CLOBBER_ALU(alu, op, dst, src)			\
+	{							\
+		#alu "_" #op " to " #dst ": no clobbering",	\
+		.u.insns_int = {				\
+			BPF_ALU64_IMM(BPF_MOV, R0, R0),		\
+			BPF_ALU64_IMM(BPF_MOV, R1, R1),		\
+			BPF_ALU64_IMM(BPF_MOV, R2, R2),		\
+			BPF_ALU64_IMM(BPF_MOV, R3, R3),		\
+			BPF_ALU64_IMM(BPF_MOV, R4, R4),		\
+			BPF_ALU64_IMM(BPF_MOV, R5, R5),		\
+			BPF_ALU64_IMM(BPF_MOV, R6, R6),		\
+			BPF_ALU64_IMM(BPF_MOV, R7, R7),		\
+			BPF_ALU64_IMM(BPF_MOV, R8, R8),		\
+			BPF_ALU64_IMM(BPF_MOV, R9, R9),		\
+			BPF_##alu(BPF_ ##op, dst, src),		\
+			BPF_ALU32_IMM(BPF_MOV, dst, dst),	\
+			BPF_JMP_IMM(BPF_JNE, R0, R0, 10),	\
+			BPF_JMP_IMM(BPF_JNE, R1, R1, 9),	\
+			BPF_JMP_IMM(BPF_JNE, R2, R2, 8),	\
+			BPF_JMP_IMM(BPF_JNE, R3, R3, 7),	\
+			BPF_JMP_IMM(BPF_JNE, R4, R4, 6),	\
+			BPF_JMP_IMM(BPF_JNE, R5, R5, 5),	\
+			BPF_JMP_IMM(BPF_JNE, R6, R6, 4),	\
+			BPF_JMP_IMM(BPF_JNE, R7, R7, 3),	\
+			BPF_JMP_IMM(BPF_JNE, R8, R8, 2),	\
+			BPF_JMP_IMM(BPF_JNE, R9, R9, 1),	\
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),		\
+			BPF_EXIT_INSN(),			\
+		},						\
+		INTERNAL,					\
+		{ },						\
+		{ { 0, 1 } }					\
+	}
+	/* ALU64 operations, register clobbering */
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, AND, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, AND, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, OR, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, OR, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, XOR, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, XOR, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, LSH, R8, 12),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, LSH, R9, 12),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, RSH, R8, 12),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, RSH, R9, 12),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, ARSH, R8, 12),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, ARSH, R9, 12),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, ADD, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, ADD, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, SUB, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, SUB, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, MUL, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, MUL, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, DIV, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, DIV, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, MOD, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU64_IMM, MOD, R9, 123456789),
+	/* ALU32 immediate operations, register clobbering */
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, AND, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, AND, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, OR, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, OR, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, XOR, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, XOR, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, LSH, R8, 12),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, LSH, R9, 12),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, RSH, R8, 12),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, RSH, R9, 12),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, ARSH, R8, 12),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, ARSH, R9, 12),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, ADD, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, ADD, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, SUB, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, SUB, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, MUL, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, MUL, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, DIV, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, DIV, R9, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, MOD, R8, 123456789),
+	BPF_TEST_CLOBBER_ALU(ALU32_IMM, MOD, R9, 123456789),
+	/* ALU64 register operations, register clobbering */
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, AND, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, AND, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, OR, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, OR, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, XOR, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, XOR, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, LSH, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, LSH, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, RSH, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, RSH, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, ARSH, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, ARSH, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, ADD, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, ADD, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, SUB, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, SUB, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, MUL, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, MUL, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, DIV, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, DIV, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, MOD, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU64_REG, MOD, R9, R1),
+	/* ALU32 register operations, register clobbering */
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, AND, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, AND, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, OR, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, OR, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, XOR, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, XOR, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, LSH, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, LSH, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, RSH, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, RSH, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, ARSH, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, ARSH, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, ADD, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, ADD, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, SUB, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, SUB, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, MUL, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, MUL, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, DIV, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, DIV, R9, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, MOD, R8, R1),
+	BPF_TEST_CLOBBER_ALU(ALU32_REG, MOD, R9, R1),
+#undef BPF_TEST_CLOBBER_ALU
+#define BPF_TEST_CLOBBER_ATOMIC(width, op)			\
+	{							\
+		"Atomic_" #width " " #op ": no clobbering",	\
+		.u.insns_int = {				\
+			BPF_ALU64_IMM(BPF_MOV, R0, 0),		\
+			BPF_ALU64_IMM(BPF_MOV, R1, 1),		\
+			BPF_ALU64_IMM(BPF_MOV, R2, 2),		\
+			BPF_ALU64_IMM(BPF_MOV, R3, 3),		\
+			BPF_ALU64_IMM(BPF_MOV, R4, 4),		\
+			BPF_ALU64_IMM(BPF_MOV, R5, 5),		\
+			BPF_ALU64_IMM(BPF_MOV, R6, 6),		\
+			BPF_ALU64_IMM(BPF_MOV, R7, 7),		\
+			BPF_ALU64_IMM(BPF_MOV, R8, 8),		\
+			BPF_ALU64_IMM(BPF_MOV, R9, 9),		\
+			BPF_ST_MEM(width, R10, -8,		\
+				   (op) == BPF_CMPXCHG ? 0 :	\
+				   (op) & BPF_FETCH ? 1 : 0),	\
+			BPF_ATOMIC_OP(width, op, R10, R1, -8),	\
+			BPF_JMP_IMM(BPF_JNE, R0, 0, 10),	\
+			BPF_JMP_IMM(BPF_JNE, R1, 1, 9),		\
+			BPF_JMP_IMM(BPF_JNE, R2, 2, 8),		\
+			BPF_JMP_IMM(BPF_JNE, R3, 3, 7),		\
+			BPF_JMP_IMM(BPF_JNE, R4, 4, 6),		\
+			BPF_JMP_IMM(BPF_JNE, R5, 5, 5),		\
+			BPF_JMP_IMM(BPF_JNE, R6, 6, 4),		\
+			BPF_JMP_IMM(BPF_JNE, R7, 7, 3),		\
+			BPF_JMP_IMM(BPF_JNE, R8, 8, 2),		\
+			BPF_JMP_IMM(BPF_JNE, R9, 9, 1),		\
+			BPF_ALU64_IMM(BPF_MOV, R0, 1),		\
+			BPF_EXIT_INSN(),			\
+		},						\
+		INTERNAL,					\
+		{ },						\
+		{ { 0, 1 } },					\
+		.stack_depth = 8,				\
+	}
+	/* 64-bit atomic operations, register clobbering */
+	BPF_TEST_CLOBBER_ATOMIC(BPF_DW, BPF_ADD),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_DW, BPF_AND),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_DW, BPF_OR),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_DW, BPF_XOR),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_DW, BPF_ADD | BPF_FETCH),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_DW, BPF_AND | BPF_FETCH),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_DW, BPF_OR | BPF_FETCH),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_DW, BPF_XOR | BPF_FETCH),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_DW, BPF_XCHG),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_DW, BPF_CMPXCHG),
+	/* 32-bit atomic operations, register clobbering */
+	BPF_TEST_CLOBBER_ATOMIC(BPF_W, BPF_ADD),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_W, BPF_AND),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_W, BPF_OR),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_W, BPF_XOR),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_W, BPF_ADD | BPF_FETCH),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_W, BPF_AND | BPF_FETCH),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_W, BPF_OR | BPF_FETCH),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_W, BPF_XOR | BPF_FETCH),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_W, BPF_XCHG),
+	BPF_TEST_CLOBBER_ATOMIC(BPF_W, BPF_CMPXCHG),
+#undef BPF_TEST_CLOBBER_ATOMIC
 	/* Checking that ALU32 src is not zero extended in place */
 #define BPF_ALU32_SRC_ZEXT(op)					\
 	{							\
-- 
2.30.2

