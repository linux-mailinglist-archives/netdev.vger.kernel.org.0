Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26E122BB43
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 03:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGXBNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 21:13:39 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37678 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgGXBNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 21:13:38 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jymHH-0001sL-2V; Fri, 24 Jul 2020 11:13:36 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 24 Jul 2020 11:13:35 +1000
Date:   Fri, 24 Jul 2020 11:13:35 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        "tgraf@suug.ch" <tgraf@suug.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sousa da Fonseca, Pedro Jose" <pfonseca@purdue.edu>
Subject: [PATCH 1/2] rhashtable: Fix unprotected RCU dereference in __rht_ptr
Message-ID: <20200724011334.GA8580@gondor.apana.org.au>
References: <20200724010823.GA8549@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724010823.GA8549@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rcu_dereference call in rht_ptr_rcu is completely bogus because
we've already dereferenced the value in __rht_ptr and operated on it.
This causes potential double readings which could be fatal.  The RCU 
dereference must occur prior to the comparison in __rht_ptr.

This patch changes the order of RCU dereference so that it is done
first and the result is then fed to __rht_ptr.  The RCU marking
changes have been minimised using casts which will be removed in
a follow-up patch.

Fixes: ba6306e3f648 ("rhashtable: Remove RCU marking from...")
Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 70ebef866cc8..e3def7bbe932 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -349,11 +349,11 @@ static inline void rht_unlock(struct bucket_table *tbl,
 	local_bh_enable();
 }
 
-static inline struct rhash_head __rcu *__rht_ptr(
-	struct rhash_lock_head *const *bkt)
+static inline struct rhash_head *__rht_ptr(
+	struct rhash_lock_head *p, struct rhash_lock_head __rcu *const *bkt)
 {
-	return (struct rhash_head __rcu *)
-		((unsigned long)*bkt & ~BIT(0) ?:
+	return (struct rhash_head *)
+		((unsigned long)p & ~BIT(0) ?:
 		 (unsigned long)RHT_NULLS_MARKER(bkt));
 }
 
@@ -365,25 +365,26 @@ static inline struct rhash_head __rcu *__rht_ptr(
  *            access is guaranteed, such as when destroying the table.
  */
 static inline struct rhash_head *rht_ptr_rcu(
-	struct rhash_lock_head *const *bkt)
+	struct rhash_lock_head *const *p)
 {
-	struct rhash_head __rcu *p = __rht_ptr(bkt);
-
-	return rcu_dereference(p);
+	struct rhash_lock_head __rcu *const *bkt = (void *)p;
+	return __rht_ptr(rcu_dereference(*bkt), bkt);
 }
 
 static inline struct rhash_head *rht_ptr(
-	struct rhash_lock_head *const *bkt,
+	struct rhash_lock_head *const *p,
 	struct bucket_table *tbl,
 	unsigned int hash)
 {
-	return rht_dereference_bucket(__rht_ptr(bkt), tbl, hash);
+	struct rhash_lock_head __rcu *const *bkt = (void *)p;
+	return __rht_ptr(rht_dereference_bucket(*bkt, tbl, hash), bkt);
 }
 
 static inline struct rhash_head *rht_ptr_exclusive(
-	struct rhash_lock_head *const *bkt)
+	struct rhash_lock_head *const *p)
 {
-	return rcu_dereference_protected(__rht_ptr(bkt), 1);
+	struct rhash_lock_head __rcu *const *bkt = (void *)p;
+	return __rht_ptr(rcu_dereference_protected(*bkt, 1), bkt);
 }
 
 static inline void rht_assign_locked(struct rhash_lock_head **bkt,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
