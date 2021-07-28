Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A5D3D93E6
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 19:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhG1RF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 13:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhG1RFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 13:05:44 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09C1C06179B
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 10:05:39 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h8so4219142ede.4
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 10:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5AoHxGp8mqtmBanUdCjZF0R3SWIM0OZzNz1CsDhm45g=;
        b=wjc6VKUeCKJy+AObRbEKNIv2JZM9mxbLy6XRaXaS2qHmo7dr+wCQcADyFS7Nwiji2Z
         2DoVXy2TeuF9pg2lTggmhx21MmmK4y5Cxxekm+dOEvGx4CHhfrDwltOS4y8QoCfDgtGS
         bqzHAsTEZ6YWNU2olj20nc/cb8et8H4w2ouJZSBo3LOeNh3ZCfqEIii1XP/I1egWR+dy
         ucf8Fx96g/DXSFzMnHXIUn8fkNBif6Bt+nLJ33PcBBXk+DQUmkb5rwMeHN8ZIzbbcW5o
         Ep99UEddsU1CWtzWCRdBYtuCKiakD0aH4Wst2Z7G90PQkGRTrZZwd4MsnNHvYXlOmsuH
         F/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5AoHxGp8mqtmBanUdCjZF0R3SWIM0OZzNz1CsDhm45g=;
        b=jcQbdDdV8bajBNZ4izLQkmiNJuq4Vrgbo3LjHcJ9YpkFaaru8aI3zihlX5yq+xksS/
         iQJtVH0t4P6+Ys1i0hQ84oPX4MINggdwJJkGbLBc/oghYJnS6zSI4LnS/ZEHvnuE8Alm
         Z+5uDUUBLQwBCjS1Onb7j5QFaS9KyYO7Ea4P0lXJ+MNre0ZU28kWVR9novT74twMAS2D
         7xmcRz/Te/t4SMgN/CwWOUiSaBZ1jY4yKBPUMvcfwygOZSzNFJ4yi6D3x3Qb3ZxETA0V
         TFnmdcx3pS8NIE9nCqH26L8BlZ1B1iUd4UANoaZSw/A/g22p8sTkPz15TPnvbdHO5Zsy
         iEJQ==
X-Gm-Message-State: AOAM5329mDpiKh6oKWzFnax8+jlUuqPSNsnRjDByXbMNvKgLHVk5L2pK
        I9qh68rxWqaKrZxTEbQThVMOsA==
X-Google-Smtp-Source: ABdhPJztMXXxYkfufd885HfBKcrThLUiuzf2j26i1+IGOS9TpOM+jGkQmxBKFRFv5+1GK324xzu6uA==
X-Received: by 2002:aa7:c489:: with SMTP id m9mr1019260edq.256.1627491938366;
        Wed, 28 Jul 2021 10:05:38 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bd24sm139349edb.56.2021.07.28.10.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 10:05:38 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH 08/14] bpf/tests: Add tests for ALU operations implemented with function calls
Date:   Wed, 28 Jul 2021 19:04:56 +0200
Message-Id: <20210728170502.351010-9-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
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
 lib/test_bpf.c | 138 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index eb61088a674f..1115e39630ce 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -1916,6 +1916,144 @@ static struct bpf_test tests[] = {
 		{ },
 		{ { 0, -1 } }
 	},
+	{
+		/*
+		 * Register (non-)clobbering test, in the case where a 32-bit
+		 * JIT implements complex ALU64 operations via function calls.
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
+			BPF_LD_IMM64(R0, 1),
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

