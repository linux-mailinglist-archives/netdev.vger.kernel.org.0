Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01A522C2E1
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgGXKOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:14:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38948 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbgGXKOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 06:14:38 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jyuio-0000vu-Ng; Fri, 24 Jul 2020 20:14:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Jul 2020 20:14:34 +1000
Date:   Fri, 24 Jul 2020 20:14:34 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        "tgraf@suug.ch" <tgraf@suug.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sousa da Fonseca, Pedro Jose" <pfonseca@purdue.edu>
Subject: [v2 PATCH 2/2] rhashtable: Restore RCU marking on rhash_lock_head
Message-ID: <20200724101434.GC15913@gondor.apana.org.au>
References: <20200724101220.GA15913@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724101220.GA15913@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch restores the RCU marking on bucket_table->buckets as
it really does need RCU protection.  Its removal had led to a fatal
bug.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index e3def7bbe932..83ad875a7ea2 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -84,7 +84,7 @@ struct bucket_table {
 
 	struct lockdep_map	dep_map;
 
-	struct rhash_lock_head *buckets[] ____cacheline_aligned_in_smp;
+	struct rhash_lock_head __rcu *buckets[] ____cacheline_aligned_in_smp;
 };
 
 /*
@@ -261,13 +261,12 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
 				 void *arg);
 void rhashtable_destroy(struct rhashtable *ht);
 
-struct rhash_lock_head **rht_bucket_nested(const struct bucket_table *tbl,
-					   unsigned int hash);
-struct rhash_lock_head **__rht_bucket_nested(const struct bucket_table *tbl,
-					     unsigned int hash);
-struct rhash_lock_head **rht_bucket_nested_insert(struct rhashtable *ht,
-						  struct bucket_table *tbl,
-						  unsigned int hash);
+struct rhash_lock_head __rcu **rht_bucket_nested(
+	const struct bucket_table *tbl, unsigned int hash);
+struct rhash_lock_head __rcu **__rht_bucket_nested(
+	const struct bucket_table *tbl, unsigned int hash);
+struct rhash_lock_head __rcu **rht_bucket_nested_insert(
+	struct rhashtable *ht, struct bucket_table *tbl, unsigned int hash);
 
 #define rht_dereference(p, ht) \
 	rcu_dereference_protected(p, lockdep_rht_mutex_is_held(ht))
@@ -284,21 +283,21 @@ struct rhash_lock_head **rht_bucket_nested_insert(struct rhashtable *ht,
 #define rht_entry(tpos, pos, member) \
 	({ tpos = container_of(pos, typeof(*tpos), member); 1; })
 
-static inline struct rhash_lock_head *const *rht_bucket(
+static inline struct rhash_lock_head __rcu *const *rht_bucket(
 	const struct bucket_table *tbl, unsigned int hash)
 {
 	return unlikely(tbl->nest) ? rht_bucket_nested(tbl, hash) :
 				     &tbl->buckets[hash];
 }
 
-static inline struct rhash_lock_head **rht_bucket_var(
+static inline struct rhash_lock_head __rcu **rht_bucket_var(
 	struct bucket_table *tbl, unsigned int hash)
 {
 	return unlikely(tbl->nest) ? __rht_bucket_nested(tbl, hash) :
 				     &tbl->buckets[hash];
 }
 
-static inline struct rhash_lock_head **rht_bucket_insert(
+static inline struct rhash_lock_head __rcu **rht_bucket_insert(
 	struct rhashtable *ht, struct bucket_table *tbl, unsigned int hash)
 {
 	return unlikely(tbl->nest) ? rht_bucket_nested_insert(ht, tbl, hash) :
@@ -325,7 +324,7 @@ static inline struct rhash_lock_head **rht_bucket_insert(
  */
 
 static inline void rht_lock(struct bucket_table *tbl,
-			    struct rhash_lock_head **bkt)
+			    struct rhash_lock_head __rcu **bkt)
 {
 	local_bh_disable();
 	bit_spin_lock(0, (unsigned long *)bkt);
@@ -333,7 +332,7 @@ static inline void rht_lock(struct bucket_table *tbl,
 }
 
 static inline void rht_lock_nested(struct bucket_table *tbl,
-				   struct rhash_lock_head **bucket,
+				   struct rhash_lock_head __rcu **bucket,
 				   unsigned int subclass)
 {
 	local_bh_disable();
@@ -342,7 +341,7 @@ static inline void rht_lock_nested(struct bucket_table *tbl,
 }
 
 static inline void rht_unlock(struct bucket_table *tbl,
-			      struct rhash_lock_head **bkt)
+			      struct rhash_lock_head __rcu **bkt)
 {
 	lock_map_release(&tbl->dep_map);
 	bit_spin_unlock(0, (unsigned long *)bkt);
@@ -365,48 +364,41 @@ static inline struct rhash_head *__rht_ptr(
  *            access is guaranteed, such as when destroying the table.
  */
 static inline struct rhash_head *rht_ptr_rcu(
-	struct rhash_lock_head *const *p)
+	struct rhash_lock_head __rcu *const *bkt)
 {
-	struct rhash_lock_head __rcu *const *bkt = (void *)p;
 	return __rht_ptr(rcu_dereference(*bkt), bkt);
 }
 
 static inline struct rhash_head *rht_ptr(
-	struct rhash_lock_head *const *p,
+	struct rhash_lock_head __rcu *const *bkt,
 	struct bucket_table *tbl,
 	unsigned int hash)
 {
-	struct rhash_lock_head __rcu *const *bkt = (void *)p;
 	return __rht_ptr(rht_dereference_bucket(*bkt, tbl, hash), bkt);
 }
 
 static inline struct rhash_head *rht_ptr_exclusive(
-	struct rhash_lock_head *const *p)
+	struct rhash_lock_head __rcu *const *bkt)
 {
-	struct rhash_lock_head __rcu *const *bkt = (void *)p;
 	return __rht_ptr(rcu_dereference_protected(*bkt, 1), bkt);
 }
 
-static inline void rht_assign_locked(struct rhash_lock_head **bkt,
+static inline void rht_assign_locked(struct rhash_lock_head __rcu **bkt,
 				     struct rhash_head *obj)
 {
-	struct rhash_head __rcu **p = (struct rhash_head __rcu **)bkt;
-
 	if (rht_is_a_nulls(obj))
 		obj = NULL;
-	rcu_assign_pointer(*p, (void *)((unsigned long)obj | BIT(0)));
+	rcu_assign_pointer(*bkt, (void *)((unsigned long)obj | BIT(0)));
 }
 
 static inline void rht_assign_unlock(struct bucket_table *tbl,
-				     struct rhash_lock_head **bkt,
+				     struct rhash_lock_head __rcu **bkt,
 				     struct rhash_head *obj)
 {
-	struct rhash_head __rcu **p = (struct rhash_head __rcu **)bkt;
-
 	if (rht_is_a_nulls(obj))
 		obj = NULL;
 	lock_map_release(&tbl->dep_map);
-	rcu_assign_pointer(*p, obj);
+	rcu_assign_pointer(*bkt, (void *)obj);
 	preempt_enable();
 	__release(bitlock);
 	local_bh_enable();
@@ -594,7 +586,7 @@ static inline struct rhash_head *__rhashtable_lookup(
 		.ht = ht,
 		.key = key,
 	};
-	struct rhash_lock_head *const *bkt;
+	struct rhash_lock_head __rcu *const *bkt;
 	struct bucket_table *tbl;
 	struct rhash_head *he;
 	unsigned int hash;
@@ -710,7 +702,7 @@ static inline void *__rhashtable_insert_fast(
 		.ht = ht,
 		.key = key,
 	};
-	struct rhash_lock_head **bkt;
+	struct rhash_lock_head __rcu **bkt;
 	struct rhash_head __rcu **pprev;
 	struct bucket_table *tbl;
 	struct rhash_head *head;
@@ -996,7 +988,7 @@ static inline int __rhashtable_remove_fast_one(
 	struct rhash_head *obj, const struct rhashtable_params params,
 	bool rhlist)
 {
-	struct rhash_lock_head **bkt;
+	struct rhash_lock_head __rcu **bkt;
 	struct rhash_head __rcu **pprev;
 	struct rhash_head *he;
 	unsigned int hash;
@@ -1148,7 +1140,7 @@ static inline int __rhashtable_replace_fast(
 	struct rhash_head *obj_old, struct rhash_head *obj_new,
 	const struct rhashtable_params params)
 {
-	struct rhash_lock_head **bkt;
+	struct rhash_lock_head __rcu **bkt;
 	struct rhash_head __rcu **pprev;
 	struct rhash_head *he;
 	unsigned int hash;
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 9f6890aedd1a..c949c1e3b87c 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -31,7 +31,7 @@
 
 union nested_table {
 	union nested_table __rcu *table;
-	struct rhash_lock_head *bucket;
+	struct rhash_lock_head __rcu *bucket;
 };
 
 static u32 head_hashfn(struct rhashtable *ht,
@@ -222,7 +222,7 @@ static struct bucket_table *rhashtable_last_table(struct rhashtable *ht,
 }
 
 static int rhashtable_rehash_one(struct rhashtable *ht,
-				 struct rhash_lock_head **bkt,
+				 struct rhash_lock_head __rcu **bkt,
 				 unsigned int old_hash)
 {
 	struct bucket_table *old_tbl = rht_dereference(ht->tbl, ht);
@@ -275,7 +275,7 @@ static int rhashtable_rehash_chain(struct rhashtable *ht,
 				    unsigned int old_hash)
 {
 	struct bucket_table *old_tbl = rht_dereference(ht->tbl, ht);
-	struct rhash_lock_head **bkt = rht_bucket_var(old_tbl, old_hash);
+	struct rhash_lock_head __rcu **bkt = rht_bucket_var(old_tbl, old_hash);
 	int err;
 
 	if (!bkt)
@@ -485,7 +485,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 }
 
 static void *rhashtable_lookup_one(struct rhashtable *ht,
-				   struct rhash_lock_head **bkt,
+				   struct rhash_lock_head __rcu **bkt,
 				   struct bucket_table *tbl, unsigned int hash,
 				   const void *key, struct rhash_head *obj)
 {
@@ -535,12 +535,10 @@ static void *rhashtable_lookup_one(struct rhashtable *ht,
 	return ERR_PTR(-ENOENT);
 }
 
-static struct bucket_table *rhashtable_insert_one(struct rhashtable *ht,
-						  struct rhash_lock_head **bkt,
-						  struct bucket_table *tbl,
-						  unsigned int hash,
-						  struct rhash_head *obj,
-						  void *data)
+static struct bucket_table *rhashtable_insert_one(
+	struct rhashtable *ht, struct rhash_lock_head __rcu **bkt,
+	struct bucket_table *tbl, unsigned int hash, struct rhash_head *obj,
+	void *data)
 {
 	struct bucket_table *new_tbl;
 	struct rhash_head *head;
@@ -591,7 +589,7 @@ static void *rhashtable_try_insert(struct rhashtable *ht, const void *key,
 {
 	struct bucket_table *new_tbl;
 	struct bucket_table *tbl;
-	struct rhash_lock_head **bkt;
+	struct rhash_lock_head __rcu **bkt;
 	unsigned int hash;
 	void *data;
 
@@ -1173,8 +1171,8 @@ void rhashtable_destroy(struct rhashtable *ht)
 }
 EXPORT_SYMBOL_GPL(rhashtable_destroy);
 
-struct rhash_lock_head **__rht_bucket_nested(const struct bucket_table *tbl,
-					     unsigned int hash)
+struct rhash_lock_head __rcu **__rht_bucket_nested(
+	const struct bucket_table *tbl, unsigned int hash)
 {
 	const unsigned int shift = PAGE_SHIFT - ilog2(sizeof(void *));
 	unsigned int index = hash & ((1 << tbl->nest) - 1);
@@ -1202,10 +1200,10 @@ struct rhash_lock_head **__rht_bucket_nested(const struct bucket_table *tbl,
 }
 EXPORT_SYMBOL_GPL(__rht_bucket_nested);
 
-struct rhash_lock_head **rht_bucket_nested(const struct bucket_table *tbl,
-					   unsigned int hash)
+struct rhash_lock_head __rcu **rht_bucket_nested(
+	const struct bucket_table *tbl, unsigned int hash)
 {
-	static struct rhash_lock_head *rhnull;
+	static struct rhash_lock_head __rcu *rhnull;
 
 	if (!rhnull)
 		INIT_RHT_NULLS_HEAD(rhnull);
@@ -1213,9 +1211,8 @@ struct rhash_lock_head **rht_bucket_nested(const struct bucket_table *tbl,
 }
 EXPORT_SYMBOL_GPL(rht_bucket_nested);
 
-struct rhash_lock_head **rht_bucket_nested_insert(struct rhashtable *ht,
-						  struct bucket_table *tbl,
-						  unsigned int hash)
+struct rhash_lock_head __rcu **rht_bucket_nested_insert(
+	struct rhashtable *ht, struct bucket_table *tbl, unsigned int hash)
 {
 	const unsigned int shift = PAGE_SHIFT - ilog2(sizeof(void *));
 	unsigned int index = hash & ((1 << tbl->nest) - 1);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
