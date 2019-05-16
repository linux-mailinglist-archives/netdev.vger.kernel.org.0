Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA85120013
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 09:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfEPHTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 03:19:54 -0400
Received: from orcrist.hmeau.com ([5.180.42.13]:44066 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbfEPHTy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 03:19:54 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hRAg7-0004PR-4t; Thu, 16 May 2019 15:19:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hRAg6-0004Fn-QR; Thu, 16 May 2019 15:19:46 +0800
Subject: [PATCH 1/2] rhashtable: Remove RCU marking from rhash_lock_head
References: <20190516051622.b4x6hlkuevof4jzr@gondor.apana.org.au>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net,
        tgraf@suug.ch, netdev@vger.kernel.org, oss-drivers@netronome.com,
        neilb@suse.com, Simon Horman <simon.horman@netronome.com>
Message-Id: <E1hRAg6-0004Fn-QR@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 16 May 2019 15:19:46 +0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opaque type rhash_lock_head should not be marked with __rcu
because it can never be dereferenced.  We should apply the RCU
marking when we turn it into a pointer which can be dereferenced.

This patch does exactly that.  This fixes a number of sparse
warnings as well as getting rid of some unnecessary RCU checking.
   
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/rhashtable.h |   58 ++++++++++++++++++++++++---------------------
 lib/rhashtable.c           |   28 ++++++++++-----------
 2 files changed, 46 insertions(+), 40 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index f7714d3b46bd..9f8bc06d4136 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -84,7 +84,7 @@ struct bucket_table {
 
 	struct lockdep_map	dep_map;
 
-	struct rhash_lock_head __rcu *buckets[] ____cacheline_aligned_in_smp;
+	struct rhash_lock_head *buckets[] ____cacheline_aligned_in_smp;
 };
 
 /*
@@ -261,13 +261,13 @@ void rhashtable_free_and_destroy(struct rhashtable *ht,
 				 void *arg);
 void rhashtable_destroy(struct rhashtable *ht);
 
-struct rhash_lock_head __rcu **rht_bucket_nested(const struct bucket_table *tbl,
-						 unsigned int hash);
-struct rhash_lock_head __rcu **__rht_bucket_nested(const struct bucket_table *tbl,
-						   unsigned int hash);
-struct rhash_lock_head __rcu **rht_bucket_nested_insert(struct rhashtable *ht,
-							struct bucket_table *tbl,
-							unsigned int hash);
+struct rhash_lock_head **rht_bucket_nested(const struct bucket_table *tbl,
+					   unsigned int hash);
+struct rhash_lock_head **__rht_bucket_nested(const struct bucket_table *tbl,
+					     unsigned int hash);
+struct rhash_lock_head **rht_bucket_nested_insert(struct rhashtable *ht,
+						  struct bucket_table *tbl,
+						  unsigned int hash);
 
 #define rht_dereference(p, ht) \
 	rcu_dereference_protected(p, lockdep_rht_mutex_is_held(ht))
@@ -284,21 +284,21 @@ struct rhash_lock_head __rcu **rht_bucket_nested_insert(struct rhashtable *ht,
 #define rht_entry(tpos, pos, member) \
 	({ tpos = container_of(pos, typeof(*tpos), member); 1; })
 
-static inline struct rhash_lock_head __rcu *const *rht_bucket(
+static inline struct rhash_lock_head *const *rht_bucket(
 	const struct bucket_table *tbl, unsigned int hash)
 {
 	return unlikely(tbl->nest) ? rht_bucket_nested(tbl, hash) :
 				     &tbl->buckets[hash];
 }
 
-static inline struct rhash_lock_head __rcu **rht_bucket_var(
+static inline struct rhash_lock_head **rht_bucket_var(
 	struct bucket_table *tbl, unsigned int hash)
 {
 	return unlikely(tbl->nest) ? __rht_bucket_nested(tbl, hash) :
 				     &tbl->buckets[hash];
 }
 
-static inline struct rhash_lock_head __rcu **rht_bucket_insert(
+static inline struct rhash_lock_head **rht_bucket_insert(
 	struct rhashtable *ht, struct bucket_table *tbl, unsigned int hash)
 {
 	return unlikely(tbl->nest) ? rht_bucket_nested_insert(ht, tbl, hash) :
@@ -349,6 +349,12 @@ static inline void rht_unlock(struct bucket_table *tbl,
 	local_bh_enable();
 }
 
+static inline struct rhash_head __rcu *__rht_ptr(
+	struct rhash_lock_head *const *bkt)
+{
+	return (struct rhash_head __rcu *)((unsigned long)*bkt & ~BIT(0));
+}
+
 /*
  * Where 'bkt' is a bucket and might be locked:
  *   rht_ptr() dereferences that pointer and clears the lock bit.
@@ -356,30 +362,30 @@ static inline void rht_unlock(struct bucket_table *tbl,
  *            access is guaranteed, such as when destroying the table.
  */
 static inline struct rhash_head *rht_ptr(
-	struct rhash_lock_head __rcu * const *bkt,
+	struct rhash_lock_head *const *bkt,
 	struct bucket_table *tbl,
 	unsigned int hash)
 {
-	const struct rhash_lock_head *p =
-		rht_dereference_bucket_rcu(*bkt, tbl, hash);
+	struct rhash_head __rcu *p = __rht_ptr(bkt);
 
-	if ((((unsigned long)p) & ~BIT(0)) == 0)
+	if (!p)
 		return RHT_NULLS_MARKER(bkt);
-	return (void *)(((unsigned long)p) & ~BIT(0));
+
+	return rht_dereference_bucket_rcu(p, tbl, hash);
 }
 
 static inline struct rhash_head *rht_ptr_exclusive(
-	struct rhash_lock_head __rcu * const *bkt)
+	struct rhash_lock_head *const *bkt)
 {
-	const struct rhash_lock_head *p =
-		rcu_dereference_protected(*bkt, 1);
+	struct rhash_head __rcu *p = __rht_ptr(bkt);
 
 	if (!p)
 		return RHT_NULLS_MARKER(bkt);
-	return (void *)(((unsigned long)p) & ~BIT(0));
+
+	return rcu_dereference_protected(p, 1);
 }
 
