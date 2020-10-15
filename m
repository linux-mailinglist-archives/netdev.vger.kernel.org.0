Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8F328E9B0
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbgJOBQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:16:45 -0400
Received: from correo.us.es ([193.147.175.20]:38738 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730279AbgJOBQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 21:16:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E89DDA7E3
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 03:16:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 584CADA722
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 03:16:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4DED8DA789; Thu, 15 Oct 2020 03:16:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26DB4DA722;
        Thu, 15 Oct 2020 03:16:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 03:16:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id E91D041FF201;
        Thu, 15 Oct 2020 03:16:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 1/9] netfilter: flowtable: add xmit path types
Date:   Thu, 15 Oct 2020 03:16:22 +0200
Message-Id: <20201015011630.2399-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201015011630.2399-1-pablo@netfilter.org>
References: <20201015011630.2399-1-pablo@netfilter.org>
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
 include/net/netfilter/nf_flow_table.h |  6 ++++
 net/netfilter/nf_flow_table_core.c    |  4 +++
 net/netfilter/nf_flow_table_ip.c      | 50 ++++++++++++++++++---------
 3 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 16e8b2f8d006..08e779f149ee 100644
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
@@ -108,6 +113,7 @@ struct flow_offload_tuple {
 	u8				l3proto;
 	u8				l4proto;
 	u8				dir;
+	enum flow_offload_xmit_type	xmit_type:8;
 
 	u16				mtu;
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 513f78db3cb2..97f04f244961 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -95,6 +95,10 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	}
 
 	flow_tuple->iifidx = other_dst->dev->ifindex;
+
+	if (dst_xfrm(dst))
+		flow_tuple->xmit_type = FLOW_OFFLOAD_XMIT_XFRM;
+
 	flow_tuple->dst_cache = dst;
 
 	return 0;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index a698dbe28ef5..e215c79e6777 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -252,6 +252,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	unsigned int thoff;
 	struct iphdr *iph;
 	__be32 nexthop;
+	int ret;
 
 	if (skb->protocol != htons(ETH_P_IP))
 		return NF_ACCEPT;
@@ -295,19 +296,27 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
-	if (unlikely(dst_xfrm(&rt->dst))) {
+	switch (tuplehash->tuple.xmit_type) {
+	case FLOW_OFFLOAD_XMIT_NEIGH:
+		skb->dev = outdev;
+		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
+		skb_dst_set_noref(skb, &rt->dst);
+		neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+		ret = NF_STOLEN;
+		break;
+	case FLOW_OFFLOAD_XMIT_XFRM:
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
 		IPCB(skb)->iif = skb->dev->ifindex;
 		IPCB(skb)->flags = IPSKB_FORWARDED;
-		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+		ret = nf_flow_xmit_xfrm(skb, state, &rt->dst);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		ret = NF_DROP;
+		break;
 	}
 
-	skb->dev = outdev;
-	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
-
-	return NF_STOLEN;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
 
@@ -493,6 +502,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	struct net_device *outdev;
 	struct ipv6hdr *ip6h;
 	struct rt6_info *rt;
+	int ret;
 
 	if (skb->protocol != htons(ETH_P_IPV6))
 		return NF_ACCEPT;
@@ -536,18 +546,26 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
-	if (unlikely(dst_xfrm(&rt->dst))) {
+	switch (tuplehash->tuple.xmit_type) {
+	case FLOW_OFFLOAD_XMIT_NEIGH:
+		skb->dev = outdev;
+		nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
+		skb_dst_set_noref(skb, &rt->dst);
+		neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
+		ret = NF_STOLEN;
+		break;
+	case FLOW_OFFLOAD_XMIT_XFRM:
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 		IP6CB(skb)->iif = skb->dev->ifindex;
 		IP6CB(skb)->flags = IP6SKB_FORWARDED;
-		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
+		ret = nf_flow_xmit_xfrm(skb, state, &rt->dst);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		ret = NF_DROP;
+		break;
 	}
 
-	skb->dev = outdev;
-	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
-	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
-
-	return NF_STOLEN;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_flow_offload_ipv6_hook);
-- 
2.20.1

