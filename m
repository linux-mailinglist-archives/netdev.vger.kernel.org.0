Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2576641124E
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhITJyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:54:22 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10199 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236833AbhITJxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131519; x=1663667519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7zh46xW6WIb46nT5IfMdGF3myb9A5ac3uBD7/y5IlH4=;
  b=f+IM3Ic63/SQXRQl2wGTdT7jDjhXSm4/MXzvKa6OLATrnyZnrB1tNUBW
   xePmOJxfkdN752/m1kJ2i/c7Pw1w7c4yAWIXoOoEXBCx4UuNxqX1CKfGH
   lqXy8zhqEwlYFiehyQ7A+b8z1RFoWKGrpa6UeLaxjVRMfPGZKH8T/VE8K
   Z3yDvZt8ddFF++eop4Jnvu2cS27pJhWKfyv/n8MJz2/lmIlY/xcpqmJVY
   uEC25SPCmGAzUf4M2DNfOK2uq4rZb0+U0wT7kKaBGoV9LBGZ8KF7MtkI3
   Pm/dgGcLZj8OLOMR9EKnAj4wpqekQE60IKhxDVL3U3Nvf+41r+SaOiEJb
   Q==;
IronPort-SDR: /pUNJDZ9u8EHp+VhzW2N8v/Nu8i8VKaCYZ/fMzGmvQ4hF0QCRyuHyORUNZaJpbZjgzHK0bhHH4
 aX/hs8/8SKG0obkT5wohcQ9rtLu4P1oHH6ehJj/MQTwuzxYh8tTo4d/b4zaFd5zE9MnDWuai2L
 Yhk6gl5Kh0/g2a8LrgUa4nbhSqe4y06zzMchWvsq5SiEfpsyxqCFmQls5nO9CTSABB/g/DZIkj
 bI2jEuA7X94P+2FzCvFifBaQGO/gQcews+ngTV6epC4XQsGz0x+/NXYweia8vQNZIvmgVONK/R
 +kE1cBCuskP1NvaBZFlEQ5wb
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="137192411"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:47 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:45 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 11/12] net: lan966x: add mactable support
Date:   Mon, 20 Sep 2021 11:52:17 +0200
Message-ID: <20210920095218.1108151-12-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
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
 .../ethernet/microchip/lan966x/lan966x_main.c | 158 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  29 ++++
 2 files changed, 187 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index cf147d44b345..53b88bb5b718 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -24,6 +24,8 @@
 
 #define READL_SLEEP_US			10
 #define READL_TIMEOUT_US		100000000
+#define TABLE_UPDATE_SLEEP_US		10
+#define TABLE_UPDATE_TIMEOUT_US		100000
 
 #define IO_RANGES 2
 
@@ -94,6 +96,107 @@ static int lan966x_create_targets(struct platform_device *pdev,
 	return 0;
 }
 
