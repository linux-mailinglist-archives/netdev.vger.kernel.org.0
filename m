Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B03832005B
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 22:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBSVgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 16:36:31 -0500
Received: from mga07.intel.com ([134.134.136.100]:25147 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229802AbhBSVgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 16:36:22 -0500
IronPort-SDR: C/TgkpbUSQrozwnCVvdcCyxfMicUobmG0mOfzFEKjedxqU98nTkKWba24VmoVRTSL4Erai/mgF
 4rLdMHQjtRwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9900"; a="248034136"
X-IronPort-AV: E=Sophos;i="5.81,191,1610438400"; 
   d="scan'208";a="248034136"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 13:35:06 -0800
IronPort-SDR: 5KiUaeQuRsg7dD8d4Agt6hjvtRJupeHlKq+CeixVIY6tBIFEmCQ05UPRtP4dcD74hajaLzfjcu
 AaPKaMGiaRDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,191,1610438400"; 
   d="scan'208";a="428012033"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Feb 2021 13:35:06 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net v2 5/8] i40e: Fix addition of RX filters after enabling FW LLDP agent
Date:   Fri, 19 Feb 2021 13:36:03 -0800
Message-Id: <20210219213606.2567536-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
References: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Fix addition of VLAN filter for PF after enabling FW LLDP agent.
Changing LLDP Agent causes FW to re-initialize per NVM settings.
Remove default PF filter and move "Enable/Disable" to currently used
reset flag.
Without this patch PF would try to add MAC VLAN filter with default
switch filter present. This causes AQ error and sets promiscuous mode
on.

Fixes: c65e78f87f81 ("i40e: Further implementation of LLDP")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 16 +++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_main.c    |  9 ++++-----
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 26ba1f3eb2d8..9e81f85ee2d8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4878,7 +4878,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 	enum i40e_admin_queue_err adq_err;
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
-	bool is_reset_needed;
+	u32 reset_needed = 0;
 	i40e_status status;
 	u32 i, j;
 
@@ -4923,9 +4923,11 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 flags_complete:
 	changed_flags = orig_flags ^ new_flags;
 
-	is_reset_needed = !!(changed_flags & (I40E_FLAG_VEB_STATS_ENABLED |
-		I40E_FLAG_LEGACY_RX | I40E_FLAG_SOURCE_PRUNING_DISABLED |
-		I40E_FLAG_DISABLE_FW_LLDP));
+	if (changed_flags & I40E_FLAG_DISABLE_FW_LLDP)
+		reset_needed = I40E_PF_RESET_AND_REBUILD_FLAG;
+	if (changed_flags & (I40E_FLAG_VEB_STATS_ENABLED |
+	    I40E_FLAG_LEGACY_RX | I40E_FLAG_SOURCE_PRUNING_DISABLED))
+		reset_needed = BIT(__I40E_PF_RESET_REQUESTED);
 
 	/* Before we finalize any flag changes, we need to perform some
 	 * checks to ensure that the changes are supported and safe.
@@ -5057,7 +5059,7 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 				case I40E_AQ_RC_EEXIST:
 					dev_warn(&pf->pdev->dev,
 						 "FW LLDP agent is already running\n");
-					is_reset_needed = false;
+					reset_needed = 0;
 					break;
 				case I40E_AQ_RC_EPERM:
 					dev_warn(&pf->pdev->dev,
@@ -5086,8 +5088,8 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 	/* Issue reset to cause things to take effect, as additional bits
 	 * are added we will need to create a mask of bits requiring reset
 	 */
-	if (is_reset_needed)
-		i40e_do_reset(pf, BIT(__I40E_PF_RESET_REQUESTED), true);
+	if (reset_needed)
+		i40e_do_reset(pf, reset_needed, true);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 53efb3a53df2..3505d641660b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8537,11 +8537,6 @@ void i40e_do_reset(struct i40e_pf *pf, u32 reset_flags, bool lock_acquired)
 		dev_dbg(&pf->pdev->dev, "PFR requested\n");
 		i40e_handle_reset_warning(pf, lock_acquired);
 
-		dev_info(&pf->pdev->dev,
-			 pf->flags & I40E_FLAG_DISABLE_FW_LLDP ?
-			 "FW LLDP is disabled\n" :
-			 "FW LLDP is enabled\n");
-
 	} else if (reset_flags & I40E_PF_RESET_AND_REBUILD_FLAG) {
 		/* Request a PF Reset
 		 *
@@ -8549,6 +8544,10 @@ void i40e_do_reset(struct i40e_pf *pf, u32 reset_flags, bool lock_acquired)
 		 */
 		i40e_prep_for_reset(pf, lock_acquired);
 		i40e_reset_and_rebuild(pf, true, lock_acquired);
+		dev_info(&pf->pdev->dev,
+			 pf->flags & I40E_FLAG_DISABLE_FW_LLDP ?
+			 "FW LLDP is disabled\n" :
+			 "FW LLDP is enabled\n");
 
 	} else if (reset_flags & BIT_ULL(__I40E_REINIT_REQUESTED)) {
 		int v;
-- 
2.26.2

