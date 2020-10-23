Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8F2296B7A
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 10:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460862AbgJWIvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 04:51:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:3681 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S460850AbgJWIvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 04:51:41 -0400
IronPort-SDR: x6Kg29JAD/5W2HqBnKgoqOMZ1Ai8lkFGYVQTpeoIUXC4UWOCFA+orWEBHiJ/aMl1Egie2ERYkf
 BIsgv985d2PQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="165055365"
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="165055365"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 01:51:40 -0700
IronPort-SDR: 97ONuQMPwkIZntN6vHHqZrPbnDtKTFyJhZ/6wTnWQSDafz6vHXBrUJaGBGioQPDtfFg+DNKj7n
 khpbq8kyRrnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,407,1596524400"; 
   d="scan'208";a="523436331"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.141])
  by fmsmga006.fm.intel.com with ESMTP; 23 Oct 2020 01:51:37 -0700
From:   Xu Yilun <yilun.xu@intel.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, mdf@kernel.org,
        lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, trix@redhat.com, lgoncalv@redhat.com,
        yilun.xu@intel.com, hao.wu@intel.com,
        Russ Weight <russell.h.weight@intel.com>
Subject: [RFC PATCH 5/6] ethernet: dfl-eth-group: add DFL eth group private feature driver
Date:   Fri, 23 Oct 2020 16:45:44 +0800
Message-Id: <1603442745-13085-6-git-send-email-yilun.xu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver supports the DFL Ether Group private feature for the Intel(R)
PAC N3000 FPGA Smart NIC.

The DFL Ether Group private feature contains an Ether Wrapper and several
ports (phy-mac pair). There are two types of Ether Groups, line side &
host side. These 2 types of Ether Groups, together with FPGA internal
logic, act as several independent pipes between the host Ethernet
Controller and the front-panel cages. The FPGA logic between the 2 Ether
Groups implements user defined mac layer offloading.

The line side ether interfaces connect to the Parkvale serdes transceiver
chips, which are working in 4 ports 10G/25G retimer mode.

There are several configurations (8x10G, 2x1x25G, 2x2x25G ...) for
different connections between line side and host side. Not all links are
active in some configurations.

For the line side link, the driver connects to the Parkvale phy device
and then register net device for each active link.

For the host side link, its link state is always on. The host side link
always has same features as host side ether controller, so there is no
need to register a netdev for it. The driver just enables the link on
probe.

This patch supports the 25G configurations. Support for 10G will be in
other patches.

Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Russ Weight <russell.h.weight@intel.com>
---
 .../ABI/testing/sysfs-class-net-dfl-eth-group      |  19 +
 drivers/net/ethernet/intel/Kconfig                 |  18 +
 drivers/net/ethernet/intel/Makefile                |   2 +
 drivers/net/ethernet/intel/dfl-eth-group-25g.c     | 525 +++++++++++++++++
 drivers/net/ethernet/intel/dfl-eth-group-main.c    | 632 +++++++++++++++++++++
 drivers/net/ethernet/intel/dfl-eth-group.h         |  83 +++
 drivers/net/ethernet/intel/intel-m10-bmc-retimer.c |   4 +-
 7 files changed, 1282 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-dfl-eth-group
 create mode 100644 drivers/net/ethernet/intel/dfl-eth-group-25g.c
 create mode 100644 drivers/net/ethernet/intel/dfl-eth-group-main.c
 create mode 100644 drivers/net/ethernet/intel/dfl-eth-group.h

diff --git a/Documentation/ABI/testing/sysfs-class-net-dfl-eth-group b/Documentation/ABI/testing/sysfs-class-net-dfl-eth-group
new file mode 100644
index 0000000..ad528f2
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-net-dfl-eth-group
@@ -0,0 +1,19 @@
+What:		/sys/class/net/<iface>/tx_pause_frame_quanta
+Date:		Oct 2020
+KernelVersion:	5.11
+Contact:	Xu Yilun <yilun.xu@intel.com>
+Description:
+		Read-Write. Value representing the tx pause quanta of Pause
+		flow control frames to be sent to remote partner. Read the file
+		for the actual tx pause quanta value. Write the file to set
+		value of the tx pause quanta.
+
+What:		/sys/class/net/<iface>/tx_pause_frame_holdoff
+Date:		Oct 2020
+KernelVersion:	5.11
+Contact:	Xu Yilun <yilun.xu@intel.com>
+Description:
+		Read-Write. Value representing the separation between 2
+		consecutive XOFF flow control frames. Read the file for the
+		actual separation value. Write the file to set value of the
+		separation.
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 81c43d4..61b5d91 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -343,6 +343,24 @@ config IGC
 	  To compile this driver as a module, choose M here. The module
 	  will be called igc.
 
+config FPGA_DFL_ETH_GROUP
+        tristate "DFL Ether Group private feature support"
+        depends on FPGA_DFL && HAS_IOMEM
+        help
+          This driver supports DFL Ether Group private feature for
+	  Intel(R) PAC N3000 FPGA Smart NIC.
+
+	  The DFL Ether Group private feature contains several ether
+	  interfaces, each of them contains an Ether Wrapper and several
+	  ports (phy-mac pairs). There are two types of interfaces, Line
+	  side & CPU side. These 2 types of interfaces, together with FPGA
+	  internal logic, act as several independent pipes between the
+	  host Ethernet Controller and the front-panel cages. The FPGA
+	  logic between 2 interfaces implements user defined mac layer
+	  offloading.
+
+	  This driver implements each active port as a netdev.
+
 config INTEL_M10_BMC_RETIMER
 	tristate "Intel(R) MAX 10 BMC ethernet retimer support"
 	depends on MFD_INTEL_M10_BMC
diff --git a/drivers/net/ethernet/intel/Makefile b/drivers/net/ethernet/intel/Makefile
index 5965447..1624c26 100644
--- a/drivers/net/ethernet/intel/Makefile
+++ b/drivers/net/ethernet/intel/Makefile
@@ -17,4 +17,6 @@ obj-$(CONFIG_IAVF) += iavf/
 obj-$(CONFIG_FM10K) += fm10k/
 obj-$(CONFIG_ICE) += ice/
 
+dfl-eth-group-objs := dfl-eth-group-main.o dfl-eth-group-25g.o
+obj-$(CONFIG_FPGA_DFL_ETH_GROUP) += dfl-eth-group.o
 obj-$(CONFIG_INTEL_M10_BMC_RETIMER) += intel-m10-bmc-retimer.o
