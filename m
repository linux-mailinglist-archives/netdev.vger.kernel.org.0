Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3124D9760
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346467AbiCOJQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346338AbiCOJQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:16:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 406154BBBF;
        Tue, 15 Mar 2022 02:15:21 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C77A563012;
        Tue, 15 Mar 2022 10:13:01 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 3/6] netfilter: flowtable: Support GRE
Date:   Tue, 15 Mar 2022 10:15:10 +0100
Message-Id: <20220315091513.66544-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315091513.66544-1-pablo@netfilter.org>
References: <20220315091513.66544-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toshiaki Makita <toshiaki.makita1@gmail.com>

Support GREv0 without NAT.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c    | 10 ++++-
 net/netfilter/nf_flow_table_ip.c      | 62 ++++++++++++++++++++++-----
 net/netfilter/nf_flow_table_offload.c | 22 +++++++---
 net/netfilter/nft_flow_offload.c      | 13 ++++++
 4 files changed, 88 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b90eca7a2f22..e66a375075c9 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -39,8 +39,14 @@ flow_offload_fill_dir(struct flow_offload *flow,
 
 	ft->l3proto = ctt->src.l3num;
 	ft->l4proto = ctt->dst.protonum;
-	ft->src_port = ctt->src.u.tcp.port;
-	ft->dst_port = ctt->dst.u.tcp.port;
+
+	switch (ctt->dst.protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		ft->src_port = ctt->src.u.tcp.port;
+		ft->dst_port = ctt->dst.u.tcp.port;
+		break;
+	}
 }
 
 struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 889cf88d3dba..6e9cacf694de 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -172,6 +172,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	struct flow_ports *ports;
 	unsigned int thoff;
 	struct iphdr *iph;
+	u8 ipproto;
 
 	if (!pskb_may_pull(skb, sizeof(*iph) + offset))
 		return -1;
@@ -185,13 +186,19 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 
 	thoff += offset;
 
-	switch (iph->protocol) {
+	ipproto = iph->protocol;
+	switch (ipproto) {
 	case IPPROTO_TCP:
 		*hdrsize = sizeof(struct tcphdr);
 		break;
 	case IPPROTO_UDP:
 		*hdrsize = sizeof(struct udphdr);
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		*hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
 	default:
 		return -1;
 	}
@@ -202,15 +209,29 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + *hdrsize))
 		return -1;
 
+	switch (ipproto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port		= ports->source;
+		tuple->dst_port		= ports->dest;
+		break;
+	case IPPROTO_GRE: {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return -1;
+		break;
+	}
+	}
+
 	iph = (struct iphdr *)(skb_network_header(skb) + offset);
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v4.s_addr	= iph->saddr;
 	tuple->dst_v4.s_addr	= iph->daddr;
-	tuple->src_port		= ports->source;
-	tuple->dst_port		= ports->dest;
 	tuple->l3proto		= AF_INET;
-	tuple->l4proto		= iph->protocol;
+	tuple->l4proto		= ipproto;
 	tuple->iifidx		= dev->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
 
@@ -521,6 +542,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
 	unsigned int thoff;
+	u8 nexthdr;
 
 	thoff = sizeof(*ip6h) + offset;
 	if (!pskb_may_pull(skb, thoff))
@@ -528,13 +550,19 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 
-	switch (ip6h->nexthdr) {
+	nexthdr = ip6h->nexthdr;
+	switch (nexthdr) {
 	case IPPROTO_TCP:
 		*hdrsize = sizeof(struct tcphdr);
 		break;
 	case IPPROTO_UDP:
 		*hdrsize = sizeof(struct udphdr);
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		*hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
 	default:
 		return -1;
 	}
@@ -545,15 +573,29 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + *hdrsize))
 		return -1;
 
+	switch (nexthdr) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port		= ports->source;
+		tuple->dst_port		= ports->dest;
+		break;
+	case IPPROTO_GRE: {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return -1;
+		break;
+	}
+	}
+
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v6		= ip6h->saddr;
 	tuple->dst_v6		= ip6h->daddr;
-	tuple->src_port		= ports->source;
-	tuple->dst_port		= ports->dest;
 	tuple->l3proto		= AF_INET6;
-	tuple->l4proto		= ip6h->nexthdr;
+	tuple->l4proto		= nexthdr;
 	tuple->iifidx		= dev->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a44a45..99f6db3757ad 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -170,6 +170,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_TCP);
 		break;
 	case IPPROTO_UDP:
+	case IPPROTO_GRE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -178,15 +179,22 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	key->basic.ip_proto = tuple->l4proto;
 	mask->basic.ip_proto = 0xff;
 
-	key->tp.src = tuple->src_port;
-	mask->tp.src = 0xffff;
-	key->tp.dst = tuple->dst_port;
-	mask->tp.dst = 0xffff;
-
 	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_META) |
 				      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
-				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
-				      BIT(FLOW_DISSECTOR_KEY_PORTS);
+				      BIT(FLOW_DISSECTOR_KEY_BASIC);
+
+	switch (tuple->l4proto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		key->tp.src = tuple->src_port;
+		mask->tp.src = 0xffff;
+		key->tp.dst = tuple->dst_port;
+		mask->tp.dst = 0xffff;
+
+		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_PORTS);
+		break;
+	}
+
 	return 0;
 }
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 0af34ad41479..731b5d87ef45 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -298,6 +298,19 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		break;
 	case IPPROTO_UDP:
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE: {
+		struct nf_conntrack_tuple *tuple;
+
+		if (ct->status & IPS_NAT_MASK)
+			goto out;
+		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+		/* No support for GRE v1 */
+		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
+			goto out;
+		break;
+	}
+#endif
 	default:
 		goto out;
 	}
-- 
2.30.2

