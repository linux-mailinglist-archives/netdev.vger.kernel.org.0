Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0114773D7
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 15:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbhLPOAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 09:00:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:12138 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237425AbhLPOAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 09:00:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639663208; x=1671199208;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=65b+QPI1sBLav0Ln+eYXX0IBrCu2Y/eTlZJerHBgNDo=;
  b=U5CgZNr3HrhAxZ85649H1+SD+/gj1inY88glXhG1QbY1PAlP+N8mpp/m
   iaf6ri2D6RBtmddoALJE7jswsaJcnA+jjm9mHiOcojcjYdln1zDpEtyMW
   A4ZuJGeaqA4+CUhg1BJLE2xPw6bsowcKUtho6Y64ZciXDFvsr1+7TxvyJ
   AMoSWEb6md1L0/GMUCnJy8KvliMKvWT+oz1RuJQtZUVUUy0ijCY7nRy0a
   ghiHu+QTkAK7F2PfPlJ6hS248A4+fI4L03X1v4nAtZpKZtQFkEOF4qCEM
   YknCVQL+FdnN13YHt1cPVDQ0T9U+F4OJ3HCHbW7sDj48gCId+PnoCGVfK
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226779277"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="226779277"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 06:00:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="545988254"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga001.jf.intel.com with ESMTP; 16 Dec 2021 06:00:06 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v2 3/4] ice: xsk: improve AF_XDP ZC Tx and use batching API
Date:   Thu, 16 Dec 2021 14:59:57 +0100
Message-Id: <20211216135958.3434-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211216135958.3434-1-maciej.fijalkowski@intel.com>
References: <20211216135958.3434-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow mostly the logic from commit 9610bd988df9 ("ice: optimize XDP_TX
workloads") that has been done in order to address the massive tx_busy
statistic bump and improve the performance as well.

Increase the ICE_TX_THRESH to 64 as it seems to work out better for both
XDP and AF_XDP. Also, separating the stats structs onto separate cache
lines seemed to improve the performance. Batching approach is inspired
by i40e's implementation with adjustments to the cleaning logic.

One difference from 'xdpdrv' XDP_TX is when ring has less than
ICE_TX_THRESH free entries, the cleaning routine will not stop after
cleaning a single ICE_TX_THRESH amount of descs but rather will forward
the next_dd pointer and check the DD bit and for this bit being set the
cleaning will be repeated. IOW clean until there are descs that can be
cleaned.

It takes three separate xdpsock instances in txonly mode to achieve the
line rate and this was not previously possible.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h |   4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 249 ++++++++++++++--------
 drivers/net/ethernet/intel/ice/ice_xsk.h  |  26 ++-
 4 files changed, 182 insertions(+), 99 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 0f3f92ce8a95..5f1a9a1ac877 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1447,7 +1447,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 		bool wd;
 
 		if (tx_ring->xsk_pool)
-			wd = ice_clean_tx_irq_zc(tx_ring, budget);
+			wd = ice_xmit_zc(tx_ring, ICE_DESC_UNUSED(tx_ring));
 		else if (ice_ring_is_xdp(tx_ring))
 			wd = true;
 		else
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index c56dd1749903..9e8b4337d131 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -13,7 +13,7 @@
 #define ICE_MAX_CHAINED_RX_BUFS	5
 #define ICE_MAX_BUF_TXD		8
 #define ICE_MIN_TX_LEN		17
-#define ICE_TX_THRESH		32
+#define ICE_TX_THRESH		64
 
 /* The size limit for a transmit buffer in a descriptor is (16K - 1).
  * In order to align with the read requests we will align the value to
@@ -322,9 +322,9 @@ struct ice_tx_ring {
 	u16 count;			/* Number of descriptors */
 	u16 q_index;			/* Queue number of ring */
 	/* stats structs */
+	struct ice_txq_stats tx_stats;
 	struct ice_q_stats	stats;
 	struct u64_stats_sync syncp;
-	struct ice_txq_stats tx_stats;
 
 	/* CL3 - 3rd cacheline starts here */
 	struct rcu_head rcu;		/* to avoid race on free */
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index ff55cb415b11..563ea7e7e0b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -611,58 +611,6 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 	return failure ? budget : (int)total_rx_packets;
 }
 
