Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B0C67F17F
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 23:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbjA0WyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 17:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjA0Wx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 17:53:57 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85A33D90A
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674860026; x=1706396026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QORsL5yr5x28II2v6hxTFF0qZdoFQp3uxELt/8Kkjz4=;
  b=MNMq+eyeMw1+wsICGVMrJz3VqT9mB505Zec1CNLoYdMjBSb0FXT0jVLp
   V+yiaQvlbI3TZ00nkBPylZFCFD9N/t3xRdFbNyOcJ2Y9h7e6hqOzO1Dwu
   Jq9OGStzTuJ6E3NJ8hCgmj+3k3CU97w0dfFEY8tUiPQrK8yjxzhoIud7j
   kCom0aWExAz9xHULbGjvj33AWCfuT9+sClGUo7JAkqd20zGPsiidsTKq1
   AGG4w4YWZ5tZJinStYDPUQrt8/+YZGWz4TWnC8jtXkHHKBnPKNK+jOP9Y
   d7uTo2hGP+4VkXPQZF8fMvfk9w37c+ixAGyx3RY8+8M+e9wm0SsW9scyx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="327229818"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="327229818"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 14:53:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="805976402"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="805976402"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jan 2023 14:53:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, leonro@nvidia.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net v4 1/2] ice: Prevent set_channel from changing queues while RDMA active
Date:   Fri, 27 Jan 2023 14:53:32 -0800
Message-Id: <20230127225333.1534783-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127225333.1534783-1-anthony.l.nguyen@intel.com>
References: <20230127225333.1534783-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The PF controls the set of queues that the RDMA auxiliary_driver requests
resources from.  The set_channel command will alter that pool and trigger a
reconfiguration of the VSI, which breaks RDMA functionality.

Prevent set_channel from executing when RDMA driver bound to auxiliary
device.

Adding a locked variable to pass down the call chain to avoid double
locking the device_lock.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 23 +++++++++-------
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h |  4 +--
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 28 +++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_main.c    |  5 ++--
 5 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 2f0b604abc5e..713069f809ec 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -880,7 +880,7 @@ void ice_set_ethtool_repr_ops(struct net_device *netdev);
 void ice_set_ethtool_safe_mode_ops(struct net_device *netdev);
 u16 ice_get_avail_txq_count(struct ice_pf *pf);
 u16 ice_get_avail_rxq_count(struct ice_pf *pf);
-int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx);
+int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked);
 void ice_update_vsi_stats(struct ice_vsi *vsi);
 void ice_update_pf_stats(struct ice_pf *pf);
 void
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 4f24d441c35e..0a55c552189a 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -441,7 +441,7 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 		goto out;
 	}
 
-	ice_pf_dcb_recfg(pf);
+	ice_pf_dcb_recfg(pf, false);
 
 out:
 	/* enable previously downed VSIs */
@@ -731,12 +731,13 @@ static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
 /**
  * ice_pf_dcb_recfg - Reconfigure all VEBs and VSIs
  * @pf: pointer to the PF struct
+ * @locked: is adev device lock held
  *
  * Assumed caller has already disabled all VSIs before
  * calling this function. Reconfiguring DCB based on
  * local_dcbx_cfg.
  */
-void ice_pf_dcb_recfg(struct ice_pf *pf)
+void ice_pf_dcb_recfg(struct ice_pf *pf, bool locked)
 {
 	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
 	struct iidc_event *event;
@@ -783,14 +784,16 @@ void ice_pf_dcb_recfg(struct ice_pf *pf)
 		if (vsi->type == ICE_VSI_PF)
 			ice_dcbnl_set_all(vsi);
 	}
-	/* Notify the AUX drivers that TC change is finished */
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
-	if (!event)
-		return;
+	if (!locked) {
+		/* Notify the AUX drivers that TC change is finished */
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (!event)
+			return;
 
-	set_bit(IIDC_EVENT_AFTER_TC_CHANGE, event->type);
-	ice_send_event_to_aux(pf, event);
-	kfree(event);
+		set_bit(IIDC_EVENT_AFTER_TC_CHANGE, event->type);
+		ice_send_event_to_aux(pf, event);
+		kfree(event);
+	}
 }
 
 /**
@@ -1044,7 +1047,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	}
 
 	/* changes in configuration update VSI */
