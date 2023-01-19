Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03BE67450C
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjASVmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjASVji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:39:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F917573A
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674163687; x=1705699687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PNdEWtfV/IOIDN11xS4FhVxPE3EzXtB0AjI+ROBsuM4=;
  b=FuMlh7JDpzEeoZx4WhfZDB7+4iT/hb8m6JwHHQ2Arayj920SfeAqo6I0
   QU0Z+9nM5MTv2mVgGzbMF55dKS2gqdySkqL053/XI7jPmlX7umxgYvrXr
   J4eUjP8ixlUPedTXp2Rq16GdN+NrT972us9FUPrQ9aaXppNYLSANZoTjg
   XAgoTE4nnF43NBOIKlmzOI+lXM+ybyWUUGxneMfnL8Ns7Z+N8Ib9pUvDa
   9zhTExrHBMAzqiWDOi8EG2vQr80a5z2PPxOyjyrybLA26ni+uYQbgKdwZ
   FtCXKfXlzAi4LJ8dBpgIPOEzvpNhmeBT2fTDji2/MfcI78DGb+M4c6F1w
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="323120629"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="323120629"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:27:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692589886"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692589886"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 13:27:27 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next 07/15] ice: Add support for 100G KR2/CR2/SR2 link reporting
Date:   Thu, 19 Jan 2023 13:27:34 -0800
Message-Id: <20230119212742.2106833-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
References: <20230119212742.2106833-1-anthony.l.nguyen@intel.com>
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
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 41 +++++++++++++++-----
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 4191994d8f3a..42ff621f9c68 100644
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
@@ -1964,15 +1963,27 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
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
+	}
+
 	phy_type_mask_lo = ICE_PHY_TYPE_LOW_100GBASE_LR4 |
 			   ICE_PHY_TYPE_LOW_100GBASE_DR;
 	if (phy_types_low & phy_type_mask_lo) {
@@ -1984,14 +1995,20 @@ ice_phy_type_to_ethtool(struct net_device *netdev,
 
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
@@ -2299,7 +2316,13 @@ ice_ksettings_find_adv_link_speed(const struct ethtool_link_ksettings *ks)
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
2.38.1

