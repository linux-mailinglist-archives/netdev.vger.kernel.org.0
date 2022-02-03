Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735284A90DA
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 23:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355879AbiBCWta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 17:49:30 -0500
Received: from mga04.intel.com ([192.55.52.120]:48202 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231437AbiBCWt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 17:49:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643928569; x=1675464569;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=twS+setjSAWsPuwnGNG/fvIv+vG+K+FoADvDwgrNZw8=;
  b=Ji9aeE0qKxA068SME8w9NPu8gnsewm9CI08Zc1cdTZHtDvF1Y1VShZnz
   ocec4eS5A55L/oKAHIhNvQu/OG2b33w9dnEevoajPvWRlCDTYd13uUEOm
   f+0cUAftEGGxeCs0I69yASrNe03SXJvKf+/iizqZWOTGvid51IUzmS1iz
   LF+WkYxZmnNQ1yfLZSNgYemJ1oJso9F/WZEd+PPfdBxQ+esIimep1b/7q
   UM8+lWVy8ROv9z8xhjO+a0wAS/d7d3h9ppmzHIQoLzuoZ+ssNtw2pOoSg
   v3nFw9okxPwCNTKG83cjA52kAbRLtJDwALrIl5Js4kizLvnRd+1hLkvzo
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="247103027"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="247103027"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 14:49:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="538951042"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 03 Feb 2022 14:49:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Samuel Mendoza-Jonas <samjonas@amazon.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/1] ixgbevf: Require large buffers for build_skb on 82599VF
Date:   Thu,  3 Feb 2022 14:49:16 -0800
Message-Id: <20220203224916.1416367-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Samuel Mendoza-Jonas <samjonas@amazon.com>

From 4.17 onwards the ixgbevf driver uses build_skb() to build an skb
around new data in the page buffer shared with the ixgbe PF.
This uses either a 2K or 3K buffer, and offsets the DMA mapping by
NET_SKB_PAD + NET_IP_ALIGN. When using a smaller buffer RXDCTL is set to
ensure the PF does not write a full 2K bytes into the buffer, which is
actually 2K minus the offset.

However on the 82599 virtual function, the RXDCTL mechanism is not
available. The driver attempts to work around this by using the SET_LPE
mailbox method to lower the maximm frame size, but the ixgbe PF driver
ignores this in order to keep the PF and all VFs in sync[0].

This means the PF will write up to the full 2K set in SRRCTL, causing it
to write NET_SKB_PAD + NET_IP_ALIGN bytes past the end of the buffer.
With 4K pages split into two buffers, this means it either writes
NET_SKB_PAD + NET_IP_ALIGN bytes past the first buffer (and into the
second), or NET_SKB_PAD + NET_IP_ALIGN bytes past the end of the DMA
mapping.

Avoid this by only enabling build_skb when using "large" buffers (3K).
These are placed in each half of an order-1 page, preventing the PF from
writing past the end of the mapping.

[0]: Technically it only ever raises the max frame size, see
ixgbe_set_vf_lpe() in ixgbe_sriov.c

Fixes: f15c5ba5b6cd ("ixgbevf: add support for using order 1 pages to receive large frames")
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 0015fcf1df2b..0f293acd17e8 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1984,14 +1984,15 @@ static void ixgbevf_set_rx_buffer_len(struct ixgbevf_adapter *adapter,
 	if (adapter->flags & IXGBEVF_FLAGS_LEGACY_RX)
 		return;
 
-	set_ring_build_skb_enabled(rx_ring);
+	if (PAGE_SIZE < 8192)
+		if (max_frame > IXGBEVF_MAX_FRAME_BUILD_SKB)
+			set_ring_uses_large_buffer(rx_ring);
 
-	if (PAGE_SIZE < 8192) {
-		if (max_frame <= IXGBEVF_MAX_FRAME_BUILD_SKB)
-			return;
+	/* 82599 can't rely on RXDCTL.RLPML to restrict the size of the frame */
+	if (adapter->hw.mac.type == ixgbe_mac_82599_vf && !ring_uses_large_buffer(rx_ring))
+		return;
 
-		set_ring_uses_large_buffer(rx_ring);
-	}
+	set_ring_build_skb_enabled(rx_ring);
 }
 
 /**
-- 
2.31.1

