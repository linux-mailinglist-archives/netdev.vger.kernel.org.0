Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23D02AF932
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgKKTib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:38:31 -0500
Received: from correo.us.es ([193.147.175.20]:45106 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbgKKTiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 14:38:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 027EE1878BD
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E90A3DA855
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 20:38:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E85B1DA853; Wed, 11 Nov 2020 20:38:01 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9437BDA84F;
        Wed, 11 Nov 2020 20:37:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Nov 2020 20:37:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 5DF4442EF9E1;
        Wed, 11 Nov 2020 20:37:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        razor@blackwall.org, jeremy@azazel.net
Subject: [PATCH net-next,v3 2/9] netfilter: flowtable: add xmit path types
Date:   Wed, 11 Nov 2020 20:37:30 +0100
Message-Id: <20201111193737.1793-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201111193737.1793-1-pablo@netfilter.org>
References: <20201111193737.1793-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the xmit_type field that defines the two supported xmit paths in the
flowtable data plane, which are the neighbour and the xfrm xmit paths.
This patch prepares for new flowtable xmit path types to come.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 11 +++++++--
 net/netfilter/nf_flow_table_core.c    |  1 +
 net/netfilter/nf_flow_table_ip.c      | 32 ++++++++++++++++++---------
 net/netfilter/nft_flow_offload.c      | 20 +++++++++++++++--
 4 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 54c4d5c908a5..7d477be06913 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -89,6 +89,11 @@ enum flow_offload_tuple_dir {
 	FLOW_OFFLOAD_DIR_MAX = IP_CT_DIR_MAX
 };
 
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
index 55fca71ace26..57dd8e40e474 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -95,6 +95,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	}
 
 	flow_tuple->iifidx = other_dst->dev->ifindex;
+	flow_tuple->xmit_type = route->tuple[dir].xmit_type;
 	flow_tuple->dst_cache = dst;
 
 	return 0;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index a698dbe28ef5..03314cc06e04 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -220,10 +220,20 @@ static bool nf_flow_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 	return true;
 }
 
-static int nf_flow_offload_dst_check(struct dst_entry *dst)
+static inline struct dst_entry *
+nft_flow_dst(struct flow_offload_tuple_rhash *tuplehash)
 {
-	if (unlikely(dst_xfrm(dst)))
+	return tuplehash->tuple.dst_cache;
+}
+
+static int nf_flow_offload_dst_check(struct flow_offload_tuple_rhash *tuplehash)
+{
+	struct dst_entry *dst;
+
+	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
+		dst = nft_flow_dst(tuplehash);
 		return dst_check(dst, 0) ? 0 : -1;
+	}
 
 	return 0;
 }
@@ -265,8 +275,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
-	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
@@ -280,7 +288,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	flow_offload_refresh(flow_table, flow);
 
-	if (nf_flow_offload_dst_check(&rt->dst)) {
+	if (nf_flow_offload_dst_check(tuplehash)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
 	}
@@ -295,13 +303,16 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
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
@@ -506,8 +517,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
-	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
@@ -518,7 +527,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	flow_offload_refresh(flow_table, flow);
 
-	if (nf_flow_offload_dst_check(&rt->dst)) {
+	if (nf_flow_offload_dst_check(tuplehash)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
 	}
@@ -536,13 +545,16 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
-	if (unlikely(dst_xfrm(&rt->dst))) {
+	rt = (struct rt6_info *)tuplehash->tuple.dst_cache;
+
+	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH)) {
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

