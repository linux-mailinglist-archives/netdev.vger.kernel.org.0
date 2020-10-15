Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B73228F6C5
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390003AbgJOQbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:31:00 -0400
Received: from correo.us.es ([193.147.175.20]:47292 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389967AbgJOQaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:30:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 56911E2C6B
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 18:30:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 492E4DA792
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 18:30:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3EBCFDA730; Thu, 15 Oct 2020 18:30:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1901DDA730;
        Thu, 15 Oct 2020 18:30:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 18:30:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id CCBD042EF4E3;
        Thu, 15 Oct 2020 18:30:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 5/9] netfilter: flowtable: use dev_fill_forward_path() to obtain ingress device
Date:   Thu, 15 Oct 2020 18:30:34 +0200
Message-Id: <20201015163038.26992-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201015163038.26992-1-pablo@netfilter.org>
References: <20201015163038.26992-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ingress device in the tuple is obtained from route in the reply
direction. Use dev_fill_forward_path() instead to provide the real
ingress device for this flow.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 include/net/netfilter/nf_flow_table.h |  6 ++-
 net/netfilter/nf_flow_table_core.c    |  3 +-
 net/netfilter/nft_flow_offload.c      | 75 ++++++++++++++++++++++++++-
 3 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 08e779f149ee..ecb84d4358cc 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -112,9 +112,10 @@ struct flow_offload_tuple {
 
 	u8				l3proto;
 	u8				l4proto;
+
+	/* All members above are keys for lookups, see flow_offload_hash(). */
 	u8				dir;
 	enum flow_offload_xmit_type	xmit_type:8;
-
 	u16				mtu;
 
 	struct dst_entry		*dst_cache;
@@ -160,6 +161,9 @@ static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
 
 struct nf_flow_route {
 	struct {
+		struct {
+			u32		ifindex;
+		} in;
 		struct dst_entry	*dst;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
 };
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 97f04f244961..66abc7f287a3 100644
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
 
 	if (dst_xfrm(dst))
 		flow_tuple->xmit_type = FLOW_OFFLOAD_XMIT_XFRM;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 3a6c84fb2c90..4b476b0a3c88 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -19,6 +19,75 @@ struct nft_flow_offload {
 	struct nft_flowtable	*flowtable;
 };
 
+static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
+				     const struct nf_conn *ct,
+				     enum ip_conntrack_dir dir,
+				     struct net_device_path_stack *stack)
+{
+	const struct dst_entry *dst_cache = route->tuple[dir].dst;
+	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
+	unsigned char ha[ETH_ALEN];
+	struct net_device *dev;
+	struct neighbour *n;
+	struct rtable *rt;
+	u8 nud_state;
+
+	rt = (struct rtable *)dst_cache;
+	dev = rt->dst.dev;
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
+	u32 iifindex;
+};
+
+static int nft_dev_forward_path(struct nf_flow_route *route,
+				const struct nf_conn *ct,
+				enum ip_conntrack_dir dir)
+{
+	struct net_device_path_stack stack = {};
+	struct nft_forward_info info = {};
+	struct net_device_path *path;
+	int i, ret;
+
+	memset(&stack, 0, sizeof(stack));
+
+	ret = nft_dev_fill_forward_path(route, ct, dir, &stack);
+	if (ret < 0)
+		return -1;
+
+	for (i = stack.num_paths - 1; i >= 0; i--) {
+		path = &stack.path[i];
+		switch (path->type) {
+		case DEV_PATH_ETHERNET:
+			info.iifindex = path->dev->ifindex;
+			break;
+		case DEV_PATH_VLAN:
+			return -1;
+		case DEV_PATH_BRIDGE:
+			return -1;
+		}
+	}
+
+	route->tuple[!dir].in.ifindex = info.iifindex;
+
+	return 0;
+}
+
 static int nft_flow_route(const struct nft_pktinfo *pkt,
 			  const struct nf_conn *ct,
 			  struct nf_flow_route *route,
@@ -47,6 +116,10 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 	route->tuple[dir].dst		= this_dst;
 	route->tuple[!dir].dst		= other_dst;
 
+	if (nft_dev_forward_path(route, ct, IP_CT_DIR_ORIGINAL) < 0 ||
+	    nft_dev_forward_path(route, ct, IP_CT_DIR_REPLY) < 0)
+		return -ENOENT;
+
 	return 0;
 }
 
@@ -74,8 +147,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
 	struct tcphdr _tcph, *tcph = NULL;
+	struct nf_flow_route route = {};
 	enum ip_conntrack_info ctinfo;
-	struct nf_flow_route route;
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
 	struct nf_conn *ct;
-- 
2.20.1

