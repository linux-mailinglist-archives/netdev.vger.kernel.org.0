Return-Path: <netdev+bounces-2521-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 026497024FA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABC322812A3
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A85F79FC;
	Mon, 15 May 2023 06:36:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663F346AA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:36:54 +0000 (UTC)
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11A7114
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 23:36:51 -0700 (PDT)
X-QQ-mid: bizesmtp69t1684132440teumfgrm
Received: from wxdbg.localdomain.com ( [115.200.228.151])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 15 May 2023 14:33:59 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: D6RqbDSxuq6Vjap+/VvgDo8xrLWVC5yHeC7PM1G9I/Cq/HLJ2EEEsQ/xYLk43
	NQ42npCIRzx9FrqiTBxVSW7twY+aiiJuDgLPuDDk/xfq7rAjuKVL4BaS51InINsH64V8jbg
	ePnpP4WbluZ9O3BG//IlMfai2108YUYP9eQaZFA5C+Nzgxz8qKyNaI/GiXHorxr74wjMNBp
	uSjijDUfvXmL6DWTpyz7JBj+EasDGMQz4eYvTmrYFXvg+gUIaiBVAT3E8VLS1fJlIRGy4Sx
	KDaZ+SUyd/n0l/UqTfyT4gNTgZDAA8bal7zTddeGm9cxuGuNKUiWVHHz47w4VIbZDKoDp9B
	1nRwXWyBpZjZPOpeZYg1vAramirkf1jzxKABjAJ2tADyyTO0LmWkWIkDAGyWV/9vceeIxeJ
	EZP9QK52xC7p0IGShxIGk2crJ1sVEpC5
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 6197810624522479615
From: Jiawen Wu <jiawenwu@trustnetic.com>
To: netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com,
	jsd@semihalf.com,
	Jose.Abreu@synopsys.com,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk
Cc: linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v8 9/9] net: txgbe: Support phylink MAC layer
Date: Mon, 15 May 2023 14:32:00 +0800
Message-Id: <20230515063200.301026-10-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230515063200.301026-1-jiawenwu@trustnetic.com>
References: <20230515063200.301026-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add phylink support to Wangxun 10Gb Ethernet controller for the 10GBASE-R
interface.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |   1 +
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  28 +++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  23 ++--
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 113 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   5 +
 5 files changed, 155 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index f3fb273e6fd0..2ca163f07359 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -46,6 +46,7 @@ config TXGBE
 	select REGMAP
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
index ded04e9e136f..bdf735e863eb 100644
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
index 36c6517c7266..8500b9a57dcd 100644
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
@@ -161,6 +163,95 @@ static int txgbe_mdio_pcs_init(struct txgbe *txgbe)
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
@@ -322,6 +413,9 @@ static void txgbe_irq_handler(struct irq_desc *desc)
 	irq_hw_number_t hwirq;
 	unsigned long gpioirq;
 	struct gpio_chip *gc;
+	u32 eicr;
+
+	eicr = wx_misc_isb(wx, WX_ISB_MISC);
 
 	chained_irq_enter(chip, desc);
 
@@ -340,6 +434,12 @@ static void txgbe_irq_handler(struct irq_desc *desc)
 
 	chained_irq_exit(chip, desc);
 
+	if (eicr & (TXGBE_PX_MISC_ETH_LK | TXGBE_PX_MISC_ETH_LKDN)) {
+		u32 reg = rd32(wx, TXGBE_CFG_PORT_ST);
+
+		phylink_mac_change(txgbe->phylink, !!(reg & TXGBE_CFG_PORT_ST_LINK_UP));
+	}
+
 	/* unmask interrupt */
 	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
 }
@@ -513,16 +613,22 @@ int txgbe_init_phy(struct txgbe *txgbe)
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
@@ -544,6 +650,8 @@ int txgbe_init_phy(struct txgbe *txgbe)
 err_unregister_clk:
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
+err_destroy_phylink:
+	phylink_destroy(txgbe->phylink);
 err_destroy_xpcs:
 	xpcs_destroy(txgbe->xpcs);
 err_unregister_swnode:
@@ -558,6 +666,7 @@ void txgbe_remove_phy(struct txgbe *txgbe)
 	platform_device_unregister(txgbe->i2c_dev);
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
+	phylink_destroy(txgbe->phylink);
 	xpcs_destroy(txgbe->xpcs);
 	software_node_unregister_node_group(txgbe->nodes.group);
 }
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 6c0393c19b83..7e46ebf704c8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -77,6 +77,10 @@
 	 TXGBE_PX_MISC_ETH_AN | TXGBE_PX_MISC_INT_ERR |   \
 	 TXGBE_PX_MISC_GPIO)
 
+/* Port cfg registers */
+#define TXGBE_CFG_PORT_ST                       0x14404
+#define TXGBE_CFG_PORT_ST_LINK_UP               BIT(0)
+
 /* I2C registers */
 #define TXGBE_I2C_BASE                          0x14900
 
@@ -177,6 +181,7 @@ struct txgbe {
 	struct txgbe_nodes nodes;
 	struct mdio_device *mdiodev;
 	struct dw_xpcs *xpcs;
+	struct phylink *phylink;
 	struct platform_device *sfp_dev;
 	struct platform_device *i2c_dev;
 	struct clk_lookup *clock;
-- 
2.27.0


