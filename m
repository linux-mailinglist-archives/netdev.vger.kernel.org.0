Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED8328D3B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388559AbfEWWeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:34:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:19068 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbfEWWdh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/15] ice: Implement LLDP persistence
Date:   Thu, 23 May 2019 15:33:27 -0700
Message-Id: <20190523223340.13449-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Implement LLDP persistence across reboots, start and stop of LLDP agent.
Add additional parameter to ice_aq_start_lldp and ice_aq_stop_lldp.

Also change the ethtool private flag from "disable-fw-lldp" to
"enable-fw-lldp". This change will flip the boolean logic of the
functionality of the flag (on = enable, off = disable). The change
in name and functionality is to differentiate between the
pre-persistence and post-persistence states.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  2 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c     | 16 +++++++++--
 drivers/net/ethernet/intel/ice/ice_dcb.h     |  8 ++++--
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 30 ++++----------------
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 10 +++----
 5 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 792e6e42030e..7958f2bac8da 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -330,7 +330,7 @@ enum ice_pf_flags {
 	ICE_FLAG_DCB_CAPABLE,
 	ICE_FLAG_DCB_ENA,
 	ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA,
-	ICE_FLAG_DISABLE_FW_LLDP,
+	ICE_FLAG_ENABLE_FW_LLDP,
 	ICE_FLAG_ETHTOOL_CTXT,		/* set when ethtool holds RTNL lock */
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 8bbf48e04a1c..8bf83134b0da 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -82,12 +82,14 @@ ice_aq_cfg_lldp_mib_change(struct ice_hw *hw, bool ena_update,
  * @hw: pointer to the HW struct
  * @shutdown_lldp_agent: True if LLDP Agent needs to be Shutdown
  *			 False if LLDP Agent needs to be Stopped
+ * @persist: True if Stop/Shutdown of LLDP Agent needs to be persistent across
+ *	     reboots
  * @cd: pointer to command details structure or NULL
  *
  * Stop or Shutdown the embedded LLDP Agent (0x0A05)
  */
 enum ice_status
-ice_aq_stop_lldp(struct ice_hw *hw, bool shutdown_lldp_agent,
+ice_aq_stop_lldp(struct ice_hw *hw, bool shutdown_lldp_agent, bool persist,
 		 struct ice_sq_cd *cd)
 {
 	struct ice_aqc_lldp_stop *cmd;
@@ -100,17 +102,22 @@ ice_aq_stop_lldp(struct ice_hw *hw, bool shutdown_lldp_agent,
 	if (shutdown_lldp_agent)
 		cmd->command |= ICE_AQ_LLDP_AGENT_SHUTDOWN;
 
+	if (persist)
+		cmd->command |= ICE_AQ_LLDP_AGENT_PERSIST_DIS;
+
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
 }
 
 /**
  * ice_aq_start_lldp
  * @hw: pointer to the HW struct
+ * @persist: True if Start of LLDP Agent needs to be persistent across reboots
  * @cd: pointer to command details structure or NULL
  *
  * Start the embedded LLDP Agent on all ports. (0x0A06)
  */
-enum ice_status ice_aq_start_lldp(struct ice_hw *hw, struct ice_sq_cd *cd)
+enum ice_status
+ice_aq_start_lldp(struct ice_hw *hw, bool persist, struct ice_sq_cd *cd)
 {
 	struct ice_aqc_lldp_start *cmd;
 	struct ice_aq_desc desc;
@@ -121,6 +128,9 @@ enum ice_status ice_aq_start_lldp(struct ice_hw *hw, struct ice_sq_cd *cd)
 
 	cmd->command = ICE_AQ_LLDP_AGENT_START;
 
+	if (persist)
+		cmd->command |= ICE_AQ_LLDP_AGENT_PERSIST_ENA;
+
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
 }
 
@@ -163,7 +173,7 @@ ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
  *
  * Get the DCBX status from the Firmware
  */
-u8 ice_get_dcbx_status(struct ice_hw *hw)
+static u8 ice_get_dcbx_status(struct ice_hw *hw)
 {
 	u32 reg;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.h b/drivers/net/ethernet/intel/ice/ice_dcb.h
index e7d4416e3a66..e8594a3bc229 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.h
@@ -120,7 +120,6 @@ struct ice_cee_app_prio {
 	u8 prio_map;
 } __packed;
 
-u8 ice_get_dcbx_status(struct ice_hw *hw);
 enum ice_status ice_lldp_to_dcb_cfg(u8 *lldpmib, struct ice_dcbx_cfg *dcbcfg);
 enum ice_status ice_get_dcb_cfg(struct ice_port_info *pi);
 enum ice_status ice_set_dcb_cfg(struct ice_port_info *pi);
@@ -131,9 +130,10 @@ ice_query_port_ets(struct ice_port_info *pi,
 		   struct ice_sq_cd *cmd_details);
 #ifdef CONFIG_DCB
 enum ice_status
-ice_aq_stop_lldp(struct ice_hw *hw, bool shutdown_lldp_agent,
+ice_aq_stop_lldp(struct ice_hw *hw, bool shutdown_lldp_agent, bool persist,
 		 struct ice_sq_cd *cd);
-enum ice_status ice_aq_start_lldp(struct ice_hw *hw, struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_start_lldp(struct ice_hw *hw, bool persist, struct ice_sq_cd *cd);
 enum ice_status
 ice_aq_start_stop_dcbx(struct ice_hw *hw, bool start_dcbx_agent,
 		       bool *dcbx_agent_status, struct ice_sq_cd *cd);
@@ -144,6 +144,7 @@ ice_aq_cfg_lldp_mib_change(struct ice_hw *hw, bool ena_update,
 static inline enum ice_status
 ice_aq_stop_lldp(struct ice_hw __always_unused *hw,
 		 bool __always_unused shutdown_lldp_agent,
+		 bool __always_unused persist,
 		 struct ice_sq_cd __always_unused *cd)
 {
 	return 0;
@@ -151,6 +152,7 @@ ice_aq_stop_lldp(struct ice_hw __always_unused *hw,
 
 static inline enum ice_status
 ice_aq_start_lldp(struct ice_hw __always_unused *hw,
+		  bool __always_unused persist,
 		  struct ice_sq_cd __always_unused *cd)
 {
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 3e81af1884fc..e2e921506edc 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -360,33 +360,10 @@ int ice_init_pf_dcb(struct ice_pf *pf)
 
 	port_info = hw->port_info;
 
-	/* check if device is DCB capable */
-	if (!hw->func_caps.common_cap.dcb) {
-		dev_dbg(dev, "DCB not supported\n");
-		return -EOPNOTSUPP;
-	}
-
-	/* Best effort to put DCBx and LLDP into a good state */
-	port_info->dcbx_status = ice_get_dcbx_status(hw);
-	if (port_info->dcbx_status != ICE_DCBX_STATUS_DONE &&
-	    port_info->dcbx_status != ICE_DCBX_STATUS_IN_PROGRESS) {
-		bool dcbx_status;
-
-		/* Attempt to start LLDP engine. Ignore errors
-		 * as this will error if it is already started
-		 */
-		ice_aq_start_lldp(hw, NULL);
-
-		/* Attempt to start DCBX. Ignore errors as this
-		 * will error if it is already started
-		 */
-		ice_aq_start_stop_dcbx(hw, true, &dcbx_status, NULL);
-	}
-
 	err = ice_init_dcb(hw);
 	if (err) {
-		/* FW LLDP not in usable state, default to SW DCBx/LLDP */
-		dev_info(&pf->pdev->dev, "FW LLDP not in usable state\n");
+		/* FW LLDP is not active, default to SW DCBx/LLDP */
+		dev_info(&pf->pdev->dev, "FW LLDP is not active\n");
 		hw->port_info->dcbx_status = ICE_DCBX_STATUS_NOT_STARTED;
 		hw->port_info->is_sw_lldp = true;
 	}
@@ -398,6 +375,9 @@ int ice_init_pf_dcb(struct ice_pf *pf)
 	if (port_info->is_sw_lldp) {
 		sw_default = 1;
 		dev_info(&pf->pdev->dev, "DCBx/LLDP in SW mode.\n");
+		clear_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags);
+	} else {
+		set_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags);
 	}
 
 	if (port_info->dcbx_status == ICE_DCBX_STATUS_NOT_STARTED) {
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 1341fde8d53f..76122a28da7e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -134,7 +134,7 @@ struct ice_priv_flag {
 
 static const struct ice_priv_flag ice_gstrings_priv_flags[] = {
 	ICE_PRIV_FLAG("link-down-on-close", ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA),
-	ICE_PRIV_FLAG("disable-fw-lldp", ICE_FLAG_DISABLE_FW_LLDP),
+	ICE_PRIV_FLAG("enable-fw-lldp", ICE_FLAG_ENABLE_FW_LLDP),
 };
 
 #define ICE_PRIV_FLAG_ARRAY_SIZE	ARRAY_SIZE(ice_gstrings_priv_flags)
@@ -433,8 +433,8 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 
 	bitmap_xor(change_flags, pf->flags, orig_flags, ICE_PF_FLAGS_NBITS);
 
-	if (test_bit(ICE_FLAG_DISABLE_FW_LLDP, change_flags)) {
-		if (test_bit(ICE_FLAG_DISABLE_FW_LLDP, pf->flags)) {
+	if (test_bit(ICE_FLAG_ENABLE_FW_LLDP, change_flags)) {
+		if (!test_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags)) {
 			enum ice_status status;
 
 			status = ice_aq_cfg_lldp_mib_change(&pf->hw, false,
@@ -450,7 +450,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			/* The AQ call to stop the FW LLDP agent will generate
 			 * an error if the agent is already stopped.
 			 */
-			status = ice_aq_stop_lldp(&pf->hw, true, NULL);
+			status = ice_aq_stop_lldp(&pf->hw, true, true, NULL);
 			if (status)
 				dev_warn(&pf->pdev->dev,
 					 "Fail to stop LLDP agent\n");
@@ -468,7 +468,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			/* AQ command to start FW LLDP agent will return an
 			 * error if the agent is already started
 			 */
-			status = ice_aq_start_lldp(&pf->hw, NULL);
+			status = ice_aq_start_lldp(&pf->hw, true, NULL);
 			if (status)
 				dev_warn(&pf->pdev->dev,
 					 "Fail to start LLDP Agent\n");
-- 
2.21.0

