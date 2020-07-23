Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB5F22BA58
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgGWXri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:43322 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgGWXrg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:36 -0400
IronPort-SDR: 28RHeAGlx5iUETvoEP8vbKMQYAav2LaKqadK+hyAcqt2BWncwvuXW2rJg4QSIeau5cuB6MD/7Q
 87+bgdnb1HfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235515439"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235515439"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:26 -0700
IronPort-SDR: ICMZwPMOZpz48BpM1n1lK8CpDR9HVIDu3z3jvRvp3+i6dksiqdXxGBh5MB1uj7CqKPjEiPiuZC
 H0A8H9yrOPng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742310"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 10/15] ice: add ice_aq_get_phy_caps() debug logs
Date:   Thu, 23 Jul 2020 16:47:15 -0700
Message-Id: <20200723234720.1547308-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Add debug logs for ice_aq_get_phy_caps(), and format
ice_aq_set_phy_cfg() and ice_aq_get_link_info() debug logs to make them
more readable.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 68 +++++++++++++++------
 1 file changed, 50 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 606e69086cb8..4c6a8e6bdd40 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -150,11 +150,13 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 	u16 pcaps_size = sizeof(*pcaps);
 	struct ice_aq_desc desc;
 	enum ice_status status;
+	struct ice_hw *hw;
 
 	cmd = &desc.params.get_phy;
 
 	if (!pcaps || (report_mode & ~ICE_AQC_REPORT_MODE_M) || !pi)
 		return ICE_ERR_PARAM;
+	hw = pi->hw;
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_phy_caps);
 
@@ -162,7 +164,32 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 		cmd->param0 |= cpu_to_le16(ICE_AQC_GET_PHY_RQM);
 
 	cmd->param0 |= cpu_to_le16(report_mode);
