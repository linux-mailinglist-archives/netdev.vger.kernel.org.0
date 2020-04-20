Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCCC1B1A1E
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgDTX0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDTX0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 19:26:46 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F90EC061A0E;
        Mon, 20 Apr 2020 16:26:46 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7F8F123066;
        Tue, 21 Apr 2020 01:26:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587425203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TRQbkbdC/gQtxrwEc1p+3zgw2fe2P/OV+V5yZdAT9Zk=;
        b=YoiycdaSFjlZ9DoTWRqalmAycNXFoYih0IIo+YOasH9NQ+SZac5MTRWS9jYwIZZF9+R5it
        lIfc8rHPxCG6ztzWNXYaC+beAP7M8Y1Zgw8IED9/Stem++AXIYLAkEIU68m1SISs4rANsi
        6tg3HrPwkRXUlLLRrTjcNrg6s6tzKfc=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [RFC PATCH net-next 3/3] net: phy: mscc: use phy_package_shared
Date:   Tue, 21 Apr 2020 01:26:24 +0200
Message-Id: <20200420232624.9127-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200420232624.9127-1-michael@walle.cc>
References: <20200420232624.9127-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 7F8F123066
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.854];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[9];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,nxp.com,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new phy_package_shared common storage to ease the package
initialization and to access the global registers.

This was only compile-time tested!

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mscc/mscc.h      |  1 -
 drivers/net/phy/mscc/mscc_main.c | 99 ++++++++++----------------------
 2 files changed, 29 insertions(+), 71 deletions(-)

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
index 5391acdece05..382b56064de9 100644
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
@@ -1287,65 +1283,36 @@ static int vsc8584_config_pre_init(struct phy_device *phydev)
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
-
-		phy = mdiobus_get_phy(bus, addr);
-		if (!phy)
-			continue;
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	u16 val, addr;
 
-		if ((phy->phy_id & phydev->drv->phy_id_mask) !=
-		    (phydev->drv->phy_id & phydev->drv->phy_id_mask))
-			continue;
+	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
 
-		vsc8531 = phy->priv;
+	addr = __phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_4);
+	addr >>= PHY_CNTL_4_ADDR_POS;
 
-		if (vsc8531 && vsc8531->pkg_init)
-			return true;
-	}
+	val = __phy_read(phydev, MSCC_PHY_ACTIPHY_CNTL);
 
-	return false;
+	if (val & PHY_ADDR_REVERSED)
+		vsc8531->base_addr = phydev->mdio.addr + addr;
+	else
+		vsc8531->base_addr = phydev->mdio.addr - addr;
+	mutex_unlock(&phydev->mdio.bus->mdio_lock);
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
@@ -1359,7 +1326,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	 * do the correct init sequence for all PHYs that are package-critical
 	 * in this pre-init function.
 	 */
-	if (!vsc8584_is_pkg_init(phydev, val & PHY_ADDR_REVERSED ? 1 : 0)) {
+	if (phy_package_init_once(phydev)) {
 		/* The following switch statement assumes that the lowest
 		 * nibble of the phy_id_mask is always 0. This works because
 		 * the lowest nibble of the PHY_ID's below are also 0.
@@ -1388,8 +1355,6 @@ static int vsc8584_config_init(struct phy_device *phydev)
 			goto err;
 	}
 
-	vsc8531->pkg_init = true;
-
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
 		       MSCC_PHY_PAGE_EXTENDED_GPIO);
 
@@ -1427,7 +1392,8 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 	/* Disable SerDes for 100Base-FX */
 	ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
-			  PROC_CMD_FIBER_PORT(addr) | PROC_CMD_FIBER_DISABLE |
+			  PROC_CMD_FIBER_PORT(vsc8531->base_addr) |
+			  PROC_CMD_FIBER_DISABLE |
 			  PROC_CMD_READ_MOD_WRITE_PORT |
 			  PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_100BASE_FX);
 	if (ret)
@@ -1435,7 +1401,8 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 	/* Disable SerDes for 1000Base-X */
 	ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
-			  PROC_CMD_FIBER_PORT(addr) | PROC_CMD_FIBER_DISABLE |
+			  PROC_CMD_FIBER_PORT(vsc8531->base_addr) |
+			  PROC_CMD_FIBER_DISABLE |
 			  PROC_CMD_READ_MOD_WRITE_PORT |
 			  PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_1000BASE_X);
 	if (ret)
@@ -1750,26 +1717,14 @@ static int vsc8514_config_init(struct phy_device *phydev)
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
@@ -1781,11 +1736,9 @@ static int vsc8514_config_init(struct phy_device *phydev)
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
 
@@ -1991,6 +1944,9 @@ static int vsc8514_probe(struct phy_device *phydev)
 
 	phydev->priv = vsc8531;
 
+	vsc8584_get_base_addr(phydev);
+	devm_phy_package_join(&phydev->mdio.dev, phydev, vsc8531->base_addr);
+
 	vsc8531->nleds = 4;
 	vsc8531->supp_led_modes = VSC85XX_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc85xx_hw_stats;
@@ -2046,6 +2002,9 @@ static int vsc8584_probe(struct phy_device *phydev)
 
 	phydev->priv = vsc8531;
 
+	vsc8584_get_base_addr(phydev);
+	devm_phy_package_join(&phydev->mdio.dev, phydev, vsc8531->base_addr);
+
 	vsc8531->nleds = 4;
 	vsc8531->supp_led_modes = VSC8584_SUPP_LED_MODES;
 	vsc8531->hw_stats = vsc8584_hw_stats;
-- 
2.20.1

