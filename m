Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1536B1598
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 22:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfILUuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 16:50:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:59558 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbfILUuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 16:50:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 13:50:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="197345144"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 12 Sep 2019 13:50:04 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 5/6] ice: Enable DDP package download
Date:   Thu, 12 Sep 2019 13:50:01 -0700
Message-Id: <20190912205002.12159-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
References: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

Attempt to request an optional device-specific DDP package file
(one with the PCIe Device Serial Number in its name so that different DDP
package files can be used on different devices). If the optional package
file exists, download it to the device. If not, download the default
package file.

Log an appropriate message based on whether or not a DDP package
file exists and the return code from the attempt to download it to the
device.  If the download fails and there is not already a package file on
the device, go into "Safe Mode" where some features are not supported.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  14 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  69 ++
 drivers/net/ethernet/intel/ice/ice_common.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  42 ++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   2 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  27 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   4 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  92 +--
 drivers/net/ethernet/intel/ice/ice_lib.h      |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 614 ++++++++++++++----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   6 +
 12 files changed, 679 insertions(+), 195 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 3a3e69a2bc5a..45e100666049 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -8,6 +8,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/firmware.h>
 #include <linux/netdevice.h>
 #include <linux/compiler.h>
 #include <linux/etherdevice.h>
@@ -307,6 +308,7 @@ enum ice_pf_flags {
 	ICE_FLAG_SRIOV_CAPABLE,
 	ICE_FLAG_DCB_CAPABLE,
 	ICE_FLAG_DCB_ENA,
+	ICE_FLAG_ADV_FEATURES,
 	ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA,
 	ICE_FLAG_NO_MEDIA,
 	ICE_FLAG_FW_LLDP_AGENT,
@@ -404,6 +406,17 @@ ice_irq_dynamic_ena(struct ice_hw *hw, struct ice_vsi *vsi,
 	wr32(hw, GLINT_DYN_CTL(vector), val);
 }
 
+/**
+ * ice_netdev_to_pf - Retrieve the PF struct associated with a netdev
+ * @netdev: pointer to the netdev struct
+ */
+static inline struct ice_pf *ice_netdev_to_pf(struct net_device *netdev)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+
+	return np->vsi->back;
+}
+
 /**
  * ice_get_main_vsi - Get the PF VSI
  * @pf: PF instance
@@ -421,6 +434,7 @@ static inline struct ice_vsi *ice_get_main_vsi(struct ice_pf *pf)
 int ice_vsi_setup_tx_rings(struct ice_vsi *vsi);
 int ice_vsi_setup_rx_rings(struct ice_vsi *vsi);
 void ice_set_ethtool_ops(struct net_device *netdev);
+void ice_set_ethtool_safe_mode_ops(struct net_device *netdev);
 u16 ice_get_avail_txq_count(struct ice_pf *pf);
 u16 ice_get_avail_rxq_count(struct ice_pf *pf);
 void ice_update_vsi_stats(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 91472e049231..3a6b3950eb0e 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1846,6 +1846,75 @@ ice_discover_caps(struct ice_hw *hw, enum ice_adminq_opc opc)
 	return status;
 }
 
+/**
+ * ice_set_safe_mode_caps - Override dev/func capabilities when in safe mode
+ * @hw: pointer to the hardware structure
+ */
+void ice_set_safe_mode_caps(struct ice_hw *hw)
+{
+	struct ice_hw_func_caps *func_caps = &hw->func_caps;
+	struct ice_hw_dev_caps *dev_caps = &hw->dev_caps;
+	u32 valid_func, rxq_first_id, txq_first_id;
+	u32 msix_vector_first_id, max_mtu;
+	u32 num_func = 0;
+	u8 i;
+
+	/* cache some func_caps values that should be restored after memset */
+	valid_func = func_caps->common_cap.valid_functions;
+	txq_first_id = func_caps->common_cap.txq_first_id;
+	rxq_first_id = func_caps->common_cap.rxq_first_id;
+	msix_vector_first_id = func_caps->common_cap.msix_vector_first_id;
+	max_mtu = func_caps->common_cap.max_mtu;
+
+	/* unset func capabilities */
+	memset(func_caps, 0, sizeof(*func_caps));
+
+	/* restore cached values */
+	func_caps->common_cap.valid_functions = valid_func;
+	func_caps->common_cap.txq_first_id = txq_first_id;
+	func_caps->common_cap.rxq_first_id = rxq_first_id;
+	func_caps->common_cap.msix_vector_first_id = msix_vector_first_id;
+	func_caps->common_cap.max_mtu = max_mtu;
+
+	/* one Tx and one Rx queue in safe mode */
+	func_caps->common_cap.num_rxq = 1;
+	func_caps->common_cap.num_txq = 1;
+
+	/* two MSIX vectors, one for traffic and one for misc causes */
+	func_caps->common_cap.num_msix_vectors = 2;
+	func_caps->guar_num_vsi = 1;
+
+	/* cache some dev_caps values that should be restored after memset */
+	valid_func = dev_caps->common_cap.valid_functions;
+	txq_first_id = dev_caps->common_cap.txq_first_id;
+	rxq_first_id = dev_caps->common_cap.rxq_first_id;
+	msix_vector_first_id = dev_caps->common_cap.msix_vector_first_id;
+	max_mtu = dev_caps->common_cap.max_mtu;
+
+	/* unset dev capabilities */
+	memset(dev_caps, 0, sizeof(*dev_caps));
+
+	/* restore cached values */
+	dev_caps->common_cap.valid_functions = valid_func;
+	dev_caps->common_cap.txq_first_id = txq_first_id;
+	dev_caps->common_cap.rxq_first_id = rxq_first_id;
+	dev_caps->common_cap.msix_vector_first_id = msix_vector_first_id;
+	dev_caps->common_cap.max_mtu = max_mtu;
+
+	/* valid_func is a bitmap. get number of functions */
+#define ICE_MAX_FUNCS 8
+	for (i = 0; i < ICE_MAX_FUNCS; i++)
+		if (valid_func & BIT(i))
+			num_func++;
+
+	/* one Tx and one Rx queue per function in safe mode */
+	dev_caps->common_cap.num_rxq = num_func;
+	dev_caps->common_cap.num_txq = num_func;
+
+	/* two MSIX vectors per function */
+	dev_caps->common_cap.num_msix_vectors = 2 * num_func;
+}
+
 /**
  * ice_get_caps - get info about the HW
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index ce55f8ae6b52..c3df92f57777 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -42,6 +42,8 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 void ice_clear_pxe_mode(struct ice_hw *hw);
 enum ice_status ice_get_caps(struct ice_hw *hw);
 
+void ice_set_safe_mode_caps(struct ice_hw *hw);
+
 void ice_dev_onetime_setup(struct ice_hw *hw);
 
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 97c22d4aae1d..dd47869c4ad4 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -3,6 +3,48 @@
 
 #include "ice_dcb_lib.h"
 
+/**
+ * ice_vsi_cfg_netdev_tc - Setup the netdev TC configuration
+ * @vsi: the VSI being configured
+ * @ena_tc: TC map to be enabled
+ */
+void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc)
+{
+	struct net_device *netdev = vsi->netdev;
+	struct ice_pf *pf = vsi->back;
+	struct ice_dcbx_cfg *dcbcfg;
+	u8 netdev_tc;
+	int i;
+
+	if (!netdev)
+		return;
+
+	if (!ena_tc) {
+		netdev_reset_tc(netdev);
+		return;
+	}
+
+	if (netdev_set_num_tc(netdev, vsi->tc_cfg.numtc))
+		return;
+
+	dcbcfg = &pf->hw.port_info->local_dcbx_cfg;
+
+	ice_for_each_traffic_class(i)
+		if (vsi->tc_cfg.ena_tc & BIT(i))
+			netdev_set_tc_queue(netdev,
+					    vsi->tc_cfg.tc_info[i].netdev_tc,
+					    vsi->tc_cfg.tc_info[i].qcount_tx,
+					    vsi->tc_cfg.tc_info[i].qoffset);
+
+	for (i = 0; i < ICE_MAX_USER_PRIORITY; i++) {
+		u8 ets_tc = dcbcfg->etscfg.prio_table[i];
+
+		/* Get the mapped netdev TC# for the UP */
+		netdev_tc = vsi->tc_cfg.tc_info[ets_tc].netdev_tc;
+		netdev_set_prio_tc_map(netdev, i, netdev_tc);
+	}
+}
+
 /**
  * ice_dcb_get_ena_tc - return bitmap of enabled TCs
  * @dcbcfg: DCB config to evaluate for enabled TCs
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 819081053ff5..661a6f7bca64 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -22,6 +22,7 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 void
 ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 				    struct ice_rq_event_info *event);
+void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc);
 static inline void
 ice_set_cgd_num(struct ice_tlan_ctx *tlan_ctx, struct ice_ring *ring)
 {
@@ -58,5 +59,6 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring __always_unused *tx_ring,
 #define ice_vsi_cfg_dcb_rings(vsi) do {} while (0)
 #define ice_dcb_process_lldp_set_mib_change(pf, event) do {} while (0)
 #define ice_set_cgd_num(tlan_ctx, ring) do {} while (0)
+#define ice_vsi_cfg_netdev_tc(vsi, ena_tc) do {} while (0)
 #endif /* CONFIG_DCB */
 #endif /* _ICE_DCB_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a16b461b46bb..7e23034df955 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3435,6 +3435,33 @@ static const struct ethtool_ops ice_ethtool_ops = {
 	.set_fecparam		= ice_set_fecparam,
 };
 
