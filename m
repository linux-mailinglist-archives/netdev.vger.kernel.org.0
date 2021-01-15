Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859AC2F768A
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 11:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbhAOKWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 05:22:18 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:12591 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbhAOKWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 05:22:16 -0500
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 10FALKti011003;
        Fri, 15 Jan 2021 02:21:21 -0800
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, rajur@chelsio.com
Subject: [PATCH net-next] cxgb4: enable interrupt based Tx completions for T5
Date:   Fri, 15 Jan 2021 15:50:59 +0530
Message-Id: <20210115102059.6846-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable interrupt based Tx completions to improve latency for T5.
The consumer index (CIDX) will now come via interrupts so that Tx
SKBs can be freed up sooner in Rx path. Also, enforce CIDX flush
threshold override (CIDXFTHRESHO) to improve latency for slow
traffic. This ensures that the interrupt is generated immediately
whenever hardware catches up with driver (i.e. CIDX == PIDX is
reached), which is often the case for slow traffic.

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 38 +++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 196652a114c5..550cc065649f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1600,7 +1600,8 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 		 * has opened up.
 		 */
 		eth_txq_stop(q);
-		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+		if (chip_ver > CHELSIO_T5)
+			wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
 	}
 
 	wr = (void *)&q->q.desc[q->q.pidx];
@@ -1832,6 +1833,7 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 	struct adapter *adapter;
 	int qidx, credits, ret;
 	size_t fw_hdr_copy_len;
+	unsigned int chip_ver;
 	u64 cntrl, *end;
 	u32 wr_mid;
 
@@ -1896,6 +1898,7 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 		goto out_free;
 	}
 
+	chip_ver = CHELSIO_CHIP_VERSION(adapter->params.chip);
 	wr_mid = FW_WR_LEN16_V(DIV_ROUND_UP(flits, 2));
 	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
 		/* After we're done injecting the Work Request for this
@@ -1907,7 +1910,8 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 		 * has opened up.
 		 */
 		eth_txq_stop(txq);
-		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+		if (chip_ver > CHELSIO_T5)
+			wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
 	}
 
 	/* Start filling in our Work Request.  Note that we do _not_ handle
@@ -1960,7 +1964,7 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 		 */
 		cpl = (void *)(lso + 1);
 
-		if (CHELSIO_CHIP_VERSION(adapter->params.chip) <= CHELSIO_T5)
+		if (chip_ver <= CHELSIO_T5)
 			cntrl = TXPKT_ETHHDR_LEN_V(eth_xtra_len);
 		else
 			cntrl = T6_TXPKT_ETHHDR_LEN_V(eth_xtra_len);
@@ -3598,6 +3602,25 @@ static void t4_tx_completion_handler(struct sge_rspq *rspq,
 	}
 
 	txq = &s->ethtxq[pi->first_qset + rspq->idx];
+
+	/* We've got the Hardware Consumer Index Update in the Egress Update
+	 * message. These Egress Update messages will be our sole CIDX Updates
+	 * we get since we don't want to chew up PCIe bandwidth for both Ingress
+	 * Messages and Status Page writes.  However, The code which manages
+	 * reclaiming successfully DMA'ed TX Work Requests uses the CIDX value
+	 * stored in the Status Page at the end of the TX Queue.  It's easiest
+	 * to simply copy the CIDX Update value from the Egress Update message
+	 * to the Status Page.  Also note that no Endian issues need to be
+	 * considered here since both are Big Endian and we're just copying
+	 * bytes consistently ...
+	 */
+	if (CHELSIO_CHIP_VERSION(adapter->params.chip) <= CHELSIO_T5) {
+		struct cpl_sge_egr_update *egr;
+
+		egr = (struct cpl_sge_egr_update *)rsp;
+		WRITE_ONCE(txq->q.stat->cidx, egr->cidx);
+	}
+
 	t4_sge_eth_txq_egress_update(adapter, txq, -1);
 }
 
@@ -4583,11 +4606,15 @@ int t4_sge_alloc_eth_txq(struct adapter *adap, struct sge_eth_txq *txq,
 	 * write the CIDX Updates into the Status Page at the end of the
 	 * TX Queue.
 	 */
-	c.autoequiqe_to_viid = htonl(FW_EQ_ETH_CMD_AUTOEQUEQE_F |
+	c.autoequiqe_to_viid = htonl(((chip_ver <= CHELSIO_T5) ?
+				      FW_EQ_ETH_CMD_AUTOEQUIQE_F :
+				      FW_EQ_ETH_CMD_AUTOEQUEQE_F) |
 				     FW_EQ_ETH_CMD_VIID_V(pi->viid));
 
 	c.fetchszm_to_iqid =
-		htonl(FW_EQ_ETH_CMD_HOSTFCMODE_V(HOSTFCMODE_STATUS_PAGE_X) |
+		htonl(FW_EQ_ETH_CMD_HOSTFCMODE_V((chip_ver <= CHELSIO_T5) ?
+						 HOSTFCMODE_INGRESS_QUEUE_X :
+						 HOSTFCMODE_STATUS_PAGE_X) |
 		      FW_EQ_ETH_CMD_PCIECHN_V(pi->tx_chan) |
 		      FW_EQ_ETH_CMD_FETCHRO_F | FW_EQ_ETH_CMD_IQID_V(iqid));
 
@@ -4598,6 +4625,7 @@ int t4_sge_alloc_eth_txq(struct adapter *adap, struct sge_eth_txq *txq,
 					    : FETCHBURSTMIN_64B_T6_X) |
 		      FW_EQ_ETH_CMD_FBMAX_V(FETCHBURSTMAX_512B_X) |
 		      FW_EQ_ETH_CMD_CIDXFTHRESH_V(CIDXFLUSHTHRESH_32_X) |
+		      FW_EQ_ETH_CMD_CIDXFTHRESHO_V(chip_ver == CHELSIO_T5) |
 		      FW_EQ_ETH_CMD_EQSIZE_V(nentries));
 
 	c.eqaddr = cpu_to_be64(txq->q.phys_addr);
-- 
2.9.5

