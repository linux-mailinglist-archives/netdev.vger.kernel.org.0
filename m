Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D96C3D0538
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhGTWja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:39:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:50224 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233607AbhGTWhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:37:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211341481"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211341481"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="415407151"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2021 16:17:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 09/12] igc: Remove _I_PHY_ID checking
Date:   Tue, 20 Jul 2021 16:20:58 -0700
Message-Id: <20210720232101.3087589-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

i225 devices have only one PHY vendor. There is no point checking
_I_PHY_ID during the link establishment and auto-negotiation process.
This patch comes to clean up these pointless checkings.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 10 +---------
 drivers/net/ethernet/intel/igc/igc_main.c |  3 +--
 drivers/net/ethernet/intel/igc/igc_phy.c  |  6 ++----
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index d0700d48ecf9..84f142f5e472 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -187,15 +187,7 @@ static s32 igc_init_phy_params_base(struct igc_hw *hw)
 
 	igc_check_for_copper_link(hw);
 
-	/* Verify phy id and set remaining function pointers */
-	switch (phy->id) {
-	case I225_I_PHY_ID:
-		phy->type	= igc_phy_i225;
-		break;
-	default:
-		ret_val = -IGC_ERR_PHY;
-		goto out;
-	}
+	phy->type = igc_phy_i225;
 
 out:
 	return ret_val;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f7cf97916390..a5278a8f491f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5231,8 +5231,7 @@ bool igc_has_link(struct igc_adapter *adapter)
 		break;
 	}
 
-	if (hw->mac.type == igc_i225 &&
-	    hw->phy.id == I225_I_PHY_ID) {
+	if (hw->mac.type == igc_i225) {
 		if (!netif_carrier_ok(adapter->netdev)) {
 			adapter->flags &= ~IGC_FLAG_NEED_LINK_UPDATE;
 		} else if (!(adapter->flags & IGC_FLAG_NEED_LINK_UPDATE)) {
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 83aeb5e7076f..5cad31c3c7b0 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -249,8 +249,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 			return ret_val;
 	}
 
-	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
-	    hw->phy.id == I225_I_PHY_ID) {
+	if (phy->autoneg_mask & ADVERTISE_2500_FULL) {
 		/* Read the MULTI GBT AN Control Register - reg 7.32 */
 		ret_val = phy->ops.read_reg(hw, (STANDARD_AN_REG_MASK <<
 					    MMD_DEVADDR_SHIFT) |
@@ -390,8 +389,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 		ret_val = phy->ops.write_reg(hw, PHY_1000T_CTRL,
 					     mii_1000t_ctrl_reg);
 
-	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
-	    hw->phy.id == I225_I_PHY_ID)
+	if (phy->autoneg_mask & ADVERTISE_2500_FULL)
 		ret_val = phy->ops.write_reg(hw,
 					     (STANDARD_AN_REG_MASK <<
 					     MMD_DEVADDR_SHIFT) |
-- 
2.26.2

