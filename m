Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4E94D9758
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346409AbiCOJQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346265AbiCOJQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:16:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 984A64DF67;
        Tue, 15 Mar 2022 02:15:21 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 650E263014;
        Tue, 15 Mar 2022 10:13:02 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 4/6] act_ct: Support GRE offload
Date:   Tue, 15 Mar 2022 10:15:11 +0100
Message-Id: <20220315091513.66544-5-pablo@netfilter.org>
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
Acked-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/sched/act_ct.c | 115 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 91 insertions(+), 24 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 5234e8bcc764..bed0b100dd0c 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -415,6 +415,19 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 		break;
 	case IPPROTO_UDP:
 		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE: {
+		struct nf_conntrack_tuple *tuple;
+
+		if (ct->status & IPS_NAT_MASK)
+			return;
+		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+		/* No support for GRE v1 */
+		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
+			return;
+		break;
+	}
+#endif
 	default:
 		return;
 	}
@@ -434,6 +447,8 @@ tcf_ct_flow_table_fill_tuple_ipv4(struct sk_buff *skb,
 	struct flow_ports *ports;
 	unsigned int thoff;
 	struct iphdr *iph;
+	size_t hdrsize;
+	u8 ipproto;
 
 	if (!pskb_network_may_pull(skb, sizeof(*iph)))
 		return false;
@@ -445,29 +460,54 @@ tcf_ct_flow_table_fill_tuple_ipv4(struct sk_buff *skb,
 	    unlikely(thoff != sizeof(struct iphdr)))
 		return false;
 
-	if (iph->protocol != IPPROTO_TCP &&
-	    iph->protocol != IPPROTO_UDP)
+	ipproto = iph->protocol;
+	switch (ipproto) {
+	case IPPROTO_TCP:
+		hdrsize = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+		hdrsize = sizeof(*ports);
+		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
+	default:
 		return false;
+	}
 
 	if (iph->ttl <= 1)
 		return false;
 
-	if (!pskb_network_may_pull(skb, iph->protocol == IPPROTO_TCP ?
-					thoff + sizeof(struct tcphdr) :
-					thoff + sizeof(*ports)))
+	if (!pskb_network_may_pull(skb, thoff + hdrsize))
 		return false;
 
-	iph = ip_hdr(skb);
-	if (iph->protocol == IPPROTO_TCP)
+	switch (ipproto) {
+	case IPPROTO_TCP:
 		*tcph = (void *)(skb_network_header(skb) + thoff);
+		fallthrough;
+	case IPPROTO_UDP:
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port = ports->source;
+		tuple->dst_port = ports->dest;
+		break;
+	case IPPROTO_GRE: {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return false;
+		break;
+	}
+	}
+
+	iph = ip_hdr(skb);
 
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 	tuple->src_v4.s_addr = iph->saddr;
 	tuple->dst_v4.s_addr = iph->daddr;
-	tuple->src_port = ports->source;
-	tuple->dst_port = ports->dest;
 	tuple->l3proto = AF_INET;
-	tuple->l4proto = iph->protocol;
+	tuple->l4proto = ipproto;
 
 	return true;
 }
@@ -480,36 +520,63 @@ tcf_ct_flow_table_fill_tuple_ipv6(struct sk_buff *skb,
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
 	unsigned int thoff;
+	size_t hdrsize;
+	u8 nexthdr;
 
 	if (!pskb_network_may_pull(skb, sizeof(*ip6h)))
 		return false;
 
 	ip6h = ipv6_hdr(skb);
+	thoff = sizeof(*ip6h);
 
-	if (ip6h->nexthdr != IPPROTO_TCP &&
-	    ip6h->nexthdr != IPPROTO_UDP)
-		return false;
+	nexthdr = ip6h->nexthdr;
+	switch (nexthdr) {
+	case IPPROTO_TCP:
+		hdrsize = sizeof(struct tcphdr);
+		break;
+	case IPPROTO_UDP:
+		hdrsize = sizeof(*ports);
+		break;
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	case IPPROTO_GRE:
+		hdrsize = sizeof(struct gre_base_hdr);
+		break;
+#endif
+	default:
+		return -1;
+	}
 
 	if (ip6h->hop_limit <= 1)
 		return false;
 
-	thoff = sizeof(*ip6h);
-	if (!pskb_network_may_pull(skb, ip6h->nexthdr == IPPROTO_TCP ?
-					thoff + sizeof(struct tcphdr) :
-					thoff + sizeof(*ports)))
+	if (!pskb_network_may_pull(skb, thoff + hdrsize))
 		return false;
 
-	ip6h = ipv6_hdr(skb);
-	if (ip6h->nexthdr == IPPROTO_TCP)
+	switch (nexthdr) {
+	case IPPROTO_TCP:
 		*tcph = (void *)(skb_network_header(skb) + thoff);
+		fallthrough;
+	case IPPROTO_UDP:
+		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+		tuple->src_port = ports->source;
+		tuple->dst_port = ports->dest;
+		break;
+	case IPPROTO_GRE: {
+		struct gre_base_hdr *greh;
+
+		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
+		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
+			return false;
+		break;
+	}
+	}
+
+	ip6h = ipv6_hdr(skb);
 
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 	tuple->src_v6 = ip6h->saddr;
 	tuple->dst_v6 = ip6h->daddr;
-	tuple->src_port = ports->source;
-	tuple->dst_port = ports->dest;
 	tuple->l3proto = AF_INET6;
-	tuple->l4proto = ip6h->nexthdr;
+	tuple->l4proto = nexthdr;
 
 	return true;
 }
-- 
2.30.2

