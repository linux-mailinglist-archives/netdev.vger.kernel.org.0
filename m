Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A3A189316
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgCRAlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:41:00 -0400
Received: from correo.us.es ([193.147.175.20]:45612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727306AbgCRAkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3D3ED27F8B5
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 286D3DA736
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1D8FADA39F; Wed, 18 Mar 2020 01:39:49 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1F5DDA736;
        Wed, 18 Mar 2020 01:39:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B6379426CCB9;
        Wed, 18 Mar 2020 01:39:46 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 15/29] nft_set_pipapo: Generalise group size for buckets
Date:   Wed, 18 Mar 2020 01:39:42 +0100
Message-Id: <20200318003956.73573-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Get rid of all hardcoded assumptions that buckets in lookup tables
correspond to four-bit groups, and replace them with appropriate
calculations based on a variable group size, now stored in struct
field.

The group size could now be in principle any divisor of eight. Note,
though, that lookup and get functions need an implementation
intimately depending on the group size, and the only supported size
there, currently, is four bits, which is also the initial and only
used size at the moment.

While at it, drop 'groups' from struct nft_pipapo: it was never used.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 208 ++++++++++++++++++++++-------------------
 1 file changed, 112 insertions(+), 96 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 26395c8188b1..43d7189a6a1f 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -350,16 +350,18 @@
 
 /* Number of bits to be grouped together in lookup table buckets, arbitrary */
 #define NFT_PIPAPO_GROUP_BITS		4
-#define NFT_PIPAPO_GROUPS_PER_BYTE	(BITS_PER_BYTE / NFT_PIPAPO_GROUP_BITS)
+
+#define NFT_PIPAPO_GROUPS_PER_BYTE(f)	(BITS_PER_BYTE / (f)->bb)
 
 /* Fields are padded to 32 bits in input registers */
-#define NFT_PIPAPO_GROUPS_PADDED_SIZE(x)				\
-	(round_up((x) / NFT_PIPAPO_GROUPS_PER_BYTE, sizeof(u32)))
-#define NFT_PIPAPO_GROUPS_PADDING(x)					\
-	(NFT_PIPAPO_GROUPS_PADDED_SIZE((x)) - (x) / NFT_PIPAPO_GROUPS_PER_BYTE)
+#define NFT_PIPAPO_GROUPS_PADDED_SIZE(f)				\
+	(round_up((f)->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f), sizeof(u32)))
+#define NFT_PIPAPO_GROUPS_PADDING(f)					\
+	(NFT_PIPAPO_GROUPS_PADDED_SIZE(f) - (f)->groups /		\
+					    NFT_PIPAPO_GROUPS_PER_BYTE(f))
 
-/* Number of buckets, given by 2 ^ n, with n grouped bits */
-#define NFT_PIPAPO_BUCKETS		(1 << NFT_PIPAPO_GROUP_BITS)
+/* Number of buckets given by 2 ^ n, with n bucket bits */
+#define NFT_PIPAPO_BUCKETS(bb)		(1 << (bb))
 
 /* Each n-bit range maps to up to n * 2 rules */
 #define NFT_PIPAPO_MAP_NBITS		(const_ilog2(NFT_PIPAPO_MAX_BITS * 2))
@@ -406,16 +408,18 @@ union nft_pipapo_map_bucket {
 
 /**
  * struct nft_pipapo_field - Lookup, mapping tables and related data for a field
- * @groups:	Amount of 4-bit groups
+ * @groups:	Amount of bit groups
  * @rules:	Number of inserted rules
  * @bsize:	Size of each bucket in lookup table, in longs
- * @lt:		Lookup table: 'groups' rows of NFT_PIPAPO_BUCKETS buckets
+ * @bb:		Number of bits grouped together in lookup table buckets
+ * @lt:		Lookup table: 'groups' rows of buckets
  * @mt:		Mapping table: one bucket per rule
  */
 struct nft_pipapo_field {
 	int groups;
 	unsigned long rules;
 	size_t bsize;
+	int bb;
 	unsigned long *lt;
 	union nft_pipapo_map_bucket *mt;
 };
@@ -443,7 +447,6 @@ static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index);
  * struct nft_pipapo - Representation of a set
  * @match:	Currently in-use matching data
  * @clone:	Copy where pending insertions and deletions are kept
