Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD749B8F0
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfHWXhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:37:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:14901 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbfHWXhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:37:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 16:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="184354411"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2019 16:37:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/14] ice: Account for all states of FW DCBx and LLDP
Date:   Fri, 23 Aug 2019 16:37:38 -0700
Message-Id: <20190823233750.7997-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Currently, only the DCBx status is taken into account to
determine if FW LLDP is possible.  But there are NVM version
coming out with DCBx enabled, and FW LLDP disabled.  This
is causing errors where the driver sees that DCBx is not
disabled, and then tries to register for LLDP MIB change
events, and fails.

Change the logic to detect both DCBx and LLDP states in the
FW engine.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 34 +++++++-------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index bf6cd4760a48..22bdc244c7e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -319,6 +319,11 @@ void ice_dcb_rebuild(struct ice_pf *pf)
 	}
 
 	ice_init_dcb(&pf->hw);
+	if (pf->hw.port_info->dcbx_status == ICE_DCBX_STATUS_DIS)
+		pf->hw.port_info->is_sw_lldp = true;
+	else
+		pf->hw.port_info->is_sw_lldp = false;
+
 	if (ice_dcb_need_recfg(pf, prev_cfg, local_dcbx_cfg)) {
 		/* difference in cfg detected - disable DCB till next MIB */
 		dev_err(&pf->pdev->dev, "Set local MIB not accurate\n");
@@ -440,35 +445,17 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 	struct device *dev = &pf->pdev->dev;
 	struct ice_port_info *port_info;
 	struct ice_hw *hw = &pf->hw;
-	int sw_default = 0;
 	int err;
 
 	port_info = hw->port_info;
 
 	err = ice_init_dcb(hw);
 	if (err) {
-		/* FW LLDP is not active, default to SW DCBX/LLDP */
-		dev_info(&pf->pdev->dev, "FW LLDP is not active\n");
-		hw->port_info->dcbx_status = ICE_DCBX_STATUS_NOT_STARTED;
-		hw->port_info->is_sw_lldp = true;
-	}
-
-	if (port_info->dcbx_status == ICE_DCBX_STATUS_DIS)
-		dev_info(&pf->pdev->dev, "DCBX disabled\n");
-
-	/* LLDP disabled in FW */
-	if (port_info->is_sw_lldp) {
-		sw_default = 1;
-		dev_info(&pf->pdev->dev, "DCBx/LLDP in SW mode.\n");
+		/* FW LLDP is disabled, activate SW DCBX/LLDP mode */
+		dev_info(&pf->pdev->dev,
+			 "FW LLDP is disabled, DCBx/LLDP in SW mode.\n");
+		port_info->is_sw_lldp = true;
 		clear_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags);
-	} else {
-		set_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags);
-	}
-
-	if (port_info->dcbx_status == ICE_DCBX_STATUS_NOT_STARTED)
-		dev_info(&pf->pdev->dev, "DCBX not started\n");
-
-	if (sw_default) {
 		err = ice_dcb_sw_dflt_cfg(pf, locked);
 		if (err) {
 			dev_err(&pf->pdev->dev,
@@ -483,6 +470,9 @@ int ice_init_pf_dcb(struct ice_pf *pf, bool locked)
 		return 0;
 	}
 
+	port_info->is_sw_lldp = false;
+	set_bit(ICE_FLAG_ENABLE_FW_LLDP, pf->flags);
+
 	/* DCBX in FW and LLDP enabled in FW */
 	pf->dcbx_cap = DCB_CAP_DCBX_LLD_MANAGED | DCB_CAP_DCBX_VER_IEEE;
 
-- 
2.21.0

