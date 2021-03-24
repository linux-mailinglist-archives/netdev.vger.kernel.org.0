Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081FA346ECF
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbhCXBb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:31:56 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60560 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbhCXBbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:17 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 18866630C3;
        Wed, 24 Mar 2021 02:31:05 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 07/24] netfilter: flowtable: add xmit path types
Date:   Wed, 24 Mar 2021 02:30:38 +0100
Message-Id: <20210324013055.5619-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the xmit_type field that defines the two supported xmit paths in the
flowtable data plane, which are the neighbour and the xfrm xmit paths.
This patch prepares for new flowtable xmit path types to come.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: resolve conflicts from rebasing on top of net-next: inconditional
    dst_check() call.

 include/net/netfilter/nf_flow_table.h | 11 +++++++++--
 net/netfilter/nf_flow_table_core.c    |  1 +
 net/netfilter/nf_flow_table_ip.c      | 14 ++++++++------
 net/netfilter/nft_flow_offload.c      | 20 ++++++++++++++++++--
 4 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index fb165697c8a1..828fcfbd5e6f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -89,6 +89,11 @@ enum flow_offload_tuple_dir {
 };
 #define FLOW_OFFLOAD_DIR_MAX	IP_CT_DIR_MAX
 
+enum flow_offload_xmit_type {
+	FLOW_OFFLOAD_XMIT_NEIGH		= 0,
+	FLOW_OFFLOAD_XMIT_XFRM,
+};
+
 struct flow_offload_tuple {
 	union {
 		struct in_addr		src_v4;
@@ -111,7 +116,8 @@ struct flow_offload_tuple {
 	/* All members above are keys for lookups, see flow_offload_hash(). */
 	struct { }			__hash;
 
-	u8				dir;
+	u8				dir:6,
+					xmit_type:2;
 
 	u16				mtu;
 
@@ -158,7 +164,8 @@ static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
 
 struct nf_flow_route {
 	struct {
-		struct dst_entry	*dst;
+		struct dst_entry		*dst;
+		enum flow_offload_xmit_type	xmit_type;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
 };
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8ffd3f3c288c..573be4d1efb5 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -95,6 +95,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	}
 
 	flow_tuple->iifidx = other_dst->dev->ifindex;
+	flow_tuple->xmit_type = route->tuple[dir].xmit_type;
 	flow_tuple->dst_cache = dst;
 
 	return 0;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3be58b6d60af..e9bef38a356b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -235,8 +235,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
-	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
@@ -265,13 +263,16 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
-	if (unlikely(dst_xfrm(&rt->dst))) {
+	rt = (struct rtable *)tuplehash->tuple.dst_cache;
+
+	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
 		IPCB(skb)->iif = skb->dev->ifindex;
 		IPCB(skb)->flags = IPSKB_FORWARDED;
 		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
 	}
 
+	outdev = rt->dst.dev;
 	skb->dev = outdev;
 	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
 	skb_dst_set_noref(skb, &rt->dst);
@@ -456,8 +457,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
-	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
@@ -485,13 +484,16 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
-	if (unlikely(dst_xfrm(&rt->dst))) {
+	rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
+
+	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 		IP6CB(skb)->iif = skb->dev->ifindex;
 		IP6CB(skb)->flags = IP6SKB_FORWARDED;
 		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
 	}
 
+	outdev = rt->dst.dev;
 	skb->dev = outdev;
 	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
 	skb_dst_set_noref(skb, &rt->dst);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 3a6c84fb2c90..1da2bb24f6c0 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -19,6 +19,22 @@ struct nft_flow_offload {
 	struct nft_flowtable	*flowtable;
 };
 
+static enum flow_offload_xmit_type nft_xmit_type(struct dst_entry *dst)
+{
+	if (dst_xfrm(dst))
+		return FLOW_OFFLOAD_XMIT_XFRM;
+
+	return FLOW_OFFLOAD_XMIT_NEIGH;
+}
+
+static void nft_default_forward_path(struct nf_flow_route *route,
+				     struct dst_entry *dst_cache,
+				     enum ip_conntrack_dir dir)
+{
+	route->tuple[dir].dst		= dst_cache;
+	route->tuple[dir].xmit_type	= nft_xmit_type(dst_cache);
+}
+
 static int nft_flow_route(const struct nft_pktinfo *pkt,
 			  const struct nf_conn *ct,
 			  struct nf_flow_route *route,
@@ -44,8 +60,8 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	if (!other_dst)
 		return -ENOENT;
 
-	route->tuple[dir].dst		= this_dst;
-	route->tuple[!dir].dst		= other_dst;
+	nft_default_forward_path(route, this_dst, dir);
+	nft_default_forward_path(route, other_dst, !dir);
 
 	return 0;
 }
-- 
2.20.1

