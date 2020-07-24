Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003F122BAF5
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgGXAWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:22:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:23104 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgGXAWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 20:22:21 -0400
IronPort-SDR: AxN6Y2oKP0mTxe/9+/t+4mlL90vK26g5tS8IFgLbbcRPi+vOsPBAWxZpid+yyQX1Qrly9bi0I9
 NzmWs1k7B9SA==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="215232505"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="215232505"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 17:22:19 -0700
IronPort-SDR: 5FOn5mxmrmi+4wjZ9plVnBneciZYULg350EpM1QAQJZBMYt7Rxfzml4897/bleJfXOMwUb5+Tt
 cd1pHA5QJvEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="272441991"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jul 2020 17:22:19 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        "Cudzilo, Szymon T" <szymon.t.cudzilo@intel.com>,
        Cudzilo@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v1 3/5] ice: Add AdminQ commands for FW update
Date:   Thu, 23 Jul 2020 17:22:01 -0700
Message-Id: <20200724002203.451621-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.rc1.139.gd6b33fda9dd1
In-Reply-To: <20200724002203.451621-1-jacob.e.keller@intel.com>
References: <20200724002203.451621-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Cudzilo, Szymon T" <szymon.t.cudzilo@intel.com>

Add structures, identifiers, and helper functions for several AdminQ
commands related to performing a firmware update for the ice hardware.
These will be used in future code for implementing the devlink
.flash_update handler.