+static int lan966x_mact_get_status(struct lan966x *lan966x)
+{
+	return lan_rd(lan966x, ANA_MACACCESS);
+}
+
+static int lan966x_mact_wait_for_completion(struct lan966x *lan966x)
+{
+	u32 val;
+
+	return readx_poll_timeout(lan966x_mact_get_status,
+		lan966x, val,
+		(ANA_MACACCESS_MAC_TABLE_CMD_GET(val)) ==
+		MACACCESS_CMD_IDLE,
+		TABLE_UPDATE_SLEEP_US, TABLE_UPDATE_TIMEOUT_US);
+}
+
+static void lan966x_mact_select(struct lan966x *lan966x,
+				const unsigned char mac[ETH_ALEN],
+				unsigned int vid)
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
+static int lan966x_mact_learn(struct lan966x *lan966x, int port,
+			      const unsigned char mac[ETH_ALEN],
+			      unsigned int vid,
+			      enum macaccess_entry_type type)
+{
+	lan966x_mact_select(lan966x, mac, vid);
+
+	/* Issue a write command */
+	lan_wr(ANA_MACACCESS_VALID_SET(1) |
+	       ANA_MACACCESS_CHANGE2SW_SET(0) |
+	       ANA_MACACCESS_DEST_IDX_SET(port) |
+	       ANA_MACACCESS_ENTRYTYPE_SET(type) |
+	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
+	       lan966x, ANA_MACACCESS);
+
+	return lan966x_mact_wait_for_completion(lan966x);
+}
+
+static int lan966x_mact_forget(struct lan966x *lan966x,
+			       const unsigned char mac[ETH_ALEN],
+			       unsigned int vid,
+			       enum macaccess_entry_type type)
+{
+	lan966x_mact_select(lan966x, mac, vid);
+
+	/* Issue a forget command */
+	lan_wr(ANA_MACACCESS_ENTRYTYPE_SET(type) |
+	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_FORGET),
+	       lan966x, ANA_MACACCESS);
+
+	return lan966x_mact_wait_for_completion(lan966x);
+}
+
+static void lan966x_mact_init(struct lan966x *lan966x)
+{
+	/* Clear the MAC table */
+	lan_wr(MACACCESS_CMD_INIT,
+	       lan966x, ANA_MACACCESS);
+	lan966x_mact_wait_for_completion(lan966x);
+}
+
+static int lan966x_port_set_mac_address(struct net_device *dev, void *p)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	const struct sockaddr *addr = p;
+	int ret;
+
+	/* Learn the new net device MAC address in the mac table. */
+	ret = lan966x_mact_learn(lan966x, PGID_CPU, addr->sa_data, port->pvid,
+				 ENTRYTYPE_LOCKED);
+	if (ret)
+		return ret;
+
+	/* Then forget the previous one. */
+	ret = lan966x_mact_forget(lan966x, dev->dev_addr, port->pvid,
+				  ENTRYTYPE_LOCKED);
+	if (ret)
+		return ret;
+
+	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	return ret;
+}
+
 static int lan966x_port_get_phys_port_name(struct net_device *dev,
 					   char *buf, size_t len)
 {
@@ -301,13 +404,50 @@ static int lan966x_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
+static int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	return lan966x_mact_forget(lan966x, addr, port->pvid, ENTRYTYPE_LOCKED);
+}
+
+static int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+
+	return lan966x_mact_learn(lan966x, PGID_CPU, addr, port->pvid,
+				  ENTRYTYPE_LOCKED);
+}
+
+static void lan966x_set_rx_mode(struct net_device *dev)
+{
+	__dev_mc_sync(dev, lan966x_mc_sync, lan966x_mc_unsync);
+}
+
+static int lan966x_port_get_parent_id(struct net_device *dev,
+				      struct netdev_phys_item_id *ppid)
+{
+	struct lan966x_port *lan966x_port = netdev_priv(dev);
+	struct lan966x *lan966x = lan966x_port->lan966x;
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
 	.ndo_change_rx_flags		= lan966x_change_rx_flags,
 	.ndo_change_mtu			= lan966x_change_mtu,
+	.ndo_set_rx_mode		= lan966x_set_rx_mode,
 	.ndo_get_phys_port_name		= lan966x_port_get_phys_port_name,
+	.ndo_set_mac_address		= lan966x_port_set_mac_address,
+	.ndo_get_port_parent_id		= lan966x_port_get_parent_id,
 };
 
 static int lan966x_ifh_extract(u32 *ifh, size_t pos, size_t length)
@@ -515,6 +655,12 @@ static int lan966x_probe_port(struct lan966x *lan966x, u8 port,
 	dev->netdev_ops = &lan966x_port_netdev_ops;
 	dev->needed_headroom = IFH_LEN * sizeof(u32);
 
+	ether_addr_copy(dev->dev_addr, lan966x->base_mac);
+	dev->dev_addr[ETH_ALEN - 1] += port + 1;
+
+	lan966x_mact_learn(lan966x, PGID_CPU, dev->dev_addr, lan966x_port->pvid,
+			   ENTRYTYPE_LOCKED);
+
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(lan966x->dev, "register_netdev failed\n");
@@ -544,6 +690,9 @@ static void lan966x_init(struct lan966x *lan966x)
 {
 	u32 port, i;
 
+	/* MAC table initialization */
+	lan966x_mact_init(lan966x);
+
 	/* Flush queues */
 	lan_wr(lan_rd(lan966x, QS_XTR_FLUSH) |
 	       GENMASK(1, 0),
@@ -708,6 +857,7 @@ static int lan966x_probe(struct platform_device *pdev)
 {
 	struct fwnode_handle *ports, *portnp;
 	struct lan966x *lan966x;
+	u8 mac_addr[ETH_ALEN];
 	int err, i;
 
 	lan966x = devm_kzalloc(&pdev->dev, sizeof(*lan966x), GFP_KERNEL);
@@ -717,6 +867,14 @@ static int lan966x_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, lan966x);
 	lan966x->dev = &pdev->dev;
 
+	if (device_get_mac_address(&pdev->dev, mac_addr, sizeof(mac_addr))) {
+		ether_addr_copy(lan966x->base_mac, mac_addr);
+	} else {
+		pr_info("MAC addr was not set, use random MAC\n");
+		eth_random_addr(lan966x->base_mac);
+		lan966x->base_mac[5] &= 0xf0;
+	}
+
 	ports = device_get_named_child_node(&pdev->dev, "ethernet-ports");
 	if (!ports) {
 		dev_err(&pdev->dev, "no ethernet-ports child not found\n");
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 9ae1582f5cdb..d499f654e316 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -4,6 +4,9 @@
 #define __LAN966X_MAIN_H__
 
 #include <linux/etherdevice.h>
+#include "linux/ethtool.h"
+#include <linux/jiffies.h>
+#include <linux/spinlock.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
 
@@ -38,6 +41,30 @@
 
 #define CPU_PORT			8
 
+#define LAN966X_MACT_COLUMNS		4
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
@@ -59,6 +86,8 @@ struct lan966x {
 
 	int shared_queue_sz;
 
+	u8 base_mac[ETH_ALEN];
+
 	/* interrupts */
 	int xtr_irq;
 };
-- 
2.31.1

