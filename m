Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796363EB2FA
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 10:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239854AbhHMIxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 04:53:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:2002 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239452AbhHMIxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 04:53:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215257493"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="215257493"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 01:52:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="639759669"
Received: from siang-ilbpg0.png.intel.com ([10.88.227.28])
  by orsmga005.jf.intel.com with ESMTP; 13 Aug 2021 01:52:33 -0700
From:   Song Yoong Siang <yoong.siang.song@intel.com>
To:     Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support to WOL event
Date:   Fri, 13 Aug 2021 16:45:36 +0800
Message-Id: <20210813084536.182381-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Wake-on-PHY feature support by enabling the Link Status Changed
interrupt.

Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 drivers/net/phy/marvell10g.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 0b7cae118ad7..d46761c225f0 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -76,6 +76,11 @@ enum {
 	MV_PCS_CSSR1_SPD2_2500	= 0x0004,
 	MV_PCS_CSSR1_SPD2_10000	= 0x0000,
 
+	/* Copper Specific Interrupt registers */
+	MV_PCS_INTR_ENABLE	= 0x8010,
+	MV_PCS_INTR_ENABLE_LSC	= BIT(10),
+	MV_PCS_INTR_STS		= 0x8011,
+
 	/* Temperature read register (88E2110 only) */
 	MV_PCS_TEMP		= 0x8042,
 
@@ -1036,7 +1041,7 @@ static void mv3110_get_wol(struct phy_device *phydev,
 {
 	int ret;
 
-	wol->supported = WAKE_MAGIC;
+	wol->supported = WAKE_MAGIC | WAKE_PHY;
 	wol->wolopts = 0;
 
 	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_WOL_CTRL);
@@ -1045,6 +1050,13 @@ static void mv3110_get_wol(struct phy_device *phydev,
 
 	if (ret & MV_V2_WOL_CTRL_MAGIC_PKT_EN)
 		wol->wolopts |= WAKE_MAGIC;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_INTR_ENABLE);
+	if (ret < 0)
+		return;
+
+	if (ret & MV_PCS_INTR_ENABLE_LSC)
+		wol->wolopts |= WAKE_PHY;
 }
 
 static int mv3110_set_wol(struct phy_device *phydev,
@@ -1099,6 +1111,25 @@ static int mv3110_set_wol(struct phy_device *phydev,
 			return ret;
 	}
 
+	if (wol->wolopts & WAKE_PHY) {
+		/* Enable the link status changed interrupt */
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS,
+				       MV_PCS_INTR_ENABLE,
+				       MV_PCS_INTR_ENABLE_LSC);
+		if (ret < 0)
+			return ret;
+
+		/* Clear the interrupt status register */
+		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_INTR_STS);
+	} else {
+		/* Disable the link status changed interrupt */
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_PCS,
+					 MV_PCS_INTR_ENABLE,
+					 MV_PCS_INTR_ENABLE_LSC);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* Reset the clear WOL status bit as it does not self-clear */
 	return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
 				  MV_V2_WOL_CTRL,
-- 
2.25.1

