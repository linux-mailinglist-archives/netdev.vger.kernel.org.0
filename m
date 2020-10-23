Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5C6296D29
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 12:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462564AbgJWK4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 06:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462552AbgJWK4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 06:56:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4218C0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 03:56:37 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukG-00087r-Kr; Fri, 23 Oct 2020 12:56:28 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukF-0001km-H8; Fri, 23 Oct 2020 12:56:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>, linux-can@vger.kernel.org
Subject: [RFC PATCH v1 5/6] can: flexcan: add phylink support
Date:   Fri, 23 Oct 2020 12:56:25 +0200
Message-Id: <20201023105626.6534-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201023105626.6534-1-o.rempel@pengutronix.de>
References: <20201023105626.6534-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/can/Kconfig   |   2 +
 drivers/net/can/flexcan.c | 133 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 424970939fd4..fc5db96a34be 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -98,6 +98,8 @@ config CAN_AT91
 config CAN_FLEXCAN
 	tristate "Support for Freescale FLEXCAN based chips"
 	depends on OF && HAS_IOMEM
+	select PHYLINK
+	select CAN_PHY
 	help
 	  Say Y here if you want to support for Freescale FlexCAN.
 
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 881799bd9c5e..c320eed31322 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -14,6 +14,7 @@
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
 #include <linux/can/led.h>
+#include <linux/can/phy.h>
 #include <linux/can/rx-offload.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
@@ -24,6 +25,9 @@
 #include <linux/netdevice.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_mdio.h>
+#include <linux/of_net.h>
+#include <linux/phylink.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -361,6 +365,10 @@ struct flexcan_priv {
 	/* Read and Write APIs */
 	u32 (*read)(void __iomem *addr);
 	void (*write)(u32 val, void __iomem *addr);
+
+	phy_interface_t phy_if_mode;
+	struct phylink *phylink;
+	struct phylink_config phylink_config;
 };
 
 static const struct flexcan_devtype_data fsl_p1010_devtype_data = {
@@ -1653,9 +1661,16 @@ static int flexcan_open(struct net_device *dev)
 		return -EINVAL;
 	}
 
+	err = phylink_of_phy_connect(priv->phylink, priv->dev->of_node, 0);
+	if (err) {
+		netdev_err(dev, "phylink_of_phy_connect filed with err: %i\n",
+			   err);
+		return err;
+	}
+
 	err = pm_runtime_get_sync(priv->dev);
 	if (err < 0)
-		return err;
+		goto out_phy_put;
 
 	err = open_candev(dev);
 	if (err)
@@ -1710,6 +1725,8 @@ static int flexcan_open(struct net_device *dev)
 	can_rx_offload_enable(&priv->offload);
 	netif_start_queue(dev);
 
+	phylink_start(priv->phylink);
+
 	return 0;
 
  out_offload_del:
@@ -1720,6 +1737,8 @@ static int flexcan_open(struct net_device *dev)
 	close_candev(dev);
  out_runtime_put:
 	pm_runtime_put(priv->dev);
+ out_phy_put:
+	phylink_disconnect_phy(priv->phylink);
 
 	return err;
 }
@@ -1740,6 +1759,104 @@ static int flexcan_close(struct net_device *dev)
 
 	can_led_event(dev, CAN_LED_EVENT_STOP);
 
