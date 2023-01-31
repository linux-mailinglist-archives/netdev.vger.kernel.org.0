Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E306837AE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjAaUpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjAaUpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:45:15 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE04B34C2E;
        Tue, 31 Jan 2023 12:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675197914; x=1706733914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uKF05JlRsuC1cLi3twPxky7tQz/KMSJRxWxjpos2CTM=;
  b=aUJnIJRb8LQ81K+XKtxJQiIZrTRSz6KjPbIxqcb545wK1hCtZLAnzrdv
   Z+Xota9UuAHXfBk6IpMDOP/5ZVr+2KWPkEXIo68OjVqRpzgXCKOh+zCh8
   6PAvc3fMEXN20RU8YlVWL8Cqsknk7nRBgAKx6ybrGyrljnZ+EcFaxEVJf
   dWa6K4t1fTSm09JxHeDVITb7x8PkwAnkOVVCzjTOaeYwMi9FTM2/qcgEd
   S33JyDi533j0R3jwe3f1v/q4S33ZCeWlVfOywKf3MG6neeYefNPP9g4lA
   0aW4NJEffjjUG9qEgmslQuehTE0OWzdjk0tbL3vObc6lmUsXQSFIIzPYN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167074"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167074"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:45:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595222"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595222"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:12 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 01/13] ice: prepare legacy-rx for upcoming XDP multi-buffer support
Date:   Tue, 31 Jan 2023 21:44:54 +0100
Message-Id: <20230131204506.219292-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
References: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rx path is going to be modified in a way that fragmented frame will be
gathered within xdp_buff in the first place. This approach implies that
underlying buffer has to provide tailroom for skb_shared_info. This is
currently the case when ring uses build_skb but not when legacy-rx knob
is turned on. This case configures 2k Rx buffers and has no way to
provide either headroom or tailroom - FWIW it currently has
XDP_PACKET_HEADROOM which is broken and in here it is removed. 2k Rx
buffers were used so driver in this setting was able to support 9k MTU
as it can chain up to 5 Rx buffers. With offset configuring HW writing
2k of a data was passing the half of the page which broke the assumption
of our internal page recycling tricks.

Now if above got fixed and legacy-rx path would be left as is, when
referring to skb_shared_info via xdp_get_shared_info_from_buff(),
packet's content would be corrupted again. Hence size of Rx buffer needs
to be lowered and therefore supported MTU. This operation will allow us
to keep the unified data path and with 8k MTU users (if any of
legacy-rx) would still be good to go. However, tendency is to drop the
support for this code path at some point.

Add ICE_RXBUF_1664 as vsi::rx_buf_len and ICE_MAX_FRAME_LEGACY_RX (8320)
as vsi::max_frame for legacy-rx. For bigger page sizes configure 3k Rx
buffers, not 2k.

