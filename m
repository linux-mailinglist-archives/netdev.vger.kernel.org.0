Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C913712BB6
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfECKn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:43:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35732 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727546AbfECKn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:43:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id h15so1552506wrb.2
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 03:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mT1oHrlzqJHZYZWe7z3ygTdI3TkFROq27Kd1TlYleYw=;
        b=Xu/mKHeY2SalJuj/CJXKbIpcoMrtNoU3BWxTESigtgDs+/3ypGo/R1ednRUlHBnSI/
         XbC27h9t9o5pTyP2iaJWbeMsJdmqPxaHqbhb6qzBOZ+2+vwAL1XrBbSj2xEgaCGH7QAB
         LeOVNffThGOlondG8Bosrjr75YxAtNez17cKfFw9rI5497/ZJJotuHIl/RnBYOeSYZ1Q
         tMl9uhcVCvDEYMexQWkcxps2lKroUb56zU0LMEaN9KYfgQqUKRMxqpdkzrlXv9loDEhs
         70uiK3QDwodzdv/54rH0FoQGAlxEEMnzGkJBNn+mhvARiIYp4oUkkRB+1t8EMlGXtvjd
         YV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mT1oHrlzqJHZYZWe7z3ygTdI3TkFROq27Kd1TlYleYw=;
        b=ByMtOh2K3PnTwtk1fKN3pkRvJOopU9gWW5Az48anXEhZN1muUyivEo8f8Qj8YG96SA
         NQqd6nOZuU0kvycrhMPPH1YotdeaHO8KswYiE9Yhsu8ZqB5zGJ1LAyCzjhhK2pBDsi7W
         EnOzEQmBWusV/WT4Bmtnqja3AfBUunGQFeJ2FyU4w03AowMRp+e4H3wMD5F9pSOamzLx
         DuU5vDfhVvriO7YJxPCdCzj57N242exgEiEG6WD51N4Aq9pRtBe3puZbWHOObofpPqP2
         dVBgle0L2xoT5ovGGG3Rv2gam5VCcpKMCxk8kQjE14Lbyn2Xbwvv1jYblNkkKKABbqOg
         YeBg==
X-Gm-Message-State: APjAAAWLwL0GdVCXITMHJdfmo0DinZf4qunjvguOqngYMgi7+NdbU/HD
        qq54p2OSAH4mvR1hD5Rve32EeQ==
X-Google-Smtp-Source: APXvYqza0zCmjCkdvz0N2XG/mgvOsWoA8+k9/mYxMJzo8uOVEliiqUhhAQvsdeU6X974UrzLbkOV5Q==
X-Received: by 2002:a5d:4942:: with SMTP id r2mr6158071wrs.159.1556880235036;
        Fri, 03 May 2019 03:43:55 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r29sm1716999wra.56.2019.05.03.03.43.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 03:43:54 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        Shubham Bansal <illusionist.neo@gmail.com>
Subject: [PATCH v6 bpf-next 11/17] arm: bpf: eliminate zero extension code-gen
Date:   Fri,  3 May 2019 11:42:38 +0100
Message-Id: <1556880164-10689-12-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Shubham Bansal <illusionist.neo@gmail.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/arm/net/bpf_jit_32.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index c8bfbbf..a6f78c8 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -736,7 +736,8 @@ static inline void emit_a32_alu_r64(const bool is64, const s8 dst[],
 
 		/* ALU operation */
 		emit_alu_r(rd[1], rs, true, false, op, ctx);
-		emit_a32_mov_i(rd[0], 0, ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit_a32_mov_i(rd[0], 0, ctx);
 	}
 
 	arm_bpf_put_reg64(dst, rd, ctx);
@@ -758,8 +759,9 @@ static inline void emit_a32_mov_r64(const bool is64, const s8 dst[],
 				  struct jit_ctx *ctx) {
 	if (!is64) {
 		emit_a32_mov_r(dst_lo, src_lo, ctx);
-		/* Zero out high 4 bytes */
-		emit_a32_mov_i(dst_hi, 0, ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			/* Zero out high 4 bytes */
+			emit_a32_mov_i(dst_hi, 0, ctx);
 	} else if (__LINUX_ARM_ARCH__ < 6 &&
 		   ctx->cpu_architecture < CPU_ARCH_ARMv5TE) {
 		/* complete 8 byte move */
@@ -1060,17 +1062,20 @@ static inline void emit_ldx_r(const s8 dst[], const s8 src,
 	case BPF_B:
 		/* Load a Byte */
 		emit(ARM_LDRB_I(rd[1], rm, off), ctx);
-		emit_a32_mov_i(rd[0], 0, ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit_a32_mov_i(rd[0], 0, ctx);
 		break;
 	case BPF_H:
 		/* Load a HalfWord */
 		emit(ARM_LDRH_I(rd[1], rm, off), ctx);
-		emit_a32_mov_i(rd[0], 0, ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit_a32_mov_i(rd[0], 0, ctx);
 		break;
 	case BPF_W:
 		/* Load a Word */
 		emit(ARM_LDR_I(rd[1], rm, off), ctx);
-		emit_a32_mov_i(rd[0], 0, ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit_a32_mov_i(rd[0], 0, ctx);
 		break;
 	case BPF_DW:
 		/* Load a Double Word */
@@ -1352,6 +1357,10 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 	switch (code) {
 	/* ALU operations */
 
+	/* dst = (u32) dst */
+	case BPF_ALU | BPF_ZEXT:
+		emit_a32_mov_i(dst_hi, 0, ctx);
+		break;
 	/* dst = src */
 	case BPF_ALU | BPF_MOV | BPF_K:
 	case BPF_ALU | BPF_MOV | BPF_X:
@@ -1438,7 +1447,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		}
 		emit_udivmod(rd_lo, rd_lo, rt, ctx, BPF_OP(code));
 		arm_bpf_put_reg32(dst_lo, rd_lo, ctx);
-		emit_a32_mov_i(dst_hi, 0, ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit_a32_mov_i(dst_hi, 0, ctx);
 		break;
 	case BPF_ALU64 | BPF_DIV | BPF_K:
 	case BPF_ALU64 | BPF_DIV | BPF_X:
@@ -1453,7 +1463,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 			return -EINVAL;
 		if (imm)
 			emit_a32_alu_i(dst_lo, imm, ctx, BPF_OP(code));
-		emit_a32_mov_i(dst_hi, 0, ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit_a32_mov_i(dst_hi, 0, ctx);
 		break;
 	/* dst = dst << imm */
 	case BPF_ALU64 | BPF_LSH | BPF_K:
@@ -1488,7 +1499,8 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 	/* dst = ~dst */
 	case BPF_ALU | BPF_NEG:
 		emit_a32_alu_i(dst_lo, 0, ctx, BPF_OP(code));
-		emit_a32_mov_i(dst_hi, 0, ctx);
+		if (!ctx->prog->aux->verifier_zext)
+			emit_a32_mov_i(dst_hi, 0, ctx);
 		break;
 	/* dst = ~dst (64 bit) */
 	case BPF_ALU64 | BPF_NEG:
@@ -1838,6 +1850,11 @@ void bpf_jit_compile(struct bpf_prog *prog)
 	/* Nothing to do here. We support Internal BPF. */
 }
 
+bool bpf_jit_hardware_zext(void)
+{
+	return false;
+}
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	struct bpf_prog *tmp, *orig_prog = prog;
-- 
2.7.4