+static const struct ethtool_ops ice_ethtool_safe_mode_ops = {
+	.get_link_ksettings	= ice_get_link_ksettings,
+	.set_link_ksettings	= ice_set_link_ksettings,
+	.get_drvinfo		= ice_get_drvinfo,
+	.get_regs_len		= ice_get_regs_len,
+	.get_regs		= ice_get_regs,
+	.get_msglevel		= ice_get_msglevel,
+	.set_msglevel		= ice_set_msglevel,
+	.get_eeprom_len		= ice_get_eeprom_len,
+	.get_eeprom		= ice_get_eeprom,
+	.get_strings		= ice_get_strings,
+	.get_ethtool_stats	= ice_get_ethtool_stats,
+	.get_sset_count		= ice_get_sset_count,
+	.get_ringparam		= ice_get_ringparam,
+	.set_ringparam		= ice_set_ringparam,
+	.nway_reset		= ice_nway_reset,
+};
+
+/**
+ * ice_set_ethtool_safe_mode_ops - setup safe mode ethtool ops
+ * @netdev: network interface device structure
+ */
+void ice_set_ethtool_safe_mode_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &ice_ethtool_safe_mode_ops;
+}
+
 /**
  * ice_set_ethtool_ops - setup netdev ethtool ops
  * @netdev: network interface device structure
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index cc8922bd61b5..cbd53b586c36 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -4,8 +4,6 @@
 #include "ice_common.h"
 #include "ice_flex_pipe.h"
 
-static void ice_fill_blk_tbls(struct ice_hw *hw);
-
 /**
  * ice_pkg_val_buf
  * @buf: pointer to the ice buffer
@@ -1358,7 +1356,7 @@ static void ice_fill_tbl(struct ice_hw *hw, enum ice_block block_id, u32 sid)
  * database with the data iteratively for all advanced feature
  * blocks. Assume that the HW tables have been allocated.
  */
-static void ice_fill_blk_tbls(struct ice_hw *hw)
+void ice_fill_blk_tbls(struct ice_hw *hw)
 {
 	u8 i;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index 9edf1e7589c7..37eb282742d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -23,6 +23,7 @@ enum ice_status
 ice_copy_and_init_pkg(struct ice_hw *hw, const u8 *buf, u32 len);
 enum ice_status ice_init_hw_tbls(struct ice_hw *hw);
 void ice_free_seg(struct ice_hw *hw);
+void ice_fill_blk_tbls(struct ice_hw *hw);
 void ice_clear_hw_tbls(struct ice_hw *hw);
 void ice_free_hw_tbls(struct ice_hw *hw);
 #endif /* _ICE_FLEX_PIPE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 9680692bf27c..cc755382df25 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -752,6 +752,17 @@ void ice_vsi_put_qs(struct ice_vsi *vsi)
 	mutex_unlock(&pf->avail_q_mutex);
 }
 
+/**
+ * ice_is_safe_mode
+ * @pf: pointer to the PF struct
+ *
+ * returns true if driver is in safe mode, false otherwise
+ */
+bool ice_is_safe_mode(struct ice_pf *pf)
+{
+	return !test_bit(ICE_FLAG_ADV_FEATURES, pf->flags);
+}
+
 /**
  * ice_rss_clean - Delete RSS related VSI structures that hold user inputs
  * @vsi: the VSI being removed
@@ -2629,15 +2640,17 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	 * DCB settings in the HW.  Also, if the FW DCBX engine is not running
 	 * then Rx LLDP packets need to be redirected up the stack.
 	 */
