Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CDF2FA670
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390440AbhARP45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:56:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:63478 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393439AbhARPY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 10:24:27 -0500
IronPort-SDR: hjpcMJYM5GBmdA1NH2+694PKHe83Rz+tzxKbUV/wjUJh57i1XL5O8jsuK2dw97dYMuch5I6YGn
 dlhteGPmFh4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="165905517"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="165905517"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 07:23:05 -0800
IronPort-SDR: /AAtrNXx2qDpe/AQNzQfGXAB9gFIbrprRcUCIWb1eaBgCn3YBIaIkJHqcn0J3vWTaN5E46YxaL
 3Ymlu6PnsBMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="500676342"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2021 07:23:03 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 net-next 05/11] ice: move skb pointer from rx_buf to rx_ring
Date:   Mon, 18 Jan 2021 16:13:12 +0100
Message-Id: <20210118151318.12324-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
References: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar thing has been done in i40e, as there is no real need for having
the sk_buff pointer in each rx_buf. Non-eop frames can be simply handled
on that pointer moved upwards to rx_ring.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 30 ++++++++++-------------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  2 +-
 2 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index dc1ad45eac8d..50fbb77bab70 100644
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
 
@@ -859,7 +860,6 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
 /**
  * ice_get_rx_buf - Fetch Rx buffer and synchronize data for use
  * @rx_ring: Rx descriptor ring to transact packets on
- * @skb: skb to be used
  * @size: size of buffer to add to skb
  * @rx_buf_pgcnt: rx_buf page refcount
  *
@@ -867,8 +867,8 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
  * for use by the CPU.
  */
 static struct ice_rx_buf *
-ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
-	       const unsigned int size, int *rx_buf_pgcnt)
+ice_get_rx_buf(struct ice_ring *rx_ring, const unsigned int size,
+	       int *rx_buf_pgcnt)
 {
 	struct ice_rx_buf *rx_buf;
 
@@ -880,7 +880,6 @@ ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
 		0;
 #endif
 	prefetchw(rx_buf->page);
-	*skb = rx_buf->skb;
 
 	if (!size)
 		return rx_buf;
@@ -1042,29 +1041,24 @@ ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
 
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
@@ -1087,6 +1081,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0, frame_sz = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
 	unsigned int xdp_res, xdp_xmit = 0;
+	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
 	struct xdp_buff xdp;
 	bool failure;
@@ -1103,7 +1098,6 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		union ice_32b_rx_flex_desc *rx_desc;
 		struct ice_rx_buf *rx_buf;
 		unsigned char *hard_start;
-		struct sk_buff *skb;
 		unsigned int size;
 		u16 stat_err_bits;
 		int rx_buf_pgcnt;
@@ -1138,7 +1132,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
 		/* retrieve a buffer from the ring */
-		rx_buf = ice_get_rx_buf(rx_ring, &skb, size, &rx_buf_pgcnt);
+		rx_buf = ice_get_rx_buf(rx_ring, size, &rx_buf_pgcnt);
 
 		if (!size) {
 			xdp.data = NULL;
@@ -1200,7 +1194,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		cleaned_count++;
 
 		/* skip if it is NOP desc */
-		if (ice_is_non_eop(rx_ring, rx_desc, skb))
+		if (ice_is_non_eop(rx_ring, rx_desc))
 			continue;
 
 		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_RXE_S);
@@ -1230,6 +1224,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 
 		/* send completed skb up the stack */
 		ice_receive_skb(rx_ring, skb, vlan_tag);
+		skb = NULL;
 
 		/* update budget accounting */
 		total_rx_pkts++;
@@ -1240,6 +1235,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 
 	if (xdp_prog)
 		ice_finalize_xdp_rx(rx_ring, xdp_xmit);
+	rx_ring->skb = skb;
 
 	ice_update_rx_ring_stats(rx_ring, total_rx_pkts, total_rx_bytes);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ff1a1cbd078e..c77dbbb760cd 100644
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
@@ -298,6 +297,7 @@ struct ice_ring {
 	struct xsk_buff_pool *xsk_pool;
 	/* CL3 - 3rd cacheline starts here */
 	struct xdp_rxq_info xdp_rxq;
+	struct sk_buff *skb;
 	/* CLX - the below items are only accessed infrequently and should be
 	 * in their own cache line if possible
 	 */
-- 
2.20.1

