Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D29224597D
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 22:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgHPUcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 16:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgHPUce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 16:32:34 -0400
X-Greylist: delayed 477 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 16 Aug 2020 13:32:33 PDT
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:171:314c::100:a1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B598C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:32:33 -0700 (PDT)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1597609470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tho6iMDjA6w2bOGFFzB148ouMAewXNkCx3JumV0y56U=;
        b=skxrDUy5uMHdi+EhbRR9OKwdSAeXhDRohUBoD3FwLS46J6B9sVHYQNOI7Qjbk/U/PPim7P
        rHtO3sU+fJ+iBI88aJpe5OaaoAxZuaZPfjUoMea3kmwbpbWCGcyRCmZjoqDZ5a+o7A9N9u
        S2tNVAC6sUyzmOBTDIgAC9RsiCT0//a9LNAMtZ28U9b+icpzGT7t/lMXAqfh1r3buhPK+N
        i36nPtf3BW5YItL6mBi7aVFUgjBse0ilYMV+cCHIzrsaJRVoapWItlQpTYopcc/RG6g6KK
        e9HsjPwN5Ue9H11MXF/VNnY5csUaIUWMz3HBnlfepFPIPdlBI9NFABxPToS7FA==
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, gluon@luebeck.freifunk.net,
        openwrt-devel@lists.openwrt.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [RFC PATCH net-next] bridge: Implement MLD Querier wake-up calls / Android bug workaround
Date:   Sun, 16 Aug 2020 22:24:24 +0200
Message-Id: <20200816202424.3526-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a configurable MLD Querier wake-up calls "feature" which
works around a widely spread Android bug in connection with IGMP/MLD
snooping.

Currently there are mobile devices (e.g. Android) which are not able
to receive and respond to MLD Queries reliably because the Wifi driver
filters a lot of ICMPv6 when the device is asleep - including
MLD. This in turn breaks IPv6 communication when MLD Snooping is
enabled. However there is one ICMPv6 type which is allowed to pass and
which can be used to wake up the mobile device: ICMPv6 Echo Requests.

If this bridge is the selected MLD Querier then setting
"multicast_wakeupcall" to a number n greater than 0 will send n
ICMPv6 Echo Requests to each host behind this port to wake
them up with each MLD Query. Upon receiving a matching ICMPv6 Echo
Reply an MLD Query with a unicast ethernet destination will be sent
to the specific host(s).

Link: https://issuetracker.google.com/issues/149630944
Link: https://github.com/freifunk-gluon/gluon/issues/1832

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
A version of this patch rebased to Linux 4.14 is currently applied on a
400 nodes mesh network (Freifunk Vogtland).

I'm aware that this is quite a hack, so I'm unsure if this is suitable
for upstream. On the other hand, the Android ticket isn't moving
anywhere and even if it were fixed in Android, I'd expect it to take
years until that fix would propagate or unpatched Android devices to
vanish. So I'm wondering if it should be treated like a hardware bug
workaround and by that should be suitable for applying it upstream in
the Linux kernel?

I've also raised this issue on the mcast-wifi@ietf.org and pim@ietf.org
mailing list earlier this year but the amount of feedback was a bit
sparse.

CC'ing the OpenWrt mailing list, too, as I expect there to be most users
affected by this issue, if they enabled IGMP/MLD snooping.

