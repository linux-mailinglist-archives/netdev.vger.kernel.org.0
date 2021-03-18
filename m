Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699C13405AC
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 13:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhCRMjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 08:39:31 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25929 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhCRMjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 08:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616071153; x=1647607153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8kby57sB5d9EUTFUeitwufhcEZhzMbXcBsVHl+LSnfo=;
  b=t0y3EP0dALAwxHypsNL3ND2lgUJUj9jm5hShRXCkDHgCn/KYsPRVQUaU
   xQ+OVocv2SI81efFF0ZooSocL72t8i34dEfq3FUwDE0jlxS/pWz8TMKC5
   0JZmbSXM98KgCJflo7dEpwN+/7PXhL1H74D2HbKNVBcbTxLSYmx/N1ScQ
   25fp1zyvOaHKEYbhuoiSvZvMp1CCvFk4C7C+beU6gODTDOyH2g1G8WhfP
   aULlvZlUCHgZIuzcLLRMNerPsss/GbocgwdsiiYWKVJCmOli1d+ympqmV
   3j8ZE1PYDLLq6b9s79v/aKQGGXOX5nACvFFk0ZuJ7BRhhlIcmDMh87+vH
   Q==;
IronPort-SDR: mHt9RUOzNUVB+9VfD2Ty8JiH7vlFmjhB15njAYR1ojexUdwcP7aY3SMOuQ7fx5xoKSZQzuwK3V
 t2MyqcnmuDCtV6FLes2KVc8Gl5MhAXb1Hxx+vt3xv4ngBUN5zDLITyY84Cz2NkkI2HgmfeFYss
 n+DWffjL8rOQZcUlD4+nlIwhDjFTUMK1t77SbT3LEhi0spa6WQvHwlNkttxls08ASiNP8iUvqq
 GvECxivSRqxLr7fGZZvmET7CAI3lL3ZtxFRT7fvuRBAblpYIo5APyyTr3MCunA0hFEQWkgCHHH
 0mM=
X-IronPort-AV: E=Sophos;i="5.81,258,1610434800"; 
   d="scan'208";a="119478863"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2021 05:39:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 05:39:12 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 18 Mar 2021 05:39:09 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v1 2/3] net: phy: mscc: improved serdes calibration applied to VSC8584
Date:   Thu, 18 Mar 2021 13:38:50 +0100
Message-ID: <20210318123851.10324-3-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210318123851.10324-1-bjarni.jonasson@microchip.com>
References: <20210318123851.10324-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduced 'FOJI' serdes calibration in commit 85e97f0b984e
("net: phy: mscc: improved serdes calibration applied to VSC8514")
Now including the VSC8584 family.

Fixes: a5afc1678044a ("net: phy: mscc: add support for VSC8584 PHYY.")
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 drivers/net/phy/mscc/mscc_main.c | 212 ++++++++++++++++++++++---------
 1 file changed, 155 insertions(+), 57 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 2c2a3424dcc1..254d882490f7 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1472,6 +1472,24 @@ static int vsc8584_config_pre_init(struct phy_device *phydev)
 	if (ret)
 		goto out;
 
+	/* Write patch vector 0, to skip IB cal polling  */
+	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED_GPIO);
+	reg = MSCC_ROM_TRAP_SERDES_6G_CFG; /* ROM address to trap, for patch vector 0 */
+	ret = phy_base_write(phydev, MSCC_TRAP_ROM_ADDR(1), reg);
+	if (ret)
+		goto out;
+
+	reg = MSCC_RAM_TRAP_SERDES_6G_CFG; /* RAM address to jump to, when patch vector 0 enabled */
+	ret = phy_base_write(phydev, MSCC_PATCH_RAM_ADDR(1), reg);
+	if (ret)
+		goto out;
+
+	reg = phy_base_read(phydev, MSCC_INT_MEM_CNTL);
+	reg |= PATCH_VEC_ZERO_EN; /* bit 8, enable patch vector 0 */
+	ret = phy_base_write(phydev, MSCC_INT_MEM_CNTL, reg);
+	if (ret)
+		goto out;
+
 	vsc8584_micro_deassert_reset(phydev, true);
 
 out:
