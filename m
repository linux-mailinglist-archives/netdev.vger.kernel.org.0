Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87243EC346
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 16:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbhHNOYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 10:24:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:45196 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238666AbhHNOYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 10:24:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="279426335"
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="279426335"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2021 07:23:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="447568490"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 14 Aug 2021 07:23:13 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        brett.creeley@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 intel-next 7/9] ice: optimize XDP_TX workloads
Date:   Sat, 14 Aug 2021 16:08:10 +0200
Message-Id: <20210814140812.46632-8-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
References: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Optimize Tx descriptor cleaning for XDP. Current approach doesn't
really scale and chokes when multiple flows are handled.

Introduce two ring fields, @next_dd and @next_rs that will keep track of
descriptor that should be looked at when the need for cleaning arise and
the descriptor that should have the RS bit set, respectively.

Note that at this point the threshold is a constant (32), but it is
something that we could make configurable.

First thing is to get away from setting RS bit on each descriptor. Let's
do this only once NTU is higher than the currently @next_rs value. In
such case, grab the tx_desc[next_rs], set the RS bit in descriptor and
advance the @next_rs by a 32.

Second thing is to clean the Tx ring only when there are less than 32
free entries. For that case, look up the tx_desc[next_dd] for a DD bit.
This bit is written back by HW to let the driver know that xmit was
successful. It will happen only for those descriptors that had RS bit
set. Clean only 32 descriptors and advance the DD bit.

Actual cleaning routine is moved from ice_napi_poll() down to the
ice_xmit_xdp_ring(). It is safe to do so as XDP ring will not get any
SKBs in there that would rely on interrupts for the cleaning. Nice side
effect is that for rare case of Tx fallback path (that next patch is
going to introduce) we don't have to trigger the SW irq to clean the
ring.

With those two concepts, ring is kept at being almost full, but it is
guaranteed that driver will be able to produce Tx descriptors.

This approach seems to work out well even though the Tx descriptors are
produced in one-by-one manner. Test was conducted with the ice HW
bombarded with packets from HW generator, configured to generate 30
flows.

Xdp2 sample yields the following results:
<snip>
proto 17:   79973066 pkt/s
proto 17:   80018911 pkt/s
proto 17:   80004654 pkt/s
proto 17:   79992395 pkt/s
proto 17:   79975162 pkt/s
proto 17:   79955054 pkt/s
proto 17:   79869168 pkt/s
proto 17:   79823947 pkt/s
proto 17:   79636971 pkt/s
</snip>

As that sample reports the Rx'ed frames, let's look at sar output.
It says that what we Rx'ed we do actually Tx, no noticeable drops.
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s txcmp/s  rxmcst/s   %ifutil
Average:       ens4f1 79842324.00 79842310.40 4678261.17 4678260.38 0.00      0.00      0.00     38.32

with tx_busy staying calm.

When compared to a state before:
Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s txcmp/s  rxmcst/s   %ifutil
Average:       ens4f1 90919711.60 42233822.60 5327326.85 2474638.04 0.00      0.00      0.00     43.64

it can be observed that the amount of txpck/s is almost doubled, meaning
that the performance is improved by around 90%. All of this due to the
drops in the driver, previously the tx_busy stat was bumped at a 7mpps
rate.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c     |  9 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 21 +++---
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 10 ++-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 73 ++++++++++++++++---
 4 files changed, 88 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c59e042de4f3..737b52b51101 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2367,7 +2367,8 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 {
 	struct device *dev = ice_pf_to_dev(vsi->back);
-	int i;
+	struct ice_tx_desc *tx_desc;
+	int i, j;
 
 	for (i = 0; i < vsi->num_xdp_txq; i++) {
 		u16 xdp_q_idx = vsi->alloc_txq + i;
@@ -2382,6 +2383,8 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		xdp_ring->reg_idx = vsi->txq_map[xdp_q_idx];
 		xdp_ring->vsi = vsi;
 		xdp_ring->netdev = NULL;
+		xdp_ring->next_dd = ICE_TX_THRESH - 1;
+		xdp_ring->next_rs = ICE_TX_THRESH - 1;
 		xdp_ring->dev = dev;
 		xdp_ring->count = vsi->num_tx_desc;
 		WRITE_ONCE(vsi->xdp_rings[i], xdp_ring);
@@ -2389,6 +2392,10 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 			goto free_xdp_rings;
 		ice_set_ring_xdp(xdp_ring);
 		xdp_ring->xsk_pool = ice_tx_xsk_pool(xdp_ring);
+		for (j = 0; j < xdp_ring->count; j++) {
+			tx_desc = ICE_TX_DESC(xdp_ring, j);
+			tx_desc->cmd_type_offset_bsz = cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE);
+		}
 	}
 
 	ice_for_each_rxq(vsi, i)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 8bae13d95f53..ca1f24deb3fd 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -245,11 +245,8 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 		total_bytes += tx_buf->bytecount;
 		total_pkts += tx_buf->gso_segs;
 
