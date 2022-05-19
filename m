Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDE152D54D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiESN5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239063AbiESN5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:57:09 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0CA5F85;
        Thu, 19 May 2022 06:57:06 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 950EF24001C;
        Thu, 19 May 2022 13:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652968625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NpJ7Y06rlWK7NL20S9LW+d8iM18Q5646oiRCct7xMqs=;
        b=k+Zosj4bOSeQs9ipDgkyb56cMN8WWYNa19kqrZCCXZNm+sPTw5+0ByMrqu8uK4XlC4oOx/
        I1g5DbmuImllriMWb2oq8i1g7O0lDnj1BZJ4fIbhFdlJADgA4aanPAOT/oWyZ1IO7immjS
        Ew9zguV/iN1necrZiMOhAbaLEGrbwBEL++6D7/f6mf6BwG7lnQDKYw6H0bxQzaAgrGOCVx
        MHzVmOvfrrHdQiCDzBXn9o8tQxq/3s8Z0MGoLasRbNxESYbWZ25Ome3mWxMClQ0x1aeE6H
        BZlt0I4Ixn3VdCw0r20BFMLSacJUakI8/z47zVvdHX+u8WTwp6d5duR4mM+0Sg==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 5/6] net: lan966x: Allow using PCH extension for PTP
Date:   Thu, 19 May 2022 15:56:46 +0200
Message-Id: <20220519135647.465653-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
References: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds the logic to use the PCH mode for timestamp passing in
ingress traffic for PTP. The tricky part is that we need to configure
both the PHY and the MAC, since the MAC will extract the timetsamp
reported by the PHY from the preamble and set it into the SKB.

Note that with the PCH mode, we only get the RX timestamp that way, the
TX timestamps are still reported OOB by the PHY.

Note that only the nanoseconds part is extracted from the PCH extension,
since there's not enough room in the 4 bytes extension to pass a full
80bits timestamp. The seconds part of the timestamp still needs to get
retrieved from the PHY using an out-of-band mechanism.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c | 12 +--
 .../ethernet/microchip/lan966x/lan966x_port.c | 11 +++
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 93 ++++++++++++++++++-
 .../ethernet/microchip/lan966x/lan966x_regs.h | 66 +++++++++++++
 4 files changed, 171 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index b8c2ef905e46..d5d65cc9fc76 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -400,13 +400,11 @@ static int lan966x_port_ioctl(struct net_device *dev, struct ifreq *ifr,
 {
 	struct lan966x_port *port = netdev_priv(dev);
 
-	if (!phy_has_hwtstamp(dev->phydev) && port->lan966x->ptp) {
-		switch (cmd) {
-		case SIOCSHWTSTAMP:
-			return lan966x_ptp_hwtstamp_set(port, ifr);
-		case SIOCGHWTSTAMP:
-			return lan966x_ptp_hwtstamp_get(port, ifr);
-		}
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return lan966x_ptp_hwtstamp_set(port, ifr);
+	case SIOCGHWTSTAMP:
+		return lan966x_ptp_hwtstamp_get(port, ifr);
 	}
 
 	if (!dev->phydev)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index ef65a44b2d34..3a0aaf566698 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -360,6 +360,17 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 		DEV_PCS1G_MODE_CFG_SAVE_PREAMBLE_ENA,
 		lan966x, DEV_PCS1G_MODE_CFG(port->chip_port));
 
+	if (full_preamble)
+		lan_rmw(DEV_ENABLE_CONFIG_MM_TX_ENA_SET(1) |
+			DEV_ENABLE_CONFIG_MM_RX_ENA_SET(1),
+			DEV_ENABLE_CONFIG_MM_TX_ENA |
+			DEV_ENABLE_CONFIG_MM_RX_ENA,
+			lan966x, DEV_ENABLE_CONFIG(port->chip_port));
+
+	lan_rmw(SYS_PTP_MODE_CFG_PTP_MODE_VAL_SET(1),
+		SYS_PTP_MODE_CFG_PTP_MODE_VAL,
+		lan966x, SYS_PTP_MODE_CFG(port->chip_port, 0));
+
 	/* Enable PCS */
 	lan_wr(DEV_PCS1G_CFG_PCS_ENA_SET(1),
 	       lan966x, DEV_PCS1G_CFG(port->chip_port));
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index ae782778d6dd..f9dc0861f038 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -35,11 +35,28 @@ static u64 lan966x_ptp_get_nominal_value(void)
 	return res;
 }
 
