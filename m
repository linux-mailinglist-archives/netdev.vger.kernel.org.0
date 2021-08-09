Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E891F3E4275
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhHIJTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbhHIJTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:19:11 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0E5C06179C
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:18:51 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id u3so27781396ejz.1
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tE7n/SwsfwFALCmJtV/Oui8fCqU+mgVKIR+of1apWuY=;
        b=yyXzT51bN/dMpHqEUxUqij3m+wS/ufGTNtWe7eTTKt7H3bfWaaBmJe4BkTxWiXy+uO
         AU2+2CzdM6tKu+t4SwcoJCDo6YchLjTE7vWQqhAmj4Mr6W8Vd9RCszL2DGR/fmFuJIqR
         eAV7NoYtDvLgwG39kmVQz+NR4yvq255deG1USTgx22BZppqdJBYjIH3Kcr20IaEVg3uB
         eWbdmvnupUAH6hjPI6lYxa59DGFsDAdb0/gF00OfhhEPvRE+SG8NuDcr5w9k1aQ6eYLf
         5fXLJwkfBzyWbDO4Ew66PRsx8t56t652CqGlmL2W2u2flobxRsBuoJ71Z+/SPFDAe3lS
         jmJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tE7n/SwsfwFALCmJtV/Oui8fCqU+mgVKIR+of1apWuY=;
        b=b6/nKDw3y+nfaPduu8oxGEFFZ8zD4rFqPtJZ6obu3Vilg+jQsNqFn8Rx/g4R9QXhDr
         VSoQAQ76hCFA0J7cPKdCp5Uv7RUrKsWVCCYOsJLdUKbQkCyDvz6RCp5RK0F/01FnFIln
         ep7OPdbSrYBmoIkhI17yHj/mafZCLE3nFCkVXNKX4bmiW53VsbTBorbUecg+iv2SnUta
         n6/ki28VVYwt/VOYr1xD3k/3wU4cev5VL8ApxAJ30Ml8+DkbX1aP00Hn0mNxSBSscqOS
         BebXONuS9bz3hWRUl28ODx/YgrA8CLArT+jvRM4naUaMbgUgeMx75gGRZuZYI71LylEL
         y6PQ==
X-Gm-Message-State: AOAM533EE4jwBVyRHmQ1z8ircjBjAvDxn9tOlzTk1messVmv2xSe2QP4
        UXUr+hXvkQkWxZZomPGVbFpdMA==
X-Google-Smtp-Source: ABdhPJxHcJfgKnu4AjZig9pA+iF+2Cv+BYEWCbR1A6viyv5LmKRAyFektjd0D4v4FUnVgAhxuefAFQ==
X-Received: by 2002:a17:906:134a:: with SMTP id x10mr21201810ejb.70.1628500729903;
        Mon, 09 Aug 2021 02:18:49 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id dg24sm1234250edb.6.2021.08.09.02.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:18:49 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v2 08/14] bpf/tests: Add tests for ALU operations implemented with function calls
Date:   Mon,  9 Aug 2021 11:18:23 +0200
Message-Id: <20210809091829.810076-9-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
References: <20210809091829.810076-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

32-bit JITs may implement complex ALU64 instructions using function calls.
The new tests check aspects related to this, such as register clobbering
and register argument re-ordering.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 141 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 072f9c51bd9b..e3c256963020 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -1916,6 +1916,147 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, -1 } }
 	},
