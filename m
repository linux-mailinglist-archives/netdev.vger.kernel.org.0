Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC4259D19E
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbiHWG7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 02:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240810AbiHWG7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 02:59:01 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC3832EC8;
        Mon, 22 Aug 2022 23:58:52 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MKTwHK003434;
        Mon, 22 Aug 2022 23:58:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=eIbSJgf+ilUg2KOa6QlSsZCF1tQwkJ6o6WndhwfUJ8M=;
 b=cMrwXszkBuEiPHDQzUXROT7cFI1rUNPGxfFhU5Fg0aqYGvfxV2WflBYJP300FfBiZQvY
 /i/ojpYwV9WJNpzaynOYnbkb/Nrz55P9vnZ1kf1x84ZixncS73m0YZjdCMi7x5GrcIpM
 THSoAe6J2tYzxF5jkdNfSK2+JJ/51vn2DPCKZ1FUkZPnRbGM45JAABrayZgSEJf5pSQn
 0+22sxgqJVxbpoFUkN+7/E2a/11hxhVd/1v3Aw48jU0ntYcxTI5EMNAPguIoOADfw7Yx
 7fa2Iy0/pfFd4njuP7iE6349s0uEMRq/3ty8rj4z+StwwgTb5NoBix0v6JIVgteMYt1K jg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3j2y4k27x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Aug 2022 23:58:38 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 22 Aug
 2022 23:58:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Aug 2022 23:58:35 -0700
Received: from localhost.localdomain (unknown [10.28.36.166])
        by maili.marvell.com (Postfix) with ESMTP id 1C1CE5B6923;
        Mon, 22 Aug 2022 23:58:31 -0700 (PDT)
From:   Suman Ghosh <sumang@marvell.com>
To:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Suman Ghosh <sumang@marvell.com>
Subject: [PATCH] octeontx2-pf: Add egress PFC support
Date:   Tue, 23 Aug 2022 12:28:29 +0530
Message-ID: <20220823065829.1060339-1-sumang@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: spECUfsJ5d96ujPRjnFdoSykvpEkEAYA
X-Proofpoint-ORIG-GUID: spECUfsJ5d96ujPRjnFdoSykvpEkEAYA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_02,2022-08-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of now all transmit queues transmit packets out of same scheduler
queue hierarchy. Due to this PFC frames sent by peer are not handled
properly, either all transmit queues are backpressured or none.
To fix this when user enables PFC for a given priority map relavant
transmit queue to a different scheduler queue hierarcy, so that
backpressure is applied only to the traffic egressing out of that TXQ.

Signed-off-by: Suman Ghosh <sumang@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/cn10k.c    |   3 +-
 .../marvell/octeontx2/nic/otx2_common.c       | 349 +++++++++++++++++-
 .../marvell/octeontx2/nic/otx2_common.h       |  29 +-
 .../marvell/octeontx2/nic/otx2_dcbnl.c        |  35 ++
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  56 ++-
 5 files changed, 455 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
index fd4f083c699e..826f691de259 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
@@ -86,8 +86,7 @@ int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	aq->sq.max_sqe_size = NIX_MAXSQESZ_W16; /* 128 byte */
 	aq->sq.cq_ena = 1;
 	aq->sq.ena = 1;
-	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
-	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
+	aq->sq.smq = otx2_get_smq_idx(pfvf, qidx);
 	aq->sq.smq_rr_weight = mtu_to_dwrr_weight(pfvf, pfvf->tx_max_pktlen);
 	aq->sq.default_chan = pfvf->hw.tx_chan_base;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index d686c7b6252f..0ac1131612d4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -586,7 +586,7 @@ void otx2_get_mac_from_af(struct net_device *netdev)
 }
 EXPORT_SYMBOL(otx2_get_mac_from_af);
 
