Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADED0441F9C
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhKARzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:55:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:15544 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230261AbhKARzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 13:55:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="294530077"
X-IronPort-AV: E=Sophos;i="5.87,200,1631602800"; 
   d="scan'208";a="294530077"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 10:52:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,200,1631602800"; 
   d="scan'208";a="500138960"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 01 Nov 2021 10:52:36 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 2/5] ice: Remove toggling of antispoof for VF trusted promiscuous mode
Date:   Mon,  1 Nov 2021 10:50:57 -0700
Message-Id: <20211101175100.216963-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101175100.216963-1-anthony.l.nguyen@intel.com>
References: <20211101175100.216963-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently when a trusted VF enables promiscuous mode spoofchk will be
disabled. This is wrong and should only be modified from the
ndo_set_vf_spoofchk callback. Fix this by removing the call to toggle
spoofchk for trusted VFs.

Fixes: 01b5e89aab49 ("ice: Add VF promiscuous support")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c   | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 92f14d68cc97..d567ff47f690 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2996,24 +2996,6 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 	rm_promisc = !allmulti && !alluni;
 
 	if (vsi->num_vlan || vf->port_vlan_info) {
-		struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
-		struct net_device *pf_netdev;
-
-		if (!pf_vsi) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		pf_netdev = pf_vsi->netdev;
-
-		ret = ice_set_vf_spoofchk(pf_netdev, vf->vf_id, rm_promisc);
-		if (ret) {
-			dev_err(dev, "Failed to update spoofchk to %s for VF %d VSI %d when setting promiscuous mode\n",
-				rm_promisc ? "ON" : "OFF", vf->vf_id,
-				vsi->vsi_num);
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		}
-
 		ret = ice_cfg_vlan_pruning(vsi, true, !rm_promisc);
 		if (ret) {
 			dev_err(dev, "Failed to configure VLAN pruning in promiscuous mode\n");
-- 
2.31.1

