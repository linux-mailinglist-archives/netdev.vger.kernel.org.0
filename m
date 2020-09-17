Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D3A26E7AC
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgIQVsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:48:07 -0400
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:47854 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbgIQVsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 17:48:06 -0400
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 17:48:05 EDT
Received: from metamini.metanet (metamini.metanet [192.168.2.5])
        by blackbox.su (Postfix) with ESMTP id CB61881828;
        Fri, 18 Sep 2020 00:39:24 +0300 (MSK)
From:   Sergej Bauer <sbauer@blackbox.su>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     sbauer@blackbox.su, Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] add virtual PHY for PHY-less devices
Date:   Fri, 18 Sep 2020 00:40:10 +0300
Message-Id: <20200917214030.646-1-sbauer@blackbox.su>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sbauer@blackbox.su

    Here is a kernel related part of my work which was helps to develop brand
new PHY device.

    It is migth be helpful for developers work with PHY-less lan743x
(7431:0011 in my case). It's just a fake virtual PHY which can change speed of
network card processing as a loopback device. Baud rate can be tuned with
ethtool from command line or by means of SIOCSMIIREG ioctl. Duplex mode not
configurable and it's allways DUPLEX_FULL.

    It also provides module parameter mii_regs for setting initial values of
IEEE 802.3 Control Register.

diff --git a/MAINTAINERS b/MAINTAINERS
index f0068bceeb61..d4c10895aa13 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11423,6 +11448,12 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/microchip/lan743x_*
 
+MICROCHIP LAN743X VIRTUAL PHY DRIVER
+M:	Sergej Bauer <sbauer@blackbox.su>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/microchip/lan743x_virtual_phy.*
+
 MICROCHIP LCDFB DRIVER
 M:	Nicolas Ferre <nicolas.ferre@microchip.com>
 L:	linux-fbdev@vger.kernel.org
diff --git a/drivers/net/ethernet/microchip/Makefile b/drivers/net/ethernet/microchip/Makefile
index da603540ca57..8850ba5f5104 100644
--- a/drivers/net/ethernet/microchip/Makefile
+++ b/drivers/net/ethernet/microchip/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_ENC28J60) += enc28j60.o
 obj-$(CONFIG_ENCX24J600) += encx24j600.o encx24j600-regmap.o
 obj-$(CONFIG_LAN743X) += lan743x.o
 
-lan743x-objs := lan743x_main.o lan743x_ethtool.o lan743x_ptp.o
+lan743x-objs := lan743x_main.o lan743x_ethtool.o lan743x_ptp.o \
+	lan743x_virtual_phy.o
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index dcde496da7fb..0eaa20529ba2 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -815,6 +815,72 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 }
 #endif /* CONFIG_PM */
 
