Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14312AF927
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbgKKTiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:38:13 -0500
Received: from correo.us.es ([193.147.175.20]:45190 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbgKKTiI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 14:38:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1FF521878C8
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12996DA72F
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11880DA722; Wed, 11 Nov 2020 20:38:05 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78CE6DA84B;
        Wed, 11 Nov 2020 20:38:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Nov 2020 20:38:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 3EC6642EF9E1;
        Wed, 11 Nov 2020 20:38:02 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        razor@blackwall.org, jeremy@azazel.net
Subject: [PATCH net-next,v3 7/9] netfilter: flowtable: use dev_fill_forward_path() to obtain egress device
Date:   Wed, 11 Nov 2020 20:37:35 +0100
Message-Id: <20201111193737.1793-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201111193737.1793-1-pablo@netfilter.org>
References: <20201111193737.1793-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The egress device in the tuple is obtained from route. Use
dev_fill_forward_path() instead to provide the real egress device for
this flow whenever this is available.

The new FLOW_OFFLOAD_XMIT_DIRECT type uses dev_queue_xmit() to transmit
ethernet frames. Cache the source and destination hardware address to
use dev_queue_xmit() to transfer packets.

The FLOW_OFFLOAD_XMIT_DIRECT replaces FLOW_OFFLOAD_XMIT_NEIGH if
dev_fill_forward_path() finds a direct transmit path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 16 +++++-
 net/netfilter/nf_flow_table_core.c    | 35 ++++++++++---
 net/netfilter/nf_flow_table_ip.c      | 72 +++++++++++++++++++++------
 net/netfilter/nft_flow_offload.c      | 25 ++++++++--
 4 files changed, 118 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 963f99fb1c06..83110e4705c0 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -92,6 +92,7 @@ enum flow_offload_tuple_dir {
 enum flow_offload_xmit_type {
 	FLOW_OFFLOAD_XMIT_NEIGH		= 0,
 	FLOW_OFFLOAD_XMIT_XFRM,
+	FLOW_OFFLOAD_XMIT_DIRECT,
 };
 
 struct flow_offload_tuple {
@@ -120,8 +121,14 @@ struct flow_offload_tuple {
 					xmit_type:2;
 
 	u16				mtu;
-
-	struct dst_entry		*dst_cache;
+	union {
+		struct dst_entry	*dst_cache;
+		struct {
+			u32		ifidx;
+			u8		h_source[ETH_ALEN];
+			u8		h_dest[ETH_ALEN];
+		} out;
+	};
 };
 
 struct flow_offload_tuple_rhash {
@@ -168,6 +175,11 @@ struct nf_flow_route {
 		struct {
 			u32			ifindex;
 		} in;
+		struct {
+			u32			ifindex;
+			u8			h_source[ETH_ALEN];
+			u8			h_dest[ETH_ALEN];
+		} out;
 		enum flow_offload_xmit_type	xmit_type;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
 };
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 27b4315d7b96..751bc1c27c16 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -81,9 +81,6 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
 	struct dst_entry *dst = route->tuple[dir].dst;
 
-	if (!dst_hold_safe(route->tuple[dir].dst))
-		return -1;
-
 	switch (flow_tuple->l3proto) {
 	case NFPROTO_IPV4:
 		flow_tuple->mtu = ip_dst_mtu_maybe_forward(dst, true);
@@ -94,12 +91,36 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	}
 
 	flow_tuple->iifidx = route->tuple[dir].in.ifindex;
+
+	switch (route->tuple[dir].xmit_type) {
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		memcpy(flow_tuple->out.h_dest, route->tuple[dir].out.h_dest,
+		       ETH_ALEN);
+		memcpy(flow_tuple->out.h_source, route->tuple[dir].out.h_source,
+		       ETH_ALEN);
+		flow_tuple->out.ifidx = route->tuple[dir].out.ifindex;
+		break;
+	case FLOW_OFFLOAD_XMIT_XFRM:
+	case FLOW_OFFLOAD_XMIT_NEIGH:
+		if (!dst_hold_safe(route->tuple[dir].dst))
+			return -1;
+
+		flow_tuple->dst_cache = dst;
+		break;
+	}
 	flow_tuple->xmit_type = route->tuple[dir].xmit_type;
-	flow_tuple->dst_cache = dst;
 
 	return 0;
 }
 
+static void nft_flow_dst_release(struct flow_offload *flow,
+				 enum flow_offload_tuple_dir dir)
+{
+	if (flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
+	    flow->tuplehash[dir].tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)
+		dst_release(flow->tuplehash[dir].tuple.dst_cache);
+}
+
 int flow_offload_route_init(struct flow_offload *flow,
 			    const struct nf_flow_route *route)
 {
@@ -118,7 +139,7 @@ int flow_offload_route_init(struct flow_offload *flow,
 	return 0;
 
 err_route_reply:
-	dst_release(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
+	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
 
 	return err;
 }
@@ -169,8 +190,8 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 
 static void flow_offload_route_release(struct flow_offload *flow)
 {
-	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_cache);
-	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_cache);
+	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
+	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_REPLY);
 }
 
 void flow_offload_free(struct flow_offload *flow)
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 03314cc06e04..d10ba09a41b5 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -248,6 +248,24 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
+static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
+				       const struct flow_offload_tuple_rhash *tuplehash,
+				       unsigned short type)
+{
+	struct net_device *outdev;
+
+	outdev = dev_get_by_index_rcu(net, tuplehash->tuple.out.ifidx);
+	if (!outdev)
+		return NF_DROP;
+
+	skb->dev = outdev;
+	dev_hard_header(skb, skb->dev, type, tuplehash->tuple.out.h_dest,
+			tuplehash->tuple.out.h_source, skb->len);
+	dev_queue_xmit(skb);
+
+	return NF_STOLEN;
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -262,6 +280,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	unsigned int thoff;
 	struct iphdr *iph;
 	__be32 nexthop;
+	int ret;
 
 	if (skb->protocol != htons(ETH_P_IP))
 		return NF_ACCEPT;
@@ -303,22 +322,32 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
-	rt = (struct rtable *)tuplehash->tuple.dst_cache;
-
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
+		rt = (struct rtable *)tuplehash->tuple.dst_cache;
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
 		IPCB(skb)->iif = skb->dev->ifindex;
 		IPCB(skb)->flags = IPSKB_FORWARDED;
 		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
 	}
 
-	outdev = rt->dst.dev;
-	skb->dev = outdev;
-	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+	switch (tuplehash->tuple.xmit_type) {
+	case FLOW_OFFLOAD_XMIT_NEIGH:
+		rt = (struct rtable *)tuplehash->tuple.dst_cache;
+		outdev = rt->dst.dev;
+		skb->dev = outdev;
+		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
+		skb_dst_set_noref(skb, &rt->dst);
+		neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+		ret = NF_STOLEN;
+		break;
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
+		if (ret == NF_DROP)
+			flow_offload_teardown(flow);
+		break;
+	}
 
-	return NF_STOLEN;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
 
@@ -504,6 +533,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	struct net_device *outdev;
 	struct ipv6hdr *ip6h;
 	struct rt6_info *rt;
+	int ret;
 
 	if (skb->protocol != htons(ETH_P_IPV6))
 		return NF_ACCEPT;
@@ -545,21 +575,31 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
-	rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
-
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH)) {
+		rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 		IP6CB(skb)->iif = skb->dev->ifindex;
 		IP6CB(skb)->flags = IP6SKB_FORWARDED;
 		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
 	}
 
