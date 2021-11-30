Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFCE463D91
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245407AbhK3SVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:21:02 -0500
Received: from mga17.intel.com ([192.55.52.151]:22722 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245432AbhK3SVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 13:21:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="216976661"
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="216976661"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 10:00:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,276,1631602800"; 
   d="scan'208";a="654258459"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 30 Nov 2021 10:00:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        andrii@kernel.org, kpsingh@kernel.org, kafai@fb.com, yhs@fb.com,
        songliubraving@fb.com,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH net-next 2/2] igc: enable XDP metadata in driver
Date:   Tue, 30 Nov 2021 09:59:18 -0800
Message-Id: <20211130175918.3705966-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211130175918.3705966-1-anthony.l.nguyen@intel.com>
References: <20211130175918.3705966-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

Enabling the XDP bpf_prog access to data_meta area is a very small
change. Hint passing 'true' to xdp_prepare_buff().

The SKB layers can also access data_meta area, which required more
driver changes to support. Reviewers, notice the igc driver have two
different functions that can create SKBs, depending on driver config.

Hint for testers, ethtool priv-flags legacy-rx enables
the function igc_construct_skb()

 ethtool --set-priv-flags DEV legacy-rx on

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 33 +++++++++++++++--------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 76b0a7311369..142c57b7a451 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1718,24 +1718,26 @@ static void igc_add_rx_frag(struct igc_ring *rx_ring,
 
 static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
 				     struct igc_rx_buffer *rx_buffer,
-				     union igc_adv_rx_desc *rx_desc,
-				     unsigned int size)
+				     struct xdp_buff *xdp)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
+	unsigned int size = xdp->data_end - xdp->data;
 	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
+	unsigned int metasize = xdp->data - xdp->data_meta;
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	net_prefetch(va);
+	net_prefetch(xdp->data_meta);
 
 	/* build an skb around the page buffer */
-	skb = build_skb(va - IGC_SKB_PAD, truesize);
+	skb = build_skb(xdp->data_hard_start, truesize);
 	if (unlikely(!skb))
 		return NULL;
 
 	/* update pointers within the skb to store the data */
-	skb_reserve(skb, IGC_SKB_PAD);
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	__skb_put(skb, size);
+	if (metasize)
+		skb_metadata_set(skb, metasize);
 
 	igc_rx_buffer_flip(rx_buffer, truesize);
 	return skb;
@@ -1746,6 +1748,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 					 struct xdp_buff *xdp,
 					 ktime_t timestamp)
 {
+	unsigned int metasize = xdp->data - xdp->data_meta;
 	unsigned int size = xdp->data_end - xdp->data;
 	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
 	void *va = xdp->data;
@@ -1753,10 +1756,11 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	net_prefetch(va);
+	net_prefetch(xdp->data_meta);
 
 	/* allocate a skb to store the frags */
-	skb = napi_alloc_skb(&rx_ring->q_vector->napi, IGC_RX_HDR_LEN);
+	skb = napi_alloc_skb(&rx_ring->q_vector->napi,
+			     IGC_RX_HDR_LEN + metasize);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -1769,7 +1773,13 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
 		headlen = eth_get_headlen(skb->dev, va, IGC_RX_HDR_LEN);
 
 	/* align pull length to size of long to optimize memcpy performance */
-	memcpy(__skb_put(skb, headlen), va, ALIGN(headlen, sizeof(long)));
+	memcpy(__skb_put(skb, headlen + metasize), xdp->data_meta,
+	       ALIGN(headlen + metasize, sizeof(long)));
+
+	if (metasize) {
+		skb_metadata_set(skb, metasize);
+		__skb_pull(skb, metasize);
+	}
 
 	/* update all of the pointers */
 	size -= headlen;
@@ -2354,7 +2364,8 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		if (!skb) {
 			xdp_init_buff(&xdp, truesize, &rx_ring->xdp_rxq);
 			xdp_prepare_buff(&xdp, pktbuf - igc_rx_offset(rx_ring),
-					 igc_rx_offset(rx_ring) + pkt_offset, size, false);
+					 igc_rx_offset(rx_ring) + pkt_offset,
+					 size, true);
 
 			skb = igc_xdp_run_prog(adapter, &xdp);
 		}
@@ -2378,7 +2389,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 		} else if (skb)
 			igc_add_rx_frag(rx_ring, rx_buffer, skb, size);
 		else if (ring_uses_build_skb(rx_ring))
-			skb = igc_build_skb(rx_ring, rx_buffer, rx_desc, size);
+			skb = igc_build_skb(rx_ring, rx_buffer, &xdp);
 		else
 			skb = igc_construct_skb(rx_ring, rx_buffer, &xdp,
 						timestamp);
-- 
2.31.1

