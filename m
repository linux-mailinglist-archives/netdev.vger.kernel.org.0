Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABBA20A241
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405990AbgFYPpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:45:03 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40017 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405955AbgFYPpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:45:00 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id E7E671C000F;
        Thu, 25 Jun 2020 15:44:52 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net-next 5/8] net: phy: mscc: do not access the MDIO bus lock directly
Date:   Thu, 25 Jun 2020 17:42:08 +0200
Message-Id: <20200625154211.606591-6-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625154211.606591-1-antoine.tenart@bootlin.com>
References: <20200625154211.606591-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch improves the MSCC driver by using the provided
phy_lock_mdio_bus and phy_unlock_mdio_bus helpers instead of locking and
unlocking the MDIO bus lock directly. The patch is only cosmetic but
should improve maintenance and consistency.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_main.c | 24 ++++++++++++------------
 drivers/net/phy/mscc/mscc_ptp.c  | 12 ++++++------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index cb4e15d6e2db..03680933f530 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1288,7 +1288,7 @@ static void vsc8584_get_base_addr(struct phy_device *phydev)
 	struct vsc8531_private *vsc8531 = phydev->priv;
 	u16 val, addr;
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
 
 	addr = __phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_4);
@@ -1297,7 +1297,7 @@ static void vsc8584_get_base_addr(struct phy_device *phydev)
 	val = __phy_read(phydev, MSCC_PHY_ACTIPHY_CNTL);
 
 	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	/* In the package, there are two pairs of PHYs (PHY0 + PHY2 and
 	 * PHY1 + PHY3). The first PHY of each pair (PHY0 and PHY1) is
@@ -1331,7 +1331,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 
 	/* Some parts of the init sequence are identical for every PHY in the
 	 * package. Some parts are modifying the GPIO register bank which is a
@@ -1428,7 +1428,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	if (ret)
 		goto err;
 
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	ret = vsc8584_macsec_init(phydev);
 	if (ret)
@@ -1469,7 +1469,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	return 0;
 
 err:
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 	return ret;
 }
 
@@ -1755,7 +1755,7 @@ static int vsc8514_config_init(struct phy_device *phydev)
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 
 	/* Some parts of the init sequence are identical for every PHY in the
 	 * package. Some parts are modifying the GPIO register bank which is a
@@ -1843,14 +1843,14 @@ static int vsc8514_config_init(struct phy_device *phydev)
 		reg = vsc85xx_csr_ctrl_phy_read(phydev, PHY_MCB_TARGET,
 						PHY_S6G_PLL_STATUS);
 		if (reg == 0xffffffff) {
-			mutex_unlock(&phydev->mdio.bus->mdio_lock);
+			phy_unlock_mdio_bus(phydev);
 			return -EIO;
 		}
 
 	} while (time_before(jiffies, deadline) && (reg & BIT(12)));
 
 	if (reg & BIT(12)) {
-		mutex_unlock(&phydev->mdio.bus->mdio_lock);
+		phy_unlock_mdio_bus(phydev);
 		return -ETIMEDOUT;
 	}
 
@@ -1870,18 +1870,18 @@ static int vsc8514_config_init(struct phy_device *phydev)
 		reg = vsc85xx_csr_ctrl_phy_read(phydev, PHY_MCB_TARGET,
 						PHY_S6G_IB_STATUS0);
 		if (reg == 0xffffffff) {
-			mutex_unlock(&phydev->mdio.bus->mdio_lock);
+			phy_unlock_mdio_bus(phydev);
 			return -EIO;
 		}
 
 	} while (time_before(jiffies, deadline) && !(reg & BIT(8)));
 
 	if (!(reg & BIT(8))) {
-		mutex_unlock(&phydev->mdio.bus->mdio_lock);
+		phy_unlock_mdio_bus(phydev);
 		return -ETIMEDOUT;
 	}
 
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	ret = phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
 
@@ -1908,7 +1908,7 @@ static int vsc8514_config_init(struct phy_device *phydev)
 	return ret;
 
 err:
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 	return ret;
 }
 
diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index d4266911efc5..ef3441747348 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -80,7 +80,7 @@ static u32 vsc85xx_ts_read_csr(struct phy_device *phydev, enum ts_blk blk,
 		break;
 	}
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 
 	phy_ts_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_1588);
 
@@ -98,7 +98,7 @@ static u32 vsc85xx_ts_read_csr(struct phy_device *phydev, enum ts_blk blk,
 
 	phy_ts_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
 
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 
 	return val;
 }
@@ -130,7 +130,7 @@ static void vsc85xx_ts_write_csr(struct phy_device *phydev, enum ts_blk blk,
 		break;
 	}
 
-	mutex_lock(&phydev->mdio.bus->mdio_lock);
+	phy_lock_mdio_bus(phydev);
 
 	bypass = phy_ts_base_read(phydev, MSCC_PHY_BYPASS_CONTROL);
 
@@ -154,7 +154,7 @@ static void vsc85xx_ts_write_csr(struct phy_device *phydev, enum ts_blk blk,
 	if (cond && upper)
 		phy_ts_base_write(phydev, MSCC_PHY_BYPASS_CONTROL, bypass);
 
-	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+	phy_unlock_mdio_bus(phydev);
 }
 
 /* Pick bytes from PTP header */
@@ -1273,7 +1273,7 @@ static int __vsc8584_init_ptp(struct phy_device *phydev)
 	u32 val;
 
 	if (!vsc8584_is_1588_input_clk_configured(phydev)) {
-		mutex_lock(&phydev->mdio.bus->mdio_lock);
+		phy_lock_mdio_bus(phydev);
 
 		/* 1588_DIFF_INPUT_CLK configuration: Use an external clock for
 		 * the LTC, as per 3.13.29 in the VSC8584 datasheet.
@@ -1285,7 +1285,7 @@ static int __vsc8584_init_ptp(struct phy_device *phydev)
 		phy_ts_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
 				  MSCC_PHY_PAGE_STANDARD);
 
-		mutex_unlock(&phydev->mdio.bus->mdio_lock);
+		phy_unlock_mdio_bus(phydev);
 
 		vsc8584_set_input_clk_configured(phydev);
 	}
-- 
2.26.2

