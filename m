Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE50634D8EE
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhC2USB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:18:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:19968 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231664AbhC2UR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:17:28 -0400
IronPort-SDR: em19HDFrEIlsn/JfgPoWa2BuQCyUbjbcOhkVMw0TMdLaQTRzDj6yoi6AltJoQKZoK0wnZwRIgg
 s/GweNsF1NIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="179160823"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="179160823"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 13:17:26 -0700
IronPort-SDR: l11iRXKLOkn5NCMtfbMJzCPGSi0Uvx2QCezW9kODXA1UJwHLepa7SUaeMsupRKArCPkRajTOMW
 XTov7fQgYTqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="454700554"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2021 13:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 8/9] ice: Use port number instead of PF ID for WoL
Date:   Mon, 29 Mar 2021 13:18:56 -0700
Message-Id: <20210329201857.3509461-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
References: <20210329201857.3509461-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

As per the spec, the WoL control word read from the NVM should be
interpreted as port numbers, and not PF numbers. So when checking
if WoL supported, use the port number instead of the PF ID.

Also, ice_is_wol_supported doesn't really need a pointer to the pf
struct, but just needs a pointer to the hw instance.

Fixes: 769c500dcc1e ("ice: Add advanced power mgmt for WoL")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         | 2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c    | 9 ++++-----
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 7934f0d17277..17101c45cbcd 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -623,7 +623,7 @@ int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
 const char *ice_stat_str(enum ice_status stat_err);
 const char *ice_aq_str(enum ice_aq_err aq_err);
-bool ice_is_wol_supported(struct ice_pf *pf);
+bool ice_is_wol_supported(struct ice_hw *hw);
 int
 ice_fdir_write_fltr(struct ice_pf *pf, struct ice_fdir_fltr *input, bool add,
 		    bool is_tun);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 2dcfa685b763..32ba71a16165 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3472,7 +3472,7 @@ static void ice_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 		netdev_warn(netdev, "Wake on LAN is not supported on this interface!\n");
 
 	/* Get WoL settings based on the HW capability */
-	if (ice_is_wol_supported(pf)) {
+	if (ice_is_wol_supported(&pf->hw)) {
 		wol->supported = WAKE_MAGIC;
 		wol->wolopts = pf->wol_ena ? WAKE_MAGIC : 0;
 	} else {
@@ -3492,7 +3492,7 @@ static int ice_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 
-	if (vsi->type != ICE_VSI_PF || !ice_is_wol_supported(pf))
+	if (vsi->type != ICE_VSI_PF || !ice_is_wol_supported(&pf->hw))
 		return -EOPNOTSUPP;
 
 	/* only magic packet is supported */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 255a07c1e33a..9f1adff85be7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3537,15 +3537,14 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
 }
 
 /**
- * ice_is_wol_supported - get NVM state of WoL
- * @pf: board private structure
+ * ice_is_wol_supported - check if WoL is supported
+ * @hw: pointer to hardware info
  *
  * Check if WoL is supported based on the HW configuration.
  * Returns true if NVM supports and enables WoL for this port, false otherwise
  */
-bool ice_is_wol_supported(struct ice_pf *pf)
+bool ice_is_wol_supported(struct ice_hw *hw)
 {
-	struct ice_hw *hw = &pf->hw;
 	u16 wol_ctrl;
 
 	/* A bit set to 1 in the NVM Software Reserved Word 2 (WoL control
@@ -3554,7 +3553,7 @@ bool ice_is_wol_supported(struct ice_pf *pf)
 	if (ice_read_sr_word(hw, ICE_SR_NVM_WOL_CFG, &wol_ctrl))
 		return false;
 
-	return !(BIT(hw->pf_id) & wol_ctrl);
+	return !(BIT(hw->port_info->lport) & wol_ctrl);
 }
 
 /**
-- 
2.26.2