-	if (vsi->type == ICE_VSI_PF) {
-		ice_vsi_add_rem_eth_mac(vsi, true);
+	if (!ice_is_safe_mode(pf)) {
+		if (vsi->type == ICE_VSI_PF) {
+			ice_vsi_add_rem_eth_mac(vsi, true);
 
-		/* Tx LLDP packets */
-		ice_cfg_sw_lldp(vsi, true, true);
+			/* Tx LLDP packets */
+			ice_cfg_sw_lldp(vsi, true, true);
 
-		/* Rx LLDP packets */
-		if (!test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
-			ice_cfg_sw_lldp(vsi, false, true);
+			/* Rx LLDP packets */
+			if (!test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
+				ice_cfg_sw_lldp(vsi, false, true);
+		}
 	}
 
 	return vsi;
@@ -2905,8 +2918,11 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
 	}
 
 	/* disable each interrupt */
-	ice_for_each_q_vector(vsi, i)
+	ice_for_each_q_vector(vsi, i) {
+		if (!vsi->q_vectors[i])
+			continue;
 		wr32(hw, GLINT_DYN_CTL(vsi->q_vectors[i]->reg_idx), 0);
+	}
 
 	ice_flush(hw);
 
@@ -2975,14 +2991,16 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		pf->num_avail_sw_msix += vsi->num_q_vectors;
 	}
 
-	if (vsi->type == ICE_VSI_PF) {
-		ice_vsi_add_rem_eth_mac(vsi, false);
-		ice_cfg_sw_lldp(vsi, true, false);
-		/* The Rx rule will only exist to remove if the LLDP FW
-		 * engine is currently stopped
-		 */
-		if (!test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
-			ice_cfg_sw_lldp(vsi, false, false);
+	if (!ice_is_safe_mode(pf)) {
+		if (vsi->type == ICE_VSI_PF) {
+			ice_vsi_add_rem_eth_mac(vsi, false);
+			ice_cfg_sw_lldp(vsi, true, false);
+			/* The Rx rule will only exist to remove if the LLDP FW
+			 * engine is currently stopped
+			 */
+			if (!test_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags))
+				ice_cfg_sw_lldp(vsi, false, false);
+		}
 	}
 
 	ice_remove_vsi_fltr(&pf->hw, vsi->idx);
@@ -3168,48 +3186,6 @@ static void ice_vsi_update_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctx)
 	       sizeof(vsi->info.tc_mapping));
 }
 
-/**
- * ice_vsi_cfg_netdev_tc - Setup the netdev TC configuration
- * @vsi: the VSI being configured
- * @ena_tc: TC map to be enabled
- */
-static void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc)
-{
-	struct net_device *netdev = vsi->netdev;
-	struct ice_pf *pf = vsi->back;
-	struct ice_dcbx_cfg *dcbcfg;
-	u8 netdev_tc;
-	int i;
-
-	if (!netdev)
-		return;
-
-	if (!ena_tc) {
-		netdev_reset_tc(netdev);
-		return;
-	}
-
-	if (netdev_set_num_tc(netdev, vsi->tc_cfg.numtc))
-		return;
-
-	dcbcfg = &pf->hw.port_info->local_dcbx_cfg;
-
-	ice_for_each_traffic_class(i)
-		if (vsi->tc_cfg.ena_tc & BIT(i))
-			netdev_set_tc_queue(netdev,
-					    vsi->tc_cfg.tc_info[i].netdev_tc,
-					    vsi->tc_cfg.tc_info[i].qcount_tx,
-					    vsi->tc_cfg.tc_info[i].qoffset);
-
-	for (i = 0; i < ICE_MAX_USER_PRIORITY; i++) {
-		u8 ets_tc = dcbcfg->etscfg.prio_table[i];
-
-		/* Get the mapped netdev TC# for the UP */
-		netdev_tc = vsi->tc_cfg.tc_info[ets_tc].netdev_tc;
-		netdev_set_prio_tc_map(netdev, i, netdev_tc);
-	}
-}
-
 /**
  * ice_vsi_cfg_tc - Configure VSI Tx Sched for given TC map
  * @vsi: VSI to be configured
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 87f7f5422b46..47bc033fff20 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -125,4 +125,5 @@ char *ice_nvm_version_str(struct ice_hw *hw);
 enum ice_status
 ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
+bool ice_is_safe_mode(struct ice_pf *pf);
 #endif /* !_ICE_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ff295cb54cfd..a9efc918c625 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -21,10 +21,15 @@ const char ice_drv_ver[] = DRV_VERSION;
 static const char ice_driver_string[] = DRV_SUMMARY;
 static const char ice_copyright[] = "Copyright (c) 2018, Intel Corporation.";
 
+/* DDP Package file located in firmware search paths (e.g. /lib/firmware/) */
+#define ICE_DDP_PKG_PATH	"intel/ice/ddp/"
+#define ICE_DDP_PKG_FILE	ICE_DDP_PKG_PATH "ice.pkg"
+
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION(DRV_SUMMARY);
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
+MODULE_FIRMWARE(ICE_DDP_PKG_FILE);
 
 static int debug = -1;
 module_param(debug, int, 0644);
@@ -35,9 +40,10 @@ MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
 #endif /* !CONFIG_DYNAMIC_DEBUG */
 
 static struct workqueue_struct *ice_wq;
+static const struct net_device_ops ice_netdev_safe_mode_ops;
 static const struct net_device_ops ice_netdev_ops;
 
-static void ice_rebuild(struct ice_pf *pf);
+static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type);
 
 static void ice_vsi_release_all(struct ice_pf *pf);
 
@@ -497,6 +503,8 @@ ice_prepare_for_reset(struct ice_pf *pf)
 	for (i = 0; i < pf->num_alloc_vfs; i++)
 		ice_set_vf_state_qs_dis(&pf->vf[i]);
 
+	/* clear SW filtering DB */
+	ice_clear_hw_tbls(hw);
 	/* disable the VSIs and their queues that are not already DOWN */
 	ice_pf_dis_all_vsi(pf, false);
 
