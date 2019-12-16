Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCD31200AF
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfLPJOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:14:02 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32854 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbfLPJOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:14:01 -0500
Received: by mail-pf1-f193.google.com with SMTP id y206so5259709pfb.0;
        Mon, 16 Dec 2019 01:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rd0ylQkfUXD47lMr1COolacBtWcmBE98gO//niHtxXI=;
        b=qIUfuvAf5plY9AdGHbegpurFDTmDKuRlVF3Lz0ZeeaL8aWA07KSjFUz5a4g3OkJJl0
         7sbcqLQyJc8jhoPW73hcA42kFw6TJBw8xoN2xOZ80LkhaZbBFFE1384G2YNKLYH7cLvl
         QjT5IkEKFLuNPoPbfMEzv/19Yt/x7PznYObaS7/cbRag8ccccqbCFYY2EhHR0mUtvjXX
         REtJ63n76pIK3I7W2la1dJE4GhvFaWJDifDnthNlm55cutG1eDhWBvphwKnzV23yo/7W
         gq5R4rR4ItY/qmIm48K0OthXZRU6AH2lqdbfKsN8cClVt9DIc9CB0VIrlfZxalpMo6lH
         daHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rd0ylQkfUXD47lMr1COolacBtWcmBE98gO//niHtxXI=;
        b=hnEzyrD7L3pzF4BilZuKH9vGLv2XLy7F8nEquKpRbfJoLRO2+/9jLWpr5Gh62H9rUi
         jE5NdX/36tLJ4k1zlsAWtcwq2rPsFVwxv5hjRhBKICnmpThbh9CadKWCmAmZUb6UVBgg
         bTkCkaxo9yqLYNeknvQIMcK4qankXecyTXA2/0h+EeL9E5ajQr8ZFBzJ5VrcwQXtecnr
         9NECqh+gny57spvXNcdsYqfXndfKEZ2Uh1roHzvffI0W7JatyPU77tJE/Cv40hZtTZXp
         TysljVXghjA6QPR5FviXmC5DR2DMycIPR/taX8ugLax8P/dfOXWr3lXfAfHG0oUispSe
         mtPw==
X-Gm-Message-State: APjAAAW0vPnuY9BMW3UxIYifR+8sceUZZ1XGF0OMYZvET0uGp/SPWoHt
        +OKz4tHN4JA62jPtDRyx2Ck=
X-Google-Smtp-Source: APXvYqwvlSWpPBFZbhR83GOWOvhvx/HkAxTGzSWuJq1dD/CdoLWHqImIZK+iC3ThDTzoYJwhgDpBeg==
X-Received: by 2002:a63:1f0c:: with SMTP id f12mr17305605pgf.247.1576487640533;
        Mon, 16 Dec 2019 01:14:00 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id x21sm12505033pfn.164.2019.12.16.01.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:14:00 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 3/9] riscv, bpf: add support for far branching when emitting tail call
Date:   Mon, 16 Dec 2019 10:13:37 +0100
Message-Id: <20191216091343.23260-4-bjorn.topel@gmail.com>
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

Start use the emit_branch() function in the tail call emitter in order
to support far branching.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index e599458a9bcd..c38c95df3440 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -496,16 +496,6 @@ static int is_12b_check(int off, int insn)
 	return 0;
 }
 
-static int is_13b_check(int off, int insn)
-{
-	if (!is_13b_int(off)) {
-		pr_err("bpf-jit: insn=%d 13b < offset=%d not supported yet!\n",
-		       insn, (int)off);
-		return -1;
-	}
-	return 0;
-}
-
 static int is_21b_check(int off, int insn)
 {
 	if (!is_21b_int(off)) {
@@ -744,18 +734,14 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 		return -1;
 	emit(rv_lwu(RV_REG_T1, off, RV_REG_A1), ctx);
 	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
-	if (is_13b_check(off, insn))
-		return -1;
-	emit(rv_bgeu(RV_REG_A2, RV_REG_T1, off >> 1), ctx);
+	emit_branch(BPF_JGE, RV_REG_A2, RV_REG_T1, off, ctx);
 
 	/* if (--TCC < 0)
 	 *     goto out;
 	 */
 	emit(rv_addi(RV_REG_T1, tcc, -1), ctx);
 	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
-	if (is_13b_check(off, insn))
-		return -1;
-	emit(rv_blt(RV_REG_T1, RV_REG_ZERO, off >> 1), ctx);
+	emit_branch(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
 
 	/* prog = array->ptrs[index];
 	 * if (!prog)
@@ -768,9 +754,7 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 		return -1;
 	emit(rv_ld(RV_REG_T2, off, RV_REG_T2), ctx);
 	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
-	if (is_13b_check(off, insn))
-		return -1;
-	emit(rv_beq(RV_REG_T2, RV_REG_ZERO, off >> 1), ctx);
+	emit_branch(BPF_JEQ, RV_REG_T2, RV_REG_ZERO, off, ctx);
 
 	/* goto *(prog->bpf_func + 4); */
 	off = offsetof(struct bpf_prog, bpf_func);
-- 
2.20.1