-int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
+int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool txschq_for_pfc)
 {
 	struct otx2_hw *hw = &pfvf->hw;
 	struct nix_txschq_config *req;
@@ -602,7 +602,13 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 	req->lvl = lvl;
 	req->num_regs = 1;
 
-	schq = hw->txschq_list[lvl][0];
+#ifdef CONFIG_DCB
+	if (txschq_for_pfc)
+		schq = pfvf->pfc_schq_list[lvl][prio];
+	else
+#endif
+		schq = hw->txschq_list[lvl][prio];
+
 	/* Set topology e.t.c configuration */
 	if (lvl == NIX_TXSCH_LVL_SMQ) {
 		req->reg[0] = NIX_AF_SMQX_CFG(schq);
@@ -611,7 +617,13 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 				  (0x2ULL << 36);
 		req->num_regs++;
 		/* MDQ config */
-		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL4][0];
+#ifdef CONFIG_DCB
+		if (txschq_for_pfc)
+			parent = pfvf->pfc_schq_list[NIX_TXSCH_LVL_TL4][prio];
+		else
+#endif
+			parent = hw->txschq_list[NIX_TXSCH_LVL_TL4][prio];
+
 		req->reg[1] = NIX_AF_MDQX_PARENT(schq);
 		req->regval[1] = parent << 16;
 		req->num_regs++;
@@ -619,14 +631,26 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		req->reg[2] = NIX_AF_MDQX_SCHEDULE(schq);
 		req->regval[2] =  dwrr_val;
 	} else if (lvl == NIX_TXSCH_LVL_TL4) {
-		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL3][0];
+#ifdef CONFIG_DCB
+		if (txschq_for_pfc)
+			parent = pfvf->pfc_schq_list[NIX_TXSCH_LVL_TL3][prio];
+		else
+#endif
+			parent = hw->txschq_list[NIX_TXSCH_LVL_TL3][prio];
+
 		req->reg[0] = NIX_AF_TL4X_PARENT(schq);
 		req->regval[0] = parent << 16;
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL4X_SCHEDULE(schq);
 		req->regval[1] = dwrr_val;
 	} else if (lvl == NIX_TXSCH_LVL_TL3) {
-		parent = hw->txschq_list[NIX_TXSCH_LVL_TL2][0];
+#ifdef CONFIG_DCB
+		if (txschq_for_pfc)
+			parent = pfvf->pfc_schq_list[NIX_TXSCH_LVL_TL2][prio];
+		else
+#endif
+			parent = hw->txschq_list[NIX_TXSCH_LVL_TL2][prio];
+
 		req->reg[0] = NIX_AF_TL3X_PARENT(schq);
 		req->regval[0] = parent << 16;
 		req->num_regs++;
@@ -635,11 +659,19 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		if (lvl == hw->txschq_link_cfg_lvl) {
 			req->num_regs++;
 			req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
-			/* Enable this queue and backpressure */
-			req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
+			/* Enable this queue and backpressure
+			 * and set relative channel
+			 */
+			req->regval[2] = BIT_ULL(13) | BIT_ULL(12) | prio;
 		}
 	} else if (lvl == NIX_TXSCH_LVL_TL2) {
-		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL1][0];
+#ifdef CONFIG_DCB
+		if (txschq_for_pfc)
+			parent = pfvf->pfc_schq_list[NIX_TXSCH_LVL_TL1][prio];
+		else
+#endif
+			parent = hw->txschq_list[NIX_TXSCH_LVL_TL1][prio];
+
 		req->reg[0] = NIX_AF_TL2X_PARENT(schq);
 		req->regval[0] = parent << 16;
 
