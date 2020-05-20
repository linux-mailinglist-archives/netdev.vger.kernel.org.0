Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90EB1DAFA3
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 12:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgETKFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 06:05:06 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48801 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgETKFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 06:05:06 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 263B260016;
        Wed, 20 May 2020 10:05:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: phy: mscc: fix initialization of the MACsec protocol mode
Date:   Wed, 20 May 2020 12:03:55 +0200
Message-Id: <20200520100355.587686-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the very end of the MACsec block initialization in the MSCC PHY
driver, the MACsec "protocol mode" is set. This setting should be set
based on the PHY id within the package, as the bank used to access the
register used depends on this. This was not done correctly, and only the
first bank was used leading to the two upper PHYs being unstable when
using the VSC8584. This patch fixes it.

Fixes: 1bbe0ecc2a1a ("net: phy: mscc: macsec initialization")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---

Hi,

This patch fixes a bug there since v5.6, but only applies on top of
net-next because commit deb04e9c0ff2 changed the way base addresses
are retrieved.

To fix earlier versions two different patches have to be made, as the
MSCC PHY driver was moved and split up into multiple files by commits
da80aa52d074 and fa164e40c53b, between v5.6 and v5.7-rc1.

To sum up, due to conflicts three (similar) patches have to be made to
fix this issue: one for net-next, one for v5.7-rc1+ and one for v4.6.

What's the best way to handle this? I can provide all the patches.

Thanks!
Antoine

 drivers/net/phy/mscc/mscc.h        |  2 ++
 drivers/net/phy/mscc/mscc_mac.h    |  6 +++---
 drivers/net/phy/mscc/mscc_macsec.c | 16 ++++++++++------
 drivers/net/phy/mscc/mscc_macsec.h |  3 ++-
 drivers/net/phy/mscc/mscc_main.c   |  2 ++
 5 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index acdd8ee61a39..f828c917b9f7 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -353,6 +353,8 @@ struct vsc8531_private {
 	const struct vsc85xx_hw_stat *hw_stats;
 	u64 *stats;
 	int nstats;
+	/* PHY address within the package. */
+	u8 addr;
 	/* For multiple port PHYs; the MDIO address of the base PHY in the
 	 * package.
 	 */
diff --git a/drivers/net/phy/mscc/mscc_mac.h b/drivers/net/phy/mscc/mscc_mac.h
index fcb5ba5e5d03..59b6837c60b3 100644
--- a/drivers/net/phy/mscc/mscc_mac.h
+++ b/drivers/net/phy/mscc/mscc_mac.h
@@ -152,8 +152,8 @@
 #define MSCC_MAC_PAUSE_CFG_STATE_PAUSE_STATE			BIT(0)
 #define MSCC_MAC_PAUSE_CFG_STATE_MAC_TX_PAUSE_GEN		BIT(4)
 
-#define MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL			0x2
-#define MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE(x)	(x)
-#define MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE_M	GENMASK(2, 0)
+#define MSCC_PROC_IP_1588_TOP_CFG_STAT_MODE_CTL			0x2
+#define MSCC_PROC_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE(x)	(x)
+#define MSCC_PROC_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE_M	GENMASK(2, 0)
 
 #endif /* _MSCC_PHY_LINE_MAC_H_ */
diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index e99e2cd72a0c..b4d3dc4068e2 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -316,6 +316,8 @@ static void vsc8584_macsec_mac_init(struct phy_device *phydev,
 /* Must be called with mdio_lock taken */
 static int __vsc8584_macsec_init(struct phy_device *phydev)
 {
+	struct vsc8531_private *priv = phydev->priv;
+	enum macsec_bank proc_bank;
 	u32 val;
 
 	vsc8584_macsec_block_init(phydev, MACSEC_INGR);
@@ -351,12 +353,14 @@ static int __vsc8584_macsec_init(struct phy_device *phydev)
 	val |= MSCC_FCBUF_ENA_CFG_TX_ENA | MSCC_FCBUF_ENA_CFG_RX_ENA;
 	vsc8584_macsec_phy_write(phydev, FC_BUFFER, MSCC_FCBUF_ENA_CFG, val);
 
-	val = vsc8584_macsec_phy_read(phydev, IP_1588,
-				      MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL);
-	val &= ~MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE_M;
-	val |= MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE(4);
-	vsc8584_macsec_phy_write(phydev, IP_1588,
-				 MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL, val);
+	proc_bank = (priv->addr < 2) ? PROC_0 : PROC_2;
+
+	val = vsc8584_macsec_phy_read(phydev, proc_bank,
+				      MSCC_PROC_IP_1588_TOP_CFG_STAT_MODE_CTL);
+	val &= ~MSCC_PROC_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE_M;
+	val |= MSCC_PROC_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE(4);
+	vsc8584_macsec_phy_write(phydev, proc_bank,
+				 MSCC_PROC_IP_1588_TOP_CFG_STAT_MODE_CTL, val);
 
 	return 0;
 }
diff --git a/drivers/net/phy/mscc/mscc_macsec.h b/drivers/net/phy/mscc/mscc_macsec.h
index d0783944d106..d751f2946b79 100644
--- a/drivers/net/phy/mscc/mscc_macsec.h
+++ b/drivers/net/phy/mscc/mscc_macsec.h
@@ -64,7 +64,8 @@ enum macsec_bank {
 	FC_BUFFER   = 0x04,
 	HOST_MAC    = 0x05,
 	LINE_MAC    = 0x06,
-	IP_1588     = 0x0e,
+	PROC_0      = 0x0e,
+	PROC_2      = 0x0f,
 	MACSEC_INGR = 0x38,
 	MACSEC_EGR  = 0x3c,
 };
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 6508d6536134..550acf547ced 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1303,6 +1303,8 @@ static void vsc8584_get_base_addr(struct phy_device *phydev)
 		vsc8531->base_addr = phydev->mdio.addr + addr;
 	else
 		vsc8531->base_addr = phydev->mdio.addr - addr;
+
+	vsc8531->addr = addr;
 }
 
 static int vsc8584_config_init(struct phy_device *phydev)
-- 
2.26.2

