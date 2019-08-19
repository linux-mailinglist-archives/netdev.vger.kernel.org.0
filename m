Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E7C949AA
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfHSQRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:17:35 -0400
Received: from mga17.intel.com ([192.55.52.151]:22455 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbfHSQRQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:17:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 09:17:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="207052953"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 19 Aug 2019 09:17:16 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Usha Ketineni <usha.k.ketineni@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 06/14] ice: Fix kernel hang with DCB reset in CEE mode
Date:   Mon, 19 Aug 2019 09:17:00 -0700
Message-Id: <20190819161708.3763-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190819161708.3763-1-jeffrey.t.kirsher@intel.com>
References: <20190819161708.3763-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Usha Ketineni <usha.k.ketineni@intel.com>

This patch fixes the set local MIB AQ call failures in the DCB rebuild path
by setting the defaults for the ETS recommended DCB configuration. Also,
willing bits for the DCB configuration needs to be set correctly. Resets
works fine in IEEE mode as the ETS recommended DCB configuration is
populated but not in CEE mode.
Without this patch, PFR causes the kernel hang in CEE mode.

Signed-off-by: Usha Ketineni <usha.k.ketineni@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 149 +++++++++++--------
 1 file changed, 88 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index fe88b127ca42..bf6cd4760a48 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -203,16 +203,87 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 	return ret;
 }
 
