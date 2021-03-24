Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DCC346ECD
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbhCXBbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:31:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60566 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234486AbhCXBbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:31:17 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B1257630CA;
        Wed, 24 Mar 2021 02:31:05 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 08/24] netfilter: flowtable: use dev_fill_forward_path() to obtain ingress device
Date:   Wed, 24 Mar 2021 02:30:39 +0100
Message-Id: <20210324013055.5619-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Obtain the ingress device in the tuple from the route in the reply
direction. Use dev_fill_forward_path() instead to get the real ingress
device for this flow.

Fall back to use the ingress device that the IP forwarding route
provides if:

- dev_fill_forward_path() finds no real ingress device.
- the ingress device that is obtained is not part of the flowtable
  devices.
- this route has a xfrm policy.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/net/netfilter/nf_flow_table.h |   3 +
 net/netfilter/nf_flow_table_core.c    |   3 +-
 net/netfilter/nft_flow_offload.c      | 102 +++++++++++++++++++++++++-
 3 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 828fcfbd5e6f..dca9fc66405f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -165,6 +165,9 @@ static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
 struct nf_flow_route {
 	struct {
 		struct dst_entry		*dst;
+		struct {
+			u32			ifindex;
+		} in;
 		enum flow_offload_xmit_type	xmit_type;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
 };
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 573be4d1efb5..51e3e1b08e1c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -79,7 +79,6 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir)
 {
 	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
-	struct dst_entry *other_dst = route->tuple[!dir].dst;
 	struct dst_entry *dst = route->tuple[dir].dst;
 
 	if (!dst_hold_safe(route->tuple[dir].dst))
@@ -94,7 +93,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		break;
 	}
 
-	flow_tuple->iifidx = other_dst->dev->ifindex;
+	flow_tuple->iifidx = route->tuple[dir].in.ifindex;
 	flow_tuple->xmit_type = route->tuple[dir].xmit_type;
 	flow_tuple->dst_cache = dst;
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 1da2bb24f6c0..15f90c31feb0 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -31,14 +31,104 @@ static void nft_default_forward_path(struct nf_flow_route *route,
 				     struct dst_entry *dst_cache,
 				     enum ip_conntrack_dir dir)
 {
+	route->tuple[!dir].in.ifindex	= dst_cache->dev->ifindex;
 	route->tuple[dir].dst		= dst_cache;
 	route->tuple[dir].xmit_type	= nft_xmit_type(dst_cache);
 }
 
+static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
+				     const struct dst_entry *dst_cache,
+				     const struct nf_conn *ct,
+				     enum ip_conntrack_dir dir,
+				     struct net_device_path_stack *stack)
+{
+	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
+	struct net_device *dev = dst_cache->dev;
+	unsigned char ha[ETH_ALEN];
+	struct neighbour *n;
+	u8 nud_state;
+
+	n = dst_neigh_lookup(dst_cache, daddr);
+	if (!n)
+		return -1;
+
+	read_lock_bh(&n->lock);
+	nud_state = n->nud_state;
+	ether_addr_copy(ha, n->ha);
+	read_unlock_bh(&n->lock);
+	neigh_release(n);
+
+	if (!(nud_state & NUD_VALID))
+		return -1;
+
+	return dev_fill_forward_path(dev, ha, stack);
+}
+
+struct nft_forward_info {
+	const struct net_device *indev;
+};
+
+static void nft_dev_path_info(const struct net_device_path_stack *stack,
+			      struct nft_forward_info *info)
+{
+	const struct net_device_path *path;
+	int i;
+
+	for (i = 0; i < stack->num_paths; i++) {
+		path = &stack->path[i];
+		switch (path->type) {
+		case DEV_PATH_ETHERNET:
+			info->indev = path->dev;
+			break;
+		case DEV_PATH_VLAN:
+		case DEV_PATH_BRIDGE:
+		default:
+			info->indev = NULL;
+			break;
+		}
+	}
+}
+
+static bool nft_flowtable_find_dev(const struct net_device *dev,
+				   struct nft_flowtable *ft)
+{
+	struct nft_hook *hook;
+	bool found = false;
+
+	list_for_each_entry_rcu(hook, &ft->hook_list, list) {
+		if (hook->ops.dev != dev)
+			continue;
+
+		found = true;
+		break;
+	}
+
+	return found;
+}
+
+static void nft_dev_forward_path(struct nf_flow_route *route,
+				 const struct nf_conn *ct,
+				 enum ip_conntrack_dir dir,
+				 struct nft_flowtable *ft)
+{
+	const struct dst_entry *dst = route->tuple[dir].dst;
+	struct net_device_path_stack stack;
+	struct nft_forward_info info = {};
+
+	if (nft_dev_fill_forward_path(route, dst, ct, dir, &stack) >= 0)
+		nft_dev_path_info(&stack, &info);
+
+	if (!info.indev || !nft_flowtable_find_dev(info.indev, ft))
+		return;
+
+	route->tuple[!dir].in.ifindex = info.indev->ifindex;
+}
+
 static int nft_flow_route(const struct nft_pktinfo *pkt,
 			  const struct nf_conn *ct,
 			  struct nf_flow_route *route,
-			  enum ip_conntrack_dir dir)
+			  enum ip_conntrack_dir dir,
+			  struct nft_flowtable *ft)
 {
 	struct dst_entry *this_dst = skb_dst(pkt->skb);
 	struct dst_entry *other_dst = NULL;
@@ -63,6 +153,12 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	nft_default_forward_path(route, this_dst, dir);
 	nft_default_forward_path(route, other_dst, !dir);
 
+	if (route->tuple[dir].xmit_type	== FLOW_OFFLOAD_XMIT_NEIGH &&
+	    route->tuple[!dir].xmit_type == FLOW_OFFLOAD_XMIT_NEIGH) {
+		nft_dev_forward_path(route, ct, dir, ft);
+		nft_dev_forward_path(route, ct, !dir, ft);
+	}
+
 	return 0;
 }
 
@@ -90,8 +186,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
 	struct tcphdr _tcph, *tcph = NULL;
+	struct nf_flow_route route = {};
 	enum ip_conntrack_info ctinfo;
-	struct nf_flow_route route;
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
 	struct nf_conn *ct;
@@ -128,7 +224,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto out;
 
 	dir = CTINFO2DIR(ctinfo);
-	if (nft_flow_route(pkt, ct, &route, dir) < 0)
+	if (nft_flow_route(pkt, ct, &route, dir, priv->flowtable) < 0)
 		goto err_flow_route;
 
 	flow = flow_offload_alloc(ct);
-- 
2.20.1

