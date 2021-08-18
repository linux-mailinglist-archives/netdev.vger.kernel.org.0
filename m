Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F533F0650
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbhHRORs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:17:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:3783 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239783AbhHROQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 10:16:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="213206848"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="213206848"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 07:15:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="531703679"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2021 07:15:03 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        brett.creeley@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v6 intel-next 6/9] ice: propagate xdp_ring onto rx_ring
Date:   Wed, 18 Aug 2021 15:59:13 +0200
Message-Id: <20210818135916.25007-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210818135916.25007-1-maciej.fijalkowski@intel.com>
References: <20210818135916.25007-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With rings being split, it is now convenient to introduce a pointer to
XDP ring within the Rx ring. For XDP_TX workloads this means that
xdp_rings array access will be skipped, which was executed per each
processed frame.

Also, read the XDP prog once per NAPI and if prog is present, set up the
local xdp_ring pointer. Reading prog a single time was discussed in [1]
with some concern raised by Toke around dispatcher handling and having
the need for going through the RCU grace period in the ndo_bpf driver
callback, but ice currently is torning down NAPI instances regardless of
the prog presence on VSI.

Although the pointer to XDP ring introduced to Rx ring makes things a
lot slimmer/simpler, I still feel that single prog read per NAPI
lifetime is beneficial.

Further patch that will introduce the fallback path will also get a
profit from that as xdp_ring pointer will be set during the XDP rings
setup.

[1]: https://lore.kernel.org/bpf/87k0oseo6e.fsf@toke.dk/

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +++
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 23 +++++++++--------
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 10 +++-----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 25 +++++++++++--------
 6 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8dc00a14ef56..de6305a8ec4f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2452,6 +2452,9 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		xdp_ring->xsk_pool = ice_tx_xsk_pool(xdp_ring);
 	}
 
+	ice_for_each_rxq(vsi, i)
+		vsi->rx_rings[i]->xdp_ring = vsi->xdp_rings[i];
+
 	return 0;
 
 free_xdp_rings:
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 7739cd379052..b4aaed34f10a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -537,15 +537,15 @@ ice_rx_frame_truesize(struct ice_rx_ring *rx_ring, unsigned int __maybe_unused s
  * @rx_ring: Rx ring
  * @xdp: xdp_buff used as input to the XDP program
  * @xdp_prog: XDP program to run
+ * @xdp_ring: ring to be used for XDP_TX action
  *
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
 static int
 ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
-	    struct bpf_prog *xdp_prog)
+	    struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring)
 {
-	struct ice_tx_ring *xdp_ring;
-	int err, result;
+	int err;
 	u32 act;
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
@@ -553,11 +553,10 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	case XDP_PASS:
 		return ICE_XDP_PASS;
 	case XDP_TX:
-		xdp_ring = rx_ring->vsi->xdp_rings[smp_processor_id()];
-		result = ice_xmit_xdp_ring(xdp->data, xdp->data_end - xdp->data, xdp_ring);
-		if (result == ICE_XDP_CONSUMED)
+		err = ice_xmit_xdp_ring(xdp->data, xdp->data_end - xdp->data, xdp_ring);
+		if (err == ICE_XDP_CONSUMED)
 			goto out_failure;
-		return result;
+		return err;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
 		if (err)
@@ -1083,6 +1082,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0, frame_sz = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
 	unsigned int offset = rx_ring->rx_offset;
+	struct ice_tx_ring *xdp_ring = NULL;
 	unsigned int xdp_res, xdp_xmit = 0;
 	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
@@ -1095,6 +1095,10 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 #endif
 	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
+	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
+	if (xdp_prog)
+		xdp_ring = rx_ring->xdp_ring;
+
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
@@ -1158,11 +1162,10 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
 #endif
 
-		xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 		if (!xdp_prog)
 			goto construct_skb;
 
-		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_prog);
+		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_prog, xdp_ring);
 		if (!xdp_res)
 			goto construct_skb;
 		if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
@@ -1239,7 +1242,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	failure = ice_alloc_rx_bufs(rx_ring, cleaned_count);
 
 	if (xdp_prog)
