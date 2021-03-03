Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3C832C469
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354913AbhCDANl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:22658 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377744AbhCCPvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 10:51:03 -0500
IronPort-SDR: zmopqqqmECsoWwMOBulXRhZtu+hpW0T4G9EWKDRpVTWu5JB4NJyimSrpCiJ519eNXlCECeWXld
 iOX6ktQkikpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="206909542"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="206909542"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 07:49:39 -0800
IronPort-SDR: yJPyFw/QMQX7wgDc3zeaJ69wXLpikCfDay3TwKl+Z0lFystwk16Zjco+CoRBHzsB8QiS0WCqwV
 cxx6aQdpj1XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="518322016"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 03 Mar 2021 07:49:36 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, brouer@redhat.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 2/3] ice: move headroom initialization to ice_setup_rx_ctx
Date:   Wed,  3 Mar 2021 16:39:27 +0100
Message-Id: <20210303153928.11764-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210303153928.11764-1-maciej.fijalkowski@intel.com>
References: <20210303153928.11764-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/intel/ice/ice_base.c | 18 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 17 -----------------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 3124a3bf519a..95f674bd52c3 100644
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
2.20.1

