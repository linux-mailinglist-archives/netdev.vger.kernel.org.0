Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E4328D31
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388626AbfEWWdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:19070 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388575AbfEWWdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Usha Ketineni <usha.k.ketineni@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] ice: Refactor the LLDP MIB change event handling
Date:   Thu, 23 May 2019 15:33:33 -0700
Message-Id: <20190523223340.13449-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Usha Ketineni <usha.k.ketineni@intel.com>

This patch fixes the LLDP MIB change event handling code by removing
the workarounds in the current code. Added ice_dcb_need_recfg() to
print the DCB configuration changes detected via MIB change event.

Signed-off-by: Usha Ketineni <usha.k.ketineni@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c     |   5 +-
 drivers/net/ethernet/intel/ice/ice_dcb.h     |   4 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 153 ++++++++++++++++---
 3 files changed, 140 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 8bf83134b0da..49fbfe7c1ad7 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -624,7 +624,8 @@ ice_parse_org_tlv(struct ice_lldp_org_tlv *tlv, struct ice_dcbx_cfg *dcbcfg)
  *
  * Parse DCB configuration from the LLDPDU
  */
-enum ice_status ice_lldp_to_dcb_cfg(u8 *lldpmib, struct ice_dcbx_cfg *dcbcfg)
+static enum ice_status
+ice_lldp_to_dcb_cfg(u8 *lldpmib, struct ice_dcbx_cfg *dcbcfg)
 {
 	struct ice_lldp_org_tlv *tlv;
 	enum ice_status ret = 0;
@@ -674,7 +675,7 @@ enum ice_status ice_lldp_to_dcb_cfg(u8 *lldpmib, struct ice_dcbx_cfg *dcbcfg)
  *
  * Query DCB configuration from the firmware
  */
-static enum ice_status
+enum ice_status
 ice_aq_get_dcb_cfg(struct ice_hw *hw, u8 mib_type, u8 bridgetype,
 		   struct ice_dcbx_cfg *dcbcfg)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.h b/drivers/net/ethernet/intel/ice/ice_dcb.h
index e8594a3bc229..522e1452abe2 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.h
@@ -120,7 +120,9 @@ struct ice_cee_app_prio {
 	u8 prio_map;
 } __packed;
 
-enum ice_status ice_lldp_to_dcb_cfg(u8 *lldpmib, struct ice_dcbx_cfg *dcbcfg);
+enum ice_status
+ice_aq_get_dcb_cfg(struct ice_hw *hw, u8 mib_type, u8 bridgetype,
+		   struct ice_dcbx_cfg *dcbcfg);
 enum ice_status ice_get_dcb_cfg(struct ice_port_info *pi);
 enum ice_status ice_set_dcb_cfg(struct ice_port_info *pi);
 enum ice_status ice_init_dcb(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 8d849ef5cb0c..b97e3e8d499b 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -501,6 +501,55 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 	return 0;
 }
 
+/**
+ * ice_dcb_need_recfg - Check if DCB needs reconfig
+ * @pf: board private structure
+ * @old_cfg: current DCB config
+ * @new_cfg: new DCB config
+ */
+static bool ice_dcb_need_recfg(struct ice_pf *pf, struct ice_dcbx_cfg *old_cfg,
+			       struct ice_dcbx_cfg *new_cfg)
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
  * ice_dcb_process_lldp_set_mib_change - Process MIB change
  * @pf: ptr to ice_pf
@@ -510,29 +559,95 @@ void
 ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 				    struct ice_rq_event_info *event)
 {
-	if (pf->dcbx_cap & DCB_CAP_DCBX_LLD_MANAGED) {
-		struct ice_dcbx_cfg *dcbcfg, *prev_cfg;
-		int err;
-
-		prev_cfg = &pf->hw.port_info->local_dcbx_cfg;
-		dcbcfg = devm_kmemdup(&pf->pdev->dev, prev_cfg,
-				      sizeof(*dcbcfg), GFP_KERNEL);
-		if (!dcbcfg)
+	struct ice_aqc_port_ets_elem buf = { 0 };
+	struct ice_aqc_lldp_get_mib *mib;
+	struct ice_dcbx_cfg tmp_dcbx_cfg;
+	bool need_reconfig = false;
+	struct ice_port_info *pi;
+	u8 type;
+	int ret;
+
+	/* Not DCB capable or capability disabled */
+	if (!(test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags)))
+		return;
+
+	if (pf->dcbx_cap & DCB_CAP_DCBX_HOST) {
+		dev_dbg(&pf->pdev->dev,
+			"MIB Change Event in HOST mode\n");
+		return;
+	}
+
+	pi = pf->hw.port_info;
+	mib = (struct ice_aqc_lldp_get_mib *)&event->desc.params.raw;
+	/* Ignore if event is not for Nearest Bridge */
+	type = ((mib->type >> ICE_AQ_LLDP_BRID_TYPE_S) &
+		ICE_AQ_LLDP_BRID_TYPE_M);
+	dev_dbg(&pf->pdev->dev, "LLDP event MIB bridge type 0x%x\n", type);
+	if (type != ICE_AQ_LLDP_BRID_TYPE_NEAREST_BRID)
+		return;
+
+	/* Check MIB Type and return if event for Remote MIB update */
+	type = mib->type & ICE_AQ_LLDP_MIB_TYPE_M;
+	dev_dbg(&pf->pdev->dev,
+		"LLDP event mib type %s\n", type ? "remote" : "local");
+	if (type == ICE_AQ_LLDP_MIB_REMOTE) {
+		/* Update the remote cached instance and return */
+		ret = ice_aq_get_dcb_cfg(pi->hw, ICE_AQ_LLDP_MIB_REMOTE,
+					 ICE_AQ_LLDP_BRID_TYPE_NEAREST_BRID,
+					 &pi->remote_dcbx_cfg);
+		if (ret) {
+			dev_err(&pf->pdev->dev, "Failed to get remote DCB config\n");
 			return;
+		}
+	}
 
-		err = ice_lldp_to_dcb_cfg(event->msg_buf, dcbcfg);
-		if (!err)
-			ice_pf_dcb_cfg(pf, dcbcfg, false);
+	/* store the old configuration */
+	tmp_dcbx_cfg = pf->hw.port_info->local_dcbx_cfg;
 
-		devm_kfree(&pf->pdev->dev, dcbcfg);
+	/* Reset the old DCBx configuration data */
+	memset(&pi->local_dcbx_cfg, 0, sizeof(pi->local_dcbx_cfg));
 
-		/* Get updated DCBx data from firmware */
-		err = ice_get_dcb_cfg(pf->hw.port_info);
-		if (err)
-			dev_err(&pf->pdev->dev,
-				"Failed to get DCB config\n");
-	} else {
+	/* Get updated DCBx data from firmware */
+	ret = ice_get_dcb_cfg(pf->hw.port_info);
+	if (ret) {
+		dev_err(&pf->pdev->dev, "Failed to get DCB config\n");
+		return;
+	}
+
+	/* No change detected in DCBX configs */
+	if (!memcmp(&tmp_dcbx_cfg, &pi->local_dcbx_cfg, sizeof(tmp_dcbx_cfg))) {
 		dev_dbg(&pf->pdev->dev,
-			"MIB Change Event in HOST mode\n");
+			"No change detected in DCBX configuration.\n");
+		return;
 	}
+
+	need_reconfig = ice_dcb_need_recfg(pf, &tmp_dcbx_cfg,
+					   &pi->local_dcbx_cfg);
+	if (!need_reconfig)
+		return;
+
+	/* Enable DCB tagging only when more than one TC */
+	if (ice_dcb_get_num_tc(&pi->local_dcbx_cfg) > 1) {
+		dev_dbg(&pf->pdev->dev, "DCB tagging enabled (num TC > 1)\n");
+		set_bit(ICE_FLAG_DCB_ENA, pf->flags);
+	} else {
+		dev_dbg(&pf->pdev->dev, "DCB tagging disabled (num TC = 1)\n");
+		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
+	}
+
+	rtnl_lock();
+	ice_pf_dis_all_vsi(pf, true);
+
+	ret = ice_query_port_ets(pf->hw.port_info, &buf, sizeof(buf), NULL);
+	if (ret) {
+		dev_err(&pf->pdev->dev, "Query Port ETS failed\n");
+		rtnl_unlock();
+		return;
+	}
+
+	/* changes in configuration update VSI */
+	ice_pf_dcb_recfg(pf);
+
+	ice_pf_ena_all_vsi(pf, true);
+	rtnl_unlock();
 }
-- 
2.21.0

