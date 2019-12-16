Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580971200AC
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLPJN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:13:59 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39341 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbfLPJN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:13:59 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so5242757pfx.6;
        Mon, 16 Dec 2019 01:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IKFdvlWbIsqVMfKHWS/eTT8rPSF1iVyjiBiv16n+QTk=;
        b=SGfveANlxHXwLMslfZEaRSW/nPAhYZ6SWMDtMpv0P7BzgNymGsdpDF85JuMVRGqABz
         E71+C9XlkLs1G9LTkfW8sB7y9MMI/CUVkkyMyUwhY6hTwnCgFWRhmH+dRwOy27geCc1y
         kTfR591B16StnsAuUsS0G4W6VqD/J2G22gyVJvaDAJhSTMdseHZ/wu2XOHz9EbwDrOax
         2X61taMctG07feNkyDP1MWgk0ho1fMG/oisx1d0NqcmBF6EZnWNPCLKbB3/f6krO5SJB
         ShX6WPG9gRVA/+LgDnjz6z0uUwo7f6ui+Zq9wy3CoU/lk/aODBUEGYMVXdvl/k5tKYt0
         wqSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IKFdvlWbIsqVMfKHWS/eTT8rPSF1iVyjiBiv16n+QTk=;
        b=ZjN2R60uSJpOzrG106b1zxh7WSTFX0bqFi/9YRG1SZZ9AMEJjvrDEXAEWbP30rns3c
         GDr2I/5TKA5PtzbYrZZPZy/b3wPJb7Opps7wQegIbWTXgSbRwJ4kPsfRmOMktq7dr/Tc
         fiW+5UPOKyYoStCSi/vA4e4DIsiNFOOTzPi/eDi3rewbm+lxlP+DtFoYIKhow5Hp91td
         OqOGBpR3J/hgpUFxWjmTl9xc+TDBogi89HR8T6OghmAYB8BU4pR/nD8wQJMkzYwJTibT
         UVRHkmqx5GjSGy2Z9nCMx2E/FKfmbuLFMD3tEVYlAjmyF6hg6BTyxXwuTM4/JB/1ERf0
         xMjQ==
X-Gm-Message-State: APjAAAW8PLxAygLijsnZlNPMjvggtAg4IMWWX8wkS9+7PkfpbFpb4SpI
        /78RsC4K7yEyni1HwWtk2xs=
X-Google-Smtp-Source: APXvYqxfvROp5uFKPkUAnVkaSA6bxX57635PyRj+vzQOEtM3gj4b2rYQUukNxytA1z7gXWYQRgwgJQ==
X-Received: by 2002:a63:512:: with SMTP id 18mr16957496pgf.221.1576487638048;
        Mon, 16 Dec 2019 01:13:58 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id x21sm12505033pfn.164.2019.12.16.01.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:13:57 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org,
        Luke Nelson <lukenels@cs.washington.edu>,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH bpf-next v2 2/9] riscv, bpf: add support for far branching
Date:   Mon, 16 Dec 2019 10:13:36 +0100
Message-Id: <20191216091343.23260-3-bjorn.topel@gmail.com>
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

This commit adds branch relaxation to the BPF JIT, and with that
support for far (offset greater than 12b) branching.

The branch relaxation requires more than two passes to converge. For
most programs it is three passes, but for larger programs it can be
more.

Reviewed-by: Luke Nelson <lukenels@cs.washington.edu>
Cc: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 352 ++++++++++++++++++----------------
 1 file changed, 188 insertions(+), 164 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 1606ebd49666..e599458a9bcd 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -461,6 +461,11 @@ static u32 rv_amoadd_d(u8 rd, u8 rs2, u8 rs1, u8 aq, u8 rl)
 	return rv_amo_insn(0, aq, rl, rs2, rs1, 3, rd, 0x2f);
 }
 