-/**
- * ice_xmit_zc - Completes AF_XDP entries, and cleans XDP entries
- * @xdp_ring: XDP Tx ring
- * @budget: max number of frames to xmit
- *
- * Returns true if cleanup/transmission is done.
- */
-static bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, int budget)
-{
-	struct ice_tx_desc *tx_desc = NULL;
-	bool work_done = true;
-	struct xdp_desc desc;
-	dma_addr_t dma;
-
-	while (likely(budget-- > 0)) {
-		struct ice_tx_buf *tx_buf;
-
-		if (unlikely(!ICE_DESC_UNUSED(xdp_ring))) {
-			xdp_ring->tx_stats.tx_busy++;
-			work_done = false;
-			break;
-		}
-
-		tx_buf = &xdp_ring->tx_buf[xdp_ring->next_to_use];
-
-		if (!xsk_tx_peek_desc(xdp_ring->xsk_pool, &desc))
-			break;
-
-		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc.addr);
-		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
-						 desc.len);
-
-		tx_buf->bytecount = desc.len;
-
-		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_to_use);
-		tx_desc->buf_addr = cpu_to_le64(dma);
-		tx_desc->cmd_type_offset_bsz =
-			ice_build_ctob(ICE_TXD_LAST_DESC_CMD, 0, desc.len, 0);
-
-		xdp_ring->next_to_use++;
-		if (xdp_ring->next_to_use == xdp_ring->count)
-			xdp_ring->next_to_use = 0;
-	}
-
-	if (tx_desc) {
-		ice_xdp_ring_update_tail(xdp_ring);
-		xsk_tx_release(xdp_ring->xsk_pool);
-	}
-
-	return budget > 0 && work_done;
-}
-
 /**
  * ice_clean_xdp_tx_buf - Free and unmap XDP Tx buffer
  * @xdp_ring: XDP Tx ring
@@ -678,32 +626,33 @@ ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 }
 
 /**
- * ice_clean_tx_irq_zc - Completes AF_XDP entries, and cleans XDP entries
- * @xdp_ring: XDP Tx ring
- * @budget: NAPI budget
+ * ice_clean_xdp_irq - Reclaim resources after transmit completes on XDP ring
+ * @xdp_ring: XDP ring to clean
  *
- * Returns true if cleanup/tranmission is done.
+ * Returns count of cleaned descriptors
  */
-bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
+static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 {
-	int total_packets = 0, total_bytes = 0;
-	s16 ntc = xdp_ring->next_to_clean;
-	struct ice_tx_desc *tx_desc;
+	struct ice_tx_desc *next_dd_desc;
+	u16 next_dd = xdp_ring->next_dd;
+	u16 desc_cnt = xdp_ring->count;
 	struct ice_tx_buf *tx_buf;
+	u16 ntc, cleared_dds = 0;
 	u32 xsk_frames = 0;
-	bool xmit_done;
+	u16 i;
 
-	tx_desc = ICE_TX_DESC(xdp_ring, ntc);
-	tx_buf = &xdp_ring->tx_buf[ntc];
-	ntc -= xdp_ring->count;
+	next_dd_desc = ICE_TX_DESC(xdp_ring, next_dd);
+	if (!(next_dd_desc->cmd_type_offset_bsz &
+	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
+		return 0;
 
-	do {
-		if (!(tx_desc->cmd_type_offset_bsz &
-		      cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
-			break;
+again:
+	cleared_dds++;
 
-		total_bytes += tx_buf->bytecount;
-		total_packets++;
+	ntc = xdp_ring->next_to_clean;
+
+	for (i = 0; i < ICE_TX_THRESH; i++) {
+		tx_buf = &xdp_ring->tx_buf[ntc];
 
 		if (tx_buf->raw_buf) {
 			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
@@ -712,34 +661,158 @@ bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
 			xsk_frames++;
 		}
 
-		tx_desc->cmd_type_offset_bsz = 0;
-		tx_buf++;
-		tx_desc++;
 		ntc++;
+		if (ntc >= xdp_ring->count)
+			ntc = 0;
+	}
 
-		if (unlikely(!ntc)) {
-			ntc -= xdp_ring->count;
-			tx_buf = xdp_ring->tx_buf;
-			tx_desc = ICE_TX_DESC(xdp_ring, 0);
-		}
+	xdp_ring->next_to_clean += ICE_TX_THRESH;
+	if (xdp_ring->next_to_clean >= desc_cnt)
+		xdp_ring->next_to_clean -= desc_cnt;
+	if (xsk_frames)
+		xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
+	next_dd_desc->cmd_type_offset_bsz = 0;
+	xdp_ring->next_dd = xdp_ring->next_dd + ICE_TX_THRESH;
+	if (xdp_ring->next_dd >= desc_cnt)
+		xdp_ring->next_dd = ICE_TX_THRESH - 1;
 
-		prefetch(tx_desc);
+	next_dd_desc = ICE_TX_DESC(xdp_ring, next_dd);
+	if ((next_dd_desc->cmd_type_offset_bsz &
+	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
+		goto again;
 
-	} while (likely(--budget));
+	return cleared_dds * ICE_TX_THRESH;
+}
 
-	ntc += xdp_ring->count;
-	xdp_ring->next_to_clean = ntc;
+/**
+ * ice_xmit_pkt - produce a single HW Tx descriptor out of AF_XDP descriptor
+ * @xdp_ring: XDP ring to produce the HW Tx descriptor on
+ * @desc: AF_XDP descriptor to pull the DMA address and length from
+ * @total_bytes: bytes accumulator that will be used for stats update
+ */
+static void ice_xmit_pkt(struct ice_tx_ring *xdp_ring, struct xdp_desc *desc,
+			 unsigned int *total_bytes)
+{
+	struct ice_tx_desc *tx_desc;
+	dma_addr_t dma;
 
-	if (xsk_frames)
-		xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
+	dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc->addr);
+	xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, desc->len);
+
+	tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_to_use++);
+	tx_desc->buf_addr = cpu_to_le64(dma);
+	tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP,
+						      0, desc->len, 0);
+
+	*total_bytes += desc->len;
+}
+
+/**
+ * ice_xmit_pkt - produce a batch of HW Tx descriptors out of AF_XDP descriptors
+ * @xdp_ring: XDP ring to produce the HW Tx descriptors on
+ * @descs: AF_XDP descriptors to pull the DMA addresses and lengths from
+ * @total_bytes: bytes accumulator that will be used for stats update
+ */
+static void ice_xmit_pkt_batch(struct ice_tx_ring *xdp_ring, struct xdp_desc *descs,
+			       unsigned int *total_bytes)
+{
+	u16 ntu = xdp_ring->next_to_use;
+	struct ice_tx_desc *tx_desc;
+	dma_addr_t dma;
+	u32 i;
+
+	loop_unrolled_for(i = 0; i < PKTS_PER_BATCH; i++) {
+		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, descs[i].addr);
+		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, descs[i].len);
+
+		tx_desc = ICE_TX_DESC(xdp_ring, ntu++);
+		tx_desc->buf_addr = cpu_to_le64(dma);
+		tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP,
+							      0, descs[i].len, 0);
+
+		*total_bytes += descs[i].len;
+	}
+
+	xdp_ring->next_to_use = ntu;
+
+	if (xdp_ring->next_to_use > xdp_ring->next_rs) {
+		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
+		tx_desc->cmd_type_offset_bsz |=
+			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
+		xdp_ring->next_rs += ICE_TX_THRESH;
+	}
+}
+
+/**
+ * ice_fill_tx_hw_ring - produce the number of Tx descriptors onto ring
+ * @xdp_ring: XDP ring to produce the HW Tx descriptors on
+ * @descs: AF_XDP descriptors to pull the DMA addresses and lengths from
+ * @nb_pkts: count of packets to be send
+ * @total_bytes: bytes accumulator that will be used for stats update
+ *
+ */
+static void ice_fill_tx_hw_ring(struct ice_tx_ring *xdp_ring, struct xdp_desc *descs,
+				u32 nb_pkts, unsigned int *total_bytes)
+{
+	struct ice_tx_desc *tx_desc;
+	u32 batched, leftover, i;
+
+	batched = nb_pkts & ~(PKTS_PER_BATCH - 1);
+	leftover = nb_pkts & (PKTS_PER_BATCH - 1);
+	for (i = 0; i < batched; i += PKTS_PER_BATCH)
+		ice_xmit_pkt_batch(xdp_ring, &descs[i], total_bytes);
+	for (i = batched; i < batched + leftover; i++)
+		ice_xmit_pkt(xdp_ring, &descs[i], total_bytes);
+
+	if (xdp_ring->next_to_use > xdp_ring->next_rs) {
+		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
+		tx_desc->cmd_type_offset_bsz |=
+			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
+		xdp_ring->next_rs += ICE_TX_THRESH;
+	}
+}
+
+/**
+ * ice_xmit_zc - take entries from XSK Tx ring and place them onto HW Tx ring
+ * @xdp_ring: XDP ring to produce the HW Tx descriptors on
+ * @budget: number of free descriptors on HW Tx ring that can be used
+ *
+ * Returns true if there is no more work that needs to be done, false otherwise
+ */
+bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget)
+{
+	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
+	u32 nb_pkts, nb_processed = 0;
+	unsigned int total_bytes = 0;
+	struct ice_tx_desc *tx_desc;
+
+	if (budget < ICE_TX_THRESH)
+		budget += ice_clean_xdp_irq_zc(xdp_ring);
+
+	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
+	if (!nb_pkts)
+		return true;
+
+	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
+		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
+		ice_fill_tx_hw_ring(xdp_ring, descs, nb_processed, &total_bytes);
+		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
+		tx_desc->cmd_type_offset_bsz |=
+			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
+		xdp_ring->next_rs = ICE_TX_THRESH - 1;
+		xdp_ring->next_to_use = 0;
+	}
+
+	ice_fill_tx_hw_ring(xdp_ring, &descs[nb_processed], nb_pkts - nb_processed,
+			    &total_bytes);
+
+	ice_xdp_ring_update_tail(xdp_ring);
+	ice_update_tx_ring_stats(xdp_ring, nb_pkts, total_bytes);
 
 	if (xsk_uses_need_wakeup(xdp_ring->xsk_pool))
 		xsk_set_tx_need_wakeup(xdp_ring->xsk_pool);
 