Let me know what you think about this.

 include/linux/if_bridge.h    |   1 +
 include/uapi/linux/if_link.h |   1 +
 net/bridge/Kconfig           |  26 ++++
 net/bridge/br_fdb.c          |  10 ++
 net/bridge/br_input.c        |   4 +-
 net/bridge/br_multicast.c    | 284 ++++++++++++++++++++++++++++++++++-
 net/bridge/br_netlink.c      |  19 +++
 net/bridge/br_private.h      |  19 +++
 net/bridge/br_sysfs_if.c     |  18 +++
 9 files changed, 374 insertions(+), 8 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 6479a38e52fa..73bc692e1ae6 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -50,6 +50,7 @@ struct br_ip_list {
 #define BR_MRP_AWARE		BIT(17)
 #define BR_MRP_LOST_CONT	BIT(18)
 #define BR_MRP_LOST_IN_CONT	BIT(19)
+#define BR_MULTICAST_WAKEUPCALL	BIT(20)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 7fba4de511de..5015f8ce1ad7 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -355,6 +355,7 @@ enum {
 	IFLA_BRPORT_BACKUP_PORT,
 	IFLA_BRPORT_MRP_RING_OPEN,
 	IFLA_BRPORT_MRP_IN_OPEN,
+	IFLA_BRPORT_MCAST_WAKEUPCALL,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index 80879196560c..056e80bf00c4 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -48,6 +48,32 @@ config BRIDGE_IGMP_SNOOPING
 
 	  If unsure, say Y.
 
+config BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+	bool "MLD Querier wake-up calls"
+	depends on BRIDGE_IGMP_SNOOPING
+	depends on IPV6
+	help
+	  If you say Y here, then the MLD Snooping Querier will be built
+	  with a per bridge port wake-up call "feature"/workaround.
+
+	  Currently there are mobile devices (e.g. Android) which are not able
+	  to receive and respond to MLD Queries reliably because the Wifi driver
+	  filters a lot of ICMPv6 when the device is asleep - including MLD.
+	  This in turn breaks IPv6 communication when MLD Snooping is enabled.
+	  However there is one ICMPv6 type which is allowed to pass and
+	  which can be used to wake up the mobile device: ICMPv6 Echo Requests.
+
+	  If this bridge is the selected MLD Querier then setting
+	  "multicast_wakeupcall" to a number n greater than 0 will send n
+	  ICMPv6 Echo Requests to each host behind this port to wake them up
+	  with each MLD Query. Upon receiving a matching ICMPv6 Echo Reply
+	  an MLD Query with a unicast ethernet destination will be sent to the
+	  specific host(s).
+
+	  Say N to exclude this support and reduce the binary size.
+
+	  If unsure, say N.
+
 config BRIDGE_VLAN_FILTERING
 	bool "VLAN filtering"
 	depends on BRIDGE
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 9db504baa094..f63f85c5007c 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -84,6 +84,10 @@ static void fdb_rcu_free(struct rcu_head *head)
 {
 	struct net_bridge_fdb_entry *ent
 		= container_of(head, struct net_bridge_fdb_entry, rcu);
+
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+	del_timer_sync(&ent->wakeupcall_timer);
+#endif
 	kmem_cache_free(br_fdb_cache, ent);
 }
 
@@ -511,6 +515,12 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
 		fdb->key.vlan_id = vid;
 		fdb->flags = flags;
 		fdb->updated = fdb->used = jiffies;
+
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+		timer_setup(&fdb->wakeupcall_timer,
+			    br_multicast_send_wakeupcall, 0);
+#endif
+
 		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
 						  &fdb->rhnode,
 						  br_fdb_rht_params)) {
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 59a318b9f646..a1e40b25eb8a 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -155,8 +155,10 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	if (dst) {
 		unsigned long now = jiffies;
 
-		if (test_bit(BR_FDB_LOCAL, &dst->flags))
+		if (test_bit(BR_FDB_LOCAL, &dst->flags)) {
+			br_multicast_wakeupcall_rcv(br, p, skb, vid);
 			return br_pass_frame_up(skb);
+		}
 
 		if (now != dst->used)
 			dst->used = now;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 4c4a93abde68..4b25ad6113bf 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -309,10 +309,11 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
 #if IS_ENABLED(CONFIG_IPV6)
 static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 						    const struct in6_addr *grp,
-						    u8 *igmp_type)
+						    u8 *igmp_type,
+						    bool delay)
 {
+	unsigned long interval = 0;
 	struct mld2_query *mld2q;
-	unsigned long interval;
 	struct ipv6hdr *ip6h;
 	struct mld_msg *mldq;
 	size_t mld_hdr_size;
@@ -371,9 +372,13 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 
 	/* ICMPv6 */
 	skb_set_transport_header(skb, skb->len);
-	interval = ipv6_addr_any(grp) ?
-			br->multicast_query_response_interval :
-			br->multicast_last_member_interval;
+	if (delay) {
+		interval = ipv6_addr_any(grp) ?
+				br->multicast_query_response_interval :
+				br->multicast_last_member_interval;
+		interval = jiffies_to_msecs(interval);
+	}
+
 	*igmp_type = ICMPV6_MGM_QUERY;
 	switch (br->multicast_mld_version) {
 	case 1:
@@ -381,7 +386,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *br,
 		mldq->mld_type = ICMPV6_MGM_QUERY;
 		mldq->mld_code = 0;
 		mldq->mld_cksum = 0;
-		mldq->mld_maxdelay = htons((u16)jiffies_to_msecs(interval));
+		mldq->mld_maxdelay = htons((u16)interval);
 		mldq->mld_reserved = 0;
 		mldq->mld_mca = *grp;
 		mldq->mld_cksum = csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
@@ -430,7 +435,7 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
 		return br_ip6_multicast_alloc_query(br, &addr->u.ip6,
-						    igmp_type);
+						    igmp_type, true);
 #endif
 	}
 	return NULL;
