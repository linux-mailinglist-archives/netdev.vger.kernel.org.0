Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F8A31A80B
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhBLWt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:49:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:44414 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232501AbhBLWqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:46:51 -0500
IronPort-SDR: 8mOP+Ujf+kqpY1p/OsjNniSwhWf1zQCfKdQM0WQMXu1Yqm8A+Dh6BTQBi7AllQq0SVCqfr64yo
 PqYNZ1zoJzpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="169617168"
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="169617168"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 14:39:01 -0800
IronPort-SDR: P1Z5+8P3IPVkzoJA/jgCHEK98AlhyDvKCwM0p/+TCvbOGA+qKqpDkbZsb0Z392E4vJRwBAs2kQ
 T2HfIKuTWoDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="381885384"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 12 Feb 2021 14:39:01 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 09/11] i40e: store the result of i40e_rx_offset() onto i40e_ring
Date:   Fri, 12 Feb 2021 14:39:50 -0800
Message-Id: <20210212223952.1172568-10-anthony.l.nguyen@intel.com>
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

Output of i40e_rx_offset() is based on ethtool's priv flag setting,
which when changed, causes PF reset (disables napi, frees irqs, loads
different Rx mem model, etc.). This means that within napi its result is
constant and there is no reason to call it per each processed frame.

Add new 'rx_offset' field to i40e_ring that is meant to hold the
i40e_rx_offset() result and use it within i40e_clean_rx_irq().
Furthermore, use it within i40e_alloc_mapped_page().

Last but not least, un-inline the function of interest so that compiler
makes the decision about inlining as it lives in .c file.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 35 +++++++++++----------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  1 +
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 79ca608ee152..f6f1af94cca0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1569,6 +1569,17 @@ void i40e_free_rx_resources(struct i40e_ring *rx_ring)
 	}
 }
 
+/**
+ * i40e_rx_offset - Return expected offset into page to access data
+ * @rx_ring: Ring we are requesting offset of
+ *
+ * Returns the offset value for ring into the data buffer.
+ */
+static unsigned int i40e_rx_offset(struct i40e_ring *rx_ring)
+{
+	return ring_uses_build_skb(rx_ring) ? I40E_SKB_PAD : 0;
+}
+
 /**
  * i40e_setup_rx_descriptors - Allocate Rx descriptors
  * @rx_ring: Rx descriptor ring (for a specific queue) to setup
@@ -1597,6 +1608,7 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 	rx_ring->next_to_alloc = 0;
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
+	rx_ring->rx_offset = i40e_rx_offset(rx_ring);
 
 	/* XDP RX-queue info only needed for RX rings exposed to XDP */
 	if (rx_ring->vsi->type == I40E_VSI_MAIN) {
@@ -1632,17 +1644,6 @@ void i40e_release_rx_desc(struct i40e_ring *rx_ring, u32 val)
 	writel(val, rx_ring->tail);
 }
 
-/**
- * i40e_rx_offset - Return expected offset into page to access data
- * @rx_ring: Ring we are requesting offset of
- *
- * Returns the offset value for ring into the data buffer.
- */
-static inline unsigned int i40e_rx_offset(struct i40e_ring *rx_ring)
-{
-	return ring_uses_build_skb(rx_ring) ? I40E_SKB_PAD : 0;
-}
-
 static unsigned int i40e_rx_frame_truesize(struct i40e_ring *rx_ring,
 					   unsigned int size)
 {
@@ -1651,8 +1652,8 @@ static unsigned int i40e_rx_frame_truesize(struct i40e_ring *rx_ring,
 #if (PAGE_SIZE < 8192)
 	truesize = i40e_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
 #else
-	truesize = i40e_rx_offset(rx_ring) ?
-		SKB_DATA_ALIGN(size + i40e_rx_offset(rx_ring)) +
+	truesize = rx_ring->rx_offset ?
+		SKB_DATA_ALIGN(size + rx_ring->rx_offset) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
 		SKB_DATA_ALIGN(size);
 #endif
@@ -1703,7 +1704,7 @@ static bool i40e_alloc_mapped_page(struct i40e_ring *rx_ring,
 
 	bi->dma = dma;
 	bi->page = page;
-	bi->page_offset = i40e_rx_offset(rx_ring);
+	bi->page_offset = rx_ring->rx_offset;
 	page_ref_add(page, USHRT_MAX - 1);
 	bi->pagecnt_bias = USHRT_MAX;
 
@@ -2057,7 +2058,7 @@ static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = i40e_rx_pg_size(rx_ring) / 2;
 #else
-	unsigned int truesize = SKB_DATA_ALIGN(size + i40e_rx_offset(rx_ring));
+	unsigned int truesize = SKB_DATA_ALIGN(size + rx_ring->rx_offset);
 #endif
 
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
@@ -2453,8 +2454,9 @@ static void i40e_inc_ntc(struct i40e_ring *rx_ring)
 static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0, frame_sz = 0;
-	struct sk_buff *skb = rx_ring->skb;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
+	unsigned int offset = rx_ring->rx_offset;
+	struct sk_buff *skb = rx_ring->skb;
 	unsigned int xdp_xmit = 0;
 	bool failure = false;
 	struct xdp_buff xdp;
@@ -2514,7 +2516,6 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
-			unsigned int offset = i40e_rx_offset(rx_ring);
 			unsigned char *hard_start;
 
 			hard_start = page_address(rx_buffer->page) +
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 5f531b195959..86fed05b4f19 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -387,6 +387,7 @@ struct i40e_ring {
 					 */
 
 	struct i40e_channel *ch;
+	u16 rx_offset;
 	struct xdp_rxq_info xdp_rxq;
 	struct xsk_buff_pool *xsk_pool;
 	struct xdp_desc *xsk_descs;      /* For storing descriptors in the AF_XDP ZC path */
-- 
2.26.2