-		ice_finalize_xdp_rx(rx_ring, xdp_xmit);
+		ice_finalize_xdp_rx(xdp_ring, xdp_xmit);
 	rx_ring->skb = skb;
 
 	ice_update_rx_ring_stats(rx_ring, total_rx_pkts, total_rx_bytes);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 7e151bc23094..4b0338a2cfdc 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -290,6 +290,7 @@ struct ice_rx_ring {
 	struct rcu_head rcu;		/* to avoid race on free */
 	/* CL4 - 3rd cacheline starts here */
 	struct bpf_prog *xdp_prog;
+	struct ice_tx_ring *xdp_ring;
 	struct xsk_buff_pool *xsk_pool;
 	struct sk_buff *skb;
 	dma_addr_t dma;			/* physical address of ring */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index bc64610df7cb..5c2319e0c66d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -283,22 +283,18 @@ int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring)
 
 /**
  * ice_finalize_xdp_rx - Bump XDP Tx tail and/or flush redirect map
- * @rx_ring: Rx ring
+ * @xdp_ring: XDP ring
  * @xdp_res: Result of the receive batch
  *
  * This function bumps XDP Tx tail and/or flush redirect map, and
  * should be called when a batch of packets has been processed in the
  * napi loop.
  */
-void ice_finalize_xdp_rx(struct ice_rx_ring *rx_ring, unsigned int xdp_res)
+void ice_finalize_xdp_rx(struct ice_tx_ring *xdp_ring, unsigned int xdp_res)
 {
 	if (xdp_res & ICE_XDP_REDIR)
 		xdp_do_flush_map();
 
-	if (xdp_res & ICE_XDP_TX) {
-		struct ice_tx_ring *xdp_ring =
-			rx_ring->vsi->xdp_rings[smp_processor_id()];
-
+	if (xdp_res & ICE_XDP_TX)
 		ice_xdp_ring_update_tail(xdp_ring);
-	}
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index 4e56e8e321a8..11b6c1601986 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -46,7 +46,7 @@ static inline void ice_xdp_ring_update_tail(struct ice_tx_ring *xdp_ring)
 	writel_relaxed(xdp_ring->next_to_use, xdp_ring->tail);
 }
 
-void ice_finalize_xdp_rx(struct ice_rx_ring *xdp_ring, unsigned int xdp_res);
+void ice_finalize_xdp_rx(struct ice_tx_ring *xdp_ring, unsigned int xdp_res);
 int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring);
 int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring);
 void ice_release_rx_desc(struct ice_rx_ring *rx_ring, u16 val);
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 7664358ec18e..24791702e313 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -458,22 +458,18 @@ ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf)
  * ice_run_xdp_zc - Executes an XDP program in zero-copy path
  * @rx_ring: Rx ring
  * @xdp: xdp_buff used as input to the XDP program
+ * @xdp_prog: XDP program to run
+ * @xdp_ring: ring to be used for XDP_TX action
  *
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
 static int
-ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
+ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
+	       struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring)
 {
 	int err, result = ICE_XDP_PASS;
-	struct ice_tx_ring *xdp_ring;
-	struct bpf_prog *xdp_prog;
 	u32 act;
 
-	/* ZC patch is enabled only when XDP program is set,
-	 * so here it can not be NULL
-	 */
-	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
-
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	if (likely(act == XDP_REDIRECT)) {
@@ -487,7 +483,6 @@ ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->q_index];
 		result = ice_xmit_xdp_buff(xdp, xdp_ring);
 		if (result == ICE_XDP_CONSUMED)
 			goto out_failure;
@@ -518,9 +513,17 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
+	struct ice_tx_ring *xdp_ring;
 	unsigned int xdp_xmit = 0;
+	struct bpf_prog *xdp_prog;
 	bool failure = false;
 
+	/* ZC patch is enabled only when XDP program is set,
+	 * so here it can not be NULL
+	 */
+	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
+	xdp_ring = rx_ring->xdp_ring;
+
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
 		unsigned int size, xdp_res = 0;
@@ -551,7 +554,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		rx_buf->xdp->data_end = rx_buf->xdp->data + size;
 		xsk_buff_dma_sync_for_cpu(rx_buf->xdp, rx_ring->xsk_pool);
 
-		xdp_res = ice_run_xdp_zc(rx_ring, rx_buf->xdp);
+		xdp_res = ice_run_xdp_zc(rx_ring, rx_buf->xdp, xdp_prog, xdp_ring);
 		if (xdp_res) {
 			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))
 				xdp_xmit |= xdp_res;
@@ -599,7 +602,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 	if (cleaned_count >= ICE_RX_BUF_WRITE)
 		failure = !ice_alloc_rx_bufs_zc(rx_ring, cleaned_count);
 
-	ice_finalize_xdp_rx(rx_ring, xdp_xmit);
+	ice_finalize_xdp_rx(xdp_ring, xdp_xmit);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
 
 	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
-- 
2.20.1

