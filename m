Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214C418930D
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCRAkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:51 -0400
Received: from correo.us.es ([193.147.175.20]:45618 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbgCRAkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C401F27F8C0
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF321DA38F
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4E64DA39F; Wed, 18 Mar 2020 01:39:49 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69AB4DA38F;
        Wed, 18 Mar 2020 01:39:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3FCA2426CCB9;
        Wed, 18 Mar 2020 01:39:47 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 16/29] nft_set_pipapo: Add support for 8-bit lookup groups and dynamic switch
Date:   Wed, 18 Mar 2020 01:39:43 +0100
Message-Id: <20200318003956.73573-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

While grouping matching bits in groups of four saves memory compared
to the more natural choice of 8-bit words (lookup table size is one
eighth), it comes at a performance cost, as the number of lookup
comparisons is doubled, and those also needs bitshifts and masking.

Introduce support for 8-bit lookup groups, together with a mapping
mechanism to dynamically switch, based on defined per-table size
thresholds and hysteresis, between 8-bit and 4-bit groups, as tables
grow and shrink. Empty sets start with 8-bit groups, and per-field
tables are converted to 4-bit groups if they get too big.

An alternative approach would have been to swap per-set lookup
operation functions as needed, but this doesn't allow for different
group sizes in the same set, which looks desirable if some fields
need significantly more matching data compared to others due to
heavier impact of ranges (e.g. a big number of subnets with
relatively simple port specifications).

Allowing different group sizes for the same lookup functions implies
the need for further conditional clauses, whose cost, however,
appears to be negligible in tests.

The matching rate figures below were obtained for x86_64 running
the nft_concat_range.sh "performance" cases, averaged over five
runs, on a single thread of an AMD Epyc 7402 CPU, and for aarch64
on a single thread of a BCM2711 (Raspberry Pi 4 Model B 4GB),
clocked at a stable 2147MHz frequency:

---------------.-----------------------------------.------------.
AMD Epyc 7402  |          baselines, Mpps          | this patch |
 1 thread      |___________________________________|____________|
 3.35GHz       |        |        |        |        |            |
 768KiB L1D$   | netdev |  hash  | rbtree |        |            |
---------------|  hook  |   no   | single | pipapo |   pipapo   |
type   entries |  drop  | ranges | field  | 4 bits | bit switch |
---------------|--------|--------|--------|--------|------------|
net,port       |        |        |        |        |            |
         1000  |   19.0 |   10.4 |    3.8 |    2.8 | 4.0   +43% |
---------------|--------|--------|--------|--------|------------|
port,net       |        |        |        |        |            |
          100  |   18.8 |   10.3 |    5.8 |    5.5 | 6.3   +14% |
---------------|--------|--------|--------|--------|------------|
net6,port      |        |        |        |        |            |
         1000  |   16.4 |    7.6 |    1.8 |    1.3 | 2.1   +61% |
---------------|--------|--------|--------|--------|------------|
port,proto     |        |        |        |        |     [1]    |
        30000  |   19.6 |   11.6 |    3.9 |    0.3 | 0.5   +66% |
---------------|--------|--------|--------|--------|------------|
net6,port,mac  |        |        |        |        |            |
           10  |   16.5 |    5.4 |    4.3 |    2.6 | 3.4   +31% |
---------------|--------|--------|--------|--------|------------|
net6,port,mac, |        |        |        |        |            |
proto    1000  |   16.5 |    5.7 |    1.9 |    1.0 | 1.4   +40% |
---------------|--------|--------|--------|--------|------------|
net,mac        |        |        |        |        |            |
         1000  |   19.0 |    8.4 |    3.9 |    1.7 | 2.5   +47% |
