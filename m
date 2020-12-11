Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355EB2D7BDC
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403941AbgLKRB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:01:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:8172 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732975AbgLKRA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 12:00:26 -0500
IronPort-SDR: 5/WSnh25rc00/kzAzQrsthskJNQ3bUzVog99+oH5cmtTbJcME0FRKNjB/TAxa4bi2dCiCJoUnF
 RjnU+p4PbYzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9832"; a="236055093"
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="236055093"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2020 08:59:35 -0800
IronPort-SDR: YZHVSbIFfYDD+xuKkUirJSX0ubHZzMln5JySkvnbAaap4agzsBCZLmJ0OJTfQ6kQN9Q5GNl/wM
 jWS8HgWDfzUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,411,1599548400"; 
   d="scan'208";a="365497537"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 11 Dec 2020 08:59:33 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH net-next 5/8] ice: move skb pointer from rx_buf to rx_ring
Date:   Fri, 11 Dec 2020 17:49:53 +0100
Message-Id: <20201211164956.59628-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
References: <20201211164956.59628-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar thing had been done in i40e, as there is no real need for having
the sk_buff pointer in each rx_buf. Non-eop frames can be simply handled
on that pointer moved upwards to rx_ring.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 28 ++++++++++-------------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  2 +-
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 8b5d23436904..bbe483c56861 100644
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
 
@@ -864,14 +865,12 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
  * for use by the CPU.
  */
 static struct ice_rx_buf *
-ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
-	       const unsigned int size)
+ice_get_rx_buf(struct ice_ring *rx_ring, const unsigned int size)
 {
 	struct ice_rx_buf *rx_buf;
 
 	rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
 	prefetchw(rx_buf->page);
-	*skb = rx_buf->skb;
 
 	if (!size)
 		return rx_buf;
@@ -1030,29 +1029,24 @@ static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 
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
@@ -1075,6 +1069,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
 	unsigned int xdp_res, xdp_xmit = 0;
+	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
 	struct xdp_buff xdp;
 	bool failure;
@@ -1089,7 +1084,6 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
 		struct ice_rx_buf *rx_buf;
-		struct sk_buff *skb;
 		unsigned int size;
 		u16 stat_err_bits;
 		u16 vlan_tag = 0;
@@ -1123,7 +1117,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
 		/* retrieve a buffer from the ring */
-		rx_buf = ice_get_rx_buf(rx_ring, &skb, size);
+		rx_buf = ice_get_rx_buf(rx_ring, size);
 
 		if (!size) {
 			xdp.data = NULL;
@@ -1186,7 +1180,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		cleaned_count++;
 
 		/* skip if it is NOP desc */
-		if (ice_is_non_eop(rx_ring, rx_desc, skb))
+		if (ice_is_non_eop(rx_ring, rx_desc))
 			continue;
 
 		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_RXE_S);
@@ -1216,6 +1210,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 
 		/* send completed skb up the stack */
 		ice_receive_skb(rx_ring, skb, vlan_tag);
+		skb = NULL;
 
 		/* update budget accounting */
 		total_rx_pkts++;
@@ -1226,6 +1221,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 
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

