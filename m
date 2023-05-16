Return-Path: <netdev+bounces-2975-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C88B3704C60
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:32:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9632C1C20B65
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E8AA24EA6;
	Tue, 16 May 2023 11:32:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA8434CEB
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:32:10 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C9F1706
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684236727; x=1715772727;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yy+H6sf8Z1odWuK9uGbeOMJCaxt2CjLPeR46KgKfvzw=;
  b=ZbrUtcy5RZVRwtGAhP1z4ZUiBHTMWXd+1DJVR/wwUWRqgzj6wvIzx1Ok
   YhpajdWPxWfNViOYl99m5f1khIEt0iMzO3vmX256ixdfaFxO3ZDyDbWeh
   TB+BJrqggBun9J08VG7+y1TFiPShhKabLCcsAbRamMCE9dyrcmE5xSS3w
   UIBdiQ/HWf0SLfXWCAfjR7yyFaNOBPIPEsXsj1IZ9bpilLQk9M6KEI4Gp
   S59cxu+AfawrBU6qSN10J5LrF1NBlLFqtjfUj+tumnIDizhq5ujE8UCnE
   xhXBcDarNUytV90HgXmlGEnT4uZL0aCubT8t7A+0XuNwqzuJS9Qkdltft
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="331071653"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="331071653"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 04:32:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="791047304"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="791047304"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by FMSMGA003.fm.intel.com with ESMTP; 16 May 2023 04:32:05 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id B99D233741;
	Tue, 16 May 2023 12:32:04 +0100 (IST)
From: Wojciech Drewek <wojciech.drewek@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	david.m.ertman@intel.com,
	mschmidt@redhat.com,
	ihuguet@redhat.com
Subject: [PATCH iwl-next v2] ice: Remove LAG+SRIOV mutual exclusion
Date: Tue, 16 May 2023 13:30:55 +0200
Message-Id: <20230516113055.7336-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
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
---
v2: remove ice_lag::handler
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
index d9731476cd7f..5ddb95d1073a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2712,8 +2712,6 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_vsi_cfg_params *params)
 	return vsi;
 
 err_vsi_cfg:
-	if (params->type == ICE_VSI_VF)
-		ice_enable_lag(pf->lag);
 	ice_vsi_free(vsi);
 
 	return NULL;
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 9788f363e9dc..a222cd702fd5 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -960,8 +960,6 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	if (!num_vfs) {
 		if (!pci_vfs_assigned(pdev)) {
 			ice_free_vfs(pf);
-			if (pf->lag)
-				ice_enable_lag(pf->lag);
 			return 0;
 		}
 
@@ -973,8 +971,6 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	if (err)
 		return err;
 
-	if (pf->lag)
-		ice_disable_lag(pf->lag);
 	return num_vfs;
 }
 
-- 
2.39.2