---------------'--------'--------'--------'--------'------------'
[1] Causes switch of lookup table buckets for 'port', not 'proto',
    to 4-bit groups

 ---------------.-----------------------------------.------------.
 BCM2711        |          baselines, Mpps          | this patch |
  1 thread      |___________________________________|____________|
  2147MHz       |        |        |        |        |            |
  32KiB L1D$    | netdev |  hash  | rbtree |        |            |
 ---------------|  hook  |   no   | single | pipapo |   pipapo   |
 type   entries |  drop  | ranges | field  | 4 bits | bit switch |
 ---------------|--------|--------|--------|--------|------------|
 net,port       |        |        |        |        |            |
          1000  |   1.63 |   1.37 |   0.87 |   0.61 | 0.70  +17% |
 ---------------|--------|--------|--------|--------|------------|
 port,net       |        |        |        |        |            |
           100  |   1.64 |   1.36 |   1.02 |   0.78 | 0.81   +4% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port      |        |        |        |        |            |
          1000  |   1.56 |   1.27 |   0.65 |   0.34 | 0.50  +47% |
 ---------------|--------|--------|--------|--------|------------|
 port,proto [2] |        |        |        |        |            |
         10000  |   1.68 |   1.43 |   0.84 |   0.30 | 0.40  +13% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port,mac  |        |        |        |        |            |
            10  |   1.56 |   1.14 |   1.02 |   0.62 | 0.66   +6% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port,mac, |        |        |        |        |            |
 proto    1000  |   1.56 |   1.12 |   0.64 |   0.27 | 0.40  +48% |
 ---------------|--------|--------|--------|--------|------------|
 net,mac        |        |        |        |        |            |
          1000  |   1.63 |   1.26 |   0.87 |   0.41 | 0.53  +29% |
 ---------------'--------'--------'--------'--------'------------'
[2] Using 10000 entries instead of 30000 as it would take way too
    long for the test script to generate all of them

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 241 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 233 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 43d7189a6a1f..83e54bd3187d 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -348,11 +348,30 @@
 #define NFT_PIPAPO_MAX_BYTES		(sizeof(struct in6_addr))
 #define NFT_PIPAPO_MAX_BITS		(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
 
-/* Number of bits to be grouped together in lookup table buckets, arbitrary */
-#define NFT_PIPAPO_GROUP_BITS		4
-
+/* Bits to be grouped together in table buckets depending on set size */
+#define NFT_PIPAPO_GROUP_BITS_INIT	NFT_PIPAPO_GROUP_BITS_SMALL_SET
+#define NFT_PIPAPO_GROUP_BITS_SMALL_SET	8
+#define NFT_PIPAPO_GROUP_BITS_LARGE_SET	4
+#define NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4				\
+	BUILD_BUG_ON((NFT_PIPAPO_GROUP_BITS_SMALL_SET != 8) ||		\
+		     (NFT_PIPAPO_GROUP_BITS_LARGE_SET != 4))
 #define NFT_PIPAPO_GROUPS_PER_BYTE(f)	(BITS_PER_BYTE / (f)->bb)
 
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
 /* Fields are padded to 32 bits in input registers */
 #define NFT_PIPAPO_GROUPS_PADDED_SIZE(f)				\
 	(round_up((f)->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f), sizeof(u32)))
