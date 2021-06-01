Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412BD397C30
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbhFAWIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39558 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbhFAWIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:22 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A26CC641D0;
        Wed,  2 Jun 2021 00:05:33 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 13/16] netfilter: nf_tables: remove unused arg in nft_set_pktinfo_unspec()
Date:   Wed,  2 Jun 2021 00:06:26 +0200
Message-Id: <20210601220629.18307-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The functions pass extra skb arg, but either its not used or the helpers
can already access it via pkt->skb.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h      |  3 +--
 include/net/netfilter/nf_tables_ipv4.h | 28 +++++++++++-------------
 include/net/netfilter/nf_tables_ipv6.h | 30 +++++++++++---------------
 net/netfilter/nft_chain_filter.c       | 26 +++++++++++-----------
 net/netfilter/nft_chain_nat.c          |  4 ++--
 net/netfilter/nft_chain_route.c        |  4 ++--
 6 files changed, 43 insertions(+), 52 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 10c1b8759990..958b8e68bb1a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -72,8 +72,7 @@ static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 	pkt->xt.state = state;
 }
 
-static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt,
-					  struct sk_buff *skb)
+static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt)
 {
 	pkt->tprot_set = false;
 	pkt->tprot = 0;
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index 1f7bea39ad1b..b185a9216bf1 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -5,8 +5,7 @@
 #include <net/netfilter/nf_tables.h>
 #include <net/ip.h>
 
-static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt,
-					struct sk_buff *skb)
+static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt)
 {
 	struct iphdr *ip;
 
@@ -17,14 +16,13 @@ static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt,
 	pkt->xt.fragoff = ntohs(ip->frag_off) & IP_OFFSET;
 }
 
-static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
-						  struct sk_buff *skb)
+static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 {
 	struct iphdr *iph, _iph;
 	u32 len, thoff;
 
-	iph = skb_header_pointer(skb, skb_network_offset(skb), sizeof(*iph),
-				 &_iph);
+	iph = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
+				 sizeof(*iph), &_iph);
 	if (!iph)
 		return -1;
 
@@ -33,7 +31,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
 
 	len = ntohs(iph->tot_len);
 	thoff = iph->ihl * 4;
-	if (skb->len < len)
+	if (pkt->skb->len < len)
 		return -1;
 	else if (len < thoff)
 		return -1;
@@ -46,29 +44,27 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
 	return 0;
 }
 
-static inline void nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
-						 struct sk_buff *skb)
+static inline void nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 {
-	if (__nft_set_pktinfo_ipv4_validate(pkt, skb) < 0)
-		nft_set_pktinfo_unspec(pkt, skb);
+	if (__nft_set_pktinfo_ipv4_validate(pkt) < 0)
+		nft_set_pktinfo_unspec(pkt);
 }
 
-static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt,
-					       struct sk_buff *skb)
+static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 {
 	struct iphdr *iph;
 	u32 len, thoff;
 
-	if (!pskb_may_pull(skb, sizeof(*iph)))
+	if (!pskb_may_pull(pkt->skb, sizeof(*iph)))
 		return -1;
 
-	iph = ip_hdr(skb);
+	iph = ip_hdr(pkt->skb);
 	if (iph->ihl < 5 || iph->version != 4)
 		goto inhdr_error;
 
 	len = ntohs(iph->tot_len);
 	thoff = iph->ihl * 4;
-	if (skb->len < len) {
+	if (pkt->skb->len < len) {
 		__IP_INC_STATS(nft_net(pkt), IPSTATS_MIB_INTRUNCATEDPKTS);
 		return -1;
 	} else if (len < thoff) {
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index 867de29f3f7a..bf132d488b17 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -6,8 +6,7 @@
 #include <net/ipv6.h>
 #include <net/netfilter/nf_tables.h>
 
-static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
-					struct sk_buff *skb)
+static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt)
 {
 	unsigned int flags = IP6_FH_F_AUTH;
 	int protohdr, thoff = 0;
@@ -15,7 +14,7 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
 	if (protohdr < 0) {
-		nft_set_pktinfo_unspec(pkt, skb);
+		nft_set_pktinfo_unspec(pkt);
 		return;
 	}
 
@@ -25,8 +24,7 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
 	pkt->xt.fragoff = frag_off;
 }
 
-static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
-						  struct sk_buff *skb)
+static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	unsigned int flags = IP6_FH_F_AUTH;
@@ -36,8 +34,8 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 	int protohdr;
 	u32 pkt_len;
 
