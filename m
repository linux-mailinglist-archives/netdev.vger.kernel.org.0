Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFD2135FB
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 01:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfECXJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 19:09:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:40730 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfECXJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 19:09:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 16:09:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,427,1549958400"; 
   d="scan'208";a="136660088"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 03 May 2019 16:09:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 06/11] i40e: Further implementation of LLDP
Date:   Fri,  3 May 2019 16:09:34 -0700
Message-Id: <20190503230939.6739-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
References: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

This code implements driver code changes necessary for LLDP
Agent support. Modified i40e_aq_start_lldp() and
i40e_aq_stop_lldp() adding false parameter whether LLDP state
should be persistent across power cycles.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |  5 ++
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h | 20 ++++--
 drivers/net/ethernet/intel/i40e/i40e_common.c | 62 ++++++++++++++++++-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  4 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  2 +-
 .../net/ethernet/intel/i40e/i40e_prototype.h  |  8 ++-
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  1 +
 8 files changed, 93 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index 45f6adc8ff2f..243dcd4bec19 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -608,6 +608,11 @@ i40e_status i40e_init_adminq(struct i40e_hw *hw)
 	     hw->aq.api_min_ver >= 7))
 		hw->flags |= I40E_HW_FLAG_802_1AD_CAPABLE;
 
