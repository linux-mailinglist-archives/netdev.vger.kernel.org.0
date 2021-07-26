Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AAB3D555A
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhGZHi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 03:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbhGZHiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 03:38:09 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F09C06179E
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:37 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x14so4629164edr.12
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 01:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5AoHxGp8mqtmBanUdCjZF0R3SWIM0OZzNz1CsDhm45g=;
        b=xwXo2DyucvdNZVO2044C/6dOH9yN2tGaKUOb24w7urhzICdjgnCAWU/UN4yiW6Csnf
         ayeDvtIeF9qxHSL/aPgZLHoTKtDmh3wGiNKsUt9Zs6yXLYgbhLJmQXzuIT39nFjMiS/7
         4jCg5xu2HMnki24qtg0NqUCU9yTnyOP/7/Zxr3Rr8BCplc+pWug8l+RYsA324hlRAgHs
         dMIJolhks9Xrd9Ue7sHYaIIDFZKpiFwJobrLebjvINLtdVq9yRPrywc1Ci2EhJN+K/Bs
         uYVJnYr0OcPuIHJ3kHjsZavsbV7jPe1hAMyVIXUp/hW7k5vTi+He9oZIJpOSYNM+HDNt
         IANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5AoHxGp8mqtmBanUdCjZF0R3SWIM0OZzNz1CsDhm45g=;
        b=ABxWHDSYZuOCrELsnztVWmJX3tKsQLKOPkQhr11bNwSe0DY8bR+RNy+6bCxHUVPx+N
         HG3EyudNOT3PDfbz+fHfwY8IB64TUY+MOu+GcA6MN0Gw/LkwO216fKsIEYhWrr3Yrv6c
         hCK5uTsU3zxC8LcXVibOQUPNUGO8cAjT/MY+kUGBtjjasEAOKtI/Wi8Iv26jD4vZTaWV
         iDiECEN1itBrhajvyp0dEdRJhvQX7UvAq6vUSQetJ6n9QM5OwYn1ntBIUiMMoCGYvr9J
         Ei0AdsNLdTFral+wAk8RssclK+GBdDIo1M3Vqkhb/x8P3AKH8yur9MFVcNR2EUBW5WfV
         EtnA==
X-Gm-Message-State: AOAM531MGP3+WnAO98ITbEn7Aq1Iq7KTUvqvGon4Oss9bb2MUyADSJ+h
        35QqGhI/LVwMVwAwearSIMEwdg==
X-Google-Smtp-Source: ABdhPJz2KcqInrFqaq3cgRxjUG29hb1ieEC5nF4RE3vx5wQY/NUR9HaUbAn8c6LXYx19+hUX2RpQTA==
X-Received: by 2002:aa7:d30e:: with SMTP id p14mr1283901edq.204.1627287516268;
        Mon, 26 Jul 2021 01:18:36 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id q9sm13937539ejf.70.2021.07.26.01.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:18:36 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [RFC PATCH 08/14] bpf/tests: add tests for ALU operations implemented with function calls
Date:   Mon, 26 Jul 2021 10:17:32 +0200
Message-Id: <20210726081738.1833704-9-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
References: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
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

