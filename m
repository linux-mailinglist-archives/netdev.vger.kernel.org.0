Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FACE495EB
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfFQXdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:33:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:25836 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbfFQXda (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 19:33:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 16:33:24 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jun 2019 16:33:26 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/11] iavf: allow null RX descriptors
Date:   Mon, 17 Jun 2019 16:33:36 -0700
Message-Id: <20190617233336.18119-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
References: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

In some circumstances, the hardware can hand us a null receive
descriptor, with no data attached but otherwise valid. Unfortunately,
the driver was ill-equipped to handle such an event, and would stop
processing packets at that point.

To fix this, use the Descriptor Done bit instead of the size to
determine whether or not a descriptor is ready to be processed. Add some
checks to allow for unused buffers.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index d28b57937245..1cde1601bc32 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1236,6 +1236,9 @@ static void iavf_add_rx_frag(struct iavf_ring *rx_ring,
 	unsigned int truesize = SKB_DATA_ALIGN(size + iavf_rx_offset(rx_ring));
 #endif
 
+	if (!size)
+		return;
+
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
 			rx_buffer->page_offset, size, truesize);
 
@@ -1260,6 +1263,9 @@ static struct iavf_rx_buffer *iavf_get_rx_buffer(struct iavf_ring *rx_ring,
 {
 	struct iavf_rx_buffer *rx_buffer;
 
+	if (!size)
+		return NULL;
+
 	rx_buffer = &rx_ring->rx_bi[rx_ring->next_to_clean];
 	prefetchw(rx_buffer->page);
 
@@ -1299,6 +1305,8 @@ static struct sk_buff *iavf_construct_skb(struct iavf_ring *rx_ring,
 	unsigned int headlen;
 	struct sk_buff *skb;
 
+	if (!rx_buffer)
+		return NULL;
 	/* prefetch first cache line of first page */
 	prefetch(va);
 #if L1_CACHE_BYTES < 128
@@ -1363,6 +1371,8 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 #endif
 	struct sk_buff *skb;
 
+	if (!rx_buffer)
+		return NULL;
 	/* prefetch first cache line of first page */
 	prefetch(va);
 #if L1_CACHE_BYTES < 128
@@ -1398,6 +1408,9 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 static void iavf_put_rx_buffer(struct iavf_ring *rx_ring,
 			       struct iavf_rx_buffer *rx_buffer)
 {
+	if (!rx_buffer)
+		return;
+
 	if (iavf_can_reuse_rx_page(rx_buffer)) {
 		/* hand second half of page back to the ring */
 		iavf_reuse_rx_page(rx_ring, rx_buffer);
@@ -1496,11 +1509,12 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
 		 * verified the descriptor has been written back.
 		 */
 		dma_rmb();
+#define IAVF_RXD_DD BIT(IAVF_RX_DESC_STATUS_DD_SHIFT)
+		if (!iavf_test_staterr(rx_desc, IAVF_RXD_DD))
+			break;
 
 		size = (qword & IAVF_RXD_QW1_LENGTH_PBUF_MASK) >>
 		       IAVF_RXD_QW1_LENGTH_PBUF_SHIFT;
-		if (!size)
-			break;
 
 		iavf_trace(clean_rx_irq, rx_ring, rx_desc, skb);
 		rx_buffer = iavf_get_rx_buffer(rx_ring, size);
@@ -1516,7 +1530,8 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
-			rx_buffer->pagecnt_bias++;
+			if (rx_buffer)
+				rx_buffer->pagecnt_bias++;
 			break;
 		}
 
-- 
2.21.0

