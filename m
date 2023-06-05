Return-Path: <netdev+bounces-8142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2414E722E89
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:21:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD5A12813A7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C24C22D71;
	Mon,  5 Jun 2023 18:21:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBACAD2E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:21:19 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4BFEC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685989277; x=1717525277;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=szu6p6CPmBsN0pQnQ2fNywIJVPsE0VZAaZDc4AD1BDs=;
  b=aKGmMOa/vmVGmgdeLx/HS+03OT4FhweeGTMt2qFrYWDw6XRrY05tRRF/
   YD3TiXfkHj2x3mxcWFtrs80vN9JyS5moLwS3LrHsPOrl6Ls7P8Fl03jhU
   OnRpWPgaNKvFz7+Xdtd/5KKnOc6SpcPdygmy5ZCyke52aq4yeowDp9LxL
   eyvZ98uTmbkhweUZ5sObWOhpNe6jdlmclv80d2xHw+0VqbVdBT7gGzU/m
   rO5js9PQ3Wwcww8HzJH/LOEDDeeqAhDuZHS/NhQfC2MNZd44u76zp01qK
   eo8ukqQH8rrKqoo7xPnjFUC5E6XWnv7Tit9Ts0ozmKv5e1pCS/GjSgXHc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="358896801"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="358896801"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 11:21:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="1038863364"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="1038863364"
Received: from dmert-dev.jf.intel.com ([10.166.241.14])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 11:21:15 -0700
From: Dave Ertman <david.m.ertman@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Subject: [PATCH net v2 02/10] ice: Add driver support for firmware changes for LAG
Date: Mon,  5 Jun 2023 11:22:50 -0700
Message-Id: <20230605182258.557933-3-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605182258.557933-1-david.m.ertman@intel.com>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
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
a ordered workqueue for processing LAG events.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  5 ++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  3 ++
 drivers/net/ethernet/intel/ice/ice_common.c   |  9 +++-
 drivers/net/ethernet/intel/ice/ice_lag.c      | 53 ++++++++++---------
 drivers/net/ethernet/intel/ice/ice_lib.c      |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 12 +++++
 drivers/net/ethernet/intel/ice/ice_type.h     |  2 +
 8 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b4bca1d964a9..7a2f93c0c3f2 100644
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
 
@@ -560,6 +562,7 @@ struct ice_pf {
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	struct mutex tc_mutex;		/* lock to protect TC changes */
 	struct mutex adev_mutex;	/* lock to protect aux device access */
+	struct mutex lag_mutex;		/* protect ice_lag struct in PF */
 	u32 msg_enable;
 	struct ice_ptp ptp;
 	struct gnss_serial *gnss_serial;
@@ -629,6 +632,8 @@ struct ice_pf {
 	struct ice_agg_node vf_agg_node[ICE_MAX_VF_AGG_NODES];
 };
 
+extern struct workqueue_struct *ice_lag_wq;
+
 struct ice_netdev_priv {
 	struct ice_vsi *vsi;
 	struct ice_repr *repr;
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 8a624cef0eb0..05ae65f1dd27 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -121,6 +121,9 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_POST_UPDATE_RESET_RESTRICT		0x0077
 #define ICE_AQC_CAPS_NVM_MGMT				0x0080
 #define ICE_AQC_CAPS_TX_SCHED_TOPO_COMP_MODE		0x0085
+#define ICE_AQC_CAPS_FW_LAG_SUPPORT			0x0092
+#define ICE_AQC_BIT_ROCEV2_LAG				0x01
+#define ICE_AQC_BIT_SRIOV_LAG				0x02
 
 	u8 major_ver;
 	u8 minor_ver;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 23a9f169bc71..fd21b5e38600 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2248,7 +2248,14 @@ ice_parse_common_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps,
 	case ICE_AQC_CAPS_TX_SCHED_TOPO_COMP_MODE:
 		caps->tx_sched_topo_comp_mode_en = (number == 1);
 		break;
-
+	case ICE_AQC_CAPS_FW_LAG_SUPPORT:
+		caps->roce_lag = !!(number & ICE_AQC_BIT_ROCEV2_LAG);
+		ice_debug(hw, ICE_DBG_INIT, "%s: roce_lag = %d\n",
+			  prefix, caps->roce_lag);
+		caps->sriov_lag = !!(number & ICE_AQC_BIT_SRIOV_LAG);
+		ice_debug(hw, ICE_DBG_INIT, "%s: sriov_lag = %d\n",
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
index 5ddb95d1073a..7b98655ceeeb 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4011,7 +4011,7 @@ bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f)
  * @pf: pointer to the struct ice_pf instance
  * @f: feature enum to set
  */
-static void ice_set_feature_support(struct ice_pf *pf, enum ice_feature f)
+void ice_set_feature_support(struct ice_pf *pf, enum ice_feature f)
 {
 	if (f < 0 || f >= ICE_F_MAX)
 		return;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index e985766e6bb5..d35fb628d7c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -162,6 +162,7 @@ int ice_vsi_del_vlan_zero(struct ice_vsi *vsi);
 bool ice_vsi_has_non_zero_vlans(struct ice_vsi *vsi);
 u16 ice_vsi_num_non_zero_vlans(struct ice_vsi *vsi);
 bool ice_is_feature_supported(struct ice_pf *pf, enum ice_feature f);
+void ice_set_feature_support(struct ice_pf *pf, enum ice_feature f);
 void ice_clear_feature_support(struct ice_pf *pf, enum ice_feature f);
 void ice_init_feature_support(struct ice_pf *pf);
 bool ice_vsi_is_rx_queue_active(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b0d1e6116eb9..7030b2e54d2b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -64,6 +64,7 @@ struct device *ice_hw_to_dev(struct ice_hw *hw)
 }
 
 static struct workqueue_struct *ice_wq;
+struct workqueue_struct *ice_lag_wq;
 static const struct net_device_ops ice_netdev_safe_mode_ops;
 static const struct net_device_ops ice_netdev_ops;
 
@@ -3780,6 +3781,7 @@ u16 ice_get_avail_rxq_count(struct ice_pf *pf)
 static void ice_deinit_pf(struct ice_pf *pf)
 {
 	ice_service_task_stop(pf);
+	mutex_destroy(&pf->lag_mutex);
 	mutex_destroy(&pf->adev_mutex);
 	mutex_destroy(&pf->sw_mutex);
 	mutex_destroy(&pf->tc_mutex);
@@ -3860,6 +3862,7 @@ static int ice_init_pf(struct ice_pf *pf)
 	mutex_init(&pf->sw_mutex);
 	mutex_init(&pf->tc_mutex);
 	mutex_init(&pf->adev_mutex);
+	mutex_init(&pf->lag_mutex);
 
 	INIT_HLIST_HEAD(&pf->aq_wait_list);
 	spin_lock_init(&pf->aq_wait_lock);
@@ -5640,10 +5643,18 @@ static int __init ice_module_init(void)
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
@@ -5660,6 +5671,7 @@ static void __exit ice_module_exit(void)
 {
 	pci_unregister_driver(&ice_driver);
 	destroy_workqueue(ice_wq);
+	destroy_workqueue(ice_lag_wq);
 	pr_info("module unloaded\n");
 }
 module_exit(ice_module_exit);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 5602695243a8..460ec75f162b 100644
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


