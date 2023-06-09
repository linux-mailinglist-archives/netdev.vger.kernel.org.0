Return-Path: <netdev+bounces-9464-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68AD3729472
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:13:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA8881C210DF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56C9D30E;
	Fri,  9 Jun 2023 09:13:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76E512B86
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:13:11 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B502949DA
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OCglsCsZZnnXlVHzsJR72PA2+sDdXVUrHDSRvtLgmrM=; b=Ttg8F3fZ1uHSKnMrAEZFfyb+z6
	PL8Cd5DHw/pA4tV4ziSDtUhP2LsfkXtgROx8mPhlFx36OLx+Q5MqDhsEn74rr/7CfuEyy9CEB3Avn
	Tnx0fb2UvOXlcPpxd4VSZI1noWEfycPxwgfq4URW5+unDL8mHOYLCZ32EyZMyBZ4catAZ09m0vwm4
	tuZEauwzyAnCBrGAYf2YeiiGBcjcCaNY2uYX0ga6jaOzifYD1WiwZ/RL+PN9gq6v29aSEsIc4C4YA
	juIi2W6uDdhGOQQ4yLWLMhDhKXZ2L8FUE7kDwOYeo+SPj/BIU4Q4oB1T8FHWWIzy70SmOLUeF3JFn
	jxOVoRvg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42440 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q7Y9c-0001k4-Ab; Fri, 09 Jun 2023 10:11:32 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q7Y9b-00DI8s-NW; Fri, 09 Jun 2023 10:11:31 +0100
In-Reply-To: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH RFC net-next 4/4] net: mvpp2: add EEE implementation
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q7Y9b-00DI8s-NW@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 09 Jun 2023 10:11:31 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add EEE support for mvpp2, using phylink's EEE implementation, which
means we just need to implement the two methods for LPI control, and
with the initial configuration. Only the GMAC is supported, so only
100M, 1G and 2.5G speeds.

Disabling LPI requires clearing a single bit. Enabling LPI needs a full
configuration of several values, as the timer values are dependent on
the MAC operating speed.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  5 ++
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 85 +++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 11e603686a27..af31da9cc89a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -481,6 +481,11 @@
 #define MVPP22_GMAC_INT_SUM_MASK		0xa4
 #define     MVPP22_GMAC_INT_SUM_MASK_LINK_STAT	BIT(1)
 #define	    MVPP22_GMAC_INT_SUM_MASK_PTP	BIT(2)
