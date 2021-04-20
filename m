Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7A83657CE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhDTLpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:45:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49420 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230491AbhDTLpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 07:45:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KBb7XT017533;
        Tue, 20 Apr 2021 04:44:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=PxTeWFaKBX71lVh7yTpaGoVVZxXLKb/Nr5EyNASRwMc=;
 b=VkfIBJFBhqT6cEC5DyZ77cmAAhhgObAVm+7LBqlWddUOLNLmHHLzmFPWrPOksj9NLm3X
 56QTZ753z7KmGCTbvmaEPahMvIf+fpHLR9DReExrK1np/oTOb5+FMDjb6p2FfQpvI+RK
 AO4RuI6wJOp7UJ273gmPFosGj0VguBdBAjdTUl9wc48ilZEW2kvkq5J4Xi9MN1qmhmzb
 C6rkjP6Nbs67bE8mqwIiCfqs9z9NFbzEslTfomP/8cFzRyqVMD4xXXIw0LqT0KJ64zw+
 klMCeWZiH73RUpKtCAOQ+1Dt3n6gyB2P8pSN5Gvp23QsvJdOwXlI0o9nnLYANUNRe2JE aQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3818tvum2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 04:44:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 04:44:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Apr 2021 04:44:25 -0700
Received: from hyd1schalla-dt.caveonetworks.com.com (unknown [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 47B363F703F;
        Tue, 20 Apr 2021 04:44:22 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <pathreya@marvell.com>, "Srujana Challa" <schalla@marvell.com>
Subject: [PATCH 2/3] octeontx2-af: cn10k: Add mailbox to configure reassembly timeout
Date:   Tue, 20 Apr 2021 17:13:48 +0530
Message-ID: <20210420114349.22640-3-schalla@marvell.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210420114349.22640-1-schalla@marvell.com>
References: <20210420114349.22640-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: duAImxhwHh1bagDVDMYb4GXx1SA_FlK_
X-Proofpoint-ORIG-GUID: duAImxhwHh1bagDVDMYb4GXx1SA_FlK_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_02:2021-04-19,2021-04-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CN10K CPT coprocessor includes a component named RXC which
is responsible for reassembly of inner IP packets. RXC has
the feature to evict oldest entries based on age/threshold.
This patch adds a new mailbox to configure reassembly age
or threshold.

Signed-off-by: Jerin Jacob Kollanukkaran <jerinj@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  | 13 ++++
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 68 +++++++++++++++++--
 2 files changed, 74 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 55629c66586e..84e4178e8a13 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -177,6 +177,8 @@ M(CPT_LF_ALLOC,		0xA00, cpt_lf_alloc, cpt_lf_alloc_req_msg,	\
 M(CPT_LF_FREE,		0xA01, cpt_lf_free, msg_req, msg_rsp)		\
 M(CPT_RD_WR_REGISTER,	0xA02, cpt_rd_wr_register,  cpt_rd_wr_reg_msg,	\
 			       cpt_rd_wr_reg_msg)			\
+M(CPT_RXC_TIME_CFG,     0xA06, cpt_rxc_time_cfg, cpt_rxc_time_cfg_req,  \
+			       msg_rsp)                                 \
 /* NPC mbox IDs (range 0x6000 - 0x7FFF) */				\
 M(NPC_MCAM_ALLOC_ENTRY,	0x6000, npc_mcam_alloc_entry, npc_mcam_alloc_entry_req,\
 				npc_mcam_alloc_entry_rsp)		\
@@ -1255,4 +1257,15 @@ struct cpt_lf_alloc_req_msg {
 	int blkaddr;
 };
 
+/* Mailbox message request format to configure reassembly timeout. */
+struct cpt_rxc_time_cfg_req {
+	struct mbox_msghdr hdr;
+	int blkaddr;
+	u32 step;
+	u16 zombie_thres;
+	u16 zombie_limit;
+	u16 active_thres;
+	u16 active_limit;
+};
+
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 42c474957b69..77bfa81a324c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -60,6 +60,17 @@ static bool is_cpt_vf(struct rvu *rvu, u16 pcifunc)
 	return true;
 }
 
+static int validate_and_get_cpt_blkaddr(int req_blkaddr)
+{
+	int blkaddr;
+
+	blkaddr = req_blkaddr ? req_blkaddr : BLKADDR_CPT0;
+	if (blkaddr != BLKADDR_CPT0 && blkaddr != BLKADDR_CPT1)
+		return -EINVAL;
+
+	return blkaddr;
+}
+
 int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
 				  struct cpt_lf_alloc_req_msg *req,
 				  struct msg_rsp *rsp)
@@ -70,9 +81,9 @@ int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
 	int num_lfs, slot;
 	u64 val;
 
-	blkaddr = req->blkaddr ? req->blkaddr : BLKADDR_CPT0;
-	if (blkaddr != BLKADDR_CPT0 && blkaddr != BLKADDR_CPT1)
-		return -ENODEV;
+	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
+	if (blkaddr < 0)
+		return blkaddr;
 
 	if (req->eng_grpmsk == 0x0)
 		return CPT_AF_ERR_GRP_INVALID;
@@ -170,7 +181,9 @@ static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
 	struct rvu_block *block;
 	struct rvu_pfvf *pfvf;
 
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
+	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
+	if (blkaddr < 0)
+		return blkaddr;
 
 	/* Registers that can be accessed from PF/VF */
 	if ((offset & 0xFF000) ==  CPT_AF_LFX_CTL(0) ||
@@ -226,9 +239,9 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 {
 	int blkaddr;
 
-	blkaddr = req->blkaddr ? req->blkaddr : BLKADDR_CPT0;
-	if (blkaddr != BLKADDR_CPT0 && blkaddr != BLKADDR_CPT1)
-		return -ENODEV;
+	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
+	if (blkaddr < 0)
+		return blkaddr;
 
 	/* This message is accepted only if sent from CPT PF/VF */
 	if (!is_cpt_pf(rvu, req->hdr.pcifunc) &&
@@ -250,6 +263,47 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 	return 0;
 }
 
+#define RXC_ZOMBIE_THRES  GENMASK_ULL(59, 48)
+#define RXC_ZOMBIE_LIMIT  GENMASK_ULL(43, 32)
+#define RXC_ACTIVE_THRES  GENMASK_ULL(27, 16)
+#define RXC_ACTIVE_LIMIT  GENMASK_ULL(11, 0)
+#define RXC_ACTIVE_COUNT  GENMASK_ULL(60, 48)
+#define RXC_ZOMBIE_COUNT  GENMASK_ULL(60, 48)
+
+static void cpt_rxc_time_cfg(struct rvu *rvu, struct cpt_rxc_time_cfg_req *req,
+			     int blkaddr)
+{
+	u64 dfrg_reg;
+
+	dfrg_reg = FIELD_PREP(RXC_ZOMBIE_THRES, req->zombie_thres);
+	dfrg_reg |= FIELD_PREP(RXC_ZOMBIE_LIMIT, req->zombie_limit);
+	dfrg_reg |= FIELD_PREP(RXC_ACTIVE_THRES, req->active_thres);
+	dfrg_reg |= FIELD_PREP(RXC_ACTIVE_LIMIT, req->active_limit);
+
+	rvu_write64(rvu, blkaddr, CPT_AF_RXC_TIME_CFG, req->step);
+	rvu_write64(rvu, blkaddr, CPT_AF_RXC_DFRG, dfrg_reg);
+}
+
+int rvu_mbox_handler_cpt_rxc_time_cfg(struct rvu *rvu,
+				      struct cpt_rxc_time_cfg_req *req,
+				      struct msg_rsp *rsp)
+{
+	int blkaddr;
+
+	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	/* This message is accepted only if sent from CPT PF/VF */
+	if (!is_cpt_pf(rvu, req->hdr.pcifunc) &&
+	    !is_cpt_vf(rvu, req->hdr.pcifunc))
+		return CPT_AF_ERR_ACCESS_DENIED;
+
+	cpt_rxc_time_cfg(rvu, req, blkaddr);
+
+	return 0;
+}
+
 #define INPROG_INFLIGHT(reg)    ((reg) & 0x1FF)
 #define INPROG_GRB_PARTIAL(reg) ((reg) & BIT_ULL(31))
 #define INPROG_GRB(reg)         (((reg) >> 32) & 0xFF)
-- 
2.29.0

