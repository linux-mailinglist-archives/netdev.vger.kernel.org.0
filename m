Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB046339557
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhCLRrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:47:06 -0500
Received: from mga06.intel.com ([134.134.136.31]:9116 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232233AbhCLRqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:46:38 -0500
IronPort-SDR: FQxB7mO4UcvBTA4oYkvJASVDVgwCS9QVWWHGAd9owJCqY/mZ/pilHH2mFXRmL5Exh8QovZWNoa
 /Yd4olSnSJsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="250232655"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="250232655"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 09:46:38 -0800
IronPort-SDR: /HBHtw9GWVepyl3BgYEwkiehjB998RG+8KWFVFAqwYTIRkEUTmvHFwjdcnqdSejC4RCexw8iKi
 BSquv+qYmG7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="589615848"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2021 09:46:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 2/5] i40e: move headroom initialization to i40e_configure_rx_ring
Date:   Fri, 12 Mar 2021 09:47:52 -0800
Message-Id: <20210312174755.2103336-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
References: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

i40e_rx_offset(), that is supposed to initialize the Rx buffer headroom,
relies on I40E_RXR_FLAGS_BUILD_SKB_ENABLED flag.

Currently, the callsite of mentioned function is placed incorrectly
within i40e_setup_rx_descriptors() where Rx ring's build skb flag is not
set yet. This causes the XDP_REDIRECT to be partially broken due to
inability to create xdp_frame in the headroom space, as the headroom is
0.

For the record, below is the call graph:

i40e_vsi_open
 i40e_vsi_setup_rx_resources
  i40e_setup_rx_descriptors
   i40e_rx_offset() <-- sets offset to 0 as build_skb flag is set below

 i40e_vsi_configure_rx
  i40e_configure_rx_ring
   set_ring_build_skb_enabled(ring) <-- set build_skb flag

Fix this by moving i40e_rx_offset() to i40e_configure_rx_ring() after
the flag setting.

Fixes: f7bb0d71d658 ("i40e: store the result of i40e_rx_offset() onto i40e_ring")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 13 +++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 ------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 353deae139f9..17f3b800640e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3258,6 +3258,17 @@ static int i40e_configure_tx_ring(struct i40e_ring *ring)
 	return 0;
 }
 
+/**
+ * i40e_rx_offset - Return expected offset into page to access data
+ * @rx_ring: Ring we are requesting offset of
+ *
+ * Returns the offset value for ring into the data buffer.
+ */
+static unsigned int i40e_rx_offset(struct i40e_ring *rx_ring)
+{
+	return ring_uses_build_skb(rx_ring) ? I40E_SKB_PAD : 0;
+}
+
 /**
  * i40e_configure_rx_ring - Configure a receive ring context
  * @ring: The Rx ring to configure
@@ -3369,6 +3380,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	else
 		set_ring_build_skb_enabled(ring);
 
+	ring->rx_offset = i40e_rx_offset(ring);
+
 	/* cache tail for quicker writes, and clear the reg before use */
 	ring->tail = hw->hw_addr + I40E_QRX_TAIL(pf_q);
 	writel(0, ring->tail);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 627794b31e33..5747a99122fb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1569,17 +1569,6 @@ void i40e_free_rx_resources(struct i40e_ring *rx_ring)
 	}
 }
 
-/**
- * i40e_rx_offset - Return expected offset into page to access data
- * @rx_ring: Ring we are requesting offset of
- *
- * Returns the offset value for ring into the data buffer.
- */
-static unsigned int i40e_rx_offset(struct i40e_ring *rx_ring)
-{
-	return ring_uses_build_skb(rx_ring) ? I40E_SKB_PAD : 0;
-}
-
 /**
  * i40e_setup_rx_descriptors - Allocate Rx descriptors
  * @rx_ring: Rx descriptor ring (for a specific queue) to setup
@@ -1608,7 +1597,6 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 	rx_ring->next_to_alloc = 0;
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
-	rx_ring->rx_offset = i40e_rx_offset(rx_ring);
 
 	/* XDP RX-queue info only needed for RX rings exposed to XDP */
 	if (rx_ring->vsi->type == I40E_VSI_MAIN) {
-- 
2.26.2

