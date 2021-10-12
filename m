Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4444042A983
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhJLQhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:37:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:1914 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231165AbhJLQhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:37:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="227102073"
X-IronPort-AV: E=Sophos;i="5.85,368,1624345200"; 
   d="scan'208";a="227102073"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 09:33:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,368,1624345200"; 
   d="scan'208";a="491050687"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 12 Oct 2021 09:33:49 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Machnikowski <maciej.machnikowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 3/4] ice: Add support for SMA control multiplexer
Date:   Tue, 12 Oct 2021 09:31:52 -0700
Message-Id: <20211012163153.2104212-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012163153.2104212-1-anthony.l.nguyen@intel.com>
References: <20211012163153.2104212-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Machnikowski <maciej.machnikowski@intel.com>

E810-T adapters have two external bidirectional SMA connectors and two
internal unidirectional U.FL connectors. Multiplexing between U.FL and
SMA and SMA direction is controlled using the PCA9575 expander.

Add support for the PCA9575 detection and control of the respective pins
of the SMA/U.FL multiplexer using the GPIO AQ API.

Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  21 +++
 drivers/net/ethernet/intel/ice/ice_common.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_devids.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   | 156 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  22 +++
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 7 files changed, 204 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 25708c320f5d..a5425f0dce3f 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1331,6 +1331,7 @@ struct ice_aqc_link_topo_addr {
 struct ice_aqc_get_link_topo {
 	struct ice_aqc_link_topo_addr addr;
 	u8 node_part_num;
+#define ICE_AQC_GET_LINK_TOPO_NODE_NR_PCA9575	0x21
 	u8 rsvd[9];
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 7416f802a558..16a25616cdc3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -69,6 +69,27 @@ bool ice_is_e810(struct ice_hw *hw)
 	return hw->mac_type == ICE_MAC_E810;
 }
 
+/**
+ * ice_is_e810t
+ * @hw: pointer to the hardware structure
+ *
+ * returns true if the device is E810T based, false if not.
+ */
+bool ice_is_e810t(struct ice_hw *hw)
+{
+	switch (hw->device_id) {
+	case ICE_DEV_ID_E810C_SFP:
+		if (hw->subsystem_device_id == ICE_SUBDEV_ID_E810T ||
+		    hw->subsystem_device_id == ICE_SUBDEV_ID_E810T2)
+			return true;
+		break;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 /**
  * ice_clear_pf_cfg - Clear PF configuration
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 4273f8921e53..65c1b3244264 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -183,6 +183,7 @@ ice_stat_update40(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 void
 ice_stat_update32(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
+bool ice_is_e810t(struct ice_hw *hw);
 enum ice_status
 ice_sched_query_elem(struct ice_hw *hw, u32 node_teid,
 		     struct ice_aqc_txsched_elem_data *buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index 9d8194671f6a..8d2c39ee775b 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -21,6 +21,8 @@
 #define ICE_DEV_ID_E810C_QSFP		0x1592
 /* Intel(R) Ethernet Controller E810-C for SFP */
 #define ICE_DEV_ID_E810C_SFP		0x1593
+#define ICE_SUBDEV_ID_E810T		0x000E
+#define ICE_SUBDEV_ID_E810T2		0x000F
 /* Intel(R) Ethernet Controller E810-XXV for SFP */
 #define ICE_DEV_ID_E810_XXV_SFP		0x159B
 /* Intel(R) Ethernet Connection E823-C for backplane */
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 3eca0e4eab0b..3e61b4473f8c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -649,3 +649,159 @@ int ice_clear_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx)
 {
 	return ice_clear_phy_tstamp_e810(hw, block, idx);
 }
+
+/* E810T SMA functions
+ *
+ * The following functions operate specifically on E810T hardware and are used
+ * to access the extended GPIOs available.
+ */
+
+/**
+ * ice_get_pca9575_handle
+ * @hw: pointer to the hw struct
+ * @pca9575_handle: GPIO controller's handle
+ *
+ * Find and return the GPIO controller's handle in the netlist.
+ * When found - the value will be cached in the hw structure and following calls
+ * will return cached value
+ */
+static int
+ice_get_pca9575_handle(struct ice_hw *hw, u16 *pca9575_handle)
+{
+	struct ice_aqc_get_link_topo *cmd;
+	struct ice_aq_desc desc;
+	int status;
+	u8 idx;
+
+	if (!hw || !pca9575_handle)
+		return -EINVAL;
+
+	/* If handle was read previously return cached value */
+	if (hw->io_expander_handle) {
+		*pca9575_handle = hw->io_expander_handle;
+		return 0;
+	}
+
+	/* If handle was not detected read it from the netlist */
+	cmd = &desc.params.get_link_topo;
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_link_topo);
+
+	/* Set node type to GPIO controller */
+	cmd->addr.topo_params.node_type_ctx =
+		(ICE_AQC_LINK_TOPO_NODE_TYPE_M &
+		 ICE_AQC_LINK_TOPO_NODE_TYPE_GPIO_CTRL);
+
+#define SW_PCA9575_SFP_TOPO_IDX		2
+#define SW_PCA9575_QSFP_TOPO_IDX	1
+
+	/* Check if the SW IO expander controlling SMA exists in the netlist. */
+	if (hw->device_id == ICE_DEV_ID_E810C_SFP)
+		idx = SW_PCA9575_SFP_TOPO_IDX;
+	else if (hw->device_id == ICE_DEV_ID_E810C_QSFP)
+		idx = SW_PCA9575_QSFP_TOPO_IDX;
+	else
+		return -EOPNOTSUPP;
+
+	cmd->addr.topo_params.index = idx;
+
+	status = ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+	if (status)
+		return -EOPNOTSUPP;
+
+	/* Verify if we found the right IO expander type */
+	if (desc.params.get_link_topo.node_part_num !=
+		ICE_AQC_GET_LINK_TOPO_NODE_NR_PCA9575)
+		return -EOPNOTSUPP;
+
+	/* If present save the handle and return it */
+	hw->io_expander_handle =
+		le16_to_cpu(desc.params.get_link_topo.addr.handle);
+	*pca9575_handle = hw->io_expander_handle;
+
+	return 0;
+}
+
+/**
+ * ice_read_sma_ctrl_e810t
+ * @hw: pointer to the hw struct
+ * @data: pointer to data to be read from the GPIO controller
+ *
+ * Read the SMA controller state. It is connected to pins 3-7 of Port 1 of the
+ * PCA9575 expander, so only bits 3-7 in data are valid.
+ */
+int ice_read_sma_ctrl_e810t(struct ice_hw *hw, u8 *data)
+{
+	int status;
+	u16 handle;
+	u8 i;
+
+	status = ice_get_pca9575_handle(hw, &handle);
+	if (status)
+		return status;
+
+	*data = 0;
+
+	for (i = ICE_SMA_MIN_BIT_E810T; i <= ICE_SMA_MAX_BIT_E810T; i++) {
+		bool pin;
+
+		status = ice_aq_get_gpio(hw, handle, i + ICE_PCA9575_P1_OFFSET,
+					 &pin, NULL);
+		if (status)
+			break;
+		*data |= (u8)(!pin) << i;
+	}
+
+	return status;
+}
+
+/**
+ * ice_write_sma_ctrl_e810t
+ * @hw: pointer to the hw struct
+ * @data: data to be written to the GPIO controller
+ *
+ * Write the data to the SMA controller. It is connected to pins 3-7 of Port 1
+ * of the PCA9575 expander, so only bits 3-7 in data are valid.
+ */
+int ice_write_sma_ctrl_e810t(struct ice_hw *hw, u8 data)
+{
+	int status;
+	u16 handle;
+	u8 i;
+
+	status = ice_get_pca9575_handle(hw, &handle);
+	if (status)
+		return status;
+
+	for (i = ICE_SMA_MIN_BIT_E810T; i <= ICE_SMA_MAX_BIT_E810T; i++) {
+		bool pin;
+
+		pin = !(data & (1 << i));
+		status = ice_aq_set_gpio(hw, handle, i + ICE_PCA9575_P1_OFFSET,
+					 pin, NULL);
+		if (status)
+			break;
+	}
+
+	return status;
+}
+
+/**
+ * ice_is_pca9575_present
+ * @hw: pointer to the hw struct
+ *
+ * Check if the SW IO expander is present in the netlist
+ */
+bool ice_is_pca9575_present(struct ice_hw *hw)
+{
+	u16 handle = 0;
+	int status;
+
+	if (!ice_is_e810t(hw))
+		return false;
+
+	status = ice_get_pca9575_handle(hw, &handle);
+	if (!status && handle)
+		return true;
+
+	return false;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index 55a414e87018..b2984b5c22c1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -30,6 +30,9 @@ int ice_clear_phy_tstamp(struct ice_hw *hw, u8 block, u8 idx);
 
 /* E810 family functions */
 int ice_ptp_init_phy_e810(struct ice_hw *hw);
+int ice_read_sma_ctrl_e810t(struct ice_hw *hw, u8 *data);
+int ice_write_sma_ctrl_e810t(struct ice_hw *hw, u8 data);
+bool ice_is_pca9575_present(struct ice_hw *hw);
 
 #define PFTSYN_SEM_BYTES	4
 
@@ -76,4 +79,23 @@ int ice_ptp_init_phy_e810(struct ice_hw *hw);
 #define LOW_TX_MEMORY_BANK_START	0x03090000
 #define HIGH_TX_MEMORY_BANK_START	0x03090004
 
+/* E810T SMA controller pin control */
+#define ICE_SMA1_DIR_EN_E810T		BIT(4)
+#define ICE_SMA1_TX_EN_E810T		BIT(5)
+#define ICE_SMA2_UFL2_RX_DIS_E810T	BIT(3)
+#define ICE_SMA2_DIR_EN_E810T		BIT(6)
+#define ICE_SMA2_TX_EN_E810T		BIT(7)
+
+#define ICE_SMA1_MASK_E810T	(ICE_SMA1_DIR_EN_E810T | \
+				 ICE_SMA1_TX_EN_E810T)
+#define ICE_SMA2_MASK_E810T	(ICE_SMA2_UFL2_RX_DIS_E810T | \
+				 ICE_SMA2_DIR_EN_E810T | \
+				 ICE_SMA2_TX_EN_E810T)
+#define ICE_ALL_SMA_MASK_E810T	(ICE_SMA1_MASK_E810T | \
+				 ICE_SMA2_MASK_E810T)
+
+#define ICE_SMA_MIN_BIT_E810T	3
+#define ICE_SMA_MAX_BIT_E810T	7
+#define ICE_PCA9575_P1_OFFSET	8
+
 #endif /* _ICE_PTP_HW_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index d22ac1d430d0..d5cb1c5a89c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -916,6 +916,7 @@ struct ice_hw {
 	struct mutex rss_locks;	/* protect RSS configuration */
 	struct list_head rss_list_head;
 	struct ice_mbx_snapshot mbx_snapshot;
+	u16 io_expander_handle;
 };
 
 /* Statistics collected by each port, VSI, VEB, and S-channel */
-- 
2.31.1

