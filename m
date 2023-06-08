Return-Path: <netdev+bounces-9317-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7736E7286D8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77BC31C21007
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A4B21EA95;
	Thu,  8 Jun 2023 18:05:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2A51DCCC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 18:05:06 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE28C19AC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686247504; x=1717783504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gnP0R/H0jVqtSCTeKb6AGZa0D3Z8AcN5ddc8oljp0SM=;
  b=LXeFs7Mjxs21pbriL0IHf30xEkHCAgUM+560hAEkzPq4U0TP5GRdx1cM
   FdD4q9ySMmi9N0z0DzVSrTY0nbQ5IVqHHEMF9Oc6egA/bRedW/nFYqeNt
   YYE94UxMF8Ic01bszDlII8ynTeQLAJVzUTG+CkXXp9olIcg8HZa9sStQZ
   zHaXD9tCZp8PcAmFw2x1qihOmFmzydiCCYt0KyV3JMSRsN5RCi1u8V3Qe
   WCz1ZRuoZwsxrLpXxVP+cF9obAe3wuqC7zzquLNnKfEk6SmxUMcKR6Gx4
   MAZ/WnIxt063Vr50+Sp9ZS9TZPs0lMzdy3AimBCsaLmolmGA0UVRic+qj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385738704"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385738704"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 11:04:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="775187922"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="775187922"
Received: from dmert-dev.jf.intel.com ([10.166.241.14])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 11:04:37 -0700
From: Dave Ertman <david.m.ertman@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	daniel.machon@microchip.com
Subject: [PATCH iwl-next v3 02/10] ice: Add driver support for firmware changes for LAG
Date: Thu,  8 Jun 2023 11:06:10 -0700
Message-Id: <20230608180618.574171-3-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608180618.574171-1-david.m.ertman@intel.com>
References: <20230608180618.574171-1-david.m.ertman@intel.com>
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
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the defines, fields, and detection code for FW support of LAG for
SRIOV.  Also exposes some previously static functions to allow access
in the lag code.

Clean up code that is unused or not needed for LAG support.  Also add
an ordered workqueue for processing LAG events.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  5 ++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  3 ++
 drivers/net/ethernet/intel/ice/ice_common.c   |  8 +++
 drivers/net/ethernet/intel/ice/ice_lag.c      | 53 ++++++++++---------
 drivers/net/ethernet/intel/ice/ice_lib.c      |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 12 +++++
 drivers/net/ethernet/intel/ice/ice_type.h     |  2 +
 8 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 9109006336f0..5ac0ad12f9f1 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -200,6 +200,8 @@ enum ice_feature {
 	ICE_F_PTP_EXTTS,
 	ICE_F_SMA_CTRL,
 	ICE_F_GNSS,
+	ICE_F_ROCE_LAG,
+	ICE_F_SRIOV_LAG,
 	ICE_F_MAX
 };
 