@@ -551,6 +570,26 @@ static void pipapo_and_field_buckets_4bit(struct nft_pipapo_field *f,
 }
 
 /**
+ * pipapo_and_field_buckets_8bit() - Intersect buckets for 8-bit groups
+ * @f:		Field including lookup table
+ * @dst:	Area to store result
+ * @data:	Input data selecting table buckets
+ */
+static void pipapo_and_field_buckets_8bit(struct nft_pipapo_field *f,
+					  unsigned long *dst,
+					  const u8 *data)
+{
+	unsigned long *lt = f->lt;
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
  * nft_pipapo_lookup() - Lookup function
  * @net:	Network namespace
  * @set:	nftables API set representation
@@ -594,8 +633,11 @@ static bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
 		/* For each bit group: select lookup table bucket depending on
 		 * packet bytes value, then AND bucket value
 		 */
-		pipapo_and_field_buckets_4bit(f, res_map, rp);
-		BUILD_BUG_ON(NFT_PIPAPO_GROUP_BITS != 4);
+		if (likely(f->bb == 8))
+			pipapo_and_field_buckets_8bit(f, res_map, rp);
+		else
+			pipapo_and_field_buckets_4bit(f, res_map, rp);
+		NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
 
 		rp += f->groups / NFT_PIPAPO_GROUPS_PER_BYTE(f);
 
@@ -693,7 +735,9 @@ static struct nft_pipapo_elem *pipapo_get(const struct net *net,
 		/* For each bit group: select lookup table bucket depending on
 		 * packet bytes value, then AND bucket value
 		 */
-		if (f->bb == 4)
+		if (f->bb == 8)
+			pipapo_and_field_buckets_8bit(f, res_map, data);
+		else if (f->bb == 4)
 			pipapo_and_field_buckets_4bit(f, res_map, data);
 		else
 			BUG();
@@ -846,6 +890,183 @@ static void pipapo_bucket_set(struct nft_pipapo_field *f, int rule, int group,
 }
 
 /**
+ * pipapo_lt_4b_to_8b() - Switch lookup table group width from 4 bits to 8 bits
+ * @old_groups:	Number of current groups
+ * @bsize:	Size of one bucket, in longs
+ * @old_lt:	Pointer to the current lookup table
+ * @new_lt:	Pointer to the new, pre-allocated lookup table
+ *
+ * Each bucket with index b in the new lookup table, belonging to group g, is
+ * filled with the bit intersection between:
+ * - bucket with index given by the upper 4 bits of b, from group g, and
+ * - bucket with index given by the lower 4 bits of b, from group g + 1
+ *
+ * That is, given buckets from the new lookup table N(x, y) and the old lookup
+ * table O(x, y), with x bucket index, and y group index:
+ *
+ *	N(b, g) := O(b / 16, g) & O(b % 16, g + 1)
+ *
+ * This ensures equivalence of the matching results on lookup. Two examples in
+ * pictures:
+ *
+ *              bucket
+ *  group  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 ... 254 255
+ *    0                ^
+ *    1                |                                                 ^
+ *   ...             ( & )                                               |
+ *                  /     \                                              |
+ *                 /       \                                         .-( & )-.
+ *                /  bucket \                                        |       |
+ *      group  0 / 1   2   3 \ 4   5   6   7   8   9  10  11  12  13 |14  15 |
+ *        0     /             \                                      |       |
+ *        1                    \                                     |       |
+ *        2                                                          |     --'
+ *        3                                                          '-
+ *       ...
+ */
+static void pipapo_lt_4b_to_8b(int old_groups, int bsize,
+			       unsigned long *old_lt, unsigned long *new_lt)
+{
+	int g, b, i;
+
+	for (g = 0; g < old_groups / 2; g++) {
+		int src_g0 = g * 2, src_g1 = g * 2 + 1;
+
+		for (b = 0; b < NFT_PIPAPO_BUCKETS(8); b++) {
+			int src_b0 = b / NFT_PIPAPO_BUCKETS(4);
+			int src_b1 = b % NFT_PIPAPO_BUCKETS(4);
+			int src_i0 = src_g0 * NFT_PIPAPO_BUCKETS(4) + src_b0;
+			int src_i1 = src_g1 * NFT_PIPAPO_BUCKETS(4) + src_b1;
+
+			for (i = 0; i < bsize; i++) {
+				*new_lt = old_lt[src_i0 * bsize + i] &
+					  old_lt[src_i1 * bsize + i];
+				new_lt++;
+			}
+		}
+	}
+}
+
+/**
+ * pipapo_lt_8b_to_4b() - Switch lookup table group width from 8 bits to 4 bits
+ * @old_groups:	Number of current groups
+ * @bsize:	Size of one bucket, in longs
+ * @old_lt:	Pointer to the current lookup table
+ * @new_lt:	Pointer to the new, pre-allocated lookup table
+ *
+ * Each bucket with index b in the new lookup table, belonging to group g, is
+ * filled with the bit union of:
+ * - all the buckets with index such that the upper four bits of the lower byte
+ *   equal b, from group g, with g odd
+ * - all the buckets with index such that the lower four bits equal b, from
+ *   group g, with g even
+ *
+ * That is, given buckets from the new lookup table N(x, y) and the old lookup
+ * table O(x, y), with x bucket index, and y group index:
+ *
+ *	- with g odd:  N(b, g) := U(O(x, g) for each x : x = (b & 0xf0) >> 4)
+ *	- with g even: N(b, g) := U(O(x, g) for each x : x = b & 0x0f)
+ *
+ * where U() denotes the arbitrary union operation (binary OR of n terms). This
+ * ensures equivalence of the matching results on lookup.
+ */
+static void pipapo_lt_8b_to_4b(int old_groups, int bsize,
+			       unsigned long *old_lt, unsigned long *new_lt)
+{
+	int g, b, bsrc, i;
+
+	memset(new_lt, 0, old_groups * 2 * NFT_PIPAPO_BUCKETS(4) * bsize *
+			  sizeof(unsigned long));
+
+	for (g = 0; g < old_groups * 2; g += 2) {
+		int src_g = g / 2;
+
+		for (b = 0; b < NFT_PIPAPO_BUCKETS(4); b++) {
+			for (bsrc = NFT_PIPAPO_BUCKETS(8) * src_g;
+			     bsrc < NFT_PIPAPO_BUCKETS(8) * (src_g + 1);
+			     bsrc++) {
+				if (((bsrc & 0xf0) >> 4) != b)
+					continue;
+
+				for (i = 0; i < bsize; i++)
+					new_lt[i] |= old_lt[bsrc * bsize + i];
+			}
+
+			new_lt += bsize;
+		}
+
+		for (b = 0; b < NFT_PIPAPO_BUCKETS(4); b++) {
+			for (bsrc = NFT_PIPAPO_BUCKETS(8) * src_g;
+			     bsrc < NFT_PIPAPO_BUCKETS(8) * (src_g + 1);
+			     bsrc++) {
+				if ((bsrc & 0x0f) != b)
+					continue;
+
+				for (i = 0; i < bsize; i++)
+					new_lt[i] |= old_lt[bsrc * bsize + i];
+			}
+
+			new_lt += bsize;
+		}
+	}
+}
+
+/**
+ * pipapo_lt_bits_adjust() - Adjust group size for lookup table if needed
+ * @f:		Field containing lookup table
+ */
+static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
+{
+	unsigned long *new_lt;
+	int groups, bb;
+	size_t lt_size;
+
+	lt_size = f->groups * NFT_PIPAPO_BUCKETS(f->bb) * f->bsize *
+		  sizeof(*f->lt);
+
+	if (f->bb == NFT_PIPAPO_GROUP_BITS_SMALL_SET &&
+	    lt_size > NFT_PIPAPO_LT_SIZE_HIGH) {
+		groups = f->groups * 2;
+		bb = NFT_PIPAPO_GROUP_BITS_LARGE_SET;
+
+		lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
+			  sizeof(*f->lt);
+	} else if (f->bb == NFT_PIPAPO_GROUP_BITS_LARGE_SET &&
+		   lt_size < NFT_PIPAPO_LT_SIZE_LOW) {
+		groups = f->groups / 2;
+		bb = NFT_PIPAPO_GROUP_BITS_SMALL_SET;
+
+		lt_size = groups * NFT_PIPAPO_BUCKETS(bb) * f->bsize *
+			  sizeof(*f->lt);
+
+		/* Don't increase group width if the resulting lookup table size
+		 * would exceed the upper size threshold for a "small" set.
+		 */
+		if (lt_size > NFT_PIPAPO_LT_SIZE_HIGH)
+			return;
+	} else {
+		return;
+	}
+
+	new_lt = kvzalloc(lt_size, GFP_KERNEL);
+	if (!new_lt)
+		return;
+
+	NFT_PIPAPO_GROUP_BITS_ARE_8_OR_4;
+	if (f->bb == 4 && bb == 8)
+		pipapo_lt_4b_to_8b(f->groups, f->bsize, f->lt, new_lt);
+	else if (f->bb == 8 && bb == 4)
+		pipapo_lt_8b_to_4b(f->groups, f->bsize, f->lt, new_lt);
+	else
+		BUG();
+
+	f->groups = groups;
+	f->bb = bb;
+	kvfree(f->lt);
+	f->lt = new_lt;
+}
+
+/**
  * pipapo_insert() - Insert new rule in field given input key and mask length
  * @f:		Field containing lookup table
  * @k:		Input key for classification, without nftables padding
@@ -894,6 +1115,8 @@ static int pipapo_insert(struct nft_pipapo_field *f, const uint8_t *k,
 		}
 	}
 
+	pipapo_lt_bits_adjust(f);
+
 	return 1;
 }
 
@@ -1424,6 +1647,8 @@ static void pipapo_drop(struct nft_pipapo_match *m,
 			;
 		}
 		f->rules -= rulemap[i].n;
+
+		pipapo_lt_bits_adjust(f);
 	}
 }
 
@@ -1936,7 +2161,7 @@ static bool nft_pipapo_estimate(const struct nft_set_desc *desc, u32 features,
 		 */
 		rules = ilog2(desc->field_len[i] * BITS_PER_BYTE) * 2;
 		entry_size += rules *
-			      NFT_PIPAPO_BUCKETS(NFT_PIPAPO_GROUP_BITS) /
+			      NFT_PIPAPO_BUCKETS(NFT_PIPAPO_GROUP_BITS_INIT) /
 			      BITS_PER_BYTE;
 		entry_size += rules * sizeof(union nft_pipapo_map_bucket);
 	}
@@ -2001,7 +2226,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 	rcu_head_init(&m->rcu);
 
 	nft_pipapo_for_each_field(f, i, m) {
-		f->bb = NFT_PIPAPO_GROUP_BITS;
+		f->bb = NFT_PIPAPO_GROUP_BITS_INIT;
 		f->groups = desc->field_len[i] * NFT_PIPAPO_GROUPS_PER_BYTE(f);
 
 		priv->width += round_up(desc->field_len[i], sizeof(u32));
-- 
2.11.0

