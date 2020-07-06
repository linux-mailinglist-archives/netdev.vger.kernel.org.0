Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6125215A8A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgGFPSj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Jul 2020 11:18:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56343 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729254AbgGFPSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:18:38 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-joU4YiTuNIqyV6XCMwJx_w-1; Mon, 06 Jul 2020 11:18:31 -0400
X-MC-Unique: joU4YiTuNIqyV6XCMwJx_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3347800415;
        Mon,  6 Jul 2020 15:18:30 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B479D71669;
        Mon,  6 Jul 2020 15:18:29 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH net-next] geneve: move all configuration under struct geneve_config
Date:   Mon,  6 Jul 2020 17:18:08 +0200
Message-Id: <0e05d6eb47238c62282bc9862d0607c41adc9330.1594046961.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new structure geneve_config and moves the per-device
configuration attributes to it, like we already have in VXLAN with
struct vxlan_config. This ends up being pretty invasive since those
attributes are used everywhere.

This allows us to clean up the argument lists for geneve_configure (4
arguments instead of 8) and geneve_nl2info (5 instead of 9).

This also reduces the copy-paste of code setting those attributes
between geneve_configure and geneve_changelink to a single memcpy,
which would have avoided the bug fixed in commit
56c09de347e4 ("geneve: allow changing DF behavior after creation").

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/geneve.c | 185 ++++++++++++++++++++-----------------------
 1 file changed, 87 insertions(+), 98 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 4661ef865807..e3d074008da2 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -48,6 +48,14 @@ struct geneve_dev_node {
 	struct geneve_dev *geneve;
 };
 
