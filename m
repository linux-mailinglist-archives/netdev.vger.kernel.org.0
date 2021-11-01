Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407F5441F9B
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhKARzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:55:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:15547 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231557AbhKARzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 13:55:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="294530078"
X-IronPort-AV: E=Sophos;i="5.87,200,1631602800"; 
   d="scan'208";a="294530078"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 10:52:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,200,1631602800"; 
   d="scan'208";a="500138963"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 01 Nov 2021 10:52:36 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 3/5] ice: Fix replacing VF hardware MAC to existing MAC filter
Date:   Mon,  1 Nov 2021 10:50:58 -0700
Message-Id: <20211101175100.216963-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101175100.216963-1-anthony.l.nguyen@intel.com>
References: <20211101175100.216963-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

VF was not able to change its hardware MAC address in case
the new address was already present in the MAC filter list.
Change the handling of VF add mac request to not return
if requested MAC address is already present on the list
and check if its hardware MAC needs to be updated in this case.

Fixes: ed4c068d46f6 ("ice: Enable ip link show on the PF to display VF unicast MAC(s)")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index d567ff47f690..83b385380d8d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3744,6 +3744,7 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
 	struct device *dev = ice_pf_to_dev(vf->pf);
 	u8 *mac_addr = vc_ether_addr->addr;
 	enum ice_status status;
+	int ret = 0;
 
 	/* device MAC already added */
 	if (ether_addr_equal(mac_addr, vf->dev_lan_addr.addr))
@@ -3756,20 +3757,23 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
 
 	status = ice_fltr_add_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
 	if (status == ICE_ERR_ALREADY_EXISTS) {
-		dev_err(dev, "MAC %pM already exists for VF %d\n", mac_addr,
+		dev_dbg(dev, "MAC %pM already exists for VF %d\n", mac_addr,
 			vf->vf_id);
-		return -EEXIST;
+		/* don't return since we might need to update
+		 * the primary MAC in ice_vfhw_mac_add() below
+		 */
+		ret = -EEXIST;
 	} else if (status) {
 		dev_err(dev, "Failed to add MAC %pM for VF %d\n, error %s\n",
 			mac_addr, vf->vf_id, ice_stat_str(status));
 		return -EIO;
+	} else {
+		vf->num_mac++;
 	}
 
 	ice_vfhw_mac_add(vf, vc_ether_addr);
 
-	vf->num_mac++;
-
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.31.1

