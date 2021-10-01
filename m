Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA02141EE3A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhJANHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354136AbhJANGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:06:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD48C061793
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 06:04:13 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v10so34841093edj.10
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 06:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5zYB8mqtE+ygJzihZK4VFYuXUtlev0s60JUhGV9c/Wg=;
        b=erH8r8HMaLwfNhcglVlsRt48YRykCk/HyR8bgmz5zhINC7Cvrz9kUo71KZD7CQZm8p
         CKDqPvJBgoMLOtLsCL3p75pUS5T63GkvrOD+jKAISfhpWZ3GFPFPAdjaIr/NEQ+bfy92
         JKoBBFVy7sDRsfneNH9k1udTEV0Jae2hKmUMm8D1p0toxKLLtyuYv1OkqzU2zWZcpMcv
         7GKC9yKN95uUeroae2ZRgu7Yk8pg6FxtfEmSPCF4Ibc4CREwEV+y62FlBhbAPt+y1CKv
         jW4eyRq0GF7wAF3ANTlo28+I7o1Za/IlJT9YvW5ZR36QZBSSgUUPBBCRu2PjMIFG0duz
         tgog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5zYB8mqtE+ygJzihZK4VFYuXUtlev0s60JUhGV9c/Wg=;
        b=vNrzrpbSdTgtMmndSLPY2G4faCoP6GMttNgAk0Fb98T8NREalXFGK3vIX0nOKn8cXv
         CRLH75/3noz3enT578b607CABdxkW3HTmfY6WXNIUNq7hzrPEPShZEDO5YykvYIn7JaT
         Q0IPU8os514AwRm+YSpOmW29bHx+vRvrWAj2jIC4l5wOQYtvJkFk9glpXJdjG/FsV25T
         r1QYSM3aDTAYum6gphbuGdTfU6KAFY3JUWm1gp4ps5zOyoLGTEI3b9Tu0ZzIV0QEIavp
         r2vEloU50QGA3gekOUdhp/FzG2RATFMjwHqKbhZ+wnaip+5M5rY7hDece02SbzM629s+
         nfew==
X-Gm-Message-State: AOAM530pLhU4xpD0jwsfRIaMheOiTy/9j1OrEO3C0JwPRXZtr4Aylhmy
        z4WL8idIu1PpAQIbatP9pELvSw==
X-Google-Smtp-Source: ABdhPJzurTk3eXztmQhe69eT45MuApqyv5juzkQJqOdeF+jvXaaptb5Cp5FYqlWek6bVH/OhOxobTg==
X-Received: by 2002:a17:906:36d6:: with SMTP id b22mr5978897ejc.387.1633093451801;
        Fri, 01 Oct 2021 06:04:11 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id p22sm2920279ejl.90.2021.10.01.06.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:04:11 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        paul@cilium.io, yangtiezhu@loongson.cn, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 10/10] bpf/tests: Add test of LDX_MEM with operand aliasing
Date:   Fri,  1 Oct 2021 15:03:48 +0200
Message-Id: <20211001130348.3670534-11-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
References: <20211001130348.3670534-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a set of tests of BPF_LDX_MEM where both operand registers
are the same register. Mainly testing 32-bit JITs that may load a 64-bit
value in two 32-bit loads, and must not overwrite the address register.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index dfcbdff714b6..b9fc330fc83b 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -11133,6 +11133,64 @@ static struct bpf_test tests[] = {
 		{},
 		{ { 0, 2 } },
 	},
+	/* BPF_LDX_MEM with operand aliasing */
+	{
+		"LDX_MEM_B: operand register aliasing",
+		.u.insns_int = {
+			BPF_ST_MEM(BPF_B, R10, -8, 123),
+			BPF_MOV64_REG(R0, R10),
+			BPF_LDX_MEM(BPF_B, R0, R0, -8),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 123 } },
+		.stack_depth = 8,
+	},
+	{
+		"LDX_MEM_H: operand register aliasing",
+		.u.insns_int = {
+			BPF_ST_MEM(BPF_H, R10, -8, 12345),
+			BPF_MOV64_REG(R0, R10),
+			BPF_LDX_MEM(BPF_H, R0, R0, -8),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 12345 } },
+		.stack_depth = 8,
+	},
+	{
+		"LDX_MEM_W: operand register aliasing",
+		.u.insns_int = {
+			BPF_ST_MEM(BPF_W, R10, -8, 123456789),
+			BPF_MOV64_REG(R0, R10),
+			BPF_LDX_MEM(BPF_W, R0, R0, -8),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 123456789 } },
+		.stack_depth = 8,
+	},
+	{
+		"LDX_MEM_DW: operand register aliasing",
+		.u.insns_int = {
+			BPF_LD_IMM64(R1, 0x123456789abcdefULL),
+			BPF_STX_MEM(BPF_DW, R10, R1, -8),
+			BPF_MOV64_REG(R0, R10),
+			BPF_LDX_MEM(BPF_DW, R0, R0, -8),
+			BPF_ALU64_REG(BPF_SUB, R0, R1),
+			BPF_MOV64_REG(R1, R0),
+			BPF_ALU64_IMM(BPF_RSH, R1, 32),
+			BPF_ALU64_REG(BPF_OR, R0, R1),
+			BPF_EXIT_INSN(),
+		},
+		INTERNAL,
+		{ },
+		{ { 0, 0 } },
+		.stack_depth = 8,
+	},
 	/*
 	 * Register (non-)clobbering tests for the case where a JIT implements
 	 * complex ALU or ATOMIC operations via function calls. If so, the
-- 
2.30.2

