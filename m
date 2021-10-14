Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF1E42D8F6
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhJNMNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhJNMNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:13:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478F1C061570;
        Thu, 14 Oct 2021 05:11:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mazZn-0002kt-RV; Thu, 14 Oct 2021 14:11:11 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, me@ubique.spb.ru,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 2/9] netfilter: nat: split nat hook iteration into a helper
Date:   Thu, 14 Oct 2021 14:10:39 +0200
Message-Id: <20211014121046.29329-4-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014121046.29329-1-fw@strlen.de>
References: <20211014121046.29329-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Makes conversion in followup patch simpler.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c | 46 +++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 273117683922..a6a273fff3f6 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -699,6 +699,32 @@ unsigned int nf_nat_packet(struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(nf_nat_packet);
 
+static unsigned int nf_nat_inet_run_hooks(const struct nf_hook_state *state,
+					  struct sk_buff *skb,
+					  struct nf_conn *ct,
+					  struct nf_nat_lookup_hook_priv *lpriv)
+{
+	enum nf_nat_manip_type maniptype = HOOK2MANIP(state->hook);
+	struct nf_hook_entries *e = rcu_dereference(lpriv->entries);
+	unsigned int ret;
+	int i;
+
+	if (!e)
+		goto null_bind;
+
+	for (i = 0; i < e->num_hook_entries; i++) {
+		ret = e->hooks[i].hook(e->hooks[i].priv, skb, state);
+		if (ret != NF_ACCEPT)
+			return ret;
+
+		if (nf_nat_initialized(ct, maniptype))
+			return NF_ACCEPT;
+	}
+
+null_bind:
+	return nf_nat_alloc_null_binding(ct, state->hook);
+}
+
 unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state)
@@ -730,23 +756,9 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 		 */
 		if (!nf_nat_initialized(ct, maniptype)) {
 			struct nf_nat_lookup_hook_priv *lpriv = priv;
-			struct nf_hook_entries *e = rcu_dereference(lpriv->entries);
 			unsigned int ret;
-			int i;
-
-			if (!e)
-				goto null_bind;
-
-			for (i = 0; i < e->num_hook_entries; i++) {
-				ret = e->hooks[i].hook(e->hooks[i].priv, skb,
-						       state);
-				if (ret != NF_ACCEPT)
-					return ret;
-				if (nf_nat_initialized(ct, maniptype))
-					goto do_nat;
-			}
-null_bind:
-			ret = nf_nat_alloc_null_binding(ct, state->hook);
+
+			ret = nf_nat_inet_run_hooks(state, skb, ct, lpriv);
 			if (ret != NF_ACCEPT)
 				return ret;
 		} else {
@@ -765,7 +777,7 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 		if (nf_nat_oif_changed(state->hook, ctinfo, nat, state->out))
 			goto oif_changed;
 	}
-do_nat:
+
 	return nf_nat_packet(ct, ctinfo, state->hook, skb);
 
 oif_changed:
-- 
2.32.0