diff --git a/drivers/net/ethernet/intel/dfl-eth-group-25g.c b/drivers/net/ethernet/intel/dfl-eth-group-25g.c
new file mode 100644
index 0000000..a690364
--- /dev/null
+++ b/drivers/net/ethernet/intel/dfl-eth-group-25g.c
@@ -0,0 +1,525 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for 25G Ether Group private feature on Intel PAC (Programmable
+ * Acceleration Card) N3000
+ *
+ * Copyright (C) 2019-2020 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Wu Hao <hao.wu@intel.com>
+ *   Xu Yilun <yilun.xu@intel.com>
+ */
+#include <linux/netdevice.h>
+
+#include "dfl-eth-group.h"
+
+/* 25G PHY/MAC Register */
+#define PHY_CONFIG	0x310
+#define PHY_MAC_RESET_MASK	GENMASK(2, 0)
+#define PHY_PMA_SLOOP		0x313
+#define MAX_TX_SIZE_CONFIG	0x407
+#define MAX_RX_SIZE_CONFIG	0x506
+#define TX_FLOW_CTRL_EN		0x605
+#define TX_FLOW_CTRL_EN_PAUSE	BIT(0)
+#define TX_FLOW_CTRL_QUANTA	0x620
+#define TX_FLOW_CTRL_HOLDOFF	0x628
+#define TX_FLOW_CTRL_SEL	0x640
+#define TX_FLOW_CTRL_SEL_PAUSE	0x0
+#define TX_FLOW_CTRL_SEL_PFC	0x1
+
+static int edev25g40g_reset(struct eth_dev *edev, bool en)
+{
+	struct eth_com *mac = edev->mac;
+	struct device *dev = edev->dev;
+	u32 val;
+	int ret;
+
+	ret = eth_com_read_reg(mac, PHY_CONFIG, &val);
+	if (ret) {
+		dev_err(dev, "fail to read PHY_CONFIG: %d\n", ret);
+		return ret;
+	}
+
+	/* skip if config is in expected state already */
+	if ((((val & PHY_MAC_RESET_MASK) == PHY_MAC_RESET_MASK) && en) ||
+	    (((val & PHY_MAC_RESET_MASK) == 0) && !en))
+		return 0;
+
+	if (en)
+		val |= PHY_MAC_RESET_MASK;
+	else
+		val &= ~PHY_MAC_RESET_MASK;
+
+	ret = eth_com_write_reg(mac, PHY_CONFIG, val);
+	if (ret)
+		dev_err(dev, "fail to write PHY_CONFIG: %d\n", ret);
+
+	return ret;
+}
+
+static ssize_t tx_pause_frame_quanta_show(struct device *d,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(to_net_dev(d));
+	u32 data;
+	int ret;
+
+	ret = eth_com_read_reg(edev->mac, TX_FLOW_CTRL_QUANTA, &data);
+
+	return ret ? : sprintf(buf, "0x%x\n", data);
+}
+
+static ssize_t tx_pause_frame_quanta_store(struct device *d,
+					   struct device_attribute *attr,
+					   const char *buf, size_t len)
+{
+	struct net_device *netdev = to_net_dev(d);
+	struct eth_dev *edev;
+	u32 data;
+	int ret;
+
+	if (kstrtou32(buf, 0, &data))
+		return -EINVAL;
+
+	edev = net_device_to_eth_dev(netdev);
+
+	rtnl_lock();
+
+	if (netif_running(netdev)) {
+		netdev_err(netdev, "must be stopped to change pause param\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = eth_com_write_reg(edev->mac, TX_FLOW_CTRL_QUANTA, data);
+
+out:
+	rtnl_unlock();
+
+	return ret ? : len;
+}
+static DEVICE_ATTR_RW(tx_pause_frame_quanta);
+
+static ssize_t tx_pause_frame_holdoff_show(struct device *d,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(to_net_dev(d));
+	u32 data;
+	int ret;
+
+	ret = eth_com_read_reg(edev->mac, TX_FLOW_CTRL_HOLDOFF, &data);
+
+	return ret ? : sprintf(buf, "0x%x\n", data);
+}
+
+static ssize_t tx_pause_frame_holdoff_store(struct device *d,
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
+{
+	struct net_device *netdev = to_net_dev(d);
+	struct eth_dev *edev;
+	u32 data;
+	int ret;
+
+	if (kstrtou32(buf, 0, &data))
+		return -EINVAL;
+
+	edev = net_device_to_eth_dev(netdev);
+
+	rtnl_lock();
+
+	if (netif_running(netdev)) {
+		netdev_err(netdev, "must be stopped to change pause param\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = eth_com_write_reg(edev->mac, TX_FLOW_CTRL_HOLDOFF, data);
+
+out:
+	rtnl_unlock();
+
+	return ret ? : len;
+}
+static DEVICE_ATTR_RW(tx_pause_frame_holdoff);
+
+static struct attribute *edev25g_dev_attrs[] = {
+	&dev_attr_tx_pause_frame_quanta.attr,
+	&dev_attr_tx_pause_frame_holdoff.attr,
+	NULL
+};
+
+/* device attributes */
+static const struct attribute_group edev25g_attr_group = {
+	.attrs = edev25g_dev_attrs,
+};
+
+/* ethtool ops */
+static struct stat_info stats_25g[] = {
+	/* TX Statistics */
+	{STAT_INFO(0x800, "tx_fragments")},
+	{STAT_INFO(0x802, "tx_jabbers")},
+	{STAT_INFO(0x804, "tx_fcs")},
+	{STAT_INFO(0x806, "tx_crc_err")},
+	{STAT_INFO(0x808, "tx_mcast_data_err")},
+	{STAT_INFO(0x80a, "tx_bcast_data_err")},
+	{STAT_INFO(0x80c, "tx_ucast_data_err")},
+	{STAT_INFO(0x80e, "tx_mcast_ctrl_err")},
+	{STAT_INFO(0x810, "tx_bcast_ctrl_err")},
+	{STAT_INFO(0x812, "tx_ucast_ctrl_err")},
+	{STAT_INFO(0x814, "tx_pause_err")},
+	{STAT_INFO(0x816, "tx_64_byte")},
+	{STAT_INFO(0x818, "tx_65_127_byte")},
+	{STAT_INFO(0x81a, "tx_128_255_byte")},
+	{STAT_INFO(0x81c, "tx_256_511_byte")},
+	{STAT_INFO(0x81e, "tx_512_1023_byte")},
+	{STAT_INFO(0x820, "tx_1024_1518_byte")},
+	{STAT_INFO(0x822, "tx_1519_max_byte")},
+	{STAT_INFO(0x824, "tx_oversize")},
+	{STAT_INFO(0x826, "tx_mcast_data_ok")},
+	{STAT_INFO(0x828, "tx_bcast_data_ok")},
+	{STAT_INFO(0x82a, "tx_ucast_data_ok")},
+	{STAT_INFO(0x82c, "tx_mcast_ctrl_ok")},
+	{STAT_INFO(0x82e, "tx_bcast_ctrl_ok")},
+	{STAT_INFO(0x830, "tx_ucast_ctrl_ok")},
+	{STAT_INFO(0x832, "tx_pause")},
+	{STAT_INFO(0x834, "tx_runt")},
+	{STAT_INFO(0x860, "tx_payload_octets_ok")},
+	{STAT_INFO(0x862, "tx_frame_octets_ok")},
+
+	/* RX Statistics */
+	{STAT_INFO(0x900, "rx_fragments")},
+	{STAT_INFO(0x902, "rx_jabbers")},
+	{STAT_INFO(0x904, "rx_fcs")},
+	{STAT_INFO(0x906, "rx_crc_err")},
+	{STAT_INFO(0x908, "rx_mcast_data_err")},
+	{STAT_INFO(0x90a, "rx_bcast_data_err")},
+	{STAT_INFO(0x90c, "rx_ucast_data_err")},
+	{STAT_INFO(0x90e, "rx_mcast_ctrl_err")},
+	{STAT_INFO(0x910, "rx_bcast_ctrl_err")},
+	{STAT_INFO(0x912, "rx_ucast_ctrl_err")},
+	{STAT_INFO(0x914, "rx_pause_err")},
+	{STAT_INFO(0x916, "rx_64_byte")},
+	{STAT_INFO(0x918, "rx_65_127_byte")},
+	{STAT_INFO(0x91a, "rx_128_255_byte")},
+	{STAT_INFO(0x91c, "rx_256_511_byte")},
+	{STAT_INFO(0x91e, "rx_512_1023_byte")},
+	{STAT_INFO(0x920, "rx_1024_1518_byte")},
+	{STAT_INFO(0x922, "rx_1519_max_byte")},
+	{STAT_INFO(0x924, "rx_oversize")},
+	{STAT_INFO(0x926, "rx_mcast_data_ok")},
+	{STAT_INFO(0x928, "rx_bcast_data_ok")},
+	{STAT_INFO(0x92a, "rx_ucast_data_ok")},
+	{STAT_INFO(0x92c, "rx_mcast_ctrl_ok")},
+	{STAT_INFO(0x92e, "rx_bcast_ctrl_ok")},
+	{STAT_INFO(0x930, "rx_ucast_ctrl_ok")},
+	{STAT_INFO(0x932, "rx_pause")},
+	{STAT_INFO(0x934, "rx_runt")},
+	{STAT_INFO(0x960, "rx_payload_octets_ok")},
+	{STAT_INFO(0x962, "rx_frame_octets_ok")},
+};
+
+static void edev25g_get_strings(struct net_device *netdev, u32 stringset, u8 *s)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(netdev);
+	unsigned int i;
+
+	if (stringset != ETH_SS_STATS || edev->lw_mac)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(stats_25g); i++, s += ETH_GSTRING_LEN)
+		memcpy(s, stats_25g[i].string, ETH_GSTRING_LEN);
+}
+
+static int edev25g_get_sset_count(struct net_device *netdev, int stringset)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(netdev);
+
+	if (stringset != ETH_SS_STATS || edev->lw_mac)
+		return -EOPNOTSUPP;
+
+	return (int)ARRAY_SIZE(stats_25g);
+}
+
+static void edev25g_get_stats(struct net_device *netdev,
+			      struct ethtool_stats *stats, u64 *data)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(netdev);
+	unsigned int i;
+
+	if (edev->lw_mac || !netif_running(netdev))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(stats_25g); i++)
+		data[i] = read_mac_stats(edev->mac, stats_25g[i].addr);
+}
+
+static int edev25g_get_link_ksettings(struct net_device *netdev,
+				      struct ethtool_link_ksettings *cmd)
+{
+	if (!netdev->phydev)
+		return -ENODEV;
+
+	phy_ethtool_ksettings_get(netdev->phydev, cmd);
+
+	return 0;
+}
+
+static int edev25g_pause_init(struct net_device *netdev)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(netdev);
+
+	return eth_com_write_reg(edev->mac, TX_FLOW_CTRL_SEL,
+				 TX_FLOW_CTRL_SEL_PAUSE);
+}
+
+static void edev25g_get_pauseparam(struct net_device *netdev,
+				   struct ethtool_pauseparam *pause)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(netdev);
+	u32 data;
+	int ret;
+
+	pause->autoneg = 0;
+	pause->rx_pause = 0;
+
+	ret = eth_com_read_reg(edev->mac, TX_FLOW_CTRL_EN, &data);
+	if (ret) {
+		pause->tx_pause = 0;
+		return;
+	}
+
+	pause->tx_pause = (data & TX_FLOW_CTRL_EN_PAUSE) ? 0x1 : 0;
+}
+
+static int edev25g_set_pauseparam(struct net_device *netdev,
+				  struct ethtool_pauseparam *pause)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(netdev);
+	bool enable = pause->tx_pause;
+
+	if (pause->autoneg || pause->rx_pause)
+		return -EOPNOTSUPP;
+
+	return eth_com_write_reg(edev->mac, TX_FLOW_CTRL_EN,
+				 enable ? TX_FLOW_CTRL_EN_PAUSE : 0);
+}
+
+static const struct ethtool_ops edev25g_ethtool_ops = {
+	.get_link = ethtool_op_get_link,
+	.get_strings = edev25g_get_strings,
+	.get_sset_count = edev25g_get_sset_count,
+	.get_ethtool_stats = edev25g_get_stats,
+	.get_link_ksettings = edev25g_get_link_ksettings,
+	.get_pauseparam = edev25g_get_pauseparam,
+	.set_pauseparam = edev25g_set_pauseparam,
+};
+
+/* netdev ops */
+static int edev25g_netdev_open(struct net_device *netdev)
+{
+	struct n3000_net_priv *priv = netdev_priv(netdev);
+	struct eth_dev *edev = priv->edev;
+	int ret;
+
+	ret = edev25g40g_reset(edev, false);
+	if (ret)
+		return ret;
+
+	if (netdev->phydev)
+		phy_start(netdev->phydev);
+
+	return 0;
+}
+
+static int edev25g_netdev_stop(struct net_device *netdev)
+{
+	struct n3000_net_priv *priv = netdev_priv(netdev);
+	struct eth_dev *edev = priv->edev;
+	int ret;
+
+	ret = edev25g40g_reset(edev, true);
+	if (ret)
+		return ret;
+
+	if (netdev->phydev)
+		phy_stop(netdev->phydev);
+
+	return 0;
+}
+
+static int edev25g_mtu_init(struct net_device *netdev)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(netdev);
+	struct eth_com *mac = edev->mac;
+	u32 tx = 0, rx = 0, mtu;
+	int ret;
+
+	ret = eth_com_read_reg(mac, MAX_TX_SIZE_CONFIG, &tx);
+	if (ret)
+		return ret;
+
+	ret = eth_com_read_reg(mac, MAX_RX_SIZE_CONFIG, &rx);
+	if (ret)
+		return ret;
+
+	mtu = min(min(tx, rx), netdev->max_mtu);
+
+	ret = eth_com_write_reg(mac, MAX_TX_SIZE_CONFIG, rx);
+	if (ret)
+		return ret;
+
+	ret = eth_com_write_reg(mac, MAX_RX_SIZE_CONFIG, tx);
+	if (ret)
+		return ret;
+
+	netdev->mtu = mtu;
+
+	return 0;
+}
+
+static int edev25g_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(netdev);
+	struct eth_com *mac = edev->mac;
+	int ret;
+
+	ret = eth_com_write_reg(mac, MAX_TX_SIZE_CONFIG, new_mtu);
+	if (ret)
+		return ret;
+
+	ret = eth_com_write_reg(mac, MAX_RX_SIZE_CONFIG, new_mtu);
+	if (ret)
+		return ret;
+
+	netdev->mtu = new_mtu;
+
+	return 0;
+}
+
+static int edev25g_set_loopback(struct net_device *netdev, bool en)
+{
+	struct eth_dev *edev = net_device_to_eth_dev(netdev);
+
+	return eth_com_write_reg(edev->mac, PHY_PMA_SLOOP, en);
+}
+
+static int edev25g_set_features(struct net_device *netdev,
+				netdev_features_t features)
+{
+	netdev_features_t changed = netdev->features ^ features;
+
+	if (changed & NETIF_F_LOOPBACK)
+		return edev25g_set_loopback(netdev,
+					    !!(features & NETIF_F_LOOPBACK));
+
+	return 0;
+}
+
+static const struct net_device_ops edev25g_netdev_ops = {
+	.ndo_open = edev25g_netdev_open,
+	.ndo_stop = edev25g_netdev_stop,
+	.ndo_change_mtu = edev25g_change_mtu,
+	.ndo_set_features = edev25g_set_features,
+	.ndo_start_xmit = n3000_dummy_netdev_xmit,
+};
+
+static void edev25g_adjust_link(struct net_device *netdev)
+{}
+
+static int edev25g_netdev_init(struct net_device *netdev)
+{
+	int ret;
+
+	ret = edev25g_pause_init(netdev);
+	if (ret)
+		return ret;
+
+	ret = edev25g_mtu_init(netdev);
+	if (ret)
+		return ret;
+
+	return edev25g_set_loopback(netdev,
+				    !!(netdev->features & NETIF_F_LOOPBACK));
+}
+
+static int dfl_eth_dev_25g_init(struct eth_dev *edev)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	struct device *dev = edev->dev;
+	struct phy_device *phydev;
+	struct net_device *netdev;
+	int ret;
+
+	netdev = n3000_netdev_create(edev);
+	if (!netdev)
+		return -ENOMEM;
+
+	netdev->hw_features |= NETIF_F_LOOPBACK;
+	netdev->netdev_ops = &edev25g_netdev_ops;
+	netdev->ethtool_ops = &edev25g_ethtool_ops;
+
+	phydev = phy_connect(netdev, edev->phy_id, edev25g_adjust_link,
+			     PHY_INTERFACE_MODE_NA);
+	if (IS_ERR(phydev)) {
+		dev_err(dev, "PHY connection failed\n");
+		ret = PTR_ERR(phydev);
+		goto err_free_netdev;
+	}
+
+	linkmode_set_bit(ETHTOOL_LINK_MODE_25000baseCR_Full_BIT, mask);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_25000baseSR_Full_BIT, mask);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, mask);
+	linkmode_and(phydev->supported, phydev->supported, mask);
+	linkmode_copy(phydev->advertising, phydev->supported);
+
+	phy_attached_info(phydev);
+
+	ret = edev25g_netdev_init(netdev);
+	if (ret) {
+		dev_err(dev, "fail to init netdev %s\n", netdev->name);
+		goto err_phy_disconnect;
+	}
+
+	netdev->sysfs_groups[0] = &edev25g_attr_group;
+
+	netif_carrier_off(netdev);
+	ret = register_netdev(netdev);
+	if (ret) {
+		dev_err(dev, "fail to register netdev %s\n", netdev->name);
+		goto err_phy_disconnect;
+	}
+
+	edev->netdev = netdev;
+
+	return 0;
+
+err_phy_disconnect:
+	if (netdev->phydev)
+		phy_disconnect(phydev);
+err_free_netdev:
+	free_netdev(netdev);
+
+	return ret;
+}
+
+static void dfl_eth_dev_25g_remove(struct eth_dev *edev)
+{
+	struct net_device *netdev = edev->netdev;
+
+	if (netdev->phydev)
+		phy_disconnect(netdev->phydev);
+
+	unregister_netdev(netdev);
+}
+
+struct eth_dev_ops dfl_eth_dev_25g_ops = {
+	.lineside_init = dfl_eth_dev_25g_init,
+	.lineside_remove = dfl_eth_dev_25g_remove,
+	.reset = edev25g40g_reset,
+};
+
+struct eth_dev_ops dfl_eth_dev_40g_ops = {
+	.reset = edev25g40g_reset,
+};
diff --git a/drivers/net/ethernet/intel/dfl-eth-group-main.c b/drivers/net/ethernet/intel/dfl-eth-group-main.c
new file mode 100644
index 0000000..a29b8b1
--- /dev/null
+++ b/drivers/net/ethernet/intel/dfl-eth-group-main.c
@@ -0,0 +1,632 @@
+// SPDX-License-Identifier: GPL-2.0
+/* DFL device driver for Ether Group private feature on Intel PAC (Programmable
+ * Acceleration Card) N3000
+ *
+ * Copyright (C) 2019-2020 Intel Corporation, Inc.
+ *
+ * Authors:
+ *   Wu Hao <hao.wu@intel.com>
+ *   Xu Yilun <yilun.xu@intel.com>
+ */
+#include <linux/bitfield.h>
+#include <linux/dfl.h>
+#include <linux/errno.h>
+#include <linux/ethtool.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+
+#include "dfl-eth-group.h"
+
+struct dfl_eth_group {
+	char name[32];
+	struct device *dev;
+	void __iomem *base;
+	/* lock to protect register access of the ether group */
+	struct mutex reg_lock;
+	struct dfl_device *dfl_dev;
+	unsigned int config;
+	unsigned int direction;
+	unsigned int group_id;
+	unsigned int speed;
+	unsigned int lw_mac;
+	unsigned int num_edevs;
+	struct eth_dev *edevs;
+	struct eth_dev_ops *ops;
+};
+
+u64 read_mac_stats(struct eth_com *ecom, unsigned int addr)
+{
+	u32 data_l, data_h;
+
+	if (eth_com_read_reg(ecom, addr, &data_l) ||
+	    eth_com_read_reg(ecom, addr + 1, &data_h))
+		return 0xffffffffffffffffULL;
+
+	return data_l + ((u64)data_h << 32);
+}
+
+netdev_tx_t n3000_dummy_netdev_xmit(struct sk_buff *skb,
+				    struct net_device *dev)
+{
+	kfree_skb(skb);
+	net_warn_ratelimited("%s(): Dropping skb.\n", __func__);
+	return NETDEV_TX_OK;
+}
+
+static void n3000_netdev_setup(struct net_device *netdev)
+{
+	netdev->features = 0;
+	netdev->hard_header_len = 0;
+	netdev->priv_flags |= IFF_NO_QUEUE;
+	netdev->needs_free_netdev = true;
+	netdev->min_mtu = 0;
+	netdev->max_mtu = ETH_MAX_MTU;
+}
+
+struct net_device *n3000_netdev_create(struct eth_dev *edev)
+{
+	struct dfl_eth_group *egroup = edev->egroup;
+	struct n3000_net_priv *priv;
+	struct net_device *netdev;
+	char name[IFNAMSIZ];
+
+	/* The name of n3000 network device is using this format "npacAgBlC"
+	 *
+	 * A is the unique ethdev index
+	 * B is the group id of this ETH Group.
+	 * C is the PHY/MAC link index for Line side ethernet group.
+	 */
+	snprintf(name, IFNAMSIZ, "npac%%dg%ul%u",
+		 egroup->group_id, edev->index);
+
+	netdev = alloc_netdev(sizeof(*priv), name, NET_NAME_UNKNOWN,
+			      n3000_netdev_setup);
+	if (!netdev)
+		return NULL;
+
+	priv = netdev_priv(netdev);
+	priv->edev = edev;
+	SET_NETDEV_DEV(netdev, egroup->dev);
+
+	return netdev;
+}
+
+enum n3000_eth_cfg {
+	ETH_CONFIG_8x10G,
+	ETH_CONFIG_4x25G,
+	ETH_CONFIG_2x1x25G,
+	ETH_CONFIG_4x25G_2x25G,
+	ETH_CONFIG_2x2x25G,
+	ETH_CONFIG_MAX
+};
+
+#define N3000_EDEV_MAX 8
+
+static int phy_addr_table[ETH_CONFIG_MAX][N3000_EDEV_MAX] = {
+	/* 8x10G configuration
+	 *
+	 *    [retimer_dev]   <------->   [eth_dev]
+	 *	  0			   0
+	 *	  1			   1
+	 *	  2			   2
+	 *	  3			   3
+	 *	  4			   4
+	 *	  5			   5
+	 *	  6			   6
+	 *	  7			   7
+	 */
+	[ETH_CONFIG_8x10G] = {0, 1, 2, 3, 4, 5, 6, 7},
+
+	/* 4x25G and 4x25G_2x25G configuration
+	 *
+	 *    [retimer_dev]   <------->   [eth_dev]
+	 *	  0			   0
+	 *	  1			   1
+	 *	  2			   2
+	 *	  3			   3
+	 *	  4
+	 *	  5
+	 *	  6
+	 *	  7
+	 */
+	[ETH_CONFIG_4x25G] = {0, 1, 2, 3, -1, -1, -1, -1},
+	[ETH_CONFIG_4x25G_2x25G] = {0, 1, 2, 3, -1, -1, -1, -1},
+
+	/* 2x1x25G configuration
+	 *
+	 *    [retimer_dev]   <------->   [eth_dev]
+	 *        0                      0
+	 *        1
+	 *        2
+	 *        3
+	 *        4                      1
+	 *        5
+	 *        6
+	 *        7
+	 */
+	[ETH_CONFIG_2x1x25G] = {0, 4, -1, -1, -1, -1, -1, -1},
+
+	/* 2x2x25G configuration
+	 *
+	 *    [retimer_dev]   <------->   [eth_dev]
+	 *	  0			   0
+	 *	  1			   1
+	 *	  2
+	 *	  3
+	 *	  4			   2
+	 *	  5			   3
+	 *	  6
+	 *	  7
+	 */
+	[ETH_CONFIG_2x2x25G] = {0, 1, 4, 5, -1, -1, -1, -1},
+};
+
+#define eth_group_for_each_dev(edev, egp) \
+	for ((edev) = (egp)->edevs; (edev) < (egp)->edevs + (egp)->num_edevs; \
+	     (edev)++)
+
+#define eth_group_reverse_each_dev(edev, egp) \
+	for ((edev)--; (edev) >= (egp)->edevs; (edev)--)
+
+static struct mii_bus *eth_group_get_phy_bus(struct dfl_eth_group *egroup)
+{
+	char mii_name[MII_BUS_ID_SIZE];
+	struct device *base_dev;
+	struct mii_bus *bus;
+
+	base_dev = dfl_dev_get_base_dev(egroup->dfl_dev);
+	if (!base_dev)
+		return ERR_PTR(-ENODEV);
+
+	snprintf(mii_name, MII_BUS_ID_SIZE, DFL_ETH_MII_ID_FMT,
+		 dev_name(base_dev));
+
+	bus = mdio_find_bus(mii_name);
+	if (!bus)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	return bus;
+}
+
+static int eth_dev_get_phy_id(struct eth_dev *edev, struct mii_bus *bus)
+{
+	struct dfl_eth_group *egroup = edev->egroup;
+	struct phy_device *phydev;
+	int phyaddr;
+
+	phyaddr = phy_addr_table[egroup->config][edev->index];
+	if (phyaddr < 0)
+		return -ENODEV;
+
+	phydev = mdiobus_get_phy(bus, phyaddr);
+	if (!phydev) {
+		dev_err(egroup->dev, "fail to get phydev\n");
+		return -EPROBE_DEFER;
+	}
+
+	strncpy(edev->phy_id, phydev_name(phydev), MII_BUS_ID_SIZE + 3);
+	edev->phy_id[MII_BUS_ID_SIZE + 2] = '\0';
+
+	return 0;
+}
+
+static int init_lineside_eth_devs(struct dfl_eth_group *egroup,
+				  struct mii_bus *phy_bus)
+{
+	struct eth_dev *edev;
+	int ret = 0;
+
+	if (!egroup->ops->lineside_init)
+		return -ENODEV;
+
+	eth_group_for_each_dev(edev, egroup) {
+		ret = eth_dev_get_phy_id(edev, phy_bus);
+		if (ret)
+			break;
+
+		ret = egroup->ops->lineside_init(edev);
+		if (ret)
+			break;
+	}
+
+	if (!ret)
+		return 0;
+
+	dev_err(egroup->dev, "failed to init lineside edev %d", edev->index);
+
+	if (egroup->ops->lineside_remove)
+		eth_group_reverse_each_dev(edev, egroup)
+			egroup->ops->lineside_remove(edev);
+
+	return ret;
+}
+
+static void remove_lineside_eth_devs(struct dfl_eth_group *egroup)
+{
+	struct eth_dev *edev;
+
+	if (!egroup->ops->lineside_remove)
+		return;
+
+	eth_group_for_each_dev(edev, egroup)
+		egroup->ops->lineside_remove(edev);
+}
+
+#define ETH_GROUP_INFO		0x8
+#define LIGHT_WEIGHT_MAC	BIT_ULL(25)
+#define INFO_DIRECTION		BIT_ULL(24)
+#define INFO_SPEED		GENMASK_ULL(23, 16)
+#define INFO_PHY_NUM		GENMASK_ULL(15, 8)
+#define INFO_GROUP_ID		GENMASK_ULL(7, 0)
+
+#define ETH_GROUP_CTRL		0x10
+#define CTRL_CMD		GENMASK_ULL(63, 62)
+#define CMD_NOP			0
+#define CMD_RD			1
+#define CMD_WR			2
+#define CTRL_DEV_SELECT		GENMASK_ULL(53, 49)
+#define CTRL_FEAT_SELECT	BIT_ULL(48)
+#define SELECT_IP		0
+#define SELECT_FEAT		1
+#define CTRL_ADDR		GENMASK_ULL(47, 32)
+#define CTRL_WR_DATA		GENMASK_ULL(31, 0)
+
+#define ETH_GROUP_STAT		0x18
+#define STAT_RW_VAL		BIT_ULL(32)
+#define STAT_RD_DATA		GENMASK_ULL(31, 0)
+
+enum ecom_type {
+	ETH_GROUP_PHY	= 1,
+	ETH_GROUP_MAC,
+	ETH_GROUP_ETHER
+};
+
+struct eth_com {
+	struct dfl_eth_group *egroup;
+	unsigned int type;
+	u8 select;
+};
+
+static const char *eth_com_type_string(enum ecom_type type)
+{
+	switch (type) {
+	case ETH_GROUP_PHY:
+		return "phy";
+	case ETH_GROUP_MAC:
+		return "mac";
+	case ETH_GROUP_ETHER:
+		return "ethernet wrapper";
+	default:
+		return "unknown";
+	}
+}
+
+#define eth_com_base(com)	((com)->egroup->base)
+#define eth_com_dev(com)	((com)->egroup->dev)
+
+#define RW_VAL_INVL		1 /* us */
+#define RW_VAL_POLL_TIMEOUT	10 /* us */
+
+static int __do_eth_com_write_reg(struct eth_com *ecom, bool add_feature,
+				  u16 addr, u32 data)
+{
+	void __iomem *base = eth_com_base(ecom);
+	struct device *dev = eth_com_dev(ecom);
+	u64 v = 0;
+
+	dev_dbg(dev, "%s [%s] select 0x%x add_feat %d addr 0x%x data 0x%x\n",
+		__func__, eth_com_type_string(ecom->type),
+		ecom->select, add_feature, addr, data);
+
+	/* only PHY has additional feature registers */
+	if (add_feature && ecom->type != ETH_GROUP_PHY)
+		return -EINVAL;
+
+	v |= FIELD_PREP(CTRL_CMD, CMD_WR);
+	v |= FIELD_PREP(CTRL_DEV_SELECT, ecom->select);
+	v |= FIELD_PREP(CTRL_ADDR, addr);
+	v |= FIELD_PREP(CTRL_WR_DATA, data);
+	v |= FIELD_PREP(CTRL_FEAT_SELECT, !!add_feature);
+
+	writeq(v, base + ETH_GROUP_CTRL);
+
+	if (readq_poll_timeout(base + ETH_GROUP_STAT, v, v & STAT_RW_VAL,
+			       RW_VAL_INVL, RW_VAL_POLL_TIMEOUT))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int __do_eth_com_read_reg(struct eth_com *ecom, bool add_feature,
+				 u16 addr, u32 *data)
+{
+	void __iomem *base = eth_com_base(ecom);
+	struct device *dev = eth_com_dev(ecom);
+	u64 v = 0;
+
+	dev_dbg(dev, "%s [%s] select %x add_feat %d addr %x\n",
+		__func__, eth_com_type_string(ecom->type),
+		ecom->select, add_feature, addr);
+
+	/* only PHY has additional feature registers */
+	if (add_feature && ecom->type != ETH_GROUP_PHY)
+		return -EINVAL;
+
+	v |= FIELD_PREP(CTRL_CMD, CMD_RD);
+	v |= FIELD_PREP(CTRL_DEV_SELECT, ecom->select);
+	v |= FIELD_PREP(CTRL_ADDR, addr);
+	v |= FIELD_PREP(CTRL_FEAT_SELECT, !!add_feature);
+
+	writeq(v, base + ETH_GROUP_CTRL);
+
+	if (readq_poll_timeout(base + ETH_GROUP_STAT, v, v & STAT_RW_VAL,
+			       RW_VAL_INVL, RW_VAL_POLL_TIMEOUT))
+		return -ETIMEDOUT;
+
+	*data = FIELD_GET(STAT_RD_DATA, v);
+
+	return 0;
+}
+
+int do_eth_com_write_reg(struct eth_com *ecom, bool add_feature,
+			 u16 addr, u32 data)
+{
+	int ret;
+
+	mutex_lock(&ecom->egroup->reg_lock);
+	ret = __do_eth_com_write_reg(ecom, add_feature, addr, data);
+	mutex_unlock(&ecom->egroup->reg_lock);
+	return ret;
+}
+
+int do_eth_com_read_reg(struct eth_com *ecom, bool add_feature,
+			u16 addr, u32 *data)
+{
+	int ret;
+
+	mutex_lock(&ecom->egroup->reg_lock);
+	ret = __do_eth_com_read_reg(ecom, add_feature, addr, data);
+	mutex_unlock(&ecom->egroup->reg_lock);
+	return ret;
+}
+
+static struct eth_com *
+eth_com_create(struct dfl_eth_group *egroup, enum ecom_type type,
+	       unsigned int link_idx)
+{
+	struct eth_com *ecom;
+
+	ecom = devm_kzalloc(egroup->dev, sizeof(*ecom), GFP_KERNEL);
+	if (!ecom)
+		return ERR_PTR(-ENOMEM);
+
+	ecom->egroup = egroup;
+	ecom->type = type;
+
+	if (type == ETH_GROUP_PHY)
+		ecom->select = link_idx * 2 + 2;
+	else if (type == ETH_GROUP_MAC)
+		ecom->select = link_idx * 2 + 3;
+	else if (type == ETH_GROUP_ETHER)
+		ecom->select = 0;
+
+	return ecom;
+}
+
+static int init_eth_dev(struct eth_dev *edev, struct dfl_eth_group *egroup,
+			unsigned int link_idx)
+{
+	edev->egroup = egroup;
+	edev->dev = egroup->dev;
+	edev->index = link_idx;
+	edev->lw_mac = !!egroup->lw_mac;
+	edev->phy = eth_com_create(egroup, ETH_GROUP_PHY, link_idx);
+	if (IS_ERR(edev->phy))
+		return PTR_ERR(edev->phy);
+
+	edev->mac = eth_com_create(egroup, ETH_GROUP_MAC, link_idx);
+	if (IS_ERR(edev->mac))
+		return PTR_ERR(edev->mac);
+
+	return 0;
+}
+
+static int eth_devs_init(struct dfl_eth_group *egroup)
+{
+	int ret, i;
+
+	egroup->edevs = devm_kcalloc(egroup->dev, egroup->num_edevs,
+				     sizeof(*egroup->edevs), GFP_KERNEL);
+	if (!egroup->edevs)
+		return -ENOMEM;
+
+	for (i = 0; i < egroup->num_edevs; i++) {
+		ret = init_eth_dev(&egroup->edevs[i], egroup, i);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int eth_group_setup(struct dfl_eth_group *egroup)
+{
+	int net_cfg, ret;
+	u64 v;
+
+	/* read parameters of this ethernet components group */
+	v = readq(egroup->base + ETH_GROUP_INFO);
+
+	egroup->direction = FIELD_GET(INFO_DIRECTION, v);
+	egroup->speed = FIELD_GET(INFO_SPEED, v);
+	egroup->num_edevs = FIELD_GET(INFO_PHY_NUM, v);
+	egroup->group_id = FIELD_GET(INFO_GROUP_ID, v);
+	egroup->lw_mac = FIELD_GET(LIGHT_WEIGHT_MAC, v);
+
+	net_cfg = dfl_dev_get_vendor_net_cfg(egroup->dfl_dev);
+	if (net_cfg < 0)
+		return -EINVAL;
+
+	egroup->config = (unsigned int)net_cfg;
+
+	ret = eth_devs_init(egroup);
+	if (ret)
+		return ret;
+
+	switch (egroup->speed) {
+	case 25:
+		egroup->ops = &dfl_eth_dev_25g_ops;
+		break;
+	case 40:
+		egroup->ops = &dfl_eth_dev_40g_ops;
+		break;
+	}
+
+	mutex_init(&egroup->reg_lock);
+
+	return 0;
+}
+
+static void eth_group_destroy(struct dfl_eth_group *egroup)
+{
+	mutex_destroy(&egroup->reg_lock);
+}
+
+static void eth_group_devs_disable(struct dfl_eth_group *egroup)
+{
+	struct eth_dev *edev;
+
+	eth_group_for_each_dev(edev, egroup)
+		egroup->ops->reset(edev, true);
+}
+
+static int eth_group_devs_enable(struct dfl_eth_group *egroup)
+{
+	struct eth_dev *edev;
+	int ret;
+
+	eth_group_for_each_dev(edev, egroup) {
+		ret = egroup->ops->reset(edev, false);
+		if (ret) {
+			dev_err(egroup->dev, "fail to enable edev%d\n",
+				edev->index);
+			eth_group_devs_disable(egroup);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int dfl_eth_group_line_side_init(struct dfl_eth_group *egroup)
+{
+	struct mii_bus *phy_bus;
+	int ret;
+
+	if (!egroup->ops || !egroup->ops->reset ||
+	    !egroup->ops->lineside_init || !egroup->ops->lineside_remove)
+		return -EINVAL;
+
+	eth_group_devs_disable(egroup);
+
+	phy_bus = eth_group_get_phy_bus(egroup);
+	if (IS_ERR(phy_bus))
+		return PTR_ERR(phy_bus);
+
+	ret = init_lineside_eth_devs(egroup, phy_bus);
+	put_device(&phy_bus->dev);
+
+	return ret;
+}
+
+static void dfl_eth_group_line_side_uinit(struct dfl_eth_group *egroup)
+{
+	remove_lineside_eth_devs(egroup);
+}
+
+static int dfl_eth_group_host_side_init(struct dfl_eth_group *egroup)
+{
+	if (!egroup->ops || !egroup->ops->reset)
+		return -EINVAL;
+
+	return eth_group_devs_enable(egroup);
+}
+
+static int dfl_eth_group_probe(struct dfl_device *dfl_dev)
+{
+	struct device *dev = &dfl_dev->dev;
+	struct dfl_eth_group *egroup;
+	int ret;
+
+	egroup = devm_kzalloc(dev, sizeof(*egroup), GFP_KERNEL);
+	if (!egroup)
+		return -ENOMEM;
+
+	dev_set_drvdata(&dfl_dev->dev, egroup);
+
+	egroup->dev = dev;
+	egroup->dfl_dev = dfl_dev;
+
+	egroup->base = devm_ioremap_resource(dev, &dfl_dev->mmio_res);
+	if (IS_ERR(egroup->base)) {
+		dev_err(dev, "get mem resource fail!\n");
+		return PTR_ERR(egroup->base);
+	}
+
+	ret = eth_group_setup(egroup);
+	if (ret)
+		return ret;
+
+	if (egroup->direction == 1)
+		ret = dfl_eth_group_line_side_init(egroup);
+	else
+		ret = dfl_eth_group_host_side_init(egroup);
+
+	if (!ret)
+		return 0;
+
+	eth_group_destroy(egroup);
+
+	return ret;
+}
+
+static void dfl_eth_group_remove(struct dfl_device *dfl_dev)
+{
+	struct dfl_eth_group *egroup = dev_get_drvdata(&dfl_dev->dev);
+
+	if (egroup->direction == 1)
+		dfl_eth_group_line_side_uinit(egroup);
+
+	eth_group_devs_disable(egroup);
+	eth_group_destroy(egroup);
+}
+
+#define FME_FEATURE_ID_ETH_GROUP	0x10
+
+static const struct dfl_device_id dfl_eth_group_ids[] = {
+	{ FME_ID, FME_FEATURE_ID_ETH_GROUP },
+	{ }
+};
+
+static struct dfl_driver dfl_eth_group_driver = {
+	.drv	= {
+		.name       = "dfl-eth-group",
+	},
+	.id_table = dfl_eth_group_ids,
+	.probe   = dfl_eth_group_probe,
+	.remove  = dfl_eth_group_remove,
+};
+
+module_dfl_driver(dfl_eth_group_driver);
+
+MODULE_DEVICE_TABLE(dfl, dfl_eth_group_ids);
+MODULE_DESCRIPTION("DFL ether group driver");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/intel/dfl-eth-group.h b/drivers/net/ethernet/intel/dfl-eth-group.h
new file mode 100644
index 0000000..2e90f86
--- /dev/null
+++ b/drivers/net/ethernet/intel/dfl-eth-group.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Internal header file for FPGA DFL Ether Group Driver
+ *
+ * Copyright (C) 2020 Intel Corporation. All rights reserved.
+ */
+
+#ifndef __DFL_ETH_GROUP_H__
+#define __DFL_ETH_GROUP_H__
+
+#include <linux/netdevice.h>
+#include <linux/phy.h>
+#include <linux/rtnetlink.h>
+
+/* Used when trying to find a virtual mii bus on a specific dfl device.
+ * dev_name(dfl base device)-mii
+ */
+#define DFL_ETH_MII_ID_FMT "%s-mii"
+
+struct eth_dev {
+	struct dfl_eth_group *egroup;
+	struct device *dev;
+	int index;
+	bool lw_mac;
+	struct eth_com *phy;
+	struct eth_com *mac;
+	struct net_device *netdev;
+
+	char phy_id[MII_BUS_ID_SIZE + 3];
+};
+
+struct eth_dev_ops {
+	int (*lineside_init)(struct eth_dev *edev);
+	void (*lineside_remove)(struct eth_dev *edev);
+	int (*reset)(struct eth_dev *edev, bool en);
+};
+
+struct n3000_net_priv {
+	struct eth_dev *edev;
+};
+
+static inline struct eth_dev *net_device_to_eth_dev(struct net_device *netdev)
+{
+	struct n3000_net_priv *priv = netdev_priv(netdev);
+
+	return priv->edev;
+}
+
+struct stat_info {
+	unsigned int addr;
+	char string[ETH_GSTRING_LEN];
+};
+
+#define STAT_INFO(_addr, _string) \
+	.addr = _addr, .string = _string,
+
+int do_eth_com_write_reg(struct eth_com *ecom, bool add_feature,
+			 u16 addr, u32 data);
+int do_eth_com_read_reg(struct eth_com *ecom, bool add_feature,
+			u16 addr, u32 *data);
+
+#define eth_com_write_reg(ecom, addr, data)	\
+	do_eth_com_write_reg(ecom, false, addr, data)
+
+#define eth_com_read_reg(ecom, addr, data)	\
+	do_eth_com_read_reg(ecom, false, addr, data)
+
+#define eth_com_add_feat_write_reg(ecom, addr, data)	\
+	do_eth_com_write_reg(ecom, true, addr, data)
+
+#define eth_com_add_feat_read_reg(ecom, addr, data)	\
+	do_eth_com_read_reg(ecom, true, addr, data)
+
+u64 read_mac_stats(struct eth_com *ecom, unsigned int addr);
+
+struct net_device *n3000_netdev_create(struct eth_dev *edev);
+netdev_tx_t n3000_dummy_netdev_xmit(struct sk_buff *skb,
+				    struct net_device *dev);
+
+extern struct eth_dev_ops dfl_eth_dev_25g_ops;
+extern struct eth_dev_ops dfl_eth_dev_40g_ops;
+
+#endif /* __DFL_ETH_GROUP_H__ */
diff --git a/drivers/net/ethernet/intel/intel-m10-bmc-retimer.c b/drivers/net/ethernet/intel/intel-m10-bmc-retimer.c
index c7b0558..3f686d2 100644
--- a/drivers/net/ethernet/intel/intel-m10-bmc-retimer.c
+++ b/drivers/net/ethernet/intel/intel-m10-bmc-retimer.c
@@ -10,6 +10,8 @@
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 
+#include "dfl-eth-group.h"
+
 #define NUM_CHIP	2
 #define MAX_LINK	4
 
@@ -148,7 +150,7 @@ static int m10bmc_retimer_mii_bus_init(struct m10bmc_retimer *retimer)
 	bus->name = M10BMC_RETIMER_MII_NAME;
 	bus->read = m10bmc_retimer_read;
 	bus->write = m10bmc_retimer_write;
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii",
+	snprintf(bus->id, MII_BUS_ID_SIZE, DFL_ETH_MII_ID_FMT,
 		 dev_name(retimer->base_dev));
 	bus->parent = retimer->dev;
 	bus->phy_mask = ~(BITS_MASK(retimer->num_devs));
-- 
2.7.4

