Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1781095E
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfEAOoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36944 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfEAOoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id y5so7273004wma.2
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PbSXjy3xqg2/4bPZ6TFNBP6P2iMvPVVWPTeoc6hgQFM=;
        b=yOKmQ09BhPNohYVm3i7uSoU4yb6FRmnpVraiE0ScVcomR++oWXiC0vktvf9dwV821l
         lynGIg+EboHhiWmzgBL7aqUQKCBPObNqSD4ZlDWQrVJiqe+KNugBwM6KgHu7xhViVYOM
         qbIaGHAXfvQkLZE6rs0mFZQejVvE8imG1vHjQJM11PcwEXSkmL7z4QVtEnU7kltGbIsy
         b+7OLphNhrzI0W9Hkb8RgcKuOwMZqxtIXGMCK+BDM+q0MfuVOVf9Ep0Q15n9Ukq7DkUz
         sHGX9Nrek/ssnjA46Jj4OWMZk2dd8418J3yOfePzwBfYphgKCYP7AxfCEsaaXNdontaz
         gEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PbSXjy3xqg2/4bPZ6TFNBP6P2iMvPVVWPTeoc6hgQFM=;
        b=UqzIe9xt0yll/RO9JTyMABp0esc6qjHrhwJ2CnexN6L3VPlVYEikF7cZedMaIoI0Ry
         1Q2sDwQPw1TsvakiCSndgS+qQ7wVUAWoTWYQr7Be0Tk0DRrt3JibooSdP1ihZVSNWgxK
         jh1Qdk13KvBLIIOuJUkqSMrr7H3oL2BSqbUsZssst6PpbI2Zd+o0dxQNGWuyPPUgA/BT
         JN0eI611VH1UPqzHZ7I4sRrv3kVvMRL6/7YxnPvGwTteI4qI5OtX9PTenIXu/Vhd0c+U
         tkuVt+FPlyeNqXlwRzVhrCXh9aS1nHYgt9iEGuMlZiIWlzgrpAw8hugcGvX8Li2b6PVZ
         5A/A==
X-Gm-Message-State: APjAAAWfv3mnMVZ77ZkRoiHB1Me/atT0Su0Y4kfpN3i55VFlpkTnio/I
        zUvb7EsLLC8I37Pw7PMtImJyIw==
X-Google-Smtp-Source: APXvYqzOe64HjpDrt0SBm5E4oRkvC0tstIYt43O6nEW3ul85gNwOowo/TO1cz7mX3Ej566aqpd0I/Q==
X-Received: by 2002:a1c:1f58:: with SMTP id f85mr7223733wmf.17.1556721868107;
        Wed, 01 May 2019 07:44:28 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:27 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v5 bpf-next 17/17] nfp: bpf: eliminate zero extension code-gen
Date:   Wed,  1 May 2019 15:44:02 +0100
Message-Id: <1556721842-29836-18-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch eliminate zero extension code-gen for instructions including
both alu and load/store. The only exception is for ctx load, because
offload target doesn't go through host ctx convert logic so we do
customized load and ignores zext flag set by verifier.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/jit.c      | 115 +++++++++++++---------
 drivers/net/ethernet/netronome/nfp/bpf/main.h     |   2 +
 drivers/net/ethernet/netronome/nfp/bpf/verifier.c |  12 +++
 3 files changed, 81 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/jit.c b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
index f272247..634bae0 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/jit.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
@@ -612,6 +612,13 @@ static void wrp_immed(struct nfp_prog *nfp_prog, swreg dst, u32 imm)
 }
 
 static void
