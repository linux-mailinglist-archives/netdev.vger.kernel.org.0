Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2510F21DEEF
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgGMRne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:43:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:39715 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730178AbgGMRna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 13:43:30 -0400
IronPort-SDR: P43S5EFSAS18bmcYi0C5byXQEOZ//9cbl3vfnXtRho3SkV9W52m/6Ll2x38qwYoLoDcY59Ojze
 lQmekcWpxZLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="147810234"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="147810234"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 10:43:28 -0700
IronPort-SDR: /eTa36Hq1Dj3prvEMd7LmWXVWqw+kC/2qIvIp7xMNOA33ZKHfVilEpzx+Mp+/X7hyCN3fApuQ7
 8M1dusVXqVcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="317450204"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jul 2020 10:43:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Xiao Zhang <xiao.zhang@intel.com>,
        Beilei Xing <beilei.xing@intel.com>,
        Nannan Lu <nannan.lu@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 5/5] ice: add switch rule management for DCF
Date:   Mon, 13 Jul 2020 10:43:20 -0700
Message-Id: <20200713174320.3982049-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

The PF shall track all the outstanding switch filters (filter IDs to be
precise) added by the DCF.

Upon a VF reset event, the PF shall clear all outstanding switch filters
for the given VF. Upon completion of either VF or PF reset, the PF shall
skip replay of filters that were added by the DCF. The PF shall however
continue to replay the filters that were not added by DCF for the VF(s).

If the trust mode of the DCF is taken away without the DCF gracefully
relinquishing the DCF functionality (by way appropriate virtchnl message
exchanges), then the PF shall remove all switch filters that were added
by the DCF. The PF shall transition back from DCF mode to regular mode,
the VF shall be treated as any other untrusted VF, and the PF will reset
the VF.

If a designated DCF requests AVF functionality from the same VF (VF-ID)
without the DCF gracefully relinquishing the DCF functionality first (by
way appropriate virtchnl message exchanges), the PF shall remove all the
switch filters that were added by the DCF.

Signed-off-by: Xiao Zhang <xiao.zhang@intel.com>
Signed-off-by: Beilei Xing <beilei.xing@intel.com>
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Nannan Lu <nannan.lu@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcf.c      | 707 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dcf.h      |  41 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |  16 +-
 drivers/net/ethernet/intel/ice/ice_switch.h   |  27 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   9 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  40 +
 6 files changed, 815 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcf.c b/drivers/net/ethernet/intel/ice/ice_dcf.c
index e7d37735aaa5..5234ec581d32 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcf.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcf.c
@@ -124,3 +124,710 @@ void ice_dcf_set_state(struct ice_pf *pf, enum ice_dcf_state state)
 
 	pf->dcf.state = state;
 }
