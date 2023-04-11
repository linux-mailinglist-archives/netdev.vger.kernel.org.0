Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCDA6DD6AB
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjDKJ3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjDKJ2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:28:49 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AB5E44;
        Tue, 11 Apr 2023 02:28:45 -0700 (PDT)
X-QQ-mid: bizesmtp91t1681205310tx0e5001
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 11 Apr 2023 17:28:29 +0800 (CST)
X-QQ-SSF: 01400000000000H0Z000000A0000000
X-QQ-FEAT: fs34Pe/+C2QCRbWdmZLGnSZ5LsQa3Q5fOAQ3B8m9qsXuZW7IG2XNFi71fPPvM
        7G5tsoffnXjT/MO+u5YZ9R7gBEe5CakXr1cWTs2y0flDQKFgp6B8vDb8ijPMfcD/XrbCHJL
        YZMVnkYcaNSYpfBm4XdIsstRiY2GYZ+Tek7Ty0of4BySFkJl7KJJVEA4tyIcRsDD0nSYVOL
        b1jmsILrW+IvVzUBmkuVlCrahq2Q80z5DovOHf3HA8FVI20P5duOOgEMo+ltQ+CX5+32TKc
        Nlw6g8nH9MLJGcaJH7TY+az0YHkR3FSI4alODXh6kM5CvDIhSWOTPxxVHZWryWrcZxBB15U
        wz0eZnsp4XTR/MsrZhB2dg73K0Ltyyy0ptVD7HA76rgYEoXVzl9Mg9C/dZmvJzADyw4TiwT
        ejAWWVn8wZSFXrWw/UKdbQ==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 15283253318957034505
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 6/6] net: txgbe: Support phylink MAC layer
Date:   Tue, 11 Apr 2023 17:27:25 +0800
Message-Id: <20230411092725.104992-7-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230411092725.104992-1-jiawenwu@trustnetic.com>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add phylink support to Wangxun 10Gb Ethernet controller, for the 10GBASE-R
and 1000BASE-X interfaces.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  34 ++++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  19 ++-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 111 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   5 +
 4 files changed, 156 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
index d914e9a05404..43ca84c90637 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
@@ -6,11 +6,45 @@
 #include <linux/netdevice.h>
 
 #include "../libwx/wx_ethtool.h"
+#include "../libwx/wx_type.h"
+#include "txgbe_type.h"
 #include "txgbe_ethtool.h"
 
