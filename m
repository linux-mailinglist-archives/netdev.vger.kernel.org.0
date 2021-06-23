Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEAC3B1951
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhFWLw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:52:28 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:56689 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230415AbhFWLw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:52:26 -0400
X-UUID: d888dcea7079499698a62fe7558d824b-20210623
X-UUID: d888dcea7079499698a62fe7558d824b-20210623
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1102916961; Wed, 23 Jun 2021 19:50:04 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Jun 2021 19:49:57 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Jun 2021 19:49:56 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
CC:     <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <chao.song@mediatek.com>,
        <zhuoliang.zhang@mediatek.com>, <kuohong.wang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH 4/4] drivers: net: mediatek: initial implementation of ccmni
Date:   Wed, 23 Jun 2021 19:34:52 +0800
Message-ID: <20210623113452.5671-4-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210623113452.5671-1-rocco.yue@mediatek.com>
References: <20210623113452.5671-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ccmni driver is used by all recent chipsets using MediaTek Inc.
modems. It provides a bridge to shield hardware differences and
connect kernel netdevice. Module provides virtual network devices
which can be used to support different mobile networks, such as
a default cellular internet,or IMS network.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 .../device_drivers/cellular/ccmni/ccmni.rst   | 151 +++++++++
 MAINTAINERS                                   |   9 +
 drivers/net/ethernet/mediatek/Kconfig         |   5 +
 drivers/net/ethernet/mediatek/Makefile        |   4 +-
 drivers/net/ethernet/mediatek/ccmni/Kconfig   |  15 +
 drivers/net/ethernet/mediatek/ccmni/Makefile  |   7 +
 drivers/net/ethernet/mediatek/ccmni/ccmni.c   | 291 ++++++++++++++++++
 drivers/net/ethernet/mediatek/ccmni/ccmni.h   |  53 ++++
 8 files changed, 534 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/device_drivers/cellular/ccmni/ccmni.rst
 create mode 100644 drivers/net/ethernet/mediatek/ccmni/Kconfig
 create mode 100644 drivers/net/ethernet/mediatek/ccmni/Makefile
 create mode 100644 drivers/net/ethernet/mediatek/ccmni/ccmni.c
 create mode 100644 drivers/net/ethernet/mediatek/ccmni/ccmni.h

