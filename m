Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6523726A3E
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbfEVS4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:56:11 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44023 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729765AbfEVS4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:56:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id t7so3172367wrr.10
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mYjuI3PNQLgs76XUw59PtH5pPyLdg/8FK9GvazowTjQ=;
        b=essbNycxQqTDhqd9qqmdkmyiBn+Vxy17t6NM0uqHVizVKGfsX2m/yTORmJkXs77MHt
         PHzHsrU2r8m+YlDN2qGtRy3SKmtvInwQcrZrjxBapZY2dfuU9bO9SLblerO+OSYUOlvv
         BDpnaYXYWj8S2TcyKKGU8lFsj5sXgeIxwAm/rC518qV41idjNDucoRjwQjHEV36q5rOa
         6OsUdMaZDn8S+bxgIsdn/bqgnp/UZ3nA0N6Fj8ci5LZsUE/Qjn6iwI/sga1K5FGPdnM6
         Bvkuh3Ak6Mkn8qOp8hWNn1oVKT5x/swvOwhVV48fcoDRkUyGCp8oYZCNViB9B0weaseL
         rLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mYjuI3PNQLgs76XUw59PtH5pPyLdg/8FK9GvazowTjQ=;
        b=Spscgec+dym7nKZ09cyWbpyZ2my1FNdliyEkfxRp4XvfcpFxKUG7vURgYMlH8OT+1m
         +7v2tXhV+9XkvT9qI2u5CDWTRwaRAUKh1zpJr59MmuIoZOfHGiLN3XOR6uwAy27VooCx
         8F/C1URrB6szaBdapJOk3glWH2KKQddQAtDV/BdoKhoboY/okBZ/lDHfvvsZBp8ZbAeX
         j7c7IfZUsyRIk+scPjWCwWXz/BxuaLXNvLqVrLFBb+ED71pxxzDckRKUBEEU/NQ/xEv2
         j8z0qZ1cyaTn+LhheFGzo301P0vkbl4Spi15BYeEXQ9AEYtL1FUCVBKFRIsYSdeqW+ja
         7Vwg==
X-Gm-Message-State: APjAAAU0VwPRzGw7ecUe3wz0UYXK5j1XwXaSyA96WNh45+bo8v4/PRto
        bd9e+TCflCSjm78OuLfEaYfUxw==
X-Google-Smtp-Source: APXvYqzr2WToJzmAY3NaeD0Fm+rwa2Jz8faA6eWhlvR9Wp9GEhfi2g8ZJ1wUeLiNCcuE0mTyIRRQlA==
X-Received: by 2002:a5d:63c7:: with SMTP id c7mr11243011wrw.68.1558551365683;
        Wed, 22 May 2019 11:56:05 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t12sm16328801wro.2.2019.05.22.11.56.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 11:56:04 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
