Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DDD3EB2F6
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 10:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbhHMIwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 04:52:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:46852 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239327AbhHMIwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 04:52:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="202720766"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="202720766"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 01:52:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="422174640"
Received: from siang-ilbpg0.png.intel.com ([10.88.227.28])
  by orsmga006.jf.intel.com with ESMTP; 13 Aug 2021 01:52:02 -0700
From:   Song Yoong Siang <yoong.siang.song@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net-next 1/1] net: phy: marvell: Add WAKE_PHY support to WOL event
Date:   Fri, 13 Aug 2021 16:45:08 +0800
Message-Id: <20210813084508.182333-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Wake-on-PHY feature support by enabling the Link Up Event.

Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 drivers/net/phy/marvell.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 3de93c9f2744..415e2a01c151 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -155,6 +155,7 @@
 
 #define MII_88E1318S_PHY_WOL_CTRL				0x10
 #define MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS		BIT(12)
+#define MII_88E1318S_PHY_WOL_CTRL_LINK_UP_ENABLE		BIT(13)
 #define MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE	BIT(14)
 
 #define MII_PHY_LED_CTRL	        16
@@ -1746,13 +1747,19 @@ static void m88e1318_get_wol(struct phy_device *phydev,
 {
 	int ret;
 
-	wol->supported = WAKE_MAGIC;
+	wol->supported = WAKE_MAGIC | WAKE_PHY;
 	wol->wolopts = 0;
 
 	ret = phy_read_paged(phydev, MII_MARVELL_WOL_PAGE,
 			     MII_88E1318S_PHY_WOL_CTRL);
-	if (ret >= 0 && ret & MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE)
+	if (ret < 0)
+		return;
+
+	if (ret & MII_88E1318S_PHY_WOL_CTRL_MAGIC_PACKET_MATCH_ENABLE)
 		wol->wolopts |= WAKE_MAGIC;
+
+	if (ret & MII_88E1318S_PHY_WOL_CTRL_LINK_UP_ENABLE)
+		wol->wolopts |= WAKE_PHY;
 }
 
 static int m88e1318_set_wol(struct phy_device *phydev,
@@ -1764,7 +1771,7 @@ static int m88e1318_set_wol(struct phy_device *phydev,
 	if (oldpage < 0)
 		goto error;
 
-	if (wol->wolopts & WAKE_MAGIC) {
+	if (wol->wolopts & (WAKE_MAGIC | WAKE_PHY)) {
 		/* Explicitly switch to page 0x00, just to be sure */
 		err = marvell_write_page(phydev, MII_MARVELL_COPPER_PAGE);
 		if (err < 0)
@@ -1796,7 +1803,9 @@ static int m88e1318_set_wol(struct phy_device *phydev,
 				   MII_88E1318S_PHY_LED_TCR_INT_ACTIVE_LOW);
 		if (err < 0)
 			goto error;
+	}
 
+	if (wol->wolopts & WAKE_MAGIC) {
 		err = marvell_write_page(phydev, MII_MARVELL_WOL_PAGE);
 		if (err < 0)
 			goto error;
@@ -1837,6 +1846,30 @@ static int m88e1318_set_wol(struct phy_device *phydev,
 			goto error;
 	}
 
+	if (wol->wolopts & WAKE_PHY) {
+		err = marvell_write_page(phydev, MII_MARVELL_WOL_PAGE);
+		if (err < 0)
+			goto error;
+
+		/* Clear WOL status and enable link up event */
+		err = __phy_modify(phydev, MII_88E1318S_PHY_WOL_CTRL, 0,
+				   MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS |
+				   MII_88E1318S_PHY_WOL_CTRL_LINK_UP_ENABLE);
+		if (err < 0)
+			goto error;
+	} else {
+		err = marvell_write_page(phydev, MII_MARVELL_WOL_PAGE);
+		if (err < 0)
+			goto error;
+
+		/* Clear WOL status and disable link up event */
+		err = __phy_modify(phydev, MII_88E1318S_PHY_WOL_CTRL,
+				   MII_88E1318S_PHY_WOL_CTRL_LINK_UP_ENABLE,
+				   MII_88E1318S_PHY_WOL_CTRL_CLEAR_WOL_STATUS);
+		if (err < 0)
+			goto error;
+	}
+
 error:
 	return phy_restore_page(phydev, oldpage, err);
 }
-- 
2.25.1