- * @groups:	Total amount of 4-bit groups for fields in this set
  * @width:	Total bytes to be matched for one packet, including padding
  * @dirty:	Working copy has pending insertions or deletions
  * @last_gc:	Timestamp of last garbage collection run, jiffies
@@ -451,7 +454,6 @@ static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index);
 struct nft_pipapo {
 	struct nft_pipapo_match __rcu *match;
 	struct nft_pipapo_match *clone;
-	int groups;
 	int width;
 	bool dirty;
 	unsigned long last_gc;
@@ -521,6 +523,34 @@ static int pipapo_refill(unsigned long *map, int len, int rules,
 }
 
 /**
+ * pipapo_and_field_buckets_4bit() - Intersect buckets for 4-bit groups
+ * @f:		Field including lookup table
+ * @dst:	Area to store result
+ * @data:	Input data selecting table buckets
+ */
+static void pipapo_and_field_buckets_4bit(struct nft_pipapo_field *f,
+					  unsigned long *dst,
+					  const u8 *data)
+{
+	unsigned long *lt = f->lt;
+	int group;
+
+	for (group = 0; group < f->groups; group += BITS_PER_BYTE / 4, data++) {
+		u8 v;
+
+		v = *data >> 4;
+		__bitmap_and(dst, dst, lt + v * f->bsize,
+			     f->bsize * BITS_PER_LONG);
+		lt += f->bsize * NFT_PIPAPO_BUCKETS(4);
+
+		v = *data & 0x0f;
+		__bitmap_and(dst, dst, lt + v * f->bsize,
+			     f->bsize * BITS_PER_LONG);
+		lt += f->bsize * NFT_PIPAPO_BUCKETS(4);
+	}
+}
+
+/**
  * nft_pipapo_lookup() - Lookup function
  * @net:	Network namespace
  * @set:	nftables API set representation
@@ -559,26 +589,15 @@ static bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last = i == m->field_count - 1;
-		unsigned long *lt = f->lt;
-		int b, group;
+		int b;
 
-		/* For each 4-bit group: select lookup table bucket depending on
+		/* For each bit group: select lookup table bucket depending on
 		 * packet bytes value, then AND bucket value
 		 */
-		for (group = 0; group < f->groups; group += 2) {
-			u8 v;
-
-			v = *rp >> 4;
-			__bitmap_and(res_map, res_map, lt + v * f->bsize,
-				     f->bsize * BITS_PER_LONG);
-			lt += f->bsize * NFT_PIPAPO_BUCKETS;
-
-			v = *rp & 0x0f;
-			rp++;
-			__bitmap_and(res_map, res_map, lt + v * f->bsize,
-				     f->bsize * BITS_PER_LONG);
-			lt += f->bsize * NFT_PIPAPO_BUCKETS;
-		}
+		pipapo_and_field_buckets_4bit(f, res_map, rp);
+		BUILD_BUG_ON(NFT_PIPAPO_GROUP_BITS != 4);
+
+		rp += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
 
 		/* Now populate the bitmap for the next field, unless this is
 		 * the last field, in which case return the matched 'ext'
@@ -621,7 +640,7 @@ static bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 		map_index = !map_index;
 		swap(res_map, fill_map);
 
-		rp += NFT_PIPAPO_GROUPS_PADDING(f->groups);
+		rp += NFT_PIPAPO_GROUPS_PADDING(f);
 	}
 
 out:
@@ -669,26 +688,17 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 
 	nft_pipapo_for_each_field(f, i, m) {
 		bool last = i == m->field_count - 1;
-		unsigned long *lt = f->lt;
-		int b, group;
+		int b;
 
-		/* For each 4-bit group: select lookup table bucket depending on
+		/* For each bit group: select lookup table bucket depending on
 		 * packet bytes value, then AND bucket value
 		 */
-		for (group = 0; group < f->groups; group++) {
-			u8 v;
-
-			if (group % 2) {
-				v = *data & 0x0f;
-				data++;
-			} else {
-				v = *data >> 4;
-			}
-			__bitmap_and(res_map, res_map, lt + v * f->bsize,
-				     f->bsize * BITS_PER_LONG);
+		if (f->bb == 4)
+			pipapo_and_field_buckets_4bit(f, res_map, data);
+		else
+			BUG();
 
-			lt += f->bsize * NFT_PIPAPO_BUCKETS;
-		}
+		data += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
 
 		/* Now populate the bitmap for the next field, unless this is
 		 * the last field, in which case return the matched 'ext'
@@ -713,7 +723,7 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 			goto out;
 		}
 
-		data += NFT_PIPAPO_GROUPS_PADDING(f->groups);
+		data += NFT_PIPAPO_GROUPS_PADDING(f);
 
 		/* Swap bitmap indices: fill_map will be the initial bitmap for
 		 * the next field (i.e. the new res_map), and res_map is
@@ -772,15 +782,15 @@ static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
 	else
 		copy = new_bucket_size;
 
-	new_lt = kvzalloc(f->groups * NFT_PIPAPO_BUCKETS * new_bucket_size *
-			  sizeof(*new_lt), GFP_KERNEL);
+	new_lt = kvzalloc(f->groups * NFT_PIPAPO_BUCKETS(f->bb) *
+			  new_bucket_size * sizeof(*new_lt), GFP_KERNEL);
 	if (!new_lt)
 		return -ENOMEM;
 
 	new_p = new_lt;
 	old_p = old_lt;
 	for (group = 0; group < f->groups; group++) {
-		for (bucket = 0; bucket < NFT_PIPAPO_BUCKETS; bucket++) {
+		for (bucket = 0; bucket < NFT_PIPAPO_BUCKETS(f->bb); bucket++) {
 			memcpy(new_p, old_p, copy * sizeof(*new_p));
 			new_p += copy;
 			old_p += copy;
@@ -829,7 +839,7 @@ static void pipapo_bucket_set(struct nft_pipapo_field *f, int rule, int group,
 {
 	unsigned long *pos;
 
-	pos = f->lt + f->bsize * NFT_PIPAPO_BUCKETS * group;
+	pos = f->lt + f->bsize * NFT_PIPAPO_BUCKETS(f->bb) * group;
 	pos += f->bsize * v;
 
 	__set_bit(rule, pos);
@@ -849,7 +859,7 @@ static void pipapo_bucket_set(struct nft_pipapo_field *f, int rule, int group,
 static int pipapo_insert(struct nft_pipapo_field *f, const uint8_t *k,
 			 int mask_bits)
 {
-	int rule = f->rules++, group, ret;
+	int rule = f->rules++, group, ret, bit_offset = 0;
 
 	ret = pipapo_resize(f, f->rules - 1, f->rules);
 	if (ret)
@@ -859,22 +869,25 @@ static int pipapo_insert(struct nft_pipapo_field *f, const uint8_t *k,
 		int i, v;
 		u8 mask;
 
-		if (group % 2)
-			v = k[group / 2] & 0x0f;
-		else
-			v = k[group / 2] >> 4;
+		v = k[group / (BITS_PER_BYTE / f->bb)];
+		v &= GENMASK(BITS_PER_BYTE - bit_offset - 1, 0);
+		v >>= (BITS_PER_BYTE - bit_offset) - f->bb;
 
-		if (mask_bits >= (group + 1) * 4) {
+		bit_offset += f->bb;
+		bit_offset %= BITS_PER_BYTE;
+
+		if (mask_bits >= (group + 1) * f->bb) {
 			/* Not masked */
 			pipapo_bucket_set(f, rule, group, v);
-		} else if (mask_bits <= group * 4) {
+		} else if (mask_bits <= group * f->bb) {
 			/* Completely masked */
-			for (i = 0; i < NFT_PIPAPO_BUCKETS; i++)
+			for (i = 0; i < NFT_PIPAPO_BUCKETS(f->bb); i++)
 				pipapo_bucket_set(f, rule, group, i);
 		} else {
 			/* The mask limit falls on this group */
-			mask = 0x0f >> (mask_bits - group * 4);
-			for (i = 0; i < NFT_PIPAPO_BUCKETS; i++) {
+			mask = GENMASK(f->bb - 1, 0);
+			mask >>= mask_bits - group * f->bb;
+			for (i = 0; i < NFT_PIPAPO_BUCKETS(f->bb); i++) {
 				if ((i & ~mask) == (v & ~mask))
 					pipapo_bucket_set(f, rule, group, i);
 			}
@@ -1123,11 +1136,11 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 			return -ENOSPC;
 
 		if (memcmp(start_p, end_p,
-			   f->groups / NFT_PIPAPO_GROUPS_PER_BYTE) > 0)
+			   f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f)) > 0)
 			return -EINVAL;
 
