Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B8E4FF0BE
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 09:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiDMHpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiDMHpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:45:22 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67B863E7
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 00:43:01 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23CNGbqB018340;
        Wed, 13 Apr 2022 00:43:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=9a5EFX5nKjGPFEa2mic8iqvfFOvzUrppoTrSDLw5phE=;
 b=Ze2PLi1d3dvu1OTaV6vF9Bi3inILdHDx91AfbQCov9jIRQqqtUAp4n2+wovijhZNsZOI
 ejggmNdNWnVMSuBAnzzMqmjDWXKu+58yeIww9lcJrJl7m+hlzM4bdjxS22Oq7Cz6ImIy
 g7F3Mom0lovpPEa527uLAAErBrW5nWszXY9z8n/yWVwO5xcfTBVWz5DPO88OE6jltGOD
 wgRb3MzIz+5evv0NCYv182OG9pDHa9lA/kv6oLx7sDkDKPO2ByLUdcyLitK+auao3Io9
 NHD0RThAjhGpOzYvHP7eDIP4DlBIRd4O7CxmMK1cN3Skbl6PSX1EUp4jt4mzZe0wtD4v yg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3fdjxysmys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 00:42:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 13 Apr
 2022 00:42:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 13 Apr 2022 00:42:57 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 1479D3F7045;
        Wed, 13 Apr 2022 00:42:54 -0700 (PDT)
From:   Suman Ghosh <sumang@marvell.com>
To:     <davem@davemloft.net>, <sgoutham@marvell.com>,
        <hkelam@marvell.com>, <sbhatta@marvell.com>, <naveenm@marvell.com>,
        <rsaladi2@marvell.com>, <gakula@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Suman Ghosh <sumang@marvell.com>
Subject: [PATCH] octeontx2-pf: Add support for adaptive interrupt coalescing
Date:   Wed, 13 Apr 2022 13:12:46 +0530
Message-ID: <20220413074246.119468-1-sumang@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: pu67QOTGABRw5zX0DjOLg8garqvmAf27
X-Proofpoint-ORIG-GUID: pu67QOTGABRw5zX0DjOLg8garqvmAf27
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_08,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for adaptive IRQ coalescing. It uses net_dim
algorithm to find the suitable delay/IRQ count based on the
current packet rate.

Signed-off-by: Suman Ghosh <sumang@marvell.com>
Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/Kconfig    |  1 +
 .../marvell/octeontx2/nic/otx2_common.c       |  5 ---
 .../marvell/octeontx2/nic/otx2_common.h       | 10 +++++
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 43 ++++++++++++++++---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 22 ++++++++++
 .../marvell/octeontx2/nic/otx2_txrx.c         | 28 ++++++++++++
 .../marvell/octeontx2/nic/otx2_txrx.h         |  1 +
 7 files changed, 99 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index 8560f7e463d3..a544733152d8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -30,6 +30,7 @@ config OCTEONTX2_PF
 	tristate "Marvell OcteonTX2 NIC Physical Function driver"
 	select OCTEONTX2_MBOX
 	select NET_DEVLINK
