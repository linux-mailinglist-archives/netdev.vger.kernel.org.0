Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A8B4B8C0B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbiBPPGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:06:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbiBPPGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:06:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BAE269
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ujqd9d7UXeLLHtIyoPI1f0XoyokZoyZk2dvXDFkGCWA=; b=elpBfMXnhusWM+OOIbGCqqxcJb
        El0pRSxXjY327b/rVAruENcxlxITm068kq+Hy/32x76npiKoFWWDy3Qc0TE3jBcf/1HTFs98qzBgb
        9bcEmtCYWd03DtWcq/b3aOLwyxFLY/kp9nzW8mnc7HiYzmu2u0mqR0yluHnDBLbqK2s2yrExAeCPj
        uR/i5NaEc67S/nmxJpkMUsyMHJ54Sj427C5qMZ5znnqtDwXl2WEzupRzh8fey4sZqPAe2j6GjAx60
        i7g5TyftNyUg+rZjsdPXRUHRNsDgQb5z+j6Ywp+60VUZjDStX50DtHy+a3aO+YN58JelilT1kbiw2
        AaifMzBQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46602 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nKLss-0003zM-4O; Wed, 16 Feb 2022 15:06:22 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nKLsr-009NN1-HQ; Wed, 16 Feb 2022 15:06:21 +0000
In-Reply-To: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
References: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 5/6] net: dsa: qca8k: move pcs configuration
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nKLsr-009NN1-HQ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 16 Feb 2022 15:06:21 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the PCS configuration to qca8k_pcs_config().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/qca8k.c | 151 ++++++++++++++++++++++------------------
 1 file changed, 85 insertions(+), 66 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 230411181379..e6c6ecdec9bb 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1706,8 +1706,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
-	int cpu_port_index, ret;
-	u32 reg, val;
+	int cpu_port_index;
+	u32 reg;
 
 	switch (port) {
 	case 0: /* 1st CPU port */
@@ -1773,70 +1773,6 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 	case PHY_INTERFACE_MODE_1000BASEX:
 		/* Enable SGMII on the port */
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
-
-		/* Enable/disable SerDes auto-negotiation as necessary */
-		ret = qca8k_read(priv, QCA8K_REG_PWS, &val);
-		if (ret)
-			return;
-		if (phylink_autoneg_inband(mode))
-			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
-		else
-			val |= QCA8K_PWS_SERDES_AEN_DIS;
-		qca8k_write(priv, QCA8K_REG_PWS, val);
-
-		/* Configure the SGMII parameters */
-		ret = qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
-		if (ret)
-			return;
-
-		val |= QCA8K_SGMII_EN_SD;
-
-		if (priv->ports_config.sgmii_enable_pll)
-			val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
-			       QCA8K_SGMII_EN_TX;
-
-		if (dsa_is_cpu_port(ds, port)) {
-			/* CPU port, we're talking to the CPU MAC, be a PHY */
-			val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
-			val |= QCA8K_SGMII_MODE_CTRL_PHY;
-		} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
-			val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
-			val |= QCA8K_SGMII_MODE_CTRL_MAC;
-		} else if (state->interface == PHY_INTERFACE_MODE_1000BASEX) {
-			val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
-			val |= QCA8K_SGMII_MODE_CTRL_BASEX;
-		}
-
-		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
-
-		/* From original code is reported port instability as SGMII also
-		 * require delay set. Apply advised values here or take them from DT.
-		 */
-		if (state->interface == PHY_INTERFACE_MODE_SGMII)
-			qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
-
-		/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
-		 * falling edge is set writing in the PORT0 PAD reg
-		 */
-		if (priv->switch_id == QCA8K_ID_QCA8327 ||
-		    priv->switch_id == QCA8K_ID_QCA8337)
-			reg = QCA8K_REG_PORT0_PAD_CTRL;
-
-		val = 0;
-
-		/* SGMII Clock phase configuration */
-		if (priv->ports_config.sgmii_rx_clk_falling_edge)
-			val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
-
-		if (priv->ports_config.sgmii_tx_clk_falling_edge)
-			val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
-
-		if (val)
-			ret = qca8k_rmw(priv, reg,
-					QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
-					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
-					val);
-
 		break;
 	default:
 		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
@@ -1981,6 +1917,89 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			    const unsigned long *advertising,
 			    bool permit_pause_to_mac)
 {
+	struct qca8k_priv *priv = pcs_to_qca8k_pcs(pcs)->priv;
+	int cpu_port_index, ret, port;
+	u32 reg, val;
+
+	port = pcs_to_qca8k_pcs(pcs)->port;
+	switch (port) {
+	case 0:
+		reg = QCA8K_REG_PORT0_PAD_CTRL;
+		cpu_port_index = QCA8K_CPU_PORT0;
+		break;
+
+	case 6:
+		reg = QCA8K_REG_PORT6_PAD_CTRL;
+		cpu_port_index = QCA8K_CPU_PORT6;
+		break;
+
+	default:
+		WARN_ON(1);
+	}
+
+	/* Enable/disable SerDes auto-negotiation as necessary */
+	ret = qca8k_read(priv, QCA8K_REG_PWS, &val);
+	if (ret)
+		return ret;
+	if (phylink_autoneg_inband(mode))
+		val &= ~QCA8K_PWS_SERDES_AEN_DIS;
+	else
+		val |= QCA8K_PWS_SERDES_AEN_DIS;
+	qca8k_write(priv, QCA8K_REG_PWS, val);
+
+	/* Configure the SGMII parameters */
+	ret = qca8k_read(priv, QCA8K_REG_SGMII_CTRL, &val);
+	if (ret)
+		return ret;
+
+	val |= QCA8K_SGMII_EN_SD;
+
+	if (priv->ports_config.sgmii_enable_pll)
+		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
+		       QCA8K_SGMII_EN_TX;
+
+	if (dsa_is_cpu_port(priv->ds, port)) {
+		/* CPU port, we're talking to the CPU MAC, be a PHY */
+		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
+		val |= QCA8K_SGMII_MODE_CTRL_PHY;
+	} else if (interface == PHY_INTERFACE_MODE_SGMII) {
+		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
+		val |= QCA8K_SGMII_MODE_CTRL_MAC;
+	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
+		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
+		val |= QCA8K_SGMII_MODE_CTRL_BASEX;
+	}
+
+	qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
+
+	/* From original code is reported port instability as SGMII also
+	 * require delay set. Apply advised values here or take them from DT.
+	 */
+	if (interface == PHY_INTERFACE_MODE_SGMII)
+		qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
+	/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
+	 * falling edge is set writing in the PORT0 PAD reg
+	 */
+	if (priv->switch_id == QCA8K_ID_QCA8327 ||
+	    priv->switch_id == QCA8K_ID_QCA8337)
+		reg = QCA8K_REG_PORT0_PAD_CTRL;
+
+	val = 0;
+
+	/* SGMII Clock phase configuration */
+	if (priv->ports_config.sgmii_rx_clk_falling_edge)
+		val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
+
+	if (priv->ports_config.sgmii_tx_clk_falling_edge)
+		val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
+
+	if (val)
+		ret = qca8k_rmw(priv, reg,
+				QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
+				QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
+				val);
+
+
 	return 0;
 }
 
-- 
2.30.2

