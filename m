Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFF31892FF
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgCRAkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:25 -0400
Received: from correo.us.es ([193.147.175.20]:45608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgCRAkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2EB1C27F8CC
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2217CDA3A5
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 17BD0DA3A3; Wed, 18 Mar 2020 01:39:50 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE7D7DA390;
        Wed, 18 Mar 2020 01:39:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C286E426CCB9;
        Wed, 18 Mar 2020 01:39:47 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/29] nft_set_pipapo: Prepare for vectorised implementation: alignment
Date:   Wed, 18 Mar 2020 01:39:44 +0100
Message-Id: <20200318003956.73573-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

SIMD vector extension sets require stricter alignment than native
instruction sets to operate efficiently (AVX, NEON) or for some
instructions to work at all (AltiVec).

Provide facilities to define arbitrary alignment for lookup tables
and scratch maps. By defining byte alignment with NFT_PIPAPO_ALIGN,
lt_aligned and scratch_aligned pointers become available.

Additional headroom is allocated, and pointers to the possibly
unaligned, originally allocated areas are kept so that they can
be freed.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 135 +++++++++++++++++++++++++++++++++--------
 1 file changed, 110 insertions(+), 25 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 83e54bd3187d..ef6866fe90a1 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -398,6 +398,22 @@
 #define NFT_PIPAPO_RULE0_MAX		((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
 					- (1UL << NFT_PIPAPO_MAP_NBITS))
 
