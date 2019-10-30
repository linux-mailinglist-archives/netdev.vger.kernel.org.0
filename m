Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50DF0E954B
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfJ3D3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:29:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:43132 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbfJ3D3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 23:29:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 20:29:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,245,1569308400"; 
   d="scan'208";a="205673656"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2019 20:29:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 7/9] ice: introduce frame padding computation logic
Date:   Tue, 29 Oct 2019 20:29:08 -0700
Message-Id: <20191030032910.24261-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
References: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Take into account the underlying architecture specific settings and
based on that calculate the possible padding that can be supplied.
Typically, for x86 and standard MTU size we will end up with 192 bytes
of headroom. This is the same behavior as our other drivers have and we
can dedicate it for XDP purposes.

Furthermore, introduce the Rx ring flag for indicating whether build_skb
is used on particular. Based on that invoke the routines for padding
calculation.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c    |  6 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c     |  3 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c    | 42 +++++-----
 drivers/net/ethernet/intel/ice/ice_txrx.h    | 81 ++++++++++++++++++++
 5 files changed, 114 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 2904de054c10..69d2da14fe5c 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -406,6 +406,12 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	if (vsi->type == ICE_VSI_VF)
 		return 0;
 
+	/* configure Rx buffer alignment */
+	if (!vsi->netdev || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
+		ice_clear_ring_build_skb_ena(ring);
+	else
+		ice_set_ring_build_skb_ena(ring);
+
 	/* init queue specific tail register */
 	ring->tail = hw->hw_addr + QRX_TAIL(pf_q);
 	writel(0, ring->tail);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index c1737625bbc2..7e779060069c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -624,7 +624,7 @@ static int ice_lbtest_receive_frames(struct ice_ring *rx_ring)
 			continue;
 
 		rx_buf = &rx_ring->rx_buf[i];
-		received_buf = page_address(rx_buf->page);
+		received_buf = page_address(rx_buf->page) + rx_buf->page_offset;
 
 		if (ice_lbtest_check_frame(received_buf))
 			valid_frames++;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 21c6198fca54..50eb723502d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1194,7 +1194,8 @@ void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
 		vsi->max_frame = ICE_AQ_SET_MAC_FRAME_SIZE_MAX;
 		vsi->rx_buf_len = ICE_RXBUF_2048;
 #if (PAGE_SIZE < 8192)
-	} else if (vsi->netdev->mtu <= ETH_DATA_LEN) {
+	} else if (!ICE_2K_TOO_SMALL_WITH_PADDING &&
+		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
 		vsi->max_frame = ICE_RXBUF_1536 - NET_IP_ALIGN;
 		vsi->rx_buf_len = ICE_RXBUF_1536 - NET_IP_ALIGN;
 #endif
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 63fe73c5097c..71c4464934af 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -415,7 +415,12 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring)
  */
 static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
 {
-	return ice_is_xdp_ena_vsi(rx_ring->vsi) ? XDP_PACKET_HEADROOM : 0;
+	if (ice_ring_uses_build_skb(rx_ring))
+		return ICE_SKB_PAD;
+	else if (ice_is_xdp_ena_vsi(rx_ring->vsi))
+		return XDP_PACKET_HEADROOM;
+
+	return 0;
 }
 
 /**
@@ -710,7 +715,7 @@ ice_add_rx_frag(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		struct sk_buff *skb, unsigned int size)
 {
 #if (PAGE_SIZE >= 8192)
-	unsigned int truesize = SKB_DATA_ALIGN(size);
+	unsigned int truesize = SKB_DATA_ALIGN(size + ice_rx_offset(rx_ring));
 #else
 	unsigned int truesize = ice_rx_pg_size(rx_ring) / 2;
 #endif
@@ -1008,27 +1013,28 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 
 		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_prog);
 		rcu_read_unlock();
-		if (xdp_res) {
-			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
-				unsigned int truesize;
+		if (!xdp_res)
+			goto construct_skb;
+		if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
+			unsigned int truesize;
 
 #if (PAGE_SIZE < 8192)
-				truesize = ice_rx_pg_size(rx_ring) / 2;
+			truesize = ice_rx_pg_size(rx_ring) / 2;
 #else
-				truesize = SKB_DATA_ALIGN(size);
+			truesize = SKB_DATA_ALIGN(ice_rx_offset(rx_ring) +
+						  size);
 #endif
-				xdp_xmit |= xdp_res;
-				ice_rx_buf_adjust_pg_offset(rx_buf, truesize);
-			} else {
-				rx_buf->pagecnt_bias++;
-			}
-			total_rx_bytes += size;
-			total_rx_pkts++;
-
-			cleaned_count++;
-			ice_put_rx_buf(rx_ring, rx_buf);
-			continue;
+			xdp_xmit |= xdp_res;
+			ice_rx_buf_adjust_pg_offset(rx_buf, truesize);
+		} else {
+			rx_buf->pagecnt_bias++;
 		}
+		total_rx_bytes += size;
+		total_rx_pkts++;
+
+		cleaned_count++;
+		ice_put_rx_buf(rx_ring, rx_buf);
+		continue;
 construct_skb:
 		if (skb)
 			ice_add_rx_frag(rx_ring, rx_buf, skb, size);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 6a6e3d2339ba..a84cc0e6dd27 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -26,6 +26,71 @@
 #define ICE_RX_BUF_WRITE	16	/* Must be power of 2 */
 #define ICE_MAX_TXQ_PER_TXQG	128
 