@@ -709,6 +714,168 @@ static void br_multicast_select_own_querier(struct net_bridge *br,
 #endif
 }
 
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+
+#define BR_MC_WAKEUP_ID htons(0xEC6B) /* random identifier */
+#define BR_MC_ETH_ZERO { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }
+#define BR_MC_IN6_ZERO \
+{ \
+	.s6_addr32[0] = 0, .s6_addr32[1] = 0, \
+	.s6_addr32[2] = 0, .s6_addr32[3] = 0, \
+}
+
+#define BR_MC_IN6_FE80 \
+{ \
+	.s6_addr32[0] = htonl(0xfe800000), \
+	.s6_addr32[1] = 0, \
+	.s6_addr32[2] = htonl(0x000000ff), \
+	.s6_addr32[3] = htonl(0xfe000000), \
+}
+
+#define BR_MC_ECHO_LEN sizeof(pkt->echohdr)
+
+static struct sk_buff *br_multicast_alloc_wakeupcall(struct net_bridge *br,
+						     struct net_bridge_port *port,
+						     u8 *eth_dst)
+{
+	struct in6_addr ip6_src, ip6_dst = BR_MC_IN6_FE80;
+	struct sk_buff *skb;
+	__wsum csum_part;
+	__sum16 csum;
+
+	struct wakeupcall_pkt {
+		struct ethhdr ethhdr;
+		struct ipv6hdr ip6hdr;
+		struct icmp6hdr echohdr;
+	} __packed;
+
+	struct wakeupcall_pkt *pkt;
+
+	static const struct wakeupcall_pkt __pkt_template = {
+		.ethhdr = {
+			.h_dest = BR_MC_ETH_ZERO, // update
+			.h_source = BR_MC_ETH_ZERO, // update
+			.h_proto = htons(ETH_P_IPV6),
+		},
+		.ip6hdr = {
+			.priority = 0,
+			.version = 0x6,
+			.flow_lbl = { 0x00, 0x00, 0x00 },
+			.payload_len = htons(BR_MC_ECHO_LEN),
+			.nexthdr = IPPROTO_ICMPV6,
+			.hop_limit = 1,
+			.saddr = BR_MC_IN6_ZERO, // update
+			.daddr = BR_MC_IN6_ZERO, // update
+		},
+		.echohdr = {
+			.icmp6_type = ICMPV6_ECHO_REQUEST,
+			.icmp6_code = 0,
+			.icmp6_cksum = 0, // update
+			.icmp6_dataun.u_echo = {
+				.identifier = BR_MC_WAKEUP_ID,
+				.sequence = 0,
+			},
+		},
+	};
+
+	memcpy(&ip6_dst.s6_addr32[2], &eth_dst[0], ETH_ALEN / 2);
+	memcpy(&ip6_dst.s6_addr[13], &eth_dst[3], ETH_ALEN / 2);
+	ip6_dst.s6_addr[8] ^= 0x02;
+	if (ipv6_dev_get_saddr(dev_net(br->dev), br->dev, &ip6_dst, 0,
+			       &ip6_src))
+		return NULL;
+
+	skb = netdev_alloc_skb_ip_align(br->dev, sizeof(*pkt));
+	if (!skb)
+		return NULL;
+
+	skb->protocol = htons(ETH_P_IPV6);
+	skb->dev = port->dev;
+
+	pkt = (struct wakeupcall_pkt *)skb->data;
+	*pkt = __pkt_template;
+
+	ether_addr_copy(pkt->ethhdr.h_source, br->dev->dev_addr);
+	ether_addr_copy(pkt->ethhdr.h_dest, eth_dst);
+
+	pkt->ip6hdr.saddr = ip6_src;
+	pkt->ip6hdr.daddr = ip6_dst;
+
+	csum_part = csum_partial(&pkt->echohdr, sizeof(pkt->echohdr), 0);
+	csum = csum_ipv6_magic(&ip6_src, &ip6_dst, sizeof(pkt->echohdr),
+			       IPPROTO_ICMPV6, csum_part);
+	pkt->echohdr.icmp6_cksum = csum;
+
+	skb_reset_mac_header(skb);
+	skb_set_network_header(skb, offsetof(struct wakeupcall_pkt, ip6hdr));
+	skb_set_transport_header(skb, offsetof(struct wakeupcall_pkt, echohdr));
+	skb_put(skb, sizeof(*pkt));
+	__skb_pull(skb, sizeof(pkt->ethhdr));
+
+	return skb;
+}
+
+void br_multicast_send_wakeupcall(struct timer_list *t)
+{
+	struct net_bridge_fdb_entry *fdb = from_timer(fdb, t, wakeupcall_timer);
+	struct net_bridge_port *port = fdb->dst;
+	struct net_bridge *br = port->br;
+	struct sk_buff *skb, *skb0;
+	int i;
+
+	skb0 = br_multicast_alloc_wakeupcall(br, port, fdb->key.addr.addr);
+	if (!skb0)
+		return;
+
+	for (i = port->wakeupcall_num_rings; i > 0; i--) {
+		if (i > 1) {
+			skb = skb_clone(skb0, GFP_ATOMIC);
+			if (!skb) {
+				kfree_skb(skb0);
+				break;
+			}
+		} else {
+			skb = skb0;
+		}
+
+		NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT,
+			dev_net(port->dev), NULL, skb, NULL, skb->dev,
+			br_dev_queue_push_xmit);
+	}
+}
+
+static void br_multicast_schedule_wakeupcalls(struct net_bridge *br,
+					      struct net_bridge_port *port,
+					      const struct in6_addr *group)
+{
+	struct net_bridge_fdb_entry *fdb;
+	unsigned long delay;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
+		if (!fdb->dst || fdb->dst->dev != port->dev)
+			continue;
+
+		/* Wake-up calls to VLANs unsupported for now */
+		if (fdb->key.vlan_id)
+			continue;
+
+		/* Spread the ICMPv6 Echo Requests to avoid congestion.
+		 * We then won't use a max response delay for the queries later,
+		 * as that would be redundant. Spread randomly by a little less
+		 * than max response delay to anticipate the extra round trip.
+		 */
+		delay =	ipv6_addr_any(group) ?
+				br->multicast_query_response_interval :
+				br->multicast_last_member_interval;
+		delay = prandom_u32() % (3 * delay / 4);
+
+		timer_reduce(&fdb->wakeupcall_timer, jiffies + delay);
+	}
+	rcu_read_unlock();
+}
+#endif /* CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS */
+
 static void __br_multicast_send_query(struct net_bridge *br,
 				      struct net_bridge_port *port,
 				      struct br_ip *ip)