+	if (hw->aq.api_maj_ver > 1 ||
+	    (hw->aq.api_maj_ver == 1 &&
+	     hw->aq.api_min_ver >= 8))
+		hw->flags |= I40E_HW_FLAG_FW_LLDP_PERSISTENT;
+
 	if (hw->aq.api_maj_ver > I40E_FW_API_VERSION_MAJOR) {
 		ret_code = I40E_ERR_FIRMWARE_API_VERSION;
 		goto init_adminq_free_arq;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
index 522058a7d4be..abcf79eb3261 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h
@@ -261,6 +261,7 @@ enum i40e_admin_queue_opc {
 	i40e_aqc_opc_get_cee_dcb_cfg	= 0x0A07,
 	i40e_aqc_opc_lldp_set_local_mib	= 0x0A08,
 	i40e_aqc_opc_lldp_stop_start_spec_agent	= 0x0A09,
+	i40e_aqc_opc_lldp_restore		= 0x0A0A,
 
 	/* Tunnel commands */
 	i40e_aqc_opc_add_udp_tunnel	= 0x0B00,
@@ -2498,18 +2499,19 @@ I40E_CHECK_CMD_LENGTH(i40e_aqc_lldp_update_tlv);
 /* Stop LLDP (direct 0x0A05) */
 struct i40e_aqc_lldp_stop {
 	u8	command;
-#define I40E_AQ_LLDP_AGENT_STOP		0x0
-#define I40E_AQ_LLDP_AGENT_SHUTDOWN	0x1
+#define I40E_AQ_LLDP_AGENT_STOP			0x0
+#define I40E_AQ_LLDP_AGENT_SHUTDOWN		0x1
+#define I40E_AQ_LLDP_AGENT_STOP_PERSIST		0x2
 	u8	reserved[15];
 };
 
 I40E_CHECK_CMD_LENGTH(i40e_aqc_lldp_stop);
 
 /* Start LLDP (direct 0x0A06) */
-
 struct i40e_aqc_lldp_start {
 	u8	command;
-#define I40E_AQ_LLDP_AGENT_START	0x1
+#define I40E_AQ_LLDP_AGENT_START		0x1
+#define I40E_AQ_LLDP_AGENT_START_PERSIST	0x2
 	u8	reserved[15];
 };
 
@@ -2633,6 +2635,16 @@ struct i40e_aqc_lldp_stop_start_specific_agent {
 
 I40E_CHECK_CMD_LENGTH(i40e_aqc_lldp_stop_start_specific_agent);
 
+/* Restore LLDP Agent factory settings (direct 0x0A0A) */
+struct i40e_aqc_lldp_restore {
+	u8	command;
+#define I40E_AQ_LLDP_AGENT_RESTORE_NOT		0x0
+#define I40E_AQ_LLDP_AGENT_RESTORE		0x1
+	u8	reserved[15];
+};
+
+I40E_CHECK_CMD_LENGTH(i40e_aqc_lldp_restore);
+
 /* Add Udp Tunnel command and completion (direct 0x0B00) */
 struct i40e_aqc_add_udp_tunnel {
 	__le16	udp_port;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index dd6b3b3ac5c6..e7d500f92a90 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -3623,15 +3623,55 @@ i40e_status i40e_aq_cfg_lldp_mib_change_event(struct i40e_hw *hw,
 	return status;
 }
 
+/**
+ * i40e_aq_restore_lldp
+ * @hw: pointer to the hw struct
+ * @setting: pointer to factory setting variable or NULL
+ * @restore: True if factory settings should be restored
+ * @cmd_details: pointer to command details structure or NULL
+ *
+ * Restore LLDP Agent factory settings if @restore set to True. In other case
+ * only returns factory setting in AQ response.
+ **/
+enum i40e_status_code
+i40e_aq_restore_lldp(struct i40e_hw *hw, u8 *setting, bool restore,
+		     struct i40e_asq_cmd_details *cmd_details)
+{
+	struct i40e_aq_desc desc;
+	struct i40e_aqc_lldp_restore *cmd =
+		(struct i40e_aqc_lldp_restore *)&desc.params.raw;
+	i40e_status status;
+
+	if (!(hw->flags & I40E_HW_FLAG_FW_LLDP_PERSISTENT)) {
+		i40e_debug(hw, I40E_DEBUG_ALL,
+			   "Restore LLDP not supported by current FW version.\n");
+		return I40E_ERR_DEVICE_NOT_SUPPORTED;
+	}
+
+	i40e_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_lldp_restore);
+
+	if (restore)
+		cmd->command |= I40E_AQ_LLDP_AGENT_RESTORE;
+
+	status = i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
+
+	if (setting)
+		*setting = cmd->command & 1;
+
+	return status;
+}
+
 /**
  * i40e_aq_stop_lldp
  * @hw: pointer to the hw struct
  * @shutdown_agent: True if LLDP Agent needs to be Shutdown
+ * @persist: True if stop of LLDP should be persistent across power cycles
  * @cmd_details: pointer to command details structure or NULL
  *
  * Stop or Shutdown the embedded LLDP Agent
  **/
 i40e_status i40e_aq_stop_lldp(struct i40e_hw *hw, bool shutdown_agent,
+				bool persist,
 				struct i40e_asq_cmd_details *cmd_details)
 {
 	struct i40e_aq_desc desc;
@@ -3644,6 +3684,14 @@ i40e_status i40e_aq_stop_lldp(struct i40e_hw *hw, bool shutdown_agent,
 	if (shutdown_agent)
 		cmd->command |= I40E_AQ_LLDP_AGENT_SHUTDOWN;
 
+	if (persist) {
+		if (hw->flags & I40E_HW_FLAG_FW_LLDP_PERSISTENT)
+			cmd->command |= I40E_AQ_LLDP_AGENT_STOP_PERSIST;
+		else
+			i40e_debug(hw, I40E_DEBUG_ALL,
+				   "Persistent Stop LLDP not supported by current FW version.\n");
+	}
+
 	status = i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
 
 	return status;
@@ -3653,13 +3701,14 @@ i40e_status i40e_aq_stop_lldp(struct i40e_hw *hw, bool shutdown_agent,
  * i40e_aq_start_lldp
  * @hw: pointer to the hw struct
  * @buff: buffer for result
+ * @persist: True if start of LLDP should be persistent across power cycles
  * @buff_size: buffer size
  * @cmd_details: pointer to command details structure or NULL
  *
  * Start the embedded LLDP Agent on all ports.
  **/
-i40e_status i40e_aq_start_lldp(struct i40e_hw *hw,
-				struct i40e_asq_cmd_details *cmd_details)
+i40e_status i40e_aq_start_lldp(struct i40e_hw *hw, bool persist,
+			       struct i40e_asq_cmd_details *cmd_details)
 {
 	struct i40e_aq_desc desc;
 	struct i40e_aqc_lldp_start *cmd =
@@ -3669,6 +3718,15 @@ i40e_status i40e_aq_start_lldp(struct i40e_hw *hw,
 	i40e_fill_default_direct_cmd_desc(&desc, i40e_aqc_opc_lldp_start);
 
 	cmd->command = I40E_AQ_LLDP_AGENT_START;
+
+	if (persist) {
+		if (hw->flags & I40E_HW_FLAG_FW_LLDP_PERSISTENT)
+			cmd->command |= I40E_AQ_LLDP_AGENT_START_PERSIST;
+		else
+			i40e_debug(hw, I40E_DEBUG_ALL,
+				   "Persistent Start LLDP not supported by current FW version.\n");
+	}
+
 	status = i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
 
 	return status;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index c67d485d6f99..7ea4f09229e4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -1321,7 +1321,7 @@ static ssize_t i40e_dbg_command_write(struct file *filp,
 		if (strncmp(&cmd_buf[5], "stop", 4) == 0) {
 			int ret;
 
-			ret = i40e_aq_stop_lldp(&pf->hw, false, NULL);
+			ret = i40e_aq_stop_lldp(&pf->hw, false, false, NULL);
 			if (ret) {
 				dev_info(&pf->pdev->dev,
 					 "Stop LLDP AQ command failed =0x%x\n",
@@ -1358,7 +1358,7 @@ static ssize_t i40e_dbg_command_write(struct file *filp,
 				/* Continue and start FW LLDP anyways */
 			}
 
-			ret = i40e_aq_start_lldp(&pf->hw, NULL);
+			ret = i40e_aq_start_lldp(&pf->hw, false, NULL);
 			if (ret) {
 				dev_info(&pf->pdev->dev,
 					 "Start LLDP AQ command failed =0x%x\n",
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 0d923c13c9a1..32e137499063 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4958,7 +4958,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		if (pf->flags & I40E_FLAG_DISABLE_FW_LLDP) {
 			struct i40e_dcbx_config *dcbcfg;
 
-			i40e_aq_stop_lldp(&pf->hw, true, NULL);
+			i40e_aq_stop_lldp(&pf->hw, true, false, NULL);
 			i40e_aq_set_dcb_parameters(&pf->hw, true, NULL);
 			/* reset local_dcbx_config to default */
 			dcbcfg = &pf->hw.local_dcbx_config;
@@ -4973,7 +4973,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 			dcbcfg->pfc.willing = 1;
 			dcbcfg->pfc.pfccap = I40E_MAX_TRAFFIC_CLASS;
 		} else {
-			i40e_aq_start_lldp(&pf->hw, NULL);
+			i40e_aq_start_lldp(&pf->hw, false, NULL);
 		}
 	}
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3e15df1d5f52..54c172c50479 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14132,7 +14132,7 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (pf->hw_features & I40E_HW_STOP_FW_LLDP) {
 		dev_info(&pdev->dev, "Stopping firmware LLDP agent.\n");
-		i40e_aq_stop_lldp(hw, true, NULL);
+		i40e_aq_stop_lldp(hw, true, false, NULL);
 	}
 
 	/* allow a platform config to override the HW addr */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index 663c8bf4d3d8..882627073dce 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -203,14 +203,18 @@ i40e_status i40e_aq_get_lldp_mib(struct i40e_hw *hw, u8 bridge_type,
 i40e_status i40e_aq_cfg_lldp_mib_change_event(struct i40e_hw *hw,
 				bool enable_update,
 				struct i40e_asq_cmd_details *cmd_details);
+enum i40e_status_code
+i40e_aq_restore_lldp(struct i40e_hw *hw, u8 *setting, bool restore,
+		     struct i40e_asq_cmd_details *cmd_details);
 i40e_status i40e_aq_stop_lldp(struct i40e_hw *hw, bool shutdown_agent,
+			      bool persist,
 				struct i40e_asq_cmd_details *cmd_details);
 i40e_status i40e_aq_set_dcb_parameters(struct i40e_hw *hw,
 				       bool dcb_enable,
 				       struct i40e_asq_cmd_details
 				       *cmd_details);
-i40e_status i40e_aq_start_lldp(struct i40e_hw *hw,
-				struct i40e_asq_cmd_details *cmd_details);
+i40e_status i40e_aq_start_lldp(struct i40e_hw *hw, bool persist,
+			       struct i40e_asq_cmd_details *cmd_details);
 i40e_status i40e_aq_get_cee_dcb_config(struct i40e_hw *hw,
 				       void *buff, u16 buff_size,
 				       struct i40e_asq_cmd_details *cmd_details);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 79420bcc7414..820af0043cc8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -616,6 +616,7 @@ struct i40e_hw {
 #define I40E_HW_FLAG_AQ_PHY_ACCESS_CAPABLE  BIT_ULL(2)
 #define I40E_HW_FLAG_NVM_READ_REQUIRES_LOCK BIT_ULL(3)
 #define I40E_HW_FLAG_FW_LLDP_STOPPABLE      BIT_ULL(4)
+#define I40E_HW_FLAG_FW_LLDP_PERSISTENT     BIT_ULL(5)
 	u64 flags;
 
 	/* Used in set switch config AQ command */
-- 
2.20.1

