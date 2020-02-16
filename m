Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A92E316019A
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgBPDpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:45:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:33359 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBPDoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916577"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] ice: Refactor port vlan configuration for the VF
Date:   Sat, 15 Feb 2020 19:44:39 -0800
Message-Id: <20200216034452.1251706-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
References: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently ice_vsi_manage_pvid() calls
ice_vsi_[set|kill]_pvid_fill_ctxt() when enabling/disabling a port VLAN
on a VSI respectively. These two functions have some duplication so just
move their unique pieces inline in ice_vsi_manage_pvid() and then the
duplicate code can be reused for both the enabling/disabling paths.

Before this patch the info.pvid field was not being written
correctly via ice_vsi_kill_pvid_fill_ctxt() so it was being hard coded
to 0 in ice_set_vf_port_vlan(). Fix this by setting the info.pvid field
to 0 before calling ice_vsi_update() in ice_vsi_manage_pvid().

We currently use vf->port_vlan_id to keep track of the port VLAN
ID and QoS, which is a bit misleading. Fix this by renaming it to
vf->port_vlan_info. Also change the name of the argument for
ice_vsi_manage_pvid() from vid to pvid_info.

In ice_vsi_manage_pvid() only save the fields that were modified
in the VSI properties structure on success instead of the entire thing.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 86 ++++++++-----------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  2 +-
 2 files changed, 37 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a8178a73ccd1..82319597c48c 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -406,44 +406,16 @@ static void ice_trigger_vf_reset(struct ice_vf *vf, bool is_vflr, bool is_pfr)
 	}
 }
 
-/**
- * ice_vsi_set_pvid_fill_ctxt - Set VSI ctxt for add PVID
- * @ctxt: the VSI ctxt to fill
- * @vid: the VLAN ID to set as a PVID
- */
-static void ice_vsi_set_pvid_fill_ctxt(struct ice_vsi_ctx *ctxt, u16 vid)
-{
-	ctxt->info.vlan_flags = (ICE_AQ_VSI_VLAN_MODE_UNTAGGED |
-				 ICE_AQ_VSI_PVLAN_INSERT_PVID |
-				 ICE_AQ_VSI_VLAN_EMOD_STR);
-	ctxt->info.pvid = cpu_to_le16(vid);
-	ctxt->info.sw_flags2 |= ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
-	ctxt->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID |
-						ICE_AQ_VSI_PROP_SW_VALID);
-}
-
-/**
- * ice_vsi_kill_pvid_fill_ctxt - Set VSI ctx for remove PVID
- * @ctxt: the VSI ctxt to fill
- */
-static void ice_vsi_kill_pvid_fill_ctxt(struct ice_vsi_ctx *ctxt)
-{
-	ctxt->info.vlan_flags = ICE_AQ_VSI_VLAN_EMOD_NOTHING;
-	ctxt->info.vlan_flags |= ICE_AQ_VSI_VLAN_MODE_ALL;
-	ctxt->info.sw_flags2 &= ~ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
-	ctxt->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID |
-						ICE_AQ_VSI_PROP_SW_VALID);
-}
-
 /**
  * ice_vsi_manage_pvid - Enable or disable port VLAN for VSI
  * @vsi: the VSI to update
- * @vid: the VLAN ID to set as a PVID
+ * @pvid_info: VLAN ID and QoS used to set the PVID VSI context field
  * @enable: true for enable PVID false for disable
  */
