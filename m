Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC216EEF2B
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240018AbjDZHTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240025AbjDZHSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:18:48 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAFD40F4;
        Wed, 26 Apr 2023 00:17:53 -0700 (PDT)
X-QQ-mid: bizesmtp63t1682493396t1i57ydq
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 26 Apr 2023 15:16:34 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: 7L1V3dHhUFOG+fbANn/jygjn4JThUGLq7qHBiKlf8QQIJrGNIsvaIxUnGMO7O
        BzZMoQdUUVlWizvvqS4NwupgSV9ogR7g53oQ2d9jaiCOELXPTprQUKdVAKHNXUOgQPptBvE
        RnLDyz0FEcJ+8I3luNVNonHmSZuiZKjSNUlD9akh3p0Nd4X4o3H7ZGlrsI2e/3lG0kQTBC4
        TahHFgbBLT0q0UuTSSLAd0xwpfaa4cd24oUkoYynkse1Lz5PbG5FwGfDT1C8jVb4D7v8lBq
        p3VDHD48Kq1aN4foxs9awv1Pc+AUB/3TAT2XnzQRKw7/FB9spBikxOU4nCBb5uAz2Y+kw8W
        /7je8cB4icstVPJf2QJSfxx4Cj1j2sx5N4ABdB82szroEE8UXMQ5lhItxHCcF1dwKBDucUp
        xn7y6qz+J9CeVFE0qBoZdLtvLsGTp/AM
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 15994322969020987853
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
        andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        jsd@semihalf.com, ose.Abreu@synopsys.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next v5 9/9] net: txgbe: Support phylink MAC layer
Date:   Wed, 26 Apr 2023 15:14:34 +0800
Message-Id: <20230426071434.452717-10-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230426071434.452717-1-jiawenwu@trustnetic.com>
References: <20230426071434.452717-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add phylink support to Wangxun 10Gb Ethernet controller for the 10GBASE-R
interface.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |   1 +
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  28 +++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  23 ++--
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 113 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   5 +
 5 files changed, 154 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index 24338b754221..c11ce10435cc 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -45,6 +45,7 @@ config TXGBE
 	select GPIOLIB
 	select COMMON_CLK
 	select PCS_XPCS
+	select PHYLINK
 	select LIBWX
 	select SFP
 	help
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
index d914e9a05404..859da112586a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
@@ -6,11 +6,39 @@
 #include <linux/netdevice.h>
 
 #include "../libwx/wx_ethtool.h"
+#include "../libwx/wx_type.h"
+#include "txgbe_type.h"
 #include "txgbe_ethtool.h"
 
+static int txgbe_nway_reset(struct net_device *netdev)
+{
+	struct txgbe *txgbe = netdev_to_txgbe(netdev);
+
+	return phylink_ethtool_nway_reset(txgbe->phylink);
+}
+
+static int txgbe_get_link_ksettings(struct net_device *netdev,
+				    struct ethtool_link_ksettings *cmd)
+{
+	struct txgbe *txgbe = netdev_to_txgbe(netdev);
+
+	return phylink_ethtool_ksettings_get(txgbe->phylink, cmd);
+}
+
+static int txgbe_set_link_ksettings(struct net_device *netdev,
+				    const struct ethtool_link_ksettings *cmd)
+{
+	struct txgbe *txgbe = netdev_to_txgbe(netdev);
+
+	return phylink_ethtool_ksettings_set(txgbe->phylink, cmd);
+}
+
 static const struct ethtool_ops txgbe_ethtool_ops = {
 	.get_drvinfo		= wx_get_drvinfo,
+	.nway_reset		= txgbe_nway_reset,
 	.get_link		= ethtool_op_get_link,
+	.get_link_ksettings	= txgbe_get_link_ksettings,
+	.set_link_ksettings	= txgbe_set_link_ksettings,
 };
 
 void txgbe_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 608fbec55427..ef54adb865bd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -7,6 +7,7 @@
 #include <linux/netdevice.h>
 #include <linux/string.h>
 #include <linux/etherdevice.h>
+#include <linux/phylink.h>
 #include <net/ip.h>
 #include <linux/if_vlan.h>
 
