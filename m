Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11EA5189314
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgCRAk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:59 -0400
Received: from correo.us.es ([193.147.175.20]:45642 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbgCRAkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 004CD27F8B3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF4FDDA38D
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D4CACDA3A0; Wed, 18 Mar 2020 01:39:50 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A68FDA38D;
        Wed, 18 Mar 2020 01:39:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4B80D426CCB9;
        Wed, 18 Mar 2020 01:39:48 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 18/29] nft_set_pipapo: Prepare for vectorised implementation: helpers
Date:   Wed, 18 Mar 2020 01:39:45 +0100
Message-Id: <20200318003956.73573-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Move most macros and helpers to a header file, so that they can be
conveniently used by related implementations.

No functional changes are intended here.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 269 ++-------------------------------------
 net/netfilter/nft_set_pipapo.h | 277 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 285 insertions(+), 261 deletions(-)
 create mode 100644 net/netfilter/nft_set_pipapo.h

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index ef6866fe90a1..141e0ab26d3c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -330,189 +330,21 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <uapi/linux/netfilter/nf_tables.h>
-#include <net/ipv6.h>			/* For the maximum length of a field */
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 
-/* Count of concatenated fields depends on count of 32-bit nftables registers */
-#define NFT_PIPAPO_MAX_FIELDS		NFT_REG32_COUNT
-
-/* Largest supported field size */
-#define NFT_PIPAPO_MAX_BYTES		(sizeof(struct in6_addr))
-#define NFT_PIPAPO_MAX_BITS		(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
-
-/* Bits to be grouped together in table buckets depending on set size */
-#define NFT_PIPAPO_GROUP_BITS_INIT	NFT_PIPAPO_GROUP_BITS_SMALL_SET
-#define NFT_PIPAPO_GROUP_BITS_SMALL_SET	8
-#define NFT_PIPAPO_GROUP_BITS_LARGE_SET	4
-#define NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4				\
-	BUILD_BUG_ON((NFT_PIPAPO_GROUP_BITS_SMALL_SET != 8) ||		\
-		     (NFT_PIPAPO_GROUP_BITS_LARGE_SET != 4))
-#define NFT_PIPAPO_GROUPS_PER_BYTE(f)	(BITS_PER_BYTE / (f)->bb)
-
-/* If a lookup table gets bigger than NFT_PIPAPO_LT_SIZE_HIGH, switch to the
- * small group width, and switch to the big group width if the table gets
- * smaller than NFT_PIPAPO_LT_SIZE_LOW.
- *
- * Picking 2MiB as threshold (for a single table) avoids as much as possible
- * crossing page boundaries on most architectures (x86-64 and MIPS huge pages,
- * ARMv7 supersections, POWER "large" pages, SPARC Level 1 regions, etc.), which
- * keeps performance nice in case kvmalloc() gives us non-contiguous areas.
- */
-#define NFT_PIPAPO_LT_SIZE_THRESHOLD	(1 << 21)
-#define NFT_PIPAPO_LT_SIZE_HYSTERESIS	(1 << 16)
-#define NFT_PIPAPO_LT_SIZE_HIGH		NFT_PIPAPO_LT_SIZE_THRESHOLD
-#define NFT_PIPAPO_LT_SIZE_LOW		NFT_PIPAPO_LT_SIZE_THRESHOLD -	\
-					NFT_PIPAPO_LT_SIZE_HYSTERESIS
-
-/* Fields are padded to 32 bits in input registers */
-#define NFT_PIPAPO_GROUPS_PADDED_SIZE(f)				\
-	(round_up((f)->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f), sizeof(u32)))
-#define NFT_PIPAPO_GROUPS_PADDING(f)					\
-	(NFT_PIPAPO_GROUPS_PADDED_SIZE(f) - (f)->groups /		\
-					    NFT_PIPAPO_GROUPS_PER_BYTE(f))
-
-/* Number of buckets given by 2 ^ n, with n bucket bits */
-#define NFT_PIPAPO_BUCKETS(bb)		(1 << (bb))
-
-/* Each n-bit range maps to up to n * 2 rules */
-#define NFT_PIPAPO_MAP_NBITS		(const_ilog2(NFT_PIPAPO_MAX_BITS * 2))
-
-/* Use the rest of mapping table buckets for rule indices, but it makes no sense
- * to exceed 32 bits
- */
-#if BITS_PER_LONG == 64
-#define NFT_PIPAPO_MAP_TOBITS		32
-#else
-#define NFT_PIPAPO_MAP_TOBITS		(BITS_PER_LONG - NFT_PIPAPO_MAP_NBITS)
-#endif
-
-/* ...which gives us the highest allowed index for a rule */
-#define NFT_PIPAPO_RULE0_MAX		((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
-					- (1UL << NFT_PIPAPO_MAP_NBITS))
-
-/* Definitions for vectorised implementations */
-#ifdef NFT_PIPAPO_ALIGN
-#define NFT_PIPAPO_ALIGN_HEADROOM					\
-	(NFT_PIPAPO_ALIGN - ARCH_KMALLOC_MINALIGN)
-#define NFT_PIPAPO_LT_ALIGN(lt)		(PTR_ALIGN((lt), NFT_PIPAPO_ALIGN))
-#define NFT_PIPAPO_LT_ASSIGN(field, x)					\
-	do {								\
-		(field)->lt_aligned = NFT_PIPAPO_LT_ALIGN(x);		\
-		(field)->lt = (x);					\
-	} while (0)
-#else
-#define NFT_PIPAPO_ALIGN_HEADROOM	0
-#define NFT_PIPAPO_LT_ALIGN(lt)		(lt)
-#define NFT_PIPAPO_LT_ASSIGN(field, x)	((field)->lt = (x))
-#endif /* NFT_PIPAPO_ALIGN */
-
-#define nft_pipapo_for_each_field(field, index, match)		\
-	for ((field) = (match)->f, (index) = 0;			\
-	     (index) < (match)->field_count;			\
-	     (index)++, (field)++)
-
-/**
- * union nft_pipapo_map_bucket - Bucket of mapping table
- * @to:		First rule number (in next field) this rule maps to
- * @n:		Number of rules (in next field) this rule maps to
- * @e:		If there's no next field, pointer to element this rule maps to
- */
-union nft_pipapo_map_bucket {
-	struct {
-#if BITS_PER_LONG == 64
-		static_assert(NFT_PIPAPO_MAP_TOBITS <= 32);
-		u32 to;
-
-		static_assert(NFT_PIPAPO_MAP_NBITS <= 32);
-		u32 n;
-#else
-		unsigned long to:NFT_PIPAPO_MAP_TOBITS;
-		unsigned long  n:NFT_PIPAPO_MAP_NBITS;
-#endif
-	};
-	struct nft_pipapo_elem *e;
-};
-
-/**
- * struct nft_pipapo_field - Lookup, mapping tables and related data for a field
- * @groups:	Amount of bit groups
- * @rules:	Number of inserted rules
- * @bsize:	Size of each bucket in lookup table, in longs
- * @bb:		Number of bits grouped together in lookup table buckets
- * @lt:		Lookup table: 'groups' rows of buckets
- * @lt_aligned:	Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
- * @mt:		Mapping table: one bucket per rule
- */
-struct nft_pipapo_field {
-	int groups;
-	unsigned long rules;
-	size_t bsize;
-	int bb;
-#ifdef NFT_PIPAPO_ALIGN
-	unsigned long *lt_aligned;
-#endif
-	unsigned long *lt;
-	union nft_pipapo_map_bucket *mt;
-};
-
-/**
- * struct nft_pipapo_match - Data used for lookup and matching
- * @field_count		Amount of fields in set
- * @scratch:		Preallocated per-CPU maps for partial matching results
- * @scratch_aligned:	Version of @scratch aligned to NFT_PIPAPO_ALIGN bytes
- * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
- * @rcu			Matching data is swapped on commits
- * @f:			Fields, with lookup and mapping tables
- */
-struct nft_pipapo_match {
-	int field_count;
-#ifdef NFT_PIPAPO_ALIGN
-	unsigned long * __percpu *scratch_aligned;
-#endif
-	unsigned long * __percpu *scratch;
-	size_t bsize_max;
-	struct rcu_head rcu;
-	struct nft_pipapo_field f[];
-};
+#include "nft_set_pipapo.h"
 
 /* Current working bitmap index, toggled between field matches */
 static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index);
 
 /**
- * struct nft_pipapo - Representation of a set
- * @match:	Currently in-use matching data
- * @clone:	Copy where pending insertions and deletions are kept
- * @width:	Total bytes to be matched for one packet, including padding
- * @dirty:	Working copy has pending insertions or deletions
- * @last_gc:	Timestamp of last garbage collection run, jiffies
- */
-struct nft_pipapo {
-	struct nft_pipapo_match __rcu *match;
-	struct nft_pipapo_match *clone;
-	int width;
-	bool dirty;
-	unsigned long last_gc;
-};
-
-struct nft_pipapo_elem;
-
-/**
- * struct nft_pipapo_elem - API-facing representation of single set element
- * @ext:	nftables API extensions
- */
-struct nft_pipapo_elem {
-	struct nft_set_ext ext;
-};
-
-/**
  * pipapo_refill() - For each set bit, set bits from selected mapping table item
  * @map:	Bitmap to be scanned for set bits
  * @len:	Length of bitmap in longs
@@ -529,9 +361,8 @@ struct nft_pipapo_elem {
  *
  * Return: -1 on no match, bit position on 'match_only', 0 otherwise.
  */
