Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7614BF596
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiBVKQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiBVKQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:16:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE78D13D577
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=t10a9OeTSuGDsM1RTVml9s7RycoNl0V0lWojMow39SY=; b=dfTvE0Bl6D4tH6sQOLNCGOupEt
        QCPAehosgaXIJvd98cZOwW65OOQzRHB3pW3hOQ6nUeVQokCVyv7R2nrtVYOfAx+SuFfdWhrrQbD75
        yPACX1mWpeHSoeX2u26ZwPmzw+ivobbD3TJdvmYToHmz8VbJF8jWCx9EVVQcNQ1DuWhzTmTSB+DYF
        sWi6jZeB3PAcfj51cWdNhysVIIxHi/Fz5cr/m6VImWGzVc7Ah5H3bcWvZQ/hPTaZZnGYRcjyrVPrB
        oBh2HWKxPLMM0wdF3WGQJRClEDf38KpTmwZrQY7Q5cNQ3orCR/FiCeFNekysiDFddjFAlqHYQmiqf
        OyOTOPvg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48104 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nMSDD-0001PI-Fo; Tue, 22 Feb 2022 10:16:03 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nMSDC-00A2RZ-S6; Tue, 22 Feb 2022 10:16:02 +0000
In-Reply-To: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
References: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/5] net: dsa: b53: populate supported_interfaces and
 mac_capabilities
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nMSDC-00A2RZ-S6@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 22 Feb 2022 10:16:02 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the supported interfaces and MAC capabilities for the Broadcom
B53 DSA switches in preparation to using these for the generic
validation functionality.

The interface modes are derived from:
- b53_serdes_phylink_validate()
- SRAB mux configuration

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/b53/b53_common.c | 28 ++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_priv.h   |  2 ++
 drivers/net/dsa/b53/b53_serdes.c | 29 +++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_serdes.h |  2 ++
 drivers/net/dsa/b53/b53_srab.c   | 34 ++++++++++++++++++++++++++++++++
 5 files changed, 95 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 7d62b0aeaae9..211c0e499370 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1353,6 +1353,33 @@ void b53_phylink_validate(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_phylink_validate);
 
