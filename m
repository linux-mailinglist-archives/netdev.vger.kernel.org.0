Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD21211620
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgGAWel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:34:41 -0400
Received: from mga18.intel.com ([134.134.136.126]:25457 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgGAWeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:34:37 -0400
IronPort-SDR: OJYta1DBCWJy+RYTL3iwsKVDx//ck5IVXgT+2kWZj41TrLCtjdng++1/PjB3d54xqrfkUg04fh
 cWSAfT5Nonfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="134178610"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="134178610"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 15:34:22 -0700
IronPort-SDR: CAF05u7XP1BDoiXPfgkK1atCYkK0Lb1N0FWBHVb6DhPsliRgxt5nlgqPCCql034fmg388BSzNV
 mx200C9rjftQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="455276133"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 15:34:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 12/12] ixgbe: Add ethtool support to enable 2.5 and 5.0 Gbps support
Date:   Wed,  1 Jul 2020 15:34:12 -0700
Message-Id: <20200701223412.2675606-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

Added full support for new version Ethtool API. New API allow use
2500Gbase-T and 5000base-T supported and advertised link speed modes.

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 262 ++++++++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   6 +-
 2 files changed, 183 insertions(+), 85 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index fd6784952766..6725d892336e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -142,32 +142,71 @@ static const char ixgbe_priv_flags_strings[][ETH_GSTRING_LEN] = {
 
 #define IXGBE_PRIV_FLAGS_STR_LEN ARRAY_SIZE(ixgbe_priv_flags_strings)
 
-/* currently supported speeds for 10G */
-#define ADVRTSD_MSK_10G (SUPPORTED_10000baseT_Full | \
-			 SUPPORTED_10000baseKX4_Full | \
-			 SUPPORTED_10000baseKR_Full)
-
 #define ixgbe_isbackplane(type) ((type) == ixgbe_media_type_backplane)
 
-static u32 ixgbe_get_supported_10gtypes(struct ixgbe_hw *hw)
+static void ixgbe_set_supported_10gtypes(struct ixgbe_hw *hw,
+					 struct ethtool_link_ksettings *cmd)
 {
-	if (!ixgbe_isbackplane(hw->phy.media_type))
-		return SUPPORTED_10000baseT_Full;
+	if (!ixgbe_isbackplane(hw->phy.media_type)) {
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     10000baseT_Full);
+		return;
+	}
 
 	switch (hw->device_id) {
 	case IXGBE_DEV_ID_82598:
 	case IXGBE_DEV_ID_82599_KX4:
 	case IXGBE_DEV_ID_82599_KX4_MEZZ:
 	case IXGBE_DEV_ID_X550EM_X_KX4:
-		return SUPPORTED_10000baseKX4_Full;
+		ethtool_link_ksettings_add_link_mode
+			(cmd, supported, 10000baseKX4_Full);
+		break;
 	case IXGBE_DEV_ID_82598_BX:
 	case IXGBE_DEV_ID_82599_KR:
 	case IXGBE_DEV_ID_X550EM_X_KR:
 	case IXGBE_DEV_ID_X550EM_X_XFI:
-		return SUPPORTED_10000baseKR_Full;
+		ethtool_link_ksettings_add_link_mode
+			(cmd, supported, 10000baseKR_Full);
+		break;
 	default:
-		return SUPPORTED_10000baseKX4_Full |
-		       SUPPORTED_10000baseKR_Full;
+		ethtool_link_ksettings_add_link_mode
+			(cmd, supported, 10000baseKX4_Full);
+		ethtool_link_ksettings_add_link_mode
+			(cmd, supported, 10000baseKR_Full);
+		break;
+	}
+}
+
+static void ixgbe_set_advertising_10gtypes(struct ixgbe_hw *hw,
+					   struct ethtool_link_ksettings *cmd)
+{
+	if (!ixgbe_isbackplane(hw->phy.media_type)) {
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     10000baseT_Full);
+		return;
+	}
+
+	switch (hw->device_id) {
+	case IXGBE_DEV_ID_82598:
+	case IXGBE_DEV_ID_82599_KX4:
+	case IXGBE_DEV_ID_82599_KX4_MEZZ:
+	case IXGBE_DEV_ID_X550EM_X_KX4:
+		ethtool_link_ksettings_add_link_mode
+			(cmd, advertising, 10000baseKX4_Full);
+		break;
+	case IXGBE_DEV_ID_82598_BX:
+	case IXGBE_DEV_ID_82599_KR:
+	case IXGBE_DEV_ID_X550EM_X_KR:
+	case IXGBE_DEV_ID_X550EM_X_XFI:
+		ethtool_link_ksettings_add_link_mode
+			(cmd, advertising, 10000baseKR_Full);
+		break;
+	default:
+		ethtool_link_ksettings_add_link_mode
+			(cmd, advertising, 10000baseKX4_Full);
+		ethtool_link_ksettings_add_link_mode
+			(cmd, advertising, 10000baseKR_Full);
+		break;
 	}
 }
 
