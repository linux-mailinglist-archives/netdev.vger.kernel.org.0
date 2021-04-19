Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E8E364239
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239366AbhDSNCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239297AbhDSNBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:01:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288E9C061761
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 06:01:25 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWa-0003th-VR; Mon, 19 Apr 2021 15:01:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lYTWX-0001m8-1Q; Mon, 19 Apr 2021 15:01:09 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v3 3/6] net: add generic selftest support
Date:   Mon, 19 Apr 2021 15:01:03 +0200
Message-Id: <20210419130106.6707-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210419130106.6707-1-o.rempel@pengutronix.de>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port some parts of the stmmac selftest and reuse it as basic generic selftest
library. This patch was tested with following combinations:
- iMX6DL FEC -> AT8035
- iMX6DL FEC -> SJA1105Q switch -> KSZ8081
- iMX6DL FEC -> SJA1105Q switch -> KSZ9031
- AR9331 ag71xx -> AR9331 PHY
- AR9331 ag71xx -> AR9331 switch -> AR9331 PHY

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/net/selftests.h |  12 ++
 net/Kconfig             |   4 +
 net/core/Makefile       |   1 +
 net/core/selftests.c    | 400 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 417 insertions(+)
 create mode 100644 include/net/selftests.h
 create mode 100644 net/core/selftests.c

diff --git a/include/net/selftests.h b/include/net/selftests.h
new file mode 100644
index 000000000000..9993b9498cf3
--- /dev/null
+++ b/include/net/selftests.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NET_SELFTESTS
+#define _NET_SELFTESTS
+
+#include <linux/ethtool.h>
+
+void net_selftest(struct net_device *ndev, struct ethtool_test *etest,
+		  u64 *buf);
+int net_selftest_get_count(void);
+void net_selftest_get_strings(u8 *data);
+
+#endif /* _NET_SELFTESTS */
diff --git a/net/Kconfig b/net/Kconfig
index 9c456acc379e..8d955195c069 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -429,6 +429,10 @@ config GRO_CELLS
 config SOCK_VALIDATE_XMIT
 	bool
 
+config NET_SELFTESTS
+	def_tristate PHYLIB
+	depends on PHYLIB
+
 config NET_SOCK_MSG
 	bool
 	default n
diff --git a/net/core/Makefile b/net/core/Makefile
index 0c2233c826fd..1a6168d8f23b 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_NET_DEVLINK) += devlink.o
 obj-$(CONFIG_GRO_CELLS) += gro_cells.o
 obj-$(CONFIG_FAILOVER) += failover.o
 ifeq ($(CONFIG_INET),y)