+static int txgbe_nway_reset(struct net_device *netdev)
+{
+	struct wx *wx = netdev_priv(netdev);
+	struct txgbe *txgbe;
+
+	txgbe = (struct txgbe *)wx->priv;
+	return phylink_ethtool_nway_reset(txgbe->phylink);
+}
+
+static int txgbe_get_link_ksettings(struct net_device *netdev,
+				    struct ethtool_link_ksettings *cmd)
+{
+	struct wx *wx = netdev_priv(netdev);
+	struct txgbe *txgbe;
+
+	txgbe = (struct txgbe *)wx->priv;
+	return phylink_ethtool_ksettings_get(txgbe->phylink, cmd);
+}
+
+static int txgbe_set_link_ksettings(struct net_device *netdev,
+				    const struct ethtool_link_ksettings *cmd)
+{
+	struct wx *wx = netdev_priv(netdev);
+	struct txgbe *txgbe;
+
+	txgbe = (struct txgbe *)wx->priv;
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
index d8108ab30818..f640ff1a084e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -7,6 +7,7 @@
 #include <linux/netdevice.h>
 #include <linux/string.h>
 #include <linux/etherdevice.h>
+#include <linux/phylink.h>
 #include <net/ip.h>
 #include <linux/if_vlan.h>
 
@@ -204,7 +205,7 @@ static int txgbe_request_irq(struct wx *wx)
 
 static void txgbe_up_complete(struct wx *wx)
 {
-	u32 reg;
+	struct txgbe *txgbe = (struct txgbe *)wx->priv;
 
 	wx_control_hw(wx, true);
 	wx_configure_vectors(wx);
@@ -213,24 +214,16 @@ static void txgbe_up_complete(struct wx *wx)
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
 	netif_tx_start_all_queues(wx->netdev);
-	netif_carrier_on(wx->netdev);
 }
 
 static void txgbe_reset(struct wx *wx)
@@ -264,7 +257,6 @@ static void txgbe_disable_device(struct wx *wx)
 		wx_disable_rx_queue(wx, wx->rx_ring[i]);
 
 	netif_tx_stop_all_queues(netdev);
-	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
 	wx_irq_disable(wx);
@@ -295,8 +287,11 @@ static void txgbe_disable_device(struct wx *wx)
 
 static void txgbe_down(struct wx *wx)
 {
+	struct txgbe *txgbe = (struct txgbe *)wx->priv;
+
 	txgbe_disable_device(wx);
 	txgbe_reset(wx);
+	phylink_stop(txgbe->phylink);
 
 	wx_clean_all_tx_rings(wx);
 	wx_clean_all_rx_rings(wx);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 123fa7ed9039..84dc3e850036 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -13,6 +13,7 @@
 #include <linux/pci.h>
 
 #include "../libwx/wx_type.h"
+#include "../libwx/wx_lib.h"
 #include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_phy.h"
@@ -445,6 +446,98 @@ static int txgbe_mdio_pcs_init(struct txgbe *txgbe)
 	return 0;
 }
 
+static struct phylink_pcs *txgbe_phylink_mac_select(struct phylink_config *config,
+						    phy_interface_t interface)
+{
+	struct wx *wx = netdev_priv(to_net_dev(config->dev));
+	struct txgbe *txgbe = (struct txgbe *)wx->priv;
+
+	return &txgbe->pcs;
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
+	u32 txcfg, rxcfg, wdg;
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
+	rxcfg = rd32(wx, WX_MAC_RX_CFG);
+	wr32(wx, WX_MAC_RX_CFG, rxcfg);
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
+	__set_bit(PHY_INTERFACE_MODE_1000BASEX, config->supported_interfaces);
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
 static void txgbe_i2c_start(struct wx *wx, u16 dev_addr)
 {
 	wr32(wx, TXGBE_I2C_ENABLE, 0);
@@ -728,7 +821,9 @@ static void txgbe_irq_handler(struct irq_desc *desc)
 	struct gpio_chip *gc = txgbe->gpio;
 	irq_hw_number_t hwirq;
 	unsigned long gpioirq;
-	u32 gpio;
+	u32 gpio, eicr, reg;
+
+	eicr = wx_misc_isb(wx, WX_ISB_MISC);
 
 	chained_irq_enter(chip, desc);
 
@@ -744,6 +839,12 @@ static void txgbe_irq_handler(struct irq_desc *desc)
 
 	chained_irq_exit(chip, desc);
 
+	if (eicr & (TXGBE_PX_MISC_ETH_LK | TXGBE_PX_MISC_ETH_LKDN |
+		    TXGBE_PX_MISC_ETH_AN)) {
+		reg = rd32(wx, TXGBE_CFG_PORT_ST);
+		phylink_mac_change(txgbe->phylink, !!(reg & TXGBE_CFG_PORT_ST_LINK_UP));
+	}
+
 	/* unmask interrupt */
 	if (netif_running(wx->netdev))
 		wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
@@ -834,6 +935,12 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		goto err;
 	}
 
+	ret = txgbe_phylink_init(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to init phylink\n");
+		goto err;
+	}
+
 	ret = txgbe_i2c_adapter_add(txgbe);
 	if (ret) {
 		wx_err(txgbe->wx, "failed to init i2c interface: %d\n", ret);
@@ -862,6 +969,8 @@ int txgbe_init_phy(struct txgbe *txgbe)
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	if (txgbe->phylink)
+		phylink_destroy(txgbe->phylink);
 	if (txgbe->sfp_dev)
 		platform_device_unregister(txgbe->sfp_dev);
 	if (txgbe->i2c_adap)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index d83225b4e34e..45fb887aaf6d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -83,6 +83,10 @@
 				TXGBE_PX_MISC_INT_ERR | \
 				TXGBE_PX_MISC_GPIO)
 
+/* Port cfg registers */
+#define TXGBE_CFG_PORT_ST                       0x14404
+#define TXGBE_CFG_PORT_ST_LINK_UP               BIT(0)
+
 /* I2C registers */
 #define TXGBE_I2C_CON                           0x14900 /* I2C Control */
 #define TXGBE_I2C_CON_SLAVE_DISABLE             BIT(6)
@@ -244,6 +248,7 @@ struct txgbe {
 	struct txgbe_nodes nodes;
 	struct mdio_device *mdiodev;
 	struct phylink_pcs pcs;
+	struct phylink *phylink;
 	struct i2c_adapter *i2c_adap;
 	struct gpio_chip *gpio;
 	struct platform_device *sfp_dev;
-- 
2.27.0

