Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E4E1200B7
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfLPJON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:14:13 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38648 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbfLPJOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:14:12 -0500
Received: by mail-pj1-f66.google.com with SMTP id l4so2702302pjt.5;
        Mon, 16 Dec 2019 01:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fDxKy5+xWcbxsQCLEwvK2/ipDbDNasXEESlHOrWAL4M=;
        b=u8C9Hkmch6zgJB9Mga36IoCRDeJvXzqUoHzx8LOnbISGd4W3Gng24bK1CIkKkx+ayZ
         teMbIbjJweClsHJas6IsDCQOuwHJ5oGZc/CjgfjXKv7f4kZNWjxG1hkhMBykkrD8+E8t
         vbl/8Inmanaijpu1v4oV+wXyZDlxGXlfckw7ejvlDy6S/IC/qyRWtawsWXC0KJ42I3Uu
         xga7OBta8KWUrFq3SVbB5GkYfxv9vA07371d9//AcXY/dePrW+bSOea6dCQka64gXOlg
         DVWAKmK3TBMbh6dCDADKfW9CQUJjepEJSOy/CmO7FhXtJjq9qlh4r0J4+755LxHg3aIZ
         OGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fDxKy5+xWcbxsQCLEwvK2/ipDbDNasXEESlHOrWAL4M=;
        b=sR0+/plUKSwEH97rBR95FSquZzw/WpBRP5ZiIYk5QPkkbGIQWNNnylhNsa+tJrmWOr
         5Y7jTAwFBBYnTV3BWRw6ILfRlAjzy7rEJpMVpuCFquxqD7DRRHTY3KOR7oDTXJT4NWhb
         lfiDawSIyoIIn7wwMWsuMEfvyTrXK7GCkc7Wf5Uvqp+3+Xdoyx8f0VOPb2RzwKrZNN87
         HIkqoKuXmc1GlvbIYSIivLPe0Vf4RcuZsWcidAWLoLt77HbAaAlo2Hukv0kXzIF/p7NB
         0t2LwGajW5PojiWBaL7m+Ss5TpTuBYKWX6rpNoAtruY6to2M1YgTpzpqW/ygonvlOsgI
         EypA==
X-Gm-Message-State: APjAAAUhXPwqn8Rokjj8+f4Z3QguJ18iklfmatH4b5WfkRprVE7na+WI
        pwtTAjoAz2LagbnIRDOgzJs=
X-Google-Smtp-Source: APXvYqy4RRBfPnji3ZSdrSQ8+HXCy69F7PXRhowUO8OlRP12zL9gdt20Ak0hfOVAkVh+ql/ziFcfOw==
X-Received: by 2002:a17:90a:bc05:: with SMTP id w5mr16386171pjr.64.1576487650999;
        Mon, 16 Dec 2019 01:14:10 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id x21sm12505033pfn.164.2019.12.16.01.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:14:10 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 7/9] riscv, bpf: optimize calls
Date:   Mon, 16 Dec 2019 10:13:41 +0100
Message-Id: <20191216091343.23260-8-bjorn.topel@gmail.com>
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

Instead of using emit_imm() and emit_jalr() which can expand to six
instructions, start using jal or auipc+jalr.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/net/bpf_jit_comp.c | 101 +++++++++++++++++++++-------------
 1 file changed, 64 insertions(+), 37 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 46cff093f526..8d7e3343a08c 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -811,11 +811,12 @@ static void emit_sext_32_rd(u8 *rd, struct rv_jit_context *ctx)
 	*rd = RV_REG_T2;
 }
 
-static void emit_jump_and_link(u8 rd, int rvoff, struct rv_jit_context *ctx)
+static void emit_jump_and_link(u8 rd, s64 rvoff, bool force_jalr,
+			       struct rv_jit_context *ctx)
 {
 	s64 upper, lower;
 
-	if (is_21b_int(rvoff)) {
+	if (rvoff && is_21b_int(rvoff) && !force_jalr) {
 		emit(rv_jal(rd, rvoff >> 1), ctx);
 		return;
 	}
@@ -832,6 +833,28 @@ static bool is_signed_bpf_cond(u8 cond)
 		cond == BPF_JSGE || cond == BPF_JSLE;
 }
 
+static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
+{
+	s64 off = 0;
+	u64 ip;
+	u8 rd;
+
+	if (addr && ctx->insns) {
+		ip = (u64)(long)(ctx->insns + ctx->ninsns);
+		off = addr - ip;
+		if (!is_32b_int(off)) {
+			pr_err("bpf-jit: target call addr %pK is out of range\n",
+			       (void *)addr);
+			return -ERANGE;
+		}
+	}
+
+	emit_jump_and_link(RV_REG_RA, off, !fixed, ctx);
+	rd = bpf_to_rv_reg(BPF_REG_0, ctx);
+	emit(rv_addi(rd, RV_REG_A0, 0), ctx);
+	return 0;
+}
+
 static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		     bool extra_pass)
 {
@@ -1107,7 +1130,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	/* JUMP off */
 	case BPF_JMP | BPF_JA:
 		rvoff = rv_offset(i, off, ctx);
-		emit_jump_and_link(RV_REG_ZERO, rvoff, ctx);
+		emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
 		break;
 
 	/* IF (dst COND src) JUMP off */
@@ -1209,7 +1232,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_JMP | BPF_CALL:
 	{
 		bool fixed;
-		int i, ret;
+		int ret;
 		u64 addr;
 
 		mark_call(ctx);
@@ -1217,20 +1240,9 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 					    &fixed);
 		if (ret < 0)
 			return ret;
-		if (fixed) {
-			emit_imm(RV_REG_T1, addr, ctx);
-		} else {
-			i = ctx->ninsns;
-			emit_imm(RV_REG_T1, addr, ctx);
-			for (i = ctx->ninsns - i; i < 8; i++) {
-				/* nop */
-				emit(rv_addi(RV_REG_ZERO, RV_REG_ZERO, 0),
-				     ctx);
-			}
-		}
-		emit(rv_jalr(RV_REG_RA, RV_REG_T1, 0), ctx);
-		rd = bpf_to_rv_reg(BPF_REG_0, ctx);
-		emit(rv_addi(rd, RV_REG_A0, 0), ctx);
+		ret = emit_call(fixed, addr, ctx);
+		if (ret)
+			return ret;
 		break;
 	}
 	/* tail call */
