Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF77315413
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhBIQj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:39:56 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:35929 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbhBIQjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:39:47 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 01BDB22FB3;
        Tue,  9 Feb 2021 17:39:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612888741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pldC4KDYMhYQEnWgcH3uaw5lE9NdWfcPJ/SoFuSqEO8=;
        b=EuTZHZOyztJc0ihexGkjZQxeMnvwRubcbMcWXDUa6rQ6d1PIsIOLX+3MefO6Ym+szGavd2
        c2/9TJmYvlWt2MciT21Q1gt0qd6ux0txnLAuep3+zb88L24+sJUNYnLyxggCCYHFoLufNb
        se3+zxT7/cIHDJ2TrRL6KlUxyc0xYJ8=
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
Subject: [PATCH net-next] net: phy: introduce phydev->port
Date:   Tue,  9 Feb 2021 17:38:52 +0100
Message-Id: <20210209163852.17037-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, PORT_MII is reported in the ethtool ops. This is odd
because it is an interface between the MAC and the PHY and no external
port. Some network card drivers will overwrite the port to twisted pair
or fiber, though. Even worse, the MDI/MDIX setting is only used by
ethtool if the port is twisted pair.

Set the port to PORT_TP by default because most PHY drivers are copper
ones. If there is fibre support and it is enabled, the PHY driver will
set it to PORT_FIBRE.

This will change reporting PORT_MII to either PORT_TP or PORT_FIBRE;
except for the genphy fallback driver.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/broadcom.c   |  2 ++
 drivers/net/phy/dp83822.c    |  3 +++
 drivers/net/phy/dp83869.c    |  4 ++++
 drivers/net/phy/lxt.c        |  1 +
 drivers/net/phy/marvell.c    |  1 +
 drivers/net/phy/marvell10g.c |  2 ++
 drivers/net/phy/micrel.c     | 14 +++++++++++---
 drivers/net/phy/phy.c        |  2 +-
 drivers/net/phy/phy_device.c |  9 +++++++++
 include/linux/phy.h          |  2 ++
 10 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 3142ba768313..0472b3470c59 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -410,6 +410,8 @@ static int bcm54616s_probe(struct phy_device *phydev)
 		 */
 		if (!(val & BCM54616S_100FX_MODE))
 			phydev->dev_flags |= PHY_BCM_FLAGS_MODE_1000BX;
+
+		phydev->port = PORT_FIBRE;
 	}
 
 	return 0;
diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index fff371ca1086..be1224b4447b 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -554,6 +554,9 @@ static int dp83822_probe(struct phy_device *phydev)
 
 	dp83822_of_init(phydev);
 
+	if (dp83822->fx_enabled)
+		phydev->port = PORT_FIBRE;
+
 	return 0;
 }
 
diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index b30bc142d82e..755220c6451f 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -855,6 +855,10 @@ static int dp83869_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	if (dp83869->mode == DP83869_RGMII_100_BASE ||
+	    dp83869->mode == DP83869_RGMII_1000_BASE)
+		phydev->port = PORT_FIBRE;
+
 	return dp83869_config_init(phydev);
 }
 
diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
index 0ee23d29c0d4..bde3356a2f86 100644
--- a/drivers/net/phy/lxt.c
+++ b/drivers/net/phy/lxt.c
@@ -292,6 +292,7 @@ static int lxt973_probe(struct phy_device *phydev)
 		phy_write(phydev, MII_BMCR, val);
 		/* Remember that the port is in fiber mode. */
 		phydev->priv = lxt973_probe;
+		phydev->port = PORT_FIBRE;
 	} else {
 		phydev->priv = NULL;
 	}
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index b523aa37ebf0..3238d0fbf437 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1552,6 +1552,7 @@ static int marvell_read_status_page(struct phy_device *phydev, int page)
 	phydev->asym_pause = 0;
 	phydev->speed = SPEED_UNKNOWN;
 	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->port = fiber ? PORT_FIBRE : PORT_TP;
 
 	if (phydev->autoneg == AUTONEG_ENABLE)
 		err = marvell_read_status_page_an(phydev, fiber, status);
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 1901ba277413..b1bb9b8e1e4e 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -631,6 +631,7 @@ static int mv3310_read_status_10gbaser(struct phy_device *phydev)
 	phydev->link = 1;
 	phydev->speed = SPEED_10000;
 	phydev->duplex = DUPLEX_FULL;
