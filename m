Return-Path: <netdev+bounces-4787-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B9470E2E0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 131C1281172
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4306521CE8;
	Tue, 23 May 2023 17:44:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F8421CD8
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:44:22 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F840E6
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684863857; x=1716399857;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=icixospv0y1xDGtqtIcrUO0gX9dndeqN0oFuaRN0PCw=;
  b=eGtsdeQrpjU6/xGSCpy1Vn9AEYEPUZ82oxJSVuPA/QONSqLej1MQ9+Pp
   3LfivQX4X++e9O3PKBPIZvE20/URibLEI8fU570CydKXlZGH+DB+V2M1U
   P7w/4w5gL6d8h/p9PrI2ntjFCpu2zcEfC81C9+7eSIDY6x2nuhkhaK77c
   zs/BZ/PQjy/O0dqVDKOj63fcj2m2XVJbnQmMZ1zms9fSxsilQgCi6ZJ52
   0gBAahmawThUJY2PdEV7hjjgX+KDkcanmxBEs1YYZUnTz3BJqG0LYvnk3
   dE11PEg2pWHNDJDnVY65FFfu+LVv5/sDLFufFM8oxfhL4H/jj/SbA4ByC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="419023275"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="419023275"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 10:44:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="816223446"
X-IronPort-AV: E=Sophos;i="6.00,187,1681196400"; 
   d="scan'208";a="816223446"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 23 May 2023 10:44:05 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Lukasz Czapnik <lukasz.czapnik@intel.com>,
	anthony.l.nguyen@intel.com,
	przemyslaw.kitszel@intel.com,
	jiri@resnulli.us,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next 4/5] ice: Add txbalancing devlink param
Date: Tue, 23 May 2023 10:40:07 -0700
Message-Id: <20230523174008.3585300-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
References: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

It was observed that Tx performance was inconsistent across all queues
and/or VSIs and that it was directly connected to existing 9-layer
topology of the Tx scheduler.

Introduce new private devlink param - txbalance. This parameter gives user
flexibility to choose the 5-layer transmit scheduler topology which helps
to smooth out the transmit performance.

Allowed parameter values are true for enabled and false for disabled.

Example usage:

Show:
devlink dev param show pci/0000:4b:00.0 name txbalancing
pci/0000:4b:00.0:
  name txbalancing type driver-specific
    values:
      cmode permanent value true

Set:
devlink dev param set pci/0000:4b:00.0 name txbalancing value true cmode
permanent

Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 161 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_fw_update.c    |   2 +-
 .../net/ethernet/intel/ice/ice_fw_update.h    |   3 +
 drivers/net/ethernet/intel/ice/ice_nvm.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_nvm.h      |   3 +
 6 files changed, 177 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index d1a449b07fdf..8a624cef0eb0 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1571,6 +1571,15 @@ struct ice_aqc_nvm {
 };
 
 #define ICE_AQC_NVM_START_POINT			0