@@ -178,52 +217,88 @@ static int ixgbe_get_link_ksettings(struct net_device *netdev,
 	struct ixgbe_hw *hw = &adapter->hw;
 	ixgbe_link_speed supported_link;
 	bool autoneg = false;
-	u32 supported, advertising;
 
-	ethtool_convert_link_mode_to_legacy_u32(&supported,
-						cmd->link_modes.supported);
+	ethtool_link_ksettings_zero_link_mode(cmd, supported);
+	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
 
 	hw->mac.ops.get_link_capabilities(hw, &supported_link, &autoneg);
 
 	/* set the supported link speeds */
-	if (supported_link & IXGBE_LINK_SPEED_10GB_FULL)
-		supported |= ixgbe_get_supported_10gtypes(hw);
-	if (supported_link & IXGBE_LINK_SPEED_1GB_FULL)
-		supported |= (ixgbe_isbackplane(hw->phy.media_type)) ?
-				   SUPPORTED_1000baseKX_Full :
-				   SUPPORTED_1000baseT_Full;
-	if (supported_link & IXGBE_LINK_SPEED_100_FULL)
-		supported |= SUPPORTED_100baseT_Full;
-	if (supported_link & IXGBE_LINK_SPEED_10_FULL)
-		supported |= SUPPORTED_10baseT_Full;
-
-	/* default advertised speed if phy.autoneg_advertised isn't set */
-	advertising = supported;
+	if (supported_link & IXGBE_LINK_SPEED_10GB_FULL) {
+		ixgbe_set_supported_10gtypes(hw, cmd);
+		ixgbe_set_advertising_10gtypes(hw, cmd);
+	}
+	if (supported_link & IXGBE_LINK_SPEED_5GB_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     5000baseT_Full);
+
+	if (supported_link & IXGBE_LINK_SPEED_2_5GB_FULL)
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     2500baseT_Full);
+
+	if (supported_link & IXGBE_LINK_SPEED_1GB_FULL) {
+		if (ixgbe_isbackplane(hw->phy.media_type)) {
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     1000baseKX_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     1000baseKX_Full);
+		} else {
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     1000baseT_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     1000baseT_Full);
+		}
+	}
+	if (supported_link & IXGBE_LINK_SPEED_100_FULL) {
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     100baseT_Full);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     100baseT_Full);
+	}
+	if (supported_link & IXGBE_LINK_SPEED_10_FULL) {
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     10baseT_Full);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     10baseT_Full);
+	}
+
 	/* set the advertised speeds */
 	if (hw->phy.autoneg_advertised) {
-		advertising = 0;
+		ethtool_link_ksettings_zero_link_mode(cmd, advertising);
 		if (hw->phy.autoneg_advertised & IXGBE_LINK_SPEED_10_FULL)
-			advertising |= ADVERTISED_10baseT_Full;
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     10baseT_Full);
 		if (hw->phy.autoneg_advertised & IXGBE_LINK_SPEED_100_FULL)
-			advertising |= ADVERTISED_100baseT_Full;
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     100baseT_Full);
 		if (hw->phy.autoneg_advertised & IXGBE_LINK_SPEED_10GB_FULL)
-			advertising |= supported & ADVRTSD_MSK_10G;
+			ixgbe_set_advertising_10gtypes(hw, cmd);
 		if (hw->phy.autoneg_advertised & IXGBE_LINK_SPEED_1GB_FULL) {
-			if (supported & SUPPORTED_1000baseKX_Full)
-				advertising |= ADVERTISED_1000baseKX_Full;
+			if (ethtool_link_ksettings_test_link_mode
+				(cmd, supported, 1000baseKX_Full))
+				ethtool_link_ksettings_add_link_mode
+					(cmd, advertising, 1000baseKX_Full);
 			else
-				advertising |= ADVERTISED_1000baseT_Full;
+				ethtool_link_ksettings_add_link_mode
+					(cmd, advertising, 1000baseT_Full);
 		}
