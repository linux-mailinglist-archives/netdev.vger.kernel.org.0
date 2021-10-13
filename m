Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3A442B637
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 07:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhJMF6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 01:58:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229582AbhJMF6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 01:58:37 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CMf7bS022197;
        Tue, 12 Oct 2021 22:56:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=PUg1PjASSHITIi7066wcw0fzWlzO1TWpDOzU6QqgrK0=;
 b=PpsVx1R+0a1wnONVTaA/FKsgBD7sttXBfq8drMNRD30kS6ZpNbRfODRf0popk+sUt1bI
 f8Q0H1TiKWWhnCvkAqG9vYZ2/OZ1fyuUIBzMLz1W4ISx0q8gNIXGSAFPH+MKc2r66is9
 Q8GeI1JCMzUFMROkmkGw/KuvTnuwO0JhZJzDeqbbYVfkBXIX9t+cYVYpiCfiGw7Frlyz
 m6RUGnA4+8fyU16U6inXF3wqt9yJKJ3xsFP3YbKqti3Sghf3F99qEvqa2zmbhxcTYdEK
 ksEDuGKr7SLy7Z04faz0kgNNRnKK6Qk9syf3c6KcdBZLoggvYvq8cGlACzCs9+aoSI+O oQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bnkcchhnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 22:56:31 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Oct
 2021 22:56:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Oct 2021 22:56:29 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 39F1B3F7062;
        Tue, 12 Oct 2021 22:56:25 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <schalla@marvell.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 net-next 1/3] octeontx2-af: Enable CPT HW interrupts
Date:   Wed, 13 Oct 2021 11:26:19 +0530
Message-ID: <20211013055621.1812301-2-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013055621.1812301-1-schalla@marvell.com>
References: <20211013055621.1812301-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vT0cjmKD_-T82y9i7bvgtCBIncYIxO6y
X-Proofpoint-GUID: vT0cjmKD_-T82y9i7bvgtCBIncYIxO6y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_01,2021-10-13_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables and registers interrupt handler for CPT HW
interrupts.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Reported-by: kernel test robot <lkp@intel.com>

---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  13 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 230 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_struct.h         |  18 ++
 4 files changed, 264 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 0a1e9f6e216a..7698a67f6465 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -854,6 +854,7 @@ static int rvu_setup_nix_hw_resource(struct rvu *rvu, int blkaddr)
 	block->lfcfg_reg = NIX_PRIV_LFX_CFG;
 	block->msixcfg_reg = NIX_PRIV_LFX_INT_CFG;
 	block->lfreset_reg = NIX_AF_LF_RST;
+	block->rvu = rvu;
 	sprintf(block->name, "NIX%d", blkid);
 	rvu->nix_blkaddr[blkid] = blkaddr;
 	return rvu_alloc_bitmap(&block->lf);
@@ -883,6 +884,7 @@ static int rvu_setup_cpt_hw_resource(struct rvu *rvu, int blkaddr)
 	block->lfcfg_reg = CPT_PRIV_LFX_CFG;
 	block->msixcfg_reg = CPT_PRIV_LFX_INT_CFG;
 	block->lfreset_reg = CPT_AF_LF_RST;
+	block->rvu = rvu;
 	sprintf(block->name, "CPT%d", blkid);
 	return rvu_alloc_bitmap(&block->lf);
 }
@@ -940,6 +942,7 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	block->lfcfg_reg = NPA_PRIV_LFX_CFG;
 	block->msixcfg_reg = NPA_PRIV_LFX_INT_CFG;
 	block->lfreset_reg = NPA_AF_LF_RST;
