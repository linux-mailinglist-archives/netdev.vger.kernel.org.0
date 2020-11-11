Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9246F2AE4D5
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732313AbgKKAUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:20:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:17132 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731854AbgKKAU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 19:20:27 -0500
IronPort-SDR: yIWPX+SbvwZm9lzefVJcJrQuYeVtqICkAMJQJNCB8nLkjZFrXrfYCdm3inf9ygIxvNGYxAl33t
 m4XBy4YNxCYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="149921009"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="149921009"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 16:20:27 -0800
IronPort-SDR: NCG49N+hYuAyK3hKPTPfL6eP51n0UblQWndaNP6ocd3R/ULIGAsMjaYyXG9Kw1vPSHIeP9Cmbt
 egBmR2D5SyWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="366049063"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 10 Nov 2020 16:20:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net 3/4] igc: Fix returning wrong statistics
Date:   Tue, 10 Nov 2020 16:19:54 -0800
Message-Id: <20201111001955.533210-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
References: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

'igc_update_stats()' was not updating 'netdev->stats', so the returned
statistics, for example, requested by:

$ ip -s link show dev enp3s0

were not being updated and were always zero.

Fix by returning a set of statistics that are actually being
updated (adapter->stats64).

Fixes: c9a11c23ceb6 ("igc: Add netdev")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9112dff075cf..b673ac1199bb 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3891,21 +3891,23 @@ static int igc_change_mtu(struct net_device *netdev, int new_mtu)
 }
 
 /**
- * igc_get_stats - Get System Network Statistics
+ * igc_get_stats64 - Get System Network Statistics
  * @netdev: network interface device structure
+ * @stats: rtnl_link_stats64 pointer
  *
  * Returns the address of the device statistics structure.
  * The statistics are updated here and also from the timer callback.
  */
-static struct net_device_stats *igc_get_stats(struct net_device *netdev)
+static void igc_get_stats64(struct net_device *netdev,
+			    struct rtnl_link_stats64 *stats)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
+	spin_lock(&adapter->stats64_lock);
 	if (!test_bit(__IGC_RESETTING, &adapter->state))
 		igc_update_stats(adapter);
-
-	/* only return the current stats */
-	return &netdev->stats;
+	memcpy(stats, &adapter->stats64, sizeof(*stats));
+	spin_unlock(&adapter->stats64_lock);
 }
 
 static netdev_features_t igc_fix_features(struct net_device *netdev,
@@ -4855,7 +4857,7 @@ static const struct net_device_ops igc_netdev_ops = {
 	.ndo_set_rx_mode	= igc_set_rx_mode,
 	.ndo_set_mac_address	= igc_set_mac,
 	.ndo_change_mtu		= igc_change_mtu,
-	.ndo_get_stats		= igc_get_stats,
+	.ndo_get_stats64	= igc_get_stats64,
 	.ndo_fix_features	= igc_fix_features,
 	.ndo_set_features	= igc_set_features,
 	.ndo_features_check	= igc_features_check,
-- 
2.26.2

