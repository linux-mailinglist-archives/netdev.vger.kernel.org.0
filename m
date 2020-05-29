Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB11B1E7116
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438004AbgE2AIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:08:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:37100 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437994AbgE2AIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:41 -0400
IronPort-SDR: XtpT9Y8LVOUR84EL6AJ5t7IwTC+YwAVEScHb9C8cJLU87kf8bJEcesCcH/nnn5aw035E9gawJW
 6ljES8CxFVkg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:35 -0700
IronPort-SDR: pK71kK7Qjpf2Mzv+gwScMfdIn4qko91UEKdZbVOP7F/b6tR/w9yzKFjESVM3PwcXlk+Nv5mzIR
 6eQ5ggqyY+0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651663"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/15] ice: Refactor VF VSI release and setup functions
Date:   Thu, 28 May 2020 17:08:31 -0700
Message-Id: <20200529000831.2803870-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when a VF VSI calls ice_vsi_release() and ice_vsi_setup() it
subsequently clears/sets the VF cached variables for lan_vsi_idx and
lan_vsi_num. This works fine, but can be improved by handling this in
the VF specific VSI release and setup functions.

Also, when a VF VSI is setup too many parameters are passed that can be
derived from the VF. Fix this by only calling VF VSI setup with the bare
minimum parameters.

Also, add functionality to invalidate a VF's VSI when it's released
and/or setup fails. This will make it so a VF VSI cannot be accessed via
its cached vsi_idx/vsi_num in these cases.

Finally when a VF's VSI is invalidated set the lan_vsi_idx and
lan_vsi_num to ICE_NO_VSI to clearly show that there is no valid VSI
associated with this VF.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 86 ++++++++++++-------
 1 file changed, 55 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 727f371db465..a126e7c7663d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -181,6 +181,26 @@ static void ice_vc_notify_vf_link_state(struct ice_vf *vf)
 			      sizeof(pfe), NULL);
 }
 
+/**
+ * ice_vf_invalidate_vsi - invalidate vsi_idx/vsi_num to remove VSI access
+ * @vf: VF to remove access to VSI for
+ */
+static void ice_vf_invalidate_vsi(struct ice_vf *vf)
+{
+	vf->lan_vsi_idx = ICE_NO_VSI;
+	vf->lan_vsi_num = ICE_NO_VSI;
+}
+
+/**
+ * ice_vf_vsi_release - invalidate the VF's VSI after freeing it
+ * @vf: invalidate this VF's VSI after freeing it
+ */
+static void ice_vf_vsi_release(struct ice_vf *vf)
+{
+	ice_vsi_release(vf->pf->vsi[vf->lan_vsi_idx]);
+	ice_vf_invalidate_vsi(vf);
+}
+
 /**
  * ice_free_vf_res - Free a VF's resources
  * @vf: pointer to the VF info
@@ -196,10 +216,8 @@ static void ice_free_vf_res(struct ice_vf *vf)
 	clear_bit(ICE_VF_STATE_INIT, vf->vf_states);
 
 	/* free VSI and disconnect it from the parent uplink */
-	if (vf->lan_vsi_idx) {
-		ice_vsi_release(pf->vsi[vf->lan_vsi_idx]);
-		vf->lan_vsi_idx = 0;
-		vf->lan_vsi_num = 0;
+	if (vf->lan_vsi_idx != ICE_NO_VSI) {
+		ice_vf_vsi_release(vf);
 		vf->num_mac = 0;
 	}
 
@@ -505,19 +523,40 @@ static int ice_vsi_manage_pvid(struct ice_vsi *vsi, u16 pvid_info, bool enable)
 	return ret;
 }
 
+/**
+ * ice_vf_get_port_info - Get the VF's port info structure
+ * @vf: VF used to get the port info structure for
+ */
+static struct ice_port_info *ice_vf_get_port_info(struct ice_vf *vf)
+{
+	return vf->pf->hw.port_info;
+}
+
 /**
  * ice_vf_vsi_setup - Set up a VF VSI
- * @pf: board private structure
- * @pi: pointer to the port_info instance
- * @vf_id: defines VF ID to which this VSI connects.
+ * @vf: VF to setup VSI for
  *
  * Returns pointer to the successfully allocated VSI struct on success,
  * otherwise returns NULL on failure.
  */
-static struct ice_vsi *
-ice_vf_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi, u16 vf_id)
+static struct ice_vsi *ice_vf_vsi_setup(struct ice_vf *vf)
 {
-	return ice_vsi_setup(pf, pi, ICE_VSI_VF, vf_id);
+	struct ice_port_info *pi = ice_vf_get_port_info(vf);
+	struct ice_pf *pf = vf->pf;
+	struct ice_vsi *vsi;
+
+	vsi = ice_vsi_setup(pf, pi, ICE_VSI_VF, vf->vf_id);
+
+	if (!vsi) {
+		dev_err(ice_pf_to_dev(pf), "Failed to create VF VSI\n");
+		ice_vf_invalidate_vsi(vf);
+		return NULL;
+	}
+
+	vf->lan_vsi_idx = vsi->idx;
+	vf->lan_vsi_num = vsi->vsi_num;
+
+	return vsi;
 }
 
 /**
@@ -1043,19 +1082,9 @@ static void ice_vf_rebuild_host_cfg(struct ice_vf *vf)
  */
 static int ice_vf_rebuild_vsi_with_release(struct ice_vf *vf)
 {
-	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi;
-
-	vsi = pf->vsi[vf->lan_vsi_idx];
-	ice_vsi_release(vsi);
-	vsi = ice_vf_vsi_setup(pf, pf->hw.port_info, vf->vf_id);
-	if (!vsi) {
-		dev_err(ice_pf_to_dev(pf), "Failed to create VF VSI\n");
+	ice_vf_vsi_release(vf);
+	if (!ice_vf_vsi_setup(vf))
 		return -ENOMEM;
-	}
-
-	vf->lan_vsi_idx = vsi->idx;
-	vf->lan_vsi_num = vsi->vsi_num;
 
 	return 0;
 }
@@ -1395,14 +1424,9 @@ static int ice_init_vf_vsi_res(struct ice_vf *vf)
 	vf->first_vector_idx = ice_calc_vf_first_vector_idx(pf, vf);
 
 	dev = ice_pf_to_dev(pf);
-	vsi = ice_vf_vsi_setup(pf, pf->hw.port_info, vf->vf_id);
-	if (!vsi) {
-		dev_err(dev, "Failed to create VF VSI\n");
+	vsi = ice_vf_vsi_setup(vf);
+	if (!vsi)
 		return -ENOMEM;
-	}
-
-	vf->lan_vsi_idx = vsi->idx;
-	vf->lan_vsi_num = vsi->vsi_num;
 
 	err = ice_vsi_add_vlan(vsi, 0, ICE_FWD_TO_VSI);
 	if (err) {
@@ -1425,7 +1449,7 @@ static int ice_init_vf_vsi_res(struct ice_vf *vf)
 	return 0;
 
 release_vsi:
-	ice_vsi_release(vsi);
+	ice_vf_vsi_release(vf);
 	return err;
 }
 
@@ -1463,7 +1487,7 @@ static int ice_start_vfs(struct ice_pf *pf)
 		struct ice_vf *vf = &pf->vf[i];
 
 		ice_dis_vf_mappings(vf);
-		ice_vsi_release(pf->vsi[vf->lan_vsi_idx]);
+		ice_vf_vsi_release(vf);
 	}
 
 	return retval;
-- 
2.26.2