+#define ICE_AQC_NVM_TX_TOPO_MOD_ID		0x14B
+
+struct ice_aqc_nvm_tx_topo_user_sel {
+	__le16 length;
+	u8 data;
+#define ICE_AQC_NVM_TX_TOPO_USER_SEL		BIT(4)
+
+	u8 reserved;
+};
 
 /* NVM Checksum Command (direct, 0x0706) */
 struct ice_aqc_nvm_checksum {
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index bc44cc220818..c716b1442d17 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -736,6 +736,159 @@ ice_devlink_port_unsplit(struct devlink *devlink, struct devlink_port *port,
 	return ice_devlink_port_split(devlink, port, 1, extack);
 }
 
+enum ice_devlink_param_id {
+	ICE_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	ICE_DEVLINK_PARAM_ID_TX_BALANCE,
+};
+
+/**
+ * ice_get_tx_topo_user_sel - Read user's choice from flash
+ * @pf: pointer to pf structure
+ * @txbalance_ena: value read from flash will be saved here
+ *
+ * Reads user's preference for Tx Scheduler Topology Tree from PFA TLV.
+ *
+ * Returns zero when read was successful, negative values otherwise.
+ */
+static int ice_get_tx_topo_user_sel(struct ice_pf *pf, bool *txbalance_ena)
+{
+	struct ice_aqc_nvm_tx_topo_user_sel usr_sel = {};
+	struct ice_hw *hw = &pf->hw;
+	int status;
+
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (status)
+		return status;
+
+	status = ice_aq_read_nvm(hw, ICE_AQC_NVM_TX_TOPO_MOD_ID, 0,
+				 sizeof(usr_sel), &usr_sel, true, true, NULL);
+	ice_release_nvm(hw);
+
+	*txbalance_ena = usr_sel.data & ICE_AQC_NVM_TX_TOPO_USER_SEL;
+
+	return status;
+}
+
+/**
+ * ice_update_tx_topo_user_sel - Save user's preference in flash
+ * @pf: pointer to pf structure
+ * @txbalance_ena: value to be saved in flash
+ *
+ * When txbalance_ena is set to true it means user's preference is to use
+ * five layer Tx Scheduler Topology Tree, when it is set to false then it is
+ * nine layer. This choice should be stored in PFA TLV field and should be
+ * picked up by driver, next time during init.
+ *
+ * Returns zero when save was successful, negative values otherwise.
+ */
+static int ice_update_tx_topo_user_sel(struct ice_pf *pf, bool txbalance_ena)
+{
+	struct ice_aqc_nvm_tx_topo_user_sel usr_sel = {};
+	struct ice_hw *hw = &pf->hw;
+	int err;
+
+	err = ice_acquire_nvm(hw, ICE_RES_WRITE);
+	if (err)
+		return err;
+
+	err = ice_aq_read_nvm(hw, ICE_AQC_NVM_TX_TOPO_MOD_ID, 0,
+			      sizeof(usr_sel), &usr_sel, true, true, NULL);
+	if (err)
+		goto exit_release_res;
+
+	if (txbalance_ena)
+		usr_sel.data |= ICE_AQC_NVM_TX_TOPO_USER_SEL;
+	else
+		usr_sel.data &= ~ICE_AQC_NVM_TX_TOPO_USER_SEL;
+
+	err = ice_write_one_nvm_block(pf, ICE_AQC_NVM_TX_TOPO_MOD_ID, 2,
+				      sizeof(usr_sel.data), &usr_sel.data,
+				      true, NULL, NULL);
+	if (err)
+		err = -EIO;
+
+exit_release_res:
+	ice_release_nvm(hw);
+
+	return err;
+}
+
+/**
+ * ice_devlink_txbalance_get - Get txbalance parameter
+ * @devlink: pointer to the devlink instance
+ * @id: the parameter ID to set
+ * @ctx: context to store the parameter value
+ *
+ * Returns zero on success and negative value on failure.
+ */
+static int ice_devlink_txbalance_get(struct devlink *devlink, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	int status;
+
+	status = ice_get_tx_topo_user_sel(pf, &ctx->val.vbool);
+	if (status) {
+		dev_warn(dev, "Failed to read Tx Scheduler Tree - User Selection data from flash\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_devlink_txbalance_set - Set txbalance parameter
+ * @devlink: pointer to the devlink instance
+ * @id: the parameter ID to set
+ * @ctx: context to get the parameter value
+ *
+ * Returns zero on success and negative value on failure.
+ */
+static int ice_devlink_txbalance_set(struct devlink *devlink, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct device *dev = ice_pf_to_dev(pf);
+	int status;
+
+	status = ice_update_tx_topo_user_sel(pf, ctx->val.vbool);
+	if (status)
+		return -EIO;
+
+	dev_warn(dev, "Transmit balancing setting has been changed on this device. You must reboot the system for the change to take effect");
+
+	return 0;
+}
+
+/**
+ * ice_devlink_txbalance_validate - Validate passed txbalance parameter value
+ * @devlink: unused pointer to devlink instance
+ * @id: the parameter ID to validate
+ * @val: value to validate
+ * @extack: netlink extended ACK structure
+ *
+ * Supported values are:
+ * true - five layer, false - nine layer Tx Scheduler Topology Tree
+ *
+ * Returns zero when passed parameter value is supported. Negative value on
+ * error.
+ */
+static int ice_devlink_txbalance_validate(struct devlink *devlink, u32 id,
+					  union devlink_param_value val,
+					  struct netlink_ext_ack *extack)
+{
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct ice_hw *hw = &pf->hw;
+
+	if (!hw->func_caps.common_cap.tx_sched_topo_comp_mode_en) {
+		NL_SET_ERR_MSG_MOD(extack, "Error: Requested feature is not supported by the FW on this device. Update the FW and run this command again.");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 /**
  * ice_tear_down_devlink_rate_tree - removes devlink-rate exported tree
  * @pf: pf struct
@@ -1391,7 +1544,13 @@ static const struct devlink_param ice_devlink_params[] = {
 			      ice_devlink_enable_iw_get,
 			      ice_devlink_enable_iw_set,
 			      ice_devlink_enable_iw_validate),
-
+	DEVLINK_PARAM_DRIVER(ICE_DEVLINK_PARAM_ID_TX_BALANCE,
+			     "txbalancing",
+			     DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     ice_devlink_txbalance_get,
+			     ice_devlink_txbalance_set,
+			     ice_devlink_txbalance_validate),
 };
 
 static void ice_devlink_free(void *devlink_ptr)
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 3dc5662d62a6..dc5b49104674 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -286,7 +286,7 @@ ice_send_component_table(struct pldmfw *context, struct pldmfw_component *compon
  *
  * Returns: zero on success, or a negative error code on failure.
  */
-static int
+int
 ice_write_one_nvm_block(struct ice_pf *pf, u16 module, u32 offset,
 			u16 block_size, u8 *block, bool last_cmd,
 			u8 *reset_level, struct netlink_ext_ack *extack)
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.h b/drivers/net/ethernet/intel/ice/ice_fw_update.h
index 750574885716..04b200462757 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.h
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.h
@@ -9,5 +9,8 @@ int ice_devlink_flash_update(struct devlink *devlink,
 			     struct netlink_ext_ack *extack);
 int ice_get_pending_updates(struct ice_pf *pf, u8 *pending,
 			    struct netlink_ext_ack *extack);
+int ice_write_one_nvm_block(struct ice_pf *pf, u16 module, u32 offset,
+			    u16 block_size, u8 *block, bool last_cmd,
+			    u8 *reset_level, struct netlink_ext_ack *extack);
 
 #endif
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index f6f52a248066..745f2459943f 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -18,7 +18,7 @@
  *
  * Read the NVM using the admin queue commands (0x0701)
  */
-static int
+int
 ice_aq_read_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset, u16 length,
 		void *data, bool last_command, bool read_shadow_ram,
 		struct ice_sq_cd *cd)
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.h b/drivers/net/ethernet/intel/ice/ice_nvm.h
index 774c2317967d..88978b9a95b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.h
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.h
@@ -14,6 +14,9 @@ struct ice_orom_civd_info {
 
 int ice_acquire_nvm(struct ice_hw *hw, enum ice_aq_res_access_type access);
 void ice_release_nvm(struct ice_hw *hw);
+int ice_aq_read_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset, u16 length,
+		    void *data, bool last_command, bool read_shadow_ram,
+		    struct ice_sq_cd *cd);
 int
 ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
 		  bool read_shadow_ram);
-- 
2.38.1


