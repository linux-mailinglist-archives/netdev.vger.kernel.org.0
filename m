Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCCD33955F
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhCLRrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:47:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:9116 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhCLRqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:46:39 -0500
IronPort-SDR: 3GYrrvfxllofZpDdeN6g26Bld3Ks4OM11op2bEW49JYsoBRNtf6Kt5MwAaJndGTNod4UtsRdIx
 lW+3BN8KXCxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="250232657"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="250232657"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 09:46:38 -0800
IronPort-SDR: lIpIs+wErLA7VUhHet/X58m516IHeVzDiNF6vB56j9iQvd/TZiZTPnbfqug9WxdVndV2joPx35
 jpkahCFgt2cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="589615854"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2021 09:46:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 3/5] ice: move headroom initialization to ice_setup_rx_ctx
Date:   Fri, 12 Mar 2021 09:47:53 -0800
Message-Id: <20210312174755.2103336-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
References: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

ice_rx_offset(), that is supposed to initialize the Rx buffer headroom,
relies on ICE_RX_FLAGS_RING_BUILD_SKB flag as well as XDP prog presence.

Currently, the callsite of mentioned function is placed incorrectly
within ice_setup_rx_ring() where Rx ring's build skb flag is not
set yet. This causes the XDP_REDIRECT to be partially broken due to
inability to create xdp_frame in the headroom space, as the headroom is
0.

Fix this by moving ice_rx_offset() to ice_setup_rx_ctx() after the flag
setting.

Fixes: f1b1f409bf79 ("ice: store the result of ice_rx_offset() onto ice_ring")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 18 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 17 -----------------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 952e41a1e001..1148d768f8ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -274,6 +274,22 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
 	tlan_ctx->legacy_int = ICE_TX_LEGACY;
 }
 
+/**
+ * ice_rx_offset - Return expected offset into page to access data
+ * @rx_ring: Ring we are requesting offset of
+ *
+ * Returns the offset value for ring into the data buffer.
+ */
+static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
+{
+	if (ice_ring_uses_build_skb(rx_ring))
+		return ICE_SKB_PAD;
+	else if (ice_is_xdp_ena_vsi(rx_ring->vsi))
+		return XDP_PACKET_HEADROOM;
+
+	return 0;
+}
+
 /**
  * ice_setup_rx_ctx - Configure a receive ring context
  * @ring: The Rx ring to configure
@@ -413,6 +429,8 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	else
 		ice_set_ring_build_skb_ena(ring);
 
+	ring->rx_offset = ice_rx_offset(ring);
+
 	/* init queue specific tail register */
 	ring->tail = hw->hw_addr + QRX_TAIL(pf_q);
 	writel(0, ring->tail);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index b7dc25da1202..b91dcfd12727 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -443,22 +443,6 @@ void ice_free_rx_ring(struct ice_ring *rx_ring)
 	}
 }
 
-/**
- * ice_rx_offset - Return expected offset into page to access data
- * @rx_ring: Ring we are requesting offset of
- *
- * Returns the offset value for ring into the data buffer.
- */
-static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
-{
-	if (ice_ring_uses_build_skb(rx_ring))
-		return ICE_SKB_PAD;
-	else if (ice_is_xdp_ena_vsi(rx_ring->vsi))
-		return XDP_PACKET_HEADROOM;
-
-	return 0;
-}
-
 /**
  * ice_setup_rx_ring - Allocate the Rx descriptors
  * @rx_ring: the Rx ring to set up
@@ -493,7 +477,6 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring)
 
 	rx_ring->next_to_use = 0;
 	rx_ring->next_to_clean = 0;
-	rx_ring->rx_offset = ice_rx_offset(rx_ring);
 
 	if (ice_is_xdp_ena_vsi(rx_ring->vsi))
 		WRITE_ONCE(rx_ring->xdp_prog, rx_ring->vsi->xdp_prog);
-- 
2.26.2

