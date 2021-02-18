Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A90C31F305
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 00:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBRXZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 18:25:36 -0500
Received: from mga12.intel.com ([192.55.52.136]:20118 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230100AbhBRXZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 18:25:32 -0500
IronPort-SDR: R0rvcIRvIW9VtXZZkmoukmIpXsoD/f5cpjcne+gFDB2D/+mHCZDsoymR9Je+wPT4Hg4Bvzgydz
 ftKMJ4R9OeYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9899"; a="162823069"
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="162823069"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 15:24:08 -0800
IronPort-SDR: DYh1IC7rb6HY1j+uiPQdAebuLHeUGwwgtEMgCguE/G92XQrsp05YMttZgBSl65EXOvznsD/rPg
 YK6D4kFRNMVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="581457640"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 18 Feb 2021 15:24:08 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Dawid Lukwinski <dawid.lukwinski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 4/8] i40e: Fix overwriting flow control settings during driver loading
Date:   Thu, 18 Feb 2021 15:25:00 -0800
Message-Id: <20210218232504.2422834-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
References: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

During driver loading flow control settings were written to FW
using a variable which was always zero, since it was being set
only by ethtool. This behavior has been corrected and driver
no longer overwrites the default FW/NVM settings.

Fixes: 373149fc99a0 ("i40e: Decrease the scope of rtnl lock")
Signed-off-by: Dawid Lukwinski <dawid.lukwinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 27 ---------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 90c6c991aebc..53efb3a53df2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10005,7 +10005,6 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	int old_recovery_mode_bit = test_bit(__I40E_RECOVERY_MODE, pf->state);
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	struct i40e_hw *hw = &pf->hw;
-	u8 set_fc_aq_fail = 0;
 	i40e_status ret;
 	u32 val;
 	int v;
@@ -10131,13 +10130,6 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 			 i40e_stat_str(&pf->hw, ret),
 			 i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
 
-	/* make sure our flow control settings are restored */
-	ret = i40e_set_fc(&pf->hw, &set_fc_aq_fail, true);
-	if (ret)
-		dev_dbg(&pf->pdev->dev, "setting flow control: ret = %s last_status = %s\n",
-			i40e_stat_str(&pf->hw, ret),
-			i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
-
 	/* Rebuild the VSIs and VEBs that existed before reset.
 	 * They are still in our local switch element arrays, so only
 	 * need to rebuild the switch model in the HW.
@@ -14720,7 +14712,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int err;
 	u32 val;
 	u32 i;
-	u8 set_fc_aq_fail;
 
 	err = pci_enable_device_mem(pdev);
 	if (err)
@@ -15054,24 +15045,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	INIT_LIST_HEAD(&pf->vsi[pf->lan_vsi]->ch_list);
 
-	/* Make sure flow control is set according to current settings */
-	err = i40e_set_fc(hw, &set_fc_aq_fail, true);
-	if (set_fc_aq_fail & I40E_SET_FC_AQ_FAIL_GET)
-		dev_dbg(&pf->pdev->dev,
-			"Set fc with err %s aq_err %s on get_phy_cap\n",
-			i40e_stat_str(hw, err),
-			i40e_aq_str(hw, hw->aq.asq_last_status));
-	if (set_fc_aq_fail & I40E_SET_FC_AQ_FAIL_SET)
-		dev_dbg(&pf->pdev->dev,
-			"Set fc with err %s aq_err %s on set_phy_config\n",
-			i40e_stat_str(hw, err),
-			i40e_aq_str(hw, hw->aq.asq_last_status));
-	if (set_fc_aq_fail & I40E_SET_FC_AQ_FAIL_UPDATE)
-		dev_dbg(&pf->pdev->dev,
-			"Set fc with err %s aq_err %s on get_link_info\n",
-			i40e_stat_str(hw, err),
-			i40e_aq_str(hw, hw->aq.asq_last_status));
-
 	/* if FDIR VSI was set up, start it now */
 	for (i = 0; i < pf->num_alloc_vsi; i++) {
 		if (pf->vsi[i] && pf->vsi[i]->type == I40E_VSI_FDIR) {
-- 
2.26.2

