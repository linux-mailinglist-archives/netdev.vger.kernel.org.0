Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576E1430CAD
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344802AbhJQWSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:18:04 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53440 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344782AbhJQWR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:58 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F2C65605E1;
        Mon, 18 Oct 2021 00:14:06 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 13/15] netfilter: ipvs: remove unneeded input wrappers
Date:   Mon, 18 Oct 2021 00:15:20 +0200
Message-Id: <20211017221522.853838-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211017221522.853838-1-pablo@netfilter.org>
References: <20211017221522.853838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

After earlier patch ip_vs_hook_in can be used directly.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 57 +++------------------------------
 1 file changed, 4 insertions(+), 53 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 2db033455204..ad5f5e50547f 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2093,55 +2093,6 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
 	return ret;
 }
 
-/*
- *	AF_INET handler in NF_INET_LOCAL_IN chain
- *	Schedule and forward packets from remote clients
- */
-static unsigned int
-ip_vs_remote_request4(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
-{
-	return ip_vs_in_hook(priv, skb, state);
-}
-
-/*
- *	AF_INET handler in NF_INET_LOCAL_OUT chain
- *	Schedule and forward packets from local clients
- */
-static unsigned int
-ip_vs_local_request4(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
-{
-	return ip_vs_in_hook(priv, skb, state);
-}
-
-#ifdef CONFIG_IP_VS_IPV6
-
-/*
- *	AF_INET6 handler in NF_INET_LOCAL_IN chain
- *	Schedule and forward packets from remote clients
- */
-static unsigned int
-ip_vs_remote_request6(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
-{
-	return ip_vs_in_hook(priv, skb, state);
-}
-
-/*
- *	AF_INET6 handler in NF_INET_LOCAL_OUT chain
- *	Schedule and forward packets from local clients
- */
-static unsigned int
-ip_vs_local_request6(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
-{
-	return ip_vs_in_hook(priv, skb, state);
-}
-
-#endif
-
-
 /*
  *	It is hooked at the NF_INET_FORWARD chain, in order to catch ICMP
  *      related packets destined for 0.0.0.0/0.
@@ -2202,7 +2153,7 @@ static const struct nf_hook_ops ip_vs_ops4[] = {
 	 * or VS/NAT(change destination), so that filtering rules can be
 	 * applied to IPVS. */
 	{
-		.hook		= ip_vs_remote_request4,
+		.hook		= ip_vs_in_hook,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC - 1,
@@ -2216,7 +2167,7 @@ static const struct nf_hook_ops ip_vs_ops4[] = {
 	},
 	/* After mangle, schedule and forward local requests */
 	{
-		.hook		= ip_vs_local_request4,
+		.hook		= ip_vs_in_hook,
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_NAT_DST + 2,
@@ -2251,7 +2202,7 @@ static const struct nf_hook_ops ip_vs_ops6[] = {
 	 * or VS/NAT(change destination), so that filtering rules can be
 	 * applied to IPVS. */
 	{
-		.hook		= ip_vs_remote_request6,
+		.hook		= ip_vs_in_hook,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_NAT_SRC - 1,
@@ -2265,7 +2216,7 @@ static const struct nf_hook_ops ip_vs_ops6[] = {
 	},
 	/* After mangle, schedule and forward local requests */
 	{
-		.hook		= ip_vs_local_request6,
+		.hook		= ip_vs_in_hook,
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_NAT_DST + 2,
-- 
2.30.2