diff --git a/Documentation/networking/device_drivers/cellular/ccmni/ccmni.rst b/Documentation/networking/device_drivers/cellular/ccmni/ccmni.rst
new file mode 100644
index 000000000000..16d547786cbd
--- /dev/null
+++ b/Documentation/networking/device_drivers/cellular/ccmni/ccmni.rst
@@ -0,0 +1,151 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+===================================================================
+Linux kernel driver for Cross Core Multi Network Interface (ccmni):
+===================================================================
+
+
+1. Introduction
+===============
+
+ccmni driver is built on the top of AP-CCCI (Application Processor Cross
+Core Communite Interface) to emulate the modem’s data networking service
+as a network interface card. This driver is used by all recent chipsets
+using MediaTek Inc. modems.
+
+This driver can support multiple tx/rx channels, each channel has its
+own IP address, and ipv4 and ipv6 link-local addresses on the interface
+is set through ioctl, which means that ccmni driver is a pure ip device
+and it does not need the kernel to generate these ip addresses
+automatically.
+
+Creating logical network devices (ccmni devices) can be used to handle
+multiple private data networks (PDNs), such as a defaule cellular
+internet, IP Multimedia Subsystem (IMS) network (VoWiFi/VoLTE), IMS
+Emergency, Tethering, Multimedia Messaging Service (MMS), and so on.
+In general, one ccmni device corresponds to one PDN.
+
+ccmni design
+------------
+
+- AT commands and responses between the Application Processor and Modem
+  Processor take place over the ccci tty serial port emulation.
+- IP packets coming into the ccmni driver (from the Modem) needs to be
+  un-framed (via the Packet Framing Protocol) before it can be stuffed
+  into the Socket Buffer.
+- IP Packets going out of the ccmni driver (to the Modem) needs to be
+  framed (via the Packet Framing Protocol) before it can be pushed into
+  the respective ccci tx buffer.
+- The Packet Framing Protocol module contains algorithms to correctly
+  add or remove frames, going out to and coming into, the ccmni driver
+  respectively.
+- Packets are passed to, and received from the Linux networking system,
+  via Socket Buffers.
+- The Android Application Framework contains codes to setup the ccmni’s
+  parameters (such as netmask), and the routing table.
+
+
+2. Architecture
+===============
+
+         +------------------------+   +---------------------+
+user     |        MTK RilD        |   |   network process   |
+space    | (config/up/down ccmni) |   | (send/recv packets) |
+         +------------------------+   +---------------------+
++--------------------------------------------------------------------+
+         +--------------------------------------------------+
+         |                      socket                      |
+         +--------------------------------------------------+
+                                      +---------------------+
+                                      |     TCP/IP stack    |
+                                      +---------------------+
+         +--------------------------------------------------+
+	 |                net device layer                  |
+         +--------------------------------------------------+
+                +--------+  +--------+     +--------+
+kernel          | ccmni0 |  | ccmni1 | ... | ccmnix |
+space           +--------+  +--------+     +--------+
+         +-------------------------------------------------+
+         |                   ccmni driver                  |
+         +-------------------------------------------------+
+         +-------------------------------------------------+
+         |                    AP-CCCI                      |
+         +-------------------------------------------------+
++---------------------------------------------------------------------+
+         +-------------------------------------------------+
+         |  +-------------------+   +-------------------+  |
+         |  |  DPMAIF hardware  |   |      MD-CCCI      |  |
+         |  +-------------------+   +-------------------+  |
+         |                     ... ...                     |
+         | Modem Processor                                 |
+         +-------------------------------------------------+
+
+
+3. Driver information and notes
+===============================
+
+Data Connection Set Up
+----------------------
+
+The data framework will first SetupDataCall with passing ccmni index,
+and then RilD will activate PDN connection and get CID (Connection ID).
+
+Next, RilD will creat ccmni socket to use ioctl to configure ccmni up,
+and then ccmni_open() will be called.
+
+In addition, since ccmni is a pureip device, RilD needs to use ioctl to
+configure the ipv4/ipv6-link-local address for ccmni after it is up.
+
+Alternatively, you can use the ip command as follows::
+    ip link set up dev ccmni<x>
+    ip addr add a.b.c.d dev ccmni<x>
+    ip -6 addr add fe80::1/64 dev ccmni<x>
+
+Data Connection Set Down
+------------------------
+
+The data service implements a method to tear down the data connection,
+after RilD deactivate the PDN connection, RilD will down the specific
+interface of ccmnix through ioctl SIOCSIFFLAGS, and then ccmni_close()
+will be called. After that, if any network process (such as browser) wants
+to write data to ccmni socket, TCP/IP stack will return an error to
+this socket.
+
+Data Transmit
+-------------
+
+In the uplink direction, when there is data to be transmitted to the cellular
+network, ccmni_start_xmit() will be called by the Linux networking system.
+
+main operations in ccmni_start_xmit():
+- the datagram to be transmitted is housed in the Socket Buffer.
+- check if the datagram is within limits (i.e. 1500 bytes) acceptable by the
+  Modem. If the datagram exceeds limit, the datagram will be dropped, and free
+  the Socket Buffer.
+- check if the AP-CCCI TX buffer is busy, or do not have enough space for this
+  datagram. If it is busy, or the free space is too small, ccmni_start_xmit()
+  return NETDEV_TX_BUSY and ask the Linux netdevice to stop the tx queue.
+
+To handle outcoming datagrams to the Modem, ccmni register a callback function
+for AP-CCCI driver. ccmni_hif_hook() means ccci can implement specific egress
+function to send these packets to the specific hardware.
+
+Data Receive
+------------
+
+In the downlink direction, DPMAIF (Data Path MD AP Interface) hardware sends
+packets and messages with channel id matching these packets to AP-CCCI driver.
+
+To handle incoming datagrams from the Modem, ccmni register a callback
+function for the AP-CCCI driver. ccmni_rx_push() responsible for extracting
+the incoming packets from the ccci rx buffer, and updating skb. Once ready,
+ccmni signal to the Linux networking system to take out Socket Buffer
+(via netif_rx() / netif_rx_ni()).
+
+
+Support
+=======
+
+If an issue is identified by published source code and supported adapter on
+the supported kernel, please email the specific information about the issue
+to rocco.yue@mediatek.com and chao.song@mediatek.com
diff --git a/MAINTAINERS b/MAINTAINERS
index 8c5ee008301a..1e53a754c727 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11612,6 +11612,15 @@ F:	Documentation/devicetree/bindings/usb/mediatek,*
 F:	drivers/usb/host/xhci-mtk*
 F:	drivers/usb/mtu3/
 
