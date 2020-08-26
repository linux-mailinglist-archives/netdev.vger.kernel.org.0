Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED934252F09
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 14:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgHZMyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 08:54:39 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44438 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729998AbgHZMyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 08:54:31 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with SMTP; 26 Aug 2020 15:54:21 +0300
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07QCsLG3003731;
        Wed, 26 Aug 2020 15:54:21 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 1/3] net: Take common prefetch code structure into a function
Date:   Wed, 26 Aug 2020 15:54:16 +0300
Message-Id: <20200826125418.11379-2-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200826125418.11379-1-tariqt@mellanox.com>
References: <20200826125418.11379-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
---
 drivers/net/ethernet/chelsio/cxgb3/sge.c         |  5 +----
 drivers/net/ethernet/hisilicon/hns/hns_enet.c    |  5 +----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c  |  5 +----
 drivers/net/ethernet/intel/fm10k/fm10k_main.c    |  5 +----
 drivers/net/ethernet/intel/i40e/i40e_txrx.c      | 12 ++++--------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c      | 11 +++--------
 drivers/net/ethernet/intel/ice/ice_txrx.c        | 10 ++--------
 drivers/net/ethernet/intel/igb/igb_main.c        | 10 ++--------
 drivers/net/ethernet/intel/igc/igc_main.c        | 10 ++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    | 11 +++--------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c    | 11 +++--------
 include/linux/netdevice.h                        | 16 ++++++++++++++++
 12 files changed, 39 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 6dabbf1502c7..ee6188dea705 100644
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
index 23f278e46975..3af33ade7b60 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -557,10 +557,7 @@ static int hns_nic_poll_rx_skb(struct hns_nic_ring_data *ring_data,
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
index 87776ce3539b..1a1ba6a41bfe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3091,10 +3091,7 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring)
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
index d88dd41a9442..99b8252eb969 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -310,10 +310,7 @@ static struct sk_buff *fm10k_fetch_rx_buffer(struct fm10k_ring *rx_ring,
 				  rx_buffer->page_offset;
 
 		/* prefetch first cache line of first page */
-		prefetch(page_addr);
-#if L1_CACHE_BYTES < 128
-		prefetch((void *)((u8 *)page_addr + L1_CACHE_BYTES));
-#endif
+		net_prefetch(page_addr);
 
 		/* allocate a skb to store the frags */
 		skb = napi_alloc_skb(&rx_ring->q_vector->napi,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3e5c566ceb01..432a984ac335 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1992,10 +1992,8 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
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
@@ -2078,10 +2076,8 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
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
index ca041b39ffda..256fa07d54d5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1309,10 +1309,7 @@ static struct sk_buff *iavf_construct_skb(struct iavf_ring *rx_ring,
 		return NULL;
 	/* prefetch first cache line of first page */
 	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(va);
 
 	/* allocate a skb to store the frags */
 	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
@@ -1376,10 +1373,8 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 		return NULL;
 	/* prefetch first cache line of first page */
 	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
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
index 9d0d6b0025cf..d2fca4a52f51 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -919,10 +919,7 @@ ice_build_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	 * likely have a consumer accessing first few bytes of meta
 	 * data, and then actual data.
 	 */
-	prefetch(xdp->data_meta);
-#if L1_CACHE_BYTES < 128
-	prefetch((void *)(xdp->data + L1_CACHE_BYTES));
-#endif
+	net_prefetch(xdp->data_meta);
 	/* build an skb around the page buffer */
 	skb = build_skb(xdp->data_hard_start, truesize);
 	if (unlikely(!skb))
@@ -964,10 +961,7 @@ ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(xdp->data);
-#if L1_CACHE_BYTES < 128
-	prefetch((void *)(xdp->data + L1_CACHE_BYTES));
-#endif /* L1_CACHE_BYTES */
+	net_prefetch(xdp->data);
 
 	/* allocate a skb to store the frags */
 	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, ICE_RX_HDR_SIZE,
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 4f05f6efe6af..698bb6a4b088 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8047,10 +8047,7 @@ static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(va);
 
 	/* allocate a skb to store the frags */
 	skb = napi_alloc_skb(&rx_ring->q_vector->napi, IGB_RX_HDR_LEN);
@@ -8104,10 +8101,7 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
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
index 9593aa4eea36..c6968fdb6caa 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1550,10 +1550,7 @@ static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
-#if L1_CACHE_BYTES < 128
-	prefetch(va + L1_CACHE_BYTES);
-#endif
+	net_prefetch(va);
 
 	/* build an skb around the page buffer */
 	skb = build_skb(va - IGC_SKB_PAD, truesize);
@@ -1589,10 +1586,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
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
index 2f8a4cfc5fa1..f4f2198f388b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2095,10 +2095,8 @@ static struct sk_buff *ixgbe_construct_skb(struct ixgbe_ring *rx_ring,
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
@@ -2161,10 +2159,7 @@ static struct sk_buff *ixgbe_build_skb(struct ixgbe_ring *rx_ring,
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
index a428113e6d54..50afec43e001 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -866,10 +866,8 @@ struct sk_buff *ixgbevf_construct_skb(struct ixgbevf_ring *rx_ring,
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
@@ -947,10 +945,7 @@ static struct sk_buff *ixgbevf_build_skb(struct ixgbevf_ring *rx_ring,
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
index b0e303f6603f..b8abe1d7aa0b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2193,6 +2193,22 @@ int netdev_get_num_tc(struct net_device *dev)
 	return dev->num_tc;
 }
 
+static inline void net_prefetch(void *p)
+{
+	prefetch(p);
+#if L1_CACHE_BYTES < 128
+	prefetch((u8 *)p + L1_CACHE_BYTES);
+#endif
+}
+
+static inline void net_prefetchw(void *p)
+{
+	prefetchw(p);
+#if L1_CACHE_BYTES < 128
+	prefetchw((u8 *)p + L1_CACHE_BYTES);
+#endif
+}
+
 void netdev_unbind_sb_channel(struct net_device *dev,
 			      struct net_device *sb_dev);
 int netdev_bind_sb_channel_queue(struct net_device *dev,
-- 
2.21.0

