Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E483023C
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfE3Sum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:50:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:30427 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbfE3Suk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:50:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:50:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2019 11:50:36 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ice: Add switch rules to handle LLDP packets
Date:   Thu, 30 May 2019 11:50:37 -0700
Message-Id: <20190530185045.3886-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
References: <20190530185045.3886-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Add call to configure dropping egress LLDP packets in ice_vsi_setup
and remove the rule in ice_vsi_release.

Add calls to add/remove rule to route LLDP packets to default VSI when
FW LLDP engine is disabled/enabled and remove rule if applied during
ice_vsi_release.

In the function ice_add_eth_mac(), there is a line that hard codes the
filter info flag to TX. This is incorrect as this flag will be set by
the calling function that built the list of filters to add. So remove
the hard coded value.

This patch also contains a fix to stop treating the DCBx state of
"Not Started" as an error state that kicks DCB in SW mode. This will
address having non-cabled interfaces automatically go into SW mode
with the FW engine running.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 11 +++
 drivers/net/ethernet/intel/ice/ice_lib.c     | 73 +++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_lib.h     |  2 +
 drivers/net/ethernet/intel/ice/ice_switch.c  |  5 +-
 5 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index b97e3e8d499b..e6a4ef6a2565 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -387,10 +387,8 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 		set_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags);
 	}
 
-	if (port_info->dcbx_status == ICE_DCBX_STATUS_NOT_STARTED) {
-		sw_default = 1;
+	if (port_info->dcbx_status == ICE_DCBX_STATUS_NOT_STARTED)
 		dev_info(&pf->pdev->dev, "DCBX not started\n");
-	}
 
 	if (sw_default) {
 		err = ice_dcb_sw_dflt_cfg(pf, locked);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 2da83847b9dc..6beb918f625f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1205,6 +1205,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 		if (!test_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags)) {
 			enum ice_status status;
 
+			/* Disable FW LLDP engine */
 			status = ice_aq_cfg_lldp_mib_change(&pf->hw, false,
 							    NULL);
 			/* If unregistering for LLDP events fails, this is
@@ -1229,6 +1230,11 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			status = ice_init_pf_dcb(pf, true);
 			if (status)
 				dev_warn(&pf->pdev->dev, "Fail to init DCB\n");
+
+			/* Forward LLDP packets to default VSI so that they
+			 * are passed up the stack
+			 */
+			ice_cfg_sw_lldp(vsi, false, true);
 		} else {
 			enum ice_status status;
 			bool dcbx_agent_status;
@@ -1262,6 +1268,11 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			status = ice_init_pf_dcb(pf, true);
 			if (status)
 				dev_dbg(&pf->pdev->dev, "Fail to init DCB\n");
+
+			/* Remove rule to direct LLDP packets to default VSI.
+			 * The FW LLDP engine will now be consuming them.
+			 */
+			ice_cfg_sw_lldp(vsi, false, false);
 		}
 	}
 	clear_bit(ICE_FLAG_ETHTOOL_CTXT, pf->flags);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index d0410c686ef4..7625a4c0532d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2345,6 +2345,56 @@ ice_vsi_add_rem_eth_mac(struct ice_vsi *vsi, bool add_rule)
 	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
 }
 