@@ -542,7 +550,7 @@ static void ice_do_reset(struct ice_pf *pf, enum ice_reset_req reset_type)
 	 */
 	if (reset_type == ICE_RESET_PFR) {
 		pf->pfr_count++;
-		ice_rebuild(pf);
+		ice_rebuild(pf, reset_type);
 		clear_bit(__ICE_PREPARED_FOR_RESET, pf->state);
 		clear_bit(__ICE_PFR_REQ, pf->state);
 		ice_reset_all_vfs(pf, true);
@@ -586,7 +594,7 @@ static void ice_reset_subtask(struct ice_pf *pf)
 		} else {
 			/* done with reset. start rebuild */
 			pf->hw.reset_ongoing = false;
-			ice_rebuild(pf);
+			ice_rebuild(pf, reset_type);
 			/* clear bit to resume normal operations, but
 			 * ICE_NEEDS_RESTART bit is set in case rebuild failed
 			 */
@@ -1496,13 +1504,19 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
+	ice_clean_adminq_subtask(pf);
 	ice_check_media_subtask(pf);
 	ice_check_for_hang_subtask(pf);
 	ice_sync_fltr_subtask(pf);
 	ice_handle_mdd_event(pf);
-	ice_process_vflr_event(pf);
 	ice_watchdog_subtask(pf);
-	ice_clean_adminq_subtask(pf);
+
+	if (ice_is_safe_mode(pf)) {
+		ice_service_task_complete(pf);
+		return;
+	}
+
+	ice_process_vflr_event(pf);
 	ice_clean_mailboxq_subtask(pf);
 
 	/* Clear __ICE_SERVICE_SCHED flag to allow scheduling next event */
@@ -1937,30 +1951,41 @@ static void ice_napi_add(struct ice_vsi *vsi)
 }
 
 /**
- * ice_cfg_netdev - Allocate, configure and register a netdev
- * @vsi: the VSI associated with the new netdev
- *
- * Returns 0 on success, negative value on failure
+ * ice_set_ops - set netdev and ethtools ops for the given netdev
+ * @netdev: netdev instance
  */
-static int ice_cfg_netdev(struct ice_vsi *vsi)
+static void ice_set_ops(struct net_device *netdev)
 {
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+
+	if (ice_is_safe_mode(pf)) {
+		netdev->netdev_ops = &ice_netdev_safe_mode_ops;
+		ice_set_ethtool_safe_mode_ops(netdev);
+		return;
+	}
+
+	netdev->netdev_ops = &ice_netdev_ops;
+	ice_set_ethtool_ops(netdev);
+}
+
+/**
+ * ice_set_netdev_features - set features for the given netdev
+ * @netdev: netdev instance
+ */
+static void ice_set_netdev_features(struct net_device *netdev)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 	netdev_features_t csumo_features;
 	netdev_features_t vlano_features;
 	netdev_features_t dflt_features;
 	netdev_features_t tso_features;
-	struct ice_netdev_priv *np;
-	struct net_device *netdev;
-	u8 mac_addr[ETH_ALEN];
-	int err;
-
-	netdev = alloc_etherdev_mqs(sizeof(*np), vsi->alloc_txq,
-				    vsi->alloc_rxq);
-	if (!netdev)
-		return -ENOMEM;
 
-	vsi->netdev = netdev;
-	np = netdev_priv(netdev);
-	np->vsi = vsi;
+	if (ice_is_safe_mode(pf)) {
+		/* safe mode */
+		netdev->features = NETIF_F_SG | NETIF_F_HIGHDMA;
+		netdev->hw_features = netdev->features;
+		return;
+	}
 
 	dflt_features = NETIF_F_SG	|
 			NETIF_F_HIGHDMA	|
@@ -1988,25 +2013,50 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 				   tso_features;
 	netdev->vlan_features |= dflt_features | csumo_features |
 				 tso_features;
+}
+
+/**
+ * ice_cfg_netdev - Allocate, configure and register a netdev
+ * @vsi: the VSI associated with the new netdev
+ *
+ * Returns 0 on success, negative value on failure
+ */
+static int ice_cfg_netdev(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_netdev_priv *np;
+	struct net_device *netdev;
+	u8 mac_addr[ETH_ALEN];
+	int err;
+
+	netdev = alloc_etherdev_mqs(sizeof(*np), vsi->alloc_txq,
+				    vsi->alloc_rxq);
+	if (!netdev)
+		return -ENOMEM;
+
+	vsi->netdev = netdev;
+	np = netdev_priv(netdev);
+	np->vsi = vsi;
+
+	ice_set_netdev_features(netdev);
+
+	ice_set_ops(netdev);
 
 	if (vsi->type == ICE_VSI_PF) {
-		SET_NETDEV_DEV(netdev, &vsi->back->pdev->dev);
+		SET_NETDEV_DEV(netdev, &pf->pdev->dev);
 		ether_addr_copy(mac_addr, vsi->port_info->mac.perm_addr);
-
 		ether_addr_copy(netdev->dev_addr, mac_addr);
 		ether_addr_copy(netdev->perm_addr, mac_addr);
 	}
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	/* assign netdev_ops */
-	netdev->netdev_ops = &ice_netdev_ops;
+	/* Setup netdev TC information */
+	ice_vsi_cfg_netdev_tc(vsi, vsi->tc_cfg.ena_tc);
 
 	/* setup watchdog timeout value to be 5 second */
 	netdev->watchdog_timeo = 5 * HZ;
 
-	ice_set_ethtool_ops(netdev);
-
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = ICE_MAX_MTU;
 
@@ -2264,29 +2314,41 @@ static void ice_deinit_pf(struct ice_pf *pf)
 }
 
 /**
- * ice_init_pf - Initialize general software structures (struct ice_pf)
- * @pf: board private structure to initialize
+ * ice_set_pf_caps - set PFs capability flags
+ * @pf: pointer to the PF instance
  */
