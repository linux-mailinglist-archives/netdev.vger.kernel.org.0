Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5088713EE2
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfEEKgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:36:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45851 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726310AbfEEKgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:36:33 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 May 2019 13:36:26 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x45AaQEU029699;
        Sun, 5 May 2019 13:36:26 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH net-next 1/2] net: Take common prefetch code structure into a function
Date:   Sun,  5 May 2019 13:36:06 +0300
Message-Id: <1557052567-31827-2-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557052567-31827-1-git-send-email-tariqt@mellanox.com>
References: <1557052567-31827-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many device drivers use the same prefetch code structure to
deal with small L1 cacheline size.
Take this code into a function and call it from the drivers.

Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c          |  5 +----
 drivers/net/ethernet/hisilicon/hns/hns_enet.c     |  5 +----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c   |  5 +----
 drivers/net/ethernet/intel/fm10k/fm10k_main.c     |  5 +----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c       | 12 ++++--------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c       | 11 +++--------
 drivers/net/ethernet/intel/ice/ice_txrx.c         |  5 +----
 drivers/net/ethernet/intel/igb/igb_main.c         | 10 ++--------
 drivers/net/ethernet/intel/igc/igc_main.c         | 10 ++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 11 +++--------
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 11 +++--------
 include/linux/netdevice.h                         | 16 ++++++++++++++++
 12 files changed, 38 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 89db739b7819..be5cba86d294 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -2372,10 +2372,7 @@ static int process_responses(struct adapter *adap, struct sge_qset *qs,
 			if (fl->use_pages) {
 				void *addr = fl->sdesc[fl->cidx].pg_chunk.va;
 
-				prefetch(addr);
-#if L1_CACHE_BYTES < 128
-				prefetch(addr + L1_CACHE_BYTES);
-#endif
+				net_prefetch(addr);
 				__refill_fl(adap, fl);
 				if (lro > 0) {
 					lro_add_page(adap, qs, fl,
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 65b985acae38..0a05f5279c3a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -561,10 +561,7 @@ static int hns_nic_poll_rx_skb(struct hns_nic_ring_data *ring_data,
 	va = (unsigned char *)desc_cb->buf + desc_cb->page_offset;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(va);
 
 	skb = *out_skb = napi_alloc_skb(&ring_data->napi,
 					HNS_RX_HEAD_SIZE);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 96272e632afc..1bfa9397ce68 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2825,10 +2825,7 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring,
 	 * lines. In such a case, single fetch would suffice to cache in the
 	 * relevant part of the header.
 	 */
-	prefetch(ring->va);
-#if L1_CACHE_BYTES < 128
-	prefetch(ring->va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(ring->va);
 
 	if (!skb) {
 		ret = hns3_alloc_skb(ring, length, ring->va);
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index b4d970e44163..ba8636d720ac 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -313,10 +313,7 @@ static struct sk_buff *fm10k_fetch_rx_buffer(struct fm10k_ring *rx_ring,
 				  rx_buffer->page_offset;
 
 		/* prefetch first cache line of first page */
-		prefetch(page_addr);
-#if L1_CACHE_BYTES < 128
-		prefetch(page_addr + L1_CACHE_BYTES);
-#endif
+		net_prefetch(page_addr);
 
 		/* allocate a skb to store the frags */
 		skb = napi_alloc_skb(&rx_ring->q_vector->napi,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index e1931701cd7e..7fda0d569000 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2005,10 +2005,8 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(xdp->data);
-#if L1_CACHE_BYTES < 128
-	prefetch(xdp->data + L1_CACHE_BYTES);
-#endif
+	net_prefetch(xdp->data);
+
 	/* Note, we get here by enabling legacy-rx via:
 	 *
 	 *    ethtool --set-priv-flags <dev> legacy-rx on
@@ -2091,10 +2089,8 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 	 * likely have a consumer accessing first few bytes of meta
 	 * data, and then actual data.
 	 */
-	prefetch(xdp->data_meta);
-#if L1_CACHE_BYTES < 128
-	prefetch(xdp->data_meta + L1_CACHE_BYTES);
-#endif
+	net_prefetch(xdp->data_meta);
+
 	/* build an skb around the page buffer */
 	skb = build_skb(xdp->data_hard_start, truesize);
 	if (unlikely(!skb))
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index cf8be63a8a4f..f72521aa03cd 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1300,10 +1300,7 @@ static struct sk_buff *iavf_construct_skb(struct iavf_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(va);
 
 	/* allocate a skb to store the frags */
 	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
@@ -1364,10 +1361,8 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(va);
+
 	/* build an skb around the page buffer */
 	skb = build_skb(va - IAVF_SKB_PAD, truesize);
 	if (unlikely(!skb))
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 259f118c7d8b..ff013abad100 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -684,10 +684,7 @@ static bool ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch((u8 *)va + L1_CACHE_BYTES);
-#endif /* L1_CACHE_BYTES */
+	net_prefetch(va);
 
 	/* allocate a skb to store the frags */
 	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, ICE_RX_HDR_SIZE,
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 9b8a4bb25327..fc736547cf08 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8032,10 +8032,7 @@ static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(va);
 
 	/* allocate a skb to store the frags */
 	skb = napi_alloc_skb(&rx_ring->q_vector->napi, IGB_RX_HDR_LEN);
@@ -8089,10 +8086,7 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(va);
 
 	/* build an skb around the page buffer */
 	skb = build_skb(va - IGB_SKB_PAD, truesize);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e58a6e0dc4d9..7497ff24cd58 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1147,10 +1147,7 @@ static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(va);
 
 	/* build an skb around the page buffer */
 	skb = build_skb(va - IGC_SKB_PAD, truesize);
@@ -1186,10 +1183,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(va);
 
 	/* allocate a skb to store the frags */
 	skb = napi_alloc_skb(&rx_ring->q_vector->napi, IGC_RX_HDR_LEN);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7b903206b534..5f37ed33b46c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2094,10 +2094,8 @@ static struct sk_buff *ixgbe_construct_skb(struct ixgbe_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(xdp->data);
-#if L1_CACHE_BYTES < 128
-	prefetch(xdp->data + L1_CACHE_BYTES);
-#endif
+	net_prefetch(xdp->data);
+
 	/* Note, we get here by enabling legacy-rx via:
 	 *
 	 *    ethtool --set-priv-flags <dev> legacy-rx on
@@ -2160,10 +2158,7 @@ static struct sk_buff *ixgbe_build_skb(struct ixgbe_ring *rx_ring,
 	 * likely have a consumer accessing first few bytes of meta
 	 * data, and then actual data.
 	 */
-	prefetch(xdp->data_meta);
-#if L1_CACHE_BYTES < 128
-	prefetch(xdp->data_meta + L1_CACHE_BYTES);
-#endif
+	net_prefetch(xdp->data_meta);
 
 	/* build an skb to around the page buffer */
 	skb = build_skb(xdp->data_hard_start, truesize);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index d189ed247665..23a6cb74da84 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -868,10 +868,8 @@ struct sk_buff *ixgbevf_construct_skb(struct ixgbevf_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(xdp->data);
-#if L1_CACHE_BYTES < 128
-	prefetch(xdp->data + L1_CACHE_BYTES);
-#endif
+	net_prefetch(xdp->data);
+
 	/* Note, we get here by enabling legacy-rx via:
 	 *
 	 *    ethtool --set-priv-flags <dev> legacy-rx on
@@ -949,10 +947,7 @@ static struct sk_buff *ixgbevf_build_skb(struct ixgbevf_ring *rx_ring,
 	 * have a consumer accessing first few bytes of meta data,
 	 * and then actual data.
 	 */
-	prefetch(xdp->data_meta);
-#if L1_CACHE_BYTES < 128
-	prefetch(xdp->data_meta + L1_CACHE_BYTES);
-#endif
+	net_prefetch(xdp->data_meta);
 
 	/* build an skb around the page buffer */
 	skb = build_skb(xdp->data_hard_start, truesize);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 44b47e9df94a..a3269153ac5e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2079,6 +2079,22 @@ int netdev_get_num_tc(struct net_device *dev)
 	return dev->num_tc;
 }
 
+static inline void net_prefetch(void *p)
+{
+	prefetch(p);
+#if L1_CACHE_BYTES < 128
+	prefetch(p + L1_CACHE_BYTES);
+#endif
+}
+
+static inline void net_prefetchw(void *p)
+{
+	prefetchw(p);
+#if L1_CACHE_BYTES < 128
+	prefetchw(p + L1_CACHE_BYTES);
+#endif
+}
+
 void netdev_unbind_sb_channel(struct net_device *dev,
 			      struct net_device *sb_dev);
 int netdev_bind_sb_channel_queue(struct net_device *dev,
-- 
1.8.3.1

