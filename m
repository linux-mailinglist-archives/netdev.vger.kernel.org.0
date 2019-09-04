Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0407EA79EB
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfIDEfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:26525 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfIDEfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804419"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/15] ice: Correctly handle return values for init DCB
Date:   Tue,  3 Sep 2019 21:35:08 -0700
Message-Id: <20190904043512.28066-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
References: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

In the init path for DCB, the call to ice_init_dcb()
can return a non-zero value for either an actual
error, or due to the FW lldp engine being stopped.

We are currently treating all non-zero values only as
an indication that the FW LLDP engine is stopped.

Check for an actual error in the DCB init flow.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 4614ec95529b..021e2e81d731 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -452,14 +452,18 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 	port_info = hw->port_info;
 
 	err = ice_init_dcb(hw);
+	if (err && !port_info->is_sw_lldp) {
+		dev_err(&pf->pdev->dev, "Error initializing DCB %d\n", err);
+		goto dcb_init_err;
+	}
+
+	dev_info(&pf->pdev->dev,
+		 "DCB is enabled in the hardware, max number of TCs supported on this port are %d\n",
+		 pf->hw.func_caps.common_cap.maxtc);
 	if (err) {
 		/* FW LLDP is disabled, activate SW DCBX/LLDP mode */
-		dev_info(&pf->pdev->dev,
-			 "DCB is enabled in the hardware, max number of TCs supported on this port are %d\n",
-			 pf->hw.func_caps.common_cap.maxtc);
 		dev_info(&pf->pdev->dev,
 			 "FW LLDP is disabled, DCBx/LLDP in SW mode.\n");
-		port_info->is_sw_lldp = true;
 		clear_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags);
 		err = ice_dcb_sw_dflt_cfg(pf, locked);
 		if (err) {
@@ -475,7 +479,6 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 		return 0;
 	}
 
-	port_info->is_sw_lldp = false;
 	set_bit(ICE_FLAG_FW_LLDP_AGENT, pf->flags);
 
 	/* DCBX in FW and LLDP enabled in FW */
@@ -487,10 +490,6 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 	if (err)
 		goto dcb_init_err;
 
-	dev_info(&pf->pdev->dev,
-		 "DCB is enabled in the hardware, max number of TCs supported on this port are %d\n",
-		 pf->hw.func_caps.common_cap.maxtc);
-	dev_info(&pf->pdev->dev, "DCBX offload supported\n");
 	return err;
 
 dcb_init_err:
-- 
2.21.0

