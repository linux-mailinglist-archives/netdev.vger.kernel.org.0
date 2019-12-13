Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C4111E707
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfLMPu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:50:29 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:37895 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbfLMPu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:50:26 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 243191C000A;
        Fri, 13 Dec 2019 15:50:23 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v3 11/15] net: phy: mscc: PN rollover support
Date:   Fri, 13 Dec 2019 16:48:40 +0100
Message-Id: <20191213154844.635389-12-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213154844.635389-1-antoine.tenart@bootlin.com>
References: <20191213154844.635389-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for handling MACsec PN rollover in the mscc PHY
driver. When a flow rolls over, an interrupt is fired. This patch adds
the logic to check all flows and identify the one rolling over in the
handle_interrupt PHY helper, then disables the flow and report the event
to the MACsec core.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc.c        | 61 ++++++++++++++++++++++++++++++++++-
 drivers/net/phy/mscc_macsec.h |  2 ++
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 18a983cec37c..2e2215335315 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -80,7 +80,7 @@ enum rgmii_rx_clock_delay {
 #define MSCC_PHY_EXT_PHY_CNTL_2		  24
 
 #define MII_VSC85XX_INT_MASK		  25
-#define MII_VSC85XX_INT_MASK_MASK	  0xa000
+#define MII_VSC85XX_INT_MASK_MASK	  0xa020
 #define MII_VSC85XX_INT_MASK_WOL	  0x0040
 #define MII_VSC85XX_INT_STATUS		  26
 
@@ -207,6 +207,9 @@ enum macsec_bank {
 #define SECURE_ON_ENABLE		  0x8000
 #define SECURE_ON_PASSWD_LEN_4		  0x4000
 
+#define MSCC_PHY_EXTENDED_INT		  28
+#define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
+
 /* Extended Page 3 Registers */
 #define MSCC_PHY_SERDES_TX_VALID_CNT	  21
 #define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
@@ -2880,6 +2883,43 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	return ret;
 }
 
+static int vsc8584_handle_interrupt(struct phy_device *phydev)
+{
+#if IS_ENABLED(CONFIG_MACSEC)
+	struct vsc8531_private *priv = phydev->priv;
+	struct macsec_flow *flow, *tmp;
+	u32 cause, rec;
+
+	/* Check MACsec PN rollover */
+	cause = vsc8584_macsec_phy_read(phydev, MACSEC_EGR,
+					MSCC_MS_INTR_CTRL_STATUS);
+	cause &= MSCC_MS_INTR_CTRL_STATUS_INTR_CLR_STATUS_M;
+	if (!(cause & MACSEC_INTR_CTRL_STATUS_ROLLOVER))
+		goto skip_rollover;
+
+	rec = 6 + priv->secy->key_len / sizeof(u32);
+	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list) {
+		u32 val;
+
+		if (flow->bank != MACSEC_EGR || !flow->has_transformation)
+			continue;
+
+		val = vsc8584_macsec_phy_read(phydev, MACSEC_EGR,
+					      MSCC_MS_XFORM_REC(flow->index, rec));
+		if (val == 0xffffffff) {
+			vsc8584_macsec_flow_disable(phydev, flow);
+			macsec_pn_wrapped(priv->secy, flow->tx_sa);
+			break;
+		}
+	}
+
+skip_rollover:
+#endif
+
+	phy_mac_interrupt(phydev);
+	return 0;
+}
+
 static int vsc85xx_config_init(struct phy_device *phydev)
 {
 	int rc, i, phy_id;
@@ -3323,6 +3363,21 @@ static int vsc85xx_config_intr(struct phy_device *phydev)
 	int rc;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		if (IS_ENABLED(CONFIG_MACSEC)) {
+			phy_write(phydev, MSCC_EXT_PAGE_ACCESS,
+				  MSCC_PHY_PAGE_EXTENDED_2);
+			phy_write(phydev, MSCC_PHY_EXTENDED_INT,
+				  MSCC_PHY_EXTENDED_INT_MS_EGR);
+			phy_write(phydev, MSCC_EXT_PAGE_ACCESS,
+				  MSCC_PHY_PAGE_STANDARD);
+
+			vsc8584_macsec_phy_write(phydev, MACSEC_EGR,
+						 MSCC_MS_AIC_CTRL, 0xf);
+			vsc8584_macsec_phy_write(phydev, MACSEC_EGR,
+				MSCC_MS_INTR_CTRL_STATUS,
+				MSCC_MS_INTR_CTRL_STATUS_INTR_ENABLE(MACSEC_INTR_CTRL_STATUS_ROLLOVER));
+		}
+
 		rc = phy_write(phydev, MII_VSC85XX_INT_MASK,
 			       MII_VSC85XX_INT_MASK_MASK);
 	} else {
@@ -3654,6 +3709,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_aneg    = &vsc85xx_config_aneg,
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
+	.handle_interrupt = &vsc8584_handle_interrupt,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.did_interrupt  = &vsc8584_did_interrupt,
@@ -3730,6 +3786,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_aneg    = &vsc85xx_config_aneg,
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
+	.handle_interrupt = &vsc8584_handle_interrupt,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.did_interrupt  = &vsc8584_did_interrupt,
@@ -3754,6 +3811,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_aneg    = &vsc85xx_config_aneg,
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
+	.handle_interrupt = &vsc8584_handle_interrupt,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.did_interrupt  = &vsc8584_did_interrupt,
@@ -3778,6 +3836,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.config_aneg    = &vsc85xx_config_aneg,
 	.aneg_done	= &genphy_aneg_done,
 	.read_status	= &vsc85xx_read_status,
+	.handle_interrupt = &vsc8584_handle_interrupt,
 	.ack_interrupt  = &vsc85xx_ack_interrupt,
 	.config_intr    = &vsc85xx_config_intr,
 	.did_interrupt  = &vsc8584_did_interrupt,
diff --git a/drivers/net/phy/mscc_macsec.h b/drivers/net/phy/mscc_macsec.h
index 9b5d0af91d20..d9ab6aba7482 100644
--- a/drivers/net/phy/mscc_macsec.h
+++ b/drivers/net/phy/mscc_macsec.h
@@ -83,6 +83,7 @@ enum mscc_macsec_validate_levels {
 #define MSCC_MS_STATUS_CONTEXT_CTRL	0x3d02
 #define MSCC_MS_INTR_CTRL_STATUS	0x3d04
 #define MSCC_MS_BLOCK_CTX_UPDATE	0x3d0c
+#define MSCC_MS_AIC_CTRL		0x3e02
 
 /* MACSEC_ENA_CFG */
 #define MSCC_MS_ENA_CFG_CLK_ENA				BIT(0)
@@ -260,5 +261,6 @@ enum mscc_macsec_validate_levels {
 #define MSCC_MS_INTR_CTRL_STATUS_INTR_CLR_STATUS_M	GENMASK(15, 0)
 #define MSCC_MS_INTR_CTRL_STATUS_INTR_ENABLE(x)		((x) << 16)
 #define MSCC_MS_INTR_CTRL_STATUS_INTR_ENABLE_M		GENMASK(31, 16)
+#define MACSEC_INTR_CTRL_STATUS_ROLLOVER		BIT(5)
 
 #endif
-- 
2.23.0