+	{
+		/*
+		 * Register (non-)clobbering test, in the case where a 32-bit
+		 * JIT implements complex ALU64 operations via function calls.
+		 * If so, the function call must be invisible in the eBPF
+		 * registers. The JIT must then save and restore relevant
+		 * registers during the call. The following tests check that
+		 * the eBPF registers retain their values after such a call.
+		 */
+		"INT: Register clobbering, R1 updated",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_ALU32_IMM(BPF_MOV, R1, 123456789),
+			BPF_ALU32_IMM(BPF_MOV, R2, 2),
+			BPF_ALU32_IMM(BPF_MOV, R3, 3),
+			BPF_ALU32_IMM(BPF_MOV, R4, 4),
+			BPF_ALU32_IMM(BPF_MOV, R5, 5),
+			BPF_ALU32_IMM(BPF_MOV, R6, 6),
+			BPF_ALU32_IMM(BPF_MOV, R7, 7),
+			BPF_ALU32_IMM(BPF_MOV, R8, 8),
+			BPF_ALU32_IMM(BPF_MOV, R9, 9),
+			BPF_ALU64_IMM(BPF_DIV, R1, 123456789),
+			BPF_JMP_IMM(BPF_JNE, R0, 0, 10),
+			BPF_JMP_IMM(BPF_JNE, R1, 1, 9),
+			BPF_JMP_IMM(BPF_JNE, R2, 2, 8),
+			BPF_JMP_IMM(BPF_JNE, R3, 3, 7),
+			BPF_JMP_IMM(BPF_JNE, R4, 4, 6),
+			BPF_JMP_IMM(BPF_JNE, R5, 5, 5),
+			BPF_JMP_IMM(BPF_JNE, R6, 6, 4),
+			BPF_JMP_IMM(BPF_JNE, R7, 7, 3),
+			BPF_JMP_IMM(BPF_JNE, R8, 8, 2),
+			BPF_JMP_IMM(BPF_JNE, R9, 9, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
+	{
+		"INT: Register clobbering, R2 updated",
+		.u.insns_int = {
+			BPF_ALU32_IMM(BPF_MOV, R0, 0),
+			BPF_ALU32_IMM(BPF_MOV, R1, 1),
+			BPF_ALU32_IMM(BPF_MOV, R2, 2 * 123456789),
+			BPF_ALU32_IMM(BPF_MOV, R3, 3),
+			BPF_ALU32_IMM(BPF_MOV, R4, 4),
+			BPF_ALU32_IMM(BPF_MOV, R5, 5),
+			BPF_ALU32_IMM(BPF_MOV, R6, 6),
+			BPF_ALU32_IMM(BPF_MOV, R7, 7),
+			BPF_ALU32_IMM(BPF_MOV, R8, 8),
+			BPF_ALU32_IMM(BPF_MOV, R9, 9),
+			BPF_ALU64_IMM(BPF_DIV, R2, 123456789),
+			BPF_JMP_IMM(BPF_JNE, R0, 0, 10),
+			BPF_JMP_IMM(BPF_JNE, R1, 1, 9),
+			BPF_JMP_IMM(BPF_JNE, R2, 2, 8),
+			BPF_JMP_IMM(BPF_JNE, R3, 3, 7),
+			BPF_JMP_IMM(BPF_JNE, R4, 4, 6),
+			BPF_JMP_IMM(BPF_JNE, R5, 5, 5),
+			BPF_JMP_IMM(BPF_JNE, R6, 6, 4),
+			BPF_JMP_IMM(BPF_JNE, R7, 7, 3),
+			BPF_JMP_IMM(BPF_JNE, R8, 8, 2),
+			BPF_JMP_IMM(BPF_JNE, R9, 9, 1),
+			BPF_ALU32_IMM(BPF_MOV, R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } }
+	},
+	{
+		/*
+		 * Test 32-bit JITs that implement complex ALU64 operations as
+		 * function calls R0 = f(R1, R2), and must re-arrange operands.
+		 */
+#define NUMER 0xfedcba9876543210ULL
+#define DENOM 0x0123456789abcdefULL
+		"ALU64_DIV X: Operand register permutations",
+		.u.insns_int = {
+			/* R0 / R2 */
+			BPF_LD_IMM64(R0, NUMER),
+			BPF_LD_IMM64(R2, DENOM),
+			BPF_ALU64_REG(BPF_DIV, R0, R2),
+			BPF_JMP_IMM(BPF_JEQ, R0, NUMER / DENOM, 1),
+			BPF_EXIT_INSN(),
+			/* R1 / R0 */
+			BPF_LD_IMM64(R1, NUMER),
+			BPF_LD_IMM64(R0, DENOM),
+			BPF_ALU64_REG(BPF_DIV, R1, R0),
+			BPF_JMP_IMM(BPF_JEQ, R1, NUMER / DENOM, 1),
+			BPF_EXIT_INSN(),
+			/* R0 / R1 */
+			BPF_LD_IMM64(R0, NUMER),
+			BPF_LD_IMM64(R1, DENOM),
+			BPF_ALU64_REG(BPF_DIV, R0, R1),
+			BPF_JMP_IMM(BPF_JEQ, R0, NUMER / DENOM, 1),
+			BPF_EXIT_INSN(),
+			/* R2 / R0 */
+			BPF_LD_IMM64(R2, NUMER),
+			BPF_LD_IMM64(R0, DENOM),
+			BPF_ALU64_REG(BPF_DIV, R2, R0),
+			BPF_JMP_IMM(BPF_JEQ, R2, NUMER / DENOM, 1),
+			BPF_EXIT_INSN(),
+			/* R2 / R1 */
+			BPF_LD_IMM64(R2, NUMER),
+			BPF_LD_IMM64(R1, DENOM),
+			BPF_ALU64_REG(BPF_DIV, R2, R1),
+			BPF_JMP_IMM(BPF_JEQ, R2, NUMER / DENOM, 1),
+			BPF_EXIT_INSN(),
+			/* R1 / R2 */
+			BPF_LD_IMM64(R1, NUMER),
+			BPF_LD_IMM64(R2, DENOM),
+			BPF_ALU64_REG(BPF_DIV, R1, R2),
+			BPF_JMP_IMM(BPF_JEQ, R1, NUMER / DENOM, 1),
+			BPF_EXIT_INSN(),
+			/* R1 / R1 */
+			BPF_LD_IMM64(R1, NUMER),
+			BPF_ALU64_REG(BPF_DIV, R1, R1),
+			BPF_JMP_IMM(BPF_JEQ, R1, 1, 1),
+			BPF_EXIT_INSN(),
+			/* R2 / R2 */
+			BPF_LD_IMM64(R2, DENOM),
+			BPF_ALU64_REG(BPF_DIV, R2, R2),
+			BPF_JMP_IMM(BPF_JEQ, R2, 1, 1),
+			BPF_EXIT_INSN(),
+			/* R3 / R4 */
+			BPF_LD_IMM64(R3, NUMER),
+			BPF_LD_IMM64(R4, DENOM),
+			BPF_ALU64_REG(BPF_DIV, R3, R4),
+			BPF_JMP_IMM(BPF_JEQ, R3, NUMER / DENOM, 1),
+			BPF_EXIT_INSN(),
+			/* Successful return */
+			BPF_LD_IMM64(R0, 1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 1 } },
+#undef NUMER
+#undef DENOM
+	},
 	{
 		"check: missing ret",
 		.u.insns = {
-- 
2.25.1

