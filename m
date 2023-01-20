Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274A1675F6E
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 22:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjATVKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 16:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjATVKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 16:10:30 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C833966DC
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 13:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674249029; x=1705785029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xyLVDfBxvxgwG0OzeCvlVfwKUaXYmyTB/FmnC+LhcyI=;
  b=Kz3+FwNhprg7dJ5UUtOKnlr0uJWr/eHlTBDomRYi0Pm+WT02ktywXzXY
   C7Mb5EqLgUrhEca8/h6xmDaj1KOQkXv+Kt/Mg1CFHfR9Nd7DlQvoVB6O6
   TcMCfVi45fz1r6IpNq7FS3DsUaDdbtHdNvcjRqhYtDj2qStqA0VAut8Gs
   OU3fKFXLS8LJJ/W9MxY5IIRzv9HelWyD4i6CRgB3J9Ne6U2UNrfUD13DS
   DLWT7WeDrg9DKDg00ExDp5BJXzv5pdTcVlwgKtzY9Tpc+pARHOM1I31eM
   xz89J/1L3dnKfEoUqS9VCteBglExdeaShz1D+6ZzBjt8DkbS/n6puGlo9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="352949182"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="352949182"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 13:10:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="784667628"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="784667628"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 20 Jan 2023 13:10:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Phani Burra <phani.r.burra@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net 2/3] iavf: Move netdev_update_features() into watchdog task
Date:   Fri, 20 Jan 2023 13:10:35 -0800
Message-Id: <20230120211036.430946-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230120211036.430946-1-anthony.l.nguyen@intel.com>
References: <20230120211036.430946-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@linux.intel.com>

Remove netdev_update_features() from iavf_adminq_task(), as it can cause
deadlocks due to needing rtnl_lock. Instead use the
IAVF_FLAG_SETUP_NETDEV_FEATURES flag to indicate that netdev features need
to be updated in the watchdog task. iavf_set_vlan_offload_features()
and iavf_set_queue_vlan_tag_loc() can be called directly from
iavf_virtchnl_completion().

Suggested-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 27 +++++++------------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  8 ++++++
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 0aa32c164ecf..de7112ae8416 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2692,6 +2692,15 @@ static void iavf_watchdog_task(struct work_struct *work)
 		goto restart_watchdog;
 	}
 
+	if ((adapter->flags & IAVF_FLAG_SETUP_NETDEV_FEATURES) &&
+	    adapter->netdev_registered &&
+	    !test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section) &&
+	    rtnl_trylock()) {
+		netdev_update_features(adapter->netdev);
+		rtnl_unlock();
+		adapter->flags &= ~IAVF_FLAG_SETUP_NETDEV_FEATURES;
+	}
+
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		iavf_change_state(adapter, __IAVF_COMM_FAILED);
 
@@ -3233,24 +3242,6 @@ static void iavf_adminq_task(struct work_struct *work)
 	} while (pending);
 	mutex_unlock(&adapter->crit_lock);
 
-	if ((adapter->flags & IAVF_FLAG_SETUP_NETDEV_FEATURES)) {
-		if (adapter->netdev_registered ||
-		    !test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section)) {
-			struct net_device *netdev = adapter->netdev;
-
-			rtnl_lock();
-			netdev_update_features(netdev);
-			rtnl_unlock();
-			/* Request VLAN offload settings */
-			if (VLAN_V2_ALLOWED(adapter))
-				iavf_set_vlan_offload_features
-					(adapter, 0, netdev->features);
-
-			iavf_set_queue_vlan_tag_loc(adapter);
-		}
-
-		adapter->flags &= ~IAVF_FLAG_SETUP_NETDEV_FEATURES;
-	}
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
 	    adapter->state == __IAVF_RESETTING)
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 0752fd67c96e..365ca0c710c4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2226,6 +2226,14 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		iavf_process_config(adapter);
 		adapter->flags |= IAVF_FLAG_SETUP_NETDEV_FEATURES;
+
+		/* Request VLAN offload settings */
+		if (VLAN_V2_ALLOWED(adapter))
+			iavf_set_vlan_offload_features(adapter, 0,
+						       netdev->features);
+
+		iavf_set_queue_vlan_tag_loc(adapter);
+
 		was_mac_changed = !ether_addr_equal(netdev->dev_addr,
 						    adapter->hw.mac.addr);
 
-- 
2.38.1