@@ -1537,62 +1555,81 @@ static void vsc85xx_coma_mode_release(struct phy_device *phydev)
 	vsc85xx_phy_write_page(phydev, MSCC_PHY_PAGE_STANDARD);
 }
 
-static int vsc8584_config_init(struct phy_device *phydev)
+static int vsc8584_config_host_serdes(struct phy_device *phydev)
 {
-	struct vsc8531_private *vsc8531 = phydev->priv;
-	int ret, i;
+	int ret;
 	u16 val;
+	struct vsc8531_private *vsc8531 = phydev->priv;
 
-	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_EXTENDED_GPIO);
+	if (ret)
+		return ret;
 
-	phy_lock_mdio_bus(phydev);
+	val = phy_base_read(phydev, MSCC_PHY_MAC_CFG_FASTLINK);
+	val &= ~MAC_CFG_MASK;
+	if (phydev->interface == PHY_INTERFACE_MODE_QSGMII) {
+		val |= MAC_CFG_QSGMII;
+	} else if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		val |= MAC_CFG_SGMII;
+	} else {
+		ret = -EINVAL;
+		return ret;
+	}
 
-	/* Some parts of the init sequence are identical for every PHY in the
-	 * package. Some parts are modifying the GPIO register bank which is a
-	 * set of registers that are affecting all PHYs, a few resetting the
-	 * microprocessor common to all PHYs. The CRC check responsible of the
-	 * checking the firmware within the 8051 microprocessor can only be
-	 * accessed via the PHY whose internal address in the package is 0.
-	 * All PHYs' interrupts mask register has to be zeroed before enabling
-	 * any PHY's interrupt in this register.
-	 * For all these reasons, we need to do the init sequence once and only
-	 * once whatever is the first PHY in the package that is initialized and
-	 * do the correct init sequence for all PHYs that are package-critical
-	 * in this pre-init function.
-	 */
-	if (phy_package_init_once(phydev)) {
-		/* The following switch statement assumes that the lowest
-		 * nibble of the phy_id_mask is always 0. This works because
-		 * the lowest nibble of the PHY_ID's below are also 0.
-		 */
-		WARN_ON(phydev->drv->phy_id_mask & 0xf);
+	ret = phy_base_write(phydev, MSCC_PHY_MAC_CFG_FASTLINK, val);
+	if (ret)
+		return ret;
 
-		switch (phydev->phy_id & phydev->drv->phy_id_mask) {
-		case PHY_ID_VSC8504:
-		case PHY_ID_VSC8552:
-		case PHY_ID_VSC8572:
-		case PHY_ID_VSC8574:
-			ret = vsc8574_config_pre_init(phydev);
-			break;
-		case PHY_ID_VSC856X:
-		case PHY_ID_VSC8575:
-		case PHY_ID_VSC8582:
-		case PHY_ID_VSC8584:
-			ret = vsc8584_config_pre_init(phydev);
-			break;
-		default:
-			ret = -EINVAL;
-			break;
-		}
+	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+			     MSCC_PHY_PAGE_STANDARD);
+	if (ret)
+		return ret;
 
-		if (ret)
-			goto err;
-	}
+	val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
+		PROC_CMD_READ_MOD_WRITE_PORT;
+	if (phydev->interface == PHY_INTERFACE_MODE_QSGMII)
+		val |= PROC_CMD_QSGMII_MAC;
+	else
+		val |= PROC_CMD_SGMII_MAC;
+
+	ret = vsc8584_cmd(phydev, val);
+	if (ret)
+		return ret;
+
+	usleep_range(10000, 20000);
+
+	/* Disable SerDes for 100Base-FX */
+	ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
+			  PROC_CMD_FIBER_PORT(vsc8531->addr) |
+			  PROC_CMD_FIBER_DISABLE |
+			  PROC_CMD_READ_MOD_WRITE_PORT |
+			  PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_100BASE_FX);
+	if (ret)
+		return ret;
+
+	/* Disable SerDes for 1000Base-X */
+	ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
+			  PROC_CMD_FIBER_PORT(vsc8531->addr) |
+			  PROC_CMD_FIBER_DISABLE |
+			  PROC_CMD_READ_MOD_WRITE_PORT |
+			  PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_1000BASE_X);
+	if (ret)
+		return ret;
+
+	return vsc85xx_sd6g_config_v2(phydev);
+}
+
+static int vsc8574_config_host_serdes(struct phy_device *phydev)
+{
+	int ret;
+	u16 val;
+	struct vsc8531_private *vsc8531 = phydev->priv;
 
 	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
 			     MSCC_PHY_PAGE_EXTENDED_GPIO);
 	if (ret)
