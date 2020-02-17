Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8851616C1
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgBQPyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:54:45 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38454 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729403AbgBQPyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:54:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yJevOeNVJrm2bBNKm0TRZK2n9AQGLykSdIU05WCMDDA=; b=FTRydt4OiSIXH9GhTYcbDwMpx2
        5/86rnsQo+Fe/3SNblTfcJaupSVDVtlPbzXp2Exay7cvWOiOCr31vDmTf5eDkSBt94ZsvtOQ+Qulq
        INSj3XjlzZPDGe9ltLICIkOYDzSyN/OVuEjsa5CYk1eBycwv1RlgxFWpU/yTvDBFXfrQ4L9pCwhB6
        VVm8GsTXvI+7UOPxsh9dPWzIi8DFU4FvN0nUMIf50Kk/bbVJYo16J9QkmczjnvVSC+hOp0KY6UStn
        2IpbUAapbYQGnSRUAfIWpQIGJDltqUTmjUsrVZSDZHDYIXgXG6eA4CHtH9z6QyUYEu1Zjy8I3lYOd
        X1FIzT4w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40678 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3ijF-0001iB-95; Mon, 17 Feb 2020 15:54:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3ijD-0006Er-Sz; Mon, 17 Feb 2020 15:54:35 +0000
In-Reply-To: <20200217155346.GW25745@shell.armlinux.org.uk>
References: <20200217155346.GW25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: phy: marvell*: add support for hw resolved
 pause modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j3ijD-0006Er-Sz@rmk-PC.armlinux.org.uk>
Date:   Mon, 17 Feb 2020 15:54:35 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support reporting the hardware resolved pause enablement states via
phylib, overriding our software implementation.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell.c    | 41 ++++++++++++++++++++++++++++++++++--
 drivers/net/phy/marvell10g.c |  6 ++++++
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 9a8badafea8a..dabf60641b93 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -152,6 +152,10 @@
 #define MII_M1011_PHY_STATUS_FULLDUPLEX	0x2000
 #define MII_M1011_PHY_STATUS_RESOLVED	0x0800
 #define MII_M1011_PHY_STATUS_LINK	0x0400
+#define MII_M1111_PHY_STATUS_TX_PAUSE	0x0008
+#define MII_M1111_PHY_STATUS_RX_PAUSE	0x0004
+#define MII_88E151X_PHY_STATUS_TX_PAUSE	0x0200
+#define MII_88E151X_PHY_STATUS_RX_PAUSE	0x0100
 
 #define MII_88E3016_PHY_SPEC_CTRL	0x10
 #define MII_88E3016_DISABLE_SCRAMBLER	0x0200
@@ -188,6 +192,8 @@ struct marvell_priv {
 	u64 stats[ARRAY_SIZE(marvell_hw_stats)];
 	char *hwmon_name;
 	struct device *hwmon_dev;
+	u16 tx_pause_mask;
+	u16 rx_pause_mask;
 };
 
 static int marvell_read_page(struct phy_device *phydev)
@@ -1275,6 +1281,7 @@ static void fiber_lpa_mod_linkmode_lpa_t(unsigned long *advertising, u32 lpa)
 static int marvell_read_status_page_an(struct phy_device *phydev,
 				       int fiber, int status)
 {
+	struct marvell_priv *priv = phydev->priv;
 	int lpa;
 	int err;
 
@@ -1328,6 +1335,11 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
 		break;
 	}
 
+	phydev->resolved_tx_pause = !!(status & priv->tx_pause_mask);
+	phydev->resolved_rx_pause = !!(status & priv->rx_pause_mask);
+	phydev->resolved_pause_valid = !fiber && priv->tx_pause_mask &&
+				       priv->rx_pause_mask;
+
 	return 0;
 }
 
@@ -1370,6 +1382,7 @@ static int marvell_read_status_page(struct phy_device *phydev, int page)
 	phydev->asym_pause = 0;
 	phydev->speed = SPEED_UNKNOWN;
 	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->resolved_pause_valid = false;
 
 	if (phydev->autoneg == AUTONEG_ENABLE)
 		err = marvell_read_status_page_an(phydev, fiber, status);
@@ -2130,6 +2143,23 @@ static int marvell_probe(struct phy_device *phydev)
 	return 0;
 }
 
+static int marvell_probe_pause(struct phy_device *phydev, u16 tx_pause_mask,
+			       u16 rx_pause_mask)
+{
+	struct marvell_priv *priv;
+	int err;
+
+	err = marvell_probe(phydev);
+	if (err)
+		return err;
+
+	priv = phydev->priv;
+	priv->tx_pause_mask = tx_pause_mask;
+	priv->rx_pause_mask = rx_pause_mask;
+
+	return 0;
+}
+
 static int m88e1121_probe(struct phy_device *phydev)
 {
 	int err;
@@ -2141,11 +2171,18 @@ static int m88e1121_probe(struct phy_device *phydev)
 	return m88e1121_hwmon_probe(phydev);
 }
 
+static int m88e1111_probe(struct phy_device *phydev)
+{
+	return marvell_probe_pause(phydev, MII_M1111_PHY_STATUS_TX_PAUSE,
+				   MII_M1111_PHY_STATUS_RX_PAUSE);
+}
+
 static int m88e1510_probe(struct phy_device *phydev)
 {
 	int err;
 
-	err = marvell_probe(phydev);
+	err = marvell_probe_pause(phydev, MII_88E151X_PHY_STATUS_TX_PAUSE,
+				  MII_88E151X_PHY_STATUS_RX_PAUSE);
 	if (err)
 		return err;
 
@@ -2208,7 +2245,7 @@ static struct phy_driver marvell_drivers[] = {
 		.phy_id_mask = MARVELL_PHY_ID_MASK,
 		.name = "Marvell 88E1111",
 		/* PHY_GBIT_FEATURES */
-		.probe = marvell_probe,
+		.probe = m88e1111_probe,
 		.config_init = &m88e1111_config_init,
 		.config_aneg = &marvell_config_aneg,
 		.read_status = &marvell_read_status,
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 9a4e12a2af07..b33d75b1d506 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -47,6 +47,8 @@ enum {
 	MV_PCS_CSSR1_SPD1_10	= 0x0000,
 	MV_PCS_CSSR1_DUPLEX_FULL= BIT(13),
 	MV_PCS_CSSR1_RESOLVED	= BIT(11),
+	MV_PCS_CSSR1_TX_PAUSE	= BIT(9),
+	MV_PCS_CSSR1_RX_PAUSE	= BIT(8),
 	MV_PCS_CSSR1_MDIX	= BIT(6),
 	MV_PCS_CSSR1_SPD2_MASK	= 0x000c,
 	MV_PCS_CSSR1_SPD2_5000	= 0x0008,
@@ -489,6 +491,10 @@ static int mv3310_read_status_copper(struct phy_device *phydev)
 	phydev->mdix = cssr1 & MV_PCS_CSSR1_MDIX ?
 		       ETH_TP_MDI_X : ETH_TP_MDI;
 
+	phydev->resolved_tx_pause = !!(cssr1 & MV_PCS_CSSR1_TX_PAUSE);
+	phydev->resolved_rx_pause = !!(cssr1 & MV_PCS_CSSR1_RX_PAUSE);
+	phydev->resolved_pause_valid = true;
+
 	if (val & MDIO_AN_STAT1_COMPLETE) {
 		val = genphy_c45_read_lpa(phydev);
 		if (val < 0)
-- 
2.20.1