+	phylink_stop(priv->phylink);
+	phylink_disconnect_phy(priv->phylink);
+
+	return 0;
+}
+
+static void flexcan_mac_config(struct phylink_config *config, unsigned int mode,
+			      const struct phylink_link_state *state)
+{
+	/* Not Supported */
+}
+
+static void flexcan_mac_validate(struct phylink_config *config,
+			    unsigned long *supported,
+			    struct phylink_link_state *state)
+{
+	struct flexcan_priv *priv = netdev_priv(to_net_dev(config->dev));
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_CAN:
+		break;
+	default:
+		goto unsupported;
+	}
+
+	phylink_set(mask, CAN_HS);
+	phylink_set(mask, CAN_LS);
+	phylink_set(mask, CAN_SW);
+
+	/* max bitrate supported by the controller */
+	if (!state->max_bitrate || state->max_bitrate > 1000000)
+		state->max_bitrate = 1000000;
+
+	priv->can.bitrate_max = state->max_bitrate;
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+	return;
+unsupported:
+	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static void flexcan_mac_pcs_get_state(struct phylink_config *config,
+				     struct phylink_link_state *state)
+{
+	state->link = 0;
+}
+
+static void flexcan_mac_an_restart(struct phylink_config *config)
+{
+	/* Not Supported */
+}
+
+static void flexcan_mac_link_down(struct phylink_config *config,
+				 unsigned int mode, phy_interface_t interface)
+{
+	/* Not Supported */
+}
+
+static void flexcan_mac_link_up(struct phylink_config *config,
+			       struct phy_device *phy,
+			       unsigned int mode, phy_interface_t interface,
+			       int speed, int duplex,
+			       bool tx_pause, bool rx_pause)
+{
+	/* Not Supported */
+}
+
+
+
+static const struct phylink_mac_ops flexcan_phylink_mac_ops = {
+	.validate = flexcan_mac_validate,
+	.mac_pcs_get_state = flexcan_mac_pcs_get_state,
+	.mac_an_restart = flexcan_mac_an_restart,
+	.mac_config = flexcan_mac_config,
+	.mac_link_down = flexcan_mac_link_down,
+	.mac_link_up = flexcan_mac_link_up,
+};
+
+static int flexcan_phylink_setup(struct flexcan_priv *priv,
+				 struct net_device *dev)
+{
+	struct phylink *phylink;
+
+	priv->phylink_config.dev = &dev->dev;
+	priv->phylink_config.type = PHYLINK_NETDEV;
+
+	phylink = phylink_create(&priv->phylink_config, priv->dev->fwnode,
+				 priv->phy_if_mode, &flexcan_phylink_mac_ops);
+	if (IS_ERR(phylink))
+		return PTR_ERR(phylink);
+
+	priv->phylink = phylink;
 	return 0;
 }
 
@@ -1818,6 +1935,12 @@ static int register_flexcandev(struct net_device *dev)
 	if (err)
 		goto out_chip_disable;
 
+	err = flexcan_phylink_setup(priv, dev);
+	if (err) {
+		netdev_err(dev, "failed to setup phylink (%d)\n", err);
+		goto out_chip_disable;
+	}
+
 	/* Disable core and let pm_runtime_put() disable the clocks.
 	 * If CONFIG_PM is not enabled, the clocks will stay powered.
 	 */
@@ -1921,6 +2044,7 @@ static int flexcan_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id;
 	const struct flexcan_devtype_data *devtype_data;
+	phy_interface_t phy_if_mode;
 	struct net_device *dev;
 	struct flexcan_priv *priv;
 	struct regulator *reg_xceiver;
@@ -1943,6 +2067,12 @@ static int flexcan_probe(struct platform_device *pdev)
 				     "clock-frequency", &clock_freq);
 		of_property_read_u8(pdev->dev.of_node,
 				    "fsl,clk-source", &clk_src);
+		can_phy_register(pdev->dev.of_node);
+		err = of_get_phy_mode(pdev->dev.of_node, &phy_if_mode);
+		if (err) {
+			dev_err(&pdev->dev, "missing phy-mode property in DT\n");
+			return err;
+		}
 	}
 
 	if (!clock_freq) {
@@ -2019,6 +2149,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	priv->clk_src = clk_src;
 	priv->devtype_data = devtype_data;
 	priv->reg_xceiver = reg_xceiver;
+	priv->phy_if_mode = phy_if_mode;
 
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD |
-- 
2.28.0

