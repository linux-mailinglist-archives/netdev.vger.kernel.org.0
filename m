Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC43D4B13CD
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245022AbiBJRFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:05:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245028AbiBJRFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:05:39 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E333EC18
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644512739; x=1676048739;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qtKL4C54tm/+7OjDc8Cde0hOBUCdl3mKTpD/6SIZFuw=;
  b=DMWTtyuDQpjUV2rormWctTCHckzck8vKutg+Zsc4Tg6sPzkQEXdbtehf
   HiHLEnMh12jx/l0owvS1AIINkwxYaawnoVjcYssM4ToZqBxNzHtGgYzp4
   QqKffz2tCYtC4ybvcWx5wqxTGUO7EvYCcZCIQ3eDq9q6VbeNJZea3xLfv
   PIKBFb4wxV1Sz2eJ/iCdpu7OyvpexB/AO++EJIxgNHCvtaIVsih3xbk+b
   09Qf8nJn0vx1B4mItiIYzxBTnGDGZL8hkZxzOHrqRyicDZWwUge9Y1yCF
   6S7JjNA56oDPsOF+BShT4wdKkoLloXP2Zi3qcDzTYG/gZW79BmJenKmzi
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="274091952"
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="274091952"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 09:05:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="622742942"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Feb 2022 09:05:21 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Jonathan Toppins <jtoppins@redhat.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net 3/4] ice: Fix KASAN error in LAG NETDEV_UNREGISTER handler
Date:   Thu, 10 Feb 2022 09:05:14 -0800
Message-Id: <20220210170515.2609656-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
References: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Currently, the same handler is called for both a NETDEV_BONDING_INFO
LAG unlink notification as for a NETDEV_UNREGISTER call.  This is
causing a problem though, since the netdev_notifier_info passed has
a different structure depending on which event is passed.  The problem
manifests as a call trace from a BUG: KASAN stack-out-of-bounds error.

Fix this by creating a handler specific to NETDEV_UNREGISTER that only
is passed valid elements in the netdev_notifier_info struct for the
NETDEV_UNREGISTER event.

Also included is the removal of an unbalanced dev_put on the peer_netdev
and related braces.

Fixes: 6a8b357278f5 ("ice: Respond to a NETDEV_UNREGISTER event for LAG")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Acked-by: Jonathan Toppins <jtoppins@redhat.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 34 +++++++++++++++++++-----
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index e375ac849aec..4f954db01b92 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -204,17 +204,39 @@ ice_lag_unlink(struct ice_lag *lag,
 		lag->upper_netdev = NULL;
 	}
 
-	if (lag->peer_netdev) {
-		dev_put(lag->peer_netdev);
-		lag->peer_netdev = NULL;
-	}
-
+	lag->peer_netdev = NULL;
 	ice_set_sriov_cap(pf);
 	ice_set_rdma_cap(pf);
 	lag->bonded = false;
 	lag->role = ICE_LAG_NONE;
 }
 
+/**
+ * ice_lag_unregister - handle netdev unregister events
+ * @lag: LAG info struct
+ * @netdev: netdev reporting the event
+ */
+static void ice_lag_unregister(struct ice_lag *lag, struct net_device *netdev)
+{
+	struct ice_pf *pf = lag->pf;
+
+	/* check to see if this event is for this netdev
+	 * check that we are in an aggregate
+	 */
+	if (netdev != lag->netdev || !lag->bonded)
+		return;
+
+	if (lag->upper_netdev) {
+		dev_put(lag->upper_netdev);
+		lag->upper_netdev = NULL;
+		ice_set_sriov_cap(pf);
+		ice_set_rdma_cap(pf);
+	}
+	/* perform some cleanup in case we come back */
+	lag->bonded = false;
+	lag->role = ICE_LAG_NONE;
+}
+
 /**
  * ice_lag_changeupper_event - handle LAG changeupper event
  * @lag: LAG info struct
@@ -307,7 +329,7 @@ ice_lag_event_handler(struct notifier_block *notif_blk, unsigned long event,
 		ice_lag_info_event(lag, ptr);
 		break;
 	case NETDEV_UNREGISTER:
-		ice_lag_unlink(lag, ptr);
+		ice_lag_unregister(lag, netdev);
 		break;
 	default:
 		break;
-- 
2.31.1

