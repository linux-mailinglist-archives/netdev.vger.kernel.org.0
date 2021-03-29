Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FC234D8F0
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhC2USI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:18:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:19969 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231709AbhC2UR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:17:28 -0400
IronPort-SDR: b/79sJKGZvjWjJAz6eitkLF7IdlNpGPn1dRBD/Xkv3AsC+2SfVP9RDLjOMV/lTcuyBvs4Afc+Z
 1T1ChiRZBa9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179160822"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="179160822"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 13:17:26 -0700
IronPort-SDR: smseh8th5sAXL98A2G8C8lb0KPhCJ8uHmHD49ahtcendx9/sgfDs1fXKRM66KP8hh4aMdost6e
 HqBKyT0O0WVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="454700551"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2021 13:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     =?UTF-8?q?Jacek=20Bu=C5=82atek?= <jacekx.bulatek@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Haiyue Wang <haiyue.wang@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 7/9] ice: Fix for dereference of NULL pointer
Date:   Mon, 29 Mar 2021 13:18:55 -0700
Message-Id: <20210329201857.3509461-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
References: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacek Bułatek <jacekx.bulatek@intel.com>

Add handling of allocation fault for ice_vsi_list_map_info.

Also *fi should not be NULL pointer, it is a reference to raw
data field, so remove this variable and use the reference
directly.

Fixes: 9daf8208dd4d ("ice: Add support for switch filter programming")
Signed-off-by: Jacek Bułatek <jacekx.bulatek@intel.com>
Co-developed-by: Haiyue Wang <haiyue.wang@intel.com>
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 67c965a3f5d2..387d3f6cd71e 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1238,6 +1238,9 @@ ice_add_update_vsi_list(struct ice_hw *hw,
 			ice_create_vsi_list_map(hw, &vsi_handle_arr[0], 2,
 						vsi_list_id);
 
+		if (!m_entry->vsi_list_info)
+			return ICE_ERR_NO_MEMORY;
+
 		/* If this entry was large action then the large action needs
 		 * to be updated to point to FWD to VSI list
 		 */
@@ -2220,6 +2223,7 @@ ice_vsi_uses_fltr(struct ice_fltr_mgmt_list_entry *fm_entry, u16 vsi_handle)
 	return ((fm_entry->fltr_info.fltr_act == ICE_FWD_TO_VSI &&
 		 fm_entry->fltr_info.vsi_handle == vsi_handle) ||
 		(fm_entry->fltr_info.fltr_act == ICE_FWD_TO_VSI_LIST &&
+		 fm_entry->vsi_list_info &&
 		 (test_bit(vsi_handle, fm_entry->vsi_list_info->vsi_map))));
 }
 
@@ -2292,14 +2296,12 @@ ice_add_to_vsi_fltr_list(struct ice_hw *hw, u16 vsi_handle,
 		return ICE_ERR_PARAM;
 
 	list_for_each_entry(fm_entry, lkup_list_head, list_entry) {
-		struct ice_fltr_info *fi;
-
-		fi = &fm_entry->fltr_info;
-		if (!fi || !ice_vsi_uses_fltr(fm_entry, vsi_handle))
+		if (!ice_vsi_uses_fltr(fm_entry, vsi_handle))
 			continue;
 
 		status = ice_add_entry_to_vsi_fltr_list(hw, vsi_handle,
-							vsi_list_head, fi);
+							vsi_list_head,
+							&fm_entry->fltr_info);
 		if (status)
 			return status;
 	}
-- 
2.26.2

