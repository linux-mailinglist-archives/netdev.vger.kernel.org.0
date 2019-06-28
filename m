Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9383959D50
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfF1N4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:56:11 -0400
Received: from packetmixer.de ([79.140.42.25]:53012 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfF1N4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:56:10 -0400
Received: from kero.packetmixer.de (p4FD57BD9.dip0.t-ipconnect.de [79.213.123.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id C131862073;
        Fri, 28 Jun 2019 15:56:07 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 06/10] batman-adv: mcast: collect softif listeners from IP lists instead
Date:   Fri, 28 Jun 2019 15:56:00 +0200
Message-Id: <20190628135604.11581-7-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190628135604.11581-1-sw@simonwunderlich.de>
References: <20190628135604.11581-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

Instead of collecting multicast MAC addresses from the netdev hw mc
list collect a node's multicast listeners from the IP lists and convert
those to MAC addresses.

This allows to exclude addresses of specific scope later. On a
multicast MAC address the IP destination scope is not visible anymore.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/multicast.c | 192 +++++++++++++++++++++++++++++++++------------
 1 file changed, 143 insertions(+), 49 deletions(-)

diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index af0e2ce8d38e..ca9e2e67bdc6 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -20,6 +20,7 @@
 #include <linux/igmp.h>
 #include <linux/in.h>
 #include <linux/in6.h>
+#include <linux/inetdevice.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/jiffies.h>
@@ -172,70 +173,129 @@ static struct net_device *batadv_mcast_get_bridge(struct net_device *soft_iface)
 }
 
 /**
- * batadv_mcast_addr_is_ipv4() - check if multicast MAC is IPv4
- * @addr: the MAC address to check
+ * batadv_mcast_mla_is_duplicate() - check whether an address is in a list
+ * @mcast_addr: the multicast address to check
+ * @mcast_list: the list with multicast addresses to search in
  *
- * Return: True, if MAC address is one reserved for IPv4 multicast, false
- * otherwise.
+ * Return: true if the given address is already in the given list.
+ * Otherwise returns false.
  */
-static bool batadv_mcast_addr_is_ipv4(const u8 *addr)
+static bool batadv_mcast_mla_is_duplicate(u8 *mcast_addr,
+					  struct hlist_head *mcast_list)
 {
-	static const u8 prefix[] = {0x01, 0x00, 0x5E};
+	struct batadv_hw_addr *mcast_entry;
 
-	return memcmp(prefix, addr, sizeof(prefix)) == 0;
+	hlist_for_each_entry(mcast_entry, mcast_list, list)
+		if (batadv_compare_eth(mcast_entry->addr, mcast_addr))
+			return true;
+
+	return false;
 }
 
 /**
- * batadv_mcast_addr_is_ipv6() - check if multicast MAC is IPv6
- * @addr: the MAC address to check
+ * batadv_mcast_mla_softif_get_ipv4() - get softif IPv4 multicast listeners
+ * @dev: the device to collect multicast addresses from
+ * @mcast_list: a list to put found addresses into
+ * @flags: flags indicating the new multicast state
  *
- * Return: True, if MAC address is one reserved for IPv6 multicast, false
- * otherwise.
+ * Collects multicast addresses of IPv4 multicast listeners residing
+ * on this kernel on the given soft interface, dev, in
+ * the given mcast_list. In general, multicast listeners provided by
+ * your multicast receiving applications run directly on this node.
+ *
+ * Return: -ENOMEM on memory allocation error or the number of
+ * items added to the mcast_list otherwise.
  */
-static bool batadv_mcast_addr_is_ipv6(const u8 *addr)
+static int
+batadv_mcast_mla_softif_get_ipv4(struct net_device *dev,
+				 struct hlist_head *mcast_list,
+				 struct batadv_mcast_mla_flags *flags)
 {
-	static const u8 prefix[] = {0x33, 0x33};
+	struct batadv_hw_addr *new;
+	struct in_device *in_dev;
+	u8 mcast_addr[ETH_ALEN];
+	struct ip_mc_list *pmc;
+	int ret = 0;
+
+	if (flags->tvlv_flags & BATADV_MCAST_WANT_ALL_IPV4)
+		return 0;
+
+	rcu_read_lock();
 
-	return memcmp(prefix, addr, sizeof(prefix)) == 0;
+	in_dev = __in_dev_get_rcu(dev);
+	if (!in_dev) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	for (pmc = rcu_dereference(in_dev->mc_list); pmc;
+	     pmc = rcu_dereference(pmc->next_rcu)) {
+		ip_eth_mc_map(pmc->multiaddr, mcast_addr);
+
+		if (batadv_mcast_mla_is_duplicate(mcast_addr, mcast_list))
+			continue;
+
+		new = kmalloc(sizeof(*new), GFP_ATOMIC);
+		if (!new) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		ether_addr_copy(new->addr, mcast_addr);
+		hlist_add_head(&new->list, mcast_list);
+		ret++;
+	}
+	rcu_read_unlock();
+
+	return ret;
 }
 
 /**
- * batadv_mcast_mla_softif_get() - get softif multicast listeners
+ * batadv_mcast_mla_softif_get_ipv6() - get softif IPv6 multicast listeners
  * @dev: the device to collect multicast addresses from
  * @mcast_list: a list to put found addresses into
  * @flags: flags indicating the new multicast state
  *
- * Collects multicast addresses of multicast listeners residing
+ * Collects multicast addresses of IPv6 multicast listeners residing
  * on this kernel on the given soft interface, dev, in
  * the given mcast_list. In general, multicast listeners provided by
  * your multicast receiving applications run directly on this node.
  *
- * If there is a bridge interface on top of dev, collects from that one
- * instead. Just like with IP addresses and routes, multicast listeners
- * will(/should) register to the bridge interface instead of an
- * enslaved bat0.
- *
  * Return: -ENOMEM on memory allocation error or the number of
  * items added to the mcast_list otherwise.
  */
+#if IS_ENABLED(CONFIG_IPV6)
 static int
-batadv_mcast_mla_softif_get(struct net_device *dev,
-			    struct hlist_head *mcast_list,
-			    struct batadv_mcast_mla_flags *flags)
+batadv_mcast_mla_softif_get_ipv6(struct net_device *dev,
+				 struct hlist_head *mcast_list,
+				 struct batadv_mcast_mla_flags *flags)
 {
-	bool all_ipv4 = flags->tvlv_flags & BATADV_MCAST_WANT_ALL_IPV4;
-	bool all_ipv6 = flags->tvlv_flags & BATADV_MCAST_WANT_ALL_IPV6;
-	struct net_device *bridge = batadv_mcast_get_bridge(dev);
-	struct netdev_hw_addr *mc_list_entry;
 	struct batadv_hw_addr *new;
+	struct inet6_dev *in6_dev;
+	u8 mcast_addr[ETH_ALEN];
+	struct ifmcaddr6 *pmc6;
 	int ret = 0;
 
-	netif_addr_lock_bh(bridge ? bridge : dev);
-	netdev_for_each_mc_addr(mc_list_entry, bridge ? bridge : dev) {
-		if (all_ipv4 && batadv_mcast_addr_is_ipv4(mc_list_entry->addr))
+	if (flags->tvlv_flags & BATADV_MCAST_WANT_ALL_IPV6)
+		return 0;
+
+	rcu_read_lock();
+
+	in6_dev = __in6_dev_get(dev);
+	if (!in6_dev) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	read_lock_bh(&in6_dev->lock);
+	for (pmc6 = in6_dev->mc_list; pmc6; pmc6 = pmc6->next) {
+		if (IPV6_ADDR_MC_SCOPE(&pmc6->mca_addr) <
+		    IPV6_ADDR_SCOPE_LINKLOCAL)
 			continue;
 
-		if (all_ipv6 && batadv_mcast_addr_is_ipv6(mc_list_entry->addr))
+		ipv6_eth_mc_map(&pmc6->mca_addr, mcast_addr);
+
+		if (batadv_mcast_mla_is_duplicate(mcast_addr, mcast_list))
 			continue;
 
 		new = kmalloc(sizeof(*new), GFP_ATOMIC);
@@ -244,36 +304,70 @@ batadv_mcast_mla_softif_get(struct net_device *dev,
 			break;
 		}
 
-		ether_addr_copy(new->addr, mc_list_entry->addr);
+		ether_addr_copy(new->addr, mcast_addr);
 		hlist_add_head(&new->list, mcast_list);
 		ret++;
 	}
-	netif_addr_unlock_bh(bridge ? bridge : dev);
-
-	if (bridge)
-		dev_put(bridge);
+	read_unlock_bh(&in6_dev->lock);
+	rcu_read_unlock();
 
 	return ret;
 }
+#else
+static inline int
+batadv_mcast_mla_softif_get_ipv6(struct net_device *dev,
+				 struct hlist_head *mcast_list,
+				 struct batadv_mcast_mla_flags *flags)
+{
+	return 0;
+}
+#endif
 
 /**
- * batadv_mcast_mla_is_duplicate() - check whether an address is in a list
- * @mcast_addr: the multicast address to check
- * @mcast_list: the list with multicast addresses to search in
+ * batadv_mcast_mla_softif_get() - get softif multicast listeners
+ * @dev: the device to collect multicast addresses from
+ * @mcast_list: a list to put found addresses into
+ * @flags: flags indicating the new multicast state
  *
- * Return: true if the given address is already in the given list.
- * Otherwise returns false.
+ * Collects multicast addresses of multicast listeners residing
+ * on this kernel on the given soft interface, dev, in
+ * the given mcast_list. In general, multicast listeners provided by
+ * your multicast receiving applications run directly on this node.
+ *
+ * If there is a bridge interface on top of dev, collects from that one
+ * instead. Just like with IP addresses and routes, multicast listeners
+ * will(/should) register to the bridge interface instead of an
+ * enslaved bat0.
+ *
+ * Return: -ENOMEM on memory allocation error or the number of
+ * items added to the mcast_list otherwise.
  */
-static bool batadv_mcast_mla_is_duplicate(u8 *mcast_addr,
-					  struct hlist_head *mcast_list)
+static int
+batadv_mcast_mla_softif_get(struct net_device *dev,
+			    struct hlist_head *mcast_list,
+			    struct batadv_mcast_mla_flags *flags)
 {
-	struct batadv_hw_addr *mcast_entry;
+	struct net_device *bridge = batadv_mcast_get_bridge(dev);
+	int ret4, ret6 = 0;
 
-	hlist_for_each_entry(mcast_entry, mcast_list, list)
-		if (batadv_compare_eth(mcast_entry->addr, mcast_addr))
-			return true;
+	if (bridge)
+		dev = bridge;
 
-	return false;
+	ret4 = batadv_mcast_mla_softif_get_ipv4(dev, mcast_list, flags);
+	if (ret4 < 0)
+		goto out;
+
+	ret6 = batadv_mcast_mla_softif_get_ipv6(dev, mcast_list, flags);
+	if (ret6 < 0) {
+		ret4 = 0;
+		goto out;
+	}
+
+out:
+	if (bridge)
+		dev_put(bridge);
+
+	return ret4 + ret6;
 }
 
 /**
-- 
2.11.0

