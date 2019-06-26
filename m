Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DF6566CD
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfFZKcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:32:35 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:53390 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZKcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:32:35 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id E7325E019FB;
        Wed, 26 Jun 2019 18:32:29 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/3 nf-next] netfilter:nf_flow_table: Support bridge type flow offload
Date:   Wed, 26 Jun 2019 18:32:27 +0800
Message-Id: <1561545148-11978-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
References: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS05MQkJCQk1DTklDTE5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NE06SQw5Ljg5GBQUNAohMC0I
        PRMKCx5VSlVKTk1KTk9OSk5LSklJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpISExKNwY+
X-HM-Tid: 0a6b93580e3220bdkuqye7325e019fb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

With nf_conntrack_bridge function. The bridge family can do
conntrack it self. The flow offload function based on the
conntrack. So the flow in the bridge wih conntrack can be
offloaded.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_flow_table.h | 30 +++++++++++-
 net/netfilter/nf_flow_table_core.c    | 53 ++++++++++++++++-----
 net/netfilter/nf_flow_table_ip.c      | 41 +++++++++++++---
 net/netfilter/nft_flow_offload.c      | 89 ++++++++++++++++++++++++++++++++---
 4 files changed, 185 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 968be64..9a0cf27 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -33,8 +33,22 @@ enum flow_offload_tuple_dir {
 	FLOW_OFFLOAD_DIR_MAX = IP_CT_DIR_MAX
 };
 
