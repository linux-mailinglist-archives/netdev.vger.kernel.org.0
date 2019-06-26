Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC940571C5
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfFZTaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:30:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:41408 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbfFZTag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:30:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 12:30:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,420,1557212400"; 
   d="scan'208";a="188762479"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2019 12:30:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/10] i40e: missing priorities for any QoS traffic
Date:   Wed, 26 Jun 2019 12:31:00 -0700
Message-Id: <20190626193103.2169-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
References: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

This patch fixes reading f/w LLDP agent status at DCB init time.
It's done by removing direct NVM reading in i40e_update_dcb_config()
and checking whether f/w LLDP agent is disabled via
I40E_FLAG_DISABLE_FW_LLDP flag in i40e_init_pf_dcb(). The function
i40e_update_dcb_config() in i40e_main.c is a temporary solution which
will be later renamed to i40e_init_dcb() in the i40e_dcb module. Also
logging was extended to make visible if f/w LLDP agent is running or not
and always log a message when DCB was not initialized. Without this
patch for new f/w versions f/w LLDP agent status was always read
from NVM as disabled and DCB initialization failed without
clear reason in logs.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 57 +++++++++++++++++++--
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index eee4dbf40fec..6a10f9f9479c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6409,6 +6409,50 @@ static int i40e_resume_port_tx(struct i40e_pf *pf)
 	return ret;
 }
 
+/**
+ * i40e_update_dcb_config
+ * @hw: pointer to the HW struct
+ * @enable_mib_change: enable MIB change event
+ *
+ * Update DCB configuration from the firmware
+ **/
+static enum i40e_status_code
+i40e_update_dcb_config(struct i40e_hw *hw, bool enable_mib_change)
+{
+	struct i40e_lldp_variables lldp_cfg;
+	i40e_status ret;
+
+	if (!hw->func_caps.dcb)
+		return I40E_NOT_SUPPORTED;
+
+	/* Read LLDP NVM area */
+	ret = i40e_read_lldp_cfg(hw, &lldp_cfg);
+	if (ret)
+		return I40E_ERR_NOT_READY;
+
+	/* Get DCBX status */
+	ret = i40e_get_dcbx_status(hw, &hw->dcbx_status);
+	if (ret)
+		return ret;
+
+	/* Check the DCBX Status */
+	if (hw->dcbx_status == I40E_DCBX_STATUS_DONE ||
+	    hw->dcbx_status == I40E_DCBX_STATUS_IN_PROGRESS) {
+		/* Get current DCBX configuration */
+		ret = i40e_get_dcb_config(hw);
+		if (ret)
+			return ret;
+	} else if (hw->dcbx_status == I40E_DCBX_STATUS_DISABLED) {
+		return I40E_ERR_NOT_READY;
+	}
+
+	/* Configure the LLDP MIB change event */
+	if (enable_mib_change)
+		ret = i40e_aq_cfg_lldp_mib_change_event(hw, true, NULL);
+
+	return ret;
+}
+
 /**
  * i40e_init_pf_dcb - Initialize DCB configuration
  * @pf: PF being configured
@@ -6425,11 +6469,13 @@ static int i40e_init_pf_dcb(struct i40e_pf *pf)
 	 * Also do not enable DCBx if FW LLDP agent is disabled
 	 */
 	if ((pf->hw_features & I40E_HW_NO_DCB_SUPPORT) ||
-	    (pf->flags & I40E_FLAG_DISABLE_FW_LLDP))
+	    (pf->flags & I40E_FLAG_DISABLE_FW_LLDP)) {
+		dev_info(&pf->pdev->dev, "DCB is not supported or FW LLDP is disabled\n");
+		err = I40E_NOT_SUPPORTED;
 		goto out;
+	}
 
-	/* Get the initial DCB configuration */
-	err = i40e_init_dcb(hw, true);
+	err = i40e_update_dcb_config(hw, true);
 	if (!err) {
 		/* Device/Function is not DCBX capable */
 		if ((!hw->func_caps.dcb) ||
@@ -14401,6 +14447,11 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, pf);
 	pci_save_state(pdev);
 
+	dev_info(&pdev->dev,
+		 (pf->flags & I40E_FLAG_DISABLE_FW_LLDP) ?
+			"FW LLDP is disabled\n" :
+			"FW LLDP is enabled\n");
+
 	/* Enable FW to write default DCB config on link-up */
 	i40e_aq_set_dcb_parameters(hw, true, NULL);
 
-- 
2.21.0

