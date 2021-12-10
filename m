Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B574706C6
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbhLJRSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:18:51 -0500
Received: from mga04.intel.com ([192.55.52.120]:27809 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhLJRSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 12:18:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639156515; x=1670692515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v1Mz+KXP4rPzOMSwMvGamNtgthZelrfbpqffSOoca7A=;
  b=OIJDrLdNnWHnylnT7k047i6qaAsuFib+QLnQ2wRIyNacmKxIXotwZ7lI
   kxg8EOkA/2+nmMw0Fshdn1iqznZPf3ngPs+zlwjd//GbfmpcGGWqAYXHb
   rdp1gXj2AgDuyKUBvk66qNfXrV3OELV9z9wM066SQK6I5T4YzYI2oeM4W
   dKt1y3HYGsr0W1ozvHXSDCn+cmen+2D076zPBRkSqpFmgDJDbL49671AJ
   19jfiSyTAo69u/gdexrjEqTOjFEx5i6NJ2dClk3xmoxvbIn7N5D0aUGGR
   xyCxwrCPUnYncn39hbuAaDAwhJHOJW04nFodD6BXqj5pfCp0yCY1ur/MH
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="237120427"
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="237120427"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 09:14:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,196,1635231600"; 
   d="scan'208";a="516848756"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 10 Dec 2021 09:14:36 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 2/3] ice: xsk: improve AF_XDP ZC Tx side
Date:   Fri, 10 Dec 2021 18:14:24 +0100
Message-Id: <20211210171425.11475-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210171425.11475-1-maciej.fijalkowski@intel.com>
References: <20211210171425.11475-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow mostly the logic from commit 9610bd988df9 ("ice: optimize XDP_TX
workloads") that has been done in order to address the massive tx_busy
statistic bump and improve the performance as well.

One difference from 'xdpdrv' XDP_TX is when ring has less than
ICE_TX_THRESH free entries, the cleaning routine will not stop after
cleaning a single ICE_TX_THRESH amount of descs but rather will forward
the next_dd pointer and check the DD bit and for this bit being set the
cleaning will be repeated. IOW clean until there are descs that can be
cleaned.

Single instance of txonly scenario from xdpsock is improved by 20%. It
takes four instances to achieve the line rate, which was not possible to
achieve previously.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 131 ++++++++++++----------
 drivers/net/ethernet/intel/ice/ice_xsk.h  |   5 +-
 4 files changed, 73 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 227513b687b9..4b0ddb6df0c7 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1452,7 +1452,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 		bool wd;
 
 		if (tx_ring->xsk_pool)
-			wd = ice_clean_tx_irq_zc(tx_ring, budget);
+			wd = ice_clean_tx_irq_zc(tx_ring);
 		else if (ice_ring_is_xdp(tx_ring))
 			wd = true;
 		else
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index b7b3bd4816f0..f2ebbe2158e7 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -321,9 +321,9 @@ struct ice_tx_ring {
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
index 925326c70701..a7f866b3fcd7 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -613,55 +613,68 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 /**
  * ice_xmit_zc - Completes AF_XDP entries, and cleans XDP entries
  * @xdp_ring: XDP Tx ring
- * @budget: max number of frames to xmit
  *
  * Returns true if cleanup/transmission is done.
  */
-static bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, int budget)
+static bool ice_xmit_zc(struct ice_tx_ring *xdp_ring)
 {
+	int total_packets = 0, total_bytes = 0;
 	struct ice_tx_desc *tx_desc = NULL;
-	bool work_done = true;
+	u16 ntu = xdp_ring->next_to_use;
 	struct xdp_desc desc;
 	dma_addr_t dma;
+	u16 budget = 0;
 
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
+	budget = ICE_DESC_UNUSED(xdp_ring);
+	if (unlikely(!budget)) {
+		xdp_ring->tx_stats.tx_busy++;
+		return false;
+	}
 
+	while (budget-- > 0) {
 		if (!xsk_tx_peek_desc(xdp_ring->xsk_pool, &desc))
 			break;
 
+		total_packets++;
 		dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc.addr);
 		xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
 						 desc.len);
 
-		tx_buf->bytecount = desc.len;
+		total_bytes += desc.len;
 
-		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_to_use);
+		tx_desc = ICE_TX_DESC(xdp_ring, ntu);
 		tx_desc->buf_addr = cpu_to_le64(dma);
 		tx_desc->cmd_type_offset_bsz =
-			ice_build_ctob(ICE_TXD_LAST_DESC_CMD, 0, desc.len, 0);
-
-		xdp_ring->next_to_use++;
-		if (xdp_ring->next_to_use == xdp_ring->count)
-			xdp_ring->next_to_use = 0;
+			ice_build_ctob(ICE_TX_DESC_CMD_EOP, 0, desc.len, 0);
+
+		ntu++;
+		if (ntu == xdp_ring->count) {
+			ntu = 0;
+			tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
+			tx_desc->cmd_type_offset_bsz |=
+				cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
+			xdp_ring->next_rs = ICE_TX_THRESH - 1;
+		}
+		if (ntu > xdp_ring->next_rs) {
+			tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
+			tx_desc->cmd_type_offset_bsz |=
+				cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
+			xdp_ring->next_rs += ICE_TX_THRESH;
+		}
 	}
 
