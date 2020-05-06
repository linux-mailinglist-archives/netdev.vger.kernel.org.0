Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFFF1C735F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 16:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbgEFOzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 10:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729078AbgEFOzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 10:55:04 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCA7C061A0F;
        Wed,  6 May 2020 07:55:03 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 09A4722F2D;
        Wed,  6 May 2020 16:55:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588776900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J8hcAbR2qDHUTRYs1cD3GEXXzgGSjE1TOh9xiHScmok=;
        b=kb7HUTVa+F73wHdsxmoRjbga2em6hf8xgAtGJ1W9i97rElHWmdq7KuWLkzaBAD6sdPNKAQ
        iUE5WNEagDyFeyhFg0760OY1SXtIVCY1VRRRA+SOC0viPFs4CDqM/gWxGXYMUuZ2o609Oi
        lTS02OBzgL12nnVtwj4/opmsDAt62kY=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 3/3] net: phy: mscc: use phy_package_shared
Date:   Wed,  6 May 2020 16:53:15 +0200
Message-Id: <20200506145315.13967-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200506145315.13967-1-michael@walle.cc>
References: <20200506145315.13967-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new phy_package_shared common storage to ease the package
initialization and to access the global registers.

Signed-off-by: Michael Walle <michael@walle.cc>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/mscc/mscc.h      |   1 -
 drivers/net/phy/mscc/mscc_main.c | 101 ++++++++++---------------------
 2 files changed, 32 insertions(+), 70 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 030bf8b600df..acdd8ee61a39 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -353,7 +353,6 @@ struct vsc8531_private {
 	const struct vsc85xx_hw_stat *hw_stats;
 	u64 *stats;
 	int nstats;
-	bool pkg_init;
 	/* For multiple port PHYs; the MDIO address of the base PHY in the
 	 * package.
 	 */
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 5391acdece05..6508d6536134 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -691,27 +691,23 @@ static int vsc85xx_eee_init_seq_set(struct phy_device *phydev)
 /* phydev->bus->mdio_lock should be locked when using this function */
 static int phy_base_write(struct phy_device *phydev, u32 regnum, u16 val)
 {
-	struct vsc8531_private *priv = phydev->priv;
-
 	if (unlikely(!mutex_is_locked(&phydev->mdio.bus->mdio_lock))) {
 		dev_err(&phydev->mdio.dev, "MDIO bus lock not held!\n");
 		dump_stack();
 	}
 
-	return __mdiobus_write(phydev->mdio.bus, priv->base_addr, regnum, val);
+	return __phy_package_write(phydev, regnum, val);
 }
 
 /* phydev->bus->mdio_lock should be locked when using this function */
 static int phy_base_read(struct phy_device *phydev, u32 regnum)
 {
-	struct vsc8531_private *priv = phydev->priv;
-
 	if (unlikely(!mutex_is_locked(&phydev->mdio.bus->mdio_lock))) {
 		dev_err(&phydev->mdio.dev, "MDIO bus lock not held!\n");
 		dump_stack();
 	}
 
-	return __mdiobus_read(phydev->mdio.bus, priv->base_addr, regnum);
+	return __phy_package_read(phydev, regnum);
 }
 
 /* bus->mdio_lock should be locked when using this function */
@@ -1287,65 +1283,38 @@ static int vsc8584_config_pre_init(struct phy_device *phydev)
 	return ret;
 }
 
-/* Check if one PHY has already done the init of the parts common to all PHYs
- * in the Quad PHY package.
- */
-static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
+static void vsc8584_get_base_addr(struct phy_device *phydev)
 {
-	struct mii_bus *bus = phydev->mdio.bus;
-	struct vsc8531_private *vsc8531;
-	struct phy_device *phy;
-	int i, addr;
-
-	/* VSC8584 is a Quad PHY */
-	for (i = 0; i < 4; i++) {
-		vsc8531 = phydev->priv;
-
-		if (reversed)
-			addr = vsc8531->base_addr - i;
-		else
-			addr = vsc8531->base_addr + i;
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	u16 val, addr;
 
-		phy = mdiobus_get_phy(bus, addr);
-		if (!phy)
-			continue;
+	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
 
-		if ((phy->phy_id & phydev->drv->phy_id_mask) !=
-		    (phydev->drv->phy_id & phydev->drv->phy_id_mask))
-			continue;
+	addr = __phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_4);
+	addr >>= PHY_CNTL_4_ADDR_POS;
 
-		vsc8531 = phy->priv;
+	val = __phy_read(phydev, MSCC_PHY_ACTIPHY_CNTL);
 
-		if (vsc8531 && vsc8531->pkg_init)
-			return true;
-	}
+	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
+	mutex_unlock(&phydev->mdio.bus->mdio_lock);
 
-	return false;
+	if (val & PHY_ADDR_REVERSED)
+		vsc8531->base_addr = phydev->mdio.addr + addr;
+	else
+		vsc8531->base_addr = phydev->mdio.addr - addr;
 }
 
 static int vsc8584_config_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
-	u16 addr, val;
 	int ret, i;
