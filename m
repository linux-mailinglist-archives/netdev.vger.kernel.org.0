Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FECE3DB809
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 13:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbhG3Ltd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 07:49:33 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53738 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238617AbhG3Ltd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 07:49:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16UBkGDp025732;
        Fri, 30 Jul 2021 04:49:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yfsCSXkd/enMNc6GZ+DCGkvldD91dFCbunH7mMj1zlw=;
 b=S5GB3aZeT0YW9q15X2jaVbBYjuA1vBOSu5eft8o1SXgu/iY0teWXn6S1rXNN1OKlgyS6
 FdeXo+ce8lIyyfqDkMTsQA8rA6qSb56t9/CFK9EsJi3uvVndvzCOXP/bpnQBQFo+u+AZ
 1t4tYIN0XMOKPy8fKqyq0vOnY0ey9GmXD4zYDQhy3rAhxJbFONDKl/kT3HMg4Nn6nyIv
 svK6GTUNPx41bbzkpuUmLD0raARRcW/AGABFFmD9yoA+5oNe3gfAEDuspH78artHhcRI
 dzD30sTY9y+Dgx2nAMQLysjeykWbweGq1c0BRTQZ7zr/SzmcXyEACvoyZidgYYFOPAy2 2g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a4866sv44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Jul 2021 04:49:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 30 Jul
 2021 04:49:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 30 Jul 2021 04:49:26 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id B01563F704F;
        Fri, 30 Jul 2021 04:49:24 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 2/2] octeontx2-pf: cn10k: Config DWRR weight based on MTU
Date:   Fri, 30 Jul 2021 17:19:14 +0530
Message-ID: <1627645754-18131-3-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1627645754-18131-1-git-send-email-sgoutham@marvell.com>
References: <1627645754-18131-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: EA20vq6SemaM78ytMs2-DDC7VYDUgwve
X-Proofpoint-ORIG-GUID: EA20vq6SemaM78ytMs2-DDC7VYDUgwve
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_05:2021-07-30,2021-07-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Program SQ, MDQ, TL4 to TL2 transmit scheduler queues' DWRR
weight based on DWRR MTU programmed at NIX_AF_DWRR_RPM_MTU.
The DWRR MTU from admin function is retrieved via mbox.

