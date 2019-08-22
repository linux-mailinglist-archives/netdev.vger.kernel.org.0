Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5AE09A126
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404416AbfHVUau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:30:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:17467 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391170AbfHVUan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:30:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 13:30:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="169907287"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 22 Aug 2019 13:30:41 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Grzegorz Siwik <grzegorz.siwik@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 10/13] i40e: Remove function i40e_update_dcb_config()
Date:   Thu, 22 Aug 2019 13:30:36 -0700
Message-Id: <20190822203039.15668-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
References: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

This patch removes function i40e_update_dcb_config(). Instead of
i40e_update_dcb_config() we use i40e_init_dcb(), which implements the
correct NVM read.

Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 46 +--------------------
 1 file changed, 1 insertion(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5c280c025085..8d6b9515b595 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6419,50 +6419,6 @@ static int i40e_resume_port_tx(struct i40e_pf *pf)
 	return ret;
 }
 
-/**
- * i40e_update_dcb_config
- * @hw: pointer to the HW struct
- * @enable_mib_change: enable MIB change event
- *
- * Update DCB configuration from the firmware
- **/
-static enum i40e_status_code
-i40e_update_dcb_config(struct i40e_hw *hw, bool enable_mib_change)
-{
-	struct i40e_lldp_variables lldp_cfg;
-	i40e_status ret;
-
-	if (!hw->func_caps.dcb)
-		return I40E_NOT_SUPPORTED;
-
-	/* Read LLDP NVM area */
-	ret = i40e_read_lldp_cfg(hw, &lldp_cfg);
-	if (ret)
-		return I40E_ERR_NOT_READY;
-
-	/* Get DCBX status */
-	ret = i40e_get_dcbx_status(hw, &hw->dcbx_status);
-	if (ret)
-		return ret;
-
-	/* Check the DCBX Status */
-	if (hw->dcbx_status == I40E_DCBX_STATUS_DONE ||
-	    hw->dcbx_status == I40E_DCBX_STATUS_IN_PROGRESS) {
-		/* Get current DCBX configuration */
-		ret = i40e_get_dcb_config(hw);
-		if (ret)
-			return ret;
-	} else if (hw->dcbx_status == I40E_DCBX_STATUS_DISABLED) {
-		return I40E_ERR_NOT_READY;
-	}
-
-	/* Configure the LLDP MIB change event */
-	if (enable_mib_change)
-		ret = i40e_aq_cfg_lldp_mib_change_event(hw, true, NULL);
-
-	return ret;
-}
-
 /**
  * i40e_init_pf_dcb - Initialize DCB configuration
  * @pf: PF being configured
@@ -6485,7 +6441,7 @@ static int i40e_init_pf_dcb(struct i40e_pf *pf)
 		goto out;
 	}
 
-	err = i40e_update_dcb_config(hw, true);
+	err = i40e_init_dcb(hw, true);
 	if (!err) {
 		/* Device/Function is not DCBX capable */
 		if ((!hw->func_caps.dcb) ||
-- 
2.21.0

