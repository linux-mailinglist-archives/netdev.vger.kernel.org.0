Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CB446C76C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbhLGWaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:30:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:6596 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242155AbhLGWaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 17:30:18 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237508430"
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="237508430"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 14:26:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="605889079"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Dec 2021 14:26:46 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, kernel test robot <lkp@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 3/7] ice: Fix problems with DSCP QoS implementation
Date:   Tue,  7 Dec 2021 14:25:40 -0800
Message-Id: <20211207222544.977843-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
References: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The patch that implemented DSCP QoS implementation removed a
bandwidth check that was used to check for a specific condition
caused by some corner cases.  This check should not of been
removed.

The same patch also added a check for when the DCBx state could
be changed in relation to DSCP, but the check was erroneously
added nested in a check for CEE mode, which made the check useless.

Fix these problems by re-adding the bandwidth check and relocating
the DSCP mode check earlier in the function that changes DCBx state
in the driver.

Fixes: 2a87bd73e50d ("ice: Add DSCP support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
index 7fdeb411b6df..3eb01731e496 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -97,6 +97,9 @@ static int ice_dcbnl_setets(struct net_device *netdev, struct ieee_ets *ets)
 
 	new_cfg->etscfg.maxtcs = pf->hw.func_caps.common_cap.maxtc;
 
+	if (!bwcfg)
+		new_cfg->etscfg.tcbwtable[0] = 100;
+
 	if (!bwrec)
 		new_cfg->etsrec.tcbwtable[0] = 100;
 
@@ -167,15 +170,18 @@ static u8 ice_dcbnl_setdcbx(struct net_device *netdev, u8 mode)
 	if (mode == pf->dcbx_cap)
 		return ICE_DCB_NO_HW_CHG;
 
-	pf->dcbx_cap = mode;
 	qos_cfg = &pf->hw.port_info->qos_cfg;
-	if (mode & DCB_CAP_DCBX_VER_CEE) {
-		if (qos_cfg->local_dcbx_cfg.pfc_mode == ICE_QOS_MODE_DSCP)
-			return ICE_DCB_NO_HW_CHG;
+
+	/* DSCP configuration is not DCBx negotiated */
+	if (qos_cfg->local_dcbx_cfg.pfc_mode == ICE_QOS_MODE_DSCP)
+		return ICE_DCB_NO_HW_CHG;
+
+	pf->dcbx_cap = mode;
+
+	if (mode & DCB_CAP_DCBX_VER_CEE)
 		qos_cfg->local_dcbx_cfg.dcbx_mode = ICE_DCBX_MODE_CEE;
-	} else {
+	else
 		qos_cfg->local_dcbx_cfg.dcbx_mode = ICE_DCBX_MODE_IEEE;
-	}
 
 	dev_info(ice_pf_to_dev(pf), "DCBx mode = 0x%x\n", mode);
 	return ICE_DCB_HW_CHG_RST;
-- 
2.31.1

