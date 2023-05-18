Return-Path: <netdev+bounces-3558-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75C1D707DA2
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 637901C2105F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CFA13AC9;
	Thu, 18 May 2023 10:08:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F203C13AC8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:08:28 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7116D1BDA;
	Thu, 18 May 2023 03:08:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1pzaYY-0005qE-5E; Thu, 18 May 2023 12:08:22 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 8/9] netfilter: flowtable: split IPv4 datapath in helper functions
Date: Thu, 18 May 2023 12:07:58 +0200
Message-Id: <20230518100759.84858-9-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518100759.84858-1-fw@strlen.de>
References: <20230518100759.84858-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Pablo Neira Ayuso <pablo@netfilter.org>

Add context structure and helper functions to look up for a matching
IPv4 entry in the flowtable and to forward packets.

No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_ip.c | 119 ++++++++++++++++++++-----------
 1 file changed, 77 insertions(+), 42 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19efba1e51ef..3fb476167d1d 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -163,38 +163,43 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
 	}
 }
 
-static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
-			    struct flow_offload_tuple *tuple, u32 *hdrsize,
-			    u32 offset)
+struct nf_flowtable_ctx {
+	const struct net_device	*in;
+	u32			offset;
+	u32			hdrsize;
+};
+
+static int nf_flow_tuple_ip(struct nf_flowtable_ctx *ctx, struct sk_buff *skb,
+			    struct flow_offload_tuple *tuple)
 {
 	struct flow_ports *ports;
 	unsigned int thoff;
 	struct iphdr *iph;
 	u8 ipproto;
 
-	if (!pskb_may_pull(skb, sizeof(*iph) + offset))
+	if (!pskb_may_pull(skb, sizeof(*iph) + ctx->offset))
 		return -1;
 
-	iph = (struct iphdr *)(skb_network_header(skb) + offset);
+	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = (iph->ihl * 4);
 
 	if (ip_is_fragment(iph) ||
 	    unlikely(ip_has_options(thoff)))
 		return -1;
 
-	thoff += offset;
+	thoff += ctx->offset;
 
 	ipproto = iph->protocol;
 	switch (ipproto) {
 	case IPPROTO_TCP:
-		*hdrsize = sizeof(struct tcphdr);
+		ctx->hdrsize = sizeof(struct tcphdr);
 		break;
 	case IPPROTO_UDP:
-		*hdrsize = sizeof(struct udphdr);
+		ctx->hdrsize = sizeof(struct udphdr);
 		break;
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	case IPPROTO_GRE:
-		*hdrsize = sizeof(struct gre_base_hdr);
+		ctx->hdrsize = sizeof(struct gre_base_hdr);
 		break;
 #endif
 	default:
@@ -204,7 +209,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	if (iph->ttl <= 1)
 		return -1;
 
-	if (!pskb_may_pull(skb, thoff + *hdrsize))
+	if (!pskb_may_pull(skb, thoff + ctx->hdrsize))
 		return -1;
 
 	switch (ipproto) {
@@ -224,13 +229,13 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	}
 	}
 
-	iph = (struct iphdr *)(skb_network_header(skb) + offset);
+	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
 
 	tuple->src_v4.s_addr	= iph->saddr;
 	tuple->dst_v4.s_addr	= iph->daddr;
 	tuple->l3proto		= AF_INET;
 	tuple->l4proto		= ipproto;
-	tuple->iifidx		= dev->ifindex;
+	tuple->iifidx		= ctx->in->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
 
 	return 0;
@@ -336,58 +341,56 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-unsigned int
-nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
-			const struct nf_hook_state *state)
+static struct flow_offload_tuple_rhash *
+nf_flow_offload_lookup(struct nf_flowtable_ctx *ctx,
+		       struct nf_flowtable *flow_table, struct sk_buff *skb)
 {
-	struct flow_offload_tuple_rhash *tuplehash;
-	struct nf_flowtable *flow_table = priv;
 	struct flow_offload_tuple tuple = {};
-	enum flow_offload_tuple_dir dir;
-	struct flow_offload *flow;
-	struct net_device *outdev;
-	u32 hdrsize, offset = 0;
-	unsigned int thoff, mtu;
-	struct rtable *rt;
-	struct iphdr *iph;
-	__be32 nexthop;
-	int ret;
 
 	if (skb->protocol != htons(ETH_P_IP) &&
-	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &offset))
-		return NF_ACCEPT;
+	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &ctx->offset))
+		return NULL;
 
-	if (nf_flow_tuple_ip(skb, state->in, &tuple, &hdrsize, offset) < 0)
-		return NF_ACCEPT;
+	if (nf_flow_tuple_ip(ctx, skb, &tuple) < 0)
+		return NULL;
 
-	tuplehash = flow_offload_lookup(flow_table, &tuple);
-	if (tuplehash == NULL)
-		return NF_ACCEPT;
+	return flow_offload_lookup(flow_table, &tuple);
+}
+
+static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
+				   struct nf_flowtable *flow_table,
+				   struct flow_offload_tuple_rhash *tuplehash,
+				   struct sk_buff *skb)
+{
+	enum flow_offload_tuple_dir dir;
+	struct flow_offload *flow;
+	unsigned int thoff, mtu;
+	struct iphdr *iph;
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
-	mtu = flow->tuplehash[dir].tuple.mtu + offset;
+	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
 	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
-		return NF_ACCEPT;
+		return 0;
 
-	iph = (struct iphdr *)(skb_network_header(skb) + offset);
-	thoff = (iph->ihl * 4) + offset;
+	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
+	thoff = (iph->ihl * 4) + ctx->offset;
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
-		return NF_ACCEPT;
+		return 0;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
 		flow_offload_teardown(flow);
-		return NF_ACCEPT;
+		return 0;
 	}
 
-	if (skb_try_make_writable(skb, thoff + hdrsize))
-		return NF_DROP;
+	if (skb_try_make_writable(skb, thoff + ctx->hdrsize))
+		return -1;
 
 	flow_offload_refresh(flow_table, flow);
 
 	nf_flow_encap_pop(skb, tuplehash);
-	thoff -= offset;
+	thoff -= ctx->offset;
 
 	iph = ip_hdr(skb);
 	nf_flow_nat_ip(flow, skb, thoff, dir, iph);
@@ -398,6 +401,35 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
 		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
 
+	return 1;
+}
+
+unsigned int
+nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
+			const struct nf_hook_state *state)
+{
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct nf_flowtable *flow_table = priv;
+	enum flow_offload_tuple_dir dir;
+	struct nf_flowtable_ctx ctx = {
+		.in	= state->in,
+	};
+	struct flow_offload *flow;
+	struct net_device *outdev;
+	struct rtable *rt;
+	__be32 nexthop;
+	int ret;
+
+	tuplehash = nf_flow_offload_lookup(&ctx, flow_table, skb);
+	if (!tuplehash)
+		return NF_ACCEPT;
+
+	ret = nf_flow_offload_forward(&ctx, flow_table, tuplehash, skb);
+	if (ret < 0)
+		return NF_DROP;
+	else if (ret == 0)
+		return NF_ACCEPT;
+
 	if (unlikely(tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM)) {
 		rt = (struct rtable *)tuplehash->tuple.dst_cache;
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
@@ -406,6 +438,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		return nf_flow_xmit_xfrm(skb, state, &rt->dst);
 	}
 
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = (struct rtable *)tuplehash->tuple.dst_cache;
-- 
2.40.1


