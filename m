Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405A02D5003
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgLJBEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:04:06 -0500
Received: from mga18.intel.com ([134.134.136.126]:24733 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgLJBDl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 20:03:41 -0500
IronPort-SDR: 5ooYmP5X3Jwzy7DvDq0VPCPhwApEi5sKG7Vy/rR7g1pxGib6wXgSrYhfqA46lwh9CMhw7OsihX
 o5XtvlHPWZfw==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="161937223"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="161937223"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 17:03:00 -0800
IronPort-SDR: 3aV6/dVEU+kWeDi3XfiS+3XLHEYPKQVSJeaPkwGZyvqwPdarPzoMzgCxQr9NrAStkcwnBsyXIl
 8p2ADL7xO12A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="338203402"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 09 Dec 2020 17:02:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Li RongQing <lirongqing@baidu.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [net 9/9] ice: avoid premature Rx buffer reuse
Date:   Wed,  9 Dec 2020 17:02:52 -0800
Message-Id: <20201210010252.4029245-10-anthony.l.nguyen@intel.com>
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

Fixes: efc2214b6047 ("ice: Add support for XDP")
Reported-and-analyzed-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 31 ++++++++++++++++-------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index eae75260fe20..23eca2f0a03b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -762,13 +762,15 @@ ice_rx_buf_adjust_pg_offset(struct ice_rx_buf *rx_buf, unsigned int size)
 /**
  * ice_can_reuse_rx_page - Determine if page can be reused for another Rx
  * @rx_buf: buffer containing the page
+ * @rx_buf_pgcnt: rx_buf page refcount pre xdp_do_redirect() call
  *
  * If page is reusable, we have a green light for calling ice_reuse_rx_page,
  * which will assign the current buffer to the buffer that next_to_alloc is
  * pointing to; otherwise, the DMA mapping needs to be destroyed and
  * page freed
  */
-static bool ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
+static bool
+ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf, int rx_buf_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buf->pagecnt_bias;
 	struct page *page = rx_buf->page;
@@ -779,7 +781,7 @@ static bool ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buf_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 #define ICE_LAST_OFFSET \
@@ -864,17 +866,24 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
  * @rx_ring: Rx descriptor ring to transact packets on
  * @skb: skb to be used
  * @size: size of buffer to add to skb
+ * @rx_buf_pgcnt: rx_buf page refcount
  *
  * This function will pull an Rx buffer from the ring and synchronize it
  * for use by the CPU.
  */
 static struct ice_rx_buf *
 ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
-	       const unsigned int size)
+	       const unsigned int size, int *rx_buf_pgcnt)
 {
 	struct ice_rx_buf *rx_buf;
 
 	rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
+	*rx_buf_pgcnt =
+#if (PAGE_SIZE < 8192)
+		page_count(rx_buf->page);
+#else
+		0;
+#endif
 	prefetchw(rx_buf->page);
 	*skb = rx_buf->skb;
 
@@ -1006,12 +1015,15 @@ ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * ice_put_rx_buf - Clean up used buffer and either recycle or free
  * @rx_ring: Rx descriptor ring to transact packets on
  * @rx_buf: Rx buffer to pull data from
+ * @rx_buf_pgcnt: Rx buffer page count pre xdp_do_redirect()
  *
  * This function will update next_to_clean and then clean up the contents
  * of the rx_buf. It will either recycle the buffer or unmap it and free
  * the associated resources.
  */
-static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
+static void
+ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
+	       int rx_buf_pgcnt)
 {
 	u16 ntc = rx_ring->next_to_clean + 1;
 
@@ -1022,7 +1034,7 @@ static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 	if (!rx_buf)
 		return;
 
-	if (ice_can_reuse_rx_page(rx_buf)) {
+	if (ice_can_reuse_rx_page(rx_buf, rx_buf_pgcnt)) {
 		/* hand second half of page back to the ring */
 		ice_reuse_rx_page(rx_ring, rx_buf);
 	} else {
@@ -1097,6 +1109,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		struct sk_buff *skb;
 		unsigned int size;
 		u16 stat_err_bits;
+		int rx_buf_pgcnt;
 		u16 vlan_tag = 0;
 		u8 rx_ptype;
 
@@ -1119,7 +1132,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		dma_rmb();
 
 		if (rx_desc->wb.rxdid == FDIR_DESC_RXDID || !rx_ring->netdev) {
-			ice_put_rx_buf(rx_ring, NULL);
+			ice_put_rx_buf(rx_ring, NULL, 0);
 			cleaned_count++;
 			continue;
 		}
@@ -1128,7 +1141,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
 		/* retrieve a buffer from the ring */
-		rx_buf = ice_get_rx_buf(rx_ring, &skb, size);
+		rx_buf = ice_get_rx_buf(rx_ring, &skb, size, &rx_buf_pgcnt);
 
 		if (!size) {
 			xdp.data = NULL;
@@ -1168,7 +1181,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		total_rx_pkts++;
 
 		cleaned_count++;
-		ice_put_rx_buf(rx_ring, rx_buf);
+		ice_put_rx_buf(rx_ring, rx_buf, rx_buf_pgcnt);
 		continue;
 construct_skb:
 		if (skb) {
@@ -1187,7 +1200,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			break;
 		}
 
-		ice_put_rx_buf(rx_ring, rx_buf);
+		ice_put_rx_buf(rx_ring, rx_buf, rx_buf_pgcnt);
 		cleaned_count++;
 
 		/* skip if it is NOP desc */
-- 
2.26.2