+	phydev->port = PORT_FIBRE;
 
 	return 0;
 }
@@ -690,6 +691,7 @@ static int mv3310_read_status_copper(struct phy_device *phydev)
 
 	phydev->duplex = cssr1 & MV_PCS_CSSR1_DUPLEX_FULL ?
 			 DUPLEX_FULL : DUPLEX_HALF;
+	phydev->port = PORT_TP;
 	phydev->mdix = cssr1 & MV_PCS_CSSR1_MDIX ?
 		       ETH_TP_MDI_X : ETH_TP_MDI;
 
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 494abf608b8f..7ec6f70d6a82 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -341,14 +341,19 @@ static int kszphy_config_init(struct phy_device *phydev)
 	return kszphy_config_reset(phydev);
 }
 
+static int ksz8041_fiber_mode(struct phy_device *phydev)
+{
+	struct device_node *of_node = phydev->mdio.dev.of_node;
+
+	return of_property_read_bool(of_node, "micrel,fiber-mode");
+}
+
 static int ksz8041_config_init(struct phy_device *phydev)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
-	struct device_node *of_node = phydev->mdio.dev.of_node;
-
 	/* Limit supported and advertised modes in fiber mode */
-	if (of_property_read_bool(of_node, "micrel,fiber-mode")) {
+	if (ksz8041_fiber_mode(phydev)) {
 		phydev->dev_flags |= MICREL_PHY_FXEN;
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, mask);
 		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, mask);
@@ -1176,6 +1181,9 @@ static int kszphy_probe(struct phy_device *phydev)
 		}
 	}
 
+	if (ksz8041_fiber_mode(phydev))
+		phydev->port = PORT_FIBRE;
+
 	/* Support legacy board-file configuration */
 	if (phydev->dev_flags & MICREL_PHY_50MHZ_CLK) {
 		priv->rmii_ref_clk_sel = true;
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 2e71d65ead54..9c4ee0a2143a 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -308,7 +308,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
 		cmd->base.port = PORT_BNC;
 	else
-		cmd->base.port = PORT_MII;
+		cmd->base.port = phydev->port;
 	cmd->base.transceiver = phy_is_internal(phydev) ?
 				XCVR_INTERNAL : XCVR_EXTERNAL;
 	cmd->base.phy_address = phydev->mdio.addr;
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8447e56ba572..30a20a29ae05 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -606,6 +606,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	dev->pause = 0;
 	dev->asym_pause = 0;
 	dev->link = 0;
+	dev->port = PORT_TP;
 	dev->interface = PHY_INTERFACE_MODE_GMII;
 
 	dev->autoneg = AUTONEG_ENABLE;
@@ -1403,6 +1404,14 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	phydev->state = PHY_READY;
 
+	/* Port is set to PORT_TP by default and the actual PHY driver will set
+	 * it to different value depending on the PHY configuration. If we have
+	 * the generic PHY driver we can't figure it out, thus set the old
+	 * legacy PORT_MII value.
+	 */
+	if (using_genphy)
+		phydev->port = PORT_MII;
+
 	/* Initial carrier state is off as the phy is about to be
 	 * (re)initialized.
 	 */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c22aba1bda59..d0e3a94882b1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -503,6 +503,7 @@ struct macsec_ops;
  *
  * @speed: Current link speed
  * @duplex: Current duplex
+ * @port: Current port
  * @pause: Current pause
  * @asym_pause: Current asymmetric pause
  * @supported: Combined MAC/PHY supported linkmodes
@@ -581,6 +582,7 @@ struct phy_device {
 	 */
 	int speed;
 	int duplex;
+	int port;
 	int pause;
 	int asym_pause;
 	u8 master_slave_get;
-- 
2.20.1