@@ -727,6 +894,13 @@ static void __br_multicast_send_query(struct net_bridge *br,
 		NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT,
 			dev_net(port->dev), NULL, skb, NULL, skb->dev,
 			br_dev_queue_push_xmit);
+
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+		if (port->wakeupcall_num_rings &&
+		    ip->proto == htons(ETH_P_IPV6))
+			br_multicast_schedule_wakeupcalls(br, port,
+							  &ip->u.ip6);
+#endif
 	} else {
 		br_multicast_select_own_querier(br, ip, skb);
 		br_multicast_count(br, port, skb, igmp_type,
@@ -1752,6 +1926,93 @@ int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
 	return ret;
 }
 
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+
+static bool br_multicast_wakeupcall_check(struct net_bridge *br,
+					  struct net_bridge_port *port,
+					  struct sk_buff *skb, u16 vid)
+{
+	struct ethhdr *eth = eth_hdr(skb);
+	const struct ipv6hdr *ip6h;
+	unsigned int offset, len;
+	struct icmp6hdr *icmp6h;
+
+	/* Wake-up calls to VLANs unsupported for now */
+	if (!port->wakeupcall_num_rings || vid ||
+	    eth->h_proto != htons(ETH_P_IPV6))
+		return false;
+
+	if (!ether_addr_equal(eth->h_dest, br->dev->dev_addr) ||
+	    is_multicast_ether_addr(eth->h_source) ||
+	    is_zero_ether_addr(eth->h_source))
+		return false;
+
+	offset = skb_network_offset(skb) + sizeof(*ip6h);
+	if (!pskb_may_pull(skb, offset))
+		return false;
+
+	ip6h = ipv6_hdr(skb);
+
+	if (ip6h->version != 6)
+		return false;
+
+	len = offset + ntohs(ip6h->payload_len);
+	if (skb->len < len || len <= offset)
+		return false;
+
+	if (ip6h->nexthdr != IPPROTO_ICMPV6)
+		return false;
+
+	skb_set_transport_header(skb, offset);
+
+	if (ipv6_mc_check_icmpv6 < 0)
+		return false;
+
+	icmp6h = (struct icmp6hdr *)skb_transport_header(skb);
+	if (icmp6h->icmp6_type != ICMPV6_ECHO_REPLY ||
+	    icmp6h->icmp6_dataun.u_echo.identifier != BR_MC_WAKEUP_ID)
+		return false;
+
+	return true;
+}
+
+static void br_multicast_wakeupcall_send_mldq(struct net_bridge *br,
+					      struct net_bridge_port *port,
+					      const u8 *eth_dst)
+{
+	const struct in6_addr grp = BR_MC_IN6_ZERO;
+	struct sk_buff *skb;
+	u8 igmp_type;
+
+	/* we might have been triggered by multicast-address-specific query
+	 * but reply with a general MLD query for now to keep things simple
+	 */
+	skb = br_ip6_multicast_alloc_query(br, &grp, &igmp_type, false);
+	if (!skb)
+		return;
+
+	skb->dev = port->dev;
+	ether_addr_copy(eth_hdr(skb)->h_dest, eth_dst);
+
+	br_multicast_count(br, port, skb, igmp_type,
+			   BR_MCAST_DIR_TX);
+	NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT,
+		dev_net(port->dev), NULL, skb, NULL, skb->dev,
+		br_dev_queue_push_xmit);
+}
+
+void br_multicast_wakeupcall_rcv(struct net_bridge *br,
+				 struct net_bridge_port *port,
+				 struct sk_buff *skb, u16 vid)
+{
+	if (!br_multicast_wakeupcall_check(br, port, skb, vid))
+		return;
+
+	br_multicast_wakeupcall_send_mldq(br, port, eth_hdr(skb)->h_source);
+}
+
+#endif /* CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS */
+
 static void br_multicast_query_expired(struct net_bridge *br,
 				       struct bridge_mcast_own_query *query,
 				       struct bridge_mcast_querier *querier)