Signed-off-by: Cudzilo, Szymon T <szymon.t.cudzilo@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  76 +++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |   2 -
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 186 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  16 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 5 files changed, 281 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index b97f50e60feb..b2ec792e6052 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1299,7 +1299,14 @@ struct ice_aqc_nvm {
 #define ICE_AQC_NVM_PRESERVATION_M	(3 << ICE_AQC_NVM_PRESERVATION_S)
 #define ICE_AQC_NVM_NO_PRESERVATION	(0 << ICE_AQC_NVM_PRESERVATION_S)
 #define ICE_AQC_NVM_PRESERVE_ALL	BIT(1)
+#define ICE_AQC_NVM_FACTORY_DEFAULT	(2 << ICE_AQC_NVM_PRESERVATION_S)
 #define ICE_AQC_NVM_PRESERVE_SELECTED	(3 << ICE_AQC_NVM_PRESERVATION_S)
+#define ICE_AQC_NVM_ACTIV_SEL_NVM	BIT(3) /* Write Activate/SR Dump only */
+#define ICE_AQC_NVM_ACTIV_SEL_OROM	BIT(4)
+#define ICE_AQC_NVM_ACTIV_SEL_NETLIST	BIT(5)
+#define ICE_AQC_NVM_SPECIAL_UPDATE	BIT(6)
+#define ICE_AQC_NVM_REVERT_LAST_ACTIV	BIT(6) /* Write Activate only */
+#define ICE_AQC_NVM_ACTIV_SEL_MASK	ICE_M(0x7, 3)
 #define ICE_AQC_NVM_FLASH_ONLY		BIT(7)
 	__le16 module_typeid;
 	__le16 length;
@@ -1348,6 +1355,67 @@ struct ice_aqc_nvm_checksum {
 #define ICE_AQC_NVM_NETLIST_ID_BLK_SHA_HASH		0xA
 #define ICE_AQC_NVM_NETLIST_ID_BLK_CUST_VER		0x2F
 
+/* Used for NVM Set Package Data command - 0x070A */
+struct ice_aqc_nvm_pkg_data {
+	u8 reserved[3];
+	u8 cmd_flags;
+#define ICE_AQC_NVM_PKG_DELETE		BIT(0) /* used for command call */
+#define ICE_AQC_NVM_PKG_SKIPPED		BIT(0) /* used for command response */
+
+	u32 reserved1;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+/* Used for Pass Component Table command - 0x070B */
+struct ice_aqc_nvm_pass_comp_tbl {
+	u8 component_response; /* Response only */
+#define ICE_AQ_NVM_PASS_COMP_CAN_BE_UPDATED		0x0
+#define ICE_AQ_NVM_PASS_COMP_CAN_MAY_BE_UPDATEABLE	0x1
+#define ICE_AQ_NVM_PASS_COMP_CAN_NOT_BE_UPDATED		0x2
+	u8 component_response_code; /* Response only */
+#define ICE_AQ_NVM_PASS_COMP_CAN_BE_UPDATED_CODE	0x0
+#define ICE_AQ_NVM_PASS_COMP_STAMP_IDENTICAL_CODE	0x1
+#define ICE_AQ_NVM_PASS_COMP_STAMP_LOWER		0x2
+#define ICE_AQ_NVM_PASS_COMP_INVALID_STAMP_CODE		0x3
+#define ICE_AQ_NVM_PASS_COMP_CONFLICT_CODE		0x4
+#define ICE_AQ_NVM_PASS_COMP_PRE_REQ_NOT_MET_CODE	0x5
+#define ICE_AQ_NVM_PASS_COMP_NOT_SUPPORTED_CODE		0x6
+#define ICE_AQ_NVM_PASS_COMP_CANNOT_DOWNGRADE_CODE	0x7
+#define ICE_AQ_NVM_PASS_COMP_INCOMPLETE_IMAGE_CODE	0x8
+#define ICE_AQ_NVM_PASS_COMP_VER_STR_IDENTICAL_CODE	0xA
+#define ICE_AQ_NVM_PASS_COMP_VER_STR_LOWER_CODE		0xB
+	u8 reserved;
+	u8 transfer_flag;
+#define ICE_AQ_NVM_PASS_COMP_TBL_START			0x1
+#define ICE_AQ_NVM_PASS_COMP_TBL_MIDDLE			0x2
+#define ICE_AQ_NVM_PASS_COMP_TBL_END			0x4
+#define ICE_AQ_NVM_PASS_COMP_TBL_START_AND_END		0x5
+	__le32 reserved1;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+struct ice_aqc_nvm_comp_tbl {
+	__le16 comp_class;
+#define NVM_COMP_CLASS_ALL_FW	0x000A
+
+	__le16 comp_id;
+#define NVM_COMP_ID_OROM	0x5
+#define NVM_COMP_ID_NVM		0x6
+#define NVM_COMP_ID_NETLIST	0x8
+
+	u8 comp_class_idx;
+#define FWU_COMP_CLASS_IDX_NOT_USE 0x0
+
+	__le32 comp_cmp_stamp;
+	u8 cvs_type;
+#define NVM_CVS_TYPE_ASCII	0x1
+
+	u8 cvs_len;
+	u8 cvs[]; /* Component Version String */
+} __packed;
+
 /**
  * Send to PF command (indirect 0x0801) ID is only used by PF
  *
@@ -1795,6 +1863,8 @@ struct ice_aq_desc {
 		struct ice_aqc_rl_profile rl_profile;
 		struct ice_aqc_nvm nvm;
 		struct ice_aqc_nvm_checksum nvm_checksum;
+		struct ice_aqc_nvm_pkg_data pkg_data;
+		struct ice_aqc_nvm_pass_comp_tbl pass_comp_tbl;
 		struct ice_aqc_pf_vf_msg virt;
 		struct ice_aqc_lldp_get_mib lldp_get_mib;
 		struct ice_aqc_lldp_set_mib_change lldp_set_event;
@@ -1923,7 +1993,13 @@ enum ice_adminq_opc {
 
 	/* NVM commands */
 	ice_aqc_opc_nvm_read				= 0x0701,
+	ice_aqc_opc_nvm_erase				= 0x0702,
+	ice_aqc_opc_nvm_write				= 0x0703,
 	ice_aqc_opc_nvm_checksum			= 0x0706,
+	ice_aqc_opc_nvm_write_activate			= 0x0707,
+	ice_aqc_opc_nvm_update_empr			= 0x0709,
+	ice_aqc_opc_nvm_pkg_data			= 0x070A,
+	ice_aqc_opc_nvm_pass_component_tbl		= 0x070B,
 
 	/* PF/VF mailbox commands */
 	ice_mbx_opc_send_msg_to_pf			= 0x0801,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 33a681a75439..d8b33d7285c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -11,8 +11,6 @@
 #include "ice_switch.h"
 #include <linux/avf/virtchnl.h>
 
-enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw);
-
 enum ice_status ice_init_hw(struct ice_hw *hw);
 void ice_deinit_hw(struct ice_hw *hw);
 enum ice_status ice_check_reset(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 7c2a06892bbb..5903a36763de 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -107,6 +107,76 @@ ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
 	return status;
 }
 
+/**
+ * ice_aq_update_nvm
+ * @hw: pointer to the HW struct
+ * @module_typeid: module pointer location in words from the NVM beginning
+ * @offset: byte offset from the module beginning
+ * @length: length of the section to be written (in bytes from the offset)
+ * @data: command buffer (size [bytes] = length)
+ * @last_command: tells if this is the last command in a series
+ * @command_flags: command parameters
+ * @cd: pointer to command details structure or NULL
+ *
+ * Update the NVM using the admin queue commands (0x0703)
+ */
+enum ice_status
+ice_aq_update_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset,
+		  u16 length, void *data, bool last_command, u8 command_flags,
+		  struct ice_sq_cd *cd)
+{
+	struct ice_aq_desc desc;
+	struct ice_aqc_nvm *cmd;
+
+	cmd = &desc.params.nvm;
+
+	/* In offset the highest byte must be zeroed. */
+	if (offset & 0xFF000000)
+		return ICE_ERR_PARAM;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_write);
+
+	cmd->cmd_flags |= command_flags;
+
+	/* If this is the last command in a series, set the proper flag. */
+	if (last_command)
+		cmd->cmd_flags |= ICE_AQC_NVM_LAST_CMD;
+	cmd->module_typeid = cpu_to_le16(module_typeid);
+	cmd->offset_low = cpu_to_le16(offset & 0xFFFF);
+	cmd->offset_high = (offset >> 16) & 0xFF;
+	cmd->length = cpu_to_le16(length);
+
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	return ice_aq_send_cmd(hw, &desc, data, length, cd);
+}
+
+/**
+ * ice_aq_erase_nvm
+ * @hw: pointer to the HW struct
+ * @module_typeid: module pointer location in words from the NVM beginning
+ * @cd: pointer to command details structure or NULL
+ *
+ * Erase the NVM sector using the admin queue commands (0x0702)
+ */
+enum ice_status
+ice_aq_erase_nvm(struct ice_hw *hw, u16 module_typeid, struct ice_sq_cd *cd)
+{
+	struct ice_aq_desc desc;
+	struct ice_aqc_nvm *cmd;
+
+	cmd = &desc.params.nvm;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_erase);
+
+	cmd->module_typeid = cpu_to_le16(module_typeid);
+	cmd->length = cpu_to_le16(ICE_AQC_NVM_ERASE_LEN);
+	cmd->offset_low = 0;
+	cmd->offset_high = 0;
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
+}
+
 /**
  * ice_read_sr_word_aq - Reads Shadow RAM via AQ
  * @hw: pointer to the HW structure
@@ -634,3 +704,119 @@ enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw)
 
 	return status;
 }
+
+/**
+ * ice_nvm_write_activate
+ * @hw: pointer to the HW struct
+ * @cmd_flags: NVM activate admin command bits (banks to be validated)
+ *
+ * Update the control word with the required banks' validity bits
+ * and dumps the Shadow RAM to flash (0x0707)
+ */
+enum ice_status ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags)
+{
+	struct ice_aqc_nvm *cmd;
+	struct ice_aq_desc desc;
+
+	cmd = &desc.params.nvm;
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_write_activate);
+
+	cmd->cmd_flags = cmd_flags;
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+}
+
+/**
+ * ice_aq_nvm_update_empr
+ * @hw: pointer to the HW struct
+ *
+ * Update empr (0x0709). This command allows SW to
+ * request an EMPR to activate new FW.
+ */
+enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw)
+{
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_update_empr);
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+}
+
+/* ice_nvm_set_pkg_data
+ * @hw: pointer to the HW struct
+ * @del_pkg_data_flag: If is set then the current pkg_data store by FW
+ *		       is deleted.
+ *		       If bit is set to 1, then buffer should be size 0.
+ * @data: pointer to buffer
+ * @length: length of the buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Set package data (0x070A). This command is equivalent to the reception
+ * of a PLDM FW Update GetPackageData cmd. This command should be sent
+ * as part of the NVM update as the first cmd in the flow.
+ */
+
+enum ice_status
+ice_nvm_set_pkg_data(struct ice_hw *hw, bool del_pkg_data_flag, u8 *data,
+		     u16 length, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_nvm_pkg_data *cmd;
+	struct ice_aq_desc desc;
+
+	if (length != 0 && !data)
+		return ICE_ERR_PARAM;
+
+	cmd = &desc.params.pkg_data;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_pkg_data);
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	if (del_pkg_data_flag)
+		cmd->cmd_flags |= ICE_AQC_NVM_PKG_DELETE;
+
+	return ice_aq_send_cmd(hw, &desc, data, length, cd);
+}
+
+/* ice_nvm_pass_component_tbl
+ * @hw: pointer to the HW struct
+ * @data: pointer to buffer
+ * @length: length of the buffer
+ * @transfer_flag: parameter for determining stage of the update
+ * @comp_response: a pointer to the response from the 0x070B AQC.
+ * @comp_response_code: a pointer to the response code from the 0x070B AQC.
+ * @cd: pointer to command details structure or NULL
+ *
+ * Pass component table (0x070B). This command is equivalent to the reception
+ * of a PLDM FW Update PassComponentTable cmd. This command should be sent once
+ * per component. It can be only sent after Set Package Data cmd and before
+ * actual update. FW will assume these commands are going to be sent until
+ * the TransferFlag is set to End or StartAndEnd.
+ */
+
+enum ice_status
+ice_nvm_pass_component_tbl(struct ice_hw *hw, u8 *data, u16 length,
+			   u8 transfer_flag, u8 *comp_response,
+			   u8 *comp_response_code, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_nvm_pass_comp_tbl *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	if (!data || !comp_response || !comp_response_code)
+		return ICE_ERR_PARAM;
+
+	cmd = &desc.params.pass_comp_tbl;
+
+	ice_fill_dflt_direct_cmd_desc(&desc,
+				      ice_aqc_opc_nvm_pass_component_tbl);
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	cmd->transfer_flag = transfer_flag;
+	status = ice_aq_send_cmd(hw, &desc, data, length, cd);
+
+	if (!status) {
+		*comp_response = cmd->component_response;
+		*comp_response_code = cmd->component_response_code;
+	}
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index 999f273ba6ad..8d430909f846 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -17,4 +17,20 @@ enum ice_status
 ice_read_pba_string(struct ice_hw *hw, u8 *pba_num, u32 pba_num_size);
 enum ice_status ice_init_nvm(struct ice_hw *hw);
 enum ice_status ice_read_sr_word(struct ice_hw *hw, u16 offset, u16 *data);
+enum ice_status
+ice_aq_update_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset,
+		  u16 length, void *data, bool last_command, u8 command_flags,
+		  struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_erase_nvm(struct ice_hw *hw, u16 module_typeid, struct ice_sq_cd *cd);
+enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw);
+enum ice_status ice_nvm_write_activate(struct ice_hw *hw, u8 cmd_flags);
+enum ice_status ice_aq_nvm_update_empr(struct ice_hw *hw);
+enum ice_status
+ice_nvm_set_pkg_data(struct ice_hw *hw, bool del_pkg_data_flag, u8 *data,
+		     u16 length, struct ice_sq_cd *cd);
+enum ice_status
+ice_nvm_pass_component_tbl(struct ice_hw *hw, u8 *data, u16 length,
+			   u8 transfer_flag, u8 *comp_response,
+			   u8 *comp_response_code, struct ice_sq_cd *cd);
 #endif /* _ICE_NVM_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 8eb1f184a886..1022086e8920 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -774,6 +774,9 @@ struct ice_hw_port_stats {
 #define ICE_OROM_VER_SHIFT		24
 #define ICE_OROM_VER_MASK		(0xff << ICE_OROM_VER_SHIFT)
 #define ICE_SR_PFA_PTR			0x40
+#define ICE_SR_1ST_NVM_BANK_PTR		0x42
+#define ICE_SR_1ST_OROM_BANK_PTR	0x44
+#define ICE_SR_NETLIST_BANK_PTR		0x46
 #define ICE_SR_SECTOR_SIZE_IN_WORDS	0x800
 
 /* Link override related */
-- 
2.28.0.rc1.139.gd6b33fda9dd1

