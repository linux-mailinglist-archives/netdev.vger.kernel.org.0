Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E816799FC
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbjAXNni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbjAXNnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:43:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106203A99;
        Tue, 24 Jan 2023 05:42:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 284A7B811D9;
        Tue, 24 Jan 2023 13:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5517EC4339E;
        Tue, 24 Jan 2023 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567759;
        bh=qCPpmKOLEPwL9PEFtlnY+g2C7kgMxd/MkU/X/+seVao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyiIpKbILgUFjWnwC08zyZim+qobCUZyEosXSZg/rbGald1zZDKO0jVkvN4Y7RGHy
         1FbAUUUBJTjtIacmhfmYUn2OuNtEnyMlx2qsuvNTZwNN1ZDf/zNFaiRoPnYmje2kmU
         MSZ0+Y3DGOS6v1H10Vat/Jxio2LHDcLmKcPrCWCq6sN7TJpmbLDHfrwyj0TbCu33eo
         OXh6oix4j8ntw0yUGeupM+Q/Q79qBg1BPDGz0NaasMJONCwp4YJWolASA4yhxDJLcq
         IFxzzlK7tJ65deCedhaFZF40wVwSlYn5iiWycRCh+unEf4PYT/C94IzyJ8WWSFL+IN
         eEvBsHtyjoWXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srujana Challa <schalla@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 27/35] octeontx2-af: recover CPT engine when it gets fault
Date:   Tue, 24 Jan 2023 08:41:23 -0500
Message-Id: <20230124134131.637036-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit 07ea567d84cdf0add274d66db7c02b55b818d517 ]

When CPT engine has uncorrectable errors, it will get halted and
must be disabled and re-enabled. This patch adds code for the same.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 110 +++++++++++++-----
 1 file changed, 80 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 38bbae5d9ae0..1ed16ce515bb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -37,34 +37,60 @@
 	(_rsp)->free_sts_##etype = free_sts;                        \
 })
 
-static irqreturn_t rvu_cpt_af_flt_intr_handler(int irq, void *ptr)
+static irqreturn_t cpt_af_flt_intr_handler(int vec, void *ptr)
 {
 	struct rvu_block *block = ptr;
 	struct rvu *rvu = block->rvu;
 	int blkaddr = block->addr;
-	u64 reg0, reg1, reg2;
-
-	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
-	reg1 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(1));
-	if (!is_rvu_otx2(rvu)) {
-		reg2 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(2));
-		dev_err_ratelimited(rvu->dev,
-				    "Received CPTAF FLT irq : 0x%llx, 0x%llx, 0x%llx",
-				     reg0, reg1, reg2);
-	} else {
-		dev_err_ratelimited(rvu->dev,
-				    "Received CPTAF FLT irq : 0x%llx, 0x%llx",
-				     reg0, reg1);
+	u64 reg, val;
+	int i, eng;
+	u8 grp;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(vec));
+	dev_err_ratelimited(rvu->dev, "Received CPTAF FLT%d irq : 0x%llx", vec, reg);
+
+	i = -1;
+	while ((i = find_next_bit((unsigned long *)&reg, 64, i + 1)) < 64) {
+		switch (vec) {
+		case 0:
+			eng = i;
+			break;
+		case 1:
+			eng = i + 64;
+			break;
+		case 2:
+			eng = i + 128;
+			break;
+		}
+		grp = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL2(eng)) & 0xFF;
+		/* Disable and enable the engine which triggers fault */
+		rvu_write64(rvu, blkaddr, CPT_AF_EXEX_CTL2(eng), 0x0);
+		val = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL(eng));
+		rvu_write64(rvu, blkaddr, CPT_AF_EXEX_CTL(eng), val & ~1ULL);
+
+		rvu_write64(rvu, blkaddr, CPT_AF_EXEX_CTL2(eng), grp);
+		rvu_write64(rvu, blkaddr, CPT_AF_EXEX_CTL(eng), val | 1ULL);
 	}
-
-	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT(0), reg0);
-	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT(1), reg1);
-	if (!is_rvu_otx2(rvu))
-		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT(2), reg2);
+	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT(vec), reg);
 
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t rvu_cpt_af_flt0_intr_handler(int irq, void *ptr)
+{
+	return cpt_af_flt_intr_handler(CPT_AF_INT_VEC_FLT0, ptr);
+}
+
+static irqreturn_t rvu_cpt_af_flt1_intr_handler(int irq, void *ptr)
+{
+	return cpt_af_flt_intr_handler(CPT_AF_INT_VEC_FLT1, ptr);
+}
+
+static irqreturn_t rvu_cpt_af_flt2_intr_handler(int irq, void *ptr)
+{
+	return cpt_af_flt_intr_handler(CPT_10K_AF_INT_VEC_FLT2, ptr);
+}
+
 static irqreturn_t rvu_cpt_af_rvu_intr_handler(int irq, void *ptr)
 {
 	struct rvu_block *block = ptr;
@@ -119,8 +145,10 @@ static void cpt_10k_unregister_interrupts(struct rvu_block *block, int off)
 	int i;
 
 	/* Disable all CPT AF interrupts */
-	for (i = 0; i < CPT_10K_AF_INT_VEC_RVU; i++)
-		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1C(i), 0x1);
+	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1C(0), ~0ULL);
+	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1C(1), ~0ULL);
+	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1C(2), 0xFFFF);
+
 	rvu_write64(rvu, blkaddr, CPT_AF_RVU_INT_ENA_W1C, 0x1);
 	rvu_write64(rvu, blkaddr, CPT_AF_RAS_INT_ENA_W1C, 0x1);
 
