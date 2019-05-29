Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA782E4BD
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfE2SsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:48:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:2790 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfE2Srq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:44 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ice: Add handler for ethtool selftest
Date:   Wed, 29 May 2019 11:47:46 -0700
Message-Id: <20190529184754.12693-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
References: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

This patch adds a handler for ethtool selftest. Selftest includes
testing link, interrupts, eeprom, registers and packet loopback.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   8 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  23 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  23 +
 drivers/net/ethernet/intel/ice/ice_common.h   |   5 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 592 ++++++++++++++++++
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  44 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  33 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |  31 +
 drivers/net/ethernet/intel/ice/ice_status.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 11 files changed, 752 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 0555d09614d8..5c5b9e3e9e5c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -189,6 +189,7 @@ struct ice_sw {
 };
 
 enum ice_state {
+	__ICE_TESTING,
 	__ICE_DOWN,
 	__ICE_NEEDS_RESTART,
 	__ICE_PREPARED_FOR_RESET,	/* set by driver when prepared */
@@ -399,6 +400,7 @@ struct ice_pf {
 	unsigned long tx_timeout_last_recovery;
 	u32 tx_timeout_recovery_level;
 	char int_name[ICE_INT_NAME_STR_LEN];
+	u32 sw_int_count;
 };
 
 struct ice_netdev_priv {
@@ -451,9 +453,13 @@ ice_find_vsi_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 	return NULL;
 }
 
+int ice_vsi_setup_tx_rings(struct ice_vsi *vsi);
+int ice_vsi_setup_rx_rings(struct ice_vsi *vsi);
 void ice_set_ethtool_ops(struct net_device *netdev);
 int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
+int ice_vsi_cfg(struct ice_vsi *vsi);
+struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
 int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
@@ -462,5 +468,7 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
 int ice_pf_ena_all_vsi(struct ice_pf *pf, bool locked);
 void ice_pf_dis_all_vsi(struct ice_pf *pf, bool locked);
 #endif /* CONFIG_DCB */
+int ice_open(struct net_device *netdev);
+int ice_stop(struct net_device *netdev);
 
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 6ef083002f5b..99eeee930dfa 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1112,6 +1112,14 @@ struct ice_aqc_set_event_mask {
 	u8	reserved1[6];
 };
 
+/* Set MAC Loopback command (direct 0x0620) */
+struct ice_aqc_set_mac_lb {
+	u8 lb_mode;
+#define ICE_AQ_MAC_LB_EN		BIT(0)
+#define ICE_AQ_MAC_LB_OSC_CLK		BIT(1)
+	u8 reserved[15];
+};
+
 /* Set Port Identification LED (direct, 0x06E9) */
 struct ice_aqc_set_port_id_led {
 	u8 lport_num;
@@ -1145,6 +1153,17 @@ struct ice_aqc_nvm {
 	__le32 addr_low;
 };
 
+/* NVM Checksum Command (direct, 0x0706) */
+struct ice_aqc_nvm_checksum {
+	u8 flags;
+#define ICE_AQC_NVM_CHECKSUM_VERIFY	BIT(0)
+#define ICE_AQC_NVM_CHECKSUM_RECALC	BIT(1)
+	u8 rsvd;
+	__le16 checksum; /* Used only by response */
+#define ICE_AQC_NVM_CHECKSUM_CORRECT	0xBABA
+	u8 rsvd2[12];
+};
+
 /**
  * Send to PF command (indirect 0x0801) ID is only used by PF
  *
@@ -1539,6 +1558,7 @@ struct ice_aq_desc {
 		struct ice_aqc_query_txsched_res query_sched_res;
 		struct ice_aqc_query_port_ets port_ets;
 		struct ice_aqc_nvm nvm;
+		struct ice_aqc_nvm_checksum nvm_checksum;
 		struct ice_aqc_pf_vf_msg virt;
 		struct ice_aqc_lldp_get_mib lldp_get_mib;
 		struct ice_aqc_lldp_set_mib_change lldp_set_event;
@@ -1554,6 +1574,7 @@ struct ice_aq_desc {
 		struct ice_aqc_add_update_free_vsi_resp add_update_free_vsi_res;
 		struct ice_aqc_fw_logging fw_logging;
 		struct ice_aqc_get_clear_fw_log get_clear_fw_log;
+		struct ice_aqc_set_mac_lb set_mac_lb;
 		struct ice_aqc_alloc_free_res_cmd sw_res_ctrl;
 		struct ice_aqc_set_event_mask set_event_mask;
 		struct ice_aqc_get_link_status get_link_status;
@@ -1642,10 +1663,12 @@ enum ice_adminq_opc {
 	ice_aqc_opc_restart_an				= 0x0605,
 	ice_aqc_opc_get_link_status			= 0x0607,
 	ice_aqc_opc_set_event_mask			= 0x0613,
+	ice_aqc_opc_set_mac_lb				= 0x0620,
 	ice_aqc_opc_set_port_id_led			= 0x06E9,
 
 	/* NVM commands */
 	ice_aqc_opc_nvm_read				= 0x0701,
+	ice_aqc_opc_nvm_checksum			= 0x0706,
 
 	/* PF/VF mailbox commands */
 	ice_mbx_opc_send_msg_to_pf			= 0x0801,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 1ad541a010fb..a377d5b3da34 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2169,6 +2169,29 @@ ice_aq_set_event_mask(struct ice_hw *hw, u8 port_num, u16 mask,
 	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
 }
 
+/**
+ * ice_aq_set_mac_loopback
+ * @hw: pointer to the HW struct
+ * @ena_lpbk: Enable or Disable loopback
+ * @cd: pointer to command details structure or NULL
+ *
+ * Enable/disable loopback on a given port
+ */
+enum ice_status
+ice_aq_set_mac_loopback(struct ice_hw *hw, bool ena_lpbk, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_set_mac_lb *cmd;
+	struct ice_aq_desc desc;
+
+	cmd = &desc.params.set_mac_lb;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_set_mac_lb);
+	if (ena_lpbk)
+		cmd->lb_mode = ICE_AQ_MAC_LB_EN;
+
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
+}
+
 /**
  * ice_aq_set_port_id_led
  * @pi: pointer to the port information
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index f1ddebf45231..9773d7b2e9c9 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -9,6 +9,8 @@
 #include "ice_switch.h"
 #include <linux/avf/virtchnl.h>
 
+enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw);
+
 void
 ice_debug_cq(struct ice_hw *hw, u32 mask, void *desc, void *buf, u16 buf_len);
 enum ice_status ice_init_hw(struct ice_hw *hw);
@@ -94,6 +96,9 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 enum ice_status
 ice_aq_set_event_mask(struct ice_hw *hw, u8 port_num, u16 mask,
 		      struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_set_mac_loopback(struct ice_hw *hw, bool ena_lpbk, struct ice_sq_cd *cd);
+
 enum ice_status
 ice_aq_set_port_id_led(struct ice_port_info *pi, bool is_orig_mode,
 		       struct ice_sq_cd *cd);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 1214325eb80b..9dd628e20091 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -61,6 +61,24 @@ static const struct ice_stats ice_gstrings_vsi_stats[] = {
 	ICE_VSI_STAT("tx_linearize", tx_linearize),
 };
 
+enum ice_ethtool_test_id {
+	ICE_ETH_TEST_REG = 0,
+	ICE_ETH_TEST_EEPROM,
+	ICE_ETH_TEST_INTR,
+	ICE_ETH_TEST_LOOP,
+	ICE_ETH_TEST_LINK,
+};
+
+static const char ice_gstrings_test[][ETH_GSTRING_LEN] = {
+	"Register test  (offline)",
+	"EEPROM test    (offline)",
+	"Interrupt test (offline)",
+	"Loopback test  (offline)",
+	"Link test   (on/offline)",
+};
+
+#define ICE_TEST_LEN (sizeof(ice_gstrings_test) / ETH_GSTRING_LEN)
+
 /* These PF_STATs might look like duplicates of some NETDEV_STATs,
  * but they aren't. This device is capable of supporting multiple
  * VSIs/netdevs on a single PF. The NETDEV_STATs are for individual
@@ -120,6 +138,9 @@ static const u32 ice_regs_dump_list[] = {
 	QINT_RQCTL(0),
 	PFINT_OICR_ENA,
 	QRX_ITR(0),
+	PF0INT_ITR_0(0),
+	PF0INT_ITR_1(0),
+	PF0INT_ITR_2(0),
 };
 
 struct ice_priv_flag {
@@ -278,6 +299,571 @@ ice_get_eeprom(struct net_device *netdev, struct ethtool_eeprom *eeprom,
 	return ret;
 }
 
+/**
+ * ice_active_vfs - check if there are any active VFs
+ * @pf: board private structure
+ *
+ * Returns true if an active VF is found, otherwise returns false
+ */
+static bool ice_active_vfs(struct ice_pf *pf)
+{
+	struct ice_vf *vf = pf->vf;
+	int i;
+
+	for (i = 0; i < pf->num_alloc_vfs; i++, vf++)
+		if (test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
+			return true;
+	return false;
+}
+
+/**
+ * ice_link_test - perform a link test on a given net_device
+ * @netdev: network interface device structure
+ *
+ * This function performs one of the self-tests required by ethtool.
+ * Returns 0 on success, non-zero on failure.
+ */
+static u64 ice_link_test(struct net_device *netdev)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	enum ice_status status;
+	bool link_up = false;
+
+	netdev_info(netdev, "link test\n");
+	status = ice_get_link_status(np->vsi->port_info, &link_up);
+	if (status) {
+		netdev_err(netdev, "link query error, status = %d\n", status);
+		return 1;
+	}
+
+	if (!link_up)
+		return 2;
+
+	return 0;
+}
+
+/**
+ * ice_eeprom_test - perform an EEPROM test on a given net_device
+ * @netdev: network interface device structure
+ *
+ * This function performs one of the self-tests required by ethtool.
+ * Returns 0 on success, non-zero on failure.
+ */
+static u64 ice_eeprom_test(struct net_device *netdev)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_pf *pf = np->vsi->back;
+
+	netdev_info(netdev, "EEPROM test\n");
+	return !!(ice_nvm_validate_checksum(&pf->hw));
+}
+
+/**
+ * ice_reg_pattern_test
+ * @hw: pointer to the HW struct
+ * @reg: reg to be tested
+ * @mask: bits to be touched
+ */
+static int ice_reg_pattern_test(struct ice_hw *hw, u32 reg, u32 mask)
+{
+	struct ice_pf *pf = (struct ice_pf *)hw->back;
+	static const u32 patterns[] = {
+		0x5A5A5A5A, 0xA5A5A5A5,
+		0x00000000, 0xFFFFFFFF
+	};
+	u32 val, orig_val;
+	int i;
+
+	orig_val = rd32(hw, reg);
+	for (i = 0; i < ARRAY_SIZE(patterns); ++i) {
+		u32 pattern = patterns[i] & mask;
+
+		wr32(hw, reg, pattern);
+		val = rd32(hw, reg);
+		if (val == pattern)
+			continue;
+		dev_err(&pf->pdev->dev,
+			"%s: reg pattern test failed - reg 0x%08x pat 0x%08x val 0x%08x\n"
+			, __func__, reg, pattern, val);
+		return 1;
+	}
+
+	wr32(hw, reg, orig_val);
+	val = rd32(hw, reg);
+	if (val != orig_val) {
+		dev_err(&pf->pdev->dev,
+			"%s: reg restore test failed - reg 0x%08x orig 0x%08x val 0x%08x\n"
+			, __func__, reg, orig_val, val);
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_reg_test - perform a register test on a given net_device
+ * @netdev: network interface device structure
+ *
+ * This function performs one of the self-tests required by ethtool.
+ * Returns 0 on success, non-zero on failure.
+ */
+static u64 ice_reg_test(struct net_device *netdev)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_hw *hw = np->vsi->port_info->hw;
+	u32 int_elements = hw->func_caps.common_cap.num_msix_vectors ?
+		hw->func_caps.common_cap.num_msix_vectors - 1 : 1;
+	struct ice_diag_reg_test_info {
+		u32 address;
+		u32 mask;
+		u32 elem_num;
+		u32 elem_size;
+	} ice_reg_list[] = {
+		{GLINT_ITR(0, 0), 0x00000fff, int_elements,
+			GLINT_ITR(0, 1) - GLINT_ITR(0, 0)},
+		{GLINT_ITR(1, 0), 0x00000fff, int_elements,
+			GLINT_ITR(1, 1) - GLINT_ITR(1, 0)},
+		{GLINT_ITR(0, 0), 0x00000fff, int_elements,
+			GLINT_ITR(2, 1) - GLINT_ITR(2, 0)},
+		{GLINT_CTL, 0xffff0001, 1, 0}
+	};
+	int i;
+
+	netdev_dbg(netdev, "Register test\n");
+	for (i = 0; i < ARRAY_SIZE(ice_reg_list); ++i) {
+		u32 j;
+
+		for (j = 0; j < ice_reg_list[i].elem_num; ++j) {
+			u32 mask = ice_reg_list[i].mask;
+			u32 reg = ice_reg_list[i].address +
+				(j * ice_reg_list[i].elem_size);
+
+			/* bail on failure (non-zero return) */
+			if (ice_reg_pattern_test(hw, reg, mask))
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ice_lbtest_prepare_rings - configure Tx/Rx test rings
+ * @vsi: pointer to the VSI structure
+ *
+ * Function configures rings of a VSI for loopback test without
+ * enabling interrupts or informing the kernel about new queues.
+ *
+ * Returns 0 on success, negative on failure.
+ */
+static int ice_lbtest_prepare_rings(struct ice_vsi *vsi)
+{
+	int status;
+
+	status = ice_vsi_setup_tx_rings(vsi);
+	if (status)
+		goto err_setup_tx_ring;
+
+	status = ice_vsi_setup_rx_rings(vsi);
+	if (status)
+		goto err_setup_rx_ring;
+
+	status = ice_vsi_cfg(vsi);
+	if (status)
+		goto err_setup_rx_ring;
+
+	status = ice_vsi_start_rx_rings(vsi);
+	if (status)
+		goto err_start_rx_ring;
+
+	return status;
+
+err_start_rx_ring:
+	ice_vsi_free_rx_rings(vsi);
+err_setup_rx_ring:
+	ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, 0);
+err_setup_tx_ring:
+	ice_vsi_free_tx_rings(vsi);
+
+	return status;
+}
+
+/**
+ * ice_lbtest_disable_rings - disable Tx/Rx test rings after loopback test
+ * @vsi: pointer to the VSI structure
+ *
+ * Function stops and frees VSI rings after a loopback test.
+ * Returns 0 on success, negative on failure.
+ */
+static int ice_lbtest_disable_rings(struct ice_vsi *vsi)
+{
+	int status;
+
+	status = ice_vsi_stop_lan_tx_rings(vsi, ICE_NO_RESET, 0);
+	if (status)
+		netdev_err(vsi->netdev, "Failed to stop Tx rings, VSI %d error %d\n",
+			   vsi->vsi_num, status);
+
+	status = ice_vsi_stop_rx_rings(vsi);
+	if (status)
+		netdev_err(vsi->netdev, "Failed to stop Rx rings, VSI %d error %d\n",
+			   vsi->vsi_num, status);
+
+	ice_vsi_free_tx_rings(vsi);
+	ice_vsi_free_rx_rings(vsi);
+
+	return status;
+}
+
+/**
+ * ice_lbtest_create_frame - create test packet
+ * @pf: pointer to the PF structure
+ * @ret_data: allocated frame buffer
+ * @size: size of the packet data
+ *
+ * Function allocates a frame with a test pattern on specific offsets.
+ * Returns 0 on success, non-zero on failure.
+ */
+static int ice_lbtest_create_frame(struct ice_pf *pf, u8 **ret_data, u16 size)
+{
+	u8 *data;
+
+	if (!pf)
+		return -EINVAL;
+
+	data = devm_kzalloc(&pf->pdev->dev, size, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* Since the ethernet test frame should always be at least
+	 * 64 bytes long, fill some octets in the payload with test data.
+	 */
+	memset(data, 0xFF, size);
+	data[32] = 0xDE;
+	data[42] = 0xAD;
+	data[44] = 0xBE;
+	data[46] = 0xEF;
+
+	*ret_data = data;
+
+	return 0;
+}
+
+/**
+ * ice_lbtest_check_frame - verify received loopback frame
+ * @frame: pointer to the raw packet data
+ *
+ * Function verifies received test frame with a pattern.
+ * Returns true if frame matches the pattern, false otherwise.
+ */
+static bool ice_lbtest_check_frame(u8 *frame)
+{
+	/* Validate bytes of a frame under offsets chosen earlier */
+	if (frame[32] == 0xDE &&
+	    frame[42] == 0xAD &&
+	    frame[44] == 0xBE &&
+	    frame[46] == 0xEF &&
+	    frame[48] == 0xFF)
+		return true;
+
+	return false;
+}
+
+/**
+ * ice_diag_send - send test frames to the test ring
+ * @tx_ring: pointer to the transmit ring
+ * @data: pointer to the raw packet data
+ * @size: size of the packet to send
+ *
+ * Function sends loopback packets on a test Tx ring.
+ */
+static int ice_diag_send(struct ice_ring *tx_ring, u8 *data, u16 size)
+{
+	struct ice_tx_desc *tx_desc;
+	struct ice_tx_buf *tx_buf;
+	dma_addr_t dma;
+	u64 td_cmd;
+
+	tx_desc = ICE_TX_DESC(tx_ring, tx_ring->next_to_use);
+	tx_buf = &tx_ring->tx_buf[tx_ring->next_to_use];
+
+	dma = dma_map_single(tx_ring->dev, data, size, DMA_TO_DEVICE);
+	if (dma_mapping_error(tx_ring->dev, dma))
+		return -EINVAL;
+
+	tx_desc->buf_addr = cpu_to_le64(dma);
+
+	/* These flags are required for a descriptor to be pushed out */
+	td_cmd = (u64)(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS);
+	tx_desc->cmd_type_offset_bsz =
+		cpu_to_le64(ICE_TX_DESC_DTYPE_DATA |
+			    (td_cmd << ICE_TXD_QW1_CMD_S) |
+			    ((u64)0 << ICE_TXD_QW1_OFFSET_S) |
+			    ((u64)size << ICE_TXD_QW1_TX_BUF_SZ_S) |
+			    ((u64)0 << ICE_TXD_QW1_L2TAG1_S));
+
+	tx_buf->next_to_watch = tx_desc;
+
+	/* Force memory write to complete before letting h/w know
+	 * there are new descriptors to fetch.
+	 */
+	wmb();
+
+	tx_ring->next_to_use++;
+	if (tx_ring->next_to_use >= tx_ring->count)
+		tx_ring->next_to_use = 0;
+
+	writel_relaxed(tx_ring->next_to_use, tx_ring->tail);
+
+	/* Wait until the packets get transmitted to the receive queue. */
+	usleep_range(1000, 2000);
+	dma_unmap_single(tx_ring->dev, dma, size, DMA_TO_DEVICE);
+
+	return 0;
+}
+
+#define ICE_LB_FRAME_SIZE 64
+/**
+ * ice_lbtest_receive_frames - receive and verify test frames
+ * @rx_ring: pointer to the receive ring
+ *
+ * Function receives loopback packets and verify their correctness.
+ * Returns number of received valid frames.
+ */
+static int ice_lbtest_receive_frames(struct ice_ring *rx_ring)
+{
+	struct ice_rx_buf *rx_buf;
+	int valid_frames, i;
+	u8 *received_buf;
+
+	valid_frames = 0;
+
+	for (i = 0; i < rx_ring->count; i++) {
+		union ice_32b_rx_flex_desc *rx_desc;
+
+		rx_desc = ICE_RX_DESC(rx_ring, i);
+
+		if (!(rx_desc->wb.status_error0 &
+		    cpu_to_le16(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)))
+			continue;
+
+		rx_buf = &rx_ring->rx_buf[i];
+		received_buf = page_address(rx_buf->page);
+
+		if (ice_lbtest_check_frame(received_buf))
+			valid_frames++;
+	}
+
+	return valid_frames;
+}
+
+/**
+ * ice_loopback_test - perform a loopback test on a given net_device
+ * @netdev: network interface device structure
+ *
+ * This function performs one of the self-tests required by ethtool.
+ * Returns 0 on success, non-zero on failure.
+ */
+static u64 ice_loopback_test(struct net_device *netdev)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_vsi *orig_vsi = np->vsi, *test_vsi;
+	struct ice_pf *pf = orig_vsi->back;
+	struct ice_ring *tx_ring, *rx_ring;
+	u8 broadcast[ETH_ALEN], ret = 0;
+	int num_frames, valid_frames;
+	LIST_HEAD(tmp_list);
+	u8 *tx_frame;
+	int i;
+
+	netdev_info(netdev, "loopback test\n");
+
+	test_vsi = ice_lb_vsi_setup(pf, pf->hw.port_info);
+	if (!test_vsi) {
+		netdev_err(netdev, "Failed to create a VSI for the loopback test");
+		return 1;
+	}
+
+	test_vsi->netdev = netdev;
+	tx_ring = test_vsi->tx_rings[0];
+	rx_ring = test_vsi->rx_rings[0];
+
+	if (ice_lbtest_prepare_rings(test_vsi)) {
+		ret = 2;
+		goto lbtest_vsi_close;
+	}
+
+	if (ice_alloc_rx_bufs(rx_ring, rx_ring->count)) {
+		ret = 3;
+		goto lbtest_rings_dis;
+	}
+
+	/* Enable MAC loopback in firmware */
+	if (ice_aq_set_mac_loopback(&pf->hw, true, NULL)) {
+		ret = 4;
+		goto lbtest_mac_dis;
+	}
+
+	/* Test VSI needs to receive broadcast packets */
+	eth_broadcast_addr(broadcast);
+	if (ice_add_mac_to_list(test_vsi, &tmp_list, broadcast)) {
+		ret = 5;
+		goto lbtest_mac_dis;
+	}
+
+	if (ice_add_mac(&pf->hw, &tmp_list)) {
+		ret = 6;
+		goto free_mac_list;
+	}
+
+	if (ice_lbtest_create_frame(pf, &tx_frame, ICE_LB_FRAME_SIZE)) {
+		ret = 7;
+		goto remove_mac_filters;
+	}
+
+	num_frames = min_t(int, tx_ring->count, 32);
+	for (i = 0; i < num_frames; i++) {
+		if (ice_diag_send(tx_ring, tx_frame, ICE_LB_FRAME_SIZE)) {
+			ret = 8;
+			goto lbtest_free_frame;
+		}
+	}
+
+	valid_frames = ice_lbtest_receive_frames(rx_ring);
+	if (!valid_frames)
+		ret = 9;
+	else if (valid_frames != num_frames)
+		ret = 10;
+
+lbtest_free_frame:
+	devm_kfree(&pf->pdev->dev, tx_frame);
+remove_mac_filters:
+	if (ice_remove_mac(&pf->hw, &tmp_list))
+		netdev_err(netdev, "Could not remove MAC filter for the test VSI");
+free_mac_list:
+	ice_free_fltr_list(&pf->pdev->dev, &tmp_list);
+lbtest_mac_dis:
+	/* Disable MAC loopback after the test is completed. */
+	if (ice_aq_set_mac_loopback(&pf->hw, false, NULL))
+		netdev_err(netdev, "Could not disable MAC loopback\n");
+lbtest_rings_dis:
+	if (ice_lbtest_disable_rings(test_vsi))
+		netdev_err(netdev, "Could not disable test rings\n");
+lbtest_vsi_close:
+	test_vsi->netdev = NULL;
+	if (ice_vsi_release(test_vsi))
+		netdev_err(netdev, "Failed to remove the test VSI");
+
+	return ret;
+}
+
+/**
+ * ice_intr_test - perform an interrupt test on a given net_device
+ * @netdev: network interface device structure
+ *
+ * This function performs one of the self-tests required by ethtool.
+ * Returns 0 on success, non-zero on failure.
+ */
+static u64 ice_intr_test(struct net_device *netdev)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_pf *pf = np->vsi->back;
+	u16 swic_old = pf->sw_int_count;
+
+	netdev_info(netdev, "interrupt test\n");
+
+	wr32(&pf->hw, GLINT_DYN_CTL(pf->sw_oicr_idx),
+	     GLINT_DYN_CTL_SW_ITR_INDX_M |
+	     GLINT_DYN_CTL_INTENA_MSK_M |
+	     GLINT_DYN_CTL_SWINT_TRIG_M);
+
+	usleep_range(1000, 2000);
+	return (swic_old == pf->sw_int_count);
+}
+
+/**
+ * ice_self_test - handler function for performing a self-test by ethtool
+ * @netdev: network interface device structure
+ * @eth_test: ethtool_test structure
+ * @data: required by ethtool.self_test
+ *
+ * This function is called after invoking 'ethtool -t devname' command where
+ * devname is the name of the network device on which ethtool should operate.
+ * It performs a set of self-tests to check if a device works properly.
+ */
+static void
+ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
+	      u64 *data)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	bool if_running = netif_running(netdev);
+	struct ice_pf *pf = np->vsi->back;
+
+	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
+		netdev_info(netdev, "offline testing starting\n");
+
+		set_bit(__ICE_TESTING, pf->state);
+
+		if (ice_active_vfs(pf)) {
+			dev_warn(&pf->pdev->dev,
+				 "Please take active VFs and Netqueues offline and restart the adapter before running NIC diagnostics\n");
+			data[ICE_ETH_TEST_REG] = 1;
+			data[ICE_ETH_TEST_EEPROM] = 1;
+			data[ICE_ETH_TEST_INTR] = 1;
+			data[ICE_ETH_TEST_LOOP] = 1;
+			data[ICE_ETH_TEST_LINK] = 1;
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+			clear_bit(__ICE_TESTING, pf->state);
+			goto skip_ol_tests;
+		}
+		/* If the device is online then take it offline */
+		if (if_running)
+			/* indicate we're in test mode */
+			ice_stop(netdev);
+
+		data[ICE_ETH_TEST_LINK] = ice_link_test(netdev);
+		data[ICE_ETH_TEST_EEPROM] = ice_eeprom_test(netdev);
+		data[ICE_ETH_TEST_INTR] = ice_intr_test(netdev);
+		data[ICE_ETH_TEST_LOOP] = ice_loopback_test(netdev);
+		data[ICE_ETH_TEST_REG] = ice_reg_test(netdev);
+
+		if (data[ICE_ETH_TEST_LINK] ||
+		    data[ICE_ETH_TEST_EEPROM] ||
+		    data[ICE_ETH_TEST_LOOP] ||
+		    data[ICE_ETH_TEST_INTR] ||
+		    data[ICE_ETH_TEST_REG])
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		clear_bit(__ICE_TESTING, pf->state);
+
+		if (if_running) {
+			int status = ice_open(netdev);
+
+			if (status) {
+				dev_err(&pf->pdev->dev,
+					"Could not open device %s, err %d",
+					pf->int_name, status);
+			}
+		}
+	} else {
+		/* Online tests */
+		netdev_info(netdev, "online testing starting\n");
+
+		data[ICE_ETH_TEST_LINK] = ice_link_test(netdev);
+		if (data[ICE_ETH_TEST_LINK])
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		/* Offline only tests, not run in online; pass by default */
+		data[ICE_ETH_TEST_REG] = 0;
+		data[ICE_ETH_TEST_EEPROM] = 0;
+		data[ICE_ETH_TEST_INTR] = 0;
+		data[ICE_ETH_TEST_LOOP] = 0;
+	}
+
+skip_ol_tests:
+	netdev_info(netdev, "testing finished\n");
+}
+
 static void ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