+obj-$(CONFIG_NET_SELFTESTS) += selftests.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 endif
diff --git a/net/core/selftests.c b/net/core/selftests.c
new file mode 100644
index 000000000000..ba7b0171974c
--- /dev/null
+++ b/net/core/selftests.c
@@ -0,0 +1,400 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019 Synopsys, Inc. and/or its affiliates.
+ * stmmac Selftests Support
+ *
+ * Author: Jose Abreu <joabreu@synopsys.com>
+ *
+ * Ported from stmmac by:
+ * Copyright (C) 2021 Oleksij Rempel <o.rempel@pengutronix.de>
+ */
+
+#include <linux/phy.h>
+#include <net/selftests.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+
+struct net_packet_attrs {
+	unsigned char *src;
+	unsigned char *dst;
+	u32 ip_src;
+	u32 ip_dst;
+	bool tcp;
+	u16 sport;
+	u16 dport;
+	int timeout;
+	int size;
+	int max_size;
+	u8 id;
+	u16 queue_mapping;
+};
+
+struct net_test_priv {
+	struct net_packet_attrs *packet;
+	struct packet_type pt;
+	struct completion comp;
+	int double_vlan;
+	int vlan_id;
+	int ok;
+};
+
+struct netsfhdr {
+	__be32 version;
+	__be64 magic;
+	u8 id;
+} __packed;
+
+static u8 net_test_next_id;
+
+#define NET_TEST_PKT_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
+			   sizeof(struct netsfhdr))
+#define NET_TEST_PKT_MAGIC	0xdeadcafecafedeadULL
+#define NET_LB_TIMEOUT		msecs_to_jiffies(200)
+
+static struct sk_buff *net_test_get_skb(struct net_device *ndev,
+					struct net_packet_attrs *attr)
+{
+	struct sk_buff *skb = NULL;
+	struct udphdr *uhdr = NULL;
+	struct tcphdr *thdr = NULL;
+	struct netsfhdr *shdr;
+	struct ethhdr *ehdr;
+	struct iphdr *ihdr;
+	int iplen, size;
+
+	size = attr->size + NET_TEST_PKT_SIZE;
+
+	if (attr->tcp)
+		size += sizeof(struct tcphdr);
+	else
+		size += sizeof(struct udphdr);
+
+	if (attr->max_size && attr->max_size > size)
+		size = attr->max_size;
+
+	skb = netdev_alloc_skb(ndev, size);
+	if (!skb)
+		return NULL;
+
+	prefetchw(skb->data);
+
+	ehdr = skb_push(skb, ETH_HLEN);
+	skb_reset_mac_header(skb);
+
+	skb_set_network_header(skb, skb->len);
+	ihdr = skb_put(skb, sizeof(*ihdr));
+
+	skb_set_transport_header(skb, skb->len);
+	if (attr->tcp)
+		thdr = skb_put(skb, sizeof(*thdr));
+	else
+		uhdr = skb_put(skb, sizeof(*uhdr));
+
+	eth_zero_addr(ehdr->h_dest);
+
+	if (attr->src)
+		ether_addr_copy(ehdr->h_source, attr->src);
+	if (attr->dst)
+		ether_addr_copy(ehdr->h_dest, attr->dst);
+
+	ehdr->h_proto = htons(ETH_P_IP);
+
+	if (attr->tcp) {
+		thdr->source = htons(attr->sport);
+		thdr->dest = htons(attr->dport);
+		thdr->doff = sizeof(struct tcphdr) / 4;
+		thdr->check = 0;
+	} else {
+		uhdr->source = htons(attr->sport);
+		uhdr->dest = htons(attr->dport);
+		uhdr->len = htons(sizeof(*shdr) + sizeof(*uhdr) + attr->size);
+		if (attr->max_size)
+			uhdr->len = htons(attr->max_size -
+					  (sizeof(*ihdr) + sizeof(*ehdr)));
+		uhdr->check = 0;
+	}
+
+	ihdr->ihl = 5;
+	ihdr->ttl = 32;
+	ihdr->version = 4;
+	if (attr->tcp)
+		ihdr->protocol = IPPROTO_TCP;
+	else
+		ihdr->protocol = IPPROTO_UDP;
+	iplen = sizeof(*ihdr) + sizeof(*shdr) + attr->size;
+	if (attr->tcp)
+		iplen += sizeof(*thdr);
+	else
+		iplen += sizeof(*uhdr);
+
+	if (attr->max_size)
+		iplen = attr->max_size - sizeof(*ehdr);
+
+	ihdr->tot_len = htons(iplen);
+	ihdr->frag_off = 0;
+	ihdr->saddr = htonl(attr->ip_src);
+	ihdr->daddr = htonl(attr->ip_dst);
+	ihdr->tos = 0;
+	ihdr->id = 0;
+	ip_send_check(ihdr);
+
+	shdr = skb_put(skb, sizeof(*shdr));
+	shdr->version = 0;
+	shdr->magic = cpu_to_be64(NET_TEST_PKT_MAGIC);
+	attr->id = net_test_next_id;
+	shdr->id = net_test_next_id++;
+
+	if (attr->size)
+		skb_put(skb, attr->size);
+	if (attr->max_size && attr->max_size > skb->len)
+		skb_put(skb, attr->max_size - skb->len);
+
+	skb->csum = 0;
+	skb->ip_summed = CHECKSUM_PARTIAL;
+	if (attr->tcp) {
+		thdr->check = ~tcp_v4_check(skb->len, ihdr->saddr,
+					    ihdr->daddr, 0);
+		skb->csum_start = skb_transport_header(skb) - skb->head;
+		skb->csum_offset = offsetof(struct tcphdr, check);
+	} else {
+		udp4_hwcsum(skb, ihdr->saddr, ihdr->daddr);
+	}
+
+	skb->protocol = htons(ETH_P_IP);
+	skb->pkt_type = PACKET_HOST;
+	skb->dev = ndev;
+
+	return skb;
+}
+
+static int net_test_loopback_validate(struct sk_buff *skb,
+				      struct net_device *ndev,
+				      struct packet_type *pt,
+				      struct net_device *orig_ndev)
+{
+	struct net_test_priv *tpriv = pt->af_packet_priv;
+	unsigned char *src = tpriv->packet->src;
+	unsigned char *dst = tpriv->packet->dst;
+	struct netsfhdr *shdr;
+	struct ethhdr *ehdr;
+	struct udphdr *uhdr;
+	struct tcphdr *thdr;
+	struct iphdr *ihdr;
+
+	skb = skb_unshare(skb, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+
+	if (skb_linearize(skb))
+		goto out;
+	if (skb_headlen(skb) < (NET_TEST_PKT_SIZE - ETH_HLEN))
+		goto out;
+
+	ehdr = (struct ethhdr *)skb_mac_header(skb);
+	if (dst) {
+		if (!ether_addr_equal_unaligned(ehdr->h_dest, dst))
+			goto out;
+	}
+
+	if (src) {
+		if (!ether_addr_equal_unaligned(ehdr->h_source, src))
+			goto out;
+	}
+
+	ihdr = ip_hdr(skb);
+	if (tpriv->double_vlan)
+		ihdr = (struct iphdr *)(skb_network_header(skb) + 4);
+
+	if (tpriv->packet->tcp) {
+		if (ihdr->protocol != IPPROTO_TCP)
+			goto out;
+
+		thdr = (struct tcphdr *)((u8 *)ihdr + 4 * ihdr->ihl);
+		if (thdr->dest != htons(tpriv->packet->dport))
+			goto out;
+
+		shdr = (struct netsfhdr *)((u8 *)thdr + sizeof(*thdr));
+	} else {
+		if (ihdr->protocol != IPPROTO_UDP)
+			goto out;
+
+		uhdr = (struct udphdr *)((u8 *)ihdr + 4 * ihdr->ihl);
+		if (uhdr->dest != htons(tpriv->packet->dport))
+			goto out;
+
+		shdr = (struct netsfhdr *)((u8 *)uhdr + sizeof(*uhdr));
+	}
+
+	if (shdr->magic != cpu_to_be64(NET_TEST_PKT_MAGIC))
+		goto out;
+	if (tpriv->packet->id != shdr->id)
+		goto out;
+
+	tpriv->ok = true;
+	complete(&tpriv->comp);
+out:
+	kfree_skb(skb);
+	return 0;
+}
+
+static int __net_test_loopback(struct net_device *ndev,
+			       struct net_packet_attrs *attr)
+{
+	struct net_test_priv *tpriv;
+	struct sk_buff *skb = NULL;
+	int ret = 0;
+
+	tpriv = kzalloc(sizeof(*tpriv), GFP_KERNEL);
+	if (!tpriv)
+		return -ENOMEM;
+
+	tpriv->ok = false;
+	init_completion(&tpriv->comp);
+
+	tpriv->pt.type = htons(ETH_P_IP);
+	tpriv->pt.func = net_test_loopback_validate;
+	tpriv->pt.dev = ndev;
+	tpriv->pt.af_packet_priv = tpriv;
+	tpriv->packet = attr;
+	dev_add_pack(&tpriv->pt);
+
+	skb = net_test_get_skb(ndev, attr);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	ret = dev_direct_xmit(skb, attr->queue_mapping);
+	if (ret < 0) {
+		goto cleanup;
+	} else if (ret > 0) {
+		ret = -ENETUNREACH;
+		goto cleanup;
+	}
+
+	if (!attr->timeout)
+		attr->timeout = NET_LB_TIMEOUT;
+
+	wait_for_completion_timeout(&tpriv->comp, attr->timeout);
+	ret = tpriv->ok ? 0 : -ETIMEDOUT;
+
+cleanup:
+	dev_remove_pack(&tpriv->pt);
+	kfree(tpriv);
+	return ret;
+}
+
+static int net_test_netif_carrier(struct net_device *ndev)
+{
+	return netif_carrier_ok(ndev) ? 0 : -ENOLINK;
+}
+
+static int net_test_phy_phydev(struct net_device *ndev)
+{
+	return ndev->phydev ? 0 : -EOPNOTSUPP;
+}
+
+static int net_test_phy_loopback_enable(struct net_device *ndev)
+{
+	if (!ndev->phydev)
+		return -EOPNOTSUPP;
+
+	return phy_loopback(ndev->phydev, true);
+}
+
+static int net_test_phy_loopback_disable(struct net_device *ndev)
+{
+	if (!ndev->phydev)
+		return -EOPNOTSUPP;
+
+	return phy_loopback(ndev->phydev, false);
+}
+
+static int net_test_phy_loopback_udp(struct net_device *ndev)
+{
+	struct net_packet_attrs attr = { };
+
+	attr.dst = ndev->dev_addr;
+	return __net_test_loopback(ndev, &attr);
+}
+
+static int net_test_phy_loopback_tcp(struct net_device *ndev)
+{
+	struct net_packet_attrs attr = { };
+
+	attr.dst = ndev->dev_addr;
+	attr.tcp = true;
+	return __net_test_loopback(ndev, &attr);
+}
+
+static const struct net_test {
+	char name[ETH_GSTRING_LEN];
+	int (*fn)(struct net_device *ndev);
+} net_selftests[] = {
+	{
+		.name = "Carrier                       ",
+		.fn = net_test_netif_carrier,
+	}, {
+		.name = "PHY dev is present            ",
+		.fn = net_test_phy_phydev,
+	}, {
+		/* This test should be done before all PHY loopback test */
+		.name = "PHY internal loopback, enable ",
+		.fn = net_test_phy_loopback_enable,
+	}, {
+		.name = "PHY internal loopback, UDP    ",
+		.fn = net_test_phy_loopback_udp,
+	}, {
+		.name = "PHY internal loopback, TCP    ",
+		.fn = net_test_phy_loopback_tcp,
+	}, {
+		/* This test should be done after all PHY loopback test */
+		.name = "PHY internal loopback, disable",
+		.fn = net_test_phy_loopback_disable,
+	},
+};
+
+void net_selftest(struct net_device *ndev, struct ethtool_test *etest, u64 *buf)
+{
+	int count = net_selftest_get_count();
+	int i;
+
+	memset(buf, 0, sizeof(*buf) * count);
+	net_test_next_id = 0;
+
+	if (etest->flags != ETH_TEST_FL_OFFLINE) {
+		netdev_err(ndev, "Only offline tests are supported\n");
+		etest->flags |= ETH_TEST_FL_FAILED;
+		return;
+	}
+
+
+	for (i = 0; i < count; i++) {
+		buf[i] = net_selftests[i].fn(ndev);
+		if (buf[i] && (buf[i] != -EOPNOTSUPP))
+			etest->flags |= ETH_TEST_FL_FAILED;
+	}
+}
+EXPORT_SYMBOL_GPL(net_selftest);
+
+int net_selftest_get_count(void)
+{
+	return ARRAY_SIZE(net_selftests);
+}
+EXPORT_SYMBOL_GPL(net_selftest_get_count);
+
+void net_selftest_get_strings(u8 *data)
+{
+	u8 *p = data;
+	int i;
+
+	for (i = 0; i < net_selftest_get_count(); i++) {
+		snprintf(p, ETH_GSTRING_LEN, "%2d. %s", i + 1,
+			 net_selftests[i].name);
+		p += ETH_GSTRING_LEN;
+	}
+}
+EXPORT_SYMBOL_GPL(net_selftest_get_strings);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Oleksij Rempel <o.rempel@pengutronix.de>");
-- 
2.29.2

