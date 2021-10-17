Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7D3430CA8
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344794AbhJQWSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:18:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53402 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344779AbhJQWR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:58 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 911ED63F10;
        Mon, 18 Oct 2021 00:14:07 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 14/15] netfilter: ipvs: merge ipv4 + ipv6 icmp reply handlers
Date:   Mon, 18 Oct 2021 00:15:21 +0200
Message-Id: <20211017221522.853838-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211017221522.853838-1-pablo@netfilter.org>
References: <20211017221522.853838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Similar to earlier patches: allow ipv4 and ipv6 to use the
same handler.  ipv4 and ipv6 specific actions can be done by
checking state->pf.

v2: split the pf == NFPROTO_IPV4 check (Julian Anastasov)

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 37 +++++++++++++--------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index ad5f5e50547f..e93c937a8bf0 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2106,40 +2106,31 @@ static unsigned int
 ip_vs_forward_icmp(void *priv, struct sk_buff *skb,
 		   const struct nf_hook_state *state)
 {
-	int r;
 	struct netns_ipvs *ipvs = net_ipvs(state->net);
-
-	if (ip_hdr(skb)->protocol != IPPROTO_ICMP)
-		return NF_ACCEPT;
+	int r;
 
 	/* ipvs enabled in this netns ? */
 	if (unlikely(sysctl_backup_only(ipvs) || !ipvs->enable))
 		return NF_ACCEPT;
 
-	return ip_vs_in_icmp(ipvs, skb, &r, state->hook);
-}
-
+	if (state->pf == NFPROTO_IPV4) {
+		if (ip_hdr(skb)->protocol != IPPROTO_ICMP)
+			return NF_ACCEPT;
 #ifdef CONFIG_IP_VS_IPV6
-static unsigned int
-ip_vs_forward_icmp_v6(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
-{
-	int r;
-	struct netns_ipvs *ipvs = net_ipvs(state->net);
-	struct ip_vs_iphdr iphdr;
+	} else {
+		struct ip_vs_iphdr iphdr;
 
-	ip_vs_fill_iph_skb(AF_INET6, skb, false, &iphdr);
-	if (iphdr.protocol != IPPROTO_ICMPV6)
-		return NF_ACCEPT;
+		ip_vs_fill_iph_skb(AF_INET6, skb, false, &iphdr);
 
-	/* ipvs enabled in this netns ? */
-	if (unlikely(sysctl_backup_only(ipvs) || !ipvs->enable))
-		return NF_ACCEPT;
+		if (iphdr.protocol != IPPROTO_ICMPV6)
+			return NF_ACCEPT;
 
-	return ip_vs_in_icmp_v6(ipvs, skb, &r, state->hook, &iphdr);
-}
+		return ip_vs_in_icmp_v6(ipvs, skb, &r, state->hook, &iphdr);
 #endif
+	}
 
+	return ip_vs_in_icmp(ipvs, skb, &r, state->hook);
+}
 
 static const struct nf_hook_ops ip_vs_ops4[] = {
 	/* After packet filtering, change source only for VS/NAT */
@@ -2224,7 +2215,7 @@ static const struct nf_hook_ops ip_vs_ops6[] = {
 	/* After packet filtering (but before ip_vs_out_icmp), catch icmp
 	 * destined for 0.0.0.0/0, which is for incoming IPVS connections */
 	{
-		.hook		= ip_vs_forward_icmp_v6,
+		.hook		= ip_vs_forward_icmp,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= 99,
-- 
2.30.2