@@ -335,6 +921,9 @@ static void ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 			p += ETH_GSTRING_LEN;
 		}
 		break;
+	case ETH_SS_TEST:
+		memcpy(data, ice_gstrings_test, ICE_TEST_LEN * ETH_GSTRING_LEN);
+		break;
 	case ETH_SS_PRIV_FLAGS:
 		for (i = 0; i < ICE_PRIV_FLAG_ARRAY_SIZE; i++) {
 			snprintf(p, ETH_GSTRING_LEN, "%s",
@@ -529,6 +1118,8 @@ static int ice_get_sset_count(struct net_device *netdev, int sset)
 		 * not safe.
 		 */
 		return ICE_ALL_STATS_LEN(netdev);
+	case ETH_SS_TEST:
+		return ICE_TEST_LEN;
 	case ETH_SS_PRIV_FLAGS:
 		return ICE_PRIV_FLAG_ARRAY_SIZE;
 	default:
@@ -2558,6 +3149,7 @@ static const struct ethtool_ops ice_ethtool_ops = {
 	.get_regs               = ice_get_regs,
 	.get_msglevel           = ice_get_msglevel,
 	.set_msglevel           = ice_set_msglevel,
+	.self_test		= ice_self_test,
 	.get_link		= ethtool_op_get_link,
 	.get_eeprom_len		= ice_get_eeprom_len,
 	.get_eeprom		= ice_get_eeprom,
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index ec25f26069b0..6c5ce05742b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -6,6 +6,9 @@
 #ifndef _ICE_HW_AUTOGEN_H_
 #define _ICE_HW_AUTOGEN_H_
 
+#define PF0INT_ITR_0(_i)			(0x03000004 + ((_i) * 4096))
+#define PF0INT_ITR_1(_i)			(0x03000008 + ((_i) * 4096))
+#define PF0INT_ITR_2(_i)			(0x0300000C + ((_i) * 4096))
 #define QTX_COMM_DBELL(_DBQM)			(0x002C0000 + ((_DBQM) * 4))
 #define QTX_COMM_HEAD(_DBQM)			(0x000E0000 + ((_DBQM) * 4))
 #define QTX_COMM_HEAD_HEAD_S			0
@@ -155,6 +158,7 @@
 #define PFINT_OICR_HMC_ERR_M			BIT(26)
 #define PFINT_OICR_PE_CRITERR_M			BIT(28)
 #define PFINT_OICR_VFLR_M			BIT(29)
+#define PFINT_OICR_SWINT_M			BIT(31)
 #define PFINT_OICR_CTL				0x0016CA80
 #define PFINT_OICR_CTL_MSIX_INDX_M		ICE_M(0x7FF, 0)
 #define PFINT_OICR_CTL_ITR_INDX_S		11
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 749d36add524..95323ee49e58 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -137,6 +137,8 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
 	 * for PF or EMP this field should be set to zero
 	 */
 	switch (vsi->type) {
+	case ICE_VSI_LB:
+		/* fall through */
 	case ICE_VSI_PF:
 		tlan_ctx->vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_PF;
 		break;
@@ -251,6 +253,10 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 	if (!vsi->rx_rings)
 		goto err_rxrings;
 
+	/* There is no need to allocate q_vectors for a loopback VSI. */
+	if (vsi->type == ICE_VSI_LB)
+		return 0;
+
 	/* allocate memory for q_vector pointers */
 	vsi->q_vectors = devm_kcalloc(&pf->pdev->dev, vsi->num_q_vectors,
 				      sizeof(*vsi->q_vectors), GFP_KERNEL);
@@ -275,6 +281,8 @@ static void ice_vsi_set_num_desc(struct ice_vsi *vsi)
 {
 	switch (vsi->type) {
 	case ICE_VSI_PF:
+		/* fall through */
+	case ICE_VSI_LB:
 		vsi->num_rx_desc = ICE_DFLT_NUM_RX_DESC;
 		vsi->num_tx_desc = ICE_DFLT_NUM_TX_DESC;
 		break;
@@ -318,6 +326,10 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 		 */
 		vsi->num_q_vectors = pf->num_vf_msix - 1;
 		break;
+	case ICE_VSI_LB:
+		vsi->alloc_txq = 1;
+		vsi->alloc_rxq = 1;
+		break;
 	default:
 		dev_warn(&pf->pdev->dev, "Unknown VSI type %d\n", vsi->type);
 		break;
@@ -516,6 +528,10 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type type, u16 vf_id)
 		if (ice_vsi_alloc_arrays(vsi))
 			goto err_rings;
 		break;
+	case ICE_VSI_LB:
+		if (ice_vsi_alloc_arrays(vsi))
+			goto err_rings;
+		break;
 	default:
 		dev_warn(&pf->pdev->dev, "Unknown VSI type %d\n", vsi->type);
 		goto unlock_pf;
@@ -732,6 +748,8 @@ static void ice_vsi_set_rss_params(struct ice_vsi *vsi)
 				      BIT(cap->rss_table_entry_width));
 		vsi->rss_lut_type = ICE_AQC_GSET_RSS_LUT_TABLE_TYPE_VSI;
 		break;
+	case ICE_VSI_LB:
+		break;
 	default:
 		dev_warn(&pf->pdev->dev, "Unknown VSI type %d\n",
 			 vsi->type);
@@ -924,6 +942,9 @@ static void ice_set_rss_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
 		lut_type = ICE_AQ_VSI_Q_OPT_RSS_LUT_VSI;
 		hash_type = ICE_AQ_VSI_Q_OPT_RSS_TPLZ;
 		break;
+	case ICE_VSI_LB:
+		dev_dbg(&pf->pdev->dev, "Unsupported VSI type %d\n", vsi->type);
+		return;
 	default:
 		dev_warn(&pf->pdev->dev, "Unknown VSI type %d\n", vsi->type);
 		return;
@@ -955,6 +976,8 @@ static int ice_vsi_init(struct ice_vsi *vsi)
 
 	ctxt->info = vsi->info;
 	switch (vsi->type) {
+	case ICE_VSI_LB:
+		/* fall through */
 	case ICE_VSI_PF:
 		ctxt->flags = ICE_AQ_VSI_TYPE_PF;
 		break;
@@ -2071,8 +2094,7 @@ ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 			break;
 
 		for (i = 0; i < vsi->tc_cfg.tc_info[tc].qcount_tx; i++) {
-			if (!rings || !rings[q_idx] ||
-			    !rings[q_idx]->q_vector) {
+			if (!rings || !rings[q_idx]) {
 				err = -EINVAL;
 				goto err_out;
 			}
@@ -2092,9 +2114,13 @@ ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 			/* trigger a software interrupt for the vector
 			 * associated to the queue to schedule NAPI handler
 			 */
-			wr32(hw, GLINT_DYN_CTL(rings[i]->q_vector->reg_idx),
-			     GLINT_DYN_CTL_SWINT_TRIG_M |
-			     GLINT_DYN_CTL_INTENA_MSK_M);
+			if (rings[q_idx]->q_vector) {
+				int reg_idx = rings[i]->q_vector->reg_idx;
+
+				wr32(hw, GLINT_DYN_CTL(reg_idx),
+				     GLINT_DYN_CTL_SWINT_TRIG_M |
+				     GLINT_DYN_CTL_INTENA_MSK_M);
+			}
 			q_idx++;
 		}
 		status = ice_dis_vsi_txq(vsi->port_info, vsi->idx, tc,
@@ -2408,6 +2434,11 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		pf->q_left_tx -= vsi->alloc_txq;
 		pf->q_left_rx -= vsi->alloc_rxq;
 		break;
+	case ICE_VSI_LB:
+		ret = ice_vsi_alloc_rings(vsi);
+		if (ret)
+			goto unroll_vsi_init;
+		break;
 	default:
 		/* clean up the resources and exit */
 		goto unroll_vsi_init;
@@ -2768,7 +2799,8 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		ice_rss_clean(vsi);
 
 	/* Disable VSI and free resources */
-	ice_vsi_dis_irq(vsi);
+	if (vsi->type != ICE_VSI_LB)
+		ice_vsi_dis_irq(vsi);
 	ice_vsi_close(vsi);
 
 	/* reclaim interrupt vectors back to PF */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index eaa1b25dd1b0..4ca2d7a8d172 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1430,6 +1430,11 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 	oicr = rd32(hw, PFINT_OICR);
 	ena_mask = rd32(hw, PFINT_OICR_ENA);
 
+	if (oicr & PFINT_OICR_SWINT_M) {
+		ena_mask &= ~PFINT_OICR_SWINT_M;
+		pf->sw_int_count++;
+	}
+
 	if (oicr & PFINT_OICR_MAL_DETECT_M) {
 		ena_mask &= ~PFINT_OICR_MAL_DETECT_M;
 		set_bit(__ICE_MDD_EVENT_PENDING, pf->state);
@@ -1803,8 +1808,8 @@ void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size)
  * @pf: board private structure
  * @pi: pointer to the port_info instance
  *
- * Returns pointer to the successfully allocated VSI sw struct on success,
- * otherwise returns NULL on failure.
+ * Returns pointer to the successfully allocated VSI software struct
+ * on success, otherwise returns NULL on failure.
  */
 static struct ice_vsi *
 ice_pf_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
@@ -1812,6 +1817,20 @@ ice_pf_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
 	return ice_vsi_setup(pf, pi, ICE_VSI_PF, ICE_INVAL_VFID);
 }
 
+/**
+ * ice_lb_vsi_setup - Set up a loopback VSI
+ * @pf: board private structure
+ * @pi: pointer to the port_info instance
+ *
+ * Returns pointer to the successfully allocated VSI software struct
+ * on success, otherwise returns NULL on failure.
+ */
+struct ice_vsi *
+ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
+{
+	return ice_vsi_setup(pf, pi, ICE_VSI_LB, ICE_INVAL_VFID);
+}
+
 /**
  * ice_vlan_rx_add_vid - Add a VLAN ID filter to HW offload
  * @netdev: network interface to be adjusted
@@ -2908,7 +2927,7 @@ static int ice_vsi_vlan_setup(struct ice_vsi *vsi)
  *
  * Return 0 on success and negative value on error
  */
-static int ice_vsi_cfg(struct ice_vsi *vsi)
+int ice_vsi_cfg(struct ice_vsi *vsi)
 {
 	int err;
 
@@ -3463,7 +3482,7 @@ int ice_down(struct ice_vsi *vsi)
  *
  * Return 0 on success, negative on failure
  */
-static int ice_vsi_setup_tx_rings(struct ice_vsi *vsi)
+int ice_vsi_setup_tx_rings(struct ice_vsi *vsi)
 {
 	int i, err = 0;
 
@@ -3489,7 +3508,7 @@ static int ice_vsi_setup_tx_rings(struct ice_vsi *vsi)
  *
  * Return 0 on success, negative on failure
  */
-static int ice_vsi_setup_rx_rings(struct ice_vsi *vsi)
+int ice_vsi_setup_rx_rings(struct ice_vsi *vsi)
 {
 	int i, err = 0;
 
@@ -4248,7 +4267,7 @@ static void ice_tx_timeout(struct net_device *netdev)
  *
  * Returns 0 on success, negative value on failure
  */
-static int ice_open(struct net_device *netdev)
+int ice_open(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
@@ -4285,7 +4304,7 @@ static int ice_open(struct net_device *netdev)
  *
  * Returns success only - not allowed to fail
  */
-static int ice_stop(struct net_device *netdev)
+int ice_stop(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 6d4adaed5810..bcb431f1bd92 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -316,3 +316,34 @@ ice_read_sr_buf(struct ice_hw *hw, u16 offset, u16 *words, u16 *data)
 
 	return status;
 }
+
+/**
+ * ice_nvm_validate_checksum
+ * @hw: pointer to the HW struct
+ *
+ * Verify NVM PFA checksum validity (0x0706)
+ */
+enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw)
+{
+	struct ice_aqc_nvm_checksum *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	status = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (status)
+		return status;
+
+	cmd = &desc.params.nvm_checksum;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_nvm_checksum);
+	cmd->flags = ICE_AQC_NVM_CHECKSUM_VERIFY;
+
+	status = ice_aq_send_cmd(hw, &desc, NULL, 0, NULL);
+	ice_release_nvm(hw);
+
+	if (!status)
+		if (le16_to_cpu(cmd->checksum) != ICE_AQC_NVM_CHECKSUM_CORRECT)
+			status = ICE_ERR_NVM_CHECKSUM;
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_status.h b/drivers/net/ethernet/intel/ice/ice_status.h
index 17afe6acb18a..c01597885629 100644
--- a/drivers/net/ethernet/intel/ice/ice_status.h
+++ b/drivers/net/ethernet/intel/ice/ice_status.h
@@ -26,6 +26,7 @@ enum ice_status {
 	ICE_ERR_IN_USE				= -16,
 	ICE_ERR_MAX_LIMIT			= -17,
 	ICE_ERR_RESET_ONGOING			= -18,
+	ICE_ERR_NVM_CHECKSUM			= -51,
 	ICE_ERR_BUF_TOO_SHORT			= -52,
 	ICE_ERR_NVM_BLANK_MODE			= -53,
 	ICE_ERR_AQ_ERROR			= -100,
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index a862af4cbf78..0a0fa30a85bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -86,6 +86,7 @@ enum ice_media_type {
 enum ice_vsi_type {
 	ICE_VSI_PF = 0,
 	ICE_VSI_VF,
+	ICE_VSI_LB = 6,
 };
 
 struct ice_link_status {
-- 
2.21.0