+	select DIMLIB
 	depends on PCI
 	help
 	  This driver supports Marvell's OcteonTX2 Resource Virtualization
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 033fd79d35b0..c28850d815c2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -103,11 +103,6 @@ void otx2_get_dev_stats(struct otx2_nic *pfvf)
 {
 	struct otx2_dev_stats *dev_stats = &pfvf->hw.dev_stats;
 
-#define OTX2_GET_RX_STATS(reg) \
-	 otx2_read64(pfvf, NIX_LF_RX_STATX(reg))
-#define OTX2_GET_TX_STATS(reg) \
-	 otx2_read64(pfvf, NIX_LF_TX_STATX(reg))
-
 	dev_stats->rx_bytes = OTX2_GET_RX_STATS(RX_OCTS);
 	dev_stats->rx_drops = OTX2_GET_RX_STATS(RX_DROP);
 	dev_stats->rx_bcast_frames = OTX2_GET_RX_STATS(RX_BCAST);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index d9f4b085b2a4..6abf5c28921f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -16,6 +16,7 @@
 #include <net/pkt_cls.h>
 #include <net/devlink.h>
 #include <linux/time64.h>
+#include <linux/dim.h>
 
 #include <mbox.h>
 #include <npc.h>
@@ -54,6 +55,11 @@ enum arua_mapped_qtypes {
 /* Send skid of 2000 packets required for CQ size of 4K CQEs. */
 #define SEND_CQ_SKID	2000
 
+#define OTX2_GET_RX_STATS(reg) \
+	 otx2_read64(pfvf, NIX_LF_RX_STATX(reg))
+#define OTX2_GET_TX_STATS(reg) \
+	 otx2_read64(pfvf, NIX_LF_TX_STATX(reg))
+
 struct otx2_lmt_info {
 	u64 lmt_addr;
 	u16 lmt_id;
@@ -363,6 +369,7 @@ struct otx2_nic {
 #define OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED	BIT_ULL(13)
 #define OTX2_FLAG_DMACFLTR_SUPPORT		BIT_ULL(14)
 #define OTX2_FLAG_PTP_ONESTEP_SYNC		BIT_ULL(15)
+#define OTX2_FLAG_ADPTV_INT_COAL_ENABLED	BIT_ULL(16)
 	u64			flags;
 	u64			*cq_op_addr;
 
@@ -442,6 +449,9 @@ struct otx2_nic {
 #endif
 	/* qos */
 	struct otx2_qos		qos;
+
+	/* napi event count. It is needed for adaptive irq coalescing */
+	u32 napi_events;
 };
 
 static inline bool is_otx2_lbkvf(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 72d0b02da3cc..8ed282991f05 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -477,6 +477,14 @@ static int otx2_get_coalesce(struct net_device *netdev,
 	cmd->rx_max_coalesced_frames = hw->cq_ecount_wait;
 	cmd->tx_coalesce_usecs = hw->cq_time_wait;
 	cmd->tx_max_coalesced_frames = hw->cq_ecount_wait;
+	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) ==
+		OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
+		cmd->use_adaptive_rx_coalesce = 1;
+		cmd->use_adaptive_tx_coalesce = 1;
+	} else {
+		cmd->use_adaptive_rx_coalesce = 0;
+		cmd->use_adaptive_tx_coalesce = 0;
+	}
 
 	return 0;
 }
@@ -486,10 +494,10 @@ static int otx2_set_coalesce(struct net_device *netdev,
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct otx2_hw *hw = &pfvf->hw;
+	u8 priv_coalesce_status;
 	int qidx;
 
-	if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce ||
-	    ec->rx_coalesce_usecs_irq || ec->rx_max_coalesced_frames_irq ||
+	if (ec->rx_coalesce_usecs_irq || ec->rx_max_coalesced_frames_irq ||
 	    ec->tx_coalesce_usecs_irq || ec->tx_max_coalesced_frames_irq ||
 	    ec->stats_block_coalesce_usecs || ec->pkt_rate_low ||
 	    ec->rx_coalesce_usecs_low || ec->rx_max_coalesced_frames_low ||
@@ -502,6 +510,18 @@ static int otx2_set_coalesce(struct net_device *netdev,
 	if (!ec->rx_max_coalesced_frames || !ec->tx_max_coalesced_frames)
 		return 0;
 
+	/* Check and update coalesce status */
+	if ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) ==
+	    OTX2_FLAG_ADPTV_INT_COAL_ENABLED) {
+		priv_coalesce_status = 1;
+		if (!ec->use_adaptive_rx_coalesce || !ec->use_adaptive_tx_coalesce)
+			pfvf->flags &= ~OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
+	} else {
+		priv_coalesce_status = 0;
+		if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce)
+			pfvf->flags |= OTX2_FLAG_ADPTV_INT_COAL_ENABLED;
+	}
+
 	/* 'cq_time_wait' is 8bit and is in multiple of 100ns,
 	 * so clamp the user given value to the range of 1 to 25usec.
 	 */
@@ -521,13 +541,13 @@ static int otx2_set_coalesce(struct net_device *netdev,
 		hw->cq_time_wait = min_t(u8, ec->rx_coalesce_usecs,
 					 ec->tx_coalesce_usecs);
 
-	/* Max ecount_wait supported is 16bit,
-	 * so clamp the user given value to the range of 1 to 64k.
+	/* Max packet budget per napi is 64,
+	 * so clamp the user given value to the range of 1 to 64.
 	 */
 	ec->rx_max_coalesced_frames = clamp_t(u32, ec->rx_max_coalesced_frames,
-					      1, U16_MAX);
+					      1, NAPI_POLL_WEIGHT);
 	ec->tx_max_coalesced_frames = clamp_t(u32, ec->tx_max_coalesced_frames,
-					      1, U16_MAX);
+					      1, NAPI_POLL_WEIGHT);
 
 	/* Rx and Tx are mapped to same CQ, check which one
 	 * is changed, if both then choose the min.
@@ -540,6 +560,17 @@ static int otx2_set_coalesce(struct net_device *netdev,
 		hw->cq_ecount_wait = min_t(u16, ec->rx_max_coalesced_frames,
 					   ec->tx_max_coalesced_frames);
 
+	/* Reset 'cq_time_wait' and 'cq_ecount_wait' to
+	 * default values if coalesce status changed from
+	 * 'on' to 'off'.
+	 */
+	if (priv_coalesce_status &&
+	    ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) !=
+	    OTX2_FLAG_ADPTV_INT_COAL_ENABLED)) {
+		hw->cq_time_wait = CQ_TIMER_THRESH_DEFAULT;
+		hw->cq_ecount_wait = CQ_CQE_THRESH_DEFAULT;
+	}
+
 	if (netif_running(netdev)) {
 		for (qidx = 0; qidx < pfvf->hw.cint_cnt; qidx++)
 			otx2_config_irq_coalescing(pfvf, qidx);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index f18c9a9a50d0..94aaafbeb365 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1279,6 +1279,7 @@ static irqreturn_t otx2_cq_intr_handler(int irq, void *cq_irq)
 	otx2_write64(pf, NIX_LF_CINTX_ENA_W1C(qidx), BIT_ULL(0));
 
 	/* Schedule NAPI */
+	pf->napi_events++;
 	napi_schedule_irqoff(&cq_poll->napi);
 
 	return IRQ_HANDLED;
@@ -1292,6 +1293,7 @@ static void otx2_disable_napi(struct otx2_nic *pf)
 
 	for (qidx = 0; qidx < pf->hw.cint_cnt; qidx++) {
 		cq_poll = &qset->napi[qidx];
+		cancel_work_sync(&cq_poll->dim.work);
 		napi_disable(&cq_poll->napi);
 		netif_napi_del(&cq_poll->napi);
 	}
@@ -1538,6 +1540,24 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	mutex_unlock(&mbox->lock);
 }
 