Subject: [PATCH v7 bpf-next 15/16] riscv: bpf: eliminate zero extension code-gen
Date:   Wed, 22 May 2019 19:55:11 +0100
Message-Id: <1558551312-17081-16-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Björn Töpel <bjorn.topel@gmail.com>
Acked-by: Björn Töpel <bjorn.topel@gmail.com>
Tested-by: Björn Töpel <bjorn.topel@gmail.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/riscv/net/bpf_jit_comp.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 80b12aa..c4c836e 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -731,6 +731,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 {
 	bool is64 = BPF_CLASS(insn->code) == BPF_ALU64 ||
 		    BPF_CLASS(insn->code) == BPF_JMP;
+	struct bpf_prog_aux *aux = ctx->prog->aux;
 	int rvoff, i = insn - ctx->prog->insnsi;
 	u8 rd = -1, rs = -1, code = insn->code;
 	s16 off = insn->off;
@@ -742,8 +743,13 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	/* dst = src */
 	case BPF_ALU | BPF_MOV | BPF_X:
 	case BPF_ALU64 | BPF_MOV | BPF_X:
+		if (imm == 1) {
+			/* Special mov32 for zext */
+			emit_zext_32(rd, ctx);
+			break;
+		}
 		emit(is64 ? rv_addi(rd, rs, 0) : rv_addiw(rd, rs, 0), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 
@@ -771,19 +777,19 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_MUL | BPF_X:
 	case BPF_ALU64 | BPF_MUL | BPF_X:
 		emit(is64 ? rv_mul(rd, rd, rs) : rv_mulw(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_DIV | BPF_X:
 	case BPF_ALU64 | BPF_DIV | BPF_X:
 		emit(is64 ? rv_divu(rd, rd, rs) : rv_divuw(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_MOD | BPF_X:
 	case BPF_ALU64 | BPF_MOD | BPF_X:
 		emit(is64 ? rv_remu(rd, rd, rs) : rv_remuw(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_LSH | BPF_X:
@@ -867,7 +873,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_MOV | BPF_K:
 	case BPF_ALU64 | BPF_MOV | BPF_K:
 		emit_imm(rd, imm, ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 
@@ -882,7 +888,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit(is64 ? rv_add(rd, rd, RV_REG_T1) :
 			     rv_addw(rd, rd, RV_REG_T1), ctx);
 		}
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_SUB | BPF_K:
@@ -895,7 +901,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit(is64 ? rv_sub(rd, rd, RV_REG_T1) :
 			     rv_subw(rd, rd, RV_REG_T1), ctx);
 		}
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_AND | BPF_K:
@@ -906,7 +912,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit_imm(RV_REG_T1, imm, ctx);
 			emit(rv_and(rd, rd, RV_REG_T1), ctx);
 		}
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_OR | BPF_K:
@@ -917,7 +923,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit_imm(RV_REG_T1, imm, ctx);
 			emit(rv_or(rd, rd, RV_REG_T1), ctx);
 		}
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_XOR | BPF_K:
@@ -928,7 +934,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit_imm(RV_REG_T1, imm, ctx);
 			emit(rv_xor(rd, rd, RV_REG_T1), ctx);
 		}
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_MUL | BPF_K:
@@ -936,7 +942,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		emit_imm(RV_REG_T1, imm, ctx);
 		emit(is64 ? rv_mul(rd, rd, RV_REG_T1) :
 		     rv_mulw(rd, rd, RV_REG_T1), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_DIV | BPF_K:
@@ -944,7 +950,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		emit_imm(RV_REG_T1, imm, ctx);
 		emit(is64 ? rv_divu(rd, rd, RV_REG_T1) :
 		     rv_divuw(rd, rd, RV_REG_T1), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_MOD | BPF_K:
@@ -952,7 +958,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		emit_imm(RV_REG_T1, imm, ctx);
 		emit(is64 ? rv_remu(rd, rd, RV_REG_T1) :
 		     rv_remuw(rd, rd, RV_REG_T1), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_LSH | BPF_K:
@@ -1239,6 +1245,8 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		emit_imm(RV_REG_T1, off, ctx);
 		emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
 		emit(rv_lbu(rd, 0, RV_REG_T1), ctx);
+		if (insn_is_zext(&insn[1]))
+			return 1;
 		break;
 	case BPF_LDX | BPF_MEM | BPF_H:
 		if (is_12b_int(off)) {
@@ -1249,6 +1257,8 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		emit_imm(RV_REG_T1, off, ctx);
 		emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
 		emit(rv_lhu(rd, 0, RV_REG_T1), ctx);
+		if (insn_is_zext(&insn[1]))
+			return 1;
 		break;
 	case BPF_LDX | BPF_MEM | BPF_W:
 		if (is_12b_int(off)) {
@@ -1259,6 +1269,8 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		emit_imm(RV_REG_T1, off, ctx);
 		emit(rv_add(RV_REG_T1, RV_REG_T1, rs), ctx);
 		emit(rv_lwu(rd, 0, RV_REG_T1), ctx);
+		if (insn_is_zext(&insn[1]))
+			return 1;
 		break;
 	case BPF_LDX | BPF_MEM | BPF_DW:
 		if (is_12b_int(off)) {
@@ -1503,6 +1515,11 @@ static void bpf_flush_icache(void *start, void *end)
 	flush_icache_range((unsigned long)start, (unsigned long)end);
 }
 
+bool bpf_jit_needs_zext(void)
+{
+	return true;
+}
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	bool tmp_blinded = false, extra_pass = false;
-- 
2.7.4

