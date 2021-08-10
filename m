Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD8F3E5A84
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240996AbhHJM47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240971AbhHJM47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:56:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3C0C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 05:56:37 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mDRIs-0004SR-8w; Tue, 10 Aug 2021 14:56:22 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mDRIp-0005Hh-Qu; Tue, 10 Aug 2021 14:56:19 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>,
        linux-hwmon@vger.kernel.org
Subject: [PATCH net-next v1] net: phy: nxp-tja11xx: log critical health state
Date:   Tue, 10 Aug 2021 14:56:18 +0200
Message-Id: <20210810125618.20255-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TJA1102 provides interrupt notification for the critical health states
like overtemperature and undervoltage.

The overtemperature bit is set if package temperature is beyond 155C°.
This functionality was tested by heating the package up to 200C°

The undervoltage bit is set if supply voltage drops beyond some critical
threshold. Currently not tested.

In a typical use case, both of this events should be logged and stored
(or send to some remote system) for further investigations.

To make testing and troubleshooting more easier, other bits are exported
over the ethtool phy stats interface:
- level of overtemperature. There is no access to thermal sensor.
- power supply line where undervoltage was detected

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/nxp-tja11xx.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index afd7afa1f498..4c37b427a53b 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -47,12 +47,14 @@
 #define MII_INTSRC_LINK_FAIL		BIT(10)
 #define MII_INTSRC_LINK_UP		BIT(9)
 #define MII_INTSRC_MASK			(MII_INTSRC_LINK_FAIL | MII_INTSRC_LINK_UP)
-#define MII_INTSRC_TEMP_ERR		BIT(1)
 #define MII_INTSRC_UV_ERR		BIT(3)
+#define MII_INTSRC_TEMP_ERR		BIT(1)
 
 #define MII_INTEN			22
 #define MII_INTEN_LINK_FAIL		BIT(10)
 #define MII_INTEN_LINK_UP		BIT(9)
+#define MII_INTEN_UV_ERR		BIT(3)
+#define MII_INTEN_TEMP_ERR		BIT(1)
 
 #define MII_COMMSTAT			23
 #define MII_COMMSTAT_LINK_UP		BIT(15)
@@ -89,6 +91,12 @@ static struct tja11xx_phy_stats tja11xx_hw_stats[] = {
 	{ "phy_polarity_detect", 25, 6, BIT(6) },
 	{ "phy_open_detect", 25, 7, BIT(7) },
 	{ "phy_short_detect", 25, 8, BIT(8) },
+	{ "phy_temp_warn (temp > 155C°)", 25, 9, BIT(9) },
+	{ "phy_temp_high (temp > 180C°)", 25, 10, BIT(10) },
+	{ "phy_uv_vddio", 25, 11, BIT(11) },
+	{ "phy_uv_vddd_1v8", 25, 13, BIT(13) },
+	{ "phy_uv_vdda_3v3", 25, 14, BIT(14) },
+	{ "phy_uv_vddd_3v3", 25, 15, BIT(15) },
 	{ "phy_rem_rcvr_count", 26, 0, GENMASK(7, 0) },
 	{ "phy_loc_rcvr_count", 26, 8, GENMASK(15, 8) },
 };
@@ -607,7 +615,8 @@ static int tja11xx_config_intr(struct phy_device *phydev)
 		if (err)
 			return err;
 
-		value = MII_INTEN_LINK_FAIL | MII_INTEN_LINK_UP;
+		value = MII_INTEN_LINK_FAIL | MII_INTEN_LINK_UP |
+			MII_INTEN_UV_ERR | MII_INTEN_TEMP_ERR;
 		err = phy_write(phydev, MII_INTEN, value);
 	} else {
 		err = phy_write(phydev, MII_INTEN, value);
@@ -622,6 +631,7 @@ static int tja11xx_config_intr(struct phy_device *phydev)
 
 static irqreturn_t tja11xx_handle_interrupt(struct phy_device *phydev)
 {
+	struct device *dev = &phydev->mdio.dev;
 	int irq_status;
 
 	irq_status = phy_read(phydev, MII_INTSRC);
@@ -630,6 +640,11 @@ static irqreturn_t tja11xx_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
+	if (irq_status & MII_INTSRC_TEMP_ERR)
+		dev_err(dev, "Overtemperature error detected (temp > 155C°).\n");
+	if (irq_status & MII_INTSRC_UV_ERR)
+		dev_err(dev, "Undervoltage error detected.\n");
+
 	if (!(irq_status & MII_INTSRC_MASK))
 		return IRQ_NONE;
 
-- 
2.30.2

