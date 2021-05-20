Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8C038B5D6
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbhETSQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:16:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:9105 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233437AbhETSQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 14:16:53 -0400
IronPort-SDR: I3N+srkWZbf3GWNY5BkhVn+OThUa0BeyFhWxf5lucAWYbl6JRWhPUM9pm1aFmnj0x4rTUG2498
 /yxbrp1g2W3A==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="181579460"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="181579460"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 11:15:32 -0700
IronPort-SDR: otAfm7JImKXRjupzL0L6KJz0aQ+4NSpPda7cBixNnKcoybcjTVRScuef4TnE32HAdRntDryUhK
 vVjQ3mRvwZXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440670749"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 20 May 2021 11:15:32 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next v2 5/9] igc: Introduce TX/RX stats helpers
Date:   Thu, 20 May 2021 11:17:40 -0700
Message-Id: <20210520181744.2217191-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
References: <20210520181744.2217191-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

In preparation for AF_XDP zero-copy support, encapsulate the code that
updates the driver RX stats in its own local helper so it can be reused
in the zero-copy path. Likewise, encapsulate TX stats code as well.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Signed-off-by: Vedang Patel <vedang.patel@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 43 ++++++++++++++++-------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 90d8e4355f43..5a262bab9116 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2111,6 +2111,20 @@ static void igc_finalize_xdp(struct igc_adapter *adapter, int status)
 		xdp_do_flush();
 }
 
+static void igc_update_rx_stats(struct igc_q_vector *q_vector,
+				unsigned int packets, unsigned int bytes)
+{
+	struct igc_ring *ring = q_vector->rx.ring;
+
+	u64_stats_update_begin(&ring->rx_syncp);
+	ring->rx_stats.packets += packets;
+	ring->rx_stats.bytes += bytes;
+	u64_stats_update_end(&ring->rx_syncp);
+
+	q_vector->rx.total_packets += packets;
+	q_vector->rx.total_bytes += bytes;
+}
+
 static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 {
 	unsigned int total_bytes = 0, total_packets = 0;
@@ -2231,12 +2245,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 	/* place incomplete frames back on ring for completion */
 	rx_ring->skb = skb;
 
-	u64_stats_update_begin(&rx_ring->rx_syncp);
-	rx_ring->rx_stats.packets += total_packets;
-	rx_ring->rx_stats.bytes += total_bytes;
-	u64_stats_update_end(&rx_ring->rx_syncp);
-	q_vector->rx.total_packets += total_packets;
-	q_vector->rx.total_bytes += total_bytes;
+	igc_update_rx_stats(q_vector, total_packets, total_bytes);
 
 	if (cleaned_count)
 		igc_alloc_rx_buffers(rx_ring, cleaned_count);
@@ -2244,6 +2253,20 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 	return total_packets;
 }
 
+static void igc_update_tx_stats(struct igc_q_vector *q_vector,
+				unsigned int packets, unsigned int bytes)
+{
+	struct igc_ring *ring = q_vector->tx.ring;
+
+	u64_stats_update_begin(&ring->tx_syncp);
+	ring->tx_stats.bytes += bytes;
+	ring->tx_stats.packets += packets;
+	u64_stats_update_end(&ring->tx_syncp);
+
+	q_vector->tx.total_bytes += bytes;
+	q_vector->tx.total_packets += packets;
+}
+
 /**
  * igc_clean_tx_irq - Reclaim resources after transmit completes
  * @q_vector: pointer to q_vector containing needed info
@@ -2346,12 +2369,8 @@ static bool igc_clean_tx_irq(struct igc_q_vector *q_vector, int napi_budget)
 
 	i += tx_ring->count;
 	tx_ring->next_to_clean = i;
-	u64_stats_update_begin(&tx_ring->tx_syncp);
-	tx_ring->tx_stats.bytes += total_bytes;
-	tx_ring->tx_stats.packets += total_packets;
-	u64_stats_update_end(&tx_ring->tx_syncp);
-	q_vector->tx.total_bytes += total_bytes;
-	q_vector->tx.total_packets += total_packets;
+
+	igc_update_tx_stats(q_vector, total_packets, total_bytes);
 
 	if (test_bit(IGC_RING_FLAG_TX_DETECT_HANG, &tx_ring->flags)) {
 		struct igc_hw *hw = &adapter->hw;
-- 
2.26.2

