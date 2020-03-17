Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B09F188CC2
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 19:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgCQSFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 14:05:10 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40982 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgCQSFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 14:05:09 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02HI52nK050812;
        Tue, 17 Mar 2020 13:05:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584468302;
        bh=YofixRqwe1BNBkGZC9BZ90T1HPwUITfs1WErunM/8Lk=;
        h=From:To:CC:Subject:Date;
        b=VqAW07HtTKnr7z/tQjQ7aguu/D9U7LHk3wbhAG151N2y6+FZnStU4yzMYoWFKfM85
         6Gp+WMtQBeldpMkmRRvWgTnBGKg3IKyAHY3xRv78TEp7yi0uKyTShevvJgk1ZuRqh+
         hGNdTlvcDtM1XQ1YMVqmJmgjjELW/fl3/1nFdxWM=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02HI52Sb033236;
        Tue, 17 Mar 2020 13:05:02 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Mar 2020 13:05:02 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Mar 2020 13:05:02 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02HI51k9027444;
        Tue, 17 Mar 2020 13:05:02 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     netdev <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: phy: dp83867: w/a for fld detect threshold bootstrapping issue
Date:   Tue, 17 Mar 2020 20:04:54 +0200
Message-ID: <20200317180454.22393-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the DP83867 PHY is strapped to enable Fast Link Drop (FLD) feature
STRAP_STS2.STRAP_ FLD (reg 0x006F bit 10), the Energy Lost Threshold for
FLD Energy Lost Mode FLD_THR_CFG.ENERGY_LOST_FLD_THR (reg 0x002e bits 2:0)
will be defaulted to 0x2. This may cause the phy link to be unstable. The
new DP83867 DM recommends to always restore ENERGY_LOST_FLD_THR to 0x1.

Hence, restore default value of FLD_THR_CFG.ENERGY_LOST_FLD_THR to 0x1 when
FLD is enabled by bootstrapping as recommended by DM.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/phy/dp83867.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 13f7f2d5a2ea..b55e3c0403ed 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -30,7 +30,8 @@
 #define DP83867_CTRL		0x1f
 
 /* Extended Registers */
-#define DP83867_CFG4            0x0031
+#define DP83867_FLD_THR_CFG	0x002e
+#define DP83867_CFG4		0x0031
 #define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
 #define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
 #define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
@@ -93,6 +94,7 @@
 #define DP83867_STRAP_STS2_CLK_SKEW_RX_MASK	GENMASK(2, 0)
 #define DP83867_STRAP_STS2_CLK_SKEW_RX_SHIFT	0
 #define DP83867_STRAP_STS2_CLK_SKEW_NONE	BIT(2)
+#define DP83867_STRAP_STS2_STRAP_FLD		BIT(10)
 
 /* PHY CTRL bits */
 #define DP83867_PHYCR_TX_FIFO_DEPTH_SHIFT	14
@@ -145,6 +147,9 @@
 /* CFG4 bits */
 #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
 
+/* FLD_THR_CFG */
+#define DP83867_FLD_THR_CFG_ENERGY_LOST_THR_MASK	0x7
+
 enum {
 	DP83867_PORT_MIRROING_KEEP,
 	DP83867_PORT_MIRROING_EN,
@@ -622,6 +627,20 @@ static int dp83867_config_init(struct phy_device *phydev)
 		phy_clear_bits_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4,
 				   BIT(7));
 
+	bs = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_STRAP_STS2);
+	if (bs & DP83867_STRAP_STS2_STRAP_FLD) {
+		/* When using strap to enable FLD, the ENERGY_LOST_FLD_THR will
+		 * be set to 0x2. This may causes the PHY link to be unstable -
+		 * the default value 0x1 need to be restored.
+		 */
+		ret = phy_modify_mmd(phydev, DP83867_DEVADDR,
+				     DP83867_FLD_THR_CFG,
+				     DP83867_FLD_THR_CFG_ENERGY_LOST_THR_MASK,
+				     0x1);
+		if (ret)
+			return ret;
+	}
+
 	if (phy_interface_is_rgmii(phydev) ||
 	    phydev->interface == PHY_INTERFACE_MODE_SGMII) {
 		val = phy_read(phydev, MII_DP83867_PHYCTRL);
-- 
2.17.1

