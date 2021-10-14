Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0081C42D8F3
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhJNMNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbhJNMNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:13:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06046C061570;
        Thu, 14 Oct 2021 05:11:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mazZj-0002kW-J6; Thu, 14 Oct 2021 14:11:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, me@ubique.spb.ru,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 1/9] netfilter: nf_queue: carry index in hook state
Date:   Thu, 14 Oct 2021 14:10:38 +0200
Message-Id: <20211014121046.29329-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014121046.29329-1-fw@strlen.de>
References: <20211014121046.29329-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than passing the index (hook function to call next)
as function argument, store it in the hook state.

This is a prerequesite to allow passing all nf hook arguments in a single
structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h        |  1 +
 include/net/netfilter/nf_queue.h |  3 +--
 net/bridge/br_input.c            |  3 ++-
 net/netfilter/core.c             |  6 +++++-
 net/netfilter/nf_queue.c         | 12 ++++++------
 5 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 3fda1a508733..1d8b87abd54c 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -67,6 +67,7 @@ struct sock;
 struct nf_hook_state {
 	u8 hook;
 	u8 pf;
+	u16 hook_index; /* index in hook_entries->hook[] */
 	struct net_device *in;
 	struct net_device *out;
 	struct sock *sk;
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 9eed51e920e8..bc245b96143a 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -13,7 +13,6 @@ struct nf_queue_entry {
 	struct list_head	list;
 	struct sk_buff		*skb;
 	unsigned int		id;
-	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	struct net_device	*physin;
 	struct net_device	*physout;
@@ -125,6 +124,6 @@ nfqueue_hash(const struct sk_buff *skb, u16 queue, u16 queues_total, u8 family,
 }
 
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
-	     unsigned int index, unsigned int verdict);
+	     unsigned int verdict);
 
 #endif /* _NF_QUEUE_H */
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index b50382f957c1..f0a025db263f 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -239,7 +239,8 @@ static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
 			kfree_skb(skb);
 			return RX_HANDLER_CONSUMED;
 		case NF_QUEUE:
-			ret = nf_queue(skb, &state, i, verdict);
+			state.hook_index = i;
+			ret = nf_queue(skb, &state, verdict);
 			if (ret == 1)
 				continue;
 			return RX_HANDLER_CONSUMED;
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 63d032191e62..57685334d32b 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -597,7 +597,8 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 				ret = -EPERM;
 			return ret;
 		case NF_QUEUE:
-			ret = nf_queue(skb, state, s, verdict);
+			state->hook_index = s;
+			ret = nf_queue(skb, state, verdict);
 			if (ret == 1)
 				continue;
 			return ret;
@@ -753,6 +754,9 @@ int __init netfilter_init(void)
 {
 	int ret;
 
+	/* state->index */
+	BUILD_BUG_ON(MAX_HOOK_COUNT > USHRT_MAX);
+
 	ret = register_pernet_subsys(&netfilter_net_ops);
 	if (ret < 0)
 		goto err;
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 6d12afabfe8a..a869ae3b9665 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -145,7 +145,7 @@ static void nf_ip6_saveroute(const struct sk_buff *skb,
 }
 
 static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
-		      unsigned int index, unsigned int queuenum)
+		      unsigned int queuenum)
 {
 	struct nf_queue_entry *entry = NULL;
 	const struct nf_queue_handler *qh;
@@ -181,7 +181,6 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
 		.state	= *state,
-		.hook_index = index,
 		.size	= sizeof(*entry) + route_key_size,
 	};
 
@@ -209,11 +208,11 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 
 /* Packets leaving via this function must come back through nf_reinject(). */
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
-	     unsigned int index, unsigned int verdict)
+	     unsigned int verdict)
 {
 	int ret;
 
-	ret = __nf_queue(skb, state, index, verdict >> NF_VERDICT_QBITS);
+	ret = __nf_queue(skb, state, verdict >> NF_VERDICT_QBITS);
 	if (ret < 0) {
 		if (ret == -ESRCH &&
 		    (verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
@@ -285,7 +284,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
-	i = entry->hook_index;
+	i = entry->state.hook_index;
 	if (WARN_ON_ONCE(!hooks || i >= hooks->num_hook_entries)) {
 		kfree_skb(skb);
 		nf_queue_entry_free(entry);
@@ -317,7 +316,8 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		local_bh_enable();
 		break;
 	case NF_QUEUE:
-		err = nf_queue(skb, &entry->state, i, verdict);
+		entry->state.hook_index = i;
+		err = nf_queue(skb, &entry->state, verdict);
 		if (err == 1)
 			goto next_hook;
 		break;
-- 
2.32.0