+		if (hw->phy.autoneg_advertised & IXGBE_LINK_SPEED_5GB_FULL)
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     5000baseT_Full);
+		if (hw->phy.autoneg_advertised & IXGBE_LINK_SPEED_2_5GB_FULL)
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     2500baseT_Full);
 	} else {
 		if (hw->phy.multispeed_fiber && !autoneg) {
 			if (supported_link & IXGBE_LINK_SPEED_10GB_FULL)
-				advertising = ADVERTISED_10000baseT_Full;
+				ethtool_link_ksettings_add_link_mode
+					(cmd, advertising, 10000baseT_Full);
 		}
 	}
 
 	if (autoneg) {
-		supported |= SUPPORTED_Autoneg;
-		advertising |= ADVERTISED_Autoneg;
+		ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
 		cmd->base.autoneg = AUTONEG_ENABLE;
 	} else
 		cmd->base.autoneg = AUTONEG_DISABLE;
@@ -235,13 +310,13 @@ static int ixgbe_get_link_ksettings(struct net_device *netdev,
 	case ixgbe_phy_x550em_ext_t:
 	case ixgbe_phy_fw:
 	case ixgbe_phy_cu_unknown:
-		supported |= SUPPORTED_TP;
-		advertising |= ADVERTISED_TP;
+		ethtool_link_ksettings_add_link_mode(cmd, supported, TP);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, TP);
 		cmd->base.port = PORT_TP;
 		break;
 	case ixgbe_phy_qt:
-		supported |= SUPPORTED_FIBRE;
-		advertising |= ADVERTISED_FIBRE;
+		ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, FIBRE);
 		cmd->base.port = PORT_FIBRE;
 		break;
 	case ixgbe_phy_nl:
@@ -260,8 +335,10 @@ static int ixgbe_get_link_ksettings(struct net_device *netdev,
 		case ixgbe_sfp_type_da_cu:
 		case ixgbe_sfp_type_da_cu_core0:
 		case ixgbe_sfp_type_da_cu_core1:
-			supported |= SUPPORTED_FIBRE;
-			advertising |= ADVERTISED_FIBRE;
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     FIBRE);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     FIBRE);
 			cmd->base.port = PORT_DA;
 			break;
 		case ixgbe_sfp_type_sr:
@@ -272,61 +349,76 @@ static int ixgbe_get_link_ksettings(struct net_device *netdev,
 		case ixgbe_sfp_type_1g_sx_core1:
 		case ixgbe_sfp_type_1g_lx_core0:
 		case ixgbe_sfp_type_1g_lx_core1:
-			supported |= SUPPORTED_FIBRE;
-			advertising |= ADVERTISED_FIBRE;
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     FIBRE);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     FIBRE);
 			cmd->base.port = PORT_FIBRE;
 			break;
 		case ixgbe_sfp_type_not_present:
-			supported |= SUPPORTED_FIBRE;
-			advertising |= ADVERTISED_FIBRE;
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     FIBRE);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     FIBRE);
 			cmd->base.port = PORT_NONE;
 			break;
 		case ixgbe_sfp_type_1g_cu_core0:
 		case ixgbe_sfp_type_1g_cu_core1:
-			supported |= SUPPORTED_TP;
-			advertising |= ADVERTISED_TP;
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     TP);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     TP);
 			cmd->base.port = PORT_TP;
 			break;
 		case ixgbe_sfp_type_unknown:
 		default:
-			supported |= SUPPORTED_FIBRE;
-			advertising |= ADVERTISED_FIBRE;
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     FIBRE);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     FIBRE);
 			cmd->base.port = PORT_OTHER;
 			break;
 		}
 		break;
 	case ixgbe_phy_xaui:
-		supported |= SUPPORTED_FIBRE;
-		advertising |= ADVERTISED_FIBRE;
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     FIBRE);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     FIBRE);
 		cmd->base.port = PORT_NONE;
 		break;
 	case ixgbe_phy_unknown:
 	case ixgbe_phy_generic:
 	case ixgbe_phy_sfp_unsupported:
 	default:
-		supported |= SUPPORTED_FIBRE;
-		advertising |= ADVERTISED_FIBRE;
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     FIBRE);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     FIBRE);
 		cmd->base.port = PORT_OTHER;
 		break;
 	}
 
 	/* Indicate pause support */
-	supported |= SUPPORTED_Pause;
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
 
 	switch (hw->fc.requested_mode) {
 	case ixgbe_fc_full:
-		advertising |= ADVERTISED_Pause;
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 		break;
 	case ixgbe_fc_rx_pause:
-		advertising |= ADVERTISED_Pause |
-				     ADVERTISED_Asym_Pause;
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     Asym_Pause);
 		break;
 	case ixgbe_fc_tx_pause:
-		advertising |= ADVERTISED_Asym_Pause;
+		ethtool_link_ksettings_add_link_mode(cmd, advertising,
+						     Asym_Pause);
 		break;
 	default:
