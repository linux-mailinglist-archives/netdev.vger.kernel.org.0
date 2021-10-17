Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98D6430CAB
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344797AbhJQWSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:18:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53396 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344778AbhJQWR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:58 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6EEE563F29;
        Mon, 18 Oct 2021 00:14:06 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 12/15] netfilter: ipvs: remove unneeded output wrappers
Date:   Mon, 18 Oct 2021 00:15:19 +0200
Message-Id: <20211017221522.853838-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211017221522.853838-1-pablo@netfilter.org>
References: <20211017221522.853838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

After earlier patch we can use ip_vs_out_hook directly.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 62 ++++-----------------------------
 1 file changed, 6 insertions(+), 56 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 5a5deee3425c..2db033455204 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1471,56 +1471,6 @@ ip_vs_out_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *stat
 	return NF_ACCEPT;
 }
 
-/*
- *	It is hooked at the NF_INET_FORWARD and NF_INET_LOCAL_IN chain,
- *	used only for VS/NAT.
- *	Check if packet is reply for established ip_vs_conn.
- */
-static unsigned int
-ip_vs_reply4(void *priv, struct sk_buff *skb,
-	     const struct nf_hook_state *state)
-{
-	return ip_vs_out_hook(priv, skb, state);
-}
-
-/*
- *	It is hooked at the NF_INET_LOCAL_OUT chain, used only for VS/NAT.
- *	Check if packet is reply for established ip_vs_conn.
- */
-static unsigned int
-ip_vs_local_reply4(void *priv, struct sk_buff *skb,
-		   const struct nf_hook_state *state)
-{
-	return ip_vs_out_hook(priv, skb, state);
-}
-
-#ifdef CONFIG_IP_VS_IPV6
-
-/*
- *	It is hooked at the NF_INET_FORWARD and NF_INET_LOCAL_IN chain,
- *	used only for VS/NAT.
- *	Check if packet is reply for established ip_vs_conn.
- */
-static unsigned int
-ip_vs_reply6(void *priv, struct sk_buff *skb,
-	     const struct nf_hook_state *state)
-{
-	return ip_vs_out_hook(priv, skb, state);
-}
-
-/*
- *	It is hooked at the NF_INET_LOCAL_OUT chain, used only for VS/NAT.
- *	Check if packet is reply for established ip_vs_conn.
- */
-static unsigned int
-ip_vs_local_reply6(void *priv, struct sk_buff *skb,
-		   const struct nf_hook_state *state)
-{
-	return ip_vs_out_hook(priv, skb, state);
-}
-
-#endif
-
 static unsigned int
 ip_vs_try_to_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 		      struct ip_vs_proto_data *pd,
@@ -2243,7 +2193,7 @@ ip_vs_forward_icmp_v6(void *priv, struct sk_buff *skb,
 static const struct nf_hook_ops ip_vs_ops4[] = {
 	/* After packet filtering, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_reply4,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC - 2,
@@ -2259,7 +2209,7 @@ static const struct nf_hook_ops ip_vs_ops4[] = {
 	},
 	/* Before ip_vs_in, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_local_reply4,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_NAT_DST + 1,
@@ -2281,7 +2231,7 @@ static const struct nf_hook_ops ip_vs_ops4[] = {
 	},
 	/* After packet filtering, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_reply4,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= 100,
@@ -2292,7 +2242,7 @@ static const struct nf_hook_ops ip_vs_ops4[] = {
 static const struct nf_hook_ops ip_vs_ops6[] = {
 	/* After packet filtering, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_reply6,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_NAT_SRC - 2,
@@ -2308,7 +2258,7 @@ static const struct nf_hook_ops ip_vs_ops6[] = {
 	},
 	/* Before ip_vs_in, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_local_reply6,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_NAT_DST + 1,
@@ -2330,7 +2280,7 @@ static const struct nf_hook_ops ip_vs_ops6[] = {
 	},
 	/* After packet filtering, change source only for VS/NAT */
 	{
-		.hook		= ip_vs_reply6,
+		.hook		= ip_vs_out_hook,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= 100,
-- 
2.30.2

