Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584E339BC95
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhFDQL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:11:28 -0400
Received: from mga04.intel.com ([192.55.52.120]:16626 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhFDQL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:11:28 -0400
IronPort-SDR: JZ4qmB+kNNjOjAVhl/7KFcA/vnVV5oW4Z8lRIr490hwJsKxIdvuzqa3motCKkQt9ieDHEo2zjQ
 /7a4yMbrv8aA==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="202460187"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="202460187"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:06:04 -0700
IronPort-SDR: +K362KSpiGFDZ3v+edoL+HIS/kOT3NHWfSC6mpu9TWAcwm/mmpYXUDH3Ejv9B6MtcTnbnbvrcV
 04EMtGJdhmuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="475511741"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2021 09:05:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 4/6] ice: report supported and advertised autoneg using PHY capabilities
Date:   Fri,  4 Jun 2021 09:08:14 -0700
Message-Id: <20210604160816.3391716-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
References: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Ethtool incorrectly reported supported and advertised auto-negotiation
settings for a backplane PHY image which did not support auto-negotiation.
This can occur when using media or PHY type for reporting ethtool
supported and advertised auto-negotiation settings.

Remove setting supported and advertised auto-negotiation settings based
on PHY type in ice_phy_type_to_ethtool(), and MAC type in
ice_get_link_ksettings().

Ethtool supported and advertised auto-negotiation settings should be
based on the PHY image using the AQ command get PHY capabilities with
media. Add setting supported and advertised auto-negotiation settings
based get PHY capabilities with media in ice_get_link_ksettings().

Fixes: 48cb27f2fd18 ("ice: Implement handlers for ethtool PHY/link operations")
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 51 +++-----------------
 1 file changed, 6 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index d9ddd0bcf65f..99301ad95290 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1773,49 +1773,6 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
 						100000baseKR4_Full);
 	}
-
-	/* Autoneg PHY types */
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100BASE_TX ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_1000BASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_1000BASE_KX ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_2500BASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_2500BASE_KX ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_5GBASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_5GBASE_KR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_10GBASE_KR_CR1 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_T ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_CR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_CR_S ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_CR1 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_KR ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_KR_S ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_25GBASE_KR1 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_CR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_40GBASE_KR4) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     Autoneg);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_CR2 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_KR2 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_CP ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_50GBASE_KR_PAM4) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     Autoneg);
-	}
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_CR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_KR4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_KR_PAM4 ||
-	    phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_CP2) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     Autoneg);
-		ethtool_link_ksettings_add_link_mode(ks, advertising,
-						     Autoneg);
-	}
 }
 
 #define TEST_SET_BITS_TIMEOUT	50
@@ -1972,9 +1929,7 @@ ice_get_link_ksettings(struct net_device *netdev,
 		ks->base.port = PORT_TP;
 		break;
 	case ICE_MEDIA_BACKPLANE:
-		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
 		ethtool_link_ksettings_add_link_mode(ks, supported, Backplane);
-		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
 		ethtool_link_ksettings_add_link_mode(ks, advertising,
 						     Backplane);
 		ks->base.port = PORT_NONE;
@@ -2049,6 +2004,12 @@ ice_get_link_ksettings(struct net_device *netdev,
 	if (caps->link_fec_options & ICE_AQC_PHY_FEC_25G_RS_CLAUSE91_EN)
 		ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
 
+	/* Set supported and advertised autoneg */
+	if (ice_is_phy_caps_an_enabled(caps)) {
+		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
+		ethtool_link_ksettings_add_link_mode(ks, advertising, Autoneg);
+	}
+
 done:
 	kfree(caps);
 	return err;
-- 
2.26.2

