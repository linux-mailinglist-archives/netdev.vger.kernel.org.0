Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFE93F74FA
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240972AbhHYMUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:20:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28946 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240855AbhHYMTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:19:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17P6f2AQ015535;
        Wed, 25 Aug 2021 05:19:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=L9BPEJlPgZR3G1udvu+dDqZjLUBiegi6vQKxmfjmW/E=;
 b=E7tg8xRIQUHH+tMGg+N3meF4vMHO/aj09hOSz0aDzPm5c4DWQxQn9aiZ7A7qfjVYuUtW
 0jV5y4D06iyPtJmfp3alLJjh0NO490Rzn7NtLEFoBIOPKOSiR2Snp0B+jleU1vp9eojA
 gcjd5rSRhVOyIBGKIDgdWglxYKsiywIUFa5eUmO21HhvewKGxYYvcJ/htEN7hAbFvpiB
 7M9JrNlD3+wRYMktdOKtiLwkcFxFw0Hja9Xausu+ysvKDuQW4/irMw4+6UaI9IdsK/BW
 ZIhosvuPB3Rs2FrSzVZExO+9gsjU5xOjwvORKvXMm1uBf6aSHFDIzcNagbBCkzDU08n0 Ow== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3angt017qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 05:19:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 25 Aug
 2021 05:19:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 25 Aug 2021 05:19:07 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 7A2423F7067;
        Wed, 25 Aug 2021 05:19:05 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     George Cherian <george.cherian@marvell.com>,
        Stanislaw Kardach <skardach@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 6/9] octeontx2-af: Add free rsrc count mbox msg
Date:   Wed, 25 Aug 2021 17:48:43 +0530
Message-ID: <1629893926-18398-7-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
References: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ot0_NXhqjxv9iDrYGhRtVW7z8rQYaIis
X-Proofpoint-GUID: ot0_NXhqjxv9iDrYGhRtVW7z8rQYaIis
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_05,2021-08-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George Cherian <george.cherian@marvell.com>

Upon receiving the MBOX_MSG_FREE_RSRC_CNT, the AF will find out the
current number of free resources and reply it back to the requester. No
guarantee is given on the future state of the free resources yet.
If another requester sends MBOX_MSG_ATTACH_RESOURCES after this call,
the number of available resources might change.

