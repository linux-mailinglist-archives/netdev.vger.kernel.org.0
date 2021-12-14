Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DD5474B5E
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbhLNTAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:00:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:50829 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237264AbhLNTAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 14:00:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639508411; x=1671044411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hnDm9IAI7ZRo6bHrimlXjwM6SweOUhnu5eazKJJ9OHg=;
  b=Z8Eq6btBiWjERSGyBGomARb/EVsYC1ayrVaHCj4ur1yYU0mkB5q+L+4H
   LBE9tV5ipO0TYoNQhSqgbHnjqah97/qCFDWhMCKn6BpiBBXVIms8j0K/2
   gC4pmcB3Ui/7ZVroO950RZ9zW9Q9ymIJjctlL2DI4lsY005UciNqkrTaW
   P3fy9q7bhQ1KzJ6TEeKEB5dYshNm+yLV3rCjcsdt67iB5LIcDYjamDv7V
   J3wQPGFeGK6xs2sUmm4EHjjXeTGBwHNkdc3CIBuhEq5cfBeOK0nGiQQuO
   igPdEV6wPTWKciWtQg5THIxhloLJkdRMzMl6Vh6IdOiobVbQRMKqqSr3s
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="263200024"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="263200024"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 10:30:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="583712741"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2021 10:30:07 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 03/12] ice: Refactor promiscuous functions
Date:   Tue, 14 Dec 2021 10:28:59 -0800
Message-Id: <20211214182908.1513343-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
References: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Some of the promiscuous mode functions take a boolean to indicate
set/clear, which affects readability. Refactor and provide an
interface for the promiscuous mode code with explicit set and clear
promiscuous mode operations.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c     |  58 ++++++++
 drivers/net/ethernet/intel/ice/ice_fltr.h     |  12 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |  49 +++---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 139 +++++++-----------
 4 files changed, 156 insertions(+), 102 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index c2e78eaf4ccb..e12c9810830b 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -46,6 +46,64 @@ ice_fltr_add_entry_to_list(struct device *dev, struct ice_fltr_info *info,
 	return 0;
 }
 
+/**
+ * ice_fltr_set_vlan_vsi_promisc
+ * @hw: pointer to the hardware structure
+ * @vsi: the VSI being configured
+ * @promisc_mask: mask of promiscuous config bits
+ *
+ * Set VSI with all associated VLANs to given promiscuous mode(s)
+ */
+enum ice_status
+ice_fltr_set_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
+			      u8 promisc_mask)
+{
+	return ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, false);
+}
+
+/**
+ * ice_fltr_clear_vlan_vsi_promisc
+ * @hw: pointer to the hardware structure
+ * @vsi: the VSI being configured
+ * @promisc_mask: mask of promiscuous config bits
+ *
+ * Clear VSI with all associated VLANs to given promiscuous mode(s)
+ */
+enum ice_status
+ice_fltr_clear_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
+				u8 promisc_mask)
+{
+	return ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, true);
+}
+
+/**
+ * ice_fltr_clear_vsi_promisc - clear specified promiscuous mode(s)
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: VSI handle to clear mode
+ * @promisc_mask: mask of promiscuous config bits to clear
+ * @vid: VLAN ID to clear VLAN promiscuous
+ */
+enum ice_status
+ice_fltr_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
+			   u16 vid)
+{
+	return ice_clear_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+}
+
+/**
+ * ice_fltr_set_vsi_promisc - set given VSI to given promiscuous mode(s)
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: VSI handle to configure
+ * @promisc_mask: mask of promiscuous config bits
+ * @vid: VLAN ID to set VLAN promiscuous
+ */
+enum ice_status
+ice_fltr_set_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
+			 u16 vid)
+{
+	return ice_set_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+}
+
 /**
  * ice_fltr_add_mac_list - add list of MAC filters
  * @vsi: pointer to VSI struct
diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.h b/drivers/net/ethernet/intel/ice/ice_fltr.h
index 8eec4febead1..6cf398a84009 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.h
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.h
@@ -6,6 +6,18 @@
 
 void ice_fltr_free_list(struct device *dev, struct list_head *h);
 enum ice_status
+ice_fltr_set_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
+			      u8 promisc_mask);
+enum ice_status
+ice_fltr_clear_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
+				u8 promisc_mask);
+enum ice_status
+ice_fltr_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
+			   u16 vid);
+enum ice_status
+ice_fltr_set_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
+			 u16 vid);
+enum ice_status
 ice_fltr_add_mac_to_list(struct ice_vsi *vsi, struct list_head *list,
 			 const u8 *mac, enum ice_sw_fwd_act_type action);
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a3ce54a78859..07a243d2ba91 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -237,32 +237,45 @@ static bool ice_vsi_fltr_changed(struct ice_vsi *vsi)
 }
 
 /**
- * ice_cfg_promisc - Enable or disable promiscuous mode for a given PF
+ * ice_set_promisc - Enable promiscuous mode for a given PF
  * @vsi: the VSI being configured
  * @promisc_m: mask of promiscuous config bits
- * @set_promisc: enable or disable promisc flag request
  *
  */
