Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6261333955C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbhCLRrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:47:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:9116 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232389AbhCLRqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:46:39 -0500
IronPort-SDR: sEAmTNS7uJ7yyntqzntbFUn4rbJHjjN++sI+okome5Da28h0fZoidUu4W+FLqeMQ5CPJ/3Y2S6
 PlMNw4UNKeZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="250232659"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="250232659"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 09:46:38 -0800
IronPort-SDR: 8+soPSxeJkhJtDchE4Jq4y944WCLhk8kNCmvXbhnvmydm0F7Dx3rxqTSLGGZJ5RRNqYwmArbCU
 G1neRWW/LtrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="589615860"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2021 09:46:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com,
        Alexander Duyck <alexanderduyck@fb.com>,
        Vishakha Jambekar <vishakha.jambekar@intel.com>
Subject: [PATCH net 5/5] igb: avoid premature Rx buffer reuse
Date:   Fri, 12 Mar 2021 09:47:55 -0800
Message-Id: <20210312174755.2103336-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
References: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

Igb needs a similar fix as commit 75aab4e10ae6a ("i40e: avoid
premature Rx buffer reuse")

The page recycle code, incorrectly, relied on that a page fragment
could not be freed inside xdp_do_redirect(). This assumption leads to
that page fragments that are used by the stack/XDP redirect can be
reused and overwritten.

To avoid this, store the page count prior invoking xdp_do_redirect().

Longer explanation:

Intel NICs have a recycle mechanism. The main idea is that a page is
split into two parts. One part is owned by the driver, one part might
be owned by someone else, such as the stack.

t0: Page is allocated, and put on the Rx ring
              +---------------
used by NIC ->| upper buffer
(rx_buffer)   +---------------
              | lower buffer
              +---------------
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX

t1: Buffer is received, and passed to the stack (e.g.)
              +---------------
              | upper buff (skb)
              +---------------
used by NIC ->| lower buffer
(rx_buffer)   +---------------
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX - 1

t2: Buffer is received, and redirected
              +---------------
              | upper buff (skb)
              +---------------
used by NIC ->| lower buffer
(rx_buffer)   +---------------

Now, prior calling xdp_do_redirect():
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX - 2

This means that buffer *cannot* be flipped/reused, because the skb is
still using it.

The problem arises when xdp_do_redirect() actually frees the
segment. Then we get:
  page count  == USHRT_MAX - 1
  rx_buffer->pagecnt_bias == USHRT_MAX - 2

From a recycle perspective, the buffer can be flipped and reused,
which means that the skb data area is passed to the Rx HW ring!

To work around this, the page count is stored prior calling
xdp_do_redirect().

Fixes: 9cbc948b5a20 ("igb: add XDP support")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 878b31d534ec..d3b37761f637 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8214,7 +8214,8 @@ static void igb_reuse_rx_page(struct igb_ring *rx_ring,
 	new_buff->pagecnt_bias	= old_buff->pagecnt_bias;
 }
 
-static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
+static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer,
+				  int rx_buf_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
@@ -8225,7 +8226,7 @@ static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_ref_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buf_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 #define IGB_LAST_OFFSET \
@@ -8614,11 +8615,17 @@ static unsigned int igb_rx_offset(struct igb_ring *rx_ring)
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
@@ -8634,9 +8641,9 @@ static struct igb_rx_buffer *igb_get_rx_buffer(struct igb_ring *rx_ring,
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
@@ -8664,6 +8671,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	unsigned int xdp_xmit = 0;
 	struct xdp_buff xdp;
 	u32 frame_sz = 0;
+	int rx_buf_pgcnt;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
 #if (PAGE_SIZE < 8192)
@@ -8693,7 +8701,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 		 */
 		dma_rmb();
 
-		rx_buffer = igb_get_rx_buffer(rx_ring, size);
+		rx_buffer = igb_get_rx_buffer(rx_ring, size, &rx_buf_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -8736,7 +8744,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 			break;
 		}
 
-		igb_put_rx_buffer(rx_ring, rx_buffer);
+		igb_put_rx_buffer(rx_ring, rx_buffer, rx_buf_pgcnt);
 		cleaned_count++;
 
 		/* fetch next buffer in frame if non-eop */
-- 
2.26.2

