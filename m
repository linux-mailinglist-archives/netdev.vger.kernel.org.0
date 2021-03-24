Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B2C346EC5
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbhCXBbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbhCXBbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0D8FC0613D8;
        Tue, 23 Mar 2021 18:31:15 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 539F262C0E;
        Wed, 24 Mar 2021 02:31:06 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 09/24] netfilter: flowtable: use dev_fill_forward_path() to obtain egress device
Date:   Wed, 24 Mar 2021 02:30:40 +0100
Message-Id: <20210324013055.5619-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

In case of topology updates, if peer is moved to different bridge port,
the connection will time out, reconnect will result in a new entry with
the correct path. Snooping fdb updates would allow for cleaning up stale
flowtable entries.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: resolve conflicts from rebasing on top of net-next: dst_check() call
    for neigh and xfrm xmit types.

 include/net/netfilter/nf_flow_table.h | 16 ++++-
 net/netfilter/nf_flow_table_core.c    | 35 ++++++++---
 net/netfilter/nf_flow_table_ip.c      | 88 ++++++++++++++++++++-------
 net/netfilter/nft_flow_offload.c      | 35 +++++++++--
 4 files changed, 137 insertions(+), 37 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index dca9fc66405f..41c8436bc77e 100644
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
index 51e3e1b08e1c..a92acb3ed019 100644
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
index e9bef38a356b..9e84767a7e9b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -207,6 +207,24 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
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
@@ -222,6 +240,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	struct iphdr *iph;
 	__be32 nexthop;
 	u32 hdrsize;
+	int ret;
 
 	if (skb->protocol != htons(ETH_P_IP))
 		return NF_ACCEPT;
@@ -244,9 +263,13 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
-	if (!dst_check(&rt->dst, 0)) {
-		flow_offload_teardown(flow);
-		return NF_ACCEPT;
+	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
+	    tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
+		rt = (struct rtable *)tuplehash->tuple.dst_cache;
+		if (!dst_check(&rt->dst, 0)) {
+			flow_offload_teardown(flow);
+			return NF_ACCEPT;
+		}
 	}
 
 	if (skb_try_make_writable(skb, thoff + hdrsize))
@@ -263,8 +286,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
-	rt = (struct rtable *)tuplehash->tuple.dst_cache;
-
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
 		IPCB(skb)->iif = skb->dev->ifindex;
@@ -272,13 +293,23 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
 	}
 
-	outdev = rt->dst.dev;
-	skb->dev = outdev;
-	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+	switch (tuplehash->tuple.xmit_type) {
+	case FLOW_OFFLOAD_XMIT_NEIGH:
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
 
@@ -444,6 +475,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	struct ipv6hdr *ip6h;
 	struct rt6_info *rt;
 	u32 hdrsize;
+	int ret;
 
 	if (skb->protocol != htons(ETH_P_IPV6))
 		return NF_ACCEPT;
@@ -465,9 +497,13 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				sizeof(*ip6h)))
 		return NF_ACCEPT;
 
-	if (!dst_check(&rt->dst, 0)) {
-		flow_offload_teardown(flow);
-		return NF_ACCEPT;
+	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
+	    tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
+		rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
+		if (!dst_check(&rt->dst, 0)) {
+			flow_offload_teardown(flow);
+			return NF_ACCEPT;
+		}
 	}
 
 	if (skb_try_make_writable(skb, sizeof(*ip6h) + hdrsize))
@@ -484,8 +520,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
-	rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
-
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 		IP6CB(skb)->iif = skb->dev->ifindex;
@@ -493,12 +527,22 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
 	}
 
-	outdev = rt->dst.dev;
-	skb->dev = outdev;
-	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
+	switch (tuplehash->tuple.xmit_type) {
+	case FLOW_OFFLOAD_XMIT_NEIGH:
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
index 15f90c31feb0..a6595dca1b1f 100644
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
 
@@ -66,27 +65,43 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 
 struct nft_forward_info {
 	const struct net_device *indev;
+	const struct net_device *outdev;
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
 
+	memcpy(info->h_dest, ha, ETH_ALEN);
+
 	for (i = 0; i < stack->num_paths; i++) {
 		path = &stack->path[i];
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 			info->indev = path->dev;
+			if (is_zero_ether_addr(info->h_source))
+				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 			break;
-		case DEV_PATH_VLAN:
 		case DEV_PATH_BRIDGE:
+			if (is_zero_ether_addr(info->h_source))
+				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
+
+			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
+			break;
+		case DEV_PATH_VLAN:
 		default:
 			info->indev = NULL;
 			break;
 		}
 	}
+	if (!info->outdev)
+		info->outdev = info->indev;
 }
 
 static bool nft_flowtable_find_dev(const struct net_device *dev,
@@ -114,14 +129,22 @@ static void nft_dev_forward_path(struct nf_flow_route *route,
 	const struct dst_entry *dst = route->tuple[dir].dst;
 	struct net_device_path_stack stack;
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
+		memcpy(route->tuple[dir].out.h_source, info.h_source, ETH_ALEN);
+		memcpy(route->tuple[dir].out.h_dest, info.h_dest, ETH_ALEN);
+		route->tuple[dir].out.ifindex = info.outdev->ifindex;
+		route->tuple[dir].xmit_type = info.xmit_type;
+	}
 }
 
 static int nft_flow_route(const struct nft_pktinfo *pkt,
-- 
2.20.1