@@ -2023,6 +2284,15 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	return err;
 }
 
+int br_multicast_set_wakeupcall(struct net_bridge_port *p, unsigned long val)
+{
+	if (val > U8_MAX)
+		return -EINVAL;
+
+	p->wakeupcall_num_rings = val;
+	return 0;
+}
+
 static void br_multicast_start_querier(struct net_bridge *br,
 				       struct bridge_mcast_own_query *query)
 {
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 147d52596e17..3372d954b075 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -149,6 +149,9 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size_64bit(sizeof(u64)) /* IFLA_BRPORT_HOLD_TIMER */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MULTICAST_ROUTER */
+#endif
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MCAST_WAKEUPCALL */
 #endif
 		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_GROUP_FWD_MASK */
 		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_RING_OPEN */
@@ -240,6 +243,11 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 		       p->multicast_router))
 		return -EMSGSIZE;
 #endif
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+	if (nla_put_u8(skb, IFLA_BRPORT_MCAST_WAKEUPCALL,
+		       p->wakeupcall_num_rings))
+		return -EMSGSIZE;
+#endif
 
 	/* we might be called only with br->lock */
 	rcu_read_lock();
@@ -724,6 +732,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_PROXYARP_WIFI] = { .type = NLA_U8 },
 	[IFLA_BRPORT_MULTICAST_ROUTER] = { .type = NLA_U8 },
 	[IFLA_BRPORT_MCAST_TO_UCAST] = { .type = NLA_U8 },
