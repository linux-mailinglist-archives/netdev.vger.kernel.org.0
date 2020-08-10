Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41292412D0
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 00:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgHJWGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 18:06:49 -0400
Received: from mail.nic.cz ([217.31.204.67]:42732 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgHJWGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 18:06:48 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id CFA0B140A43;
        Tue, 11 Aug 2020 00:06:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597097206; bh=TkyvAiderS6Hjp7zIPks+TkJnVzjVZ0NAddGtON8TW0=;
        h=From:To:Date;
        b=wvjMBWBdS5QGlMMFRVVweAmO3Gn9n06/Ho41cUgK5JM139pYFkJkaIIH9fDAoUOcx
         cgNv4i/XrJ9dEg+E8Og7F7PeToOR5bV2a85h0NknV97h2thZ+XVBvTQj3jm4W2Flnx
         GFY5hCGKuazAies5YNTOiwNZaXE3ssNsn9zQvhcs=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change MACTYPE according to phydev->interface
Date:   Tue, 11 Aug 2020 00:06:44 +0200
Message-Id: <20200810220645.19326-4-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200810220645.19326-1-marek.behun@nic.cz>
References: <20200810220645.19326-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RollBall SFPs contain Marvell 88X3310 PHY, but they have configuration
pins strapped so that MACTYPE is configured in XFI with Rate Matching
mode.

When these SFPs are inserted into a device which only supports lower
speeds on host interface, we need to configure the MACTYPE to a mode
in which the H unit changes SerDes speed according to speed on the
copper interface. I chose to use the
10GBASE-R/5GBASE-R/2500BASE-X/SGMII with AN mode.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/phy/marvell10g.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 29575442b25b2..13a588fa69e77 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -81,6 +81,7 @@ enum {
 	MV_V2_PORT_CTRL_SWRST	= BIT(15),
 	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
 	MV_V2_PORT_MAC_TYPE_MASK = 0x7,
+	MV_V2_PORT_MAC_TYPE_10GBR_SGMII_AN = 0x4,
 	MV_V2_PORT_MAC_TYPE_RATE_MATCH = 0x6,
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
@@ -258,17 +259,40 @@ static int mv3310_power_down(struct phy_device *phydev)
 static int mv3310_power_up(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	u16 val, mask;
 	int ret;
 
 	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
 				 MV_V2_PORT_CTRL_PWRDOWN);
 
-	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310 ||
-	    priv->firmware_ver < 0x00030000)
+	if (ret < 0)
 		return ret;
 
-	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
-				MV_V2_PORT_CTRL_SWRST);
+	/* TODO: add support for changing MACTYPE on 88E2110 via register 1.C0A4.2:0 */
+	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
+		return 0;
+
+	val = mask = MV_V2_PORT_CTRL_SWRST;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		val |= MV_V2_PORT_MAC_TYPE_10GBR_SGMII_AN;
+		mask |= MV_V2_PORT_MAC_TYPE_MASK;
+		break;
+
+	default:
+		/* Otherwise we assume that the MACTYPE is set correctly by strapping pins.
+		 * Feel free to add support for changing MACTYPE for other modes
+		 * (XAUI/RXAUI/USXGMII).
+		 */
+
+		/* reset is not needed for firmware version < 0.3.0.0 when not changing MACTYPE */
+		if (priv->firmware_ver < 0x00030000)
+			return 0;
+	}
+
+	return phy_modify_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL, mask, val);
 }
 
 static int mv3310_reset(struct phy_device *phydev, u32 unit)
-- 
2.26.2

