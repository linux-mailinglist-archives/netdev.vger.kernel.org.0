Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E094AFFA5
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiBIV5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:57:40 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbiBIV5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:20 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03B8E00F7DB
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644443836; x=1675979836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KKa5z3ItSDN21HWv3+KtPkX7QU7y5alr0SRp9RNo5+o=;
  b=YknSF9NR6YpWn3QYmRWjClaAmHH7pnuC78l9ZEPBVs1TZNOiUNSRrzBQ
   RuuYDz4yZ++EpSadVSTZJtmjRhDMHCHouBoHtHzl8eIRQ77ZyBM0WHCei
   XRyZxc9FPZfBgEEEa05DYtgCJWj+giNUZCKiFSmKcIvq5glaGIEGTv6zv
   gPLSpUfWicSsudVTTBfEdt+J1HDDTHneGVD08jQe7YxJm10wLx3o5F32Z
   noUQS3OL2v3l41B3ND79D7FYArpxvKaXINE9q5ksKxSxMrPt3LwAxtVpf
   pmP7amWgDattIlGZrTgTtLW7+jITMjP3Tx/B6kM9Q/lZtjxrD5CJE/S/I
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249104091"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249104091"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 13:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="601790485"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2022 13:57:14 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 04/14] ice: Introduce ice_vlan struct
Date:   Wed,  9 Feb 2022 13:56:56 -0800
Message-Id: <20220209215706.2468371-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
References: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Add a new struct for VLAN related information. Currently this holds
VLAN ID and priority values, but will be expanded to hold TPID value.
This reduces the changes necessary if any other values are added in
future. Remove the action argument from these calls as it's always
ICE_FWD_VSI.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c     | 35 +++++++------------
 drivers/net/ethernet/intel/ice/ice_fltr.h     | 10 +++---
 drivers/net/ethernet/intel/ice/ice_lib.c      |  5 ++-
 drivers/net/ethernet/intel/ice/ice_lib.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  8 +++--
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 19 ++++++----
 drivers/net/ethernet/intel/ice/ice_vlan.h     | 17 +++++++++
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c | 31 +++++++++-------
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.h |  9 +++--
 .../net/ethernet/intel/ice/ice_vsi_vlan_ops.h |  6 ++--
 10 files changed, 82 insertions(+), 59 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vlan.h

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index c29177c6bb9d..0e6c4f052686 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -203,21 +203,20 @@ ice_fltr_add_mac_to_list(struct ice_vsi *vsi, struct list_head *list,
  * ice_fltr_add_vlan_to_list - add VLAN filter info to exsisting list
  * @vsi: pointer to VSI struct
  * @list: list to add filter info to
- * @vlan_id: VLAN ID to add
- * @action: filter action
+ * @vlan: VLAN filter details
  */
 static int
 ice_fltr_add_vlan_to_list(struct ice_vsi *vsi, struct list_head *list,
-			  u16 vlan_id, enum ice_sw_fwd_act_type action)
+			  struct ice_vlan *vlan)
 {
 	struct ice_fltr_info info = { 0 };
 
 	info.flag = ICE_FLTR_TX;
 	info.src_id = ICE_SRC_ID_VSI;
 	info.lkup_type = ICE_SW_LKUP_VLAN;
-	info.fltr_act = action;
+	info.fltr_act = ICE_FWD_TO_VSI;
 	info.vsi_handle = vsi->idx;
-	info.l_data.vlan.vlan_id = vlan_id;
+	info.l_data.vlan.vlan_id = vlan->vid;
 
 	return ice_fltr_add_entry_to_list(ice_pf_to_dev(vsi->back), &info,
 					  list);
@@ -310,19 +309,17 @@ ice_fltr_prepare_mac_and_broadcast(struct ice_vsi *vsi, const u8 *mac,
 /**
  * ice_fltr_prepare_vlan - add or remove VLAN filter
  * @vsi: pointer to VSI struct
- * @vlan_id: VLAN ID to add
- * @action: action to be performed on filter match
+ * @vlan: VLAN filter details
  * @vlan_action: pointer to add or remove VLAN function
  */
 static int
-ice_fltr_prepare_vlan(struct ice_vsi *vsi, u16 vlan_id,
-		      enum ice_sw_fwd_act_type action,
+ice_fltr_prepare_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan,
 		      int (*vlan_action)(struct ice_vsi *, struct list_head *))
 {
 	LIST_HEAD(tmp_list);
 	int result;
 
-	if (ice_fltr_add_vlan_to_list(vsi, &tmp_list, vlan_id, action))
+	if (ice_fltr_add_vlan_to_list(vsi, &tmp_list, vlan))
 		return -ENOMEM;
 
 	result = vlan_action(vsi, &tmp_list);
@@ -395,27 +392,21 @@ int ice_fltr_remove_mac(struct ice_vsi *vsi, const u8 *mac,
 /**
  * ice_fltr_add_vlan - add single VLAN filter
  * @vsi: pointer to VSI struct
- * @vlan_id: VLAN ID to add
- * @action: action to be performed on filter match
+ * @vlan: VLAN filter details
  */
-int ice_fltr_add_vlan(struct ice_vsi *vsi, u16 vlan_id,
-		      enum ice_sw_fwd_act_type action)
+int ice_fltr_add_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 {
-	return ice_fltr_prepare_vlan(vsi, vlan_id, action,
-				     ice_fltr_add_vlan_list);
+	return ice_fltr_prepare_vlan(vsi, vlan, ice_fltr_add_vlan_list);
 }
 
 /**
  * ice_fltr_remove_vlan - remove VLAN filter
  * @vsi: pointer to VSI struct
- * @vlan_id: filter VLAN to remove
- * @action: action to remove
+ * @vlan: VLAN filter details
  */
-int ice_fltr_remove_vlan(struct ice_vsi *vsi, u16 vlan_id,
-			 enum ice_sw_fwd_act_type action)
+int ice_fltr_remove_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 {
-	return ice_fltr_prepare_vlan(vsi, vlan_id, action,
-				     ice_fltr_remove_vlan_list);
+	return ice_fltr_prepare_vlan(vsi, vlan, ice_fltr_remove_vlan_list);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.h b/drivers/net/ethernet/intel/ice/ice_fltr.h
index 3eb42479175f..0f3dbc308eec 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.h
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.h
@@ -4,6 +4,8 @@
 #ifndef _ICE_FLTR_H_
 #define _ICE_FLTR_H_
 
+#include "ice_vlan.h"
+
 void ice_fltr_free_list(struct device *dev, struct list_head *h);
 int
 ice_fltr_set_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
@@ -32,12 +34,8 @@ ice_fltr_remove_mac(struct ice_vsi *vsi, const u8 *mac,
 		    enum ice_sw_fwd_act_type action);
 int ice_fltr_remove_mac_list(struct ice_vsi *vsi, struct list_head *list);
 
-int
-ice_fltr_add_vlan(struct ice_vsi *vsi, u16 vid,
-		  enum ice_sw_fwd_act_type action);
-int
-ice_fltr_remove_vlan(struct ice_vsi *vsi, u16 vid,
-		     enum ice_sw_fwd_act_type action);
+int ice_fltr_add_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
+int ice_fltr_remove_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
 
 int
 ice_fltr_add_eth(struct ice_vsi *vsi, u16 ethertype, u16 flag,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index e069722e3d85..58e796191a0f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3921,7 +3921,10 @@ int ice_set_link(struct ice_vsi *vsi, bool ena)
  */
 int ice_vsi_add_vlan_zero(struct ice_vsi *vsi)
 {
-	return vsi->vlan_ops.add_vlan(vsi, 0, ICE_FWD_TO_VSI);
+	struct ice_vlan vlan;
+
+	vlan = ICE_VLAN(0, 0);
+	return vsi->vlan_ops.add_vlan(vsi, &vlan);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index de14e0f5fcfe..e3dabc9ec64e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -5,6 +5,7 @@
 #define _ICE_LIB_H_
 
 #include "ice.h"
+#include "ice_vlan.h"
 
 const char *ice_vsi_type_str(enum ice_vsi_type vsi_type);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 61be24ea8d0b..cc13943a1d88 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3413,6 +3413,7 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __always_unused __be16 proto,
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
+	struct ice_vlan vlan;
 	int ret;
 
 	/* VLAN 0 is added by default during load/reset */
@@ -3429,7 +3430,8 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __always_unused __be16 proto,
 	/* Add a switch rule for this VLAN ID so its corresponding VLAN tagged
 	 * packets aren't pruned by the device's internal switch on Rx
 	 */
-	ret = vsi->vlan_ops.add_vlan(vsi, vid, ICE_FWD_TO_VSI);
+	vlan = ICE_VLAN(vid, 0);
+	ret = vsi->vlan_ops.add_vlan(vsi, &vlan);
 	if (!ret)
 		set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
 
@@ -3450,6 +3452,7 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
+	struct ice_vlan vlan;
 	int ret;
 
 	/* don't allow removal of VLAN 0 */
@@ -3459,7 +3462,8 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
 	/* Make sure VLAN delete is successful before updating VLAN
 	 * information
 	 */
-	ret = vsi->vlan_ops.del_vlan(vsi, vid);
+	vlan = ICE_VLAN(vid, 0);
+	ret = vsi->vlan_ops.del_vlan(vsi, &vlan);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 0033ef65db96..fdc50b42f8ee 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -760,24 +760,25 @@ static int ice_vf_rebuild_host_tx_rate_cfg(struct ice_vf *vf)
  */
 static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf)
 {
+	u8 vlan_prio = (vf->port_vlan_info & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	u16 vlan_id = vf->port_vlan_info & VLAN_VID_MASK;
 	struct device *dev = ice_pf_to_dev(vf->pf);
 	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
-	u16 vlan_id = 0;
+	struct ice_vlan vlan;
 	int err;
 
+	vlan = ICE_VLAN(vlan_id, vlan_prio);
 	if (vf->port_vlan_info) {
-		err = vsi->vlan_ops.set_port_vlan(vsi, vf->port_vlan_info);
+		err = vsi->vlan_ops.set_port_vlan(vsi, &vlan);
 		if (err) {
 			dev_err(dev, "failed to configure port VLAN via VSI parameters for VF %u, error %d\n",
 				vf->vf_id, err);
 			return err;
 		}
-
-		vlan_id = vf->port_vlan_info & VLAN_VID_MASK;
 	}
 
 	/* vlan_id will either be 0 or the port VLAN number */
-	err = vsi->vlan_ops.add_vlan(vsi, vlan_id, ICE_FWD_TO_VSI);
+	err = vsi->vlan_ops.add_vlan(vsi, &vlan);
 	if (err) {
 		dev_err(dev, "failed to add %s VLAN %u filter for VF %u, error %d\n",
 			vf->port_vlan_info ? "port" : "", vlan_id, vf->vf_id,
@@ -4232,6 +4233,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 	if (add_v) {
 		for (i = 0; i < vfl->num_elements; i++) {
 			u16 vid = vfl->vlan_id[i];
+			struct ice_vlan vlan;
 
 			if (!ice_is_vf_trusted(vf) &&
 			    vsi->num_vlan >= ICE_MAX_VLAN_PER_VF) {
@@ -4251,7 +4253,8 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 			if (!vid)
 				continue;
 
-			status = vsi->vlan_ops.add_vlan(vsi, vid, ICE_FWD_TO_VSI);
+			vlan = ICE_VLAN(vid, 0);
+			status = vsi->vlan_ops.add_vlan(vsi, &vlan);
 			if (status) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
@@ -4294,6 +4297,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 		num_vf_vlan = vsi->num_vlan;
 		for (i = 0; i < vfl->num_elements && i < num_vf_vlan; i++) {
 			u16 vid = vfl->vlan_id[i];
+			struct ice_vlan vlan;
 
 			/* we add VLAN 0 by default for each VF so we can enable
 			 * Tx VLAN anti-spoof without triggering MDD events so
@@ -4302,7 +4306,8 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 			if (!vid)
 				continue;
 
-			status = vsi->vlan_ops.del_vlan(vsi, vid);
+			vlan = ICE_VLAN(vid, 0);
+			status = vsi->vlan_ops.del_vlan(vsi, &vlan);
 			if (status) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
diff --git a/drivers/net/ethernet/intel/ice/ice_vlan.h b/drivers/net/ethernet/intel/ice/ice_vlan.h
new file mode 100644
index 000000000000..3fad0cba2da6
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_vlan.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2019-2021, Intel Corporation. */
+
+#ifndef _ICE_VLAN_H_
+#define _ICE_VLAN_H_
+
+#include <linux/types.h>
+#include "ice_type.h"
+
+struct ice_vlan {
+	u16 vid;
+	u8 prio;
+};
+
+#define ICE_VLAN(vid, prio) ((struct ice_vlan){ vid, prio })
+
+#endif /* _ICE_VLAN_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
index 6b0a4bf28305..74b6dec0744b 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
@@ -9,20 +9,18 @@
 /**
  * ice_vsi_add_vlan - default add VLAN implementation for all VSI types
  * @vsi: VSI being configured
- * @vid: VLAN ID to be added
- * @action: filter action to be performed on match
+ * @vlan: VLAN filter to add
  */
-int
-ice_vsi_add_vlan(struct ice_vsi *vsi, u16 vid, enum ice_sw_fwd_act_type action)
+int ice_vsi_add_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 {
 	int err = 0;
 
-	if (!ice_fltr_add_vlan(vsi, vid, action)) {
+	if (!ice_fltr_add_vlan(vsi, vlan)) {
 		vsi->num_vlan++;
 	} else {
 		err = -ENODEV;
 		dev_err(ice_pf_to_dev(vsi->back), "Failure Adding VLAN %d on VSI %i\n",
-			vid, vsi->vsi_num);
+			vlan->vid, vsi->vsi_num);
 	}
 
 	return err;
@@ -31,9 +29,9 @@ ice_vsi_add_vlan(struct ice_vsi *vsi, u16 vid, enum ice_sw_fwd_act_type action)
 /**
  * ice_vsi_del_vlan - default del VLAN implementation for all VSI types
  * @vsi: VSI being configured
- * @vid: VLAN ID to be removed
+ * @vlan: VLAN filter to delete
  */
-int ice_vsi_del_vlan(struct ice_vsi *vsi, u16 vid)
+int ice_vsi_del_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 {
 	struct ice_pf *pf = vsi->back;
 	struct device *dev;
@@ -41,16 +39,16 @@ int ice_vsi_del_vlan(struct ice_vsi *vsi, u16 vid)
 
 	dev = ice_pf_to_dev(pf);
 
-	err = ice_fltr_remove_vlan(vsi, vid, ICE_FWD_TO_VSI);
+	err = ice_fltr_remove_vlan(vsi, vlan);
 	if (!err) {
 		vsi->num_vlan--;
 	} else if (err == -ENOENT) {
 		dev_dbg(dev, "Failed to remove VLAN %d on VSI %i, it does not exist\n",
-			vid, vsi->vsi_num);
+			vlan->vid, vsi->vsi_num);
 		err = 0;
 	} else {
 		dev_err(dev, "Error removing VLAN %d on VSI %i error: %d\n",
-			vid, vsi->vsi_num, err);
+			vlan->vid, vsi->vsi_num, err);
 	}
 
 	return err;
@@ -214,9 +212,16 @@ static int ice_vsi_manage_pvid(struct ice_vsi *vsi, u16 pvid_info, bool enable)
 	return ret;
 }
 
-int ice_vsi_set_port_vlan(struct ice_vsi *vsi, u16 pvid_info)
+int ice_vsi_set_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan)
 {
-	return ice_vsi_manage_pvid(vsi, pvid_info, true);
+	u16 port_vlan_info;
+
+	if (vlan->prio > 7)
+		return -EINVAL;
+
+	port_vlan_info = vlan->vid | (vlan->prio << VLAN_PRIO_SHIFT);
+
+	return ice_vsi_manage_pvid(vsi, port_vlan_info, true);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
index f9fe33026306..a0305007896c 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
@@ -5,19 +5,18 @@
 #define _ICE_VSI_VLAN_LIB_H_
 
 #include <linux/types.h>
-#include "ice_type.h"
+#include "ice_vlan.h"
 
 struct ice_vsi;
 
-int
-ice_vsi_add_vlan(struct ice_vsi *vsi, u16 vid, enum ice_sw_fwd_act_type action);
-int ice_vsi_del_vlan(struct ice_vsi *vsi, u16 vid);
+int ice_vsi_add_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
+int ice_vsi_del_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
 
 int ice_vsi_ena_stripping(struct ice_vsi *vsi);
 int ice_vsi_dis_stripping(struct ice_vsi *vsi);
 int ice_vsi_ena_insertion(struct ice_vsi *vsi);
 int ice_vsi_dis_insertion(struct ice_vsi *vsi);
-int ice_vsi_set_port_vlan(struct ice_vsi *vsi, u16 pvid_info);
+int ice_vsi_set_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
 
 int ice_vsi_ena_rx_vlan_filtering(struct ice_vsi *vsi);
 int ice_vsi_dis_rx_vlan_filtering(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
index 522169742661..c944f04acd3c 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
@@ -10,8 +10,8 @@
 struct ice_vsi;
 
 struct ice_vsi_vlan_ops {
-	int (*add_vlan)(struct ice_vsi *vsi, u16 vid, enum ice_sw_fwd_act_type action);
-	int (*del_vlan)(struct ice_vsi *vsi, u16 vid);
+	int (*add_vlan)(struct ice_vsi *vsi, struct ice_vlan *vlan);
+	int (*del_vlan)(struct ice_vsi *vsi, struct ice_vlan *vlan);
 	int (*ena_stripping)(struct ice_vsi *vsi);
 	int (*dis_stripping)(struct ice_vsi *vsi);
 	int (*ena_insertion)(struct ice_vsi *vsi);
@@ -20,7 +20,7 @@ struct ice_vsi_vlan_ops {
 	int (*dis_rx_filtering)(struct ice_vsi *vsi);
 	int (*ena_tx_filtering)(struct ice_vsi *vsi);
 	int (*dis_tx_filtering)(struct ice_vsi *vsi);
-	int (*set_port_vlan)(struct ice_vsi *vsi, u16 pvid_info);
+	int (*set_port_vlan)(struct ice_vsi *vsi, struct ice_vlan *vlan);
 };
 
 void ice_vsi_init_vlan_ops(struct ice_vsi *vsi);
-- 
2.31.1