-static int ice_init_pf(struct ice_pf *pf)
+static void ice_set_pf_caps(struct ice_pf *pf)
 {
-	bitmap_zero(pf->flags, ICE_PF_FLAGS_NBITS);
-	if (pf->hw.func_caps.common_cap.dcb)
+	struct ice_hw_func_caps *func_caps = &pf->hw.func_caps;
+
+	clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
+	if (func_caps->common_cap.dcb)
 		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 #ifdef CONFIG_PCI_IOV
-	if (pf->hw.func_caps.common_cap.sr_iov_1_1) {
-		struct ice_hw *hw = &pf->hw;
-
+	clear_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
+	if (func_caps->common_cap.sr_iov_1_1) {
 		set_bit(ICE_FLAG_SRIOV_CAPABLE, pf->flags);
-		pf->num_vfs_supported = min_t(int, hw->func_caps.num_allocd_vfs,
+		pf->num_vfs_supported = min_t(int, func_caps->num_allocd_vfs,
 					      ICE_MAX_VF_COUNT);
 	}
 #endif /* CONFIG_PCI_IOV */
+	clear_bit(ICE_FLAG_RSS_ENA, pf->flags);
+	if (func_caps->common_cap.rss_table_size)
+		set_bit(ICE_FLAG_RSS_ENA, pf->flags);
 
-	mutex_init(&pf->sw_mutex);
-	mutex_init(&pf->avail_q_mutex);
+	pf->max_pf_txqs = func_caps->common_cap.num_txq;
+	pf->max_pf_rxqs = func_caps->common_cap.num_rxq;
+}
 
-	if (pf->hw.func_caps.common_cap.rss_table_size)
-		set_bit(ICE_FLAG_RSS_ENA, pf->flags);
+/**
+ * ice_init_pf - Initialize general software structures (struct ice_pf)
+ * @pf: board private structure to initialize
+ */
+static int ice_init_pf(struct ice_pf *pf)
+{
+	ice_set_pf_caps(pf);
+
+	mutex_init(&pf->sw_mutex);
 
 	/* setup service timer and periodic service task */
 	timer_setup(&pf->serv_tmr, ice_service_timer, 0);
@@ -2294,9 +2356,7 @@ static int ice_init_pf(struct ice_pf *pf)
 	INIT_WORK(&pf->serv_task, ice_service_task);
 	clear_bit(__ICE_SERVICE_SCHED, pf->state);
 
-	pf->max_pf_txqs = pf->hw.func_caps.common_cap.num_txq;
-	pf->max_pf_rxqs = pf->hw.func_caps.common_cap.num_rxq;
-
+	mutex_init(&pf->avail_q_mutex);
 	pf->avail_txqs = bitmap_zalloc(pf->max_pf_txqs, GFP_KERNEL);
 	if (!pf->avail_txqs)
 		return -ENOMEM;
@@ -2449,6 +2509,163 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_log_pkg_init - log result of DDP package load
+ * @hw: pointer to hardware info
+ * @status: status of package load
+ */
+static void
+ice_log_pkg_init(struct ice_hw *hw, enum ice_status *status)
+{
+	struct ice_pf *pf = (struct ice_pf *)hw->back;
+	struct device *dev = &pf->pdev->dev;
+
+	switch (*status) {
+	case ICE_SUCCESS:
+		/* The package download AdminQ command returned success because
+		 * this download succeeded or ICE_ERR_AQ_NO_WORK since there is
+		 * already a package loaded on the device.
+		 */
+		if (hw->pkg_ver.major == hw->active_pkg_ver.major &&
+		    hw->pkg_ver.minor == hw->active_pkg_ver.minor &&
+		    hw->pkg_ver.update == hw->active_pkg_ver.update &&
+		    hw->pkg_ver.draft == hw->active_pkg_ver.draft &&
+		    !memcmp(hw->pkg_name, hw->active_pkg_name,
+			    sizeof(hw->pkg_name))) {
+			if (hw->pkg_dwnld_status == ICE_AQ_RC_EEXIST)
+				dev_info(dev,
+					 "DDP package already present on device: %s version %d.%d.%d.%d\n",
+					 hw->active_pkg_name,
+					 hw->active_pkg_ver.major,
+					 hw->active_pkg_ver.minor,
+					 hw->active_pkg_ver.update,
+					 hw->active_pkg_ver.draft);
+			else
+				dev_info(dev,
+					 "The DDP package was successfully loaded: %s version %d.%d.%d.%d\n",
+					 hw->active_pkg_name,
+					 hw->active_pkg_ver.major,
+					 hw->active_pkg_ver.minor,
+					 hw->active_pkg_ver.update,
+					 hw->active_pkg_ver.draft);
+		} else if (hw->active_pkg_ver.major != ICE_PKG_SUPP_VER_MAJ ||
+			   hw->active_pkg_ver.minor != ICE_PKG_SUPP_VER_MNR) {
+			dev_err(dev,
+				"The device has a DDP package that is not supported by the driver.  The device has package '%s' version %d.%d.x.x.  The driver requires version %d.%d.x.x.  Entering Safe Mode.\n",
+				hw->active_pkg_name,
+				hw->active_pkg_ver.major,
+				hw->active_pkg_ver.minor,
+				ICE_PKG_SUPP_VER_MAJ, ICE_PKG_SUPP_VER_MNR);
+			*status = ICE_ERR_NOT_SUPPORTED;
+		} else if (hw->active_pkg_ver.major == ICE_PKG_SUPP_VER_MAJ &&
+			   hw->active_pkg_ver.minor == ICE_PKG_SUPP_VER_MNR) {
+			dev_info(dev,
+				 "The driver could not load the DDP package file because a compatible DDP package is already present on the device.  The device has package '%s' version %d.%d.%d.%d.  The package file found by the driver: '%s' version %d.%d.%d.%d.\n",
+				 hw->active_pkg_name,
+				 hw->active_pkg_ver.major,
+				 hw->active_pkg_ver.minor,
+				 hw->active_pkg_ver.update,
+				 hw->active_pkg_ver.draft,
+				 hw->pkg_name,
+				 hw->pkg_ver.major,
+				 hw->pkg_ver.minor,
+				 hw->pkg_ver.update,
+				 hw->pkg_ver.draft);
+		} else {
+			dev_err(dev,
+				"An unknown error occurred when loading the DDP package, please reboot the system.  If the problem persists, update the NVM.  Entering Safe Mode.\n");
+			*status = ICE_ERR_NOT_SUPPORTED;
+		}
+		break;
+	case ICE_ERR_BUF_TOO_SHORT:
+		/* fall-through */
+	case ICE_ERR_CFG:
+		dev_err(dev,
+			"The DDP package file is invalid. Entering Safe Mode.\n");
+		break;
+	case ICE_ERR_NOT_SUPPORTED:
+		/* Package File version not supported */
+		if (hw->pkg_ver.major > ICE_PKG_SUPP_VER_MAJ ||
+		    (hw->pkg_ver.major == ICE_PKG_SUPP_VER_MAJ &&
+		     hw->pkg_ver.minor > ICE_PKG_SUPP_VER_MNR))
+			dev_err(dev,
+				"The DDP package file version is higher than the driver supports.  Please use an updated driver.  Entering Safe Mode.\n");
+		else if (hw->pkg_ver.major < ICE_PKG_SUPP_VER_MAJ ||
+			 (hw->pkg_ver.major == ICE_PKG_SUPP_VER_MAJ &&
+			  hw->pkg_ver.minor < ICE_PKG_SUPP_VER_MNR))
+			dev_err(dev,
+				"The DDP package file version is lower than the driver supports.  The driver requires version %d.%d.x.x.  Please use an updated DDP Package file.  Entering Safe Mode.\n",
+				ICE_PKG_SUPP_VER_MAJ, ICE_PKG_SUPP_VER_MNR);
+		break;
+	case ICE_ERR_AQ_ERROR:
+		switch (hw->adminq.sq_last_status) {
+		case ICE_AQ_RC_ENOSEC:
+		case ICE_AQ_RC_EBADSIG:
+			dev_err(dev,
+				"The DDP package could not be loaded because its signature is not valid.  Please use a valid DDP Package.  Entering Safe Mode.\n");
+			return;
+		case ICE_AQ_RC_ESVN:
+			dev_err(dev,
+				"The DDP Package could not be loaded because its security revision is too low.  Please use an updated DDP Package.  Entering Safe Mode.\n");
+			return;
+		case ICE_AQ_RC_EBADMAN:
+		case ICE_AQ_RC_EBADBUF:
+			dev_err(dev,
+				"An error occurred on the device while loading the DDP package.  The device will be reset.\n");
+			return;
+		default:
+			break;
+		}
+		/* fall-through */
+	default:
+		dev_err(dev,
+			"An unknown error (%d) occurred when loading the DDP package.  Entering Safe Mode.\n",
+			*status);
+		break;
+	}
+}
+
+/**
+ * ice_load_pkg - load/reload the DDP Package file
+ * @firmware: firmware structure when firmware requested or NULL for reload
+ * @pf: pointer to the PF instance
+ *
+ * Called on probe and post CORER/GLOBR rebuild to load DDP Package and
+ * initialize HW tables.
+ */
+static void
+ice_load_pkg(const struct firmware *firmware, struct ice_pf *pf)
+{
+	enum ice_status status = ICE_ERR_PARAM;
+	struct device *dev = &pf->pdev->dev;
+	struct ice_hw *hw = &pf->hw;
+
+	/* Load DDP Package */
+	if (firmware && !hw->pkg_copy) {
+		status = ice_copy_and_init_pkg(hw, firmware->data,
+					       firmware->size);
+		ice_log_pkg_init(hw, &status);
+	} else if (!firmware && hw->pkg_copy) {
+		/* Reload package during rebuild after CORER/GLOBR reset */
+		status = ice_init_pkg(hw, hw->pkg_copy, hw->pkg_size);
+		ice_log_pkg_init(hw, &status);
+	} else {
+		dev_err(dev,
+			"The DDP package file failed to load. Entering Safe Mode.\n");
+	}
+
+	if (status) {
+		/* Safe Mode */
+		clear_bit(ICE_FLAG_ADV_FEATURES, pf->flags);
+		return;
+	}
+
+	/* Successful download package is the precondition for advanced
+	 * features, hence setting the ICE_FLAG_ADV_FEATURES flag
+	 */
+	set_bit(ICE_FLAG_ADV_FEATURES, pf->flags);
+}
+
 /**
  * ice_verify_cacheline_size - verify driver's assumption of 64 Byte cache lines
  * @pf: pointer to the PF structure
@@ -2484,6 +2701,86 @@ static enum ice_status ice_send_version(struct ice_pf *pf)
 	return ice_aq_send_driver_ver(&pf->hw, &dv, NULL);
 }
 
+/**
+ * ice_get_opt_fw_name - return optional firmware file name or NULL
+ * @pf: pointer to the PF instance
+ */
+static char *ice_get_opt_fw_name(struct ice_pf *pf)
+{
+	/* Optional firmware name same as default with additional dash
+	 * followed by a EUI-64 identifier (PCIe Device Serial Number)
+	 */
+	struct pci_dev *pdev = pf->pdev;
+	char *opt_fw_filename = NULL;
+	u32 dword;
+	u8 dsn[8];
+	int pos;
+
+	/* Determine the name of the optional file using the DSN (two
+	 * dwords following the start of the DSN Capability).
+	 */
+	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN);
+	if (pos) {
+		opt_fw_filename = kzalloc(NAME_MAX, GFP_KERNEL);
+		if (!opt_fw_filename)
+			return NULL;
+
+		pci_read_config_dword(pdev, pos + 4, &dword);
+		put_unaligned_le32(dword, &dsn[0]);
+		pci_read_config_dword(pdev, pos + 8, &dword);
+		put_unaligned_le32(dword, &dsn[4]);
+		snprintf(opt_fw_filename, NAME_MAX,
+			 "%sice-%02x%02x%02x%02x%02x%02x%02x%02x.pkg",
+			 ICE_DDP_PKG_PATH,
+			 dsn[7], dsn[6], dsn[5], dsn[4],
+			 dsn[3], dsn[2], dsn[1], dsn[0]);
+	}
+
+	return opt_fw_filename;
+}
+
+/**
+ * ice_request_fw - Device initialization routine
+ * @pf: pointer to the PF instance
+ */
+static void ice_request_fw(struct ice_pf *pf)
+{
+	char *opt_fw_filename = ice_get_opt_fw_name(pf);
+	const struct firmware *firmware = NULL;
+	struct device *dev = &pf->pdev->dev;
+	int err = 0;
+
+	/* optional device-specific DDP (if present) overrides the default DDP
+	 * package file. kernel logs a debug message if the file doesn't exist,
+	 * and warning messages for other errors.
+	 */
+	if (opt_fw_filename) {
+		err = firmware_request_nowarn(&firmware, opt_fw_filename, dev);
+		if (err) {
+			kfree(opt_fw_filename);
+			goto dflt_pkg_load;
+		}
+
+		/* request for firmware was successful. Download to device */
+		ice_load_pkg(firmware, pf);
+		kfree(opt_fw_filename);
+		release_firmware(firmware);
+		return;
+	}
+
+dflt_pkg_load:
+	err = request_firmware(&firmware, ICE_DDP_PKG_FILE, dev);
+	if (err) {
+		dev_err(dev,
+			"The DDP package file was not found or could not be read. Entering Safe Mode\n");
+		return;
+	}
+
+	/* request for firmware was successful. Download to device */
+	ice_load_pkg(firmware, pf);
+	release_firmware(firmware);
+}
+
 /**
  * ice_probe - Device initialization routine
  * @pdev: PCI device information struct
@@ -2563,22 +2860,29 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		 hw->api_maj_ver, hw->api_min_ver, hw->api_patch,
 		 ice_nvm_version_str(hw), hw->fw_build);
 
+	ice_request_fw(pf);
+
+	/* if ice_request_fw fails, ICE_FLAG_ADV_FEATURES bit won't be
+	 * set in pf->state, which will cause ice_is_safe_mode to return
+	 * true
+	 */
+	if (ice_is_safe_mode(pf)) {
+		dev_err(dev,
+			"Package download failed. Advanced features disabled - Device now in Safe Mode\n");
+		/* we already got function/device capabilities but these don't
+		 * reflect what the driver needs to do in safe mode. Instead of
+		 * adding conditional logic everywhere to ignore these
+		 * device/function capabilities, override them.
+		 */
+		ice_set_safe_mode_caps(hw);
+	}
+
 	err = ice_init_pf(pf);
 	if (err) {
 		dev_err(dev, "ice_init_pf failed: %d\n", err);
 		goto err_init_pf_unroll;
 	}
 
-	if (test_bit(ICE_FLAG_DCB_CAPABLE, pf->flags)) {
-		/* Note: DCB init failure is non-fatal to load */
-		if (ice_init_pf_dcb(pf, false)) {
-			clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
-			clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
-		} else {
-			ice_cfg_lldp_mib_change(&pf->hw, true);
-		}
-	}
-
 	pf->num_alloc_vsi = hw->func_caps.guar_num_vsi;
 	if (!pf->num_alloc_vsi) {
 		err = -EIO;
@@ -2658,6 +2962,20 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	ice_verify_cacheline_size(pf);
 
+	/* If no DDP driven features have to be setup, return here */
+	if (ice_is_safe_mode(pf))
+		return 0;
+
+	/* initialize DDP driven features */
+
+	/* Note: DCB init failure is non-fatal to load */
+	if (ice_init_pf_dcb(pf, false)) {
+		clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
+		clear_bit(ICE_FLAG_DCB_ENA, pf->flags);
+	} else {
+		ice_cfg_lldp_mib_change(&pf->hw, true);
+	}
+
 	return 0;
 
 err_alloc_sw_unroll:
@@ -3110,6 +3428,13 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 	struct ice_vsi *vsi = np->vsi;
 	int ret = 0;
 
+	/* Don't set any netdev advanced features with device in Safe Mode */
+	if (ice_is_safe_mode(vsi->back)) {
+		dev_err(&vsi->back->pdev->dev,
+			"Device is in Safe Mode - not enabling advanced netdev features\n");
+		return ret;
+	}
+
 	/* Multiple features can be changed in one call so keep features in
 	 * separate if/else statements to guarantee each feature is checked
 	 */
@@ -3799,9 +4124,6 @@ static int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
  */
 #ifdef CONFIG_DCB
 int ice_pf_ena_all_vsi(struct ice_pf *pf, bool locked)
-#else
-static int ice_pf_ena_all_vsi(struct ice_pf *pf, bool locked)
-#endif /* CONFIG_DCB */
 {
 	int v;
 
@@ -3812,94 +4134,107 @@ static int ice_pf_ena_all_vsi(struct ice_pf *pf, bool locked)
 
 	return 0;
 }
+#endif /* CONFIG_DCB */
 
 /**
- * ice_vsi_rebuild_all - rebuild all VSIs in PF
- * @pf: the PF
+ * ice_vsi_rebuild_by_type - Rebuild VSI of a given type
+ * @pf: pointer to the PF instance
+ * @type: VSI type to rebuild
+ *
+ * Iterates through the pf->vsi array and rebuilds VSIs of the requested type
  */
-static int ice_vsi_rebuild_all(struct ice_pf *pf)
+static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 {
-	int i;
+	enum ice_status status;
+	int i, err;
 
-	/* loop through pf->vsi array and reinit the VSI if found */
 	ice_for_each_vsi(pf, i) {
 		struct ice_vsi *vsi = pf->vsi[i];
-		int err;
 
-		if (!vsi)
+		if (!vsi || vsi->type != type)
 			continue;
 
+		/* rebuild the VSI */
 		err = ice_vsi_rebuild(vsi);
 		if (err) {
 			dev_err(&pf->pdev->dev,
-				"VSI at index %d rebuild failed\n",
-				vsi->idx);
+				"rebuild VSI failed, err %d, VSI index %d, type %d\n",
+				err, vsi->idx, type);
 			return err;
 		}
 
-		dev_info(&pf->pdev->dev,
-			 "VSI at index %d rebuilt. vsi_num = 0x%x\n",
-			 vsi->idx, vsi->vsi_num);
+		/* replay filters for the VSI */
+		status = ice_replay_vsi(&pf->hw, vsi->idx);
+		if (status) {
+			dev_err(&pf->pdev->dev,
+				"replay VSI failed, status %d, VSI index %d, type %d\n",
+				status, vsi->idx, type);
+			return -EIO;
+		}
+
+		/* Re-map HW VSI number, using VSI handle that has been
+		 * previously validated in ice_replay_vsi() call above
+		 */
+		vsi->vsi_num = ice_get_hw_vsi_num(&pf->hw, vsi->idx);
+
+		/* enable the VSI */
+		err = ice_ena_vsi(vsi, false);
+		if (err) {
+			dev_err(&pf->pdev->dev,
+				"enable VSI failed, err %d, VSI index %d, type %d\n",
+				err, vsi->idx, type);
+			return err;
+		}
+
+		dev_info(&pf->pdev->dev, "VSI rebuilt. VSI index %d, type %d\n",
+			 vsi->idx, type);
 	}
 
 	return 0;
 }
 
 /**
- * ice_vsi_replay_all - replay all VSIs configuration in the PF
- * @pf: the PF
+ * ice_update_pf_netdev_link - Update PF netdev link status
+ * @pf: pointer to the PF instance
  */
-static int ice_vsi_replay_all(struct ice_pf *pf)
+static void ice_update_pf_netdev_link(struct ice_pf *pf)
 {
-	struct ice_hw *hw = &pf->hw;
-	enum ice_status ret;
+	bool link_up;
 	int i;
 
-	/* loop through pf->vsi array and replay the VSI if found */
 	ice_for_each_vsi(pf, i) {
 		struct ice_vsi *vsi = pf->vsi[i];
 
-		if (!vsi)
-			continue;
+		if (!vsi || vsi->type != ICE_VSI_PF)
+			return;
 
-		ret = ice_replay_vsi(hw, vsi->idx);
-		if (ret) {
-			dev_err(&pf->pdev->dev,
-				"VSI at index %d replay failed %d\n",
-				vsi->idx, ret);
-			return -EIO;
+		ice_get_link_status(pf->vsi[i]->port_info, &link_up);
+		if (link_up) {
+			netif_carrier_on(pf->vsi[i]->netdev);
+			netif_tx_wake_all_queues(pf->vsi[i]->netdev);
+		} else {
+			netif_carrier_off(pf->vsi[i]->netdev);
+			netif_tx_stop_all_queues(pf->vsi[i]->netdev);
 		}
-
-		/* Re-map HW VSI number, using VSI handle that has been
-		 * previously validated in ice_replay_vsi() call above
-		 */
-		vsi->vsi_num = ice_get_hw_vsi_num(hw, vsi->idx);
-
-		dev_info(&pf->pdev->dev,
-			 "VSI at index %d filter replayed successfully - vsi_num %i\n",
-			 vsi->idx, vsi->vsi_num);
 	}
-
-	/* Clean up replay filter after successful re-configuration */
-	ice_replay_post(hw);
-	return 0;
 }
 
 /**
  * ice_rebuild - rebuild after reset
  * @pf: PF to rebuild
+ * @reset_type: type of reset
  */
-static void ice_rebuild(struct ice_pf *pf)
+static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 {
 	struct device *dev = &pf->pdev->dev;
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status ret;
-	int err, i;
+	int err;
 
 	if (test_bit(__ICE_DOWN, pf->state))
 		goto clear_recovery;
 
-	dev_dbg(dev, "rebuilding PF\n");
+	dev_dbg(dev, "rebuilding PF after reset_type=%d\n", reset_type);
 
 	ret = ice_init_all_ctrlq(hw);
 	if (ret) {
@@ -3907,6 +4242,16 @@ static void ice_rebuild(struct ice_pf *pf)
 		goto err_init_ctrlq;
 	}
 
+	/* if DDP was previously loaded successfully */
+	if (!ice_is_safe_mode(pf)) {
+		/* reload the SW DB of filter tables */
+		if (reset_type == ICE_RESET_PFR)
+			ice_fill_blk_tbls(hw);
+		else
+			/* Reload DDP Package after CORER/GLOBR reset */
+			ice_load_pkg(NULL, pf);
+	}
+
 	ret = ice_clear_pf_cfg(hw);
 	if (ret) {
 		dev_err(dev, "clear PF configuration failed %d\n", ret);
@@ -3925,63 +4270,53 @@ static void ice_rebuild(struct ice_pf *pf)
 	if (err)
 		goto err_sched_init_port;
 
-	ice_dcb_rebuild(pf);
-
-	err = ice_vsi_rebuild_all(pf);
-	if (err) {
-		dev_err(dev, "ice_vsi_rebuild_all failed\n");
-		goto err_vsi_rebuild;
-	}
-
 	err = ice_update_link_info(hw->port_info);
 	if (err)
 		dev_err(&pf->pdev->dev, "Get link status error %d\n", err);
 
-	/* Replay all VSIs Configuration, including filters after reset */
-	if (ice_vsi_replay_all(pf)) {
-		dev_err(&pf->pdev->dev,
-			"error replaying VSI configurations with switch filter rules\n");
-		goto err_vsi_rebuild;
-	}
-
 	/* start misc vector */
 	err = ice_req_irq_msix_misc(pf);
 	if (err) {
 		dev_err(dev, "misc vector setup failed: %d\n", err);
-		goto err_vsi_rebuild;
+		goto err_sched_init_port;
 	}
 
-	/* restart the VSIs that were rebuilt and running before the reset */
-	err = ice_pf_ena_all_vsi(pf, false);
+	if (test_bit(ICE_FLAG_DCB_ENA, pf->flags))
+		ice_dcb_rebuild(pf);
+
+	/* rebuild PF VSI */
+	err = ice_vsi_rebuild_by_type(pf, ICE_VSI_PF);
 	if (err) {
-		dev_err(&pf->pdev->dev, "error enabling VSIs\n");
-		/* no need to disable VSIs in tear down path in ice_rebuild()
-		 * since its already taken care in ice_vsi_open()
-		 */
+		dev_err(dev, "PF VSI rebuild failed: %d\n", err);
 		goto err_vsi_rebuild;
 	}
 
-	ice_for_each_vsi(pf, i) {
-		bool link_up;
-
-		if (!pf->vsi[i] || pf->vsi[i]->type != ICE_VSI_PF)
-			continue;
-		ice_get_link_status(pf->vsi[i]->port_info, &link_up);
-		if (link_up) {
-			netif_carrier_on(pf->vsi[i]->netdev);
-			netif_tx_wake_all_queues(pf->vsi[i]->netdev);
-		} else {
-			netif_carrier_off(pf->vsi[i]->netdev);
-			netif_tx_stop_all_queues(pf->vsi[i]->netdev);
+	if (test_bit(ICE_FLAG_SRIOV_ENA, pf->flags)) {
+		err = ice_vsi_rebuild_by_type(pf, ICE_VSI_VF);
+		if (err) {
+			dev_err(dev, "VF VSI rebuild failed: %d\n", err);
+			goto err_vsi_rebuild;
 		}
 	}
 
+	ice_update_pf_netdev_link(pf);
+
+	/* tell the firmware we are up */
+	ret = ice_send_version(pf);
+	if (ret) {
+		dev_err(dev,
+			"Rebuild failed due to error sending driver version: %d\n",
+			ret);
+		goto err_vsi_rebuild;
+	}
+
+	ice_replay_post(hw);
+
 	/* if we get here, reset flow is successful */
 	clear_bit(__ICE_RESET_FAILED, pf->state);
 	return;
 
 err_vsi_rebuild:
-	ice_vsi_release_all(pf);
 err_sched_init_port:
 	ice_sched_cleanup_all(hw);
 err_init_ctrlq:
@@ -4508,6 +4843,17 @@ ice_features_check(struct sk_buff *skb,
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
+static const struct net_device_ops ice_netdev_safe_mode_ops = {
+	.ndo_open = ice_open,
+	.ndo_stop = ice_stop,
+	.ndo_start_xmit = ice_start_xmit,
+	.ndo_set_mac_address = ice_set_mac_address,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_change_mtu = ice_change_mtu,
+	.ndo_get_stats64 = ice_get_stats64,
+	.ndo_tx_timeout = ice_tx_timeout,
+};
+
 static const struct net_device_ops ice_netdev_ops = {
 	.ndo_open = ice_open,
 	.ndo_stop = ice_stop,
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 64de05ccbc47..b45797f39b2f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1443,6 +1443,12 @@ int ice_sriov_configure(struct pci_dev *pdev, int num_vfs)
 {
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 
+	if (ice_is_safe_mode(pf)) {
+		dev_err(&pf->pdev->dev,
+			"SR-IOV cannot be configured - Device is in Safe Mode\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (num_vfs)
 		return ice_pci_sriov_ena(pf, num_vfs);
 
-- 
2.21.0

