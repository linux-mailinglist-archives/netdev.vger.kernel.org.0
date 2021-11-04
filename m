Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36E244598A
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 19:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhKDSXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 14:23:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55130 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234159AbhKDSXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 14:23:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A49jSUc018743;
        Thu, 4 Nov 2021 11:20:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=CEpJe2E+URFgjcqM1/YkLKH5BoGvuo2p+IIpcI7uUS0=;
 b=NaolcU3f8ANuGBL0AMmXDagfKncVMUdolAK/J5qPRLfmHRnSj/T9KXNkmcgha2MwEPwH
 CbhG/2X2jwP58jSBR/xNr+rHGD9/PnPSoaeGiIXB3dRZmQZmAwGjXCbYzccV/9YAvKb+
 Ad9Zt/ygaNWRli4llkIlCWn1iDTXxvc+TxPebM8y3Za6SlPFPvMUCU6HYhTRODuC9q2U
 r3mwgc694eSPXLGK28CuqpNjBCJLGuWViPivWFB7q4RfsK0qBGZtVSlAL3cm1VlV908K
 0+cnu614Cvm5DA5XS+2kFTRqlZ70Ze/1v7ctXezWPZ2vqYAqCZDWyxWg4YgDSOMF+aGS 2g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3c43sf4bhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 11:20:51 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 4 Nov
 2021 11:20:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 4 Nov 2021 11:20:49 -0700
Received: from rchintakuntla-lnx3.caveonetworks.com (unknown [10.111.140.81])
        by maili.marvell.com (Postfix) with ESMTP id 634503F7066;
        Thu,  4 Nov 2021 11:20:49 -0700 (PDT)
From:   Radha Mohan Chintakuntla <radhac@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <sgoutham@marvell.com>, <linux-kernel@vger.kernel.org>
CC:     Radha Mohan Chintakuntla <radhac@marvell.com>
Subject: [PATCH] octeontx2-nicvf: Add netdev interface support for SDP VF devices
Date:   Thu, 4 Nov 2021 11:20:45 -0700
Message-ID: <20211104182046.28308-1-radhac@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: kcTnzdavBxqHtkLrOno_d0Lk2bOeQDC0
X-Proofpoint-GUID: kcTnzdavBxqHtkLrOno_d0Lk2bOeQDC0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_06,2021-11-03_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds netdev interface for SDP VFs. This interface can be used
to communicate with a host over PCIe when OcteonTx is in PCIe Endpoint
mode.

Signed-off-by: Radha Mohan Chintakuntla <radhac@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/cn10k.c    |  4 +--
 .../ethernet/marvell/octeontx2/nic/cn10k.h    |  2 +-
 .../marvell/octeontx2/nic/otx2_common.c       | 32 +++++++++++++------
 .../marvell/octeontx2/nic/otx2_common.h       | 14 ++++++--
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  | 16 ++++++++--
 6 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index fd4f083c699e..2262d33a7f23 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -72,7 +72,7 @@ int cn10k_lmtst_init(struct otx2_nic *pfvf)
 }
 EXPORT_SYMBOL(cn10k_lmtst_init);
 
