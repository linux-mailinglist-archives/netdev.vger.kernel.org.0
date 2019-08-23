Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C68E9B8F5
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfHWXiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:38:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:14903 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbfHWXhy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:37:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 16:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="184354446"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2019 16:37:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/14] ice: Don't allow VSI to remove unassociated ucast filter
Date:   Fri, 23 Aug 2019 16:37:50 -0700
Message-Id: <20190823233750.7997-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

If a VSI is not using a unicast filter or did not configure that
particular unicast filter, driver should not allow it to be removed
by the rogue VSI.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 56 +++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 8271fd651725..99cf527d2b1a 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2136,6 +2136,38 @@ ice_cfg_dflt_vsi(struct ice_hw *hw, u16 vsi_handle, bool set, u8 direction)
 	return status;
 }
 
+/**
+ * ice_find_ucast_rule_entry - Search for a unicast MAC filter rule entry
+ * @hw: pointer to the hardware structure
+ * @recp_id: lookup type for which the specified rule needs to be searched
+ * @f_info: rule information
+ *
+ * Helper function to search for a unicast rule entry - this is to be used
+ * to remove unicast MAC filter that is not shared with other VSIs on the
+ * PF switch.
+ *
+ * Returns pointer to entry storing the rule if found
+ */
+static struct ice_fltr_mgmt_list_entry *
+ice_find_ucast_rule_entry(struct ice_hw *hw, u8 recp_id,
+			  struct ice_fltr_info *f_info)
+{
+	struct ice_switch_info *sw = hw->switch_info;
+	struct ice_fltr_mgmt_list_entry *list_itr;
+	struct list_head *list_head;
+
+	list_head = &sw->recp_list[recp_id].filt_rules;
+	list_for_each_entry(list_itr, list_head, list_entry) {
+		if (!memcmp(&f_info->l_data, &list_itr->fltr_info.l_data,
+			    sizeof(f_info->l_data)) &&
+		    f_info->fwd_id.hw_vsi_id ==
+		    list_itr->fltr_info.fwd_id.hw_vsi_id &&
+		    f_info->flag == list_itr->fltr_info.flag)
+			return list_itr;
+	}
+	return NULL;
+}
+
 /**
  * ice_remove_mac - remove a MAC address based filter rule
  * @hw: pointer to the hardware structure
@@ -2153,15 +2185,39 @@ enum ice_status
 ice_remove_mac(struct ice_hw *hw, struct list_head *m_list)
 {
 	struct ice_fltr_list_entry *list_itr, *tmp;
+	struct mutex *rule_lock; /* Lock to protect filter rule list */
 
 	if (!m_list)
 		return ICE_ERR_PARAM;
 
+	rule_lock = &hw->switch_info->recp_list[ICE_SW_LKUP_MAC].filt_rule_lock;
 	list_for_each_entry_safe(list_itr, tmp, m_list, list_entry) {
 		enum ice_sw_lkup_type l_type = list_itr->fltr_info.lkup_type;
+		u8 *add = &list_itr->fltr_info.l_data.mac.mac_addr[0];
+		u16 vsi_handle;
 
 		if (l_type != ICE_SW_LKUP_MAC)
 			return ICE_ERR_PARAM;
+
+		vsi_handle = list_itr->fltr_info.vsi_handle;
+		if (!ice_is_vsi_valid(hw, vsi_handle))
+			return ICE_ERR_PARAM;
+
+		list_itr->fltr_info.fwd_id.hw_vsi_id =
+					ice_get_hw_vsi_num(hw, vsi_handle);
+		if (is_unicast_ether_addr(add) && !hw->ucast_shared) {
+			/* Don't remove the unicast address that belongs to
+			 * another VSI on the switch, since it is not being
+			 * shared...
+			 */
+			mutex_lock(rule_lock);
+			if (!ice_find_ucast_rule_entry(hw, ICE_SW_LKUP_MAC,
+						       &list_itr->fltr_info)) {
+				mutex_unlock(rule_lock);
+				return ICE_ERR_DOES_NOT_EXIST;
+			}
+			mutex_unlock(rule_lock);
+		}
 		list_itr->status = ice_remove_rule_internal(hw,
 							    ICE_SW_LKUP_MAC,
 							    list_itr);
-- 
2.21.0

