Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF008172DF
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfEHHv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:51:59 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:56542 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbfEHHva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 03:51:30 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 41F4AC00F5;
        Wed,  8 May 2019 07:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557301893; bh=btpUZFvHO9ysQIPJjUWlkv+3u5lyFdbQGpZR+oveb1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=I8hG0tibMd8Ocfh4NQ/3lV8npY9jHYVffEUno8qpGzuyvCcFaRQeBRqSssBDdWEB+
         N+vkVg0U2XNZtOmehjUlML3EdSmScnuOI0pP43Fxvvfplvvs2kTB3iIoy57TagB25r
         4NGFJu/CYgb/Rk7T1JOOUiS/KBbZEeb3uGxREFdWRQig6Jg0uiyD8Kdt5I2TUmisaE
         QLprodY4Zhzd5Kdm28S7soBRV+I4AXyAaZEaEUlEAgknQ9tUNQAtnYFs4r3VOPvfoA
         XdqbWrp1UbdRC0HscMH8F1ono5dL/SCZZY9wRKcblH8tDqb9Bca523AWH+nU5B79KT
         K2TaAxfRXVvzQ==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 789FFA02DF;
        Wed,  8 May 2019 07:51:29 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 0B3BE3D535;
        Wed,  8 May 2019 09:51:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 10/11] net: stmmac: Introduce selftests support
Date:   Wed,  8 May 2019 09:51:10 +0200
Message-Id: <be9099bbf8783b210dc9034a8b82219984f03250.1557300602.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1557300602.git.joabreu@synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
In-Reply-To: <cover.1557300602.git.joabreu@synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We add support for selftests on stmmac driver with 4 basic sanity checks
for now:
	- MAC Loopback
	- PHY Loopback
	- MMC Counters
	- EEE
	- Hash Filter Multicast
	- Perfect Filter Unicast
	- Flow Control

This allows for fast tracking of regressions in the driver and helps in
spotting mis-configuration of HW.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   9 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  22 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   6 +
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 743 +++++++++++++++++++++
 5 files changed, 782 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index f194235153f9..fd0bb87a41ee 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -12,6 +12,15 @@ config STMMAC_ETH
 
 if STMMAC_ETH
 
+config STMMAC_SELFTESTS
+	bool "Support for STMMAC Selftests"
+	depends on STMMAC_ETH
+	default n
+	---help---
+	  This adds support for STMMAC Selftests using ethtool. Enable this
+	  feature if you are facing problems with your HW and submit the test
+	  results to the netdev Mailing List.
+
 config STMMAC_PLATFORM
 	tristate "STMMAC Platform bus support"
 	depends on STMMAC_ETH
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index c529c21e9bdd..c59926d96bcc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -8,6 +8,8 @@ stmmac-objs:= stmmac_main.o stmmac_ethtool.o stmmac_mdio.o ring_mode.o	\
 	      stmmac_tc.o dwxgmac2_core.o dwxgmac2_dma.o dwxgmac2_descs.o \
 	      $(stmmac-y)
 
+stmmac-$(CONFIG_STMMAC_SELFTESTS) += stmmac_selftests.o
+
 # Ordering matters. Generic driver must be last.
 obj-$(CONFIG_STMMAC_PLATFORM)	+= stmmac-platform.o
 obj-$(CONFIG_DWMAC_ANARION)	+= dwmac-anarion.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index dd95d959c1ce..a16ada8b8507 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -229,4 +229,26 @@ int stmmac_dvr_probe(struct device *device,
 void stmmac_disable_eee_mode(struct stmmac_priv *priv);
 bool stmmac_eee_init(struct stmmac_priv *priv);
 
+#if IS_ENABLED(CONFIG_STMMAC_SELFTESTS)
+void stmmac_selftest_run(struct net_device *dev,
+			 struct ethtool_test *etest, u64 *buf);
+void stmmac_selftest_get_strings(struct stmmac_priv *priv, u8 *data);
+int stmmac_selftest_get_count(struct stmmac_priv *priv);
+#else
+static inline void stmmac_selftest_run(struct net_device *dev,
+				       struct ethtool_test *etest, u64 *buf)
+{
+	/* Not enabled */
+}
+static inline void stmmac_selftest_get_strings(struct stmmac_priv *priv,
+					       u8 *data)
+{
+	/* Not enabled */
+}
+static inline int stmmac_selftest_get_count(struct stmmac_priv *priv)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_STMMAC_SELFTESTS */
+
 #endif /* __STMMAC_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index b9f29df7e98a..19ffb4fa90a8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -589,6 +589,8 @@ static int stmmac_get_sset_count(struct net_device *netdev, int sset)
 		}
 
 		return len;
