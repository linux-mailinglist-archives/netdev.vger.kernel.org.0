Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D742FA49E
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405728AbhARPZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:25:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:63424 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393475AbhARPZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 10:25:06 -0500
IronPort-SDR: 6ug3QFN8YF+iNqZlLmHMEEYdyfv0WeZssSSnAClGi7PPw49dtIa7fKdF1Y+p9T0y9OvYewjQjh
 VxaI0wLZi+3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="165905546"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="165905546"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 07:23:16 -0800
IronPort-SDR: WpbDM4yLvCumj55b1pe2r5iLRHuqjefTXbefL7emJACY/KTBZclgIz6RnHohNFKqqmhmPXoseD
 SyV1SBcOP1GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="500676397"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2021 07:23:14 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 net-next 10/11] ice: store the result of ice_rx_offset() onto ice_ring
Date:   Mon, 18 Jan 2021 16:13:17 +0100
Message-Id: <20210118151318.12324-11-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
References: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Output of ice_rx_offset() is based on ethtool's priv flag setting, which
when changed, causes PF reset (disables napi, frees irqs, loads
different Rx mem model, etc.). This means that within napi its result is
constant and there is no reason to call it per each processed frame.

Add new 'rx_offset' field to ice_ring that is meant to hold the
ice_rx_offset() result and use it within ice_clean_rx_irq().
Furthermore, use it within ice_alloc_mapped_page().

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 43 ++++++++++++-----------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  1 +
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 50fbb77bab70..fdd0d8b326ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -443,6 +443,22 @@ void ice_free_rx_ring(struct ice_ring *rx_ring)
 	}
 }
 
+/**
+ * ice_rx_offset - Return expected offset into page to access data
+ * @rx_ring: Ring we are requesting offset of
+ *
+ * Returns the offset value for ring into the data buffer.
+ */
+static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
+{
+	if (ice_ring_uses_build_skb(rx_ring))
+		return ICE_SKB_PAD;
+	else if (ice_is_xdp_ena_vsi(rx_ring->vsi))
+		return XDP_PACKET_HEADROOM;
+
+	return 0;
+}
+
 /**
  * ice_setup_rx_ring - Allocate the Rx descriptors
  * @rx_ring: the Rx ring to set up
@@ -477,6 +493,7 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring)
 
 	rx_ring->next_to_use = 0;
 	rx_ring->next_to_clean = 0;
+	rx_ring->rx_offset = ice_rx_offset(rx_ring);
 
 	if (ice_is_xdp_ena_vsi(rx_ring->vsi))
 		WRITE_ONCE(rx_ring->xdp_prog, rx_ring->vsi->xdp_prog);
@@ -494,22 +511,6 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring)
 	return -ENOMEM;
 }
 
-/**
- * ice_rx_offset - Return expected offset into page to access data
- * @rx_ring: Ring we are requesting offset of
- *
- * Returns the offset value for ring into the data buffer.
- */
-static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
-{
-	if (ice_ring_uses_build_skb(rx_ring))
-		return ICE_SKB_PAD;
-	else if (ice_is_xdp_ena_vsi(rx_ring->vsi))
-		return XDP_PACKET_HEADROOM;
-
-	return 0;
-}
-
 static unsigned int
 ice_rx_frame_truesize(struct ice_ring *rx_ring, unsigned int __maybe_unused size)
 {
@@ -518,8 +519,8 @@ ice_rx_frame_truesize(struct ice_ring *rx_ring, unsigned int __maybe_unused size
 #if (PAGE_SIZE < 8192)
 	truesize = ice_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
 #else
-	truesize = ice_rx_offset(rx_ring) ?
-		SKB_DATA_ALIGN(ice_rx_offset(rx_ring) + size) +
+	truesize = rx_ring->rx_offset ?
+		SKB_DATA_ALIGN(rx_ring->rx_offset + size) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
 		SKB_DATA_ALIGN(size);
 #endif
@@ -652,7 +653,7 @@ ice_alloc_mapped_page(struct ice_ring *rx_ring, struct ice_rx_buf *bi)
 
 	bi->dma = dma;
 	bi->page = page;
-	bi->page_offset = ice_rx_offset(rx_ring);
+	bi->page_offset = rx_ring->rx_offset;
 	page_ref_add(page, USHRT_MAX - 1);
 	bi->pagecnt_bias = USHRT_MAX;
 
@@ -814,7 +815,7 @@ ice_add_rx_frag(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		struct sk_buff *skb, unsigned int size)
 {
 #if (PAGE_SIZE >= 8192)
-	unsigned int truesize = SKB_DATA_ALIGN(size + ice_rx_offset(rx_ring));
+	unsigned int truesize = SKB_DATA_ALIGN(size + rx_ring->rx_offset);
 #else
 	unsigned int truesize = ice_rx_pg_size(rx_ring) / 2;
 #endif
@@ -1080,6 +1081,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0, frame_sz = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
+	unsigned int offset = rx_ring->rx_offset;
 	unsigned int xdp_res, xdp_xmit = 0;
 	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
@@ -1094,7 +1096,6 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
-		unsigned int offset = ice_rx_offset(rx_ring);
 		union ice_32b_rx_flex_desc *rx_desc;
 		struct ice_rx_buf *rx_buf;
 		unsigned char *hard_start;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index c77dbbb760cd..d5f609056ab9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -295,6 +295,7 @@ struct ice_ring {
 	struct rcu_head rcu;		/* to avoid race on free */
 	struct bpf_prog *xdp_prog;
 	struct xsk_buff_pool *xsk_pool;
+	u16 rx_offset;
 	/* CL3 - 3rd cacheline starts here */
 	struct xdp_rxq_info xdp_rxq;
 	struct sk_buff *skb;
-- 
2.20.1

