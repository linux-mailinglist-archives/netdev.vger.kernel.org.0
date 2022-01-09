Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3854A488D25
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbiAIXRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:07 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42124 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237416AbiAIXRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:17:01 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0BC29607C1;
        Mon, 10 Jan 2022 00:14:10 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 17/32] net: prefer nf_ct_put instead of nf_conntrack_put
Date:   Mon, 10 Jan 2022 00:16:25 +0100
Message-Id: <20220109231640.104123-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its the same as nf_conntrack_put(), but without the
need for an indirect call.  The downside is a module dependency on
nf_conntrack, but all of these already depend on conntrack anyway.

Cc: Paul Blakey <paulb@mellanox.com>
Cc: dev@openvswitch.org
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c |  4 ++--
 net/openvswitch/conntrack.c       | 14 ++++++++++----
 net/sched/act_ct.c                |  6 +++---
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7a2063abae04..c74933a6039f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -989,7 +989,7 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 
 		nf_ct_acct_merge(ct, ctinfo, loser_ct);
 		nf_ct_add_to_dying_list(loser_ct);
-		nf_conntrack_put(&loser_ct->ct_general);
+		nf_ct_put(loser_ct);
 		nf_ct_set(skb, ct, ctinfo);
 
 		NF_CT_STAT_INC(net, clash_resolve);
@@ -1921,7 +1921,7 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
 		pr_debug("nf_conntrack_in: Can't track with proto module\n");
-		nf_conntrack_put(&ct->ct_general);
+		nf_ct_put(ct);
 		skb->_nfct = 0;
 		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 		if (ret == -NF_DROP)
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 121664e52271..a921c5c00a1b 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -574,7 +574,7 @@ ovs_ct_expect_find(struct net *net, const struct nf_conntrack_zone *zone,
 			struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 
 			nf_ct_delete(ct, 0, 0);
-			nf_conntrack_put(&ct->ct_general);
+			nf_ct_put(ct);
 		}
 	}
 
@@ -723,7 +723,7 @@ static bool skb_nfct_cached(struct net *net,
 		if (nf_ct_is_confirmed(ct))
 			nf_ct_delete(ct, 0, 0);
 
-		nf_conntrack_put(&ct->ct_general);
+		nf_ct_put(ct);
 		nf_ct_set(skb, NULL, 0);
 		return false;
 	}
@@ -967,7 +967,8 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 
 		/* Associate skb with specified zone. */
 		if (tmpl) {
-			nf_conntrack_put(skb_nfct(skb));
+			ct = nf_ct_get(skb, &ctinfo);
+			nf_ct_put(ct);
 			nf_conntrack_get(&tmpl->ct_general);
 			nf_ct_set(skb, tmpl, IP_CT_NEW);
 		}
@@ -1328,7 +1329,12 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
 
 int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 {
-	nf_conntrack_put(skb_nfct(skb));
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+
+	nf_ct_put(ct);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 	ovs_ct_fill_key(skb, key, false);
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 3fa904cf8f27..9db291b45878 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -598,7 +598,7 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 		if (nf_ct_is_confirmed(ct))
 			nf_ct_kill(ct);
 
-		nf_conntrack_put(&ct->ct_general);
+		nf_ct_put(ct);
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 
 		return false;
@@ -763,7 +763,7 @@ static void tcf_ct_params_free(struct rcu_head *head)
 	tcf_ct_flow_table_put(params);
 
 	if (params->tmpl)
-		nf_conntrack_put(&params->tmpl->ct_general);
+		nf_ct_put(params->tmpl);
 	kfree(params);
 }
 
@@ -967,7 +967,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		qdisc_skb_cb(skb)->post_ct = false;
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct) {
-			nf_conntrack_put(&ct->ct_general);
+			nf_ct_put(ct);
 			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 		}
 
-- 
2.30.2

