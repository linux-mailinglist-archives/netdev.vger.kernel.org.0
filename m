Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E5F636546
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbiKWQFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238357AbiKWQFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:05:32 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F3C6E568
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 08:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669219531; x=1700755531;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vLMeN9NE/PRoKbgNDxOaVzGpXNGa9z26lr/tiY6bKg0=;
  b=VNzg70+NTXNUYopbq2m+4yGqXRJb0J5+jZsLyOjIq4oj3SpWyB4qIyWc
   dY82KCEGNu+s2dBCqMb5bbznZdugQojM/P6S/LFv+Ki9g8uiVATApApMv
   EFQ5cxqgwGmgb55sw7PAN9PrqJ4XqGgfnCkrpajZlIRj18orzGRHyrGDl
   v7XCHXu456IdcgG9/h2x80m4m5NQ+Gko4HmoZQ2yq6pWoRn9HNrVt769z
   H6Xudx+tc1Yr2yk+V1/Ew3sc1lWJpt5KAhocwz5KKG39owuF2f0vx15IT
   t8nObiCTRh8xI/A7xIJPN7lGDlzN7XiYkp6oUMXkVBsYerd6Rvp+uFGo1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315919709"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315919709"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 08:05:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674769524"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674769524"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 08:05:29 -0800
Received: from vecna.. (vecna.igk.intel.com [10.123.220.17])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANG5SoS003509;
        Wed, 23 Nov 2022 16:05:28 GMT
From:   Przemek Kitszel <przemyslaw.kitszel@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH net-next 1/2] ice: Add support for 100G KR2/CR2/SR2 link reporting
Date:   Wed, 23 Nov 2022 16:55:43 +0100
Message-Id: <20221123155544.1660952-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Commit 2736d94f351b ("ethtool: Added support for 50Gbps per lane link modes")
in v5.1 added (among other things) support for 100G CR2/KR2/SR2 link modes.
Advertise these link modes if the firmware reports the corresponding PHY types.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 42 +++++++++++++++-----
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index ba4ccc5f7d60..417efc401001 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1950,8 +1950,7 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 			   ICE_PHY_TYPE_LOW_100G_CAUI4 |
 			   ICE_PHY_TYPE_LOW_100G_AUI4_AOC_ACC |
 			   ICE_PHY_TYPE_LOW_100G_AUI4 |
-			   ICE_PHY_TYPE_LOW_100GBASE_CR_PAM4 |
-			   ICE_PHY_TYPE_LOW_100GBASE_CP2;
+			   ICE_PHY_TYPE_LOW_100GBASE_CR_PAM4;
 	phy_type_mask_hi = ICE_PHY_TYPE_HIGH_100G_CAUI2_AOC_ACC |
 			   ICE_PHY_TYPE_HIGH_100G_CAUI2 |
 			   ICE_PHY_TYPE_HIGH_100G_AUI2_AOC_ACC |
@@ -1964,15 +1963,28 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 						100000baseCR4_Full);
 	}
 
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_SR4 |
-			   ICE_PHY_TYPE_LOW_100GBASE_SR2;
-	if (phy_types_low & phy_type_mask_lo) {
+	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_CP2) {
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseCR2_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
+						100000baseCR2_Full);
+	}
+
+	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_SR4) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseSR4_Full);
 		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
 						100000baseSR4_Full);
 	}
 
+	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_SR2) {
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseSR2_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
+						100000baseSR2_Full);
+
+	}
+
 	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_LR4 |
 			   ICE_PHY_TYPE_LOW_100GBASE_DR;
 	if (phy_types_low & phy_type_mask_lo) {
@@ -1984,14 +1996,20 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 
 	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_KR4 |
 			   ICE_PHY_TYPE_LOW_100GBASE_KR_PAM4;
-	phy_type_mask_hi = ICE_PHY_TYPE_HIGH_100GBASE_KR2_PAM4;
-	if (phy_types_low & phy_type_mask_lo ||
-	    phy_types_high & phy_type_mask_hi) {
+	if (phy_types_low & phy_type_mask_lo) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseKR4_Full);
 		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
 						100000baseKR4_Full);
 	}
+
+	if (phy_types_high & ICE_PHY_TYPE_HIGH_100GBASE_KR2_PAM4) {
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseKR2_Full);
+		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
+						100000baseKR2_Full);
+	}
+
 }
 
 #define TEST_SET_BITS_TIMEOUT	50
@@ -2299,7 +2317,13 @@ ice_ksettings_find_adv_link_speed(const struct ethtool_link_ksettings *ks)
 	    ethtool_link_ksettings_test_link_mode(ks, advertising,
 						  100000baseLR4_ER4_Full) ||
 	    ethtool_link_ksettings_test_link_mode(ks, advertising,
-						  100000baseKR4_Full))
+						  100000baseKR4_Full) ||
+	    ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  100000baseCR2_Full) ||
+	    ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  100000baseSR2_Full) ||
+	    ethtool_link_ksettings_test_link_mode(ks, advertising,
+						  100000baseKR2_Full))
 		adv_link_speed |= ICE_AQ_LINK_SPEED_100GB;
 
 	return adv_link_speed;
-- 
2.34.3

