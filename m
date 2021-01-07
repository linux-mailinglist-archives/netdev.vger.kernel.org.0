Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF1A2EC935
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 04:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbhAGDv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 22:51:58 -0500
Received: from mx435.baidu.com ([119.249.100.99]:46689 "EHLO
        dbl-sys-mailin02.dbl01.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726051AbhAGDv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 22:51:58 -0500
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2021 22:51:57 EST
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (unknown [10.217.33.253])
        by dbl-sys-mailin02.dbl01.baidu.com (Postfix) with ESMTP id 7D7592F0009E;
        Thu,  7 Jan 2021 11:41:45 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        bjorn.topel@intel.com
Subject: [PATCH] igb: avoid premature Rx buffer reuse
Date:   Thu,  7 Jan 2021 11:41:45 +0800
Message-Id: <1609990905-29220-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The page recycle code, incorrectly, relied on that a page fragment
could not be freed inside xdp_do_redirect(). This assumption leads to
that page fragments that are used by the stack/XDP redirect can be
reused and overwritten.

To avoid this, store the page count prior invoking xdp_do_redirect().

Fixes: 9cbc948b5a20 ("igb: add XDP support")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03f78fdb0dcd..3e0d903cf919 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8232,7 +8232,8 @@ static inline bool igb_page_is_reserved(struct page *page)
 	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
-static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
+static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer,
+								 int rx_buf_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
@@ -8243,7 +8244,7 @@ static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_ref_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buf_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 #define IGB_LAST_OFFSET \
@@ -8632,11 +8633,17 @@ static unsigned int igb_rx_offset(struct igb_ring *rx_ring)
 }
 
 static struct igb_rx_buffer *igb_get_rx_buffer(struct igb_ring *rx_ring,
-					       const unsigned int size)
+					       const unsigned int size, int *rx_buf_pgcnt)
 {
 	struct igb_rx_buffer *rx_buffer;
 
 	rx_buffer = &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
+	*rx_buf_pgcnt =
+#if (PAGE_SIZE < 8192)
+		page_count(rx_buffer->page);
+#else
+		0;
+#endif
 	prefetchw(rx_buffer->page);
 
 	/* we are reusing so sync this buffer for CPU use */
@@ -8652,9 +8659,9 @@ static struct igb_rx_buffer *igb_get_rx_buffer(struct igb_ring *rx_ring,
 }
 
 static void igb_put_rx_buffer(struct igb_ring *rx_ring,
-			      struct igb_rx_buffer *rx_buffer)
+			      struct igb_rx_buffer *rx_buffer, int rx_buf_pgcnt)
 {
-	if (igb_can_reuse_rx_page(rx_buffer)) {
+	if (igb_can_reuse_rx_page(rx_buffer, rx_buf_pgcnt)) {
 		/* hand second half of page back to the ring */
 		igb_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
@@ -8681,6 +8688,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	u16 cleaned_count = igb_desc_unused(rx_ring);
 	unsigned int xdp_xmit = 0;
 	struct xdp_buff xdp;
+	int rx_buf_pgcnt;
 
 	xdp.rxq = &rx_ring->xdp_rxq;
 
@@ -8711,7 +8719,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 		 */
 		dma_rmb();
 
-		rx_buffer = igb_get_rx_buffer(rx_ring, size);
+		rx_buffer = igb_get_rx_buffer(rx_ring, size, &rx_buf_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -8754,7 +8762,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 			break;
 		}
 
-		igb_put_rx_buffer(rx_ring, rx_buffer);
+		igb_put_rx_buffer(rx_ring, rx_buffer, rx_buf_pgcnt);
 		cleaned_count++;
 
 		/* fetch next buffer in frame if non-eop */
-- 
2.17.3

