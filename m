Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC5526A44
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbfEVS4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:56:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38259 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbfEVS4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:56:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so3480609wrs.5
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P5M/sOCzka2qT+p4DDAjrnnn2G6z55p/ok/4haADAMQ=;
        b=gaNUG1uwtbvPobVRRWgOlPAFobYj6VzGJQs+RLTUsJKKLvXwKcydEzeJWuBbfYXkWp
         EyAKl+fB6RugluFPETCrJYH8CPXMSUL3vXpLFXjSwLVuv9UF35tZUOOczkqAH2K365eb
         RkygOBmzmtNVmL/sAN8dqKiyITjk5g0ie3TFZwyNF4omIDJSPoelADjY5Tx7F3iKbnLB
         ONd57cPoDEQIFAAuxsK7rny+GXESx7DWPI8lalORoM29ItIUFA2e7bYti9IWc4PnazzJ
         C9vr0PlIMSTVk7RU/ZK0yxSclDfeSNsJqLAn8g/Y8VnPXJCB+SQTr5k/w5GKi+IJ5br8
         CZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P5M/sOCzka2qT+p4DDAjrnnn2G6z55p/ok/4haADAMQ=;
        b=Q2nXDrU7L8em8e0K3LzCwAbFZGUCED4YPyMwwf8MxQ5iY9nwuoPXHOWBsM+aI8gxnj
         PIGQYz7ys0/xoc0Z1SX7d4/kClspbOAfO9lkVeBZD8SlN82ASWbY4BVeXbDc6v1Skjwa
         3poPLjiUkrQ5cH0sVbf/KTR3+GBOqhpFQk4t1uUCmWncrWtDpG77cJKy1AB3THglLOKr
         m9luFroPMOLgGM4N3BbIFh/wc94yh1AikmglBRowrhviLP93mniY5C0oEEitkU5vxbey
         NFSTIQ6IpId+weYnMmQG9jxn6odDLSOQ7eeciZWEpVTddWoL8DyvPE8oit6fihmMdM5v
         /q9Q==
X-Gm-Message-State: APjAAAUts8HBjtUM5XxLVxCC/LwFpdj8EBeo6CNy6rHdSDPFncw+sv3j
        /Tn+99zxxy7AUVmECsPtgjasUQ==
X-Google-Smtp-Source: APXvYqydkqWWbfq5UvfMurrIgg5fvMJYiu4JrQ6eEGDH9L3tDKczRFK1zOBFPzhpY9RzJ9i14NNXOA==
X-Received: by 2002:adf:dc8e:: with SMTP id r14mr40630016wrj.121.1558551366756;
        Wed, 22 May 2019 11:56:06 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t12sm16328801wro.2.2019.05.22.11.56.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 11:56:06 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v7 bpf-next 16/16] nfp: bpf: eliminate zero extension code-gen
Date:   Wed, 22 May 2019 19:55:12 +0100
Message-Id: <1558551312-17081-17-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch eliminate zero extension code-gen for instructions including
both alu and load/store. The only exception is for ctx load, because
offload target doesn't go through host ctx convert logic so we do
customized load and ignores zext flag set by verifier.

Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/bpf/jit.c      | 115 +++++++++++++---------
 drivers/net/ethernet/netronome/nfp/bpf/main.h     |   2 +
 drivers/net/ethernet/netronome/nfp/bpf/verifier.c |  12 +++
 3 files changed, 81 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/jit.c b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
index d4bf0e6..4054b70 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/jit.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/jit.c
@@ -623,6 +623,13 @@ static void wrp_immed(struct nfp_prog *nfp_prog, swreg dst, u32 imm)
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
@@ -858,7 +865,8 @@ static int nfp_cpp_memcpy(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 }
 
 static int
