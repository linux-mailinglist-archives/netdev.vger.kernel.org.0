Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A68C13C52
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 01:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfEDXyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 19:54:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:17213 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727390AbfEDXyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 19:54:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 16:49:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="139994674"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 04 May 2019 16:49:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: Add function to program ethertype based filter rule on VSIs
Date:   Sat,  4 May 2019 16:49:26 -0700
Message-Id: <20190504234929.3005-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
References: <20190504234929.3005-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

This patch adds function to program VSI with ethertype based filter rule,
so that all flow control frames would be disallowed from being transmitted
to the client, in order to prevent malicious VSI, especially VF from
sending out PAUSE or PFC frames, and then control other VSIs traffic.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h        |  2 +
 drivers/net/ethernet/intel/ice/ice_lib.c    | 55 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_switch.c | 59 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_switch.h |  4 ++
 4 files changed, 120 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 6f970edf50c7..792e6e42030e 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -255,6 +255,8 @@ struct ice_vsi {
 
 	s16 vf_id;			/* VF ID for SR-IOV VSIs */
 
+	u16 ethtype;			/* Ethernet protocol for pause frame */
+
 	/* RSS config */
 	u16 rss_table_size;	/* HW RSS table size */
 	u16 rss_size;		/* Allocated RSS queues */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7a88bf639376..fbf1eba0cc2a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2250,6 +2250,46 @@ ice_vsi_set_q_vectors_reg_idx(struct ice_vsi *vsi)
 	return -EINVAL;
 }
 
+/**
+ * ice_vsi_add_rem_eth_mac - Program VSI ethertype based filter with rule
+ * @vsi: the VSI being configured
+ * @add_rule: boolean value to add or remove ethertype filter rule
+ */
+static void
+ice_vsi_add_rem_eth_mac(struct ice_vsi *vsi, bool add_rule)
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
+	list->fltr_info.fltr_act = ICE_DROP_PACKET;
+	list->fltr_info.flag = ICE_FLTR_TX;
+	list->fltr_info.src_id = ICE_SRC_ID_VSI;
+	list->fltr_info.vsi_handle = vsi->idx;
+	list->fltr_info.l_data.ethertype_mac.ethertype = vsi->ethtype;
+
+	INIT_LIST_HEAD(&list->list_entry);
+	list_add(&list->list_entry, &tmp_add_list);
+
+	if (add_rule)
+		status = ice_add_eth_mac(&pf->hw, &tmp_add_list);
+	else
+		status = ice_remove_eth_mac(&pf->hw, &tmp_add_list);
+
+	if (status)
+		dev_err(&pf->pdev->dev,
+			"Failure Adding or Removing Ethertype on VSI %i error: %d\n",
+			vsi->vsi_num, status);
+
+	ice_free_fltr_list(&pf->pdev->dev, &tmp_add_list);
+}
+
 /**
  * ice_vsi_setup - Set up a VSI by a given type
  * @pf: board private structure
@@ -2285,6 +2325,9 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 
 	vsi->port_info = pi;
 	vsi->vsw = pf->first_sw;
+	if (vsi->type == ICE_VSI_PF)
+		vsi->ethtype = ETH_P_PAUSE;
+
 	if (vsi->type == ICE_VSI_VF)
 		vsi->vf_id = vf_id;
 
@@ -2382,6 +2425,15 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		goto unroll_vector_base;
 	}
 
+	/* Add switch rule to drop all Tx Flow Control Frames, of look up
+	 * type ETHERTYPE from VSIs, and restrict malicious VF from sending
+	 * out PAUSE or PFC frames. If enabled, FW can still send FC frames.
+	 * The rule is added once for PF VSI in order to create appropriate
+	 * recipe, since VSI/VSI list is ignored with drop action...
+	 */
+	if (vsi->type == ICE_VSI_PF)
+		ice_vsi_add_rem_eth_mac(vsi, true);
+
 	return vsi;
 
 unroll_vector_base:
@@ -2740,6 +2792,9 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		pf->num_avail_hw_msix += pf->num_vf_msix;
 	}
 
+	if (vsi->type == ICE_VSI_PF)
+		ice_vsi_add_rem_eth_mac(vsi, false);
+
 	ice_remove_vsi_fltr(&pf->hw, vsi->idx);
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	ice_vsi_delete(vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 81f44939c859..9f1f595ae7e6 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1969,6 +1969,65 @@ ice_add_vlan(struct ice_hw *hw, struct list_head *v_list)
 	return 0;
 }
 
+/**
+ * ice_add_eth_mac - Add ethertype and MAC based filter rule
+ * @hw: pointer to the hardware structure
+ * @em_list: list of ether type MAC filter, MAC is optional
+ */
+enum ice_status
+ice_add_eth_mac(struct ice_hw *hw, struct list_head *em_list)
+{
+	struct ice_fltr_list_entry *em_list_itr;
+
+	if (!em_list || !hw)
+		return ICE_ERR_PARAM;
+
+	list_for_each_entry(em_list_itr, em_list, list_entry) {
+		enum ice_sw_lkup_type l_type =
+			em_list_itr->fltr_info.lkup_type;
+
+		if (l_type != ICE_SW_LKUP_ETHERTYPE_MAC &&
+		    l_type != ICE_SW_LKUP_ETHERTYPE)
+			return ICE_ERR_PARAM;
+
+		em_list_itr->fltr_info.flag = ICE_FLTR_TX;
+		em_list_itr->status = ice_add_rule_internal(hw, l_type,
+							    em_list_itr);
+		if (em_list_itr->status)
+			return em_list_itr->status;
+	}
+	return 0;
+}
+
+/**
+ * ice_remove_eth_mac - Remove an ethertype (or MAC) based filter rule
+ * @hw: pointer to the hardware structure
+ * @em_list: list of ethertype or ethertype MAC entries
+ */
+enum ice_status
+ice_remove_eth_mac(struct ice_hw *hw, struct list_head *em_list)
+{
+	struct ice_fltr_list_entry *em_list_itr, *tmp;
+
+	if (!em_list || !hw)
+		return ICE_ERR_PARAM;
+
+	list_for_each_entry_safe(em_list_itr, tmp, em_list, list_entry) {
+		enum ice_sw_lkup_type l_type =
+			em_list_itr->fltr_info.lkup_type;
+
+		if (l_type != ICE_SW_LKUP_ETHERTYPE_MAC &&
+		    l_type != ICE_SW_LKUP_ETHERTYPE)
+			return ICE_ERR_PARAM;
+
+		em_list_itr->status = ice_remove_rule_internal(hw, l_type,
+							       em_list_itr);
+		if (em_list_itr->status)
+			return em_list_itr->status;
+	}
+	return 0;
+}
+
 /**
  * ice_rem_sw_rule_info
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 88eb4be4d5a4..732b0b9b2e15 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -218,6 +218,10 @@ enum ice_status ice_get_initial_sw_cfg(struct ice_hw *hw);
 enum ice_status ice_update_sw_rule_bridge_mode(struct ice_hw *hw);
 enum ice_status ice_add_mac(struct ice_hw *hw, struct list_head *m_lst);
 enum ice_status ice_remove_mac(struct ice_hw *hw, struct list_head *m_lst);
+enum ice_status
+ice_add_eth_mac(struct ice_hw *hw, struct list_head *em_list);
+enum ice_status
+ice_remove_eth_mac(struct ice_hw *hw, struct list_head *em_list);
 void ice_remove_vsi_fltr(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status
 ice_add_vlan(struct ice_hw *hw, struct list_head *m_list);
-- 
2.20.1