-static inline void rht_assign_locked(struct rhash_lock_head __rcu **bkt,
+static inline void rht_assign_locked(struct rhash_lock_head **bkt,
 				     struct rhash_head *obj)
 {
 	struct rhash_head __rcu **p = (struct rhash_head __rcu **)bkt;
@@ -390,7 +396,7 @@ static inline void rht_assign_locked(struct rhash_lock_head __rcu **bkt,
 }
 
 static inline void rht_assign_unlock(struct bucket_table *tbl,
-				     struct rhash_lock_head __rcu **bkt,
+				     struct rhash_lock_head **bkt,
 				     struct rhash_head *obj)
 {
 	struct rhash_head __rcu **p = (struct rhash_head __rcu **)bkt;
@@ -587,7 +593,7 @@ static inline struct rhash_head *__rhashtable_lookup(
 		.ht = ht,
 		.key = key,
 	};
-	struct rhash_lock_head __rcu * const *bkt;
+	struct rhash_lock_head *const *bkt;
 	struct bucket_table *tbl;
 	struct rhash_head *he;
 	unsigned int hash;
@@ -703,7 +709,7 @@ static inline void *__rhashtable_insert_fast(
 		.ht = ht,
 		.key = key,
 	};
-	struct rhash_lock_head __rcu **bkt;
+	struct rhash_lock_head **bkt;
 	struct rhash_head __rcu **pprev;
 	struct bucket_table *tbl;
 	struct rhash_head *head;
@@ -989,7 +995,7 @@ static inline int __rhashtable_remove_fast_one(
 	struct rhash_head *obj, const struct rhashtable_params params,
 	bool rhlist)
 {
-	struct rhash_lock_head __rcu **bkt;
+	struct rhash_lock_head **bkt;
 	struct rhash_head __rcu **pprev;
 	struct rhash_head *he;
 	unsigned int hash;
@@ -1141,7 +1147,7 @@ static inline int __rhashtable_replace_fast(
 	struct rhash_head *obj_old, struct rhash_head *obj_new,
 	const struct rhashtable_params params)
 {
-	struct rhash_lock_head __rcu **bkt;
+	struct rhash_lock_head **bkt;
 	struct rhash_head __rcu **pprev;
 	struct rhash_head *he;
 	unsigned int hash;
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6529fe1b45c1..7708699a5b96 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -34,7 +34,7 @@
 
 union nested_table {
 	union nested_table __rcu *table;
-	struct rhash_lock_head __rcu *bucket;
+	struct rhash_lock_head *bucket;
 };
 
 static u32 head_hashfn(struct rhashtable *ht,
@@ -216,7 +216,7 @@ static struct bucket_table *rhashtable_last_table(struct rhashtable *ht,
 }
 
 static int rhashtable_rehash_one(struct rhashtable *ht,
-				 struct rhash_lock_head __rcu **bkt,
+				 struct rhash_lock_head **bkt,
 				 unsigned int old_hash)
 {
 	struct bucket_table *old_tbl = rht_dereference(ht->tbl, ht);
@@ -269,7 +269,7 @@ static int rhashtable_rehash_chain(struct rhashtable *ht,
 				    unsigned int old_hash)
 {
 	struct bucket_table *old_tbl = rht_dereference(ht->tbl, ht);
-	struct rhash_lock_head __rcu **bkt = rht_bucket_var(old_tbl, old_hash);
+	struct rhash_lock_head **bkt = rht_bucket_var(old_tbl, old_hash);
 	int err;
 
 	if (!bkt)
@@ -478,7 +478,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 }
 
 static void *rhashtable_lookup_one(struct rhashtable *ht,
-				   struct rhash_lock_head __rcu **bkt,
+				   struct rhash_lock_head **bkt,
 				   struct bucket_table *tbl, unsigned int hash,
 				   const void *key, struct rhash_head *obj)
 {
@@ -529,7 +529,7 @@ static void *rhashtable_lookup_one(struct rhashtable *ht,
 }
 
 static struct bucket_table *rhashtable_insert_one(struct rhashtable *ht,
-						  struct rhash_lock_head __rcu **bkt,
+						  struct rhash_lock_head **bkt,
 						  struct bucket_table *tbl,
 						  unsigned int hash,
 						  struct rhash_head *obj,
@@ -584,7 +584,7 @@ static void *rhashtable_try_insert(struct rhashtable *ht, const void *key,
 {
 	struct bucket_table *new_tbl;
 	struct bucket_table *tbl;
-	struct rhash_lock_head __rcu **bkt;
+	struct rhash_lock_head **bkt;
 	unsigned int hash;
 	void *data;
 
@@ -1166,8 +1166,8 @@ void rhashtable_destroy(struct rhashtable *ht)
 }
 EXPORT_SYMBOL_GPL(rhashtable_destroy);
 
-struct rhash_lock_head __rcu **__rht_bucket_nested(const struct bucket_table *tbl,
-						   unsigned int hash)
+struct rhash_lock_head **__rht_bucket_nested(const struct bucket_table *tbl,
+					     unsigned int hash)
 {
 	const unsigned int shift = PAGE_SHIFT - ilog2(sizeof(void *));
 	unsigned int index = hash & ((1 << tbl->nest) - 1);
@@ -1195,10 +1195,10 @@ struct rhash_lock_head __rcu **__rht_bucket_nested(const struct bucket_table *tb
 }
 EXPORT_SYMBOL_GPL(__rht_bucket_nested);
 
-struct rhash_lock_head __rcu **rht_bucket_nested(const struct bucket_table *tbl,
-						 unsigned int hash)
+struct rhash_lock_head **rht_bucket_nested(const struct bucket_table *tbl,
+					   unsigned int hash)
 {
-	static struct rhash_lock_head __rcu *rhnull;
+	static struct rhash_lock_head *rhnull;
 
 	if (!rhnull)
 		INIT_RHT_NULLS_HEAD(rhnull);
@@ -1206,9 +1206,9 @@ struct rhash_lock_head __rcu **rht_bucket_nested(const struct bucket_table *tbl,
 }
 EXPORT_SYMBOL_GPL(rht_bucket_nested);
 
-struct rhash_lock_head __rcu **rht_bucket_nested_insert(struct rhashtable *ht,
-							struct bucket_table *tbl,
-							unsigned int hash)
+struct rhash_lock_head **rht_bucket_nested_insert(struct rhashtable *ht,
+						  struct bucket_table *tbl,
+						  unsigned int hash)
 {
 	const unsigned int shift = PAGE_SHIFT - ilog2(sizeof(void *));
 	unsigned int index = hash & ((1 << tbl->nest) - 1);
