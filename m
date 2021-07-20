Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BE73D0544
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhGTWnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:43:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:6290 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234905AbhGTWmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:42:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="208225505"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="208225505"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:23:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="657876567"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jul 2021 16:23:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Markus Boehme <markubo@amazon.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, stable@vger.kernel.org,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 1/1] ixgbe: Fix packet corruption due to missing DMA sync
Date:   Tue, 20 Jul 2021 16:26:19 -0700
Message-Id: <20210720232619.3088791-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Boehme <markubo@amazon.com>

When receiving a packet with multiple fragments, hardware may still
touch the first fragment until the entire packet has been received. The
driver therefore keeps the first fragment mapped for DMA until end of
packet has been asserted, and delays its dma_sync call until then.

The driver tries to fit multiple receive buffers on one page. When using
3K receive buffers (e.g. using Jumbo frames and legacy-rx is turned
off/build_skb is being used) on an architecture with 4K pages, the
driver allocates an order 1 compound page and uses one page per receive
buffer. To determine the correct offset for a delayed DMA sync of the
first fragment of a multi-fragment packet, the driver then cannot just
use PAGE_MASK on the DMA address but has to construct a mask based on
the actual size of the backing page.

Using PAGE_MASK in the 3K RX buffer/4K page architecture configuration
will always sync the first page of a compound page. With the SWIOTLB
enabled this can lead to corrupted packets (zeroed out first fragment,
re-used garbage from another packet) and various consequences, such as
slow/stalling data transfers and connection resets. For example, testing
on a link with MTU exceeding 3058 bytes on a host with SWIOTLB enabled
(e.g. "iommu=soft swiotlb=262144,force") TCP transfers quickly fizzle
out without this patch.

Cc: stable@vger.kernel.org
Fixes: 0c5661ecc5dd7 ("ixgbe: fix crash in build_skb Rx code path")
Signed-off-by: Markus Boehme <markubo@amazon.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 913253f8ecb4..14aea40da50f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1825,7 +1825,8 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 				struct sk_buff *skb)
 {
 	if (ring_uses_build_skb(rx_ring)) {
-		unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
+		unsigned long mask = (unsigned long)ixgbe_rx_pg_size(rx_ring) - 1;
+		unsigned long offset = (unsigned long)(skb->data) & mask;
 
 		dma_sync_single_range_for_cpu(rx_ring->dev,
 					      IXGBE_CB(skb)->dma,
-- 
2.26.2

