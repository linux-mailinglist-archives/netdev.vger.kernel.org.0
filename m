Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0746EB788
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 07:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjDVFDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 01:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDVFDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 01:03:41 -0400
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4203C1BE4;
        Fri, 21 Apr 2023 22:03:34 -0700 (PDT)
X-QQ-mid: bizesmtp66t1682139556t799mksa
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 22 Apr 2023 12:59:15 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: DQ0OCu3gog3rE8xw6j7RkzI2GTjKNF9tNpDWExj27WUlOKN9BHYuJjyoFMe2o
        Q/RO1nxGZiGtt7SnJ9N66yGnGtDInEolFMwdALeWE6yoprITNseED3dWWH0WmTDyHc4pc//
        9al6hTkZP6LZsul0c/l/aNwQOvdvGfiF4BXe+aCTcjvTuKKy+gwMsq/BrnZsIIw3K+M3Pwv
        zBHtR3mJqC960INQenQpPVMl6HHqbCnlo2yRgWrRp87dsEmQ9jz69N5cFz0RvK6YTH6nlkj
        IgjJAYucA8o9zMPwqG7inm1iHkFkwF+J/Taj2pJS8r2KgEsIE9yJRvWp/LzLX2S+IbLaB5a
        vxQaID3fmrY9ugpZB0jgBlJ2BpjXwb0O4fq6t+UUZ6Sc0lP/+7Y3TYsdkETXpdkrf+wrItS
        aqOLdzNmmoANue9uA0OhAA==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 14461354643565128443
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        andriy.shevchenko@linux.intel.com, hkallweit1@gmail.com
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v4 8/8] net: txgbe: Support phylink MAC layer
Date:   Sat, 22 Apr 2023 12:56:21 +0800
Message-Id: <20230422045621.360918-9-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230422045621.360918-1-jiawenwu@trustnetic.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR,
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
 drivers/net/ethernet/wangxun/Kconfig          |  1 +
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    | 28 ++++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 23 ++---
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 91 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  5 +
 5 files changed, 135 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index dde979b623fa..e303bff0b13a 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -43,6 +43,7 @@ config TXGBE
 	select I2C_DESIGNWARE_PLATFORM
 	select GPIOLIB_IRQCHIP
 	select GPIOLIB
+	select PHYLINK
 	select PCS_XPCS
 	select LIBWX
 	select SFP
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
index b1ede19f4ff8..04091355a5d8 100644
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
index 3e5be9aa3b04..937ee9a703ec 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -8,11 +8,13 @@
 #include <linux/gpio/driver.h>
 #include <linux/gpio/property.h>
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
@@ -153,6 +155,95 @@ static int txgbe_mdio_pcs_init(struct txgbe *txgbe)
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
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 89a635593ae2..95ed19912a34 100644
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
 	struct gpio_chip *gpio;
-- 
2.27.0

