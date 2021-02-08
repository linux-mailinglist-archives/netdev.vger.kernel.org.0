Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC46B3141F6
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbhBHVgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:36:51 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:44497 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236505AbhBHVgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 16:36:39 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 679C423E5F;
        Mon,  8 Feb 2021 22:35:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612820140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UfrI+GcaHGiqs+S+5NHCQt7ZC3BRv0+EfSOAV5ChAMk=;
        b=Md1shnpXmQkSrdWpF3eY3218AkgmQKTPx49fR0WVGq4taSF0LwVknNdD6oeg5eSimhlK+i
        BjYA0//QqtNd+ikU4ZbrtPrlIcD8MnhPzLVli63ct0B47bF5mwHCQgamxgjEfWCpHyJR4k
        yV+NEdUMK0z26iEARjIeIgVjXwvBBZc=
From:   Michael Walle <michael@walle.cc>
To:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH] net: phy: broadcom: remove BCM5482 1000BX support
Date:   Mon,  8 Feb 2021 22:35:29 +0100
Message-Id: <20210208213529.28481-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is nowhere used in the kernel. It also seems to be lacking the
proper fiber advertise flags. Remove it.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/broadcom.c | 93 +-------------------------------------
 1 file changed, 1 insertion(+), 92 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 8a4ec3222168..3142ba768313 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -361,96 +361,6 @@ static int bcm54811_config_init(struct phy_device *phydev)
 	return err;
 }
 
-static int bcm5482_config_init(struct phy_device *phydev)
-{
-	int err, reg;
-
-	err = bcm54xx_config_init(phydev);
-
-	if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX) {
-		/*
-		 * Enable secondary SerDes and its use as an LED source
-		 */
-		reg = bcm_phy_read_shadow(phydev, BCM5482_SHD_SSD);
-		bcm_phy_write_shadow(phydev, BCM5482_SHD_SSD,
-				     reg |
-				     BCM5482_SHD_SSD_LEDM |
-				     BCM5482_SHD_SSD_EN);
-
-		/*
-		 * Enable SGMII slave mode and auto-detection
-		 */
-		reg = BCM5482_SSD_SGMII_SLAVE | MII_BCM54XX_EXP_SEL_SSD;
-		err = bcm_phy_read_exp(phydev, reg);
-		if (err < 0)
-			return err;
-		err = bcm_phy_write_exp(phydev, reg, err |
-					BCM5482_SSD_SGMII_SLAVE_EN |
-					BCM5482_SSD_SGMII_SLAVE_AD);
-		if (err < 0)
-			return err;
-
-		/*
-		 * Disable secondary SerDes powerdown
-		 */
-		reg = BCM5482_SSD_1000BX_CTL | MII_BCM54XX_EXP_SEL_SSD;
-		err = bcm_phy_read_exp(phydev, reg);
-		if (err < 0)
-			return err;
-		err = bcm_phy_write_exp(phydev, reg,
-					err & ~BCM5482_SSD_1000BX_CTL_PWRDOWN);
-		if (err < 0)
-			return err;
-
-		/*
-		 * Select 1000BASE-X register set (primary SerDes)
-		 */
-		reg = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
-		bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE,
-				     reg | BCM54XX_SHD_MODE_1000BX);
-
-		/*
-		 * LED1=ACTIVITYLED, LED3=LINKSPD[2]
-		 * (Use LED1 as secondary SerDes ACTIVITY LED)
-		 */
-		bcm_phy_write_shadow(phydev, BCM5482_SHD_LEDS1,
-			BCM5482_SHD_LEDS1_LED1(BCM_LED_SRC_ACTIVITYLED) |
-			BCM5482_SHD_LEDS1_LED3(BCM_LED_SRC_LINKSPD2));
-
-		/*
-		 * Auto-negotiation doesn't seem to work quite right
-		 * in this mode, so we disable it and force it to the
-		 * right speed/duplex setting.  Only 'link status'
-		 * is important.
-		 */
-		phydev->autoneg = AUTONEG_DISABLE;
-		phydev->speed = SPEED_1000;
-		phydev->duplex = DUPLEX_FULL;
-	}
-
-	return err;
-}
-
-static int bcm5482_read_status(struct phy_device *phydev)
-{
-	int err;
-
-	err = genphy_read_status(phydev);
-
-	if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX) {
-		/*
-		 * Only link status matters for 1000Base-X mode, so force
-		 * 1000 Mbit/s full-duplex status
-		 */
-		if (phydev->link) {
-			phydev->speed = SPEED_1000;
-			phydev->duplex = DUPLEX_FULL;
-		}
-	}
-
-	return err;
-}
-
 static int bcm5481_config_aneg(struct phy_device *phydev)
 {
 	struct device_node *np = phydev->mdio.dev.of_node;
@@ -800,8 +710,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM5482",
 	/* PHY_GBIT_FEATURES */
-	.config_init	= bcm5482_config_init,
-	.read_status	= bcm5482_read_status,
+	.config_init	= bcm54xx_config_init,
 	.config_intr	= bcm_phy_config_intr,
 	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
-- 
2.20.1