+static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
+				 struct phylink_config *config)
+{
+	struct b53_device *dev = ds->priv;
+
+	/* Internal ports need GMII for PHYLIB */
+	__set_bit(PHY_INTERFACE_MODE_GMII, config->supported_interfaces);
+
+	/* These switches appear to support MII and RevMII too, but beyond
+	 * this, the code gives very few clues. FIXME: We probably need more
+	 * interface modes here.
+	 */
+	__set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_REVMII, config->supported_interfaces);
+
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+		MAC_10 | MAC_100;
+
+	/* 5325/5365 are not capable of gigabit speeds, everything else is */
+	if (!(is5325(dev) || is5365(dev)))
+		config->mac_capabilities |= MAC_1000;
+
+	/* Get the implementation specific capabilities */
+	if (dev->ops->phylink_get_caps)
+		dev->ops->phylink_get_caps(dev, port, config);
+}
+
 int b53_phylink_mac_link_state(struct dsa_switch *ds, int port,
 			       struct phylink_link_state *state)
 {
@@ -2262,6 +2289,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.phy_read		= b53_phy_read16,
 	.phy_write		= b53_phy_write16,
 	.adjust_link		= b53_adjust_link,
+	.phylink_get_caps	= b53_phylink_get_caps,
 	.phylink_validate	= b53_phylink_validate,
 	.phylink_mac_link_state	= b53_phylink_mac_link_state,
 	.phylink_mac_config	= b53_phylink_mac_config,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index b41dc8ac2ca8..b9d1b4819c5f 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -46,6 +46,8 @@ struct b53_io_ops {
 	int (*phy_write16)(struct b53_device *dev, int addr, int reg, u16 value);
 	int (*irq_enable)(struct b53_device *dev, int port);
 	void (*irq_disable)(struct b53_device *dev, int port);
+	void (*phylink_get_caps)(struct b53_device *dev, int port,
+				 struct phylink_config *config);
 	u8 (*serdes_map_lane)(struct b53_device *dev, int port);
 	int (*serdes_link_state)(struct b53_device *dev, int port,
 				 struct phylink_link_state *state);
diff --git a/drivers/net/dsa/b53/b53_serdes.c b/drivers/net/dsa/b53/b53_serdes.c
index 5ae3d9783b68..e4cc6442c113 100644
--- a/drivers/net/dsa/b53/b53_serdes.c
+++ b/drivers/net/dsa/b53/b53_serdes.c
@@ -180,6 +180,35 @@ void b53_serdes_phylink_validate(struct b53_device *dev, int port,
 }
 EXPORT_SYMBOL(b53_serdes_phylink_validate);
 
+void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
+				 struct phylink_config *config)
+{
+	u8 lane = b53_serdes_map_lane(dev, port);
+
+	if (lane == B53_INVALID_LANE)
+		return;
+
+	switch (lane) {
+	case 0:
+		/* It appears lane 0 supports 2500base-X and 1000base-X */
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+			  config->supported_interfaces);
+		config->mac_capabilities |= MAC_2500FD;
+		fallthrough;
+	case 1:
+		/* It appears lane 1 only supports 1000base-X and SGMII */
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+			  config->supported_interfaces);
+		__set_bit(PHY_INTERFACE_MODE_SGMII,
+			  config->supported_interfaces);
+		config->mac_capabilities |= MAC_1000FD;
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL(b53_serdes_phylink_get_caps);
+
 int b53_serdes_init(struct b53_device *dev, int port)
 {
 	u8 lane = b53_serdes_map_lane(dev, port);
diff --git a/drivers/net/dsa/b53/b53_serdes.h b/drivers/net/dsa/b53/b53_serdes.h
index 55d280fe38e4..8fa24f7001aa 100644
--- a/drivers/net/dsa/b53/b53_serdes.h
+++ b/drivers/net/dsa/b53/b53_serdes.h
@@ -115,6 +115,8 @@ void b53_serdes_config(struct b53_device *dev, int port, unsigned int mode,
 void b53_serdes_an_restart(struct b53_device *dev, int port);
 void b53_serdes_link_set(struct b53_device *dev, int port, unsigned int mode,
 			 phy_interface_t interface, bool link_up);
+void b53_serdes_phylink_get_caps(struct b53_device *dev, int port,
+				 struct phylink_config *config);
 void b53_serdes_phylink_validate(struct b53_device *dev, int port,
 				unsigned long *supported,
 				struct phylink_link_state *state);
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index 4591bb1c05d2..7d72f3b293d3 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -443,6 +443,39 @@ static void b53_srab_irq_disable(struct b53_device *dev, int port)
 	}
 }
 
+static void b53_srab_phylink_get_caps(struct b53_device *dev, int port,
+				      struct phylink_config *config)
+{
+	struct b53_srab_priv *priv = dev->priv;
+	struct b53_srab_port_priv *p = &priv->port_intrs[port];
+
+	switch (p->mode) {
+	case PHY_INTERFACE_MODE_SGMII:
+#if IS_ENABLED(CONFIG_B53_SERDES)
+		/* If p->mode indicates SGMII mode, that essentially means we
+		 * are using a serdes. As the serdes for the capabilities.
+		 */
+		b53_serdes_phylink_get_caps(dev, port, config);
+#endif
+		break;
+
+	case PHY_INTERFACE_MODE_NA:
+		break;
+
+	case PHY_INTERFACE_MODE_RGMII:
+		/* If we support RGMII, support all RGMII modes, since
+		 * that dictates the PHY delay settings.
+		 */
+		phy_interface_set_rgmii(config->supported_interfaces);
+		break;
+
+	default:
+		/* Some other mode (e.g. MII, GMII etc) */
+		__set_bit(p->mode, config->supported_interfaces);
+		break;
+	}
+}
+
 static const struct b53_io_ops b53_srab_ops = {
 	.read8 = b53_srab_read8,
 	.read16 = b53_srab_read16,
@@ -456,6 +489,7 @@ static const struct b53_io_ops b53_srab_ops = {
 	.write64 = b53_srab_write64,
 	.irq_enable = b53_srab_irq_enable,
 	.irq_disable = b53_srab_irq_disable,
+	.phylink_get_caps = b53_srab_phylink_get_caps,
 #if IS_ENABLED(CONFIG_B53_SERDES)
 	.serdes_map_lane = b53_srab_serdes_map_lane,
 	.serdes_link_state = b53_serdes_link_state,
-- 
2.30.2

