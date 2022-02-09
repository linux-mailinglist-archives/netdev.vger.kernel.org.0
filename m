Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790064AF2DE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbiBINg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbiBINgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:24 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FA13C0613C9;
        Wed,  9 Feb 2022 05:36:27 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8F001601CF;
        Wed,  9 Feb 2022 14:36:15 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/14] netfilter: conntrack: handle ->destroy hook via nat_ops instead
Date:   Wed,  9 Feb 2022 14:36:07 +0100
Message-Id: <20220209133616.165104-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The nat module already exposes a few functions to the conntrack core.
Move the nat extension destroy hook to it.

After this, no conntrack extension needs a destroy hook.
'struct nf_ct_ext_type' and the register/unregister api can be removed
in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h                   |  1 +
 include/net/netfilter/nf_conntrack_extend.h |  3 ---
 net/netfilter/nf_conntrack_core.c           | 14 ++++++++++++--
 net/netfilter/nf_conntrack_extend.c         | 21 ---------------------
 net/netfilter/nf_nat_core.c                 | 13 +++----------
 5 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 15e71bfff726..c2c6f332fb90 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -379,6 +379,7 @@ struct nf_nat_hook {
 	unsigned int (*manip_pkt)(struct sk_buff *skb, struct nf_conn *ct,
 				  enum nf_nat_manip_type mtype,
 				  enum ip_conntrack_dir dir);
+	void (*remove_nat_bysrc)(struct nf_conn *ct);
 };
 
 extern const struct nf_nat_hook __rcu *nf_nat_hook;
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 87d818414092..343f9194423a 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -79,9 +79,6 @@ void nf_ct_ext_destroy(struct nf_conn *ct);
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
 
 struct nf_ct_ext_type {
-	/* Destroys relationships (can be NULL). */
-	void (*destroy)(struct nf_conn *ct);
-
 	enum nf_ct_ext_id id;
 };
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9edd3ae8d62e..8f0c0c0fd329 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -594,7 +594,7 @@ EXPORT_SYMBOL_GPL(nf_ct_tmpl_alloc);
 
 void nf_ct_tmpl_free(struct nf_conn *tmpl)
 {
-	nf_ct_ext_destroy(tmpl);
+	kfree(tmpl->ext);
 
 	if (ARCH_KMALLOC_MINALIGN <= NFCT_INFOMASK)
 		kfree((char *)tmpl - tmpl->proto.tmpl_padto);
@@ -1597,7 +1597,17 @@ void nf_conntrack_free(struct nf_conn *ct)
 	 */
 	WARN_ON(refcount_read(&ct->ct_general.use) != 0);
 
-	nf_ct_ext_destroy(ct);
+	if (ct->status & IPS_SRC_NAT_DONE) {
+		const struct nf_nat_hook *nat_hook;
+
+		rcu_read_lock();
+		nat_hook = rcu_dereference(nf_nat_hook);
+		if (nat_hook)
+			nat_hook->remove_nat_bysrc(ct);
+		rcu_read_unlock();
+	}
+
+	kfree(ct->ext);
 	kmem_cache_free(nf_conntrack_cachep, ct);
 	cnet = nf_ct_pernet(net);
 
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 69a6cafcb045..6b772b804ee2 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -89,27 +89,6 @@ static __always_inline unsigned int total_extension_size(void)
 	;
 }
 
-void nf_ct_ext_destroy(struct nf_conn *ct)
-{
-	unsigned int i;
-	struct nf_ct_ext_type *t;
-
-	for (i = 0; i < NF_CT_EXT_NUM; i++) {
-		rcu_read_lock();
-		t = rcu_dereference(nf_ct_ext_types[i]);
-
-		/* Here the nf_ct_ext_type might have been unregisterd.
-		 * I.e., it has responsible to cleanup private
-		 * area in all conntracks when it is unregisterd.
-		 */
-		if (t && t->destroy)
-			t->destroy(ct);
-		rcu_read_unlock();
-	}
-
-	kfree(ct->ext);
-}
-
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	unsigned int newlen, newoff, oldlen, alloc;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2ff20d6a5afb..8cc31d695e36 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -838,7 +838,7 @@ static int nf_nat_proto_remove(struct nf_conn *i, void *data)
 	return i->status & IPS_NAT_MASK ? 1 : 0;
 }
 
-static void __nf_nat_cleanup_conntrack(struct nf_conn *ct)
+static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 {
 	unsigned int h;
 
@@ -860,7 +860,7 @@ static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 	 * will delete entry from already-freed table.
 	 */
 	if (test_and_clear_bit(IPS_SRC_NAT_DONE_BIT, &ct->status))
-		__nf_nat_cleanup_conntrack(ct);
+		nf_nat_cleanup_conntrack(ct);
 
 	/* don't delete conntrack.  Although that would make things a lot
 	 * simpler, we'd end up flushing all conntracks on nat rmmod.
@@ -868,15 +868,7 @@ static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 	return 0;
 }
 
-/* No one using conntrack by the time this called. */
-static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
-{
-	if (ct->status & IPS_SRC_NAT_DONE)
-		__nf_nat_cleanup_conntrack(ct);
-}
-
 static struct nf_ct_ext_type nat_extend __read_mostly = {
-	.destroy	= nf_nat_cleanup_conntrack,
 	.id		= NF_CT_EXT_NAT,
 };
 
@@ -1171,6 +1163,7 @@ static const struct nf_nat_hook nat_hook = {
 	.decode_session		= __nf_nat_decode_session,
 #endif
 	.manip_pkt		= nf_nat_manip_pkt,
+	.remove_nat_bysrc	= nf_nat_cleanup_conntrack,
 };
 
 static int __init nf_nat_init(void)
-- 
2.30.2