+MEDIATEK CCMNI DRIVER
+M:	Rocco Yue <rocco.yue@mediatek.com>
+M:	Chao Song <chao.song@mediatek.com>
+M:	Zhuoliang Zhang <zhuoliang.zhang@mediatek.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/networking/device_drivers/cellular/mediatek/ccmni.rst
+F:	drivers/net/ethernet/mediatek/ccmni/
+
 MEGACHIPS STDPXXXX-GE-B850V3-FW LVDS/DP++ BRIDGES
 M:	Peter Senna Tschudin <peter.senna@gmail.com>
 M:	Martin Donnelly <martin.donnelly@ge.com>
diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index c357c193378e..2f499f3bc720 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+#
+# MediaTek network device configuration
+#
 config NET_VENDOR_MEDIATEK
 	bool "MediaTek devices"
 	depends on ARCH_MEDIATEK || SOC_MT7621 || SOC_MT7620
@@ -24,4 +27,6 @@ config NET_MEDIATEK_STAR_EMAC
 	  This driver supports the ethernet MAC IP first used on
 	  MediaTek MT85** SoCs.
 
+source "drivers/net/ethernet/mediatek/ccmni/Kconfig"
+
 endif #NET_VENDOR_MEDIATEK
diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
index 79d4cdbbcbf5..85bd3ebf2388 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -1,8 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# Makefile for the Mediatek SoCs built-in ethernet macs
+# Makefile for the Mediatek network device drivers.
 #
 
 obj-$(CONFIG_NET_MEDIATEK_SOC) += mtk_eth.o
 mtk_eth-y := mtk_eth_soc.o mtk_sgmii.o mtk_eth_path.o mtk_ppe.o mtk_ppe_debugfs.o mtk_ppe_offload.o
 obj-$(CONFIG_NET_MEDIATEK_STAR_EMAC) += mtk_star_emac.o
