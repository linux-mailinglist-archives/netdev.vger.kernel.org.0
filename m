Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B322D177B24
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgCCPyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:54:17 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37772 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgCCPyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:54:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gSmcSrVvZ6EvOgTJ2reGeLbxzBIDALzRNL1B98xEHBE=; b=BaIytfBcOvbLxI6LF9jT3MBTbV
        FSW0IcZHFwAJUvDuWwJXEh/2B487nt3M5aMZ+zIeJo5/mHyVifhzysjbIym1SwFYR42Vo7qjmp3pM
        /a1XntjdhZNhyaesf81BJUMao6+HSJYKtybffXPLSS66du74uPKCHh+B86ikGG1n09rEQ7oRGuI3H
        Icd/YCe3lh+aO4OqxV0w+1IUTjJjMNTdn6DaxqmVBIwDB8LtkqVLFBu/XE2LGzu69AetwQsVgujsM
        OnwZO8vdAGOeMSH38vgCQLb4yNtKSpccpRIXvMjC68WyTAwgDBwWa8cXzB9+Ic6MMH/k+qMkaZ/G5
        JIMFv42Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:34042 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j99s2-0000Tz-Bm; Tue, 03 Mar 2020 15:54:10 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j99s1-00011Q-RB; Tue, 03 Mar 2020 15:54:09 +0000
In-Reply-To: <20200303155347.GS25745@shell.armlinux.org.uk>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/3] net: phy: marvell10g: add mdix control
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j99s1-00011Q-RB@rmk-PC.armlinux.org.uk>
Date:   Tue, 03 Mar 2020 15:54:09 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for controlling the MDI-X state of the PHY.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 61 ++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 9a4e12a2af07..9d4fed782b19 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -23,6 +23,7 @@
  * link takes priority and the other port is completely locked out.
  */
 #include <linux/ctype.h>
+#include <linux/delay.h>
 #include <linux/hwmon.h>
 #include <linux/marvell_phy.h>
 #include <linux/phy.h>
@@ -39,6 +40,12 @@ enum {
 	MV_PCS_BASE_R		= 0x1000,
 	MV_PCS_1000BASEX	= 0x2000,
 
+	MV_PCS_CSCR1		= 0x8000,
+	MV_PCS_CSCR1_MDIX_MASK	= 0x0060,
+	MV_PCS_CSCR1_MDIX_MDI	= 0x0000,
+	MV_PCS_CSCR1_MDIX_MDIX	= 0x0020,
+	MV_PCS_CSCR1_MDIX_AUTO	= 0x0060,
+
 	MV_PCS_CSSR1		= 0x8008,
 	MV_PCS_CSSR1_SPD1_MASK	= 0xc000,
 	MV_PCS_CSSR1_SPD1_SPD2	= 0xc000,
@@ -216,6 +223,26 @@ static int mv3310_hwmon_probe(struct phy_device *phydev)
 }
 #endif
 
+static int mv3310_reset(struct phy_device *phydev, u32 unit)
+{
+	int retries, val, err;
+
+	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
+			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
+	if (err < 0)
+		return err;
+
+	retries = 20;
+	do {
+		msleep(5);
+		val = phy_read_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1);
+		if (val < 0)
+			return val;
+	} while (val & MDIO_CTRL1_RESET && --retries);
+
+	return val & MDIO_CTRL1_RESET ? -ETIMEDOUT : 0;
+}
+
 static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 {
 	struct phy_device *phydev = upstream;
@@ -316,6 +343,8 @@ static int mv3310_config_init(struct phy_device *phydev)
 	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
 		return -ENODEV;
 
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
 	return 0;
 }
 
@@ -345,14 +374,42 @@ static int mv3310_get_features(struct phy_device *phydev)
 	return 0;
 }
 
+static int mv3310_config_mdix(struct phy_device *phydev)
+{
+	u16 val;
+	int err;
+
+	switch (phydev->mdix_ctrl) {
+	case ETH_TP_MDI_AUTO:
+		val = MV_PCS_CSCR1_MDIX_AUTO;
+		break;
+	case ETH_TP_MDI_X:
+		val = MV_PCS_CSCR1_MDIX_MDIX;
+		break;
+	case ETH_TP_MDI:
+		val = MV_PCS_CSCR1_MDIX_MDI;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = phy_modify_mmd_changed(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1,
+				     MV_PCS_CSCR1_MDIX_MASK, val);
+	if (err > 0)
+		err = mv3310_reset(phydev, MV_PCS_BASE_T);
+
+	return err;
+}
+
 static int mv3310_config_aneg(struct phy_device *phydev)
 {
 	bool changed = false;
 	u16 reg;
 	int ret;
 
-	/* We don't support manual MDI control */
-	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	ret = mv3310_config_mdix(phydev);
+	if (ret < 0)
+		return ret;
 
 	if (phydev->autoneg == AUTONEG_DISABLE)
 		return genphy_c45_pma_setup_forced(phydev);
-- 
2.20.1

