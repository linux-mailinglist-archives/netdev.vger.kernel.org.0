Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7821ECB2C
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 10:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFCIMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 04:12:48 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59458 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgFCIMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 04:12:47 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jgOVv-0008Sx-MM; Wed, 03 Jun 2020 18:12:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 03 Jun 2020 18:12:43 +1000
Date:   Wed, 3 Jun 2020 18:12:43 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] rhashtable: Drop raw RCU deref in nested_table_free
Message-ID: <20200603081243.GA30134@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces some unnecessary uses of rcu_dereference_raw
in the rhashtable code with rcu_dereference_protected.

The top-level nested table entry is only marked as RCU because it
shares the same type as the tree entries underneath it.  So it
doesn't need any RCU protection.

We also don't need RCU protection when we're freeing a nested RCU
table because by this stage we've long passed a memory barrier
when anyone could change the nested table.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index bdb7e4cadf05..9f6890aedd1a 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -63,13 +63,22 @@ EXPORT_SYMBOL_GPL(lockdep_rht_bucket_is_held);
 #define ASSERT_RHT_MUTEX(HT)
 #endif
 
+static inline union nested_table *nested_table_top(
+	const struct bucket_table *tbl)
+{
+	/* The top-level bucket entry does not need RCU protection
+	 * because it's set at the same time as tbl->nest.
+	 */
+	return (void *)rcu_dereference_protected(tbl->buckets[0], 1);
+}
+
 static void nested_table_free(union nested_table *ntbl, unsigned int size)
 {
 	const unsigned int shift = PAGE_SHIFT - ilog2(sizeof(void *));
 	const unsigned int len = 1 << shift;
 	unsigned int i;
 
-	ntbl = rcu_dereference_raw(ntbl->table);
+	ntbl = rcu_dereference_protected(ntbl->table, 1);
 	if (!ntbl)
 		return;
 
@@ -89,7 +98,7 @@ static void nested_bucket_table_free(const struct bucket_table *tbl)
 	union nested_table *ntbl;
 	unsigned int i;
 
-	ntbl = (union nested_table *)rcu_dereference_raw(tbl->buckets[0]);
+	ntbl = nested_table_top(tbl);
 
 	for (i = 0; i < len; i++)
 		nested_table_free(ntbl + i, size);
@@ -1173,7 +1182,7 @@ struct rhash_lock_head **__rht_bucket_nested(const struct bucket_table *tbl,
 	unsigned int subhash = hash;
 	union nested_table *ntbl;
 
-	ntbl = (union nested_table *)rcu_dereference_raw(tbl->buckets[0]);
+	ntbl = nested_table_top(tbl);
 	ntbl = rht_dereference_bucket_rcu(ntbl[index].table, tbl, hash);
 	subhash >>= tbl->nest;
 
@@ -1213,7 +1222,7 @@ struct rhash_lock_head **rht_bucket_nested_insert(struct rhashtable *ht,
 	unsigned int size = tbl->size >> tbl->nest;
 	union nested_table *ntbl;
 
-	ntbl = (union nested_table *)rcu_dereference_raw(tbl->buckets[0]);
+	ntbl = nested_table_top(tbl);
 	hash >>= tbl->nest;
 	ntbl = nested_table_alloc(ht, &ntbl[index].table,
 				  size <= (1 << shift));
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
