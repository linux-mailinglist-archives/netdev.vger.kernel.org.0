Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3A12BFD8
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 09:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfE1HCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 03:02:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42624 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfE1HCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 03:02:34 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hVW80-0003Xb-NJ; Tue, 28 May 2019 15:02:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hVW7z-0007BE-BG; Tue, 28 May 2019 15:02:31 +0800
Date:   Tue, 28 May 2019 15:02:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     netdev@vger.kernel.org
Subject: [PATCH] rhashtable: Add rht_ptr_rcu and improve rht_ptr
Message-ID: <20190528070231.v3ajkzqshwkoyhcz@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves common code between rht_ptr and rht_ptr_exclusive
into __rht_ptr.  It also adds a new helper rht_ptr_rcu exclusively
for the RCU case.  This way rht_ptr becomes a lock-only construct
so we can use the lighter rcu_dereference_protected primitive.
 
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/rhashtable.h |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 9f8bc06d4136..beb9a9da1699 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -352,37 +352,38 @@ static inline void rht_unlock(struct bucket_table *tbl,
 static inline struct rhash_head __rcu *__rht_ptr(
 	struct rhash_lock_head *const *bkt)
 {
-	return (struct rhash_head __rcu *)((unsigned long)*bkt & ~BIT(0));
+	return (struct rhash_head __rcu *)
+		((unsigned long)*bkt & ~BIT(0) ?:
+		 (unsigned long)RHT_NULLS_MARKER(bkt));
 }
 
 /*
  * Where 'bkt' is a bucket and might be locked:
- *   rht_ptr() dereferences that pointer and clears the lock bit.
+ *   rht_ptr_rcu() dereferences that pointer and clears the lock bit.
+ *   rht_ptr() dereferences in a context where the bucket is locked.
  *   rht_ptr_exclusive() dereferences in a context where exclusive
  *            access is guaranteed, such as when destroying the table.
  */
+static inline struct rhash_head *rht_ptr_rcu(
+	struct rhash_lock_head *const *bkt)
+{
+	struct rhash_head __rcu *p = __rht_ptr(bkt);
+
+	return rcu_dereference(p);
+}
+
 static inline struct rhash_head *rht_ptr(
 	struct rhash_lock_head *const *bkt,
 	struct bucket_table *tbl,
 	unsigned int hash)
 {
-	struct rhash_head __rcu *p = __rht_ptr(bkt);
-
-	if (!p)
-		return RHT_NULLS_MARKER(bkt);
-
-	return rht_dereference_bucket_rcu(p, tbl, hash);
+	return rht_dereference_bucket(__rht_ptr(bkt), tbl, hash);
 }
 
 static inline struct rhash_head *rht_ptr_exclusive(
 	struct rhash_lock_head *const *bkt)
 {
-	struct rhash_head __rcu *p = __rht_ptr(bkt);
-
-	if (!p)
-		return RHT_NULLS_MARKER(bkt);
-
-	return rcu_dereference_protected(p, 1);
+	return rcu_dereference_protected(__rht_ptr(bkt), 1);
 }
 
 static inline void rht_assign_locked(struct rhash_lock_head **bkt,
@@ -509,7 +510,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
  */
 #define rht_for_each_rcu(pos, tbl, hash)			\
 	for (({barrier(); }),					\
-	     pos = rht_ptr(rht_bucket(tbl, hash), tbl, hash);	\
+	     pos = rht_ptr_rcu(rht_bucket(tbl, hash));		\
 	     !rht_is_a_nulls(pos);				\
 	     pos = rcu_dereference_raw(pos->next))
 
@@ -546,8 +547,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
  */
 #define rht_for_each_entry_rcu(tpos, pos, tbl, hash, member)		   \
 	rht_for_each_entry_rcu_from(tpos, pos,				   \
-				    rht_ptr(rht_bucket(tbl, hash),	   \
-					    tbl, hash),			   \
+				    rht_ptr_rcu(rht_bucket(tbl, hash)),	   \
 				    tbl, hash, member)
 
 /**
@@ -603,7 +603,7 @@ static inline struct rhash_head *__rhashtable_lookup(
 	hash = rht_key_hashfn(ht, tbl, key, params);
 	bkt = rht_bucket(tbl, hash);
 	do {
-		rht_for_each_rcu_from(he, rht_ptr(bkt, tbl, hash), tbl, hash) {
+		rht_for_each_rcu_from(he, rht_ptr_rcu(bkt), tbl, hash) {
 			if (params.obj_cmpfn ?
 			    params.obj_cmpfn(&arg, rht_obj(ht, he)) :
 			    rhashtable_compare(&arg, rht_obj(ht, he)))
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
