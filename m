Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB2546C770
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242184AbhLGWaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:30:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:41415 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242177AbhLGWaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 17:30:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237508439"
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="237508439"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 14:26:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="605889097"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Dec 2021 14:26:47 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        stephen@networkplumber.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 7/7] ice: safer stats processing
Date:   Tue,  7 Dec 2021 14:25:44 -0800
Message-Id: <20211207222544.977843-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
References: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver was zeroing live stats that could be fetched by
ndo_get_stats64 at any time. This could result in inconsistent
statistics, and the telltale sign was when reading stats frequently from
/proc/net/dev, the stats would go backwards.

Fix by collecting stats into a local, and delaying when we write to the
structure so it's not incremental.

Fixes: fcea6f3da546 ("ice: Add stats and ethtool support")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 31 +++++++++++++++--------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c6d6ce52e2ca..610a0d20af9f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5930,14 +5930,15 @@ ice_fetch_u64_stats_per_ring(struct u64_stats_sync *syncp, struct ice_q_stats st
 /**
  * ice_update_vsi_tx_ring_stats - Update VSI Tx ring stats counters
  * @vsi: the VSI to be updated
+ * @vsi_stats: the stats struct to be updated
  * @rings: rings to work on
  * @count: number of rings
  */
 static void
-ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, struct ice_tx_ring **rings,
-			     u16 count)
+ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi,
+			     struct rtnl_link_stats64 *vsi_stats,
+			     struct ice_tx_ring **rings, u16 count)
 {
-	struct rtnl_link_stats64 *vsi_stats = &vsi->net_stats;
 	u16 i;
 
 	for (i = 0; i < count; i++) {
@@ -5949,6 +5950,7 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, struct ice_tx_ring **rings,
 			ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);
 		vsi_stats->tx_packets += pkts;
 		vsi_stats->tx_bytes += bytes;
+
 		vsi->tx_restart += ring->tx_stats.restart_q;
 		vsi->tx_busy += ring->tx_stats.tx_busy;
 		vsi->tx_linearize += ring->tx_stats.tx_linearize;
@@ -5961,15 +5963,13 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, struct ice_tx_ring **rings,
  */
 static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 {
-	struct rtnl_link_stats64 *vsi_stats = &vsi->net_stats;
+	struct rtnl_link_stats64 *vsi_stats;
 	u64 pkts, bytes;
 	int i;
 
-	/* reset netdev stats */
-	vsi_stats->tx_packets = 0;
-	vsi_stats->tx_bytes = 0;
-	vsi_stats->rx_packets = 0;
-	vsi_stats->rx_bytes = 0;
+	vsi_stats = kzalloc(sizeof(*vsi_stats), GFP_ATOMIC);
+	if (!vsi_stats)
+		return;
 
 	/* reset non-netdev (extended) stats */
 	vsi->tx_restart = 0;
@@ -5981,7 +5981,8 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 	rcu_read_lock();
 
 	/* update Tx rings counters */
-	ice_update_vsi_tx_ring_stats(vsi, vsi->tx_rings, vsi->num_txq);
+	ice_update_vsi_tx_ring_stats(vsi, vsi_stats, vsi->tx_rings,
+				     vsi->num_txq);
 
 	/* update Rx rings counters */
 	ice_for_each_rxq(vsi, i) {
@@ -5996,10 +5997,17 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 
 	/* update XDP Tx rings counters */
 	if (ice_is_xdp_ena_vsi(vsi))
-		ice_update_vsi_tx_ring_stats(vsi, vsi->xdp_rings,
+		ice_update_vsi_tx_ring_stats(vsi, vsi_stats, vsi->xdp_rings,
 					     vsi->num_xdp_txq);
 
 	rcu_read_unlock();
+
+	vsi->net_stats.tx_packets = vsi_stats->tx_packets;
+	vsi->net_stats.tx_bytes = vsi_stats->tx_bytes;
+	vsi->net_stats.rx_packets = vsi_stats->rx_packets;
+	vsi->net_stats.rx_bytes = vsi_stats->rx_bytes;
+
+	kfree(vsi_stats);
 }
 
 /**
@@ -6219,6 +6227,7 @@ void ice_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 	 */
 	if (!test_bit(ICE_VSI_DOWN, vsi->state))
 		ice_update_vsi_ring_stats(vsi);
+
 	stats->tx_packets = vsi_stats->tx_packets;
 	stats->tx_bytes = vsi_stats->tx_bytes;
 	stats->rx_packets = vsi_stats->rx_packets;
-- 
2.31.1

