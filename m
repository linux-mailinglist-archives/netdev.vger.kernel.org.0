Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1D61172CA
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLIRcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:32:01 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41538 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIRb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:31:59 -0500
Received: by mail-pf1-f194.google.com with SMTP id s18so7574207pfd.8;
        Mon, 09 Dec 2019 09:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q72cQM+3SI70k7ctcpb9LKDM8a7LAen8E8Vv2d4hTLo=;
        b=sRk23x/JpxVKbzZj54qVRUi2aIExQ0SRE7GqFLD/hMDxEVsFavaeMfS44RU6oiuXfb
         H0xi5LdEkduZ2iYCJYodCJF6Ing7Rv1IW8FMsyWVB2+sCdRzMHiUhKXmMg3xSMH6nHsX
         ayoDJZab2LVWXwXub2wg/AlQtXMlEvPjhk8JTyMAKviCRlRECgURo0yOcgepZ2IDOykr
         W3UsS2Gn8bgOe6SddLX7KSOBEYFK9IYdxMuaWv45tRXpfXQSmLLWywYTazar2mRObXn5
         1loXAYvQ7kzXfJ7qWWqSuEMjX6mcN+A83MnD5l6sHk/M+WOUax9WPdqqaHvnilPlsfcj
         gSCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q72cQM+3SI70k7ctcpb9LKDM8a7LAen8E8Vv2d4hTLo=;
        b=QDxy+jmJ1Xo2KJOwZlCPmcenyIMnwDJ7oKj0PIu0v+DggwbVzpjIi/iGCbQQ+zmvMC
         /Y+TSW3d0r+ouiawLGhwdyiLIr1gd38woL0iYQr1ucAPlPVUKzCuikyo5oL3KBqm9Ni0
         03OPB30o4y1dgg0O2xiDVNOUGcFTB2H92MoWzVdXwAbBYNV7j4PUDghIJ32XUriV2n4w
         ACdRnIUMxpWf37coR3abv9VHmnzo6qSeecG7KN125ZTioogkXQsXefghKDMOH7aAVU8S
         43lSL0ngXYb/ywZsK0C97c51dX/EWvx6YSeok7utBdqoODveXOYMlAUA/WaQG0qXJI7g
         CyYQ==
X-Gm-Message-State: APjAAAWaH4T9+9bW3VPGIMFo2Hz1Enz04FWy5z01xRVffN8U+IpYnpuj
        rhDvAvR68VegfnvLEC7lBIY=
X-Google-Smtp-Source: APXvYqxlMvkVuCdFoizkUk0kiP7e9NabguDeK3+5YeBoqX6bG5u2+aRmcgQwBwQtLnS2H8IY30slww==
X-Received: by 2002:a63:d501:: with SMTP id c1mr19227970pgg.356.1575912719116;
        Mon, 09 Dec 2019 09:31:59 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id d23sm54943pfo.176.2019.12.09.09.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 09:31:58 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 4/8] riscv, bpf: optimize BPF tail calls
Date:   Mon,  9 Dec 2019 18:31:32 +0100
Message-Id: <20191209173136.29615-5-bjorn.topel@gmail.com>
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

Remove one addi, and instead use the offset part of jalr.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index e9cc9832ac2c..cbcb33613d1d 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -562,7 +562,7 @@ static int epilogue_offset(struct rv_jit_context *ctx)
 	return (to - from) << 2;
 }
 
-static void __build_epilogue(u8 reg, struct rv_jit_context *ctx)
+static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 {
 	int stack_adjust = ctx->stack_size, store_offset = stack_adjust - 8;
 
@@ -599,9 +599,11 @@ static void __build_epilogue(u8 reg, struct rv_jit_context *ctx)
 
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
 
 static void emit_zext_32(u8 reg, struct rv_jit_context *ctx)
@@ -664,9 +666,8 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 	if (is_12b_check(off, insn))
 		return -1;
 	emit(rv_ld(RV_REG_T3, off, RV_REG_T2), ctx);
-	emit(rv_addi(RV_REG_T3, RV_REG_T3, 4), ctx);
 	emit(rv_addi(RV_REG_TCC, RV_REG_T1, 0), ctx);
-	__build_epilogue(RV_REG_T3, ctx);
+	__build_epilogue(true, ctx);
 	return 0;
 }
 
@@ -1520,7 +1521,7 @@ static void build_prologue(struct rv_jit_context *ctx)
 
 static void build_epilogue(struct rv_jit_context *ctx)
 {
-	__build_epilogue(RV_REG_RA, ctx);
+	__build_epilogue(false, ctx);
 }
 
 static int build_body(struct rv_jit_context *ctx, bool extra_pass)
-- 
2.20.1