+
+/**
+ * ice_dcf_rm_sw_rule_to_vsi - remove switch rule of "forward to VSI"
+ * @pf: pointer to the PF struct
+ * @s_entry: pointer to switch rule entry to remove
+ */
+static int
+ice_dcf_rm_sw_rule_to_vsi(struct ice_pf *pf,
+			  struct ice_dcf_sw_rule_entry *s_entry)
+{
+	struct ice_aqc_sw_rules_elem *s_rule;
+	enum ice_status status;
+
+	s_rule = kzalloc(ICE_SW_RULE_RX_TX_NO_HDR_SIZE, GFP_KERNEL);
+	if (!s_rule)
+		return -ENOMEM;
+
+	s_rule->type = cpu_to_le16(ICE_AQC_SW_RULES_T_LKUP_RX);
+	s_rule->pdata.lkup_tx_rx.act = 0;
+	s_rule->pdata.lkup_tx_rx.hdr_len = 0;
+	s_rule->pdata.lkup_tx_rx.index = cpu_to_le16(s_entry->rule_id);
+	status = ice_aq_sw_rules(&pf->hw, s_rule, ICE_SW_RULE_RX_TX_NO_HDR_SIZE,
+				 1, ice_aqc_opc_remove_sw_rules, NULL);
+	kfree(s_rule);
+	if (status)
+		return -EIO;
+
+	list_del(&s_entry->list_entry);
+	kfree(s_entry);
+	return 0;
+}
+
+/**
+ * ice_dcf_rm_sw_rule_to_vsi_list - remove switch rule of "forward to VSI list"
+ * @pf: pointer to the PF struct
+ * @s_entry: pointer to switch rule entry to remove
+ */
+static int
+ice_dcf_rm_sw_rule_to_vsi_list(struct ice_pf *pf,
+			       struct ice_dcf_sw_rule_entry *s_entry)
+{
+	struct ice_dcf_vsi_list_info *vsi_list_info = s_entry->vsi_list_info;
+	struct ice_aqc_alloc_free_res_elem *res_buf;
+	struct ice_aqc_sw_rules_elem *s_rule;
+	enum ice_status status;
+	u16 rule_sz;
+	u16 vsi_id;
+	int i = 0;
+
+	if (!vsi_list_info)
+		return -EINVAL;
+
+	/* The VSI list is empty, it can be freed immediately */
+	if (!vsi_list_info->vsi_count)
+		goto free_vsi_list;
+
+	rule_sz = ICE_SW_RULE_VSI_LIST_SIZE(vsi_list_info->vsi_count);
+	s_rule = kzalloc(rule_sz, GFP_KERNEL);
+	if (!s_rule)
+		return -ENOMEM;
+
+	s_rule->type = cpu_to_le16(ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR);
+	s_rule->pdata.vsi_list.index = cpu_to_le16(vsi_list_info->list_id);
+	s_rule->pdata.vsi_list.number_vsi =
+					cpu_to_le16(vsi_list_info->vsi_count);
+	for_each_set_bit(vsi_id, vsi_list_info->hw_vsi_map, ICE_HW_VSI_ID_MAX)
+		s_rule->pdata.vsi_list.vsi[i++] = cpu_to_le16(vsi_id);
+
+	bitmap_zero(vsi_list_info->hw_vsi_map, ICE_HW_VSI_ID_MAX);
+	vsi_list_info->vsi_count = 0;
+
+	status = ice_aq_sw_rules(&pf->hw, s_rule, rule_sz, 1,
+				 ice_aqc_opc_update_sw_rules, NULL);
+	kfree(s_rule);
+	if (status)
+		return -EIO;
+
+free_vsi_list:
+	res_buf = kzalloc(sizeof(*res_buf), GFP_KERNEL);
+	if (!res_buf)
+		return -ENOMEM;
+
+	res_buf->res_type = cpu_to_le16(ICE_AQC_RES_TYPE_VSI_LIST_REP);
+	res_buf->num_elems = cpu_to_le16(1);
+	res_buf->elem[0].e.sw_resp = cpu_to_le16(vsi_list_info->list_id);
+	status = ice_aq_alloc_free_res(&pf->hw, 1, res_buf, sizeof(*res_buf),
+				       ice_aqc_opc_free_res, NULL);
+	kfree(res_buf);
+	if (status)
+		return -EIO;
+
+	list_del(&vsi_list_info->list_entry);
+	kfree(vsi_list_info);
+	s_entry->vsi_list_info = NULL;
+
+	return ice_dcf_rm_sw_rule_to_vsi(pf, s_entry);
+}
+
+/**
+ * ice_dcf_rm_vsi_from_list - remove VSI from switch rule forward VSI list
+ * @pf: pointer to the PF struct
+ * @vsi_list_info: pointer to the VSI list info
+ * @hw_vsi_id: the Hardware VSI number
+ */
+static int
+ice_dcf_rm_vsi_from_list(struct ice_pf *pf,
+			 struct ice_dcf_vsi_list_info *vsi_list_info,
+			 u16 hw_vsi_id)
+{
+	struct ice_aqc_sw_rules_elem *s_rule;
+	enum ice_status status;
+
+	if (!vsi_list_info || !vsi_list_info->vsi_count ||
+	    !test_bit(hw_vsi_id, vsi_list_info->hw_vsi_map))
+		return -ENOENT;
+
+	s_rule = kzalloc(ICE_SW_RULE_VSI_LIST_SIZE(1), GFP_KERNEL);
+	if (!s_rule)
+		return -ENOMEM;
+
+	s_rule->type = cpu_to_le16(ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR);
+	s_rule->pdata.vsi_list.index = cpu_to_le16(vsi_list_info->list_id);
+	s_rule->pdata.vsi_list.number_vsi = cpu_to_le16(1);
+	s_rule->pdata.vsi_list.vsi[0] = cpu_to_le16(hw_vsi_id);
+	status = ice_aq_sw_rules(&pf->hw, s_rule,
+				 ICE_SW_RULE_VSI_LIST_SIZE(1), 1,
+				 ice_aqc_opc_update_sw_rules, NULL);
+	kfree(s_rule);
+	if (status)
+		return -EIO;
+
+	/* When the VF resets gracefully, it should keep the VSI list and its
+	 * rule, just clears the VSI from list, so that the DCF can replay the
+	 * rule by updating this VF to list successfully.
+	 */
+	vsi_list_info->vsi_count--;
+	clear_bit(hw_vsi_id, vsi_list_info->hw_vsi_map);
+
+	return 0;
+}
+
+/**
+ * ice_rm_dcf_sw_vsi_rule - remove switch rules added by DCF to VSI
+ * @pf: pointer to the PF struct
+ * @hw_vsi_id: hardware VSI ID of the VF
+ */
+void ice_rm_dcf_sw_vsi_rule(struct ice_pf *pf, u16 hw_vsi_id)
+{
+	struct ice_dcf_sw_rule_entry *s_entry, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(s_entry, tmp, &pf->dcf.sw_rule_head,
+				 list_entry)
+		if (s_entry->fltr_act == ICE_FWD_TO_VSI_LIST) {
+			ret = ice_dcf_rm_vsi_from_list(pf,
+						       s_entry->vsi_list_info,
+						       hw_vsi_id);
+			if (ret && ret != -ENOENT)
+				dev_err(ice_pf_to_dev(pf),
+					"Failed to remove VSI %u from VSI list : %d\n",
+					hw_vsi_id, ret);
+		} else if (s_entry->fwd_id.hw_vsi_id == hw_vsi_id) {
+			ret = ice_dcf_rm_sw_rule_to_vsi(pf, s_entry);
+			if (ret)
+				dev_err(ice_pf_to_dev(pf),
+					"Failed to remove VSI %u switch rule : %d\n",
+					hw_vsi_id, ret);
+		}
+}
+
+/**
+ * ice_dcf_init_sw_rule_mgmt - initializes DCF rule filter mgmt struct
+ * @pf: pointer to the PF struct
+ */
+void ice_dcf_init_sw_rule_mgmt(struct ice_pf *pf)
+{
+	INIT_LIST_HEAD(&pf->dcf.sw_rule_head);
+	INIT_LIST_HEAD(&pf->dcf.vsi_list_info_head);
+}
+
+/**
+ * ice_rm_all_dcf_sw_rules - remove switch rules configured by DCF
+ * @pf: pointer to the PF struct
+ */
+void ice_rm_all_dcf_sw_rules(struct ice_pf *pf)
+{
+	struct ice_dcf_vsi_list_info *vsi_list_info, *list_info_tmp;
+	struct ice_dcf_sw_rule_entry *sw_rule, *rule_tmp;
+	u16 rule_id, list_id;
+	int ret;
+
+	list_for_each_entry_safe(sw_rule, rule_tmp, &pf->dcf.sw_rule_head,
+				 list_entry)
+		if (sw_rule->fltr_act == ICE_FWD_TO_VSI_LIST) {
+			list_id = sw_rule->fwd_id.vsi_list_id;
+			rule_id = sw_rule->rule_id;
+			ret = ice_dcf_rm_sw_rule_to_vsi_list(pf, sw_rule);
+			if (ret)
+				dev_err(ice_pf_to_dev(pf),
+					"Failed to remove switch rule 0x%04x with list id %u : %d\n",
+					rule_id, list_id, ret);
+		} else {
+			rule_id = sw_rule->rule_id;
+			ret = ice_dcf_rm_sw_rule_to_vsi(pf, sw_rule);
+			if (ret)
+				dev_err(ice_pf_to_dev(pf),
+					"Failed to remove switch rule 0x%04x : %d\n",
+					rule_id, ret);
+		}
+
+	/* clears rule filter management data if AdminQ command has error */
+	list_for_each_entry_safe(vsi_list_info, list_info_tmp,
+				 &pf->dcf.vsi_list_info_head,
+				 list_entry) {
+		list_del(&vsi_list_info->list_entry);
+		kfree(vsi_list_info);
+	}
+
+	list_for_each_entry_safe(sw_rule, rule_tmp, &pf->dcf.sw_rule_head,
+				 list_entry) {
+		list_del(&sw_rule->list_entry);
+		kfree(sw_rule);
+	}
+}
+
+/**
+ * ice_dcf_find_vsi_list_info - find the VSI list by ID
+ * @pf: pointer to the PF info
+ * @vsi_list_id: VSI list ID
+ */
+static struct ice_dcf_vsi_list_info *
+ice_dcf_find_vsi_list_info(struct ice_pf *pf, u16 vsi_list_id)
+{
+	struct ice_dcf_vsi_list_info *list_info;
+
+	list_for_each_entry(list_info, &pf->dcf.vsi_list_info_head, list_entry)
+		if (list_info->list_id == vsi_list_id)
+			return list_info;
+
+	return NULL;
+}
+
+/**
+ * ice_dcf_add_vsi_id - add new VSI ID into list
+ * @vsi_list_info: pointer to the VSI list info
+ * @hw_vsi_id: the VSI ID
+ */
+static void
+ice_dcf_add_vsi_id(struct ice_dcf_vsi_list_info *vsi_list_info, u16 hw_vsi_id)
+{
+	if (!test_and_set_bit(hw_vsi_id, vsi_list_info->hw_vsi_map))
+		vsi_list_info->vsi_count++;
+}
+
+/**
+ * ice_dcf_del_vsi_id - delete the VSI ID from list
+ * @vsi_list_info: pointer to the VSI list info
+ * @hw_vsi_id: the VSI ID
+ */
+static void
+ice_dcf_del_vsi_id(struct ice_dcf_vsi_list_info *vsi_list_info, u16 hw_vsi_id)
+{
+	if (test_and_clear_bit(hw_vsi_id, vsi_list_info->hw_vsi_map))
+		vsi_list_info->vsi_count--;
+}
+
+/**
+ * ice_dcf_parse_alloc_vsi_list_res - parse the allocate VSI list resource
+ * @pf: pointer to the PF info
+ * @res: pointer to the VSI list resource
+ */
+static enum virtchnl_status_code
+ice_dcf_parse_alloc_vsi_list_res(struct ice_pf *pf,
+				 struct ice_aqc_res_elem *res)
+{
+	struct ice_dcf_vsi_list_info *vsi_list_info;
+	u16 list_id = le16_to_cpu(res->e.sw_resp);
+
+	vsi_list_info = ice_dcf_find_vsi_list_info(pf, list_id);
+	if (vsi_list_info)
+		return VIRTCHNL_STATUS_SUCCESS;
+
+	vsi_list_info = kzalloc(sizeof(*vsi_list_info), GFP_KERNEL);
+	if (!vsi_list_info)
+		return VIRTCHNL_STATUS_ERR_NO_MEMORY;
+
+	vsi_list_info->list_id = list_id;
+	list_add(&vsi_list_info->list_entry, &pf->dcf.vsi_list_info_head);
+
+	return VIRTCHNL_STATUS_SUCCESS;
+}
+
+/**
+ * ice_dcf_parse_free_vsi_list_res - parse the free VSI list resource
+ * @pf: pointer to the PF info
+ * @res: pointer to the VSI list resource
+ */
+static enum virtchnl_status_code
+ice_dcf_parse_free_vsi_list_res(struct ice_pf *pf,
+				struct ice_aqc_res_elem *res)
+{
+	struct ice_dcf_vsi_list_info *vsi_list_info;
+	u16 list_id = le16_to_cpu(res->e.sw_resp);
+
+	vsi_list_info = ice_dcf_find_vsi_list_info(pf, list_id);
+	if (!vsi_list_info)
+		return VIRTCHNL_STATUS_ERR_PARAM;
+
+	if (vsi_list_info->vsi_count)
+		dev_warn(ice_pf_to_dev(pf),
+			 "VSI list %u still has %u VSIs to be removed!\n",
+			 list_id, vsi_list_info->vsi_count);
+
+	if (vsi_list_info->sw_rule)
+		vsi_list_info->sw_rule->vsi_list_info = NULL;
+
+	list_del(&vsi_list_info->list_entry);
+	kfree(vsi_list_info);
+
+	return VIRTCHNL_STATUS_SUCCESS;
+}
+
+/**
+ * ice_dcf_set_vsi_list - set the VSI to VSI list
+ * @pf: pointer to the PF info
+ * @vsi_list: pointer to the VSI ID list to be set
+ */
+static enum virtchnl_status_code
+ice_dcf_set_vsi_list(struct ice_pf *pf, struct ice_aqc_sw_rules_elem *vsi_list)
+{
+	struct ice_dcf_vsi_list_info *vsi_list_info;
+	int i;
+
+	vsi_list_info = ice_dcf_find_vsi_list_info(pf,
+						   le16_to_cpu(vsi_list->pdata.vsi_list.index));
+	if (!vsi_list_info)
+		return VIRTCHNL_STATUS_ERR_PARAM;
+
+	for (i = 0; i < le16_to_cpu(vsi_list->pdata.vsi_list.number_vsi); i++)
+		ice_dcf_add_vsi_id(vsi_list_info,
+				   le16_to_cpu(vsi_list->pdata.vsi_list.vsi[i]));
+
+	return VIRTCHNL_STATUS_SUCCESS;
+}
+
+/**
+ * ice_dcf_clear_vsi_list - clear the VSI from VSI list
+ * @pf: pointer to the PF info
+ * @vsi_list: pointer to the VSI ID list to be cleared
+ */
+static enum virtchnl_status_code
+ice_dcf_clear_vsi_list(struct ice_pf *pf, struct ice_aqc_sw_rules_elem *vsi_list)
+{
+	struct ice_dcf_vsi_list_info *vsi_list_info;
+	int i;
+
+	vsi_list_info = ice_dcf_find_vsi_list_info(pf,
+						   le16_to_cpu(vsi_list->pdata.vsi_list.index));
+	if (!vsi_list_info)
+		return VIRTCHNL_STATUS_ERR_PARAM;
+
+	for (i = 0; i < le16_to_cpu(vsi_list->pdata.vsi_list.number_vsi); i++)
+		ice_dcf_del_vsi_id(vsi_list_info,
+				   le16_to_cpu(vsi_list->pdata.vsi_list.vsi[i]));
+
+	return VIRTCHNL_STATUS_SUCCESS;
+}
+
+/**
+ * ice_dcf_find_sw_rule - find the switch rule by ID
+ * @pf: pointer to the PF info
+ * @rule_id: switch rule ID
+ */
+static struct ice_dcf_sw_rule_entry *
+ice_dcf_find_sw_rule(struct ice_pf *pf, u16 rule_id)
+{
+	struct ice_dcf_sw_rule_entry *sw_rule;
+
+	list_for_each_entry(sw_rule, &pf->dcf.sw_rule_head, list_entry)
+		if (sw_rule->rule_id == rule_id)
+			return sw_rule;
+
+	return NULL;
+}
+
+/**
+ * ice_dcf_parse_add_sw_rule_data - parse the add switch rule data
+ * @pf: pointer to the PF info
+ * @lkup: pointer to the add switch rule data
+ */
+static enum virtchnl_status_code
+ice_dcf_parse_add_sw_rule_data(struct ice_pf *pf, struct ice_aqc_sw_rules_elem *lkup)
+{
+	struct ice_dcf_sw_rule_entry *sw_rule;
+	u32 act;
+
+	sw_rule = kzalloc(sizeof(*sw_rule), GFP_KERNEL);
+	if (!sw_rule)
+		return VIRTCHNL_STATUS_ERR_NO_MEMORY;
+
+	act = le32_to_cpu(lkup->pdata.lkup_tx_rx.act);
+	sw_rule->fltr_act = ICE_FWD_TO_VSI;
+	sw_rule->fwd_id.hw_vsi_id = (act & ICE_SINGLE_ACT_VSI_ID_M) >>
+					ICE_SINGLE_ACT_VSI_ID_S;
+	sw_rule->rule_id = le16_to_cpu(lkup->pdata.lkup_tx_rx.index);
+
+	list_add(&sw_rule->list_entry, &pf->dcf.sw_rule_head);
+
+	return VIRTCHNL_STATUS_SUCCESS;
+}
+
+/**
+ * ice_dcf_parse_updt_sw_rule_data - parse the update switch rule data
+ * @pf: pointer to the PF info
+ * @lkup: pointer to the update switch rule data
+ */
+static enum virtchnl_status_code
+ice_dcf_parse_updt_sw_rule_data(struct ice_pf *pf, struct ice_aqc_sw_rules_elem *lkup)
+{
+	struct ice_dcf_vsi_list_info *vsi_list_info;
+	struct ice_dcf_sw_rule_entry *sw_rule;
+	u16 vsi_list_id, rule_id;
+	u32 act;
+
+	rule_id = le16_to_cpu(lkup->pdata.lkup_tx_rx.index);
+	sw_rule = ice_dcf_find_sw_rule(pf, rule_id);
+	if (!sw_rule)
+		return VIRTCHNL_STATUS_ERR_PARAM;
+
+	act = le32_to_cpu(lkup->pdata.lkup_tx_rx.act);
+	if (!(act & ICE_SINGLE_ACT_VSI_LIST)) {
+		u16 vsi_hw_id = (act & ICE_SINGLE_ACT_VSI_ID_M) >>
+				ICE_SINGLE_ACT_VSI_ID_S;
+
+		sw_rule->fltr_act = ICE_FWD_TO_VSI;
+		sw_rule->fwd_id.hw_vsi_id = vsi_hw_id;
+
+		return VIRTCHNL_STATUS_SUCCESS;
+	}
+
+	vsi_list_id = (act & ICE_SINGLE_ACT_VSI_LIST_ID_M) >>
+				ICE_SINGLE_ACT_VSI_LIST_ID_S;
+	if (sw_rule->vsi_list_info) {
+		if (sw_rule->vsi_list_info->list_id == vsi_list_id)
+			return VIRTCHNL_STATUS_SUCCESS;
+
+		dev_err(ice_pf_to_dev(pf),
+			"The switch rule 0x%04x is running on VSI list %u\n",
+			rule_id, sw_rule->vsi_list_info->list_id);
+		return VIRTCHNL_STATUS_ERR_PARAM;
+	}
+
+	vsi_list_info = ice_dcf_find_vsi_list_info(pf, vsi_list_id);
+	if (!vsi_list_info) {
+		dev_err(ice_pf_to_dev(pf),
+			"No VSI list %u found to bind the switch rule 0x%04x\n",
+			vsi_list_id, rule_id);
+		return VIRTCHNL_STATUS_ERR_PARAM;
+	}
+
+	if (vsi_list_info->sw_rule) {
+		if (vsi_list_info->sw_rule->rule_id == rule_id)
+			return VIRTCHNL_STATUS_SUCCESS;
+
+		dev_err(ice_pf_to_dev(pf),
+			"The VSI list %u is running on switch rule 0x%04x\n",
+			vsi_list_id, vsi_list_info->sw_rule->rule_id);
+		return VIRTCHNL_STATUS_ERR_PARAM;
+	}
+
+	vsi_list_info->sw_rule = sw_rule;
+
+	sw_rule->fltr_act = ICE_FWD_TO_VSI_LIST;
+	sw_rule->fwd_id.vsi_list_id = vsi_list_id;
+	sw_rule->vsi_list_info = vsi_list_info;
+
+	return VIRTCHNL_STATUS_SUCCESS;
+}
+
+/**
+ * ice_dcf_parse_rm_sw_rule_data - parse the remove switch rule data
+ * @pf: pointer to the PF info
+ * @lkup: pointer to the remove switch rule data
+ */
+static enum virtchnl_status_code
+ice_dcf_parse_rm_sw_rule_data(struct ice_pf *pf, struct ice_aqc_sw_rules_elem *lkup)
+{
+	u16 rule_id = le16_to_cpu(lkup->pdata.lkup_tx_rx.index);
+	struct ice_dcf_sw_rule_entry *sw_rule, *tmp;
+
+	list_for_each_entry_safe(sw_rule, tmp, &pf->dcf.sw_rule_head,
+				 list_entry)
+		if (sw_rule->rule_id == rule_id) {
+			list_del(&sw_rule->list_entry);
+			kfree(sw_rule);
+		}
+
+	return VIRTCHNL_STATUS_SUCCESS;
+}
+
+/**
+ * ice_dcf_handle_add_sw_rule_rsp - handle the add switch rule response
+ * @pf: pointer to the PF info
+ * @aq_buf: pointer to the add switch rule command buffer
+ */
+static enum virtchnl_status_code
+ice_dcf_handle_add_sw_rule_rsp(struct ice_pf *pf, u8 *aq_buf)
+{
+	enum virtchnl_status_code status = VIRTCHNL_STATUS_SUCCESS;
+	struct ice_aqc_sw_rules_elem *em =
+			(struct ice_aqc_sw_rules_elem *)aq_buf;
+	u16 type = le16_to_cpu(em->type);
+
+	if (type == ICE_AQC_SW_RULES_T_VSI_LIST_SET)
+		status = ice_dcf_set_vsi_list(pf, em);
+	else if (type == ICE_AQC_SW_RULES_T_LKUP_RX)
+		status = ice_dcf_parse_add_sw_rule_data(pf, em);
+
+	return status;
+}
+
+/**
+ * ice_dcf_handle_updt_sw_rule_rsp - handle the update switch rule response
+ * @pf: pointer to the PF info
+ * @aq_buf: pointer to the update switch rule command buffer
+ */
+static enum virtchnl_status_code
+ice_dcf_handle_updt_sw_rule_rsp(struct ice_pf *pf, u8 *aq_buf)
+{
+	enum virtchnl_status_code status = VIRTCHNL_STATUS_SUCCESS;
+	struct ice_aqc_sw_rules_elem *em =
+			(struct ice_aqc_sw_rules_elem *)aq_buf;
+	u16 type = le16_to_cpu(em->type);
+
+	if (type == ICE_AQC_SW_RULES_T_VSI_LIST_SET)
+		status = ice_dcf_set_vsi_list(pf, em);
+	else if (type == ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR)
+		status = ice_dcf_clear_vsi_list(pf, em);
+	else if (type == ICE_AQC_SW_RULES_T_LKUP_RX)
+		status = ice_dcf_parse_updt_sw_rule_data(pf, em);
+
+	return status;
+}
+
+/**
+ * ice_dcf_handle_rm_sw_rule_rsp - handle the remove switch rule response
+ * @pf: pointer to the PF info
+ * @aq_buf: pointer to the remove switch rule command buffer
+ */
+static enum virtchnl_status_code
+ice_dcf_handle_rm_sw_rule_rsp(struct ice_pf *pf, u8 *aq_buf)
+{
+	enum virtchnl_status_code status = VIRTCHNL_STATUS_SUCCESS;
+	struct ice_aqc_sw_rules_elem *em =
+			(struct ice_aqc_sw_rules_elem *)aq_buf;
+	u16 type = le16_to_cpu(em->type);
+
+	if (type == ICE_AQC_SW_RULES_T_LKUP_RX)
+		status = ice_dcf_parse_rm_sw_rule_data(pf, em);
+
+	return status;
+}
+
+/**
+ * ice_dcf_handle_alloc_res_rsp - handle the allocate resource response
+ * @pf: pointer to the PF info
+ * @aq_buf: pointer to the allocate resource command buffer
+ */
+static enum virtchnl_status_code
+ice_dcf_handle_alloc_res_rsp(struct ice_pf *pf, u8 *aq_buf)
+{
+	enum virtchnl_status_code status = VIRTCHNL_STATUS_SUCCESS;
+	struct ice_aqc_alloc_free_res_elem *res_buf =
+		 (struct ice_aqc_alloc_free_res_elem *)aq_buf;
+	u16 type = (le16_to_cpu(res_buf->res_type) &
+		    ICE_AQC_RES_TYPE_M) >> ICE_AQC_RES_TYPE_S;
+
+	if (type == ICE_AQC_RES_TYPE_VSI_LIST_REP)
+		status = ice_dcf_parse_alloc_vsi_list_res(pf,
+							  &res_buf->elem[0]);
+
+	return status;
+}
+
+/**
+ * ice_dcf_handle_free_res_rsp - handle the free resource response
+ * @pf: pointer to the PF info
+ * @aq_buf: pointer to the free resource command buffer
+ */
+static enum virtchnl_status_code
+ice_dcf_handle_free_res_rsp(struct ice_pf *pf, u8 *aq_buf)
+{
+	enum virtchnl_status_code status = VIRTCHNL_STATUS_SUCCESS;
+	struct ice_aqc_alloc_free_res_elem *res_buf =
+		 (struct ice_aqc_alloc_free_res_elem *)aq_buf;
+	u16 type = (le16_to_cpu(res_buf->res_type) &
+		    ICE_AQC_RES_TYPE_M) >> ICE_AQC_RES_TYPE_S;
+
+	if (type == ICE_AQC_RES_TYPE_VSI_LIST_REP)
+		status = ice_dcf_parse_free_vsi_list_res(pf,
+							 &res_buf->elem[0]);
+
+	return status;
+}
+
+/**
+ * ice_dcf_post_aq_send_cmd - get the data from firmware successful response
+ * @pf: pointer to the PF info
+ * @aq_desc: descriptor describing the command
+ * @aq_buf: the AdminQ command buffer
+ */
+enum virtchnl_status_code
+ice_dcf_post_aq_send_cmd(struct ice_pf *pf, struct ice_aq_desc *aq_desc,
+			 u8 *aq_buf)
+{
+	enum virtchnl_status_code status = VIRTCHNL_STATUS_SUCCESS;
+	u16 opc = le16_to_cpu(aq_desc->opcode);
+
+	if (!aq_buf)
+		return VIRTCHNL_STATUS_SUCCESS;
+
+	if (opc == ice_aqc_opc_add_sw_rules)
+		status = ice_dcf_handle_add_sw_rule_rsp(pf, aq_buf);
+	else if (opc == ice_aqc_opc_update_sw_rules)
+		status = ice_dcf_handle_updt_sw_rule_rsp(pf, aq_buf);
+	else if (opc == ice_aqc_opc_remove_sw_rules)
+		status = ice_dcf_handle_rm_sw_rule_rsp(pf, aq_buf);
+	else if (opc == ice_aqc_opc_alloc_res)
+		status = ice_dcf_handle_alloc_res_rsp(pf, aq_buf);
+	else if (opc == ice_aqc_opc_free_res)
+		status = ice_dcf_handle_free_res_rsp(pf, aq_buf);
+
+	return status;
+}
+
+/**
+ * ice_dcf_pre_aq_send_cmd - check if it needs to send the command to firmware
+ * @vf: pointer to the VF info
+ * @aq_desc: descriptor describing the command
+ * @aq_buf: the AdminQ command buffer
+ * @aq_buf_size: the AdminQ command buffer size
+ */
+bool
+ice_dcf_pre_aq_send_cmd(struct ice_vf *vf, struct ice_aq_desc *aq_desc,
+			u8 *aq_buf, u16 aq_buf_size)
+{
+	struct ice_pf *pf = vf->pf;
+
+	switch (le16_to_cpu(aq_desc->opcode)) {
+	case ice_aqc_opc_update_sw_rules:
+	{
+		struct ice_dcf_vsi_list_info *vsi_list_info;
+		struct ice_aqc_sw_rules_elem *s_rule;
+		u16 list_id, vsi_id;
+
+		if (aq_buf_size < ICE_SW_RULE_VSI_LIST_SIZE(1))
+			break;
+
+		s_rule = (struct ice_aqc_sw_rules_elem *)aq_buf;
+		if (le16_to_cpu(s_rule->type) !=
+					ICE_AQC_SW_RULES_T_VSI_LIST_CLEAR ||
+		    le16_to_cpu(s_rule->pdata.vsi_list.number_vsi) != 1)
+			break;
+
+		list_id = le16_to_cpu(s_rule->pdata.vsi_list.index);
+		vsi_list_info = ice_dcf_find_vsi_list_info(pf, list_id);
+		if (!vsi_list_info)
+			break;
+
+		vsi_id = le16_to_cpu(s_rule->pdata.vsi_list.vsi[0]);
+		if (vsi_id >= ICE_HW_VSI_ID_MAX ||
+		    test_bit(vsi_id, vsi_list_info->hw_vsi_map))
+			break;
+
+		/* The VSI is removed from list already, no need to send the
+		 * command to firmware.
+		 */
+		return true;
+	}
+	case ice_aqc_opc_remove_sw_rules:
+	{
+		struct ice_aqc_sw_rules_elem *s_rule;
+		u16 rule_id;
+
+		if (aq_buf_size < ICE_SW_RULE_RX_TX_NO_HDR_SIZE)
+			break;
+
+		s_rule = (struct ice_aqc_sw_rules_elem *)aq_buf;
+		if (le16_to_cpu(s_rule->type) != ICE_AQC_SW_RULES_T_LKUP_RX)
+			break;
+
+		rule_id = le16_to_cpu(s_rule->pdata.lkup_tx_rx.index);
+		if (ice_dcf_find_sw_rule(pf, rule_id))
+			break;
+
+		/* The switch rule is removed already, no need to send the
+		 * command to firmware.
+		 */
+		return true;
+	}
+
+	default:
+		break;
+	}
+
+	return false;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_dcf.h b/drivers/net/ethernet/intel/ice/ice_dcf.h
index 1ca228f89a19..23842db0a884 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcf.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcf.h
@@ -21,10 +21,42 @@ enum ice_dcf_state {
 	ICE_DCF_STATE_PAUSE,
 };
 
+struct ice_dcf_sw_rule_entry;
+
+#define ICE_HW_VSI_ID_MAX	BIT(10) /* The AQ VSI number uses 10 bits */
+
+struct ice_dcf_vsi_list_info {
+	struct list_head list_entry;
+	struct ice_dcf_sw_rule_entry *sw_rule;
+	u16 list_id;
+
+	u16 vsi_count;
+	DECLARE_BITMAP(hw_vsi_map, ICE_HW_VSI_ID_MAX);
+};
+
+struct ice_dcf_sw_rule_entry {
+	struct list_head list_entry;
+	u16 rule_id;
+
+	/* Only support ICE_FWD_TO_VSI and ICE_FWD_TO_VSI_LIST */
+	enum ice_sw_fwd_act_type fltr_act;
+	/* Depending on filter action */
+	union {
+		u16 hw_vsi_id:10;
+		u16 vsi_list_id:10;
+	} fwd_id;
+
+	struct ice_dcf_vsi_list_info *vsi_list_info;
+};
+
 struct ice_dcf {
 	struct ice_vf *vf;
 	enum ice_dcf_state state;
 
+	/* Trace the switch rules added/removed by DCF */
+	struct list_head sw_rule_head;
+	struct list_head vsi_list_info_head;
+
 	/* Handle the AdminQ command between the DCF (Device Config Function)
 	 * and the firmware.
 	 */
@@ -46,5 +78,14 @@ bool ice_check_dcf_allowed(struct ice_vf *vf);
 bool ice_is_vf_dcf(struct ice_vf *vf);
 enum ice_dcf_state ice_dcf_get_state(struct ice_pf *pf);
 void ice_dcf_set_state(struct ice_pf *pf, enum ice_dcf_state state);
+void ice_dcf_init_sw_rule_mgmt(struct ice_pf *pf);
+void ice_rm_all_dcf_sw_rules(struct ice_pf *pf);
+void ice_rm_dcf_sw_vsi_rule(struct ice_pf *pf, u16 hw_vsi_id);
+bool
+ice_dcf_pre_aq_send_cmd(struct ice_vf *vf, struct ice_aq_desc *aq_desc,
+			u8 *aq_buf, u16 aq_buf_size);
+enum virtchnl_status_code
+ice_dcf_post_aq_send_cmd(struct ice_pf *pf, struct ice_aq_desc *aq_desc,
+			 u8 *aq_buf);
 #endif /* CONFIG_PCI_IOV */
 #endif /* _ICE_DCF_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index ccbe1cc64295..ee434b8d794d 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -23,24 +23,10 @@
  *	In case of Ether type filter it is treated as header without VLAN tag
  *	and byte 12 and 13 is used to program a given Ether type instead
  */
-#define DUMMY_ETH_HDR_LEN		16
 static const u8 dummy_eth_header[DUMMY_ETH_HDR_LEN] = { 0x2, 0, 0, 0, 0, 0,
 							0x2, 0, 0, 0, 0, 0,
 							0x81, 0, 0, 0};
 
-#define ICE_SW_RULE_RX_TX_ETH_HDR_SIZE \
-	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr) + \
-	 (DUMMY_ETH_HDR_LEN * \
-	  sizeof(((struct ice_sw_rule_lkup_rx_tx *)0)->hdr[0])))
-#define ICE_SW_RULE_RX_TX_NO_HDR_SIZE \
-	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr))
-#define ICE_SW_RULE_LG_ACT_SIZE(n) \
-	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lg_act.act) + \
-	 ((n) * sizeof(((struct ice_sw_rule_lg_act *)0)->act[0])))
-#define ICE_SW_RULE_VSI_LIST_SIZE(n) \
-	(offsetof(struct ice_aqc_sw_rules_elem, pdata.vsi_list.vsi) + \
-	 ((n) * sizeof(((struct ice_sw_rule_vsi_list *)0)->vsi[0])))
-
 /**
  * ice_init_def_sw_recp - initialize the recipe book keeping tables
  * @hw: pointer to the HW struct
@@ -490,7 +476,7 @@ ice_aq_alloc_free_vsi_list(struct ice_hw *hw, u16 *vsi_list_id,
  *
  * Add(0x02a0)/Update(0x02a1)/Remove(0x02a2) switch rules commands to firmware
  */