-	ip6h = skb_header_pointer(skb, skb_network_offset(skb), sizeof(*ip6h),
-				  &_ip6h);
+	ip6h = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
+				  sizeof(*ip6h), &_ip6h);
 	if (!ip6h)
 		return -1;
 
@@ -45,7 +43,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 		return -1;
 
 	pkt_len = ntohs(ip6h->payload_len);
-	if (pkt_len + sizeof(*ip6h) > skb->len)
+	if (pkt_len + sizeof(*ip6h) > pkt->skb->len)
 		return -1;
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
@@ -63,15 +61,13 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 #endif
 }
 
-static inline void nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
-						 struct sk_buff *skb)
+static inline void nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 {
-	if (__nft_set_pktinfo_ipv6_validate(pkt, skb) < 0)
-		nft_set_pktinfo_unspec(pkt, skb);
+	if (__nft_set_pktinfo_ipv6_validate(pkt) < 0)
+		nft_set_pktinfo_unspec(pkt);
 }
 
-static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt,
-					       struct sk_buff *skb)
+static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	unsigned int flags = IP6_FH_F_AUTH;
@@ -82,15 +78,15 @@ static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt,
 	int protohdr;
 	u32 pkt_len;
 
-	if (!pskb_may_pull(skb, sizeof(*ip6h)))
+	if (!pskb_may_pull(pkt->skb, sizeof(*ip6h)))
 		return -1;
 
-	ip6h = ipv6_hdr(skb);
+	ip6h = ipv6_hdr(pkt->skb);
 	if (ip6h->version != 6)
 		goto inhdr_error;
 
 	pkt_len = ntohs(ip6h->payload_len);