-	ice_pf_dcb_recfg(pf);
+	ice_pf_dcb_recfg(pf, false);
 
 	/* enable previously downed VSIs */
 	ice_dcb_ena_dis_vsi(pf, true, true);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 4c421c842a13..800879a88c5e 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -23,7 +23,7 @@ u8 ice_dcb_get_tc(struct ice_vsi *vsi, int queue_index);
 int
 ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked);
 int ice_dcb_bwchk(struct ice_pf *pf, struct ice_dcbx_cfg *dcbcfg);
-void ice_pf_dcb_recfg(struct ice_pf *pf);
+void ice_pf_dcb_recfg(struct ice_pf *pf, bool locked);
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
 void ice_update_dcb_stats(struct ice_pf *pf);
@@ -128,7 +128,7 @@ static inline u8 ice_get_pfc_mode(struct ice_pf *pf)
 	return 0;
 }
 
-static inline void ice_pf_dcb_recfg(struct ice_pf *pf) { }
+static inline void ice_pf_dcb_recfg(struct ice_pf *pf, bool locked) { }
 static inline void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi) { }
 static inline void ice_update_dcb_stats(struct ice_pf *pf) { }
 static inline void
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 4191994d8f3a..a359f1610fc1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3641,7 +3641,9 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	int new_rx = 0, new_tx = 0;
+	bool locked = false;
 	u32 curr_combined;
+	int ret = 0;
 
 	/* do not support changing channels in Safe Mode */
 	if (ice_is_safe_mode(pf)) {
@@ -3705,15 +3707,33 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 		return -EINVAL;
 	}
 
-	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
+	if (pf->adev) {
+		mutex_lock(&pf->adev_mutex);
+		device_lock(&pf->adev->dev);
+		locked = true;
+		if (pf->adev->dev.driver) {
+			netdev_err(dev, "Cannot change channels when RDMA is active\n");
+			ret = -EBUSY;
+			goto adev_unlock;
+		}
+	}
+
+	ice_vsi_recfg_qs(vsi, new_rx, new_tx, locked);
 
-	if (!netif_is_rxfh_configured(dev))
-		return ice_vsi_set_dflt_rss_lut(vsi, new_rx);
+	if (!netif_is_rxfh_configured(dev)) {
+		ret = ice_vsi_set_dflt_rss_lut(vsi, new_rx);
+		goto adev_unlock;
+	}
 
 	/* Update rss_size due to change in Rx queues */
 	vsi->rss_size = ice_get_valid_rss_size(&pf->hw, new_rx);
 
-	return 0;
+adev_unlock:
+	if (locked) {
+		device_unlock(&pf->adev->dev);
+		mutex_unlock(&pf->adev_mutex);
+	}
+	return ret;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 237ede2cffb0..5f86e4111fa9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4195,12 +4195,13 @@ bool ice_is_wol_supported(struct ice_hw *hw)
  * @vsi: VSI being changed
  * @new_rx: new number of Rx queues
  * @new_tx: new number of Tx queues
+ * @locked: is adev device_lock held
  *
  * Only change the number of queues if new_tx, or new_rx is non-0.
  *
  * Returns 0 on success.
  */
-int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
+int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx, bool locked)
 {
 	struct ice_pf *pf = vsi->back;
 	int err = 0, timeout = 50;
@@ -4229,7 +4230,7 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx)
 
 	ice_vsi_close(vsi);
 	ice_vsi_rebuild(vsi, false);
-	ice_pf_dcb_recfg(pf);
+	ice_pf_dcb_recfg(pf, locked);
 	ice_vsi_open(vsi);
 done:
 	clear_bit(ICE_CFG_BUSY, pf->state);
-- 
2.38.1

