Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9DD488D21
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbiAIXRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:04 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42174 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237409AbiAIXQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:59 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 61C9C64690;
        Mon, 10 Jan 2022 00:14:09 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 16/32] netfilter: conntrack: avoid useless indirection during conntrack destruction
Date:   Mon, 10 Jan 2022 00:16:24 +0100
Message-Id: <20220109231640.104123-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nf_ct_put() results in a usesless indirection:

nf_ct_put -> nf_conntrack_put -> nf_conntrack_destroy -> rcu readlock +
indirect call of ct_hooks->destroy().

There are two _put helpers:
nf_ct_put and nf_conntrack_put.  The latter is what should be used in
code that MUST NOT cause a linker dependency on the conntrack module
(e.g. calls from core network stack).

Everyone else should call nf_ct_put() instead.

A followup patch will convert a few nf_conntrack_put() calls to
nf_ct_put(), in particular from modules that already have a conntrack
dependency such as act_ct or even nf_conntrack itself.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h |  2 ++
 include/net/netfilter/nf_conntrack.h          |  8 ++++++--
 net/netfilter/nf_conntrack_core.c             | 12 ++++++------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index a03f7a80b9ab..2770db2fa080 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -29,6 +29,8 @@ struct nf_conntrack {
 };
 
 void nf_conntrack_destroy(struct nf_conntrack *nfct);
+
+/* like nf_ct_put, but without module dependency on nf_conntrack */
 static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
 	if (nfct && refcount_dec_and_test(&nfct->use))
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a4a14f3a5e38..8731d5bcb47d 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -76,6 +76,8 @@ struct nf_conn {
 	 * Hint, SKB address this struct and refcnt via skb->_nfct and
 	 * helpers nf_conntrack_get() and nf_conntrack_put().
 	 * Helper nf_ct_put() equals nf_conntrack_put() by dec refcnt,
+	 * except that the latter uses internal indirection and does not
+	 * result in a conntrack module dependency.
 	 * beware nf_ct_get() is different and don't inc refcnt.
 	 */
 	struct nf_conntrack ct_general;
@@ -170,11 +172,13 @@ nf_ct_get(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
 	return (struct nf_conn *)(nfct & NFCT_PTRMASK);
 }
 
+void nf_ct_destroy(struct nf_conntrack *nfct);
+
 /* decrement reference count on a conntrack */
 static inline void nf_ct_put(struct nf_conn *ct)
 {
-	WARN_ON(!ct);
-	nf_conntrack_put(&ct->ct_general);
+	if (ct && refcount_dec_and_test(&ct->ct_general.use))
+		nf_ct_destroy(&ct->ct_general);
 }
 
 /* Protocol module loading */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index cd3d07e418b5..7a2063abae04 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -558,7 +558,7 @@ static void nf_ct_del_from_dying_or_unconfirmed_list(struct nf_conn *ct)
 
 #define NFCT_ALIGN(len)	(((len) + NFCT_INFOMASK) & ~NFCT_INFOMASK)
 
-/* Released via destroy_conntrack() */
+/* Released via nf_ct_destroy() */
 struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 				 const struct nf_conntrack_zone *zone,
 				 gfp_t flags)
@@ -612,12 +612,11 @@ static void destroy_gre_conntrack(struct nf_conn *ct)
 #endif
 }
 
-static void
-destroy_conntrack(struct nf_conntrack *nfct)
+void nf_ct_destroy(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 
-	pr_debug("destroy_conntrack(%p)\n", ct);
+	pr_debug("%s(%p)\n", __func__, ct);
 	WARN_ON(refcount_read(&nfct->use) != 0);
 
 	if (unlikely(nf_ct_is_template(ct))) {
@@ -643,9 +642,10 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	if (ct->master)
 		nf_ct_put(ct->master);
 
-	pr_debug("destroy_conntrack: returning ct=%p to slab\n", ct);
+	pr_debug("%s: returning ct=%p to slab\n", __func__, ct);
 	nf_conntrack_free(ct);
 }
+EXPORT_SYMBOL(nf_ct_destroy);
 
 static void nf_ct_delete_from_lists(struct nf_conn *ct)
 {
@@ -2771,7 +2771,7 @@ int nf_conntrack_init_start(void)
 
 static const struct nf_ct_hook nf_conntrack_hook = {
 	.update		= nf_conntrack_update,
-	.destroy	= destroy_conntrack,
+	.destroy	= nf_ct_destroy,
 	.get_tuple_skb  = nf_conntrack_get_tuple_skb,
 	.attach		= nf_conntrack_attach,
 };
-- 
2.30.2