@@ -204,7 +205,8 @@ static int txgbe_request_irq(struct wx *wx)
 
 static void txgbe_up_complete(struct wx *wx)
 {
-	u32 reg;
+	struct net_device *netdev = wx->netdev;
+	struct txgbe *txgbe = netdev_to_txgbe(netdev);
 
 	wx_control_hw(wx, true);
 	wx_configure_vectors(wx);
@@ -213,24 +215,16 @@ static void txgbe_up_complete(struct wx *wx)
 	smp_mb__before_atomic();
 	wx_napi_enable_all(wx);
 
+	phylink_start(txgbe->phylink);
+
 	/* clear any pending interrupts, may auto mask */
 	rd32(wx, WX_PX_IC(0));
 	rd32(wx, WX_PX_IC(1));
 	rd32(wx, WX_PX_MISC_IC);
 	txgbe_irq_enable(wx, true);
 
-	/* Configure MAC Rx and Tx when link is up */
-	reg = rd32(wx, WX_MAC_RX_CFG);
-	wr32(wx, WX_MAC_RX_CFG, reg);
-	wr32(wx, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
-	reg = rd32(wx, WX_MAC_WDG_TIMEOUT);
-	wr32(wx, WX_MAC_WDG_TIMEOUT, reg);
-	reg = rd32(wx, WX_MAC_TX_CFG);
-	wr32(wx, WX_MAC_TX_CFG, (reg & ~WX_MAC_TX_CFG_SPEED_MASK) | WX_MAC_TX_CFG_SPEED_10G);
-
 	/* enable transmits */
-	netif_tx_start_all_queues(wx->netdev);
-	netif_carrier_on(wx->netdev);
+	netif_tx_start_all_queues(netdev);
 }
 
 static void txgbe_reset(struct wx *wx)
@@ -264,7 +258,6 @@ static void txgbe_disable_device(struct wx *wx)
 		wx_disable_rx_queue(wx, wx->rx_ring[i]);
 
 	netif_tx_stop_all_queues(netdev);
-	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
 	wx_irq_disable(wx);
@@ -295,8 +288,12 @@ static void txgbe_disable_device(struct wx *wx)
 
 static void txgbe_down(struct wx *wx)
 {
+	struct net_device *netdev = wx->netdev;
+	struct txgbe *txgbe = netdev_to_txgbe(netdev);
+
 	txgbe_disable_device(wx);
 	txgbe_reset(wx);
+	phylink_stop(txgbe->phylink);
 
 	wx_clean_all_tx_rings(wx);
 	wx_clean_all_rx_rings(wx);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 39fe09e3a82c..b10edefccec8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -9,11 +9,13 @@
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
 #include <linux/pcs/pcs-xpcs.h>
+#include <linux/phylink.h>
 #include <linux/mdio.h>
 #include <linux/i2c.h>
 #include <linux/pci.h>
 
 #include "../libwx/wx_type.h"
+#include "../libwx/wx_lib.h"
 #include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_phy.h"
@@ -155,6 +157,95 @@ static int txgbe_mdio_pcs_init(struct txgbe *txgbe)
 	return 0;
 }
 
+static struct phylink_pcs *txgbe_phylink_mac_select(struct phylink_config *config,
+						    phy_interface_t interface)
+{
+	struct txgbe *txgbe = netdev_to_txgbe(to_net_dev(config->dev));
+
+	return &txgbe->xpcs->pcs;
+}
+
+static void txgbe_mac_config(struct phylink_config *config, unsigned int mode,
+			     const struct phylink_link_state *state)
+{
+}
+
+static void txgbe_mac_link_down(struct phylink_config *config,
+				unsigned int mode, phy_interface_t interface)
+{
+	struct wx *wx = netdev_priv(to_net_dev(config->dev));
+
+	wr32m(wx, WX_MAC_TX_CFG, WX_MAC_TX_CFG_TE, 0);
+}
+
+static void txgbe_mac_link_up(struct phylink_config *config,
+			      struct phy_device *phy,
+			      unsigned int mode, phy_interface_t interface,
+			      int speed, int duplex,
+			      bool tx_pause, bool rx_pause)
+{
+	struct wx *wx = netdev_priv(to_net_dev(config->dev));
+	u32 txcfg, wdg;
+
+	txcfg = rd32(wx, WX_MAC_TX_CFG);
+	txcfg &= ~WX_MAC_TX_CFG_SPEED_MASK;
+
+	switch (speed) {
+	case SPEED_10000:
+		txcfg |= WX_MAC_TX_CFG_SPEED_10G;
+		break;
+	case SPEED_1000:
+	case SPEED_100:
+	case SPEED_10:
+		txcfg |= WX_MAC_TX_CFG_SPEED_1G;
+		break;
+	default:
+		break;
+	}
+
+	wr32(wx, WX_MAC_TX_CFG, txcfg | WX_MAC_TX_CFG_TE);
+
+	/* Re configure MAC Rx */
+	wr32m(wx, WX_MAC_RX_CFG, WX_MAC_RX_CFG_RE, WX_MAC_RX_CFG_RE);
+	wr32(wx, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
+	wdg = rd32(wx, WX_MAC_WDG_TIMEOUT);
+	wr32(wx, WX_MAC_WDG_TIMEOUT, wdg);
+}
+
+static const struct phylink_mac_ops txgbe_mac_ops = {
+	.mac_select_pcs = txgbe_phylink_mac_select,
+	.mac_config = txgbe_mac_config,
+	.mac_link_down = txgbe_mac_link_down,
+	.mac_link_up = txgbe_mac_link_up,
+};
+
+static int txgbe_phylink_init(struct txgbe *txgbe)
+{
+	struct phylink_config *config;
+	struct fwnode_handle *fwnode;
+	struct wx *wx = txgbe->wx;
+	phy_interface_t phy_mode;
+	struct phylink *phylink;
+
+	config = devm_kzalloc(&wx->pdev->dev, sizeof(*config), GFP_KERNEL);
+	if (!config)
+		return -ENOMEM;
+
+	config->dev = &wx->netdev->dev;
+	config->type = PHYLINK_NETDEV;
+	config->mac_capabilities = MAC_10000FD | MAC_1000FD | MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
+	phy_mode = PHY_INTERFACE_MODE_10GBASER;
+	__set_bit(PHY_INTERFACE_MODE_10GBASER, config->supported_interfaces);
+	fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_PHYLINK]);
+	phylink = phylink_create(config, fwnode, phy_mode, &txgbe_mac_ops);
+	if (IS_ERR(phylink))
+		return PTR_ERR(phylink);
+
+	txgbe->phylink = phylink;
+
+	return 0;
+}
+
 static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
 {
 	struct wx *wx = gpiochip_get_data(chip);
@@ -301,7 +392,9 @@ static void txgbe_irq_handler(struct irq_desc *desc)
 	irq_hw_number_t hwirq;
 	unsigned long gpioirq;
 	struct gpio_chip *gc;
-	u32 gpio;
+	u32 gpio, eicr, reg;
+
+	eicr = wx_misc_isb(wx, WX_ISB_MISC);
 
 	chained_irq_enter(chip, desc);
 
@@ -318,6 +411,11 @@ static void txgbe_irq_handler(struct irq_desc *desc)
 
 	chained_irq_exit(chip, desc);
 
+	if (eicr & (TXGBE_PX_MISC_ETH_LK | TXGBE_PX_MISC_ETH_LKDN)) {
+		reg = rd32(wx, TXGBE_CFG_PORT_ST);
+		phylink_mac_change(txgbe->phylink, !!(reg & TXGBE_CFG_PORT_ST_LINK_UP));
+	}
+
 	/* unmask interrupt */
 	if (netif_running(wx->netdev))
 		wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
@@ -463,16 +561,22 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		goto err_unregister_swnode;
 	}
 