-		start_p += NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
-		end_p += NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+		start_p += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
+		end_p += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
 
 	/* Insert */
@@ -1141,22 +1154,19 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		rulemap[i].to = f->rules;
 
 		ret = memcmp(start, end,
-			     f->groups / NFT_PIPAPO_GROUPS_PER_BYTE);
-		if (!ret) {
-			ret = pipapo_insert(f, start,
-					    f->groups * NFT_PIPAPO_GROUP_BITS);
-		} else {
-			ret = pipapo_expand(f, start, end,
-					    f->groups * NFT_PIPAPO_GROUP_BITS);
-		}
+			     f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f));
+		if (!ret)
+			ret = pipapo_insert(f, start, f->groups * f->bb);
+		else
+			ret = pipapo_expand(f, start, end, f->groups * f->bb);
 
 		if (f->bsize > bsize_max)
 			bsize_max = f->bsize;
 
 		rulemap[i].n = ret;
 
-		start += NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
-		end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+		start += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
+		end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
 
 	if (!*this_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
@@ -1208,7 +1218,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 	for (i = 0; i < old->field_count; i++) {
 		memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));
 
-		dst->lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS *
+		dst->lt = kvzalloc(src->groups * NFT_PIPAPO_BUCKETS(src->bb) *
 				   src->bsize * sizeof(*dst->lt),
 				   GFP_KERNEL);
 		if (!dst->lt)
