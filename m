Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7848342A981
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhJLQhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:37:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:1914 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhJLQhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:37:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="227102071"
X-IronPort-AV: E=Sophos;i="5.85,368,1624345200"; 
   d="scan'208";a="227102071"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 09:33:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,368,1624345200"; 
   d="scan'208";a="491050683"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 12 Oct 2021 09:33:49 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Machnikowski <maciej.machnikowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 2/4] ice: Implement functions for reading and setting GPIO pins
Date:   Tue, 12 Oct 2021 09:31:51 -0700
Message-Id: <20211012163153.2104212-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012163153.2104212-1-anthony.l.nguyen@intel.com>
References: <20211012163153.2104212-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Machnikowski <maciej.machnikowski@intel.com>

Implement ice_aq_get_gpio and ice_aq_set_gpio for reading and changing
the state of GPIO pins described in the topology.

Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 13 +++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 58 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  6 ++
 3 files changed, 77 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 9f6edfa59770..25708c320f5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1344,6 +1344,16 @@ struct ice_aqc_set_port_id_led {
 	u8 rsvd[13];
 };
 
+/* Set/Get GPIO (direct, 0x06EC/0x06ED) */
+struct ice_aqc_gpio {
+	__le16 gpio_ctrl_handle;
+#define ICE_AQC_GPIO_HANDLE_S	0
+#define ICE_AQC_GPIO_HANDLE_M	(0x3FF << ICE_AQC_GPIO_HANDLE_S)
+	u8 gpio_num;
+	u8 gpio_val;
+	u8 rsvd[12];
+};
+
 /* Read/Write SFF EEPROM command (indirect 0x06EE) */
 struct ice_aqc_sff_eeprom {
 	u8 lport_num;
@@ -1985,6 +1995,7 @@ struct ice_aq_desc {
 		struct ice_aqc_get_phy_caps get_phy;
 		struct ice_aqc_set_phy_cfg set_phy;
 		struct ice_aqc_restart_an restart_an;
+		struct ice_aqc_gpio read_write_gpio;
 		struct ice_aqc_sff_eeprom read_write_sff_param;
 		struct ice_aqc_set_port_id_led set_port_id_led;
 		struct ice_aqc_get_sw_cfg get_sw_conf;
@@ -2140,6 +2151,8 @@ enum ice_adminq_opc {
 	ice_aqc_opc_set_mac_lb				= 0x0620,
 	ice_aqc_opc_get_link_topo			= 0x06E0,
 	ice_aqc_opc_set_port_id_led			= 0x06E9,
+	ice_aqc_opc_set_gpio				= 0x06EC,
+	ice_aqc_opc_get_gpio				= 0x06ED,
 	ice_aqc_opc_sff_eeprom				= 0x06EE,
 
 	/* NVM commands */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index b0084359a7e1..7416f802a558 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -4794,6 +4794,64 @@ ice_aq_get_driver_param(struct ice_hw *hw, enum ice_aqc_driver_params idx,
 	return 0;
 }
 
+/**
+ * ice_aq_set_gpio
+ * @hw: pointer to the hw struct
+ * @gpio_ctrl_handle: GPIO controller node handle
+ * @pin_idx: IO Number of the GPIO that needs to be set
+ * @value: SW provide IO value to set in the LSB
+ * @cd: pointer to command details structure or NULL
+ *
+ * Sends 0x06EC AQ command to set the GPIO pin state that's part of the topology
+ */
+int
+ice_aq_set_gpio(struct ice_hw *hw, u16 gpio_ctrl_handle, u8 pin_idx, bool value,
+		struct ice_sq_cd *cd)
+{
+	struct ice_aqc_gpio *cmd;
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_gpio);
+	cmd = &desc.params.read_write_gpio;
+	cmd->gpio_ctrl_handle = cpu_to_le16(gpio_ctrl_handle);
+	cmd->gpio_num = pin_idx;
+	cmd->gpio_val = value ? 1 : 0;
+
+	return ice_status_to_errno(ice_aq_send_cmd(hw, &desc, NULL, 0, cd));
+}
+
+/**
+ * ice_aq_get_gpio
+ * @hw: pointer to the hw struct
+ * @gpio_ctrl_handle: GPIO controller node handle
+ * @pin_idx: IO Number of the GPIO that needs to be set
+ * @value: IO value read
+ * @cd: pointer to command details structure or NULL
+ *
+ * Sends 0x06ED AQ command to get the value of a GPIO signal which is part of
+ * the topology
+ */
+int
+ice_aq_get_gpio(struct ice_hw *hw, u16 gpio_ctrl_handle, u8 pin_idx,
+		bool *value, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_gpio *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_gpio);
+	cmd = &desc.params.read_write_gpio;
+	cmd->gpio_ctrl_handle = cpu_to_le16(gpio_ctrl_handle);
+	cmd->gpio_num = pin_idx;
+
+	status = ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
+	if (status)
+		return ice_status_to_errno(status);
+
+	*value = !!cmd->gpio_val;
+	return 0;
+}
+
 /**
  * ice_fw_supports_link_override
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index fb16070f02e2..4273f8921e53 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -192,6 +192,12 @@ ice_aq_set_driver_param(struct ice_hw *hw, enum ice_aqc_driver_params idx,
 int
 ice_aq_get_driver_param(struct ice_hw *hw, enum ice_aqc_driver_params idx,
 			u32 *value, struct ice_sq_cd *cd);
+int
+ice_aq_set_gpio(struct ice_hw *hw, u16 gpio_ctrl_handle, u8 pin_idx, bool value,
+		struct ice_sq_cd *cd);
+int
+ice_aq_get_gpio(struct ice_hw *hw, u16 gpio_ctrl_handle, u8 pin_idx,
+		bool *value, struct ice_sq_cd *cd);
 enum ice_status
 ice_aq_set_lldp_mib(struct ice_hw *hw, u8 mib_type, void *buf, u16 buf_size,
 		    struct ice_sq_cd *cd);
-- 
2.31.1

