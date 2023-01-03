Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E85A65CA27
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 00:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbjACXGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 18:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbjACXGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 18:06:12 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247FE140F4
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 15:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672787171; x=1704323171;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=djNf3kCJHdpZIgfqUs89dsIfvDo01J2jfd+GutlOemw=;
  b=EoUJVrLENXdLdJYxD3ME/xn0Tf+zED06LCH2YFBbv7CDnQsm9lvlryJi
   HiLsAv6acFtFSVpYU3/AT8CLWcYawhngByqt+bu+yxQCgWYkVGjL94SXT
   bIisVYZI3YeimSdG6gt76VgpJp3Y8FQwHz8z5VnjsMj2ilMLbPAyPBd5M
   9CbUuwBtU5KLSFFNUuIQsZDA1+YiD1Pxa+cF4KjOUWqwTv3XhdH9FvsHM
   75/bKIWKhRSI68sozCRCtqJnB9Q5cTPQ20DaQO1Ad8FMhpAP3l/NiQ9ek
   xSHPABKQpe6y6pJ36EeJN9g1biQ9S4R42cgmHbbvB4+4BdHLC/zTIS8Ah
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="302152478"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="302152478"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 15:06:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="797330131"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="797330131"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jan 2023 15:06:09 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jamie Gloudon <jamie.gloudon@gmx.fr>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 1/1] e1000e: Enable Link Partner Advertised Support
Date:   Tue,  3 Jan 2023 15:06:53 -0800
Message-Id: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

From: Jamie Gloudon <jamie.gloudon@gmx.fr>

This enables link partner advertised support to show link modes and
pause frame use.

Signed-off-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c | 10 +++++++++-
 drivers/net/ethernet/intel/e1000e/phy.c     |  9 +++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 59e82d131d88..721f86fd5802 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -110,9 +110,9 @@ static const char e1000_gstrings_test[][ETH_GSTRING_LEN] = {
 static int e1000_get_link_ksettings(struct net_device *netdev,
 				    struct ethtool_link_ksettings *cmd)
 {
+	u32 speed, supported, advertising, lp_advertising, lpa_t;
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
-	u32 speed, supported, advertising;
 
 	if (hw->phy.media_type == e1000_media_type_copper) {
 		supported = (SUPPORTED_10baseT_Half |
@@ -120,7 +120,9 @@ static int e1000_get_link_ksettings(struct net_device *netdev,
 			     SUPPORTED_100baseT_Half |
 			     SUPPORTED_100baseT_Full |
 			     SUPPORTED_1000baseT_Full |
+			     SUPPORTED_Asym_Pause |
 			     SUPPORTED_Autoneg |
+			     SUPPORTED_Pause |
 			     SUPPORTED_TP);
 		if (hw->phy.type == e1000_phy_ife)
 			supported &= ~SUPPORTED_1000baseT_Full;
@@ -192,10 +194,16 @@ static int e1000_get_link_ksettings(struct net_device *netdev,
 	if (hw->phy.media_type != e1000_media_type_copper)
 		cmd->base.eth_tp_mdix_ctrl = ETH_TP_MDI_INVALID;
 
+	lpa_t = mii_stat1000_to_ethtool_lpa_t(adapter->phy_regs.stat1000);
+	lp_advertising = lpa_t |
+	mii_lpa_to_ethtool_lpa_t(adapter->phy_regs.lpa);
+
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
 						supported);
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
 						advertising);
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.lp_advertising,
+						lp_advertising);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index 060b263348ce..08c3d477dd6f 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 1999 - 2018 Intel Corporation. */
 
 #include "e1000.h"
+#include <linux/ethtool.h>
 
 static s32 e1000_wait_autoneg(struct e1000_hw *hw);
 static s32 e1000_access_phy_wakeup_reg_bm(struct e1000_hw *hw, u32 offset,
@@ -1011,6 +1012,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
 		 */
 		mii_autoneg_adv_reg &=
 		    ~(ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
+		phy->autoneg_advertised &=
+		    ~(ADVERTISED_Pause | ADVERTISED_Asym_Pause);
 		break;
 	case e1000_fc_rx_pause:
 		/* Rx Flow control is enabled, and Tx Flow control is
@@ -1024,6 +1027,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
 		 */
 		mii_autoneg_adv_reg |=
 		    (ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
+		phy->autoneg_advertised |=
+		    (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
 		break;
 	case e1000_fc_tx_pause:
 		/* Tx Flow control is enabled, and Rx Flow control is
@@ -1031,6 +1036,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
 		 */
 		mii_autoneg_adv_reg |= ADVERTISE_PAUSE_ASYM;
 		mii_autoneg_adv_reg &= ~ADVERTISE_PAUSE_CAP;
+		phy->autoneg_advertised |= ADVERTISED_Asym_Pause;
+		phy->autoneg_advertised &= ~ADVERTISED_Pause;
 		break;
 	case e1000_fc_full:
 		/* Flow control (both Rx and Tx) is enabled by a software
@@ -1038,6 +1045,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
 		 */
 		mii_autoneg_adv_reg |=
 		    (ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
+		phy->autoneg_advertised |=
+		    (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
 		break;
 	default:
 		e_dbg("Flow control param set incorrectly\n");
-- 
2.38.1