-	outdev = rt->dst.dev;
-	skb->dev = outdev;
-	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
+	switch (tuplehash->tuple.xmit_type) {
+	case FLOW_OFFLOAD_XMIT_NEIGH:
+		rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
+		outdev = rt->dst.dev;
+		skb->dev = outdev;
+		nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
+		skb_dst_set_noref(skb, &rt->dst);
+		neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
+		ret = NF_STOLEN;
+		break;
+	case FLOW_OFFLOAD_XMIT_DIRECT:
+		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
+		if (ret == NF_DROP)
+			flow_offload_teardown(flow);
+		break;
+	}
 
-	return NF_STOLEN;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index cae53c56f957..849fc40786cf 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -39,12 +39,11 @@ static void nft_default_forward_path(struct nf_flow_route *route,
 static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 				     const struct dst_entry *dst_cache,
 				     const struct nf_conn *ct,
-				     enum ip_conntrack_dir dir,
+				     enum ip_conntrack_dir dir, u8 *ha,
 				     struct net_device_path_stack *stack)
 {
 	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
 	struct net_device *dev = dst_cache->dev;
-	unsigned char ha[ETH_ALEN];
 	struct neighbour *n;
 	u8 nud_state;
 
@@ -66,10 +65,14 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 
 struct nft_forward_info {
 	const struct net_device *indev;
+	u8 h_source[ETH_ALEN];
+	u8 h_dest[ETH_ALEN];
+	enum flow_offload_xmit_type xmit_type;
 };
 
 static void nft_dev_path_info(const struct net_device_path_stack *stack,
-			      struct nft_forward_info *info)
+			      struct nft_forward_info *info,
+			      unsigned char *ha)
 {
 	const struct net_device_path *path;
 	int i;
@@ -79,10 +82,14 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 			info->indev = path->dev;
+			memcpy(info->h_dest, path->dev->dev_addr, ETH_ALEN);
+			memcpy(info->h_source, ha, ETH_ALEN);
 			break;
 		case DEV_PATH_VLAN:
 			break;
 		case DEV_PATH_BRIDGE:
+			memcpy(info->h_dest, path->dev->dev_addr, ETH_ALEN);
+			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
 		}
 	}
@@ -113,14 +120,22 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 	const struct dst_entry *dst = route->tuple[dir].dst;
 	struct net_device_path_stack stack = {};
 	struct nft_forward_info info = {};
+	unsigned char ha[ETH_ALEN];
 
-	if (nft_dev_fill_forward_path(route, dst, ct, dir, &stack) >= 0)
-		nft_dev_path_info(&stack, &info);
+	if (nft_dev_fill_forward_path(route, dst, ct, dir, ha, &stack) >= 0)
+		nft_dev_path_info(&stack, &info, ha);
 
 	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
 		return;
 
 	route->tuple[!dir].in.ifindex = info.indev->ifindex;
+
+	if (info.xmit_type == FLOW_OFFLOAD_XMIT_DIRECT) {
+		memcpy(route->tuple[dir].out.h_dest, info.h_source, ETH_ALEN);
+		memcpy(route->tuple[dir].out.h_source, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.ifindex = info.indev->ifindex;
+		route->tuple[dir].xmit_type = info.xmit_type;
+	}
 }
 
 static int nft_flow_route(const struct nft_pktinfo *pkt,
-- 
2.20.1