-static enum ice_status
+enum ice_status
 ice_aq_sw_rules(struct ice_hw *hw, void *rule_list, u16 rule_list_sz,
 		u8 num_rules, enum ice_adminq_opc opc, struct ice_sq_cd *cd)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index 8b4f9d35c860..05cd6ea24d44 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -14,6 +14,20 @@
 #define ICE_VSI_INVAL_ID 0xffff
 #define ICE_INVAL_Q_HANDLE 0xFFFF
 
+#define DUMMY_ETH_HDR_LEN		16
+#define ICE_SW_RULE_RX_TX_ETH_HDR_SIZE \
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr) + \
+	 (DUMMY_ETH_HDR_LEN * \
+	  sizeof(((struct ice_sw_rule_lkup_rx_tx *)0)->hdr[0])))
+#define ICE_SW_RULE_RX_TX_NO_HDR_SIZE \
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lkup_tx_rx.hdr))
+#define ICE_SW_RULE_LG_ACT_SIZE(n) \
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.lg_act.act) + \
+	 ((n) * sizeof(((struct ice_sw_rule_lg_act *)0)->act[0])))
+#define ICE_SW_RULE_VSI_LIST_SIZE(n) \
+	(offsetof(struct ice_aqc_sw_rules_elem, pdata.vsi_list.vsi) + \
+	 ((n) * sizeof(((struct ice_sw_rule_vsi_list *)0)->vsi[0])))
+
 /* VSI context structure for add/get/update/free operations */
 struct ice_vsi_ctx {
 	u16 vsi_num;
@@ -28,15 +42,6 @@ struct ice_vsi_ctx {
 	struct ice_q_ctx *lan_q_ctx[ICE_MAX_TRAFFIC_CLASS];
 };
 
-enum ice_sw_fwd_act_type {
-	ICE_FWD_TO_VSI = 0,
-	ICE_FWD_TO_VSI_LIST, /* Do not use this when adding filter */
-	ICE_FWD_TO_Q,
-	ICE_FWD_TO_QGRP,
-	ICE_DROP_PACKET,
-	ICE_INVAL_ACT
-};
-
 /* Switch recipe ID enum values are specific to hardware */
 enum ice_sw_lkup_type {
 	ICE_SW_LKUP_ETHERTYPE = 0,
@@ -247,5 +252,7 @@ bool ice_is_vsi_valid(struct ice_hw *hw, u16 vsi_handle);
 
 enum ice_status ice_replay_vsi_all_fltr(struct ice_hw *hw, u16 vsi_handle);
 void ice_rm_all_sw_replay_rule_info(struct ice_hw *hw);
-
+enum ice_status
+ice_aq_sw_rules(struct ice_hw *hw, void *rule_list, u16 rule_list_sz,
+		u8 num_rules, enum ice_adminq_opc opc, struct ice_sq_cd *cd);
 #endif /* _ICE_SWITCH_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index c1ad8622e65c..c2eff68d5469 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -707,6 +707,15 @@ struct ice_hw_port_stats {
 	u64 fd_sb_match;
 };
 
+enum ice_sw_fwd_act_type {
+	ICE_FWD_TO_VSI = 0,
+	ICE_FWD_TO_VSI_LIST, /* Do not use this when adding filter */
+	ICE_FWD_TO_Q,
+	ICE_FWD_TO_QGRP,
+	ICE_DROP_PACKET,
+	ICE_INVAL_ACT
+};
+
 /* Checksum and Shadow RAM pointers */
 #define ICE_SR_BOOT_CFG_PTR		0x132
 #define ICE_NVM_OROM_VER_OFF		0x02
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index c9dd9d473922..a0ec716c193b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -361,6 +361,7 @@ void ice_free_vfs(struct ice_pf *pf)
 		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
 
 	if (ice_dcf_get_state(pf) != ICE_DCF_STATE_OFF) {
+		ice_rm_all_dcf_sw_rules(pf);
 		ice_dcf_set_state(pf, ICE_DCF_STATE_OFF);
 		pf->dcf.vf = NULL;
 	}
@@ -1055,6 +1056,9 @@ static void ice_vf_clear_counters(struct ice_vf *vf)
  */
 static void ice_vf_pre_vsi_rebuild(struct ice_vf *vf)
 {
+	/* Remove switch rules associated with the reset VF */
+	ice_rm_dcf_sw_vsi_rule(vf->pf, vf->lan_vsi_num);
+
 	ice_vf_clear_counters(vf);
 	ice_clear_vf_reset_trigger(vf);
 }
@@ -1584,6 +1588,8 @@ static int ice_ena_vfs(struct ice_pf *pf, u16 num_vfs)
 	if (ret)
 		goto err_pci_disable_sriov;
 
+	ice_dcf_init_sw_rule_mgmt(pf);
+
 	if (ice_set_per_vf_res(pf)) {
 		dev_err(dev, "Not enough resources for %d VFs, try with fewer number of VFs\n",
 			num_vfs);
@@ -2013,6 +2019,13 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 			 ICE_DCF_VFID);
 	} else if (ice_is_vf_dcf(vf) &&
 		   ice_dcf_get_state(pf) != ICE_DCF_STATE_OFF) {
+		/* If a designated DCF requests AVF functionality from the
+		 * same VF without the DCF gracefully relinquishing the DCF
+		 * functionality first, remove ALL switch filters that were
+		 * added by the DCF.
+		 */
+		dev_info(ice_pf_to_dev(pf), "DCF is not in the OFF state, removing all switch filters that were added by the DCF\n");
+		ice_rm_all_dcf_sw_rules(pf);
 		ice_dcf_set_state(pf, ICE_DCF_STATE_OFF);
 		pf->dcf.vf = NULL;
 		ice_reset_vf(vf, false);
@@ -3724,6 +3737,18 @@ ice_dcf_handle_aq_cmd(struct ice_vf *vf, struct ice_aq_desc *aq_desc,
 	if ((aq_buf && !aq_buf_size) || (!aq_buf && aq_buf_size))
 		return -EINVAL;
 
+	if (ice_dcf_pre_aq_send_cmd(vf, aq_desc, aq_buf, aq_buf_size)) {
+		ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DCF_CMD_DESC,
+					    VIRTCHNL_STATUS_SUCCESS,
+					    (u8 *)aq_desc, sizeof(*aq_desc));
+		if (ret || !aq_buf_size)
+			return ret;
+
+		v_op = VIRTCHNL_OP_DCF_CMD_BUFF;
+		v_ret = VIRTCHNL_STATUS_SUCCESS;
+		goto err;
+	}
+
 	aq_ret = ice_aq_send_cmd(&pf->hw, aq_desc, aq_buf, aq_buf_size, NULL);
 	/* It needs to send back the AQ response message if ICE_ERR_AQ_ERROR
 	 * returns, some AdminQ handlers will use the error code filled by FW
@@ -3735,6 +3760,14 @@ ice_dcf_handle_aq_cmd(struct ice_vf *vf, struct ice_aq_desc *aq_desc,
 		goto err;
 	}
 
+	if (aq_ret != ICE_ERR_AQ_ERROR) {
+		v_ret = ice_dcf_post_aq_send_cmd(pf, aq_desc, aq_buf);
+		if (v_ret != VIRTCHNL_STATUS_SUCCESS) {
+			v_op = VIRTCHNL_OP_DCF_CMD_DESC;
+			goto err;
+		}
+	}
+
 	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DCF_CMD_DESC, v_ret,
 				    (u8 *)aq_desc, sizeof(*aq_desc));
 	/* Bail out so we don't send the VIRTCHNL_OP_DCF_CMD_BUFF message
@@ -3841,6 +3874,7 @@ static int ice_vc_dis_dcf_cap(struct ice_vf *vf)
 
 	if (vf->driver_caps & VIRTCHNL_VF_CAP_DCF) {
 		vf->driver_caps &= ~VIRTCHNL_VF_CAP_DCF;
+		ice_rm_all_dcf_sw_rules(vf->pf);
 		ice_dcf_set_state(vf->pf, ICE_DCF_STATE_OFF);
 		vf->pf->dcf.vf = NULL;
 	}
@@ -4257,8 +4291,14 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	if (trusted == vf->trusted)
 		return 0;
 
+	/* If the trust mode of a given DCF is taken away without the DCF
+	 * gracefully relinquishing the DCF functionality, remove ALL switch
+	 * filters that were added by the DCF and treat this VF as any other
+	 * untrusted AVF.
+	 */
 	if (ice_is_vf_dcf(vf) && !trusted &&
 	    ice_dcf_get_state(pf) != ICE_DCF_STATE_OFF) {
+		ice_rm_all_dcf_sw_rules(pf);
 		ice_dcf_set_state(pf, ICE_DCF_STATE_OFF);
 		pf->dcf.vf = NULL;
 		vf->driver_caps &= ~VIRTCHNL_VF_CAP_DCF;
-- 
2.26.2