-int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
+int cn10k_sq_aq_init(void *dev, u16 qidx, u8 chan_offset, u16 sqb_aura)
 {
 	struct nix_cn10k_aq_enq_req *aq;
 	struct otx2_nic *pfvf = dev;
@@ -89,7 +89,7 @@ int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
 	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
 	aq->sq.smq_rr_weight = mtu_to_dwrr_weight(pfvf, pfvf->tx_max_pktlen);
-	aq->sq.default_chan = pfvf->hw.tx_chan_base;
+	aq->sq.default_chan = pfvf->hw.tx_chan_base + chan_offset;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
 	aq->sq.sqb_aura = sqb_aura;
 	aq->sq.sq_int_ena = NIX_SQINT_BITS;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
index 8ae96815865e..28b3b3275fe6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h
@@ -26,7 +26,7 @@ static inline int mtu_to_dwrr_weight(struct otx2_nic *pfvf, int mtu)
 
 void cn10k_refill_pool_ptrs(void *dev, struct otx2_cq_queue *cq);
 void cn10k_sqe_flush(void *dev, struct otx2_snd_queue *sq, int size, int qidx);
-int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
+int cn10k_sq_aq_init(void *dev, u16 qidx, u8 chan_offset, u16 sqb_aura);
 int cn10k_lmtst_init(struct otx2_nic *pfvf);
 int cn10k_free_all_ipolicers(struct otx2_nic *pfvf);
 int cn10k_alloc_matchall_ipolicer(struct otx2_nic *pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 66da31f30d3e..e46c24171597 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -233,6 +233,9 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 
 	req->maxlen = pfvf->netdev->mtu + OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
 
+	if (is_otx2_sdpvf(pfvf->pdev))
+		req->sdp_link = true;
+
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 	mutex_unlock(&pfvf->mbox.lock);
 	return err;
@@ -243,7 +246,7 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
 	struct cgx_pause_frm_cfg *req;
 	int err;
 
-	if (is_otx2_lbkvf(pfvf->pdev))
+	if (is_otx2_lbkvf(pfvf->pdev) || is_otx2_sdpvf(pfvf->pdev))
 		return 0;
 
 	mutex_lock(&pfvf->mbox.lock);
@@ -622,6 +625,11 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL4X_SCHEDULE(schq);
 		req->regval[1] = dwrr_val;
+		if (is_otx2_sdpvf(pfvf->pdev)) {
+			req->num_regs++;
+			req->reg[2] = NIX_AF_TL4X_SDP_LINK_CFG(schq);
+			req->regval[2] = BIT_ULL(12);
+		}
 	} else if (lvl == NIX_TXSCH_LVL_TL3) {
 		parent = hw->txschq_list[NIX_TXSCH_LVL_TL2][0];
 		req->reg[0] = NIX_AF_TL3X_PARENT(schq);
@@ -638,11 +646,12 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		req->reg[1] = NIX_AF_TL2X_SCHEDULE(schq);
 		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | dwrr_val;
 
-		req->num_regs++;
-		req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
-		/* Enable this queue and backpressure */
-		req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
-
+		if (!is_otx2_sdpvf(pfvf->pdev)) {
+			req->num_regs++;
+			req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
+			/* Enable this queue and backpressure */
+			req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
+		}
 	} else if (lvl == NIX_TXSCH_LVL_TL1) {
 		/* Default config for TL1.
 		 * For VF this is always ignored.
@@ -779,7 +788,7 @@ static int otx2_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
 	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
 
-int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
+int otx2_sq_aq_init(void *dev, u16 qidx, u8 chan_offset, u16 sqb_aura)
 {
 	struct otx2_nic *pfvf = dev;
 	struct otx2_snd_queue *sq;
@@ -799,7 +808,7 @@ int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
 	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
 	aq->sq.smq_rr_quantum = mtu_to_dwrr_weight(pfvf, pfvf->tx_max_pktlen);
-	aq->sq.default_chan = pfvf->hw.tx_chan_base;
+	aq->sq.default_chan = pfvf->hw.tx_chan_base + chan_offset;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
 	aq->sq.sqb_aura = sqb_aura;
 	aq->sq.sq_int_ena = NIX_SQINT_BITS;
@@ -822,6 +831,7 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	struct otx2_qset *qset = &pfvf->qset;
 	struct otx2_snd_queue *sq;
 	struct otx2_pool *pool;
+	u8 chan_offset;
 	int err;
 
 	pool = &pfvf->qset.pool[sqb_aura];
@@ -864,8 +874,8 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	sq->stats.bytes = 0;
 	sq->stats.pkts = 0;
 
-	return pfvf->hw_ops->sq_aq_init(pfvf, qidx, sqb_aura);
-
+	chan_offset = qidx % pfvf->hw.tx_chan_cnt;
+	return pfvf->hw_ops->sq_aq_init(pfvf, qidx, chan_offset, sqb_aura);
 }
 
 static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
@@ -1590,6 +1600,8 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 	pfvf->hw.sqb_size = rsp->sqb_size;
 	pfvf->hw.rx_chan_base = rsp->rx_chan_base;
 	pfvf->hw.tx_chan_base = rsp->tx_chan_base;
+	pfvf->hw.rx_chan_cnt = rsp->rx_chan_cnt;
+	pfvf->hw.tx_chan_cnt = rsp->tx_chan_cnt;
 	pfvf->hw.lso_tsov4_idx = rsp->lso_tsov4_idx;
 	pfvf->hw.lso_tsov6_idx = rsp->lso_tsov6_idx;
 	pfvf->hw.cgx_links = rsp->cgx_links;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 61e52812983f..386fd7f95944 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -28,6 +28,7 @@
 /* PCI device IDs */
 #define PCI_DEVID_OCTEONTX2_RVU_PF              0xA063
 #define PCI_DEVID_OCTEONTX2_RVU_VF		0xA064
+#define PCI_DEVID_OCTEONTX2_SDP_VF		0xA0F7
 #define PCI_DEVID_OCTEONTX2_RVU_AFVF		0xA0F8
 
 #define PCI_SUBSYS_DEVID_96XX_RVU_PFVF		0xB200
@@ -191,6 +192,8 @@ struct otx2_hw {
 	/* HW settings, coalescing etc */
 	u16			rx_chan_base;
 	u16			tx_chan_base;
+	u8			rx_chan_cnt;
+	u8			tx_chan_cnt;
 	u16			cq_qcount_wait;
 	u16			cq_ecount_wait;
 	u16			rq_skid;
@@ -314,7 +317,7 @@ struct otx2_tc_info {
 };
 
 struct dev_hw_ops {
-	int	(*sq_aq_init)(void *dev, u16 qidx, u16 sqb_aura);
+	int	(*sq_aq_init)(void *dev, u16 qidx, u8 chan_offset, u16 sqb_aura);
 	void	(*sqe_flush)(void *dev, struct otx2_snd_queue *sq,
 			     int size, int qidx);
 	void	(*refill_pool_ptrs)(void *dev, struct otx2_cq_queue *cq);
@@ -403,6 +406,11 @@ static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
 	return pdev->device == PCI_DEVID_OCTEONTX2_RVU_AFVF;
 }
 
+static inline bool is_otx2_sdpvf(struct pci_dev *pdev)
+{
+	return pdev->device == PCI_DEVID_OCTEONTX2_SDP_VF;
+}
+
 static inline bool is_96xx_A0(struct pci_dev *pdev)
 {
 	return (pdev->revision == 0x00) &&
@@ -794,8 +802,8 @@ void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);
 void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
-int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
-int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
+int otx2_sq_aq_init(void *dev, u16 qidx, u8 chan_offset, u16 sqb_aura);
+int cn10k_sq_aq_init(void *dev, u16 qidx, u8 chan_offset, u16 sqb_aura);
 int otx2_alloc_buffer(struct otx2_nic *pfvf, struct otx2_cq_queue *cq,
 		      dma_addr_t *dma);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index 1b967eaf948b..6ef52051ab09 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -140,6 +140,7 @@
 
 /* NIX AF transmit scheduler registers */
 #define NIX_AF_SMQX_CFG(a)		(0x700 | (a) << 16)
+#define NIX_AF_TL4X_SDP_LINK_CFG(a)	(0xB10 | (a) << 16)
 #define NIX_AF_TL1X_SCHEDULE(a)		(0xC00 | (a) << 16)
 #define NIX_AF_TL1X_CIR(a)		(0xC20 | (a) << 16)
 #define NIX_AF_TL1X_TOPOLOGY(a)		(0xC80 | (a) << 16)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index e6cb8cd0787d..b1e88fe981f0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -21,6 +21,7 @@
 static const struct pci_device_id otx2_vf_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_AFVF) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_RVU_VF) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_SDP_VF) },
 	{ }
 };
 
