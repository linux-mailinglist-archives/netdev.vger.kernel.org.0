Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51F9104CD0
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKUHqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:46:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:4523 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbfKUHqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 02:46:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 23:46:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,224,1571727600"; 
   d="scan'208";a="216077554"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga001.fm.intel.com with ESMTP; 20 Nov 2019 23:46:15 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] ice: Refactor removal of VLAN promiscuous rules
Date:   Wed, 20 Nov 2019 23:46:05 -0800
Message-Id: <20191121074612.3055661-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently ice_clear_vsi_promisc() detects if the VLAN ID sent is not 0
and sets the recipe_id to ICE_SW_LKUP_PROMISC_VLAN in that case and
ICE_SW_LKUP_PROMISC if the VLAN_ID is 0. However this doesn't allow VLAN
0 promiscuous rules to be removed, but they can be added. Fix this by
checking if the promisc_mask contains ICE_PROMISC_VLAN_RX or
ICE_PROMISC_VLAN_TX. This change was made to match what is being done
for ice_set_vsi_promisc().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 77d211ea3aae..b5a53f862a83 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2428,7 +2428,7 @@ ice_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 	if (!ice_is_vsi_valid(hw, vsi_handle))
 		return ICE_ERR_PARAM;
 
-	if (vid)
+	if (promisc_mask & (ICE_PROMISC_VLAN_RX | ICE_PROMISC_VLAN_TX))
 		recipe_id = ICE_SW_LKUP_PROMISC_VLAN;
 	else
 		recipe_id = ICE_SW_LKUP_PROMISC;
@@ -2440,13 +2440,18 @@ ice_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 
 	mutex_lock(rule_lock);
 	list_for_each_entry(itr, rule_head, list_entry) {
+		struct ice_fltr_info *fltr_info;
 		u8 fltr_promisc_mask = 0;
 
 		if (!ice_vsi_uses_fltr(itr, vsi_handle))
 			continue;
+		fltr_info = &itr->fltr_info;
+
+		if (recipe_id == ICE_SW_LKUP_PROMISC_VLAN &&
+		    vid != fltr_info->l_data.mac_vlan.vlan_id)
+			continue;
 
-		fltr_promisc_mask |=
-			ice_determine_promisc_mask(&itr->fltr_info);
+		fltr_promisc_mask |= ice_determine_promisc_mask(fltr_info);
 
 		/* Skip if filter is not completely specified by given mask */
 		if (fltr_promisc_mask & ~promisc_mask)
@@ -2454,7 +2459,7 @@ ice_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
 
 		status = ice_add_entry_to_vsi_fltr_list(hw, vsi_handle,
 							&remove_list_head,
-							&itr->fltr_info);
+							fltr_info);
 		if (status) {
 			mutex_unlock(rule_lock);
 			goto free_fltr_list;
-- 
2.23.0

