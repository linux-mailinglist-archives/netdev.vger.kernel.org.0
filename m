Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA9142D8F7
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhJNMNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhJNMNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:13:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873A8C061570;
        Thu, 14 Oct 2021 05:11:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mazZs-0002lQ-3s; Thu, 14 Oct 2021 14:11:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, me@ubique.spb.ru,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 3/9] netfilter: remove hook index from nf_hook_slow arguments
Date:   Thu, 14 Oct 2021 14:10:40 +0200
Message-Id: <20211014121046.29329-5-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014121046.29329-1-fw@strlen.de>
References: <20211014121046.29329-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous patch added hook_entry member to nf_hook_state struct, so
use that for passing the index.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h         | 5 +++--
 include/linux/netfilter_ingress.h | 2 +-
 net/bridge/br_netfilter_hooks.c   | 3 ++-
 net/netfilter/core.c              | 6 +++---
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 1d8b87abd54c..61a8c8ded57b 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -154,6 +154,7 @@ static inline void nf_hook_state_init(struct nf_hook_state *p,
 {
 	p->hook = hook;
 	p->pf = pf;
+	p->hook_index = 0;
 	p->in = indev;
 	p->out = outdev;
 	p->sk = sk;
@@ -198,7 +199,7 @@ extern struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 #endif
 
 int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
-		 const struct nf_hook_entries *e, unsigned int i);
+		 const struct nf_hook_entries *e);
 
 void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
 		       const struct nf_hook_entries *e);
@@ -260,7 +261,7 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 		nf_hook_state_init(&state, hook, pf, indev, outdev,
 				   sk, net, okfn);
 
-		ret = nf_hook_slow(skb, &state, hook_head, 0);
+		ret = nf_hook_slow(skb, &state, hook_head);
 	}
 	rcu_read_unlock();
 
diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_ingress.h
index a13774be2eb5..c95f84a5badc 100644
--- a/include/linux/netfilter_ingress.h
+++ b/include/linux/netfilter_ingress.h
@@ -31,7 +31,7 @@ static inline int nf_hook_ingress(struct sk_buff *skb)
 	nf_hook_state_init(&state, NF_NETDEV_INGRESS,
 			   NFPROTO_NETDEV, skb->dev, NULL, NULL,
 			   dev_net(skb->dev), NULL);
-	ret = nf_hook_slow(skb, &state, e, 0);
+	ret = nf_hook_slow(skb, &state, e);
 	if (ret == 0)
 		return -1;
 
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 8edfb98ae1d5..5ed8b698ce11 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1020,7 +1020,8 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 	nf_hook_state_init(&state, hook, NFPROTO_BRIDGE, indev, outdev,
 			   sk, net, okfn);
 
-	ret = nf_hook_slow(skb, &state, e, i);
+	state.hook_index = i;
+	ret = nf_hook_slow(skb, &state, e);
 	if (ret == 1)
 		ret = okfn(net, sk, skb);
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 57685334d32b..129d48304821 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -580,9 +580,9 @@ EXPORT_SYMBOL(nf_unregister_net_hooks);
 /* Returns 1 if okfn() needs to be executed by the caller,
  * -EPERM for NF_DROP, 0 otherwise.  Caller must hold rcu_read_lock. */
 int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
-		 const struct nf_hook_entries *e, unsigned int s)
+		 const struct nf_hook_entries *e)
 {
-	unsigned int verdict;
+	unsigned int verdict, s = state->hook_index;
 	int ret;
 
 	for (; s < e->num_hook_entries; s++) {
@@ -625,7 +625,7 @@ void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
 
 	list_for_each_entry_safe(skb, next, head, list) {
 		skb_list_del_init(skb);
-		ret = nf_hook_slow(skb, state, e, 0);
+		ret = nf_hook_slow(skb, state, e);
 		if (ret == 1)
 			list_add_tail(&skb->list, &sublist);
 	}
-- 
2.32.0