+	[IFLA_BRPORT_MCAST_WAKEUPCALL] = { .type = NLA_U8 },
 	[IFLA_BRPORT_MCAST_FLOOD] = { .type = NLA_U8 },
 	[IFLA_BRPORT_BCAST_FLOOD] = { .type = NLA_U8 },
 	[IFLA_BRPORT_VLAN_TUNNEL] = { .type = NLA_U8 },
@@ -868,6 +877,16 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[])
 	}
 #endif
 
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+	if (tb[IFLA_BRPORT_MCAST_WAKEUPCALL]) {
+		u8 wakeupcall = nla_get_u8(tb[IFLA_BRPORT_MCAST_WAKEUPCALL]);
+
+		err = br_multicast_set_wakeupcall(p, wakeupcall);
+		if (err)
+			return err;
+	}
+#endif
+
 	if (tb[IFLA_BRPORT_GROUP_FWD_MASK]) {
 		u16 fwd_mask = nla_get_u16(tb[IFLA_BRPORT_GROUP_FWD_MASK]);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index baa1500f384f..3d22571294f3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -208,6 +208,10 @@ struct net_bridge_fdb_entry {
 	unsigned long			used;
 
 	struct rcu_head			rcu;
+
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+	struct timer_list		wakeupcall_timer;
+#endif
 };
 
 #define MDB_PG_FLAGS_PERMANENT	BIT(0)
@@ -277,6 +281,7 @@ struct net_bridge_port {
 	struct timer_list		multicast_router_timer;
 	struct hlist_head		mglist;
 	struct hlist_node		rlist;
+	u8				wakeupcall_num_rings;
 #endif
 
 #ifdef CONFIG_SYSFS
@@ -940,6 +945,20 @@ static inline int br_multicast_igmp_type(const struct sk_buff *skb)
 }
 #endif
 
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+void br_multicast_wakeupcall_rcv(struct net_bridge *br,
+				 struct net_bridge_port *port,
+				 struct sk_buff *skb, u16 vid);
+void br_multicast_send_wakeupcall(struct timer_list *t);
+int br_multicast_set_wakeupcall(struct net_bridge_port *p, unsigned long val);
+#else
+static inline void br_multicast_wakeupcall_rcv(struct net_bridge *br,
+					       struct net_bridge_port *port,
+					       struct sk_buff *skb, u16 vid)
+{
+}
+#endif /* CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS */
+
 /* br_vlan.c */
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
 bool br_allowed_ingress(const struct net_bridge *br,
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 7a59cdddd3ce..0b68576b6da6 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -249,6 +249,21 @@ BRPORT_ATTR_FLAG(multicast_fast_leave, BR_MULTICAST_FAST_LEAVE);
 BRPORT_ATTR_FLAG(multicast_to_unicast, BR_MULTICAST_TO_UNICAST);
 #endif
 
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+static ssize_t show_multicast_wakeupcall(struct net_bridge_port *p, char *buf)
+{
+	return sprintf(buf, "%d\n", p->wakeupcall_num_rings);
+}
+
+static int store_multicast_wakeupcall(struct net_bridge_port *p,
+				      unsigned long v)
+{
+	return br_multicast_set_wakeupcall(p, v);
+}
+static BRPORT_ATTR(multicast_wakeupcall, 0644, show_multicast_wakeupcall,
+		   store_multicast_wakeupcall);
+#endif
+
 static const struct brport_attribute *brport_attrs[] = {
 	&brport_attr_path_cost,
 	&brport_attr_priority,
@@ -274,6 +289,9 @@ static const struct brport_attribute *brport_attrs[] = {
 	&brport_attr_multicast_router,
 	&brport_attr_multicast_fast_leave,
 	&brport_attr_multicast_to_unicast,
+#endif
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
+	&brport_attr_multicast_wakeupcall,
 #endif
 	&brport_attr_proxyarp,
 	&brport_attr_proxyarp_wifi,
-- 
2.28.0.rc1