-		goto err;
+		return ret;
 
 	val = phy_base_read(phydev, MSCC_PHY_MAC_CFG_FASTLINK);
 	val &= ~MAC_CFG_MASK;
@@ -1604,17 +1641,17 @@ static int vsc8584_config_init(struct phy_device *phydev)
 		val |= MAC_CFG_RGMII;
 	} else {
 		ret = -EINVAL;
-		goto err;
+		return ret;
 	}
 
 	ret = phy_base_write(phydev, MSCC_PHY_MAC_CFG_FASTLINK, val);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
 			     MSCC_PHY_PAGE_STANDARD);
 	if (ret)
-		goto err;
+		return ret;
 
 	if (!phy_interface_is_rgmii(phydev)) {
 		val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
@@ -1626,7 +1663,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 		ret = vsc8584_cmd(phydev, val);
 		if (ret)
-			goto err;
+			return ret;
 
 		usleep_range(10000, 20000);
 	}
@@ -1638,16 +1675,77 @@ static int vsc8584_config_init(struct phy_device *phydev)
 			  PROC_CMD_READ_MOD_WRITE_PORT |
 			  PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_100BASE_FX);
 	if (ret)
-		goto err;
+		return ret;
 
 	/* Disable SerDes for 1000Base-X */
-	ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
-			  PROC_CMD_FIBER_PORT(vsc8531->addr) |
-			  PROC_CMD_FIBER_DISABLE |
-			  PROC_CMD_READ_MOD_WRITE_PORT |
-			  PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_1000BASE_X);
-	if (ret)
-		goto err;
+	return vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
+			   PROC_CMD_FIBER_PORT(vsc8531->addr) |
+			   PROC_CMD_FIBER_DISABLE |
+			   PROC_CMD_READ_MOD_WRITE_PORT |
+			   PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_1000BASE_X);
+}
+
+static int vsc8584_config_init(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	int ret, i;
+	u16 val;
+
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
+	phy_lock_mdio_bus(phydev);
+
+	/* Some parts of the init sequence are identical for every PHY in the
+	 * package. Some parts are modifying the GPIO register bank which is a
+	 * set of registers that are affecting all PHYs, a few resetting the
+	 * microprocessor common to all PHYs. The CRC check responsible of the
+	 * checking the firmware within the 8051 microprocessor can only be
+	 * accessed via the PHY whose internal address in the package is 0.
+	 * All PHYs' interrupts mask register has to be zeroed before enabling
+	 * any PHY's interrupt in this register.
+	 * For all these reasons, we need to do the init sequence once and only
+	 * once whatever is the first PHY in the package that is initialized and
+	 * do the correct init sequence for all PHYs that are package-critical
+	 * in this pre-init function.
+	 */
+	if (phy_package_init_once(phydev)) {
+		/* The following switch statement assumes that the lowest
+		 * nibble of the phy_id_mask is always 0. This works because
+		 * the lowest nibble of the PHY_ID's below are also 0.
+		 */
+		WARN_ON(phydev->drv->phy_id_mask & 0xf);
+
+		switch (phydev->phy_id & phydev->drv->phy_id_mask) {
+		case PHY_ID_VSC8504:
+		case PHY_ID_VSC8552:
+		case PHY_ID_VSC8572:
+		case PHY_ID_VSC8574:
+			ret = vsc8574_config_pre_init(phydev);
+			if (ret)
+				goto err;
+			ret = vsc8574_config_host_serdes(phydev);
+			if (ret)
+				goto err;
+			break;
+		case PHY_ID_VSC856X:
+		case PHY_ID_VSC8575:
+		case PHY_ID_VSC8582:
+		case PHY_ID_VSC8584:
+			ret = vsc8584_config_pre_init(phydev);
+			if (ret)
+				goto err;
+			ret = vsc8584_config_host_serdes(phydev);
+			if (ret)
+				goto err;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
+		if (ret)
+			goto err;
+	}
 
 	phy_unlock_mdio_bus(phydev);
 
-- 
2.17.1

