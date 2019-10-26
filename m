Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1779E5A16
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfJZLrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:55 -0400
Received: from correo.us.es ([193.147.175.20]:46416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbfJZLrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF5378C3C68
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4233A7EE6
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D9972A7EE4; Sat, 26 Oct 2019 13:47:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0A41DA72F;
        Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A31A842EE393;
        Sat, 26 Oct 2019 13:47:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 16/31] netfilter: conntrack: free extension area immediately
Date:   Sat, 26 Oct 2019 13:47:18 +0200
Message-Id: <20191026114733.28111-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Instead of waiting for rcu grace period just free it directly.

This is safe because conntrack lookup doesn't consider extensions.

Other accesses happen while ct->ext can't be free'd, either because
a ct refcount was taken or because the conntrack hash bucket lock or
the dying list spinlock have been taken.

This allows to remove __krealloc in a followup patch, netfilter was the
only user.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_extend.h | 10 ----------
 net/netfilter/nf_conntrack_core.c           |  2 --
 net/netfilter/nf_conntrack_extend.c         | 21 ++++++++++-----------
 3 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 112a6f40dfaf..5ae5295aa46d 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -43,7 +43,6 @@ enum nf_ct_ext_id {
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
-	struct rcu_head rcu;
 	u8 offset[NF_CT_EXT_NUM];
 	u8 len;
 	char data[0];
@@ -72,15 +71,6 @@ static inline void *__nf_ct_ext_find(const struct nf_conn *ct, u8 id)
 /* Destroy all relationships */
 void nf_ct_ext_destroy(struct nf_conn *ct);
 
-/* Free operation. If you want to free a object referred from private area,
- * please implement __nf_ct_ext_free() and call it.
- */
-static inline void nf_ct_ext_free(struct nf_conn *ct)
-{
-	if (ct->ext)
-		kfree_rcu(ct->ext, rcu);
-}
-
 /* Add this type, returns pointer to data or NULL. */
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp);
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0c63120b2db2..bcccaa7ec34c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -573,7 +573,6 @@ EXPORT_SYMBOL_GPL(nf_ct_tmpl_alloc);
 void nf_ct_tmpl_free(struct nf_conn *tmpl)
 {
 	nf_ct_ext_destroy(tmpl);
-	nf_ct_ext_free(tmpl);
 
 	if (ARCH_KMALLOC_MINALIGN <= NFCT_INFOMASK)
 		kfree((char *)tmpl - tmpl->proto.tmpl_padto);
@@ -1417,7 +1416,6 @@ void nf_conntrack_free(struct nf_conn *ct)
 	WARN_ON(atomic_read(&ct->ct_general.use) != 0);
 
 	nf_ct_ext_destroy(ct);
-	nf_ct_ext_free(ct);
 	kmem_cache_free(nf_conntrack_cachep, ct);
 	smp_mb__before_atomic();
 	atomic_dec(&net->ct.count);
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index d4ed1e197921..c24e5b64b00c 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -34,21 +34,24 @@ void nf_ct_ext_destroy(struct nf_conn *ct)
 			t->destroy(ct);
 		rcu_read_unlock();
 	}
+
+	kfree(ct->ext);
 }
 EXPORT_SYMBOL(nf_ct_ext_destroy);
 
 void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 {
 	unsigned int newlen, newoff, oldlen, alloc;
-	struct nf_ct_ext *old, *new;
 	struct nf_ct_ext_type *t;
+	struct nf_ct_ext *new;
 
 	/* Conntrack must not be confirmed to avoid races on reallocation. */
 	WARN_ON(nf_ct_is_confirmed(ct));
 
-	old = ct->ext;
 
-	if (old) {
+	if (ct->ext) {
+		const struct nf_ct_ext *old = ct->ext;
+
 		if (__nf_ct_ext_exist(old, id))
 			return NULL;
 		oldlen = old->len;
@@ -68,22 +71,18 @@ void *nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	rcu_read_unlock();
 
 	alloc = max(newlen, NF_CT_EXT_PREALLOC);
-	kmemleak_not_leak(old);
-	new = __krealloc(old, alloc, gfp);
+	new = krealloc(ct->ext, alloc, gfp);
 	if (!new)
 		return NULL;
 
-	if (!old) {
+	if (!ct->ext)
 		memset(new->offset, 0, sizeof(new->offset));
-		ct->ext = new;
-	} else if (new != old) {
-		kfree_rcu(old, rcu);
-		rcu_assign_pointer(ct->ext, new);
-	}
 
 	new->offset[id] = newoff;
 	new->len = newlen;
 	memset((void *)new + newoff, 0, newlen - newoff);
+
+	ct->ext = new;
 	return (void *)new + newoff;
 }
 EXPORT_SYMBOL(nf_ct_ext_add);
-- 
2.11.0