+	xdp_ring->next_to_use = ntu;
 	if (tx_desc) {
 		ice_xdp_ring_update_tail(xdp_ring);
 		xsk_tx_release(xdp_ring->xsk_pool);
 	}
 
-	return budget > 0 && work_done;
-}
+	if (xsk_uses_need_wakeup(xdp_ring->xsk_pool))
+		xsk_set_tx_need_wakeup(xdp_ring->xsk_pool);
+	ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
 
+	return budget > 0;
+}
 /**
  * ice_clean_xdp_tx_buf - Free and unmap XDP Tx buffer
  * @xdp_ring: XDP Tx ring
@@ -679,30 +692,31 @@ ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 /**
  * ice_clean_tx_irq_zc - Completes AF_XDP entries, and cleans XDP entries
  * @xdp_ring: XDP Tx ring
- * @budget: NAPI budget
  *
  * Returns true if cleanup/tranmission is done.
  */
-bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
+bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring)
 {
-	int total_packets = 0, total_bytes = 0;
-	s16 ntc = xdp_ring->next_to_clean;
+	u16 next_dd = xdp_ring->next_dd;
+	u16 desc_cnt = xdp_ring->count;
 	struct ice_tx_desc *tx_desc;
 	struct ice_tx_buf *tx_buf;
-	u32 xsk_frames = 0;
-	bool xmit_done;
+	u32 xsk_frames;
+	u16 ntc;
+	int i;
 
-	tx_desc = ICE_TX_DESC(xdp_ring, ntc);
-	tx_buf = &xdp_ring->tx_buf[ntc];
-	ntc -= xdp_ring->count;
+	tx_desc = ICE_TX_DESC(xdp_ring, next_dd);
 
-	do {
-		if (!(tx_desc->cmd_type_offset_bsz &
-		      cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
-			break;
+	if (!(tx_desc->cmd_type_offset_bsz &
+	      cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
+		return ice_xmit_zc(xdp_ring);
 
-		total_bytes += tx_buf->bytecount;
-		total_packets++;
+again:
+	xsk_frames = 0;
+	ntc = xdp_ring->next_to_clean;
+
+	for (i = 0; i < ICE_TX_THRESH; i++) {
+		tx_buf = &xdp_ring->tx_buf[ntc];
 
 		if (tx_buf->raw_buf) {
 			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
@@ -711,34 +725,27 @@ bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
 			xsk_frames++;
 		}
 
-		tx_desc->cmd_type_offset_bsz = 0;
-		tx_buf++;
-		tx_desc++;
 		ntc++;
-
-		if (unlikely(!ntc)) {
-			ntc -= xdp_ring->count;
-			tx_buf = xdp_ring->tx_buf;
-			tx_desc = ICE_TX_DESC(xdp_ring, 0);
-		}
-
-		prefetch(tx_desc);
-
-	} while (likely(--budget));
-
-	ntc += xdp_ring->count;
-	xdp_ring->next_to_clean = ntc;
-
+		if (ntc >= xdp_ring->count)
+			ntc = 0;
+	}
+	xdp_ring->next_to_clean += ICE_TX_THRESH;
+	if (xdp_ring->next_to_clean >= desc_cnt)
+		xdp_ring->next_to_clean -= desc_cnt;
 	if (xsk_frames)
 		xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
-
-	if (xsk_uses_need_wakeup(xdp_ring->xsk_pool))
-		xsk_set_tx_need_wakeup(xdp_ring->xsk_pool);
-
-	ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
-	xmit_done = ice_xmit_zc(xdp_ring, ICE_DFLT_IRQ_WORK);
-
-	return budget > 0 && xmit_done;
+	tx_desc->cmd_type_offset_bsz = 0;
+	next_dd += ICE_TX_THRESH;
+	if (next_dd > desc_cnt)
+		next_dd = ICE_TX_THRESH - 1;
+
+	tx_desc = ICE_TX_DESC(xdp_ring, next_dd);
+	if ((tx_desc->cmd_type_offset_bsz &
+	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
+		goto again;
+	xdp_ring->next_dd = next_dd;
+
+	return ice_xmit_zc(xdp_ring);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index 4c7bd8e9dfc4..1f98ad090f89 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -12,7 +12,7 @@ struct ice_vsi;
 int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool,
 		       u16 qid);
 int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget);
-bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget);
+bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring);
 int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
 bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count);
 bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
@@ -35,8 +35,7 @@ ice_clean_rx_irq_zc(struct ice_rx_ring __always_unused *rx_ring,
 }
 
 static inline bool
-ice_clean_tx_irq_zc(struct ice_tx_ring __always_unused *xdp_ring,
-		    int __always_unused budget)
+ice_clean_tx_irq_zc(struct ice_tx_ring __always_unused *xdp_ring)
 {
 	return false;
 }
-- 
2.33.1