-static int ice_cfg_promisc(struct ice_vsi *vsi, u8 promisc_m, bool set_promisc)
+static int ice_set_promisc(struct ice_vsi *vsi, u8 promisc_m)
 {
-	struct ice_hw *hw = &vsi->back->hw;
-	enum ice_status status = 0;
+	enum ice_status status;
 
 	if (vsi->type != ICE_VSI_PF)
 		return 0;
 
-	if (vsi->num_vlan > 1) {
-		status = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_m,
-						  set_promisc);
-	} else {
-		if (set_promisc)
-			status = ice_set_vsi_promisc(hw, vsi->idx, promisc_m,
-						     0);
-		else
-			status = ice_clear_vsi_promisc(hw, vsi->idx, promisc_m,
-						       0);
-	}
+	if (vsi->num_vlan > 1)
+		status = ice_fltr_set_vlan_vsi_promisc(&vsi->back->hw, vsi, promisc_m);
+	else
+		status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m, 0);
+	if (status)
+		return -EIO;
+
+	return 0;
+}
 
+/**
+ * ice_clear_promisc - Disable promiscuous mode for a given PF
+ * @vsi: the VSI being configured
+ * @promisc_m: mask of promiscuous config bits
+ *
+ */
+static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
+{
+	enum ice_status status;
+
+	if (vsi->type != ICE_VSI_PF)
+		return 0;
+
+	if (vsi->num_vlan > 1)
+		status = ice_fltr_clear_vlan_vsi_promisc(&vsi->back->hw, vsi, promisc_m);
+	else
+		status = ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m, 0);
 	if (status)
 		return -EIO;
 
@@ -358,7 +371,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 			else
 				promisc_m = ICE_MCAST_PROMISC_BITS;
 
-			err = ice_cfg_promisc(vsi, promisc_m, true);
+			err = ice_set_promisc(vsi, promisc_m);
 			if (err) {
 				netdev_err(netdev, "Error setting Multicast promiscuous mode on VSI %i\n",
 					   vsi->vsi_num);
@@ -372,7 +385,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 			else
 				promisc_m = ICE_MCAST_PROMISC_BITS;
 
-			err = ice_cfg_promisc(vsi, promisc_m, false);
+			err = ice_clear_promisc(vsi, promisc_m);
 			if (err) {
 				netdev_err(netdev, "Error clearing Multicast promiscuous mode on VSI %i\n",
 					   vsi->vsi_num);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 596d354f714e..8a1a3364298f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -202,37 +202,6 @@ static int ice_check_vf_init(struct ice_pf *pf, struct ice_vf *vf)
 	return 0;
 }
 
-/**
- * ice_err_to_virt_err - translate errors for VF return code
- * @ice_err: error return code
- */
-static enum virtchnl_status_code ice_err_to_virt_err(enum ice_status ice_err)
-{
-	switch (ice_err) {
-	case ICE_SUCCESS:
-		return VIRTCHNL_STATUS_SUCCESS;
-	case ICE_ERR_BAD_PTR:
-	case ICE_ERR_INVAL_SIZE:
-	case ICE_ERR_DEVICE_NOT_SUPPORTED:
-	case ICE_ERR_PARAM:
-	case ICE_ERR_CFG:
-		return VIRTCHNL_STATUS_ERR_PARAM;
-	case ICE_ERR_NO_MEMORY:
-		return VIRTCHNL_STATUS_ERR_NO_MEMORY;
-	case ICE_ERR_NOT_READY:
-	case ICE_ERR_RESET_FAILED:
-	case ICE_ERR_FW_API_VER:
-	case ICE_ERR_AQ_ERROR:
-	case ICE_ERR_AQ_TIMEOUT:
-	case ICE_ERR_AQ_FULL:
-	case ICE_ERR_AQ_NO_WORK:
-	case ICE_ERR_AQ_EMPTY:
-		return VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
-	default:
-		return VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
-	}
-}
-
 /**
  * ice_vc_vf_broadcast - Broadcast a message to all VFs on PF
  * @pf: pointer to the PF structure
@@ -1255,45 +1224,50 @@ static void ice_clear_vf_reset_trigger(struct ice_vf *vf)
 	ice_flush(hw);
 }
 
-/**
- * ice_vf_set_vsi_promisc - set given VF VSI to given promiscuous mode(s)
- * @vf: pointer to the VF info
- * @vsi: the VSI being configured
- * @promisc_m: mask of promiscuous config bits
- * @rm_promisc: promisc flag request from the VF to remove or add filter
- *
- * This function configures VF VSI promiscuous mode, based on the VF requests,
- * for Unicast, Multicast and VLAN
- */
-static enum ice_status
-ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m,
-		       bool rm_promisc)
+static int
+ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
 {
-	struct ice_pf *pf = vf->pf;
-	enum ice_status status = 0;
-	struct ice_hw *hw;
+	struct ice_hw *hw = &vsi->back->hw;
+	enum ice_status status;
 
-	hw = &pf->hw;
-	if (vsi->num_vlan) {
-		status = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_m,
-						  rm_promisc);
-	} else if (vf->port_vlan_info) {
-		if (rm_promisc)
-			status = ice_clear_vsi_promisc(hw, vsi->idx, promisc_m,
-						       vf->port_vlan_info);
-		else
-			status = ice_set_vsi_promisc(hw, vsi->idx, promisc_m,
-						     vf->port_vlan_info);
-	} else {
-		if (rm_promisc)
-			status = ice_clear_vsi_promisc(hw, vsi->idx, promisc_m,
-						       0);
-		else
-			status = ice_set_vsi_promisc(hw, vsi->idx, promisc_m,
-						     0);
+	if (vf->port_vlan_info)
+		status = ice_fltr_set_vsi_promisc(hw, vsi->idx, promisc_m,
+						  vf->port_vlan_info & VLAN_VID_MASK);
+	else if (vsi->num_vlan > 1)
+		status = ice_fltr_set_vlan_vsi_promisc(hw, vsi, promisc_m);
+	else
+		status = ice_fltr_set_vsi_promisc(hw, vsi->idx, promisc_m, 0);
+
+	if (status && status != ICE_ERR_ALREADY_EXISTS) {
+		dev_err(ice_pf_to_dev(vsi->back), "enable Tx/Rx filter promiscuous mode on VF-%u failed, error: %s\n",
+			vf->vf_id, ice_stat_str(status));
+		return ice_status_to_errno(status);
+	}
+
+	return 0;
+}
+
+static int
+ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	enum ice_status status;
+
+	if (vf->port_vlan_info)
+		status = ice_fltr_clear_vsi_promisc(hw, vsi->idx, promisc_m,
+						    vf->port_vlan_info & VLAN_VID_MASK);
+	else if (vsi->num_vlan > 1)
+		status = ice_fltr_clear_vlan_vsi_promisc(hw, vsi, promisc_m);
+	else
+		status = ice_fltr_clear_vsi_promisc(hw, vsi->idx, promisc_m, 0);
+
+	if (status && status != ICE_ERR_DOES_NOT_EXIST) {
+		dev_err(ice_pf_to_dev(vsi->back), "disable Tx/Rx filter promiscuous mode on VF-%u failed, error: %s\n",
+			vf->vf_id, ice_stat_str(status));
+		return ice_status_to_errno(status);
 	}
 