+wrp_zext(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta, u8 dst)
+{
+	if (meta->flags & FLAG_INSN_DO_ZEXT)
+		wrp_immed(nfp_prog, reg_both(dst + 1), 0);
+}
+
+static void
 wrp_immed_relo(struct nfp_prog *nfp_prog, swreg dst, u32 imm,
 	       enum nfp_relo_type relo)
 {
@@ -847,7 +854,8 @@ static int nfp_cpp_memcpy(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 }
 
 static int
-data_ld(struct nfp_prog *nfp_prog, swreg offset, u8 dst_gpr, int size)
+data_ld(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta, swreg offset,
+	u8 dst_gpr, int size)
 {
 	unsigned int i;
 	u16 shift, sz;
@@ -870,14 +878,15 @@ data_ld(struct nfp_prog *nfp_prog, swreg offset, u8 dst_gpr, int size)
 			wrp_mov(nfp_prog, reg_both(dst_gpr + i), reg_xfer(i));
 
 	if (i < 2)
-		wrp_immed(nfp_prog, reg_both(dst_gpr + 1), 0);
+		wrp_zext(nfp_prog, meta, dst_gpr);
 
 	return 0;
 }
 
 static int
-data_ld_host_order(struct nfp_prog *nfp_prog, u8 dst_gpr,
-		   swreg lreg, swreg rreg, int size, enum cmd_mode mode)
+data_ld_host_order(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
+		   u8 dst_gpr, swreg lreg, swreg rreg, int size,
+		   enum cmd_mode mode)
 {
 	unsigned int i;
 	u8 mask, sz;
@@ -900,33 +909,34 @@ data_ld_host_order(struct nfp_prog *nfp_prog, u8 dst_gpr,
 			wrp_mov(nfp_prog, reg_both(dst_gpr + i), reg_xfer(i));
 
 	if (i < 2)
-		wrp_immed(nfp_prog, reg_both(dst_gpr + 1), 0);
+		wrp_zext(nfp_prog, meta, dst_gpr);
 
 	return 0;
 }
 
 static int
-data_ld_host_order_addr32(struct nfp_prog *nfp_prog, u8 src_gpr, swreg offset,
-			  u8 dst_gpr, u8 size)
+data_ld_host_order_addr32(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
+			  u8 src_gpr, swreg offset, u8 dst_gpr, u8 size)
 {
-	return data_ld_host_order(nfp_prog, dst_gpr, reg_a(src_gpr), offset,
-				  size, CMD_MODE_32b);
+	return data_ld_host_order(nfp_prog, meta, dst_gpr, reg_a(src_gpr),
+				  offset, size, CMD_MODE_32b);
 }
 
 static int
-data_ld_host_order_addr40(struct nfp_prog *nfp_prog, u8 src_gpr, swreg offset,
-			  u8 dst_gpr, u8 size)
+data_ld_host_order_addr40(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
+			  u8 src_gpr, swreg offset, u8 dst_gpr, u8 size)
 {
 	swreg rega, regb;
 
 	addr40_offset(nfp_prog, src_gpr, offset, &rega, &regb);
 
-	return data_ld_host_order(nfp_prog, dst_gpr, rega, regb,
+	return data_ld_host_order(nfp_prog, meta, dst_gpr, rega, regb,
 				  size, CMD_MODE_40b_BA);
 }
 
 static int
-construct_data_ind_ld(struct nfp_prog *nfp_prog, u16 offset, u16 src, u8 size)
+construct_data_ind_ld(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
+		      u16 offset, u16 src, u8 size)
 {
 	swreg tmp_reg;
 
@@ -942,10 +952,12 @@ construct_data_ind_ld(struct nfp_prog *nfp_prog, u16 offset, u16 src, u8 size)
 	emit_br_relo(nfp_prog, BR_BLO, BR_OFF_RELO, 0, RELO_BR_GO_ABORT);
 
 	/* Load data */
-	return data_ld(nfp_prog, imm_b(nfp_prog), 0, size);
+	return data_ld(nfp_prog, meta, imm_b(nfp_prog), 0, size);
 }
 
-static int construct_data_ld(struct nfp_prog *nfp_prog, u16 offset, u8 size)
+static int
+construct_data_ld(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
+		  u16 offset, u8 size)
 {
 	swreg tmp_reg;
 
@@ -956,7 +968,7 @@ static int construct_data_ld(struct nfp_prog *nfp_prog, u16 offset, u8 size)
 
 	/* Load data */
 	tmp_reg = re_load_imm_any(nfp_prog, offset, imm_b(nfp_prog));
-	return data_ld(nfp_prog, tmp_reg, 0, size);
+	return data_ld(nfp_prog, meta, tmp_reg, 0, size);
 }
 
 static int
@@ -1193,7 +1205,7 @@ mem_op_stack(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 	}
 
 	if (clr_gpr && size < 8)
-		wrp_immed(nfp_prog, reg_both(gpr + 1), 0);
+		wrp_zext(nfp_prog, meta, gpr);
 
 	while (size) {
 		u32 slice_end;
@@ -1294,9 +1306,10 @@ wrp_alu32_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 	      enum alu_op alu_op)
 {
 	const struct bpf_insn *insn = &meta->insn;
+	u8 dst = insn->dst_reg * 2;
 
-	wrp_alu_imm(nfp_prog, insn->dst_reg * 2, alu_op, insn->imm);
-	wrp_immed(nfp_prog, reg_both(insn->dst_reg * 2 + 1), 0);
+	wrp_alu_imm(nfp_prog, dst, alu_op, insn->imm);
+	wrp_zext(nfp_prog, meta, dst);
 
 	return 0;
 }
@@ -1308,7 +1321,7 @@ wrp_alu32_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 	u8 dst = meta->insn.dst_reg * 2, src = meta->insn.src_reg * 2;
 
 	emit_alu(nfp_prog, reg_both(dst), reg_a(dst), alu_op, reg_b(src));
-	wrp_immed(nfp_prog, reg_both(meta->insn.dst_reg * 2 + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 
 	return 0;
 }
@@ -2385,12 +2398,14 @@ static int neg_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	u8 dst = meta->insn.dst_reg * 2;
 
 	emit_alu(nfp_prog, reg_both(dst), reg_imm(0), ALU_OP_SUB, reg_b(dst));
-	wrp_immed(nfp_prog, reg_both(meta->insn.dst_reg * 2 + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 
 	return 0;
 }
 
-static int __ashr_imm(struct nfp_prog *nfp_prog, u8 dst, u8 shift_amt)
+static int
+__ashr_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta, u8 dst,
+	   u8 shift_amt)
 {
 	if (shift_amt) {
 		/* Set signedness bit (MSB of result). */
@@ -2399,7 +2414,7 @@ static int __ashr_imm(struct nfp_prog *nfp_prog, u8 dst, u8 shift_amt)
 		emit_shf(nfp_prog, reg_both(dst), reg_none(), SHF_OP_ASHR,
 			 reg_b(dst), SHF_SC_R_SHF, shift_amt);
 	}
-	wrp_immed(nfp_prog, reg_both(dst + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 
 	return 0;
 }
@@ -2414,7 +2429,7 @@ static int ashr_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	umin = meta->umin_src;
 	umax = meta->umax_src;
 	if (umin == umax)
-		return __ashr_imm(nfp_prog, dst, umin);
+		return __ashr_imm(nfp_prog, meta, dst, umin);
 
 	src = insn->src_reg * 2;
 	/* NOTE: the first insn will set both indirect shift amount (source A)
@@ -2423,7 +2438,7 @@ static int ashr_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	emit_alu(nfp_prog, reg_none(), reg_a(src), ALU_OP_OR, reg_b(dst));
 	emit_shf_indir(nfp_prog, reg_both(dst), reg_none(), SHF_OP_ASHR,
 		       reg_b(dst), SHF_SC_R_SHF);
-	wrp_immed(nfp_prog, reg_both(dst + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 
 	return 0;
 }
@@ -2433,15 +2448,17 @@ static int ashr_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	const struct bpf_insn *insn = &meta->insn;
 	u8 dst = insn->dst_reg * 2;
 
-	return __ashr_imm(nfp_prog, dst, insn->imm);
+	return __ashr_imm(nfp_prog, meta, dst, insn->imm);
 }
 
-static int __shr_imm(struct nfp_prog *nfp_prog, u8 dst, u8 shift_amt)
+static int
+__shr_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta, u8 dst,
+	  u8 shift_amt)
 {
 	if (shift_amt)
 		emit_shf(nfp_prog, reg_both(dst), reg_none(), SHF_OP_NONE,
 			 reg_b(dst), SHF_SC_R_SHF, shift_amt);
-	wrp_immed(nfp_prog, reg_both(dst + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 	return 0;
 }
 
@@ -2450,7 +2467,7 @@ static int shr_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	const struct bpf_insn *insn = &meta->insn;
 	u8 dst = insn->dst_reg * 2;
 
-	return __shr_imm(nfp_prog, dst, insn->imm);
+	return __shr_imm(nfp_prog, meta, dst, insn->imm);
 }
 
 static int shr_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
@@ -2463,22 +2480,24 @@ static int shr_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	umin = meta->umin_src;
 	umax = meta->umax_src;
 	if (umin == umax)
-		return __shr_imm(nfp_prog, dst, umin);
+		return __shr_imm(nfp_prog, meta, dst, umin);
 
 	src = insn->src_reg * 2;
 	emit_alu(nfp_prog, reg_none(), reg_a(src), ALU_OP_OR, reg_imm(0));
 	emit_shf_indir(nfp_prog, reg_both(dst), reg_none(), SHF_OP_NONE,
 		       reg_b(dst), SHF_SC_R_SHF);
-	wrp_immed(nfp_prog, reg_both(dst + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 	return 0;
 }
 
-static int __shl_imm(struct nfp_prog *nfp_prog, u8 dst, u8 shift_amt)
+static int
+__shl_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta, u8 dst,
+	  u8 shift_amt)
 {
 	if (shift_amt)
 		emit_shf(nfp_prog, reg_both(dst), reg_none(), SHF_OP_NONE,
 			 reg_b(dst), SHF_SC_L_SHF, shift_amt);
-	wrp_immed(nfp_prog, reg_both(dst + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 	return 0;
 }
 
@@ -2487,7 +2506,7 @@ static int shl_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	const struct bpf_insn *insn = &meta->insn;
 	u8 dst = insn->dst_reg * 2;
 
-	return __shl_imm(nfp_prog, dst, insn->imm);
+	return __shl_imm(nfp_prog, meta, dst, insn->imm);
 }
 
 static int shl_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
@@ -2500,11 +2519,11 @@ static int shl_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	umin = meta->umin_src;
 	umax = meta->umax_src;
 	if (umin == umax)
-		return __shl_imm(nfp_prog, dst, umin);
+		return __shl_imm(nfp_prog, meta, dst, umin);
 
 	src = insn->src_reg * 2;
 	shl_reg64_lt32_low(nfp_prog, dst, src);
-	wrp_immed(nfp_prog, reg_both(dst + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 	return 0;
 }
 
@@ -2566,34 +2585,34 @@ static int imm_ld8(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 
 static int data_ld1(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 {
-	return construct_data_ld(nfp_prog, meta->insn.imm, 1);
+	return construct_data_ld(nfp_prog, meta, meta->insn.imm, 1);
 }
 
 static int data_ld2(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 {
-	return construct_data_ld(nfp_prog, meta->insn.imm, 2);
+	return construct_data_ld(nfp_prog, meta, meta->insn.imm, 2);
 }
 
 static int data_ld4(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 {
-	return construct_data_ld(nfp_prog, meta->insn.imm, 4);
+	return construct_data_ld(nfp_prog, meta, meta->insn.imm, 4);
 }
 
 static int data_ind_ld1(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 {
-	return construct_data_ind_ld(nfp_prog, meta->insn.imm,
+	return construct_data_ind_ld(nfp_prog, meta, meta->insn.imm,
 				     meta->insn.src_reg * 2, 1);
 }
 
 static int data_ind_ld2(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 {
-	return construct_data_ind_ld(nfp_prog, meta->insn.imm,
+	return construct_data_ind_ld(nfp_prog, meta, meta->insn.imm,
 				     meta->insn.src_reg * 2, 2);
 }
 
 static int data_ind_ld4(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 {
-	return construct_data_ind_ld(nfp_prog, meta->insn.imm,
+	return construct_data_ind_ld(nfp_prog, meta, meta->insn.imm,
 				     meta->insn.src_reg * 2, 4);
 }
 
@@ -2671,7 +2690,7 @@ mem_ldx_data(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 
 	tmp_reg = re_load_imm_any(nfp_prog, meta->insn.off, imm_b(nfp_prog));
 
-	return data_ld_host_order_addr32(nfp_prog, meta->insn.src_reg * 2,
+	return data_ld_host_order_addr32(nfp_prog, meta, meta->insn.src_reg * 2,
 					 tmp_reg, meta->insn.dst_reg * 2, size);
 }
 
@@ -2683,7 +2702,7 @@ mem_ldx_emem(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 
 	tmp_reg = re_load_imm_any(nfp_prog, meta->insn.off, imm_b(nfp_prog));
 
-	return data_ld_host_order_addr40(nfp_prog, meta->insn.src_reg * 2,
+	return data_ld_host_order_addr40(nfp_prog, meta, meta->insn.src_reg * 2,
 					 tmp_reg, meta->insn.dst_reg * 2, size);
 }
 
@@ -2744,7 +2763,7 @@ mem_ldx_data_from_pktcache_unaligned(struct nfp_prog *nfp_prog,
 	wrp_reg_subpart(nfp_prog, dst_lo, src_lo, len_lo, off);
 
 	if (!len_mid) {
-		wrp_immed(nfp_prog, dst_hi, 0);
+		wrp_zext(nfp_prog, meta, dst_gpr);
 		return 0;
 	}
 
@@ -2752,7 +2771,7 @@ mem_ldx_data_from_pktcache_unaligned(struct nfp_prog *nfp_prog,
 
 	if (size <= REG_WIDTH) {
 		wrp_reg_or_subpart(nfp_prog, dst_lo, src_mid, len_mid, len_lo);
-		wrp_immed(nfp_prog, dst_hi, 0);
+		wrp_zext(nfp_prog, meta, dst_gpr);
 	} else {
 		swreg src_hi = reg_xfer(idx + 2);
 
@@ -2783,10 +2802,10 @@ mem_ldx_data_from_pktcache_aligned(struct nfp_prog *nfp_prog,
 
 	if (size < REG_WIDTH) {
 		wrp_reg_subpart(nfp_prog, dst_lo, src_lo, size, 0);
-		wrp_immed(nfp_prog, dst_hi, 0);
+		wrp_zext(nfp_prog, meta, dst_gpr);
 	} else if (size == REG_WIDTH) {
 		wrp_mov(nfp_prog, dst_lo, src_lo);
-		wrp_immed(nfp_prog, dst_hi, 0);
+		wrp_zext(nfp_prog, meta, dst_gpr);
 	} else {
 		swreg src_hi = reg_xfer(idx + 1);
 
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.h b/drivers/net/ethernet/netronome/nfp/bpf/main.h
index e54d1ac..57d6ff5 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.h
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.h
@@ -238,6 +238,8 @@ struct nfp_bpf_reg_state {
 #define FLAG_INSN_SKIP_PREC_DEPENDENT		BIT(4)
 /* Instruction is optimized by the verifier */
 #define FLAG_INSN_SKIP_VERIFIER_OPT		BIT(5)
+/* Instruction needs to zero extend to high 32-bit */
+#define FLAG_INSN_DO_ZEXT			BIT(6)
 
 #define FLAG_INSN_SKIP_MASK		(FLAG_INSN_SKIP_NOOP | \
 					 FLAG_INSN_SKIP_PREC_DEPENDENT | \
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/verifier.c b/drivers/net/ethernet/netronome/nfp/bpf/verifier.c
index 36f56eb..e92ee51 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/verifier.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/verifier.c
@@ -744,6 +744,17 @@ static unsigned int nfp_bpf_get_stack_usage(struct nfp_prog *nfp_prog)
 	goto continue_subprog;
 }
 
+static void nfp_bpf_insn_flag_zext(struct nfp_prog *nfp_prog,
+				   struct bpf_insn_aux_data *aux)
+{
+	struct nfp_insn_meta *meta;
+
+	list_for_each_entry(meta, &nfp_prog->insns, l) {
+		if (aux[meta->n].zext_dst)
+			meta->flags |= FLAG_INSN_DO_ZEXT;
+	}
+}
+
 int nfp_bpf_finalize(struct bpf_verifier_env *env)
 {
 	struct bpf_subprog_info *info;
@@ -784,6 +795,7 @@ int nfp_bpf_finalize(struct bpf_verifier_env *env)
 		return -EOPNOTSUPP;
 	}
 
+	nfp_bpf_insn_flag_zext(nfp_prog, env->insn_aux_data);
 	return 0;
 }
 
-- 
2.7.4