@@ -569,6 +571,7 @@ struct ice_pf {
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	struct mutex tc_mutex;		/* lock to protect TC changes */
 	struct mutex adev_mutex;	/* lock to protect aux device access */
+	struct mutex lag_mutex;		/* protect ice_lag struct in PF */
 	u32 msg_enable;
 	struct ice_ptp ptp;
 	struct gnss_serial *gnss_serial;
@@ -639,6 +642,8 @@ struct ice_pf {
 	struct ice_agg_node vf_agg_node[ICE_MAX_VF_AGG_NODES];
 };
 
+extern struct workqueue_struct *ice_lag_wq;
+
 struct ice_netdev_priv {
 	struct ice_vsi *vsi;
 	struct ice_repr *repr;
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 63d3e1dcbba5..1d4227b024d3 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -120,6 +120,9 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_PCIE_RESET_AVOIDANCE		0x0076
 #define ICE_AQC_CAPS_POST_UPDATE_RESET_RESTRICT		0x0077
 #define ICE_AQC_CAPS_NVM_MGMT				0x0080
+#define ICE_AQC_CAPS_FW_LAG_SUPPORT			0x0092
+#define ICE_AQC_BIT_ROCEV2_LAG				0x01
+#define ICE_AQC_BIT_SRIOV_LAG				0x02
 
 	u8 major_ver;
 	u8 minor_ver;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index ebdaf8dc679c..9704e7fa2953 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2241,6 +2241,14 @@ ice_parse_common_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps,
 			  "%s: reset_restrict_support = %d\n", prefix,
 			  caps->reset_restrict_support);
 		break;
+	case ICE_AQC_CAPS_FW_LAG_SUPPORT:
+		caps->roce_lag = !!(number & ICE_AQC_BIT_ROCEV2_LAG);
+		ice_debug(hw, ICE_DBG_INIT, "%s: roce_lag = %u\n",
+			  prefix, caps->roce_lag);
+		caps->sriov_lag = !!(number & ICE_AQC_BIT_SRIOV_LAG);
+		ice_debug(hw, ICE_DBG_INIT, "%s: sriov_lag = %u\n",
+			  prefix, caps->sriov_lag);
+		break;
 	default:
 		/* Not one of the recognized common capabilities */
 		found = false;
diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 5a7753bda324..73bfc5cd8b37 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -4,8 +4,12 @@
 /* Link Aggregation code */
 
 #include "ice.h"
+#include "ice_lib.h"
 #include "ice_lag.h"
 
+#define ICE_LAG_RES_SHARED	BIT(14)
+#define ICE_LAG_RES_VALID	BIT(15)
+
 /**
  * ice_lag_set_primary - set PF LAG state as Primary
  * @lag: LAG info struct
@@ -225,6 +229,26 @@ static void ice_lag_unregister(struct ice_lag *lag, struct net_device *netdev)
 	lag->role = ICE_LAG_NONE;
 }
 
+/**
+ * ice_lag_check_nvm_support - Check for NVM support for LAG
+ * @pf: PF struct
+ */
+static void ice_lag_check_nvm_support(struct ice_pf *pf)
+{
+	struct ice_hw_dev_caps *caps;
+
+	caps = &pf->hw.dev_caps;
+	if (caps->common_cap.roce_lag)
+		ice_set_feature_support(pf, ICE_F_ROCE_LAG);
+	else
+		ice_clear_feature_support(pf, ICE_F_ROCE_LAG);
+
+	if (caps->common_cap.sriov_lag)
+		ice_set_feature_support(pf, ICE_F_SRIOV_LAG);
+	else
+		ice_clear_feature_support(pf, ICE_F_SRIOV_LAG);
+}
+
 /**
  * ice_lag_changeupper_event - handle LAG changeupper event
  * @lag: LAG info struct
@@ -264,26 +288,6 @@ static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
 	ice_display_lag_info(lag);
 }
 
-/**
- * ice_lag_changelower_event - handle LAG changelower event
- * @lag: LAG info struct
- * @ptr: opaque data pointer
- *
- * ptr to be cast to netdev_notifier_changelowerstate_info
- */
-static void ice_lag_changelower_event(struct ice_lag *lag, void *ptr)
-{
-	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
-
-	if (netdev != lag->netdev)
-		return;
-
-	netdev_dbg(netdev, "bonding info\n");
-
-	if (!netif_is_lag_port(netdev))
-		netdev_dbg(netdev, "CHANGELOWER rcvd, but netdev not in LAG. Bail\n");
-}
-
 /**
  * ice_lag_event_handler - handle LAG events from netdev
  * @notif_blk: notifier block registered by this netdev
@@ -310,9 +314,6 @@ ice_lag_event_handler(struct notifier_block *notif_blk, unsigned long event,
 	case NETDEV_CHANGEUPPER:
 		ice_lag_changeupper_event(lag, ptr);
 		break;
-	case NETDEV_CHANGELOWERSTATE:
-		ice_lag_changelower_event(lag, ptr);
-		break;
 	case NETDEV_BONDING_INFO:
 		ice_lag_info_event(lag, ptr);
 		break;
@@ -379,6 +380,8 @@ int ice_init_lag(struct ice_pf *pf)
 	struct ice_vsi *vsi;
 	int err;
 
+	ice_lag_check_nvm_support(pf);
+
 	pf->lag = kzalloc(sizeof(*lag), GFP_KERNEL);
 	if (!pf->lag)
 		return -ENOMEM;
@@ -435,9 +438,7 @@ void ice_deinit_lag(struct ice_pf *pf)
 	if (lag->pf)
 		ice_unregister_lag_handler(lag);
 
-	dev_put(lag->upper_netdev);
-
-	dev_put(lag->peer_netdev);
+	flush_workqueue(ice_lag_wq);
 
 	kfree(lag);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index c3722c68af99..a3d3857ef59b 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3997,7 +3997,7 @@ bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f)
  * @pf: pointer to the struct ice_pf instance
  * @f: feature enum to set
  */
-static void ice_set_feature_support(struct ice_pf *pf, enum ice_feature f)
+void ice_set_feature_support(struct ice_pf *pf, enum ice_feature f)
 {
 	if (f < 0 || f >= ICE_F_MAX)
 		return;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 1628385a9672..dd53fe968ad8 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -163,6 +163,7 @@ int ice_vsi_del_vlan_zero(struct ice_vsi *vsi);
 bool ice_vsi_has_non_zero_vlans(struct ice_vsi *vsi);
 u16 ice_vsi_num_non_zero_vlans(struct ice_vsi *vsi);
 bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f);
+void ice_set_feature_support(struct ice_pf *pf, enum ice_feature f);
 void ice_clear_feature_support(struct ice_pf *pf, enum ice_feature f);
 void ice_init_feature_support(struct ice_pf *pf);
 bool ice_vsi_is_rx_queue_active(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f358018337af..e01834d0417e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -64,6 +64,7 @@ struct device *ice_hw_to_dev(struct ice_hw *hw)
 }
 
 static struct workqueue_struct *ice_wq;
+struct workqueue_struct *ice_lag_wq;
 static const struct net_device_ops ice_netdev_safe_mode_ops;
 static const struct net_device_ops ice_netdev_ops;
 
@@ -3795,6 +3796,7 @@ u16 ice_get_avail_rxq_count(struct ice_pf *pf)
 static void ice_deinit_pf(struct ice_pf *pf)
 {
 	ice_service_task_stop(pf);
+	mutex_destroy(&pf->lag_mutex);
 	mutex_destroy(&pf->adev_mutex);
 	mutex_destroy(&pf->sw_mutex);
 	mutex_destroy(&pf->tc_mutex);
@@ -3875,6 +3877,7 @@ static int ice_init_pf(struct ice_pf *pf)
 	mutex_init(&pf->sw_mutex);
 	mutex_init(&pf->tc_mutex);
 	mutex_init(&pf->adev_mutex);
+	mutex_init(&pf->lag_mutex);
 
 	INIT_HLIST_HEAD(&pf->aq_wait_list);
 	spin_lock_init(&pf->aq_wait_lock);
@@ -5576,10 +5579,18 @@ static int __init ice_module_init(void)
 		return -ENOMEM;
 	}
 
+	ice_lag_wq = alloc_ordered_workqueue("ice_lag_wq", 0);
+	if (!ice_lag_wq) {
+		pr_err("Failed to create LAG workqueue\n");
+		destroy_workqueue(ice_wq);
+		return -ENOMEM;
+	}
+
 	status = pci_register_driver(&ice_driver);
 	if (status) {
 		pr_err("failed to register PCI driver, err %d\n", status);
 		destroy_workqueue(ice_wq);
+		destroy_workqueue(ice_lag_wq);
 	}
 
 	return status;
@@ -5596,6 +5607,7 @@ static void __exit ice_module_exit(void)
 {
 	pci_unregister_driver(&ice_driver);
 	destroy_workqueue(ice_wq);
+	destroy_workqueue(ice_lag_wq);
 	pr_info("module unloaded\n");
 }
 module_exit(ice_module_exit);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index df9171a1a34f..e82f38c2a940 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -277,6 +277,8 @@ struct ice_hw_common_caps {
 	u8 dcb;
 	u8 ieee_1588;
 	u8 rdma;
+	u8 roce_lag;
+	u8 sriov_lag;
 
 	bool nvm_update_pending_nvm;
 	bool nvm_update_pending_orom;
-- 
2.40.1


