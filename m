Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4262D5007
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgLJBEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:04:36 -0500
Received: from mga18.intel.com ([134.134.136.126]:24733 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731002AbgLJBEW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 20:04:22 -0500
IronPort-SDR: Y7aIBpQ50Xw/L/NCmCZXL1buumHqW+0MX5DFatU1r2LodMpmkSXnOXLy7w3xIKlKzfONthX/Oe
 HkKmj4gaa4Xg==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="161937222"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="161937222"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 17:03:00 -0800
IronPort-SDR: GboAISJEHlZEjPNCogGFysoLKjC1ssg9PXZST+10G11EdAQQxejalPd+WjjFiaQbgF13BxIfbd
 +3yv66Ba4bWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="338203399"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 09 Dec 2020 17:02:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Li RongQing <lirongqing@baidu.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [net 8/9] ixgbe: avoid premature Rx buffer reuse
Date:   Wed,  9 Dec 2020 17:02:51 -0800
Message-Id: <20201210010252.4029245-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201210010252.4029245-1-anthony.l.nguyen@intel.com>
References: <20201210010252.4029245-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The page recycle code, incorrectly, relied on that a page fragment
could not be freed inside xdp_do_redirect(). This assumption leads to
that page fragments that are used by the stack/XDP redirect can be
reused and overwritten.

To avoid this, store the page count prior invoking xdp_do_redirect().

Fixes: 6453073987ba ("ixgbe: add initial support for xdp redirect")
Reported-and-analyzed-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 45ae33e15303..f3f449f53920 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1945,7 +1945,8 @@ static inline bool ixgbe_page_is_reserved(struct page *page)
 	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
-static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer)
+static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer,
+				    int rx_buffer_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
@@ -1956,7 +1957,7 @@ static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_ref_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 	/* The last offset is a bit aggressive in that we assume the
@@ -2021,11 +2022,18 @@ static void ixgbe_add_rx_frag(struct ixgbe_ring *rx_ring,
 static struct ixgbe_rx_buffer *ixgbe_get_rx_buffer(struct ixgbe_ring *rx_ring,
 						   union ixgbe_adv_rx_desc *rx_desc,
 						   struct sk_buff **skb,
-						   const unsigned int size)
+						   const unsigned int size,
+						   int *rx_buffer_pgcnt)
 {
 	struct ixgbe_rx_buffer *rx_buffer;
 
 	rx_buffer = &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
+	*rx_buffer_pgcnt =
+#if (PAGE_SIZE < 8192)
+		page_count(rx_buffer->page);
+#else
+		0;
+#endif
 	prefetchw(rx_buffer->page);
 	*skb = rx_buffer->skb;
 
@@ -2055,9 +2063,10 @@ static struct ixgbe_rx_buffer *ixgbe_get_rx_buffer(struct ixgbe_ring *rx_ring,
 
 static void ixgbe_put_rx_buffer(struct ixgbe_ring *rx_ring,
 				struct ixgbe_rx_buffer *rx_buffer,
-				struct sk_buff *skb)
+				struct sk_buff *skb,
+				int rx_buffer_pgcnt)
 {
-	if (ixgbe_can_reuse_rx_page(rx_buffer)) {
+	if (ixgbe_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
 		/* hand second half of page back to the ring */
 		ixgbe_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
@@ -2303,6 +2312,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		union ixgbe_adv_rx_desc *rx_desc;
 		struct ixgbe_rx_buffer *rx_buffer;
 		struct sk_buff *skb;
+		int rx_buffer_pgcnt;
 		unsigned int size;
 
 		/* return some buffers to hardware, one at a time is too slow */
@@ -2322,7 +2332,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		 */
 		dma_rmb();
 
-		rx_buffer = ixgbe_get_rx_buffer(rx_ring, rx_desc, &skb, size);
+		rx_buffer = ixgbe_get_rx_buffer(rx_ring, rx_desc, &skb, size, &rx_buffer_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -2367,7 +2377,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			break;
 		}
 
-		ixgbe_put_rx_buffer(rx_ring, rx_buffer, skb);
+		ixgbe_put_rx_buffer(rx_ring, rx_buffer, skb, rx_buffer_pgcnt);
 		cleaned_count++;
 
 		/* place incomplete frames back on ring for completion */
-- 
2.26.2