+	u16 val;
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
 	mutex_lock(&phydev->mdio.bus->mdio_lock);
 
-	__mdiobus_write(phydev->mdio.bus, phydev->mdio.addr,
-			MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
-	addr = __mdiobus_read(phydev->mdio.bus, phydev->mdio.addr,
-			      MSCC_PHY_EXT_PHY_CNTL_4);
-	addr >>= PHY_CNTL_4_ADDR_POS;
-
-	val = __mdiobus_read(phydev->mdio.bus, phydev->mdio.addr,
-			     MSCC_PHY_ACTIPHY_CNTL);
-	if (val & PHY_ADDR_REVERSED)
-		vsc8531->base_addr = phydev->mdio.addr + addr;
-	else
-		vsc8531->base_addr = phydev->mdio.addr - addr;
-
 	/* Some parts of the init sequence are identical for every PHY in the
 	 * package. Some parts are modifying the GPIO register bank which is a
 	 * set of registers that are affecting all PHYs, a few resetting the
@@ -1359,7 +1328,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	 * do the correct init sequence for all PHYs that are package-critical
 	 * in this pre-init function.
 	 */
-	if (!vsc8584_is_pkg_init(phydev, val & PHY_ADDR_REVERSED ? 1 : 0)) {
+	if (phy_package_init_once(phydev)) {
 		/* The following switch statement assumes that the lowest
 		 * nibble of the phy_id_mask is always 0. This works because
 		 * the lowest nibble of the PHY_ID's below are also 0.
@@ -1388,8 +1357,6 @@ static int vsc8584_config_init(struct phy_device *phydev)
 			goto err;
 	}
 
-	vsc8531->pkg_init = true;
-
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
 		       MSCC_PHY_PAGE_EXTENDED_GPIO);
 
@@ -1427,7 +1394,8 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 	/* Disable SerDes for 100Base-FX */
 	ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
-			  PROC_CMD_FIBER_PORT(addr) | PROC_CMD_FIBER_DISABLE |
+			  PROC_CMD_FIBER_PORT(vsc8531->base_addr) |
+			  PROC_CMD_FIBER_DISABLE |
 			  PROC_CMD_READ_MOD_WRITE_PORT |
 			  PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_100BASE_FX);
 	if (ret)
@@ -1435,7 +1403,8 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 	/* Disable SerDes for 1000Base-X */
 	ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
-			  PROC_CMD_FIBER_PORT(addr) | PROC_CMD_FIBER_DISABLE |
+			  PROC_CMD_FIBER_PORT(vsc8531->base_addr) |
+			  PROC_CMD_FIBER_DISABLE |
 			  PROC_CMD_READ_MOD_WRITE_PORT |
 			  PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_1000BASE_X);
 	if (ret)
@@ -1750,26 +1719,14 @@ static int vsc8514_config_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
 	unsigned long deadline;
-	u16 val, addr;
 	int ret, i;
+	u16 val;
 	u32 reg;
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
 	mutex_lock(&phydev->mdio.bus->mdio_lock);
 
-	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
-
-	addr = __phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_4);
-	addr >>= PHY_CNTL_4_ADDR_POS;
-
-	val = __phy_read(phydev, MSCC_PHY_ACTIPHY_CNTL);
-
-	if (val & PHY_ADDR_REVERSED)
-		vsc8531->base_addr = phydev->mdio.addr + addr;
-	else
-		vsc8531->base_addr = phydev->mdio.addr - addr;
-
 	/* Some parts of the init sequence are identical for every PHY in the
 	 * package. Some parts are modifying the GPIO register bank which is a
 	 * set of registers that are affecting all PHYs, a few resetting the
@@ -1781,11 +1738,9 @@ static int vsc8514_config_init(struct phy_device *phydev)
 	 * do the correct init sequence for all PHYs that are package-critical
 	 * in this pre-init function.
 	 */
-	if (!vsc8584_is_pkg_init(phydev, val & PHY_ADDR_REVERSED ? 1 : 0))
+	if (phy_package_init_once(phydev))
 		vsc8514_config_pre_init(phydev);
 
-	vsc8531->pkg_init = true;
-
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
 		       MSCC_PHY_PAGE_EXTENDED_GPIO);
 
@@ -1991,6 +1946,10 @@ static int vsc8514_probe(struct phy_device *phydev)
 
 	phydev->priv = vsc8531;
 
+	vsc8584_get_base_addr(phydev);
+	devm_phy_package_join(&phydev->mdio.dev, phydev,
+			      vsc8531->base_addr, 0);
+
 	vsc8531->nleds = 4;
 	vsc8531->supp_led_modes = VSC85XX_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc85xx_hw_stats;
@@ -2046,6 +2005,10 @@ static int vsc8584_probe(struct phy_device *phydev)
 
 	phydev->priv = vsc8531;
 
+	vsc8584_get_base_addr(phydev);
+	devm_phy_package_join(&phydev->mdio.dev, phydev,
+			      vsc8531->base_addr, 0);
+
 	vsc8531->nleds = 4;
 	vsc8531->supp_led_modes = VSC8584_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc8584_hw_stats;
-- 
2.20.1

