Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8979628AB74
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 03:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbgJLBif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 21:38:35 -0400
Received: from correo.us.es ([193.147.175.20]:41722 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727483AbgJLBid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 21:38:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6BADEE780D
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 03:38:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59447DA73D
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 03:38:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4E975DA722; Mon, 12 Oct 2020 03:38:31 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 32442DA72F;
        Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 04AF641FF201;
        Mon, 12 Oct 2020 03:38:28 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 5/6] netfilter: nf_tables: add inet ingress support
Date:   Mon, 12 Oct 2020 03:38:18 +0200
Message-Id: <20201012013819.23128-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201012013819.23128-1-pablo@netfilter.org>
References: <20201012013819.23128-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new ingress hook for the inet family. The inet ingress
hook emulates the IP receive path code, therefore, unclean packets are
drop before walking over the ruleset in this basechain.

This patch also introduces the nft_base_chain_netdev() helper function
to check if this hook is bound to one or more devices (through the hook
list infrastructure). This check allows to perform the same handling for
the inet ingress as it would be a netdev ingress chain from the control
plane.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      |  6 ++++
 include/net/netfilter/nf_tables_ipv4.h | 33 ++++++++++++++++++
 include/net/netfilter/nf_tables_ipv6.h | 46 ++++++++++++++++++++++++++
 net/netfilter/nf_tables_api.c          | 14 ++++----
 net/netfilter/nft_chain_filter.c       | 35 +++++++++++++++++++-
 5 files changed, 126 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0bd2a081ae39..3965ce18226f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1081,6 +1081,12 @@ struct nft_table {
 	u8				*udata;
 };
 
+static inline bool nft_base_chain_netdev(int family, u32 hooknum)
+{
+	return family == NFPROTO_NETDEV ||
+	       (family == NFPROTO_INET && hooknum == NF_INET_INGRESS);
+}
+
 void nft_register_chain_type(const struct nft_chain_type *);
 void nft_unregister_chain_type(const struct nft_chain_type *);
 
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index ed7b511f0a59..1f7bea39ad1b 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -53,4 +53,37 @@ static inline void nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
 		nft_set_pktinfo_unspec(pkt, skb);
 }
 
+static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt,
+					       struct sk_buff *skb)
+{
+	struct iphdr *iph;
+	u32 len, thoff;
+
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return -1;
+
+	iph = ip_hdr(skb);
+	if (iph->ihl < 5 || iph->version != 4)
+		goto inhdr_error;
+
+	len = ntohs(iph->tot_len);
+	thoff = iph->ihl * 4;
+	if (skb->len < len) {
+		__IP_INC_STATS(nft_net(pkt), IPSTATS_MIB_INTRUNCATEDPKTS);
+		return -1;
+	} else if (len < thoff) {
+		goto inhdr_error;
+	}
+
+	pkt->tprot_set = true;
+	pkt->tprot = iph->protocol;
+	pkt->xt.thoff = thoff;
+	pkt->xt.fragoff = ntohs(iph->frag_off) & IP_OFFSET;
+
+	return 0;
+
+inhdr_error:
+	__IP_INC_STATS(nft_net(pkt), IPSTATS_MIB_INHDRERRORS);
+	return -1;
+}
 #endif
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index d0f1c537b017..867de29f3f7a 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -70,4 +70,50 @@ static inline void nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 		nft_set_pktinfo_unspec(pkt, skb);
 }
 