+	block->rvu = rvu;
 	sprintf(block->name, "NPA");
 	err = rvu_alloc_bitmap(&block->lf);
 	if (err) {
@@ -979,6 +982,7 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	block->lfcfg_reg = SSO_PRIV_LFX_HWGRP_CFG;
 	block->msixcfg_reg = SSO_PRIV_LFX_HWGRP_INT_CFG;
 	block->lfreset_reg = SSO_AF_LF_HWGRP_RST;
+	block->rvu = rvu;
 	sprintf(block->name, "SSO GROUP");
 	err = rvu_alloc_bitmap(&block->lf);
 	if (err) {
@@ -1003,6 +1007,7 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	block->lfcfg_reg = SSOW_PRIV_LFX_HWS_CFG;
 	block->msixcfg_reg = SSOW_PRIV_LFX_HWS_INT_CFG;
 	block->lfreset_reg = SSOW_AF_LF_HWS_RST;
+	block->rvu = rvu;
 	sprintf(block->name, "SSOWS");
 	err = rvu_alloc_bitmap(&block->lf);
 	if (err) {
@@ -1028,6 +1033,7 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	block->lfcfg_reg = TIM_PRIV_LFX_CFG;
 	block->msixcfg_reg = TIM_PRIV_LFX_INT_CFG;
 	block->lfreset_reg = TIM_AF_LF_RST;
+	block->rvu = rvu;
 	sprintf(block->name, "TIM");
 	err = rvu_alloc_bitmap(&block->lf);
 	if (err) {
@@ -2724,6 +2730,8 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 {
 	int irq;
 
+	rvu_cpt_unregister_interrupts(rvu);
+
 	/* Disable the Mbox interrupt */
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFAF_MBOX_INT_ENA_W1C,
 		    INTR_MASK(rvu->hw->total_pfs) & ~1ULL);
@@ -2933,6 +2941,11 @@ static int rvu_register_interrupts(struct rvu *rvu)
 		goto fail;
 	}
 	rvu->irq_allocated[offset] = true;
+
+	ret = rvu_cpt_register_interrupts(rvu);
+	if (ret)
+		goto fail;
+
 	return 0;
 
 fail:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 58b166698fa5..cdbd2846127d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -101,6 +101,7 @@ struct rvu_block {
 	u64  msixcfg_reg;
 	u64  lfreset_reg;
 	unsigned char name[NAME_SIZE];
+	struct rvu *rvu;
 };
 
 struct nix_mcast {
@@ -812,6 +813,8 @@ bool is_mcam_entry_enabled(struct rvu *rvu, struct npc_mcam *mcam, int blkaddr,
 			   int index);
 
 /* CPT APIs */
+int rvu_cpt_register_interrupts(struct rvu *rvu);
+void rvu_cpt_unregister_interrupts(struct rvu *rvu);
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
 
 /* CN10K RVU */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 267d092b8e97..259131435edc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -37,6 +37,236 @@
 	(_rsp)->free_sts_##etype = free_sts;                        \
 })
 
+static irqreturn_t rvu_cpt_af_flt_intr_handler(int irq, void *ptr)
+{
+	struct rvu_block *block = ptr;
+	struct rvu *rvu = block->rvu;
+	int blkaddr = block->addr;
+	u64 reg0, reg1, reg2;
+
+	reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
+	reg1 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(1));
+	if (!is_rvu_otx2(rvu)) {
+		reg2 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(2));
+		dev_err_ratelimited(rvu->dev,
+				    "Received CPTAF FLT irq : 0x%llx, 0x%llx, 0x%llx",
+				     reg0, reg1, reg2);
+	} else {
+		dev_err_ratelimited(rvu->dev,
+				    "Received CPTAF FLT irq : 0x%llx, 0x%llx",
+				     reg0, reg1);
+	}
+
+	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT(0), reg0);
+	rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT(1), reg1);
+	if (!is_rvu_otx2(rvu))
+		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT(2), reg2);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_cpt_af_rvu_intr_handler(int irq, void *ptr)
+{
+	struct rvu_block *block = ptr;
+	struct rvu *rvu = block->rvu;
+	int blkaddr = block->addr;
+	u64 reg;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RVU_INT);
+	dev_err_ratelimited(rvu->dev, "Received CPTAF RVU irq : 0x%llx", reg);
+
+	rvu_write64(rvu, blkaddr, CPT_AF_RVU_INT, reg);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_cpt_af_ras_intr_handler(int irq, void *ptr)
+{
+	struct rvu_block *block = ptr;
+	struct rvu *rvu = block->rvu;
+	int blkaddr = block->addr;
+	u64 reg;
+
+	reg = rvu_read64(rvu, blkaddr, CPT_AF_RAS_INT);
+	dev_err_ratelimited(rvu->dev, "Received CPTAF RAS irq : 0x%llx", reg);
+
+	rvu_write64(rvu, blkaddr, CPT_AF_RAS_INT, reg);
+	return IRQ_HANDLED;
+}
+
+static int rvu_cpt_do_register_interrupt(struct rvu_block *block, int irq_offs,
+					 irq_handler_t handler,
+					 const char *name)
+{
+	struct rvu *rvu = block->rvu;
+	int ret;
+
+	ret = request_irq(pci_irq_vector(rvu->pdev, irq_offs), handler, 0,
+			  name, block);
+	if (ret) {
+		dev_err(rvu->dev, "RVUAF: %s irq registration failed", name);
+		return ret;
+	}
+
+	WARN_ON(rvu->irq_allocated[irq_offs]);
+	rvu->irq_allocated[irq_offs] = true;
+	return 0;
+}
+
+static void cpt_10k_unregister_interrupts(struct rvu_block *block, int off)
+{
+	struct rvu *rvu = block->rvu;
+	int blkaddr = block->addr;
+	int i;
+
+	/* Disable all CPT AF interrupts */
+	for (i = 0; i < CPT_10K_AF_INT_VEC_RVU; i++)
+		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1C(i), 0x1);
+	rvu_write64(rvu, blkaddr, CPT_AF_RVU_INT_ENA_W1C, 0x1);
+	rvu_write64(rvu, blkaddr, CPT_AF_RAS_INT_ENA_W1C, 0x1);
+
+	for (i = 0; i < CPT_10K_AF_INT_VEC_CNT; i++)
+		if (rvu->irq_allocated[off + i]) {
+			free_irq(pci_irq_vector(rvu->pdev, off + i), block);
+			rvu->irq_allocated[off + i] = false;
+		}
+}
+
+static void cpt_unregister_interrupts(struct rvu *rvu, int blkaddr)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int i, offs;
+
+	if (!is_block_implemented(rvu->hw, blkaddr))
+		return;
+	offs = rvu_read64(rvu, blkaddr, CPT_PRIV_AF_INT_CFG) & 0x7FF;
+	if (!offs) {
+		dev_warn(rvu->dev,
+			 "Failed to get CPT_AF_INT vector offsets\n");
+		return;
+	}
+	block = &hw->block[blkaddr];
+	if (!is_rvu_otx2(rvu))
+		return cpt_10k_unregister_interrupts(block, offs);
+
+	/* Disable all CPT AF interrupts */
+	for (i = 0; i < CPT_AF_INT_VEC_RVU; i++)
+		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1C(i), 0x1);
+	rvu_write64(rvu, blkaddr, CPT_AF_RVU_INT_ENA_W1C, 0x1);
+	rvu_write64(rvu, blkaddr, CPT_AF_RAS_INT_ENA_W1C, 0x1);
+
+	for (i = 0; i < CPT_AF_INT_VEC_CNT; i++)
+		if (rvu->irq_allocated[offs + i]) {
+			free_irq(pci_irq_vector(rvu->pdev, offs + i), block);
+			rvu->irq_allocated[offs + i] = false;
+		}
+}
+
+void rvu_cpt_unregister_interrupts(struct rvu *rvu)
+{
+	cpt_unregister_interrupts(rvu, BLKADDR_CPT0);
+	cpt_unregister_interrupts(rvu, BLKADDR_CPT1);
+}
+
+static int cpt_10k_register_interrupts(struct rvu_block *block, int off)
+{
+	struct rvu *rvu = block->rvu;
+	int blkaddr = block->addr;
+	char irq_name[16];
+	int i, ret;
+
+	for (i = CPT_10K_AF_INT_VEC_FLT0; i < CPT_10K_AF_INT_VEC_RVU; i++) {
+		snprintf(irq_name, sizeof(irq_name), "CPTAF FLT%d", i);
+		ret = rvu_cpt_do_register_interrupt(block, off + i,
+						    rvu_cpt_af_flt_intr_handler,
+						    irq_name);
+		if (ret)
+			goto err;
+		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1S(i), 0x1);
+	}
+
+	ret = rvu_cpt_do_register_interrupt(block, off + CPT_10K_AF_INT_VEC_RVU,
+					    rvu_cpt_af_rvu_intr_handler,
+					    "CPTAF RVU");
+	if (ret)
+		goto err;
+	rvu_write64(rvu, blkaddr, CPT_AF_RVU_INT_ENA_W1S, 0x1);
+
+	ret = rvu_cpt_do_register_interrupt(block, off + CPT_10K_AF_INT_VEC_RAS,
+					    rvu_cpt_af_ras_intr_handler,
+					    "CPTAF RAS");
+	if (ret)
+		goto err;
+	rvu_write64(rvu, blkaddr, CPT_AF_RAS_INT_ENA_W1S, 0x1);
+
+	return 0;
+err:
+	rvu_cpt_unregister_interrupts(rvu);
+	return ret;
+}
+
+static int cpt_register_interrupts(struct rvu *rvu, int blkaddr)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int i, offs, ret = 0;
+	char irq_name[16];
+
+	if (!is_block_implemented(rvu->hw, blkaddr))
+		return 0;
+
+	block = &hw->block[blkaddr];
+	offs = rvu_read64(rvu, blkaddr, CPT_PRIV_AF_INT_CFG) & 0x7FF;
+	if (!offs) {
+		dev_warn(rvu->dev,
+			 "Failed to get CPT_AF_INT vector offsets\n");
+		return 0;
+	}
+
+	if (!is_rvu_otx2(rvu))
+		return cpt_10k_register_interrupts(block, offs);
+
+	for (i = CPT_AF_INT_VEC_FLT0; i < CPT_AF_INT_VEC_RVU; i++) {
+		snprintf(irq_name, sizeof(irq_name), "CPTAF FLT%d", i);
+		ret = rvu_cpt_do_register_interrupt(block, offs + i,
+						    rvu_cpt_af_flt_intr_handler,
+						    irq_name);
+		if (ret)
+			goto err;
+		rvu_write64(rvu, blkaddr, CPT_AF_FLTX_INT_ENA_W1S(i), 0x1);
+	}
+
+	ret = rvu_cpt_do_register_interrupt(block, offs + CPT_AF_INT_VEC_RVU,
+					    rvu_cpt_af_rvu_intr_handler,
+					    "CPTAF RVU");
+	if (ret)
+		goto err;
+	rvu_write64(rvu, blkaddr, CPT_AF_RVU_INT_ENA_W1S, 0x1);
+
+	ret = rvu_cpt_do_register_interrupt(block, offs + CPT_AF_INT_VEC_RAS,
+					    rvu_cpt_af_ras_intr_handler,
+					    "CPTAF RAS");
+	if (ret)
+		goto err;
+	rvu_write64(rvu, blkaddr, CPT_AF_RAS_INT_ENA_W1S, 0x1);
+
+	return 0;
+err:
+	rvu_cpt_unregister_interrupts(rvu);
+	return ret;
+}
+
+int rvu_cpt_register_interrupts(struct rvu *rvu)
+{
+	int ret;
+
+	ret = cpt_register_interrupts(rvu, BLKADDR_CPT0);
+	if (ret)
+		return ret;
+
+	return cpt_register_interrupts(rvu, BLKADDR_CPT1);
+}
+
 static int get_cpt_pf_num(struct rvu *rvu)
 {
 	int i, domain_nr, cpt_pf_num = -1;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 77ac96693f04..edc9367b1b95 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -62,6 +62,24 @@ enum rvu_af_int_vec_e {
 	RVU_AF_INT_VEC_CNT    = 0x5,
 };
 
+/* CPT Admin function Interrupt Vector Enumeration */
+enum cpt_af_int_vec_e {
+	CPT_AF_INT_VEC_FLT0	= 0x0,
+	CPT_AF_INT_VEC_FLT1	= 0x1,
+	CPT_AF_INT_VEC_RVU	= 0x2,
+	CPT_AF_INT_VEC_RAS	= 0x3,
+	CPT_AF_INT_VEC_CNT	= 0x4,
+};
+
+enum cpt_10k_af_int_vec_e {
+	CPT_10K_AF_INT_VEC_FLT0	= 0x0,
+	CPT_10K_AF_INT_VEC_FLT1	= 0x1,
+	CPT_10K_AF_INT_VEC_FLT2	= 0x2,
+	CPT_10K_AF_INT_VEC_RVU	= 0x3,
+	CPT_10K_AF_INT_VEC_RAS	= 0x4,
+	CPT_10K_AF_INT_VEC_CNT	= 0x5,
+};
+
 /* NPA Admin function Interrupt Vector Enumeration */
 enum npa_af_int_vec_e {
 	NPA_AF_INT_VEC_RVU	= 0x0,
-- 
2.25.1