+
+obj-$(CONFIG_MTK_NET_CCMNI) += ccmni/
diff --git a/drivers/net/ethernet/mediatek/ccmni/Kconfig b/drivers/net/ethernet/mediatek/ccmni/Kconfig
new file mode 100644
index 000000000000..d97c0e48b58e
--- /dev/null
+++ b/drivers/net/ethernet/mediatek/ccmni/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# MediaTek CCMNI driver
+#
+
+menuconfig MTK_NET_CCMNI
+	tristate "MediaTek CCMNI driver"
+	default n
+	help
+	  Cross Core Multi Network Interface:
+	  If you select this, you will enable the CCMNI module which is used
+	  to shield hardware differences and communicate with kernel netdevice
+	  and be used for handling outgoing/incoimg mobile data. Module provides
+	  virtual network devices which can be used to support different mobile
+	  networks.
diff --git a/drivers/net/ethernet/mediatek/ccmni/Makefile b/drivers/net/ethernet/mediatek/ccmni/Makefile
new file mode 100644
index 000000000000..e79c23d1b79d
--- /dev/null
+++ b/drivers/net/ethernet/mediatek/ccmni/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the ccmni module
+#
+ccflags-y += -I$(srctree)/drivers/net/ethernet/mediatek/ccmni/
+obj-$(CONFIG_MTK_NET_CCMNI) += ccmni.o
+
diff --git a/drivers/net/ethernet/mediatek/ccmni/ccmni.c b/drivers/net/ethernet/mediatek/ccmni/ccmni.c
new file mode 100644
index 000000000000..700a0d092596
--- /dev/null
+++ b/drivers/net/ethernet/mediatek/ccmni/ccmni.c
@@ -0,0 +1,291 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 MediaTek Inc.
+ *
+ * CCMNI Data virtual netwotrk driver
+ */
+
+#include <linux/if_arp.h>
+#include <linux/module.h>
+#include <linux/preempt.h>
+#include <net/sch_generic.h>
+
+#include "ccmni.h"
+
+static struct ccmni_ctl_block *s_ccmni_ctlb;
+static int ccmni_hook_ready;
+
+/* Network Device Operations */
+
+static int ccmni_open(struct net_device *ccmni_dev)
+{
+	struct ccmni_inst *ccmni = netdev_priv(ccmni_dev);
+
+	netif_tx_start_all_queues(ccmni_dev);
+	netif_carrier_on(ccmni_dev);
+
+	if (atomic_inc_return(&ccmni->usage) > 1) {
+		atomic_dec(&ccmni->usage);
+		netdev_err(ccmni_dev, "dev already open\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ccmni_close(struct net_device *ccmni_dev)
+{
+	struct ccmni_inst *ccmni = netdev_priv(ccmni_dev);
+
+	atomic_dec(&ccmni->usage);
+	netif_tx_disable(ccmni_dev);
+
+	return 0;
+}
+
+static netdev_tx_t
+ccmni_start_xmit(struct sk_buff *skb, struct net_device *ccmni_dev)
+{
+	struct ccmni_inst *ccmni = NULL;
+
+	if (unlikely(!ccmni_hook_ready))
+		goto tx_ok;
+
+	if (!skb || !ccmni_dev)
+		goto tx_ok;
+
+	ccmni = netdev_priv(ccmni_dev);
+
+	/* some process can modify ccmni_dev->mtu */
+	if (skb->len > ccmni_dev->mtu) {
+		netdev_err(ccmni_dev, "xmit fail: len(0x%x) > MTU(0x%x, 0x%x)",
+			   skb->len, CCMNI_MTU, ccmni_dev->mtu);
+		goto tx_ok;
+	}
+
+	/* hardware driver send packet will return a negative value
+	 * ask the Linux netdevice to stop the tx queue
+	 */
+	if ((s_ccmni_ctlb->xmit_pkt(ccmni->index, skb, 0)) < 0)
+		return NETDEV_TX_BUSY;
+
+	return NETDEV_TX_OK;
+tx_ok:
+	dev_kfree_skb(skb);
+	ccmni_dev->stats.tx_dropped++;
+	return NETDEV_TX_OK;
+}
+
+static int ccmni_change_mtu(struct net_device *ccmni_dev, int new_mtu)
+{
+	if (new_mtu < 0 || new_mtu > CCMNI_MTU)
+		return -EINVAL;
+
+	if (unlikely(!ccmni_dev))
+		return -EINVAL;
+
+	ccmni_dev->mtu = new_mtu;
+	return 0;
+}
+
+static void ccmni_tx_timeout(struct net_device *ccmni_dev, unsigned int txqueue)
+{
+	struct ccmni_inst *ccmni = netdev_priv(ccmni_dev);
+
+	ccmni_dev->stats.tx_errors++;
+	if (atomic_read(&ccmni->usage) > 0)
+		netif_tx_wake_all_queues(ccmni_dev);
+}
+
+static const struct net_device_ops ccmni_netdev_ops = {
+	.ndo_open		= ccmni_open,
+	.ndo_stop		= ccmni_close,
+	.ndo_start_xmit		= ccmni_start_xmit,
+	.ndo_tx_timeout		= ccmni_tx_timeout,
+	.ndo_change_mtu		= ccmni_change_mtu,
+};
+
+/* init ccmni network device */
+static inline void ccmni_dev_init(struct net_device *ccmni_dev, unsigned int idx)
+{
+	ccmni_dev->mtu = CCMNI_MTU;
+	ccmni_dev->tx_queue_len = CCMNI_TX_QUEUE;
+	ccmni_dev->watchdog_timeo = CCMNI_NETDEV_WDT_TO;
+	ccmni_dev->flags = IFF_NOARP &
+			(~IFF_BROADCAST & ~IFF_MULTICAST);
+
+	/* not support VLAN */
+	ccmni_dev->features = NETIF_F_VLAN_CHALLENGED;
+	ccmni_dev->features |= NETIF_F_SG;
+	ccmni_dev->hw_features |= NETIF_F_SG;
+
+	/* pure ip mode */
+	ccmni_dev->type = ARPHRD_PUREIP;
+	ccmni_dev->header_ops = NULL;
+	ccmni_dev->hard_header_len = 0;
+	ccmni_dev->addr_len = 0;
+	ccmni_dev->priv_destructor = free_netdev;
+	ccmni_dev->netdev_ops = &ccmni_netdev_ops;
+	random_ether_addr((u8 *)ccmni_dev->dev_addr);
+	sprintf(ccmni_dev->name, "ccmni%d", idx);
+}
+
+/* init ccmni instance */
+static inline void ccmni_inst_init(struct net_device *netdev, unsigned int idx)
+{
+	struct ccmni_inst *ccmni = netdev_priv(netdev);
+
+	ccmni->index = idx;
+	ccmni->dev = netdev;
+	atomic_set(&ccmni->usage, 0);
+
+	s_ccmni_ctlb->ccmni_inst[idx] = ccmni;
+}
+
+/* ccmni driver module startup/shutdown */
+
+static int __init ccmni_init(void)
+{
+	struct net_device *dev = NULL;
+	unsigned int i, j;
+	int ret = 0;
+
+	s_ccmni_ctlb = kzalloc(sizeof(*s_ccmni_ctlb), GFP_KERNEL);
+	if (!s_ccmni_ctlb)
+		return -ENOMEM;
+
+	s_ccmni_ctlb->max_num = MAX_CCMNI_NUM;
+	for (i = 0; i < MAX_CCMNI_NUM; i++) {
+		/* alloc multiple tx queue, 2 txq and 1 rxq */
+		dev = alloc_etherdev_mqs(sizeof(struct ccmni_inst), 2, 1);
+		if (unlikely(!dev)) {
+			ret = -ENOMEM;
+			goto alloc_netdev_fail;
+		}
+		ccmni_dev_init(dev, i);
+		ccmni_inst_init(dev, i);
+		ret = register_netdev(dev);
+		if (ret)
+			goto alloc_netdev_fail;
+	}
+	return ret;
+
+alloc_netdev_fail:
+	if (dev) {
+		free_netdev(dev);
+		s_ccmni_ctlb->ccmni_inst[i] = NULL;
+	}
+	for (j = i - 1; j >= 0; j--) {
+		unregister_netdev(s_ccmni_ctlb->ccmni_inst[j]->dev);
+		s_ccmni_ctlb->ccmni_inst[j] = NULL;
+	}
+	kfree(s_ccmni_ctlb);
+	s_ccmni_ctlb = NULL;
+
+	return ret;
+}
+
+static void __exit ccmni_exit(void)
+{
+	struct ccmni_ctl_block *ctlb = NULL;
+	struct ccmni_inst *ccmni = NULL;
+	int i;
+
+	ctlb = s_ccmni_ctlb;
+	if (!s_ccmni_ctlb)
+		return;
+	for (i = 0; i < s_ccmni_ctlb->max_num; i++) {
+		ccmni = s_ccmni_ctlb->ccmni_inst[i];
+		if (ccmni) {
+			unregister_netdev(ccmni->dev);
+			s_ccmni_ctlb->ccmni_inst[i] = NULL;
+		}
+	}
+	kfree(s_ccmni_ctlb);
+	s_ccmni_ctlb = NULL;
+}
+
+/* exposed API
+ * receive incoming datagrams from the Modem and push them to the
+ * kernel networking system
+ */
+int ccmni_rx_push(unsigned int ccmni_idx, struct sk_buff *skb)
+{
+	struct ccmni_inst *ccmni = NULL;
+	struct net_device *dev = NULL;
+	int pkt_type, skb_len;
+
+	if (unlikely(!ccmni_hook_ready))
+		return -EINVAL;
+
+	/* Some hardware can send us error index. Catch them */
+	if (unlikely(ccmni_idx >= s_ccmni_ctlb->max_num))
+		return -EINVAL;
+
+	ccmni = s_ccmni_ctlb->ccmni_inst[ccmni_idx];
+	dev = ccmni->dev;
+
+	pkt_type = skb->data[0] & 0xF0;
+	skb_reset_transport_header(skb);
+	skb_reset_network_header(skb);
+	skb_set_mac_header(skb, 0);
+	skb_reset_mac_len(skb);
+	skb->dev = dev;
+
+	if (pkt_type == IPV6_VERSION)
+		skb->protocol = htons(ETH_P_IPV6);
+	else if (pkt_type == IPV4_VERSION)
+		skb->protocol = htons(ETH_P_IP);
+
+	skb_len = skb->len;
+
+	if (!in_interrupt())
+		netif_rx_ni(skb);
+	else
+		netif_rx(skb);
+
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += skb_len;
+
+	return 0;
+}
+EXPORT_SYMBOL(ccmni_rx_push);
+
+/* exposed API
+ * hardware driver can init the struct ccmni_hif_ops and implement specific
+ * xmnit function to send UL packets to the specific hardware
+ */
+int ccmni_hif_hook(struct ccmni_hif_ops *hif_ops)
+{
+	if (unlikely(!hif_ops)) {
+		pr_err("ccmni: %s fail: argument is NULL\n", __func__);
+		return -EINVAL;
+	}
+	if (unlikely(!s_ccmni_ctlb)) {
+		pr_err("ccmni: %s fail: s_ccmni_ctlb is NULL\n", __func__);
+		return -EINVAL;
+	}
+	if (unlikely(s_ccmni_ctlb->hif_ops)) {
+		pr_err("ccmni: %s fail: hif_ops already hooked\n", __func__);
+		return -EINVAL;
+	}
+
+	s_ccmni_ctlb->hif_ops = hif_ops;
+	if (!hif_ops->xmit_pkt) {
+		pr_err("ccmni: %s fail: key hook func: xmit is NULL\n",
+		       __func__);
+		return -EINVAL;
+	}
+
+	s_ccmni_ctlb->xmit_pkt = hif_ops->xmit_pkt;
+	ccmni_hook_ready = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(ccmni_hif_hook);
+
+module_init(ccmni_init);
+module_exit(ccmni_exit);
+MODULE_AUTHOR("MediaTek, Inc.");
+MODULE_DESCRIPTION("ccmni driver v1.0");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/mediatek/ccmni/ccmni.h b/drivers/net/ethernet/mediatek/ccmni/ccmni.h
new file mode 100644
index 000000000000..e2799aa2c9d4
--- /dev/null
+++ b/drivers/net/ethernet/mediatek/ccmni/ccmni.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 MediaTek Inc.
+ *
+ * CCMNI Data virtual netwotrk driver
+ */
+
+#ifndef __CCMNI_NET_H__
+#define __CCMNI_NET_H__
+
+#include <linux/device.h>
+#include <linux/etherdevice.h>
+#include <linux/if_ether.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+
+#define CCMNI_MTU		1500
+#define CCMNI_TX_QUEUE		1000
+#define CCMNI_NETDEV_WDT_TO	(1 * HZ)
+
+#define IPV4_VERSION		0x40
+#define IPV6_VERSION		0x60
+
+#define MAX_CCMNI_NUM		22
+
+/* One instance of this structure is instantiated for each
+ * real_dev associated with ccmni
+ */
+struct ccmni_inst {
+	int			index;
+	atomic_t		usage;
+	struct net_device	*dev;
+	unsigned char		name[16];
+};
+
+/* an export struct of ccmni hardware interface operations
+ */
+struct ccmni_hif_ops {
+	int (*xmit_pkt)(int index, void *data, int ref_flag);
+};
+
+struct ccmni_ctl_block {
+	int (*xmit_pkt)(int index, void *data, int ref_flag);
+	struct ccmni_hif_ops	*hif_ops;
+	struct ccmni_inst	*ccmni_inst[MAX_CCMNI_NUM];
+	int max_num;
+};
+
+int ccmni_hif_hook(struct ccmni_hif_ops *hif_ops);
+int ccmni_rx_push(unsigned int ccmni_idx, struct sk_buff *skb);
+
+#endif /* __CCMNI_NET_H__ */
-- 
2.18.0

