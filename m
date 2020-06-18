Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C371FEABF
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgFRFOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:25340 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgFRFOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:04 -0400
IronPort-SDR: ubD4iiVbJOEDaQAdDU56okGtqlNWoJqVgUhEc/nqgGE5nXXbckAhkhopCO2aPoynTjN3MsZ0BH
 RAJ6m4sww/wA==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="142378059"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="142378059"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:52 -0700
IronPort-SDR: QPUCIy59UnZEGXnxtYTjfVaMqevf4fwfmc878/PS4Ob3GEmVkiABsQ6NVmyHAUgyMeK+AcS3kF
 QnFvWMNMhucA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495612"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:52 -0700
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
Subject: [net-next 11/15] iecm: Add splitq TX/RX
Date:   Wed, 17 Jun 2020 22:13:40 -0700
Message-Id: <20200618051344.516587-12-jeffrey.t.kirsher@intel.com>
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

Implement main TX/RX flows for split queue model.

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
 drivers/net/ethernet/intel/iecm/iecm_txrx.c | 1283 ++++++++++++++++++-
 1 file changed, 1235 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/intel/iecm/iecm_txrx.c b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
index 92dc25c10a6c..071f78858282 100644
--- a/drivers/net/ethernet/intel/iecm/iecm_txrx.c
+++ b/drivers/net/ethernet/intel/iecm/iecm_txrx.c
@@ -11,7 +11,12 @@
 static enum iecm_status iecm_buf_lifo_push(struct iecm_buf_lifo *stack,
 					   struct iecm_tx_buf *buf)
 {
-	/* stub */
+	if (stack->top == stack->size)
+		return IECM_ERR_MAX_LIMIT;
+
+	stack->bufs[stack->top++] = buf;
+
+	return 0;
 }
 
 /**
@@ -20,7 +25,10 @@ static enum iecm_status iecm_buf_lifo_push(struct iecm_buf_lifo *stack,
  **/
 static struct iecm_tx_buf *iecm_buf_lifo_pop(struct iecm_buf_lifo *stack)
 {
-	/* stub */
+	if (!stack->top)
+		return NULL;
+
+	return stack->bufs[--stack->top];
 }
 
 /**
@@ -31,7 +39,16 @@ static struct iecm_tx_buf *iecm_buf_lifo_pop(struct iecm_buf_lifo *stack)
 void iecm_get_stats64(struct net_device *netdev,
 		      struct rtnl_link_stats64 *stats)
 {
-	/* stub */
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+
+	iecm_send_get_stats_msg(vport);
+	stats->rx_packets = vport->netstats.rx_packets;
+	stats->tx_packets = vport->netstats.tx_packets;
+	stats->rx_bytes = vport->netstats.rx_bytes;
+	stats->tx_bytes = vport->netstats.tx_bytes;
+	stats->tx_errors = vport->netstats.tx_errors;
+	stats->rx_dropped = vport->netstats.rx_dropped;
+	stats->tx_dropped = vport->netstats.tx_dropped;
 }
 
 /**
@@ -1246,7 +1263,16 @@ enum iecm_status iecm_vport_queues_alloc(struct iecm_vport *vport)
 static struct iecm_queue *
 iecm_tx_find_q(struct iecm_vport *vport, int q_id)
 {
-	/* stub */
+	int i;
+
+	for (i = 0; i < vport->num_txq; i++) {
+		struct iecm_queue *tx_q = vport->txqs[i];
+
+		if (tx_q->q_id == q_id)
+			return tx_q;
+	}
+
+	return NULL;
 }
 
 /**
@@ -1255,7 +1281,22 @@ iecm_tx_find_q(struct iecm_vport *vport, int q_id)
  */
 static void iecm_tx_handle_sw_marker(struct iecm_queue *tx_q)
 {
-	/* stub */
+	struct iecm_vport *vport = tx_q->vport;
+	bool drain_complete = true;
+	int i;
+
+	clear_bit(__IECM_Q_SW_MARKER, tx_q->flags);
+	/* Hardware must write marker packets to all queues associated with
+	 * completion queues. So check if all queues received marker packets
+	 */
+	for (i = 0; i < vport->num_txq; i++) {
+		if (test_bit(__IECM_Q_SW_MARKER, vport->txqs[i]->flags))
+			drain_complete = false;
+	}
+	if (drain_complete) {
+		set_bit(__IECM_VPORT_SW_MARKER, vport->flags);
+		wake_up(&vport->sw_marker_wq);
+	}
 }
 
 /**
@@ -1270,7 +1311,30 @@ static struct iecm_tx_queue_stats
 iecm_tx_splitq_clean_buf(struct iecm_queue *tx_q, struct iecm_tx_buf *tx_buf,
 			 int napi_budget)
 {
-	/* stub */
+	struct iecm_tx_queue_stats cleaned = {0};
+	struct netdev_queue *nq;
+
+	/* update the statistics for this packet */
+	cleaned.bytes = tx_buf->bytecount;
+	cleaned.packets = tx_buf->gso_segs;
+
+	/* free the skb */
+	napi_consume_skb(tx_buf->skb, napi_budget);
+	nq = netdev_get_tx_queue(tx_q->vport->netdev, tx_q->idx);
+	netdev_tx_completed_queue(nq, cleaned.packets,
+				  cleaned.bytes);
+
+	/* unmap skb header data */
+	dma_unmap_single(tx_q->dev,
+			 dma_unmap_addr(tx_buf, dma),
+			 dma_unmap_len(tx_buf, len),
+			 DMA_TO_DEVICE);
+
+	/* clear tx_buf data */
+	tx_buf->skb = NULL;
+	dma_unmap_len_set(tx_buf, len, 0);
+
+	return cleaned;
 }
 
 /**
@@ -1282,7 +1346,33 @@ iecm_tx_splitq_clean_buf(struct iecm_queue *tx_q, struct iecm_tx_buf *tx_buf,
 static int
 iecm_stash_flow_sch_buffers(struct iecm_queue *txq, struct iecm_tx_buf *tx_buf)
 {
-	/* stub */
+	struct iecm_adapter *adapter = txq->vport->adapter;
+	struct iecm_tx_buf *shadow_buf;
+
+	shadow_buf = iecm_buf_lifo_pop(&txq->buf_stack);
+	if (!shadow_buf) {
+		dev_err(&adapter->pdev->dev,
+			"No out-of-order TX buffers left!\n");
+		return -ENOMEM;
+	}
+
+	/* Store buffer params in shadow buffer */
+	shadow_buf->skb = tx_buf->skb;
+	shadow_buf->bytecount = tx_buf->bytecount;
+	shadow_buf->gso_segs = tx_buf->gso_segs;
+	shadow_buf->dma = tx_buf->dma;
+	shadow_buf->len = tx_buf->len;
+	shadow_buf->compl_tag = tx_buf->compl_tag;
+
+	/* Add buffer to buf_hash table to be freed
+	 * later
+	 */
+	hash_add(txq->sched_buf_hash, &shadow_buf->hlist,
+		 shadow_buf->compl_tag);
+
+	memset(tx_buf, 0, sizeof(struct iecm_tx_buf));
+
+	return 0;
 }
 
 /**
@@ -1305,7 +1395,91 @@ static struct iecm_tx_queue_stats
 iecm_tx_splitq_clean(struct iecm_queue *tx_q, u16 end, int napi_budget,
 		     bool descs_only)
 {
-	/* stub */
+	union iecm_tx_flex_desc *next_pending_desc = NULL;
+	struct iecm_tx_queue_stats cleaned_stats = {0};
+	union iecm_tx_flex_desc *tx_desc;
+	s16 ntc = tx_q->next_to_clean;
+	struct iecm_tx_buf *tx_buf;
+
+	tx_desc = IECM_FLEX_TX_DESC(tx_q, ntc);
+	next_pending_desc = IECM_FLEX_TX_DESC(tx_q, end);
+	tx_buf = &tx_q->tx_buf[ntc];
+	ntc -= tx_q->desc_count;
+
+	while (tx_desc != next_pending_desc) {
+		union iecm_tx_flex_desc *eop_desc =
+			(union iecm_tx_flex_desc *)tx_buf->next_to_watch;
+
+		/* clear next_to_watch to prevent false hangs */
+		tx_buf->next_to_watch = NULL;
+
+		if (descs_only) {
+			if (iecm_stash_flow_sch_buffers(tx_q, tx_buf))
+				goto tx_splitq_clean_out;
+
+			while (tx_desc != eop_desc) {
+				tx_buf++;
+				tx_desc++;
+				ntc++;
+				if (unlikely(!ntc)) {
+					ntc -= tx_q->desc_count;
+					tx_buf = tx_q->tx_buf;
+					tx_desc = IECM_FLEX_TX_DESC(tx_q, 0);
+				}
+
+				if (dma_unmap_len(tx_buf, len)) {
+					if (iecm_stash_flow_sch_buffers(tx_q,
+									tx_buf))
+						goto tx_splitq_clean_out;
+				}
+			}
+		} else {
+			struct iecm_tx_queue_stats buf_stats = {0};
+
+			buf_stats = iecm_tx_splitq_clean_buf(tx_q, tx_buf,
+							     napi_budget);
+
+			/* update the statistics for this packet */
+			cleaned_stats.bytes += buf_stats.bytes;
+			cleaned_stats.packets += buf_stats.packets;
+
+			/* unmap remaining buffers */
+			while (tx_desc != eop_desc) {
+				tx_buf++;
+				tx_desc++;
+				ntc++;
+				if (unlikely(!ntc)) {
+					ntc -= tx_q->desc_count;
+					tx_buf = tx_q->tx_buf;
+					tx_desc = IECM_FLEX_TX_DESC(tx_q, 0);
+				}
+
+				/* unmap any remaining paged data */
+				if (dma_unmap_len(tx_buf, len)) {
+					dma_unmap_page(tx_q->dev,
+						dma_unmap_addr(tx_buf, dma),
+						dma_unmap_len(tx_buf, len),
+						DMA_TO_DEVICE);
+					dma_unmap_len_set(tx_buf, len, 0);
+				}
+			}
+		}
+
+		tx_buf++;
+		tx_desc++;
+		ntc++;
+		if (unlikely(!ntc)) {
+			ntc -= tx_q->desc_count;
+			tx_buf = tx_q->tx_buf;
+			tx_desc = IECM_FLEX_TX_DESC(tx_q, 0);
+		}
+	}
+
+tx_splitq_clean_out:
+	ntc += tx_q->desc_count;
+	tx_q->next_to_clean = ntc;
+
+	return cleaned_stats;
 }
 
 /**
@@ -1315,7 +1489,18 @@ iecm_tx_splitq_clean(struct iecm_queue *tx_q, u16 end, int napi_budget,
  */
 static inline void iecm_tx_hw_tstamp(struct sk_buff *skb, u8 *desc_ts)
 {
-	/* stub */
+	struct skb_shared_hwtstamps hwtstamps;
+	u64 tstamp;
+
+	/* Only report timestamp to stack if requested */
+	if (!likely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		return;
+
+	tstamp = (desc_ts[0] | (desc_ts[1] << 8) | (desc_ts[2] & 0x3F) << 16);
+	hwtstamps.hwtstamp =
+		ns_to_ktime(tstamp << IECM_TW_TIME_STAMP_GRAN_512_DIV_S);
+
+	skb_tstamp_tx(skb, &hwtstamps);
 }
 
 /**
@@ -1330,7 +1515,39 @@ static struct iecm_tx_queue_stats
 iecm_tx_clean_flow_sch_bufs(struct iecm_queue *txq, u16 compl_tag,
 			    u8 *desc_ts, int budget)
 {
-	/* stub */
+	struct iecm_tx_queue_stats cleaned_stats = {0};
+	struct hlist_node *tmp_buf = NULL;
+	struct iecm_tx_buf *tx_buf = NULL;
+
+	/* Buffer completion */
+	hash_for_each_possible_safe(txq->sched_buf_hash, tx_buf, tmp_buf,
+				    hlist, compl_tag) {
+		if (tx_buf->compl_tag != compl_tag)
+			continue;
+
+		if (likely(tx_buf->skb)) {
+			/* fetch timestamp from completion
+			 * descriptor to report to stack
+			 */
+			iecm_tx_hw_tstamp(tx_buf->skb, desc_ts);
+
+			cleaned_stats = iecm_tx_splitq_clean_buf(txq, tx_buf,
+								 budget);
+		} else if (dma_unmap_len(tx_buf, len)) {
+			dma_unmap_page(txq->dev,
+				       dma_unmap_addr(tx_buf, dma),
+				       dma_unmap_len(tx_buf, len),
+				       DMA_TO_DEVICE);
+			dma_unmap_len_set(tx_buf, len, 0);
+		}
+
+		/* Push shadow buf back onto stack */
+		iecm_buf_lifo_push(&txq->buf_stack, tx_buf);
+
+		hash_del(&tx_buf->hlist);
+	}
+
+	return cleaned_stats;
 }
 
 /**
@@ -1343,7 +1560,109 @@ iecm_tx_clean_flow_sch_bufs(struct iecm_queue *txq, u16 compl_tag,
 static bool
 iecm_tx_clean_complq(struct iecm_queue *complq, int budget)
 {
-	/* stub */
+	struct iecm_splitq_tx_compl_desc *tx_desc;
+	struct iecm_vport *vport = complq->vport;
+	s16 ntc = complq->next_to_clean;
+	unsigned int complq_budget;
+
+	complq_budget = vport->compln_clean_budget;
+	tx_desc = IECM_SPLITQ_TX_COMPLQ_DESC(complq, ntc);
+	ntc -= complq->desc_count;
+
+	do {
+		struct iecm_tx_queue_stats cleaned_stats = {0};
+		bool descs_only = false;
+		struct iecm_queue *tx_q;
+		u16 compl_tag, hw_head;
+		int tx_qid;
+		u8 ctype;	/* completion type */
+		u16 gen;
+
+		/* if the descriptor isn't done, no work yet to do */
+		gen = (le16_to_cpu(tx_desc->qid_comptype_gen) &
+		      IECM_TXD_COMPLQ_GEN_M) >> IECM_TXD_COMPLQ_GEN_S;
+		if (test_bit(__IECM_Q_GEN_CHK, complq->flags) != gen)
+			break;
+
+		/* Find necessary info of TX queue to clean buffers */
+		tx_qid = (le16_to_cpu(tx_desc->qid_comptype_gen) &
+			 IECM_TXD_COMPLQ_QID_M) >> IECM_TXD_COMPLQ_QID_S;
+		tx_q = iecm_tx_find_q(vport, tx_qid);
+		if (!tx_q) {
+			dev_err(&complq->vport->adapter->pdev->dev,
+				"TxQ #%d not found\n", tx_qid);
+			goto fetch_next_desc;
+		}
+
+		/* Determine completion type */
+		ctype = (le16_to_cpu(tx_desc->qid_comptype_gen) &
+			IECM_TXD_COMPLQ_COMPL_TYPE_M) >>
+			IECM_TXD_COMPLQ_COMPL_TYPE_S;
+		switch (ctype) {
+		case IECM_TXD_COMPLT_RE:
+			hw_head = le16_to_cpu(tx_desc->q_head_compl_tag.q_head);
+
+			cleaned_stats = iecm_tx_splitq_clean(tx_q, hw_head,
+							     budget,
+							     descs_only);
+			break;
+		case IECM_TXD_COMPLT_RS:
+			if (test_bit(__IECM_Q_FLOW_SCH_EN, tx_q->flags)) {
+				compl_tag =
+				le16_to_cpu(tx_desc->q_head_compl_tag.compl_tag);
+
+				cleaned_stats =
+					iecm_tx_clean_flow_sch_bufs(tx_q,
+								    compl_tag,
+								    tx_desc->ts,
+								    budget);
+			} else {
+				hw_head =
+				le16_to_cpu(tx_desc->q_head_compl_tag.q_head);
+
+				cleaned_stats = iecm_tx_splitq_clean(tx_q,
+								     hw_head,
+								     budget,
+								     false);
+			}
+
+			break;
+		case IECM_TXD_COMPLT_SW_MARKER:
+			iecm_tx_handle_sw_marker(tx_q);
+			break;
+		default:
+			dev_err(&tx_q->vport->adapter->pdev->dev,
+				"Unknown TX completion type: %d\n",
+				ctype);
+			goto fetch_next_desc;
+		}
+
+		tx_q->itr.stats.tx.packets += cleaned_stats.packets;
+		tx_q->itr.stats.tx.bytes += cleaned_stats.bytes;
+		u64_stats_update_begin(&tx_q->stats_sync);
+		tx_q->q_stats.tx.packets += cleaned_stats.packets;
+		tx_q->q_stats.tx.bytes += cleaned_stats.bytes;
+		u64_stats_update_end(&tx_q->stats_sync);
+
+fetch_next_desc:
+		tx_desc++;
+		ntc++;
+		if (unlikely(!ntc)) {
+			ntc -= complq->desc_count;
+			tx_desc = IECM_SPLITQ_TX_COMPLQ_DESC(complq, 0);
+			change_bit(__IECM_Q_GEN_CHK, complq->flags);
+		}
+
+		prefetch(tx_desc);
+
+		/* update budget accounting */
+		complq_budget--;
+	} while (likely(complq_budget));
+
+	ntc += complq->desc_count;
+	complq->next_to_clean = ntc;
+
+	return !!complq_budget;
 }
 
 /**
@@ -1359,7 +1678,12 @@ iecm_tx_splitq_build_ctb(union iecm_tx_flex_desc *desc,
 			 struct iecm_tx_splitq_params *parms,
 			 u16 td_cmd, u16 size)
 {
-	/* stub */
+	desc->q.qw1.cmd_dtype =
+		cpu_to_le16(parms->dtype & IECM_FLEX_TXD_QW1_DTYPE_M);
+	desc->q.qw1.cmd_dtype |=
+		cpu_to_le16((td_cmd << IECM_FLEX_TXD_QW1_CMD_S) &
+			    IECM_FLEX_TXD_QW1_CMD_M);
+	desc->q.qw1.buf_size = cpu_to_le16((u16)size);
 }
 
 /**
@@ -1375,7 +1699,13 @@ iecm_tx_splitq_build_flow_desc(union iecm_tx_flex_desc *desc,
 			       struct iecm_tx_splitq_params *parms,
 			       u16 td_cmd, u16 size)
 {
-	/* stub */
+	desc->flow.qw1.cmd_dtype = cpu_to_le16((u16)parms->dtype | td_cmd);
+	desc->flow.qw1.rxr_bufsize = cpu_to_le16((u16)size);
+	desc->flow.qw1.compl_tag = cpu_to_le16(parms->compl_tag);
+
+	desc->flow.qw1.ts[0] = parms->offload.desc_ts & 0xff;
+	desc->flow.qw1.ts[1] = (parms->offload.desc_ts >> 8) & 0xff;
+	desc->flow.qw1.ts[2] = (parms->offload.desc_ts >> 16) & 0xff;
 }
 
 /**
@@ -1388,7 +1718,19 @@ iecm_tx_splitq_build_flow_desc(union iecm_tx_flex_desc *desc,
 static int
 __iecm_tx_maybe_stop(struct iecm_queue *tx_q, unsigned int size)
 {
-	/* stub */
+	netif_stop_subqueue(tx_q->vport->netdev, tx_q->idx);
+
+	/* Memory barrier before checking head and tail */
+	smp_mb();
+
+	/* Check again in a case another CPU has just made room available. */
+	if (likely(IECM_DESC_UNUSED(tx_q) < size))
+		return -EBUSY;
+
+	/* A reprieve! - use start_subqueue because it doesn't call schedule */
+	netif_start_subqueue(tx_q->vport->netdev, tx_q->idx);
+
+	return 0;
 }
 
 /**
@@ -1400,7 +1742,10 @@ __iecm_tx_maybe_stop(struct iecm_queue *tx_q, unsigned int size)
  */
 int iecm_tx_maybe_stop(struct iecm_queue *tx_q, unsigned int size)
 {
-	/* stub */
+	if (likely(IECM_DESC_UNUSED(tx_q) >= size))
+		return 0;
+
+	return __iecm_tx_maybe_stop(tx_q, size);
 }
 
 /**
@@ -1412,7 +1757,23 @@ int iecm_tx_maybe_stop(struct iecm_queue *tx_q, unsigned int size)
 void iecm_tx_buf_hw_update(struct iecm_queue *tx_q, u32 val,
 			   struct sk_buff *skb)
 {
-	/* stub */
+	struct netdev_queue *nq;
+
+	nq = netdev_get_tx_queue(tx_q->vport->netdev, tx_q->idx);
+	tx_q->next_to_use = val;
+
+	iecm_tx_maybe_stop(tx_q, IECM_TX_DESC_NEEDED);
+
+	/* Force memory writes to complete before letting h/w
+	 * know there are new descriptors to fetch.  (Only
+	 * applicable for weak-ordered memory model archs,
+	 * such as IA-64).
+	 */
+	wmb();
+
+	/* notify HW of packet */
+	if (netif_xmit_stopped(nq) || !netdev_xmit_more())
+		writel_relaxed(val, tx_q->tail);
 }
 
 /**
@@ -1445,7 +1806,7 @@ void iecm_tx_buf_hw_update(struct iecm_queue *tx_q, u32 val,
  */
 static unsigned int __iecm_tx_desc_count_required(unsigned int size)
 {
-	/* stub */
+	return ((size * 85) >> 20) + IECM_TX_DESCS_FOR_SKB_DATA_PTR;
 }
 
 /**
@@ -1456,13 +1817,26 @@ static unsigned int __iecm_tx_desc_count_required(unsigned int size)
  */
 unsigned int iecm_tx_desc_count_required(struct sk_buff *skb)
 {
-	/* stub */
+	const skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
+	unsigned int nr_frags = skb_shinfo(skb)->nr_frags;
+	unsigned int count = 0, size = skb_headlen(skb);
+
+	for (;;) {
+		count += __iecm_tx_desc_count_required(size);
+
+		if (!nr_frags--)
+			break;
+
+		size = skb_frag_size(frag++);
+	}
+
+	return count;
 }
 
 /**
  * iecm_tx_splitq_map - Build the Tx flex descriptor
  * @tx_q: queue to send buffer on
- * @off: pointer to offload params struct
+ * @parms: pointer to splitq params struct
  * @first: first buffer info buffer to use
  *
  * This function loops over the skb data pointed to by *first
@@ -1471,10 +1845,130 @@ unsigned int iecm_tx_desc_count_required(struct sk_buff *skb)
  */
 static void
 iecm_tx_splitq_map(struct iecm_queue *tx_q,
-		   struct iecm_tx_offload_params *off,
+		   struct iecm_tx_splitq_params *parms,
 		   struct iecm_tx_buf *first)
 {
-	/* stub */
+	union iecm_tx_flex_desc *tx_desc;
+	unsigned int data_len, size;
+	struct iecm_tx_buf *tx_buf;
+	u16 i = tx_q->next_to_use;
+	struct netdev_queue *nq;
+	struct sk_buff *skb;
+	skb_frag_t *frag;
+	u16 td_cmd = 0;
+	dma_addr_t dma;
+
+	skb = first->skb;
+
+	td_cmd = parms->offload.td_cmd;
+	parms->compl_tag = tx_q->tx_buf_key;
+
+	data_len = skb->data_len;
+	size = skb_headlen(skb);
+
+	tx_desc = IECM_FLEX_TX_DESC(tx_q, i);
+
+	dma = dma_map_single(tx_q->dev, skb->data, size, DMA_TO_DEVICE);
+
+	tx_buf = first;
+
+	for (frag = &skb_shinfo(skb)->frags[0];; frag++) {
+		unsigned int max_data = IECM_TX_MAX_DESC_DATA_ALIGNED;
+
+		if (dma_mapping_error(tx_q->dev, dma))
+			goto dma_error;
+
+		/* record length, and DMA address */
+		dma_unmap_len_set(tx_buf, len, size);
+		dma_unmap_addr_set(tx_buf, dma, dma);
+
+		/* align size to end of page */
+		max_data += -dma & (IECM_TX_MAX_READ_REQ_SIZE - 1);
+
+		/* buf_addr is in same location for both desc types */
+		tx_desc->q.buf_addr = cpu_to_le64(dma);
+
+		/* account for data chunks larger than the hardware
+		 * can handle
+		 */
+		while (unlikely(size > IECM_TX_MAX_DESC_DATA)) {
+			parms->splitq_build_ctb(tx_desc, parms, td_cmd, size);
+
+			tx_desc++;
+			i++;
+
+			if (i == tx_q->desc_count) {
+				tx_desc = IECM_FLEX_TX_DESC(tx_q, 0);
+				i = 0;
+			}
+
+			dma += max_data;
+			size -= max_data;
+
+			max_data = IECM_TX_MAX_DESC_DATA_ALIGNED;
+			/* buf_addr is in same location for both desc types */
+			tx_desc->q.buf_addr = cpu_to_le64(dma);
+		}
+
+		if (likely(!data_len))
+			break;
+		parms->splitq_build_ctb(tx_desc, parms, td_cmd, size);
+		tx_desc++;
+		i++;
+
+		if (i == tx_q->desc_count) {
+			tx_desc = IECM_FLEX_TX_DESC(tx_q, 0);
+			i = 0;
+		}
+
+		size = skb_frag_size(frag);
+		data_len -= size;
+
+		dma = skb_frag_dma_map(tx_q->dev, frag, 0, size,
+				       DMA_TO_DEVICE);
+
+		tx_buf->compl_tag = parms->compl_tag;
+		tx_buf = &tx_q->tx_buf[i];
+	}
+
+	/* record bytecount for BQL */
+	nq = netdev_get_tx_queue(tx_q->vport->netdev, tx_q->idx);
+	netdev_tx_sent_queue(nq, first->bytecount);
+
+	/* record SW timestamp if HW timestamp is not available */
+	skb_tx_timestamp(first->skb);
+
+	/* write last descriptor with RS and EOP bits */
+	td_cmd |= parms->eop_cmd;
+	parms->splitq_build_ctb(tx_desc, parms, td_cmd, size);
+	i++;
+	if (i == tx_q->desc_count)
+		i = 0;
+
+	/* set next_to_watch value indicating a packet is present */
+	first->next_to_watch = tx_desc;
+	tx_buf->compl_tag = parms->compl_tag++;
+
+	iecm_tx_buf_hw_update(tx_q, i, skb);
+
+	/* Update TXQ Completion Tag key for next buffer */
+	tx_q->tx_buf_key = parms->compl_tag;
+
+	return;
+
+dma_error:
+	/* clear DMA mappings for failed tx_buf map */
+	for (;;) {
+		tx_buf = &tx_q->tx_buf[i];
+		iecm_tx_buf_rel(tx_q, tx_buf);
+		if (tx_buf == first)
+			break;
+		if (i == 0)
+			i = tx_q->desc_count;
+		i--;
+	}
+
+	tx_q->next_to_use = i;
 }
 
 /**
@@ -1490,7 +1984,79 @@ iecm_tx_splitq_map(struct iecm_queue *tx_q,
 static int iecm_tso(struct iecm_tx_buf *first,
 		    struct iecm_tx_offload_params *off)
 {
-	/* stub */
+	struct sk_buff *skb = first->skb;
+	union {
+		struct iphdr *v4;
+		struct ipv6hdr *v6;
+		unsigned char *hdr;
+	} ip;
+	union {
+		struct tcphdr *tcp;
+		struct udphdr *udp;
+		unsigned char *hdr;
+	} l4;
+	u32 paylen, l4_start;
+	int err;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return 0;
+
+	if (!skb_is_gso(skb))
+		return 0;
+
+	err = skb_cow_head(skb, 0);
+	if (err < 0)
+		return err;
+
+	ip.hdr = skb_network_header(skb);
+	l4.hdr = skb_transport_header(skb);
+
+	/* initialize outer IP header fields */
+	if (ip.v4->version == 4) {
+		ip.v4->tot_len = 0;
+		ip.v4->check = 0;
+	} else {
+		ip.v6->payload_len = 0;
+	}
+
+	/* determine offset of transport header */
+	l4_start = l4.hdr - skb->data;
+
+	/* remove payload length from checksum */
+	paylen = skb->len - l4_start;
+
+	switch (skb_shinfo(skb)->gso_type) {
+	case SKB_GSO_TCPV4:
+	case SKB_GSO_TCPV6:
+		csum_replace_by_diff(&l4.tcp->check,
+				     (__force __wsum)htonl(paylen));
+
+		/* compute length of segmentation header */
+		off->tso_hdr_len = (l4.tcp->doff * 4) + l4_start;
+		break;
+	case SKB_GSO_UDP_L4:
+		csum_replace_by_diff(&l4.udp->check,
+				     (__force __wsum)htonl(paylen));
+		/* compute length of segmentation header */
+		off->tso_hdr_len = sizeof(struct udphdr) + l4_start;
+		l4.udp->len =
+			htons(skb_shinfo(skb)->gso_size +
+			      sizeof(struct udphdr));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	off->tso_len = skb->len - off->tso_hdr_len;
+	off->mss = skb_shinfo(skb)->gso_size;
+
+	/* update gso_segs and bytecount */
+	first->gso_segs = skb_shinfo(skb)->gso_segs;
+	first->bytecount += (first->gso_segs - 1) * off->tso_hdr_len;
+
+	first->tx_flags |= IECM_TX_FLAGS_TSO;
+
+	return 0;
 }
 
 /**
@@ -1503,7 +2069,84 @@ static int iecm_tso(struct iecm_tx_buf *first,
 static netdev_tx_t
 iecm_tx_splitq_frame(struct sk_buff *skb, struct iecm_queue *tx_q)
 {
-	/* stub */
+	struct iecm_tx_splitq_params tx_parms = {0};
+	struct iecm_tx_buf *first;
+	unsigned int count;
+
+	count = iecm_tx_desc_count_required(skb);
+
+	/* need: 1 descriptor per page * PAGE_SIZE/IECM_MAX_DATA_PER_TXD,
+	 *       + 1 desc for skb_head_len/IECM_MAX_DATA_PER_TXD,
+	 *       + 4 desc gap to avoid the cache line where head is,
+	 *       + 1 desc for context descriptor,
+	 * otherwise try next time
+	 */
+	if (iecm_tx_maybe_stop(tx_q, count + IECM_TX_DESCS_PER_CACHE_LINE +
+			       IECM_TX_DESCS_FOR_CTX)) {
+		return NETDEV_TX_BUSY;
+	}
+
+	/* record the location of the first descriptor for this packet */
+	first = &tx_q->tx_buf[tx_q->next_to_use];
+	first->skb = skb;
+	first->bytecount = max_t(unsigned int, skb->len, ETH_ZLEN);
+	first->gso_segs = 1;
+	first->tx_flags = 0;
+
+	if (iecm_tso(first, &tx_parms.offload) < 0) {
+		/* If tso returns an error, drop the packet */
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
+	if (first->tx_flags & IECM_TX_FLAGS_TSO) {
+		/* If TSO is needed, set up context desc */
+		union iecm_flex_tx_ctx_desc *ctx_desc;
+		int i = tx_q->next_to_use;
+
+		/* grab the next descriptor */
+		ctx_desc = IECM_FLEX_TX_CTX_DESC(tx_q, i);
+		i++;
+		tx_q->next_to_use = (i < tx_q->desc_count) ? i : 0;
+
+		ctx_desc->tso.qw1.cmd_dtype |=
+				cpu_to_le16(IECM_TX_DESC_DTYPE_FLEX_TSO_CTX |
+					    IECM_TX_FLEX_CTX_DESC_CMD_TSO);
+		ctx_desc->tso.qw0.flex_tlen =
+				cpu_to_le32(tx_parms.offload.tso_len &
+					    IECM_TXD_FLEX_CTX_TLEN_M);
+		ctx_desc->tso.qw0.mss_rt =
+				cpu_to_le16(tx_parms.offload.mss &
+					    IECM_TXD_FLEX_CTX_MSS_RT_M);
+		ctx_desc->tso.qw0.hdr_len = tx_parms.offload.tso_hdr_len;
+	}
+
+	if (test_bit(__IECM_Q_FLOW_SCH_EN, tx_q->flags)) {
+		s64 ts_ns = first->skb->skb_mstamp_ns;
+
+		tx_parms.offload.desc_ts =
+			ts_ns >> IECM_TW_TIME_STAMP_GRAN_512_DIV_S;
+
+		tx_parms.dtype = IECM_TX_DESC_DTYPE_FLEX_FLOW_SCHE;
+		tx_parms.splitq_build_ctb = iecm_tx_splitq_build_flow_desc;
+		tx_parms.eop_cmd =
+			IECM_TXD_FLEX_FLOW_CMD_EOP | IECM_TXD_FLEX_FLOW_CMD_RE;
+
+		if (skb->ip_summed == CHECKSUM_PARTIAL)
+			tx_parms.offload.td_cmd |= IECM_TXD_FLEX_FLOW_CMD_CS_EN;
+
+	} else {
+		tx_parms.dtype = IECM_TX_DESC_DTYPE_FLEX_DATA;
+		tx_parms.splitq_build_ctb = iecm_tx_splitq_build_ctb;
+		tx_parms.eop_cmd = IECM_TX_DESC_CMD_EOP | IECM_TX_DESC_CMD_RS;
+
+		if (skb->ip_summed == CHECKSUM_PARTIAL)
+			tx_parms.offload.td_cmd |= IECM_TX_FLEX_DESC_CMD_CS_EN;
+	}
+
+	iecm_tx_splitq_map(tx_q, &tx_parms, first);
+
+	return NETDEV_TX_OK;
 }
 
 /**
@@ -1516,7 +2159,18 @@ iecm_tx_splitq_frame(struct sk_buff *skb, struct iecm_queue *tx_q)
 netdev_tx_t iecm_tx_splitq_start(struct sk_buff *skb,
 				 struct net_device *netdev)
 {
-	/* stub */
+	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
+	struct iecm_queue *tx_q;
+
+	tx_q = vport->txqs[skb->queue_mapping];
+
+	/* hardware can't handle really short frames, hardware padding works
+	 * beyond this point
+	 */
+	if (skb_put_padto(skb, IECM_TX_MIN_LEN))
+		return NETDEV_TX_OK;
+
+	return iecm_tx_splitq_frame(skb, tx_q);
 }
 
 /**
@@ -1531,7 +2185,18 @@ netdev_tx_t iecm_tx_splitq_start(struct sk_buff *skb,
 static enum pkt_hash_types iecm_ptype_to_htype(struct iecm_vport *vport,
 					       u16 ptype)
 {
-	/* stub */
+	struct iecm_rx_ptype_decoded decoded = vport->rx_ptype_lkup[ptype];
+
+	if (!decoded.known)
+		return PKT_HASH_TYPE_NONE;
+	if (decoded.payload_layer == IECM_RX_PTYPE_PAYLOAD_LAYER_PAY4)
+		return PKT_HASH_TYPE_L4;
+	if (decoded.payload_layer == IECM_RX_PTYPE_PAYLOAD_LAYER_PAY3)
+		return PKT_HASH_TYPE_L3;
+	if (decoded.outer_ip == IECM_RX_PTYPE_OUTER_L2)
+		return PKT_HASH_TYPE_L2;
+
+	return PKT_HASH_TYPE_NONE;
 }
 
 /**
@@ -1545,7 +2210,17 @@ static void
 iecm_rx_hash(struct iecm_queue *rxq, struct sk_buff *skb,
 	     struct iecm_flex_rx_desc *rx_desc, u16 ptype)
 {
-	/* stub */
+	u32 hash;
+
+	if (!iecm_is_feature_ena(rxq->vport, NETIF_F_RXHASH))
+		return;
+
+	hash = rx_desc->status_err1 |
+	       (rx_desc->fflags1 << 8) |
+	       (rx_desc->ts_low << 16) |
+	       (rx_desc->ff2_mirrid_hash2.hash2 << 24);
+
+	skb_set_hash(skb, hash, iecm_ptype_to_htype(rxq->vport, ptype));
 }
 
 /**
@@ -1561,7 +2236,63 @@ static void
 iecm_rx_csum(struct iecm_queue *rxq, struct sk_buff *skb,
 	     struct iecm_flex_rx_desc *rx_desc, u16 ptype)
 {
-	/* stub */
+	struct iecm_rx_ptype_decoded decoded;
+	u8 rx_status_0_qw1, rx_status_0_qw0;
+	bool ipv4, ipv6;
+
+	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
+	skb->ip_summed = CHECKSUM_NONE;
+
+	/* check if Rx checksum is enabled */
+	if (!iecm_is_feature_ena(rxq->vport, NETIF_F_RXCSUM))
+		return;
+
+	rx_status_0_qw1 = rx_desc->status_err0_qw1;
+	/* check if HW has decoded the packet and checksum */
+	if (!(rx_status_0_qw1 & BIT(IECM_RX_FLEX_DESC_STATUS0_L3L4P_S)))
+		return;
+
+	decoded = rxq->vport->rx_ptype_lkup[ptype];
+	if (!(decoded.known && decoded.outer_ip))
+		return;
+
+	ipv4 = (decoded.outer_ip == IECM_RX_PTYPE_OUTER_IP) &&
+	       (decoded.outer_ip_ver == IECM_RX_PTYPE_OUTER_IPV4);
+	ipv6 = (decoded.outer_ip == IECM_RX_PTYPE_OUTER_IP) &&
+	       (decoded.outer_ip_ver == IECM_RX_PTYPE_OUTER_IPV6);
+
+	if (ipv4 && (rx_status_0_qw1 &
+		     (BIT(IECM_RX_FLEX_DESC_STATUS0_XSUM_IPE_S) |
+		      BIT(IECM_RX_FLEX_DESC_STATUS0_XSUM_EIPE_S))))
+		goto checksum_fail;
+
+	rx_status_0_qw0 = rx_desc->status_err0_qw0;
+	if (ipv6 && (rx_status_0_qw0 &
+		     (BIT(IECM_RX_FLEX_DESC_STATUS0_IPV6EXADD_S))))
+		return;
+
+	/* check for L4 errors and handle packets that were not able to be
+	 * checksummed
+	 */
+	if (rx_status_0_qw1 & BIT(IECM_RX_FLEX_DESC_STATUS0_XSUM_L4E_S))
+		goto checksum_fail;
+
+	/* Only report checksum unnecessary for ICMP, TCP, UDP, or SCTP */
+	switch (decoded.inner_prot) {
+	case IECM_RX_PTYPE_INNER_PROT_ICMP:
+	case IECM_RX_PTYPE_INNER_PROT_TCP:
+	case IECM_RX_PTYPE_INNER_PROT_UDP:
+	case IECM_RX_PTYPE_INNER_PROT_SCTP:
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		rxq->q_stats.rx.basic_csum++;
+	default:
+		break;
+	}
+	return;
+
+checksum_fail:
+	rxq->q_stats.rx.csum_err++;
+	dev_dbg(rxq->dev, "RX Checksum not available\n");
 }
 
 /**
@@ -1577,7 +2308,74 @@ iecm_rx_csum(struct iecm_queue *rxq, struct sk_buff *skb,
 static bool iecm_rx_rsc(struct iecm_queue *rxq, struct sk_buff *skb,
 			struct iecm_flex_rx_desc *rx_desc, u16 ptype)
 {
-	/* stub */
+	struct iecm_rx_ptype_decoded decoded;
+	u16 rsc_segments, rsc_payload_len;
+	struct ipv6hdr *ipv6h;
+	struct tcphdr *tcph;
+	struct iphdr *ipv4h;
+	bool ipv4, ipv6;
+	u16 hdr_len;
+
+	rsc_payload_len = le32_to_cpu(rx_desc->fmd1_misc.rscseglen);
+	if (!rsc_payload_len)
+		goto rsc_err;
+
+	decoded = rxq->vport->rx_ptype_lkup[ptype];
+	if (!(decoded.known && decoded.outer_ip))
+		goto rsc_err;
+
+	ipv4 = (decoded.outer_ip == IECM_RX_PTYPE_OUTER_IP) &&
+		(decoded.outer_ip_ver == IECM_RX_PTYPE_OUTER_IPV4);
+	ipv6 = (decoded.outer_ip == IECM_RX_PTYPE_OUTER_IP) &&
+		(decoded.outer_ip_ver == IECM_RX_PTYPE_OUTER_IPV6);
+
+	if (!(ipv4 ^ ipv6))
+		goto rsc_err;
+
+	if (ipv4)
+		hdr_len = ETH_HLEN + sizeof(struct tcphdr) +
+			  sizeof(struct iphdr);
+	else
+		hdr_len = ETH_HLEN + sizeof(struct tcphdr) +
+			  sizeof(struct ipv6hdr);
+
+	rsc_segments = DIV_ROUND_UP(skb->len - hdr_len, rsc_payload_len);
+
+	NAPI_GRO_CB(skb)->count = rsc_segments;
+	skb_shinfo(skb)->gso_size = rsc_payload_len;
+
+	skb_reset_network_header(skb);
+
+	if (ipv4) {
+		ipv4h = ip_hdr(skb);
+		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
+
+		/* Reset and set transport header offset in skb */
+		skb_set_transport_header(skb, sizeof(struct iphdr));
+		tcph = tcp_hdr(skb);
+
+		/* Compute the TCP pseudo header checksum*/
+		tcph->check =
+			~tcp_v4_check(skb->len - skb_transport_offset(skb),
+				      ipv4h->saddr, ipv4h->daddr, 0);
+	} else {
+		ipv6h = ipv6_hdr(skb);
+		skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
+		skb_set_transport_header(skb, sizeof(struct ipv6hdr));
+		tcph = tcp_hdr(skb);
+		tcph->check =
+			~tcp_v6_check(skb->len - skb_transport_offset(skb),
+				      &ipv6h->saddr, &ipv6h->daddr, 0);
+	}
+
+	tcp_gro_complete(skb);
+
+	/* Map Rx qid to the skb*/
+	skb_record_rx_queue(skb, rxq->q_id);
+
+	return true;
+rsc_err:
+	return false;
 }
 
 /**
@@ -1589,7 +2387,19 @@ static bool iecm_rx_rsc(struct iecm_queue *rxq, struct sk_buff *skb,
 static void iecm_rx_hwtstamp(struct iecm_flex_rx_desc *rx_desc,
 			     struct sk_buff __maybe_unused *skb)
 {
-	/* stub */
+	u8 ts_lo = rx_desc->ts_low;
+	u32 ts_hi = 0;
+	u64 ts_ns = 0;
+
+	ts_hi = le32_to_cpu(rx_desc->flex_ts.ts_high);
+
+	ts_ns |= ts_lo | ((u64)ts_hi << 8);
+
+	if (ts_ns) {
+		memset(skb_hwtstamps(skb), 0,
+		       sizeof(struct skb_shared_hwtstamps));
+		skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(ts_ns);
+	}
 }
 
 /**
@@ -1606,7 +2416,26 @@ static bool
 iecm_rx_process_skb_fields(struct iecm_queue *rxq, struct sk_buff *skb,
 			   struct iecm_flex_rx_desc *rx_desc)
 {
-	/* stub */
+	bool err = false;
+	u16 rx_ptype;
+	bool rsc;
+
+	rx_ptype = le16_to_cpu(rx_desc->ptype_err_fflags0) &
+		   IECM_RXD_FLEX_PTYPE_M;
+
+	/* modifies the skb - consumes the enet header */
+	skb->protocol = eth_type_trans(skb, rxq->vport->netdev);
+	iecm_rx_csum(rxq, skb, rx_desc, rx_ptype);
+	/* process RSS/hash */
+	iecm_rx_hash(rxq, skb, rx_desc, rx_ptype);
+
+	rsc = le16_to_cpu(rx_desc->hdrlen_flags) & IECM_RXD_FLEX_RSC_M;
+	if (rsc)
+		err = iecm_rx_rsc(rxq, skb, rx_desc, rx_ptype);
+
+	iecm_rx_hwtstamp(rx_desc, skb);
+
+	return err;
 }
 
 /**
@@ -1619,7 +2448,7 @@ iecm_rx_process_skb_fields(struct iecm_queue *rxq, struct sk_buff *skb,
  */
 void iecm_rx_skb(struct iecm_queue *rxq, struct sk_buff *skb)
 {
-	/* stub */
+	napi_gro_receive(&rxq->q_vector->napi, skb);
 }
 
 /**
@@ -1628,7 +2457,7 @@ void iecm_rx_skb(struct iecm_queue *rxq, struct sk_buff *skb)
  */
 static bool iecm_rx_page_is_reserved(struct page *page)
 {
-	/* stub */
+	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
 /**
@@ -1644,7 +2473,13 @@ static bool iecm_rx_page_is_reserved(struct page *page)
 static void
 iecm_rx_buf_adjust_pg_offset(struct iecm_rx_buf *rx_buf, unsigned int size)
 {
-	/* stub */
+#if (PAGE_SIZE < 8192)
+	/* flip page offset to other buffer */
+	rx_buf->page_offset ^= size;
+#else
+	/* move offset up to the next cache line */
+	rx_buf->page_offset += size;
+#endif
 }
 
 /**
@@ -1658,7 +2493,34 @@ iecm_rx_buf_adjust_pg_offset(struct iecm_rx_buf *rx_buf, unsigned int size)
  */
 static bool iecm_rx_can_reuse_page(struct iecm_rx_buf *rx_buf)
 {
-	/* stub */
+#if (PAGE_SIZE >= 8192)
+#endif
+	unsigned int pagecnt_bias = rx_buf->pagecnt_bias;
+	struct page *page = rx_buf->page;
+
+	/* avoid re-using remote pages */
+	if (unlikely(iecm_rx_page_is_reserved(page)))
+		return false;
+
+#if (PAGE_SIZE < 8192)
+	/* if we are only owner of page we can reuse it */
+	if (unlikely((page_count(page) - pagecnt_bias) > 1))
+		return false;
+#else
+	if (rx_buf->page_offset > last_offset)
+		return false;
+#endif /* PAGE_SIZE < 8192) */
+
+	/* If we have drained the page fragment pool we need to update
+	 * the pagecnt_bias and page count so that we fully restock the
+	 * number of references the driver holds.
+	 */
+	if (unlikely(pagecnt_bias == 1)) {
+		page_ref_add(page, USHRT_MAX - 1);
+		rx_buf->pagecnt_bias = USHRT_MAX;
+	}
+
+	return true;
 }
 
 /**
@@ -1674,7 +2536,17 @@ static bool iecm_rx_can_reuse_page(struct iecm_rx_buf *rx_buf)
 void iecm_rx_add_frag(struct iecm_rx_buf *rx_buf, struct sk_buff *skb,
 		      unsigned int size)
 {
-	/* stub */
+#if (PAGE_SIZE >= 8192)
+	unsigned int truesize = SKB_DATA_ALIGN(size);
+#else
+	unsigned int truesize = IECM_RX_BUF_2048;
+#endif
+
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buf->page,
+			rx_buf->page_offset, size, truesize);
+
+	/* page is being used so we must update the page offset */
+	iecm_rx_buf_adjust_pg_offset(rx_buf, truesize);
 }
 
 /**
@@ -1689,7 +2561,22 @@ void iecm_rx_reuse_page(struct iecm_queue *rx_bufq,
 			bool hsplit,
 			struct iecm_rx_buf *old_buf)
 {
-	/* stub */
+	u16 ntu = rx_bufq->next_to_use;
+	struct iecm_rx_buf *new_buf;
+
+	if (hsplit)
+		new_buf = &rx_bufq->rx_buf.hdr_buf[ntu];
+	else
+		new_buf = &rx_bufq->rx_buf.buf[ntu];
+
+	/* Transfer page from old buffer to new buffer.
+	 * Move each member individually to avoid possible store
+	 * forwarding stalls and unnecessary copy of skb.
+	 */
+	new_buf->dma = old_buf->dma;
+	new_buf->page = old_buf->page;
+	new_buf->page_offset = old_buf->page_offset;
+	new_buf->pagecnt_bias = old_buf->pagecnt_bias;
 }
 
 /**
@@ -1704,7 +2591,15 @@ static void
 iecm_rx_get_buf_page(struct device *dev, struct iecm_rx_buf *rx_buf,
 		     const unsigned int size)
 {
-	/* stub */
+	prefetch(rx_buf->page);
+
+	/* we are reusing so sync this buffer for CPU use */
+	dma_sync_single_range_for_cpu(dev, rx_buf->dma,
+				      rx_buf->page_offset, size,
+				      DMA_FROM_DEVICE);
+
+	/* We have pulled a buffer for use, so decrement pagecnt_bias */
+	rx_buf->pagecnt_bias--;
 }
 
 /**
@@ -1721,7 +2616,52 @@ struct sk_buff *
 iecm_rx_construct_skb(struct iecm_queue *rxq, struct iecm_rx_buf *rx_buf,
 		      unsigned int size)
 {
-	/* stub */
+	void *va = page_address(rx_buf->page) + rx_buf->page_offset;
+	unsigned int headlen;
+	struct sk_buff *skb;
+
+	/* prefetch first cache line of first page */
+	prefetch(va);
+#if L1_CACHE_BYTES < 128
+	prefetch((u8 *)va + L1_CACHE_BYTES);
+#endif /* L1_CACHE_BYTES */
+	/* allocate a skb to store the frags */
+	skb = __napi_alloc_skb(&rxq->q_vector->napi, IECM_RX_HDR_SIZE,
+			       GFP_ATOMIC | __GFP_NOWARN);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_record_rx_queue(skb, rxq->idx);
+
+	/* Determine available headroom for copy */
+	headlen = size;
+	if (headlen > IECM_RX_HDR_SIZE)
+		headlen = eth_get_headlen(skb->dev, va, IECM_RX_HDR_SIZE);
+
+	/* align pull length to size of long to optimize memcpy performance */
+	memcpy(__skb_put(skb, headlen), va, ALIGN(headlen, sizeof(long)));
+
+	/* if we exhaust the linear part then add what is left as a frag */
+	size -= headlen;
+	if (size) {
+#if (PAGE_SIZE >= 8192)
+		unsigned int truesize = SKB_DATA_ALIGN(size);
+#else
+		unsigned int truesize = IECM_RX_BUF_2048;
+#endif
+		skb_add_rx_frag(skb, 0, rx_buf->page,
+				rx_buf->page_offset + headlen, size, truesize);
+		/* buffer is used by skb, update page_offset */
+		iecm_rx_buf_adjust_pg_offset(rx_buf, truesize);
+	} else {
+		/* buffer is unused, reset bias back to rx_buf; data was copied
+		 * onto skb's linear part so there's no need for adjusting
+		 * page offset and we can reuse this buffer as-is
+		 */
+		rx_buf->pagecnt_bias++;
+	}
+
+	return skb;
 }
 
 /**
@@ -1738,7 +2678,11 @@ iecm_rx_construct_skb(struct iecm_queue *rxq, struct iecm_rx_buf *rx_buf,
  */
 bool iecm_rx_cleanup_headers(struct sk_buff *skb)
 {
-	/* stub */
+	/* if eth_skb_pad returns an error the skb was freed */
+	if (eth_skb_pad(skb))
+		return true;
+
+	return false;
 }
 
 /**
@@ -1751,7 +2695,7 @@ bool iecm_rx_cleanup_headers(struct sk_buff *skb)
 static bool
 iecm_rx_splitq_test_staterr(u8 stat_err_field, const u8 stat_err_bits)
 {
-	/* stub */
+	return !!(stat_err_field & stat_err_bits);
 }
 
 /**
@@ -1764,7 +2708,13 @@ iecm_rx_splitq_test_staterr(u8 stat_err_field, const u8 stat_err_bits)
 static bool
 iecm_rx_splitq_is_non_eop(struct iecm_flex_rx_desc *rx_desc)
 {
-	/* stub */
+	/* if we are the last buffer then there is nothing else to do */
+#define IECM_RXD_EOF BIT(IECM_RX_FLEX_DESC_STATUS0_EOF_S)
+	if (likely(iecm_rx_splitq_test_staterr(rx_desc->status_err0_qw1,
+					       IECM_RXD_EOF)))
+		return false;
+
+	return true;
 }
 
 /**
@@ -1781,7 +2731,24 @@ iecm_rx_splitq_is_non_eop(struct iecm_flex_rx_desc *rx_desc)
 bool iecm_rx_recycle_buf(struct iecm_queue *rx_bufq, bool hsplit,
 			 struct iecm_rx_buf *rx_buf)
 {
-	/* stub */
+	bool recycled = false;
+
+	if (iecm_rx_can_reuse_page(rx_buf)) {
+		/* hand second half of page back to the queue */
+		iecm_rx_reuse_page(rx_bufq, hsplit, rx_buf);
+		recycled = true;
+	} else {
+		/* we are not reusing the buffer so unmap it */
+		dma_unmap_page_attrs(rx_bufq->dev, rx_buf->dma, PAGE_SIZE,
+				     DMA_FROM_DEVICE, IECM_RX_DMA_ATTR);
+		__page_frag_cache_drain(rx_buf->page, rx_buf->pagecnt_bias);
+	}
+
+	/* clear contents of buffer_info */
+	rx_buf->page = NULL;
+	rx_buf->skb = NULL;
+
+	return recycled;
 }
 
 /**
@@ -1797,7 +2764,19 @@ static void iecm_rx_splitq_put_bufs(struct iecm_queue *rx_bufq,
 				    struct iecm_rx_buf *hdr_buf,
 				    struct iecm_rx_buf *rx_buf)
 {
-	/* stub */
+	u16 ntu = rx_bufq->next_to_use;
+	bool recycled = false;
+
+	if (likely(hdr_buf))
+		recycled = iecm_rx_recycle_buf(rx_bufq, true, hdr_buf);
+	if (likely(rx_buf))
+		recycled = iecm_rx_recycle_buf(rx_bufq, false, rx_buf);
+
+	/* update, and store next to alloc if the buffer was recycled */
+	if (recycled) {
+		ntu++;
+		rx_bufq->next_to_use = (ntu < rx_bufq->desc_count) ? ntu : 0;
+	}
 }
 
 /**
@@ -1806,7 +2785,14 @@ static void iecm_rx_splitq_put_bufs(struct iecm_queue *rx_bufq,
  */
 static void iecm_rx_bump_ntc(struct iecm_queue *q)
 {
-	/* stub */
+	u16 ntc = q->next_to_clean + 1;
+	/* fetch, update, and store next to clean */
+	if (ntc < q->desc_count) {
+		q->next_to_clean = ntc;
+	} else {
+		q->next_to_clean = 0;
+		change_bit(__IECM_Q_GEN_CHK, q->flags);
+	}
 }
 
 /**
@@ -1823,7 +2809,158 @@ static void iecm_rx_bump_ntc(struct iecm_queue *q)
  */
 static int iecm_rx_splitq_clean(struct iecm_queue *rxq, int budget)
 {
-	/* stub */
+	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
+	u16 cleaned_count[IECM_BUFQS_PER_RXQ_SET] = {0};
+	struct iecm_queue *rx_bufq = NULL;
+	struct sk_buff *skb = rxq->skb;
+	bool failure = false;
+	int i;
+
+	/* Process Rx packets bounded by budget */
+	while (likely(total_rx_pkts < (unsigned int)budget)) {
+		struct iecm_flex_rx_desc *splitq_flex_rx_desc;
+		union iecm_rx_desc *rx_desc;
+		struct iecm_rx_buf *hdr_buf = NULL;
+		struct iecm_rx_buf *rx_buf = NULL;
+		unsigned int pkt_len = 0;
+		unsigned int hdr_len = 0;
+		u16 gen_id, buf_id;
+		u8 stat_err0_qw0;
+		u8 stat_err_bits;
+		 /* Header buffer overflow only valid for header split */
+		bool hbo = false;
+		int bufq_id;
+
+		/* get the Rx desc from Rx queue based on 'next_to_clean' */
+		rx_desc = IECM_RX_DESC(rxq, rxq->next_to_clean);
+		splitq_flex_rx_desc = (struct iecm_flex_rx_desc *)rx_desc;
+
+		/* This memory barrier is needed to keep us from reading
+		 * any other fields out of the rx_desc
+		 */
+		dma_rmb();
+
+		/* if the descriptor isn't done, no work yet to do */
+		gen_id = le16_to_cpu(splitq_flex_rx_desc->pktlen_gen_bufq_id);
+		gen_id = (gen_id & IECM_RXD_FLEX_GEN_M) >> IECM_RXD_FLEX_GEN_S;
+		if (test_bit(__IECM_Q_GEN_CHK, rxq->flags) != gen_id)
+			break;
+
+		pkt_len = le16_to_cpu(splitq_flex_rx_desc->pktlen_gen_bufq_id) &
+			  IECM_RXD_FLEX_LEN_PBUF_M;
+
+		hbo = le16_to_cpu(splitq_flex_rx_desc->status_err0_qw1) &
+		      BIT(IECM_RX_FLEX_DESC_STATUS0_HBO_S);
+
+		if (unlikely(hbo)) {
+			rxq->q_stats.rx.hsplit_hbo++;
+			goto bypass_hsplit;
+		}
+
+		hdr_len =
+			le16_to_cpu(splitq_flex_rx_desc->hdrlen_flags) &
+			IECM_RXD_FLEX_LEN_HDR_M;
+
+bypass_hsplit:
+		bufq_id = le16_to_cpu(splitq_flex_rx_desc->pktlen_gen_bufq_id);
+		bufq_id = (bufq_id & IECM_RXD_FLEX_BUFQ_ID_M) >>
+			  IECM_RXD_FLEX_BUFQ_ID_S;
+		/* retrieve buffer from the rxq */
+		rx_bufq = &rxq->rxq_grp->splitq.bufq_sets[bufq_id].bufq;
+
+		buf_id = le16_to_cpu(splitq_flex_rx_desc->fmd0_bufid.buf_id);
+
+		if (pkt_len) {
+			rx_buf = &rx_bufq->rx_buf.buf[buf_id];
+			iecm_rx_get_buf_page(rx_bufq->dev, rx_buf, pkt_len);
+		}
+
+		if (hdr_len) {
+			hdr_buf = &rx_bufq->rx_buf.hdr_buf[buf_id];
+			iecm_rx_get_buf_page(rx_bufq->dev, hdr_buf,
+					     hdr_len);
+
+			skb = iecm_rx_construct_skb(rxq, hdr_buf, hdr_len);
+		}
+
+		if (skb && pkt_len)
+			iecm_rx_add_frag(rx_buf, skb, pkt_len);
+		else if (pkt_len)
+			skb = iecm_rx_construct_skb(rxq, rx_buf, pkt_len);
+
+		/* exit if we failed to retrieve a buffer */
+		if (!skb) {
+			/* If we fetched a buffer, but didn't use it
+			 * undo pagecnt_bias decrement
+			 */
+			if (rx_buf)
+				rx_buf->pagecnt_bias++;
+			break;
+		}
+
+		iecm_rx_splitq_put_bufs(rx_bufq, hdr_buf, rx_buf);
+		iecm_rx_bump_ntc(rxq);
+		cleaned_count[bufq_id]++;
+
+		/* skip if it is non EOP desc */
+		if (iecm_rx_splitq_is_non_eop(splitq_flex_rx_desc))
+			continue;
+
+		stat_err_bits = BIT(IECM_RX_FLEX_DESC_STATUS0_RXE_S);
+		stat_err0_qw0 = splitq_flex_rx_desc->status_err0_qw0;
+		if (unlikely(iecm_rx_splitq_test_staterr(stat_err0_qw0,
+							 stat_err_bits))) {
+			dev_kfree_skb_any(skb);
+			skb = NULL;
+			continue;
+		}
+
+		/* correct empty headers and pad skb if needed (to make valid
+		 * Ethernet frame
+		 */
+		if (iecm_rx_cleanup_headers(skb)) {
+			skb = NULL;
+			continue;
+		}
+
+		/* probably a little skewed due to removing CRC */
+		total_rx_bytes += skb->len;
+
+		/* protocol */
+		if (unlikely(iecm_rx_process_skb_fields(rxq, skb,
+							splitq_flex_rx_desc))) {
+			dev_kfree_skb_any(skb);
+			skb = NULL;
+			continue;
+		}
+
+		/* send completed skb up the stack */
+		iecm_rx_skb(rxq, skb);
+		skb = NULL;
+
+		/* update budget accounting */
+		total_rx_pkts++;
+	}
+	for (i = 0; i < IECM_BUFQS_PER_RXQ_SET; i++) {
+		if (cleaned_count[i]) {
+			rx_bufq = &rxq->rxq_grp->splitq.bufq_sets[i].bufq;
+			failure = iecm_rx_buf_hw_alloc_all(rx_bufq,
+							   cleaned_count[i]) ||
+				  failure;
+		}
+	}
+
+	rxq->skb = skb;
+	u64_stats_update_begin(&rxq->stats_sync);
+	rxq->q_stats.rx.packets += total_rx_pkts;
+	rxq->q_stats.rx.bytes += total_rx_bytes;
+	u64_stats_update_end(&rxq->stats_sync);
+
+	rxq->itr.stats.rx.packets += total_rx_pkts;
+	rxq->itr.stats.rx.bytes += total_rx_bytes;
+
+	/* guarantee a trip back through this routine if there was a failure */
+	return failure ? budget : (int)total_rx_pkts;
 }
 
 /**
@@ -2379,7 +3516,15 @@ iecm_vport_intr_napi_ena_all(struct iecm_vport *vport)
 static inline bool
 iecm_tx_splitq_clean_all(struct iecm_q_vector *q_vec, int budget)
 {
-	/* stub */
+	bool clean_complete = true;
+	int i, budget_per_q;
+
+	budget_per_q = max(budget / q_vec->num_txq, 1);
+	for (i = 0; i < q_vec->num_txq; i++) {
+		if (!iecm_tx_clean_complq(q_vec->tx[i], budget_per_q))
+			clean_complete = false;
+	}
+	return clean_complete;
 }
 
 /**
@@ -2394,7 +3539,22 @@ static inline bool
 iecm_rx_splitq_clean_all(struct iecm_q_vector *q_vec, int budget,
 			 int *cleaned)
 {
-	/* stub */
+	bool clean_complete = true;
+	int pkts_cleaned_per_q;
+	int i, budget_per_q;
+
+	budget_per_q = max(budget / q_vec->num_rxq, 1);
+	for (i = 0; i < q_vec->num_rxq; i++) {
+		pkts_cleaned_per_q  = iecm_rx_splitq_clean(q_vec->rx[i],
+							   budget_per_q);
+		/* if we clean as many as budgeted, we must not
+		 * be done
+		 */
+		if (pkts_cleaned_per_q >= budget_per_q)
+			clean_complete = false;
+		*cleaned += pkts_cleaned_per_q;
+	}
+	return clean_complete;
 }
 
 /**
@@ -2404,7 +3564,34 @@ iecm_rx_splitq_clean_all(struct iecm_q_vector *q_vec, int budget,
  */
 int iecm_vport_splitq_napi_poll(struct napi_struct *napi, int budget)
 {
-	/* stub */
+	struct iecm_q_vector *q_vector =
+				container_of(napi, struct iecm_q_vector, napi);
+	bool clean_complete;
+	int work_done = 0;
+
+	clean_complete = iecm_tx_splitq_clean_all(q_vector, budget);
+
+	/* Handle case where we are called by netpoll with a budget of 0 */
+	if (budget <= 0)
+		return budget;
+
+	/* We attempt to distribute budget to each Rx queue fairly, but don't
+	 * allow the budget to go below 1 because that would exit polling early.
+	 */
+	clean_complete |= iecm_rx_splitq_clean_all(q_vector, budget,
+						   &work_done);
+
+	/* If work not completed, return budget and polling will return */
+	if (!clean_complete)
+		return budget;
+
+	/* Exit the polling mode, but don't re-enable interrupts if stack might
+	 * poll us due to busy-polling
+	 */
+	if (likely(napi_complete_done(napi, work_done)))
+		iecm_vport_intr_update_itr_ena_irq(q_vector);
+
+	return min_t(int, work_done, budget - 1);
 }
 
 /**
-- 
2.26.2

