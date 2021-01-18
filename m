Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203732FA492
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393424AbhARPYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:24:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:63476 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391586AbhARPXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 10:23:55 -0500
IronPort-SDR: r7ZCXCkTZozXdF69AqTS+8GDxWvstKcRcmnfQ41qzi8ZkYvnoRGo87k+W6ZVdvVa8WleqXS1xT
 OKeJO/BLBnsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="165905500"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="165905500"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 07:22:58 -0800
IronPort-SDR: Bd4fTjG3K5Bhe8zJXXX38hsKDWODEMr3ulSxXAOB/B1LVnSsITF5KbNtnjEpbQJNkFI5oAhqT4
 fVCUysn7Xs4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="500676310"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2021 07:22:56 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 net-next 02/11] i40e: drop misleading function comments
Date:   Mon, 18 Jan 2021 16:13:09 +0100
Message-Id: <20210118151318.12324-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
References: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i40e_cleanup_headers has a statement about check against skb being
linear or not which is not relevant anymore, so let's remove it.

Same case for i40e_can_reuse_rx_page, it references things that are not
present there anymore.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 33 ++++-----------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 2574e78f7597..f8aa68f2a7fd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1809,9 +1809,6 @@ void i40e_process_skb_fields(struct i40e_ring *rx_ring,
  * @skb: pointer to current skb being fixed
  * @rx_desc: pointer to the EOP Rx descriptor
  *
- * Also address the case where we are pulling data in on pages only
- * and as such no data is present in the skb header.
- *
  * In addition if skb is not at least 60 bytes we need to pad it so that
  * it is large enough to qualify as a valid Ethernet frame.
  *
@@ -1857,33 +1854,15 @@ static inline bool i40e_page_is_reusable(struct page *page)
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
2.20.1

