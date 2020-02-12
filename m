Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2EA815B2D2
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgBLVe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:34:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:42952 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729125AbgBLVeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 16:34:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 13:34:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,434,1574150400"; 
   d="scan'208";a="233911682"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga003.jf.intel.com with ESMTP; 12 Feb 2020 13:34:00 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 03/15] ice: display supported and advertised link modes
Date:   Wed, 12 Feb 2020 13:33:45 -0800
Message-Id: <20200212213357.2198911-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
References: <20200212213357.2198911-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Display all of the supported and advertised link modes based on the PHY
capability with media.

Displaying all supported modes is more informative then only displaying
the current link mode.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 282 +------------------
 1 file changed, 2 insertions(+), 280 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 90c6a3ca20c9..26eca4ce9e2c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1710,291 +1710,13 @@ ice_get_settings_link_up(struct ethtool_link_ksettings *ks,
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_port_info *pi = np->vsi->port_info;
-	struct ethtool_link_ksettings cap_ksettings;
 	struct ice_link_status *link_info;
 	struct ice_vsi *vsi = np->vsi;
-	bool unrecog_phy_high = false;
-	bool unrecog_phy_low = false;
 
 	link_info = &vsi->port_info->phy.link_info;
 
-	/* Initialize supported and advertised settings based on PHY settings */
-	switch (link_info->phy_type_low) {
-	case ICE_PHY_TYPE_LOW_100BASE_TX:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100baseT_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     100baseT_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_100M_SGMII:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100baseT_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_1000BASE_T:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     1000baseT_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     1000baseT_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_1G_SGMII:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     1000baseT_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_1000BASE_SX:
-	case ICE_PHY_TYPE_LOW_1000BASE_LX:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     1000baseX_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_1000BASE_KX:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     1000baseKX_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     1000baseKX_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_2500BASE_T:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     2500baseT_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     2500baseT_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_2500BASE_X:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     2500baseX_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_2500BASE_KX:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     2500baseX_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     2500baseX_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_5GBASE_T:
-	case ICE_PHY_TYPE_LOW_5GBASE_KR:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     5000baseT_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     5000baseT_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_10GBASE_T:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     10000baseT_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     10000baseT_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_10G_SFI_DA:
-	case ICE_PHY_TYPE_LOW_10G_SFI_AOC_ACC:
-	case ICE_PHY_TYPE_LOW_10G_SFI_C2C:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     10000baseT_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_10GBASE_SR:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     10000baseSR_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_10GBASE_LR:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     10000baseLR_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_10GBASE_KR_CR1:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     10000baseKR_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     10000baseKR_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_25GBASE_T:
-	case ICE_PHY_TYPE_LOW_25GBASE_CR:
-	case ICE_PHY_TYPE_LOW_25GBASE_CR_S:
-	case ICE_PHY_TYPE_LOW_25GBASE_CR1:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     25000baseCR_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     25000baseCR_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_25G_AUI_AOC_ACC:
-	case ICE_PHY_TYPE_LOW_25G_AUI_C2C:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     25000baseCR_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_25GBASE_SR:
-	case ICE_PHY_TYPE_LOW_25GBASE_LR:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     25000baseSR_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_25GBASE_KR:
-	case ICE_PHY_TYPE_LOW_25GBASE_KR1:
-	case ICE_PHY_TYPE_LOW_25GBASE_KR_S:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     25000baseKR_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     25000baseKR_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_40GBASE_CR4:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     40000baseCR4_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     40000baseCR4_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_40G_XLAUI_AOC_ACC:
-	case ICE_PHY_TYPE_LOW_40G_XLAUI:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     40000baseCR4_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_40GBASE_SR4:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     40000baseSR4_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_40GBASE_LR4:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     40000baseLR4_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_40GBASE_KR4:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     40000baseKR4_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     40000baseKR4_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_50GBASE_CR2:
-	case ICE_PHY_TYPE_LOW_50GBASE_CP:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     50000baseCR2_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     50000baseCR2_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_50G_LAUI2_AOC_ACC:
-	case ICE_PHY_TYPE_LOW_50G_LAUI2:
-	case ICE_PHY_TYPE_LOW_50G_AUI2_AOC_ACC:
-	case ICE_PHY_TYPE_LOW_50G_AUI2:
-	case ICE_PHY_TYPE_LOW_50GBASE_SR:
-	case ICE_PHY_TYPE_LOW_50G_AUI1_AOC_ACC:
-	case ICE_PHY_TYPE_LOW_50G_AUI1:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     50000baseCR2_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_50GBASE_KR2:
-	case ICE_PHY_TYPE_LOW_50GBASE_KR_PAM4:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     50000baseKR2_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     50000baseKR2_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_50GBASE_SR2:
-	case ICE_PHY_TYPE_LOW_50GBASE_LR2:
-	case ICE_PHY_TYPE_LOW_50GBASE_FR:
-	case ICE_PHY_TYPE_LOW_50GBASE_LR:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     50000baseSR2_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_100GBASE_CR4:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseCR4_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     100000baseCR4_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_100G_CAUI4_AOC_ACC:
-	case ICE_PHY_TYPE_LOW_100G_CAUI4:
-	case ICE_PHY_TYPE_LOW_100G_AUI4_AOC_ACC:
-	case ICE_PHY_TYPE_LOW_100G_AUI4:
-	case ICE_PHY_TYPE_LOW_100GBASE_CR_PAM4:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseCR4_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_100GBASE_CP2:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseCR4_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     100000baseCR4_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_100GBASE_SR4:
-	case ICE_PHY_TYPE_LOW_100GBASE_SR2:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseSR4_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_100GBASE_LR4:
-	case ICE_PHY_TYPE_LOW_100GBASE_DR:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseLR4_ER4_Full);
-		break;
-	case ICE_PHY_TYPE_LOW_100GBASE_KR4:
-	case ICE_PHY_TYPE_LOW_100GBASE_KR_PAM4:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseKR4_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     100000baseKR4_Full);
-		break;
-	default:
-		unrecog_phy_low = true;
-	}
-
-	switch (link_info->phy_type_high) {
-	case ICE_PHY_TYPE_HIGH_100GBASE_KR2_PAM4:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseKR4_Full);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     100000baseKR4_Full);
-		break;
-	case ICE_PHY_TYPE_HIGH_100G_CAUI2_AOC_ACC:
-	case ICE_PHY_TYPE_HIGH_100G_CAUI2:
-	case ICE_PHY_TYPE_HIGH_100G_AUI2_AOC_ACC:
-	case ICE_PHY_TYPE_HIGH_100G_AUI2:
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseCR4_Full);
-		break;
-	default:
-		unrecog_phy_high = true;
-	}
-
-	if (unrecog_phy_low && unrecog_phy_high) {
-		/* if we got here and link is up something bad is afoot */
-		netdev_info(netdev,
-			    "WARNING: Unrecognized PHY_Low (0x%llx).\n",
-			    (u64)link_info->phy_type_low);
-		netdev_info(netdev,
-			    "WARNING: Unrecognized PHY_High (0x%llx).\n",
-			    (u64)link_info->phy_type_high);
-	}
-
-	/* Now that we've worked out everything that could be supported by the
-	 * current PHY type, get what is supported by the NVM and intersect
-	 * them to get what is truly supported
-	 */
-	memset(&cap_ksettings, 0, sizeof(cap_ksettings));
-	ice_phy_type_to_ethtool(netdev, &cap_ksettings);
-	ethtool_intersect_link_masks(ks, &cap_ksettings);
+	/* Get supported and advertised settings from PHY ability with media */
+	ice_phy_type_to_ethtool(netdev, ks);
 
 	switch (link_info->link_speed) {
 	case ICE_AQ_LINK_SPEED_100GB:
-- 
2.24.1