+#define MVPP2_GMAC_LPI_CTRL0			0xc0
+#define     MVPP2_GMAC_LPI_CTRL0_TS_MASK	GENMASK(8, 8)
+#define MVPP2_GMAC_LPI_CTRL1			0xc4
+#define     MVPP2_GMAC_LPI_CTRL1_REQ_EN		BIT(0)
+#define     MVPP2_GMAC_LPI_CTRL1_TW_MASK	GENMASK(15, 4)
 
 /* Per-port XGMAC registers. PPv2.2 and PPv2.3, only for GOP port 0,
  * relative to port->base.
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index adc953611913..a06c455b7180 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5716,6 +5716,31 @@ static int mvpp2_ethtool_set_rxfh_context(struct net_device *dev,
 
 	return mvpp22_port_rss_ctx_indir_set(port, *rss_context, indir);
 }
+
+static int mvpp2_ethtool_get_eee(struct net_device *dev,
+				 struct ethtool_eee *eee)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+
+	if (!port->phylink)
+		return -ENOTSUPP;
+
+	return phylink_ethtool_get_eee(port->phylink, eee);
+}
+
+static int mvpp2_ethtool_set_eee(struct net_device *dev,
+				 struct ethtool_eee *eee)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+
+	if (!port->phylink)
+		return -ENOTSUPP;
+
+	if (eee->tx_lpi_timer > 255)
+		eee->tx_lpi_timer = 255;
+
+	return phylink_ethtool_set_eee(port->phylink, eee);
+}
 /* Device ops */
 
 static const struct net_device_ops mvpp2_netdev_ops = {
@@ -5759,6 +5784,8 @@ static const struct ethtool_ops mvpp2_eth_tool_ops = {
 	.set_rxfh		= mvpp2_ethtool_set_rxfh,
 	.get_rxfh_context	= mvpp2_ethtool_get_rxfh_context,
 	.set_rxfh_context	= mvpp2_ethtool_set_rxfh_context,
+	.get_eee		= mvpp2_ethtool_get_eee,
+	.set_eee		= mvpp2_ethtool_set_eee,
 };
 
 /* Used for PPv2.1, or PPv2.2 with the old Device Tree binding that
@@ -6623,6 +6650,57 @@ static void mvpp2_mac_link_down(struct phylink_config *config,
 	mvpp2_port_disable(port);
 }
 
+static void mvpp2_mac_disable_tx_lpi(struct phylink_config *config)
+{
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
+
+	mvpp2_modify(port->base + MVPP2_GMAC_LPI_CTRL1,
+		     MVPP2_GMAC_LPI_CTRL1_REQ_EN, 0);
+}
+
+static void mvpp2_mac_enable_tx_lpi(struct phylink_config *config, u32 timer)
+{
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
+	u32 ts, tw, lpi0, lpi1, status;
+
+	status = readl(port->base + MVPP2_GMAC_STATUS0);
+	if (status & MVPP2_GMAC_STATUS0_GMII_SPEED) {
+		/* At 1G speeds, the timer resolution are 1us, and
+		 * 802.3 says tw is 16.5us. Round up to 17us.
+		 */
+		tw = 17;
+		ts = timer;
+	} else {
+		/* At 100M speeds, the timer resolutions are 10us, and
+		 * 802.3 says tw is 30us.
+		 */
+		tw = 3;
+		ts = DIV_ROUND_UP(timer, 10);
+	}
+
+	if (ts > 255)
+		ts = 255;
+
+	/* Ensure LPI generation is disabled */
+	lpi1 = readl(port->base + MVPP2_GMAC_LPI_CTRL1);
+	writel(lpi1 & ~MVPP2_GMAC_LPI_CTRL1_REQ_EN,
+	       port->base + MVPP2_GMAC_LPI_CTRL1);
+
+	/* Configure ts */
+	lpi0 = readl(port->base + MVPP2_GMAC_LPI_CTRL0);
+	lpi0 &= ~MVPP2_GMAC_LPI_CTRL0_TS_MASK;
+	lpi0 |= FIELD_PREP(MVPP2_GMAC_LPI_CTRL0_TS_MASK, ts);
+	writel(lpi0, port->base + MVPP2_GMAC_LPI_CTRL0);
+
+	/* Configure tw */
+	lpi1 &= ~MVPP2_GMAC_LPI_CTRL1_TW_MASK;
+	lpi1 |= FIELD_PREP(MVPP2_GMAC_LPI_CTRL1_TW_MASK, tw);
+
+	/* Enable LPI generation */
+	writel(lpi1 | MVPP2_GMAC_LPI_CTRL1_REQ_EN,
+	       port->base + MVPP2_GMAC_LPI_CTRL1);
+}
+
 static const struct phylink_mac_ops mvpp2_phylink_ops = {
 	.mac_select_pcs = mvpp2_select_pcs,
 	.mac_prepare = mvpp2_mac_prepare,
@@ -6630,6 +6708,8 @@ static const struct phylink_mac_ops mvpp2_phylink_ops = {
 	.mac_finish = mvpp2_mac_finish,
 	.mac_link_up = mvpp2_mac_link_up,
 	.mac_link_down = mvpp2_mac_link_down,
+	.mac_enable_tx_lpi = mvpp2_mac_enable_tx_lpi,
+	.mac_disable_tx_lpi = mvpp2_mac_disable_tx_lpi,
 };
 
 /* Work-around for ACPI */
@@ -6968,6 +7048,11 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 				  port->phylink_config.supported_interfaces);
 		}
 
+		/* Setup EEE.  Choose 250us idle. */
+		port->phylink_config.eee.eee_enabled = true;
+		port->phylink_config.eee.tx_lpi_enabled = true;
+		port->phylink_config.eee.tx_lpi_timer = 250;
+
 		phylink = phylink_create(&port->phylink_config, port_fwnode,
 					 phy_mode, &mvpp2_phylink_ops);
 		if (IS_ERR(phylink)) {
-- 
2.30.2


