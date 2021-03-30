Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5FB34E9A7
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhC3Nyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbhC3NyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:54:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E6AC061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:54:14 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lREos-0006Q4-3h; Tue, 30 Mar 2021 15:54:10 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lREoq-0004Rk-Po; Tue, 30 Mar 2021 15:54:08 +0200
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
Subject: [PATCH net-next v1 3/3] net: fec: add basic selftest support
Date:   Tue, 30 Mar 2021 15:54:07 +0200
Message-Id: <20210330135407.17010-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210330135407.17010-1-o.rempel@pengutronix.de>
References: <20210330135407.17010-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Port some parts of the stmmac selftest to the FEC. This patch was tested
on iMX6DL.
With this tests it is possible to detect some basic issues like:
- MAC loopback fail: most probably wrong clock configuration.
- PHY loopback fail: incorrect RGMII timings, damaged traces, etc

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/freescale/Makefile       |   2 +-
 drivers/net/ethernet/freescale/fec.h          |   6 +
 drivers/net/ethernet/freescale/fec_main.c     |   6 +
 .../net/ethernet/freescale/fec_selftests.c    | 425 ++++++++++++++++++
 4 files changed, 438 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/freescale/fec_selftests.c

diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
index 67c436400352..b936c6fe5911 100644
--- a/drivers/net/ethernet/freescale/Makefile
+++ b/drivers/net/ethernet/freescale/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-$(CONFIG_FEC) += fec.o
-fec-objs :=fec_main.o fec_ptp.o
+fec-objs :=fec_main.o fec_ptp.o fec_selftests.o
 
 obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx.o
 ifeq ($(CONFIG_FEC_MPC52xx_MDIO),y)
diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0602d5d5d2ee..ade6a80934bf 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -467,6 +467,9 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_NO_HARD_RESET		(1 << 18)
 
+#define FEC_ENET_DRT	(1 << 1)
+#define FEC_ENET_LOOP	(1 << 0)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
@@ -604,6 +607,9 @@ void fec_ptp_start_cyclecounter(struct net_device *ndev);
 void fec_ptp_disable_hwts(struct net_device *ndev);
 int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
 int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
