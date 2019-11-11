Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2F3F8378
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfKKXaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:30:20 -0500
Received: from correo.us.es ([193.147.175.20]:41034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbfKKXaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:30:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E15471C43A6
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C196FFF13B
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 00:30:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AA453B8004; Tue, 12 Nov 2019 00:30:06 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77B2BDA72F;
        Tue, 12 Nov 2019 00:30:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 00:30:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 15F5442EF4E0;
        Tue, 12 Nov 2019 00:30:04 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, majd@mellanox.com, saeedm@mellanox.com
Subject: [PATCH net-next 4/6] netfilter: nf_flow_table: detach routing information from flow description
Date:   Tue, 12 Nov 2019 00:29:54 +0100
Message-Id: <20191111232956.24898-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111232956.24898-1-pablo@netfilter.org>
References: <20191111232956.24898-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the infrastructure to support for flow entry types.
The initial type is NF_FLOW_OFFLOAD_ROUTE that stores the routing
information into the flow entry to define a fastpath for the classic
forwarding path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 14 ++++--
 net/netfilter/nf_flow_table_core.c    | 88 ++++++++++++++++++++++++++---------
 net/netfilter/nft_flow_offload.c      |  5 +-
 3 files changed, 80 insertions(+), 27 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 6d33734c8fa1..f000e8917487 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -70,10 +70,16 @@ struct flow_offload_tuple_rhash {
 #define FLOW_OFFLOAD_DYING	0x4
 #define FLOW_OFFLOAD_TEARDOWN	0x8
 
+enum flow_offload_type {
+	NF_FLOW_OFFLOAD_UNSPEC	= 0,
+	NF_FLOW_OFFLOAD_ROUTE,
+};
+
 struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
 	struct nf_conn				*ct;
-	u32					flags;
+	u16					flags;
+	u16					type;
 	u32					timeout;
 	struct rcu_head				rcu_head;
 };
@@ -86,10 +92,12 @@ struct nf_flow_route {
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
 };
 
-struct flow_offload *flow_offload_alloc(struct nf_conn *ct,
-					struct nf_flow_route *route);
+struct flow_offload *flow_offload_alloc(struct nf_conn *ct);
 void flow_offload_free(struct flow_offload *flow);
 
+int flow_offload_route_init(struct flow_offload *flow,
+			    const struct nf_flow_route *route);
+
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 15a5555940c7..139a5e074743 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -19,13 +19,10 @@ static LIST_HEAD(flowtables);
 
 static void
 flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
-		      struct nf_flow_route *route,
 		      enum flow_offload_tuple_dir dir)
 {
 	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
 	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
-	struct dst_entry *other_dst = route->tuple[!dir].dst;
-	struct dst_entry *dst = route->tuple[dir].dst;
 
 	ft->dir = dir;
 
@@ -33,12 +30,10 @@ flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
 	case NFPROTO_IPV4:
 		ft->src_v4 = ctt->src.u3.in;
 		ft->dst_v4 = ctt->dst.u3.in;
-		ft->mtu = ip_dst_mtu_maybe_forward(dst, true);
 		break;
 	case NFPROTO_IPV6:
 		ft->src_v6 = ctt->src.u3.in6;
 		ft->dst_v6 = ctt->dst.u3.in6;
-		ft->mtu = ip6_dst_mtu_forward(dst);
 		break;
 	}
 
@@ -46,13 +41,9 @@ flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
 	ft->l4proto = ctt->dst.protonum;
 	ft->src_port = ctt->src.u.tcp.port;
 	ft->dst_port = ctt->dst.u.tcp.port;
-
-	ft->iifidx = other_dst->dev->ifindex;
-	ft->dst_cache = dst;
 }
 
-struct flow_offload *
-flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
+struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 {
 	struct flow_offload *flow;
 
@@ -64,16 +55,10 @@ flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 	if (!flow)
 		goto err_ct_refcnt;
 
-	if (!dst_hold_safe(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
-		goto err_dst_cache_original;
-
-	if (!dst_hold_safe(route->tuple[FLOW_OFFLOAD_DIR_REPLY].dst))
-		goto err_dst_cache_reply;
-
 	flow->ct = ct;
 
-	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_ORIGINAL);
-	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_REPLY);
+	flow_offload_fill_dir(flow, ct, FLOW_OFFLOAD_DIR_ORIGINAL);
+	flow_offload_fill_dir(flow, ct, FLOW_OFFLOAD_DIR_REPLY);
 
 	if (ct->status & IPS_SRC_NAT)
 		flow->flags |= FLOW_OFFLOAD_SNAT;
@@ -82,10 +67,6 @@ flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 
 	return flow;
 
-err_dst_cache_reply:
-	dst_release(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
-err_dst_cache_original:
-	kfree(flow);
 err_ct_refcnt:
 	nf_ct_put(ct);
 
@@ -93,6 +74,56 @@ flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 }
 EXPORT_SYMBOL_GPL(flow_offload_alloc);
 
+static int flow_offload_fill_route(struct flow_offload *flow,
+				   const struct nf_flow_route *route,
+				   enum flow_offload_tuple_dir dir)
+{
+	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
+	struct dst_entry *other_dst = route->tuple[!dir].dst;
+	struct dst_entry *dst = route->tuple[dir].dst;
+
+	if (!dst_hold_safe(route->tuple[dir].dst))
+		return -1;
+
+	switch (flow_tuple->l3proto) {
+	case NFPROTO_IPV4:
+		flow_tuple->mtu = ip_dst_mtu_maybe_forward(dst, true);
+		break;
+	case NFPROTO_IPV6:
+		flow_tuple->mtu = ip6_dst_mtu_forward(dst);
+		break;
+	}
+
+	flow_tuple->iifidx = other_dst->dev->ifindex;
+	flow_tuple->dst_cache = dst;
+
+	return 0;
+}
+
+int flow_offload_route_init(struct flow_offload *flow,
+			    const struct nf_flow_route *route)
+{
+	int err;
+
+	err = flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_ORIGINAL);
+	if (err < 0)
+		return err;
+
+	err = flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_REPLY);
+	if (err < 0)
+		goto err_route_reply;
+
+	flow->type = NF_FLOW_OFFLOAD_ROUTE;
+
+	return 0;
+
+err_route_reply:
+	dst_release(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(flow_offload_route_init);
+
 static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 {
 	tcp->state = TCP_CONNTRACK_ESTABLISHED;
@@ -141,10 +172,21 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 	flow_offload_fixup_ct_timeout(ct);
 }
 
-void flow_offload_free(struct flow_offload *flow)
+static void flow_offload_route_release(struct flow_offload *flow)
 {
 	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_cache);
 	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_cache);
+}
+
+void flow_offload_free(struct flow_offload *flow)
+{
+	switch (flow->type) {
+	case NF_FLOW_OFFLOAD_ROUTE:
+		flow_offload_route_release(flow);
+		break;
+	default:
+		break;
+	}
 	if (flow->flags & FLOW_OFFLOAD_DYING)
 		nf_ct_delete(flow->ct, 0, 0);
 	nf_ct_put(flow->ct);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index f29bbc74c4bf..dd82ff2ee19f 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -115,10 +115,13 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (nft_flow_route(pkt, ct, &route, dir) < 0)
 		goto err_flow_route;
 
-	flow = flow_offload_alloc(ct, &route);
+	flow = flow_offload_alloc(ct);
 	if (!flow)
 		goto err_flow_alloc;
 
+	if (flow_offload_route_init(flow, &route) < 0)
+		goto err_flow_add;
+
 	if (tcph) {
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-- 
2.11.0

