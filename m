Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777EA488D1C
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbiAIXRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:02 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42124 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237405AbiAIXQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:58 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id EEB6864291;
        Mon, 10 Jan 2022 00:14:07 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 14/32] netfilter: core: move ip_ct_attach indirection to struct nf_ct_hook
Date:   Mon, 10 Jan 2022 00:16:22 +0100
Message-Id: <20220109231640.104123-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

ip_ct_attach predates struct nf_ct_hook, we can place it there and
remove the exported symbol.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h         |  2 +-
 net/netfilter/core.c              | 19 ++++++++-----------
 net/netfilter/nf_conntrack_core.c |  4 +---
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 3fda1a508733..e0e3f3355ab1 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -440,7 +440,6 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <linux/netfilter/nf_conntrack_zones_common.h>
 
-extern void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *) __rcu;
 void nf_ct_attach(struct sk_buff *, const struct sk_buff *);
 struct nf_conntrack_tuple;
 bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
@@ -463,6 +462,7 @@ struct nf_ct_hook {
 	void (*destroy)(struct nf_conntrack *);
 	bool (*get_tuple_skb)(struct nf_conntrack_tuple *,
 			      const struct sk_buff *);
+	void (*attach)(struct sk_buff *nskb, const struct sk_buff *skb);
 };
 extern struct nf_ct_hook __rcu *nf_ct_hook;
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 6dec9cd395f1..dc806dc9fe28 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -673,25 +673,22 @@ struct nf_ct_hook __rcu *nf_ct_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_hook);
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-/* This does not belong here, but locally generated errors need it if connection
-   tracking in use: without this, connection may not be in hash table, and hence
-   manufactured ICMP or RST packets will not be associated with it. */
-void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *)
-		__rcu __read_mostly;
-EXPORT_SYMBOL(ip_ct_attach);
-
 struct nf_nat_hook __rcu *nf_nat_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_hook);
 
+/* This does not belong here, but locally generated errors need it if connection
+ * tracking in use: without this, connection may not be in hash table, and hence
+ * manufactured ICMP or RST packets will not be associated with it.
+ */
 void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
 {
-	void (*attach)(struct sk_buff *, const struct sk_buff *);
+	const struct nf_ct_hook *ct_hook;
 
 	if (skb->_nfct) {
 		rcu_read_lock();
-		attach = rcu_dereference(ip_ct_attach);
-		if (attach)
-			attach(new, skb);
+		ct_hook = rcu_dereference(nf_ct_hook);
+		if (ct_hook)
+			ct_hook->attach(new, skb);
 		rcu_read_unlock();
 	}
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 328d359fcabe..89f1e5f0090b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2455,7 +2455,6 @@ static int kill_all(struct nf_conn *i, void *data)
 void nf_conntrack_cleanup_start(void)
 {
 	conntrack_gc_work.exiting = true;
-	RCU_INIT_POINTER(ip_ct_attach, NULL);
 }
 
 void nf_conntrack_cleanup_end(void)
@@ -2774,12 +2773,11 @@ static struct nf_ct_hook nf_conntrack_hook = {
 	.update		= nf_conntrack_update,
 	.destroy	= destroy_conntrack,
 	.get_tuple_skb  = nf_conntrack_get_tuple_skb,
+	.attach		= nf_conntrack_attach,
 };
 
 void nf_conntrack_init_end(void)
 {
-	/* For use by REJECT target */
-	RCU_INIT_POINTER(ip_ct_attach, nf_conntrack_attach);
 	RCU_INIT_POINTER(nf_ct_hook, &nf_conntrack_hook);
 }
 
-- 
2.30.2

