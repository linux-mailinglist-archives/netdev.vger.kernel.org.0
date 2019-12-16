Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817C01200A8
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfLPJN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:13:56 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34832 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfLPJNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:13:55 -0500
Received: by mail-pg1-f194.google.com with SMTP id l24so3330854pgk.2;
        Mon, 16 Dec 2019 01:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bYazlit0M4yBFQMfwCbOmC5g6AIzkoA/91yiEDZt7b0=;
        b=RwRGeVm1aeN2qkJLadfLujw+Gg4mmYcLdCef5IRe1XA0xhjwByucNBCckRiVYY6fLO
         4296nh+AjY2dK6wlGr86OM9pf7cguH6tlpQf7mVCmE9ZJhFyMvWHH1X5jR8DAxXPdrzK
         Pq2mcImd24XixdeDeiReoUuU4bH2acto7KmAoYFdMkqUMLAKgT2mJIi3syGlZU4BFC3P
         TSSxkz5RTMxufDP3glc76F5k57NP/Cxj5MleehiJXmq63EI0qxK7T7GEVKH6gXaZmUFM
         qbH4Z0myz4VWg3u95JgmzKBXo23KfOmUgkcIZRXNLngGdkYKAf8Vguh9We/lv8iqrVqW
         D2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bYazlit0M4yBFQMfwCbOmC5g6AIzkoA/91yiEDZt7b0=;
        b=D3hX6XSBV6FFVSuKxCr31mXnql7hupfJEr1dhdRv0ZDJwJk3edjnSe8ZLcYqeSIP8P
         1hluffqGxQUXjP6vI4c6BoX9EKH650/4t7+OzB6cAvswsy47Atb1lkAD5wSTfJxYM6Si
         LM+7nojKxd2/peySVJjlDdsPfJlZd3Aiw1GhzV6LDqNSWhz+QlS8pSZtAIHYm9apHAiF
         rNq38M8idp4IE8nJRCv/9R49MTdcTHsq+hRig7NgV9V6WDQLjpMVR0JqPJgZpVuMbs+w
         2Vf/BZMmb1+anZAWd9BQYGTYQKu3NxxRlqSbL09pClyg/EBuEh4jmrxKGM3welIfzv9w
         oH7A==
X-Gm-Message-State: APjAAAVF56i/0EI6WKZHMxD6LTaIazhZXlPBDusFlvb5FuPi+4YwKNkV
        E8D1I4yni4vMde3utFhn2NULE8JGZWg=
X-Google-Smtp-Source: APXvYqya/ZK/sigSlCk224VfrvfZoRMNqXimX/XMn+BCFUGM3rt7mHAstLVa1xEVZ3DJ9X5w/O85hA==
X-Received: by 2002:a63:5807:: with SMTP id m7mr15787129pgb.83.1576487634904;
        Mon, 16 Dec 2019 01:13:54 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id x21sm12505033pfn.164.2019.12.16.01.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:13:54 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 1/9] riscv, bpf: fix broken BPF tail calls
Date:   Mon, 16 Dec 2019 10:13:35 +0100
Message-Id: <20191216091343.23260-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191216091343.23260-1-bjorn.topel@gmail.com>
References: <20191216091343.23260-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF JIT incorrectly clobbered the a0 register, and did not flag
usage of s5 register when BPF stack was being used.

Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 5451ef3845f2..1606ebd49666 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -120,6 +120,11 @@ static bool seen_reg(int reg, struct rv_jit_context *ctx)
 	return false;
 }
 
+static void mark_fp(struct rv_jit_context *ctx)
+{
+	__set_bit(RV_CTX_F_SEEN_S5, &ctx->flags);
+}
+
 static void mark_call(struct rv_jit_context *ctx)
 {
 	__set_bit(RV_CTX_F_SEEN_CALL, &ctx->flags);
@@ -596,7 +601,8 @@ static void __build_epilogue(u8 reg, struct rv_jit_context *ctx)
 
 	emit(rv_addi(RV_REG_SP, RV_REG_SP, stack_adjust), ctx);
 	/* Set return value. */
-	emit(rv_addi(RV_REG_A0, RV_REG_A5, 0), ctx);
+	if (reg == RV_REG_RA)
+		emit(rv_addi(RV_REG_A0, RV_REG_A5, 0), ctx);
 	emit(rv_jalr(RV_REG_ZERO, reg, 0), ctx);
 }
 
@@ -1426,6 +1432,10 @@ static void build_prologue(struct rv_jit_context *ctx)
 {
 	int stack_adjust = 0, store_offset, bpf_stack_adjust;
 
+	bpf_stack_adjust = round_up(ctx->prog->aux->stack_depth, 16);
+	if (bpf_stack_adjust)
+		mark_fp(ctx);
+
 	if (seen_reg(RV_REG_RA, ctx))
 		stack_adjust += 8;
 	stack_adjust += 8; /* RV_REG_FP */
@@ -1443,7 +1453,6 @@ static void build_prologue(struct rv_jit_context *ctx)
 		stack_adjust += 8;
 
 	stack_adjust = round_up(stack_adjust, 16);
-	bpf_stack_adjust = round_up(ctx->prog->aux->stack_depth, 16);
 	stack_adjust += bpf_stack_adjust;
 
 	store_offset = stack_adjust - 8;
-- 
2.20.1

