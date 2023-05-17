Return-Path: <netdev+bounces-3408-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC84706EEC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:00:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 281542815FF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B2F3113D;
	Wed, 17 May 2023 16:59:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8121442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 16:59:27 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68FB86B4
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684342762; x=1715878762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RFGqYCJrYN45dHnT9QDTiBPyAQRAm4PEpIcl4Sfxxbg=;
  b=IiPpAMUdbmoo1RqGK8T4LfdpZP4ifOclQXekHp58G97KSzIdYKxNbGQf
   KI+FUY2+yuLPic7LEmz+0uLAZ4Nk8rBwYA9ZDhwfH2esoFD+G4KifRorW
   obhyOo/XzgyHdxBcz6rY3TAyv7kM0HchgjnL2acwiCE5yUZSwqQHEcHn6
   5wQtRgaUZT9LZLwGfe2RKgLV43xcoeJDoDIASqbRxBMZ8ooncdl/W+9QB
   y1a47Ywiyvg4VAInlAqNvluFTVXPUtE21lBh0hVwRvrZlS+QH9EwfHhvL
   HonjT/3q4LvvXoSQRl+YO6H8m6Hba9ziKV8WuWj0i+iblw0V7PGhrVzdZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="380011551"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="380011551"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2023 09:59:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="704876771"
X-IronPort-AV: E=Sophos;i="5.99,282,1677571200"; 
   d="scan'208";a="704876771"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga007.fm.intel.com with ESMTP; 17 May 2023 09:59:16 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Paul Greenwalt <paul.greenwalt@intel.com>,
	anthony.l.nguyen@intel.com,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next 2/5] ice: refactor PHY type to ethtool link mode
Date: Wed, 17 May 2023 09:55:27 -0700
Message-Id: <20230517165530.3179965-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
References: <20230517165530.3179965-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Paul Greenwalt <paul.greenwalt@intel.com>

Refactor ice_phy_type_to_ethtool to use phy_type_[low|high]_lkup table to
map PHY type to AQ link speed and ethtool link mode. This removes
complexity and simplifies future changes.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |   1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 309 +++----------------
 drivers/net/ethernet/intel/ice/ice_ethtool.h | 105 +++++++
 3 files changed, 141 insertions(+), 274 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ethtool.h

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index d637032c8139..8b016511561f 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -32,6 +32,7 @@
 #include <linux/pkt_sched.h>
 #include <linux/if_bridge.h>
 #include <linux/ctype.h>
+#include <linux/linkmode.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
 #include <linux/auxiliary_bus.h>
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 8407c7175cf6..8d5cbbd0b3d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -4,6 +4,7 @@
 /* ethtool support for ice */
 
 #include "ice.h"
+#include "ice_ethtool.h"
 #include "ice_flow.h"
 #include "ice_fltr.h"
 #include "ice_lib.h"
@@ -1658,15 +1659,26 @@ ice_mask_min_supported_speeds(struct ice_hw *hw,
 		*phy_types_low &= ~ICE_PHY_TYPE_LOW_MASK_MIN_1G;
 }
 
