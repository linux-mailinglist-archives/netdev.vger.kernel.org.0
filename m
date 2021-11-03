Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A5844460E
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhKCQlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:41:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:30954 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232860AbhKCQlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:41:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="255168199"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="255168199"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 09:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="497645552"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 03 Nov 2021 09:21:09 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net v2 1/5] ice: Fix VF true promiscuous mode
Date:   Wed,  3 Nov 2021 09:19:31 -0700
Message-Id: <20211103161935.2997369-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
References: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

When a VF requests promiscuous mode and it's trusted and true promiscuous
mode is enabled the PF driver attempts to enable unicast and/or
multicast promiscuous mode filters based on the request. This is fine,
but there are a couple issues with the current code.

[1] The define to configure the unicast promiscuous mode mask also
    includes bits to configure the multicast promiscuous mode mask, which
    causes multicast to be set/cleared unintentionally.
[2] All 4 cases for enable/disable unicast/multicast mode are not
    handled in the promiscuous mode message handler, which causes
    unexpected results regarding the current promiscuous mode settings.

To fix [1] make sure any promiscuous mask defines include the correct
bits for each of the promiscuous modes.

To fix [2] make sure that all 4 cases are handled since there are 2 bits
(FLAG_VF_UNICAST_PROMISC and FLAG_VF_MULTICAST_PROMISC) that can be
either set or cleared. Also, since either unicast and/or multicast
promiscuous configuration can fail, introduce two separate error values
to handle each of these cases.

Fixes: 01b5e89aab49 ("ice: Add VF promiscuous support")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  5 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 78 +++++++++----------
 2 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index bf4ecd9a517c..b2db39ee5f85 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -165,13 +165,10 @@
 #define ice_for_each_chnl_tc(i)	\
 	for ((i) = ICE_CHNL_START_TC; (i) < ICE_CHNL_MAX_TC; (i)++)
 
-#define ICE_UCAST_PROMISC_BITS (ICE_PROMISC_UCAST_TX | ICE_PROMISC_MCAST_TX | \
-				ICE_PROMISC_UCAST_RX | ICE_PROMISC_MCAST_RX)
+#define ICE_UCAST_PROMISC_BITS (ICE_PROMISC_UCAST_TX | ICE_PROMISC_UCAST_RX)
 
 #define ICE_UCAST_VLAN_PROMISC_BITS (ICE_PROMISC_UCAST_TX | \
-				     ICE_PROMISC_MCAST_TX | \
 				     ICE_PROMISC_UCAST_RX | \
-				     ICE_PROMISC_MCAST_RX | \
 				     ICE_PROMISC_VLAN_TX  | \
 				     ICE_PROMISC_VLAN_RX)
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 2ac21484b876..9b699419c933 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3013,6 +3013,7 @@ bool ice_is_any_vf_in_promisc(struct ice_pf *pf)
 static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	enum ice_status mcast_status = 0, ucast_status = 0;
 	bool rm_promisc, alluni = false, allmulti = false;
 	struct virtchnl_promisc_info *info =
 	    (struct virtchnl_promisc_info *)msg;
@@ -3105,52 +3106,51 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 			goto error_param;
 		}
 	} else {
-		enum ice_status status;
-		u8 promisc_m;
-
-		if (alluni) {
-			if (vf->port_vlan_info || vsi->num_vlan)
-				promisc_m = ICE_UCAST_VLAN_PROMISC_BITS;
-			else
-				promisc_m = ICE_UCAST_PROMISC_BITS;
-		} else if (allmulti) {
-			if (vf->port_vlan_info || vsi->num_vlan)
-				promisc_m = ICE_MCAST_VLAN_PROMISC_BITS;
-			else
-				promisc_m = ICE_MCAST_PROMISC_BITS;
+		u8 mcast_m, ucast_m;
+
+		if (vf->port_vlan_info || vsi->num_vlan > 1) {
+			mcast_m = ICE_MCAST_VLAN_PROMISC_BITS;
+			ucast_m = ICE_UCAST_VLAN_PROMISC_BITS;
 		} else {
-			if (vf->port_vlan_info || vsi->num_vlan)
-				promisc_m = ICE_UCAST_VLAN_PROMISC_BITS;
-			else
-				promisc_m = ICE_UCAST_PROMISC_BITS;
+			mcast_m = ICE_MCAST_PROMISC_BITS;
+			ucast_m = ICE_UCAST_PROMISC_BITS;
 		}
 
-		/* Configure multicast/unicast with or without VLAN promiscuous
-		 * mode
-		 */
-		status = ice_vf_set_vsi_promisc(vf, vsi, promisc_m, rm_promisc);
-		if (status) {
-			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed, error: %s\n",
-				rm_promisc ? "dis" : "en", vf->vf_id,
-				ice_stat_str(status));
-			v_ret = ice_err_to_virt_err(status);
-			goto error_param;
-		} else {
-			dev_dbg(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d succeeded\n",
-				rm_promisc ? "dis" : "en", vf->vf_id);
+		ucast_status = ice_vf_set_vsi_promisc(vf, vsi, ucast_m,
+						      !alluni);
+		if (ucast_status) {
+			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed\n",
+				alluni ? "en" : "dis", vf->vf_id);
+			v_ret = ice_err_to_virt_err(ucast_status);
+		}
+
+		mcast_status = ice_vf_set_vsi_promisc(vf, vsi, mcast_m,
+						      !allmulti);
+		if (mcast_status) {
+			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed\n",
+				allmulti ? "en" : "dis", vf->vf_id);
+			v_ret = ice_err_to_virt_err(mcast_status);
 		}
 	}
 
-	if (allmulti &&
-	    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
-		dev_info(dev, "VF %u successfully set multicast promiscuous mode\n", vf->vf_id);
-	else if (!allmulti && test_and_clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
-		dev_info(dev, "VF %u successfully unset multicast promiscuous mode\n", vf->vf_id);
+	if (!mcast_status) {
+		if (allmulti &&
+		    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully set multicast promiscuous mode\n",
+				 vf->vf_id);
+		else if (!allmulti && test_and_clear_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully unset multicast promiscuous mode\n",
+				 vf->vf_id);
+	}
 
-	if (alluni && !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
-		dev_info(dev, "VF %u successfully set unicast promiscuous mode\n", vf->vf_id);
-	else if (!alluni && test_and_clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
-		dev_info(dev, "VF %u successfully unset unicast promiscuous mode\n", vf->vf_id);
+	if (!ucast_status) {
+		if (alluni && !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully set unicast promiscuous mode\n",
+				 vf->vf_id);
+		else if (!alluni && test_and_clear_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
+			dev_info(dev, "VF %u successfully unset unicast promiscuous mode\n",
+				 vf->vf_id);
+	}
 
 error_param:
 	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
-- 
2.31.1