-data_ld(struct nfp_prog *nfp_prog, swreg offset, u8 dst_gpr, int size)
+data_ld(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta, swreg offset,
+	u8 dst_gpr, int size)
 {
 	unsigned int i;
 	u16 shift, sz;
@@ -881,14 +889,15 @@ data_ld(struct nfp_prog *nfp_prog, swreg offset, u8 dst_gpr, int size)
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
@@ -911,33 +920,34 @@ data_ld_host_order(struct nfp_prog *nfp_prog, u8 dst_gpr,
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
 
@@ -953,10 +963,12 @@ construct_data_ind_ld(struct nfp_prog *nfp_prog, u16 offset, u16 src, u8 size)
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
 
@@ -967,7 +979,7 @@ static int construct_data_ld(struct nfp_prog *nfp_prog, u16 offset, u8 size)
 
 	/* Load data */
 	tmp_reg = re_load_imm_any(nfp_prog, offset, imm_b(nfp_prog));
-	return data_ld(nfp_prog, tmp_reg, 0, size);
+	return data_ld(nfp_prog, meta, tmp_reg, 0, size);
 }
 
 static int
@@ -1204,7 +1216,7 @@ mem_op_stack(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 	}
 
 	if (clr_gpr && size < 8)
-		wrp_immed(nfp_prog, reg_both(gpr + 1), 0);
+		wrp_zext(nfp_prog, meta, gpr);
 
 	while (size) {
 		u32 slice_end;
@@ -1305,9 +1317,10 @@ wrp_alu32_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
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
@@ -1319,7 +1332,7 @@ wrp_alu32_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 	u8 dst = meta->insn.dst_reg * 2, src = meta->insn.src_reg * 2;
 
 	emit_alu(nfp_prog, reg_both(dst), reg_a(dst), alu_op, reg_b(src));
-	wrp_immed(nfp_prog, reg_both(meta->insn.dst_reg * 2 + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 
 	return 0;
 }
@@ -2396,12 +2409,14 @@ static int neg_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
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
@@ -2410,7 +2425,7 @@ static int __ashr_imm(struct nfp_prog *nfp_prog, u8 dst, u8 shift_amt)
 		emit_shf(nfp_prog, reg_both(dst), reg_none(), SHF_OP_ASHR,
 			 reg_b(dst), SHF_SC_R_SHF, shift_amt);
 	}
-	wrp_immed(nfp_prog, reg_both(dst + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 
 	return 0;
 }
@@ -2425,7 +2440,7 @@ static int ashr_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	umin = meta->umin_src;
 	umax = meta->umax_src;
 	if (umin == umax)
-		return __ashr_imm(nfp_prog, dst, umin);
+		return __ashr_imm(nfp_prog, meta, dst, umin);
 
 	src = insn->src_reg * 2;
 	/* NOTE: the first insn will set both indirect shift amount (source A)
@@ -2434,7 +2449,7 @@ static int ashr_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	emit_alu(nfp_prog, reg_none(), reg_a(src), ALU_OP_OR, reg_b(dst));
 	emit_shf_indir(nfp_prog, reg_both(dst), reg_none(), SHF_OP_ASHR,
 		       reg_b(dst), SHF_SC_R_SHF);
-	wrp_immed(nfp_prog, reg_both(dst + 1), 0);
+	wrp_zext(nfp_prog, meta, dst);
 
 	return 0;
 }
@@ -2444,15 +2459,17 @@ static int ashr_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
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
 
@@ -2461,7 +2478,7 @@ static int shr_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	const struct bpf_insn *insn = &meta->insn;
 	u8 dst = insn->dst_reg * 2;
 
-	return __shr_imm(nfp_prog, dst, insn->imm);
+	return __shr_imm(nfp_prog, meta, dst, insn->imm);
 }
 
 static int shr_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
@@ -2474,22 +2491,24 @@ static int shr_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
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
 
@@ -2498,7 +2517,7 @@ static int shl_imm(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 	const struct bpf_insn *insn = &meta->insn;
 	u8 dst = insn->dst_reg * 2;
 
-	return __shl_imm(nfp_prog, dst, insn->imm);
+	return __shl_imm(nfp_prog, meta, dst, insn->imm);
 }
 
 static int shl_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
@@ -2511,11 +2530,11 @@ static int shl_reg(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
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
 
@@ -2577,34 +2596,34 @@ static int imm_ld8(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta)
 
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
 
@@ -2682,7 +2701,7 @@ mem_ldx_data(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 
 	tmp_reg = re_load_imm_any(nfp_prog, meta->insn.off, imm_b(nfp_prog));
 
-	return data_ld_host_order_addr32(nfp_prog, meta->insn.src_reg * 2,
+	return data_ld_host_order_addr32(nfp_prog, meta, meta->insn.src_reg * 2,
 					 tmp_reg, meta->insn.dst_reg * 2, size);
 }
 
@@ -2694,7 +2713,7 @@ mem_ldx_emem(struct nfp_prog *nfp_prog, struct nfp_insn_meta *meta,
 
 	tmp_reg = re_load_imm_any(nfp_prog, meta->insn.off, imm_b(nfp_prog));
 
-	return data_ld_host_order_addr40(nfp_prog, meta->insn.src_reg * 2,
+	return data_ld_host_order_addr40(nfp_prog, meta, meta->insn.src_reg * 2,
 					 tmp_reg, meta->insn.dst_reg * 2, size);
 }
 
@@ -2755,7 +2774,7 @@ mem_ldx_data_from_pktcache_unaligned(struct nfp_prog *nfp_prog,
 	wrp_reg_subpart(nfp_prog, dst_lo, src_lo, len_lo, off);
 
 	if (!len_mid) {
-		wrp_immed(nfp_prog, dst_hi, 0);
+		wrp_zext(nfp_prog, meta, dst_gpr);
 		return 0;
 	}
 
@@ -2763,7 +2782,7 @@ mem_ldx_data_from_pktcache_unaligned(struct nfp_prog *nfp_prog,
 
 	if (size <= REG_WIDTH) {
 		wrp_reg_or_subpart(nfp_prog, dst_lo, src_mid, len_mid, len_lo);
-		wrp_immed(nfp_prog, dst_hi, 0);
+		wrp_zext(nfp_prog, meta, dst_gpr);
 	} else {
 		swreg src_hi = reg_xfer(idx + 2);
 
@@ -2794,10 +2813,10 @@ mem_ldx_data_from_pktcache_aligned(struct nfp_prog *nfp_prog,
 
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