@@ -1216,7 +1226,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 
 		memcpy(dst->lt, src->lt,
 		       src->bsize * sizeof(*dst->lt) *
-		       src->groups * NFT_PIPAPO_BUCKETS);
+		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
 		dst->mt = kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
 		if (!dst->mt)
@@ -1394,9 +1404,9 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 			unsigned long *pos;
 			int b;
 
-			pos = f->lt + g * NFT_PIPAPO_BUCKETS * f->bsize;
+			pos = f->lt + g * NFT_PIPAPO_BUCKETS(f->bb) * f->bsize;
 
-			for (b = 0; b < NFT_PIPAPO_BUCKETS; b++) {
+			for (b = 0; b < NFT_PIPAPO_BUCKETS(f->bb); b++) {
 				bitmap_cut(pos, pos, rulemap[i].to,
 					   rulemap[i].n,
 					   f->bsize * BITS_PER_LONG);
@@ -1690,30 +1700,33 @@ static bool nft_pipapo_flush(const struct net *net, const struct nft_set *set,
 static int pipapo_get_boundaries(struct nft_pipapo_field *f, int first_rule,
 				 int rule_count, u8 *left, u8 *right)
 {
+	int g, mask_len = 0, bit_offset = 0;
 	u8 *l = left, *r = right;
-	int g, mask_len = 0;
 
 	for (g = 0; g < f->groups; g++) {
 		int b, x0, x1;
 
 		x0 = -1;
 		x1 = -1;
-		for (b = 0; b < NFT_PIPAPO_BUCKETS; b++) {
+		for (b = 0; b < NFT_PIPAPO_BUCKETS(f->bb); b++) {
 			unsigned long *pos;
 
-			pos = f->lt + (g * NFT_PIPAPO_BUCKETS + b) * f->bsize;
+			pos = f->lt + (g * NFT_PIPAPO_BUCKETS(f->bb) + b) *
+				      f->bsize;
 			if (test_bit(first_rule, pos) && x0 == -1)
 				x0 = b;
 			if (test_bit(first_rule + rule_count - 1, pos))
 				x1 = b;
 		}
 
-		if (g % 2) {
-			*(l++) |= x0 & 0x0f;
-			*(r++) |= x1 & 0x0f;
-		} else {
-			*l |= x0 << 4;
-			*r |= x1 << 4;
+		*l |= x0 << (BITS_PER_BYTE - f->bb - bit_offset);
+		*r |= x1 << (BITS_PER_BYTE - f->bb - bit_offset);
+
+		bit_offset += f->bb;
+		if (bit_offset >= BITS_PER_BYTE) {
+			bit_offset %= BITS_PER_BYTE;
+			l++;
+			r++;
 		}
 
 		if (x1 - x0 == 0)
@@ -1748,8 +1761,9 @@ static bool pipapo_match_field(struct nft_pipapo_field *f,
 
 	pipapo_get_boundaries(f, first_rule, rule_count, left, right);
 
-	return !memcmp(start, left, f->groups / NFT_PIPAPO_GROUPS_PER_BYTE) &&
-	       !memcmp(end, right, f->groups / NFT_PIPAPO_GROUPS_PER_BYTE);
+	return !memcmp(start, left,
+		       f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f)) &&
+	       !memcmp(end, right, f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f));
 }
 
 /**
@@ -1801,8 +1815,8 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 			rules_fx = f->mt[start].n;
 			start = f->mt[start].to;
 
-			match_start += NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
-			match_end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+			match_start += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
+			match_end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 		}
 
 		if (i == m->field_count) {
@@ -1895,9 +1909,9 @@ static u64 nft_pipapo_privsize(const struct nlattr * const nla[],
  * case here.
  *
  * In general, for a non-ranged entry or a single composing netmask, we need
- * one bit in each of the sixteen NFT_PIPAPO_BUCKETS, for each 4-bit group (that
- * is, each input bit needs four bits of matching data), plus a bucket in the
- * mapping table for each field.
+ * one bit in each of the sixteen buckets, for each 4-bit group (that is, each
+ * input bit needs four bits of matching data), plus a bucket in the mapping
+ * table for each field.
  *
  * Return: true only for compatible range concatenations
  */
@@ -1921,7 +1935,9 @@ static bool nft_pipapo_estimate(const struct nft_set_desc *desc, u32 features,
 		 * each rule also needs a mapping bucket.
 		 */
 		rules = ilog2(desc->field_len[i] * BITS_PER_BYTE) * 2;
-		entry_size += rules * NFT_PIPAPO_BUCKETS / BITS_PER_BYTE;
+		entry_size += rules *
+			      NFT_PIPAPO_BUCKETS(NFT_PIPAPO_GROUP_BITS) /
+			      BITS_PER_BYTE;
 		entry_size += rules * sizeof(union nft_pipapo_map_bucket);
 	}
 
@@ -1985,8 +2001,8 @@ static int nft_pipapo_init(const struct nft_set *set,
 	rcu_head_init(&m->rcu);
 
 	nft_pipapo_for_each_field(f, i, m) {
-		f->groups = desc->field_len[i] * NFT_PIPAPO_GROUPS_PER_BYTE;
-		priv->groups += f->groups;
+		f->bb = NFT_PIPAPO_GROUP_BITS;
+		f->groups = desc->field_len[i] * NFT_PIPAPO_GROUPS_PER_BYTE(f);
 
 		priv->width += round_up(desc->field_len[i], sizeof(u32));
 
-- 
2.11.0

