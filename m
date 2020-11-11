Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632752AF928
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgKKTiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:38:15 -0500
Received: from correo.us.es ([193.147.175.20]:45226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727497AbgKKTiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 14:38:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 801181878B4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72C0DDA84A
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 67C45DA84F; Wed, 11 Nov 2020 20:38:07 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1CB5DA84A;
        Wed, 11 Nov 2020 20:38:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Nov 2020 20:38:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id AA6B042EF9E1;
        Wed, 11 Nov 2020 20:38:01 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        razor@blackwall.org, jeremy@azazel.net
Subject: [PATCH net-next,v3 6/9] netfilter: flowtable: use dev_fill_forward_path() to obtain ingress device
Date:   Wed, 11 Nov 2020 20:37:34 +0100
Message-Id: <20201111193737.1793-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201111193737.1793-1-pablo@netfilter.org>
References: <20201111193737.1793-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
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
 include/net/netfilter/nf_flow_table.h |   3 +
 net/netfilter/nf_flow_table_core.c    |   3 +-
 net/netfilter/nft_flow_offload.c      | 101 +++++++++++++++++++++++++-
 3 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 7d477be06913..963f99fb1c06 100644
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
index 57dd8e40e474..27b4315d7b96 100644
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
index 1da2bb24f6c0..cae53c56f957 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -31,14 +31,103 @@ static void nft_default_forward_path(struct nf_flow_route *route,
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
+	for (i = stack->num_paths - 1; i >= 0; i--) {
+		path = &stack->path[i];
+		switch (path->type) {
+		case DEV_PATH_ETHERNET:
+			info->indev = path->dev;
+			break;
+		case DEV_PATH_VLAN:
+			break;
+		case DEV_PATH_BRIDGE:
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
+	struct net_device_path_stack stack = {};
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
@@ -63,6 +152,12 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
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
 
@@ -90,8 +185,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
 	struct tcphdr _tcph, *tcph = NULL;
+	struct nf_flow_route route = {};
 	enum ip_conntrack_info ctinfo;
-	struct nf_flow_route route;
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
 	struct nf_conn *ct;
@@ -128,7 +223,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto out;
 
 	dir = CTINFO2DIR(ctinfo);
-	if (nft_flow_route(pkt, ct, &route, dir) < 0)
+	if (nft_flow_route(pkt, ct, &route, dir, priv->flowtable) < 0)
 		goto err_flow_route;
 
 	flow = flow_offload_alloc(ct);
-- 
2.20.1

