Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444791172C3
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLIRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:31:52 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34896 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIRbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:31:51 -0500
Received: by mail-pj1-f66.google.com with SMTP id w23so6193277pjd.2;
        Mon, 09 Dec 2019 09:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bYazlit0M4yBFQMfwCbOmC5g6AIzkoA/91yiEDZt7b0=;
        b=JG/FdtoaT1PdHdeb1nQSG3n58INhw4WAwPx4fgf/iNqq6+YukonnT/Te2EfrJCYbwS
         BA839prSyM9HNh1zIq1Y6mtGIkk9Hb+UVfTCxDxX7jXyY2CwmcHbybwq+G5REvSl/X40
         P9Rh91X5SyPVRrqmh9uS5XjMdub94pM7M0MD5oQtO/gb4wKcvuCcLgwXIQ2VOyXkAC1b
         q22mSGWXKWS6XeieReZpy5r+4wkmjv+esiy9JZkyXkCJRjbFGxTYAPCdvNaLN6VVjfK2
         0Gua8XtVNUIyFq0HqEyNqTgudqrWWL9uHE+hGO7h/IaBfuYzgCqRMBV0akFCO4kKU77v
         2YZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bYazlit0M4yBFQMfwCbOmC5g6AIzkoA/91yiEDZt7b0=;
        b=EczPqMI39UG+7Y0mks3KMJQYhgOmc+7fb4qjye+hVN5xrSXvZZvQYJgtZ5sda4VxvG
         Kxuff/uKmH/DQN9t8Cp8xfL+eI5wHy6YVCpVCYDkE2PBNbzKm7uX2F2lSwMGHlKqmSRq
         fStgyWe4zvD281M1BZEP1edEFwPwlULWRVAEQLFd/VmWt8YIHBvCs3F4I/XqpRZHInE8
         kDetjlykcgwdJrOE07ONmvHFgKfC+G59YfxgmvmJLMufqcm7oAwVOTzpq+Ndt7YIwdtY
         NFDLxt1kbsiTYingpBoCwpa+nEDtKJBxhc+D5HFph1gH8ZXEX3j9XxfZzXDQlYIlrHYg
         NCTg==
X-Gm-Message-State: APjAAAUFExxkM0uAVax6v+jCm6W4W7aPKDWCJcBdPYP4/QhJb/l359Lc
        6H4pVDSXlRNqlD6OoMDH6Tc=
X-Google-Smtp-Source: APXvYqwrSC1AJl671lj66BCLyGpEOq1PPz3mWlePEUYhbgIUczUyAsdnUS2TdGA2AA3b+CVw6LGv2Q==
X-Received: by 2002:a17:902:6502:: with SMTP id b2mr30307947plk.182.1575912710989;
        Mon, 09 Dec 2019 09:31:50 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id d23sm54943pfo.176.2019.12.09.09.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 09:31:50 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/8] riscv, bpf: fix broken BPF tail calls
Date:   Mon,  9 Dec 2019 18:31:29 +0100
Message-Id: <20191209173136.29615-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209173136.29615-1-bjorn.topel@gmail.com>
References: <20191209173136.29615-1-bjorn.topel@gmail.com>
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

