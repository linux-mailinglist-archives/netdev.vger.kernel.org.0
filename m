Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C60545B6AF
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241423AbhKXIoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:44:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:32180 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbhKXIoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:44:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637743256; x=1669279256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ogQzmhrsNxWrT99SnyptP3MyBzHs/oQUGH28wHws3fU=;
  b=FxHnGnqhqSGw8BlT5c1F+65h5iJrsMDVGykdRdGCX5hOtnrjU8zxMOAP
   iP9rAAcD2okYKYcmODox6SHccMHlLFIv7NZ+4yoPFZipy7zNsyYPrvrSD
   WU4yNnKrx+U+3ML8V3lHQLeh1dOdg0VSpXJ50KY99tS1DJYroYSXZiwl5
   +DgS8KBa8tw7GkfBXxUo5vWa634ov58UIFxqJT0bG2E9MDvddztdF+lXL
   LYBkG+fL4KZQUcumyOCWsyt36f8W1s6OKFptjPMyhWvGdKh8HhP59b/LD
   rY5VYEtPAVuOG8YF2py3dUXxiB9bnG7OgKk/GGNSkzUqm3qA6Au0QeOUp
   w==;
IronPort-SDR: qx9op/43Bxl0rL9WDriYWXWrBkDXMFR7nPq8JDUlAHuMf8NT9bTro2s5gkHyx0e1IuTnxvQwf8
 ncEIvxJY6UXwl8+AMTY9DXcu/iSElnbhascZB/Hn9HhEaCHVmHfEBGoHzMRf2RC3I+vBYh1p5T
 aY39FoLHXaXVqyfiI+ZGMjnGPKIpAVDUagdS90FAnSSSw4NKx2mEhzsZkC+VYRT+NueIylvGoz
 ymBaeeYYn7n/0G7I3CD/qFhwNtXpnbOQMYqX5REo9QSgCc52qpYgdw74RNvFT9X2xoxOCOrSCZ
 yWxK7USQh7EJKAQgFVvcrHez
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="77436210"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2021 01:40:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 24 Nov 2021 01:40:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 24 Nov 2021 01:40:52 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 4/6] net: lan966x: add mactable support
Date:   Wed, 24 Nov 2021 09:39:13 +0100
Message-ID: <20211124083915.2223065-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
References: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for MAC table operations like add and forget.
Also add the functionality to read the MAC address from DT, if there is
no MAC set in DT it would use a random one.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 101 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  74 +++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  31 ++++++
 4 files changed, 208 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index e18c9b2d0bb7..75556387df08 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -5,4 +5,5 @@
 
 obj-$(CONFIG_LAN966X_SWITCH) += lan966x-switch.o
 
-lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o
+lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
+			lan966x_mac.o
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
new file mode 100644
index 000000000000..f6878b9f57ef
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+
+#define LAN966X_MAC_COLUMNS		4
+#define MACACCESS_CMD_IDLE		0
+#define MACACCESS_CMD_LEARN		1
+#define MACACCESS_CMD_FORGET		2
+#define MACACCESS_CMD_AGE		3
+#define MACACCESS_CMD_GET_NEXT		4
+#define MACACCESS_CMD_INIT		5
+#define MACACCESS_CMD_READ		6
+#define MACACCESS_CMD_WRITE		7
+#define MACACCESS_CMD_SYNC_GET_NEXT	8
+
+static int lan966x_mac_get_status(struct lan966x *lan966x)
+{
+	return lan_rd(lan966x, ANA_MACACCESS);
+}
+
+static int lan966x_mac_wait_for_completion(struct lan966x *lan966x)
+{
+	u32 val;
+
+	return readx_poll_timeout(lan966x_mac_get_status,
+		lan966x, val,
+		(ANA_MACACCESS_MAC_TABLE_CMD_GET(val)) ==
+		MACACCESS_CMD_IDLE,
+		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
+}
+
+static void lan966x_mac_select(struct lan966x *lan966x,
+			       const unsigned char mac[ETH_ALEN],
+			       unsigned int vid)
+{
+	u32 macl = 0, mach = 0;
+
+	/* Set the MAC address to handle and the vlan associated in a format
+	 * understood by the hardware.
+	 */
+	mach |= vid    << 16;
+	mach |= mac[0] << 8;
+	mach |= mac[1] << 0;
+	macl |= mac[2] << 24;
+	macl |= mac[3] << 16;
+	macl |= mac[4] << 8;
+	macl |= mac[5] << 0;
+
+	lan_wr(macl, lan966x, ANA_MACLDATA);
+	lan_wr(mach, lan966x, ANA_MACHDATA);
+}
+
+int lan966x_mac_learn(struct lan966x *lan966x, int port,
+		      const unsigned char mac[ETH_ALEN],
+		      unsigned int vid,
+		      enum macaccess_entry_type type)
+{
+	lan966x_mac_select(lan966x, mac, vid);
+
+	/* Issue a write command */
+	lan_wr(ANA_MACACCESS_VALID_SET(1) |
+	       ANA_MACACCESS_CHANGE2SW_SET(0) |
+	       ANA_MACACCESS_DEST_IDX_SET(port) |
+	       ANA_MACACCESS_ENTRYTYPE_SET(type) |
+	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
+	       lan966x, ANA_MACACCESS);
+
+	return lan966x_mac_wait_for_completion(lan966x);
+}
+
+int lan966x_mac_forget(struct lan966x *lan966x,
+		       const unsigned char mac[ETH_ALEN],
+		       unsigned int vid,
+		       enum macaccess_entry_type type)
+{
+	lan966x_mac_select(lan966x, mac, vid);
+
+	/* Issue a forget command */
+	lan_wr(ANA_MACACCESS_ENTRYTYPE_SET(type) |
+	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_FORGET),
+	       lan966x, ANA_MACACCESS);
+
+	return lan966x_mac_wait_for_completion(lan966x);
+}
+
+int lan966x_mac_cpu_learn(struct lan966x *lan966x, const char *addr, u16 vid)
+{
+	return lan966x_mac_learn(lan966x, PGID_CPU, addr, vid, ENTRYTYPE_LOCKED);
+}
+
+int lan966x_mac_cpu_forget(struct lan966x *lan966x, const char *addr, u16 vid)
+{
+	return lan966x_mac_forget(lan966x, addr, vid, ENTRYTYPE_LOCKED);
+}
+
+void lan966x_mac_init(struct lan966x *lan966x)
+{
+	/* Clear the MAC table */
+	lan_wr(MACACCESS_CMD_INIT, lan966x, ANA_MACACCESS);
+	lan966x_mac_wait_for_completion(lan966x);
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 4286cc1b0417..ade4a35924c6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -99,6 +99,27 @@ static int lan966x_create_targets(struct platform_device *pdev,
 	return 0;
 }
 
+static int lan966x_port_set_mac_address(struct net_device *dev, void *p)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	const struct sockaddr *addr = p;
+	int ret;
+
+	/* Learn the new net device MAC address in the mac table. */
+	ret = lan966x_mac_cpu_learn(lan966x, addr->sa_data, port->pvid);
+	if (ret)
+		return ret;
+
+	/* Then forget the previous one. */
+	ret = lan966x_mac_cpu_forget(lan966x, dev->dev_addr, port->pvid);
+	if (ret)
+		return ret;
+
+	eth_hw_addr_set(dev, addr->sa_data);
+	return ret;
+}
+
 static int lan966x_port_get_phys_port_name(struct net_device *dev,
 					   char *buf, size_t len)
 {
@@ -309,13 +330,49 @@ static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
+static int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	return lan966x_mac_forget(lan966x, addr, port->pvid, ENTRYTYPE_LOCKED);
+}
+
+static int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	return lan966x_mac_cpu_learn(lan966x, addr, port->pvid);
+}
+
+static void lan966x_port_set_rx_mode(struct net_device *dev)
+{
+	__dev_mc_sync(dev, lan966x_mc_sync, lan966x_mc_unsync);
+}
+
+static int lan966x_port_get_parent_id(struct net_device *dev,
+				      struct netdev_phys_item_id *ppid)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	ppid->id_len = sizeof(lan966x->base_mac);
+	memcpy(&ppid->id, &lan966x->base_mac, ppid->id_len);
+
+	return 0;
+}
+
 static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_open			= lan966x_port_open,
 	.ndo_stop			= lan966x_port_stop,
 	.ndo_start_xmit			= lan966x_port_xmit,
 	.ndo_change_rx_flags		= lan966x_port_change_rx_flags,
 	.ndo_change_mtu			= lan966x_port_change_mtu,
+	.ndo_set_rx_mode		= lan966x_port_set_rx_mode,
 	.ndo_get_phys_port_name		= lan966x_port_get_phys_port_name,
