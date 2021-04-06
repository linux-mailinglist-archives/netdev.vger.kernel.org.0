Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3699C3553BE
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344084AbhDFMXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:23:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34440 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343970AbhDFMWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:02 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B2EA663E62;
        Tue,  6 Apr 2021 14:21:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 11/28] netfilter: flowtable: dst_check() from garbage collector path
Date:   Tue,  6 Apr 2021 14:21:16 +0200
Message-Id: <20210406122133.1644-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move dst_check() to the garbage collector path. Stale routes trigger the
flow entry teardown state which makes affected flows go back to the
classic forwarding path to re-evaluate flow offloading.

IPv6 requires the dst cookie to work, store it in the flow_tuple,
otherwise dst_check() always fails.

Fixes: e5075c0badaa ("netfilter: flowtable: call dst_check() to fall back to classic forwarding")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  5 +++-
 net/netfilter/nf_flow_table_core.c    | 37 ++++++++++++++++++++++++++-
 net/netfilter/nf_flow_table_ip.c      | 22 +++-------------
 3 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 4d991c1e93ef..583b327d8fc0 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -129,7 +129,10 @@ struct flow_offload_tuple {
 					in_vlan_ingress:2;
 	u16				mtu;
 	union {
-		struct dst_entry	*dst_cache;
+		struct {
+			struct dst_entry *dst_cache;
+			u32		dst_cookie;
+		};
 		struct {
 			u32		ifidx;
 			u32		hw_ifidx;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1bce1d2805c4..76573bae6664 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -74,6 +74,18 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(flow_offload_alloc);
 
+static u32 flow_offload_dst_cookie(struct flow_offload_tuple *flow_tuple)
+{
+	const struct rt6_info *rt;
+
+	if (flow_tuple->l3proto == NFPROTO_IPV6) {
+		rt = (const struct rt6_info *)flow_tuple->dst_cache;
+		return rt6_get_cookie(rt);
+	}
+
+	return 0;
+}
+
 static int flow_offload_fill_route(struct flow_offload *flow,
 				   const struct nf_flow_route *route,
 				   enum flow_offload_tuple_dir dir)
@@ -116,6 +128,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 			return -1;
 
 		flow_tuple->dst_cache = dst;
+		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
 		break;
 	}
 	flow_tuple->xmit_type = route->tuple[dir].xmit_type;
@@ -390,11 +403,33 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 	return err;
 }
 
+static bool flow_offload_stale_dst(struct flow_offload_tuple *tuple)
+{
+	struct dst_entry *dst;
+
+	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
+	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
+		dst = tuple->dst_cache;
+		if (!dst_check(dst, tuple->dst_cookie))
+			return true;
+	}
+
+	return false;
+}
+
+static bool nf_flow_has_stale_dst(struct flow_offload *flow)
+{
+	return flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
+	       flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple);
+}
+
 static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
 
-	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct))
+	if (nf_flow_has_expired(flow) ||
+	    nf_ct_is_dying(flow->ct) ||
+	    nf_flow_has_stale_dst(flow))
 		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 12cb0cc6958c..889cf88d3dba 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -364,15 +364,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
-	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
-	    tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
-		rt = (struct rtable *)tuplehash->tuple.dst_cache;
-		if (!dst_check(&rt->dst, 0)) {
-			flow_offload_teardown(flow);
-			return NF_ACCEPT;
-		}
-	}
-
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
@@ -391,6 +382,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
+		rt = (struct rtable *)tuplehash->tuple.dst_cache;
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
 		IPCB(skb)->iif = skb->dev->ifindex;
 		IPCB(skb)->flags = IPSKB_FORWARDED;
@@ -399,6 +391,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
+		rt = (struct rtable *)tuplehash->tuple.dst_cache;
 		outdev = rt->dst.dev;
 		skb->dev = outdev;
 		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
@@ -607,15 +600,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
 		return NF_ACCEPT;
 
-	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
-	    tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
-		rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
-		if (!dst_check(&rt->dst, 0)) {
-			flow_offload_teardown(flow);
-			return NF_ACCEPT;
-		}
-	}
-
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
@@ -633,6 +617,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
+		rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 		IP6CB(skb)->iif = skb->dev->ifindex;
 		IP6CB(skb)->flags = IP6SKB_FORWARDED;
@@ -641,6 +626,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
+		rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
 		outdev = rt->dst.dev;
 		skb->dev = outdev;
 		nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
-- 
2.30.2

