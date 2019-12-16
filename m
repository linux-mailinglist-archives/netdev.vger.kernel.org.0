Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447D41200B2
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfLPJOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:14:07 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41079 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbfLPJOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:14:06 -0500
Received: by mail-pf1-f194.google.com with SMTP id s18so5245685pfd.8;
        Mon, 16 Dec 2019 01:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+QLmugLg69uwoq+Jwozb0oyKbaFcKUgep+k5spKK228=;
        b=vgYlauhSVRfk3SG2Bd3rFWaU/N5IO+0XFjRzwLL4Nj2mEqZngDETSaWN91nNeMPO3C
         msXmmWZHLDuxE48AHdWqXT6qEl9CAAhWHMyiM1n7Nlruv3uqa7ZAcrKoQjZ9ZSPtCV40
         1yGYGdpgJ2xFvUFfoQwM+ExMaNHpxQ07VJg3pCVLHTpgjsEME9vSonPXVDaGDeoHBbka
         vTqTq2ktbA86v0VieraSm+XBruaQNdvt91/NGAYuYphJzCbvmHl730QiqLx/6Hwu8muD
         OhyyU0s+3mjUYLfi0bwMKNe5LRBQQF5hki2gJMFFsVw3zPGyWvAmXNGTcL1mDAeHHf3F
         /2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QLmugLg69uwoq+Jwozb0oyKbaFcKUgep+k5spKK228=;
        b=udUZ4maWiHfqH07Vd6HNjxjUZo15RjLjFqFNys/j9iuhaRCbF9sOppsWj2sMhHGUM/
         tJEm2S7cVZWrPzvGTFJCnzEYAm4D6cceAxDw5TT8DEVgFxQZzj7e4jsDKrPekvRxjSd9
         KancQuIs5WCHZBggbUyxLqhn56cPy7PvxdbD3Zyd3tTFu5G+bLWNA4hU/FsElmKQ7IX8
         UyrV89Hy5jz4xH5OMN2a8jWOjwEf62XKNmI1UnmEmQu3AacX56vxi3ldji4py2jtVo4u
         z+PsFcJhUOVC+THP3CbO1cQb6b0C6n/wOeTS2UzK8Z7bS+1QhrT3d5pZN8/rdbvD1OCu
         OYXA==
X-Gm-Message-State: APjAAAWJTSYn4olDvc18hN3aQGu1bnxY8Lp6+WbFkT5v58cmd3DZCeeP
        kihz/ZtKd844lH6/vvwTgVE=
X-Google-Smtp-Source: APXvYqwNqrSXeV+vfLV2wS5LMUNUPbO2epEFOMwSUXehrzv1nnOdTQ7R3mn/CNh1KLbocAfAIqkurg==
X-Received: by 2002:a63:590e:: with SMTP id n14mr16640396pgb.10.1576487645927;
        Mon, 16 Dec 2019 01:14:05 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id x21sm12505033pfn.164.2019.12.16.01.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:14:05 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 5/9] riscv, bpf: optimize BPF tail calls
Date:   Mon, 16 Dec 2019 10:13:39 +0100
Message-Id: <20191216091343.23260-6-bjorn.topel@gmail.com>
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

Remove one addi, and instead use the offset part of jalr.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 2fc0f24ad30f..8aa19c846881 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -552,7 +552,7 @@ static int epilogue_offset(struct rv_jit_context *ctx)
 	return (to - from) << 2;
 }
 
-static void __build_epilogue(u8 reg, struct rv_jit_context *ctx)
+static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 {
 	int stack_adjust = ctx->stack_size, store_offset = stack_adjust - 8;
 
@@ -589,9 +589,11 @@ static void __build_epilogue(u8 reg, struct rv_jit_context *ctx)
 
 	emit(rv_addi(RV_REG_SP, RV_REG_SP, stack_adjust), ctx);
 	/* Set return value. */
-	if (reg == RV_REG_RA)
+	if (!is_tail_call)
 		emit(rv_addi(RV_REG_A0, RV_REG_A5, 0), ctx);
-	emit(rv_jalr(RV_REG_ZERO, reg, 0), ctx);
+	emit(rv_jalr(RV_REG_ZERO, is_tail_call ? RV_REG_T3 : RV_REG_RA,
+		     is_tail_call ? 4 : 0), /* skip TCC init */
+	     ctx);
 }
 
 /* return -1 or inverted cond */
@@ -751,9 +753,8 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	if (is_12b_check(off, insn))
 		return -1;
 	emit(rv_ld(RV_REG_T3, off, RV_REG_T2), ctx);
-	emit(rv_addi(RV_REG_T3, RV_REG_T3, 4), ctx);
 	emit(rv_addi(RV_REG_TCC, RV_REG_T1, 0), ctx);
-	__build_epilogue(RV_REG_T3, ctx);
+	__build_epilogue(true, ctx);
 	return 0;
 }
 
@@ -1504,7 +1505,7 @@ static void build_prologue(struct rv_jit_context *ctx)
 
 static void build_epilogue(struct rv_jit_context *ctx)
 {
-	__build_epilogue(RV_REG_RA, ctx);
+	__build_epilogue(false, ctx);
 }
 
 static int build_body(struct rv_jit_context *ctx, bool extra_pass)
-- 
2.20.1

