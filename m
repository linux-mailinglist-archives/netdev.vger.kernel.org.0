Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF523768F5
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 18:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbhEGQlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 12:41:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:29740 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238330AbhEGQk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 12:40:57 -0400
IronPort-SDR: jXNzR1QeDw2dosQzRExbH4zlY8vg9taglSN9b6KRvPVTmKmlXZ7tbypgXnqmU0z168rFfF7CMD
 tnTIcIaDX5FA==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="196748703"
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="196748703"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 09:39:55 -0700
IronPort-SDR: sRwitwAkbQ+2GyVNivLyGzOTonQAzrqTbgjezLHghGnr+Y152VQhtQQWe8LSFYbFgppS+5hEdl
 NdCisnYt/XXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="620267982"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2021 09:39:55 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Subject: [PATCH net 5/5] i40e: Remove LLDP frame filters
Date:   Fri,  7 May 2021 09:41:51 -0700
Message-Id: <20210507164151.2878147-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
References: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Remove filters from being setup in case of software DCB and allow the
LLDP frames to be properly transmitted to the wire.

It is not possible to transmit the LLDP frame out of the port, if they
are filtered by control VSI. This prohibits software LLDP agent
properly communicate its DCB capabilities to the neighbors.

Fixes: 4b208eaa8078 ("i40e: Add init and default config of software based DCB")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |  1 -
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  1 -
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 42 -------------------
 3 files changed, 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 9067cd3ce243..85d3dd3a3339 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1144,7 +1144,6 @@ static inline bool i40e_is_sw_dcb(struct i40e_pf *pf)
 	return !!(pf->flags & I40E_FLAG_DISABLE_FW_LLDP);
 }
 
-void i40e_set_lldp_forwarding(struct i40e_pf *pf, bool enable);
 #ifdef CONFIG_I40E_DCB
 void i40e_dcbnl_flush_apps(struct i40e_pf *pf,
 			   struct i40e_dcbx_config *old_cfg,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index bd527eab002b..ccd5b9486ea9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5282,7 +5282,6 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 			i40e_aq_cfg_lldp_mib_change_event(&pf->hw, false, NULL);
 			i40e_aq_stop_lldp(&pf->hw, true, false, NULL);
 		} else {
-			i40e_set_lldp_forwarding(pf, false);
 			status = i40e_aq_start_lldp(&pf->hw, false, NULL);
 			if (status) {
 				adq_err = pf->hw.aq.asq_last_status;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c2d145a56b5e..704e474879c5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6879,40 +6879,6 @@ static int i40e_init_pf_dcb(struct i40e_pf *pf)
 }
 #endif /* CONFIG_I40E_DCB */
 
-/**
- * i40e_set_lldp_forwarding - set forwarding of lldp frames
- * @pf: PF being configured
- * @enable: if forwarding to OS shall be enabled
- *
- * Toggle forwarding of lldp frames behavior,
- * When passing DCB control from firmware to software
- * lldp frames must be forwarded to the software based
- * lldp agent.
- */
-void i40e_set_lldp_forwarding(struct i40e_pf *pf, bool enable)
-{
-	if (pf->lan_vsi == I40E_NO_VSI)
-		return;
-
-	if (!pf->vsi[pf->lan_vsi])
-		return;
-
-	/* No need to check the outcome, commands may fail
-	 * if desired value is already set
-	 */
-	i40e_aq_add_rem_control_packet_filter(&pf->hw, NULL, ETH_P_LLDP,
-					      I40E_AQC_ADD_CONTROL_PACKET_FLAGS_TX |
-					      I40E_AQC_ADD_CONTROL_PACKET_FLAGS_IGNORE_MAC,
-					      pf->vsi[pf->lan_vsi]->seid, 0,
-					      enable, NULL, NULL);
-
-	i40e_aq_add_rem_control_packet_filter(&pf->hw, NULL, ETH_P_LLDP,
-					      I40E_AQC_ADD_CONTROL_PACKET_FLAGS_RX |
-					      I40E_AQC_ADD_CONTROL_PACKET_FLAGS_IGNORE_MAC,
-					      pf->vsi[pf->lan_vsi]->seid, 0,
-					      enable, NULL, NULL);
-}
-
 /**
  * i40e_print_link_message - print link up or down
  * @vsi: the VSI for which link needs a message
@@ -10736,10 +10702,6 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	 */
 	i40e_add_filter_to_drop_tx_flow_control_frames(&pf->hw,
 						       pf->main_vsi_seid);
-#ifdef CONFIG_I40E_DCB
-	if (pf->flags & I40E_FLAG_DISABLE_FW_LLDP)
-		i40e_set_lldp_forwarding(pf, true);
-#endif /* CONFIG_I40E_DCB */
 
 	/* restart the VSIs that were rebuilt and running before the reset */
 	i40e_pf_unquiesce_all_vsi(pf);
@@ -15772,10 +15734,6 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	i40e_add_filter_to_drop_tx_flow_control_frames(&pf->hw,
 						       pf->main_vsi_seid);
-#ifdef CONFIG_I40E_DCB
-	if (pf->flags & I40E_FLAG_DISABLE_FW_LLDP)
-		i40e_set_lldp_forwarding(pf, true);
-#endif /* CONFIG_I40E_DCB */
 
 	if ((pf->hw.device_id == I40E_DEV_ID_10G_BASE_T) ||
 		(pf->hw.device_id == I40E_DEV_ID_10G_BASE_T4))
-- 
2.26.2

