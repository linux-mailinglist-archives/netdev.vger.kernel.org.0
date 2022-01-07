Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B6A4871A2
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346016AbiAGEDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346013AbiAGEDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:03:47 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2034CC061201;
        Thu,  6 Jan 2022 20:03:47 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1n5gTh-0005Oe-Iy; Fri, 07 Jan 2022 05:03:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/5] netfilter: core: move ip_ct_attach indirection to struct nf_ct_hook
Date:   Fri,  7 Jan 2022 05:03:23 +0100
Message-Id: <20220107040326.28038-3-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107040326.28038-1-fw@strlen.de>
References: <20220107040326.28038-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip_ct_attach predates struct nf_ct_hook, we can place it there and
remove the exported symbol.

Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.34.1