-	if (pkt_len + sizeof(*ip6h) > skb->len) {
+	if (pkt_len + sizeof(*ip6h) > pkt->skb->len) {
 		idev = __in6_dev_get(nft_in(pkt));
 		__IP6_INC_STATS(nft_net(pkt), idev, IPSTATS_MIB_INTRUNCATEDPKTS);
 		return -1;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 363bdd7044ec..5b02408a920b 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -18,7 +18,7 @@ static unsigned int nft_do_chain_ipv4(void *priv,
 	struct nft_pktinfo pkt;
 
 	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_ipv4(&pkt, skb);
+	nft_set_pktinfo_ipv4(&pkt);
 
 	return nft_do_chain(&pkt, priv);
 }
@@ -62,7 +62,7 @@ static unsigned int nft_do_chain_arp(void *priv, struct sk_buff *skb,
 	struct nft_pktinfo pkt;
 
 	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_unspec(&pkt, skb);
+	nft_set_pktinfo_unspec(&pkt);
 
 	return nft_do_chain(&pkt, priv);
 }
@@ -102,7 +102,7 @@ static unsigned int nft_do_chain_ipv6(void *priv,
 	struct nft_pktinfo pkt;
 
 	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_ipv6(&pkt, skb);
+	nft_set_pktinfo_ipv6(&pkt);
 
 	return nft_do_chain(&pkt, priv);
 }
@@ -149,10 +149,10 @@ static unsigned int nft_do_chain_inet(void *priv, struct sk_buff *skb,
 
 	switch (state->pf) {
 	case NFPROTO_IPV4:
-		nft_set_pktinfo_ipv4(&pkt, skb);
+		nft_set_pktinfo_ipv4(&pkt);
 		break;
 	case NFPROTO_IPV6:
-		nft_set_pktinfo_ipv6(&pkt, skb);
+		nft_set_pktinfo_ipv6(&pkt);
 		break;
 	default:
 		break;
@@ -174,7 +174,7 @@ static unsigned int nft_do_chain_inet_ingress(void *priv, struct sk_buff *skb,
 		ingress_state.hook = NF_INET_INGRESS;
 		nft_set_pktinfo(&pkt, skb, &ingress_state);
 
-		if (nft_set_pktinfo_ipv4_ingress(&pkt, skb) < 0)
+		if (nft_set_pktinfo_ipv4_ingress(&pkt) < 0)
 			return NF_DROP;
 		break;
 	case htons(ETH_P_IPV6):
@@ -182,7 +182,7 @@ static unsigned int nft_do_chain_inet_ingress(void *priv, struct sk_buff *skb,
 		ingress_state.hook = NF_INET_INGRESS;
 		nft_set_pktinfo(&pkt, skb, &ingress_state);
 
-		if (nft_set_pktinfo_ipv6_ingress(&pkt, skb) < 0)
+		if (nft_set_pktinfo_ipv6_ingress(&pkt) < 0)
 			return NF_DROP;
 		break;
 	default:
@@ -238,13 +238,13 @@ nft_do_chain_bridge(void *priv,
 
 	switch (eth_hdr(skb)->h_proto) {
 	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt, skb);
+		nft_set_pktinfo_ipv4_validate(&pkt);
 		break;
 	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt, skb);
+		nft_set_pktinfo_ipv6_validate(&pkt);
 		break;
 	default:
-		nft_set_pktinfo_unspec(&pkt, skb);
+		nft_set_pktinfo_unspec(&pkt);
 		break;
 	}
 
@@ -293,13 +293,13 @@ static unsigned int nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt, skb);
+		nft_set_pktinfo_ipv4_validate(&pkt);
 		break;
 	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt, skb);
+		nft_set_pktinfo_ipv6_validate(&pkt);
 		break;
 	default:
-		nft_set_pktinfo_unspec(&pkt, skb);
+		nft_set_pktinfo_unspec(&pkt);
 		break;
 	}
 
diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index eac4a901233f..98e4946100c5 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -17,12 +17,12 @@ static unsigned int nft_nat_do_chain(void *priv, struct sk_buff *skb,
 	switch (state->pf) {
 #ifdef CONFIG_NF_TABLES_IPV4
 	case NFPROTO_IPV4:
-		nft_set_pktinfo_ipv4(&pkt, skb);
+		nft_set_pktinfo_ipv4(&pkt);
 		break;
 #endif
 #ifdef CONFIG_NF_TABLES_IPV6
 	case NFPROTO_IPV6:
-		nft_set_pktinfo_ipv6(&pkt, skb);
+		nft_set_pktinfo_ipv6(&pkt);
 		break;
 #endif
 	default:
diff --git a/net/netfilter/nft_chain_route.c b/net/netfilter/nft_chain_route.c
index edd02cda57fc..925db0dce48d 100644
--- a/net/netfilter/nft_chain_route.c
+++ b/net/netfilter/nft_chain_route.c
@@ -26,7 +26,7 @@ static unsigned int nf_route_table_hook4(void *priv,
 	u8 tos;
 
 	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_ipv4(&pkt, skb);
+	nft_set_pktinfo_ipv4(&pkt);
 
 	mark = skb->mark;
 	iph = ip_hdr(skb);
@@ -74,7 +74,7 @@ static unsigned int nf_route_table_hook6(void *priv,
 	int err;
 
 	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_ipv6(&pkt, skb);
+	nft_set_pktinfo_ipv6(&pkt);
 
 	/* save source/dest address, mark, hoplimit, flowlabel, priority */
 	memcpy(&saddr, &ipv6_hdr(skb)->saddr, sizeof(saddr));
-- 
2.30.2

