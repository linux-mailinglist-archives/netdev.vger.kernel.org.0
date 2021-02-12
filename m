Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B355F31A7F6
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhBLWoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:44:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:44262 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232360AbhBLWl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:41:59 -0500
IronPort-SDR: 583SsiXpRsdf6g+et8wXnM+gPCW47TExatgWffZ+sCDQs1V9eI6OMahvsApCpHF/W1M0oGTZLU
 7IFik8bMQmVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="169617156"
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="169617156"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 14:39:00 -0800
IronPort-SDR: xcN6ntD+KAGlvXfvrjxwIrX7b1NB5tqN91gduIgTm5Cz9V0Qy89zOaaQm1RpC6VJYviDIS8JHC
 ++/l1ArqK20w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="381885351"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 12 Feb 2021 14:38:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 02/11] i40e: drop misleading function comments
Date:   Fri, 12 Feb 2021 14:39:43 -0800
Message-Id: <20210212223952.1172568-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
References: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

i40e_cleanup_headers has a statement about check against skb being
linear or not which is not relevant anymore, so let's remove it.

Same case for i40e_can_reuse_rx_page, it references things that are not
present there anymore.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 33 ++++-----------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3d24c6032616..5f6aa13e85ca 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1963,9 +1963,6 @@ void i40e_process_skb_fields(struct i40e_ring *rx_ring,
  * @skb: pointer to current skb being fixed
  * @rx_desc: pointer to the EOP Rx descriptor
  *
- * Also address the case where we are pulling data in on pages only
- * and as such no data is present in the skb header.
- *
  * In addition if skb is not at least 60 bytes we need to pad it so that
  * it is large enough to qualify as a valid Ethernet frame.
  *
@@ -1998,33 +1995,15 @@ static bool i40e_cleanup_headers(struct i40e_ring *rx_ring, struct sk_buff *skb,
 }
 
 /**
- * i40e_can_reuse_rx_page - Determine if this page can be reused by
- * the adapter for another receive
- *
+ * i40e_can_reuse_rx_page - Determine if page can be reused for another Rx
  * @rx_buffer: buffer containing the page
  * @rx_buffer_pgcnt: buffer page refcount pre xdp_do_redirect() call
  *
- * If page is reusable, rx_buffer->page_offset is adjusted to point to
- * an unused region in the page.
- *
- * For small pages, @truesize will be a constant value, half the size
- * of the memory at page.  We'll attempt to alternate between high and
- * low halves of the page, with one half ready for use by the hardware
- * and the other half being consumed by the stack.  We use the page
- * ref count to determine whether the stack has finished consuming the
- * portion of this page that was passed up with a previous packet.  If
- * the page ref count is >1, we'll assume the "other" half page is
- * still busy, and this page cannot be reused.
- *
- * For larger pages, @truesize will be the actual space used by the
- * received packet (adjusted upward to an even multiple of the cache
- * line size).  This will advance through the page by the amount
- * actually consumed by the received packets while there is still
- * space for a buffer.  Each region of larger pages will be used at
- * most once, after which the page will not be reused.
- *
- * In either case, if the page is reusable its refcount is increased.
- **/
+ * If page is reusable, we have a green light for calling i40e_reuse_rx_page,
+ * which will assign the current buffer to the buffer that next_to_alloc is
+ * pointing to; otherwise, the DMA mapping needs to be destroyed and
+ * page freed
+ */
 static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
 				   int rx_buffer_pgcnt)
 {
-- 
2.26.2