+int lan743x_set_link_ksettings(struct net_device *netdev,
+			       const struct ethtool_link_ksettings *cmd)
+{
+	struct ethtool_link_ksettings *cmd_ref =
+		(struct ethtool_link_ksettings *)cmd;
+	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	u8 duplex = cmd->base.duplex;
+	u32 speed = cmd->base.speed;
+	u16 v = 0, mac_rx, mac_tx;
+
+	if (speed &&
+	    speed != SPEED_10 && speed != SPEED_100 && speed != SPEED_1000) {
+		netdev_err(netdev, "%s: unknown speed %d\n",
+			   netdev->name, speed);
+		goto out;
+	}
+
+	mac_tx = lan743x_csr_read(adapter, MAC_TX);
+	mac_rx = lan743x_csr_read(adapter, MAC_RX);
+
+	if (adapter->virtual_phy) {
+		v = adapter->regs802p3[0];
+		v &= ~(BMCR_SPEED1000 | BMCR_SPEED100);
+
+		lan743x_netdev_set_bit(netdev, MAC_CR, 12, 0); // ADD
+		lan743x_netdev_set_bit(netdev, MAC_CR, 11, 0); // ASD
+		duplex = DUPLEX_FULL;
+		switch (speed) {
+		case 0:
+			break;
+		case SPEED_10:
+			lan743x_netdev_set_bit(netdev, MAC_CR, 2, 0);
+			lan743x_netdev_set_bit(netdev, MAC_CR, 1, 0);
+			netif_info(adapter, probe, adapter->netdev,
+				   "lan743x: speed 10Mbps/%s\n",
+				   duplex ? "Full" : "Half");
+			break;
+		case SPEED_100:
+			v |= BMCR_SPEED100;
+			lan743x_netdev_set_bit(netdev, MAC_CR, 2, 0);
+			lan743x_netdev_set_bit(netdev, MAC_CR, 1, 1);
+			netif_info(adapter, probe, adapter->netdev,
+				   "lan743x: speed 100Mbps/%s\n",
+				   duplex ? "Full" : "Half");
+			break;
+		case SPEED_1000:
+			v |= BMCR_SPEED1000;
+			lan743x_netdev_set_bit(netdev, MAC_CR, 2, 1);
+			lan743x_netdev_set_bit(netdev, MAC_CR, 1, 0);
+			netif_info(adapter, probe, adapter->netdev,
+				   "lan743x: speed 1Gbps/%s\n",
+				   duplex ? "Full" : "Half");
+			break;
+		default:
+			return -EINVAL;
+		};
+
+		v |= BMCR_LOOPBACK | BMCR_FULLDPLX;
+		adapter->regs802p3[0] = v;
+		cmd_ref->base.duplex = duplex;
+	}
+
+out:
+	return phy_ethtool_set_link_ksettings(netdev, cmd);
+}
+
 const struct ethtool_ops lan743x_ethtool_ops = {
 	.get_drvinfo = lan743x_ethtool_get_drvinfo,
 	.get_msglevel = lan743x_ethtool_get_msglevel,
@@ -838,7 +904,7 @@ const struct ethtool_ops lan743x_ethtool_ops = {
 	.get_eee = lan743x_ethtool_get_eee,
 	.set_eee = lan743x_ethtool_set_eee,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
-	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.set_link_ksettings = lan743x_set_link_ksettings,
 #ifdef CONFIG_PM
 	.get_wol = lan743x_ethtool_get_wol,
 	.set_wol = lan743x_ethtool_set_wol,
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.h b/drivers/net/ethernet/microchip/lan743x_ethtool.h
index d0d11a777a58..5caeec9b12dd 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.h
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.h
@@ -6,6 +6,8 @@
 
 #include "linux/ethtool.h"
 
+int lan743x_set_link_ksettings(struct net_device *netdev,
+			       const struct ethtool_link_ksettings *cmd);
 extern const struct ethtool_ops lan743x_ethtool_ops;
 
 #endif /* _LAN743X_ETHTOOL_H */
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index de93cc6ebc1a..4f6052121a0c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2018 Microchip Technology Inc. */
 
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
@@ -15,8 +16,32 @@
 #include <linux/rtnetlink.h>
 #include <linux/iopoll.h>
 #include <linux/crc16.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/netdev_features.h>
 #include "lan743x_main.h"
 #include "lan743x_ethtool.h"
+#include "lan743x_virtual_phy.h"
+
+static char *mii_regs[16];
+static int mii_regs_count;
+module_param_array(mii_regs, charp, &mii_regs_count, 0644);
+
+static atomic_t device_no = ATOMIC_INIT(0);
+
+void lan743x_netdev_set_bit(struct net_device *netdev, int reg, int n,
+			    int state)
+{
+	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	u32 val;
+
+	val = lan743x_csr_read(adapter, reg);
+	if (state)
+		val |= BIT(n);
+	else
+		val &= ~BIT(n);
+	lan743x_csr_write(adapter, reg, val);
+}
 
 static void lan743x_pci_cleanup(struct lan743x_adapter *adapter)
 {
@@ -44,14 +69,18 @@ static int lan743x_pci_init(struct lan743x_adapter *adapter,
 	if (!test_bit(0, &bars))
 		goto disable_device;
 
-	ret = pci_request_selected_regions(pdev, bars, DRIVER_NAME);
+	adapter->name = kzalloc(strlen(DRIVER_NAME) + 3, GFP_KERNEL);
+	snprintf(adapter->name, strlen(DRIVER_NAME) + 2, "%s%d", DRIVER_NAME,
+		 atomic_read(&device_no));
+	ret = pci_request_selected_regions(pdev, bars, adapter->name);
 	if (ret)
 		goto disable_device;
-
+	atomic_inc(&device_no);
 	pci_set_master(pdev);
 	return 0;
 
 disable_device:
+	kfree(adapter->name);
 	pci_disable_device(adapter->pdev);
 
 return_error:
@@ -1012,8 +1041,16 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 
-	phy_stop(netdev->phydev);
-	phy_disconnect(netdev->phydev);
+	if (!netdev->phydev)
+		return;
+
+	if (adapter->virtual_phy) {
+		kfree(netdev->phydev);
+		kfree(adapter->regs802p3);
+	} else {
+		phy_stop(netdev->phydev);
+		phy_disconnect(netdev->phydev);
+	}
 	netdev->phydev = NULL;
 }
 
@@ -1049,12 +1086,26 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 			goto return_error;
 	} else {
 		phydev = phy_find_first(adapter->mdiobus);
-		if (!phydev)
-			goto return_error;
+		if (!phydev) {
+			phydev = lan743x_virtual_phy(adapter, mii_regs,
+						     mii_regs_count);
+			if (!phydev) {
+				netif_warn(adapter, ifup, adapter->netdev,
+					   "cannot open PHY\n");
+				goto return_error;
+			}
+		}
+
+		if (adapter->virtual_phy) {
+			ret = lan743x_virtual_phy_connect(netdev, phydev,
+							  lan743x_phy_link_status_change,
+							  PHY_INTERFACE_MODE_GMII);
+		} else {
+			ret = phy_connect_direct(netdev, phydev,
+						 lan743x_phy_link_status_change,
+						 PHY_INTERFACE_MODE_GMII);
+		}
 
-		ret = phy_connect_direct(netdev, phydev,
-					 lan743x_phy_link_status_change,
-					 adapter->phy_mode);
 		if (ret)
 			goto return_error;
 	}
@@ -1066,9 +1117,11 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 	phy_support_asym_pause(phydev);
 	phy->fc_request_control = (FLOW_CTRL_RX | FLOW_CTRL_TX);
 	phy->fc_autoneg = phydev->autoneg;
+	if (!adapter->virtual_phy) {
+		phy_start(phydev);
+		phy_start_aneg(phydev);
+	}
 
-	phy_start(phydev);
-	phy_start_aneg(phydev);
 	return 0;
 
 return_error:
@@ -1962,6 +2015,8 @@ static struct sk_buff *lan743x_rx_allocate_skb(struct lan743x_rx *rx)
 	int length = 0;
 
 	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
+	if ((rx->adapter->netdev->features & NETIF_F_RXFCS) == 0)
+		length -= ETH_FCS_LEN;
 	return __netdev_alloc_skb(rx->adapter->netdev,
 				  length, GFP_ATOMIC | GFP_DMA);
 }
@@ -1974,6 +2029,10 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
 	int length = 0;
 
 	length = (LAN743X_MAX_FRAME_SIZE + ETH_HLEN + 4 + RX_HEAD_PADDING);
+
+	if ((rx->adapter->netdev->features & NETIF_F_RXFCS) == 0)
+		length -= ETH_FCS_LEN;
+
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
 	buffer_info->skb = skb;
@@ -2151,6 +2210,9 @@ static int lan743x_rx_process_packet(struct lan743x_rx *rx)
 			buffer_info->skb = NULL;
 			packet_length =	RX_DESC_DATA0_FRAME_LENGTH_GET_
 					(descriptor->data0);
+			if ((rx->adapter->netdev->features &
+				    NETIF_F_RXFCS) == 0)
+				packet_length -= ETH_FCS_LEN;
 			skb_put(skb, packet_length - 4);
 			skb->protocol = eth_type_trans(skb,
 						       rx->adapter->netdev);
@@ -2608,11 +2670,21 @@ static netdev_tx_t lan743x_netdev_xmit_frame(struct sk_buff *skb,
 static int lan743x_netdev_ioctl(struct net_device *netdev,
 				struct ifreq *ifr, int cmd)
 {
+	struct lan743x_adapter *adapter;
+	int ret;
+
+	adapter = netdev_priv(netdev);
 	if (!netif_running(netdev))
 		return -EINVAL;
 	if (cmd == SIOCSHWTSTAMP)
 		return lan743x_ptp_ioctl(netdev, ifr, cmd);
-	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
+
+	if (adapter->virtual_phy)
+		ret = lan743x_virtual_phy_mii_ioctl(netdev->phydev, ifr, cmd);
+	else
+		ret = phy_mii_ioctl(netdev->phydev, ifr, cmd);
+
+	return ret;
 }
 
 static void lan743x_netdev_set_multicast(struct net_device *netdev)
@@ -2696,7 +2768,55 @@ static int lan743x_netdev_set_mac_address(struct net_device *netdev,
 	return 0;
 }
 
+static int lan743x_netdev_set_features(struct net_device *netdev,
+				       netdev_features_t features)
+{
+	netdev_features_t features_diff = netdev->features ^ features;
+
+	if (!(features_diff & (NETIF_F_SG | NETIF_F_TSO | NETIF_F_HW_CSUM |
+			NETIF_F_RXCSUM | NETIF_F_RXFCS | NETIF_F_RXALL |
+			NETIF_F_LOOPBACK))) {
+		return 0;
+	}
+
+	if (features & NETIF_F_RXALL)
+		lan743x_netdev_set_bit(netdev, FCT_CFG, 0, 1);
+	else
+		lan743x_netdev_set_bit(netdev, FCT_CFG, 0, 0);
+
+	if (features & NETIF_F_RXFCS)
+		lan743x_netdev_set_bit(netdev, MAC_RX, 4, 0);
+	else
+		lan743x_netdev_set_bit(netdev, MAC_RX, 4, 1);
+
+	if (features & NETIF_F_RXCSUM)
+		lan743x_netdev_set_bit(netdev, MAC_WUCSR2, 31, 0);
+	else
+		lan743x_netdev_set_bit(netdev, MAC_WUCSR2, 31, 1);
+
+	if (features & NETIF_F_LOOPBACK)
+		lan743x_netdev_set_bit(netdev, MAC_CR, 10, 1);
+	else
+		lan743x_netdev_set_bit(netdev, MAC_CR, 10, 0);
+
+	netdev->features = features;
+
+	return 0;
+}
+
+static int lan743x_netdev_init(struct net_device *netdev)
+{
+	netdev->hw_features = NETIF_F_SG | NETIF_F_TSO | NETIF_F_HW_CSUM |
+			NETIF_F_RXCSUM | NETIF_F_RXFCS | NETIF_F_RXALL |
+			NETIF_F_LOOPBACK;
+	netdev->features = netdev->hw_features &
+			~(NETIF_F_RXFCS | NETIF_F_RXALL | NETIF_F_LOOPBACK);
+
+	return 0;
+}
+
 static const struct net_device_ops lan743x_netdev_ops = {
+	.ndo_init		= lan743x_netdev_init,
 	.ndo_open		= lan743x_netdev_open,
 	.ndo_stop		= lan743x_netdev_close,
 	.ndo_start_xmit		= lan743x_netdev_xmit_frame,
@@ -2705,6 +2825,7 @@ static const struct net_device_ops lan743x_netdev_ops = {
 	.ndo_change_mtu		= lan743x_netdev_change_mtu,
 	.ndo_get_stats64	= lan743x_netdev_get_stats64,
 	.ndo_set_mac_address	= lan743x_netdev_set_mac_address,
+	.ndo_set_features	= lan743x_netdev_set_features,
 };
 
 static void lan743x_hardware_cleanup(struct lan743x_adapter *adapter)
@@ -2724,6 +2845,8 @@ static void lan743x_full_cleanup(struct lan743x_adapter *adapter)
 	lan743x_mdiobus_cleanup(adapter);
 	lan743x_hardware_cleanup(adapter);
 	lan743x_pci_cleanup(adapter);
+
+	kfree(adapter->name);
 }
 
 static int lan743x_hardware_init(struct lan743x_adapter *adapter,
@@ -2856,6 +2979,7 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 
 	adapter->netdev->netdev_ops = &lan743x_netdev_ops;
 	adapter->netdev->ethtool_ops = &lan743x_ethtool_ops;
+	adapter->netdev->priv_flags |= IFF_SUPP_NOFCS;
 	adapter->netdev->features = NETIF_F_SG | NETIF_F_TSO | NETIF_F_HW_CSUM;
 	adapter->netdev->hw_features = adapter->netdev->features;
 
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index c61a40411317..4516c76acb08 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -104,6 +104,8 @@
 #define FCT_FLOW_CTL_ON_THRESHOLD_SET_(value)	\
 	((value << 0) & FCT_FLOW_CTL_ON_THRESHOLD_)
 
+#define FCT_CFG				(0x00DC)
+
 #define MAC_CR				(0x100)
 #define MAC_CR_MII_EN_			BIT(19)
 #define MAC_CR_EEE_EN_			BIT(17)
@@ -726,6 +728,9 @@ struct lan743x_adapter {
 
 #define LAN743X_ADAPTER_FLAG_OTP		BIT(0)
 	u32			flags;
+	u8			virtual_phy;
+	u16			*regs802p3;
+	char			*name;
 };
 
 #define LAN743X_COMPONENT_FLAG_RX(channel)  BIT(20 + (channel))
@@ -839,5 +844,7 @@ struct lan743x_rx_buffer_info {
 
 u32 lan743x_csr_read(struct lan743x_adapter *adapter, int offset);
 void lan743x_csr_write(struct lan743x_adapter *adapter, int offset, u32 data);
+void lan743x_netdev_set_bit(struct net_device *netdev, int reg, int n,
+			    int state);
 
 #endif /* _LAN743X_H */
diff --git a/drivers/net/ethernet/microchip/lan743x_virtual_phy.c b/drivers/net/ethernet/microchip/lan743x_virtual_phy.c
new file mode 100644
index 000000000000..6246b248f86e
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan743x_virtual_phy.c
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0+
+// Copyright (C) 2020 Sergej Bauer
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/crc32.h>
+#include <linux/microchipphy.h>
+#include <linux/net_tstamp.h>
+#include <linux/phy.h>
+#include <linux/rtnetlink.h>
+#include <linux/iopoll.h>
+#include <linux/crc16.h>
+#include <linux/netdev_features.h>
+#include "lan743x_main.h"
+#include "lan743x_ethtool.h"
+#include "lan743x_virtual_phy.h"
+
+int lan743x_virtual_phy_connect(struct net_device *netdev,
+				struct phy_device *phydev,
+				void (*handler)(struct net_device *),
+				phy_interface_t interface)
+{
+	phydev->adjust_link = handler;
+	phydev->attached_dev = netdev;
+	phydev->duplex = DUPLEX_FULL;
+	phydev->speed = SPEED_1000;
+	phydev->state = PHY_RUNNING;
+	phydev->autoneg = 1;
+	clear_bit(__LINK_STATE_NOCARRIER, &netdev->state);
+	netdev->flags |= IFF_UP; //IFF_LOOPBACK;
+	netdev->phydev = phydev;
+	write_lock_bh(&dev_base_lock);
+	netdev->operstate = IF_OPER_UP;
+	write_unlock_bh(&dev_base_lock);
+	netdev_state_change(netdev);
+
+	return 0;
+}
+
+int lan743x_virtual_phy_mii_ioctl(struct phy_device *phydev,
+				  struct ifreq *ifr, int cmd)
+{
+	struct ethtool_link_ksettings ksettings;
+	struct net_device *netdev = phydev->attached_dev;
+	struct mii_ioctl_data *mii_data = if_mii(ifr);
+	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	int duplex, ret = 0;
+	u16 val = mii_data->val_in;
+	u16 reg_num = mii_data->reg_num;
+
+	if (reg_num > 0x1f)
+		return -ERANGE;
+
+	memset(&ksettings, 0, sizeof(ksettings));
+	phy_ethtool_get_link_ksettings(netdev, &ksettings);
+	ksettings.base.autoneg = AUTONEG_DISABLE;
+	switch (cmd) {
+	case SIOCGMIIPHY:
+		break;
+	case SIOCGMIIREG:
+		if (reg_num < 0x20)
+			mii_data->val_out = adapter->regs802p3[reg_num];
+		break;
+	case SIOCSMIIREG:
+		switch (reg_num) {
+		case 0:
+			val &= ~BMCR_RESET;
+			val |= BMCR_LOOPBACK;
+			if (!(val & BMCR_FULLDPLX))
+				val |= BMCR_FULLDPLX;
+			val &= ~0x1f;
+
+			if (val & BMCR_ANRESTART)
+				val &= ~BMCR_ANRESTART;
+
+			if ((val & BMCR_SPEED1000) && (val & BMCR_SPEED100)) {
+				ret = -EINVAL;
+				netif_err(adapter, probe, adapter->netdev,
+					  "invalid values for bits 0.6 and 0.13");
+				break;
+			}
+
+			duplex = DUPLEX_FULL;
+			ksettings.base.duplex = DUPLEX_FULL;
+			if (val & BMCR_SPEED1000) {
+				ksettings.base.speed = SPEED_1000;
+			} else {
+				ksettings.base.speed = val & BMCR_SPEED100 ?
+				    SPEED_100 : SPEED_10;
+			}
+
+			break;
+
+		case 1:
+		case 2:
+		case 3:
+		case 15:
+		default:
+			break;
+		}
+		if (ret)
+			break;
+
+		adapter->regs802p3[reg_num] = val;
+		ret = lan743x_set_link_ksettings(netdev, &ksettings);
+
+		break;
+	default:
+		netdev_err(netdev, "lan743x: not supported ioctl %X\n", cmd);
+		ret = -EOPNOTSUPP;
+	};
+
+	return ret;
+}
+
+struct phy_device *lan743x_virtual_phy(struct lan743x_adapter *adapter,
+				       char *mii_regs[], int mi_regs_count)
+{
+	struct phy_device *phydev = NULL;
+	struct net_device *netdev = adapter->netdev;
+	struct ifreq ifr;
+	struct mii_ioctl_data mii_data;
+	long res;
+	int i, ret;
+
+	phydev = kzalloc(sizeof(*phydev), GFP_KERNEL);
+	phydev->attached_dev = netdev;
+	set_bit(__LINK_STATE_PRESENT, &netdev->state);
+	netdev->reg_state = NETREG_REGISTERED; //NETREG_DUMMY;
+	phy_set_asym_pause(phydev, true, true);
+
+	linkmode_zero(phydev->supported);
+	linkmode_zero(phydev->advertising);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT,
+			 phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			 phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+			 phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+			 phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+			 phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+			 phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+			 phydev->supported);
+	phy_advertise_supported(phydev);
+
+	phydev->state |= PHY_UP;
+	adapter->virtual_phy = 1;
+
+	/* create faked regs [0..1f] */
+	adapter->regs802p3 = kzalloc(sizeof(u16) * 32, GFP_KERNEL);
+	if (!adapter->regs802p3)
+		return NULL;
+
+	lan743x_netdev_set_bit(netdev, MAC_CR, 19, 0);
+	lan743x_netdev_set_bit(netdev, MAC_CR, 12, 0); // turn off ADD
+	lan743x_netdev_set_bit(netdev, MAC_CR, 11, 0); // turn off ASD
+	lan743x_netdev_set_bit(netdev, MAC_CR, 10, 1); // INT_LOOP
+	lan743x_netdev_set_bit(netdev, MAC_CR, 3, 1); // full duplex
+
+	memset(&ifr, 0, sizeof(struct ifreq));
+
+	if (mi_regs_count > 0) {
+		for (i = 0; i < mi_regs_count; i++) {
+			mii_data.reg_num = i;
+			ret = kstrtol(mii_regs[i], 16, &res);
+
+			if (ret == 0)
+				mii_data.val_in = res;
+			else
+				mii_data.val_in = 0xffff;
+
+			memcpy(&ifr.ifr_ifru.ifru_data, &mii_data,
+			       sizeof(mii_data));
+			ret = lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+			if (ret < 0)
+				return NULL;
+		}
+	} else {
+
+		mii_data.reg_num = 0x1;
+		mii_data.val_in = 0x796d;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = 0x2;
+		mii_data.val_in = (adapter->csr.id_rev & ID_REV_ID_MASK_) >> 16;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = 0x3;
+		mii_data.val_in = adapter->csr.id_rev & ID_REV_CHIP_REV_MASK_;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = 0xf;
+		mii_data.val_in = 0x3000;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+
+		mii_data.reg_num = 0x0;
+		mii_data.val_in = 0x4140;
+		memcpy(&ifr.ifr_ifru.ifru_data, &mii_data, sizeof(mii_data));
+		lan743x_virtual_phy_mii_ioctl(phydev, &ifr, SIOCSMIIREG);
+	}
+
+	return phydev;
+}
diff --git a/drivers/net/ethernet/microchip/lan743x_virtual_phy.h b/drivers/net/ethernet/microchip/lan743x_virtual_phy.h
new file mode 100644
index 000000000000..d91d322e16ce
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan743x_virtual_phy.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* Copyright (C) 2020 Sergej Bauer */
+
+#ifndef LAN743X_VIRTUAL_PHY_H
+#define LAN743X_VIRTUAL_PHY_H
+
+#include <linux/phy.h>
+#include <uapi/linux/if.h>
+#include "lan743x_main.h"
+
+int lan743x_virtual_phy_mii_ioctl(struct phy_device *phydev,
+				  struct ifreq *ifr, int cmd);
+
+struct phy_device *lan743x_virtual_phy(struct lan743x_adapter *adapter,
+				       char *mii_regs[], int mi_regs_count);
+
+int lan743x_virtual_phy_connect(struct net_device *netdev,
+				struct phy_device *phydev,
+				void (*handler)(struct net_device *),
+				phy_interface_t interface);
+#endif