Since headroom support is removed, disable data_meta support on legacy-rx.
When preparing XDP buff, rely on ice_rx_ring::rx_offset setting when
deciding whether to support data_meta or not.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c |  3 ---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  8 ++------
 drivers/net/ethernet/intel/ice/ice_main.c | 10 ++++++++--
 drivers/net/ethernet/intel/ice/ice_txrx.c | 17 +++++------------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  2 ++
 5 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 554095b25f44..e36abcfeb958 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -355,9 +355,6 @@ static unsigned int ice_rx_offset(struct ice_rx_ring *rx_ring)
 {
 	if (ice_ring_uses_build_skb(rx_ring))
 		return ICE_SKB_PAD;
-	else if (ice_is_xdp_ena_vsi(rx_ring->vsi))
-		return XDP_PACKET_HEADROOM;
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 94aa834cd9a6..c9ec219d40a6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1992,8 +1992,8 @@ void ice_update_eth_stats(struct ice_vsi *vsi)
 void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
 {
 	if (!vsi->netdev || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags)) {
-		vsi->max_frame = ICE_AQ_SET_MAC_FRAME_SIZE_MAX;
-		vsi->rx_buf_len = ICE_RXBUF_2048;
+		vsi->max_frame = ICE_MAX_FRAME_LEGACY_RX;
+		vsi->rx_buf_len = ICE_RXBUF_1664;
 #if (PAGE_SIZE < 8192)
 	} else if (!ICE_2K_TOO_SMALL_WITH_PADDING &&
 		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
@@ -2002,11 +2002,7 @@ void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
 #endif
 	} else {
 		vsi->max_frame = ICE_AQ_SET_MAC_FRAME_SIZE_MAX;
-#if (PAGE_SIZE < 8192)
 		vsi->rx_buf_len = ICE_RXBUF_3072;
-#else
-		vsi->rx_buf_len = ICE_RXBUF_2048;
-#endif
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a9a7f8b52140..88b4a017990d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -7327,8 +7327,8 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
  */
 static int ice_max_xdp_frame_size(struct ice_vsi *vsi)
 {
-	if (PAGE_SIZE >= 8192 || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
-		return ICE_RXBUF_2048 - XDP_PACKET_HEADROOM;
+	if (test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
+		return ICE_RXBUF_1664;
 	else
 		return ICE_RXBUF_3072;
 }
@@ -7361,6 +7361,12 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 				   frame_size - ICE_ETH_PKT_HDR_PAD);
 			return -EINVAL;
 		}
+	} else if (test_bit(ICE_FLAG_LEGACY_RX, pf->flags)) {
+		if (new_mtu + ICE_ETH_PKT_HDR_PAD > ICE_MAX_FRAME_LEGACY_RX) {
+			netdev_err(netdev, "Too big MTU for legacy-rx; Max is %d\n",
+				   ICE_MAX_FRAME_LEGACY_RX - ICE_ETH_PKT_HDR_PAD);
+			return -EINVAL;
+		}
 	}
 
 	/* if a reset is in progress, wait for some time for it to complete */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 086f0b3ab68d..d0a6534122e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -984,17 +984,15 @@ static struct sk_buff *
 ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		  struct xdp_buff *xdp)
 {
-	unsigned int metasize = xdp->data - xdp->data_meta;
 	unsigned int size = xdp->data_end - xdp->data;
 	unsigned int headlen;
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	net_prefetch(xdp->data_meta);
+	net_prefetch(xdp->data);
 
 	/* allocate a skb to store the frags */
-	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
-			       ICE_RX_HDR_SIZE + metasize,
+	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, ICE_RX_HDR_SIZE,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
@@ -1006,13 +1004,8 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		headlen = eth_get_headlen(skb->dev, xdp->data, ICE_RX_HDR_SIZE);
 
 	/* align pull length to size of long to optimize memcpy performance */
-	memcpy(__skb_put(skb, headlen + metasize), xdp->data_meta,
-	       ALIGN(headlen + metasize, sizeof(long)));
-
-	if (metasize) {
-		skb_metadata_set(skb, metasize);
-		__skb_pull(skb, metasize);
-	}
+	memcpy(__skb_put(skb, headlen), xdp->data, ALIGN(headlen,
+							 sizeof(long)));
 
 	/* if we exhaust the linear part then add what is left as a frag */
 	size -= headlen;
@@ -1187,7 +1180,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 
 		hard_start = page_address(rx_buf->page) + rx_buf->page_offset -
 			     offset;
-		xdp_prepare_buff(&xdp, hard_start, offset, size, true);
+		xdp_prepare_buff(&xdp, hard_start, offset, size, !!offset);
 #if (PAGE_SIZE > 4096)
 		/* At larger PAGE_SIZE, frame_sz depend on len size */
 		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 4fd0e5d0a313..166713f8abbd 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -9,10 +9,12 @@
 #define ICE_DFLT_IRQ_WORK	256
 #define ICE_RXBUF_3072		3072
 #define ICE_RXBUF_2048		2048
+#define ICE_RXBUF_1664		1664
 #define ICE_RXBUF_1536		1536
 #define ICE_MAX_CHAINED_RX_BUFS	5
 #define ICE_MAX_BUF_TXD		8
 #define ICE_MIN_TX_LEN		17
+#define ICE_MAX_FRAME_LEGACY_RX 8320
 
 /* The size limit for a transmit buffer in a descriptor is (16K - 1).
  * In order to align with the read requests we will align the value to
-- 
2.34.1