+struct geneve_config {
+	struct ip_tunnel_info	info;
+	bool			collect_md;
+	bool			use_udp6_rx_checksums;
+	bool			ttl_inherit;
+	enum ifla_geneve_df	df;
+};
+
 /* Pseudo network device */
 struct geneve_dev {
 	struct geneve_dev_node hlist4;	/* vni hash table for IPv4 socket */
@@ -56,17 +64,13 @@ struct geneve_dev {
 #endif
 	struct net	   *net;	/* netns for packet i/o */
 	struct net_device  *dev;	/* netdev for geneve tunnel */
-	struct ip_tunnel_info info;
 	struct geneve_sock __rcu *sock4;	/* IPv4 socket used for geneve tunnel */
 #if IS_ENABLED(CONFIG_IPV6)
 	struct geneve_sock __rcu *sock6;	/* IPv6 socket used for geneve tunnel */
 #endif
 	struct list_head   next;	/* geneve's per namespace list */
 	struct gro_cells   gro_cells;
-	bool		   collect_md;
-	bool		   use_udp6_rx_checksums;
-	bool		   ttl_inherit;
-	enum ifla_geneve_df df;
+	struct geneve_config cfg;
 };
 
 struct geneve_sock {
@@ -132,8 +136,8 @@ static struct geneve_dev *geneve_lookup(struct geneve_sock *gs,
 	hash = geneve_net_vni_hash(vni);
 	vni_list_head = &gs->vni_list[hash];
 	hlist_for_each_entry_rcu(node, vni_list_head, hlist) {
-		if (eq_tun_id_and_vni((u8 *)&node->geneve->info.key.tun_id, vni) &&
-		    addr == node->geneve->info.key.u.ipv4.dst)
+		if (eq_tun_id_and_vni((u8 *)&node->geneve->cfg.info.key.tun_id, vni) &&
+		    addr == node->geneve->cfg.info.key.u.ipv4.dst)
 			return node->geneve;
 	}
 	return NULL;
@@ -151,8 +155,8 @@ static struct geneve_dev *geneve6_lookup(struct geneve_sock *gs,
 	hash = geneve_net_vni_hash(vni);
 	vni_list_head = &gs->vni_list[hash];
 	hlist_for_each_entry_rcu(node, vni_list_head, hlist) {
-		if (eq_tun_id_and_vni((u8 *)&node->geneve->info.key.tun_id, vni) &&
-		    ipv6_addr_equal(&addr6, &node->geneve->info.key.u.ipv6.dst))
+		if (eq_tun_id_and_vni((u8 *)&node->geneve->cfg.info.key.tun_id, vni) &&
+		    ipv6_addr_equal(&addr6, &node->geneve->cfg.info.key.u.ipv6.dst))
 			return node->geneve;
 	}
 	return NULL;
@@ -321,7 +325,7 @@ static int geneve_init(struct net_device *dev)
 		return err;
 	}
 
-	err = dst_cache_init(&geneve->info.dst_cache, GFP_KERNEL);
+	err = dst_cache_init(&geneve->cfg.info.dst_cache, GFP_KERNEL);
 	if (err) {
 		free_percpu(dev->tstats);
 		gro_cells_destroy(&geneve->gro_cells);
@@ -334,7 +338,7 @@ static void geneve_uninit(struct net_device *dev)
 {
 	struct geneve_dev *geneve = netdev_priv(dev);
 
-	dst_cache_destroy(&geneve->info.dst_cache);
+	dst_cache_destroy(&geneve->cfg.info.dst_cache);
 	gro_cells_destroy(&geneve->gro_cells);
 	free_percpu(dev->tstats);
 }
@@ -654,19 +658,19 @@ static int geneve_sock_add(struct geneve_dev *geneve, bool ipv6)
 	__u8 vni[3];
 	__u32 hash;
 
-	gs = geneve_find_sock(gn, ipv6 ? AF_INET6 : AF_INET, geneve->info.key.tp_dst);
+	gs = geneve_find_sock(gn, ipv6 ? AF_INET6 : AF_INET, geneve->cfg.info.key.tp_dst);
 	if (gs) {
 		gs->refcnt++;
 		goto out;
 	}
 
-	gs = geneve_socket_create(net, geneve->info.key.tp_dst, ipv6,
-				  geneve->use_udp6_rx_checksums);
+	gs = geneve_socket_create(net, geneve->cfg.info.key.tp_dst, ipv6,
+				  geneve->cfg.use_udp6_rx_checksums);
 	if (IS_ERR(gs))
 		return PTR_ERR(gs);
 
 out:
-	gs->collect_md = geneve->collect_md;
+	gs->collect_md = geneve->cfg.collect_md;
 #if IS_ENABLED(CONFIG_IPV6)
 	if (ipv6) {
 		rcu_assign_pointer(geneve->sock6, gs);
@@ -679,7 +683,7 @@ static int geneve_sock_add(struct geneve_dev *geneve, bool ipv6)
 	}
 	node->geneve = geneve;
 
-	tunnel_id_to_vni(geneve->info.key.tun_id, vni);
+	tunnel_id_to_vni(geneve->cfg.info.key.tun_id, vni);
 	hash = geneve_net_vni_hash(vni);
 	hlist_add_head_rcu(&node->hlist, &gs->vni_list[hash]);
 	return 0;
@@ -688,11 +692,11 @@ static int geneve_sock_add(struct geneve_dev *geneve, bool ipv6)
 static int geneve_open(struct net_device *dev)
 {
 	struct geneve_dev *geneve = netdev_priv(dev);
-	bool metadata = geneve->collect_md;
+	bool metadata = geneve->cfg.collect_md;
 	bool ipv4, ipv6;
 	int ret = 0;
 
-	ipv6 = geneve->info.mode & IP_TUNNEL_INFO_IPV6 || metadata;
+	ipv6 = geneve->cfg.info.mode & IP_TUNNEL_INFO_IPV6 || metadata;
 	ipv4 = !ipv6 || metadata;
 #if IS_ENABLED(CONFIG_IPV6)
 	if (ipv6) {
@@ -791,7 +795,7 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 	fl4->saddr = info->key.u.ipv4.src;
 
 	tos = info->key.tos;
-	if ((tos == 1) && !geneve->collect_md) {
+	if ((tos == 1) && !geneve->cfg.collect_md) {
 		tos = ip_tunnel_get_dsfield(ip_hdr(skb), skb);
 		use_cache = false;
 	}
@@ -840,7 +844,7 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 	fl6->daddr = info->key.u.ipv6.dst;
 	fl6->saddr = info->key.u.ipv6.src;
 	prio = info->key.tos;
-	if ((prio == 1) && !geneve->collect_md) {
+	if ((prio == 1) && !geneve->cfg.collect_md) {
 		prio = ip_tunnel_get_dsfield(ip_hdr(skb), skb);
 		use_cache = false;
 	}
@@ -893,22 +897,22 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			      GENEVE_IPV4_HLEN + info->options_len);
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
-	if (geneve->collect_md) {
+	if (geneve->cfg.collect_md) {
 		tos = ip_tunnel_ecn_encap(key->tos, ip_hdr(skb), skb);
 		ttl = key->ttl;
 
 		df = key->tun_flags & TUNNEL_DONT_FRAGMENT ? htons(IP_DF) : 0;
 	} else {
 		tos = ip_tunnel_ecn_encap(fl4.flowi4_tos, ip_hdr(skb), skb);
-		if (geneve->ttl_inherit)
+		if (geneve->cfg.ttl_inherit)
 			ttl = ip_tunnel_get_ttl(ip_hdr(skb), skb);
 		else
 			ttl = key->ttl;
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 
-		if (geneve->df == GENEVE_DF_SET) {
+		if (geneve->cfg.df == GENEVE_DF_SET) {
 			df = htons(IP_DF);
-		} else if (geneve->df == GENEVE_DF_INHERIT) {
+		} else if (geneve->cfg.df == GENEVE_DF_INHERIT) {
 			struct ethhdr *eth = eth_hdr(skb);
 
 			if (ntohs(eth->h_proto) == ETH_P_IPV6) {
@@ -927,7 +931,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		return err;
 
 	udp_tunnel_xmit_skb(rt, gs4->sock->sk, skb, fl4.saddr, fl4.daddr,
-			    tos, ttl, df, sport, geneve->info.key.tp_dst,
+			    tos, ttl, df, sport, geneve->cfg.info.key.tp_dst,
 			    !net_eq(geneve->net, dev_net(geneve->dev)),
 			    !(info->key.tun_flags & TUNNEL_CSUM));
 	return 0;
@@ -954,13 +958,13 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	skb_tunnel_check_pmtu(skb, dst, GENEVE_IPV6_HLEN + info->options_len);
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
-	if (geneve->collect_md) {
+	if (geneve->cfg.collect_md) {
 		prio = ip_tunnel_ecn_encap(key->tos, ip_hdr(skb), skb);
 		ttl = key->ttl;
 	} else {
 		prio = ip_tunnel_ecn_encap(ip6_tclass(fl6.flowlabel),
 					   ip_hdr(skb), skb);
-		if (geneve->ttl_inherit)
+		if (geneve->cfg.ttl_inherit)
 			ttl = ip_tunnel_get_ttl(ip_hdr(skb), skb);
 		else
 			ttl = key->ttl;
@@ -972,7 +976,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 
 	udp_tunnel6_xmit_skb(dst, gs6->sock->sk, skb, dev,
 			     &fl6.saddr, &fl6.daddr, prio, ttl,
-			     info->key.label, sport, geneve->info.key.tp_dst,
+			     info->key.label, sport, geneve->cfg.info.key.tp_dst,
 			     !(info->key.tun_flags & TUNNEL_CSUM));
 	return 0;
 }
@@ -984,7 +988,7 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ip_tunnel_info *info = NULL;
 	int err;
 
-	if (geneve->collect_md) {
+	if (geneve->cfg.collect_md) {
 		info = skb_tunnel_info(skb);
 		if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX))) {
 			netdev_dbg(dev, "no tunnel metadata\n");
@@ -993,7 +997,7 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 			return NETDEV_TX_OK;
 		}
 	} else {
-		info = &geneve->info;
+		info = &geneve->cfg.info;
 	}
 
 	rcu_read_lock();
@@ -1065,7 +1069,7 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 
 	info->key.tp_src = udp_flow_src_port(geneve->net, skb,
 					     1, USHRT_MAX, true);
-	info->key.tp_dst = geneve->info.key.tp_dst;
+	info->key.tp_dst = geneve->cfg.info.key.tp_dst;
 	return 0;
 }
 
@@ -1227,13 +1231,13 @@ static struct geneve_dev *geneve_find_dev(struct geneve_net *gn,
 	*tun_on_same_port = false;
 	*tun_collect_md = false;
 	list_for_each_entry(geneve, &gn->geneve_list, next) {
-		if (info->key.tp_dst == geneve->info.key.tp_dst) {
-			*tun_collect_md = geneve->collect_md;
+		if (info->key.tp_dst == geneve->cfg.info.key.tp_dst) {
+			*tun_collect_md = geneve->cfg.collect_md;
 			*tun_on_same_port = true;
 		}
-		if (info->key.tun_id == geneve->info.key.tun_id &&
-		    info->key.tp_dst == geneve->info.key.tp_dst &&
-		    !memcmp(&info->key.u, &geneve->info.key.u, sizeof(info->key.u)))
+		if (info->key.tun_id == geneve->cfg.info.key.tun_id &&
+		    info->key.tp_dst == geneve->cfg.info.key.tp_dst &&
+		    !memcmp(&info->key.u, &geneve->cfg.info.key.u, sizeof(info->key.u)))
 			t = geneve;
 	}
 	return t;
@@ -1257,16 +1261,15 @@ static bool geneve_dst_addr_equal(struct ip_tunnel_info *a,
 
 static int geneve_configure(struct net *net, struct net_device *dev,
 			    struct netlink_ext_ack *extack,
-			    const struct ip_tunnel_info *info,
-			    bool metadata, bool ipv6_rx_csum,
-			    bool ttl_inherit, enum ifla_geneve_df df)
+			    const struct geneve_config *cfg)
 {
 	struct geneve_net *gn = net_generic(net, geneve_net_id);
 	struct geneve_dev *t, *geneve = netdev_priv(dev);
+	const struct ip_tunnel_info *info = &cfg->info;
 	bool tun_collect_md, tun_on_same_port;
 	int err, encap_len;
 
-	if (metadata && !is_tnl_info_zero(info)) {
+	if (cfg->collect_md && !is_tnl_info_zero(info)) {
 		NL_SET_ERR_MSG(extack,
 			       "Device is externally controlled, so attributes (VNI, Port, and so on) must not be specified");
 		return -EINVAL;
@@ -1281,7 +1284,7 @@ static int geneve_configure(struct net *net, struct net_device *dev,
 
 	/* make enough headroom for basic scenario */
 	encap_len = GENEVE_BASE_HLEN + ETH_HLEN;
-	if (!metadata && ip_tunnel_info_af(info) == AF_INET) {
+	if (!cfg->collect_md && ip_tunnel_info_af(info) == AF_INET) {
 		encap_len += sizeof(struct iphdr);
 		dev->max_mtu -= sizeof(struct iphdr);
 	} else {
@@ -1290,7 +1293,7 @@ static int geneve_configure(struct net *net, struct net_device *dev,
 	}
 	dev->needed_headroom = encap_len + ETH_HLEN;
 
-	if (metadata) {
+	if (cfg->collect_md) {
 		if (tun_on_same_port) {
 			NL_SET_ERR_MSG(extack,
 				       "There can be only one externally controlled device on a destination port");
@@ -1304,12 +1307,8 @@ static int geneve_configure(struct net *net, struct net_device *dev,
 		}
 	}
 
-	dst_cache_reset(&geneve->info.dst_cache);
-	geneve->info = *info;
-	geneve->collect_md = metadata;
-	geneve->use_udp6_rx_checksums = ipv6_rx_csum;
-	geneve->ttl_inherit = ttl_inherit;
-	geneve->df = df;
+	dst_cache_reset(&geneve->cfg.info.dst_cache);
+	memcpy(&geneve->cfg, cfg, sizeof(*cfg));
 
 	err = register_netdevice(dev);
 	if (err)
@@ -1327,11 +1326,10 @@ static void init_tnl_info(struct ip_tunnel_info *info, __u16 dst_port)
 
 static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 			  struct netlink_ext_ack *extack,
-			  struct ip_tunnel_info *info, bool *metadata,
-			  bool *use_udp6_rx_checksums, bool *ttl_inherit,
-			  enum ifla_geneve_df *df, bool changelink)
+			  struct geneve_config *cfg, bool changelink)
 {
 	int attrtype;
+	struct ip_tunnel_info *info = &cfg->info;
 
 	if (data[IFLA_GENEVE_REMOTE] && data[IFLA_GENEVE_REMOTE6]) {
 		NL_SET_ERR_MSG(extack,
@@ -1378,7 +1376,7 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 			return -EINVAL;
 		}
 		info->key.tun_flags |= TUNNEL_CSUM;
-		*use_udp6_rx_checksums = true;
+		cfg->use_udp6_rx_checksums = true;
 #else
 		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_GENEVE_REMOTE6],
 				    "IPv6 support not enabled in the kernel");
@@ -1406,19 +1404,19 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 
 	if (data[IFLA_GENEVE_TTL_INHERIT]) {
 		if (nla_get_u8(data[IFLA_GENEVE_TTL_INHERIT]))
-			*ttl_inherit = true;
+			cfg->ttl_inherit = true;
 		else
-			*ttl_inherit = false;
+			cfg->ttl_inherit = false;
 	} else if (data[IFLA_GENEVE_TTL]) {
 		info->key.ttl = nla_get_u8(data[IFLA_GENEVE_TTL]);
-		*ttl_inherit = false;
+		cfg->ttl_inherit = false;
 	}
 
 	if (data[IFLA_GENEVE_TOS])
 		info->key.tos = nla_get_u8(data[IFLA_GENEVE_TOS]);
 
 	if (data[IFLA_GENEVE_DF])
-		*df = nla_get_u8(data[IFLA_GENEVE_DF]);
+		cfg->df = nla_get_u8(data[IFLA_GENEVE_DF]);
 
 	if (data[IFLA_GENEVE_LABEL]) {
 		info->key.label = nla_get_be32(data[IFLA_GENEVE_LABEL]) &
@@ -1443,7 +1441,7 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 			attrtype = IFLA_GENEVE_COLLECT_METADATA;
 			goto change_notsup;
 		}
-		*metadata = true;
+		cfg->collect_md = true;
 	}
 
 	if (data[IFLA_GENEVE_UDP_CSUM]) {
@@ -1477,7 +1475,7 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 			goto change_notsup;
 		}
 		if (nla_get_u8(data[IFLA_GENEVE_UDP_ZERO_CSUM6_RX]))
-			*use_udp6_rx_checksums = false;
+			cfg->use_udp6_rx_checksums = false;
 #else
 		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_GENEVE_UDP_ZERO_CSUM6_RX],
 				    "IPv6 support not enabled in the kernel");
@@ -1542,25 +1540,24 @@ static int geneve_newlink(struct net *net, struct net_device *dev,
 			  struct nlattr *tb[], struct nlattr *data[],
 			  struct netlink_ext_ack *extack)
 {
-	enum ifla_geneve_df df = GENEVE_DF_UNSET;
-	bool use_udp6_rx_checksums = false;
-	struct ip_tunnel_info info;
-	bool ttl_inherit = false;
-	bool metadata = false;
+	struct geneve_config cfg = {
+		.df = GENEVE_DF_UNSET,
+		.use_udp6_rx_checksums = false,
+		.ttl_inherit = false,
+		.collect_md = false,
+	};
 	int err;
 
-	init_tnl_info(&info, GENEVE_UDP_PORT);
-	err = geneve_nl2info(tb, data, extack, &info, &metadata,
-			     &use_udp6_rx_checksums, &ttl_inherit, &df, false);
+	init_tnl_info(&cfg.info, GENEVE_UDP_PORT);
+	err = geneve_nl2info(tb, data, extack, &cfg, false);
 	if (err)
 		return err;
 
-	err = geneve_configure(net, dev, extack, &info, metadata,
-			       use_udp6_rx_checksums, ttl_inherit, df);
+	err = geneve_configure(net, dev, extack, &cfg);
 	if (err)
 		return err;
 
-	geneve_link_config(dev, &info, tb);
+	geneve_link_config(dev, &cfg.info, tb);
 
 	return 0;
 }
@@ -1616,40 +1613,28 @@ static int geneve_changelink(struct net_device *dev, struct nlattr *tb[],
 {
 	struct geneve_dev *geneve = netdev_priv(dev);
 	struct geneve_sock *gs4, *gs6;
-	struct ip_tunnel_info info;
-	bool metadata;
-	bool use_udp6_rx_checksums;
-	enum ifla_geneve_df df;
-	bool ttl_inherit;
+	struct geneve_config cfg;
 	int err;
 
 	/* If the geneve device is configured for metadata (or externally
 	 * controlled, for example, OVS), then nothing can be changed.
 	 */
-	if (geneve->collect_md)
+	if (geneve->cfg.collect_md)
 		return -EOPNOTSUPP;
 
 	/* Start with the existing info. */
-	memcpy(&info, &geneve->info, sizeof(info));
-	metadata = geneve->collect_md;
-	use_udp6_rx_checksums = geneve->use_udp6_rx_checksums;
-	ttl_inherit = geneve->ttl_inherit;
-	err = geneve_nl2info(tb, data, extack, &info, &metadata,
-			     &use_udp6_rx_checksums, &ttl_inherit, &df, true);
+	memcpy(&cfg, &geneve->cfg, sizeof(cfg));
+	err = geneve_nl2info(tb, data, extack, &cfg, true);
 	if (err)
 		return err;
 
-	if (!geneve_dst_addr_equal(&geneve->info, &info)) {
-		dst_cache_reset(&info.dst_cache);
-		geneve_link_config(dev, &info, tb);
+	if (!geneve_dst_addr_equal(&geneve->cfg.info, &cfg.info)) {
+		dst_cache_reset(&cfg.info.dst_cache);
+		geneve_link_config(dev, &cfg.info, tb);
 	}
 
 	geneve_quiesce(geneve, &gs4, &gs6);
-	geneve->info = info;
-	geneve->collect_md = metadata;
-	geneve->use_udp6_rx_checksums = use_udp6_rx_checksums;
-	geneve->ttl_inherit = ttl_inherit;
-	geneve->df = df;
+	memcpy(&geneve->cfg, &cfg, sizeof(cfg));
 	geneve_unquiesce(geneve, gs4, gs6);
 
 	return 0;
@@ -1683,9 +1668,9 @@ static size_t geneve_get_size(const struct net_device *dev)
 static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct geneve_dev *geneve = netdev_priv(dev);
-	struct ip_tunnel_info *info = &geneve->info;
-	bool ttl_inherit = geneve->ttl_inherit;
-	bool metadata = geneve->collect_md;
+	struct ip_tunnel_info *info = &geneve->cfg.info;
+	bool ttl_inherit = geneve->cfg.ttl_inherit;
+	bool metadata = geneve->cfg.collect_md;
 	__u8 tmp_vni[3];
 	__u32 vni;
 
@@ -1718,7 +1703,7 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put_be32(skb, IFLA_GENEVE_LABEL, info->key.label))
 		goto nla_put_failure;
 
-	if (nla_put_u8(skb, IFLA_GENEVE_DF, geneve->df))
+	if (nla_put_u8(skb, IFLA_GENEVE_DF, geneve->cfg.df))
 		goto nla_put_failure;
 
 	if (nla_put_be16(skb, IFLA_GENEVE_PORT, info->key.tp_dst))
@@ -1729,7 +1714,7 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (nla_put_u8(skb, IFLA_GENEVE_UDP_ZERO_CSUM6_RX,
-		       !geneve->use_udp6_rx_checksums))
+		       !geneve->cfg.use_udp6_rx_checksums))
 		goto nla_put_failure;
 #endif
 
@@ -1760,10 +1745,15 @@ struct net_device *geneve_dev_create_fb(struct net *net, const char *name,
 					u8 name_assign_type, u16 dst_port)
 {
 	struct nlattr *tb[IFLA_MAX + 1];
-	struct ip_tunnel_info info;
 	struct net_device *dev;
 	LIST_HEAD(list_kill);
 	int err;
+	struct geneve_config cfg = {
+		.df = GENEVE_DF_UNSET,
+		.use_udp6_rx_checksums = true,
+		.ttl_inherit = false,
+		.collect_md = true,
+	};
 
 	memset(tb, 0, sizeof(tb));
 	dev = rtnl_create_link(net, name, name_assign_type,
@@ -1771,9 +1761,8 @@ struct net_device *geneve_dev_create_fb(struct net *net, const char *name,
 	if (IS_ERR(dev))
 		return dev;
 
-	init_tnl_info(&info, dst_port);
-	err = geneve_configure(net, dev, NULL, &info,
-			       true, true, false, GENEVE_DF_UNSET);
+	init_tnl_info(&cfg.info, dst_port);
+	err = geneve_configure(net, dev, NULL, &cfg);
 	if (err) {
 		free_netdev(dev);
 		return ERR_PTR(err);
-- 
2.27.0