+/* Attempt to maximize the headroom available for incoming frames. We use a 2K
+ * buffer for MTUs <= 1500 and need 1536/1534 to store the data for the frame.
+ * This leaves us with 512 bytes of room.  From that we need to deduct the
+ * space needed for the shared info and the padding needed to IP align the
+ * frame.
+ *
+ * Note: For cache line sizes 256 or larger this value is going to end
+ *       up negative.  In these cases we should fall back to the legacy
+ *       receive path.
+ */
+#if (PAGE_SIZE < 8192)
+#define ICE_2K_TOO_SMALL_WITH_PADDING \
+((NET_SKB_PAD + ICE_RXBUF_1536) > SKB_WITH_OVERHEAD(ICE_RXBUF_2048))
+
+/**
+ * ice_compute_pad - compute the padding
+ * rx_buf_len: buffer length
+ *
+ * Figure out the size of half page based on given buffer length and
+ * then subtract the skb_shared_info followed by subtraction of the
+ * actual buffer length; this in turn results in the actual space that
+ * is left for padding usage
+ */
+static inline int ice_compute_pad(int rx_buf_len)
+{
+	int half_page_size;
+
+	half_page_size = ALIGN(rx_buf_len, PAGE_SIZE / 2);
+	return SKB_WITH_OVERHEAD(half_page_size) - rx_buf_len;
+}
+
+/**
+ * ice_skb_pad - determine the padding that we can supply
+ *
+ * Figure out the right Rx buffer size and based on that calculate the
+ * padding
+ */
+static inline int ice_skb_pad(void)
+{
+	int rx_buf_len;
+
+	/* If a 2K buffer cannot handle a standard Ethernet frame then
+	 * optimize padding for a 3K buffer instead of a 1.5K buffer.
+	 *
+	 * For a 3K buffer we need to add enough padding to allow for
+	 * tailroom due to NET_IP_ALIGN possibly shifting us out of
+	 * cache-line alignment.
+	 */
+	if (ICE_2K_TOO_SMALL_WITH_PADDING)
+		rx_buf_len = ICE_RXBUF_3072 + SKB_DATA_ALIGN(NET_IP_ALIGN);
+	else
+		rx_buf_len = ICE_RXBUF_1536;
+
+	/* if needed make room for NET_IP_ALIGN */
+	rx_buf_len -= NET_IP_ALIGN;
+
+	return ice_compute_pad(rx_buf_len);
+}
+
+#define ICE_SKB_PAD ice_skb_pad()
+#else
+#define ICE_2K_TOO_SMALL_WITH_PADDING false
+#define ICE_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
+#endif
+
 /* We are assuming that the cache line is always 64 Bytes here for ice.
  * In order to make sure that is a correct assumption there is a check in probe
  * to print a warning if the read from GLPCI_CNF2 tells us that the cache line
@@ -231,6 +296,7 @@ struct ice_ring {
 	 * in their own cache line if possible
 	 */
 #define ICE_TX_FLAGS_RING_XDP		BIT(0)
+#define ICE_RX_FLAGS_RING_BUILD_SKB	BIT(1)
 	u8 flags;
 	dma_addr_t dma;			/* physical address of ring */
 	unsigned int size;		/* length of descriptor ring in bytes */
@@ -239,6 +305,21 @@ struct ice_ring {
 	u8 dcb_tc;			/* Traffic class of ring */
 } ____cacheline_internodealigned_in_smp;
 
+static inline bool ice_ring_uses_build_skb(struct ice_ring *ring)
+{
+	return !!(ring->flags & ICE_RX_FLAGS_RING_BUILD_SKB);
+}
+
+static inline void ice_set_ring_build_skb_ena(struct ice_ring *ring)
+{
+	ring->flags |= ICE_RX_FLAGS_RING_BUILD_SKB;
+}
+
+static inline void ice_clear_ring_build_skb_ena(struct ice_ring *ring)
+{
+	ring->flags &= ~ICE_RX_FLAGS_RING_BUILD_SKB;
+}
+
 static inline bool ice_ring_is_xdp(struct ice_ring *ring)
 {
 	return !!(ring->flags & ICE_TX_FLAGS_RING_XDP);
-- 
2.21.0

