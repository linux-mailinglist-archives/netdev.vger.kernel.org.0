Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A3D15B2C4
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgBLVeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:34:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:42951 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbgBLVeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 16:34:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 13:34:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,434,1574150400"; 
   d="scan'208";a="233911677"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga003.jf.intel.com with ESMTP; 12 Feb 2020 13:34:00 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 01/15] ice: Fix DCB rebuild after reset
Date:   Wed, 12 Feb 2020 13:33:43 -0800
Message-Id: <20200212213357.2198911-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
References: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The function ice_dcb_rebuild had some logic
flaws in it, and also didn't differentiate
between FW and SW modes needs.

For FW flow, the willing setting was being
forced to OFF and left that way.  Unwilling
in DCB FW mode is not a supported model.

Leave the config alone and use the return value
from the set command to determine if setting the
config was successful.

The SW DCB flow does not need to need to register
for MIB change events (as they are not used in
SW mode).

Use !is_sw_lldp checks to only perform FW specific
task while in FW mode.

Also adding a reapplication of the current DCB
config after a link event.  Some NVMs are not
maintaining their DCB configs across link events.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 88 ++++++++------------
 drivers/net/ethernet/intel/ice/ice_main.c    |  1 +
 2 files changed, 36 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 0664e5b8d130..99ee4c009a96 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -315,9 +315,9 @@ ice_dcb_need_recfg(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
  */
 void ice_dcb_rebuild(struct ice_pf *pf)
 {
-	struct ice_dcbx_cfg *local_dcbx_cfg, *desired_dcbx_cfg, *prev_cfg;
 	struct ice_aqc_port_ets_elem buf = { 0 };
 	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_dcbx_cfg *err_cfg;
 	enum ice_status ret;
 
 	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
@@ -330,53 +330,25 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 	if (!test_bit(ICE_FLAG_DCB_ENA, pf->flags))
 		return;
 
-	local_dcbx_cfg = &pf->hw.port_info->local_dcbx_cfg;
-	desired_dcbx_cfg = &pf->hw.port_info->desired_dcbx_cfg;
+	mutex_lock(&pf->tc_mutex);
 
-	/* Save current willing state and force FW to unwilling */
-	local_dcbx_cfg->etscfg.willing = 0x0;
-	local_dcbx_cfg->pfc.willing = 0x0;
-	local_dcbx_cfg->app_mode = ICE_DCBX_APPS_NON_WILLING;
+	if (!pf->hw.port_info->is_sw_lldp)
+		ice_cfg_etsrec_defaults(pf->hw.port_info);
 
-	ice_cfg_etsrec_defaults(pf->hw.port_info);
 	ret = ice_set_dcb_cfg(pf->hw.port_info);
 	if (ret) {
-		dev_err(dev, "Failed to set DCB to unwilling\n");
+		dev_err(dev, "Failed to set DCB config in rebuild\n");
 		goto dcb_error;
 	}
 
-	/* Retrieve DCB config and ensure same as current in SW */
-	prev_cfg = kmemdup(local_dcbx_cfg, sizeof(*prev_cfg), GFP_KERNEL);
-	if (!prev_cfg)
-		goto dcb_error;
-
-	ice_init_dcb(&pf->hw, true);
-	if (pf->hw.port_info->dcbx_status == ICE_DCBX_STATUS_DIS)
-		pf->hw.port_info->is_sw_lldp = true;
-	else
-		pf->hw.port_info->is_sw_lldp = false;
-
-	if (ice_dcb_need_recfg(pf, prev_cfg, local_dcbx_cfg)) {
-		/* difference in cfg detected - disable DCB till next MIB */
-		dev_err(dev, "Set local MIB not accurate\n");
-		kfree(prev_cfg);
-		goto dcb_error;
+	if (!pf->hw.port_info->is_sw_lldp) {
+		ret = ice_cfg_lldp_mib_change(&pf->hw, true);
+		if (ret && !pf->hw.port_info->is_sw_lldp) {
+			dev_err(dev, "Failed to register for MIB changes\n");
+			goto dcb_error;
+		}
 	}
 
-	/* fetched config congruent to previous configuration */
-	kfree(prev_cfg);
-
-	/* Set the local desired config */
-	if (local_dcbx_cfg->dcbx_mode == ICE_DCBX_MODE_CEE)
-		memcpy(local_dcbx_cfg, desired_dcbx_cfg,
-		       sizeof(*local_dcbx_cfg));
-
-	ice_cfg_etsrec_defaults(pf->hw.port_info);
-	ret = ice_set_dcb_cfg(pf->hw.port_info);
-	if (ret) {
-		dev_err(dev, "Failed to set desired config\n");
-		goto dcb_error;
-	}
 	dev_info(dev, "DCB restored after reset\n");
 	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
 	if (ret) {
@@ -384,26 +356,32 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 		goto dcb_error;
 	}
 
+	mutex_unlock(&pf->tc_mutex);
+
 	return;
 
 dcb_error:
 	dev_err(dev, "Disabling DCB until new settings occur\n");
-	prev_cfg = kzalloc(sizeof(*prev_cfg), GFP_KERNEL);
-	if (!prev_cfg)
+	err_cfg = kzalloc(sizeof(*err_cfg), GFP_KERNEL);
+	if (!err_cfg) {
+		mutex_unlock(&pf->tc_mutex);
 		return;
+	}
 
-	prev_cfg->etscfg.willing = true;
-	prev_cfg->etscfg.tcbwtable[0] = ICE_TC_MAX_BW;
-	prev_cfg->etscfg.tsatable[0] = ICE_IEEE_TSA_ETS;
-	memcpy(&prev_cfg->etsrec, &prev_cfg->etscfg, sizeof(prev_cfg->etsrec));
+	err_cfg->etscfg.willing = true;
+	err_cfg->etscfg.tcbwtable[0] = ICE_TC_MAX_BW;
+	err_cfg->etscfg.tsatable[0] = ICE_IEEE_TSA_ETS;
+	memcpy(&err_cfg->etsrec, &err_cfg->etscfg, sizeof(err_cfg->etsrec));
 	/* Coverity warns the return code of ice_pf_dcb_cfg() is not checked
 	 * here as is done for other calls to that function. That check is
 	 * not necessary since this is in this function's error cleanup path.
 	 * Suppress the Coverity warning with the following comment...
 	 */
 	/* coverity[check_return] */
-	ice_pf_dcb_cfg(pf, prev_cfg, false);
-	kfree(prev_cfg);
+	ice_pf_dcb_cfg(pf, err_cfg, false);
+	kfree(err_cfg);
+
+	mutex_unlock(&pf->tc_mutex);
 }
 
 /**
@@ -777,6 +755,8 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 		}
 	}
 
+	mutex_lock(&pf->tc_mutex);
+
 	/* store the old configuration */
 	tmp_dcbx_cfg = pf->hw.port_info->local_dcbx_cfg;
 
@@ -787,20 +767,20 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	ret = ice_get_dcb_cfg(pf->hw.port_info);
 	if (ret) {
 		dev_err(dev, "Failed to get DCB config\n");
-		return;
+		goto out;
 	}
 
 	/* No change detected in DCBX configs */
 	if (!memcmp(&tmp_dcbx_cfg, &pi->local_dcbx_cfg, sizeof(tmp_dcbx_cfg))) {
 		dev_dbg(dev, "No change detected in DCBX configuration.\n");
-		return;
+		goto out;
 	}
 
 	need_reconfig = ice_dcb_need_recfg(pf, &tmp_dcbx_cfg,
 					   &pi->local_dcbx_cfg);
 	ice_dcbnl_flush_apps(pf, &tmp_dcbx_cfg, &pi->local_dcbx_cfg);
 	if (!need_reconfig)
-		return;
+		goto out;
 
 	/* Enable DCB tagging only when more than one TC */
 	if (ice_dcb_get_num_tc(&pi->local_dcbx_cfg) > 1) {
@@ -814,7 +794,7 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	pf_vsi = ice_get_main_vsi(pf);
 	if (!pf_vsi) {
 		dev_dbg(dev, "PF VSI doesn't exist\n");
-		return;
+		goto out;
 	}
 
 	rtnl_lock();
@@ -823,13 +803,15 @@ ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
 	if (ret) {
 		dev_err(dev, "Query Port ETS failed\n");
-		rtnl_unlock();
-		return;
+		goto unlock_rtnl;
 	}
 
 	/* changes in configuration update VSI */
 	ice_pf_dcb_recfg(pf);
 
 	ice_ena_vsi(pf_vsi, true);
+unlock_rtnl:
 	rtnl_unlock();
+out:
+	mutex_unlock(&pf->tc_mutex);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5ae671609f98..4075d5379b23 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -841,6 +841,7 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 		}
 	}
 
+	ice_dcb_rebuild(pf);
 	ice_vsi_link_event(vsi, link_up);
 	ice_print_link_msg(vsi, link_up);
 
-- 
2.24.1