+#define ICE_ETH_P_LLDP	0x88CC
+
+/**
+ * ice_cfg_sw_lldp - Config switch rules for LLDP packet handling
+ * @vsi: the VSI being configured
+ * @tx: bool to determine Tx or Rx rule
+ * @create: bool to determine create or remove Rule
+ */
+void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create)
+{
+	struct ice_fltr_list_entry *list;
+	struct ice_pf *pf = vsi->back;
+	LIST_HEAD(tmp_add_list);
+	enum ice_status status;
+
+	list = devm_kzalloc(&pf->pdev->dev, sizeof(*list), GFP_KERNEL);
+	if (!list)
+		return;
+
+	list->fltr_info.lkup_type = ICE_SW_LKUP_ETHERTYPE;
+	list->fltr_info.vsi_handle = vsi->idx;
+	list->fltr_info.l_data.ethertype_mac.ethertype = ICE_ETH_P_LLDP;
+
+	if (tx) {
+		list->fltr_info.fltr_act = ICE_DROP_PACKET;
+		list->fltr_info.flag = ICE_FLTR_TX;
+		list->fltr_info.src_id = ICE_SRC_ID_VSI;
+	} else {
+		list->fltr_info.fltr_act = ICE_FWD_TO_VSI;
+		list->fltr_info.flag = ICE_FLTR_RX;
+		list->fltr_info.src_id = ICE_SRC_ID_LPORT;
+	}
+
+	INIT_LIST_HEAD(&list->list_entry);
+	list_add(&list->list_entry, &tmp_add_list);
+
+	if (create)
+		status = ice_add_eth_mac(&pf->hw, &tmp_add_list);
+	else
+		status = ice_remove_eth_mac(&pf->hw, &tmp_add_list);
+
+	if (status)
+		dev_err(&pf->pdev->dev,
+			"Fail %s %s LLDP rule on VSI %i error: %d\n",
+			create ? "adding" : "removing", tx ? "TX" : "RX",
+			vsi->vsi_num, status);
+
+	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
+}
+
 /**
  * ice_vsi_setup - Set up a VSI by a given type
  * @pf: board private structure
@@ -2487,10 +2537,22 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	 * out PAUSE or PFC frames. If enabled, FW can still send FC frames.
 	 * The rule is added once for PF VSI in order to create appropriate
 	 * recipe, since VSI/VSI list is ignored with drop action...
+	 * Also add rules to handle LLDP Tx and Rx packets.  Tx LLDP packets
+	 * need to be dropped so that VFs cannot send LLDP packets to reconfig
+	 * DCB settings in the HW.  Also, if the FW DCBx engine is not running
+	 * then Rx LLDP packets need to be redirected up the stack.
 	 */
-	if (vsi->type == ICE_VSI_PF)
+	if (vsi->type == ICE_VSI_PF) {
 		ice_vsi_add_rem_eth_mac(vsi, true);
 
+		/* Tx LLDP packets */
+		ice_cfg_sw_lldp(vsi, true, true);
+
+		/* Rx LLDP packets */
+		if (!test_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags))
+			ice_cfg_sw_lldp(vsi, false, true);
+	}
+
 	return vsi;
 
 unroll_vector_base:
@@ -2829,8 +2891,15 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		pf->num_avail_sw_msix += vsi->num_q_vectors;
 	}
 
-	if (vsi->type == ICE_VSI_PF)
+	if (vsi->type == ICE_VSI_PF) {
 		ice_vsi_add_rem_eth_mac(vsi, false);
+		ice_cfg_sw_lldp(vsi, true, false);
+		/* The Rx rule will only exist to remove if the LLDP FW
+		 * engine is currently stopped
+		 */
+		if (!test_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags))
+			ice_cfg_sw_lldp(vsi, false, false);
+	}
 
 	ice_remove_vsi_fltr(&pf->hw, vsi->idx);
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 2acae3215f5f..6e43ef03bfc3 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -45,6 +45,8 @@ ice_vsi_stop_lan_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 
 int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena, bool vlan_promisc);
 
+void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create);
+
 void ice_vsi_delete(struct ice_vsi *vsi);
 
 int ice_vsi_clear(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 5b82a7280783..8271fd651725 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1973,6 +1973,10 @@ ice_add_vlan(struct ice_hw *hw, struct list_head *v_list)
  * ice_add_eth_mac - Add ethertype and MAC based filter rule
  * @hw: pointer to the hardware structure
  * @em_list: list of ether type MAC filter, MAC is optional
+ *
+ * This function requires the caller to populate the entries in
+ * the filter list with the necessary fields (including flags to
+ * indicate Tx or Rx rules).
  */
 enum ice_status
 ice_add_eth_mac(struct ice_hw *hw, struct list_head *em_list)
@@ -1990,7 +1994,6 @@ ice_add_eth_mac(struct ice_hw *hw, struct list_head *em_list)
 		    l_type != ICE_SW_LKUP_ETHERTYPE)
 			return ICE_ERR_PARAM;
 
-		em_list_itr->fltr_info.flag = ICE_FLTR_TX;
 		em_list_itr->status = ice_add_rule_internal(hw, l_type,
 							    em_list_itr);
 		if (em_list_itr->status)
-- 
2.21.0