-		if (ice_ring_is_xdp(tx_ring))
-			page_frag_free(tx_buf->raw_buf);
-		else
-			/* free the skb */
-			napi_consume_skb(tx_buf->skb, napi_budget);
+		/* free the skb */
+		napi_consume_skb(tx_buf->skb, napi_budget);
 
 		/* unmap skb header data */
 		dma_unmap_single(tx_ring->dev,
@@ -305,9 +302,6 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 
 	ice_update_tx_ring_stats(tx_ring, total_pkts, total_bytes);
 
-	if (ice_ring_is_xdp(tx_ring))
-		return !!budget;
-
 	netdev_tx_completed_queue(txring_txq(tx_ring), total_pkts,
 				  total_bytes);
 
@@ -1416,9 +1410,14 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	 * budget and be more aggressive about cleaning up the Tx descriptors.
 	 */
 	ice_for_each_tx_ring(tx_ring, q_vector->tx) {
-		bool wd = tx_ring->xsk_pool ?
-			  ice_clean_tx_irq_zc(tx_ring, budget) :
-			  ice_clean_tx_irq(tx_ring, budget);
+		bool wd;
+
+		if (tx_ring->xsk_pool)
+			wd = ice_clean_tx_irq_zc(tx_ring, budget);
+		else if (ice_ring_is_xdp(tx_ring))
+			wd = true;
+		else
+			wd = ice_clean_tx_irq(tx_ring, budget);
 
 		if (!wd)
 			clean_complete = false;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index f35a4002eadd..7f6811f6ae42 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -13,6 +13,7 @@
 #define ICE_MAX_CHAINED_RX_BUFS	5
 #define ICE_MAX_BUF_TXD		8
 #define ICE_MIN_TX_LEN		17
+#define ICE_TX_THRESH		32
 
 /* The size limit for a transmit buffer in a descriptor is (16K - 1).
  * In order to align with the read requests we will align the value to
@@ -313,12 +314,15 @@ struct ice_tx_ring {
 	struct ice_vsi *vsi;		/* Backreference to associated VSI */
 	/* CL2 - 2nd cacheline starts here */
 	dma_addr_t dma;			/* physical address of ring */
+	struct xsk_buff_pool *xsk_pool;
 	u16 next_to_use;
 	u16 next_to_clean;
+	u16 next_rs;
+	u16 next_dd;
+	u16 q_handle;			/* Queue handle per TC */
+	u16 reg_idx;			/* HW register index of the ring */
 	u16 count;			/* Number of descriptors */
 	u16 q_index;			/* Queue number of ring */
-	struct xsk_buff_pool *xsk_pool;
-
 	/* stats structs */
 	struct ice_q_stats	stats;
 	struct u64_stats_sync syncp;
@@ -329,8 +333,6 @@ struct ice_tx_ring {
 	DECLARE_BITMAP(xps_state, ICE_TX_NBITS);	/* XPS Config State */
 	struct ice_ptp_tx *tx_tstamps;
 	u32 txq_teid;			/* Added Tx queue TEID */
-	u16 q_handle;			/* Queue handle per TC */
-	u16 reg_idx;			/* HW register index of the ring */
 #define ICE_TX_FLAGS_RING_XDP		BIT(0)
 	u8 flags;
 	u8 dcb_tc;			/* Traffic class of ring */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 294f30496322..c31c451e67af 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019, Intel Corporation. */
 
 #include "ice_txrx_lib.h"
+#include "ice_lib.h"
 
 /**
  * ice_release_rx_desc - Store the new tail and head values
@@ -211,6 +212,52 @@ ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
 	napi_gro_receive(&rx_ring->q_vector->napi, skb);
 }
 
+/**
+ * ice_clean_xdp_irq - Reclaim resources after transmit completes on XDP ring
+ * @xdp_ring: XDP ring to clean
+ */
+static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
+{
+	unsigned int total_bytes = 0, total_pkts = 0;
+	u16 ntc = xdp_ring->next_to_clean;
+	struct ice_tx_desc *next_dd_desc;
+	u16 next_dd = xdp_ring->next_dd;
+	struct ice_tx_buf *tx_buf;
+	int i;
+
+	next_dd_desc = ICE_TX_DESC(xdp_ring, next_dd);
+	if (!(next_dd_desc->cmd_type_offset_bsz &
+	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
+		return;
+
+	for (i = 0; i < ICE_TX_THRESH; i++) {
+		tx_buf = &xdp_ring->tx_buf[ntc];
+
+		total_bytes += tx_buf->bytecount;
+		/* normally tx_buf->gso_segs was taken but at this point
+		 * it's always 1 for us
+		 */
+		total_pkts++;
+
+		page_frag_free(tx_buf->raw_buf);
+		dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
+				 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
+		dma_unmap_len_set(tx_buf, len, 0);
+		tx_buf->raw_buf = NULL;
+
+		ntc++;
+		if (ntc >= xdp_ring->count)
+			ntc = 0;
+	}
+
+	next_dd_desc->cmd_type_offset_bsz = 0;
+	xdp_ring->next_dd = xdp_ring->next_dd + ICE_TX_THRESH;
+	if (xdp_ring->next_dd > xdp_ring->count)
+		xdp_ring->next_dd = ICE_TX_THRESH - 1;
+	xdp_ring->next_to_clean = ntc;
+	ice_update_tx_ring_stats(xdp_ring, total_pkts, total_bytes);
+}
+
 /**
  * ice_xmit_xdp_ring - submit single packet to XDP ring for transmission
  * @data: packet data pointer
@@ -224,6 +271,9 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
 	struct ice_tx_buf *tx_buf;
 	dma_addr_t dma;
 
+	if (ICE_DESC_UNUSED(xdp_ring) < ICE_TX_THRESH)
+		ice_clean_xdp_irq(xdp_ring);
+
 	if (!unlikely(ICE_DESC_UNUSED(xdp_ring))) {
 		xdp_ring->tx_stats.tx_busy++;
 		return ICE_XDP_CONSUMED;
@@ -244,21 +294,26 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
 
 	tx_desc = ICE_TX_DESC(xdp_ring, i);
 	tx_desc->buf_addr = cpu_to_le64(dma);
-	tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TXD_LAST_DESC_CMD, 0,
+	tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP, 0,
 						      size, 0);
 
-	/* Make certain all of the status bits have been updated
-	 * before next_to_watch is written.
-	 */
-	smp_wmb();
-
 	i++;
-	if (i == xdp_ring->count)
+	if (i == xdp_ring->count) {
 		i = 0;
-
-	tx_buf->next_to_watch = tx_desc;
+		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
+		tx_desc->cmd_type_offset_bsz |=
+			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
+		xdp_ring->next_rs = ICE_TX_THRESH - 1;
+	}
 	xdp_ring->next_to_use = i;
 
+	if (i > xdp_ring->next_rs) {
+		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
+		tx_desc->cmd_type_offset_bsz |=
+			cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
+		xdp_ring->next_rs += ICE_TX_THRESH;
+	}
+
 	return ICE_XDP_TX;
 }
 
-- 
2.20.1

