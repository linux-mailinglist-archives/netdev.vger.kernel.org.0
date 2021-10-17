Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BC9430CA7
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344767AbhJQWSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:18:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53460 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344772AbhJQWR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:57 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4C11763F04;
        Mon, 18 Oct 2021 00:14:05 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 10/15] netfilter: ebtables: allow use of ebt_do_table as hookfn
Date:   Mon, 18 Oct 2021 00:15:17 +0200
Message-Id: <20211017221522.853838-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211017221522.853838-1-pablo@netfilter.org>
References: <20211017221522.853838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This is possible now that the xt_table structure is passed via *priv.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_bridge/ebtables.h |  5 ++---
 net/bridge/netfilter/ebtable_broute.c     |  2 +-
 net/bridge/netfilter/ebtable_filter.c     | 13 +++----------
 net/bridge/netfilter/ebtable_nat.c        | 12 +++---------
 net/bridge/netfilter/ebtables.c           |  6 +++---
 5 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 10a01978bc0d..a13296d6c7ce 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -112,9 +112,8 @@ extern int ebt_register_table(struct net *net,
 			      const struct nf_hook_ops *ops);
 extern void ebt_unregister_table(struct net *net, const char *tablename);
 void ebt_unregister_table_pre_exit(struct net *net, const char *tablename);
-extern unsigned int ebt_do_table(struct sk_buff *skb,
-				 const struct nf_hook_state *state,
-				 struct ebt_table *table);
+extern unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
+				 const struct nf_hook_state *state);
 
 /* True if the hook mask denotes that the rule is in a base chain,
  * used in the check() functions */
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index a7af4eaff17d..1a11064f9990 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -66,7 +66,7 @@ static unsigned int ebt_broute(void *priv, struct sk_buff *skb,
 			   NFPROTO_BRIDGE, s->in, NULL, NULL,
 			   s->net, NULL);
 
-	ret = ebt_do_table(skb, &state, priv);
+	ret = ebt_do_table(priv, skb, &state);
 	if (ret != NF_DROP)
 		return ret;
 
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index c0b121df4a9a..cb949436bc0e 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -58,28 +58,21 @@ static const struct ebt_table frame_filter = {
 	.me		= THIS_MODULE,
 };
 
-static unsigned int
-ebt_filter_hook(void *priv, struct sk_buff *skb,
-		const struct nf_hook_state *state)
-{
-	return ebt_do_table(skb, state, priv);
-}
-
 static const struct nf_hook_ops ebt_ops_filter[] = {
 	{
-		.hook		= ebt_filter_hook,
+		.hook		= ebt_do_table,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_IN,
 		.priority	= NF_BR_PRI_FILTER_BRIDGED,
 	},
 	{
-		.hook		= ebt_filter_hook,
+		.hook		= ebt_do_table,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_FORWARD,
 		.priority	= NF_BR_PRI_FILTER_BRIDGED,
 	},
 	{
-		.hook		= ebt_filter_hook,
+		.hook		= ebt_do_table,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_OUT,
 		.priority	= NF_BR_PRI_FILTER_OTHER,
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 4078151c224f..5ee0531ae506 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -58,27 +58,21 @@ static const struct ebt_table frame_nat = {
 	.me		= THIS_MODULE,
 };
 
-static unsigned int ebt_nat_hook(void *priv, struct sk_buff *skb,
-				 const struct nf_hook_state *state)
-{
-	return ebt_do_table(skb, state, priv);
-}
-
 static const struct nf_hook_ops ebt_ops_nat[] = {
 	{
-		.hook		= ebt_nat_hook,
+		.hook		= ebt_do_table,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_OUT,
 		.priority	= NF_BR_PRI_NAT_DST_OTHER,
 	},
 	{
-		.hook		= ebt_nat_hook,
+		.hook		= ebt_do_table,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_POST_ROUTING,
 		.priority	= NF_BR_PRI_NAT_SRC,
 	},
 	{
-		.hook		= ebt_nat_hook,
+		.hook		= ebt_do_table,
 		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_PRE_ROUTING,
 		.priority	= NF_BR_PRI_NAT_DST_BRIDGED,
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 83d1798dfbb4..4a1508a1c566 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -189,10 +189,10 @@ ebt_get_target_c(const struct ebt_entry *e)
 }
 
 /* Do some firewalling */
-unsigned int ebt_do_table(struct sk_buff *skb,
-			  const struct nf_hook_state *state,
-			  struct ebt_table *table)
+unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
+			  const struct nf_hook_state *state)
 {
+	struct ebt_table *table = priv;
 	unsigned int hook = state->hook;
 	int i, nentries;
 	struct ebt_entry *point;
-- 
2.30.2

