Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE939F06C
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfH0QjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:39:00 -0400
Received: from mga17.intel.com ([192.55.52.151]:7294 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbfH0Qig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876336"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] ice: shorten local and add debug prints
Date:   Tue, 27 Aug 2019 09:38:21 -0700
Message-Id: <20190827163832.8362-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Add some verbose debugging for dyndbg to help us when
we are having issues with link and/or PHY.

While there, shorten some strings used by locals that
were causing long line wrapping.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 63 ++++++++++++++-------
 1 file changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 4b43e6de847b..302ad981129c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -263,21 +263,23 @@ enum ice_status
 ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 		     struct ice_link_status *link, struct ice_sq_cd *cd)
 {
-	struct ice_link_status *hw_link_info_old, *hw_link_info;
 	struct ice_aqc_get_link_status_data link_data = { 0 };
 	struct ice_aqc_get_link_status *resp;
+	struct ice_link_status *li_old, *li;
 	enum ice_media_type *hw_media_type;
 	struct ice_fc_info *hw_fc_info;
 	bool tx_pause, rx_pause;
 	struct ice_aq_desc desc;
 	enum ice_status status;
+	struct ice_hw *hw;
 	u16 cmd_flags;
 
 	if (!pi)
 		return ICE_ERR_PARAM;
-	hw_link_info_old = &pi->phy.link_info_old;
+	hw = pi->hw;
+	li_old = &pi->phy.link_info_old;
 	hw_media_type = &pi->phy.media_type;
-	hw_link_info = &pi->phy.link_info;
+	li = &pi->phy.link_info;
 	hw_fc_info = &pi->fc;
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_link_status);
@@ -286,27 +288,27 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 	resp->cmd_flags = cpu_to_le16(cmd_flags);
 	resp->lport_num = pi->lport;
 
-	status = ice_aq_send_cmd(pi->hw, &desc, &link_data, sizeof(link_data),
-				 cd);
+	status = ice_aq_send_cmd(hw, &desc, &link_data, sizeof(link_data), cd);
 
 	if (status)
 		return status;
 
 	/* save off old link status information */
-	*hw_link_info_old = *hw_link_info;
+	*li_old = *li;
 
 	/* update current link status information */
-	hw_link_info->link_speed = le16_to_cpu(link_data.link_speed);
-	hw_link_info->phy_type_low = le64_to_cpu(link_data.phy_type_low);
-	hw_link_info->phy_type_high = le64_to_cpu(link_data.phy_type_high);
+	li->link_speed = le16_to_cpu(link_data.link_speed);
+	li->phy_type_low = le64_to_cpu(link_data.phy_type_low);
+	li->phy_type_high = le64_to_cpu(link_data.phy_type_high);
 	*hw_media_type = ice_get_media_type(pi);
-	hw_link_info->link_info = link_data.link_info;
-	hw_link_info->an_info = link_data.an_info;
-	hw_link_info->ext_info = link_data.ext_info;
-	hw_link_info->max_frame_size = le16_to_cpu(link_data.max_frame_size);
-	hw_link_info->fec_info = link_data.cfg & ICE_AQ_FEC_MASK;
-	hw_link_info->topo_media_conflict = link_data.topo_media_conflict;
-	hw_link_info->pacing = link_data.cfg & ICE_AQ_CFG_PACING_M;
+	li->link_info = link_data.link_info;
+	li->an_info = link_data.an_info;
+	li->ext_info = link_data.ext_info;
+	li->max_frame_size = le16_to_cpu(link_data.max_frame_size);
+	li->fec_info = link_data.cfg & ICE_AQ_FEC_MASK;
+	li->topo_media_conflict = link_data.topo_media_conflict;
+	li->pacing = link_data.cfg & (ICE_AQ_CFG_PACING_M |
+				      ICE_AQ_CFG_PACING_TYPE_M);
 
 	/* update fc info */
 	tx_pause = !!(link_data.an_info & ICE_AQ_LINK_PAUSE_TX);
@@ -320,12 +322,24 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 	else
 		hw_fc_info->current_mode = ICE_FC_NONE;
 
-	hw_link_info->lse_ena =
-		!!(resp->cmd_flags & cpu_to_le16(ICE_AQ_LSE_IS_ENABLED));
+	li->lse_ena = !!(resp->cmd_flags & cpu_to_le16(ICE_AQ_LSE_IS_ENABLED));
+
+	ice_debug(hw, ICE_DBG_LINK, "link_speed = 0x%x\n", li->link_speed);
+	ice_debug(hw, ICE_DBG_LINK, "phy_type_low = 0x%llx\n",
+		  (unsigned long long)li->phy_type_low);
+	ice_debug(hw, ICE_DBG_LINK, "phy_type_high = 0x%llx\n",
+		  (unsigned long long)li->phy_type_high);
+	ice_debug(hw, ICE_DBG_LINK, "media_type = 0x%x\n", *hw_media_type);
+	ice_debug(hw, ICE_DBG_LINK, "link_info = 0x%x\n", li->link_info);
+	ice_debug(hw, ICE_DBG_LINK, "an_info = 0x%x\n", li->an_info);
+	ice_debug(hw, ICE_DBG_LINK, "ext_info = 0x%x\n", li->ext_info);
+	ice_debug(hw, ICE_DBG_LINK, "lse_ena = 0x%x\n", li->lse_ena);
+	ice_debug(hw, ICE_DBG_LINK, "max_frame = 0x%x\n", li->max_frame_size);
+	ice_debug(hw, ICE_DBG_LINK, "pacing = 0x%x\n", li->pacing);
 
 	/* save link status information */
 	if (link)
-		*link = *hw_link_info;
+		*link = *li;
 
 	/* flag cleared so calling functions don't call AQ again */
 	pi->phy.get_link_info = false;
@@ -2000,6 +2014,17 @@ ice_aq_set_phy_cfg(struct ice_hw *hw, u8 lport,
 	desc.params.set_phy.lport_num = lport;
 	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
 
+	ice_debug(hw, ICE_DBG_LINK, "phy_type_low = 0x%llx\n",
+		  (unsigned long long)le64_to_cpu(cfg->phy_type_low));
+	ice_debug(hw, ICE_DBG_LINK, "phy_type_high = 0x%llx\n",
+		  (unsigned long long)le64_to_cpu(cfg->phy_type_high));
+	ice_debug(hw, ICE_DBG_LINK, "caps = 0x%x\n", cfg->caps);
+	ice_debug(hw, ICE_DBG_LINK, "low_power_ctrl = 0x%x\n",
+		  cfg->low_power_ctrl);
+	ice_debug(hw, ICE_DBG_LINK, "eee_cap = 0x%x\n", cfg->eee_cap);
+	ice_debug(hw, ICE_DBG_LINK, "eeer_value = 0x%x\n", cfg->eeer_value);
+	ice_debug(hw, ICE_DBG_LINK, "link_fec_opt = 0x%x\n", cfg->link_fec_opt);
+
 	return ice_aq_send_cmd(hw, &desc, cfg, sizeof(*cfg), cd);
 }
 
-- 
2.21.0