-static int pipapo_refill(unsigned long *map, int len, int rules,
-			 unsigned long *dst, union nft_pipapo_map_bucket *mt,
-			 bool match_only)
+int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
+		  union nft_pipapo_map_bucket *mt, bool match_only)
 {
 	unsigned long bitset;
 	int k, ret = -1;
@@ -566,54 +397,6 @@ static int pipapo_refill(unsigned long *map, int len, int rules,
 }
 
 /**
- * pipapo_and_field_buckets_4bit() - Intersect buckets for 4-bit groups
- * @f:		Field including lookup table
- * @dst:	Area to store result
- * @data:	Input data selecting table buckets
- */
-static void pipapo_and_field_buckets_4bit(struct nft_pipapo_field *f,
-					  unsigned long *dst,
-					  const u8 *data)
-{
-	unsigned long *lt = f->lt;
-	int group;
-
-	for (group = 0; group < f->groups; group += BITS_PER_BYTE / 4, data++) {
-		u8 v;
-
-		v = *data >> 4;
-		__bitmap_and(dst, dst, lt + v * f->bsize,
-			     f->bsize * BITS_PER_LONG);
-		lt += f->bsize * NFT_PIPAPO_BUCKETS(4);
-
-		v = *data & 0x0f;
-		__bitmap_and(dst, dst, lt + v * f->bsize,
-			     f->bsize * BITS_PER_LONG);
-		lt += f->bsize * NFT_PIPAPO_BUCKETS(4);
-	}
-}
-
-/**
- * pipapo_and_field_buckets_8bit() - Intersect buckets for 8-bit groups
- * @f:		Field including lookup table
- * @dst:	Area to store result
- * @data:	Input data selecting table buckets
- */
-static void pipapo_and_field_buckets_8bit(struct nft_pipapo_field *f,
-					  unsigned long *dst,
-					  const u8 *data)
-{
-	unsigned long *lt = f->lt;
-	int group;
-
-	for (group = 0; group < f->groups; group++, data++) {
-		__bitmap_and(dst, dst, lt + *data * f->bsize,
-			     f->bsize * BITS_PER_LONG);
-		lt += f->bsize * NFT_PIPAPO_BUCKETS(8);
-	}
-}
-
-/**
  * nft_pipapo_lookup() - Lookup function
  * @net:	Network namespace
  * @set:	nftables API set representation
@@ -753,7 +536,6 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
 
 	nft_pipapo_for_each_field(f, i, m) {
-		unsigned long *lt = NFT_PIPAPO_LT_ALIGN(f->lt);
 		bool last = i == m->field_count - 1;
 		int b;
 
@@ -2190,58 +1972,23 @@ static u64 nft_pipapo_privsize(const struct nlattr * const nla[],
 }
 
 /**
- * nft_pipapo_estimate() - Estimate set size, space and lookup complexity
- * @desc:	Set description, element count and field description used here
+ * nft_pipapo_estimate() - Set size, space and lookup complexity
+ * @desc:	Set description, element count and field description used
  * @features:	Flags: NFT_SET_INTERVAL needs to be there
  * @est:	Storage for estimation data
  *
- * The size for this set type can vary dramatically, as it depends on the number
- * of rules (composing netmasks) the entries expand to. We compute the worst
- * case here.
- *
- * In general, for a non-ranged entry or a single composing netmask, we need
- * one bit in each of the sixteen buckets, for each 4-bit group (that is, each
- * input bit needs four bits of matching data), plus a bucket in the mapping
- * table for each field.
- *
- * Return: true only for compatible range concatenations
+ * Return: true if set description is compatible, false otherwise
  */
 static bool nft_pipapo_estimate(const struct nft_set_desc *desc, u32 features,
 				struct nft_set_estimate *est)
 {
-	unsigned long entry_size;
-	int i;
-
 	if (!(features & NFT_SET_INTERVAL) || desc->field_count <= 1)
 		return false;
 
-	for (i = 0, entry_size = 0; i < desc->field_count; i++) {
-		unsigned long rules;
-
-		if (desc->field_len[i] > NFT_PIPAPO_MAX_BYTES)
-			return false;
-
-		/* Worst-case ranges for each concatenated field: each n-bit
-		 * field can expand to up to n * 2 rules in each bucket, and
-		 * each rule also needs a mapping bucket.
-		 */
-		rules = ilog2(desc->field_len[i] * BITS_PER_BYTE) * 2;
-		entry_size += rules *
-			      NFT_PIPAPO_BUCKETS(NFT_PIPAPO_GROUP_BITS_INIT) /
-			      BITS_PER_BYTE;
-		entry_size += rules * sizeof(union nft_pipapo_map_bucket);
-	}
-
-	/* Rules in lookup and mapping tables are needed for each entry */
-	est->size = desc->size * entry_size;
-	if (est->size && div_u64(est->size, desc->size) != entry_size)
+	est->size = pipapo_estimate_size(desc);
+	if (!est->size)
 		return false;
 
-	est->size += sizeof(struct nft_pipapo) +
-		     sizeof(struct nft_pipapo_match) * 2;
-
-	est->size += sizeof(struct nft_pipapo_field) * desc->field_count;
-
 	est->lookup = NFT_SET_CLASS_O_LOG_N;
 
 	est->space = NFT_SET_CLASS_O_N;
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
new file mode 100644
index 000000000000..3cfc0a385ee2
--- /dev/null
+++ b/net/netfilter/nft_set_pipapo.h
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#ifndef _NFT_SET_PIPAPO_H
+
+#include <linux/log2.h>
+#include <net/ipv6.h>			/* For the maximum length of a field */
+
+/* Count of concatenated fields depends on count of 32-bit nftables registers */
+#define NFT_PIPAPO_MAX_FIELDS		NFT_REG32_COUNT
+
+/* Largest supported field size */
+#define NFT_PIPAPO_MAX_BYTES		(sizeof(struct in6_addr))
+#define NFT_PIPAPO_MAX_BITS		(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
+
+/* Bits to be grouped together in table buckets depending on set size */
+#define NFT_PIPAPO_GROUP_BITS_INIT	NFT_PIPAPO_GROUP_BITS_SMALL_SET
+#define NFT_PIPAPO_GROUP_BITS_SMALL_SET	8
+#define NFT_PIPAPO_GROUP_BITS_LARGE_SET	4
+#define NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4				\
+	BUILD_BUG_ON((NFT_PIPAPO_GROUP_BITS_SMALL_SET != 8) ||		\
+		     (NFT_PIPAPO_GROUP_BITS_LARGE_SET != 4))
+#define NFT_PIPAPO_GROUPS_PER_BYTE(f)	(BITS_PER_BYTE / (f)->bb)
+
+/* If a lookup table gets bigger than NFT_PIPAPO_LT_SIZE_HIGH, switch to the
+ * small group width, and switch to the big group width if the table gets
+ * smaller than NFT_PIPAPO_LT_SIZE_LOW.
+ *
+ * Picking 2MiB as threshold (for a single table) avoids as much as possible
+ * crossing page boundaries on most architectures (x86-64 and MIPS huge pages,
+ * ARMv7 supersections, POWER "large" pages, SPARC Level 1 regions, etc.), which
+ * keeps performance nice in case kvmalloc() gives us non-contiguous areas.
+ */
+#define NFT_PIPAPO_LT_SIZE_THRESHOLD	(1 << 21)
+#define NFT_PIPAPO_LT_SIZE_HYSTERESIS	(1 << 16)
+#define NFT_PIPAPO_LT_SIZE_HIGH		NFT_PIPAPO_LT_SIZE_THRESHOLD
+#define NFT_PIPAPO_LT_SIZE_LOW		NFT_PIPAPO_LT_SIZE_THRESHOLD -	\
+					NFT_PIPAPO_LT_SIZE_HYSTERESIS
+
+/* Fields are padded to 32 bits in input registers */
+#define NFT_PIPAPO_GROUPS_PADDED_SIZE(f)				\
+	(round_up((f)->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f), sizeof(u32)))
+#define NFT_PIPAPO_GROUPS_PADDING(f)					\
+	(NFT_PIPAPO_GROUPS_PADDED_SIZE(f) - (f)->groups /		\
+					    NFT_PIPAPO_GROUPS_PER_BYTE(f))
+
+/* Number of buckets given by 2 ^ n, with n bucket bits */
+#define NFT_PIPAPO_BUCKETS(bb)		(1 << (bb))
+
+/* Each n-bit range maps to up to n * 2 rules */
+#define NFT_PIPAPO_MAP_NBITS		(const_ilog2(NFT_PIPAPO_MAX_BITS * 2))
+
+/* Use the rest of mapping table buckets for rule indices, but it makes no sense
+ * to exceed 32 bits
+ */
+#if BITS_PER_LONG == 64
+#define NFT_PIPAPO_MAP_TOBITS		32
+#else
+#define NFT_PIPAPO_MAP_TOBITS		(BITS_PER_LONG - NFT_PIPAPO_MAP_NBITS)
+#endif
+
+/* ...which gives us the highest allowed index for a rule */
+#define NFT_PIPAPO_RULE0_MAX		((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
+					- (1UL << NFT_PIPAPO_MAP_NBITS))
+
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
+#define nft_pipapo_for_each_field(field, index, match)		\
+	for ((field) = (match)->f, (index) = 0;			\
+	     (index) < (match)->field_count;			\
+	     (index)++, (field)++)
+
+/**
+ * union nft_pipapo_map_bucket - Bucket of mapping table
+ * @to:		First rule number (in next field) this rule maps to
+ * @n:		Number of rules (in next field) this rule maps to
+ * @e:		If there's no next field, pointer to element this rule maps to
+ */
+union nft_pipapo_map_bucket {
+	struct {
+#if BITS_PER_LONG == 64
+		static_assert(NFT_PIPAPO_MAP_TOBITS <= 32);
+		u32 to;
+
+		static_assert(NFT_PIPAPO_MAP_NBITS <= 32);
+		u32 n;
+#else
+		unsigned long to:NFT_PIPAPO_MAP_TOBITS;
+		unsigned long  n:NFT_PIPAPO_MAP_NBITS;
+#endif
+	};
+	struct nft_pipapo_elem *e;
+};
+
+/**
+ * struct nft_pipapo_field - Lookup, mapping tables and related data for a field
+ * @groups:	Amount of bit groups
+ * @rules:	Number of inserted rules
+ * @bsize:	Size of each bucket in lookup table, in longs
+ * @bb:		Number of bits grouped together in lookup table buckets
+ * @lt:		Lookup table: 'groups' rows of buckets
+ * @lt_aligned:	Version of @lt aligned to NFT_PIPAPO_ALIGN bytes
+ * @mt:		Mapping table: one bucket per rule
+ */
+struct nft_pipapo_field {
+	int groups;
+	unsigned long rules;
+	size_t bsize;
+	int bb;
+#ifdef NFT_PIPAPO_ALIGN
+	unsigned long *lt_aligned;
+#endif
+	unsigned long *lt;
+	union nft_pipapo_map_bucket *mt;
+};
+
+/**
+ * struct nft_pipapo_match - Data used for lookup and matching
+ * @field_count		Amount of fields in set
+ * @scratch:		Preallocated per-CPU maps for partial matching results
+ * @scratch_aligned:	Version of @scratch aligned to NFT_PIPAPO_ALIGN bytes
+ * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
+ * @rcu			Matching data is swapped on commits
+ * @f:			Fields, with lookup and mapping tables
+ */
+struct nft_pipapo_match {
+	int field_count;
+#ifdef NFT_PIPAPO_ALIGN
+	unsigned long * __percpu *scratch_aligned;
+#endif
+	unsigned long * __percpu *scratch;
+	size_t bsize_max;
+	struct rcu_head rcu;
+	struct nft_pipapo_field f[];
+};
+
+/**
+ * struct nft_pipapo - Representation of a set
+ * @match:	Currently in-use matching data
+ * @clone:	Copy where pending insertions and deletions are kept
+ * @width:	Total bytes to be matched for one packet, including padding
+ * @dirty:	Working copy has pending insertions or deletions
+ * @last_gc:	Timestamp of last garbage collection run, jiffies
+ */
+struct nft_pipapo {
+	struct nft_pipapo_match __rcu *match;
+	struct nft_pipapo_match *clone;
+	int width;
+	bool dirty;
+	unsigned long last_gc;
+};
+
+struct nft_pipapo_elem;
+
+/**
+ * struct nft_pipapo_elem - API-facing representation of single set element
+ * @ext:	nftables API extensions
+ */
+struct nft_pipapo_elem {
+	struct nft_set_ext ext;
+};
+
+int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
+		  union nft_pipapo_map_bucket *mt, bool match_only);
+
+/**
+ * pipapo_and_field_buckets_4bit() - Intersect 4-bit buckets
+ * @f:		Field including lookup table
+ * @dst:	Area to store result
+ * @data:	Input data selecting table buckets
+ */
+static inline void pipapo_and_field_buckets_4bit(struct nft_pipapo_field *f,
+						 unsigned long *dst,
+						 const u8 *data)
+{
+	unsigned long *lt = NFT_PIPAPO_LT_ALIGN(f->lt);
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
+ * pipapo_and_field_buckets_8bit() - Intersect 8-bit buckets
+ * @f:		Field including lookup table
+ * @dst:	Area to store result
+ * @data:	Input data selecting table buckets
+ */
+static inline void pipapo_and_field_buckets_8bit(struct nft_pipapo_field *f,
+						 unsigned long *dst,
+						 const u8 *data)
+{
+	unsigned long *lt = NFT_PIPAPO_LT_ALIGN(f->lt);
+	int group;
+
+	for (group = 0; group < f->groups; group++, data++) {
+		__bitmap_and(dst, dst, lt + *data * f->bsize,
+			     f->bsize * BITS_PER_LONG);
+		lt += f->bsize * NFT_PIPAPO_BUCKETS(8);
+	}
+}
+
+/**
+ * pipapo_estimate_size() - Estimate worst-case for set size
+ * @desc:	Set description, element count and field description used here
+ *
+ * The size for this set type can vary dramatically, as it depends on the number
+ * of rules (composing netmasks) the entries expand to. We compute the worst
+ * case here.
+ *
+ * In general, for a non-ranged entry or a single composing netmask, we need
+ * one bit in each of the sixteen NFT_PIPAPO_BUCKETS, for each 4-bit group (that
+ * is, each input bit needs four bits of matching data), plus a bucket in the
+ * mapping table for each field.
+ *
+ * Return: worst-case set size in bytes, 0 on any overflow
+ */
+static u64 pipapo_estimate_size(const struct nft_set_desc *desc)
+{
+	unsigned long entry_size;
+	u64 size;
+	int i;
+
+	for (i = 0, entry_size = 0; i < desc->field_count; i++) {
+		unsigned long rules;
+
+		if (desc->field_len[i] > NFT_PIPAPO_MAX_BYTES)
+			return 0;
+
+		/* Worst-case ranges for each concatenated field: each n-bit
+		 * field can expand to up to n * 2 rules in each bucket, and
+		 * each rule also needs a mapping bucket.
+		 */
+		rules = ilog2(desc->field_len[i] * BITS_PER_BYTE) * 2;
+		entry_size += rules *
+			      NFT_PIPAPO_BUCKETS(NFT_PIPAPO_GROUP_BITS_INIT) /
+			      BITS_PER_BYTE;
+		entry_size += rules * sizeof(union nft_pipapo_map_bucket);
+	}
+
+	/* Rules in lookup and mapping tables are needed for each entry */
+	size = desc->size * entry_size;
+	if (size && div_u64(size, desc->size) != entry_size)
+		return 0;
+
+	size += sizeof(struct nft_pipapo) + sizeof(struct nft_pipapo_match) * 2;
+
+	size += sizeof(struct nft_pipapo_field) * desc->field_count;
+
+	return size;
+}
+
+#endif /* _NFT_SET_PIPAPO_H */
-- 
2.11.0