-#define ice_ethtool_advertise_link_mode(aq_link_speed, ethtool_link_mode)    \
-	do {								     \
-		if (req_speeds & (aq_link_speed) ||			     \
-		    (!req_speeds &&					     \
-		     (advert_phy_type_lo & phy_type_mask_lo ||		     \
-		      advert_phy_type_hi & phy_type_mask_hi)))		     \
-			ethtool_link_ksettings_add_link_mode(ks, advertising,\
-							ethtool_link_mode);  \
-	} while (0)
+/**
+ * ice_linkmode_set_bit - set link mode bit
+ * @phy_to_ethtool: PHY type to ethtool link mode struct to set
+ * @ks: ethtool link ksettings struct to fill out
+ * @req_speeds: speed requested by user
+ * @advert_phy_type: advertised PHY type
+ * @phy_type: PHY type
+ */
+static void
+ice_linkmode_set_bit(const struct ice_phy_type_to_ethtool *phy_to_ethtool,
+		     struct ethtool_link_ksettings *ks, u32 req_speeds,
+		     u64 advert_phy_type, u32 phy_type)
+{
+	linkmode_set_bit(phy_to_ethtool->link_mode, ks->link_modes.supported);
+
+	if (req_speeds & phy_to_ethtool->aq_link_speed ||
+	    (!req_speeds && advert_phy_type & BIT(phy_type)))
+		linkmode_set_bit(phy_to_ethtool->link_mode,
+				 ks->link_modes.advertising);
+}
 
 /**
  * ice_phy_type_to_ethtool - convert the phy_types to ethtool link modes
@@ -1682,11 +1694,10 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 	struct ice_pf *pf = vsi->back;
 	u64 advert_phy_type_lo = 0;
 	u64 advert_phy_type_hi = 0;
-	u64 phy_type_mask_lo = 0;
-	u64 phy_type_mask_hi = 0;
 	u64 phy_types_high = 0;
 	u64 phy_types_low = 0;
-	u16 req_speeds;
+	u32 req_speeds;
+	u32 i;
 
 	req_speeds = vsi->port_info->phy.link_info.req_speeds;
 
@@ -1743,272 +1754,22 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 		advert_phy_type_hi = vsi->port_info->phy.phy_type_high;
 	}
 
-	ethtool_link_ksettings_zero_link_mode(ks, supported);
-	ethtool_link_ksettings_zero_link_mode(ks, advertising);
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100BASE_TX |
-			   ICE_PHY_TYPE_LOW_100M_SGMII;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100baseT_Full);
-
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100MB,
-						100baseT_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_1000BASE_T |
-			   ICE_PHY_TYPE_LOW_1G_SGMII;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     1000baseT_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_1000MB,
-						1000baseT_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_1000BASE_KX;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     1000baseKX_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_1000MB,
-						1000baseKX_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_1000BASE_SX |
-			   ICE_PHY_TYPE_LOW_1000BASE_LX;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     1000baseX_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_1000MB,
-						1000baseX_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_2500BASE_T;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     2500baseT_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_2500MB,
-						2500baseT_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_2500BASE_X |
-			   ICE_PHY_TYPE_LOW_2500BASE_KX;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     2500baseX_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_2500MB,
-						2500baseX_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_5GBASE_T |
-			   ICE_PHY_TYPE_LOW_5GBASE_KR;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     5000baseT_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_5GB,
-						5000baseT_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_10GBASE_T |
-			   ICE_PHY_TYPE_LOW_10G_SFI_DA |
-			   ICE_PHY_TYPE_LOW_10G_SFI_AOC_ACC |
-			   ICE_PHY_TYPE_LOW_10G_SFI_C2C;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     10000baseT_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_10GB,
-						10000baseT_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_10GBASE_KR_CR1;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     10000baseKR_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_10GB,
-						10000baseKR_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_10GBASE_SR;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     10000baseSR_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_10GB,
-						10000baseSR_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_10GBASE_LR;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     10000baseLR_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_10GB,
-						10000baseLR_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_25GBASE_T |
-			   ICE_PHY_TYPE_LOW_25GBASE_CR |
-			   ICE_PHY_TYPE_LOW_25GBASE_CR_S |
-			   ICE_PHY_TYPE_LOW_25GBASE_CR1 |
-			   ICE_PHY_TYPE_LOW_25G_AUI_AOC_ACC |
-			   ICE_PHY_TYPE_LOW_25G_AUI_C2C;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     25000baseCR_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_25GB,
-						25000baseCR_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_25GBASE_SR |
-			   ICE_PHY_TYPE_LOW_25GBASE_LR;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     25000baseSR_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_25GB,
-						25000baseSR_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_25GBASE_KR |
-			   ICE_PHY_TYPE_LOW_25GBASE_KR_S |
-			   ICE_PHY_TYPE_LOW_25GBASE_KR1;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     25000baseKR_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_25GB,
-						25000baseKR_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_40GBASE_KR4;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     40000baseKR4_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_40GB,
-						40000baseKR4_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_40GBASE_CR4 |
-			   ICE_PHY_TYPE_LOW_40G_XLAUI_AOC_ACC |
-			   ICE_PHY_TYPE_LOW_40G_XLAUI;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     40000baseCR4_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_40GB,
-						40000baseCR4_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_40GBASE_SR4;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     40000baseSR4_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_40GB,
-						40000baseSR4_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_40GBASE_LR4;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     40000baseLR4_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_40GB,
-						40000baseLR4_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_50GBASE_CR2 |
-			   ICE_PHY_TYPE_LOW_50G_LAUI2_AOC_ACC |
-			   ICE_PHY_TYPE_LOW_50G_LAUI2 |
-			   ICE_PHY_TYPE_LOW_50G_AUI2_AOC_ACC |
-			   ICE_PHY_TYPE_LOW_50G_AUI2 |
-			   ICE_PHY_TYPE_LOW_50GBASE_CP |
-			   ICE_PHY_TYPE_LOW_50GBASE_SR |
-			   ICE_PHY_TYPE_LOW_50G_AUI1_AOC_ACC |
-			   ICE_PHY_TYPE_LOW_50G_AUI1;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     50000baseCR2_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_50GB,
-						50000baseCR2_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_50GBASE_KR2 |
-			   ICE_PHY_TYPE_LOW_50GBASE_KR_PAM4;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     50000baseKR2_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_50GB,
-						50000baseKR2_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_50GBASE_SR2 |
-			   ICE_PHY_TYPE_LOW_50GBASE_LR2 |
-			   ICE_PHY_TYPE_LOW_50GBASE_FR |
-			   ICE_PHY_TYPE_LOW_50GBASE_LR;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     50000baseSR2_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_50GB,
-						50000baseSR2_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_CR4 |
-			   ICE_PHY_TYPE_LOW_100G_CAUI4_AOC_ACC |
-			   ICE_PHY_TYPE_LOW_100G_CAUI4 |
-			   ICE_PHY_TYPE_LOW_100G_AUI4_AOC_ACC |
-			   ICE_PHY_TYPE_LOW_100G_AUI4 |
-			   ICE_PHY_TYPE_LOW_100GBASE_CR_PAM4;
-	phy_type_mask_hi = ICE_PHY_TYPE_HIGH_100G_CAUI2_AOC_ACC |
-			   ICE_PHY_TYPE_HIGH_100G_CAUI2 |
-			   ICE_PHY_TYPE_HIGH_100G_AUI2_AOC_ACC |
-			   ICE_PHY_TYPE_HIGH_100G_AUI2;
-	if (phy_types_low & phy_type_mask_lo ||
-	    phy_types_high & phy_type_mask_hi) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseCR4_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
-						100000baseCR4_Full);
-	}
-
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_CP2) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseCR2_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
-						100000baseCR2_Full);
-	}
-
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_SR4) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseSR4_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
-						100000baseSR4_Full);
-	}
-
-	if (phy_types_low & ICE_PHY_TYPE_LOW_100GBASE_SR2) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseSR2_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
-						100000baseSR2_Full);
-	}
-
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_LR4 |
-			   ICE_PHY_TYPE_LOW_100GBASE_DR;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseLR4_ER4_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
-						100000baseLR4_ER4_Full);
-	}
+	linkmode_zero(ks->link_modes.supported);
+	linkmode_zero(ks->link_modes.advertising);
 
-	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_KR4 |
-			   ICE_PHY_TYPE_LOW_100GBASE_KR_PAM4;
-	if (phy_types_low & phy_type_mask_lo) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseKR4_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
-						100000baseKR4_Full);
+	for (i = 0; i < BITS_PER_TYPE(u64); i++) {
+		if (phy_types_low & BIT_ULL(i))
+			ice_linkmode_set_bit(&phy_type_low_lkup[i], ks,
+					     req_speeds, advert_phy_type_lo,
+					     i);
 	}
 
-	if (phy_types_high & ICE_PHY_TYPE_HIGH_100GBASE_KR2_PAM4) {
-		ethtool_link_ksettings_add_link_mode(ks, supported,
-						     100000baseKR2_Full);
-		ice_ethtool_advertise_link_mode(ICE_AQ_LINK_SPEED_100GB,
-						100000baseKR2_Full);
+	for (i = 0; i < BITS_PER_TYPE(u64); i++) {
+		if (phy_types_high & BIT_ULL(i))
+			ice_linkmode_set_bit(&phy_type_high_lkup[i], ks,
+					     req_speeds, advert_phy_type_hi,
+					     i);
 	}
-
 }
 
 #define TEST_SET_BITS_TIMEOUT	50
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.h b/drivers/net/ethernet/intel/ice/ice_ethtool.h
new file mode 100644
index 000000000000..00043ea9469a
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2023 Intel Corporation */
+
+#ifndef _ICE_ETHTOOL_H_
+#define _ICE_ETHTOOL_H_
+
+struct ice_phy_type_to_ethtool {
+	u64 aq_link_speed;
+	u8 link_mode;
+};
+
+/* Macro to make PHY type to Ethtool link mode table entry.
+ * The index is the PHY type.
+ */
+#define ICE_PHY_TYPE(LINK_SPEED, ETHTOOL_LINK_MODE) {\
+	.aq_link_speed = ICE_AQ_LINK_SPEED_##LINK_SPEED, \
+	.link_mode = ETHTOOL_LINK_MODE_##ETHTOOL_LINK_MODE##_BIT, \
+}
+
+/* Lookup table mapping PHY type low to link speed and Ethtool link modes.
+ * Array index corresponds to HW PHY type bit, see
+ * ice_adminq_cmd.h:ICE_PHY_TYPE_LOW_*.
+ */
+static const struct ice_phy_type_to_ethtool
+phy_type_low_lkup[] = {
+	[0] = ICE_PHY_TYPE(100MB, 100baseT_Full),
+	[1] = ICE_PHY_TYPE(100MB, 100baseT_Full),
+	[2] = ICE_PHY_TYPE(1000MB, 1000baseT_Full),
+	[3] = ICE_PHY_TYPE(1000MB, 1000baseX_Full),
+	[4] = ICE_PHY_TYPE(1000MB, 1000baseX_Full),
+	[5] = ICE_PHY_TYPE(1000MB, 1000baseKX_Full),
+	[6] = ICE_PHY_TYPE(1000MB, 1000baseT_Full),
+	[7] = ICE_PHY_TYPE(2500MB, 2500baseT_Full),
+	[8] = ICE_PHY_TYPE(2500MB, 2500baseX_Full),
+	[9] = ICE_PHY_TYPE(2500MB, 2500baseX_Full),
+	[10] = ICE_PHY_TYPE(5GB, 5000baseT_Full),
+	[11] = ICE_PHY_TYPE(5GB, 5000baseT_Full),
+	[12] = ICE_PHY_TYPE(10GB, 10000baseT_Full),
+	[13] = ICE_PHY_TYPE(10GB, 10000baseT_Full),
+	[14] = ICE_PHY_TYPE(10GB, 10000baseSR_Full),
+	[15] = ICE_PHY_TYPE(10GB, 10000baseLR_Full),
+	[16] = ICE_PHY_TYPE(10GB, 10000baseKR_Full),
+	[17] = ICE_PHY_TYPE(10GB, 10000baseT_Full),
+	[18] = ICE_PHY_TYPE(10GB, 10000baseKR_Full),
+	[19] = ICE_PHY_TYPE(25GB, 25000baseCR_Full),
+	[20] = ICE_PHY_TYPE(25GB, 25000baseCR_Full),
+	[21] = ICE_PHY_TYPE(25GB, 25000baseCR_Full),
+	[22] = ICE_PHY_TYPE(25GB, 25000baseCR_Full),
+	[23] = ICE_PHY_TYPE(25GB, 25000baseSR_Full),
+	[24] = ICE_PHY_TYPE(25GB, 25000baseSR_Full),
+	[25] = ICE_PHY_TYPE(25GB, 25000baseKR_Full),
+	[26] = ICE_PHY_TYPE(25GB, 25000baseKR_Full),
+	[27] = ICE_PHY_TYPE(25GB, 25000baseKR_Full),
+	[28] = ICE_PHY_TYPE(25GB, 25000baseCR_Full),
+	[29] = ICE_PHY_TYPE(25GB, 25000baseKR_Full),
+	[30] = ICE_PHY_TYPE(40GB, 40000baseCR4_Full),
+	[31] = ICE_PHY_TYPE(40GB, 40000baseSR4_Full),
+	[32] = ICE_PHY_TYPE(40GB, 40000baseLR4_Full),
+	[33] = ICE_PHY_TYPE(40GB, 40000baseKR4_Full),
+	[34] = ICE_PHY_TYPE(40GB, 40000baseCR4_Full),
+	[35] = ICE_PHY_TYPE(40GB, 40000baseCR4_Full),
+	[36] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[37] = ICE_PHY_TYPE(50GB, 50000baseSR2_Full),
+	[38] = ICE_PHY_TYPE(50GB, 50000baseSR2_Full),
+	[39] = ICE_PHY_TYPE(50GB, 50000baseKR2_Full),
+	[40] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[41] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[42] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[43] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[44] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[45] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[46] = ICE_PHY_TYPE(50GB, 50000baseSR2_Full),
+	[47] = ICE_PHY_TYPE(50GB, 50000baseSR2_Full),
+	[48] = ICE_PHY_TYPE(50GB, 50000baseKR2_Full),
+	[49] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[50] = ICE_PHY_TYPE(50GB, 50000baseCR2_Full),
+	[51] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[52] = ICE_PHY_TYPE(100GB, 100000baseSR4_Full),
+	[53] = ICE_PHY_TYPE(100GB, 100000baseLR4_ER4_Full),
+	[54] = ICE_PHY_TYPE(100GB, 100000baseKR4_Full),
+	[55] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[56] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[57] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[58] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[59] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[60] = ICE_PHY_TYPE(100GB, 100000baseKR4_Full),
+	[61] = ICE_PHY_TYPE(100GB, 100000baseCR2_Full),
+	[62] = ICE_PHY_TYPE(100GB, 100000baseSR2_Full),
+	[63] = ICE_PHY_TYPE(100GB, 100000baseLR4_ER4_Full),
+};
+
+/* Lookup table mapping PHY type high to link speed and Ethtool link modes.
+ * Array index corresponds to HW PHY type bit, see
+ * ice_adminq_cmd.h:ICE_PHY_TYPE_HIGH_*
+ */
+static const struct ice_phy_type_to_ethtool
+phy_type_high_lkup[] = {
+	[0] = ICE_PHY_TYPE(100GB, 100000baseKR2_Full),
+	[1] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[2] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[3] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+	[4] = ICE_PHY_TYPE(100GB, 100000baseCR4_Full),
+};
+
+#endif /* !_ICE_ETHTOOL_H_ */
-- 
2.38.1


