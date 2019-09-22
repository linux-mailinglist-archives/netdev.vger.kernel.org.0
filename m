Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C164BA1EE
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 13:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbfIVLAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 07:00:34 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35636 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbfIVLAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 07:00:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zlSgHImzNO8B75aIQlOOUK6+Gg6VBx7s/SKp+BoNcr0=; b=BsmbADOI14CzEVdHzxoSnPZjiK
        klMWmZYicUYL7lRCqJ0jgIV9pTzrJA04tpNq/pfqEhM+nh4clBWJulCnAyVBZH4+CIYpGb0q5Sst7
        27Yn7UnIYs8DwY84zp/LnxTdGoReZGeuGa1ab7VOuxWnBljU0MJQ8gywM/1b0XiJQCseTqK6sDim6
        oGA1NLHCvKpJOFAOJafA/dMUStYpUUa/MZyj9Yq2kgqUsS7lwggDxAQzdh0eVHOgxvtzsMIFmj8Bt
        xJz8Q99STE8qcsEIxu/oHjOhPJWss50kyDNZoU8pbpNLYFWF/Wggd4zOjGX54zJVpYW37VasqH4k6
        CXizSqfQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34018 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iBzbP-0006b6-A7; Sun, 22 Sep 2019 12:00:27 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iBzbN-00007N-U4; Sun, 22 Sep 2019 12:00:25 +0100
In-Reply-To: <20190922105932.GP25745@shell.armlinux.org.uk>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 4/4] net: phy: at803x: use operating parameters from
 PHY-specific status
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iBzbN-00007N-U4@rmk-PC.armlinux.org.uk>
Date:   Sun, 22 Sep 2019 12:00:25 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Read the PHY-specific status register for the current operating mode
(speed and duplex) of the PHY.  This register reflects the actual
mode that the PHY has resolved depending on either the advertisements
of autoneg is enabled, or the forced mode if autoneg is disabled.

This ensures that phylib's software state always tracks the hardware
state.

It seems both AR8033 (which uses the AR8031 ID) and AR8035 support
this status register.  AR8030 is not known at the present time.

Reported-by: tinywrkb <tinywrkb@gmail.com>
Fixes: 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/at803x.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index b3893347804d..7dca170fdd80 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -16,6 +16,15 @@
 #include <linux/of_gpio.h>
 #include <linux/gpio/consumer.h>
 
+#define AT803X_SPECIFIC_STATUS			0x11
+#define AT803X_SS_SPEED_MASK			(3 << 14)
+#define AT803X_SS_SPEED_1000			(2 << 14)
+#define AT803X_SS_SPEED_100			(1 << 14)
+#define AT803X_SS_SPEED_10			(0 << 14)
+#define AT803X_SS_DUPLEX			BIT(13)
+#define AT803X_SS_SPEED_DUPLEX_RESOLVED		BIT(11)
+#define AT803X_SS_MDIX				BIT(6)
+
 #define AT803X_INTR_ENABLE			0x12
 #define AT803X_INTR_ENABLE_AUTONEG_ERR		BIT(15)
 #define AT803X_INTR_ENABLE_SPEED_CHANGED	BIT(14)
@@ -404,6 +413,64 @@ static int at803x_aneg_done(struct phy_device *phydev)
 	return aneg_done;
 }
 
+static int at803x_read_status(struct phy_device *phydev)
+{
+	int ss, err, old_link = phydev->link;
+
+	/* Update the link, but return if there was an error */
+	err = genphy_update_link(phydev);
+	if (err)
+		return err;
+
+	/* why bother the PHY if nothing can have changed */
+	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
+		return 0;
+
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	err = genphy_read_lpa(phydev);
+	if (err < 0)
+		return err;
+
+	/* Read the AT8035 PHY-Specific Status register, which indicates the
+	 * speed and duplex that the PHY is actually using, irrespective of
+	 * whether we are in autoneg mode or not.
+	 */
+	ss = phy_read(phydev, AT803X_SPECIFIC_STATUS);
+	if (ss < 0)
+		return ss;
+
+	if (ss & AT803X_SS_SPEED_DUPLEX_RESOLVED) {
+		switch (ss & AT803X_SS_SPEED_MASK) {
+		case AT803X_SS_SPEED_10:
+			phydev->speed = SPEED_10;
+			break;
+		case AT803X_SS_SPEED_100:
+			phydev->speed = SPEED_100;
+			break;
+		case AT803X_SS_SPEED_1000:
+			phydev->speed = SPEED_1000;
+			break;
+		}
+		if (ss & AT803X_SS_DUPLEX)
+			phydev->duplex = DUPLEX_FULL;
+		else
+			phydev->duplex = DUPLEX_HALF;
+		if (ss & AT803X_SS_MDIX)
+			phydev->mdix = ETH_TP_MDI_X;
+		else
+			phydev->mdix = ETH_TP_MDI;
+	}
+
+	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete)
+		phy_resolve_aneg_pause(phydev);
+
+	return 0;
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* ATHEROS 8035 */
@@ -417,6 +484,7 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_GBIT_FEATURES */
+	.read_status		= at803x_read_status,
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 	.get_eee		= at8035_get_eee,
@@ -447,6 +515,7 @@ static struct phy_driver at803x_driver[] = {
 	.suspend		= at803x_suspend,
 	.resume			= at803x_resume,
 	/* PHY_GBIT_FEATURES */
+	.read_status		= at803x_read_status,
 	.aneg_done		= at803x_aneg_done,
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
-- 
2.7.4