-		advertising &= ~(ADVERTISED_Pause |
-				       ADVERTISED_Asym_Pause);
+		ethtool_link_ksettings_del_link_mode(cmd, advertising, Pause);
+		ethtool_link_ksettings_del_link_mode(cmd, advertising,
+						     Asym_Pause);
 	}
 
 	if (netif_carrier_ok(netdev)) {
@@ -358,11 +450,6 @@ static int ixgbe_get_link_ksettings(struct net_device *netdev,
 		cmd->base.duplex = DUPLEX_UNKNOWN;
 	}
 
-	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
-						supported);
-	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
-						advertising);
-
 	return 0;
 }
 
@@ -373,12 +460,6 @@ static int ixgbe_set_link_ksettings(struct net_device *netdev,
 	struct ixgbe_hw *hw = &adapter->hw;
 	u32 advertised, old;
 	s32 err = 0;
-	u32 supported, advertising;
-
-	ethtool_convert_link_mode_to_legacy_u32(&supported,
-						cmd->link_modes.supported);
-	ethtool_convert_link_mode_to_legacy_u32(&advertising,
-						cmd->link_modes.advertising);
 
 	if ((hw->phy.media_type == ixgbe_media_type_copper) ||
 	    (hw->phy.multispeed_fiber)) {
@@ -386,29 +467,41 @@ static int ixgbe_set_link_ksettings(struct net_device *netdev,
 		 * this function does not support duplex forcing, but can
 		 * limit the advertising of the adapter to the specified speed
 		 */
-		if (advertising & ~supported)
+		if (!bitmap_subset(cmd->link_modes.advertising,
+				   cmd->link_modes.supported,
+				   __ETHTOOL_LINK_MODE_MASK_NBITS))
 			return -EINVAL;
 
 		/* only allow one speed at a time if no autoneg */
 		if (!cmd->base.autoneg && hw->phy.multispeed_fiber) {
-			if (advertising ==
-			    (ADVERTISED_10000baseT_Full |
-			     ADVERTISED_1000baseT_Full))
+			if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+								  10000baseT_Full) &&
+			    ethtool_link_ksettings_test_link_mode(cmd, advertising,
+								  1000baseT_Full))
 				return -EINVAL;
 		}
 
 		old = hw->phy.autoneg_advertised;
 		advertised = 0;
-		if (advertising & ADVERTISED_10000baseT_Full)
+		if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+							  10000baseT_Full))
 			advertised |= IXGBE_LINK_SPEED_10GB_FULL;
-
-		if (advertising & ADVERTISED_1000baseT_Full)
+		if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+							  5000baseT_Full))
+			advertised |= IXGBE_LINK_SPEED_5GB_FULL;
+		if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+							  2500baseT_Full))
+			advertised |= IXGBE_LINK_SPEED_2_5GB_FULL;
+		if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+							  1000baseT_Full))
 			advertised |= IXGBE_LINK_SPEED_1GB_FULL;
 
-		if (advertising & ADVERTISED_100baseT_Full)
+		if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+							  100baseT_Full))
 			advertised |= IXGBE_LINK_SPEED_100_FULL;
 
-		if (advertising & ADVERTISED_10baseT_Full)
+		if (ethtool_link_ksettings_test_link_mode(cmd, advertising,
+							  10baseT_Full))
 			advertised |= IXGBE_LINK_SPEED_10_FULL;
 
 		if (old == advertised)
@@ -429,7 +522,8 @@ static int ixgbe_set_link_ksettings(struct net_device *netdev,
 		u32 speed = cmd->base.speed;
 
 		if ((cmd->base.autoneg == AUTONEG_ENABLE) ||
-		    (advertising != ADVERTISED_10000baseT_Full) ||
+		    (!ethtool_link_ksettings_test_link_mode(cmd, advertising,
+							    10000baseT_Full)) ||
 		    (speed + cmd->base.duplex != SPEED_10000 + DUPLEX_FULL))
 			return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 4601118f88c9..f5d3d6230786 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5501,9 +5501,13 @@ static int ixgbe_non_sfp_link_config(struct ixgbe_hw *hw)
 		return ret;
 
 	speed = hw->phy.autoneg_advertised;
-	if ((!speed) && (hw->mac.ops.get_link_capabilities))
+	if (!speed && hw->mac.ops.get_link_capabilities) {
 		ret = hw->mac.ops.get_link_capabilities(hw, &speed,
 							&autoneg);
+		speed &= ~(IXGBE_LINK_SPEED_5GB_FULL |
+			   IXGBE_LINK_SPEED_2_5GB_FULL);
+	}
+
 	if (ret)
 		return ret;
 
-- 
2.26.2