+static u32 rv_auipc(u8 rd, u32 imm31_12)
+{
+	return rv_u_insn(imm31_12, rd, 0x17);
+}
+
 static bool is_12b_int(s64 val)
 {
 	return -(1 << 11) <= val && val < (1 << 11);
@@ -484,7 +489,7 @@ static bool is_32b_int(s64 val)
 static int is_12b_check(int off, int insn)
 {
 	if (!is_12b_int(off)) {
-		pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
+		pr_err("bpf-jit: insn=%d 12b < offset=%d not supported yet!\n",
 		       insn, (int)off);
 		return -1;
 	}
@@ -494,7 +499,7 @@ static int is_12b_check(int off, int insn)
 static int is_13b_check(int off, int insn)
 {
 	if (!is_13b_int(off)) {
-		pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
+		pr_err("bpf-jit: insn=%d 13b < offset=%d not supported yet!\n",
 		       insn, (int)off);
 		return -1;
 	}
@@ -504,7 +509,7 @@ static int is_13b_check(int off, int insn)
 static int is_21b_check(int off, int insn)
 {
 	if (!is_21b_int(off)) {
-		pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
+		pr_err("bpf-jit: insn=%d 21b < offset=%d not supported yet!\n",
 		       insn, (int)off);
 		return -1;
 	}
@@ -550,10 +555,13 @@ static void emit_imm(u8 rd, s64 val, struct rv_jit_context *ctx)
 		emit(rv_addi(rd, rd, lower), ctx);
 }
 
-static int rv_offset(int bpf_to, int bpf_from, struct rv_jit_context *ctx)
+static int rv_offset(int insn, int off, struct rv_jit_context *ctx)
 {
-	int from = ctx->offset[bpf_from] - 1, to = ctx->offset[bpf_to];
+	int from, to;
 
+	off++; /* BPF branch is from PC+1, RV is from PC */
+	from = (insn > 0) ? ctx->offset[insn - 1] : 0;
+	to = (insn + off > 0) ? ctx->offset[insn + off - 1] : 0;
 	return (to - from) << 2;
 }
 
@@ -606,6 +614,109 @@ static void __build_epilogue(u8 reg, struct rv_jit_context *ctx)
 	emit(rv_jalr(RV_REG_ZERO, reg, 0), ctx);
 }
 
+/* return -1 or inverted cond */
+static int invert_bpf_cond(u8 cond)
+{
+	switch (cond) {
+	case BPF_JEQ:
+		return BPF_JNE;
+	case BPF_JGT:
+		return BPF_JLE;
+	case BPF_JLT:
+		return BPF_JGE;
+	case BPF_JGE:
+		return BPF_JLT;
+	case BPF_JLE:
+		return BPF_JGT;
+	case BPF_JNE:
+		return BPF_JEQ;
+	case BPF_JSGT:
+		return BPF_JSLE;
+	case BPF_JSLT:
+		return BPF_JSGE;
+	case BPF_JSGE:
+		return BPF_JSLT;
+	case BPF_JSLE:
+		return BPF_JSGT;
+	}
+	return -1;
+}
+
+static void emit_bcc(u8 cond, u8 rd, u8 rs, int rvoff,
+		     struct rv_jit_context *ctx)
+{
+	switch (cond) {
+	case BPF_JEQ:
+		emit(rv_beq(rd, rs, rvoff >> 1), ctx);
+		return;
+	case BPF_JGT:
+		emit(rv_bltu(rs, rd, rvoff >> 1), ctx);
+		return;
+	case BPF_JLT:
+		emit(rv_bltu(rd, rs, rvoff >> 1), ctx);
+		return;
+	case BPF_JGE:
+		emit(rv_bgeu(rd, rs, rvoff >> 1), ctx);
+		return;
+	case BPF_JLE:
+		emit(rv_bgeu(rs, rd, rvoff >> 1), ctx);
+		return;
+	case BPF_JNE:
+		emit(rv_bne(rd, rs, rvoff >> 1), ctx);
+		return;
+	case BPF_JSGT:
+		emit(rv_blt(rs, rd, rvoff >> 1), ctx);
+		return;
+	case BPF_JSLT:
+		emit(rv_blt(rd, rs, rvoff >> 1), ctx);
+		return;
+	case BPF_JSGE:
+		emit(rv_bge(rd, rs, rvoff >> 1), ctx);
+		return;
+	case BPF_JSLE:
+		emit(rv_bge(rs, rd, rvoff >> 1), ctx);
+	}
+}
+
+static void emit_branch(u8 cond, u8 rd, u8 rs, int rvoff,
+			struct rv_jit_context *ctx)
+{
+	s64 upper, lower;
+
+	if (is_13b_int(rvoff)) {
+		emit_bcc(cond, rd, rs, rvoff, ctx);
+		return;
+	}
+
+	/* Adjust for jal */
+	rvoff -= 4;
+
+	/* Transform, e.g.:
+	 *   bne rd,rs,foo
+	 * to
+	 *   beq rd,rs,<.L1>
+	 *   (auipc foo)
+	 *   jal(r) foo
+	 * .L1
+	 */
+	cond = invert_bpf_cond(cond);
+	if (is_21b_int(rvoff)) {
+		emit_bcc(cond, rd, rs, 8, ctx);
+		emit(rv_jal(RV_REG_ZERO, rvoff >> 1), ctx);
+		return;
+	}
+
+	/* 32b No need for an additional rvoff adjustment, since we
+	 * get that from the auipc at PC', where PC = PC' + 4.
+	 */
+	upper = (rvoff + (1 << 11)) >> 12;
+	lower = rvoff & 0xfff;
+
+	emit_bcc(cond, rd, rs, 12, ctx);
+	emit(rv_auipc(RV_REG_T1, upper), ctx);
+	emit(rv_jalr(RV_REG_ZERO, RV_REG_T1, lower), ctx);
+}
+
 static void emit_zext_32(u8 reg, struct rv_jit_context *ctx)
 {
 	emit(rv_slli(reg, reg, 32), ctx);
@@ -693,13 +804,6 @@ static void init_regs(u8 *rd, u8 *rs, const struct bpf_insn *insn,
 		*rs = bpf_to_rv_reg(insn->src_reg, ctx);
 }
 
-static int rv_offset_check(int *rvoff, s16 off, int insn,
-			   struct rv_jit_context *ctx)
-{
-	*rvoff = rv_offset(insn + off, insn, ctx);
-	return is_13b_check(*rvoff, insn);
-}
-
 static void emit_zext_32_rd_rs(u8 *rd, u8 *rs, struct rv_jit_context *ctx)
 {
 	emit(rv_addi(RV_REG_T2, *rd, 0), ctx);
@@ -732,13 +836,19 @@ static void emit_sext_32_rd(u8 *rd, struct rv_jit_context *ctx)
 	*rd = RV_REG_T2;
 }
 
+static bool is_signed_bpf_cond(u8 cond)
+{
+	return cond == BPF_JSGT || cond == BPF_JSLT ||
+		cond == BPF_JSGE || cond == BPF_JSLE;
+}
+
 static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		     bool extra_pass)
 {
 	bool is64 = BPF_CLASS(insn->code) == BPF_ALU64 ||
 		    BPF_CLASS(insn->code) == BPF_JMP;
+	int s, e, rvoff, i = insn - ctx->prog->insnsi;
 	struct bpf_prog_aux *aux = ctx->prog->aux;
-	int rvoff, i = insn - ctx->prog->insnsi;
 	u8 rd = -1, rs = -1, code = insn->code;
 	s16 off = insn->off;
 	s32 imm = insn->imm;
@@ -1006,7 +1116,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 
 	/* JUMP off */
 	case BPF_JMP | BPF_JA:
-		rvoff = rv_offset(i + off, i, ctx);
+		rvoff = rv_offset(i, off, ctx);
 		if (!is_21b_int(rvoff)) {
 			pr_err("bpf-jit: insn=%d offset=%d not supported yet!\n",
 			       i, rvoff);
@@ -1019,194 +1129,96 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	/* IF (dst COND src) JUMP off */
 	case BPF_JMP | BPF_JEQ | BPF_X:
 	case BPF_JMP32 | BPF_JEQ | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_zext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_beq(rd, rs, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JGT | BPF_X:
 	case BPF_JMP32 | BPF_JGT | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_zext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_bltu(rs, rd, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JLT | BPF_X:
 	case BPF_JMP32 | BPF_JLT | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_zext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_bltu(rd, rs, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JGE | BPF_X:
 	case BPF_JMP32 | BPF_JGE | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_zext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_bgeu(rd, rs, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JLE | BPF_X:
 	case BPF_JMP32 | BPF_JLE | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_zext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_bgeu(rs, rd, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JNE | BPF_X:
 	case BPF_JMP32 | BPF_JNE | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_zext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_bne(rd, rs, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JSGT | BPF_X:
 	case BPF_JMP32 | BPF_JSGT | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_sext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_blt(rs, rd, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JSLT | BPF_X:
 	case BPF_JMP32 | BPF_JSLT | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_sext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_blt(rd, rs, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JSGE | BPF_X:
 	case BPF_JMP32 | BPF_JSGE | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_sext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_bge(rd, rs, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JSLE | BPF_X:
 	case BPF_JMP32 | BPF_JSLE | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_sext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_bge(rs, rd, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JSET | BPF_X:
 	case BPF_JMP32 | BPF_JSET | BPF_X:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		if (!is64)
-			emit_zext_32_rd_rs(&rd, &rs, ctx);
-		emit(rv_and(RV_REG_T1, rd, rs), ctx);
-		emit(rv_bne(RV_REG_T1, RV_REG_ZERO, rvoff >> 1), ctx);
+		rvoff = rv_offset(i, off, ctx);
+		if (!is64) {
+			s = ctx->ninsns;
+			if (is_signed_bpf_cond(BPF_OP(code)))
+				emit_sext_32_rd_rs(&rd, &rs, ctx);
+			else
+				emit_zext_32_rd_rs(&rd, &rs, ctx);
+			e = ctx->ninsns;
+
+			/* Adjust for extra insns */
+			rvoff -= (e - s) << 2;
+		}
+
+		if (BPF_OP(code) == BPF_JSET) {
+			/* Adjust for and */
+			rvoff -= 4;
+			emit(rv_and(RV_REG_T1, rd, rs), ctx);
+			emit_branch(BPF_JNE, RV_REG_T1, RV_REG_ZERO, rvoff,
+				    ctx);
+		} else {
+			emit_branch(BPF_OP(code), rd, rs, rvoff, ctx);
+		}
 		break;
 
 	/* IF (dst COND imm) JUMP off */
 	case BPF_JMP | BPF_JEQ | BPF_K:
 	case BPF_JMP32 | BPF_JEQ | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_zext_32_rd_t1(&rd, ctx);
-		emit(rv_beq(rd, RV_REG_T1, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JGT | BPF_K:
 	case BPF_JMP32 | BPF_JGT | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_zext_32_rd_t1(&rd, ctx);
-		emit(rv_bltu(RV_REG_T1, rd, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JLT | BPF_K:
 	case BPF_JMP32 | BPF_JLT | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_zext_32_rd_t1(&rd, ctx);
-		emit(rv_bltu(rd, RV_REG_T1, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JGE | BPF_K:
 	case BPF_JMP32 | BPF_JGE | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_zext_32_rd_t1(&rd, ctx);
-		emit(rv_bgeu(rd, RV_REG_T1, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JLE | BPF_K:
 	case BPF_JMP32 | BPF_JLE | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_zext_32_rd_t1(&rd, ctx);
-		emit(rv_bgeu(RV_REG_T1, rd, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JNE | BPF_K:
 	case BPF_JMP32 | BPF_JNE | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_zext_32_rd_t1(&rd, ctx);
-		emit(rv_bne(rd, RV_REG_T1, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JSGT | BPF_K:
 	case BPF_JMP32 | BPF_JSGT | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_sext_32_rd(&rd, ctx);
-		emit(rv_blt(RV_REG_T1, rd, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JSLT | BPF_K:
 	case BPF_JMP32 | BPF_JSLT | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_sext_32_rd(&rd, ctx);
-		emit(rv_blt(rd, RV_REG_T1, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JSGE | BPF_K:
 	case BPF_JMP32 | BPF_JSGE | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_sext_32_rd(&rd, ctx);
-		emit(rv_bge(rd, RV_REG_T1, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JSLE | BPF_K:
 	case BPF_JMP32 | BPF_JSLE | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
-		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_sext_32_rd(&rd, ctx);
-		emit(rv_bge(RV_REG_T1, rd, rvoff >> 1), ctx);
-		break;
 	case BPF_JMP | BPF_JSET | BPF_K:
 	case BPF_JMP32 | BPF_JSET | BPF_K:
-		if (rv_offset_check(&rvoff, off, i, ctx))
-			return -1;
+		rvoff = rv_offset(i, off, ctx);
+		s = ctx->ninsns;
 		emit_imm(RV_REG_T1, imm, ctx);
-		if (!is64)
-			emit_zext_32_rd_t1(&rd, ctx);
-		emit(rv_and(RV_REG_T1, rd, RV_REG_T1), ctx);
-		emit(rv_bne(RV_REG_T1, RV_REG_ZERO, rvoff >> 1), ctx);
+		if (!is64) {
+			if (is_signed_bpf_cond(BPF_OP(code)))
+				emit_sext_32_rd(&rd, ctx);
+			else
+				emit_zext_32_rd_t1(&rd, ctx);
+		}
+		e = ctx->ninsns;
+
+		/* Adjust for extra insns */
+		rvoff -= (e - s) << 2;
+
+		if (BPF_OP(code) == BPF_JSET) {
+			/* Adjust for and */
+			rvoff -= 4;
+			emit(rv_and(RV_REG_T1, rd, RV_REG_T1), ctx);
+			emit_branch(BPF_JNE, RV_REG_T1, RV_REG_ZERO, rvoff,
+				    ctx);
+		} else {
+			emit_branch(BPF_OP(code), rd, RV_REG_T1, rvoff, ctx);
+		}
 		break;
 
 	/* function call */
@@ -1557,6 +1569,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	bool tmp_blinded = false, extra_pass = false;
 	struct bpf_prog *tmp, *orig_prog = prog;
+	int pass = 0, prev_ninsns = 0, i;
 	struct rv_jit_data *jit_data;
 	struct rv_jit_context *ctx;
 	unsigned int image_size;
@@ -1596,15 +1609,25 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		prog = orig_prog;
 		goto out_offset;
 	}
+	for (i = 0; i < prog->len; i++) {
+		prev_ninsns += 32;
+		ctx->offset[i] = prev_ninsns;
+	}
 
-	/* First pass generates the ctx->offset, but does not emit an image. */
-	if (build_body(ctx, extra_pass)) {
-		prog = orig_prog;
-		goto out_offset;
+	for (i = 0; i < 16; i++) {
+		pass++;
+		ctx->ninsns = 0;
+		if (build_body(ctx, extra_pass)) {
+			prog = orig_prog;
+			goto out_offset;
+		}
+		build_prologue(ctx);
+		ctx->epilogue_offset = ctx->ninsns;
+		build_epilogue(ctx);
+		if (ctx->ninsns == prev_ninsns)
+			break;
+		prev_ninsns = ctx->ninsns;
 	}
-	build_prologue(ctx);
-	ctx->epilogue_offset = ctx->ninsns;
-	build_epilogue(ctx);
 
 	/* Allocate image, now that we know the size. */
 	image_size = sizeof(u32) * ctx->ninsns;
@@ -1619,6 +1642,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	/* Second, real pass, that acutally emits the image. */
 	ctx->insns = (u32 *)jit_data->image;
 skip_init_ctx:
+	pass++;
 	ctx->ninsns = 0;
 
 	build_prologue(ctx);
@@ -1630,7 +1654,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	build_epilogue(ctx);
 
 	if (bpf_jit_enable > 1)
-		bpf_jit_dump(prog->len, image_size, 2, ctx->insns);
+		bpf_jit_dump(prog->len, image_size, pass, ctx->insns);
 
 	prog->bpf_func = (void *)ctx->insns;
 	prog->jited = 1;
-- 
2.20.1