+	.ndo_set_mac_address		= lan966x_port_set_mac_address,
+	.ndo_get_port_parent_id		= lan966x_port_get_parent_id,
 };
 
 static int lan966x_ifh_extract(u32 *ifh, size_t pos, size_t length)
@@ -525,6 +582,11 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 	dev->netdev_ops = &lan966x_port_netdev_ops;
 	dev->needed_headroom = IFH_LEN * sizeof(u32);
 
+	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
+
+	lan966x_mac_learn(lan966x, PGID_CPU, dev->dev_addr, port->pvid,
+			  ENTRYTYPE_LOCKED);
+
 	port->phylink_config.dev = &port->dev->dev;
 	port->phylink_config.type = PHYLINK_NETDEV;
 	port->phylink_config.pcs_poll = true;
@@ -572,6 +634,9 @@ static void lan966x_init(struct lan966x *lan966x)
 {
 	u32 p, i;
 
+	/* MAC table initialization */
+	lan966x_mac_init(lan966x);
+
 	/* Flush queues */
 	lan_wr(lan_rd(lan966x, QS_XTR_FLUSH) |
 	       GENMASK(1, 0),
@@ -741,6 +806,7 @@ static int lan966x_probe(struct platform_device *pdev)
 {
 	struct fwnode_handle *ports, *portnp;
 	struct lan966x *lan966x;
+	u8 mac_addr[ETH_ALEN];
 	int err, i;
 
 	lan966x = devm_kzalloc(&pdev->dev, sizeof(*lan966x), GFP_KERNEL);
@@ -750,6 +816,14 @@ static int lan966x_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, lan966x);
 	lan966x->dev = &pdev->dev;
 
+	if (!device_get_mac_address(&pdev->dev, mac_addr)) {
+		ether_addr_copy(lan966x->base_mac, mac_addr);
+	} else {
+		pr_info("MAC addr was not set, use random MAC\n");
+		eth_random_addr(lan966x->base_mac);
+		lan966x->base_mac[5] &= 0xf0;
+	}
+
 	ports = device_get_named_child_node(&pdev->dev, "ethernet-ports");
 	if (!ports)
 		return dev_err_probe(&pdev->dev, -ENODEV,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index ce2798db0449..332bcda0ded1 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -4,12 +4,16 @@
 #define __LAN966X_MAIN_H__
 
 #include <linux/etherdevice.h>
+#include <linux/jiffies.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
 
 #include "lan966x_regs.h"
 #include "lan966x_ifh.h"
 
+#define TABLE_UPDATE_SLEEP_US		10
+#define TABLE_UPDATE_TIMEOUT_US		100000
+
 #define LAN966X_BUFFER_CELL_SZ		64
 #define LAN966X_BUFFER_MEMORY		(160 * 1024)
 #define LAN966X_BUFFER_MIN_SZ		60
@@ -38,6 +42,19 @@
 
 #define CPU_PORT			8
 
+/* MAC table entry types.
+ * ENTRYTYPE_NORMAL is subject to aging.
+ * ENTRYTYPE_LOCKED is not subject to aging.
+ * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
+ * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
+ */
+enum macaccess_entry_type {
+	ENTRYTYPE_NORMAL = 0,
+	ENTRYTYPE_LOCKED,
+	ENTRYTYPE_MACV4,
+	ENTRYTYPE_MACV6,
+};
+
 struct lan966x_port;
 
 struct lan966x_frame_info {
@@ -59,6 +76,8 @@ struct lan966x {
 
 	int shared_queue_sz;
 
+	u8 base_mac[ETH_ALEN];
+
 	/* interrupts */
 	int xtr_irq;
 };
@@ -100,6 +119,18 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 			 struct lan966x_port_config *config);
 void lan966x_port_init(struct lan966x_port *port);
 
+int lan966x_mac_learn(struct lan966x *lan966x, int port,
+		      const unsigned char mac[ETH_ALEN],
+		      unsigned int vid,
+		      enum macaccess_entry_type type);
+int lan966x_mac_forget(struct lan966x *lan966x,
+		       const unsigned char mac[ETH_ALEN],
+		       unsigned int vid,
+		       enum macaccess_entry_type type);
+int lan966x_mac_cpu_learn(struct lan966x *lan966x, const char *addr, u16 vid);
+int lan966x_mac_cpu_forget(struct lan966x *lan966x, const char *addr, u16 vid);
+void lan966x_mac_init(struct lan966x *lan966x);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
-- 
2.33.0