-	ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
-	xmit_done = ice_xmit_zc(xdp_ring, ICE_DFLT_IRQ_WORK);
-
-	return budget > 0 && xmit_done;
+	return nb_pkts < budget;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index 4c7bd8e9dfc4..f2eb99063c1f 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -6,19 +6,36 @@
 #include "ice_txrx.h"
 #include "ice.h"
 
+#define PKTS_PER_BATCH 8
+
+#ifdef __clang__
+#define loop_unrolled_for _Pragma("clang loop unroll_count(8)") for
+#elif __GNUC__ >= 4
+#define loop_unrolled_for _Pragma("GCC unroll 8") for
+#else
+#define loop_unrolled_for for
+#endif
+
 struct ice_vsi;
 
 #ifdef CONFIG_XDP_SOCKETS
 int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool,
 		       u16 qid);
 int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget);
-bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget);
 int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
 bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count);
 bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
 void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring);
 void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring);
+bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget);
 #else
+static inline bool
+ice_xmit_zc(struct ice_tx_ring __always_unused *xdp_ring,
+	    u32 __always_unused budget)
+{
+	return false;
+}
+
 static inline int
 ice_xsk_pool_setup(struct ice_vsi __always_unused *vsi,
 		   struct xsk_buff_pool __always_unused *pool,
@@ -34,13 +51,6 @@ ice_clean_rx_irq_zc(struct ice_rx_ring __always_unused *rx_ring,
 	return 0;
 }
 
-static inline bool
-ice_clean_tx_irq_zc(struct ice_tx_ring __always_unused *xdp_ring,
-		    int __always_unused budget)
-{
-	return false;
-}
-
 static inline bool
 ice_alloc_rx_bufs_zc(struct ice_rx_ring __always_unused *rx_ring,
 		     u16 __always_unused count)
-- 
2.33.1