+void fec_selftest(struct net_device *ndev, struct ethtool_test *etest, u64 *data);
+int fec_selftest_get_count(void);
+void fec_selftest_get_strings(u8 *data);
 
 /****************************************************************************/
 #endif /* FEC_H */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3db882322b2b..2ca72f7b5b7d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2474,6 +2474,9 @@ static void fec_enet_get_strings(struct net_device *netdev,
 {
 	int i;
 	switch (stringset) {
+	case ETH_SS_TEST:
+		fec_selftest_get_strings(data);
+		break;
 	case ETH_SS_STATS:
 		for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
 			memcpy(data + i * ETH_GSTRING_LEN,
@@ -2485,6 +2488,8 @@ static void fec_enet_get_strings(struct net_device *netdev,
 static int fec_enet_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
+	case ETH_SS_TEST:
+		return fec_selftest_get_count();
 	case ETH_SS_STATS:
 		return ARRAY_SIZE(fec_stats);
 	default:
@@ -2738,6 +2743,7 @@ static const struct ethtool_ops fec_enet_ethtool_ops = {
 	.set_wol		= fec_enet_set_wol,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+	.self_test		= fec_selftest,
 };
 
 static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
diff --git a/drivers/net/ethernet/freescale/fec_selftests.c b/drivers/net/ethernet/freescale/fec_selftests.c
new file mode 100644
index 000000000000..788213a6454f
--- /dev/null
+++ b/drivers/net/ethernet/freescale/fec_selftests.c
@@ -0,0 +1,425 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019 Synopsys, Inc. and/or its affiliates.
+ * stmmac Selftests Support
+ *
+ * Author: Jose Abreu <joabreu@synopsys.com>
+ *
+ * Ported from stmmac to the FEC by:
+ * Copyright (C) 2021 Oleksij Rempel <o.rempel@pengutronix.de>
+ */
+
+#include <linux/phy.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+
+#include "fec.h"
+
+struct fec_packet_attrs {
+	unsigned char *src;
+	unsigned char *dst;
+	u32 ip_src;
+	u32 ip_dst;
+	int tcp;
+	int sport;
+	int dport;
+	int timeout;
+	int size;
+	int max_size;
+	u8 id;
+	u16 queue_mapping;
+};
+
+struct fec_test_priv {
+	struct fec_packet_attrs *packet;
+	struct packet_type pt;
+	struct completion comp;
+	int double_vlan;
+	int vlan_id;
+	int ok;
+};
+
+struct fechdr {
+	__be32 version;
+	__be64 magic;
+	u8 id;
+} __packed;
+
+static u8 fec_test_next_id;
+
+#define FEC_TEST_PKT_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
+			      sizeof(struct fechdr))
+#define FEC_TEST_PKT_MAGIC	0xdeadcafecafedeadULL
+#define FEC_LB_TIMEOUT	msecs_to_jiffies(200)
+
+static struct sk_buff *fec_test_get_udp_skb(struct fec_enet_private *fep,
+					       struct fec_packet_attrs *attr)
+{
+	struct sk_buff *skb = NULL;
+	struct udphdr *uhdr = NULL;
+	struct tcphdr *thdr = NULL;
+	struct fechdr *shdr;
+	struct ethhdr *ehdr;
+	struct iphdr *ihdr;
+	int iplen, size;
+
+	size = attr->size + FEC_TEST_PKT_SIZE;
+
+	if (attr->tcp)
+		size += sizeof(struct tcphdr);
+	else
+		size += sizeof(struct udphdr);
+
+	if (attr->max_size && (attr->max_size > size))
+		size = attr->max_size;
+
+	skb = netdev_alloc_skb(fep->netdev, size);
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
+	eth_zero_addr(ehdr->h_dest);
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
+	shdr->magic = cpu_to_be64(FEC_TEST_PKT_MAGIC);
+	attr->id = fec_test_next_id;
+	shdr->id = fec_test_next_id++;
+
+	if (attr->size)
+		skb_put(skb, attr->size);
+	if (attr->max_size && (attr->max_size > skb->len))
+		skb_put(skb, attr->max_size - skb->len);
+
+	skb->csum = 0;
+	skb->ip_summed = CHECKSUM_PARTIAL;
+	if (attr->tcp) {
+		thdr->check = ~tcp_v4_check(skb->len, ihdr->saddr, ihdr->daddr, 0);
+		skb->csum_start = skb_transport_header(skb) - skb->head;
+		skb->csum_offset = offsetof(struct tcphdr, check);
+	} else {
+		udp4_hwcsum(skb, ihdr->saddr, ihdr->daddr);
+	}
+
+	skb->protocol = htons(ETH_P_IP);
+	skb->pkt_type = PACKET_HOST;
+	skb->dev = fep->netdev;
+
+	return skb;
+}
+
+static int fec_test_loopback_validate(struct sk_buff *skb,
+					 struct net_device *ndev,
+					 struct packet_type *pt,
+					 struct net_device *orig_ndev)
+{
+	struct fec_test_priv *tpriv = pt->af_packet_priv;
+	unsigned char *src = tpriv->packet->src;
+	unsigned char *dst = tpriv->packet->dst;
+	struct fechdr *shdr;
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
+	if (skb_headlen(skb) < (FEC_TEST_PKT_SIZE - ETH_HLEN))
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
+		shdr = (struct fechdr *)((u8 *)thdr + sizeof(*thdr));
+	} else {
+		if (ihdr->protocol != IPPROTO_UDP)
+			goto out;
+
+		uhdr = (struct udphdr *)((u8 *)ihdr + 4 * ihdr->ihl);
+		if (uhdr->dest != htons(tpriv->packet->dport))
+			goto out;
+
+		shdr = (struct fechdr *)((u8 *)uhdr + sizeof(*uhdr));
+	}
+
+	if (shdr->magic != cpu_to_be64(FEC_TEST_PKT_MAGIC))
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
+static int __fec_test_loopback(struct fec_enet_private *fep,
+				  struct fec_packet_attrs *attr)
+{
+	struct fec_test_priv *tpriv;
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
+	tpriv->pt.func = fec_test_loopback_validate;
+	tpriv->pt.dev = fep->netdev;
+	tpriv->pt.af_packet_priv = tpriv;
+	tpriv->packet = attr;
+
+	skb = fec_test_get_udp_skb(fep, attr);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	ret = dev_direct_xmit(skb, attr->queue_mapping);
+	if (ret)
+		goto cleanup;
+
+	if (!attr->timeout)
+		attr->timeout = FEC_LB_TIMEOUT;
+
+	wait_for_completion_timeout(&tpriv->comp, attr->timeout);
+	ret = tpriv->ok ? 0 : -ETIMEDOUT;
+
+cleanup:
+	kfree(tpriv);
+	return ret;
+}
+
+static int fec_test_mac_loopback(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct fec_packet_attrs attr = { };
+
+	attr.dst = ndev->dev_addr;
+	return __fec_test_loopback(fep, &attr);
+}
+
+static int fec_test_phy_loopback(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct fec_packet_attrs attr = { };
+
+	attr.dst = ndev->dev_addr;
+	return __fec_test_loopback(fep, &attr);
+}
+
+static int fec_test_tcp(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct fec_packet_attrs attr = { };
+
+	attr.dst = ndev->dev_addr;
+	attr.tcp = true;
+	return __fec_test_loopback(fep, &attr);
+}
+
+#define FEC_LOOPBACK_MAC 0
+#define FEC_LOOPBACK_PHY 1
+
+static const struct fec_test {
+	char name[ETH_GSTRING_LEN];
+	int lb;
+	int (*fn)(struct net_device *ndev);
+} fec_selftests[] = {
+	{
+		.name = "MAC Loopback, UDP          ",
+		.lb = FEC_LOOPBACK_MAC,
+		.fn = fec_test_mac_loopback,
+	}, {
+		.name = "PHY Loopback, UDP          ",
+		.lb = FEC_LOOPBACK_PHY,
+		.fn = fec_test_phy_loopback,
+	}, {
+		.name = "PHY Loopback, TCP          ",
+		.lb = FEC_LOOPBACK_PHY,
+		.fn = fec_test_tcp,
+	},
+};
+
+void fec_selftest(struct net_device *ndev,
+			   struct ethtool_test *etest, u64 *buf)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	int count = fec_selftest_get_count();
+	u32 tmp, r_cntrl;
+	int i, ret;
+
+	memset(buf, 0, sizeof(*buf) * count);
+	fec_test_next_id = 0;
+
+	if (etest->flags != ETH_TEST_FL_OFFLINE) {
+		netdev_err(ndev, "Only offline tests are supported\n");
+		etest->flags |= ETH_TEST_FL_FAILED;
+		return;
+	} else if (!netif_carrier_ok(ndev)) {
+		netdev_err(ndev, "You need valid Link to execute tests\n");
+		etest->flags |= ETH_TEST_FL_FAILED;
+		return;
+	}
+
+	/* Wait for queues drain */
+	msleep(200);
+	for (i = 0; i < count; i++) {
+		ret = 0;
+
+
+		switch (fec_selftests[i].lb) {
+		case FEC_LOOPBACK_PHY:
+			ret = -EOPNOTSUPP;
+			if (ndev->phydev)
+				ret = phy_loopback(ndev->phydev, true);
+			if (!ret)
+				break;
+			fallthrough;
+		case FEC_LOOPBACK_MAC:
+			/* disable half duplex if present and enable MAC loop back  */
+			r_cntrl = readl(fep->hwp + FEC_R_CNTRL);
+			tmp = FEC_ENET_LOOP | (r_cntrl & ~FEC_ENET_DRT);
+			writel(tmp, fep->hwp + FEC_R_CNTRL);
+			break;
+		default:
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		/*
+		 * First tests will always be MAC / PHY loobpack. If any of
+		 * them is not supported we abort earlier.
+		 */
+		if (ret) {
+			netdev_err(ndev, "Loopback is not supported\n");
+			etest->flags |= ETH_TEST_FL_FAILED;
+			break;
+		}
+
+		ret = fec_selftests[i].fn(ndev);
+		if (ret && (ret != -EOPNOTSUPP))
+			etest->flags |= ETH_TEST_FL_FAILED;
+		buf[i] = ret;
+
+		switch (fec_selftests[i].lb) {
+		case FEC_LOOPBACK_PHY:
+			ret = -EOPNOTSUPP;
+			if (ndev->phydev)
+				ret = phy_loopback(ndev->phydev, false);
+			if (!ret)
+				break;
+			fallthrough;
+		case FEC_LOOPBACK_MAC:
+			writel(r_cntrl, fep->hwp + FEC_R_CNTRL);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+int fec_selftest_get_count(void)
+{
+	return ARRAY_SIZE(fec_selftests);
+}
+
+void fec_selftest_get_strings(u8 *data)
+{
+	u8 *p = data;
+	int i;
+
+	for (i = 0; i < fec_selftest_get_count(); i++) {
+		snprintf(p, ETH_GSTRING_LEN, "%2d. %s", i + 1,
+			 fec_selftests[i].name);
+		p += ETH_GSTRING_LEN;
+	}
+}
+
+
-- 
2.29.2

