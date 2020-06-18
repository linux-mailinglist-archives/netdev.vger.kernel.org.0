Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DBF1FEAB9
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgFRFOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:25338 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgFRFOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:02 -0400
IronPort-SDR: iHYsr1u5ecBtzaR1CT7A1+2hVsfWh/TsvgxIjXHvtp360KrjqSdvLa1lHJ0OFg8GMNMBIDVmqV
 eYJxUEksHYxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="142378057"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="142378057"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:52 -0700
IronPort-SDR: mhu7sBS7ffePvqZb4DZ4jXU46xUZU5L1BDzpusiC/dH3J4sMaMLEu1At03NPfDQIe1fnMyNkMA
 keteJcPtNPnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495606"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/15] iecm: Deinit vport
Date:   Wed, 17 Jun 2020 22:13:39 -0700
Message-Id: <20200618051344.516587-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Implement vport take down and release its queue
resources.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iecm/iecm_lib.c    |  29 ++-
 drivers/net/ethernet/intel/iecm/iecm_txrx.c   | 218 ++++++++++++++++--
 .../net/ethernet/intel/iecm/iecm_virtchnl.c   |  15 +-
 3 files changed, 246 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c b/drivers/net/ethernet/intel/iecm/iecm_lib.c
index d855d6238740..707520553912 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_lib.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_lib.c
@@ -366,7 +366,27 @@ struct iecm_adapter *iecm_netdev_to_adapter(struct net_device *netdev)
  */
 static void iecm_vport_stop(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+
+	if (adapter->state <= __IECM_DOWN)
+		return;
+	adapter->dev_ops.vc_ops.irq_map_unmap(vport, false);
+	adapter->dev_ops.vc_ops.disable_queues(vport);
+	/* Normally we ask for queues in create_vport, but if we're changing
+	 * number of requested queues we do a delete then add instead of
+	 * deleting and reallocating the vport.
+	 */
+	if (test_and_clear_bit(__IECM_DEL_QUEUES,
+			       vport->adapter->flags))
+		iecm_send_delete_queues_msg(vport);
+	netif_carrier_off(vport->netdev);
+	netif_tx_disable(vport->netdev);
+	adapter->link_up = false;
+	iecm_vport_intr_deinit(vport);
+	iecm_vport_queues_rel(vport);
+	if (adapter->dev_ops.vc_ops.disable_vport)
+		adapter->dev_ops.vc_ops.disable_vport(vport);
+	adapter->state = __IECM_DOWN;
 }
 
 /**
@@ -381,7 +401,11 @@ static void iecm_vport_stop(struct iecm_vport *vport)
  */
 static int iecm_stop(struct net_device *netdev)
 {
-	/* stub */
+	struct iecm_netdev_priv *np = netdev_priv(netdev);
+
+	iecm_vport_stop(np->vport);
+
+	return 0;
 }
 
 /**
@@ -488,6 +512,7 @@ iecm_vport_alloc(struct iecm_adapter *adapter, int vport_id)
 
 	/* fill vport slot in the adapter struct */
 	adapter->vports[adapter->next_vport] = vport;
+
 	if (iecm_cfg_netdev(vport))
 		goto cfg_netdev_fail;
 
