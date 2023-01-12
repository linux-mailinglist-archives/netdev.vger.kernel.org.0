Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00299666A7A
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 05:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbjALEm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 23:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236414AbjALEmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 23:42:25 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24BB4E42F
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:42:02 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C3vuvJ001311;
        Wed, 11 Jan 2023 20:41:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=p0D23KBpv4fRKp5Iy9t0AC2RwN2ZFq6GmggyczF6ZiE=;
 b=Gxejh1WLTvK1iQ1COwyOx8krrYMaXRmi2gY1itRJesZ72+Vz3LfmBBa2F5T4ho4XmOPj
 Mea8q9Pk1C+U8shFiYu6vteMv8AF8/hFKxBU1gKPMiGzrCvKUVSzElhUNdpbyUJGJmt4
 jeJT0F2npBJliAbIVnXWnRil+/EejBwLavDYbLu6Qy2mnaxWaiLR5udu3gL2htqxaJk0
 ram84p0wFPIjPzN7sguxSMsUD7Xi+Hu/KmTgMzXA8XdiNm1zqu1EXaZMiAi0b23MS27c
 wAot25aWXCDt5aTtsaQR1vyXXmvDBdBpuHrrZpJNMPoaCwAU3He0iRZ3O8+SM4tX3H5X nw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3n23b2gscs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 20:41:57 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 11 Jan
 2023 20:41:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 11 Jan 2023 20:41:55 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 0A51F3F7051;
        Wed, 11 Jan 2023 20:41:51 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v2 net-next,1/8] octeontx2-af: recover CPT engine when it gets fault
Date:   Thu, 12 Jan 2023 10:11:40 +0530
Message-ID: <20230112044147.931159-2-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112044147.931159-1-schalla@marvell.com>
References: <20230112044147.931159-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: XSB9YCCznZMCMW1h6koFkxNaYIJbzNcd
X-Proofpoint-ORIG-GUID: XSB9YCCznZMCMW1h6koFkxNaYIJbzNcd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_02,2023-01-11_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CPT engine has uncorrectable errors, it will get halted and
must be disabled and re-enabled. This patch adds code for the same.

Signed-off-by: Srujana Challa <schalla@marvell.com>
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
2.25.1

