Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E1388279
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436733AbfHISbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:31:46 -0400
Received: from mga17.intel.com ([192.55.52.151]:55689 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436493AbfHISbn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 14:31:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 11:31:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="175229911"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2019 11:31:43 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] ice: allow empty Rx descriptors
Date:   Fri,  9 Aug 2019 11:31:32 -0700
Message-Id: <20190809183139.30871-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
References: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

In some circumstances, the hardware will hand us a receive descriptor
which has no data attached, but is otherwise valid. The receive code was
improperly ignoring these descriptors, which result in an infinite loop.

To fix this, change the receive code to process all descriptors,
regardless of the size of the associated data. Add checks to the
memory-handling functions to allow for zero size.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index c88e0701e1d7..e5c4c9139e54 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -607,6 +607,8 @@ ice_add_rx_frag(struct ice_rx_buf *rx_buf, struct sk_buff *skb,
 	unsigned int truesize = ICE_RXBUF_2048;
 #endif
 
+	if (!size)
+		return;
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buf->page,
 			rx_buf->page_offset, size, truesize);
 
@@ -662,6 +664,8 @@ ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
 	prefetchw(rx_buf->page);
 	*skb = rx_buf->skb;
 
+	if (!size)
+		return rx_buf;
 	/* we are reusing so sync this buffer for CPU use */
 	dma_sync_single_range_for_cpu(rx_ring->dev, rx_buf->dma,
 				      rx_buf->page_offset, size,
@@ -745,8 +749,11 @@ ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  */
 static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 {
-		/* hand second half of page back to the ring */
+	if (!rx_buf)
+		return;
+
 	if (ice_can_reuse_rx_page(rx_buf)) {
+		/* hand second half of page back to the ring */
 		ice_reuse_rx_page(rx_ring, rx_buf);
 		rx_ring->rx_stats.page_reuse_count++;
 	} else {
@@ -1031,8 +1038,9 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		size = le16_to_cpu(rx_desc->wb.pkt_len) &
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
+		/* retrieve a buffer from the ring */
 		rx_buf = ice_get_rx_buf(rx_ring, &skb, size);
-		/* allocate (if needed) and populate skb */
+
 		if (skb)
 			ice_add_rx_frag(rx_buf, skb, size);
 		else
@@ -1041,7 +1049,8 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buf_failed++;
-			rx_buf->pagecnt_bias++;
+			if (rx_buf)
+				rx_buf->pagecnt_bias++;
 			break;
 		}
 
-- 
2.21.0