@@ -1245,7 +1257,7 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			break;
 
 		rvoff = epilogue_offset(ctx);
-		emit_jump_and_link(RV_REG_ZERO, rvoff, ctx);
+		emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
 		break;
 
 	/* dst = imm64 */
@@ -1508,7 +1520,7 @@ static void build_epilogue(struct rv_jit_context *ctx)
 	__build_epilogue(false, ctx);
 }
 
-static int build_body(struct rv_jit_context *ctx, bool extra_pass)
+static int build_body(struct rv_jit_context *ctx, bool extra_pass, int *offset)
 {
 	const struct bpf_prog *prog = ctx->prog;
 	int i;
@@ -1520,12 +1532,12 @@ static int build_body(struct rv_jit_context *ctx, bool extra_pass)
 		ret = emit_insn(insn, ctx, extra_pass);
 		if (ret > 0) {
 			i++;
-			if (ctx->insns == NULL)
-				ctx->offset[i] = ctx->ninsns;
+			if (offset)
+				offset[i] = ctx->ninsns;
 			continue;
 		}
-		if (ctx->insns == NULL)
-			ctx->offset[i] = ctx->ninsns;
+		if (offset)
+			offset[i] = ctx->ninsns;
 		if (ret)
 			return ret;
 	}
@@ -1553,8 +1565,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	struct bpf_prog *tmp, *orig_prog = prog;
 	int pass = 0, prev_ninsns = 0, i;
 	struct rv_jit_data *jit_data;
+	unsigned int image_size = 0;
 	struct rv_jit_context *ctx;
-	unsigned int image_size;
 
 	if (!prog->jit_requested)
 		return orig_prog;
@@ -1599,36 +1611,51 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	for (i = 0; i < 16; i++) {
 		pass++;
 		ctx->ninsns = 0;
-		if (build_body(ctx, extra_pass)) {
+		if (build_body(ctx, extra_pass, ctx->offset)) {
 			prog = orig_prog;
 			goto out_offset;
 		}
 		build_prologue(ctx);
 		ctx->epilogue_offset = ctx->ninsns;
 		build_epilogue(ctx);
-		if (ctx->ninsns == prev_ninsns)
-			break;
+
+		if (ctx->ninsns == prev_ninsns) {
+			if (jit_data->header)
+				break;
+
+			image_size = sizeof(u32) * ctx->ninsns;
+			jit_data->header =
+				bpf_jit_binary_alloc(image_size,
+						     &jit_data->image,
+						     sizeof(u32),
+						     bpf_fill_ill_insns);
+			if (!jit_data->header) {
+				prog = orig_prog;
+				goto out_offset;
+			}
+
+			ctx->insns = (u32 *)jit_data->image;
+			/* Now, when the image is allocated, the image
+			 * can potentially shrink more (auipc/jalr ->
+			 * jal).
+			 */
+		}
 		prev_ninsns = ctx->ninsns;
 	}
 
-	/* Allocate image, now that we know the size. */
-	image_size = sizeof(u32) * ctx->ninsns;
-	jit_data->header = bpf_jit_binary_alloc(image_size, &jit_data->image,
-						sizeof(u32),
-						bpf_fill_ill_insns);
-	if (!jit_data->header) {
+	if (i == 16) {
+		pr_err("bpf-jit: image did not converge in <%d passes!\n", i);
+		bpf_jit_binary_free(jit_data->header);
 		prog = orig_prog;
 		goto out_offset;
 	}
 
-	/* Second, real pass, that acutally emits the image. */
-	ctx->insns = (u32 *)jit_data->image;
 skip_init_ctx:
 	pass++;
 	ctx->ninsns = 0;
 
 	build_prologue(ctx);
-	if (build_body(ctx, extra_pass)) {
+	if (build_body(ctx, extra_pass, NULL)) {
 		bpf_jit_binary_free(jit_data->header);
 		prog = orig_prog;
 		goto out_offset;
-- 
2.20.1