+/**
+ * ice_cfg_etsrec_defaults - Set default ETS recommended DCB config
+ * @pi: port information structure
+ */
+static void ice_cfg_etsrec_defaults(struct ice_port_info *pi)
+{
+	struct ice_dcbx_cfg *dcbcfg = &pi->local_dcbx_cfg;
+	u8 i;
+
+	/* Ensure ETS recommended DCB configuration is not already set */
+	if (dcbcfg->etsrec.maxtcs)
+		return;
+
+	/* In CEE mode, set the default to 1 TC */
+	dcbcfg->etsrec.maxtcs = 1;
+	for (i = 0; i < ICE_MAX_TRAFFIC_CLASS; i++) {
+		dcbcfg->etsrec.tcbwtable[i] = i ? 0 : 100;
+		dcbcfg->etsrec.tsatable[i] = i ? ICE_IEEE_TSA_STRICT :
+						 ICE_IEEE_TSA_ETS;
+	}
+}
+
+/**
+ * ice_dcb_need_recfg - Check if DCB needs reconfig
+ * @pf: board private structure
+ * @old_cfg: current DCB config
+ * @new_cfg: new DCB config
+ */
+static bool
+ice_dcb_need_recfg(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
+		   struct ice_dcbx_cfg *new_cfg)
+{
+	bool need_reconfig = false;
+
+	/* Check if ETS configuration has changed */
+	if (memcmp(&new_cfg->etscfg, &old_cfg->etscfg,
+		   sizeof(new_cfg->etscfg))) {
+		/* If Priority Table has changed reconfig is needed */
+		if (memcmp(&new_cfg->etscfg.prio_table,
+			   &old_cfg->etscfg.prio_table,
+			   sizeof(new_cfg->etscfg.prio_table))) {
+			need_reconfig = true;
+			dev_dbg(&pf->pdev->dev, "ETS UP2TC changed.\n");
+		}
+
+		if (memcmp(&new_cfg->etscfg.tcbwtable,
+			   &old_cfg->etscfg.tcbwtable,
+			   sizeof(new_cfg->etscfg.tcbwtable)))
+			dev_dbg(&pf->pdev->dev, "ETS TC BW Table changed.\n");
+
+		if (memcmp(&new_cfg->etscfg.tsatable,
+			   &old_cfg->etscfg.tsatable,
+			   sizeof(new_cfg->etscfg.tsatable)))
+			dev_dbg(&pf->pdev->dev, "ETS TSA Table changed.\n");
+	}
+
+	/* Check if PFC configuration has changed */
+	if (memcmp(&new_cfg->pfc, &old_cfg->pfc, sizeof(new_cfg->pfc))) {
+		need_reconfig = true;
+		dev_dbg(&pf->pdev->dev, "PFC config change detected.\n");
+	}
+
+	/* Check if APP Table has changed */
+	if (memcmp(&new_cfg->app, &old_cfg->app, sizeof(new_cfg->app))) {
+		need_reconfig = true;
+		dev_dbg(&pf->pdev->dev, "APP Table change detected.\n");
+	}
+
+	dev_dbg(&pf->pdev->dev, "dcb need_reconfig=%d\n", need_reconfig);
+	return need_reconfig;
+}
+
 /**
  * ice_dcb_rebuild - rebuild DCB post reset
  * @pf: physical function instance
  */
 void ice_dcb_rebuild(struct ice_pf *pf)
 {
+	struct ice_dcbx_cfg *local_dcbx_cfg, *desired_dcbx_cfg, *prev_cfg;
 	struct ice_aqc_port_ets_elem buf = { 0 };
-	struct ice_dcbx_cfg *prev_cfg;
 	enum ice_status ret;
-	u8 willing;
 
 	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
 	if (ret) {
@@ -224,9 +295,15 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 	if (!test_bit(ICE_FLAG_DCB_ENA, pf->flags))
 		return;
 
+	local_dcbx_cfg = &pf->hw.port_info->local_dcbx_cfg;
+	desired_dcbx_cfg = &pf->hw.port_info->desired_dcbx_cfg;
+
 	/* Save current willing state and force FW to unwilling */
-	willing = pf->hw.port_info->local_dcbx_cfg.etscfg.willing;
-	pf->hw.port_info->local_dcbx_cfg.etscfg.willing = 0x0;
+	local_dcbx_cfg->etscfg.willing = 0x0;
+	local_dcbx_cfg->pfc.willing = 0x0;
+	local_dcbx_cfg->app_mode = ICE_DCBX_APPS_NON_WILLING;
+
+	ice_cfg_etsrec_defaults(pf->hw.port_info);
 	ret = ice_set_dcb_cfg(pf->hw.port_info);
 	if (ret) {
 		dev_err(&pf->pdev->dev, "Failed to set DCB to unwilling\n");
@@ -234,8 +311,7 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 	}
 
 	/* Retrieve DCB config and ensure same as current in SW */
-	prev_cfg = devm_kmemdup(&pf->pdev->dev,
-				&pf->hw.port_info->local_dcbx_cfg,
+	prev_cfg = devm_kmemdup(&pf->pdev->dev, local_dcbx_cfg,
 				sizeof(*prev_cfg), GFP_KERNEL);
 	if (!prev_cfg) {
 		dev_err(&pf->pdev->dev, "Failed to alloc space for DCB cfg\n");
@@ -243,22 +319,22 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 	}
 
 	ice_init_dcb(&pf->hw);
-	if (memcmp(prev_cfg, &pf->hw.port_info->local_dcbx_cfg,
-		   sizeof(*prev_cfg))) {
+	if (ice_dcb_need_recfg(pf, prev_cfg, local_dcbx_cfg)) {
 		/* difference in cfg detected - disable DCB till next MIB */
 		dev_err(&pf->pdev->dev, "Set local MIB not accurate\n");
-		devm_kfree(&pf->pdev->dev, prev_cfg);
 		goto dcb_error;
 	}
 
 	/* fetched config congruent to previous configuration */
 	devm_kfree(&pf->pdev->dev, prev_cfg);
 
-	/* Configuration replayed - reset willing state to previous */
-	pf->hw.port_info->local_dcbx_cfg.etscfg.willing = willing;
+	/* Set the local desired config */
+	memset(&pf->hw.port_info->local_dcbx_cfg, 0, sizeof(*local_dcbx_cfg));
+	memcpy(local_dcbx_cfg, desired_dcbx_cfg, sizeof(*local_dcbx_cfg));
+	ice_cfg_etsrec_defaults(pf->hw.port_info);
 	ret = ice_set_dcb_cfg(pf->hw.port_info);
 	if (ret) {
-		dev_err(&pf->pdev->dev, "Fail restoring prev willing state\n");
+		dev_err(&pf->pdev->dev, "Failed to set desired config\n");
 		goto dcb_error;
 	}
 	dev_info(&pf->pdev->dev, "DCB restored after reset\n");
@@ -501,55 +577,6 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 	return 0;
 }
 
-/**
- * ice_dcb_need_recfg - Check if DCB needs reconfig
- * @pf: board private structure
- * @old_cfg: current DCB config
- * @new_cfg: new DCB config
- */
-static bool ice_dcb_need_recfg(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
-			       struct ice_dcbx_cfg *new_cfg)
-{
-	bool need_reconfig = false;
-
-	/* Check if ETS configuration has changed */
-	if (memcmp(&new_cfg->etscfg, &old_cfg->etscfg,
-		   sizeof(new_cfg->etscfg))) {
-		/* If Priority Table has changed reconfig is needed */
-		if (memcmp(&new_cfg->etscfg.prio_table,
-			   &old_cfg->etscfg.prio_table,
-			   sizeof(new_cfg->etscfg.prio_table))) {
-			need_reconfig = true;
-			dev_dbg(&pf->pdev->dev, "ETS UP2TC changed.\n");
-		}
-
-		if (memcmp(&new_cfg->etscfg.tcbwtable,
-			   &old_cfg->etscfg.tcbwtable,
-			   sizeof(new_cfg->etscfg.tcbwtable)))
-			dev_dbg(&pf->pdev->dev, "ETS TC BW Table changed.\n");
-
-		if (memcmp(&new_cfg->etscfg.tsatable,
-			   &old_cfg->etscfg.tsatable,
-			   sizeof(new_cfg->etscfg.tsatable)))
-			dev_dbg(&pf->pdev->dev, "ETS TSA Table changed.\n");
-	}
-
-	/* Check if PFC configuration has changed */
-	if (memcmp(&new_cfg->pfc, &old_cfg->pfc, sizeof(new_cfg->pfc))) {
-		need_reconfig = true;
-		dev_dbg(&pf->pdev->dev, "PFC config change detected.\n");
-	}
-
-	/* Check if APP Table has changed */
-	if (memcmp(&new_cfg->app, &old_cfg->app, sizeof(new_cfg->app))) {
-		need_reconfig = true;
-		dev_dbg(&pf->pdev->dev, "APP Table change detected.\n");
-	}
-
-	dev_dbg(&pf->pdev->dev, "dcb need_reconfig=%d\n", need_reconfig);
-	return need_reconfig;
-}
-
 /**
  * ice_dcb_process_lldp_set_mib_change - Process MIB change
  * @pf: ptr to ice_pf
-- 
2.21.0

