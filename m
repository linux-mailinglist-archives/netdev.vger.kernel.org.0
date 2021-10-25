Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2E743A557
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhJYVAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 17:00:32 -0400
Received: from mga12.intel.com ([192.55.52.136]:2993 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232690AbhJYVAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 17:00:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10148"; a="209846550"
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="209846550"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 13:58:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,181,1631602800"; 
   d="scan'208";a="446799557"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 25 Oct 2021 13:58:03 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 1/2] ice: Respond to a NETDEV_UNREGISTER event for LAG
Date:   Mon, 25 Oct 2021 13:56:21 -0700
Message-Id: <20211025205622.1967785-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205622.1967785-1-anthony.l.nguyen@intel.com>
References: <20211025205622.1967785-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

When the PF is a member of a link aggregate, and the driver
is removed, the process will hang unless we respond to the
NETDEV_UNREGISTER event that is sent to the event_handler
for LAG.

Add a case statement for the ice_lag_event_handler to unlink
the PF from the link aggregate.

Also remove code that was incorrectly applying a dev_hold to
peer_netdevs that were associated with the ice driver.

Fixes: df006dd4b1dc ("ice: Add initial support framework for LAG")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 37c18c66b5c7..e375ac849aec 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -100,9 +100,9 @@ static void ice_display_lag_info(struct ice_lag *lag)
  */
 static void ice_lag_info_event(struct ice_lag *lag, void *ptr)
 {
-	struct net_device *event_netdev, *netdev_tmp;
 	struct netdev_notifier_bonding_info *info;
 	struct netdev_bonding_info *bonding_info;
+	struct net_device *event_netdev;
 	const char *lag_netdev_name;
 
 	event_netdev = netdev_notifier_info_to_dev(ptr);
@@ -123,19 +123,6 @@ static void ice_lag_info_event(struct ice_lag *lag, void *ptr)
 		goto lag_out;
 	}
 
-	rcu_read_lock();
-	for_each_netdev_in_bond_rcu(lag->upper_netdev, netdev_tmp) {
-		if (!netif_is_ice(netdev_tmp))
-			continue;
-
-		if (netdev_tmp && netdev_tmp != lag->netdev &&
-		    lag->peer_netdev != netdev_tmp) {
-			dev_hold(netdev_tmp);
-			lag->peer_netdev = netdev_tmp;
-		}
-	}
-	rcu_read_unlock();
-
 	if (bonding_info->slave.state)
 		ice_lag_set_backup(lag);
 	else
@@ -319,6 +306,9 @@ ice_lag_event_handler(struct notifier_block *notif_blk, unsigned long event,
 	case NETDEV_BONDING_INFO:
 		ice_lag_info_event(lag, ptr);
 		break;
+	case NETDEV_UNREGISTER:
+		ice_lag_unlink(lag, ptr);
+		break;
 	default:
 		break;
 	}
-- 
2.31.1

