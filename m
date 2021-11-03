Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C73E4445D0
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhKCQXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:23:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:20327 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231876AbhKCQXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:23:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="230256985"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="230256985"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 09:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="497645561"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 03 Nov 2021 09:21:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net v2 3/5] ice: Fix replacing VF hardware MAC to existing MAC filter
Date:   Wed,  3 Nov 2021 09:19:33 -0700
Message-Id: <20211103161935.2997369-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
References: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
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
index 3f8f94732a1f..650ad7f56829 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3806,6 +3806,7 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
 	struct device *dev = ice_pf_to_dev(vf->pf);
 	u8 *mac_addr = vc_ether_addr->addr;
 	enum ice_status status;
+	int ret = 0;
 
 	/* device MAC already added */
 	if (ether_addr_equal(mac_addr, vf->dev_lan_addr.addr))
@@ -3818,20 +3819,23 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
 
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