@@ -151,7 +179,7 @@ static void cpt_unregister_interrupts(struct rvu *rvu, int blkaddr)
 
 	/* Disable all CPT AF interrupts */
 	for (i = 0; i < CPT_AF_INT_VEC_RVU; i++)
-		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1C(i), 0x1);
+		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1C(i), ~0ULL);
 	rvu_write64(rvu, blkaddr, CPT_AF_RVU_INT_ENA_W1C, 0x1);
 	rvu_write64(rvu, blkaddr, CPT_AF_RAS_INT_ENA_W1C, 0x1);
 
@@ -172,16 +200,31 @@ static int cpt_10k_register_interrupts(struct rvu_block *block, int off)
 {
 	struct rvu *rvu = block->rvu;
 	int blkaddr = block->addr;
+	irq_handler_t flt_fn;
 	int i, ret;
 
 	for (i = CPT_10K_AF_INT_VEC_FLT0; i < CPT_10K_AF_INT_VEC_RVU; i++) {
 		sprintf(&rvu->irq_name[(off + i) * NAME_SIZE], "CPTAF FLT%d", i);
+
+		switch (i) {
+		case CPT_10K_AF_INT_VEC_FLT0:
+			flt_fn = rvu_cpt_af_flt0_intr_handler;
+			break;
+		case CPT_10K_AF_INT_VEC_FLT1:
+			flt_fn = rvu_cpt_af_flt1_intr_handler;
+			break;
+		case CPT_10K_AF_INT_VEC_FLT2:
+			flt_fn = rvu_cpt_af_flt2_intr_handler;
+			break;
+		}
 		ret = rvu_cpt_do_register_interrupt(block, off + i,
-						    rvu_cpt_af_flt_intr_handler,
-						    &rvu->irq_name[(off + i) * NAME_SIZE]);
+						    flt_fn, &rvu->irq_name[(off + i) * NAME_SIZE]);
 		if (ret)
 			goto err;
-		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1S(i), 0x1);
+		if (i == CPT_10K_AF_INT_VEC_FLT2)
+			rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1S(i), 0xFFFF);
+		else
+			rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1S(i), ~0ULL);
 	}
 
 	ret = rvu_cpt_do_register_interrupt(block, off + CPT_10K_AF_INT_VEC_RVU,
@@ -208,8 +251,8 @@ static int cpt_register_interrupts(struct rvu *rvu, int blkaddr)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	struct rvu_block *block;
+	irq_handler_t flt_fn;
 	int i, offs, ret = 0;
-	char irq_name[16];
 
 	if (!is_block_implemented(rvu->hw, blkaddr))
 		return 0;
@@ -226,13 +269,20 @@ static int cpt_register_interrupts(struct rvu *rvu, int blkaddr)
 		return cpt_10k_register_interrupts(block, offs);
 
 	for (i = CPT_AF_INT_VEC_FLT0; i < CPT_AF_INT_VEC_RVU; i++) {
-		snprintf(irq_name, sizeof(irq_name), "CPTAF FLT%d", i);
+		sprintf(&rvu->irq_name[(offs + i) * NAME_SIZE], "CPTAF FLT%d", i);
+		switch (i) {
+		case CPT_AF_INT_VEC_FLT0:
+			flt_fn = rvu_cpt_af_flt0_intr_handler;
+			break;
+		case CPT_AF_INT_VEC_FLT1:
+			flt_fn = rvu_cpt_af_flt1_intr_handler;
+			break;
+		}
 		ret = rvu_cpt_do_register_interrupt(block, offs + i,
-						    rvu_cpt_af_flt_intr_handler,
-						    irq_name);
+						    flt_fn, &rvu->irq_name[(offs + i) * NAME_SIZE]);
 		if (ret)
 			goto err;
-		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1S(i), 0x1);
+		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1S(i), ~0ULL);
 	}
 
 	ret = rvu_cpt_do_register_interrupt(block, offs + CPT_AF_INT_VEC_RVU,
-- 
2.39.0