+static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt,
+					       struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	unsigned int flags = IP6_FH_F_AUTH;
+	unsigned short frag_off;
+	unsigned int thoff = 0;
+	struct inet6_dev *idev;
+	struct ipv6hdr *ip6h;
+	int protohdr;
+	u32 pkt_len;
+
+	if (!pskb_may_pull(skb, sizeof(*ip6h)))
+		return -1;
+
+	ip6h = ipv6_hdr(skb);
+	if (ip6h->version != 6)
+		goto inhdr_error;
+
+	pkt_len = ntohs(ip6h->payload_len);
+	if (pkt_len + sizeof(*ip6h) > skb->len) {
+		idev = __in6_dev_get(nft_in(pkt));
+		__IP6_INC_STATS(nft_net(pkt), idev, IPSTATS_MIB_INTRUNCATEDPKTS);
+		return -1;
+	}
+
+	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
+	if (protohdr < 0)
+		goto inhdr_error;
+
+	pkt->tprot_set = true;
+	pkt->tprot = protohdr;
+	pkt->xt.thoff = thoff;
+	pkt->xt.fragoff = frag_off;
+
+	return 0;
+
+inhdr_error:
+	idev = __in6_dev_get(nft_in(pkt));
+	__IP6_INC_STATS(nft_net(pkt), idev, IPSTATS_MIB_INHDRERRORS);
+	return -1;
+#else
+	return -1;
+#endif
+}
+
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ae2c04d411b1..f22ad21d0230 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -206,7 +206,7 @@ static int nf_tables_register_hook(struct net *net,
 	if (basechain->type->ops_register)
 		return basechain->type->ops_register(net, ops);
 
-	if (table->family == NFPROTO_NETDEV)
+	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
 		return nft_netdev_register_hooks(net, &basechain->hook_list);
 
 	return nf_register_net_hook(net, &basechain->ops);
@@ -228,7 +228,7 @@ static void nf_tables_unregister_hook(struct net *net,
 	if (basechain->type->ops_unregister)
 		return basechain->type->ops_unregister(net, ops);
 
-	if (table->family == NFPROTO_NETDEV)
+	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
 		nft_netdev_unregister_hooks(net, &basechain->hook_list);
 	else
 		nf_unregister_net_hook(net, &basechain->ops);
@@ -1381,7 +1381,7 @@ static int nft_dump_basechain_hook(struct sk_buff *skb, int family,
 	if (nla_put_be32(skb, NFTA_HOOK_PRIORITY, htonl(ops->priority)))
 		goto nla_put_failure;
 
-	if (family == NFPROTO_NETDEV) {
+	if (nft_base_chain_netdev(family, ops->hooknum)) {
 		nest_devs = nla_nest_start_noflag(skb, NFTA_HOOK_DEVS);
 		list_for_each_entry(hook, &basechain->hook_list, list) {
 			if (!first)
@@ -1685,7 +1685,7 @@ void nf_tables_chain_destroy(struct nft_ctx *ctx)
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
-		if (ctx->family == NFPROTO_NETDEV) {
+		if (nft_base_chain_netdev(ctx->family, basechain->ops.hooknum)) {
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
@@ -1877,7 +1877,7 @@ static int nft_chain_parse_hook(struct net *net,
 	hook->type = type;
 
 	INIT_LIST_HEAD(&hook->list);
-	if (family == NFPROTO_NETDEV) {
+	if (nft_base_chain_netdev(family, hook->num)) {
 		err = nft_chain_parse_netdev(net, ha, &hook->list);
 		if (err < 0) {
 			module_put(type->owner);
@@ -1944,7 +1944,7 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 	INIT_LIST_HEAD(&basechain->hook_list);
 	chain = &basechain->chain;
 
-	if (family == NFPROTO_NETDEV) {
+	if (nft_base_chain_netdev(family, hook->num)) {
 		list_splice_init(&hook->list, &basechain->hook_list);
 		list_for_each_entry(h, &basechain->hook_list, list)
 			nft_basechain_hook_init(&h->ops, family, hook, chain);
@@ -2168,7 +2168,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			return -EEXIST;
 		}
 
-		if (ctx->family == NFPROTO_NETDEV) {
+		if (nft_base_chain_netdev(ctx->family, hook.num)) {
 			if (!nft_hook_list_equal(&basechain->hook_list,
 						 &hook.list)) {
 				nft_chain_release_hook(&hook);
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index c78d01bc02e9..ff8528ad3dc6 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -161,16 +161,49 @@ static unsigned int nft_do_chain_inet(void *priv, struct sk_buff *skb,
 	return nft_do_chain(&pkt, priv);
 }
 
+static unsigned int nft_do_chain_inet_ingress(void *priv, struct sk_buff *skb,
+					      const struct nf_hook_state *state)
+{
+	struct nf_hook_state ingress_state = *state;
+	struct nft_pktinfo pkt;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		/* Original hook is NFPROTO_NETDEV and NF_NETDEV_INGRESS. */
+		ingress_state.pf = NFPROTO_IPV4;
+		ingress_state.hook = NF_INET_INGRESS;
+		nft_set_pktinfo(&pkt, skb, &ingress_state);
+
+		if (nft_set_pktinfo_ipv4_ingress(&pkt, skb) < 0)
+			return NF_DROP;
+		break;
+	case htons(ETH_P_IPV6):
+		ingress_state.pf = NFPROTO_IPV6;
+		ingress_state.hook = NF_INET_INGRESS;
+		nft_set_pktinfo(&pkt, skb, &ingress_state);
+
+		if (nft_set_pktinfo_ipv6_ingress(&pkt, skb) < 0)
+			return NF_DROP;
+		break;
+	default:
+		return NF_ACCEPT;
+	}
+
+	return nft_do_chain(&pkt, priv);
+}
+
 static const struct nft_chain_type nft_chain_filter_inet = {
 	.name		= "filter",
 	.type		= NFT_CHAIN_T_DEFAULT,
 	.family		= NFPROTO_INET,
-	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
+	.hook_mask	= (1 << NF_INET_INGRESS) |
+			  (1 << NF_INET_LOCAL_IN) |
 			  (1 << NF_INET_LOCAL_OUT) |
 			  (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_POST_ROUTING),
 	.hooks		= {
+		[NF_INET_INGRESS]	= nft_do_chain_inet_ingress,
 		[NF_INET_LOCAL_IN]	= nft_do_chain_inet,
 		[NF_INET_LOCAL_OUT]	= nft_do_chain_inet,
 		[NF_INET_FORWARD]	= nft_do_chain_inet,
-- 
2.20.1