diff --git a/drivers/net/ethernet/intel/iecm/iecm_txrx.c b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
index 16fea9ad6545..92dc25c10a6c 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_txrx.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
@@ -41,7 +41,23 @@ void iecm_get_stats64(struct net_device *netdev,
  */
 void iecm_tx_buf_rel(struct iecm_queue *tx_q, struct iecm_tx_buf *tx_buf)
 {
-	/* stub */
+	if (tx_buf->skb) {
+		dev_kfree_skb_any(tx_buf->skb);
+		if (dma_unmap_len(tx_buf, len))
+			dma_unmap_single(tx_q->dev,
+					 dma_unmap_addr(tx_buf, dma),
+					 dma_unmap_len(tx_buf, len),
+					 DMA_TO_DEVICE);
+	} else if (dma_unmap_len(tx_buf, len)) {
+		dma_unmap_page(tx_q->dev,
+			       dma_unmap_addr(tx_buf, dma),
+			       dma_unmap_len(tx_buf, len),
+			       DMA_TO_DEVICE);
+	}
+
+	tx_buf->next_to_watch = NULL;
+	tx_buf->skb = NULL;
+	dma_unmap_len_set(tx_buf, len, 0);
 }
 
 /**
@@ -50,7 +66,26 @@ void iecm_tx_buf_rel(struct iecm_queue *tx_q, struct iecm_tx_buf *tx_buf)
  */
 void iecm_tx_buf_rel_all(struct iecm_queue *txq)
 {
-	/* stub */
+	u16 i;
+
+	/* Buffers already cleared, nothing to do */
+	if (!txq->tx_buf)
+		return;
+
+	/* Free all the Tx buffer sk_buffs */
+	for (i = 0; i < txq->desc_count; i++)
+		iecm_tx_buf_rel(txq, &txq->tx_buf[i]);
+
+	kfree(txq->tx_buf);
+	txq->tx_buf = NULL;
+
+	if (txq->buf_stack.bufs) {
+		for (i = 0; i < txq->buf_stack.size; i++) {
+			iecm_tx_buf_rel(txq, txq->buf_stack.bufs[i]);
+			kfree(txq->buf_stack.bufs[i]);
+		}
+		kfree(txq->buf_stack.bufs);
+	}
 }
 
 /**
@@ -62,7 +97,17 @@ void iecm_tx_buf_rel_all(struct iecm_queue *txq)
  */
 void iecm_tx_desc_rel(struct iecm_queue *txq, bool bufq)
 {
-	/* stub */
+	if (bufq)
+		iecm_tx_buf_rel_all(txq);
+
+	if (txq->desc_ring) {
+		dmam_free_coherent(txq->dev, txq->size,
+				   txq->desc_ring, txq->dma);
+		txq->desc_ring = NULL;
+		txq->next_to_alloc = 0;
+		txq->next_to_use = 0;
+		txq->next_to_clean = 0;
+	}
 }
 
 /**
@@ -73,7 +118,24 @@ void iecm_tx_desc_rel(struct iecm_queue *txq, bool bufq)
  */
 void iecm_tx_desc_rel_all(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_queue *txq;
+	int i, j;
+
+	if (!vport->txq_grps)
+		return;
+
+	for (i = 0; i < vport->num_txq_grp; i++) {
+		for (j = 0; j < vport->txq_grps[i].num_txq; j++) {
+			if (vport->txq_grps[i].txqs) {
+				txq = &vport->txq_grps[i].txqs[j];
+				iecm_tx_desc_rel(txq, true);
+			}
+		}
+		if (iecm_is_queue_model_split(vport->txq_model)) {
+			txq = vport->txq_grps[i].complq;
+			iecm_tx_desc_rel(txq, false);
+		}
+	}
 }
 
 /**
@@ -209,7 +271,21 @@ static enum iecm_status iecm_tx_desc_alloc_all(struct iecm_vport *vport)
 static void iecm_rx_buf_rel(struct iecm_queue *rxq,
 			    struct iecm_rx_buf *rx_buf)
 {
-	/* stub */
+	struct device *dev = rxq->dev;
+
+	if (!rx_buf->page)
+		return;
+
+	if (rx_buf->skb) {
+		dev_kfree_skb_any(rx_buf->skb);
+		rx_buf->skb = NULL;
+	}
+
+	dma_unmap_page(dev, rx_buf->dma, PAGE_SIZE, DMA_FROM_DEVICE);
+	__free_pages(rx_buf->page, 0);
+
+	rx_buf->page = NULL;
+	rx_buf->page_offset = 0;
 }
 
 /**
@@ -218,7 +294,23 @@ static void iecm_rx_buf_rel(struct iecm_queue *rxq,
  */
 void iecm_rx_buf_rel_all(struct iecm_queue *rxq)
 {
-	/* stub */
+	u16 i;
+
+	/* queue already cleared, nothing to do */
+	if (!rxq->rx_buf.buf)
+		return;
+
+	/* Free all the bufs allocated and given to HW on Rx queue */
+	for (i = 0; i < rxq->desc_count; i++) {
+		iecm_rx_buf_rel(rxq, &rxq->rx_buf.buf[i]);
+		if (rxq->rx_hsplit_en)
+			iecm_rx_buf_rel(rxq, &rxq->rx_buf.hdr_buf[i]);
+	}
+
+	kfree(rxq->rx_buf.buf);
+	rxq->rx_buf.buf = NULL;
+	kfree(rxq->rx_buf.hdr_buf);
+	rxq->rx_buf.hdr_buf = NULL;
 }
 
 /**
@@ -232,7 +324,25 @@ void iecm_rx_buf_rel_all(struct iecm_queue *rxq)
 void iecm_rx_desc_rel(struct iecm_queue *rxq, bool bufq,
 		      enum virtchnl_queue_model q_model)
 {
-	/* stub */
+	if (!rxq)
+		return;
+
+	if (!bufq && iecm_is_queue_model_split(q_model) && rxq->skb) {
+		dev_kfree_skb_any(rxq->skb);
+		rxq->skb = NULL;
+	}
+
+	if (bufq || !iecm_is_queue_model_split(q_model))
+		iecm_rx_buf_rel_all(rxq);
+
+	if (rxq->desc_ring) {
+		dmam_free_coherent(rxq->dev, rxq->size,
+				   rxq->desc_ring, rxq->dma);
+		rxq->desc_ring = NULL;
+		rxq->next_to_alloc = 0;
+		rxq->next_to_clean = 0;
+		rxq->next_to_use = 0;
+	}
 }
 
 /**
@@ -243,7 +353,49 @@ void iecm_rx_desc_rel(struct iecm_queue *rxq, bool bufq,
  */
 void iecm_rx_desc_rel_all(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_rxq_group *rx_qgrp;
+	struct iecm_queue *q;
+	int i, j, num_rxq;
+
+	if (!vport->rxq_grps)
+		return;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		rx_qgrp = &vport->rxq_grps[i];
+
+		if (iecm_is_queue_model_split(vport->rxq_model)) {
+			if (rx_qgrp->splitq.rxq_sets) {
+				num_rxq = rx_qgrp->splitq.num_rxq_sets;
+				for (j = 0; j < num_rxq; j++) {
+					q = &rx_qgrp->splitq.rxq_sets[j].rxq;
+					iecm_rx_desc_rel(q, false,
+							 vport->rxq_model);
+				}
+			}
+
+			if (!rx_qgrp->splitq.bufq_sets)
+				continue;
+			for (j = 0; j < IECM_BUFQS_PER_RXQ_SET; j++) {
+				struct iecm_bufq_set *bufq_set =
+					&rx_qgrp->splitq.bufq_sets[j];
+
+				q = &bufq_set->bufq;
+				iecm_rx_desc_rel(q, true, vport->rxq_model);
+				if (!bufq_set->refillqs)
+					continue;
+				kfree(bufq_set->refillqs);
+				bufq_set->refillqs = NULL;
+			}
+		} else {
+			if (rx_qgrp->singleq.rxqs) {
+				for (j = 0; j < rx_qgrp->singleq.num_rxq; j++) {
+					q = &rx_qgrp->singleq.rxqs[j];
+					iecm_rx_desc_rel(q, false,
+							 vport->rxq_model);
+				}
+			}
+		}
+	}
 }
 
 /**
@@ -570,7 +722,18 @@ static enum iecm_status iecm_rx_desc_alloc_all(struct iecm_vport *vport)
  */
 static void iecm_txq_group_rel(struct iecm_vport *vport)
 {
-	/* stub */
+	if (vport->txq_grps) {
+		int i;
+
+		for (i = 0; i < vport->num_txq_grp; i++) {
+			kfree(vport->txq_grps[i].txqs);
+			vport->txq_grps[i].txqs = NULL;
+			kfree(vport->txq_grps[i].complq);
+			vport->txq_grps[i].complq = NULL;
+		}
+		kfree(vport->txq_grps);
+		vport->txq_grps = NULL;
+	}
 }
 
 /**
@@ -579,7 +742,25 @@ static void iecm_txq_group_rel(struct iecm_vport *vport)
  */
 static void iecm_rxq_group_rel(struct iecm_vport *vport)
 {
-	/* stub */
+	if (vport->rxq_grps) {
+		int i;
+
+		for (i = 0; i < vport->num_rxq_grp; i++) {
+			struct iecm_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+
+			if (iecm_is_queue_model_split(vport->rxq_model)) {
+				kfree(rx_qgrp->splitq.rxq_sets);
+				rx_qgrp->splitq.rxq_sets = NULL;
+				kfree(rx_qgrp->splitq.bufq_sets);
+				rx_qgrp->splitq.bufq_sets = NULL;
+			} else {
+				kfree(rx_qgrp->singleq.rxqs);
+				vport->rxq_grps[i].singleq.rxqs = NULL;
+			}
+		}
+		kfree(vport->rxq_grps);
+		vport->rxq_grps = NULL;
+	}
 }
 
 /**
@@ -588,7 +769,8 @@ static void iecm_rxq_group_rel(struct iecm_vport *vport)
  */
 static void iecm_vport_queue_grp_rel_all(struct iecm_vport *vport)
 {
-	/* stub */
+	iecm_txq_group_rel(vport);
+	iecm_rxq_group_rel(vport);
 }
 
 /**
@@ -599,7 +781,12 @@ static void iecm_vport_queue_grp_rel_all(struct iecm_vport *vport)
  */
 void iecm_vport_queues_rel(struct iecm_vport *vport)
 {
-	/* stub */
+	iecm_tx_desc_rel_all(vport);
+	iecm_rx_desc_rel_all(vport);
+	iecm_vport_queue_grp_rel_all(vport);
+
+	kfree(vport->txqs);
+	vport->txqs = NULL;
 }
 
 /**
@@ -2577,5 +2764,10 @@ int iecm_init_rss(struct iecm_vport *vport)
  */
 void iecm_deinit_rss(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+
+	kfree(adapter->rss_data.rss_key);
+	adapter->rss_data.rss_key = NULL;
+	kfree(adapter->rss_data.rss_lut);
+	adapter->rss_data.rss_lut = NULL;
 }
diff --git a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
index d56f8126521a..2aeeb8ca10af 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_virtchnl.c
@@ -689,7 +689,20 @@ iecm_send_enable_vport_msg(struct iecm_vport *vport)
 enum iecm_status
 iecm_send_disable_vport_msg(struct iecm_vport *vport)
 {
-	/* stub */
+	struct iecm_adapter *adapter = vport->adapter;
+	struct virtchnl_vport v_id;
+	enum iecm_status err;
+
+	v_id.vport_id = vport->vport_id;
+
+	err = iecm_send_mb_msg(adapter, VIRTCHNL_OP_DISABLE_VPORT,
+			       sizeof(v_id), (u8 *)&v_id);
+
+	if (!err)
+		err = iecm_wait_for_event(adapter, IECM_VC_DIS_VPORT,
+					  IECM_VC_DIS_VPORT_ERR);
+
+	return err;
 }
 
 /**
-- 
2.26.2

