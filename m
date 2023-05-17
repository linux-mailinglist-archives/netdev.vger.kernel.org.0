Return-Path: <netdev+bounces-3410-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 239A3706EEE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A242528128B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4711131EF2;
	Wed, 17 May 2023 16:59:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D4C442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:59:30 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9670183C4
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684342766; x=1715878766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zvYVDhZJTQ1CaaP4ZQeJqLAfQ3FFRaWzZQvrIX/k/r0=;
  b=PM8doNskoYcjLmyp2XzlRoRp/PRGy3Wl6yePT0HCUS2lF5l39Bc/0/8H
   UGNPJvYG96r9vd/27OEYZTASqoPYUvQE43+eKxMOg1BB/QAx3ByuMYpls
   1qf/5kGamuEwVRy0HdHQ4opHAI/9rkUEW6y/Zvmgp9Wp+vJqVBeFyqSro
   BW6qjU4rfuuvtZ8/MDUmpFXOH8HuzMM5Po8Ipb38GHC3lyKQ2+qXgyHm1
   dAUZnoVpHe0N5YmazO+jsSwJwMfKPmIGAru6ALt9bz4kXgrQ6OMb09Cgm
   JgudRqTmdaPWCmcYgEZncJ8xGWBmngj85o7qRTw2gafiYgfSMnAQnxGWV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="380011562"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="380011562"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 09:59:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="704876781"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="704876781"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 17 May 2023 09:59:16 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Dave Ertman <david.m.ertman@intel.com>,
	anthony.l.nguyen@intel.com,
	mschmidt@redhat.com,
	ihuguet@redhat.com,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next 4/5] ice: Remove LAG+SRIOV mutual exclusion
Date: Wed, 17 May 2023 09:55:29 -0700
Message-Id: <20230517165530.3179965-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
References: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Dave Ertman <david.m.ertman@intel.com>

There was a change previously to stop SR-IOV and LAG from existing on the
same interface.  This was to prevent the violation of LACP (Link
Aggregation Control Protocol).  The method to achieve this was to add a
no-op Rx handler onto the netdev when SR-IOV VFs were present, thus
blocking bonding, bridging, etc from claiming the interface by adding
its own Rx handler.  Also, when an interface was added into a aggregate,
then the SR-IOV capability was set to false.

There are some users that have in house solutions using both SR-IOV and
bridging/bonding that this method interferes with (e.g. creating duplicate
VFs on the bonded interfaces and failing between them when the interface
fails over).

It makes more sense to provide the most functionality
possible, the restriction on co-existence of these features will be
removed.  No additional functionality is currently being provided beyond
what existed before the co-existence restriction was put into place.  It is
up to the end user to not implement a solution that would interfere with
existing network protocols.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../device_drivers/ethernet/intel/ice.rst     | 18 -------
 drivers/net/ethernet/intel/ice/ice.h          | 19 -------
 drivers/net/ethernet/intel/ice/ice_lag.c      | 12 -----
 drivers/net/ethernet/intel/ice/ice_lag.h      | 54 -------------------
 drivers/net/ethernet/intel/ice/ice_lib.c      |  2 -
 drivers/net/ethernet/intel/ice/ice_sriov.c    |  4 --
 6 files changed, 109 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/ice.rst b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
index 69695e5511f4..e4d065c55ea8 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/ice.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
@@ -84,24 +84,6 @@ Once the VM shuts down, or otherwise releases the VF, the command will
 complete.
 
 
-Important notes for SR-IOV and Link Aggregation
------------------------------------------------
-Link Aggregation is mutually exclusive with SR-IOV.
-
-- If Link Aggregation is active, SR-IOV VFs cannot be created on the PF.
-- If SR-IOV is active, you cannot set up Link Aggregation on the interface.
-
-Bridging and MACVLAN are also affected by this. If you wish to use bridging or
-MACVLAN with SR-IOV, you must set up bridging or MACVLAN before enabling
-SR-IOV. If you are using bridging or MACVLAN in conjunction with SR-IOV, and
-you want to remove the interface from the bridge or MACVLAN, you must follow
-these steps:
-
-1. Destroy SR-IOV VFs if they exist
-2. Remove the interface from the bridge or MACVLAN
-3. Recreate SRIOV VFs as needed
-
-
 Additional Features and Configurations
 ======================================
 
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 8b016511561f..b4bca1d964a9 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -814,25 +814,6 @@ static inline bool ice_is_switchdev_running(struct ice_pf *pf)
 	return pf->switchdev.is_running;
 }
 
-/**
- * ice_set_sriov_cap - enable SRIOV in PF flags
- * @pf: PF struct
- */
-static inline void ice_set_sriov_cap(struct ice_pf *pf)
-{
-	if (pf->hw.func_caps.common_cap.sr_iov_1_1)
-		set_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
-}
-
-/**
- * ice_clear_sriov_cap - disable SRIOV in PF flags
- * @pf: PF struct
- */
-static inline void ice_clear_sriov_cap(struct ice_pf *pf)
-{
-	clear_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
-}
-
 #define ICE_FD_STAT_CTR_BLOCK_COUNT	256
 #define ICE_FD_STAT_PF_IDX(base_idx) \
 			((base_idx) * ICE_FD_STAT_CTR_BLOCK_COUNT)
diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index ee5b36941ba3..5a7753bda324 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -6,15 +6,6 @@
 #include "ice.h"
 #include "ice_lag.h"
 
-/**
- * ice_lag_nop_handler - no-op Rx handler to disable LAG
- * @pskb: pointer to skb pointer
- */
-rx_handler_result_t ice_lag_nop_handler(struct sk_buff __always_unused **pskb)
-{
-	return RX_HANDLER_PASS;
-}
-
 /**
  * ice_lag_set_primary - set PF LAG state as Primary
  * @lag: LAG info struct
@@ -158,7 +149,6 @@ ice_lag_link(struct ice_lag *lag, struct netdev_notifier_changeupper_info *info)
 		lag->upper_netdev = upper;
 	}
 
-	ice_clear_sriov_cap(pf);
 	ice_clear_rdma_cap(pf);
 
 	lag->bonded = true;
@@ -205,7 +195,6 @@ ice_lag_unlink(struct ice_lag *lag,
 	}
 
 	lag->peer_netdev = NULL;
-	ice_set_sriov_cap(pf);
 	ice_set_rdma_cap(pf);
 	lag->bonded = false;
 	lag->role = ICE_LAG_NONE;
@@ -229,7 +218,6 @@ static void ice_lag_unregister(struct ice_lag *lag, struct net_device *netdev)
 	if (lag->upper_netdev) {
 		dev_put(lag->upper_netdev);
 		lag->upper_netdev = NULL;
-		ice_set_sriov_cap(pf);
 		ice_set_rdma_cap(pf);
 	}
 	/* perform some cleanup in case we come back */
diff --git a/drivers/net/ethernet/intel/ice/ice_lag.h b/drivers/net/ethernet/intel/ice/ice_lag.h
index 51b5cf467ce2..2c373676c42f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.h
+++ b/drivers/net/ethernet/intel/ice/ice_lag.h
@@ -25,63 +25,9 @@ struct ice_lag {
 	struct notifier_block notif_block;
 	u8 bonded:1; /* currently bonded */
 	u8 primary:1; /* this is primary */
-	u8 handler:1; /* did we register a rx_netdev_handler */
-	/* each thing blocking bonding will increment this value by one.
-	 * If this value is zero, then bonding is allowed.
-	 */
-	u16 dis_lag;
 	u8 role;
 };
 
 int ice_init_lag(struct ice_pf *pf);
 void ice_deinit_lag(struct ice_pf *pf);
-rx_handler_result_t ice_lag_nop_handler(struct sk_buff **pskb);
-
-/**
- * ice_disable_lag - increment LAG disable count
- * @lag: LAG struct
- */
-static inline void ice_disable_lag(struct ice_lag *lag)
-{
-	/* If LAG this PF is not already disabled, disable it */
-	rtnl_lock();
-	if (!netdev_is_rx_handler_busy(lag->netdev)) {
-		if (!netdev_rx_handler_register(lag->netdev,
-						ice_lag_nop_handler,
-						NULL))
-			lag->handler = true;
-	}
-	rtnl_unlock();
-	lag->dis_lag++;
-}
-
-/**
- * ice_enable_lag - decrement disable count for a PF
- * @lag: LAG struct
- *
- * Decrement the disable counter for a port, and if that count reaches
- * zero, then remove the no-op Rx handler from that netdev
- */
-static inline void ice_enable_lag(struct ice_lag *lag)
-{
-	if (lag->dis_lag)
-		lag->dis_lag--;
-	if (!lag->dis_lag && lag->handler) {
-		rtnl_lock();
-		netdev_rx_handler_unregister(lag->netdev);
-		rtnl_unlock();
-		lag->handler = false;
-	}
-}
-
-/**
- * ice_is_lag_dis - is LAG disabled
- * @lag: LAG struct
- *
- * Return true if bonding is disabled
- */
-static inline bool ice_is_lag_dis(struct ice_lag *lag)
-{
-	return !!(lag->dis_lag);
-}
 #endif /* _ICE_LAG_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 387bb9cbafbe..3de9556b89ac 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2707,8 +2707,6 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_vsi_cfg_params *params)
 	return vsi;
 
 err_vsi_cfg:
-	if (params->type == ICE_VSI_VF)
-		ice_enable_lag(pf->lag);
 	ice_vsi_free(vsi);
 
 	return NULL;
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 80c643fb9f2f..a7e7debb1428 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -979,8 +979,6 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	if (!num_vfs) {
 		if (!pci_vfs_assigned(pdev)) {
 			ice_free_vfs(pf);
-			if (pf->lag)
-				ice_enable_lag(pf->lag);
 			return 0;
 		}
 
@@ -992,8 +990,6 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	if (err)
 		return err;
 
-	if (pf->lag)
-		ice_disable_lag(pf->lag);
 	return num_vfs;
 }
 
-- 
2.38.1