-	return status;
+	return 0;
 }
 
 static void ice_vf_clear_counters(struct ice_vf *vf)
@@ -1657,7 +1631,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 		else
 			promisc_m = ICE_UCAST_PROMISC_BITS;
 
-		if (ice_vf_set_vsi_promisc(vf, vsi, promisc_m, true))
+		if (ice_vf_clear_vsi_promisc(vf, vsi, promisc_m))
 			dev_err(dev, "disabling promiscuous mode failed\n");
 	}
 
@@ -3026,10 +3000,10 @@ bool ice_is_any_vf_in_promisc(struct ice_pf *pf)
 static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	enum ice_status mcast_status = 0, ucast_status = 0;
 	bool rm_promisc, alluni = false, allmulti = false;
 	struct virtchnl_promisc_info *info =
 	    (struct virtchnl_promisc_info *)msg;
+	int mcast_err = 0, ucast_err = 0;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 	struct device *dev;
@@ -3111,24 +3085,21 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 			ucast_m = ICE_UCAST_PROMISC_BITS;
 		}
 
-		ucast_status = ice_vf_set_vsi_promisc(vf, vsi, ucast_m,
-						      !alluni);
-		if (ucast_status) {
-			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed\n",
-				alluni ? "en" : "dis", vf->vf_id);
-			v_ret = ice_err_to_virt_err(ucast_status);
-		}
+		if (alluni)
+			ucast_err = ice_vf_set_vsi_promisc(vf, vsi, ucast_m);
+		else
+			ucast_err = ice_vf_clear_vsi_promisc(vf, vsi, ucast_m);
 
-		mcast_status = ice_vf_set_vsi_promisc(vf, vsi, mcast_m,
-						      !allmulti);
-		if (mcast_status) {
-			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed\n",
-				allmulti ? "en" : "dis", vf->vf_id);
-			v_ret = ice_err_to_virt_err(mcast_status);
-		}
+		if (allmulti)
+			mcast_err = ice_vf_set_vsi_promisc(vf, vsi, mcast_m);
+		else
+			mcast_err = ice_vf_clear_vsi_promisc(vf, vsi, mcast_m);
+
+		if (ucast_err || mcast_err)
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 	}
 
-	if (!mcast_status) {
+	if (!mcast_err) {
 		if (allmulti &&
 		    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
 			dev_info(dev, "VF %u successfully set multicast promiscuous mode\n",
@@ -3138,7 +3109,7 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 				 vf->vf_id);
 	}
 
-	if (!ucast_status) {
+	if (!ucast_err) {
 		if (alluni && !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
 			dev_info(dev, "VF %u successfully set unicast promiscuous mode\n",
 				 vf->vf_id);
-- 
2.31.1