+/* Definitions for vectorised implementations */
+#ifdef NFT_PIPAPO_ALIGN
+#define NFT_PIPAPO_ALIGN_HEADROOM					\
+	(NFT_PIPAPO_ALIGN - ARCH_KMALLOC_MINALIGN)
+#define NFT_PIPAPO_LT_ALIGN(lt)		(PTR_ALIGN((lt), NFT_PIPAPO_ALIGN))
+#define NFT_PIPAPO_LT_ASSIGN(field, x)					\
+	do {								\
+		(field)->lt_aligned = NFT_PIPAPO_LT_ALIGN(x);		\
+		(field)->lt = (x);					\
+	} while (0)
+#else
+#define NFT_PIPAPO_ALIGN_HEADROOM	0
+#define NFT_PIPAPO_LT_ALIGN(lt)		(lt)
+#define NFT_PIPAPO_LT_ASSIGN(field, x)	((field)->lt = (x))
+#endif /* NFT_PIPAPO_ALIGN */
+
 #define nft_pipapo_for_each_field(field, index, match)		\
 	for ((field) = (match)->f, (index) = 0;			\
 	     (index) < (match)->field_count;			\
@@ -432,6 +448,7 @@ union nft_pipapo_map_bucket {
  * @bsize:	Size of each bucket in lookup table, in longs
  * @bb:		Number of bits grouped together in lookup table buckets
  * @lt:		Lookup table: 'groups' rows of buckets
+ * @lt_aligned:	Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
  * @mt:		Mapping table: one bucket per rule
  */
 struct nft_pipapo_field {
@@ -439,6 +456,9 @@ struct nft_pipapo_field {
 	unsigned long rules;
 	size_t bsize;
 	int bb;
+#ifdef NFT_PIPAPO_ALIGN
+	unsigned long *lt_aligned;
+#endif
 	unsigned long *lt;
 	union nft_pipapo_map_bucket *mt;
 };
@@ -447,12 +467,16 @@ struct nft_pipapo_field {
  * struct nft_pipapo_match - Data used for lookup and matching
  * @field_count		Amount of fields in set
  * @scratch:		Preallocated per-CPU maps for partial matching results
+ * @scratch_aligned:	Version of @scratch aligned to NFT_PIPAPO_ALIGN bytes
  * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
  * @rcu			Matching data is swapped on commits
  * @f:			Fields, with lookup and mapping tables
  */
 struct nft_pipapo_match {
 	int field_count;
+#ifdef NFT_PIPAPO_ALIGN
+	unsigned long * __percpu *scratch_aligned;
+#endif
 	unsigned long * __percpu *scratch;
 	size_t bsize_max;
 	struct rcu_head rcu;
@@ -729,6 +753,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
 
 	nft_pipapo_for_each_field(f, i, m) {
+		unsigned long *lt = NFT_PIPAPO_LT_ALIGN(f->lt);
 		bool last = i == m->field_count - 1;
 		int b;
 
@@ -817,6 +842,10 @@ static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
 	int group, bucket;
 
 	new_bucket_size = DIV_ROUND_UP(rules, BITS_PER_LONG);
+#ifdef NFT_PIPAPO_ALIGN
+	new_bucket_size = roundup(new_bucket_size,
+				  NFT_PIPAPO_ALIGN / sizeof(*new_lt));
+#endif
 
 	if (new_bucket_size == f->bsize)
 		goto mt;
@@ -827,12 +856,15 @@ static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
 		copy = new_bucket_size;
 
 	new_lt = kvzalloc(f->groups * NFT_PIPAPO_BUCKETS(f->bb) *
-			  new_bucket_size * sizeof(*new_lt), GFP_KERNEL);
+			  new_bucket_size * sizeof(*new_lt) +
+			  NFT_PIPAPO_ALIGN_HEADROOM,
+			  GFP_KERNEL);
 	if (!new_lt)
 		return -ENOMEM;
 
-	new_p = new_lt;
-	old_p = old_lt;
+	new_p = NFT_PIPAPO_LT_ALIGN(new_lt);
+	old_p = NFT_PIPAPO_LT_ALIGN(old_lt);
+
 	for (group = 0; group < f->groups; group++) {
 		for (bucket = 0; bucket < NFT_PIPAPO_BUCKETS(f->bb); bucket++) {
 			memcpy(new_p, old_p, copy * sizeof(*new_p));
@@ -861,7 +893,7 @@ static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
 
 	if (new_lt) {
 		f->bsize = new_bucket_size;
-		f->lt = new_lt;
+		NFT_PIPAPO_LT_ASSIGN(f, new_lt);
 		kvfree(old_lt);
 	}
 
@@ -883,7 +915,8 @@ static void pipapo_bucket_set(struct nft_pipapo_field *f, int rule, int group,
 {
 	unsigned long *pos;
 
-	pos = f->lt + f->bsize * NFT_PIPAPO_BUCKETS(f->bb) * group;
+	pos = NFT_PIPAPO_LT_ALIGN(f->lt);
+	pos += f->bsize * NFT_PIPAPO_BUCKETS(f->bb) * group;
 	pos += f->bsize * v;
 
 	__set_bit(rule, pos);
@@ -1048,22 +1081,27 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
 		return;
 	}
 
-	new_lt = kvzalloc(lt_size, GFP_KERNEL);
+	new_lt = kvzalloc(lt_size + NFT_PIPAPO_ALIGN_HEADROOM, GFP_KERNEL);
 	if (!new_lt)
 		return;
 
 	NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
-	if (f->bb == 4 && bb == 8)
-		pipapo_lt_4b_to_8b(f->groups, f->bsize, f->lt, new_lt);
-	else if (f->bb == 8 && bb == 4)
-		pipapo_lt_8b_to_4b(f->groups, f->bsize, f->lt, new_lt);
-	else
+	if (f->bb == 4 && bb == 8) {
+		pipapo_lt_4b_to_8b(f->groups, f->bsize,
+				   NFT_PIPAPO_LT_ALIGN(f->lt),
+				   NFT_PIPAPO_LT_ALIGN(new_lt));
+	} else if (f->bb == 8 && bb == 4) {
+		pipapo_lt_8b_to_4b(f->groups, f->bsize,
+				   NFT_PIPAPO_LT_ALIGN(f->lt),
+				   NFT_PIPAPO_LT_ALIGN(new_lt));
+	} else {
 		BUG();
+	}
 
 	f->groups = groups;
 	f->bb = bb;
 	kvfree(f->lt);
-	f->lt = new_lt;
+	NFT_PIPAPO_LT_ASSIGN(f, new_lt);
 }
 
 /**
@@ -1289,8 +1327,12 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 
 	for_each_possible_cpu(i) {
 		unsigned long *scratch;
+#ifdef NFT_PIPAPO_ALIGN
+		unsigned long *scratch_aligned;
+#endif
 
-		scratch = kzalloc_node(bsize_max * sizeof(*scratch) * 2,
+		scratch = kzalloc_node(bsize_max * sizeof(*scratch) * 2 +
+				       NFT_PIPAPO_ALIGN_HEADROOM,
 				       GFP_KERNEL, cpu_to_node(i));
 		if (!scratch) {
 			/* On failure, there's no need to undo previous
@@ -1306,6 +1348,11 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		kfree(*per_cpu_ptr(clone->scratch, i));
 
 		*per_cpu_ptr(clone->scratch, i) = scratch;
+
+#ifdef NFT_PIPAPO_ALIGN
+		scratch_aligned = NFT_PIPAPO_LT_ALIGN(scratch);
+		*per_cpu_ptr(clone->scratch_aligned, i) = scratch_aligned;
+#endif
 	}
 
 	return 0;
@@ -1433,21 +1480,33 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	if (!new->scratch)
 		goto out_scratch;
 
+#ifdef NFT_PIPAPO_ALIGN
+	new->scratch_aligned = alloc_percpu(*new->scratch_aligned);
+	if (!new->scratch_aligned)
+		goto out_scratch;
+#endif
+
 	rcu_head_init(&new->rcu);
 
 	src = old->f;
 	dst = new->f;
 
 	for (i = 0; i < old->field_count; i++) {
+		unsigned long *new_lt;
+
 		memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));
 
-		dst->lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
-				   src->bsize * sizeof(*dst->lt),
-				   GFP_KERNEL);
-		if (!dst->lt)
+		new_lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
+				  src->bsize * sizeof(*dst->lt) +
+				  NFT_PIPAPO_ALIGN_HEADROOM,
+				  GFP_KERNEL);
+		if (!new_lt)
 			goto out_lt;
 
-		memcpy(dst->lt, src->lt,
+		NFT_PIPAPO_LT_ASSIGN(dst, new_lt);
+
+		memcpy(NFT_PIPAPO_LT_ALIGN(new_lt),
+		       NFT_PIPAPO_LT_ALIGN(src->lt),
 		       src->bsize * sizeof(*dst->lt) *
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
@@ -1470,8 +1529,11 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		kvfree(dst->lt);
 		dst--;
 	}
-	free_percpu(new->scratch);
+#ifdef NFT_PIPAPO_ALIGN
+	free_percpu(new->scratch_aligned);
+#endif
 out_scratch:
+	free_percpu(new->scratch);
 	kfree(new);
 
 	return ERR_PTR(-ENOMEM);
@@ -1627,7 +1689,8 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 			unsigned long *pos;
 			int b;
 
-			pos = f->lt + g * NFT_PIPAPO_BUCKETS(f->bb) * f->bsize;
+			pos = NFT_PIPAPO_LT_ALIGN(f->lt) + g *
+			      NFT_PIPAPO_BUCKETS(f->bb) * f->bsize;
 
 			for (b = 0; b < NFT_PIPAPO_BUCKETS(f->bb); b++) {
 				bitmap_cut(pos, pos, rulemap[i].to,
@@ -1733,6 +1796,9 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
 	for_each_possible_cpu(i)
 		kfree(*per_cpu_ptr(m->scratch, i));
 
+#ifdef NFT_PIPAPO_ALIGN
+	free_percpu(m->scratch_aligned);
+#endif
 	free_percpu(m->scratch);
 
 	pipapo_free_fields(m);
@@ -1936,8 +2002,8 @@ static int pipapo_get_boundaries(struct nft_pipapo_field *f, int first_rule,
 		for (b = 0; b < NFT_PIPAPO_BUCKETS(f->bb); b++) {
 			unsigned long *pos;
 
-			pos = f->lt + (g * NFT_PIPAPO_BUCKETS(f->bb) + b) *
-				      f->bsize;
+			pos = NFT_PIPAPO_LT_ALIGN(f->lt) +
+			      (g * NFT_PIPAPO_BUCKETS(f->bb) + b) * f->bsize;
 			if (test_bit(first_rule, pos) && x0 == -1)
 				x0 = b;
 			if (test_bit(first_rule + rule_count - 1, pos))
@@ -2218,11 +2284,21 @@ static int nft_pipapo_init(const struct nft_set *set,
 	m->scratch = alloc_percpu(unsigned long *);
 	if (!m->scratch) {
 		err = -ENOMEM;
-		goto out_free;
+		goto out_scratch;
 	}
 	for_each_possible_cpu(i)
 		*per_cpu_ptr(m->scratch, i) = NULL;
 
+#ifdef NFT_PIPAPO_ALIGN
+	m->scratch_aligned = alloc_percpu(unsigned long *);
+	if (!m->scratch_aligned) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+	for_each_possible_cpu(i)
+		*per_cpu_ptr(m->scratch_aligned, i) = NULL;
+#endif
+
 	rcu_head_init(&m->rcu);
 
 	nft_pipapo_for_each_field(f, i, m) {
@@ -2233,7 +2309,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 
 		f->bsize = 0;
 		f->rules = 0;
-		f->lt = NULL;
+		NFT_PIPAPO_LT_ASSIGN(f, NULL);
 		f->mt = NULL;
 	}
 
@@ -2251,7 +2327,11 @@ static int nft_pipapo_init(const struct nft_set *set,
 	return 0;
 
 out_free:
+#ifdef NFT_PIPAPO_ALIGN
+	free_percpu(m->scratch_aligned);
+#endif
 	free_percpu(m->scratch);
+out_scratch:
 	kfree(m);
 
 	return err;
@@ -2286,16 +2366,21 @@ static void nft_pipapo_destroy(const struct nft_set *set)
 			nft_set_elem_destroy(set, e, true);
 		}
 
+#ifdef NFT_PIPAPO_ALIGN
+		free_percpu(m->scratch_aligned);
+#endif
 		for_each_possible_cpu(cpu)
 			kfree(*per_cpu_ptr(m->scratch, cpu));
 		free_percpu(m->scratch);
-
 		pipapo_free_fields(m);
 		kfree(m);
 		priv->match = NULL;
 	}
 
 	if (priv->clone) {
+#ifdef NFT_PIPAPO_ALIGN
+		free_percpu(priv->clone->scratch_aligned);
+#endif
 		for_each_possible_cpu(cpu)
 			kfree(*per_cpu_ptr(priv->clone->scratch, cpu));
 		free_percpu(priv->clone->scratch);
-- 
2.11.0

