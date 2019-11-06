Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACDCF0B3D
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 01:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbfKFAqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 19:46:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:56517 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbfKFAq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 19:46:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 16:46:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="403554772"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 05 Nov 2019 16:46:25 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] ice: Rename VF function ice_vc_dis_vf to match its behavior
Date:   Tue,  5 Nov 2019 16:46:19 -0800
Message-Id: <20191106004620.10416-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191106004620.10416-1-jeffrey.t.kirsher@intel.com>
References: <20191106004620.10416-1-jeffrey.t.kirsher@intel.com>
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
index 7289a3726ae8..74351ddeb307 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1502,12 +1502,10 @@ void ice_process_vflr_event(struct ice_pf *pf)
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
@@ -2547,7 +2545,7 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
 	} else {
 		/* request is successful, then reset VF */
 		vf->num_req_qs = req_queues;
-		ice_vc_dis_vf(vf);
+		ice_vc_reset_vf(vf);
 		dev_info(&pf->pdev->dev,
 			 "VF %d granted request of %u queues.\n",
 			 vf->vf_id, req_queues);
@@ -3174,7 +3172,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		    "MAC on VF %d set to %pM. VF driver will be reinitialized\n",
 		    vf_id, mac);
 
-	ice_vc_dis_vf(vf);
+	ice_vc_reset_vf(vf);
 	return ret;
 }
 
@@ -3210,7 +3208,7 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 		return 0;
 
 	vf->trusted = trusted;
-	ice_vc_dis_vf(vf);
+	ice_vc_reset_vf(vf);
 	dev_info(&pf->pdev->dev, "VF %u is now %strusted\n",
 		 vf_id, trusted ? "" : "un");
 
-- 
2.21.0

