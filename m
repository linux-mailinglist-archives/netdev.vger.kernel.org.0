Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AFC59D56
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfF1N4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:56:20 -0400
Received: from packetmixer.de ([79.140.42.25]:53062 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfF1N4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:56:16 -0400
Received: from kero.packetmixer.de (p4FD57BD9.dip0.t-ipconnect.de [79.213.123.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id DF22762076;
        Fri, 28 Jun 2019 15:56:08 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 09/10] batman-adv: mcast: detect, distribute and maintain multicast router presence
Date:   Fri, 28 Jun 2019 15:56:03 +0200
Message-Id: <20190628135604.11581-10-sw@simonwunderlich.de>
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

To be able to apply our group aware multicast optimizations to packets
with a scope greater than link-local we need to not only keep track of
multicast listeners but also multicast routers.

With this patch a node detects the presence of multicast routers on
its segment by checking if
/proc/sys/net/ipv{4,6}/conf/<bat0|br0(bat)>/mc_forwarding is set for one
thing. This option is enabled by multicast routing daemons and needed
for the kernel's multicast routing tables to receive and route packets.

For another thing if a bridge is configured on top of bat0 then the
presence of an IPv6 multicast router behind this bridge is currently
detected by checking for an IPv6 multicast "All Routers Address"
(ff02::2). This should later be replaced by querying the bridge, which
performs proper, RFC4286 compliant Multicast Router Discovery (our
simplified approach includes more hosts than necessary, most notably
not just multicast routers but also unicast ones and is not applicable
for IPv4).

If no multicast router is detected then this is signalized via the new
BATADV_MCAST_WANT_NO_RTR4 and BATADV_MCAST_WANT_NO_RTR6
multicast tvlv flags.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 include/uapi/linux/batadv_packet.h |   8 +
 net/batman-adv/multicast.c         | 412 ++++++++++++++++++++++++++++++++-----
 net/batman-adv/originator.c        |   4 +-
 net/batman-adv/types.h             |  29 +++
 4 files changed, 399 insertions(+), 54 deletions(-)

diff --git a/include/uapi/linux/batadv_packet.h b/include/uapi/linux/batadv_packet.h
index 4ebc2135e950..2a15f01c2243 100644
--- a/include/uapi/linux/batadv_packet.h
+++ b/include/uapi/linux/batadv_packet.h
@@ -107,12 +107,20 @@ enum batadv_icmp_packettype {
  * @BATADV_MCAST_WANT_ALL_UNSNOOPABLES: we want all packets destined for
  *  224.0.0.0/24 or ff02::1
  * @BATADV_MCAST_WANT_ALL_IPV4: we want all IPv4 multicast packets
+ *  (both link-local and routable ones)
  * @BATADV_MCAST_WANT_ALL_IPV6: we want all IPv6 multicast packets
+ *  (both link-local and routable ones)
+ * @BATADV_MCAST_WANT_NO_RTR4: we have no IPv4 multicast router and therefore
+ * only need routable IPv4 multicast packets we signed up for explicitly
+ * @BATADV_MCAST_WANT_NO_RTR6: we have no IPv6 multicast router and therefore
+ * only need routable IPv6 multicast packets we signed up for explicitly
  */
 enum batadv_mcast_flags {
 	BATADV_MCAST_WANT_ALL_UNSNOOPABLES	= 1UL << 0,
 	BATADV_MCAST_WANT_ALL_IPV4		= 1UL << 1,
 	BATADV_MCAST_WANT_ALL_IPV6		= 1UL << 2,
+	BATADV_MCAST_WANT_NO_RTR4		= 1UL << 3,
+	BATADV_MCAST_WANT_NO_RTR6		= 1UL << 4,
 };
 
 /* tt data subtypes */
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index d4e7474022e3..80d5f3c892cb 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -73,27 +73,201 @@ static void batadv_mcast_start_timer(struct batadv_priv *bat_priv)
 }
 
 /**
- * batadv_mcast_has_bridge() - check whether the soft-iface is bridged
- * @bat_priv: the bat priv with all the soft interface information
+ * batadv_mcast_get_bridge() - get the bridge on top of the softif if it exists
+ * @soft_iface: netdev struct of the mesh interface
  *
- * Checks whether there is a bridge on top of our soft interface.
+ * If the given soft interface has a bridge on top then the refcount
+ * of the according net device is increased.
  *
- * Return: true if there is a bridge, false otherwise.
+ * Return: NULL if no such bridge exists. Otherwise the net device of the
+ * bridge.
  */
-static bool batadv_mcast_has_bridge(struct batadv_priv *bat_priv)
+static struct net_device *batadv_mcast_get_bridge(struct net_device *soft_iface)
 {
-	struct net_device *upper = bat_priv->soft_iface;
+	struct net_device *upper = soft_iface;
 
 	rcu_read_lock();
 	do {
 		upper = netdev_master_upper_dev_get_rcu(upper);
 	} while (upper && !(upper->priv_flags & IFF_EBRIDGE));
+
+	if (upper)
+		dev_hold(upper);
 	rcu_read_unlock();
 
 	return upper;
 }
 
 /**
+ * batadv_mcast_mla_rtr_flags_softif_get_ipv4() - get mcast router flags from
+ *  node for IPv4
+ * @dev: the interface to check
+ *
+ * Checks the presence of an IPv4 multicast router on this node.
+ *
+ * Caller needs to hold rcu read lock.
+ *
+ * Return: BATADV_NO_FLAGS if present, BATADV_MCAST_WANT_NO_RTR4 otherwise.
+ */
+static u8 batadv_mcast_mla_rtr_flags_softif_get_ipv4(struct net_device *dev)
+{
+	struct in_device *in_dev = __in_dev_get_rcu(dev);
+
+	if (in_dev && IN_DEV_MFORWARD(in_dev))
+		return BATADV_NO_FLAGS;
+	else
+		return BATADV_MCAST_WANT_NO_RTR4;
+}
+
+/**
+ * batadv_mcast_mla_rtr_flags_softif_get_ipv6() - get mcast router flags from
+ *  node for IPv6
+ * @dev: the interface to check
+ *
+ * Checks the presence of an IPv6 multicast router on this node.
+ *
+ * Caller needs to hold rcu read lock.
+ *
+ * Return: BATADV_NO_FLAGS if present, BATADV_MCAST_WANT_NO_RTR6 otherwise.
+ */
+#if IS_ENABLED(CONFIG_IPV6_MROUTE)
+static u8 batadv_mcast_mla_rtr_flags_softif_get_ipv6(struct net_device *dev)
+{
+	struct inet6_dev *in6_dev = __in6_dev_get(dev);
+
+	if (in6_dev && in6_dev->cnf.mc_forwarding)
+		return BATADV_NO_FLAGS;
+	else
+		return BATADV_MCAST_WANT_NO_RTR6;
+}
+#else
+static inline u8
+batadv_mcast_mla_rtr_flags_softif_get_ipv6(struct net_device *dev)
+{
+	return BATADV_MCAST_WANT_NO_RTR6;
+}
+#endif
+
+/**
+ * batadv_mcast_mla_rtr_flags_softif_get() - get mcast router flags from node
+ * @bat_priv: the bat priv with all the soft interface information
+ * @bridge: bridge interface on top of the soft_iface if present,
+ *  otherwise pass NULL
+ *
+ * Checks the presence of IPv4 and IPv6 multicast routers on this
+ * node.
+ *
+ * Return:
+ *	BATADV_NO_FLAGS: Both an IPv4 and IPv6 multicast router is present
+ *	BATADV_MCAST_WANT_NO_RTR4: No IPv4 multicast router is present
+ *	BATADV_MCAST_WANT_NO_RTR6: No IPv6 multicast router is present
+ *	The former two OR'd: no multicast router is present
+ */
+static u8 batadv_mcast_mla_rtr_flags_softif_get(struct batadv_priv *bat_priv,
+						struct net_device *bridge)
+{
+	struct net_device *dev = bridge ? bridge : bat_priv->soft_iface;
+	u8 flags = BATADV_NO_FLAGS;
+
+	rcu_read_lock();
+
+	flags |= batadv_mcast_mla_rtr_flags_softif_get_ipv4(dev);
+	flags |= batadv_mcast_mla_rtr_flags_softif_get_ipv6(dev);
+
+	rcu_read_unlock();
+
+	return flags;
+}
+
+/**
+ * batadv_mcast_mla_rtr_flags_bridge_get() - get mcast router flags from bridge
+ * @bat_priv: the bat priv with all the soft interface information
+ * @bridge: bridge interface on top of the soft_iface if present,
+ *  otherwise pass NULL
+ *
+ * Checks the presence of IPv4 and IPv6 multicast routers behind a bridge.
+ *
+ * Return:
+ *	BATADV_NO_FLAGS: Both an IPv4 and IPv6 multicast router is present
+ *	BATADV_MCAST_WANT_NO_RTR4: No IPv4 multicast router is present
+ *	BATADV_MCAST_WANT_NO_RTR6: No IPv6 multicast router is present
+ *	The former two OR'd: no multicast router is present
+ */
+#if IS_ENABLED(CONFIG_IPV6)
+static u8 batadv_mcast_mla_rtr_flags_bridge_get(struct batadv_priv *bat_priv,
+						struct net_device *bridge)
+{
+	struct list_head bridge_mcast_list = LIST_HEAD_INIT(bridge_mcast_list);
+	struct net_device *dev = bat_priv->soft_iface;
+	struct br_ip_list *br_ip_entry, *tmp;
+	u8 flags = BATADV_MCAST_WANT_NO_RTR6;
+	int ret;
+
+	if (!bridge)
+		return BATADV_MCAST_WANT_NO_RTR4 | BATADV_MCAST_WANT_NO_RTR6;
+
+	/* TODO: ask the bridge if a multicast router is present (the bridge
+	 * is capable of performing proper RFC4286 multicast multicast router
+	 * discovery) instead of searching for a ff02::2 listener here
+	 */
+	ret = br_multicast_list_adjacent(dev, &bridge_mcast_list);
+	if (ret < 0)
+		return BATADV_NO_FLAGS;
+
+	list_for_each_entry_safe(br_ip_entry, tmp, &bridge_mcast_list, list) {
+		/* the bridge snooping does not maintain IPv4 link-local
+		 * addresses - therefore we won't find any IPv4 multicast router
+		 * address here, only IPv6 ones
+		 */
+		if (br_ip_entry->addr.proto == htons(ETH_P_IPV6) &&
+		    ipv6_addr_is_ll_all_routers(&br_ip_entry->addr.u.ip6))
+			flags &= ~BATADV_MCAST_WANT_NO_RTR6;
+
+		list_del(&br_ip_entry->list);
+		kfree(br_ip_entry);
+	}
+
+	return flags;
+}
+#else
+static inline u8
+batadv_mcast_mla_rtr_flags_bridge_get(struct batadv_priv *bat_priv,
+				      struct net_device *bridge)
+{
+	if (bridge)
+		return BATADV_NO_FLAGS;
+	else
+		return BATADV_MCAST_WANT_NO_RTR4 | BATADV_MCAST_WANT_NO_RTR6;
+}
+#endif
+
+/**
+ * batadv_mcast_mla_rtr_flags_get() - get multicast router flags
+ * @bat_priv: the bat priv with all the soft interface information
+ * @bridge: bridge interface on top of the soft_iface if present,
+ *  otherwise pass NULL
+ *
+ * Checks the presence of IPv4 and IPv6 multicast routers on this
+ * node or behind its bridge.
+ *
+ * Return:
+ *	BATADV_NO_FLAGS: Both an IPv4 and IPv6 multicast router is present
+ *	BATADV_MCAST_WANT_NO_RTR4: No IPv4 multicast router is present
+ *	BATADV_MCAST_WANT_NO_RTR6: No IPv6 multicast router is present
+ *	The former two OR'd: no multicast router is present
+ */
+static u8 batadv_mcast_mla_rtr_flags_get(struct batadv_priv *bat_priv,
+					 struct net_device *bridge)
+{
+	u8 flags = BATADV_MCAST_WANT_NO_RTR4 | BATADV_MCAST_WANT_NO_RTR6;
+
+	flags &= batadv_mcast_mla_rtr_flags_softif_get(bat_priv, bridge);
+	flags &= batadv_mcast_mla_rtr_flags_bridge_get(bat_priv, bridge);
+
+	return flags;
+}
+
+/**
  * batadv_mcast_mla_flags_get() - get the new multicast flags
  * @bat_priv: the bat priv with all the soft interface information
  *
@@ -106,13 +280,20 @@ batadv_mcast_mla_flags_get(struct batadv_priv *bat_priv)
 	struct net_device *dev = bat_priv->soft_iface;
 	struct batadv_mcast_querier_state *qr4, *qr6;
 	struct batadv_mcast_mla_flags mla_flags;
+	struct net_device *bridge;
+
+	bridge = batadv_mcast_get_bridge(dev);
 
 	memset(&mla_flags, 0, sizeof(mla_flags));
 	mla_flags.enabled = 1;
+	mla_flags.tvlv_flags |= batadv_mcast_mla_rtr_flags_get(bat_priv,
+							       bridge);
 
-	if (!batadv_mcast_has_bridge(bat_priv))
+	if (!bridge)
 		return mla_flags;
 
+	dev_put(bridge);
+
 	mla_flags.bridged = 1;
 	qr4 = &mla_flags.querier_ipv4;
 	qr6 = &mla_flags.querier_ipv6;
@@ -137,42 +318,20 @@ batadv_mcast_mla_flags_get(struct batadv_priv *bat_priv)
 	 * In both cases, we will signalize other batman nodes that
 	 * we need all multicast traffic of the according protocol.
 	 */
-	if (!qr4->exists || qr4->shadowing)
+	if (!qr4->exists || qr4->shadowing) {
 		mla_flags.tvlv_flags |= BATADV_MCAST_WANT_ALL_IPV4;
+		mla_flags.tvlv_flags &= ~BATADV_MCAST_WANT_NO_RTR4;
+	}
 
-	if (!qr6->exists || qr6->shadowing)
+	if (!qr6->exists || qr6->shadowing) {
 		mla_flags.tvlv_flags |= BATADV_MCAST_WANT_ALL_IPV6;
+		mla_flags.tvlv_flags &= ~BATADV_MCAST_WANT_NO_RTR6;
+	}
 
 	return mla_flags;
 }
 
 /**
- * batadv_mcast_get_bridge() - get the bridge on top of the softif if it exists
- * @soft_iface: netdev struct of the mesh interface
- *
- * If the given soft interface has a bridge on top then the refcount
- * of the according net device is increased.
- *
- * Return: NULL if no such bridge exists. Otherwise the net device of the
- * bridge.
- */
-static struct net_device *batadv_mcast_get_bridge(struct net_device *soft_iface)
-{
-	struct net_device *upper = soft_iface;
-
-	rcu_read_lock();
-	do {
-		upper = netdev_master_upper_dev_get_rcu(upper);
-	} while (upper && !(upper->priv_flags & IFF_EBRIDGE));
-
-	if (upper)
-		dev_hold(upper);
-	rcu_read_unlock();
-
-	return upper;
-}
-
-/**
  * batadv_mcast_mla_is_duplicate() - check whether an address is in a list
  * @mcast_addr: the multicast address to check
  * @mcast_list: the list with multicast addresses to search in
@@ -234,6 +393,10 @@ batadv_mcast_mla_softif_get_ipv4(struct net_device *dev,
 		    ipv4_is_local_multicast(pmc->multiaddr))
 			continue;
 
+		if (!(flags->tvlv_flags & BATADV_MCAST_WANT_NO_RTR4) &&
+		    !ipv4_is_local_multicast(pmc->multiaddr))
+			continue;
+
 		ip_eth_mc_map(pmc->multiaddr, mcast_addr);
 
 		if (batadv_mcast_mla_is_duplicate(mcast_addr, mcast_list))
@@ -301,6 +464,11 @@ batadv_mcast_mla_softif_get_ipv6(struct net_device *dev,
 		    ipv6_addr_is_ll_all_nodes(&pmc6->mca_addr))
 			continue;
 
+		if (!(flags->tvlv_flags & BATADV_MCAST_WANT_NO_RTR6) &&
+		    IPV6_ADDR_MC_SCOPE(&pmc6->mca_addr) >
+		    IPV6_ADDR_SCOPE_LINKLOCAL)
+			continue;
+
 		ipv6_eth_mc_map(&pmc6->mca_addr, mcast_addr);
 
 		if (batadv_mcast_mla_is_duplicate(mcast_addr, mcast_list))
@@ -442,6 +610,10 @@ static int batadv_mcast_mla_bridge_get(struct net_device *dev,
 			if (tvlv_flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES &&
 			    ipv4_is_local_multicast(br_ip_entry->addr.u.ip4))
 				continue;
+
+			if (!(tvlv_flags & BATADV_MCAST_WANT_NO_RTR4) &&
+			    !ipv4_is_local_multicast(br_ip_entry->addr.u.ip4))
+				continue;
 		}
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -452,6 +624,11 @@ static int batadv_mcast_mla_bridge_get(struct net_device *dev,
 			if (tvlv_flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES &&
 			    ipv6_addr_is_ll_all_nodes(&br_ip_entry->addr.u.ip6))
 				continue;
+
+			if (!(tvlv_flags & BATADV_MCAST_WANT_NO_RTR6) &&
+			    IPV6_ADDR_MC_SCOPE(&br_ip_entry->addr.u.ip6) >
+			    IPV6_ADDR_SCOPE_LINKLOCAL)
+				continue;
 		}
 #endif
 
@@ -662,19 +839,23 @@ static void batadv_mcast_flags_log(struct batadv_priv *bat_priv, u8 flags)
 {
 	bool old_enabled = bat_priv->mcast.mla_flags.enabled;
 	u8 old_flags = bat_priv->mcast.mla_flags.tvlv_flags;
-	char str_old_flags[] = "[...]";
+	char str_old_flags[] = "[.... . ]";
 
-	sprintf(str_old_flags, "[%c%c%c]",
+	sprintf(str_old_flags, "[%c%c%c%s%s]",
 		(old_flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES) ? 'U' : '.',
 		(old_flags & BATADV_MCAST_WANT_ALL_IPV4) ? '4' : '.',
-		(old_flags & BATADV_MCAST_WANT_ALL_IPV6) ? '6' : '.');
+		(old_flags & BATADV_MCAST_WANT_ALL_IPV6) ? '6' : '.',
+		!(old_flags & BATADV_MCAST_WANT_NO_RTR4) ? "R4" : ". ",
+		!(old_flags & BATADV_MCAST_WANT_NO_RTR6) ? "R6" : ". ");
 
 	batadv_dbg(BATADV_DBG_MCAST, bat_priv,
-		   "Changing multicast flags from '%s' to '[%c%c%c]'\n",
+		   "Changing multicast flags from '%s' to '[%c%c%c%s%s]'\n",
 		   old_enabled ? str_old_flags : "<undefined>",
 		   (flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES) ? 'U' : '.',
 		   (flags & BATADV_MCAST_WANT_ALL_IPV4) ? '4' : '.',
-		   (flags & BATADV_MCAST_WANT_ALL_IPV6) ? '6' : '.');
+		   (flags & BATADV_MCAST_WANT_ALL_IPV6) ? '6' : '.',
+		   !(flags & BATADV_MCAST_WANT_NO_RTR4) ? "R4" : ". ",
+		   !(flags & BATADV_MCAST_WANT_NO_RTR6) ? "R6" : ". ");
 }
 
 /**
@@ -1467,6 +1648,127 @@ static void batadv_mcast_want_ipv6_update(struct batadv_priv *bat_priv,
 }
 
 /**
+ * batadv_mcast_want_rtr4_update() - update want-all-rtr4 counter and list
+ * @bat_priv: the bat priv with all the soft interface information
+ * @orig: the orig_node which multicast state might have changed of
+ * @mcast_flags: flags indicating the new multicast state
+ *
+ * If the BATADV_MCAST_WANT_NO_RTR4 flag of this originator, orig, has
+ * toggled then this method updates counter and list accordingly.
+ *
+ * Caller needs to hold orig->mcast_handler_lock.
+ */
+static void batadv_mcast_want_rtr4_update(struct batadv_priv *bat_priv,
+					  struct batadv_orig_node *orig,
+					  u8 mcast_flags)
+{
+	struct hlist_node *node = &orig->mcast_want_all_rtr4_node;
+	struct hlist_head *head = &bat_priv->mcast.want_all_rtr4_list;
+
+	lockdep_assert_held(&orig->mcast_handler_lock);
+
+	/* switched from flag set to unset */
+	if (!(mcast_flags & BATADV_MCAST_WANT_NO_RTR4) &&
+	    orig->mcast_flags & BATADV_MCAST_WANT_NO_RTR4) {
+		atomic_inc(&bat_priv->mcast.num_want_all_rtr4);
+
+		spin_lock_bh(&bat_priv->mcast.want_lists_lock);
+		/* flag checks above + mcast_handler_lock prevents this */
+		WARN_ON(!hlist_unhashed(node));
+
+		hlist_add_head_rcu(node, head);
+		spin_unlock_bh(&bat_priv->mcast.want_lists_lock);
+	/* switched from flag unset to set */
+	} else if (mcast_flags & BATADV_MCAST_WANT_NO_RTR4 &&
+		   !(orig->mcast_flags & BATADV_MCAST_WANT_NO_RTR4)) {
+		atomic_dec(&bat_priv->mcast.num_want_all_rtr4);
+
+		spin_lock_bh(&bat_priv->mcast.want_lists_lock);
+		/* flag checks above + mcast_handler_lock prevents this */
+		WARN_ON(hlist_unhashed(node));
+
+		hlist_del_init_rcu(node);
+		spin_unlock_bh(&bat_priv->mcast.want_lists_lock);
+	}
+}
+
+/**
+ * batadv_mcast_want_rtr6_update() - update want-all-rtr6 counter and list
+ * @bat_priv: the bat priv with all the soft interface information
+ * @orig: the orig_node which multicast state might have changed of
+ * @mcast_flags: flags indicating the new multicast state
+ *
+ * If the BATADV_MCAST_WANT_NO_RTR6 flag of this originator, orig, has
+ * toggled then this method updates counter and list accordingly.
+ *
+ * Caller needs to hold orig->mcast_handler_lock.
+ */
+static void batadv_mcast_want_rtr6_update(struct batadv_priv *bat_priv,
+					  struct batadv_orig_node *orig,
+					  u8 mcast_flags)
+{
+	struct hlist_node *node = &orig->mcast_want_all_rtr6_node;
+	struct hlist_head *head = &bat_priv->mcast.want_all_rtr6_list;
+
+	lockdep_assert_held(&orig->mcast_handler_lock);
+
+	/* switched from flag set to unset */
+	if (!(mcast_flags & BATADV_MCAST_WANT_NO_RTR6) &&
+	    orig->mcast_flags & BATADV_MCAST_WANT_NO_RTR6) {
+		atomic_inc(&bat_priv->mcast.num_want_all_rtr6);
+
+		spin_lock_bh(&bat_priv->mcast.want_lists_lock);
+		/* flag checks above + mcast_handler_lock prevents this */
+		WARN_ON(!hlist_unhashed(node));
+
+		hlist_add_head_rcu(node, head);
+		spin_unlock_bh(&bat_priv->mcast.want_lists_lock);
+	/* switched from flag unset to set */
+	} else if (mcast_flags & BATADV_MCAST_WANT_NO_RTR6 &&
+		   !(orig->mcast_flags & BATADV_MCAST_WANT_NO_RTR6)) {
+		atomic_dec(&bat_priv->mcast.num_want_all_rtr6);
+
+		spin_lock_bh(&bat_priv->mcast.want_lists_lock);
+		/* flag checks above + mcast_handler_lock prevents this */
+		WARN_ON(hlist_unhashed(node));
+
+		hlist_del_init_rcu(node);
+		spin_unlock_bh(&bat_priv->mcast.want_lists_lock);
+	}
+}
+
+/**
+ * batadv_mcast_tvlv_flags_get() - get multicast flags from an OGM TVLV
+ * @enabled: whether the originator has multicast TVLV support enabled
+ * @tvlv_value: tvlv buffer containing the multicast flags
+ * @tvlv_value_len: tvlv buffer length
+ *
+ * Return: multicast flags for the given tvlv buffer
+ */
+static u8
+batadv_mcast_tvlv_flags_get(bool enabled, void *tvlv_value, u16 tvlv_value_len)
+{
+	u8 mcast_flags = BATADV_NO_FLAGS;
+
+	if (enabled && tvlv_value && tvlv_value_len >= sizeof(mcast_flags))
+		mcast_flags = *(u8 *)tvlv_value;
+
+	if (!enabled) {
+		mcast_flags |= BATADV_MCAST_WANT_ALL_IPV4;
+		mcast_flags |= BATADV_MCAST_WANT_ALL_IPV6;
+	}
+
+	/* remove redundant flags to avoid sending duplicate packets later */
+	if (mcast_flags & BATADV_MCAST_WANT_ALL_IPV4)
+		mcast_flags |= BATADV_MCAST_WANT_NO_RTR4;
+
+	if (mcast_flags & BATADV_MCAST_WANT_ALL_IPV6)
+		mcast_flags |= BATADV_MCAST_WANT_NO_RTR6;
+
+	return mcast_flags;
+}
+
+/**
  * batadv_mcast_tvlv_ogm_handler() - process incoming multicast tvlv container
  * @bat_priv: the bat priv with all the soft interface information
  * @orig: the orig_node of the ogm
@@ -1481,16 +1783,10 @@ static void batadv_mcast_tvlv_ogm_handler(struct batadv_priv *bat_priv,
 					  u16 tvlv_value_len)
 {
 	bool orig_mcast_enabled = !(flags & BATADV_TVLV_HANDLER_OGM_CIFNOTFND);
-	u8 mcast_flags = BATADV_NO_FLAGS;
-
-	if (orig_mcast_enabled && tvlv_value &&
-	    tvlv_value_len >= sizeof(mcast_flags))
-		mcast_flags = *(u8 *)tvlv_value;
+	u8 mcast_flags;
 
-	if (!orig_mcast_enabled) {
-		mcast_flags |= BATADV_MCAST_WANT_ALL_IPV4;
-		mcast_flags |= BATADV_MCAST_WANT_ALL_IPV6;
-	}
+	mcast_flags = batadv_mcast_tvlv_flags_get(orig_mcast_enabled,
+						  tvlv_value, tvlv_value_len);
 
 	spin_lock_bh(&orig->mcast_handler_lock);
 
@@ -1507,6 +1803,8 @@ static void batadv_mcast_tvlv_ogm_handler(struct batadv_priv *bat_priv,
 	batadv_mcast_want_unsnoop_update(bat_priv, orig, mcast_flags);
 	batadv_mcast_want_ipv4_update(bat_priv, orig, mcast_flags);
 	batadv_mcast_want_ipv6_update(bat_priv, orig, mcast_flags);
+	batadv_mcast_want_rtr4_update(bat_priv, orig, mcast_flags);
+	batadv_mcast_want_rtr6_update(bat_priv, orig, mcast_flags);
 
 	orig->mcast_flags = mcast_flags;
 	spin_unlock_bh(&orig->mcast_handler_lock);
@@ -1556,10 +1854,12 @@ static void batadv_mcast_flags_print_header(struct batadv_priv *bat_priv,
 		shadowing6 = '?';
 	}
 
-	seq_printf(seq, "Multicast flags (own flags: [%c%c%c])\n",
+	seq_printf(seq, "Multicast flags (own flags: [%c%c%c%s%s])\n",
 		   (flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES) ? 'U' : '.',
 		   (flags & BATADV_MCAST_WANT_ALL_IPV4) ? '4' : '.',
-		   (flags & BATADV_MCAST_WANT_ALL_IPV6) ? '6' : '.');
+		   (flags & BATADV_MCAST_WANT_ALL_IPV6) ? '6' : '.',
+		   !(flags & BATADV_MCAST_WANT_NO_RTR4) ? "R4" : ". ",
+		   !(flags & BATADV_MCAST_WANT_NO_RTR6) ? "R6" : ". ");
 	seq_printf(seq, "* Bridged [U]\t\t\t\t%c\n", bridged ? 'U' : '.');
 	seq_printf(seq, "* No IGMP/MLD Querier [4/6]:\t\t%c/%c\n",
 		   querier4, querier6);
@@ -1613,13 +1913,17 @@ int batadv_mcast_flags_seq_print_text(struct seq_file *seq, void *offset)
 
 			flags = orig_node->mcast_flags;
 
-			seq_printf(seq, "%pM [%c%c%c]\n", orig_node->orig,
+			seq_printf(seq, "%pM [%c%c%c%s%s]\n", orig_node->orig,
 				   (flags & BATADV_MCAST_WANT_ALL_UNSNOOPABLES)
 				   ? 'U' : '.',
 				   (flags & BATADV_MCAST_WANT_ALL_IPV4)
 				   ? '4' : '.',
 				   (flags & BATADV_MCAST_WANT_ALL_IPV6)
-				   ? '6' : '.');
+				   ? '6' : '.',
+				   !(flags & BATADV_MCAST_WANT_NO_RTR4)
+				   ? "R4" : ". ",
+				   !(flags & BATADV_MCAST_WANT_NO_RTR6)
+				   ? "R6" : ". ");
 		}
 		rcu_read_unlock();
 	}
@@ -1893,6 +2197,8 @@ void batadv_mcast_purge_orig(struct batadv_orig_node *orig)
 	batadv_mcast_want_unsnoop_update(bat_priv, orig, BATADV_NO_FLAGS);
 	batadv_mcast_want_ipv4_update(bat_priv, orig, BATADV_NO_FLAGS);
 	batadv_mcast_want_ipv6_update(bat_priv, orig, BATADV_NO_FLAGS);
+	batadv_mcast_want_rtr4_update(bat_priv, orig, BATADV_NO_FLAGS);
+	batadv_mcast_want_rtr6_update(bat_priv, orig, BATADV_NO_FLAGS);
 
 	spin_unlock_bh(&orig->mcast_handler_lock);
 }
diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 45db798a7297..38613487fb1b 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -27,6 +27,7 @@
 #include <linux/stddef.h>
 #include <linux/workqueue.h>
 #include <net/sock.h>
+#include <uapi/linux/batadv_packet.h>
 #include <uapi/linux/batman_adv.h>
 
 #include "bat_algo.h"
@@ -1043,7 +1044,8 @@ struct batadv_orig_node *batadv_orig_node_new(struct batadv_priv *bat_priv,
 	orig_node->bcast_seqno_reset = reset_time;
 
 #ifdef CONFIG_BATMAN_ADV_MCAST
-	orig_node->mcast_flags = BATADV_NO_FLAGS;
+	orig_node->mcast_flags = BATADV_MCAST_WANT_NO_RTR4;
+	orig_node->mcast_flags |= BATADV_MCAST_WANT_NO_RTR6;
 	INIT_HLIST_NODE(&orig_node->mcast_want_all_unsnoopables_node);
 	INIT_HLIST_NODE(&orig_node->mcast_want_all_ipv4_node);
 	INIT_HLIST_NODE(&orig_node->mcast_want_all_ipv6_node);
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 72f65b3769d0..c2996296b953 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -404,6 +404,17 @@ struct batadv_orig_node {
 	 *  list
 	 */
 	struct hlist_node mcast_want_all_ipv6_node;
+
+	/**
+	 * @mcast_want_all_rtr4_node: a list node for the mcast.want_all_rtr4
+	 *  list
+	 */
+	struct hlist_node mcast_want_all_rtr4_node;
+	/**
+	 * @mcast_want_all_rtr6_node: a list node for the mcast.want_all_rtr6
+	 *  list
+	 */
+	struct hlist_node mcast_want_all_rtr6_node;
 #endif
 
 	/** @capabilities: announced capabilities of this originator */
@@ -1219,6 +1230,18 @@ struct batadv_priv_mcast {
 	struct hlist_head want_all_ipv6_list;
 
 	/**
+	 * @want_all_rtr4_list: a list of orig_nodes wanting all routable IPv4
+	 *  multicast traffic
+	 */
+	struct hlist_head want_all_rtr4_list;
+
+	/**
+	 * @want_all_rtr6_list: a list of orig_nodes wanting all routable IPv6
+	 *  multicast traffic
+	 */
+	struct hlist_head want_all_rtr6_list;
+
+	/**
 	 * @mla_flags: flags for the querier, bridge and tvlv state
 	 */
 	struct batadv_mcast_mla_flags mla_flags;
@@ -1240,6 +1263,12 @@ struct batadv_priv_mcast {
 	/** @num_want_all_ipv6: counter for items in want_all_ipv6_list */
 	atomic_t num_want_all_ipv6;
 
+	/** @num_want_all_rtr4: counter for items in want_all_rtr4_list */
+	atomic_t num_want_all_rtr4;
+
+	/** @num_want_all_rtr6: counter for items in want_all_rtr6_list */
+	atomic_t num_want_all_rtr6;
+
 	/**
 	 * @want_lists_lock: lock for protecting modifications to mcasts
 	 *  want_all_{unsnoopables,ipv4,ipv6}_list (traversals are rcu-locked)
-- 
2.11.0

