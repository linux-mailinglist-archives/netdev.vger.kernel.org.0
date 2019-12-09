Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5EC41172C8
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLIRb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:31:57 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45419 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIRb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:31:57 -0500
Received: by mail-pf1-f195.google.com with SMTP id 2so7556311pfg.12;
        Mon, 09 Dec 2019 09:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ldUAi30p4Fm9YFcB6XPp82qK2Gx4LpczH2It45srXeo=;
        b=I2wCeTTo+LKa1bhU4VfmVyMc9Cd30NbyeEDRCtVDaC5dxtYFpo1WOKYY95ZDtYBt77
         iLg4li5iVJPHBpqiaviSog5MP82WrRWIN/U2NuUoXiE3R3G05In5bf47/BcNlaYuSw5r
         TY7FoFnUt8LsxJwW7Golo15Zr7pxD2JDCB/F7YFcStshkWcBbf14zYnOq9CyNkKkyUYL
         GQtBNYFSfB+mL85SqgoiKbPnOcD0xRd6re5WemLJ97anofCxlu2xl7NAKKtUT1ksbCmL
         TiLKe8bVYr+vQoalNaG2xu/HojCwUu3u1UYd2zktXNHybg6SAW1BJNBwyv8xjNIasv9G
         RMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ldUAi30p4Fm9YFcB6XPp82qK2Gx4LpczH2It45srXeo=;
        b=mfqYBYvZ+413a9lP/mwe6RMQQaNY0ogbY8J+kfzB9gMc6nrApxUFx9KtOiDjAtU2kl
         mbLs3MjWWn+ADIOE/Xy/Aq8LmFTDw1lBxcipGnxnIjVAJK6P94xQVim9w4glt3/UQy+u
         Grg5YoKtSc0XN7j54IZcCBCSkRSlX/amM1OeSQAPCGcVJ6jYEjFzB5TIuOlQ0U4O9CH8
         BvKSVg2QAhWYL7p2XGSTHGKzO7YRgvgihkKId1mmiBaswUnWK2HwIBCHLV++r8QzT6ww
         Qo+6mnEtrOh5AMQM9pgrD8JUqebsg5dc4HPyOmfDvyarfo7EDhWnwVEZXT75slKvTHRr
         ny6A==
X-Gm-Message-State: APjAAAUIFht1CkCjL6+AttHgONRZwNGlOJmcfbpwkRExhbD//ixzTzvU
        8EGdcCghfLPFisH9m0LCEWH312bVBzc=
X-Google-Smtp-Source: APXvYqwXA7UudhebZ3PjOLU7xMSYDqHPA3gpUTrpfjHhuIm1CEOoB/cMYEqKSVi2rCrmP7SQU/ckUQ==
X-Received: by 2002:a63:e14b:: with SMTP id h11mr19248346pgk.297.1575912716328;
        Mon, 09 Dec 2019 09:31:56 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id d23sm54943pfo.176.2019.12.09.09.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 09:31:55 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 3/8] riscv, bpf: add support for far jumps and exits
Date:   Mon,  9 Dec 2019 18:31:31 +0100
Message-Id: <20191209173136.29615-4-bjorn.topel@gmail.com>
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

This commit add support for far (offset > 21b) jumps and exits.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 37 ++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index e2f6724b64f7..e9cc9832ac2c 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -506,16 +506,6 @@ static int is_13b_check(int off, int insn)
 	return 0;
 }
 
-static int is_21b_check(int off, int insn)
-{
-	if (!is_21b_int(off)) {
-		pr_err("bpf-jit: insn=%d 21b < offset=%d not supported yet!\n",
-		       insn, (int)off);
-		return -1;
-	}
-	return 0;
-}
-
 static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
 {
 	/* Note that the immediate from the add is sign-extended,
@@ -733,6 +723,21 @@ static void emit_sext_32_rd(u8 *rd, struct rv_jit_context *ctx)
 	*rd = RV_REG_T2;
 }
 
+static void emit_jump_and_link(u8 rd, int rvoff, struct rv_jit_context *ctx)
+{
+	s64 upper, lower;
+
+	if (is_21b_int(rvoff)) {
+		emit(rv_jal(rd, rvoff >> 1), ctx);
+		return;
+	}
+
+	upper = (rvoff + (1 << 11)) >> 12;
+	lower = rvoff & 0xfff;
+	emit(rv_auipc(RV_REG_T1, upper), ctx);
+	emit(rv_jalr(rd, RV_REG_T1, lower), ctx);
+}
+
 /* return -1 or inverted cond */
 static int invert_bpf_cond(u8 cond)
 {
@@ -1117,13 +1122,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	/* JUMP off */
 	case BPF_JMP | BPF_JA:
 		rvoff = rv_offset(i, off, ctx);
-		if (!is_21b_int(rvoff)) {
-			pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
-			       i, rvoff);
-			return -1;
-		}
-
-		emit(rv_jal(RV_REG_ZERO, rvoff >> 1), ctx);
+		emit_jump_and_link(RV_REG_ZERO, rvoff, ctx);
 		break;
 
 	/* IF (dst COND src) JUMP off */
@@ -1261,9 +1260,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			break;
 
 		rvoff = epilogue_offset(ctx);
-		if (is_21b_check(rvoff, i))
-			return -1;
-		emit(rv_jal(RV_REG_ZERO, rvoff >> 1), ctx);
+		emit_jump_and_link(RV_REG_ZERO, rvoff, ctx);
 		break;
 
 	/* dst = imm64 */
-- 
2.20.1