+static void otx2_dim_work(struct work_struct *w)
+{
+	struct dim_cq_moder cur_moder;
+	struct otx2_cq_poll *cq_poll;
+	struct otx2_nic *pfvf;
+	struct dim *dim;
+
+	dim = container_of(w, struct dim, work);
+	cur_moder = net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
+	cq_poll = container_of(dim, struct otx2_cq_poll, dim);
+	pfvf = (struct otx2_nic *)cq_poll->dev;
+	pfvf->hw.cq_time_wait = (cur_moder.usec > CQ_TIMER_THRESH_MAX) ?
+				CQ_TIMER_THRESH_MAX : cur_moder.usec;
+	pfvf->hw.cq_ecount_wait = (cur_moder.pkts > NAPI_POLL_WEIGHT) ?
+				NAPI_POLL_WEIGHT : cur_moder.pkts;
+	dim->state = DIM_START_MEASURE;
+}
+
 int otx2_open(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
@@ -1611,6 +1631,8 @@ int otx2_open(struct net_device *netdev)
 					  CINT_INVALID_CQ;
 
 		cq_poll->dev = (void *)pf;
+		cq_poll->dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_CQE;
+		INIT_WORK(&cq_poll->dim.work, otx2_dim_work);
 		netif_napi_add(netdev, &cq_poll->napi,
 			       otx2_napi_handler, NAPI_POLL_WEIGHT);
 		napi_enable(&cq_poll->napi);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 459b94b99ddb..927dd12b4f4e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -512,6 +512,22 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 	return 0;
 }
 
+static void otx2_adjust_adaptive_coalese(struct otx2_nic *pfvf, struct otx2_cq_poll *cq_poll)
+{
+	struct dim_sample dim_sample;
+	u64 rx_frames, rx_bytes;
+
+	rx_frames = OTX2_GET_RX_STATS(RX_BCAST) + OTX2_GET_RX_STATS(RX_MCAST) +
+			OTX2_GET_RX_STATS(RX_UCAST);
+	rx_bytes = OTX2_GET_RX_STATS(RX_OCTS);
+	dim_update_sample(pfvf->napi_events,
+			  rx_frames,
+			  rx_bytes,
+			  &dim_sample);
+
+	net_dim(&cq_poll->dim, dim_sample);
+}
+
 int otx2_napi_handler(struct napi_struct *napi, int budget)
 {
 	struct otx2_cq_queue *rx_cq = NULL;
@@ -549,6 +565,18 @@ int otx2_napi_handler(struct napi_struct *napi, int budget)
 		if (pfvf->flags & OTX2_FLAG_INTF_DOWN)
 			return workdone;
 
+		/* Check for adaptive interrupt coalesce */
+		if (workdone != 0 &&
+		    ((pfvf->flags & OTX2_FLAG_ADPTV_INT_COAL_ENABLED) ==
+		    OTX2_FLAG_ADPTV_INT_COAL_ENABLED)) {
+			/* Adjust irq coalese using net_dim */
+			otx2_adjust_adaptive_coalese(pfvf, cq_poll);
+
+			/* Update irq coalescing */
+			for (i = 0; i < pfvf->hw.cint_cnt; i++)
+				otx2_config_irq_coalescing(pfvf, i);
+		}
+
 		/* Re-enable interrupts */
 		otx2_write64(pfvf, NIX_LF_CINTX_ENA_W1S(cq_poll->cint_idx),
 			     BIT_ULL(0));
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index a2ac2b3bdbf5..ed41a68d3ec6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -107,6 +107,7 @@ struct otx2_cq_poll {
 #define CINT_INVALID_CQ		255
 	u8			cint_idx;
 	u8			cq_ids[CQS_PER_CINT];
+	struct dim		dim;
 	struct napi_struct	napi;
 };
 
-- 
2.25.1