+	ret = txgbe_phylink_init(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to init phylink\n");
+		goto err_destroy_xpcs;
+	}
+
 	ret = txgbe_gpio_init(txgbe);
 	if (ret) {
 		wx_err(txgbe->wx, "failed to init gpio\n");
-		goto err_destroy_xpcs;
+		goto err_destroy_phylink;
 	}
 
 	ret = txgbe_clock_register(txgbe);
 	if (ret) {
 		wx_err(txgbe->wx, "failed to register clock: %d\n", ret);
-		goto err_destroy_xpcs;
+		goto err_destroy_phylink;
 	}
 
 	ret = txgbe_i2c_register(txgbe);
@@ -494,6 +598,8 @@ int txgbe_init_phy(struct txgbe *txgbe)
 err_unregister_clk:
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
+err_destroy_phylink:
+	phylink_destroy(txgbe->phylink);
 err_destroy_xpcs:
 	xpcs_destroy(txgbe->xpcs);
 err_unregister_swnode:
@@ -508,6 +614,7 @@ void txgbe_remove_phy(struct txgbe *txgbe)
 	platform_device_unregister(txgbe->i2c_dev);
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
+	phylink_destroy(txgbe->phylink);
 	xpcs_destroy(txgbe->xpcs);
 	software_node_unregister_node_group(txgbe->nodes.group);
 }
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 75b9c7ae3c21..a889f340b14d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -80,6 +80,10 @@
 				TXGBE_PX_MISC_INT_ERR | \
 				TXGBE_PX_MISC_GPIO)
 
+/* Port cfg registers */
+#define TXGBE_CFG_PORT_ST                       0x14404
+#define TXGBE_CFG_PORT_ST_LINK_UP               BIT(0)
+
 /* I2C registers */
 #define TXGBE_I2C_BASE                          0x14900
 
@@ -180,6 +184,7 @@ struct txgbe {
 	struct txgbe_nodes nodes;
 	struct mdio_device *mdiodev;
 	struct dw_xpcs *xpcs;
+	struct phylink *phylink;
 	struct platform_device *sfp_dev;
 	struct platform_device *i2c_dev;
 	struct clk_lookup *clock;
-- 
2.27.0

