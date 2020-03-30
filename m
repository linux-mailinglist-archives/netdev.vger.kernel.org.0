Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A0619842B
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgC3TW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:22:28 -0400
Received: from correo.us.es ([193.147.175.20]:48570 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbgC3TWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:22:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23A4F10328A
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:22:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE136100A6C
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 21:22:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0BD7F1021A1; Mon, 30 Mar 2020 21:21:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEEC9100A4C;
        Mon, 30 Mar 2020 21:21:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 21:21:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 84F9242EF4E1;
        Mon, 30 Mar 2020 21:21:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 18/28] netfilter: nf_queue: place bridge physports into queue_entry struct
Date:   Mon, 30 Mar 2020 21:21:26 +0200
Message-Id: <20200330192136.230459-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330192136.230459-1-pablo@netfilter.org>
References: <20200330192136.230459-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The refcount is done via entry->skb, which does work fine.
Major problem: When putting the refcount of the bridge ports, we
must always put the references while the skb is still around.

However, we will need to put the references after okfn() to avoid
a possible 1 -> 0 -> 1 refcount transition, so we cannot use the
skb pointer anymore.

Place the physports in the queue entry structure instead to allow
for refcounting changes in the next patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_queue.h |  5 +++-
 net/netfilter/nf_queue.c         | 53 +++++++++++++++++-----------------------
 2 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index cdbd98730852..e770bba00066 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -14,7 +14,10 @@ struct nf_queue_entry {
 	struct sk_buff		*skb;
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
-
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	struct net_device	*physin;
+	struct net_device	*physout;
+#endif
 	struct nf_hook_state	state;
 	u16			size; /* sizeof(entry) + saved route keys */
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 4da5776a9904..96eb72908467 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -46,24 +46,6 @@ void nf_unregister_queue_handler(struct net *net)
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
 
-static void nf_queue_entry_release_br_nf_refs(struct sk_buff *skb)
-{
-#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
-
-	if (nf_bridge) {
-		struct net_device *physdev;
-
-		physdev = nf_bridge_get_physindev(skb);
-		if (physdev)
-			dev_put(physdev);
-		physdev = nf_bridge_get_physoutdev(skb);
-		if (physdev)
-			dev_put(physdev);
-	}
-#endif
-}
-
 static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
@@ -76,7 +58,12 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	if (state->sk)
 		sock_put(state->sk);
 
-	nf_queue_entry_release_br_nf_refs(entry->skb);
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (entry->physin)
+		dev_put(entry->physin);
+	if (entry->physout)
+		dev_put(entry->physout);
+#endif
 }
 
 void nf_queue_entry_free(struct nf_queue_entry *entry)
@@ -86,20 +73,19 @@ void nf_queue_entry_free(struct nf_queue_entry *entry)
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_free);
 
-static void nf_queue_entry_get_br_nf_refs(struct sk_buff *skb)
+static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
+	const struct sk_buff *skb = entry->skb;
+	struct nf_bridge_info *nf_bridge;
 
+	nf_bridge = nf_bridge_info_get(skb);
 	if (nf_bridge) {
-		struct net_device *physdev;
-
-		physdev = nf_bridge_get_physindev(skb);
-		if (physdev)
-			dev_hold(physdev);
-		physdev = nf_bridge_get_physoutdev(skb);
-		if (physdev)
-			dev_hold(physdev);
+		entry->physin = nf_bridge_get_physindev(skb);
+		entry->physout = nf_bridge_get_physoutdev(skb);
+	} else {
+		entry->physin = NULL;
+		entry->physout = NULL;
 	}
 #endif
 }
@@ -116,7 +102,12 @@ void nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 	if (state->sk)
 		sock_hold(state->sk);
 
-	nf_queue_entry_get_br_nf_refs(entry->skb);
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (entry->physin)
+		dev_hold(entry->physin);
+	if (entry->physout)
+		dev_hold(entry->physout);
+#endif
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
 
@@ -207,6 +198,8 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		.size	= sizeof(*entry) + route_key_size,
 	};
 
+	__nf_queue_entry_init_physdevs(entry);
+
 	nf_queue_entry_get_refs(entry);
 
 	switch (entry->state.pf) {
-- 
2.11.0