-static int ice_vsi_manage_pvid(struct ice_vsi *vsi, u16 vid, bool enable)
+static int ice_vsi_manage_pvid(struct ice_vsi *vsi, u16 pvid_info, bool enable)
 {
 	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_aqc_vsi_props *info;
 	struct ice_vsi_ctx *ctxt;
 	enum ice_status status;
 	int ret = 0;
@@ -453,20 +425,33 @@ static int ice_vsi_manage_pvid(struct ice_vsi *vsi, u16 vid, bool enable)
 		return -ENOMEM;
 
 	ctxt->info = vsi->info;
-	if (enable)
-		ice_vsi_set_pvid_fill_ctxt(ctxt, vid);
-	else
-		ice_vsi_kill_pvid_fill_ctxt(ctxt);
+	info = &ctxt->info;
+	if (enable) {
+		info->vlan_flags = ICE_AQ_VSI_VLAN_MODE_UNTAGGED |
+			ICE_AQ_VSI_PVLAN_INSERT_PVID |
+			ICE_AQ_VSI_VLAN_EMOD_STR;
+		info->sw_flags2 |= ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
+	} else {
+		info->vlan_flags = ICE_AQ_VSI_VLAN_EMOD_NOTHING |
+			ICE_AQ_VSI_VLAN_MODE_ALL;
+		info->sw_flags2 &= ~ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
+	}
+
+	info->pvid = cpu_to_le16(pvid_info);
+	info->valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_VLAN_VALID |
+					   ICE_AQ_VSI_PROP_SW_VALID);
 
 	status = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
 	if (status) {
-		dev_info(ice_pf_to_dev(vsi->back), "update VSI for port VLAN failed, err %d aq_err %d\n",
+		dev_info(ice_hw_to_dev(hw), "update VSI for port VLAN failed, err %d aq_err %d\n",
 			 status, hw->adminq.sq_last_status);
 		ret = -EIO;
 		goto out;
 	}
 
-	vsi->info = ctxt->info;
+	vsi->info.vlan_flags = info->vlan_flags;
+	vsi->info.sw_flags2 = info->sw_flags2;
+	vsi->info.pvid = info->pvid;
 out:
 	kfree(ctxt);
 	return ret;
@@ -533,9 +518,9 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	vf->lan_vsi_num = vsi->vsi_num;
 
 	/* Check if port VLAN exist before, and restore it accordingly */
-	if (vf->port_vlan_id) {
-		ice_vsi_manage_pvid(vsi, vf->port_vlan_id, true);
-		ice_vsi_add_vlan(vsi, vf->port_vlan_id & ICE_VLAN_M);
+	if (vf->port_vlan_info) {
+		ice_vsi_manage_pvid(vsi, vf->port_vlan_info, true);
+		ice_vsi_add_vlan(vsi, vf->port_vlan_info & ICE_VLAN_M);
 	}
 
 	eth_broadcast_addr(broadcast);
@@ -985,13 +970,13 @@ ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m,
 	if (vsi->num_vlan) {
 		status = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_m,
 						  rm_promisc);
-	} else if (vf->port_vlan_id) {
+	} else if (vf->port_vlan_info) {
 		if (rm_promisc)
 			status = ice_clear_vsi_promisc(hw, vsi->idx, promisc_m,
-						       vf->port_vlan_id);
+						       vf->port_vlan_info);
 		else
 			status = ice_set_vsi_promisc(hw, vsi->idx, promisc_m,
-						     vf->port_vlan_id);
+						     vf->port_vlan_info);
 	} else {
 		if (rm_promisc)
 			status = ice_clear_vsi_promisc(hw, vsi->idx, promisc_m,
@@ -1231,7 +1216,7 @@ static bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	 */
 	if (test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states) ||
 	    test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states)) {
-		if (vf->port_vlan_id || vsi->num_vlan)
+		if (vf->port_vlan_info || vsi->num_vlan)
 			promisc_m = ICE_UCAST_VLAN_PROMISC_BITS;
 		else
 			promisc_m = ICE_UCAST_PROMISC_BITS;
@@ -2731,10 +2716,11 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	if (vlan_id || qos) {
 		ret = ice_vsi_manage_pvid(vsi, vlanprio, true);
 		if (ret)
-			goto error_set_pvid;
+			goto error_manage_pvid;
 	} else {
-		ice_vsi_manage_pvid(vsi, 0, false);
-		vsi->info.pvid = 0;
+		ret = ice_vsi_manage_pvid(vsi, 0, false);
+		if (ret)
+			goto error_manage_pvid;
 	}
 
 	if (vlan_id) {
@@ -2744,15 +2730,15 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		/* add new VLAN filter for each MAC */
 		ret = ice_vsi_add_vlan(vsi, vlan_id);
 		if (ret)
-			goto error_set_pvid;
+			goto error_manage_pvid;
 	}
 
 	/* The Port VLAN needs to be saved across resets the same as the
 	 * default LAN MAC address.
 	 */
-	vf->port_vlan_id = le16_to_cpu(vsi->info.pvid);
+	vf->port_vlan_info = le16_to_cpu(vsi->info.pvid);
 
-error_set_pvid:
+error_manage_pvid:
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 4647d636ed36..80bb1acc7c28 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -74,7 +74,7 @@ struct ice_vf {
 	struct virtchnl_ether_addr dflt_lan_addr;
 	DECLARE_BITMAP(txq_ena, ICE_MAX_BASE_QS_PER_VF);
 	DECLARE_BITMAP(rxq_ena, ICE_MAX_BASE_QS_PER_VF);
-	u16 port_vlan_id;
+	u16 port_vlan_info;		/* Port VLAN ID and QoS */
 	u8 pf_set_mac:1;		/* VF MAC address set by VMM admin */
 	u8 trusted:1;
 	u8 spoofchk:1;
-- 
2.24.1

