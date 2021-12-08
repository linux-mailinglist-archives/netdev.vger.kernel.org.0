Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E72446DDC1
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238913AbhLHVoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:44:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:15036 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238697AbhLHVof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 16:44:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="237757864"
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="237757864"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 13:12:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="606528309"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2021 13:12:50 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        stephen@networkplumber.org, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net v2 7/7] ice: safer stats processing
Date:   Wed,  8 Dec 2021 13:11:44 -0800
Message-Id: <20211208211144.2629867-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211208211144.2629867-1-anthony.l.nguyen@intel.com>
References: <20211208211144.2629867-1-anthony.l.nguyen@intel.com>
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
 drivers/net/ethernet/intel/ice/ice_main.c | 29 ++++++++++++++---------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c6d6ce52e2ca..73c61cdb036f 100644
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
@@ -5961,15 +5962,13 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, struct ice_tx_ring **rings,
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
@@ -5981,7 +5980,8 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 	rcu_read_lock();
 
 	/* update Tx rings counters */
-	ice_update_vsi_tx_ring_stats(vsi, vsi->tx_rings, vsi->num_txq);
+	ice_update_vsi_tx_ring_stats(vsi, vsi_stats, vsi->tx_rings,
+				     vsi->num_txq);
 
 	/* update Rx rings counters */
 	ice_for_each_rxq(vsi, i) {
@@ -5996,10 +5996,17 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 
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
-- 
2.31.1

