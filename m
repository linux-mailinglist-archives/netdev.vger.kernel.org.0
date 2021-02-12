Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3947931A7FD
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhBLWpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:45:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:44262 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232270AbhBLWnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:43:06 -0500
IronPort-SDR: QGmZrQjvCInLwru9aigBg/ioe/jr9fWxlUivQXPiW09sRcqV16sapsWFcFDGdP6K3j7NbUOcur
 KYYNAWWkJcgA==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="169617160"
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="169617160"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 14:39:00 -0800
IronPort-SDR: 7RvtZb4XZQklOeJPPPg2cI0eXTVkEvjqa16WeOHWEP1OqbGJdny+GpmVWyJtC9jTCDJULfrlN2
 LbEifjTV+ouw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="381885366"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 12 Feb 2021 14:39:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 05/11] ice: move skb pointer from rx_buf to rx_ring
Date:   Fri, 12 Feb 2021 14:39:46 -0800
Message-Id: <20210212223952.1172568-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
References: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Similar thing has been done in i40e, as there is no real need for having
the sk_buff pointer in each rx_buf. Non-eop frames can be simply handled
on that pointer moved upwards to rx_ring.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 30 ++++++++++-------------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  2 +-
 2 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 47d8100159c5..d92ddcdeaa4d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -375,6 +375,11 @@ void ice_clean_rx_ring(struct ice_ring *rx_ring)
 	if (!rx_ring->rx_buf)
 		return;
 
+	if (rx_ring->skb) {
+		dev_kfree_skb(rx_ring->skb);
+		rx_ring->skb = NULL;
+	}
+
 	if (rx_ring->xsk_pool) {
 		ice_xsk_clean_rx_ring(rx_ring);
 		goto rx_skip_free;
@@ -384,10 +389,6 @@ void ice_clean_rx_ring(struct ice_ring *rx_ring)
 	for (i = 0; i < rx_ring->count; i++) {
 		struct ice_rx_buf *rx_buf = &rx_ring->rx_buf[i];
 
-		if (rx_buf->skb) {
-			dev_kfree_skb(rx_buf->skb);
-			rx_buf->skb = NULL;
-		}
 		if (!rx_buf->page)
 			continue;
 
@@ -850,7 +851,6 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
 /**
  * ice_get_rx_buf - Fetch Rx buffer and synchronize data for use
  * @rx_ring: Rx descriptor ring to transact packets on
- * @skb: skb to be used
  * @size: size of buffer to add to skb
  * @rx_buf_pgcnt: rx_buf page refcount
  *
@@ -858,8 +858,8 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
  * for use by the CPU.
  */
 static struct ice_rx_buf *
-ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
-	       const unsigned int size, int *rx_buf_pgcnt)
+ice_get_rx_buf(struct ice_ring *rx_ring, const unsigned int size,
+	       int *rx_buf_pgcnt)
 {
 	struct ice_rx_buf *rx_buf;
 
@@ -871,7 +871,6 @@ ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
 		0;
 #endif
 	prefetchw(rx_buf->page);
-	*skb = rx_buf->skb;
 
 	if (!size)
 		return rx_buf;
@@ -1033,29 +1032,24 @@ ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
 
 	/* clear contents of buffer_info */
 	rx_buf->page = NULL;
-	rx_buf->skb = NULL;
 }
 
 /**
  * ice_is_non_eop - process handling of non-EOP buffers
  * @rx_ring: Rx ring being processed
  * @rx_desc: Rx descriptor for current buffer
- * @skb: Current socket buffer containing buffer in progress
  *
  * If the buffer is an EOP buffer, this function exits returning false,
  * otherwise return true indicating that this is in fact a non-EOP buffer.
  */
 static bool
-ice_is_non_eop(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
-	       struct sk_buff *skb)
+ice_is_non_eop(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc)
 {
 	/* if we are the last buffer then there is nothing else to do */
 #define ICE_RXD_EOF BIT(ICE_RX_FLEX_DESC_STATUS0_EOF_S)
 	if (likely(ice_test_staterr(rx_desc, ICE_RXD_EOF)))
 		return false;
 
-	/* place skb in next buffer to be received */
-	rx_ring->rx_buf[rx_ring->next_to_clean].skb = skb;
 	rx_ring->rx_stats.non_eop_descs++;
 
 	return true;
@@ -1078,6 +1072,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0, frame_sz = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
 	unsigned int xdp_res, xdp_xmit = 0;
+	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
 	struct xdp_buff xdp;
 	bool failure;
@@ -1094,7 +1089,6 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		union ice_32b_rx_flex_desc *rx_desc;
 		struct ice_rx_buf *rx_buf;
 		unsigned char *hard_start;
-		struct sk_buff *skb;
 		unsigned int size;
 		u16 stat_err_bits;
 		int rx_buf_pgcnt;
@@ -1129,7 +1123,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
 		/* retrieve a buffer from the ring */
-		rx_buf = ice_get_rx_buf(rx_ring, &skb, size, &rx_buf_pgcnt);
+		rx_buf = ice_get_rx_buf(rx_ring, size, &rx_buf_pgcnt);
 
 		if (!size) {
 			xdp.data = NULL;
@@ -1191,7 +1185,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		cleaned_count++;
 
 		/* skip if it is NOP desc */
-		if (ice_is_non_eop(rx_ring, rx_desc, skb))
+		if (ice_is_non_eop(rx_ring, rx_desc))
 			continue;
 
 		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_RXE_S);
@@ -1221,6 +1215,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 
 		/* send completed skb up the stack */
 		ice_receive_skb(rx_ring, skb, vlan_tag);
+		skb = NULL;
 
 		/* update budget accounting */
 		total_rx_pkts++;
@@ -1231,6 +1226,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 
 	if (xdp_prog)
 		ice_finalize_xdp_rx(rx_ring, xdp_xmit);
+	rx_ring->skb = skb;
 
 	ice_update_rx_ring_stats(rx_ring, total_rx_pkts, total_rx_bytes);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index db56a0c8bfe1..1425f5e68611 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -165,7 +165,6 @@ struct ice_tx_offload_params {
 struct ice_rx_buf {
 	union {
 		struct {
-			struct sk_buff *skb;
 			dma_addr_t dma;
 			struct page *page;
 			unsigned int page_offset;
@@ -297,6 +296,7 @@ struct ice_ring {
 	struct xsk_buff_pool *xsk_pool;
 	/* CL3 - 3rd cacheline starts here */
 	struct xdp_rxq_info xdp_rxq;
+	struct sk_buff *skb;
 	/* CLX - the below items are only accessed infrequently and should be
 	 * in their own cache line if possible
 	 */
-- 
2.26.2

