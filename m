Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090C634D8F4
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbhC2USP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:18:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:19969 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230395AbhC2UR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:17:28 -0400
IronPort-SDR: n8d5kmK2CWNukvTvNCF1hnaMLVxHvspLhugBGGZItPCttroccgnWhWjYbneZpRBXlWCA+xW2FO
 /jjSPPyB950A==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179160824"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="179160824"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 13:17:26 -0700
IronPort-SDR: FcOSmDQjqUUUnSZ9Iad4oXkBIZUFg6ojhzhNFsDpINkMzGHKRJanLo9N3vl5IM1dWd1BCnZ6qJ
 Lk5ds/cz5QVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="454700556"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2021 13:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Robert Malz <robertx.malz@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 9/9] ice: Cleanup fltr list in case of allocation issues
Date:   Mon, 29 Mar 2021 13:18:57 -0700
Message-Id: <20210329201857.3509461-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
References: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Malz <robertx.malz@intel.com>

When ice_remove_vsi_lkup_fltr is called, by calling
ice_add_to_vsi_fltr_list local copy of vsi filter list
is created. If any issues during creation of vsi filter
list occurs it up for the caller to free already
allocated memory. This patch ensures proper memory
deallocation in these cases.

Fixes: 80d144c9ac82 ("ice: Refactor switch rule management structures and functions")
Signed-off-by: Robert Malz <robertx.malz@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 387d3f6cd71e..834cbd3f7b31 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2624,7 +2624,7 @@ ice_remove_vsi_lkup_fltr(struct ice_hw *hw, u16 vsi_handle,
 					  &remove_list_head);
 	mutex_unlock(rule_lock);
 	if (status)
-		return;
+		goto free_fltr_list;
 
 	switch (lkup) {
 	case ICE_SW_LKUP_MAC:
@@ -2647,6 +2647,7 @@ ice_remove_vsi_lkup_fltr(struct ice_hw *hw, u16 vsi_handle,
 		break;
 	}
 
+free_fltr_list:
 	list_for_each_entry_safe(fm_entry, tmp, &remove_list_head, list_entry) {
 		list_del(&fm_entry->list_entry);
 		devm_kfree(ice_hw_to_dev(hw), fm_entry);
-- 
2.26.2