Signed-off-by: George Cherian <george.cherian@marvell.com>
Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 20 +++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c  | 93 ++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 7fbd1e2..bc9cd1d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -130,6 +130,7 @@ static inline struct mbox_msghdr *otx2_mbox_alloc_msg(struct otx2_mbox *mbox,
 M(READY,		0x001, ready, msg_req, ready_msg_rsp)		\
 M(ATTACH_RESOURCES,	0x002, attach_resources, rsrc_attach, msg_rsp)	\
 M(DETACH_RESOURCES,	0x003, detach_resources, rsrc_detach, msg_rsp)	\
+M(FREE_RSRC_CNT,	0x004, free_rsrc_cnt, msg_req, free_rsrcs_rsp)	\
 M(MSIX_OFFSET,		0x005, msix_offset, msg_req, msix_offset_rsp)	\
 M(VF_FLR,		0x006, vf_flr, msg_req, msg_rsp)		\
 M(PTP_OP,		0x007, ptp_op, ptp_req, ptp_rsp)		\
@@ -367,6 +368,25 @@ struct rsrc_detach {
 	u8 cptlfs:1;
 };
 
+/* Number of resources available to the caller.
+ * In reply to MBOX_MSG_FREE_RSRC_CNT.
+ */
+struct free_rsrcs_rsp {
+	struct mbox_msghdr hdr;
+	u16 schq[NIX_TXSCH_LVL_CNT];
+	u16  sso;
+	u16  tim;
+	u16  ssow;
+	u16  cpt;
+	u8   npa;
+	u8   nix;
+	u16  schq_nix1[NIX_TXSCH_LVL_CNT];
+	u8   nix1;
+	u8   cpt1;
+	u8   ree0;
+	u8   ree1;
+};
+
 #define MSIX_VECTOR_INVALID	0xFFFF
 #define MAX_RVU_BLKLF_CNT	256
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 6801cd3..8e3ed57 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1796,6 +1796,99 @@ int rvu_mbox_handler_msix_offset(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+int rvu_mbox_handler_free_rsrc_cnt(struct rvu *rvu, struct msg_req *req,
+				   struct free_rsrcs_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	struct nix_txsch *txsch;
+	struct nix_hw *nix_hw;
+
+	mutex_lock(&rvu->rsrc_lock);
+
+	block = &hw->block[BLKADDR_NPA];
+	rsp->npa = rvu_rsrc_free_count(&block->lf);
+
+	block = &hw->block[BLKADDR_NIX0];
+	rsp->nix = rvu_rsrc_free_count(&block->lf);
+
+	block = &hw->block[BLKADDR_NIX1];
+	rsp->nix1 = rvu_rsrc_free_count(&block->lf);
+
+	block = &hw->block[BLKADDR_SSO];
+	rsp->sso = rvu_rsrc_free_count(&block->lf);
+
+	block = &hw->block[BLKADDR_SSOW];
+	rsp->ssow = rvu_rsrc_free_count(&block->lf);
+
+	block = &hw->block[BLKADDR_TIM];
+	rsp->tim = rvu_rsrc_free_count(&block->lf);
+
+	block = &hw->block[BLKADDR_CPT0];
+	rsp->cpt = rvu_rsrc_free_count(&block->lf);
+
+	block = &hw->block[BLKADDR_CPT1];
+	rsp->cpt1 = rvu_rsrc_free_count(&block->lf);
+
+	if (rvu->hw->cap.nix_fixed_txschq_mapping) {
+		rsp->schq[NIX_TXSCH_LVL_SMQ] = 1;
+		rsp->schq[NIX_TXSCH_LVL_TL4] = 1;
+		rsp->schq[NIX_TXSCH_LVL_TL3] = 1;
+		rsp->schq[NIX_TXSCH_LVL_TL2] = 1;
+		/* NIX1 */
+		if (!is_block_implemented(rvu->hw, BLKADDR_NIX1))
+			goto out;
+		rsp->schq_nix1[NIX_TXSCH_LVL_SMQ] = 1;
+		rsp->schq_nix1[NIX_TXSCH_LVL_TL4] = 1;
+		rsp->schq_nix1[NIX_TXSCH_LVL_TL3] = 1;
+		rsp->schq_nix1[NIX_TXSCH_LVL_TL2] = 1;
+	} else {
+		nix_hw = get_nix_hw(hw, BLKADDR_NIX0);
+		txsch = &nix_hw->txsch[NIX_TXSCH_LVL_SMQ];
+		rsp->schq[NIX_TXSCH_LVL_SMQ] =
+				rvu_rsrc_free_count(&txsch->schq);
+
+		txsch = &nix_hw->txsch[NIX_TXSCH_LVL_TL4];
+		rsp->schq[NIX_TXSCH_LVL_TL4] =
+				rvu_rsrc_free_count(&txsch->schq);
+
+		txsch = &nix_hw->txsch[NIX_TXSCH_LVL_TL3];
+		rsp->schq[NIX_TXSCH_LVL_TL3] =
+				rvu_rsrc_free_count(&txsch->schq);
+
+		txsch = &nix_hw->txsch[NIX_TXSCH_LVL_TL2];
+		rsp->schq[NIX_TXSCH_LVL_TL2] =
+				rvu_rsrc_free_count(&txsch->schq);
+
+		if (!is_block_implemented(rvu->hw, BLKADDR_NIX1))
+			goto out;
+
+		nix_hw = get_nix_hw(hw, BLKADDR_NIX1);
+		txsch = &nix_hw->txsch[NIX_TXSCH_LVL_SMQ];
+		rsp->schq_nix1[NIX_TXSCH_LVL_SMQ] =
+				rvu_rsrc_free_count(&txsch->schq);
+
+		txsch = &nix_hw->txsch[NIX_TXSCH_LVL_TL4];
+		rsp->schq_nix1[NIX_TXSCH_LVL_TL4] =
+				rvu_rsrc_free_count(&txsch->schq);
+
+		txsch = &nix_hw->txsch[NIX_TXSCH_LVL_TL3];
+		rsp->schq_nix1[NIX_TXSCH_LVL_TL3] =
+				rvu_rsrc_free_count(&txsch->schq);
+
+		txsch = &nix_hw->txsch[NIX_TXSCH_LVL_TL2];
+		rsp->schq_nix1[NIX_TXSCH_LVL_TL2] =
+				rvu_rsrc_free_count(&txsch->schq);
+	}
+
+	rsp->schq_nix1[NIX_TXSCH_LVL_TL1] = 1;
+out:
+	rsp->schq[NIX_TXSCH_LVL_TL1] = 1;
+	mutex_unlock(&rvu->rsrc_lock);
+
+	return 0;
+}
+
 int rvu_mbox_handler_vf_flr(struct rvu *rvu, struct msg_req *req,
 			    struct msg_rsp *rsp)
 {
-- 
2.7.4