-	status = ice_aq_send_cmd(pi->hw, &desc, pcaps, pcaps_size, cd);
+	status = ice_aq_send_cmd(hw, &desc, pcaps, pcaps_size, cd);
+
+	ice_debug(hw, ICE_DBG_LINK, "get phy caps - report_mode = 0x%x\n",
+		  report_mode);
+	ice_debug(hw, ICE_DBG_LINK, "	phy_type_low = 0x%llx\n",
+		  (unsigned long long)le64_to_cpu(pcaps->phy_type_low));
+	ice_debug(hw, ICE_DBG_LINK, "	phy_type_high = 0x%llx\n",
+		  (unsigned long long)le64_to_cpu(pcaps->phy_type_high));
+	ice_debug(hw, ICE_DBG_LINK, "	caps = 0x%x\n", pcaps->caps);
+	ice_debug(hw, ICE_DBG_LINK, "	low_power_ctrl = 0x%x\n",
+		  pcaps->low_power_ctrl);
+	ice_debug(hw, ICE_DBG_LINK, "	eee_cap = 0x%x\n", pcaps->eee_cap);
+	ice_debug(hw, ICE_DBG_LINK, "	eeer_value = 0x%x\n",
+		  pcaps->eeer_value);
+	ice_debug(hw, ICE_DBG_LINK, "	link_fec_options = 0x%x\n",
+		  pcaps->link_fec_options);
+	ice_debug(hw, ICE_DBG_LINK, "	module_compliance_enforcement = 0x%x\n",
+		  pcaps->module_compliance_enforcement);
+	ice_debug(hw, ICE_DBG_LINK, "   extended_compliance_code = 0x%x\n",
+		  pcaps->extended_compliance_code);
+	ice_debug(hw, ICE_DBG_LINK, "   module_type[0] = 0x%x\n",
+		  pcaps->module_type[0]);
+	ice_debug(hw, ICE_DBG_LINK, "   module_type[1] = 0x%x\n",
+		  pcaps->module_type[1]);
+	ice_debug(hw, ICE_DBG_LINK, "   module_type[2] = 0x%x\n",
+		  pcaps->module_type[2]);
 
 	if (!status && report_mode == ICE_AQC_REPORT_TOPO_CAP) {
 		pi->phy.phy_type_low = le64_to_cpu(pcaps->phy_type_low);
@@ -326,18 +353,21 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 
 	li->lse_ena = !!(resp->cmd_flags & cpu_to_le16(ICE_AQ_LSE_IS_ENABLED));
 
-	ice_debug(hw, ICE_DBG_LINK, "link_speed = 0x%x\n", li->link_speed);
-	ice_debug(hw, ICE_DBG_LINK, "phy_type_low = 0x%llx\n",
+	ice_debug(hw, ICE_DBG_LINK, "get link info\n");
+	ice_debug(hw, ICE_DBG_LINK, "	link_speed = 0x%x\n", li->link_speed);
+	ice_debug(hw, ICE_DBG_LINK, "	phy_type_low = 0x%llx\n",
 		  (unsigned long long)li->phy_type_low);
-	ice_debug(hw, ICE_DBG_LINK, "phy_type_high = 0x%llx\n",
+	ice_debug(hw, ICE_DBG_LINK, "	phy_type_high = 0x%llx\n",
 		  (unsigned long long)li->phy_type_high);
-	ice_debug(hw, ICE_DBG_LINK, "media_type = 0x%x\n", *hw_media_type);
-	ice_debug(hw, ICE_DBG_LINK, "link_info = 0x%x\n", li->link_info);
-	ice_debug(hw, ICE_DBG_LINK, "an_info = 0x%x\n", li->an_info);
-	ice_debug(hw, ICE_DBG_LINK, "ext_info = 0x%x\n", li->ext_info);
-	ice_debug(hw, ICE_DBG_LINK, "lse_ena = 0x%x\n", li->lse_ena);
-	ice_debug(hw, ICE_DBG_LINK, "max_frame = 0x%x\n", li->max_frame_size);
-	ice_debug(hw, ICE_DBG_LINK, "pacing = 0x%x\n", li->pacing);
+	ice_debug(hw, ICE_DBG_LINK, "	media_type = 0x%x\n", *hw_media_type);
+	ice_debug(hw, ICE_DBG_LINK, "	link_info = 0x%x\n", li->link_info);
+	ice_debug(hw, ICE_DBG_LINK, "	an_info = 0x%x\n", li->an_info);
+	ice_debug(hw, ICE_DBG_LINK, "	ext_info = 0x%x\n", li->ext_info);
+	ice_debug(hw, ICE_DBG_LINK, "	fec_info = 0x%x\n", li->fec_info);
+	ice_debug(hw, ICE_DBG_LINK, "	lse_ena = 0x%x\n", li->lse_ena);
+	ice_debug(hw, ICE_DBG_LINK, "	max_frame = 0x%x\n",
+		  li->max_frame_size);
+	ice_debug(hw, ICE_DBG_LINK, "	pacing = 0x%x\n", li->pacing);
 
 	/* save link status information */
 	if (link)
@@ -2489,16 +2519,18 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, struct ice_port_info *pi,
 	desc.params.set_phy.lport_num = pi->lport;
 	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
 
-	ice_debug(hw, ICE_DBG_LINK, "phy_type_low = 0x%llx\n",
+	ice_debug(hw, ICE_DBG_LINK, "set phy cfg\n");
+	ice_debug(hw, ICE_DBG_LINK, "	phy_type_low = 0x%llx\n",
 		  (unsigned long long)le64_to_cpu(cfg->phy_type_low));
-	ice_debug(hw, ICE_DBG_LINK, "phy_type_high = 0x%llx\n",
+	ice_debug(hw, ICE_DBG_LINK, "	phy_type_high = 0x%llx\n",
 		  (unsigned long long)le64_to_cpu(cfg->phy_type_high));
-	ice_debug(hw, ICE_DBG_LINK, "caps = 0x%x\n", cfg->caps);
-	ice_debug(hw, ICE_DBG_LINK, "low_power_ctrl = 0x%x\n",
+	ice_debug(hw, ICE_DBG_LINK, "	caps = 0x%x\n", cfg->caps);
+	ice_debug(hw, ICE_DBG_LINK, "	low_power_ctrl = 0x%x\n",
 		  cfg->low_power_ctrl);
-	ice_debug(hw, ICE_DBG_LINK, "eee_cap = 0x%x\n", cfg->eee_cap);
-	ice_debug(hw, ICE_DBG_LINK, "eeer_value = 0x%x\n", cfg->eeer_value);
-	ice_debug(hw, ICE_DBG_LINK, "link_fec_opt = 0x%x\n", cfg->link_fec_opt);
+	ice_debug(hw, ICE_DBG_LINK, "	eee_cap = 0x%x\n", cfg->eee_cap);
+	ice_debug(hw, ICE_DBG_LINK, "	eeer_value = 0x%x\n", cfg->eeer_value);
+	ice_debug(hw, ICE_DBG_LINK, "	link_fec_opt = 0x%x\n",
+		  cfg->link_fec_opt);
 
 	status = ice_aq_send_cmd(hw, &desc, cfg, sizeof(*cfg), cd);
 	if (hw->adminq.sq_last_status == ICE_AQ_RC_EMODE)
-- 
2.26.2