-int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
+/* Enable or disable PCH timestamp transmission. This uses the USGMII PCH
+ * extensions to transmit the timestamps in the frame preamble.
+ */
+static void lan966x_ptp_pch_configure(struct lan966x_port *port, bool enable)
+{
+	lan_rmw(SYS_PCH_CFG_PCH_SUB_PORT_ID_SET(port->chip_port % 4) |
+		SYS_PCH_CFG_PCH_TX_MODE_SET(enable) |
+		SYS_PCH_CFG_PCH_RX_MODE_SET(enable),
+		SYS_PCH_CFG_PCH_SUB_PORT_ID |
+		SYS_PCH_CFG_PCH_TX_MODE |
+		SYS_PCH_CFG_PCH_RX_MODE,
+		port->lan966x, SYS_PCH_CFG(port->chip_port));
+}
+
+static int lan966x_ptp_mac_hwtstamp_set(struct lan966x_port *port,
+					struct ifreq *ifr,
+					bool inband)
 {
 	struct lan966x *lan966x = port->lan966x;
 	struct hwtstamp_config cfg;
 	struct lan966x_phc *phc;
+	bool timestamp_in_pch = false;
 
 	/* For now don't allow to run ptp on ports that are part of a bridge,
 	 * because in case of transparent clock the HW will still forward the
@@ -88,16 +105,48 @@ int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
 		return -ERANGE;
 	}
 
+	if (inband &&
+	    port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP &&
+	    port->config.portmode == PHY_INTERFACE_MODE_QUSGMII)
+		timestamp_in_pch = true;
+
 	/* Commit back the result & save it */
 	mutex_lock(&lan966x->ptp_lock);
 	phc = &lan966x->phc[LAN966X_PHC_PORT];
 	memcpy(&phc->hwtstamp_config, &cfg, sizeof(cfg));
+	lan966x_ptp_pch_configure(port, timestamp_in_pch);
 	mutex_unlock(&lan966x->ptp_lock);
 
 	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+
 }
 
-int lan966x_ptp_hwtstamp_get(struct lan966x_port *port, struct ifreq *ifr)
+int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
+{
+	struct phy_device *phydev = port->dev->phydev;
+	int ret;
+
+	if (!phy_has_hwtstamp(phydev) && port->lan966x->ptp)
+		return lan966x_ptp_mac_hwtstamp_set(port, ifr, false);
+
+	ret = phy_mii_ioctl(phydev, ifr, SIOCSHWTSTAMP);
+	if (ret)
+		return ret;
+
+	if (phy_inband_ext_available(phydev, PHY_INBAND_EXT_PCH)) {
+		ret = phy_inband_ext_enable(phydev, PHY_INBAND_EXT_PCH);
+		if (ret)
+			return ret;
+
+		ret = lan966x_ptp_mac_hwtstamp_set(port, ifr, true);
+		if (ret)
+			return phy_inband_ext_disable(phydev, PHY_INBAND_EXT_PCH);
+	}
+
+	return ret;
+}
+
+static int lan966x_ptp_mac_hwtstamp_get(struct lan966x_port *port, struct ifreq *ifr)
 {
 	struct lan966x *lan966x = port->lan966x;
 	struct lan966x_phc *phc;
@@ -107,6 +156,14 @@ int lan966x_ptp_hwtstamp_get(struct lan966x_port *port, struct ifreq *ifr)
 			    sizeof(phc->hwtstamp_config)) ? -EFAULT : 0;
 }
 
