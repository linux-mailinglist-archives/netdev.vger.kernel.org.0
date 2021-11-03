Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07E444460F
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhKCQlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:41:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:30954 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232851AbhKCQlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:41:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="255168200"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="255168200"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 09:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="497645556"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 03 Nov 2021 09:21:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net v2 2/5] ice: Remove toggling of antispoof for VF trusted promiscuous mode
Date:   Wed,  3 Nov 2021 09:19:32 -0700
Message-Id: <20211103161935.2997369-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
References: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
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
index 9b699419c933..3f8f94732a1f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3055,24 +3055,6 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
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
 		if (rm_promisc)
 			ret = ice_cfg_vlan_pruning(vsi, true);
 		else
-- 
2.31.1