@@ -650,8 +682,10 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		if (lvl == hw->txschq_link_cfg_lvl) {
 			req->num_regs++;
 			req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
-			/* Enable this queue and backpressure */
-			req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
+			/* Enable this queue and backpressure
+			 * and set relative channel
+			 */
+			req->regval[2] = BIT_ULL(13) | BIT_ULL(12) | prio;
 		}
 	} else if (lvl == NIX_TXSCH_LVL_TL1) {
 		/* Default config for TL1.
@@ -677,6 +711,298 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
 
+int otx2_smq_flush(struct otx2_nic *pfvf, int smq)
+{
+	struct nix_txschq_config *req;
+	int rc;
+
+	mutex_lock(&pfvf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_nix_txschq_cfg(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->lvl = NIX_TXSCH_LVL_SMQ;
+	req->reg[0] = NIX_AF_SMQX_CFG(smq);
+	req->regval[0] |= BIT_ULL(49);
+	req->num_regs++;
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+	return rc;
+}
+
+#ifdef CONFIG_DCB
+int otx2_pfc_txschq_config(struct otx2_nic *pfvf)
+{
+	u8 pfc_en, pfc_bit_set;
+	int prio, lvl, err;
+
+	pfc_en = pfvf->pfc_en;
+	for (prio = 0; prio < NIX_PF_PFC_PRIO_MAX; prio++) {
+		pfc_bit_set = pfc_en & (1 << prio);
+
+		/* Either PFC bit is not set
+		 * or tx scheduler is not allocated for the priority
+		 */
+		if (!pfc_bit_set || !pfvf->pfc_alloc_status[prio])
+			continue;
+
+		/* configure the scheduler for the tls*/
+		for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
+			err = otx2_txschq_config(pfvf, lvl, prio, true);
+			if (err) {
+				dev_err(pfvf->dev,
+					"%s configure PFC tx schq for lvl:%d, prio:%d failed!\n",
+					__func__, lvl, prio);
+				return err;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int otx2_pfc_txschq_alloc_one(struct otx2_nic *pfvf, u8 prio)
+{
+	struct nix_txsch_alloc_req *req;
+	struct nix_txsch_alloc_rsp *rsp;
+	int lvl, rc;
+
+	/* Get memory to put this msg */
+	req = otx2_mbox_alloc_msg_nix_txsch_alloc(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	/* Request one schq per level upto max level as configured
+	 * link config level. These rest of the scheduler can be
+	 * same as hw.txschq_list.
+	 */
+	for (lvl = 0; lvl < pfvf->hw.txschq_link_cfg_lvl; lvl++)
+		req->schq[lvl] = 1;
+
+	rc = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (rc)
+		return rc;
+
+	rsp = (struct nix_txsch_alloc_rsp *)
+	      otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp))
+		return PTR_ERR(rsp);
+
+	/* Setup transmit scheduler list */
+	for (lvl = 0; lvl < pfvf->hw.txschq_link_cfg_lvl; lvl++) {
+		if (!rsp->schq[lvl])
+			return -ENOSPC;
+
+		pfvf->pfc_schq_list[lvl][prio] = rsp->schq_list[lvl][0];
+	}
+
+	/* Set the Tx schedulers for rest of the levels same as
+	 * hw.txschq_list as those will be common for all.
+	 */
+	for (; lvl < NIX_TXSCH_LVL_CNT; lvl++)
+		pfvf->pfc_schq_list[lvl][prio] = pfvf->hw.txschq_list[lvl][0];
+
+	pfvf->pfc_alloc_status[prio] = true;
+	return 0;
+}
+
+int otx2_pfc_txschq_alloc(struct otx2_nic *pfvf)
+{
+	u8 pfc_en = pfvf->pfc_en;
+	u8 pfc_bit_set;
+	int err, prio;
+
+	for (prio = 0; prio < NIX_PF_PFC_PRIO_MAX; prio++) {
+		pfc_bit_set = pfc_en & (1 << prio);
+
+		if (!pfc_bit_set || pfvf->pfc_alloc_status[prio])
+			continue;
+
+		/* Add new scheduler to the priority */
+		err = otx2_pfc_txschq_alloc_one(pfvf, prio);
+		if (err) {
+			dev_err(pfvf->dev, "%s failed to allocate PFC TX schedulers\n", __func__);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int otx2_pfc_txschq_stop_one(struct otx2_nic *pfvf, u8 prio)
+{
+	struct nix_txsch_free_req *free_req;
+	int err;
+
+	mutex_lock(&pfvf->mbox.lock);
+	/* free PFC TLx nodes */
+	free_req = otx2_mbox_alloc_msg_nix_txsch_free(&pfvf->mbox);
+	if (!free_req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return -ENOMEM;
+	}
+
+	free_req->flags = TXSCHQ_FREE_ALL;
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+
+	pfvf->pfc_alloc_status[prio] = false;
+	return 0;
+}
+
+static int otx2_pfc_update_sq_smq_mapping(struct otx2_nic *pfvf, int prio)
+{
+	struct nix_cn10k_aq_enq_req *cn10k_sq_aq;
+	struct net_device *dev = pfvf->netdev;
+	bool if_up = netif_running(dev);
+	struct nix_aq_enq_req *sq_aq;
+
+	if (if_up) {
+		if (pfvf->pfc_alloc_status[prio])
+			netif_tx_stop_all_queues(pfvf->netdev);
+		else
+			netif_tx_stop_queue(netdev_get_tx_queue(dev, prio));
+	}
+
+	if (test_bit(CN10K_LMTST, &pfvf->hw.cap_flag)) {
+		cn10k_sq_aq = otx2_mbox_alloc_msg_nix_cn10k_aq_enq(&pfvf->mbox);
+		if (!cn10k_sq_aq)
+			return -ENOMEM;
+
+		/* Fill AQ info */
+		cn10k_sq_aq->qidx = prio;
+		cn10k_sq_aq->ctype = NIX_AQ_CTYPE_SQ;
+		cn10k_sq_aq->op = NIX_AQ_INSTOP_WRITE;
+
+		/* Fill fields to update */
+		cn10k_sq_aq->sq.ena = 1;
+		cn10k_sq_aq->sq_mask.ena = 1;
+		cn10k_sq_aq->sq_mask.smq = GENMASK(9, 0);
+		cn10k_sq_aq->sq.smq = otx2_get_smq_idx(pfvf, prio);
+	} else {
+		sq_aq = otx2_mbox_alloc_msg_nix_aq_enq(&pfvf->mbox);
+		if (!sq_aq)
+			return -ENOMEM;
+
+		/* Fill AQ info */
+		sq_aq->qidx = prio;
+		sq_aq->ctype = NIX_AQ_CTYPE_SQ;
+		sq_aq->op = NIX_AQ_INSTOP_WRITE;
+
+		/* Fill fields to update */
+		sq_aq->sq.ena = 1;
+		sq_aq->sq_mask.ena = 1;
+		sq_aq->sq_mask.smq = GENMASK(8, 0);
+		sq_aq->sq.smq = otx2_get_smq_idx(pfvf, prio);
+	}
+
+	otx2_sync_mbox_msg(&pfvf->mbox);
+
+	if (if_up) {
+		if (pfvf->pfc_alloc_status[prio])
+			netif_tx_start_all_queues(pfvf->netdev);
+		else
+			netif_tx_start_queue(netdev_get_tx_queue(dev, prio));
+	}
+
+	return 0;
+}
+
+int otx2_pfc_txschq_update(struct otx2_nic *pfvf)
+{
+	u8 pfc_en = pfvf->pfc_en, pfc_bit_set;
+	struct mbox *mbox = &pfvf->mbox;
+	bool if_up = netif_running(pfvf->netdev);
+	int err, prio;
+
+	mutex_lock(&mbox->lock);
+	for (prio = 0; prio < NIX_PF_PFC_PRIO_MAX; prio++) {
+		pfc_bit_set = pfc_en & (1 << prio);
+
+		/* tx scheduler was created but user wants to disable now */
+		if (!pfc_bit_set && pfvf->pfc_alloc_status[prio]) {
+			mutex_unlock(&mbox->lock);
+			if (if_up)
+				netif_tx_stop_all_queues(pfvf->netdev);
+
+			otx2_smq_flush(pfvf, pfvf->pfc_schq_list[NIX_TXSCH_LVL_SMQ][prio]);
+			if (if_up)
+				netif_tx_start_all_queues(pfvf->netdev);
+
+			/* delete the schq */
+			err = otx2_pfc_txschq_stop_one(pfvf, prio);
+			if (err) {
+				dev_err(pfvf->dev,
+					"%s failed to stop PFC tx schedulers for priority: %d\n",
+					__func__, prio);
+				return err;
+			}
+
+			mutex_lock(&mbox->lock);
+			goto update_sq_smq_map;
+		}
+
+		/* Either PFC bit is not set
+		 * or Tx scheduler is already mapped for the priority
+		 */
+		if (!pfc_bit_set || pfvf->pfc_alloc_status[prio])
+			continue;
+
+		/* Add new scheduler to the priority */
+		err = otx2_pfc_txschq_alloc_one(pfvf, prio);
+		if (err) {
+			mutex_unlock(&mbox->lock);
+			dev_err(pfvf->dev,
+				"%s failed to allocate PFC tx schedulers for priority: %d\n",
+				__func__, prio);
+			return err;
+		}
+
+update_sq_smq_map:
+		err = otx2_pfc_update_sq_smq_mapping(pfvf, prio);
+		if (err) {
+			mutex_unlock(&mbox->lock);
+			dev_err(pfvf->dev, "%s failed PFC Tx schq sq:%d mapping", __func__, prio);
+			return err;
+		}
+	}
+
+	err = otx2_pfc_txschq_config(pfvf);
+	mutex_unlock(&mbox->lock);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL(otx2_pfc_txschq_update);
+
+int otx2_pfc_txschq_stop(struct otx2_nic *pfvf)
+{
+	u8 pfc_en, pfc_bit_set;
+	int prio, err;
+
+	pfc_en = pfvf->pfc_en;
+	for (prio = 0; prio < NIX_PF_PFC_PRIO_MAX; prio++) {
+		pfc_bit_set = pfc_en & (1 << prio);
+		if (!pfc_bit_set || !pfvf->pfc_alloc_status[prio])
+			continue;
+
+		/* Delete the existing scheduler */
+		err = otx2_pfc_txschq_stop_one(pfvf, prio);
+		if (err) {
+			dev_err(pfvf->dev, "%s failed to stop PFC TX schedulers\n", __func__);
+			return err;
+		}
+	}
+
+	return 0;
+}
+#endif
+
 int otx2_txsch_alloc(struct otx2_nic *pfvf)
 {
 	struct nix_txsch_alloc_req *req;
@@ -806,8 +1132,7 @@ int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	aq->sq.max_sqe_size = NIX_MAXSQESZ_W16; /* 128 byte */
 	aq->sq.cq_ena = 1;
 	aq->sq.ena = 1;
-	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
-	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
+	aq->sq.smq = otx2_get_smq_idx(pfvf, qidx);
 	aq->sq.smq_rr_quantum = mtu_to_dwrr_weight(pfvf, pfvf->tx_max_pktlen);
 	aq->sq.default_chan = pfvf->hw.tx_chan_base;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index b28029cc4316..eae593f67ddb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -40,6 +40,11 @@
 
 #define NAME_SIZE                               32
 
+#ifdef CONFIG_DCB
+/* Max priority supported for PFC */
+#define NIX_PF_PFC_PRIO_MAX			8
+#endif
+
 enum arua_mapped_qtypes {
 	AURA_NIX_RQ,
 	AURA_NIX_SQ,
@@ -196,7 +201,7 @@ struct otx2_hw {
 
 	/* NIX */
 	u8			txschq_link_cfg_lvl;
-	u16		txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
+	u16			txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
 	u16			matchall_ipolicer;
 	u32			dwrr_mtu;
 
@@ -415,6 +420,8 @@ struct otx2_nic {
 	/* PFC */
 	u8			pfc_en;
 	u8			*queue_to_pfc_map;
+	u16			pfc_schq_list[NIX_TXSCH_LVL_CNT][NIX_PF_PFC_PRIO_MAX];
+	bool			pfc_alloc_status[NIX_PF_PFC_PRIO_MAX];
 #endif
 
 	/* napi event count. It is needed for adaptive irq coalescing. */
@@ -785,6 +792,16 @@ static inline void otx2_dma_unmap_page(struct otx2_nic *pfvf,
 			     dir, DMA_ATTR_SKIP_CPU_SYNC);
 }
 
+static inline u16 otx2_get_smq_idx(struct otx2_nic *pfvf, u16 qidx)
+{
+#ifdef CONFIG_DCB
+	if (pfvf->pfc_alloc_status[qidx])
+		return pfvf->pfc_schq_list[NIX_TXSCH_LVL_SMQ][qidx];
+#endif
+
+	return pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
+}
+
 /* MSI-X APIs */
 void otx2_free_cints(struct otx2_nic *pfvf, int n);
 void otx2_set_cints_affinity(struct otx2_nic *pfvf);
@@ -807,9 +824,15 @@ void otx2_free_aura_ptr(struct otx2_nic *pfvf, int type);
 void otx2_sq_free_sqbs(struct otx2_nic *pfvf);
 int otx2_config_nix(struct otx2_nic *pfvf);
 int otx2_config_nix_queues(struct otx2_nic *pfvf);
-int otx2_txschq_config(struct otx2_nic *pfvf, int lvl);
+int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool pfc_en);
 int otx2_txsch_alloc(struct otx2_nic *pfvf);
 int otx2_txschq_stop(struct otx2_nic *pfvf);
+#ifdef CONFIG_DCB
+int otx2_pfc_txschq_config(struct otx2_nic *pfvf);
+int otx2_pfc_txschq_alloc(struct otx2_nic *pfvf);
+int otx2_pfc_txschq_update(struct otx2_nic *pfvf);
+int otx2_pfc_txschq_stop(struct otx2_nic *pfvf);
+#endif
 void otx2_sqb_flush(struct otx2_nic *pfvf);
 int __otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 		      dma_addr_t *dma);
@@ -888,6 +911,8 @@ bool otx2_xdp_sq_append_pkt(struct otx2_nic *pfvf, u64 iova, int len, u16 qidx);
 u16 otx2_get_max_mtu(struct otx2_nic *pfvf);
 int otx2_handle_ntuple_tc_features(struct net_device *netdev,
 				   netdev_features_t features);
+int otx2_smq_flush(struct otx2_nic *pfvf, int smq);
+
 /* tc support */
 int otx2_init_tc(struct otx2_nic *nic);
 void otx2_shutdown_tc(struct otx2_nic *nic);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
index 723d2506d309..4864794200f3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
@@ -7,6 +7,24 @@
 
 #include "otx2_common.h"
 
+static int otx2_check_pfc_config(struct otx2_nic *pfvf)
+{
+	u8 tx_queues = pfvf->hw.tx_queues, prio;
+	u8 pfc_en = pfvf->pfc_en;
+
+	for (prio = 0; prio < NIX_PF_PFC_PRIO_MAX; prio++) {
+		if ((pfc_en & (1 << prio)) &&
+		    prio > tx_queues - 1) {
+			dev_warn(pfvf->dev,
+				 "Increase number of tx queues from %d to %d to support PFC.\n",
+				 tx_queues, prio + 1);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 int otx2_config_priority_flow_ctrl(struct otx2_nic *pfvf)
 {
 	struct cgx_pfc_cfg *req;
@@ -128,6 +146,17 @@ static int otx2_dcbnl_ieee_setpfc(struct net_device *dev, struct ieee_pfc *pfc)
 	/* Save PFC configuration to interface */
 	pfvf->pfc_en = pfc->pfc_en;
 
+	if (pfvf->hw.tx_queues >= NIX_PF_PFC_PRIO_MAX)
+		goto process_pfc;
+
+	/* Check if the PFC configuration can be
+	 * supported by the tx queue configuration
+	 */
+	err = otx2_check_pfc_config(pfvf);
+	if (err)
+		return err;
+
+process_pfc:
 	err = otx2_config_priority_flow_ctrl(pfvf);
 	if (err)
 		return err;
@@ -136,6 +165,12 @@ static int otx2_dcbnl_ieee_setpfc(struct net_device *dev, struct ieee_pfc *pfc)
 	if (pfc->pfc_en)
 		otx2_nix_config_bp(pfvf, true);
 
+	err = otx2_pfc_txschq_update(pfvf);
+	if (err) {
+		dev_err(pfvf->dev, "%s failed to update TX schedulers\n", __func__);
+		return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 9376d0e62914..a365be5f99a5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1389,18 +1389,40 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 		goto err_free_sq_ptrs;
 	}
 
+#ifdef CONFIG_DCB
+	if (pf->pfc_en) {
+		err = otx2_pfc_txschq_alloc(pf);
+		if (err) {
+			mutex_unlock(&mbox->lock);
+			goto err_free_sq_ptrs;
+		}
+	}
+#endif
+
 	err = otx2_config_nix_queues(pf);
 	if (err) {
 		mutex_unlock(&mbox->lock);
 		goto err_free_txsch;
 	}
+
 	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
-		err = otx2_txschq_config(pf, lvl);
+		err = otx2_txschq_config(pf, lvl, 0, false);
+		if (err) {
+			mutex_unlock(&mbox->lock);
+			goto err_free_nix_queues;
+		}
+	}
+
+#ifdef CONFIG_DCB
+	if (pf->pfc_en) {
+		err = otx2_pfc_txschq_config(pf);
 		if (err) {
 			mutex_unlock(&mbox->lock);
 			goto err_free_nix_queues;
 		}
 	}
+#endif
+
 	mutex_unlock(&mbox->lock);
 	return err;
 
@@ -1455,6 +1477,11 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	if (err)
 		dev_err(pf->dev, "RVUPF: Failed to stop/free TX schedulers\n");
 
+#ifdef CONFIG_DCB
+	if (pf->pfc_en)
+		otx2_pfc_txschq_stop(pf);
+#endif
+
 	mutex_lock(&mbox->lock);
 	/* Disable backpressure */
 	if (!(pf->pcifunc & RVU_PFVF_FUNC_MASK))
@@ -1853,6 +1880,32 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
+static u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
+			     struct net_device *sb_dev)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+#ifdef CONFIG_DCB
+	u8 vlan_prio;
+#endif
+	int txq;
+
+#ifdef CONFIG_DCB
+	if (!skb->vlan_present)
+		goto pick_tx;
+
+	vlan_prio = skb->vlan_tci >> 13;
+	if ((vlan_prio > pf->hw.tx_queues - 1) ||
+	    !pf->pfc_alloc_status[vlan_prio])
+		goto pick_tx;
+
+	return vlan_prio;
+
+pick_tx:
+#endif
+	txq = netdev_pick_tx(netdev, skb, NULL);
+	return txq;
+}
+
 static netdev_features_t otx2_fix_features(struct net_device *dev,
 					   netdev_features_t features)
 {
@@ -2447,6 +2500,7 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_open		= otx2_open,
 	.ndo_stop		= otx2_stop,
 	.ndo_start_xmit		= otx2_xmit,
+	.ndo_select_queue	= otx2_select_queue,
 	.ndo_fix_features	= otx2_fix_features,
 	.ndo_set_mac_address    = otx2_set_mac_address,
 	.ndo_change_mtu		= otx2_change_mtu,
-- 
2.25.1