+	case ETH_SS_TEST:
+		return stmmac_selftest_get_count(priv);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -625,6 +627,9 @@ static void stmmac_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 			p += ETH_GSTRING_LEN;
 		}
 		break;
+	case ETH_SS_TEST:
+		stmmac_selftest_get_strings(priv, p);
+		break;
 	default:
 		WARN_ON(1);
 		break;
@@ -890,6 +895,7 @@ static const struct ethtool_ops stmmac_ethtool_ops = {
 	.nway_reset = phy_ethtool_nway_reset,
 	.get_pauseparam = stmmac_get_pauseparam,
 	.set_pauseparam = stmmac_set_pauseparam,
+	.self_test = stmmac_selftest_run,
 	.get_ethtool_stats = stmmac_get_ethtool_stats,
 	.get_strings = stmmac_get_strings,
 	.get_wol = stmmac_get_wol,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
new file mode 100644
index 000000000000..66e2d842864e
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -0,0 +1,743 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019 Synopsys, Inc. and/or its affiliates.
+ * stmmac Selftests Support
+ *
+ * Author: Jose Abreu <joabreu@synopsys.com>
+ */
+
+#include <linux/completion.h>
+#include <linux/ethtool.h>
+#include <linux/ip.h>
+#include <linux/phy.h>
+#include <linux/udp.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+#include "stmmac.h"
+
+struct stmmachdr {
+	__be32 version;
+	__be64 magic;
+	u8 id;
+} __packed;
+
+#define STMMAC_TEST_PKT_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
+			      sizeof(struct stmmachdr))
+#define STMMAC_TEST_PKT_MAGIC	0xdeadcafecafedeadULL
+#define STMMAC_LB_TIMEOUT	msecs_to_jiffies(200)
+
+struct stmmac_packet_attrs {
+	int vlan;
+	int vlan_id_in;
+	int vlan_id_out;
+	unsigned char *src;
+	unsigned char *dst;
+	u32 ip_src;
+	u32 ip_dst;
+	int tcp;
+	int sport;
+	int dport;
+	u32 exp_hash;
+	int dont_wait;
+	int timeout;
+	int size;
+	int remove_sa;
+	u8 id;
+};
+
+static u8 stmmac_test_next_id;
+
+static struct sk_buff *stmmac_test_get_udp_skb(struct stmmac_priv *priv,
+					       struct stmmac_packet_attrs *attr)
+{
+	struct sk_buff *skb = NULL;
+	struct udphdr *uhdr = NULL;
+	struct tcphdr *thdr = NULL;
+	struct stmmachdr *shdr;
+	struct ethhdr *ehdr;
+	struct iphdr *ihdr;
+	int iplen, size;
+
+	size = attr->size + STMMAC_TEST_PKT_SIZE;
+	if (attr->vlan) {
+		size += 4;
+		if (attr->vlan > 1)
+			size += 4;
+	}
+
+	if (attr->tcp)
+		size += sizeof(struct tcphdr);
+	else
+		size += sizeof(struct udphdr);
+
+	skb = netdev_alloc_skb(priv->dev, size);
+	if (!skb)
+		return NULL;
+
+	prefetchw(skb->data);
+	skb_reserve(skb, NET_IP_ALIGN);
+
+	if (attr->vlan > 1)
+		ehdr = skb_push(skb, ETH_HLEN + 8);
+	else if (attr->vlan)
+		ehdr = skb_push(skb, ETH_HLEN + 4);
+	else if (attr->remove_sa)
+		ehdr = skb_push(skb, ETH_HLEN - 6);
+	else
+		ehdr = skb_push(skb, ETH_HLEN);
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
+	if (!attr->remove_sa)
+		eth_zero_addr(ehdr->h_source);
+	eth_zero_addr(ehdr->h_dest);
+	if (attr->src && !attr->remove_sa)
+		ether_addr_copy(ehdr->h_source, attr->src);
+	if (attr->dst)
+		ether_addr_copy(ehdr->h_dest, attr->dst);
+
+	if (!attr->remove_sa) {
+		ehdr->h_proto = htons(ETH_P_IP);
+	} else {
+		__be16 *ptr = (__be16 *)ehdr;
+
+		/* HACK */
+		ptr[3] = htons(ETH_P_IP);
+	}
+
+	if (attr->vlan) {
+		u16 *tag, *proto;
+
+		if (!attr->remove_sa) {
+			tag = (void *)ehdr + ETH_HLEN;
+			proto = (void *)ehdr + (2 * ETH_ALEN);
+		} else {
+			tag = (void *)ehdr + ETH_HLEN - 6;
+			proto = (void *)ehdr + ETH_ALEN;
+		}
+
+		proto[0] = htons(ETH_P_8021Q);
+		tag[0] = htons(attr->vlan_id_out);
+		tag[1] = htons(ETH_P_IP);
+		if (attr->vlan > 1) {
+			proto[0] = htons(ETH_P_8021AD);
+			tag[1] = htons(ETH_P_8021Q);
+			tag[2] = htons(attr->vlan_id_in);
+			tag[3] = htons(ETH_P_IP);
+		}
+	}
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
+	ihdr->tot_len = htons(iplen);
+	ihdr->frag_off = 0;
+	ihdr->saddr = 0;
+	ihdr->daddr = htonl(attr->ip_dst);
+	ihdr->tos = 0;
+	ihdr->id = 0;
+	ip_send_check(ihdr);
+
+	shdr = skb_put(skb, sizeof(*shdr));
+	shdr->version = 0;
+	shdr->magic = cpu_to_be64(STMMAC_TEST_PKT_MAGIC);
+	attr->id = stmmac_test_next_id;
+	shdr->id = stmmac_test_next_id++;
+
+	if (attr->size)
+		skb_put(skb, attr->size);
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
+	skb->dev = priv->dev;
+
+	return skb;
+}
+
+struct stmmac_test_priv {
+	struct stmmac_packet_attrs *packet;
+	struct packet_type pt;
+	struct completion comp;
+	int double_vlan;
+	int vlan_id;
+	int ok;
+};
+
+static int stmmac_test_loopback_validate(struct sk_buff *skb,
+					 struct net_device *ndev,
+					 struct packet_type *pt,
+					 struct net_device *orig_ndev)
+{
+	struct stmmac_test_priv *tpriv = pt->af_packet_priv;
+	struct stmmachdr *shdr;
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
+	if (skb_headlen(skb) < (STMMAC_TEST_PKT_SIZE - ETH_HLEN))
+		goto out;
+
+	ehdr = (struct ethhdr *)skb_mac_header(skb);
+	if (tpriv->packet->dst) {
+		if (!ether_addr_equal(ehdr->h_dest, tpriv->packet->dst))
+			goto out;
+	}
+	if (tpriv->packet->src) {
+		if (!ether_addr_equal(ehdr->h_source, orig_ndev->dev_addr))
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
+		shdr = (struct stmmachdr *)((u8 *)thdr + sizeof(*thdr));
+	} else {
+		if (ihdr->protocol != IPPROTO_UDP)
+			goto out;
+
+		uhdr = (struct udphdr *)((u8 *)ihdr + 4 * ihdr->ihl);
+		if (uhdr->dest != htons(tpriv->packet->dport))
+			goto out;
+
+		shdr = (struct stmmachdr *)((u8 *)uhdr + sizeof(*uhdr));
+	}
+
+	if (shdr->magic != cpu_to_be64(STMMAC_TEST_PKT_MAGIC))
+		goto out;
+	if (tpriv->packet->exp_hash && !skb->hash)
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
+static int __stmmac_test_loopback(struct stmmac_priv *priv,
+				  struct stmmac_packet_attrs *attr)
+{
+	struct stmmac_test_priv *tpriv;
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
+	tpriv->pt.func = stmmac_test_loopback_validate;
+	tpriv->pt.dev = priv->dev;
+	tpriv->pt.af_packet_priv = tpriv;
+	tpriv->packet = attr;
+	dev_add_pack(&tpriv->pt);
+
+	skb = stmmac_test_get_udp_skb(priv, attr);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	skb_set_queue_mapping(skb, 0);
+	ret = dev_queue_xmit(skb);
+	if (ret)
+		goto cleanup;
+
+	if (attr->dont_wait)
+		goto cleanup;
+
+	if (!attr->timeout)
+		attr->timeout = STMMAC_LB_TIMEOUT;
+
+	wait_for_completion_timeout(&tpriv->comp, attr->timeout);
+	ret = !tpriv->ok;
+
+cleanup:
+	dev_remove_pack(&tpriv->pt);
+	kfree(tpriv);
+	return ret;
+}
+
+static int stmmac_test_loopback(struct stmmac_priv *priv)
+{
+	struct stmmac_packet_attrs attr = { };
+
+	attr.dst = priv->dev->dev_addr;
+	return __stmmac_test_loopback(priv, &attr);
+}
+
+static int stmmac_test_phy_loopback(struct stmmac_priv *priv)
+{
+	int ret;
+
+	if (!priv->dev->phydev)
+		return -EBUSY;
+
+	ret = phy_loopback(priv->dev->phydev, true);
+	if (ret)
+		return ret;
+
+	return stmmac_test_loopback(priv);
+}
+
+static int stmmac_test_mmc(struct stmmac_priv *priv)
+{
+	struct stmmac_counters initial, final;
+	int ret;
+
+	memset(&initial, 0, sizeof(initial));
+	memset(&final, 0, sizeof(final));
+
+	if (!priv->dma_cap.rmon)
+		return -EOPNOTSUPP;
+
+	/* Save previous results into internal struct */
+	stmmac_mmc_read(priv, priv->mmcaddr, &priv->mmc);
+
+	ret = stmmac_test_loopback(priv);
+	if (ret)
+		return ret;
+
+	/* These will be loopback results so no need to save them */
+	stmmac_mmc_read(priv, priv->mmcaddr, &final);
+
+	if (final.mmc_tx_64_octets_gb <= initial.mmc_tx_64_octets_gb)
+		return -1;
+	if (final.mmc_tx_octetcount_gb <= initial.mmc_tx_octetcount_gb)
+		return -1;
+	if (final.mmc_tx_framecount_gb <= initial.mmc_tx_framecount_gb)
+		return -1;
+	if (final.mmc_tx_octetcount_g <= initial.mmc_tx_octetcount_g)
+		return -1;
+	if (final.mmc_tx_framecount_g <= initial.mmc_tx_framecount_g)
+		return -1;
+	if (final.mmc_rx_64_octets_gb <= initial.mmc_rx_64_octets_gb)
+		return -1;
+	if (final.mmc_rx_octetcount_gb <= initial.mmc_rx_octetcount_gb)
+		return -1;
+	if (final.mmc_rx_framecount_gb <= initial.mmc_rx_framecount_gb)
+		return -1;
+	if (final.mmc_rx_octetcount_g <= initial.mmc_rx_octetcount_g)
+		return -1;
+
+	return 0;
+}
+
+static int stmmac_test_eee(struct stmmac_priv *priv)
+{
+	struct stmmac_extra_stats *initial, *final;
+	int timeout = 100;
+	int ret;
+
+	if (!priv->dma_cap.eee || !priv->eee_active)
+		return -EOPNOTSUPP;
+
+	initial = kzalloc(sizeof(*initial), GFP_KERNEL);
+	if (!initial)
+		return -ENOMEM;
+
+	final = kzalloc(sizeof(*final), GFP_KERNEL);
+	if (!final) {
+		ret = -ENOMEM;
+		goto out_free_initial;
+	}
+
+	memcpy(initial, &priv->xstats, sizeof(*initial));
+
+	ret = stmmac_test_loopback(priv);
+	if (ret)
+		goto out_free_final;
+
+	/* We have no traffic in the line so, sooner or later it will go LPI */
+	while (--timeout) {
+		memcpy(final, &priv->xstats, sizeof(*final));
+
+		if (final->irq_tx_path_in_lpi_mode_n >
+		    initial->irq_tx_path_in_lpi_mode_n)
+			break;
+		msleep(100);
+	}
+
+	if (!timeout) {
+		ret = -ETIMEDOUT;
+		goto out_free_final;
+	}
+
+	if (final->irq_tx_path_in_lpi_mode_n <=
+	    initial->irq_tx_path_in_lpi_mode_n) {
+		ret = -EINVAL;
+		goto out_free_final;
+	}
+
+	if (final->irq_tx_path_exit_lpi_mode_n <=
+	    initial->irq_tx_path_exit_lpi_mode_n) {
+		ret = -EINVAL;
+		goto out_free_final;
+	}
+
+out_free_final:
+	kfree(final);
+out_free_initial:
+	kfree(initial);
+	return ret;
+}
+
+static int stmmac_filter_check(struct stmmac_priv *priv)
+{
+	if (!(priv->dev->flags & IFF_PROMISC))
+		return 0;
+
+	netdev_warn(priv->dev, "Test can't be run in promiscuous mode!\n");
+	return 1;
+}
+
+static int stmmac_test_hfilt(struct stmmac_priv *priv)
+{
+	unsigned char gd_addr[ETH_ALEN] = {0x01, 0x0c, 0xcd, 0x04, 0x00, 0x00};
+	unsigned char bd_addr[ETH_ALEN] = {0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b};
+	struct stmmac_packet_attrs attr = { };
+	int ret;
+
+	if (stmmac_filter_check(priv))
+		return -EOPNOTSUPP;
+
+	ret = dev_mc_add(priv->dev, gd_addr);
+	if (ret)
+		return ret;
+
+	attr.dst = gd_addr;
+
+	/* Shall receive packet */
+	ret = __stmmac_test_loopback(priv, &attr);
+	if (ret)
+		goto cleanup;
+
+	attr.dst = bd_addr;
+
+	/* Shall NOT receive packet */
+	ret = __stmmac_test_loopback(priv, &attr);
+	ret = !ret;
+
+cleanup:
+	dev_mc_del(priv->dev, gd_addr);
+	return ret;
+}
+
+static int stmmac_test_pfilt(struct stmmac_priv *priv)
+{
+	unsigned char gd_addr[ETH_ALEN] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06};
+	unsigned char bd_addr[ETH_ALEN] = {0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b};
+	struct stmmac_packet_attrs attr = { };
+	int ret;
+
+	if (stmmac_filter_check(priv))
+		return -EOPNOTSUPP;
+
+	ret = dev_uc_add(priv->dev, gd_addr);
+	if (ret)
+		return ret;
+
+	attr.dst = gd_addr;
+
+	/* Shall receive packet */
+	ret = __stmmac_test_loopback(priv, &attr);
+	if (ret)
+		goto cleanup;
+
+	attr.dst = bd_addr;
+
+	/* Shall NOT receive packet */
+	ret = __stmmac_test_loopback(priv, &attr);
+	ret = !ret;
+
+cleanup:
+	dev_uc_del(priv->dev, gd_addr);
+	return ret;
+}
+
+static int stmmac_test_flowctrl_validate(struct sk_buff *skb,
+					 struct net_device *ndev,
+					 struct packet_type *pt,
+					 struct net_device *orig_ndev)
+{
+	struct stmmac_test_priv *tpriv = pt->af_packet_priv;
+	struct ethhdr *ehdr;
+
+	ehdr = (struct ethhdr *)skb_mac_header(skb);
+	if (!ether_addr_equal(ehdr->h_source, orig_ndev->dev_addr))
+		goto out;
+	if (ehdr->h_proto != htons(ETH_P_PAUSE))
+		goto out;
+
+	tpriv->ok = true;
+	complete(&tpriv->comp);
+out:
+	kfree(skb);
+	return 0;
+}
+
+static int stmmac_test_flowctrl(struct stmmac_priv *priv)
+{
+	unsigned char paddr[ETH_ALEN] = {0x01, 0x80, 0xC2, 0x00, 0x00, 0x01};
+	struct phy_device *phydev = priv->dev->phydev;
+	u32 rx_cnt = priv->plat->rx_queues_to_use;
+	struct stmmac_test_priv *tpriv;
+	unsigned int pkt_count;
+	int i, ret = 0;
+
+	if (!phydev || !phydev->pause)
+		return -EOPNOTSUPP;
+
+	tpriv = kzalloc(sizeof(*tpriv), GFP_KERNEL);
+	if (!tpriv)
+		return -ENOMEM;
+
+	tpriv->ok = false;
+	init_completion(&tpriv->comp);
+	tpriv->pt.type = htons(ETH_P_PAUSE);
+	tpriv->pt.func = stmmac_test_flowctrl_validate;
+	tpriv->pt.dev = priv->dev;
+	tpriv->pt.af_packet_priv = tpriv;
+	dev_add_pack(&tpriv->pt);
+
+	/* Compute minimum number of packets to make FIFO full */
+	pkt_count = priv->plat->rx_fifo_size;
+	if (!pkt_count)
+		pkt_count = priv->dma_cap.rx_fifo_size;
+	pkt_count /= 1400;
+	pkt_count *= 2;
+
+	for (i = 0; i < rx_cnt; i++)
+		stmmac_stop_rx(priv, priv->ioaddr, i);
+
+	ret = dev_set_promiscuity(priv->dev, 1);
+	if (ret)
+		goto cleanup;
+
+	ret = dev_mc_add(priv->dev, paddr);
+	if (ret)
+		goto cleanup;
+
+	for (i = 0; i < pkt_count; i++) {
+		struct stmmac_packet_attrs attr = { };
+
+		attr.dst = priv->dev->dev_addr;
+		attr.dont_wait = true;
+		attr.size = 1400;
+
+		ret = __stmmac_test_loopback(priv, &attr);
+		if (ret)
+			goto cleanup;
+		if (tpriv->ok)
+			break;
+	}
+
+	/* Wait for some time in case RX Watchdog is enabled */
+	msleep(200);
+
+	for (i = 0; i < rx_cnt; i++) {
+		struct stmmac_channel *ch = &priv->channel[i];
+
+		stmmac_start_rx(priv, priv->ioaddr, i);
+		napi_schedule(&ch->rx_napi);
+	}
+
+	wait_for_completion_timeout(&tpriv->comp, STMMAC_LB_TIMEOUT);
+	ret = !tpriv->ok;
+
+cleanup:
+	dev_mc_del(priv->dev, paddr);
+	dev_set_promiscuity(priv->dev, -1);
+	dev_remove_pack(&tpriv->pt);
+	kfree(tpriv);
+	return ret;
+}
+
+#define STMMAC_LOOPBACK_NONE	0
+#define STMMAC_LOOPBACK_MAC	1
+#define STMMAC_LOOPBACK_PHY	2
+
+static const struct stmmac_test {
+	char name[ETH_GSTRING_LEN];
+	int lb;
+	int (*fn)(struct stmmac_priv *priv);
+} stmmac_selftests[] = {
+	{
+		.name = "MAC Loopback         ",
+		.lb = STMMAC_LOOPBACK_MAC,
+		.fn = stmmac_test_loopback,
+	}, {
+		.name = "PHY Loopback         ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_phy_loopback,
+	}, {
+		.name = "MMC Counters         ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_mmc,
+	}, {
+		.name = "EEE                  ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_eee,
+	}, {
+		.name = "Hash Filter MC       ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_hfilt,
+	}, {
+		.name = "Perfect Filter UC    ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_pfilt,
+	}, {
+		.name = "Flow Control         ",
+		.lb = STMMAC_LOOPBACK_PHY,
+		.fn = stmmac_test_flowctrl,
+	},
+};
+
+void stmmac_selftest_run(struct net_device *dev,
+			 struct ethtool_test *etest, u64 *buf)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	int count = stmmac_selftest_get_count(priv);
+	int carrier = netif_carrier_ok(dev);
+	int i, ret;
+
+	memset(buf, 0, sizeof(*buf) * count);
+	stmmac_test_next_id = 0;
+
+	/* We don't want extra traffic */
+	netif_carrier_off(dev);
+
+	/* Wait for queues drain */
+	msleep(200);
+
+	for (i = 0; i < count; i++) {
+		ret = 0;
+
+		switch (stmmac_selftests[i].lb) {
+		case STMMAC_LOOPBACK_PHY:
+			ret = -EOPNOTSUPP;
+			if (dev->phydev)
+				ret = phy_loopback(dev->phydev, true);
+			if (!ret)
+				break;
+			/* Fallthrough */
+		case STMMAC_LOOPBACK_MAC:
+			ret = stmmac_set_mac_loopback(priv, priv->ioaddr, true);
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
+			netdev_err(priv->dev, "Loopback is not supported\n");
+			etest->flags |= ETH_TEST_FL_FAILED;
+			break;
+		}
+
+		ret = stmmac_selftests[i].fn(priv);
+		if (ret && (ret != -EOPNOTSUPP))
+			etest->flags |= ETH_TEST_FL_FAILED;
+		buf[i] = ret;
+
+		switch (stmmac_selftests[i].lb) {
+		case STMMAC_LOOPBACK_PHY:
+			ret = -EOPNOTSUPP;
+			if (dev->phydev)
+				ret = phy_loopback(dev->phydev, false);
+			if (!ret)
+				break;
+			/* Fallthrough */
+		case STMMAC_LOOPBACK_MAC:
+			stmmac_set_mac_loopback(priv, priv->ioaddr, false);
+			break;
+		default:
+			break;
+		}
+	}
+
+	/* Restart everything */
+	if (carrier)
+		netif_carrier_on(dev);
+}
+
+void stmmac_selftest_get_strings(struct stmmac_priv *priv, u8 *data)
+{
+	u8 *p = data;
+	int i;
+
+	for (i = 0; i < stmmac_selftest_get_count(priv); i++) {
+		snprintf(p, ETH_GSTRING_LEN, "%2d. %s", i + 1,
+			 stmmac_selftests[i].name);
+		p += ETH_GSTRING_LEN;
+	}
+}
+
+int stmmac_selftest_get_count(struct stmmac_priv *priv)
+{
+	return ARRAY_SIZE(stmmac_selftests);
+}
-- 
2.7.4