@@ -361,7 +362,7 @@ static int otx2vf_open(struct net_device *netdev)
 
 	/* LBKs do not receive link events so tell everyone we are up here */
 	vf = netdev_priv(netdev);
-	if (is_otx2_lbkvf(vf->pdev)) {
+	if (is_otx2_lbkvf(vf->pdev) || is_otx2_sdpvf(vf->pdev)) {
 		pr_info("%s NIC Link is UP\n", netdev->name);
 		netif_carrier_on(netdev);
 		netif_tx_start_all_queues(netdev);
@@ -681,6 +682,16 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		snprintf(netdev->name, sizeof(netdev->name), "lbk%d", n);
 	}
 
+	/* To distinguish, for SDP VFs set netdev name explicitly */
+	if (is_otx2_sdpvf(vf->pdev)) {
+		int n;
+
+		n = (vf->pcifunc >> RVU_PFVF_FUNC_SHIFT) & RVU_PFVF_FUNC_MASK;
+		/* Need to subtract 1 to get proper VF number */
+		n -= 1;
+		snprintf(netdev->name, sizeof(netdev->name), "sdp%d-%d", pdev->bus->number, n);
+	}
+
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
@@ -691,7 +702,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_unreg_netdev;
 
-	otx2vf_set_ethtool_ops(netdev);
+	if (!is_otx2_sdpvf(vf->pdev))
+		otx2vf_set_ethtool_ops(netdev);
 
 	err = otx2vf_mcam_flow_init(vf);
 	if (err)
-- 
2.17.1

