Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E44F0107A9C
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfKVW3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:29:31 -0500
Received: from mga07.intel.com ([134.134.136.100]:7936 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbfKVW3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:29:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:29:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409027337"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:29:08 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 04/15] ice: Don't modify stripping for add/del VLANs on VF
Date:   Fri, 22 Nov 2019 14:28:54 -0800
Message-Id: <20191122222905.670858-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
References: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when adding/deleting vlans in ice_vc_process_vlan_msg()
we are calling ice_vsi_manage_vlan_stripping() to enable/disable
when adding and deleting a VLAN respectively. This is wrong
because adding/deleting VLANs has nothing to do with configuring
VLAN stripping. VLAN stripping is configured through the
following VIRTCHNL operations:
	VIRTCHNL_OP_ENABLE_VLAN_STRIPPING
	VIRTCHNL_OP_DISABLE_VLAN_STRIPPING

Unfortunately we can't just remove this because then stripping
will never be configured on VF initialization. Fix this by
adding a new function that initializes (disables/enables) VLAN
stripping for the VF based on the device supported capabilities.
This allows us to remove the call to
ice_vsi_manage_vlan_stripping() in ice_vc_process_vlan_msg().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 39 +++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 3cb394bdfe51..fd419230a6c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2735,14 +2735,6 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 		goto error_param;
 	}
 
-	if (ice_vsi_manage_vlan_stripping(vsi, add_v)) {
-		dev_err(&pf->pdev->dev,
-			"%sable VLAN stripping failed for VSI %i\n",
-			 add_v ? "en" : "dis", vsi->vsi_num);
-		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		goto error_param;
-	}
-
 	if (test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states) ||
 	    test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
 		vlan_promisc = true;
@@ -2933,6 +2925,33 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
 				     v_ret, NULL, 0);
 }
 
+/**
+ * ice_vf_init_vlan_stripping - enable/disable VLAN stripping on initialization
+ * @vf: VF to enable/disable VLAN stripping for on initialization
+ *
+ * If the VIRTCHNL_VF_OFFLOAD_VLAN flag is set enable VLAN stripping, else if
+ * the flag is cleared then we want to disable stripping. For example, the flag
+ * will be cleared when port VLANs are configured by the administrator before
+ * passing the VF to the guest or if the AVF driver doesn't support VLAN
+ * offloads.
+ */
+static int ice_vf_init_vlan_stripping(struct ice_vf *vf)
+{
+	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
+
+	if (!vsi)
+		return -EINVAL;
+
+	/* don't modify stripping if port VLAN is configured */
+	if (vsi->info.pvid)
+		return 0;
+
+	if (ice_vf_vlan_offload_ena(vf->driver_caps))
+		return ice_vsi_manage_vlan_stripping(vsi, true);
+	else
+		return ice_vsi_manage_vlan_stripping(vsi, false);
+}
+
 /**
  * ice_vc_process_vf_msg - Process request from VF
  * @pf: pointer to the PF structure
@@ -2987,6 +3006,10 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		break;
 	case VIRTCHNL_OP_GET_VF_RESOURCES:
 		err = ice_vc_get_vf_res_msg(vf, msg);
+		if (ice_vf_init_vlan_stripping(vf))
+			dev_err(&pf->pdev->dev,
+				"Failed to initialize VLAN stripping for VF %d\n",
+				vf->vf_id);
 		ice_vc_notify_vf_link_state(vf);
 		break;
 	case VIRTCHNL_OP_RESET_VF:
-- 
2.23.0

