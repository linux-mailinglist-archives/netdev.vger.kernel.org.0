Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F8728D32
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388639AbfEWWdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:42 -0400
Received: from mga12.intel.com ([192.55.52.136]:19068 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388574AbfEWWdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ice: Advertise supported link modes if none requested
Date:   Thu, 23 May 2019 15:33:32 -0700
Message-Id: <20190523223340.13449-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

User requested link modes affect what is returned as an advertised
link mode.  If no modes have been requested, we are not advertising
any link modes.  Advertise what we are capable of supporting if no
link modes have been requested.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 75 +++++++++++++-------
 1 file changed, 50 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index c1511393846f..91e3c451c66c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -628,7 +628,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_100M_SGMII) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100baseT_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100MB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100MB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     100baseT_Full);
 	}
@@ -636,14 +637,16 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_1G_SGMII) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     1000baseT_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_1000MB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_1000MB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     1000baseT_Full);
 	}
 	if (phy_types_low & ICE_PHY_TYPE_LOW_1000BASE_KX) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     1000baseKX_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_1000MB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_1000MB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     1000baseKX_Full);
 	}
@@ -651,14 +654,16 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_1000BASE_LX) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     1000baseX_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_1000MB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_1000MB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     1000baseX_Full);
 	}
 	if (phy_types_low & ICE_PHY_TYPE_LOW_2500BASE_T) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     2500baseT_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_2500MB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_2500MB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     2500baseT_Full);
 	}
@@ -666,7 +671,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_2500BASE_KX) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     2500baseX_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_2500MB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_2500MB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     2500baseX_Full);
 	}
@@ -674,7 +680,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_5GBASE_KR) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     5000baseT_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_5GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_5GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     5000baseT_Full);
 	}
@@ -684,28 +691,32 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_10G_SFI_C2C) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseT_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     10000baseT_Full);
 	}
 	if (phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_KR_CR1) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseKR_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     10000baseKR_Full);
 	}
 	if (phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_SR) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseSR_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     10000baseSR_Full);
 	}
 	if (phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_LR) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     10000baseLR_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_10GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     10000baseLR_Full);
 	}
@@ -717,7 +728,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_25G_AUI_C2C) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     25000baseCR_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_25GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_25GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     25000baseCR_Full);
 	}
@@ -725,7 +737,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_LR) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     25000baseSR_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_25GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_25GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     25000baseSR_Full);
 	}
@@ -734,14 +747,16 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_KR1) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     25000baseKR_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_25GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_25GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     25000baseKR_Full);
 	}
 	if (phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_KR4) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseKR4_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     40000baseKR4_Full);
 	}
@@ -750,21 +765,24 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_40G_XLAUI) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseCR4_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     40000baseCR4_Full);
 	}
 	if (phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_SR4) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseSR4_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     40000baseSR4_Full);
 	}
 	if (phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_LR4) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     40000baseLR4_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_40GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     40000baseLR4_Full);
 	}
@@ -779,7 +797,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_50G_AUI1) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     50000baseCR2_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_50GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_50GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     50000baseCR2_Full);
 	}
@@ -787,7 +806,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_KR_PAM4) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     50000baseKR2_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_50GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_50GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     50000baseKR2_Full);
 	}
@@ -797,7 +817,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_LR) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     50000baseSR2_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_50GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_50GB)
 			ethtool_link_ksettings_add_link_mode(ks, advertising,
 							     50000baseSR2_Full);
 	}
@@ -814,7 +835,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_high & ICE_PHY_TYPE_HIGH_100G_AUI2) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseCR4_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
 			need_add_adv_mode = true;
 	}
 	if (need_add_adv_mode) {
@@ -826,7 +848,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_SR2) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseSR4_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
 			need_add_adv_mode = true;
 	}
 	if (need_add_adv_mode) {
@@ -838,7 +861,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_DR) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseLR4_ER4_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
 			need_add_adv_mode = true;
 	}
 	if (need_add_adv_mode) {
@@ -851,7 +875,8 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	    phy_types_high & ICE_PHY_TYPE_HIGH_100GBASE_KR2_PAM4) {
 		ethtool_link_ksettings_add_link_mode(ks, supported,
 						     100000baseKR4_Full);
-		if (hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
+		if (!hw_link_info->req_speeds ||
+		    hw_link_info->req_speeds & ICE_AQ_LINK_SPEED_100GB)
 			need_add_adv_mode = true;
 	}
 	if (need_add_adv_mode)
-- 
2.21.0