+int lan966x_ptp_hwtstamp_get(struct lan966x_port *port, struct ifreq *ifr)
+{
+	if (!phy_has_hwtstamp(port->dev->phydev) && port->lan966x->ptp)
+		return lan966x_ptp_mac_hwtstamp_get(port, ifr);
+
+	return phy_mii_ioctl(port->dev->phydev, ifr, SIOCGHWTSTAMP);
+}
+
 static int lan966x_ptp_classify(struct lan966x_port *port, struct sk_buff *skb)
 {
 	struct ptp_header *header;
@@ -182,8 +239,16 @@ int lan966x_ptp_txtstamp_request(struct lan966x_port *port,
 	LAN966X_SKB_CB(skb)->jiffies = jiffies;
 
 	lan966x->ptp_skbs++;
-	port->ts_id++;
-	if (port->ts_id == LAN966X_MAX_PTP_ID)
+
+	/* If PHC is enabled, the subns part of the ID is not passed in the PCH
+	 * header. So shift it by 2 to skip the subns part
+	 */
+	if (phy_inband_ext_enabled(port->dev->phydev, PHY_INBAND_EXT_PCH))
+		port->ts_id = (((port->ts_id >> 2) + 1) << 2);
+	else
+		port->ts_id++;
+
+	if (port->ts_id >= LAN966X_MAX_PTP_ID)
 		port->ts_id = 0;
 
 	spin_unlock_irqrestore(&lan966x->ptp_ts_id_lock, flags);
@@ -285,6 +350,26 @@ irqreturn_t lan966x_ptp_irq_handler(int irq, void *args)
 		/* Read RX timestamping to get the ID */
 		id = lan_rd(lan966x, PTP_TWOSTEP_STAMP);
 
+		/* If PCH is enabled, there is a "feature" that also the MAC
+		 * will generate an interrupt for transmitted frames. This
+		 * interrupt should be ignored, so clear the allocated resources
+		 * and try to get the next timestamp. Maybe should clean the
+		 * resources on the TX side?
+		 */
+		if (phy_inband_ext_enabled(port->dev->phydev, PHY_INBAND_EXT_PCH)) {
+			spin_lock(&lan966x->ptp_ts_id_lock);
+			lan966x->ptp_skbs--;
+			spin_unlock(&lan966x->ptp_ts_id_lock);
+
+			dev_kfree_skb_any(skb_match);
+
+			lan_rmw(PTP_TWOSTEP_CTRL_NXT_SET(1),
+				PTP_TWOSTEP_CTRL_NXT,
+				lan966x, PTP_TWOSTEP_CTRL);
+
+			continue;
+		}
+
 		spin_lock_irqsave(&port->tx_skbs.lock, flags);
 		skb_queue_walk_safe(&port->tx_skbs, skb, skb_tmp) {
 			if (LAN966X_SKB_CB(skb)->ts_id != id)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index d4839e4b8ed5..e0d4364ee204 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -585,6 +585,27 @@ enum lan966x_target {
 #define DEV_PCS1G_STICKY_LINK_DOWN_STICKY_GET(x)\
 	FIELD_GET(DEV_PCS1G_STICKY_LINK_DOWN_STICKY, x)
 
+/*      DEV:MM_CONFIG:ENABLE_CONFIG */
+#define DEV_ENABLE_CONFIG(t)      __REG(TARGET_DEV, t, 8, 156, 0, 1, 8, 0, 0, 1, 4)
+
+#define DEV_ENABLE_CONFIG_KEEP_S_AFTER_D         BIT(8)
+#define DEV_ENABLE_CONFIG_KEEP_S_AFTER_D_SET(x)\
+	FIELD_PREP(DEV_ENABLE_CONFIG_KEEP_S_AFTER_D, x)
+#define DEV_ENABLE_CONFIG_KEEP_S_AFTER_D_GET(x)\
+	FIELD_GET(DEV_ENABLE_CONFIG_KEEP_S_AFTER_D, x)
+
+#define DEV_ENABLE_CONFIG_MM_TX_ENA              BIT(4)
+#define DEV_ENABLE_CONFIG_MM_TX_ENA_SET(x)\
+	FIELD_PREP(DEV_ENABLE_CONFIG_MM_TX_ENA, x)
+#define DEV_ENABLE_CONFIG_MM_TX_ENA_GET(x)\
+	FIELD_GET(DEV_ENABLE_CONFIG_MM_TX_ENA, x)
+
+#define DEV_ENABLE_CONFIG_MM_RX_ENA              BIT(0)
+#define DEV_ENABLE_CONFIG_MM_RX_ENA_SET(x)\
+	FIELD_PREP(DEV_ENABLE_CONFIG_MM_RX_ENA, x)
+#define DEV_ENABLE_CONFIG_MM_RX_ENA_GET(x)\
+	FIELD_GET(DEV_ENABLE_CONFIG_MM_RX_ENA, x)
+
 /*      FDMA:FDMA:FDMA_CH_ACTIVATE */
 #define FDMA_CH_ACTIVATE          __REG(TARGET_FDMA, 0, 1, 8, 0, 1, 428, 0, 0, 1, 4)
 
@@ -792,6 +813,15 @@ enum lan966x_target {
 #define PTP_TWOSTEP_STAMP_STAMP_NSEC_GET(x)\
 	FIELD_GET(PTP_TWOSTEP_STAMP_STAMP_NSEC, x)
 
+/*      SYS:PTPPORT:PTP_MODE_CFG */
+#define SYS_PTP_MODE_CFG(g, r)    __REG(TARGET_SYS, 0, 1, 4452, g, 10, 28, 20, r, 2, 4)
+
+#define SYS_PTP_MODE_CFG_PTP_MODE_VAL            GENMASK(1, 0)
+#define SYS_PTP_MODE_CFG_PTP_MODE_VAL_SET(x)\
+	FIELD_PREP(SYS_PTP_MODE_CFG_PTP_MODE_VAL, x)
+#define SYS_PTP_MODE_CFG_PTP_MODE_VAL_GET(x)\
+	FIELD_GET(SYS_PTP_MODE_CFG_PTP_MODE_VAL, x)
+
 /*      DEVCPU_QS:XTR:XTR_GRP_CFG */
 #define QS_XTR_GRP_CFG(r)         __REG(TARGET_QS, 0, 1, 0, 0, 1, 36, 0, r, 2, 4)
 
@@ -972,6 +1002,21 @@ enum lan966x_target {
 #define REW_PORT_CFG_NO_REWRITE_GET(x)\
 	FIELD_GET(REW_PORT_CFG_NO_REWRITE, x)
 
+/*      REW:PORT:PTP_MISC_CFG */
+#define REW_PTP_MISC_CFG(g)       __REG(TARGET_REW, 0, 1, 0, g, 10, 128, 80, 0, 1, 4)
+
+#define REW_PTP_MISC_CFG_PTP_RSRV_MOVEBACK       BIT(2)
+#define REW_PTP_MISC_CFG_PTP_RSRV_MOVEBACK_SET(x)\
+	FIELD_PREP(REW_PTP_MISC_CFG_PTP_RSRV_MOVEBACK, x)
+#define REW_PTP_MISC_CFG_PTP_RSRV_MOVEBACK_GET(x)\
+	FIELD_GET(REW_PTP_MISC_CFG_PTP_RSRV_MOVEBACK, x)
+
+#define REW_PTP_MISC_CFG_PTP_SIGNATURE_SEL       GENMASK(1, 0)
+#define REW_PTP_MISC_CFG_PTP_SIGNATURE_SEL_SET(x)\
+	FIELD_PREP(REW_PTP_MISC_CFG_PTP_SIGNATURE_SEL, x)
+#define REW_PTP_MISC_CFG_PTP_SIGNATURE_SEL_GET(x)\
+	FIELD_GET(REW_PTP_MISC_CFG_PTP_SIGNATURE_SEL, x)
+
 /*      SYS:SYSTEM:RESET_CFG */
 #define SYS_RESET_CFG             __REG(TARGET_SYS, 0, 1, 4128, 0, 1, 168, 0, 0, 1, 4)
 
@@ -1101,4 +1146,25 @@ enum lan966x_target {
 #define SYS_RAM_INIT_RAM_INIT_GET(x)\
 	FIELD_GET(SYS_RAM_INIT_RAM_INIT, x)
 
+/*      SYS:PTPPORT:PCH_CFG */
+#define SYS_PCH_CFG(g)            __REG(TARGET_SYS, 0, 1, 4452, g, 10, 28, 0, 0, 1, 4)
+
+#define SYS_PCH_CFG_PCH_SUB_PORT_ID		GENMASK(10, 7)
+#define SYS_PCH_CFG_PCH_SUB_PORT_ID_SET(x)\
+	FIELD_PREP(SYS_PCH_CFG_PCH_SUB_PORT_ID, x)
+#define SYS_PCH_CFG_PCH_SUB_PORT_ID_GET(x)\
+	FIELD_GET(SYS_PCH_CFG_PCH_SUB_PORT_ID, x)
+
+#define SYS_PCH_CFG_PCH_TX_MODE			GENMASK(6, 5)
+#define SYS_PCH_CFG_PCH_TX_MODE_SET(x)\
+	FIELD_PREP(SYS_PCH_CFG_PCH_TX_MODE, x)
+#define SYS_PCH_CFG_PCH_TX_MODE_GET(x)\
+	FIELD_GET(SYS_MAC_FC_CFG_PAUSE_VAL_CFG, x)
+
+#define SYS_PCH_CFG_PCH_RX_MODE			GENMASK(4, 2)
+#define SYS_PCH_CFG_PCH_RX_MODE_SET(x)\
+	FIELD_PREP(SYS_PCH_CFG_PCH_RX_MODE, x)
+#define SYS_PCH_CFG_PCH_RX_MODE_GET(x)\
+	FIELD_GET(SYS_PCH_CFG_PCH_RX_MODE, x)
+
 #endif /* _LAN966X_REGS_H_ */
-- 
2.36.1