On OcteaonTx2 silicon, admin function driver responds with DWRR
MTU as '1'. This helps to avoid silicon specific transmit
scheduler DWRR quantum/weight configuration logic.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h |  4 ----
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  4 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 15 ++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |  3 +--
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h | 14 +++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 23 ++++++++++++++++------
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 7 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index e9a52b1..752ba6b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -146,10 +146,6 @@ enum nix_scheduler {
 #define TXSCH_RR_QTM_MAX		((1 << 24) - 1)
 #define TXSCH_TL1_DFLT_RR_QTM		TXSCH_RR_QTM_MAX
 #define TXSCH_TL1_DFLT_RR_PRIO		(0x1ull)
-#define MAX_SCHED_WEIGHT		0xFF
-#define DFLT_RR_WEIGHT			71
-#define DFLT_RR_QTM	((DFLT_RR_WEIGHT * TXSCH_RR_QTM_MAX) \
-			 / MAX_SCHED_WEIGHT)
 #define CN10K_MAX_DWRR_WEIGHT          16384 /* Weight is 14bit on CN10K */
 
 /* Min/Max packet sizes, excluding FCS */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index f5ec39d..4470933 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1032,8 +1032,12 @@ struct nix_bp_cfg_rsp {
 
 struct nix_hw_info {
 	struct mbox_msghdr hdr;
+	u16 rsvs16;
 	u16 max_mtu;
 	u16 min_mtu;
+	u32 rpm_dwrr_mtu;
+	u32 sdp_dwrr_mtu;
+	u64 rsvd[16]; /* Add reserved fields for future expansion */
 };
 
 struct nix_bandprof_alloc_req {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 5c68367..2bafde22 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2790,6 +2790,7 @@ int rvu_mbox_handler_nix_get_hw_info(struct rvu *rvu, struct msg_req *req,
 				     struct nix_hw_info *rsp)
 {
 	u16 pcifunc = req->hdr.pcifunc;
+	u64 dwrr_mtu;
 	int blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
@@ -2802,6 +2803,20 @@ int rvu_mbox_handler_nix_get_hw_info(struct rvu *rvu, struct msg_req *req,
 		rvu_get_lmac_link_max_frs(rvu, &rsp->max_mtu);
 
 	rsp->min_mtu = NIC_HW_MIN_FRS;
+
+	if (!rvu->hw->cap.nix_common_dwrr_mtu) {
+		/* Return '1' on OTx2 */
+		rsp->rpm_dwrr_mtu = 1;
+		rsp->sdp_dwrr_mtu = 1;
+		return 0;
+	}
+
+	dwrr_mtu = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_DWRR_RPM_MTU);
+	rsp->rpm_dwrr_mtu = convert_dwrr_mtu_to_bytes(dwrr_mtu);
+
+	dwrr_mtu = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_DWRR_SDP_MTU);
+	rsp->sdp_dwrr_mtu = convert_dwrr_mtu_to_bytes(dwrr_mtu);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index 184de94..ccffdda 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -92,8 +92,7 @@ int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	aq->sq.ena = 1;
 	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
 	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
-	/* FIXME: set based on NIX_AF_DWRR_RPM_MTU*/
-	aq->sq.smq_rr_weight = pfvf->netdev->mtu;
+	aq->sq.smq_rr_weight = mtu_to_dwrr_weight(pfvf, pfvf->max_frs);
 	aq->sq.default_chan = pfvf->hw.tx_chan_base;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
 	aq->sq.sqb_aura = sqb_aura;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
index 1a1ae33..e07723d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
@@ -9,6 +9,20 @@
 
 #include "otx2_common.h"
 
+static inline int mtu_to_dwrr_weight(struct otx2_nic *pfvf, int mtu)
+{
+	u32 weight;
+
+	/* On OTx2, since AF returns DWRR_MTU as '1', this logic
+	 * will work on those silicons as well.
+	 */
+	weight = mtu / pfvf->hw.dwrr_mtu;
+	if (mtu % pfvf->hw.dwrr_mtu)
+		weight += 1;
+
+	return weight;
+}
+
 void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
 void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx);
 int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 7cccd802..14736cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -596,6 +596,9 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 	struct otx2_hw *hw = &pfvf->hw;
 	struct nix_txschq_config *req;
 	u64 schq, parent;
+	u64 dwrr_val;
+
+	dwrr_val = mtu_to_dwrr_weight(pfvf, pfvf->max_frs);
 
 	req = otx2_mbox_alloc_msg_nix_txschq_cfg(&pfvf->mbox);
 	if (!req)
@@ -621,21 +624,21 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		req->num_regs++;
 		/* Set DWRR quantum */
 		req->reg[2] = NIX_AF_MDQX_SCHEDULE(schq);
-		req->regval[2] =  DFLT_RR_QTM;
+		req->regval[2] =  dwrr_val;
 	} else if (lvl == NIX_TXSCH_LVL_TL4) {
 		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL3][0];
 		req->reg[0] = NIX_AF_TL4X_PARENT(schq);
 		req->regval[0] = parent << 16;
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL4X_SCHEDULE(schq);
-		req->regval[1] = DFLT_RR_QTM;
+		req->regval[1] = dwrr_val;
 	} else if (lvl == NIX_TXSCH_LVL_TL3) {
 		parent = hw->txschq_list[NIX_TXSCH_LVL_TL2][0];
 		req->reg[0] = NIX_AF_TL3X_PARENT(schq);
 		req->regval[0] = parent << 16;
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL3X_SCHEDULE(schq);
-		req->regval[1] = DFLT_RR_QTM;
+		req->regval[1] = dwrr_val;
 	} else if (lvl == NIX_TXSCH_LVL_TL2) {
 		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL1][0];
 		req->reg[0] = NIX_AF_TL2X_PARENT(schq);
@@ -643,7 +646,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL2X_SCHEDULE(schq);
-		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | DFLT_RR_QTM;
+		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | dwrr_val;
 
 		req->num_regs++;
 		req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq,
@@ -656,7 +659,10 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		 * For VF this is always ignored.
 		 */
 
-		/* Set DWRR quantum */
+		/* On CN10K, if RR_WEIGHT is greater than 16384, HW will
+		 * clip it to 16384, so configuring a 24bit max value
+		 * will work on both OTx2 and CN10K.
+		 */
 		req->reg[0] = NIX_AF_TL1X_SCHEDULE(schq);
 		req->regval[0] = TXSCH_TL1_DFLT_RR_QTM;
 
@@ -803,7 +809,7 @@ int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	aq->sq.ena = 1;
 	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
 	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
-	aq->sq.smq_rr_quantum = DFLT_RR_QTM;
+	aq->sq.smq_rr_quantum = mtu_to_dwrr_weight(pfvf, pfvf->max_frs);
 	aq->sq.default_chan = pfvf->hw.tx_chan_base;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
 	aq->sq.sqb_aura = sqb_aura;
@@ -1666,6 +1672,11 @@ u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
 		 * SMQ errors
 		 */
 		max_mtu = rsp->max_mtu - 8 - OTX2_ETH_HLEN;
+
+		/* Also save DWRR MTU, needed for DWRR weight calculation */
+		pfvf->hw.dwrr_mtu = rsp->rpm_dwrr_mtu;
+		if (!pfvf->hw.dwrr_mtu)
+			pfvf->hw.dwrr_mtu = 1;
 	}
 
 out:
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 8fd58cd..2a80cdc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -181,6 +181,7 @@ struct otx2_hw {
 	/* NIX */
 	u16		txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
 	u16			matchall_ipolicer;
+	u32			dwrr_mtu;
 
 	/* HW settings, coalescing etc */
 	u16			rx_chan_base;
-- 
2.7.4

