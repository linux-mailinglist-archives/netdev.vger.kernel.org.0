Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719B0476138
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344071AbhLOSzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:55:43 -0500
Received: from mga18.intel.com ([134.134.136.126]:24022 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344051AbhLOSzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:55:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639594533; x=1671130533;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ESp1jXs9yJkzRaHu30u75ck907nUT/ZvGIndNhsW15Q=;
  b=jhNAAAH3QlrP4DP0E2ZHrfgXxVDgCKzy+IoIlwP8BxJ/D8rv67h5wPH6
   H8ykbK6vNhbnXOIT6kFs7eABL9kxE/ItTJ2csJ8CZsglFV/9S6F4HjiNa
   qYOjz8+pUFGSMkTTZSDB2WStW4pe/k+HudSZjHp/0JjBRmyH1Ehnd9QK+
   BWevsyhaipAljQ3iAwmcSSS7XFESKSplySqPQXy8nSnWMIyY5P0ZqrB8J
   9i2lxIhVNCqZVXAelAXjQhVh2SRr5hsuDbnnYMPgV3EQXttSj/CHRr9io
   jaB28bLdUTXv2Cx5xZCizQkS9Cg5rX9yLVYRncLF7sdCBACYKptXfVeBO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226169612"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="226169612"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 10:54:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465729949"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 10:54:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 6/9] ice: update to newer kernel API
Date:   Wed, 15 Dec 2021 10:53:52 -0800
Message-Id: <20211215185355.3249738-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
References: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Use the netif_tx_* API from netdevice.h which has simpler parameters.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Testing Hints: test transmit performance and queue
start/stop tests which increment tx_restart counter.

 drivers/net/ethernet/intel/ice/ice_txrx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index bc3ba19dc88f..12a2edd13877 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -304,8 +304,10 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 
 	ice_update_tx_ring_stats(tx_ring, total_pkts, total_bytes);
 
-	netdev_tx_completed_queue(txring_txq(tx_ring), total_pkts,
-				  total_bytes);
+	if (ice_ring_is_xdp(tx_ring))
+		return !!budget;
+
+	netdev_tx_completed_queue(txring_txq(tx_ring), total_pkts, total_bytes);
 
 #define TX_WAKE_THRESHOLD ((s16)(DESC_NEEDED * 2))
 	if (unlikely(total_pkts && netif_carrier_ok(tx_ring->netdev) &&
@@ -314,11 +316,9 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 		 * sees the new next_to_clean.
 		 */
 		smp_mb();
-		if (__netif_subqueue_stopped(tx_ring->netdev,
-					     tx_ring->q_index) &&
+		if (netif_tx_queue_stopped(txring_txq(tx_ring)) &&
 		    !test_bit(ICE_VSI_DOWN, vsi->state)) {
-			netif_wake_subqueue(tx_ring->netdev,
-					    tx_ring->q_index);
+			netif_tx_wake_queue(txring_txq(tx_ring));
 			++tx_ring->tx_stats.restart_q;
 		}
 	}
@@ -1517,7 +1517,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
  */
 static int __ice_maybe_stop_tx(struct ice_tx_ring *tx_ring, unsigned int size)
 {
-	netif_stop_subqueue(tx_ring->netdev, tx_ring->q_index);
+	netif_tx_stop_queue(txring_txq(tx_ring));
 	/* Memory barrier before checking head and tail */
 	smp_mb();
 
@@ -1525,8 +1525,8 @@ static int __ice_maybe_stop_tx(struct ice_tx_ring *tx_ring, unsigned int size)
 	if (likely(ICE_DESC_UNUSED(tx_ring) < size))
 		return -EBUSY;
 
-	/* A reprieve! - use start_subqueue because it doesn't call schedule */
-	netif_start_subqueue(tx_ring->netdev, tx_ring->q_index);
+	/* A reprieve! - use start_queue because it doesn't call schedule */
+	netif_tx_start_queue(txring_txq(tx_ring));
 	++tx_ring->tx_stats.restart_q;
 	return 0;
 }
-- 
2.31.1

