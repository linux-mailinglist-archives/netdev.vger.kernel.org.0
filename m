Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB862F1F13
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732523AbfKFTiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:38:08 -0500
Received: from mga04.intel.com ([192.55.52.120]:25889 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732411AbfKFTiC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 14:38:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 11:38:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="402473315"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2019 11:38:02 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 13/14] ice: Rename VF function ice_vc_dis_vf to match its behavior
Date:   Wed,  6 Nov 2019 11:37:55 -0800
Message-Id: <20191106193756.23819-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
References: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

ice_vc_dis_vf() tells iavf that it's going to perform a reset
and then performs a software reset. This is misleading based on
the function name because the VF does not get disabled. So fix
this by changing the name to ice_vc_reset_vf().

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 3d8c231b0614..7ef2cc739587 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1496,12 +1496,10 @@ void ice_process_vflr_event(struct ice_pf *pf)
 }
 
 /**
- * ice_vc_dis_vf - Disable a given VF via SW reset
+ * ice_vc_reset_vf - Perform software reset on the VF after informing the AVF
  * @vf: pointer to the VF info
- *
- * Disable the VF through a SW reset
  */
-static void ice_vc_dis_vf(struct ice_vf *vf)
+static void ice_vc_reset_vf(struct ice_vf *vf)
 {
 	ice_vc_notify_vf_reset(vf);
 	ice_reset_vf(vf, false);
@@ -2541,7 +2539,7 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 	} else {
 		/* request is successful, then reset VF */
 		vf->num_req_qs = req_queues;
-		ice_vc_dis_vf(vf);
+		ice_vc_reset_vf(vf);
 		dev_info(&pf->pdev->dev,
 			 "VF %d granted request of %u queues.\n",
 			 vf->vf_id, req_queues);
@@ -3168,7 +3166,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		    "MAC on VF %d set to %pM. VF driver will be reinitialized\n",
 		    vf_id, mac);
 
-	ice_vc_dis_vf(vf);
+	ice_vc_reset_vf(vf);
 	return ret;
 }
 
@@ -3204,7 +3202,7 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 		return 0;
 
 	vf->trusted = trusted;
-	ice_vc_dis_vf(vf);
+	ice_vc_reset_vf(vf);
 	dev_info(&pf->pdev->dev, "VF %u is now %strusted\n",
 		 vf_id, trusted ? "" : "un");
 
-- 
2.21.0

