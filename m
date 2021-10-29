Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE37C440453
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhJ2Ut5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:49:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:9536 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230221AbhJ2Uts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:49:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="291587512"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="291587512"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 13:47:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="448483289"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 29 Oct 2021 13:47:17 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 1/7] ice: Remove boolean vlan_promisc flag from function
Date:   Fri, 29 Oct 2021 13:45:34 -0700
Message-Id: <20211029204540.3390007-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
References: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently, the vlan_promisc flag is used exclusively by VF VSI to
determine whether or not to toggle VLAN pruning along with
trusted/true-promiscuous mode. This is not needed for a couple of
reasons. First, trusted/true-promiscuous mode is only supposed to allow
all MAC filters within VLANs that a VF has added filters for, so VLAN
pruning should not be disabled. Second, the boolean argument makes the
function confusing and unintuitive. Remove this flag.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c         |  7 ++-----
 drivers/net/ethernet/intel/ice/ice_lib.h         |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c        | 12 ++++++------
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |  9 ++++++---
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 159c52b9b9d4..40562600a8cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2284,11 +2284,10 @@ bool ice_vsi_is_vlan_pruning_ena(struct ice_vsi *vsi)
  * ice_cfg_vlan_pruning - enable or disable VLAN pruning on the VSI
  * @vsi: VSI to enable or disable VLAN pruning on
  * @ena: set to true to enable VLAN pruning and false to disable it
- * @vlan_promisc: enable valid security flags if not in VLAN promiscuous mode
  *
  * returns 0 if VSI is updated, negative otherwise
  */
-int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena, bool vlan_promisc)
+int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena)
 {
 	struct ice_vsi_ctx *ctxt;
 	struct ice_pf *pf;
@@ -2316,9 +2315,7 @@ int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena, bool vlan_promisc)
 	else
 		ctxt->info.sw_flags2 &= ~ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
 
-	if (!vlan_promisc)
-		ctxt->info.valid_sections =
-			cpu_to_le16(ICE_AQ_VSI_PROP_SW_VALID);
+	ctxt->info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_SW_VALID);
 
 	status = ice_update_vsi(&pf->hw, vsi->idx, ctxt, NULL);
 	if (status) {
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index e7f4ecbb8549..6c803407b67d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -45,7 +45,7 @@ int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi);
 
 bool ice_vsi_is_vlan_pruning_ena(struct ice_vsi *vsi);
 
-int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena, bool vlan_promisc);
+int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena);
 
 void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 66112addfb9a..f099797f35e3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -396,7 +396,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 						~IFF_PROMISC;
 					goto out_promisc;
 				}
-				ice_cfg_vlan_pruning(vsi, false, false);
+				ice_cfg_vlan_pruning(vsi, false);
 			}
 		} else {
 			/* Clear Rx filter to remove traffic from wire */
@@ -410,7 +410,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 					goto out_promisc;
 				}
 				if (vsi->num_vlan > 1)
-					ice_cfg_vlan_pruning(vsi, true, false);
+					ice_cfg_vlan_pruning(vsi, true);
 			}
 		}
 	}
@@ -3387,7 +3387,7 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __always_unused __be16 proto,
 
 	/* Enable VLAN pruning when a VLAN other than 0 is added */
 	if (!ice_vsi_is_vlan_pruning_ena(vsi)) {
-		ret = ice_cfg_vlan_pruning(vsi, true, false);
+		ret = ice_cfg_vlan_pruning(vsi, true);
 		if (ret)
 			return ret;
 	}
@@ -3431,7 +3431,7 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
 
 	/* Disable pruning when VLAN 0 is the only VLAN rule */
 	if (vsi->num_vlan == 1 && ice_vsi_is_vlan_pruning_ena(vsi))
-		ret = ice_cfg_vlan_pruning(vsi, false, false);
+		ret = ice_cfg_vlan_pruning(vsi, false);
 
 	set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
 	return ret;
@@ -5616,10 +5616,10 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 
 	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    !(netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
-		ret = ice_cfg_vlan_pruning(vsi, true, false);
+		ret = ice_cfg_vlan_pruning(vsi, true);
 	else if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
-		ret = ice_cfg_vlan_pruning(vsi, false, false);
+		ret = ice_cfg_vlan_pruning(vsi, false);
 
 	if ((features & NETIF_F_NTUPLE) &&
 	    !(netdev->features & NETIF_F_NTUPLE)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 6a74344a3c21..2ac21484b876 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3072,7 +3072,10 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		}
 
-		ret = ice_cfg_vlan_pruning(vsi, true, !rm_promisc);
+		if (rm_promisc)
+			ret = ice_cfg_vlan_pruning(vsi, true);
+		else
+			ret = ice_cfg_vlan_pruning(vsi, false);
 		if (ret) {
 			dev_err(dev, "Failed to configure VLAN pruning in promiscuous mode\n");
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -4277,7 +4280,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 			/* Enable VLAN pruning when non-zero VLAN is added */
 			if (!vlan_promisc && vid &&
 			    !ice_vsi_is_vlan_pruning_ena(vsi)) {
-				status = ice_cfg_vlan_pruning(vsi, true, false);
+				status = ice_cfg_vlan_pruning(vsi, true);
 				if (status) {
 					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 					dev_err(dev, "Enable VLAN pruning on VLAN ID: %d failed error-%d\n",
@@ -4331,7 +4334,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 			/* Disable VLAN pruning when only VLAN 0 is left */
 			if (vsi->num_vlan == 1 &&
 			    ice_vsi_is_vlan_pruning_ena(vsi))
-				ice_cfg_vlan_pruning(vsi, false, false);
+				ice_cfg_vlan_pruning(vsi, false);
 
 			/* Disable Unicast/Multicast VLAN promiscuous mode */
 			if (vlan_promisc) {
-- 
2.31.1