+enum flow_offload_tuple_type {
+	FLOW_OFFLOAD_TYPE_INET,
+	FLOW_OFFLOAD_TYPE_BRIDGE,
+};
+
+struct dst_br_port {
+	struct net_device *dev;
+	u16	dst_vlan_tag;
+};
+
 struct flow_offload_dst {
-	struct dst_entry		*dst_cache;
+	enum flow_offload_tuple_type type;
+	union {
+		struct dst_entry		*dst_cache;
+		struct dst_br_port		dst_port;
+	};
 };
 
 struct flow_offload_tuple {
@@ -52,6 +66,7 @@ struct flow_offload_tuple {
 	};
 
 	int				iifidx;
+	u16				vlan_tag;
 
 	u8				l3proto;
 	u8				l4proto;
@@ -89,8 +104,19 @@ struct nf_flow_route {
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
 };
 
+struct nf_flow_forward {
+	struct {
+		struct dst_br_port	dst_port;
+		u16 vlan_tag;
+	} tuple[FLOW_OFFLOAD_DIR_MAX];
+};
+
 struct nf_flow_data {
-	struct nf_flow_route route;
+	enum flow_offload_tuple_type type;
+	union {
+		struct nf_flow_route route;
+		struct nf_flow_forward forward;
+	};
 };
 
 struct flow_offload *flow_offload_alloc(struct nf_conn *ct,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 125ce1c..19ee69c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -29,16 +29,38 @@ struct flow_offload_entry {
 {
 	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
 	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
-	struct dst_entry *other_dst = date->route.tuple[!dir].dst;
-	struct dst_entry *dst = data->route.tuple[dir].dst;
 
+	struct dst_entry *other_dst;
+	struct dst_entry *dst;
+	struct dst_br_port other_dst_port;
+	struct dst_br_port dst_port;
+
+	if (data->type == FLOW_OFFLOAD_TYPE_BRIDGE) {
+		other_dst_port = data->forward.tuple[!dir].dst_port;
+		dst_port = data->forward.tuple[dir].dst_port;
+
+		ft->iifidx = other_dst_port.dev->ifindex;
+		ft->dst.dst_port = dst_port;
+		ft->vlan_tag = data->forward.tuple[dir].vlan_tag;
+	} else {
+		other_dst = data->route.tuple[!dir].dst;
+		dst = data->route.tuple[dir].dst;
+
+		ft->iifidx = other_dst->dev->ifindex;
+		ft->dst.dst_cache = dst;
+	}
+
+	ft->dst.type = data->type;
 	ft->dir = dir;
 
 	switch (ctt->src.l3num) {
 	case NFPROTO_IPV4:
 		ft->src_v4 = ctt->src.u3.in;
 		ft->dst_v4 = ctt->dst.u3.in;
-		ft->mtu = ip_dst_mtu_maybe_forward(dst, true);
+		if (data->type == FLOW_OFFLOAD_TYPE_BRIDGE)
+			ft->mtu = dst_port.dev->mtu;
+		else
+			ft->mtu = ip_dst_mtu_maybe_forward(dst, true);
 		break;
 	case NFPROTO_IPV6:
 		ft->src_v6 = ctt->src.u3.in6;
@@ -51,9 +73,6 @@ struct flow_offload_entry {
 	ft->l4proto = ctt->dst.protonum;
 	ft->src_port = ctt->src.u.tcp.port;
 	ft->dst_port = ctt->dst.u.tcp.port;
-
-	ft->iifidx = other_dst->dev->ifindex;
-	ft->dst_cache = dst;
 }
 
 struct flow_offload *
@@ -72,11 +91,13 @@ struct flow_offload *
 
 	flow = &entry->flow;
 
-	if (!dst_hold_safe(data->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
-		goto err_dst_cache_original;
+	if (data->type == FLOW_OFFLOAD_TYPE_INET) {
+		if (!dst_hold_safe(data->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
+			goto err_dst_cache_original;
 
-	if (!dst_hold_safe(data->route.tuple[FLOW_OFFLOAD_DIR_REPLY].dst))
-		goto err_dst_cache_reply;
+		if (!dst_hold_safe(data->route.tuple[FLOW_OFFLOAD_DIR_REPLY].dst))
+			goto err_dst_cache_reply;
+	}
 
 	entry->ct = ct;
 
@@ -91,7 +112,8 @@ struct flow_offload *
 	return flow;
 
 err_dst_cache_reply:
-	dst_release(data->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
+	if (data->type == FLOW_OFFLOAD_TYPE_INET)
+		dst_release(data->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
 err_dst_cache_original:
 	kfree(entry);
 err_ct_refcnt:
@@ -139,8 +161,13 @@ void flow_offload_free(struct flow_offload *flow)
 {
 	struct flow_offload_entry *e;
 
-	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.dst_cache);
-	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst.dst_cache);
+	if (flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.type == FLOW_OFFLOAD_TYPE_INET) {
+		dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.dst_cache);
+		dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst.dst_cache);
+	} else {
+		dev_put(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.dst_port.dev);
+		dev_put(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst.dst_port.dev);
+	}
 	e = container_of(flow, struct flow_offload_entry, flow);
 	if (flow->flags & FLOW_OFFLOAD_DYING)
 		nf_ct_delete(e->ct, 0, 0);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 0016bb8..9af01ef 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -16,6 +16,8 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 
+#include "../bridge/br_private.h"
+
 static int nf_flow_state_check(struct flow_offload *flow, int proto,
 			       struct sk_buff *skb, unsigned int thoff)
 {
@@ -220,6 +222,7 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct nf_flowtable *flow_table = priv;
+	int family = flow_table->type->family;
 	struct flow_offload_tuple tuple = {};
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
@@ -228,6 +231,7 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	unsigned int thoff;
 	struct iphdr *iph;
 	__be32 nexthop;
+	u16 vlan_tag;
 
 	if (skb->protocol != htons(ETH_P_IP))
 		return NF_ACCEPT;
@@ -235,14 +239,25 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	if (nf_flow_tuple_ip(skb, state->in, &tuple) < 0)
 		return NF_ACCEPT;
 
+	if (family != NFPROTO_BRIDGE && family != NFPROTO_IPV4)
+		return NF_ACCEPT;
+
+	if (family == NFPROTO_BRIDGE && skb_vlan_tag_present(skb))
+		tuple.vlan_tag = skb_vlan_tag_get_id(skb);
+
 	tuplehash = flow_offload_lookup(flow_table, &tuple);
 	if (tuplehash == NULL)
 		return NF_ACCEPT;
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst.dst_cache;
-	outdev = rt->dst.dev;
+	if (family == NFPROTO_IPV4) {
+		rt = (struct rtable *)flow->tuplehash[dir].tuple.dst.dst_cache;
+		outdev = rt->dst.dev;
+	} else {
+		vlan_tag = flow->tuplehash[dir].tuple.dst.dst_port.dst_vlan_tag;
+		outdev = flow->tuplehash[dir].tuple.dst.dst_port.dev;
+	}
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
@@ -258,13 +273,25 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 		return NF_DROP;
 
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
-	iph = ip_hdr(skb);
-	ip_decrease_ttl(iph);
 
 	skb->dev = outdev;
-	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+	if (family == NFPROTO_IPV4) {
+		iph = ip_hdr(skb);
+		ip_decrease_ttl(iph);
+
+		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
+		skb_dst_set_noref(skb, &rt->dst);
+		neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+	} else {
+		const struct net_bridge_port *p;
+
+		if (vlan_tag && (p = br_port_get_rtnl_rcu(state->in)))
+			__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, vlan_tag);
+		else
+			__vlan_hwaccel_clear_tag(skb);
+
+		br_dev_queue_push_xmit(state->net, state->sk, skb);
+	}
 
 	return NF_STOLEN;
 }
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index cdb7c46..c88396a 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -14,6 +14,8 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <net/netfilter/nf_flow_table.h>
 
+#include "../bridge/br_private.h"
+
 struct nft_flow_offload {
 	struct nft_flowtable	*flowtable;
 };
@@ -49,6 +51,58 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	return 0;
 }
 
+static int nft_flow_forward(const struct nft_pktinfo *pkt,
+			    const struct nf_conn *ct,
+			    struct nf_flow_forward *forward,
+			    enum ip_conntrack_dir dir)
+{
+	struct net_bridge_vlan_group *vg;
+	const struct net_bridge_port *p;
+	u16 vid = 0;
+
+	if (skb_vlan_tag_present(pkt->skb))
+		vid = skb_vlan_tag_get_id(pkt->skb);
+
+	forward->tuple[dir].dst_port.dst_vlan_tag = vid;
+	forward->tuple[!dir].vlan_tag = vid;
+	forward->tuple[dir].dst_port.dev = dev_get_by_index(dev_net(nft_out(pkt)),
+							    nft_out(pkt)->ifindex);
+	forward->tuple[!dir].dst_port.dev = dev_get_by_index(dev_net(nft_in(pkt)),
+							     nft_in(pkt)->ifindex);
+
+	rtnl_lock();
+	p = br_port_get_rtnl_rcu(nft_out(pkt));
+	if (p) {
+		if (!br_opt_get(p->br, BROPT_VLAN_ENABLED))
+			goto out;
+
+		if (!vid) {
+			vg = nbp_vlan_group_rcu(p);
+			vid = br_get_pvid(vg);
+		}
+
+		if (vid) {
+			struct bridge_vlan_info info;
+
+			if (br_vlan_get_info(nft_in(pkt), vid, &info) == 0 &&
+			    info.flags & BRIDGE_VLAN_INFO_UNTAGGED)
+				vid = 0;
+		}
+	} else {
+		rtnl_unlock();
+		dev_put(forward->tuple[dir].dst_port.dev);
+		dev_put(forward->tuple[!dir].dst_port.dev);
+		return -ENOENT;
+	}
+
+out:
+	rtnl_unlock();
+	forward->tuple[!dir].dst_port.dst_vlan_tag = vid;
+	forward->tuple[dir].vlan_tag = vid;
+
+	return 0;
+}
+
 static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 {
 	if (skb_sec_path(skb))
@@ -61,6 +115,15 @@ static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 
 		if (unlikely(opt->optlen))
 			return true;
+	} else if (family == NFPROTO_BRIDGE) {
+		const struct iphdr *iph;
+
+		if (skb->protocol != htons(ETH_P_IP))
+			return true;
+
+		iph = ip_hdr(skb);
+		if (iph->ihl > 5)
+			return true;
 	}
 
 	return false;
@@ -76,11 +139,12 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct nf_flow_data data;
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
+	int family = nft_pf(pkt);
 	bool is_tcp = false;
 	struct nf_conn *ct;
 	int ret;
 
-	if (nft_flow_offload_skip(pkt->skb, nft_pf(pkt)))
+	if (nft_flow_offload_skip(pkt->skb, family))
 		goto out;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
@@ -108,8 +172,15 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto out;
 
 	dir = CTINFO2DIR(ctinfo);
-	if (nft_flow_route(pkt, ct, &data.route, dir) < 0)
-		goto err_flow_route;
+	if (family == NFPROTO_BRIDGE) {
+		data.type = FLOW_OFFLOAD_TYPE_BRIDGE;
+		if (nft_flow_forward(pkt, ct, &data.forward, dir) < 0)
+			goto err_flow_data;
+	} else {
+		data.type = FLOW_OFFLOAD_TYPE_INET;
+		if (nft_flow_route(pkt, ct, &data.route, dir) < 0)
+			goto err_flow_data;
+	}
 
 	flow = flow_offload_alloc(ct, &data);
 	if (!flow)
@@ -124,14 +195,20 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err_flow_add;
 
-	dst_release(data.route.tuple[!dir].dst);
+	if (family != NFPROTO_BRIDGE)
+		dst_release(data.route.tuple[!dir].dst);
 	return;
 
 err_flow_add:
 	flow_offload_free(flow);
 err_flow_alloc:
-	dst_release(data.route.tuple[!dir].dst);
-err_flow_route:
+	if (family == NFPROTO_BRIDGE) {
+		dev_put(data.forward.tuple[dir].dst_port.dev);
+		dev_put(data.forward.tuple[!dir].dst_port.dev);
+	} else {
+		dst_release(data.route.tuple[!dir].dst);
+	}
+err_flow_data:
 	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
 out:
 	regs->verdict.code = NFT_BREAK;
-- 
1.8.3.1

