Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E5A1E9E41
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 08:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgFAGaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 02:30:08 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55897 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgFAGaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 02:30:07 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4e28d431;
        Mon, 1 Jun 2020 06:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=ctAVz0b3hgd5G8xBte1aR9sfx
        9c=; b=cpNUlAn6Fm+5S3jRomv64mU+18/6iOZ6biaCf1aMHZKzA28Ct/2+ceRXr
        zgbnEYXLZ01LilKfZQ9QlTkLNBP05V0oMZAuJdxErEH81I3HgpDSA5SRdN1JF6kF
        +V7nw5Q+ouJdbj7dikTrbCwBdxKYYysQfy5FLbyutztrpacu9Cstc1e4AM0y7pXo
        +ogfBNfMBGGNp8wigFP41E05wKf+m/o9vUQovURnfKtOrS3Q9gu08stqL2sZkhYP
        EvsTsLXJEqtsZsfh3jqfBbkJ71UzjRhNknLYr9KodDoe+sWdgtk73GSk1+DJIbh8
        8DOoJ79FGUxyQRO8zWMGL+LMzHCcw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 71b920dd (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 1 Jun 2020 06:13:54 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 1/1] wireguard: reformat to 100 column lines
Date:   Mon,  1 Jun 2020 00:29:46 -0600
Message-Id: <20200601062946.160954-2-Jason@zx2c4.com>
In-Reply-To: <20200601062946.160954-1-Jason@zx2c4.com>
References: <20200601062946.160954-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While this sort of change is typically viewed as "trivial", "cosmetic",
or even "bikesheddy", I think there's a very serious argument to be made
about the readability and comprehensibility of the code as a result.

One of the principle motivations for WireGuard is that the code is
readable and, generally, enjoyable to read, so that people do actually
spend time understanding it and helping to find bugs. Changing the
original codebase to 80 columns was a painful exercise, and resulted in
something much less satisfactory than desired. It wasn't really worth
debating -- conventions are conventions, after all -- but with the
recent Linux style guideline being changed from 80 to 100, we can
finally revisit this. The end result makes a considerable difference.
Even when developing on this code base prior, I tended to work in ~100
line columns, sometimes reformatting a function for the purposes of
development, before packaging it back up for the mailing list. With this
change, development and maintenance also becomes a more enjoyable task.

Generally speaking, I did not write WireGuard with butchered variable
names, preferring things that would be immediately memorable and
recognizable for readers. For example, I prefer to name the ephemeral
private key "ephemeral_private" instead of "ep" or "eph_priv", so that
there's no guess work or additional cognitive strain when auditing. It
seems like many other parts of the kernel have made similar choices. For
example, "hlist_for_each_entry_rcu_bh" is a very clearly named function,
that tells me exactly what it's going to do, without needing to guess or
look things up in documentation. But it's also 27 characters. Previously
this would cause all sorts of gnarly wrapping; now it reads naturally.

To be clear, this isn't at all a reversion to the original v1 submission
of WireGuard, which had wild and out of control column widths. Rather,
this is a thorough reworking based on the readability afforded to us now
by the 100 column guideline. This also isn't some kind of machine-made
automated conversion. All of this has been reworked by hand, hours of
work, with real attention to detail, given 100 column constraints.

My hope in paying attention to readability like this is that it will
produce a more maintainable codebase, as well as being more attractive
to audit and understand fully. Logistically, it also happens to be a
good time in the development cycle for making these kinds of changes.

Since, as mentioned earlier, I did do this by hand, I've made sure that
the actual resulting algorithms haven't changed at all by accident. The
only actual change is that device.o winds up slightly different, due to
the call to `ASSERT_RTNL` in `wg_netdevice_notification`. That macro
expands to something with __LINE__ in it, which then changes the input
argument to the printk. Beyond this, the object files are byte-for-byte
identical.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/allowedips.c           |  98 +++---
 drivers/net/wireguard/allowedips.h           |  22 +-
 drivers/net/wireguard/cookie.c               |  90 ++----
 drivers/net/wireguard/cookie.h               |  15 +-
 drivers/net/wireguard/device.c               |  69 ++--
 drivers/net/wireguard/messages.h             |  10 +-
 drivers/net/wireguard/netlink.c              | 143 +++------
 drivers/net/wireguard/noise.c                | 321 ++++++++-----------
 drivers/net/wireguard/noise.h                |  20 +-
 drivers/net/wireguard/peer.c                 |  92 +++---
 drivers/net/wireguard/peer.h                 |   3 +-
 drivers/net/wireguard/peerlookup.c           |  96 +++---
 drivers/net/wireguard/peerlookup.h           |  27 +-
 drivers/net/wireguard/queueing.c             |  14 +-
 drivers/net/wireguard/queueing.h             |  66 ++--
 drivers/net/wireguard/ratelimiter.c          |  39 +--
 drivers/net/wireguard/receive.c              | 162 ++++------
 drivers/net/wireguard/selftest/allowedips.c  | 164 ++++------
 drivers/net/wireguard/selftest/counter.c     |  13 +-
 drivers/net/wireguard/selftest/ratelimiter.c |  35 +-
 drivers/net/wireguard/send.c                 | 163 ++++------
 drivers/net/wireguard/socket.c               |  75 ++---
 drivers/net/wireguard/socket.h               |  30 +-
 drivers/net/wireguard/timers.c               | 110 +++----
 drivers/net/wireguard/timers.h               |   3 +-
 include/uapi/linux/wireguard.h               |  89 +++--
 26 files changed, 753 insertions(+), 1216 deletions(-)

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index 3725e9cd85f4..ef059c83f7f7 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -16,8 +16,7 @@ static void swap_endian(u8 *dst, const u8 *src, u8 bits)
 	}
 }
 
-static void copy_and_assign_cidr(struct allowedips_node *node, const u8 *src,
-				 u8 cidr, u8 bits)
+static void copy_and_assign_cidr(struct allowedips_node *node, const u8 *src, u8 cidr, u8 bits)
 {
 	node->cidr = cidr;
 	node->bit_at_a = cidr / 8U;
@@ -28,11 +27,9 @@ static void copy_and_assign_cidr(struct allowedips_node *node, const u8 *src,
 	node->bitlen = bits;
 	memcpy(node->bits, src, bits / 8U);
 }
-#define CHOOSE_NODE(parent, key) \
-	parent->bit[(key[parent->bit_at_a] >> parent->bit_at_b) & 1]
+#define CHOOSE_NODE(parent, key) parent->bit[(key[parent->bit_at_a] >> parent->bit_at_b) & 1]
 
-static void push_rcu(struct allowedips_node **stack,
-		     struct allowedips_node __rcu *p, unsigned int *len)
+static void push_rcu(struct allowedips_node **stack, struct allowedips_node __rcu *p, unsigned int *len)
 {
 	if (rcu_access_pointer(p)) {
 		WARN_ON(IS_ENABLED(DEBUG) && *len >= 128);
@@ -42,8 +39,7 @@ static void push_rcu(struct allowedips_node **stack,
 
 static void root_free_rcu(struct rcu_head *rcu)
 {
-	struct allowedips_node *node, *stack[128] = {
-		container_of(rcu, struct allowedips_node, rcu) };
+	struct allowedips_node *node, *stack[128] = { container_of(rcu, struct allowedips_node, rcu) };
 	unsigned int len = 1;
 
 	while (len > 0 && (node = stack[--len])) {
@@ -66,8 +62,8 @@ static void root_remove_peer_lists(struct allowedips_node *root)
 	}
 }
 
-static void walk_remove_by_peer(struct allowedips_node __rcu **top,
-				struct wg_peer *peer, struct mutex *lock)
+static void walk_remove_by_peer(struct allowedips_node __rcu **top, struct wg_peer *peer,
+				struct mutex *lock)
 {
 #define REF(p) rcu_access_pointer(p)
 #define DEREF(p) rcu_dereference_protected(*(p), lockdep_is_held(lock))
@@ -90,8 +86,7 @@ static void walk_remove_by_peer(struct allowedips_node __rcu **top,
 			--len;
 			continue;
 		}
-		if (!prev || REF(prev->bit[0]) == node ||
-		    REF(prev->bit[1]) == node) {
+		if (!prev || REF(prev->bit[0]) == node || REF(prev->bit[1]) == node) {
 			if (REF(node->bit[0]))
 				PUSH(&node->bit[0]);
 			else if (REF(node->bit[1]))
@@ -100,13 +95,11 @@ static void walk_remove_by_peer(struct allowedips_node __rcu **top,
 			if (REF(node->bit[1]))
 				PUSH(&node->bit[1]);
 		} else {
-			if (rcu_dereference_protected(node->peer,
-				lockdep_is_held(lock)) == peer) {
+			if (rcu_dereference_protected(node->peer, lockdep_is_held(lock)) == peer) {
 				RCU_INIT_POINTER(node->peer, NULL);
 				list_del_init(&node->peer_list);
 				if (!node->bit[0] || !node->bit[1]) {
-					rcu_assign_pointer(*nptr, DEREF(
-					       &node->bit[!REF(node->bit[0])]));
+					rcu_assign_pointer(*nptr, DEREF(&node->bit[!REF(node->bit[0])]));
 					kfree_rcu(node, rcu);
 					node = DEREF(nptr);
 				}
@@ -125,32 +118,27 @@ static unsigned int fls128(u64 a, u64 b)
 	return a ? fls64(a) + 64U : fls64(b);
 }
 
-static u8 common_bits(const struct allowedips_node *node, const u8 *key,
-		      u8 bits)
+static u8 common_bits(const struct allowedips_node *node, const u8 *key, u8 bits)
 {
 	if (bits == 32)
 		return 32U - fls(*(const u32 *)node->bits ^ *(const u32 *)key);
 	else if (bits == 128)
-		return 128U - fls128(
-			*(const u64 *)&node->bits[0] ^ *(const u64 *)&key[0],
-			*(const u64 *)&node->bits[8] ^ *(const u64 *)&key[8]);
+		return 128U - fls128(*(const u64 *)&node->bits[0] ^ *(const u64 *)&key[0],
+				     *(const u64 *)&node->bits[8] ^ *(const u64 *)&key[8]);
 	return 0;
 }
 
-static bool prefix_matches(const struct allowedips_node *node, const u8 *key,
-			   u8 bits)
+static bool prefix_matches(const struct allowedips_node *node, const u8 *key, u8 bits)
 {
-	/* This could be much faster if it actually just compared the common
-	 * bits properly, by precomputing a mask bswap(~0 << (32 - cidr)), and
-	 * the rest, but it turns out that common_bits is already super fast on
-	 * modern processors, even taking into account the unfortunate bswap.
-	 * So, we just inline it like this instead.
+	/* This could be much faster if it actually just compared the common bits properly, by
+	 * precomputing a mask bswap(~0 << (32 - cidr)), and the rest, but it turns out that
+	 * common_bits is already super fast on modern processors, even taking into account the
+	 * unfortunate bswap.  So, we just inline it like this instead.
 	 */
 	return common_bits(node, key, bits) >= node->cidr;
 }
 
-static struct allowedips_node *find_node(struct allowedips_node *trie, u8 bits,
-					 const u8 *key)
+static struct allowedips_node *find_node(struct allowedips_node *trie, u8 bits, const u8 *key)
 {
 	struct allowedips_node *node = trie, *found = NULL;
 
@@ -165,8 +153,7 @@ static struct allowedips_node *find_node(struct allowedips_node *trie, u8 bits,
 }
 
 /* Returns a strong reference to a peer */
-static struct wg_peer *lookup(struct allowedips_node __rcu *root, u8 bits,
-			      const void *be_ip)
+static struct wg_peer *lookup(struct allowedips_node __rcu *root, u8 bits, const void *be_ip)
 {
 	/* Aligned so it can be passed to fls/fls64 */
 	u8 ip[16] __aligned(__alignof(u64));
@@ -187,12 +174,10 @@ static struct wg_peer *lookup(struct allowedips_node __rcu *root, u8 bits,
 	return peer;
 }
 
-static bool node_placement(struct allowedips_node __rcu *trie, const u8 *key,
-			   u8 cidr, u8 bits, struct allowedips_node **rnode,
-			   struct mutex *lock)
+static bool node_placement(struct allowedips_node __rcu *trie, const u8 *key, u8 cidr, u8 bits,
+			   struct allowedips_node **rnode, struct mutex *lock)
 {
-	struct allowedips_node *node = rcu_dereference_protected(trie,
-						lockdep_is_held(lock));
+	struct allowedips_node *node = rcu_dereference_protected(trie, lockdep_is_held(lock));
 	struct allowedips_node *parent = NULL;
 	bool exact = false;
 
@@ -202,15 +187,14 @@ static bool node_placement(struct allowedips_node __rcu *trie, const u8 *key,
 			exact = true;
 			break;
 		}
-		node = rcu_dereference_protected(CHOOSE_NODE(parent, key),
-						 lockdep_is_held(lock));
+		node = rcu_dereference_protected(CHOOSE_NODE(parent, key), lockdep_is_held(lock));
 	}
 	*rnode = parent;
 	return exact;
 }
 
-static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
-	       u8 cidr, struct wg_peer *peer, struct mutex *lock)
+static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key, u8 cidr,
+	       struct wg_peer *peer, struct mutex *lock)
 {
 	struct allowedips_node *node, *parent, *down, *newnode;
 
@@ -243,8 +227,7 @@ static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
 	if (!node) {
 		down = rcu_dereference_protected(*trie, lockdep_is_held(lock));
 	} else {
-		down = rcu_dereference_protected(CHOOSE_NODE(node, key),
-						 lockdep_is_held(lock));
+		down = rcu_dereference_protected(CHOOSE_NODE(node, key), lockdep_is_held(lock));
 		if (!down) {
 			rcu_assign_pointer(CHOOSE_NODE(node, key), newnode);
 			return 0;
@@ -258,8 +241,7 @@ static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
 		if (!parent)
 			rcu_assign_pointer(*trie, newnode);
 		else
-			rcu_assign_pointer(CHOOSE_NODE(parent, newnode->bits),
-					   newnode);
+			rcu_assign_pointer(CHOOSE_NODE(parent, newnode->bits), newnode);
 	} else {
 		node = kzalloc(sizeof(*node), GFP_KERNEL);
 		if (unlikely(!node)) {
@@ -275,8 +257,7 @@ static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
 		if (!parent)
 			rcu_assign_pointer(*trie, node);
 		else
-			rcu_assign_pointer(CHOOSE_NODE(parent, node->bits),
-					   node);
+			rcu_assign_pointer(CHOOSE_NODE(parent, node->bits), node);
 	}
 	return 0;
 }
@@ -295,23 +276,21 @@ void wg_allowedips_free(struct allowedips *table, struct mutex *lock)
 	RCU_INIT_POINTER(table->root4, NULL);
 	RCU_INIT_POINTER(table->root6, NULL);
 	if (rcu_access_pointer(old4)) {
-		struct allowedips_node *node = rcu_dereference_protected(old4,
-							lockdep_is_held(lock));
+		struct allowedips_node *node = rcu_dereference_protected(old4, lockdep_is_held(lock));
 
 		root_remove_peer_lists(node);
 		call_rcu(&node->rcu, root_free_rcu);
 	}
 	if (rcu_access_pointer(old6)) {
-		struct allowedips_node *node = rcu_dereference_protected(old6,
-							lockdep_is_held(lock));
+		struct allowedips_node *node = rcu_dereference_protected(old6, lockdep_is_held(lock));
 
 		root_remove_peer_lists(node);
 		call_rcu(&node->rcu, root_free_rcu);
 	}
 }
 
-int wg_allowedips_insert_v4(struct allowedips *table, const struct in_addr *ip,
-			    u8 cidr, struct wg_peer *peer, struct mutex *lock)
+int wg_allowedips_insert_v4(struct allowedips *table, const struct in_addr *ip, u8 cidr,
+			    struct wg_peer *peer, struct mutex *lock)
 {
 	/* Aligned so it can be passed to fls */
 	u8 key[4] __aligned(__alignof(u32));
@@ -321,8 +300,8 @@ int wg_allowedips_insert_v4(struct allowedips *table, const struct in_addr *ip,
 	return add(&table->root4, 32, key, cidr, peer, lock);
 }
 
-int wg_allowedips_insert_v6(struct allowedips *table, const struct in6_addr *ip,
-			    u8 cidr, struct wg_peer *peer, struct mutex *lock)
+int wg_allowedips_insert_v6(struct allowedips *table, const struct in6_addr *ip, u8 cidr,
+			    struct wg_peer *peer, struct mutex *lock)
 {
 	/* Aligned so it can be passed to fls64 */
 	u8 key[16] __aligned(__alignof(u64));
@@ -332,8 +311,7 @@ int wg_allowedips_insert_v6(struct allowedips *table, const struct in6_addr *ip,
 	return add(&table->root6, 128, key, cidr, peer, lock);
 }
 
-void wg_allowedips_remove_by_peer(struct allowedips *table,
-				  struct wg_peer *peer, struct mutex *lock)
+void wg_allowedips_remove_by_peer(struct allowedips *table, struct wg_peer *peer, struct mutex *lock)
 {
 	++table->seq;
 	walk_remove_by_peer(&table->root4, peer, lock);
@@ -353,8 +331,7 @@ int wg_allowedips_read_node(struct allowedips_node *node, u8 ip[16], u8 *cidr)
 }
 
 /* Returns a strong reference to a peer */
-struct wg_peer *wg_allowedips_lookup_dst(struct allowedips *table,
-					 struct sk_buff *skb)
+struct wg_peer *wg_allowedips_lookup_dst(struct allowedips *table, struct sk_buff *skb)
 {
 	if (skb->protocol == htons(ETH_P_IP))
 		return lookup(table->root4, 32, &ip_hdr(skb)->daddr);
@@ -364,8 +341,7 @@ struct wg_peer *wg_allowedips_lookup_dst(struct allowedips *table,
 }
 
 /* Returns a strong reference to a peer */
-struct wg_peer *wg_allowedips_lookup_src(struct allowedips *table,
-					 struct sk_buff *skb)
+struct wg_peer *wg_allowedips_lookup_src(struct allowedips *table, struct sk_buff *skb)
 {
 	if (skb->protocol == htons(ETH_P_IP))
 		return lookup(table->root4, 32, &ip_hdr(skb)->saddr);
diff --git a/drivers/net/wireguard/allowedips.h b/drivers/net/wireguard/allowedips.h
index e5c83cafcef4..288f9981261f 100644
--- a/drivers/net/wireguard/allowedips.h
+++ b/drivers/net/wireguard/allowedips.h
@@ -15,9 +15,8 @@ struct wg_peer;
 struct allowedips_node {
 	struct wg_peer __rcu *peer;
 	struct allowedips_node __rcu *bit[2];
-	/* While it may seem scandalous that we waste space for v4,
-	 * we're alloc'ing to the nearest power of 2 anyway, so this
-	 * doesn't actually make a difference.
+	/* While it may seem scandalous that we waste space for v4, we're alloc'ing to the nearest
+	 * power of 2 anyway, so this doesn't actually make a difference.
 	 */
 	u8 bits[16] __aligned(__alignof(u64));
 	u8 cidr, bit_at_a, bit_at_b, bitlen;
@@ -37,20 +36,17 @@ struct allowedips {
 
 void wg_allowedips_init(struct allowedips *table);
 void wg_allowedips_free(struct allowedips *table, struct mutex *mutex);
-int wg_allowedips_insert_v4(struct allowedips *table, const struct in_addr *ip,
-			    u8 cidr, struct wg_peer *peer, struct mutex *lock);
-int wg_allowedips_insert_v6(struct allowedips *table, const struct in6_addr *ip,
-			    u8 cidr, struct wg_peer *peer, struct mutex *lock);
-void wg_allowedips_remove_by_peer(struct allowedips *table,
-				  struct wg_peer *peer, struct mutex *lock);
+int wg_allowedips_insert_v4(struct allowedips *table, const struct in_addr *ip, u8 cidr,
+			    struct wg_peer *peer, struct mutex *lock);
+int wg_allowedips_insert_v6(struct allowedips *table, const struct in6_addr *ip, u8 cidr,
+			    struct wg_peer *peer, struct mutex *lock);
+void wg_allowedips_remove_by_peer(struct allowedips *table, struct wg_peer *peer, struct mutex *lock);
 /* The ip input pointer should be __aligned(__alignof(u64))) */
 int wg_allowedips_read_node(struct allowedips_node *node, u8 ip[16], u8 *cidr);
 
 /* These return a strong reference to a peer: */
-struct wg_peer *wg_allowedips_lookup_dst(struct allowedips *table,
-					 struct sk_buff *skb);
-struct wg_peer *wg_allowedips_lookup_src(struct allowedips *table,
-					 struct sk_buff *skb);
+struct wg_peer *wg_allowedips_lookup_dst(struct allowedips *table, struct sk_buff *skb);
+struct wg_peer *wg_allowedips_lookup_src(struct allowedips *table, struct sk_buff *skb);
 
 #ifdef DEBUG
 bool wg_allowedips_selftest(void);
diff --git a/drivers/net/wireguard/cookie.c b/drivers/net/wireguard/cookie.c
index 4956f0499c19..a15c25828b4f 100644
--- a/drivers/net/wireguard/cookie.c
+++ b/drivers/net/wireguard/cookie.c
@@ -16,8 +16,7 @@
 #include <net/ipv6.h>
 #include <crypto/algapi.h>
 
-void wg_cookie_checker_init(struct cookie_checker *checker,
-			    struct wg_device *wg)
+void wg_cookie_checker_init(struct cookie_checker *checker, struct wg_device *wg)
 {
 	init_rwsem(&checker->secret_lock);
 	checker->secret_birthdate = ktime_get_coarse_boottime_ns();
@@ -29,8 +28,7 @@ enum { COOKIE_KEY_LABEL_LEN = 8 };
 static const u8 mac1_key_label[COOKIE_KEY_LABEL_LEN] = "mac1----";
 static const u8 cookie_key_label[COOKIE_KEY_LABEL_LEN] = "cookie--";
 
-static void precompute_key(u8 key[NOISE_SYMMETRIC_KEY_LEN],
-			   const u8 pubkey[NOISE_PUBLIC_KEY_LEN],
+static void precompute_key(u8 key[NOISE_SYMMETRIC_KEY_LEN], const u8 pubkey[NOISE_PUBLIC_KEY_LEN],
 			   const u8 label[COOKIE_KEY_LABEL_LEN])
 {
 	struct blake2s_state blake;
@@ -46,24 +44,21 @@ void wg_cookie_checker_precompute_device_keys(struct cookie_checker *checker)
 {
 	if (likely(checker->device->static_identity.has_identity)) {
 		precompute_key(checker->cookie_encryption_key,
-			       checker->device->static_identity.static_public,
-			       cookie_key_label);
+			       checker->device->static_identity.static_public, cookie_key_label);
 		precompute_key(checker->message_mac1_key,
-			       checker->device->static_identity.static_public,
-			       mac1_key_label);
+			       checker->device->static_identity.static_public, mac1_key_label);
 	} else {
-		memset(checker->cookie_encryption_key, 0,
-		       NOISE_SYMMETRIC_KEY_LEN);
+		memset(checker->cookie_encryption_key, 0, NOISE_SYMMETRIC_KEY_LEN);
 		memset(checker->message_mac1_key, 0, NOISE_SYMMETRIC_KEY_LEN);
 	}
 }
 
 void wg_cookie_checker_precompute_peer_keys(struct wg_peer *peer)
 {
-	precompute_key(peer->latest_cookie.cookie_decryption_key,
-		       peer->handshake.remote_static, cookie_key_label);
-	precompute_key(peer->latest_cookie.message_mac1_key,
-		       peer->handshake.remote_static, mac1_key_label);
+	precompute_key(peer->latest_cookie.cookie_decryption_key, peer->handshake.remote_static,
+		       cookie_key_label);
+	precompute_key(peer->latest_cookie.message_mac1_key, peer->handshake.remote_static,
+		       mac1_key_label);
 }
 
 void wg_cookie_init(struct cookie *cookie)
@@ -75,26 +70,22 @@ void wg_cookie_init(struct cookie *cookie)
 static void compute_mac1(u8 mac1[COOKIE_LEN], const void *message, size_t len,
 			 const u8 key[NOISE_SYMMETRIC_KEY_LEN])
 {
-	len = len - sizeof(struct message_macs) +
-	      offsetof(struct message_macs, mac1);
+	len = len - sizeof(struct message_macs) + offsetof(struct message_macs, mac1);
 	blake2s(mac1, message, key, COOKIE_LEN, len, NOISE_SYMMETRIC_KEY_LEN);
 }
 
 static void compute_mac2(u8 mac2[COOKIE_LEN], const void *message, size_t len,
 			 const u8 cookie[COOKIE_LEN])
 {
-	len = len - sizeof(struct message_macs) +
-	      offsetof(struct message_macs, mac2);
+	len = len - sizeof(struct message_macs) + offsetof(struct message_macs, mac2);
 	blake2s(mac2, message, cookie, COOKIE_LEN, len, COOKIE_LEN);
 }
 
-static void make_cookie(u8 cookie[COOKIE_LEN], struct sk_buff *skb,
-			struct cookie_checker *checker)
+static void make_cookie(u8 cookie[COOKIE_LEN], struct sk_buff *skb, struct cookie_checker *checker)
 {
 	struct blake2s_state state;
 
-	if (wg_birthdate_has_expired(checker->secret_birthdate,
-				     COOKIE_SECRET_MAX_AGE)) {
+	if (wg_birthdate_has_expired(checker->secret_birthdate, COOKIE_SECRET_MAX_AGE)) {
 		down_write(&checker->secret_lock);
 		checker->secret_birthdate = ktime_get_coarse_boottime_ns();
 		get_random_bytes(checker->secret, NOISE_HASH_LEN);
@@ -105,30 +96,25 @@ static void make_cookie(u8 cookie[COOKIE_LEN], struct sk_buff *skb,
 
 	blake2s_init_key(&state, COOKIE_LEN, checker->secret, NOISE_HASH_LEN);
 	if (skb->protocol == htons(ETH_P_IP))
-		blake2s_update(&state, (u8 *)&ip_hdr(skb)->saddr,
-			       sizeof(struct in_addr));
+		blake2s_update(&state, (u8 *)&ip_hdr(skb)->saddr, sizeof(struct in_addr));
 	else if (skb->protocol == htons(ETH_P_IPV6))
-		blake2s_update(&state, (u8 *)&ipv6_hdr(skb)->saddr,
-			       sizeof(struct in6_addr));
+		blake2s_update(&state, (u8 *)&ipv6_hdr(skb)->saddr, sizeof(struct in6_addr));
 	blake2s_update(&state, (u8 *)&udp_hdr(skb)->source, sizeof(__be16));
 	blake2s_final(&state, cookie);
 
 	up_read(&checker->secret_lock);
 }
 
-enum cookie_mac_state wg_cookie_validate_packet(struct cookie_checker *checker,
-						struct sk_buff *skb,
+enum cookie_mac_state wg_cookie_validate_packet(struct cookie_checker *checker, struct sk_buff *skb,
 						bool check_cookie)
 {
-	struct message_macs *macs = (struct message_macs *)
-		(skb->data + skb->len - sizeof(*macs));
+	struct message_macs *macs = (struct message_macs *)(skb->data + skb->len - sizeof(*macs));
 	enum cookie_mac_state ret;
 	u8 computed_mac[COOKIE_LEN];
 	u8 cookie[COOKIE_LEN];
 
 	ret = INVALID_MAC;
-	compute_mac1(computed_mac, skb->data, skb->len,
-		     checker->message_mac1_key);
+	compute_mac1(computed_mac, skb->data, skb->len, checker->message_mac1_key);
 	if (crypto_memneq(computed_mac, macs->mac1, COOKIE_LEN))
 		goto out;
 
@@ -153,15 +139,12 @@ enum cookie_mac_state wg_cookie_validate_packet(struct cookie_checker *checker,
 	return ret;
 }
 
-void wg_cookie_add_mac_to_packet(void *message, size_t len,
-				 struct wg_peer *peer)
+void wg_cookie_add_mac_to_packet(void *message, size_t len, struct wg_peer *peer)
 {
-	struct message_macs *macs = (struct message_macs *)
-		((u8 *)message + len - sizeof(*macs));
+	struct message_macs *macs = (struct message_macs *)((u8 *)message + len - sizeof(*macs));
 
 	down_write(&peer->latest_cookie.lock);
-	compute_mac1(macs->mac1, message, len,
-		     peer->latest_cookie.message_mac1_key);
+	compute_mac1(macs->mac1, message, len, peer->latest_cookie.message_mac1_key);
 	memcpy(peer->latest_cookie.last_mac1_sent, macs->mac1, COOKIE_LEN);
 	peer->latest_cookie.have_sent_mac1 = true;
 	up_write(&peer->latest_cookie.lock);
@@ -169,20 +152,17 @@ void wg_cookie_add_mac_to_packet(void *message, size_t len,
 	down_read(&peer->latest_cookie.lock);
 	if (peer->latest_cookie.is_valid &&
 	    !wg_birthdate_has_expired(peer->latest_cookie.birthdate,
-				COOKIE_SECRET_MAX_AGE - COOKIE_SECRET_LATENCY))
-		compute_mac2(macs->mac2, message, len,
-			     peer->latest_cookie.cookie);
+				      COOKIE_SECRET_MAX_AGE - COOKIE_SECRET_LATENCY))
+		compute_mac2(macs->mac2, message, len, peer->latest_cookie.cookie);
 	else
 		memset(macs->mac2, 0, COOKIE_LEN);
 	up_read(&peer->latest_cookie.lock);
 }
 
-void wg_cookie_message_create(struct message_handshake_cookie *dst,
-			      struct sk_buff *skb, __le32 index,
-			      struct cookie_checker *checker)
+void wg_cookie_message_create(struct message_handshake_cookie *dst, struct sk_buff *skb,
+			      __le32 index, struct cookie_checker *checker)
 {
-	struct message_macs *macs = (struct message_macs *)
-		((u8 *)skb->data + skb->len - sizeof(*macs));
+	struct message_macs *macs = (struct message_macs *)((u8 *)skb->data + skb->len - sizeof(*macs));
 	u8 cookie[COOKIE_LEN];
 
 	dst->header.type = cpu_to_le32(MESSAGE_HANDSHAKE_COOKIE);
@@ -190,21 +170,18 @@ void wg_cookie_message_create(struct message_handshake_cookie *dst,
 	get_random_bytes_wait(dst->nonce, COOKIE_NONCE_LEN);
 
 	make_cookie(cookie, skb, checker);
-	xchacha20poly1305_encrypt(dst->encrypted_cookie, cookie, COOKIE_LEN,
-				  macs->mac1, COOKIE_LEN, dst->nonce,
-				  checker->cookie_encryption_key);
+	xchacha20poly1305_encrypt(dst->encrypted_cookie, cookie, COOKIE_LEN, macs->mac1, COOKIE_LEN,
+				  dst->nonce, checker->cookie_encryption_key);
 }
 
-void wg_cookie_message_consume(struct message_handshake_cookie *src,
-			       struct wg_device *wg)
+void wg_cookie_message_consume(struct message_handshake_cookie *src, struct wg_device *wg)
 {
 	struct wg_peer *peer = NULL;
 	u8 cookie[COOKIE_LEN];
 	bool ret;
 
 	if (unlikely(!wg_index_hashtable_lookup(wg->index_hashtable,
-						INDEX_HASHTABLE_HANDSHAKE |
-						INDEX_HASHTABLE_KEYPAIR,
+						INDEX_HASHTABLE_HANDSHAKE | INDEX_HASHTABLE_KEYPAIR,
 						src->receiver_index, &peer)))
 		return;
 
@@ -213,10 +190,9 @@ void wg_cookie_message_consume(struct message_handshake_cookie *src,
 		up_read(&peer->latest_cookie.lock);
 		goto out;
 	}
-	ret = xchacha20poly1305_decrypt(
-		cookie, src->encrypted_cookie, sizeof(src->encrypted_cookie),
-		peer->latest_cookie.last_mac1_sent, COOKIE_LEN, src->nonce,
-		peer->latest_cookie.cookie_decryption_key);
+	ret = xchacha20poly1305_decrypt(cookie, src->encrypted_cookie, sizeof(src->encrypted_cookie),
+					peer->latest_cookie.last_mac1_sent, COOKIE_LEN, src->nonce,
+					peer->latest_cookie.cookie_decryption_key);
 	up_read(&peer->latest_cookie.lock);
 
 	if (ret) {
diff --git a/drivers/net/wireguard/cookie.h b/drivers/net/wireguard/cookie.h
index c4bd61ca03f2..722ca8c50dc8 100644
--- a/drivers/net/wireguard/cookie.h
+++ b/drivers/net/wireguard/cookie.h
@@ -38,22 +38,17 @@ enum cookie_mac_state {
 	VALID_MAC_WITH_COOKIE
 };
 
-void wg_cookie_checker_init(struct cookie_checker *checker,
-			    struct wg_device *wg);
+void wg_cookie_checker_init(struct cookie_checker *checker, struct wg_device *wg);
 void wg_cookie_checker_precompute_device_keys(struct cookie_checker *checker);
 void wg_cookie_checker_precompute_peer_keys(struct wg_peer *peer);
 void wg_cookie_init(struct cookie *cookie);
 
-enum cookie_mac_state wg_cookie_validate_packet(struct cookie_checker *checker,
-						struct sk_buff *skb,
+enum cookie_mac_state wg_cookie_validate_packet(struct cookie_checker *checker, struct sk_buff *skb,
 						bool check_cookie);
-void wg_cookie_add_mac_to_packet(void *message, size_t len,
-				 struct wg_peer *peer);
+void wg_cookie_add_mac_to_packet(void *message, size_t len, struct wg_peer *peer);
 
-void wg_cookie_message_create(struct message_handshake_cookie *src,
-			      struct sk_buff *skb, __le32 index,
+void wg_cookie_message_create(struct message_handshake_cookie *src, struct sk_buff *skb, __le32 index,
 			      struct cookie_checker *checker);
-void wg_cookie_message_consume(struct message_handshake_cookie *src,
-			       struct wg_device *wg);
+void wg_cookie_message_consume(struct message_handshake_cookie *src, struct wg_device *wg);
 
 #endif /* _WG_COOKIE_H */
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 3ac3f8570ca1..6ba4ad392699 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -35,9 +35,8 @@ static int wg_open(struct net_device *dev)
 	int ret;
 
 	if (dev_v4) {
-		/* At some point we might put this check near the ip_rt_send_
-		 * redirect call of ip_forward in net/ipv4/ip_forward.c, similar
-		 * to the current secpath check.
+		/* At some point we might put this check near the ip_rt_send_ redirect call of
+		 * ip_forward in net/ipv4/ip_forward.c, similar to the current secpath check.
 		 */
 		IN_DEV_CONF_SET(dev_v4, SEND_REDIRECTS, false);
 		IPV4_DEVCONF_ALL(dev_net(dev), SEND_REDIRECTS) = false;
@@ -59,15 +58,13 @@ static int wg_open(struct net_device *dev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int wg_pm_notification(struct notifier_block *nb, unsigned long action,
-			      void *data)
+static int wg_pm_notification(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct wg_device *wg;
 	struct wg_peer *peer;
 
-	/* If the machine is constantly suspending and resuming, as part of
-	 * its normal operation rather than as a somewhat rare event, then we
-	 * don't actually want to clear keys.
+	/* If the machine is constantly suspending and resuming, as part of its normal operation
+	 * rather than as a somewhat rare event, then we don't actually want to clear keys.
 	 */
 	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID))
 		return 0;
@@ -171,8 +168,8 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (unlikely(!skb))
 			continue;
 
-		/* We only need to keep the original dst around for icmp,
-		 * so at this point we're in a position to drop it.
+		/* We only need to keep the original dst around for icmp, so at this point we're in
+		 * a position to drop it.
 		 */
 		skb_dst_drop(skb);
 
@@ -182,9 +179,9 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	spin_lock_bh(&peer->staged_packet_queue.lock);
-	/* If the queue is getting too big, we start removing the oldest packets
-	 * until it's small again. We do this before adding the new packet, so
-	 * we don't remove GSO segments that are in excess.
+	/* If the queue is getting too big, we start removing the oldest packets until it's small
+	 * again. We do this before adding the new packet, so we don't remove GSO segments that are
+	 * in excess.
 	 */
 	while (skb_queue_len(&peer->staged_packet_queue) > MAX_STAGED_PACKETS) {
 		dev_kfree_skb(__skb_dequeue(&peer->staged_packet_queue));
@@ -255,8 +252,7 @@ static const struct device_type device_type = { .name = KBUILD_MODNAME };
 static void wg_setup(struct net_device *dev)
 {
 	struct wg_device *wg = netdev_priv(dev);
-	enum { WG_NETDEV_FEATURES = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-				    NETIF_F_SG | NETIF_F_GSO |
+	enum { WG_NETDEV_FEATURES = NETIF_F_HW_CSUM | NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 				    NETIF_F_GSO_SOFTWARE | NETIF_F_HIGHDMA };
 	const int overhead = MESSAGE_MINIMUM_LENGTH + sizeof(struct udphdr) +
 			     max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
@@ -285,9 +281,8 @@ static void wg_setup(struct net_device *dev)
 	wg->dev = dev;
 }
 
-static int wg_newlink(struct net *src_net, struct net_device *dev,
-		      struct nlattr *tb[], struct nlattr *data[],
-		      struct netlink_ext_ack *extack)
+static int wg_newlink(struct net *src_net, struct net_device *dev, struct nlattr *tb[],
+		      struct nlattr *data[], struct netlink_ext_ack *extack)
 {
 	struct wg_device *wg = netdev_priv(dev);
 	int ret = -ENOMEM;
@@ -314,34 +309,32 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 	if (!dev->tstats)
 		goto err_free_index_hashtable;
 
-	wg->incoming_handshakes_worker =
-		wg_packet_percpu_multicore_worker_alloc(
-				wg_packet_handshake_receive_worker, wg);
+	wg->incoming_handshakes_worker = wg_packet_percpu_multicore_worker_alloc(
+							wg_packet_handshake_receive_worker, wg);
 	if (!wg->incoming_handshakes_worker)
 		goto err_free_tstats;
 
-	wg->handshake_receive_wq = alloc_workqueue("wg-kex-%s",
-			WQ_CPU_INTENSIVE | WQ_FREEZABLE, 0, dev->name);
+	wg->handshake_receive_wq = alloc_workqueue("wg-kex-%s",	WQ_CPU_INTENSIVE | WQ_FREEZABLE, 0,
+						   dev->name);
 	if (!wg->handshake_receive_wq)
 		goto err_free_incoming_handshakes;
 
-	wg->handshake_send_wq = alloc_workqueue("wg-kex-%s",
-			WQ_UNBOUND | WQ_FREEZABLE, 0, dev->name);
+	wg->handshake_send_wq = alloc_workqueue("wg-kex-%s", WQ_UNBOUND | WQ_FREEZABLE, 0, dev->name);
 	if (!wg->handshake_send_wq)
 		goto err_destroy_handshake_receive;
 
-	wg->packet_crypt_wq = alloc_workqueue("wg-crypt-%s",
-			WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 0, dev->name);
+	wg->packet_crypt_wq = alloc_workqueue("wg-crypt-%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 0,
+					      dev->name);
 	if (!wg->packet_crypt_wq)
 		goto err_destroy_handshake_send;
 
-	ret = wg_packet_queue_init(&wg->encrypt_queue, wg_packet_encrypt_worker,
-				   true, MAX_QUEUED_PACKETS);
+	ret = wg_packet_queue_init(&wg->encrypt_queue, wg_packet_encrypt_worker, true,
+				   MAX_QUEUED_PACKETS);
 	if (ret < 0)
 		goto err_destroy_packet_crypt;
 
-	ret = wg_packet_queue_init(&wg->decrypt_queue, wg_packet_decrypt_worker,
-				   true, MAX_QUEUED_PACKETS);
+	ret = wg_packet_queue_init(&wg->decrypt_queue, wg_packet_decrypt_worker, true,
+				   MAX_QUEUED_PACKETS);
 	if (ret < 0)
 		goto err_free_encrypt_queue;
 
@@ -355,8 +348,8 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 
 	list_add(&wg->device_list, &device_list);
 
-	/* We wait until the end to assign priv_destructor, so that
-	 * register_netdevice doesn't call it for us if it fails.
+	/* We wait until the end to assign priv_destructor, so that register_netdevice doesn't call
+	 * it for us if it fails.
 	 */
 	dev->priv_destructor = wg_destruct;
 
@@ -393,8 +386,7 @@ static struct rtnl_link_ops link_ops __read_mostly = {
 	.newlink		= wg_newlink,
 };
 
-static int wg_netdevice_notification(struct notifier_block *nb,
-				     unsigned long action, void *data)
+static int wg_netdevice_notification(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct net_device *dev = ((struct netdev_notifier_info *)data)->dev;
 	struct wg_device *wg = netdev_priv(dev);
@@ -407,17 +399,14 @@ static int wg_netdevice_notification(struct notifier_block *nb,
 	if (dev_net(dev) == wg->creating_net && wg->have_creating_net_ref) {
 		put_net(wg->creating_net);
 		wg->have_creating_net_ref = false;
-	} else if (dev_net(dev) != wg->creating_net &&
-		   !wg->have_creating_net_ref) {
+	} else if (dev_net(dev) != wg->creating_net && !wg->have_creating_net_ref) {
 		wg->have_creating_net_ref = true;
 		get_net(wg->creating_net);
 	}
 	return 0;
 }
 
-static struct notifier_block netdevice_notifier = {
-	.notifier_call = wg_netdevice_notification
-};
+static struct notifier_block netdevice_notifier = { .notifier_call = wg_netdevice_notification };
 
 int __init wg_device_init(void)
 {
diff --git a/drivers/net/wireguard/messages.h b/drivers/net/wireguard/messages.h
index 208da72673fc..660635cae81d 100644
--- a/drivers/net/wireguard/messages.h
+++ b/drivers/net/wireguard/messages.h
@@ -66,8 +66,8 @@ struct message_header {
 	 * u8 type
 	 * u8 reserved_zero[3]
 	 *
-	 * But it turns out that by encoding this as little endian,
-	 * we achieve the same thing, and it makes checking faster.
+	 * But it turns out that by encoding this as little endian, we achieve the same thing, and
+	 * it makes checking faster.
 	 */
 	__le32 type;
 };
@@ -109,8 +109,7 @@ struct message_data {
 	u8 encrypted_data[];
 };
 
-#define message_data_len(plain_len) \
-	(noise_encrypted_len(plain_len) + sizeof(struct message_data))
+#define message_data_len(plain_len) (noise_encrypted_len(plain_len) + sizeof(struct message_data))
 
 enum message_alignments {
 	MESSAGE_PADDING_MULTIPLE = 16,
@@ -120,8 +119,7 @@ enum message_alignments {
 #define SKB_HEADER_LEN                                       \
 	(max(sizeof(struct iphdr), sizeof(struct ipv6hdr)) + \
 	 sizeof(struct udphdr) + NET_SKB_PAD)
-#define DATA_PACKET_HEAD_ROOM \
-	ALIGN(sizeof(struct message_data) + SKB_HEADER_LEN, 4)
+#define DATA_PACKET_HEAD_ROOM ALIGN(sizeof(struct message_data) + SKB_HEADER_LEN, 4)
 
 enum { HANDSHAKE_DSCP = 0x88 /* AF41, plus 00 ECN */ };
 
diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index 802099c8828a..0a1e62016f7e 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -57,11 +57,9 @@ static struct wg_device *lookup_interface(struct nlattr **attrs,
 	if (!attrs[WGDEVICE_A_IFINDEX] == !attrs[WGDEVICE_A_IFNAME])
 		return ERR_PTR(-EBADR);
 	if (attrs[WGDEVICE_A_IFINDEX])
-		dev = dev_get_by_index(sock_net(skb->sk),
-				       nla_get_u32(attrs[WGDEVICE_A_IFINDEX]));
+		dev = dev_get_by_index(sock_net(skb->sk), nla_get_u32(attrs[WGDEVICE_A_IFINDEX]));
 	else if (attrs[WGDEVICE_A_IFNAME])
-		dev = dev_get_by_name(sock_net(skb->sk),
-				      nla_data(attrs[WGDEVICE_A_IFNAME]));
+		dev = dev_get_by_name(sock_net(skb->sk), nla_data(attrs[WGDEVICE_A_IFNAME]));
 	if (!dev)
 		return ERR_PTR(-ENODEV);
 	if (!dev->rtnl_link_ops || !dev->rtnl_link_ops->kind ||
@@ -114,8 +112,7 @@ get_peer(struct wg_peer *peer, struct sk_buff *skb, struct dump_ctx *ctx)
 		return -EMSGSIZE;
 
 	down_read(&peer->handshake.lock);
-	fail = nla_put(skb, WGPEER_A_PUBLIC_KEY, NOISE_PUBLIC_KEY_LEN,
-		       peer->handshake.remote_static);
+	fail = nla_put(skb, WGPEER_A_PUBLIC_KEY, NOISE_PUBLIC_KEY_LEN, peer->handshake.remote_static);
 	up_read(&peer->handshake.lock);
 	if (fail)
 		goto err;
@@ -127,39 +124,33 @@ get_peer(struct wg_peer *peer, struct sk_buff *skb, struct dump_ctx *ctx)
 		};
 
 		down_read(&peer->handshake.lock);
-		fail = nla_put(skb, WGPEER_A_PRESHARED_KEY,
-			       NOISE_SYMMETRIC_KEY_LEN,
+		fail = nla_put(skb, WGPEER_A_PRESHARED_KEY, NOISE_SYMMETRIC_KEY_LEN,
 			       peer->handshake.preshared_key);
 		up_read(&peer->handshake.lock);
 		if (fail)
 			goto err;
 
-		if (nla_put(skb, WGPEER_A_LAST_HANDSHAKE_TIME,
-			    sizeof(last_handshake), &last_handshake) ||
+		if (nla_put(skb, WGPEER_A_LAST_HANDSHAKE_TIME, sizeof(last_handshake),
+			    &last_handshake) ||
 		    nla_put_u16(skb, WGPEER_A_PERSISTENT_KEEPALIVE_INTERVAL,
 				peer->persistent_keepalive_interval) ||
-		    nla_put_u64_64bit(skb, WGPEER_A_TX_BYTES, peer->tx_bytes,
-				      WGPEER_A_UNSPEC) ||
-		    nla_put_u64_64bit(skb, WGPEER_A_RX_BYTES, peer->rx_bytes,
-				      WGPEER_A_UNSPEC) ||
+		    nla_put_u64_64bit(skb, WGPEER_A_TX_BYTES, peer->tx_bytes, WGPEER_A_UNSPEC) ||
+		    nla_put_u64_64bit(skb, WGPEER_A_RX_BYTES, peer->rx_bytes, WGPEER_A_UNSPEC) ||
 		    nla_put_u32(skb, WGPEER_A_PROTOCOL_VERSION, 1))
 			goto err;
 
 		read_lock_bh(&peer->endpoint_lock);
 		if (peer->endpoint.addr.sa_family == AF_INET)
-			fail = nla_put(skb, WGPEER_A_ENDPOINT,
-				       sizeof(peer->endpoint.addr4),
+			fail = nla_put(skb, WGPEER_A_ENDPOINT, sizeof(peer->endpoint.addr4),
 				       &peer->endpoint.addr4);
 		else if (peer->endpoint.addr.sa_family == AF_INET6)
-			fail = nla_put(skb, WGPEER_A_ENDPOINT,
-				       sizeof(peer->endpoint.addr6),
+			fail = nla_put(skb, WGPEER_A_ENDPOINT, sizeof(peer->endpoint.addr6),
 				       &peer->endpoint.addr6);
 		read_unlock_bh(&peer->endpoint_lock);
 		if (fail)
 			goto err;
-		allowedips_node =
-			list_first_entry_or_null(&peer->allowedips_list,
-					struct allowedips_node, peer_list);
+		allowedips_node = list_first_entry_or_null(&peer->allowedips_list,
+							   struct allowedips_node, peer_list);
 	}
 	if (!allowedips_node)
 		goto no_allowedips;
@@ -172,8 +163,7 @@ get_peer(struct wg_peer *peer, struct sk_buff *skb, struct dump_ctx *ctx)
 	if (!allowedips_nest)
 		goto err;
 
-	list_for_each_entry_from(allowedips_node, &peer->allowedips_list,
-				 peer_list) {
+	list_for_each_entry_from(allowedips_node, &peer->allowedips_list, peer_list) {
 		u8 cidr, ip[16] __aligned(__alignof(u64));
 		int family;
 
@@ -222,15 +212,14 @@ static int wg_get_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	cb->seq = wg->device_update_gen;
 	next_peer_cursor = ctx->next_peer;
 
-	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
-			  &genl_family, NLM_F_MULTI, WG_CMD_GET_DEVICE);
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq, &genl_family,
+			  NLM_F_MULTI, WG_CMD_GET_DEVICE);
 	if (!hdr)
 		goto out;
 	genl_dump_check_consistent(cb, hdr);
 
 	if (!ctx->next_peer) {
-		if (nla_put_u16(skb, WGDEVICE_A_LISTEN_PORT,
-				wg->incoming_port) ||
+		if (nla_put_u16(skb, WGDEVICE_A_LISTEN_PORT, wg->incoming_port) ||
 		    nla_put_u32(skb, WGDEVICE_A_FWMARK, wg->fwmark) ||
 		    nla_put_u32(skb, WGDEVICE_A_IFINDEX, wg->dev->ifindex) ||
 		    nla_put_string(skb, WGDEVICE_A_IFNAME, wg->dev->name))
@@ -238,11 +227,9 @@ static int wg_get_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 		down_read(&wg->static_identity.lock);
 		if (wg->static_identity.has_identity) {
-			if (nla_put(skb, WGDEVICE_A_PRIVATE_KEY,
-				    NOISE_PUBLIC_KEY_LEN,
+			if (nla_put(skb, WGDEVICE_A_PRIVATE_KEY, NOISE_PUBLIC_KEY_LEN,
 				    wg->static_identity.static_private) ||
-			    nla_put(skb, WGDEVICE_A_PUBLIC_KEY,
-				    NOISE_PUBLIC_KEY_LEN,
+			    nla_put(skb, WGDEVICE_A_PUBLIC_KEY, NOISE_PUBLIC_KEY_LEN,
 				    wg->static_identity.static_public)) {
 				up_read(&wg->static_identity.lock);
 				goto out;
@@ -255,13 +242,11 @@ static int wg_get_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	if (!peers_nest)
 		goto out;
 	ret = 0;
-	/* If the last cursor was removed via list_del_init in peer_remove, then
-	 * we just treat this the same as there being no more peers left. The
-	 * reason is that seq_nr should indicate to userspace that this isn't a
-	 * coherent dump anyway, so they'll try again.
+	/* If the last cursor was removed via list_del_init in peer_remove, then we just treat this
+	 * the same as there being no more peers left. The reason is that seq_nr should indicate to
+	 * userspace that this isn't a coherent dump anyway, so they'll try again.
 	 */
-	if (list_empty(&wg->peer_list) ||
-	    (ctx->next_peer && list_empty(&ctx->next_peer->peer_list))) {
+	if (list_empty(&wg->peer_list) || (ctx->next_peer && list_empty(&ctx->next_peer->peer_list))) {
 		nla_nest_cancel(skb, peers_nest);
 		goto out;
 	}
@@ -295,9 +280,9 @@ static int wg_get_device_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	ctx->next_peer = next_peer_cursor;
 	return skb->len;
 
-	/* At this point, we can't really deal ourselves with safely zeroing out
-	 * the private key material after usage. This will need an additional API
-	 * in the kernel for marking skbs as zero_on_free.
+	/* At this point, we can't really deal ourselves with safely zeroing out the private key
+	 * material after usage. This will need an additional API in the kernel for marking skbs as
+	 * zero_on_free.
 	 */
 }
 
@@ -340,14 +325,12 @@ static int set_allowedip(struct wg_peer *peer, struct nlattr **attrs)
 
 	if (family == AF_INET && cidr <= 32 &&
 	    nla_len(attrs[WGALLOWEDIP_A_IPADDR]) == sizeof(struct in_addr))
-		ret = wg_allowedips_insert_v4(
-			&peer->device->peer_allowedips,
+		ret = wg_allowedips_insert_v4(&peer->device->peer_allowedips,
 			nla_data(attrs[WGALLOWEDIP_A_IPADDR]), cidr, peer,
 			&peer->device->device_update_lock);
 	else if (family == AF_INET6 && cidr <= 128 &&
 		 nla_len(attrs[WGALLOWEDIP_A_IPADDR]) == sizeof(struct in6_addr))
-		ret = wg_allowedips_insert_v6(
-			&peer->device->peer_allowedips,
+		ret = wg_allowedips_insert_v6(&peer->device->peer_allowedips,
 			nla_data(attrs[WGALLOWEDIP_A_IPADDR]), cidr, peer,
 			&peer->device->device_update_lock);
 
@@ -383,8 +366,7 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 			goto out;
 	}
 
-	peer = wg_pubkey_hashtable_lookup(wg->peer_hashtable,
-					  nla_data(attrs[WGPEER_A_PUBLIC_KEY]));
+	peer = wg_pubkey_hashtable_lookup(wg->peer_hashtable, nla_data(attrs[WGPEER_A_PUBLIC_KEY]));
 	ret = 0;
 	if (!peer) { /* Peer doesn't exist yet. Add a new one. */
 		if (flags & (WGPEER_F_REMOVE_ME | WGPEER_F_UPDATE_ONLY))
@@ -395,13 +377,11 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 
 		down_read(&wg->static_identity.lock);
 		if (wg->static_identity.has_identity &&
-		    !memcmp(nla_data(attrs[WGPEER_A_PUBLIC_KEY]),
-			    wg->static_identity.static_public,
+		    !memcmp(nla_data(attrs[WGPEER_A_PUBLIC_KEY]), wg->static_identity.static_public,
 			    NOISE_PUBLIC_KEY_LEN)) {
-			/* We silently ignore peers that have the same public
-			 * key as the device. The reason we do it silently is
-			 * that we'd like for people to be able to reuse the
-			 * same set of API calls across peers.
+			/* We silently ignore peers that have the same public key as the device. The
+			 * reason we do it silently is that we'd like for people to be able to reuse
+			 * the same set of API calls across peers.
 			 */
 			up_read(&wg->static_identity.lock);
 			ret = 0;
@@ -415,9 +395,7 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 			peer = NULL;
 			goto out;
 		}
-		/* Take additional reference, as though we've just been
-		 * looked up.
-		 */
+		/* Take additional reference, as though we've just been looked up. */
 		wg_peer_get(peer);
 	}
 
@@ -428,8 +406,7 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 
 	if (preshared_key) {
 		down_write(&peer->handshake.lock);
-		memcpy(&peer->handshake.preshared_key, preshared_key,
-		       NOISE_SYMMETRIC_KEY_LEN);
+		memcpy(&peer->handshake.preshared_key, preshared_key, NOISE_SYMMETRIC_KEY_LEN);
 		up_write(&peer->handshake.lock);
 	}
 
@@ -437,10 +414,8 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 		struct sockaddr *addr = nla_data(attrs[WGPEER_A_ENDPOINT]);
 		size_t len = nla_len(attrs[WGPEER_A_ENDPOINT]);
 
-		if ((len == sizeof(struct sockaddr_in) &&
-		     addr->sa_family == AF_INET) ||
-		    (len == sizeof(struct sockaddr_in6) &&
-		     addr->sa_family == AF_INET6)) {
+		if ((len == sizeof(struct sockaddr_in) && addr->sa_family == AF_INET) ||
+		    (len == sizeof(struct sockaddr_in6) && addr->sa_family == AF_INET6)) {
 			struct endpoint endpoint = { { { 0 } } };
 
 			memcpy(&endpoint.addr, addr, len);
@@ -449,16 +424,15 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 	}
 
 	if (flags & WGPEER_F_REPLACE_ALLOWEDIPS)
-		wg_allowedips_remove_by_peer(&wg->peer_allowedips, peer,
-					     &wg->device_update_lock);
+		wg_allowedips_remove_by_peer(&wg->peer_allowedips, peer, &wg->device_update_lock);
 
 	if (attrs[WGPEER_A_ALLOWEDIPS]) {
 		struct nlattr *attr, *allowedip[WGALLOWEDIP_A_MAX + 1];
 		int rem;
 
 		nla_for_each_nested(attr, attrs[WGPEER_A_ALLOWEDIPS], rem) {
-			ret = nla_parse_nested(allowedip, WGALLOWEDIP_A_MAX,
-					       attr, allowedip_policy, NULL);
+			ret = nla_parse_nested(allowedip, WGALLOWEDIP_A_MAX, attr, allowedip_policy,
+					       NULL);
 			if (ret < 0)
 				goto out;
 			ret = set_allowedip(peer, allowedip);
@@ -468,12 +442,10 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 	}
 
 	if (attrs[WGPEER_A_PERSISTENT_KEEPALIVE_INTERVAL]) {
-		const u16 persistent_keepalive_interval = nla_get_u16(
-				attrs[WGPEER_A_PERSISTENT_KEEPALIVE_INTERVAL]);
-		const bool send_keepalive =
-			!peer->persistent_keepalive_interval &&
-			persistent_keepalive_interval &&
-			netif_running(wg->dev);
+		u16 persistent_keepalive_interval = nla_get_u16(
+						attrs[WGPEER_A_PERSISTENT_KEEPALIVE_INTERVAL]);
+		bool send_keepalive = !peer->persistent_keepalive_interval &&
+				      persistent_keepalive_interval && netif_running(wg->dev);
 
 		peer->persistent_keepalive_interval = persistent_keepalive_interval;
 		if (send_keepalive)
@@ -512,8 +484,7 @@ static int wg_set_device(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 
 	ret = -EPERM;
-	if ((info->attrs[WGDEVICE_A_LISTEN_PORT] ||
-	     info->attrs[WGDEVICE_A_FWMARK]) &&
+	if ((info->attrs[WGDEVICE_A_LISTEN_PORT] || info->attrs[WGDEVICE_A_FWMARK]) &&
 	    !ns_capable(wg->creating_net->user_ns, CAP_NET_ADMIN))
 		goto out;
 
@@ -528,8 +499,7 @@ static int wg_set_device(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[WGDEVICE_A_LISTEN_PORT]) {
-		ret = set_port(wg,
-			nla_get_u16(info->attrs[WGDEVICE_A_LISTEN_PORT]));
+		ret = set_port(wg, nla_get_u16(info->attrs[WGDEVICE_A_LISTEN_PORT]));
 		if (ret)
 			goto out;
 	}
@@ -538,22 +508,18 @@ static int wg_set_device(struct sk_buff *skb, struct genl_info *info)
 		wg_peer_remove_all(wg);
 
 	if (info->attrs[WGDEVICE_A_PRIVATE_KEY] &&
-	    nla_len(info->attrs[WGDEVICE_A_PRIVATE_KEY]) ==
-		    NOISE_PUBLIC_KEY_LEN) {
+	    nla_len(info->attrs[WGDEVICE_A_PRIVATE_KEY]) == NOISE_PUBLIC_KEY_LEN) {
 		u8 *private_key = nla_data(info->attrs[WGDEVICE_A_PRIVATE_KEY]);
 		u8 public_key[NOISE_PUBLIC_KEY_LEN];
 		struct wg_peer *peer, *temp;
 
-		if (!crypto_memneq(wg->static_identity.static_private,
-				   private_key, NOISE_PUBLIC_KEY_LEN))
+		if (!crypto_memneq(wg->static_identity.static_private, private_key,
+				   NOISE_PUBLIC_KEY_LEN))
 			goto skip_set_private_key;
 
-		/* We remove before setting, to prevent race, which means doing
-		 * two 25519-genpub ops.
-		 */
+		/* We remove before setting, to prevent race, which means doing two 25519-genpub ops. */
 		if (curve25519_generate_public(public_key, private_key)) {
-			peer = wg_pubkey_hashtable_lookup(wg->peer_hashtable,
-							  public_key);
+			peer = wg_pubkey_hashtable_lookup(wg->peer_hashtable, public_key);
 			if (peer) {
 				wg_peer_put(peer);
 				wg_peer_remove(peer);
@@ -561,10 +527,8 @@ static int wg_set_device(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		down_write(&wg->static_identity.lock);
-		wg_noise_set_static_identity_private_key(&wg->static_identity,
-							 private_key);
-		list_for_each_entry_safe(peer, temp, &wg->peer_list,
-					 peer_list) {
+		wg_noise_set_static_identity_private_key(&wg->static_identity, private_key);
+		list_for_each_entry_safe(peer, temp, &wg->peer_list, peer_list) {
 			wg_noise_precompute_static_static(peer);
 			wg_noise_expire_current_peer_keypairs(peer);
 		}
@@ -578,8 +542,7 @@ static int wg_set_device(struct sk_buff *skb, struct genl_info *info)
 		int rem;
 
 		nla_for_each_nested(attr, info->attrs[WGDEVICE_A_PEERS], rem) {
-			ret = nla_parse_nested(peer, WGPEER_A_MAX, attr,
-					       peer_policy, NULL);
+			ret = nla_parse_nested(peer, WGPEER_A_MAX, attr, peer_policy, NULL);
 			if (ret < 0)
 				goto out;
 			ret = set_peer(wg, peer);
diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index 626433690abb..4c98689bb486 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -35,8 +35,8 @@ void __init wg_noise_init(void)
 {
 	struct blake2s_state blake;
 
-	blake2s(handshake_init_chaining_key, handshake_name, NULL,
-		NOISE_HASH_LEN, sizeof(handshake_name), 0);
+	blake2s(handshake_init_chaining_key, handshake_name, NULL, NOISE_HASH_LEN,
+		sizeof(handshake_name), 0);
 	blake2s_init(&blake, NOISE_HASH_LEN);
 	blake2s_update(&blake, handshake_init_chaining_key, NOISE_HASH_LEN);
 	blake2s_update(&blake, identifier_name, sizeof(identifier_name));
@@ -51,8 +51,7 @@ void wg_noise_precompute_static_static(struct wg_peer *peer)
 	    !curve25519(peer->handshake.precomputed_static_static,
 			peer->handshake.static_identity->static_private,
 			peer->handshake.remote_static))
-		memset(peer->handshake.precomputed_static_static, 0,
-		       NOISE_PUBLIC_KEY_LEN);
+		memset(peer->handshake.precomputed_static_static, 0, NOISE_PUBLIC_KEY_LEN);
 	up_write(&peer->handshake.lock);
 }
 
@@ -68,8 +67,7 @@ void wg_noise_handshake_init(struct noise_handshake *handshake,
 	handshake->entry.peer = peer;
 	memcpy(handshake->remote_static, peer_public_key, NOISE_PUBLIC_KEY_LEN);
 	if (peer_preshared_key)
-		memcpy(handshake->preshared_key, peer_preshared_key,
-		       NOISE_SYMMETRIC_KEY_LEN);
+		memcpy(handshake->preshared_key, peer_preshared_key, NOISE_SYMMETRIC_KEY_LEN);
 	handshake->static_identity = static_identity;
 	handshake->state = HANDSHAKE_ZEROED;
 	wg_noise_precompute_static_static(peer);
@@ -87,15 +85,13 @@ static void handshake_zero(struct noise_handshake *handshake)
 
 void wg_noise_handshake_clear(struct noise_handshake *handshake)
 {
-	wg_index_hashtable_remove(
-			handshake->entry.peer->device->index_hashtable,
-			&handshake->entry);
+	wg_index_hashtable_remove(handshake->entry.peer->device->index_hashtable,
+				  &handshake->entry);
 	down_write(&handshake->lock);
 	handshake_zero(handshake);
 	up_write(&handshake->lock);
-	wg_index_hashtable_remove(
-			handshake->entry.peer->device->index_hashtable,
-			&handshake->entry);
+	wg_index_hashtable_remove(handshake->entry.peer->device->index_hashtable,
+				  &handshake->entry);
 }
 
 static struct noise_keypair *keypair_create(struct wg_peer *peer)
@@ -124,10 +120,8 @@ static void keypair_free_kref(struct kref *kref)
 
 	net_dbg_ratelimited("%s: Keypair %llu destroyed for peer %llu\n",
 			    keypair->entry.peer->device->dev->name,
-			    keypair->internal_id,
-			    keypair->entry.peer->internal_id);
-	wg_index_hashtable_remove(keypair->entry.peer->device->index_hashtable,
-				  &keypair->entry);
+			    keypair->internal_id, keypair->entry.peer->internal_id);
+	wg_index_hashtable_remove(keypair->entry.peer->device->index_hashtable, &keypair->entry);
 	call_rcu(&keypair->rcu, keypair_free_rcu);
 }
 
@@ -136,9 +130,8 @@ void wg_noise_keypair_put(struct noise_keypair *keypair, bool unreference_now)
 	if (unlikely(!keypair))
 		return;
 	if (unlikely(unreference_now))
-		wg_index_hashtable_remove(
-			keypair->entry.peer->device->index_hashtable,
-			&keypair->entry);
+		wg_index_hashtable_remove(keypair->entry.peer->device->index_hashtable,
+					  &keypair->entry);
 	kref_put(&keypair->refcount, keypair_free_kref);
 }
 
@@ -157,22 +150,21 @@ void wg_noise_keypairs_clear(struct noise_keypairs *keypairs)
 
 	spin_lock_bh(&keypairs->keypair_update_lock);
 
-	/* We zero the next_keypair before zeroing the others, so that
-	 * wg_noise_received_with_keypair returns early before subsequent ones
-	 * are zeroed.
+	/* We zero the next_keypair before zeroing the others, so that wg_noise_received_with_keypair
+	 * returns early before subsequent ones are zeroed.
 	 */
 	old = rcu_dereference_protected(keypairs->next_keypair,
-		lockdep_is_held(&keypairs->keypair_update_lock));
+					lockdep_is_held(&keypairs->keypair_update_lock));
 	RCU_INIT_POINTER(keypairs->next_keypair, NULL);
 	wg_noise_keypair_put(old, true);
 
 	old = rcu_dereference_protected(keypairs->previous_keypair,
-		lockdep_is_held(&keypairs->keypair_update_lock));
+					lockdep_is_held(&keypairs->keypair_update_lock));
 	RCU_INIT_POINTER(keypairs->previous_keypair, NULL);
 	wg_noise_keypair_put(old, true);
 
 	old = rcu_dereference_protected(keypairs->current_keypair,
-		lockdep_is_held(&keypairs->keypair_update_lock));
+					lockdep_is_held(&keypairs->keypair_update_lock));
 	RCU_INIT_POINTER(keypairs->current_keypair, NULL);
 	wg_noise_keypair_put(old, true);
 
@@ -188,62 +180,55 @@ void wg_noise_expire_current_peer_keypairs(struct wg_peer *peer)
 
 	spin_lock_bh(&peer->keypairs.keypair_update_lock);
 	keypair = rcu_dereference_protected(peer->keypairs.next_keypair,
-			lockdep_is_held(&peer->keypairs.keypair_update_lock));
+					    lockdep_is_held(&peer->keypairs.keypair_update_lock));
 	if (keypair)
 		keypair->sending.is_valid = false;
 	keypair = rcu_dereference_protected(peer->keypairs.current_keypair,
-			lockdep_is_held(&peer->keypairs.keypair_update_lock));
+					    lockdep_is_held(&peer->keypairs.keypair_update_lock));
 	if (keypair)
 		keypair->sending.is_valid = false;
 	spin_unlock_bh(&peer->keypairs.keypair_update_lock);
 }
 
-static void add_new_keypair(struct noise_keypairs *keypairs,
-			    struct noise_keypair *new_keypair)
+static void add_new_keypair(struct noise_keypairs *keypairs, struct noise_keypair *new_keypair)
 {
 	struct noise_keypair *previous_keypair, *next_keypair, *current_keypair;
 
 	spin_lock_bh(&keypairs->keypair_update_lock);
 	previous_keypair = rcu_dereference_protected(keypairs->previous_keypair,
-		lockdep_is_held(&keypairs->keypair_update_lock));
+						     lockdep_is_held(&keypairs->keypair_update_lock));
 	next_keypair = rcu_dereference_protected(keypairs->next_keypair,
-		lockdep_is_held(&keypairs->keypair_update_lock));
+						lockdep_is_held(&keypairs->keypair_update_lock));
 	current_keypair = rcu_dereference_protected(keypairs->current_keypair,
-		lockdep_is_held(&keypairs->keypair_update_lock));
+						    lockdep_is_held(&keypairs->keypair_update_lock));
 	if (new_keypair->i_am_the_initiator) {
-		/* If we're the initiator, it means we've sent a handshake, and
-		 * received a confirmation response, which means this new
-		 * keypair can now be used.
+		/* If we're the initiator, it means we've sent a handshake, and received a
+		 * confirmation response, which means this new keypair can now be used.
 		 */
 		if (next_keypair) {
-			/* If there already was a next keypair pending, we
-			 * demote it to be the previous keypair, and free the
-			 * existing current. Note that this means KCI can result
-			 * in this transition. It would perhaps be more sound to
-			 * always just get rid of the unused next keypair
-			 * instead of putting it in the previous slot, but this
-			 * might be a bit less robust. Something to think about
-			 * for the future.
+			/* If there already was a next keypair pending, we demote it to be the
+			 * previous keypair, and free the existing current. Note that this means KCI
+			 * can result in this transition. It would perhaps be more sound to always
+			 * just get rid of the unused next keypair instead of putting it in the
+			 * previous slot, but this might be a bit less robust. Something to think
+			 * about for the future.
 			 */
 			RCU_INIT_POINTER(keypairs->next_keypair, NULL);
-			rcu_assign_pointer(keypairs->previous_keypair,
-					   next_keypair);
+			rcu_assign_pointer(keypairs->previous_keypair, next_keypair);
 			wg_noise_keypair_put(current_keypair, true);
-		} else /* If there wasn't an existing next keypair, we replace
-			* the previous with the current one.
+		} else /* If there wasn't an existing next keypair, we replace the previous with
+			* the current one.
 			*/
-			rcu_assign_pointer(keypairs->previous_keypair,
-					   current_keypair);
-		/* At this point we can get rid of the old previous keypair, and
-		 * set up the new keypair.
+			rcu_assign_pointer(keypairs->previous_keypair, current_keypair);
+		/* At this point we can get rid of the old previous keypair, and set up the new
+		 * keypair.
 		 */
 		wg_noise_keypair_put(previous_keypair, true);
 		rcu_assign_pointer(keypairs->current_keypair, new_keypair);
 	} else {
-		/* If we're the responder, it means we can't use the new keypair
-		 * until we receive confirmation via the first data packet, so
-		 * we get rid of the existing previous one, the possibly
-		 * existing next one, and slide in the new next one.
+		/* If we're the responder, it means we can't use the new keypair until we receive
+		 * confirmation via the first data packet, so we get rid of the existing previous
+		 * one, the possibly existing next one, and slide in the new next one.
 		 */
 		rcu_assign_pointer(keypairs->next_keypair, new_keypair);
 		wg_noise_keypair_put(next_keypair, true);
@@ -266,25 +251,21 @@ bool wg_noise_received_with_keypair(struct noise_keypairs *keypairs,
 		return false;
 
 	spin_lock_bh(&keypairs->keypair_update_lock);
-	/* After locking, we double check that things didn't change from
-	 * beneath us.
-	 */
-	if (unlikely(received_keypair !=
-		    rcu_dereference_protected(keypairs->next_keypair,
-			    lockdep_is_held(&keypairs->keypair_update_lock)))) {
+	/* After locking, we double check that things didn't change from beneath us. */
+	if (unlikely(received_keypair != rcu_dereference_protected(keypairs->next_keypair,
+			   		 lockdep_is_held(&keypairs->keypair_update_lock)))) {
 		spin_unlock_bh(&keypairs->keypair_update_lock);
 		return false;
 	}
 
-	/* When we've finally received the confirmation, we slide the next
-	 * into the current, the current into the previous, and get rid of
-	 * the old previous.
+	/* When we've finally received the confirmation, we slide the next into the current, the
+	 * current into the previous, and get rid of the old previous.
 	 */
 	old_keypair = rcu_dereference_protected(keypairs->previous_keypair,
-		lockdep_is_held(&keypairs->keypair_update_lock));
+						lockdep_is_held(&keypairs->keypair_update_lock));
 	rcu_assign_pointer(keypairs->previous_keypair,
-		rcu_dereference_protected(keypairs->current_keypair,
-			lockdep_is_held(&keypairs->keypair_update_lock)));
+			   rcu_dereference_protected(keypairs->current_keypair,
+						lockdep_is_held(&keypairs->keypair_update_lock)));
 	wg_noise_keypair_put(old_keypair, true);
 	rcu_assign_pointer(keypairs->current_keypair, received_keypair);
 	RCU_INIT_POINTER(keypairs->next_keypair, NULL);
@@ -294,35 +275,30 @@ bool wg_noise_received_with_keypair(struct noise_keypairs *keypairs,
 }
 
 /* Must hold static_identity->lock */
-void wg_noise_set_static_identity_private_key(
-	struct noise_static_identity *static_identity,
-	const u8 private_key[NOISE_PUBLIC_KEY_LEN])
+void wg_noise_set_static_identity_private_key(struct noise_static_identity *static_identity,
+					      const u8 private_key[NOISE_PUBLIC_KEY_LEN])
 {
-	memcpy(static_identity->static_private, private_key,
-	       NOISE_PUBLIC_KEY_LEN);
+	memcpy(static_identity->static_private, private_key, NOISE_PUBLIC_KEY_LEN);
 	curve25519_clamp_secret(static_identity->static_private);
-	static_identity->has_identity = curve25519_generate_public(
-		static_identity->static_public, private_key);
+	static_identity->has_identity = curve25519_generate_public(static_identity->static_public,
+								   private_key);
 }
 
 /* This is Hugo Krawczyk's HKDF:
  *  - https://eprint.iacr.org/2010/264.pdf
  *  - https://tools.ietf.org/html/rfc5869
  */
-static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
-		size_t first_len, size_t second_len, size_t third_len,
-		size_t data_len, const u8 chaining_key[NOISE_HASH_LEN])
+static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data, size_t first_len,
+		size_t second_len, size_t third_len, size_t data_len,
+		const u8 chaining_key[NOISE_HASH_LEN])
 {
 	u8 output[BLAKE2S_HASH_SIZE + 1];
 	u8 secret[BLAKE2S_HASH_SIZE];
 
-	WARN_ON(IS_ENABLED(DEBUG) &&
-		(first_len > BLAKE2S_HASH_SIZE ||
-		 second_len > BLAKE2S_HASH_SIZE ||
-		 third_len > BLAKE2S_HASH_SIZE ||
-		 ((second_len || second_dst || third_len || third_dst) &&
-		  (!first_len || !first_dst)) ||
-		 ((third_len || third_dst) && (!second_len || !second_dst))));
+	WARN_ON(IS_ENABLED(DEBUG) && (first_len > BLAKE2S_HASH_SIZE ||
+		second_len > BLAKE2S_HASH_SIZE || third_len > BLAKE2S_HASH_SIZE ||
+		((second_len || second_dst || third_len || third_dst) && (!first_len || !first_dst)) ||
+		((third_len || third_dst) && (!second_len || !second_dst))));
 
 	/* Extract entropy from data into secret */
 	blake2s256_hmac(secret, data, chaining_key, data_len, NOISE_HASH_LEN);
@@ -340,8 +316,7 @@ static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
 
 	/* Expand second key: key = secret, data = first-key || 0x2 */
 	output[BLAKE2S_HASH_SIZE] = 2;
-	blake2s256_hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1,
-			BLAKE2S_HASH_SIZE);
+	blake2s256_hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1, BLAKE2S_HASH_SIZE);
 	memcpy(second_dst, output, second_len);
 
 	if (!third_dst || !third_len)
@@ -349,8 +324,7 @@ static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
 
 	/* Expand third key: key = secret, data = second-key || 0x3 */
 	output[BLAKE2S_HASH_SIZE] = 3;
-	blake2s256_hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1,
-			BLAKE2S_HASH_SIZE);
+	blake2s256_hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1, BLAKE2S_HASH_SIZE);
 	memcpy(third_dst, output, third_len);
 
 out:
@@ -359,20 +333,17 @@ static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
 	memzero_explicit(output, BLAKE2S_HASH_SIZE + 1);
 }
 
-static void derive_keys(struct noise_symmetric_key *first_dst,
-			struct noise_symmetric_key *second_dst,
+static void derive_keys(struct noise_symmetric_key *first_dst, struct noise_symmetric_key *second_dst,
 			const u8 chaining_key[NOISE_HASH_LEN])
 {
 	u64 birthdate = ktime_get_coarse_boottime_ns();
-	kdf(first_dst->key, second_dst->key, NULL, NULL,
-	    NOISE_SYMMETRIC_KEY_LEN, NOISE_SYMMETRIC_KEY_LEN, 0, 0,
-	    chaining_key);
+	kdf(first_dst->key, second_dst->key, NULL, NULL, NOISE_SYMMETRIC_KEY_LEN,
+	    NOISE_SYMMETRIC_KEY_LEN, 0, 0, chaining_key);
 	first_dst->birthdate = second_dst->birthdate = birthdate;
 	first_dst->is_valid = second_dst->is_valid = true;
 }
 
-static bool __must_check mix_dh(u8 chaining_key[NOISE_HASH_LEN],
-				u8 key[NOISE_SYMMETRIC_KEY_LEN],
+static bool __must_check mix_dh(u8 chaining_key[NOISE_HASH_LEN], u8 key[NOISE_SYMMETRIC_KEY_LEN],
 				const u8 private[NOISE_PUBLIC_KEY_LEN],
 				const u8 public[NOISE_PUBLIC_KEY_LEN])
 {
@@ -380,8 +351,8 @@ static bool __must_check mix_dh(u8 chaining_key[NOISE_HASH_LEN],
 
 	if (unlikely(!curve25519(dh_calculation, private, public)))
 		return false;
-	kdf(chaining_key, key, NULL, dh_calculation, NOISE_HASH_LEN,
-	    NOISE_SYMMETRIC_KEY_LEN, 0, NOISE_PUBLIC_KEY_LEN, chaining_key);
+	kdf(chaining_key, key, NULL, dh_calculation, NOISE_HASH_LEN, NOISE_SYMMETRIC_KEY_LEN, 0,
+	    NOISE_PUBLIC_KEY_LEN, chaining_key);
 	memzero_explicit(dh_calculation, NOISE_PUBLIC_KEY_LEN);
 	return true;
 }
@@ -393,9 +364,8 @@ static bool __must_check mix_precomputed_dh(u8 chaining_key[NOISE_HASH_LEN],
 	static u8 zero_point[NOISE_PUBLIC_KEY_LEN];
 	if (unlikely(!crypto_memneq(precomputed, zero_point, NOISE_PUBLIC_KEY_LEN)))
 		return false;
-	kdf(chaining_key, key, NULL, precomputed, NOISE_HASH_LEN,
-	    NOISE_SYMMETRIC_KEY_LEN, 0, NOISE_PUBLIC_KEY_LEN,
-	    chaining_key);
+	kdf(chaining_key, key, NULL, precomputed, NOISE_HASH_LEN, NOISE_SYMMETRIC_KEY_LEN, 0,
+	    NOISE_PUBLIC_KEY_LEN, chaining_key);
 	return true;
 }
 
@@ -410,8 +380,7 @@ static void mix_hash(u8 hash[NOISE_HASH_LEN], const u8 *src, size_t src_len)
 }
 
 static void mix_psk(u8 chaining_key[NOISE_HASH_LEN], u8 hash[NOISE_HASH_LEN],
-		    u8 key[NOISE_SYMMETRIC_KEY_LEN],
-		    const u8 psk[NOISE_SYMMETRIC_KEY_LEN])
+		    u8 key[NOISE_SYMMETRIC_KEY_LEN], const u8 psk[NOISE_SYMMETRIC_KEY_LEN])
 {
 	u8 temp_hash[NOISE_HASH_LEN];
 
@@ -421,8 +390,7 @@ static void mix_psk(u8 chaining_key[NOISE_HASH_LEN], u8 hash[NOISE_HASH_LEN],
 	memzero_explicit(temp_hash, NOISE_HASH_LEN);
 }
 
-static void handshake_init(u8 chaining_key[NOISE_HASH_LEN],
-			   u8 hash[NOISE_HASH_LEN],
+static void handshake_init(u8 chaining_key[NOISE_HASH_LEN], u8 hash[NOISE_HASH_LEN],
 			   const u8 remote_static[NOISE_PUBLIC_KEY_LEN])
 {
 	memcpy(hash, handshake_init_hash, NOISE_HASH_LEN);
@@ -430,22 +398,18 @@ static void handshake_init(u8 chaining_key[NOISE_HASH_LEN],
 	mix_hash(hash, remote_static, NOISE_PUBLIC_KEY_LEN);
 }
 
-static void message_encrypt(u8 *dst_ciphertext, const u8 *src_plaintext,
-			    size_t src_len, u8 key[NOISE_SYMMETRIC_KEY_LEN],
-			    u8 hash[NOISE_HASH_LEN])
+static void message_encrypt(u8 *dst_ciphertext, const u8 *src_plaintext, size_t src_len,
+			    u8 key[NOISE_SYMMETRIC_KEY_LEN], u8 hash[NOISE_HASH_LEN])
 {
-	chacha20poly1305_encrypt(dst_ciphertext, src_plaintext, src_len, hash,
-				 NOISE_HASH_LEN,
+	chacha20poly1305_encrypt(dst_ciphertext, src_plaintext, src_len, hash, NOISE_HASH_LEN,
 				 0 /* Always zero for Noise_IK */, key);
 	mix_hash(hash, dst_ciphertext, noise_encrypted_len(src_len));
 }
 
-static bool message_decrypt(u8 *dst_plaintext, const u8 *src_ciphertext,
-			    size_t src_len, u8 key[NOISE_SYMMETRIC_KEY_LEN],
-			    u8 hash[NOISE_HASH_LEN])
+static bool message_decrypt(u8 *dst_plaintext, const u8 *src_ciphertext, size_t src_len,
+			    u8 key[NOISE_SYMMETRIC_KEY_LEN], u8 hash[NOISE_HASH_LEN])
 {
-	if (!chacha20poly1305_decrypt(dst_plaintext, src_ciphertext, src_len,
-				      hash, NOISE_HASH_LEN,
+	if (!chacha20poly1305_decrypt(dst_plaintext, src_ciphertext, src_len, hash, NOISE_HASH_LEN,
 				      0 /* Always zero for Noise_IK */, key))
 		return false;
 	mix_hash(hash, src_ciphertext, src_len);
@@ -454,14 +418,13 @@ static bool message_decrypt(u8 *dst_plaintext, const u8 *src_ciphertext,
 
 static void message_ephemeral(u8 ephemeral_dst[NOISE_PUBLIC_KEY_LEN],
 			      const u8 ephemeral_src[NOISE_PUBLIC_KEY_LEN],
-			      u8 chaining_key[NOISE_HASH_LEN],
-			      u8 hash[NOISE_HASH_LEN])
+			      u8 chaining_key[NOISE_HASH_LEN], u8 hash[NOISE_HASH_LEN])
 {
 	if (ephemeral_dst != ephemeral_src)
 		memcpy(ephemeral_dst, ephemeral_src, NOISE_PUBLIC_KEY_LEN);
 	mix_hash(hash, ephemeral_src, NOISE_PUBLIC_KEY_LEN);
-	kdf(chaining_key, NULL, NULL, ephemeral_src, NOISE_HASH_LEN, 0, 0,
-	    NOISE_PUBLIC_KEY_LEN, chaining_key);
+	kdf(chaining_key, NULL, NULL, ephemeral_src, NOISE_HASH_LEN, 0, 0, NOISE_PUBLIC_KEY_LEN,
+	    chaining_key);
 }
 
 static void tai64n_now(u8 output[NOISE_TIMESTAMP_LEN])
@@ -470,29 +433,27 @@ static void tai64n_now(u8 output[NOISE_TIMESTAMP_LEN])
 
 	ktime_get_real_ts64(&now);
 
-	/* In order to prevent some sort of infoleak from precise timers, we
-	 * round down the nanoseconds part to the closest rounded-down power of
-	 * two to the maximum initiations per second allowed anyway by the
-	 * implementation.
+	/* In order to prevent some sort of infoleak from precise timers, we round down the
+	 * nanoseconds part to the closest rounded-down power of two to the maximum initiations per
+	 * second allowed anyway by the implementation.
 	 */
 	now.tv_nsec = ALIGN_DOWN(now.tv_nsec,
-		rounddown_pow_of_two(NSEC_PER_SEC / INITIATIONS_PER_SECOND));
+				 rounddown_pow_of_two(NSEC_PER_SEC / INITIATIONS_PER_SECOND));
 
 	/* https://cr.yp.to/libtai/tai64.html */
 	*(__be64 *)output = cpu_to_be64(0x400000000000000aULL + now.tv_sec);
 	*(__be32 *)(output + sizeof(__be64)) = cpu_to_be32(now.tv_nsec);
 }
 
-bool
-wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
-				     struct noise_handshake *handshake)
+bool wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
+					  struct noise_handshake *handshake)
 {
 	u8 timestamp[NOISE_TIMESTAMP_LEN];
 	u8 key[NOISE_SYMMETRIC_KEY_LEN];
 	bool ret = false;
 
-	/* We need to wait for crng _before_ taking any locks, since
-	 * curve25519_generate_secret uses get_random_bytes_wait.
+	/* We need to wait for crng _before_ taking any locks, since curve25519_generate_secret uses
+	 * get_random_bytes_wait.
 	 */
 	wait_for_random_bytes();
 
@@ -504,17 +465,14 @@ wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
 
 	dst->header.type = cpu_to_le32(MESSAGE_HANDSHAKE_INITIATION);
 
-	handshake_init(handshake->chaining_key, handshake->hash,
-		       handshake->remote_static);
+	handshake_init(handshake->chaining_key, handshake->hash, handshake->remote_static);
 
 	/* e */
 	curve25519_generate_secret(handshake->ephemeral_private);
-	if (!curve25519_generate_public(dst->unencrypted_ephemeral,
-					handshake->ephemeral_private))
+	if (!curve25519_generate_public(dst->unencrypted_ephemeral, handshake->ephemeral_private))
 		goto out;
-	message_ephemeral(dst->unencrypted_ephemeral,
-			  dst->unencrypted_ephemeral, handshake->chaining_key,
-			  handshake->hash);
+	message_ephemeral(dst->unencrypted_ephemeral, dst->unencrypted_ephemeral,
+			  handshake->chaining_key, handshake->hash);
 
 	/* es */
 	if (!mix_dh(handshake->chaining_key, key, handshake->ephemeral_private,
@@ -522,23 +480,19 @@ wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
 		goto out;
 
 	/* s */
-	message_encrypt(dst->encrypted_static,
-			handshake->static_identity->static_public,
+	message_encrypt(dst->encrypted_static, handshake->static_identity->static_public,
 			NOISE_PUBLIC_KEY_LEN, key, handshake->hash);
 
 	/* ss */
-	if (!mix_precomputed_dh(handshake->chaining_key, key,
-				handshake->precomputed_static_static))
+	if (!mix_precomputed_dh(handshake->chaining_key, key, handshake->precomputed_static_static))
 		goto out;
 
 	/* {t} */
 	tai64n_now(timestamp);
-	message_encrypt(dst->encrypted_timestamp, timestamp,
-			NOISE_TIMESTAMP_LEN, key, handshake->hash);
+	message_encrypt(dst->encrypted_timestamp, timestamp, NOISE_TIMESTAMP_LEN, key, handshake->hash);
 
-	dst->sender_index = wg_index_hashtable_insert(
-		handshake->entry.peer->device->index_hashtable,
-		&handshake->entry);
+	dst->sender_index = wg_index_hashtable_insert(handshake->entry.peer->device->index_hashtable,
+						      &handshake->entry);
 
 	handshake->state = HANDSHAKE_CREATED_INITIATION;
 	ret = true;
@@ -550,9 +504,8 @@ wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
 	return ret;
 }
 
-struct wg_peer *
-wg_noise_handshake_consume_initiation(struct message_handshake_initiation *src,
-				      struct wg_device *wg)
+struct wg_peer *wg_noise_handshake_consume_initiation(struct message_handshake_initiation *src,
+						      struct wg_device *wg)
 {
 	struct wg_peer *peer = NULL, *ret_peer = NULL;
 	struct noise_handshake *handshake;
@@ -579,8 +532,7 @@ wg_noise_handshake_consume_initiation(struct message_handshake_initiation *src,
 		goto out;
 
 	/* s */
-	if (!message_decrypt(s, src->encrypted_static,
-			     sizeof(src->encrypted_static), key, hash))
+	if (!message_decrypt(s, src->encrypted_static, sizeof(src->encrypted_static), key, hash))
 		goto out;
 
 	/* Lookup which peer we're actually talking to */
@@ -590,21 +542,17 @@ wg_noise_handshake_consume_initiation(struct message_handshake_initiation *src,
 	handshake = &peer->handshake;
 
 	/* ss */
-	if (!mix_precomputed_dh(chaining_key, key,
-				handshake->precomputed_static_static))
+	if (!mix_precomputed_dh(chaining_key, key, handshake->precomputed_static_static))
 	    goto out;
 
 	/* {t} */
-	if (!message_decrypt(t, src->encrypted_timestamp,
-			     sizeof(src->encrypted_timestamp), key, hash))
+	if (!message_decrypt(t, src->encrypted_timestamp, sizeof(src->encrypted_timestamp), key, hash))
 		goto out;
 
 	down_read(&handshake->lock);
-	replay_attack = memcmp(t, handshake->latest_timestamp,
-			       NOISE_TIMESTAMP_LEN) <= 0;
+	replay_attack = memcmp(t, handshake->latest_timestamp, NOISE_TIMESTAMP_LEN) <= 0;
 	flood_attack = (s64)handshake->last_initiation_consumption +
-			       NSEC_PER_SEC / INITIATIONS_PER_SECOND >
-		       (s64)ktime_get_coarse_boottime_ns();
+		       NSEC_PER_SEC / INITIATIONS_PER_SECOND > (s64)ktime_get_coarse_boottime_ns();
 	up_read(&handshake->lock);
 	if (replay_attack || flood_attack)
 		goto out;
@@ -656,12 +604,10 @@ bool wg_noise_handshake_create_response(struct message_handshake_response *dst,
 
 	/* e */
 	curve25519_generate_secret(handshake->ephemeral_private);
-	if (!curve25519_generate_public(dst->unencrypted_ephemeral,
-					handshake->ephemeral_private))
+	if (!curve25519_generate_public(dst->unencrypted_ephemeral, handshake->ephemeral_private))
 		goto out;
-	message_ephemeral(dst->unencrypted_ephemeral,
-			  dst->unencrypted_ephemeral, handshake->chaining_key,
-			  handshake->hash);
+	message_ephemeral(dst->unencrypted_ephemeral, dst->unencrypted_ephemeral,
+			  handshake->chaining_key, handshake->hash);
 
 	/* ee */
 	if (!mix_dh(handshake->chaining_key, NULL, handshake->ephemeral_private,
@@ -674,15 +620,13 @@ bool wg_noise_handshake_create_response(struct message_handshake_response *dst,
 		goto out;
 
 	/* psk */
-	mix_psk(handshake->chaining_key, handshake->hash, key,
-		handshake->preshared_key);
+	mix_psk(handshake->chaining_key, handshake->hash, key, handshake->preshared_key);
 
 	/* {} */
 	message_encrypt(dst->encrypted_nothing, NULL, 0, key, handshake->hash);
 
-	dst->sender_index = wg_index_hashtable_insert(
-		handshake->entry.peer->device->index_hashtable,
-		&handshake->entry);
+	dst->sender_index = wg_index_hashtable_insert(handshake->entry.peer->device->index_hashtable,
+						      &handshake->entry);
 
 	handshake->state = HANDSHAKE_CREATED_RESPONSE;
 	ret = true;
@@ -694,9 +638,8 @@ bool wg_noise_handshake_create_response(struct message_handshake_response *dst,
 	return ret;
 }
 
-struct wg_peer *
-wg_noise_handshake_consume_response(struct message_handshake_response *src,
-				    struct wg_device *wg)
+struct wg_peer *wg_noise_handshake_consume_response(struct message_handshake_response *src,
+						    struct wg_device *wg)
 {
 	enum noise_handshake_state state = HANDSHAKE_ZEROED;
 	struct wg_peer *peer = NULL, *ret_peer = NULL;
@@ -714,9 +657,8 @@ wg_noise_handshake_consume_response(struct message_handshake_response *src,
 	if (unlikely(!wg->static_identity.has_identity))
 		goto out;
 
-	handshake = (struct noise_handshake *)wg_index_hashtable_lookup(
-		wg->index_hashtable, INDEX_HASHTABLE_HANDSHAKE,
-		src->receiver_index, &peer);
+	handshake = (struct noise_handshake *)wg_index_hashtable_lookup(wg->index_hashtable,
+					INDEX_HASHTABLE_HANDSHAKE, src->receiver_index, &peer);
 	if (unlikely(!handshake))
 		goto out;
 
@@ -724,10 +666,8 @@ wg_noise_handshake_consume_response(struct message_handshake_response *src,
 	state = handshake->state;
 	memcpy(hash, handshake->hash, NOISE_HASH_LEN);
 	memcpy(chaining_key, handshake->chaining_key, NOISE_HASH_LEN);
-	memcpy(ephemeral_private, handshake->ephemeral_private,
-	       NOISE_PUBLIC_KEY_LEN);
-	memcpy(preshared_key, handshake->preshared_key,
-	       NOISE_SYMMETRIC_KEY_LEN);
+	memcpy(ephemeral_private, handshake->ephemeral_private, NOISE_PUBLIC_KEY_LEN);
+	memcpy(preshared_key, handshake->preshared_key, NOISE_SYMMETRIC_KEY_LEN);
 	up_read(&handshake->lock);
 
 	if (state != HANDSHAKE_CREATED_INITIATION)
@@ -748,15 +688,12 @@ wg_noise_handshake_consume_response(struct message_handshake_response *src,
 	mix_psk(chaining_key, hash, key, preshared_key);
 
 	/* {} */
-	if (!message_decrypt(NULL, src->encrypted_nothing,
-			     sizeof(src->encrypted_nothing), key, hash))
+	if (!message_decrypt(NULL, src->encrypted_nothing, sizeof(src->encrypted_nothing), key, hash))
 		goto fail;
 
 	/* Success! Copy everything to peer */
 	down_write(&handshake->lock);
-	/* It's important to check that the state is still the same, while we
-	 * have an exclusive lock.
-	 */
+	/* It's important to check that the state is still the same, while we have an exclusive lock. */
 	if (handshake->state != state) {
 		up_write(&handshake->lock);
 		goto fail;
@@ -797,29 +734,23 @@ bool wg_noise_handshake_begin_session(struct noise_handshake *handshake,
 	new_keypair = keypair_create(handshake->entry.peer);
 	if (!new_keypair)
 		goto out;
-	new_keypair->i_am_the_initiator = handshake->state ==
-					  HANDSHAKE_CONSUMED_RESPONSE;
+	new_keypair->i_am_the_initiator = handshake->state == HANDSHAKE_CONSUMED_RESPONSE;
 	new_keypair->remote_index = handshake->remote_index;
 
 	if (new_keypair->i_am_the_initiator)
-		derive_keys(&new_keypair->sending, &new_keypair->receiving,
-			    handshake->chaining_key);
+		derive_keys(&new_keypair->sending, &new_keypair->receiving, handshake->chaining_key);
 	else
-		derive_keys(&new_keypair->receiving, &new_keypair->sending,
-			    handshake->chaining_key);
+		derive_keys(&new_keypair->receiving, &new_keypair->sending, handshake->chaining_key);
 
 	handshake_zero(handshake);
 	rcu_read_lock_bh();
-	if (likely(!READ_ONCE(container_of(handshake, struct wg_peer,
-					   handshake)->is_dead))) {
+	if (likely(!READ_ONCE(container_of(handshake, struct wg_peer, handshake)->is_dead))) {
 		add_new_keypair(keypairs, new_keypair);
 		net_dbg_ratelimited("%s: Keypair %llu created for peer %llu\n",
 				    handshake->entry.peer->device->dev->name,
-				    new_keypair->internal_id,
-				    handshake->entry.peer->internal_id);
-		ret = wg_index_hashtable_replace(
-			handshake->entry.peer->device->index_hashtable,
-			&handshake->entry, &new_keypair->entry);
+				    new_keypair->internal_id, handshake->entry.peer->internal_id);
+		ret = wg_index_hashtable_replace(handshake->entry.peer->device->index_hashtable,
+						 &handshake->entry, &new_keypair->entry);
 	} else {
 		kzfree(new_keypair);
 	}
diff --git a/drivers/net/wireguard/noise.h b/drivers/net/wireguard/noise.h
index c527253dba80..25ade2cc4db6 100644
--- a/drivers/net/wireguard/noise.h
+++ b/drivers/net/wireguard/noise.h
@@ -111,23 +111,19 @@ bool wg_noise_received_with_keypair(struct noise_keypairs *keypairs,
 				    struct noise_keypair *received_keypair);
 void wg_noise_expire_current_peer_keypairs(struct wg_peer *peer);
 
-void wg_noise_set_static_identity_private_key(
-	struct noise_static_identity *static_identity,
-	const u8 private_key[NOISE_PUBLIC_KEY_LEN]);
+void wg_noise_set_static_identity_private_key(struct noise_static_identity *static_identity,
+					      const u8 private_key[NOISE_PUBLIC_KEY_LEN]);
 void wg_noise_precompute_static_static(struct wg_peer *peer);
 
-bool
-wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
-				     struct noise_handshake *handshake);
-struct wg_peer *
-wg_noise_handshake_consume_initiation(struct message_handshake_initiation *src,
-				      struct wg_device *wg);
+bool wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
+					  struct noise_handshake *handshake);
+struct wg_peer *wg_noise_handshake_consume_initiation(struct message_handshake_initiation *src,
+						      struct wg_device *wg);
 
 bool wg_noise_handshake_create_response(struct message_handshake_response *dst,
 					struct noise_handshake *handshake);
-struct wg_peer *
-wg_noise_handshake_consume_response(struct message_handshake_response *src,
-				    struct wg_device *wg);
+struct wg_peer *wg_noise_handshake_consume_response(struct message_handshake_response *src,
+						    struct wg_device *wg);
 
 bool wg_noise_handshake_begin_session(struct noise_handshake *handshake,
 				      struct noise_keypairs *keypairs);
diff --git a/drivers/net/wireguard/peer.c b/drivers/net/wireguard/peer.c
index 1d634bd3038f..2e1e8dd67bd7 100644
--- a/drivers/net/wireguard/peer.c
+++ b/drivers/net/wireguard/peer.c
@@ -17,8 +17,7 @@
 
 static atomic64_t peer_counter = ATOMIC64_INIT(0);
 
-struct wg_peer *wg_peer_create(struct wg_device *wg,
-			       const u8 public_key[NOISE_PUBLIC_KEY_LEN],
+struct wg_peer *wg_peer_create(struct wg_device *wg, const u8 public_key[NOISE_PUBLIC_KEY_LEN],
 			       const u8 preshared_key[NOISE_SYMMETRIC_KEY_LEN])
 {
 	struct wg_peer *peer;
@@ -34,15 +33,13 @@ struct wg_peer *wg_peer_create(struct wg_device *wg,
 		return ERR_PTR(ret);
 	peer->device = wg;
 
-	wg_noise_handshake_init(&peer->handshake, &wg->static_identity,
-				public_key, preshared_key, peer);
+	wg_noise_handshake_init(&peer->handshake, &wg->static_identity,	public_key, preshared_key,
+				peer);
 	if (dst_cache_init(&peer->endpoint_cache, GFP_KERNEL))
 		goto err_1;
-	if (wg_packet_queue_init(&peer->tx_queue, wg_packet_tx_worker, false,
-				 MAX_QUEUED_PACKETS))
+	if (wg_packet_queue_init(&peer->tx_queue, wg_packet_tx_worker, false, MAX_QUEUED_PACKETS))
 		goto err_2;
-	if (wg_packet_queue_init(&peer->rx_queue, NULL, false,
-				 MAX_QUEUED_PACKETS))
+	if (wg_packet_queue_init(&peer->rx_queue, NULL, false, MAX_QUEUED_PACKETS))
 		goto err_3;
 
 	peer->internal_id = atomic64_inc_return(&peer_counter);
@@ -51,15 +48,13 @@ struct wg_peer *wg_peer_create(struct wg_device *wg,
 	wg_timers_init(peer);
 	wg_cookie_checker_precompute_peer_keys(peer);
 	spin_lock_init(&peer->keypairs.keypair_update_lock);
-	INIT_WORK(&peer->transmit_handshake_work,
-		  wg_packet_handshake_send_worker);
+	INIT_WORK(&peer->transmit_handshake_work, wg_packet_handshake_send_worker);
 	rwlock_init(&peer->endpoint_lock);
 	kref_init(&peer->refcount);
 	skb_queue_head_init(&peer->staged_packet_queue);
 	wg_noise_reset_last_sent_handshake(&peer->last_sent_handshake);
 	set_bit(NAPI_STATE_NO_BUSY_POLL, &peer->napi.state);
-	netif_napi_add(wg->dev, &peer->napi, wg_packet_rx_poll,
-		       NAPI_POLL_WEIGHT);
+	netif_napi_add(wg->dev, &peer->napi, wg_packet_rx_poll, NAPI_POLL_WEIGHT);
 	napi_enable(&peer->napi);
 	list_add_tail(&peer->peer_list, &wg->peer_list);
 	INIT_LIST_HEAD(&peer->allowedips_list);
@@ -104,20 +99,17 @@ static void peer_remove_after_dead(struct wg_peer *peer)
 {
 	WARN_ON(!peer->is_dead);
 
-	/* No more keypairs can be created for this peer, since is_dead protects
-	 * add_new_keypair, so we can now destroy existing ones.
+	/* No more keypairs can be created for this peer, since is_dead protects add_new_keypair, so
+	 * we can now destroy existing ones.
 	 */
 	wg_noise_keypairs_clear(&peer->keypairs);
 
-	/* Destroy all ongoing timers that were in-flight at the beginning of
-	 * this function.
-	 */
+	/* Destroy all ongoing timers that were in-flight at the beginning of this function. */
 	wg_timers_stop(peer);
 
-	/* The transition between packet encryption/decryption queues isn't
-	 * guarded by is_dead, but each reference's life is strictly bounded by
-	 * two generations: once for parallel crypto and once for serial
-	 * ingestion, so we can simply flush twice, and be sure that we no
+	/* The transition between packet encryption/decryption queues isn't guarded by is_dead, but
+	 * each reference's life is strictly bounded by two generations: once for parallel crypto
+	 * and once for serial ingestion, so we can simply flush twice, and be sure that we no
 	 * longer have references inside these queues.
 	 */
 
@@ -127,40 +119,34 @@ static void peer_remove_after_dead(struct wg_peer *peer)
 	flush_workqueue(peer->device->packet_crypt_wq);
 	/* b.2.1) For receive (but not send, since that's wq). */
 	napi_disable(&peer->napi);
-	/* b.2.1) It's now safe to remove the napi struct, which must be done
-	 * here from process context.
-	 */
+	/* b.2.1) It's now safe to remove the napi struct, which must be done here from process context. */
 	netif_napi_del(&peer->napi);
 
-	/* Ensure any workstructs we own (like transmit_handshake_work or
-	 * clear_peer_work) no longer are in use.
+	/* Ensure any workstructs we own (like transmit_handshake_work or clear_peer_work) no longer
+	 * are in use.
 	 */
 	flush_workqueue(peer->device->handshake_send_wq);
 
-	/* After the above flushes, a peer might still be active in a few
-	 * different contexts: 1) from xmit(), before hitting is_dead and
-	 * returning, 2) from wg_packet_consume_data(), before hitting is_dead
-	 * and returning, 3) from wg_receive_handshake_packet() after a point
-	 * where it has processed an incoming handshake packet, but where
-	 * all calls to pass it off to timers fails because of is_dead. We won't
-	 * have new references in (1) eventually, because we're removed from
-	 * allowedips; we won't have new references in (2) eventually, because
-	 * wg_index_hashtable_lookup will always return NULL, since we removed
-	 * all existing keypairs and no more can be created; we won't have new
-	 * references in (3) eventually, because we're removed from the pubkey
-	 * hash table, which allows for a maximum of one handshake response,
-	 * via the still-uncleared index hashtable entry, but not more than one,
-	 * and in wg_cookie_message_consume, the lookup eventually gets a peer
-	 * with a refcount of zero, so no new reference is taken.
+	/* After the above flushes, a peer might still be active in a few different contexts: 1)
+	 * from xmit(), before hitting is_dead and returning, 2) from wg_packet_consume_data(),
+	 * before hitting is_dead and returning, 3) from wg_receive_handshake_packet() after a point
+	 * where it has processed an incoming handshake packet, but where all calls to pass it off
+	 * to timers fails because of is_dead. We won't have new references in (1) eventually,
+	 * because we're removed from allowedips; we won't have new references in (2) eventually,
+	 * because wg_index_hashtable_lookup will always return NULL, since we removed all existing
+	 * keypairs and no more can be created; we won't have new references in (3) eventually,
+	 * because we're removed from the pubkey hash table, which allows for a maximum of one
+	 * handshake response, via the still-uncleared index hashtable entry, but not more than one,
+	 * and in wg_cookie_message_consume, the lookup eventually gets a peer with a refcount of
+	 * zero, so no new reference is taken.
 	 */
 
 	--peer->device->num_peers;
 	wg_peer_put(peer);
 }
 
-/* We have a separate "remove" function make sure that all active places where
- * a peer is currently operating will eventually come to an end and not pass
- * their reference onto another context.
+/* We have a separate "remove" function make sure that all active places where a peer is currently
+ * operating will eventually come to an end and not pass their reference onto another context.
  */
 void wg_peer_remove(struct wg_peer *peer)
 {
@@ -200,8 +186,8 @@ static void rcu_release(struct rcu_head *rcu)
 	wg_packet_queue_free(&peer->rx_queue, false);
 	wg_packet_queue_free(&peer->tx_queue, false);
 
-	/* The final zeroing takes care of clearing any remaining handshake key
-	 * material and other potentially sensitive information.
+	/* The final zeroing takes care of clearing any remaining handshake key material and other
+	 * potentially sensitive information.
 	 */
 	kzfree(peer);
 }
@@ -210,19 +196,13 @@ static void kref_release(struct kref *refcount)
 {
 	struct wg_peer *peer = container_of(refcount, struct wg_peer, refcount);
 
-	pr_debug("%s: Peer %llu (%pISpfsc) destroyed\n",
-		 peer->device->dev->name, peer->internal_id,
+	pr_debug("%s: Peer %llu (%pISpfsc) destroyed\n", peer->device->dev->name, peer->internal_id,
 		 &peer->endpoint.addr);
 
-	/* Remove ourself from dynamic runtime lookup structures, now that the
-	 * last reference is gone.
-	 */
-	wg_index_hashtable_remove(peer->device->index_hashtable,
-				  &peer->handshake.entry);
+	/* Remove ourself from dynamic runtime lookup structures, now that the last reference is gone. */
+	wg_index_hashtable_remove(peer->device->index_hashtable, &peer->handshake.entry);
 
-	/* Remove any lingering packets that didn't have a chance to be
-	 * transmitted.
-	 */
+	/* Remove any lingering packets that didn't have a chance to be transmitted. */
 	wg_packet_purge_staged_packets(peer);
 
 	/* Free the memory used. */
diff --git a/drivers/net/wireguard/peer.h b/drivers/net/wireguard/peer.h
index 23af40922997..6d771fd9499d 100644
--- a/drivers/net/wireguard/peer.h
+++ b/drivers/net/wireguard/peer.h
@@ -66,8 +66,7 @@ struct wg_peer {
 	bool is_dead;
 };
 
-struct wg_peer *wg_peer_create(struct wg_device *wg,
-			       const u8 public_key[NOISE_PUBLIC_KEY_LEN],
+struct wg_peer *wg_peer_create(struct wg_device *wg, const u8 public_key[NOISE_PUBLIC_KEY_LEN],
 			       const u8 preshared_key[NOISE_SYMMETRIC_KEY_LEN]);
 
 struct wg_peer *__must_check wg_peer_get_maybe_zero(struct wg_peer *peer);
diff --git a/drivers/net/wireguard/peerlookup.c b/drivers/net/wireguard/peerlookup.c
index e4deb331476b..aa9fcd756e03 100644
--- a/drivers/net/wireguard/peerlookup.c
+++ b/drivers/net/wireguard/peerlookup.c
@@ -10,9 +10,8 @@
 static struct hlist_head *pubkey_bucket(struct pubkey_hashtable *table,
 					const u8 pubkey[NOISE_PUBLIC_KEY_LEN])
 {
-	/* siphash gives us a secure 64bit number based on a random key. Since
-	 * the bits are uniformly distributed, we can then mask off to get the
-	 * bits we need.
+	/* siphash gives us a secure 64bit number based on a random key. Since the bits are
+	 * uniformly distributed, we can then mask off to get the bits we need.
 	 */
 	const u64 hash = siphash(pubkey, NOISE_PUBLIC_KEY_LEN, &table->key);
 
@@ -32,17 +31,14 @@ struct pubkey_hashtable *wg_pubkey_hashtable_alloc(void)
 	return table;
 }
 
-void wg_pubkey_hashtable_add(struct pubkey_hashtable *table,
-			     struct wg_peer *peer)
+void wg_pubkey_hashtable_add(struct pubkey_hashtable *table, struct wg_peer *peer)
 {
 	mutex_lock(&table->lock);
-	hlist_add_head_rcu(&peer->pubkey_hash,
-			   pubkey_bucket(table, peer->handshake.remote_static));
+	hlist_add_head_rcu(&peer->pubkey_hash, pubkey_bucket(table, peer->handshake.remote_static));
 	mutex_unlock(&table->lock);
 }
 
-void wg_pubkey_hashtable_remove(struct pubkey_hashtable *table,
-				struct wg_peer *peer)
+void wg_pubkey_hashtable_remove(struct pubkey_hashtable *table, struct wg_peer *peer)
 {
 	mutex_lock(&table->lock);
 	hlist_del_init_rcu(&peer->pubkey_hash);
@@ -50,17 +46,14 @@ void wg_pubkey_hashtable_remove(struct pubkey_hashtable *table,
 }
 
 /* Returns a strong reference to a peer */
-struct wg_peer *
-wg_pubkey_hashtable_lookup(struct pubkey_hashtable *table,
-			   const u8 pubkey[NOISE_PUBLIC_KEY_LEN])
+struct wg_peer *wg_pubkey_hashtable_lookup(struct pubkey_hashtable *table,
+					   const u8 pubkey[NOISE_PUBLIC_KEY_LEN])
 {
 	struct wg_peer *iter_peer, *peer = NULL;
 
 	rcu_read_lock_bh();
-	hlist_for_each_entry_rcu_bh(iter_peer, pubkey_bucket(table, pubkey),
-				    pubkey_hash) {
-		if (!memcmp(pubkey, iter_peer->handshake.remote_static,
-			    NOISE_PUBLIC_KEY_LEN)) {
+	hlist_for_each_entry_rcu_bh(iter_peer, pubkey_bucket(table, pubkey), pubkey_hash) {
+		if (!memcmp(pubkey, iter_peer->handshake.remote_static, NOISE_PUBLIC_KEY_LEN)) {
 			peer = iter_peer;
 			break;
 		}
@@ -70,14 +63,12 @@ wg_pubkey_hashtable_lookup(struct pubkey_hashtable *table,
 	return peer;
 }
 
-static struct hlist_head *index_bucket(struct index_hashtable *table,
-				       const __le32 index)
+static struct hlist_head *index_bucket(struct index_hashtable *table, const __le32 index)
 {
-	/* Since the indices are random and thus all bits are uniformly
-	 * distributed, we can find its bucket simply by masking.
+	/* Since the indices are random and thus all bits are uniformly distributed, we can find its
+	 * bucket simply by masking.
 	 */
-	return &table->hashtable[(__force u32)index &
-				 (HASH_SIZE(table->hashtable) - 1)];
+	return &table->hashtable[(__force u32)index & (HASH_SIZE(table->hashtable) - 1)];
 }
 
 struct index_hashtable *wg_index_hashtable_alloc(void)
@@ -92,10 +83,9 @@ struct index_hashtable *wg_index_hashtable_alloc(void)
 	return table;
 }
 
-/* At the moment, we limit ourselves to 2^20 total peers, which generally might
- * amount to 2^20*3 items in this hashtable. The algorithm below works by
- * picking a random number and testing it. We can see that these limits mean we
- * usually succeed pretty quickly:
+/* At the moment, we limit ourselves to 2^20 total peers, which generally might amount to 2^20*3
+ * items in this hashtable. The algorithm below works by picking a random number and testing it. We
+ * can see that these limits mean we usually succeed pretty quickly:
  *
  * >>> def calculation(tries, size):
  * ...     return (size / 2**32)**(tries - 1) *  (1 - (size / 2**32))
@@ -109,15 +99,13 @@ struct index_hashtable *wg_index_hashtable_alloc(void)
  * >>> calculation(4, 2**20 * 3)
  * 3.9261394135792216e-10
  *
- * At the moment, we don't do any masking, so this algorithm isn't exactly
- * constant time in either the random guessing or in the hash list lookup. We
- * could require a minimum of 3 tries, which would successfully mask the
- * guessing. this would not, however, help with the growing hash lengths, which
- * is another thing to consider moving forward.
+ * At the moment, we don't do any masking, so this algorithm isn't exactly constant time in either
+ * the random guessing or in the hash list lookup. We could require a minimum of 3 tries, which
+ * would successfully mask the guessing. this would not, however, help with the growing hash
+ * lengths, which is another thing to consider moving forward.
  */
 
-__le32 wg_index_hashtable_insert(struct index_hashtable *table,
-				 struct index_hashtable_entry *entry)
+__le32 wg_index_hashtable_insert(struct index_hashtable *table, struct index_hashtable_entry *entry)
 {
 	struct index_hashtable_entry *existing_entry;
 
@@ -130,32 +118,25 @@ __le32 wg_index_hashtable_insert(struct index_hashtable *table,
 search_unused_slot:
 	/* First we try to find an unused slot, randomly, while unlocked. */
 	entry->index = (__force __le32)get_random_u32();
-	hlist_for_each_entry_rcu_bh(existing_entry,
-				    index_bucket(table, entry->index),
-				    index_hash) {
+	hlist_for_each_entry_rcu_bh(existing_entry, index_bucket(table, entry->index), index_hash) {
 		if (existing_entry->index == entry->index)
 			/* If it's already in use, we continue searching. */
 			goto search_unused_slot;
 	}
 
-	/* Once we've found an unused slot, we lock it, and then double-check
-	 * that nobody else stole it from us.
+	/* Once we've found an unused slot, we lock it, and then double-check that nobody else stole
+	 * it from us.
 	 */
 	spin_lock_bh(&table->lock);
-	hlist_for_each_entry_rcu_bh(existing_entry,
-				    index_bucket(table, entry->index),
-				    index_hash) {
+	hlist_for_each_entry_rcu_bh(existing_entry, index_bucket(table, entry->index), index_hash) {
 		if (existing_entry->index == entry->index) {
 			spin_unlock_bh(&table->lock);
 			/* If it was stolen, we start over. */
 			goto search_unused_slot;
 		}
 	}
-	/* Otherwise, we know we have it exclusively (since we're locked),
-	 * so we insert.
-	 */
-	hlist_add_head_rcu(&entry->index_hash,
-			   index_bucket(table, entry->index));
+	/* Otherwise, we know we have it exclusively (since we're locked), so we insert. */
+	hlist_add_head_rcu(&entry->index_hash, index_bucket(table, entry->index));
 	spin_unlock_bh(&table->lock);
 
 	rcu_read_unlock_bh();
@@ -163,8 +144,7 @@ __le32 wg_index_hashtable_insert(struct index_hashtable *table,
 	return entry->index;
 }
 
-bool wg_index_hashtable_replace(struct index_hashtable *table,
-				struct index_hashtable_entry *old,
+bool wg_index_hashtable_replace(struct index_hashtable *table, struct index_hashtable_entry *old,
 				struct index_hashtable_entry *new)
 {
 	if (unlikely(hlist_unhashed(&old->index_hash)))
@@ -173,10 +153,9 @@ bool wg_index_hashtable_replace(struct index_hashtable *table,
 	new->index = old->index;
 	hlist_replace_rcu(&old->index_hash, &new->index_hash);
 
-	/* Calling init here NULLs out index_hash, and in fact after this
-	 * function returns, it's theoretically possible for this to get
-	 * reinserted elsewhere. That means the RCU lookup below might either
-	 * terminate early or jump between buckets, in which case the packet
+	/* Calling init here NULLs out index_hash, and in fact after this function returns, it's
+	 * theoretically possible for this to get reinserted elsewhere. That means the RCU lookup
+	 * below might either terminate early or jump between buckets, in which case the packet
 	 * simply gets dropped, which isn't terrible.
 	 */
 	INIT_HLIST_NODE(&old->index_hash);
@@ -184,8 +163,7 @@ bool wg_index_hashtable_replace(struct index_hashtable *table,
 	return true;
 }
 
-void wg_index_hashtable_remove(struct index_hashtable *table,
-			       struct index_hashtable_entry *entry)
+void wg_index_hashtable_remove(struct index_hashtable *table, struct index_hashtable_entry *entry)
 {
 	spin_lock_bh(&table->lock);
 	hlist_del_init_rcu(&entry->index_hash);
@@ -193,16 +171,14 @@ void wg_index_hashtable_remove(struct index_hashtable *table,
 }
 
 /* Returns a strong reference to a entry->peer */
-struct index_hashtable_entry *
-wg_index_hashtable_lookup(struct index_hashtable *table,
-			  const enum index_hashtable_type type_mask,
-			  const __le32 index, struct wg_peer **peer)
+struct index_hashtable_entry *wg_index_hashtable_lookup(struct index_hashtable *table,
+							const enum index_hashtable_type type_mask,
+							const __le32 index, struct wg_peer **peer)
 {
 	struct index_hashtable_entry *iter_entry, *entry = NULL;
 
 	rcu_read_lock_bh();
-	hlist_for_each_entry_rcu_bh(iter_entry, index_bucket(table, index),
-				    index_hash) {
+	hlist_for_each_entry_rcu_bh(iter_entry, index_bucket(table, index), index_hash) {
 		if (iter_entry->index == index) {
 			if (likely(iter_entry->type & type_mask))
 				entry = iter_entry;
diff --git a/drivers/net/wireguard/peerlookup.h b/drivers/net/wireguard/peerlookup.h
index ced811797680..e17969c487d7 100644
--- a/drivers/net/wireguard/peerlookup.h
+++ b/drivers/net/wireguard/peerlookup.h
@@ -22,13 +22,10 @@ struct pubkey_hashtable {
 };
 
 struct pubkey_hashtable *wg_pubkey_hashtable_alloc(void);
-void wg_pubkey_hashtable_add(struct pubkey_hashtable *table,
-			     struct wg_peer *peer);
-void wg_pubkey_hashtable_remove(struct pubkey_hashtable *table,
-				struct wg_peer *peer);
-struct wg_peer *
-wg_pubkey_hashtable_lookup(struct pubkey_hashtable *table,
-			   const u8 pubkey[NOISE_PUBLIC_KEY_LEN]);
+void wg_pubkey_hashtable_add(struct pubkey_hashtable *table, struct wg_peer *peer);
+void wg_pubkey_hashtable_remove(struct pubkey_hashtable *table, struct wg_peer *peer);
+struct wg_peer *wg_pubkey_hashtable_lookup(struct pubkey_hashtable *table,
+					   const u8 pubkey[NOISE_PUBLIC_KEY_LEN]);
 
 struct index_hashtable {
 	/* TODO: move to rhashtable */
@@ -49,16 +46,12 @@ struct index_hashtable_entry {
 };
 
 struct index_hashtable *wg_index_hashtable_alloc(void);
-__le32 wg_index_hashtable_insert(struct index_hashtable *table,
-				 struct index_hashtable_entry *entry);
-bool wg_index_hashtable_replace(struct index_hashtable *table,
-				struct index_hashtable_entry *old,
+__le32 wg_index_hashtable_insert(struct index_hashtable *table, struct index_hashtable_entry *entry);
+bool wg_index_hashtable_replace(struct index_hashtable *table, struct index_hashtable_entry *old,
 				struct index_hashtable_entry *new);
-void wg_index_hashtable_remove(struct index_hashtable *table,
-			       struct index_hashtable_entry *entry);
-struct index_hashtable_entry *
-wg_index_hashtable_lookup(struct index_hashtable *table,
-			  const enum index_hashtable_type type_mask,
-			  const __le32 index, struct wg_peer **peer);
+void wg_index_hashtable_remove(struct index_hashtable *table, struct index_hashtable_entry *entry);
+struct index_hashtable_entry *wg_index_hashtable_lookup(struct index_hashtable *table,
+							const enum index_hashtable_type type_mask,
+							const __le32 index, struct wg_peer **peer);
 
 #endif /* _WG_PEERLOOKUP_H */
diff --git a/drivers/net/wireguard/queueing.c b/drivers/net/wireguard/queueing.c
index 71b8e80b58e1..42ffc4d6f501 100644
--- a/drivers/net/wireguard/queueing.c
+++ b/drivers/net/wireguard/queueing.c
@@ -5,12 +5,11 @@
 
 #include "queueing.h"
 
-struct multicore_worker __percpu *
-wg_packet_percpu_multicore_worker_alloc(work_func_t function, void *ptr)
+struct multicore_worker __percpu *wg_packet_percpu_multicore_worker_alloc(work_func_t function,
+									  void *ptr)
 {
 	int cpu;
-	struct multicore_worker __percpu *worker =
-		alloc_percpu(struct multicore_worker);
+	struct multicore_worker __percpu *worker = alloc_percpu(struct multicore_worker);
 
 	if (!worker)
 		return NULL;
@@ -22,8 +21,8 @@ wg_packet_percpu_multicore_worker_alloc(work_func_t function, void *ptr)
 	return worker;
 }
 
-int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function,
-			 bool multicore, unsigned int len)
+int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function, bool multicore,
+			 unsigned int len)
 {
 	int ret;
 
@@ -33,8 +32,7 @@ int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function,
 		return ret;
 	if (function) {
 		if (multicore) {
-			queue->worker = wg_packet_percpu_multicore_worker_alloc(
-				function, queue);
+			queue->worker = wg_packet_percpu_multicore_worker_alloc(function, queue);
 			if (!queue->worker) {
 				ptr_ring_cleanup(&queue->ring, NULL);
 				return -ENOMEM;
diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index c58df439dbbe..305776e0d335 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -19,11 +19,11 @@ struct crypt_queue;
 struct sk_buff;
 
 /* queueing.c APIs: */
-int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function,
-			 bool multicore, unsigned int len);
+int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function, bool multicore,
+			 unsigned int len);
 void wg_packet_queue_free(struct crypt_queue *queue, bool multicore);
-struct multicore_worker __percpu *
-wg_packet_percpu_multicore_worker_alloc(work_func_t function, void *ptr);
+struct multicore_worker __percpu *wg_packet_percpu_multicore_worker_alloc(work_func_t function,
+									  void *ptr);
 
 /* receive.c APIs: */
 void wg_packet_receive(struct wg_device *wg, struct sk_buff *skb);
@@ -34,11 +34,9 @@ int wg_packet_rx_poll(struct napi_struct *napi, int budget);
 void wg_packet_decrypt_worker(struct work_struct *work);
 
 /* send.c APIs: */
-void wg_packet_send_queued_handshake_initiation(struct wg_peer *peer,
-						bool is_retry);
+void wg_packet_send_queued_handshake_initiation(struct wg_peer *peer, bool is_retry);
 void wg_packet_send_handshake_response(struct wg_peer *peer);
-void wg_packet_send_handshake_cookie(struct wg_device *wg,
-				     struct sk_buff *initiating_skb,
+void wg_packet_send_handshake_cookie(struct wg_device *wg, struct sk_buff *initiating_skb,
 				     __le32 sender_index);
 void wg_packet_send_keepalive(struct wg_peer *peer);
 void wg_packet_purge_staged_packets(struct wg_peer *peer);
@@ -69,13 +67,11 @@ struct packet_cb {
 static inline __be16 wg_examine_packet_protocol(struct sk_buff *skb)
 {
 	if (skb_network_header(skb) >= skb->head &&
-	    (skb_network_header(skb) + sizeof(struct iphdr)) <=
-		    skb_tail_pointer(skb) &&
+	    (skb_network_header(skb) + sizeof(struct iphdr)) <= skb_tail_pointer(skb) &&
 	    ip_hdr(skb)->version == 4)
 		return htons(ETH_P_IP);
 	if (skb_network_header(skb) >= skb->head &&
-	    (skb_network_header(skb) + sizeof(struct ipv6hdr)) <=
-		    skb_tail_pointer(skb) &&
+	    (skb_network_header(skb) + sizeof(struct ipv6hdr)) <= skb_tail_pointer(skb) &&
 	    ipv6_hdr(skb)->version == 6)
 		return htons(ETH_P_IPV6);
 	return 0;
@@ -93,9 +89,8 @@ static inline void wg_reset_packet(struct sk_buff *skb, bool encapsulating)
 	u8 sw_hash = skb->sw_hash;
 	u32 hash = skb->hash;
 	skb_scrub_packet(skb, true);
-	memset(&skb->headers_start, 0,
-	       offsetof(struct sk_buff, headers_end) -
-		       offsetof(struct sk_buff, headers_start));
+	memset(&skb->headers_start, 0, offsetof(struct sk_buff, headers_end) -
+				       offsetof(struct sk_buff, headers_start));
 	if (encapsulating) {
 		skb->l4_hash = l4_hash;
 		skb->sw_hash = sw_hash;
@@ -122,8 +117,7 @@ static inline int wg_cpumask_choose_online(int *stored_cpu, unsigned int id)
 {
 	unsigned int cpu = *stored_cpu, cpu_index, i;
 
-	if (unlikely(cpu == nr_cpumask_bits ||
-		     !cpumask_test_cpu(cpu, cpu_online_mask))) {
+	if (unlikely(cpu == nr_cpumask_bits || !cpumask_test_cpu(cpu, cpu_online_mask))) {
 		cpu_index = id % cpumask_weight(cpu_online_mask);
 		cpu = cpumask_first(cpu_online_mask);
 		for (i = 0; i < cpu_index; ++i)
@@ -133,11 +127,10 @@ static inline int wg_cpumask_choose_online(int *stored_cpu, unsigned int id)
 	return cpu;
 }
 
-/* This function is racy, in the sense that next is unlocked, so it could return
- * the same CPU twice. A race-free version of this would be to instead store an
- * atomic sequence number, do an increment-and-return, and then iterate through
- * every possible CPU until we get to that index -- choose_cpu. However that's
- * a bit slower, and it doesn't seem like this potential race actually
+/* This function is racy, in the sense that next is unlocked, so it could return the same CPU twice.
+ * A race-free version of this would be to instead store an atomic sequence number, do an
+ * increment-and-return, and then iterate through every possible CPU until we get to that index --
+ * choose_cpu. However that's a bit slower, and it doesn't seem like this potential race actually
  * introduces any performance loss, so we live with it.
  */
 static inline int wg_cpumask_next_online(int *next)
@@ -151,20 +144,18 @@ static inline int wg_cpumask_next_online(int *next)
 }
 
 static inline int wg_queue_enqueue_per_device_and_peer(
-	struct crypt_queue *device_queue, struct crypt_queue *peer_queue,
-	struct sk_buff *skb, struct workqueue_struct *wq, int *next_cpu)
+	struct crypt_queue *device_queue, struct crypt_queue *peer_queue, struct sk_buff *skb,
+	struct workqueue_struct *wq, int *next_cpu)
 {
 	int cpu;
 
 	atomic_set_release(&PACKET_CB(skb)->state, PACKET_STATE_UNCRYPTED);
-	/* We first queue this up for the peer ingestion, but the consumer
-	 * will wait for the state to change to CRYPTED or DEAD before.
+	/* We first queue this up for the peer ingestion, but the consumer will wait for the state
+	 * to change to CRYPTED or DEAD before.
 	 */
 	if (unlikely(ptr_ring_produce_bh(&peer_queue->ring, skb)))
 		return -ENOSPC;
-	/* Then we queue it up in the device queue, which consumes the
-	 * packet as soon as it can.
-	 */
+	/* Then we queue it up in the device queue, which consumes the packet as soon as it can. */
 	cpu = wg_cpumask_next_online(next_cpu);
 	if (unlikely(ptr_ring_produce_bh(&device_queue->ring, skb)))
 		return -EPIPE;
@@ -172,27 +163,24 @@ static inline int wg_queue_enqueue_per_device_and_peer(
 	return 0;
 }
 
-static inline void wg_queue_enqueue_per_peer(struct crypt_queue *queue,
-					     struct sk_buff *skb,
+static inline void wg_queue_enqueue_per_peer(struct crypt_queue *queue, struct sk_buff *skb,
 					     enum packet_state state)
 {
-	/* We take a reference, because as soon as we call atomic_set, the
-	 * peer can be freed from below us.
+	/* We take a reference, because as soon as we call atomic_set, the peer can be freed from
+	 * below us.
 	 */
 	struct wg_peer *peer = wg_peer_get(PACKET_PEER(skb));
 
 	atomic_set_release(&PACKET_CB(skb)->state, state);
-	queue_work_on(wg_cpumask_choose_online(&peer->serial_work_cpu,
-					       peer->internal_id),
+	queue_work_on(wg_cpumask_choose_online(&peer->serial_work_cpu, peer->internal_id),
 		      peer->device->packet_crypt_wq, &queue->work);
 	wg_peer_put(peer);
 }
 
-static inline void wg_queue_enqueue_per_peer_napi(struct sk_buff *skb,
-						  enum packet_state state)
+static inline void wg_queue_enqueue_per_peer_napi(struct sk_buff *skb, enum packet_state state)
 {
-	/* We take a reference, because as soon as we call atomic_set, the
-	 * peer can be freed from below us.
+	/* We take a reference, because as soon as we call atomic_set, the peer can be freed from
+	 * below us.
 	 */
 	struct wg_peer *peer = wg_peer_get(PACKET_PEER(skb));
 
diff --git a/drivers/net/wireguard/ratelimiter.c b/drivers/net/wireguard/ratelimiter.c
index 3fedd1d21f5e..9398cd5ef5c9 100644
--- a/drivers/net/wireguard/ratelimiter.c
+++ b/drivers/net/wireguard/ratelimiter.c
@@ -40,8 +40,7 @@ enum {
 
 static void entry_free(struct rcu_head *rcu)
 {
-	kmem_cache_free(entry_cache,
-			container_of(rcu, struct ratelimiter_entry, rcu));
+	kmem_cache_free(entry_cache, container_of(rcu, struct ratelimiter_entry, rcu));
 	atomic_dec(&total_entries);
 }
 
@@ -62,14 +61,12 @@ static void wg_ratelimiter_gc_entries(struct work_struct *work)
 	for (i = 0; i < table_size; ++i) {
 		spin_lock(&table_lock);
 		hlist_for_each_entry_safe(entry, temp, &table_v4[i], hash) {
-			if (unlikely(!work) ||
-			    now - entry->last_time_ns > NSEC_PER_SEC)
+			if (unlikely(!work) || now - entry->last_time_ns > NSEC_PER_SEC)
 				entry_uninit(entry);
 		}
 #if IS_ENABLED(CONFIG_IPV6)
 		hlist_for_each_entry_safe(entry, temp, &table_v6[i], hash) {
-			if (unlikely(!work) ||
-			    now - entry->last_time_ns > NSEC_PER_SEC)
+			if (unlikely(!work) || now - entry->last_time_ns > NSEC_PER_SEC)
 				entry_uninit(entry);
 		}
 #endif
@@ -83,9 +80,8 @@ static void wg_ratelimiter_gc_entries(struct work_struct *work)
 
 bool wg_ratelimiter_allow(struct sk_buff *skb, struct net *net)
 {
-	/* We only take the bottom half of the net pointer, so that we can hash
-	 * 3 words in the end. This way, siphash's len param fits into the final
-	 * u32, and we don't incur an extra round.
+	/* We only take the bottom half of the net pointer, so that we can hash 3 words in the end.
+	 * This way, siphash's len param fits into the final u32, and we don't incur an extra round.
 	 */
 	const u32 net_word = (unsigned long)net;
 	struct ratelimiter_entry *entry;
@@ -94,15 +90,13 @@ bool wg_ratelimiter_allow(struct sk_buff *skb, struct net *net)
 
 	if (skb->protocol == htons(ETH_P_IP)) {
 		ip = (u64 __force)ip_hdr(skb)->saddr;
-		bucket = &table_v4[hsiphash_2u32(net_word, ip, &key) &
-				   (table_size - 1)];
+		bucket = &table_v4[hsiphash_2u32(net_word, ip, &key) & (table_size - 1)];
 	}
 #if IS_ENABLED(CONFIG_IPV6)
 	else if (skb->protocol == htons(ETH_P_IPV6)) {
 		/* Only use 64 bits, so as to ratelimit the whole /64. */
 		memcpy(&ip, &ipv6_hdr(skb)->saddr, sizeof(ip));
-		bucket = &table_v6[hsiphash_3u32(net_word, ip >> 32, ip, &key) &
-				   (table_size - 1)];
+		bucket = &table_v6[hsiphash_3u32(net_word, ip >> 32, ip, &key) & (table_size - 1)];
 	}
 #endif
 	else
@@ -112,16 +106,13 @@ bool wg_ratelimiter_allow(struct sk_buff *skb, struct net *net)
 		if (entry->net == net && entry->ip == ip) {
 			u64 now, tokens;
 			bool ret;
-			/* Quasi-inspired by nft_limit.c, but this is actually a
-			 * slightly different algorithm. Namely, we incorporate
-			 * the burst as part of the maximum tokens, rather than
-			 * as part of the rate.
+			/* Quasi-inspired by nft_limit.c, but this is actually a slightly different
+			 * algorithm. Namely, we incorporate the burst as part of the maximum
+			 * tokens, rather than as part of the rate.
 			 */
 			spin_lock(&entry->lock);
 			now = ktime_get_coarse_boottime_ns();
-			tokens = min_t(u64, TOKEN_MAX,
-				       entry->tokens + now -
-					       entry->last_time_ns);
+			tokens = min_t(u64, TOKEN_MAX, entry->tokens + now - entry->last_time_ns);
 			entry->last_time_ns = now;
 			ret = tokens >= PACKET_COST;
 			entry->tokens = ret ? tokens - PACKET_COST : tokens;
@@ -165,10 +156,10 @@ int wg_ratelimiter_init(void)
 	if (!entry_cache)
 		goto err;
 
-	/* xt_hashlimit.c uses a slightly different algorithm for ratelimiting,
-	 * but what it shares in common is that it uses a massive hashtable. So,
-	 * we borrow their wisdom about good table sizes on different systems
-	 * dependent on RAM. This calculation here comes from there.
+	/* xt_hashlimit.c uses a slightly different algorithm for ratelimiting, but what it shares
+	 * in common is that it uses a massive hashtable. So, we borrow their wisdom about good
+	 * table sizes on different systems dependent on RAM. This calculation here comes from
+	 * there.
 	 */
 	table_size = (totalram_pages() > (1U << 30) / PAGE_SIZE) ? 8192 :
 		max_t(unsigned long, 16, roundup_pow_of_two(
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 91438144e4f7..de70e2dee610 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -19,8 +19,7 @@
 /* Must be called with bh disabled. */
 static void update_rx_stats(struct wg_peer *peer, size_t len)
 {
-	struct pcpu_sw_netstats *tstats =
-		get_cpu_ptr(peer->device->dev->tstats);
+	struct pcpu_sw_netstats *tstats = get_cpu_ptr(peer->device->dev->tstats);
 
 	u64_stats_update_begin(&tstats->syncp);
 	++tstats->rx_packets;
@@ -36,8 +35,7 @@ static size_t validate_header_len(struct sk_buff *skb)
 {
 	if (unlikely(skb->len < sizeof(struct message_header)))
 		return 0;
-	if (SKB_TYPE_LE32(skb) == cpu_to_le32(MESSAGE_DATA) &&
-	    skb->len >= MESSAGE_MINIMUM_LENGTH)
+	if (SKB_TYPE_LE32(skb) == cpu_to_le32(MESSAGE_DATA) && skb->len >= MESSAGE_MINIMUM_LENGTH)
 		return sizeof(struct message_data);
 	if (SKB_TYPE_LE32(skb) == cpu_to_le32(MESSAGE_HANDSHAKE_INITIATION) &&
 	    skb->len == sizeof(struct message_handshake_initiation))
@@ -56,36 +54,26 @@ static int prepare_skb_header(struct sk_buff *skb, struct wg_device *wg)
 	size_t data_offset, data_len, header_len;
 	struct udphdr *udp;
 
-	if (unlikely(!wg_check_packet_protocol(skb) ||
-		     skb_transport_header(skb) < skb->head ||
-		     (skb_transport_header(skb) + sizeof(struct udphdr)) >
-			     skb_tail_pointer(skb)))
-		return -EINVAL; /* Bogus IP header */
+	if (unlikely(!wg_check_packet_protocol(skb) || skb_transport_header(skb) < skb->head ||
+		     (skb_transport_header(skb) + sizeof(struct udphdr)) > skb_tail_pointer(skb)))
+		return -EINVAL; /* Bogus IP header. */
 	udp = udp_hdr(skb);
 	data_offset = (u8 *)udp - skb->data;
-	if (unlikely(data_offset > U16_MAX ||
-		     data_offset + sizeof(struct udphdr) > skb->len))
-		/* Packet has offset at impossible location or isn't big enough
-		 * to have UDP fields.
-		 */
+	if (unlikely(data_offset > U16_MAX || data_offset + sizeof(struct udphdr) > skb->len))
+		/* Packet has offset at impossible location or isn't big enough to have UDP fields. */
 		return -EINVAL;
 	data_len = ntohs(udp->len);
-	if (unlikely(data_len < sizeof(struct udphdr) ||
-		     data_len > skb->len - data_offset))
-		/* UDP packet is reporting too small of a size or lying about
-		 * its size.
-		 */
+	if (unlikely(data_len < sizeof(struct udphdr) || data_len > skb->len - data_offset))
+		/* UDP packet is reporting too small of a size or lying about its size. */
 		return -EINVAL;
 	data_len -= sizeof(struct udphdr);
 	data_offset = (u8 *)udp + sizeof(struct udphdr) - skb->data;
-	if (unlikely(!pskb_may_pull(skb,
-				data_offset + sizeof(struct message_header)) ||
+	if (unlikely(!pskb_may_pull(skb, data_offset + sizeof(struct message_header)) ||
 		     pskb_trim(skb, data_len + data_offset) < 0))
 		return -EINVAL;
 	skb_pull(skb, data_offset);
 	if (unlikely(skb->len != data_len))
-		/* Final len does not agree with calculated len */
-		return -EINVAL;
+		return -EINVAL; /* Final len does not agree with calculated len. */
 	header_len = validate_header_len(skb);
 	if (unlikely(!header_len))
 		return -EINVAL;
@@ -101,8 +89,8 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 {
 	enum cookie_mac_state mac_state;
 	struct wg_peer *peer = NULL;
-	/* This is global, so that our load calculation applies to the whole
-	 * system. We don't care about races with it at all.
+	/* This is global, so that our load calculation applies to the whole system. We don't care
+	 * about races with it at all.
 	 */
 	static u64 last_under_load;
 	bool packet_needs_cookie;
@@ -111,13 +99,11 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 	if (SKB_TYPE_LE32(skb) == cpu_to_le32(MESSAGE_HANDSHAKE_COOKIE)) {
 		net_dbg_skb_ratelimited("%s: Receiving cookie response from %pISpfsc\n",
 					wg->dev->name, skb);
-		wg_cookie_message_consume(
-			(struct message_handshake_cookie *)skb->data, wg);
+		wg_cookie_message_consume((struct message_handshake_cookie *)skb->data, wg);
 		return;
 	}
 
-	under_load = skb_queue_len(&wg->incoming_handshakes) >=
-		     MAX_QUEUED_INCOMING_HANDSHAKES / 8;
+	under_load = skb_queue_len(&wg->incoming_handshakes) >= MAX_QUEUED_INCOMING_HANDSHAKES / 8;
 	if (under_load) {
 		last_under_load = ktime_get_coarse_boottime_ns();
 	} else if (last_under_load) {
@@ -125,8 +111,7 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 		if (!under_load)
 			last_under_load = 0;
 	}
-	mac_state = wg_cookie_validate_packet(&wg->cookie_checker, skb,
-					      under_load);
+	mac_state = wg_cookie_validate_packet(&wg->cookie_checker, skb, under_load);
 	if ((under_load && mac_state == VALID_MAC_WITH_COOKIE) ||
 	    (!under_load && mac_state == VALID_MAC_BUT_NO_COOKIE)) {
 		packet_needs_cookie = false;
@@ -144,8 +129,7 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 			(struct message_handshake_initiation *)skb->data;
 
 		if (packet_needs_cookie) {
-			wg_packet_send_handshake_cookie(wg, skb,
-							message->sender_index);
+			wg_packet_send_handshake_cookie(wg, skb, message->sender_index);
 			return;
 		}
 		peer = wg_noise_handshake_consume_initiation(message, wg);
@@ -156,8 +140,7 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 		}
 		wg_socket_set_peer_endpoint_from_skb(peer, skb);
 		net_dbg_ratelimited("%s: Receiving handshake initiation from peer %llu (%pISpfsc)\n",
-				    wg->dev->name, peer->internal_id,
-				    &peer->endpoint.addr);
+				    wg->dev->name, peer->internal_id, &peer->endpoint.addr);
 		wg_packet_send_handshake_response(peer);
 		break;
 	}
@@ -166,8 +149,7 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 			(struct message_handshake_response *)skb->data;
 
 		if (packet_needs_cookie) {
-			wg_packet_send_handshake_cookie(wg, skb,
-							message->sender_index);
+			wg_packet_send_handshake_cookie(wg, skb, message->sender_index);
 			return;
 		}
 		peer = wg_noise_handshake_consume_response(message, wg);
@@ -178,17 +160,14 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 		}
 		wg_socket_set_peer_endpoint_from_skb(peer, skb);
 		net_dbg_ratelimited("%s: Receiving handshake response from peer %llu (%pISpfsc)\n",
-				    wg->dev->name, peer->internal_id,
-				    &peer->endpoint.addr);
-		if (wg_noise_handshake_begin_session(&peer->handshake,
-						     &peer->keypairs)) {
+				    wg->dev->name, peer->internal_id, &peer->endpoint.addr);
+		if (wg_noise_handshake_begin_session(&peer->handshake, &peer->keypairs)) {
 			wg_timers_session_derived(peer);
 			wg_timers_handshake_complete(peer);
-			/* Calling this function will either send any existing
-			 * packets in the queue and not send a keepalive, which
-			 * is the best case, Or, if there's nothing in the
-			 * queue, it will send a keepalive, in order to give
-			 * immediate confirmation of the session.
+			/* Calling this function will either send any existing packets in the queue
+			 * and not send a keepalive, which is the best case, Or, if there's nothing
+			 * in the queue, it will send a keepalive, in order to give immediate
+			 * confirmation of the session.
 			 */
 			wg_packet_send_keepalive(peer);
 		}
@@ -212,8 +191,7 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 
 void wg_packet_handshake_receive_worker(struct work_struct *work)
 {
-	struct wg_device *wg = container_of(work, struct multicore_worker,
-					    work)->ptr;
+	struct wg_device *wg = container_of(work, struct multicore_worker, work)->ptr;
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&wg->incoming_handshakes)) != NULL) {
@@ -233,10 +211,9 @@ static void keep_key_fresh(struct wg_peer *peer)
 
 	rcu_read_lock_bh();
 	keypair = rcu_dereference_bh(peer->keypairs.current_keypair);
-	send = keypair && READ_ONCE(keypair->sending.is_valid) &&
-	       keypair->i_am_the_initiator &&
+	send = keypair && READ_ONCE(keypair->sending.is_valid) && keypair->i_am_the_initiator &&
 	       wg_birthdate_has_expired(keypair->sending.birthdate,
-			REJECT_AFTER_TIME - KEEPALIVE_TIMEOUT - REKEY_TIMEOUT);
+					REJECT_AFTER_TIME - KEEPALIVE_TIMEOUT - REKEY_TIMEOUT);
 	rcu_read_unlock_bh();
 
 	if (unlikely(send)) {
@@ -262,12 +239,11 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 		return false;
 	}
 
-	PACKET_CB(skb)->nonce =
-		le64_to_cpu(((struct message_data *)skb->data)->counter);
+	PACKET_CB(skb)->nonce = le64_to_cpu(((struct message_data *)skb->data)->counter);
 
-	/* We ensure that the network header is part of the packet before we
-	 * call skb_cow_data, so that there's no chance that data is removed
-	 * from the skb, so that later we can extract the original endpoint.
+	/* We ensure that the network header is part of the packet before we call skb_cow_data, so
+	 * that there's no chance that data is removed from the skb, so that later we can extract
+	 * the original endpoint.
 	 */
 	offset = skb->data - skb_network_header(skb);
 	skb_push(skb, offset);
@@ -281,13 +257,12 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 	if (skb_to_sgvec(skb, sg, 0, skb->len) <= 0)
 		return false;
 
-	if (!chacha20poly1305_decrypt_sg_inplace(sg, skb->len, NULL, 0,
-					         PACKET_CB(skb)->nonce,
+	if (!chacha20poly1305_decrypt_sg_inplace(sg, skb->len, NULL, 0, PACKET_CB(skb)->nonce,
 						 keypair->receiving.key))
 		return false;
 
-	/* Another ugly situation of pushing and pulling the header so as to
-	 * keep endpoint information intact.
+	/* Another ugly situation of pushing and pulling the header so as to keep endpoint
+	 * information intact.
 	 */
 	skb_push(skb, offset);
 	if (pskb_trim(skb, skb->len - noise_encrypted_len(0)))
@@ -311,16 +286,14 @@ static bool counter_validate(struct noise_replay_counter *counter, u64 their_cou
 
 	++their_counter;
 
-	if (unlikely((COUNTER_WINDOW_SIZE + their_counter) <
-		     counter->counter))
+	if (unlikely((COUNTER_WINDOW_SIZE + their_counter) < counter->counter))
 		goto out;
 
 	index = their_counter >> ilog2(BITS_PER_LONG);
 
 	if (likely(their_counter > counter->counter)) {
 		index_current = counter->counter >> ilog2(BITS_PER_LONG);
-		top = min_t(unsigned long, index - index_current,
-			    COUNTER_BITS_TOTAL / BITS_PER_LONG);
+		top = min_t(unsigned long, index - index_current, COUNTER_BITS_TOTAL / BITS_PER_LONG);
 		for (i = 1; i <= top; ++i)
 			counter->backtrack[(i + index_current) &
 				((COUNTER_BITS_TOTAL / BITS_PER_LONG) - 1)] = 0;
@@ -328,8 +301,7 @@ static bool counter_validate(struct noise_replay_counter *counter, u64 their_cou
 	}
 
 	index &= (COUNTER_BITS_TOTAL / BITS_PER_LONG) - 1;
-	ret = !test_and_set_bit(their_counter & (BITS_PER_LONG - 1),
-				&counter->backtrack[index]);
+	ret = !test_and_set_bit(their_counter & (BITS_PER_LONG - 1), &counter->backtrack[index]);
 
 out:
 	spin_unlock_bh(&counter->lock);
@@ -338,8 +310,7 @@ static bool counter_validate(struct noise_replay_counter *counter, u64 their_cou
 
 #include "selftest/counter.c"
 
-static void wg_packet_consume_data_done(struct wg_peer *peer,
-					struct sk_buff *skb,
+static void wg_packet_consume_data_done(struct wg_peer *peer, struct sk_buff *skb,
 					struct endpoint *endpoint)
 {
 	struct net_device *dev = peer->device->dev;
@@ -348,8 +319,7 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 
 	wg_socket_set_peer_endpoint(peer, endpoint);
 
-	if (unlikely(wg_noise_received_with_keypair(&peer->keypairs,
-						    PACKET_CB(skb)->keypair))) {
+	if (unlikely(wg_noise_received_with_keypair(&peer->keypairs, PACKET_CB(skb)->keypair))) {
 		wg_timers_handshake_complete(peer);
 		wg_packet_send_staged_packets(peer);
 	}
@@ -379,11 +349,10 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 		goto dishonest_packet_type;
 
 	skb->dev = dev;
-	/* We've already verified the Poly1305 auth tag, which means this packet
-	 * was not modified in transit. We can therefore tell the networking
-	 * stack that all checksums of every layer of encapsulation have already
-	 * been checked "by the hardware" and therefore is unnecessary to check
-	 * again in software.
+	/* We've already verified the Poly1305 auth tag, which means this packet was not modified in
+	 * transit. We can therefore tell the networking stack that all checksums of every layer of
+	 * encapsulation have already been checked "by the hardware" and therefore is unnecessary to
+	 * check again in software.
 	 */
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	skb->csum_level = ~0; /* All levels */
@@ -394,8 +363,7 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 			goto dishonest_packet_size;
 		INET_ECN_decapsulate(skb, PACKET_CB(skb)->ds, ip_hdr(skb)->tos);
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
-		len = ntohs(ipv6_hdr(skb)->payload_len) +
-		      sizeof(struct ipv6hdr);
+		len = ntohs(ipv6_hdr(skb)->payload_len) + sizeof(struct ipv6hdr);
 		INET_ECN_decapsulate(skb, PACKET_CB(skb)->ds, ipv6_get_dsfield(ipv6_hdr(skb)));
 	} else {
 		goto dishonest_packet_type;
@@ -407,8 +375,7 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 	if (unlikely(pskb_trim(skb, len)))
 		goto packet_processed;
 
-	routed_peer = wg_allowedips_lookup_src(&peer->device->peer_allowedips,
-					       skb);
+	routed_peer = wg_allowedips_lookup_src(&peer->device->peer_allowedips, skb);
 	wg_peer_put(routed_peer); /* We don't need the extra reference. */
 
 	if (unlikely(routed_peer != peer))
@@ -417,8 +384,7 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 	if (unlikely(napi_gro_receive(&peer->napi, skb) == GRO_DROP)) {
 		++dev->stats.rx_dropped;
 		net_dbg_ratelimited("%s: Failed to give packet to userspace from peer %llu (%pISpfsc)\n",
-				    dev->name, peer->internal_id,
-				    &peer->endpoint.addr);
+				    dev->name, peer->internal_id, &peer->endpoint.addr);
 	} else {
 		update_rx_stats(peer, message_data_len(len_before_trim));
 	}
@@ -426,8 +392,7 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 
 dishonest_packet_peer:
 	net_dbg_skb_ratelimited("%s: Packet has unallowed src IP (%pISc) from peer %llu (%pISpfsc)\n",
-				dev->name, skb, peer->internal_id,
-				&peer->endpoint.addr);
+				dev->name, skb, peer->internal_id, &peer->endpoint.addr);
 	++dev->stats.rx_errors;
 	++dev->stats.rx_frame_errors;
 	goto packet_processed;
@@ -462,8 +427,7 @@ int wg_packet_rx_poll(struct napi_struct *napi, int budget)
 		return 0;
 
 	while ((skb = __ptr_ring_peek(&queue->ring)) != NULL &&
-	       (state = atomic_read_acquire(&PACKET_CB(skb)->state)) !=
-		       PACKET_STATE_UNCRYPTED) {
+	       (state = atomic_read_acquire(&PACKET_CB(skb)->state)) != PACKET_STATE_UNCRYPTED) {
 		__ptr_ring_discard_one(&queue->ring);
 		peer = PACKET_PEER(skb);
 		keypair = PACKET_CB(skb)->keypair;
@@ -472,11 +436,9 @@ int wg_packet_rx_poll(struct napi_struct *napi, int budget)
 		if (unlikely(state != PACKET_STATE_CRYPTED))
 			goto next;
 
-		if (unlikely(!counter_validate(&keypair->receiving_counter,
-					       PACKET_CB(skb)->nonce))) {
+		if (unlikely(!counter_validate(&keypair->receiving_counter, PACKET_CB(skb)->nonce))) {
 			net_dbg_ratelimited("%s: Packet has invalid nonce %llu (max %llu)\n",
-					    peer->device->dev->name,
-					    PACKET_CB(skb)->nonce,
+					    peer->device->dev->name, PACKET_CB(skb)->nonce,
 					    keypair->receiving_counter.counter);
 			goto next;
 		}
@@ -511,9 +473,8 @@ void wg_packet_decrypt_worker(struct work_struct *work)
 	struct sk_buff *skb;
 
 	while ((skb = ptr_ring_consume_bh(&queue->ring)) != NULL) {
-		enum packet_state state =
-			likely(decrypt_packet(skb, PACKET_CB(skb)->keypair)) ?
-				PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
+		enum packet_state state = likely(decrypt_packet(skb, PACKET_CB(skb)->keypair)) ?
+							PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
 		wg_queue_enqueue_per_peer_napi(skb, state);
 		if (need_resched())
 			cond_resched();
@@ -527,20 +488,16 @@ static void wg_packet_consume_data(struct wg_device *wg, struct sk_buff *skb)
 	int ret;
 
 	rcu_read_lock_bh();
-	PACKET_CB(skb)->keypair =
-		(struct noise_keypair *)wg_index_hashtable_lookup(
-			wg->index_hashtable, INDEX_HASHTABLE_KEYPAIR, idx,
-			&peer);
+	PACKET_CB(skb)->keypair = (struct noise_keypair *)wg_index_hashtable_lookup(
+					wg->index_hashtable, INDEX_HASHTABLE_KEYPAIR, idx, &peer);
 	if (unlikely(!wg_noise_keypair_get(PACKET_CB(skb)->keypair)))
 		goto err_keypair;
 
 	if (unlikely(READ_ONCE(peer->is_dead)))
 		goto err;
 
-	ret = wg_queue_enqueue_per_device_and_peer(&wg->decrypt_queue,
-						   &peer->rx_queue, skb,
-						   wg->packet_crypt_wq,
-						   &wg->decrypt_queue.last_cpu);
+	ret = wg_queue_enqueue_per_device_and_peer(&wg->decrypt_queue, &peer->rx_queue, skb,
+						   wg->packet_crypt_wq, &wg->decrypt_queue.last_cpu);
 	if (unlikely(ret == -EPIPE))
 		wg_queue_enqueue_per_peer_napi(skb, PACKET_STATE_DEAD);
 	if (likely(!ret || ret == -EPIPE)) {
@@ -565,8 +522,7 @@ void wg_packet_receive(struct wg_device *wg, struct sk_buff *skb)
 	case cpu_to_le32(MESSAGE_HANDSHAKE_COOKIE): {
 		int cpu;
 
-		if (skb_queue_len(&wg->incoming_handshakes) >
-			    MAX_QUEUED_INCOMING_HANDSHAKES ||
+		if (skb_queue_len(&wg->incoming_handshakes) > MAX_QUEUED_INCOMING_HANDSHAKES ||
 		    unlikely(!rng_is_initialized())) {
 			net_dbg_skb_ratelimited("%s: Dropping handshake packet from %pISpfsc\n",
 						wg->dev->name, skb);
@@ -578,7 +534,7 @@ void wg_packet_receive(struct wg_device *wg, struct sk_buff *skb)
 		 */
 		cpu = wg_cpumask_next_online(&wg->incoming_handshake_cpu);
 		queue_work_on(cpu, wg->handshake_receive_wq,
-			&per_cpu_ptr(wg->incoming_handshakes_worker, cpu)->work);
+			      &per_cpu_ptr(wg->incoming_handshakes_worker, cpu)->work);
 		break;
 	}
 	case cpu_to_le32(MESSAGE_DATA):
diff --git a/drivers/net/wireguard/selftest/allowedips.c b/drivers/net/wireguard/selftest/allowedips.c
index 846db14cb046..6939e24f8674 100644
--- a/drivers/net/wireguard/selftest/allowedips.c
+++ b/drivers/net/wireguard/selftest/allowedips.c
@@ -2,25 +2,22 @@
 /*
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  *
- * This contains some basic static unit tests for the allowedips data structure.
- * It also has two additional modes that are disabled and meant to be used by
- * folks directly playing with this file. If you define the macro
- * DEBUG_PRINT_TRIE_GRAPHVIZ to be 1, then every time there's a full tree in
- * memory, it will be printed out as KERN_DEBUG in a format that can be passed
- * to graphviz (the dot command) to visualize it. If you define the macro
- * DEBUG_RANDOM_TRIE to be 1, then there will be an extremely costly set of
- * randomized tests done against a trivial implementation, which may take
- * upwards of a half-hour to complete. There's no set of users who should be
- * enabling these, and the only developers that should go anywhere near these
- * nobs are the ones who are reading this comment.
+ * This contains some basic static unit tests for the allowedips data structure.  It also has two
+ * additional modes that are disabled and meant to be used by folks directly playing with this file.
+ * If you define the macro DEBUG_PRINT_TRIE_GRAPHVIZ to be 1, then every time there's a full tree in
+ * memory, it will be printed out as KERN_DEBUG in a format that can be passed to graphviz (the dot
+ * command) to visualize it. If you define the macro DEBUG_RANDOM_TRIE to be 1, then there will be
+ * an extremely costly set of randomized tests done against a trivial implementation, which may take
+ * upwards of a half-hour to complete. There's no set of users who should be enabling these, and the
+ * only developers that should go anywhere near these nobs are the ones who are reading this
+ * comment.
  */
 
 #ifdef DEBUG
 
 #include <linux/siphash.h>
 
-static __init void swap_endian_and_apply_cidr(u8 *dst, const u8 *src, u8 bits,
-					      u8 cidr)
+static __init void swap_endian_and_apply_cidr(u8 *dst, const u8 *src, u8 bits, u8 cidr)
 {
 	swap_endian(dst, src, bits);
 	memset(dst + (cidr + 7) / 8, 0, bits / 8 - (cidr + 7) / 8);
@@ -31,20 +28,17 @@ static __init void swap_endian_and_apply_cidr(u8 *dst, const u8 *src, u8 bits,
 static __init void print_node(struct allowedips_node *node, u8 bits)
 {
 	char *fmt_connection = KERN_DEBUG "\t\"%p/%d\" -> \"%p/%d\";\n";
-	char *fmt_declaration = KERN_DEBUG
-		"\t\"%p/%d\"[style=%s, color=\"#%06x\"];\n";
+	char *fmt_declaration = KERN_DEBUG "\t\"%p/%d\"[style=%s, color=\"#%06x\"];\n";
 	char *style = "dotted";
 	u8 ip1[16], ip2[16];
 	u32 color = 0;
 
 	if (bits == 32) {
 		fmt_connection = KERN_DEBUG "\t\"%pI4/%d\" -> \"%pI4/%d\";\n";
-		fmt_declaration = KERN_DEBUG
-			"\t\"%pI4/%d\"[style=%s, color=\"#%06x\"];\n";
+		fmt_declaration = KERN_DEBUG "\t\"%pI4/%d\"[style=%s, color=\"#%06x\"];\n";
 	} else if (bits == 128) {
 		fmt_connection = KERN_DEBUG "\t\"%pI6/%d\" -> \"%pI6/%d\";\n";
-		fmt_declaration = KERN_DEBUG
-			"\t\"%pI6/%d\"[style=%s, color=\"#%06x\"];\n";
+		fmt_declaration = KERN_DEBUG "\t\"%pI6/%d\"[style=%s, color=\"#%06x\"];\n";
 	}
 	if (node->peer) {
 		hsiphash_key_t key = { { 0 } };
@@ -58,19 +52,15 @@ static __init void print_node(struct allowedips_node *node, u8 bits)
 	swap_endian_and_apply_cidr(ip1, node->bits, bits, node->cidr);
 	printk(fmt_declaration, ip1, node->cidr, style, color);
 	if (node->bit[0]) {
-		swap_endian_and_apply_cidr(ip2,
-				rcu_dereference_raw(node->bit[0])->bits, bits,
-				node->cidr);
-		printk(fmt_connection, ip1, node->cidr, ip2,
-		       rcu_dereference_raw(node->bit[0])->cidr);
+		swap_endian_and_apply_cidr(ip2, rcu_dereference_raw(node->bit[0])->bits, bits,
+					   node->cidr);
+		printk(fmt_connection, ip1, node->cidr, ip2, rcu_dereference_raw(node->bit[0])->cidr);
 		print_node(rcu_dereference_raw(node->bit[0]), bits);
 	}
 	if (node->bit[1]) {
-		swap_endian_and_apply_cidr(ip2,
-				rcu_dereference_raw(node->bit[1])->bits,
-				bits, node->cidr);
-		printk(fmt_connection, ip1, node->cidr, ip2,
-		       rcu_dereference_raw(node->bit[1])->cidr);
+		swap_endian_and_apply_cidr(ip2, rcu_dereference_raw(node->bit[1])->bits, bits,
+					   node->cidr);
+		printk(fmt_connection, ip1, node->cidr, ip2, rcu_dereference_raw(node->bit[1])->cidr);
 		print_node(rcu_dereference_raw(node->bit[1]), bits);
 	}
 }
@@ -135,8 +125,7 @@ static __init inline u8 horrible_mask_to_cidr(union nf_inet_addr subnet)
 	       hweight32(subnet.all[2]) + hweight32(subnet.all[3]);
 }
 
-static __init inline void
-horrible_mask_self(struct horrible_allowedips_node *node)
+static __init inline void horrible_mask_self(struct horrible_allowedips_node *node)
 {
 	if (node->ip_version == 4) {
 		node->ip.ip &= node->mask.ip;
@@ -148,38 +137,30 @@ horrible_mask_self(struct horrible_allowedips_node *node)
 	}
 }
 
-static __init inline bool
-horrible_match_v4(const struct horrible_allowedips_node *node,
-		  struct in_addr *ip)
+static __init inline bool horrible_match_v4(const struct horrible_allowedips_node *node,
+					    struct in_addr *ip)
 {
 	return (ip->s_addr & node->mask.ip) == node->ip.ip;
 }
 
-static __init inline bool
-horrible_match_v6(const struct horrible_allowedips_node *node,
-		  struct in6_addr *ip)
+static __init inline bool horrible_match_v6(const struct horrible_allowedips_node *node,
+					    struct in6_addr *ip)
 {
-	return (ip->in6_u.u6_addr32[0] & node->mask.ip6[0]) ==
-		       node->ip.ip6[0] &&
-	       (ip->in6_u.u6_addr32[1] & node->mask.ip6[1]) ==
-		       node->ip.ip6[1] &&
-	       (ip->in6_u.u6_addr32[2] & node->mask.ip6[2]) ==
-		       node->ip.ip6[2] &&
+	return (ip->in6_u.u6_addr32[0] & node->mask.ip6[0]) == node->ip.ip6[0] &&
+	       (ip->in6_u.u6_addr32[1] & node->mask.ip6[1]) == node->ip.ip6[1] &&
+	       (ip->in6_u.u6_addr32[2] & node->mask.ip6[2]) == node->ip.ip6[2] &&
 	       (ip->in6_u.u6_addr32[3] & node->mask.ip6[3]) == node->ip.ip6[3];
 }
 
-static __init void
-horrible_insert_ordered(struct horrible_allowedips *table,
-			struct horrible_allowedips_node *node)
+static __init void horrible_insert_ordered(struct horrible_allowedips *table,
+					   struct horrible_allowedips_node *node)
 {
 	struct horrible_allowedips_node *other = NULL, *where = NULL;
 	u8 my_cidr = horrible_mask_to_cidr(node->mask);
 
 	hlist_for_each_entry(other, &table->head, table) {
-		if (!memcmp(&other->mask, &node->mask,
-			    sizeof(union nf_inet_addr)) &&
-		    !memcmp(&other->ip, &node->ip,
-			    sizeof(union nf_inet_addr)) &&
+		if (!memcmp(&other->mask, &node->mask, sizeof(union nf_inet_addr)) &&
+		    !memcmp(&other->ip, &node->ip, sizeof(union nf_inet_addr)) &&
 		    other->ip_version == node->ip_version) {
 			other->value = node->value;
 			kfree(node);
@@ -197,12 +178,10 @@ horrible_insert_ordered(struct horrible_allowedips *table,
 		hlist_add_before(&node->table, &where->table);
 }
 
-static __init int
-horrible_allowedips_insert_v4(struct horrible_allowedips *table,
-			      struct in_addr *ip, u8 cidr, void *value)
+static __init int horrible_allowedips_insert_v4(struct horrible_allowedips *table, struct in_addr *ip,
+						u8 cidr, void *value)
 {
-	struct horrible_allowedips_node *node = kzalloc(sizeof(*node),
-							GFP_KERNEL);
+	struct horrible_allowedips_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
 
 	if (unlikely(!node))
 		return -ENOMEM;
@@ -215,12 +194,10 @@ horrible_allowedips_insert_v4(struct horrible_allowedips *table,
 	return 0;
 }
 
-static __init int
-horrible_allowedips_insert_v6(struct horrible_allowedips *table,
-			      struct in6_addr *ip, u8 cidr, void *value)
+static __init int horrible_allowedips_insert_v6(struct horrible_allowedips *table, struct in6_addr *ip,
+						u8 cidr, void *value)
 {
-	struct horrible_allowedips_node *node = kzalloc(sizeof(*node),
-							GFP_KERNEL);
+	struct horrible_allowedips_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
 
 	if (unlikely(!node))
 		return -ENOMEM;
@@ -233,9 +210,7 @@ horrible_allowedips_insert_v6(struct horrible_allowedips *table,
 	return 0;
 }
 
-static __init void *
-horrible_allowedips_lookup_v4(struct horrible_allowedips *table,
-			      struct in_addr *ip)
+static __init void *horrible_allowedips_lookup_v4(struct horrible_allowedips *table, struct in_addr *ip)
 {
 	struct horrible_allowedips_node *node;
 	void *ret = NULL;
@@ -252,8 +227,7 @@ horrible_allowedips_lookup_v4(struct horrible_allowedips *table,
 }
 
 static __init void *
-horrible_allowedips_lookup_v6(struct horrible_allowedips *table,
-			      struct in6_addr *ip)
+horrible_allowedips_lookup_v6(struct horrible_allowedips *table, struct in6_addr *ip)
 {
 	struct horrible_allowedips_node *node;
 	void *ret = NULL;
@@ -304,13 +278,11 @@ static __init bool randomized_test(void)
 		prandom_bytes(ip, 4);
 		cidr = prandom_u32_max(32) + 1;
 		peer = peers[prandom_u32_max(NUM_PEERS)];
-		if (wg_allowedips_insert_v4(&t, (struct in_addr *)ip, cidr,
-					    peer, &mutex) < 0) {
+		if (wg_allowedips_insert_v4(&t, (struct in_addr *)ip, cidr, peer, &mutex) < 0) {
 			pr_err("allowedips random self-test malloc: FAIL\n");
 			goto free_locked;
 		}
-		if (horrible_allowedips_insert_v4(&h, (struct in_addr *)ip,
-						  cidr, peer) < 0) {
+		if (horrible_allowedips_insert_v4(&h, (struct in_addr *)ip, cidr, peer) < 0) {
 			pr_err("allowedips random self-test malloc: FAIL\n");
 			goto free_locked;
 		}
@@ -320,24 +292,21 @@ static __init bool randomized_test(void)
 			mutate_amount = prandom_u32_max(32);
 			for (k = 0; k < mutate_amount / 8; ++k)
 				mutate_mask[k] = 0xff;
-			mutate_mask[k] = 0xff
-					 << ((8 - (mutate_amount % 8)) % 8);
+			mutate_mask[k] = 0xff << ((8 - (mutate_amount % 8)) % 8);
 			for (; k < 4; ++k)
 				mutate_mask[k] = 0;
 			for (k = 0; k < 4; ++k)
 				mutated[k] = (mutated[k] & mutate_mask[k]) |
-					     (~mutate_mask[k] &
-					      prandom_u32_max(256));
+					     (~mutate_mask[k] & prandom_u32_max(256));
 			cidr = prandom_u32_max(32) + 1;
 			peer = peers[prandom_u32_max(NUM_PEERS)];
-			if (wg_allowedips_insert_v4(&t,
-						    (struct in_addr *)mutated,
-						    cidr, peer, &mutex) < 0) {
+			if (wg_allowedips_insert_v4(&t, (struct in_addr *)mutated, cidr, peer,
+						    &mutex) < 0) {
 				pr_err("allowedips random malloc: FAIL\n");
 				goto free_locked;
 			}
-			if (horrible_allowedips_insert_v4(&h,
-				(struct in_addr *)mutated, cidr, peer)) {
+			if (horrible_allowedips_insert_v4(&h, (struct in_addr *)mutated, cidr,
+							  peer)) {
 				pr_err("allowedips random self-test malloc: FAIL\n");
 				goto free_locked;
 			}
@@ -348,13 +317,11 @@ static __init bool randomized_test(void)
 		prandom_bytes(ip, 16);
 		cidr = prandom_u32_max(128) + 1;
 		peer = peers[prandom_u32_max(NUM_PEERS)];
-		if (wg_allowedips_insert_v6(&t, (struct in6_addr *)ip, cidr,
-					    peer, &mutex) < 0) {
+		if (wg_allowedips_insert_v6(&t, (struct in6_addr *)ip, cidr, peer, &mutex) < 0) {
 			pr_err("allowedips random self-test malloc: FAIL\n");
 			goto free_locked;
 		}
-		if (horrible_allowedips_insert_v6(&h, (struct in6_addr *)ip,
-						  cidr, peer) < 0) {
+		if (horrible_allowedips_insert_v6(&h, (struct in6_addr *)ip, cidr, peer) < 0) {
 			pr_err("allowedips random self-test malloc: FAIL\n");
 			goto free_locked;
 		}
@@ -364,25 +331,21 @@ static __init bool randomized_test(void)
 			mutate_amount = prandom_u32_max(128);
 			for (k = 0; k < mutate_amount / 8; ++k)
 				mutate_mask[k] = 0xff;
-			mutate_mask[k] = 0xff
-					 << ((8 - (mutate_amount % 8)) % 8);
+			mutate_mask[k] = 0xff << ((8 - (mutate_amount % 8)) % 8);
 			for (; k < 4; ++k)
 				mutate_mask[k] = 0;
 			for (k = 0; k < 4; ++k)
 				mutated[k] = (mutated[k] & mutate_mask[k]) |
-					     (~mutate_mask[k] &
-					      prandom_u32_max(256));
+					     (~mutate_mask[k] & prandom_u32_max(256));
 			cidr = prandom_u32_max(128) + 1;
 			peer = peers[prandom_u32_max(NUM_PEERS)];
-			if (wg_allowedips_insert_v6(&t,
-						    (struct in6_addr *)mutated,
-						    cidr, peer, &mutex) < 0) {
+			if (wg_allowedips_insert_v6(&t, (struct in6_addr *)mutated, cidr, peer,
+						    &mutex) < 0) {
 				pr_err("allowedips random self-test malloc: FAIL\n");
 				goto free_locked;
 			}
-			if (horrible_allowedips_insert_v6(
-				    &h, (struct in6_addr *)mutated, cidr,
-				    peer)) {
+			if (horrible_allowedips_insert_v6(&h, (struct in6_addr *)mutated, cidr,
+							  peer)) {
 				pr_err("allowedips random self-test malloc: FAIL\n");
 				goto free_locked;
 			}
@@ -464,9 +427,8 @@ static __init struct wg_peer *init_peer(void)
 	return peer;
 }
 
-#define insert(version, mem, ipa, ipb, ipc, ipd, cidr)                       \
-	wg_allowedips_insert_v##version(&t, ip##version(ipa, ipb, ipc, ipd), \
-					cidr, mem, &mutex)
+#define insert(version, mem, ipa, ipb, ipc, ipd, cidr) \
+	wg_allowedips_insert_v##version(&t, ip##version(ipa, ipb, ipc, ipd), cidr, mem, &mutex)
 
 #define maybe_fail() do {                                               \
 		++i;                                                    \
@@ -495,11 +457,10 @@ static __init struct wg_peer *init_peer(void)
 
 bool __init wg_allowedips_selftest(void)
 {
-	bool found_a = false, found_b = false, found_c = false, found_d = false,
-	     found_e = false, found_other = false;
-	struct wg_peer *a = init_peer(), *b = init_peer(), *c = init_peer(),
-		       *d = init_peer(), *e = init_peer(), *f = init_peer(),
-		       *g = init_peer(), *h = init_peer();
+	bool found_a = false, found_b = false, found_c = false, found_d = false, found_e = false,
+	     found_other = false;
+	struct wg_peer *a = init_peer(), *b = init_peer(), *c = init_peer(), *d = init_peer(),
+		       *e = init_peer(), *f = init_peer(), *g = init_peer(), *h = init_peer();
 	struct allowedips_node *iter_node;
 	bool success = false;
 	struct allowedips t;
@@ -639,8 +600,7 @@ bool __init wg_allowedips_selftest(void)
 				 sizeof(struct in6_addr)))
 			found_d = true;
 		else if (cidr == 21 && family == AF_INET6 &&
-			 !memcmp(ip, ip6(0x26075000, 0, 0, 0),
-				 sizeof(struct in6_addr)))
+			 !memcmp(ip, ip6(0x26075000, 0, 0, 0), sizeof(struct in6_addr)))
 			found_e = true;
 		else
 			found_other = true;
diff --git a/drivers/net/wireguard/selftest/counter.c b/drivers/net/wireguard/selftest/counter.c
index ec3c156bf91b..39214e43b4df 100644
--- a/drivers/net/wireguard/selftest/counter.c
+++ b/drivers/net/wireguard/selftest/counter.c
@@ -21,13 +21,12 @@ bool __init wg_packet_counter_selftest(void)
 		spin_lock_init(&counter->lock);        \
 	} while (0)
 #define T_LIM (COUNTER_WINDOW_SIZE + 1)
-#define T(n, v) do {                                                  \
-		++test_num;                                           \
-		if (counter_validate(counter, n) != (v)) {            \
-			pr_err("nonce counter self-test %u: FAIL\n",  \
-			       test_num);                             \
-			success = false;                              \
-		}                                                     \
+#define T(n, v) do {                                                             \
+		++test_num;                                                      \
+		if (counter_validate(counter, n) != (v)) {                       \
+			pr_err("nonce counter self-test %u: FAIL\n", test_num);  \
+			success = false;                                         \
+		}                                                                \
 	} while (0)
 
 	T_INIT;
diff --git a/drivers/net/wireguard/selftest/ratelimiter.c b/drivers/net/wireguard/selftest/ratelimiter.c
index 007cd4457c5f..7a97e4e651bc 100644
--- a/drivers/net/wireguard/selftest/ratelimiter.c
+++ b/drivers/net/wireguard/selftest/ratelimiter.c
@@ -30,9 +30,8 @@ static __init unsigned int maximum_jiffies_at_index(int index)
 	return msecs_to_jiffies(total_msecs);
 }
 
-static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
-			       struct sk_buff *skb6, struct ipv6hdr *hdr6,
-			       int *test)
+static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4, struct sk_buff *skb6,
+			       struct ipv6hdr *hdr6, int *test)
 {
 	unsigned long loop_start_time;
 	int i;
@@ -45,17 +44,14 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
 		if (expected_results[i].msec_to_sleep_before)
 			msleep(expected_results[i].msec_to_sleep_before);
 
-		if (time_is_before_jiffies(loop_start_time +
-					   maximum_jiffies_at_index(i)))
+		if (time_is_before_jiffies(loop_start_time + maximum_jiffies_at_index(i)))
 			return -ETIMEDOUT;
-		if (wg_ratelimiter_allow(skb4, &init_net) !=
-					expected_results[i].result)
+		if (wg_ratelimiter_allow(skb4, &init_net) != expected_results[i].result)
 			return -EXFULL;
 		++(*test);
 
 		hdr4->saddr = htonl(ntohl(hdr4->saddr) + i + 1);
-		if (time_is_before_jiffies(loop_start_time +
-					   maximum_jiffies_at_index(i)))
+		if (time_is_before_jiffies(loop_start_time + maximum_jiffies_at_index(i)))
 			return -ETIMEDOUT;
 		if (!wg_ratelimiter_allow(skb4, &init_net))
 			return -EXFULL;
@@ -66,36 +62,29 @@ static __init int timings_test(struct sk_buff *skb4, struct iphdr *hdr4,
 #if IS_ENABLED(CONFIG_IPV6)
 		hdr6->saddr.in6_u.u6_addr32[2] = htonl(i);
 		hdr6->saddr.in6_u.u6_addr32[3] = htonl(i);
-		if (time_is_before_jiffies(loop_start_time +
-					   maximum_jiffies_at_index(i)))
+		if (time_is_before_jiffies(loop_start_time + maximum_jiffies_at_index(i)))
 			return -ETIMEDOUT;
-		if (wg_ratelimiter_allow(skb6, &init_net) !=
-					expected_results[i].result)
+		if (wg_ratelimiter_allow(skb6, &init_net) != expected_results[i].result)
 			return -EXFULL;
 		++(*test);
 
-		hdr6->saddr.in6_u.u6_addr32[0] =
-			htonl(ntohl(hdr6->saddr.in6_u.u6_addr32[0]) + i + 1);
-		if (time_is_before_jiffies(loop_start_time +
-					   maximum_jiffies_at_index(i)))
+		hdr6->saddr.in6_u.u6_addr32[0] = htonl(ntohl(hdr6->saddr.in6_u.u6_addr32[0]) + i + 1);
+		if (time_is_before_jiffies(loop_start_time + maximum_jiffies_at_index(i)))
 			return -ETIMEDOUT;
 		if (!wg_ratelimiter_allow(skb6, &init_net))
 			return -EXFULL;
 		++(*test);
 
-		hdr6->saddr.in6_u.u6_addr32[0] =
-			htonl(ntohl(hdr6->saddr.in6_u.u6_addr32[0]) - i - 1);
+		hdr6->saddr.in6_u.u6_addr32[0] = htonl(ntohl(hdr6->saddr.in6_u.u6_addr32[0]) - i - 1);
 
-		if (time_is_before_jiffies(loop_start_time +
-					   maximum_jiffies_at_index(i)))
+		if (time_is_before_jiffies(loop_start_time + maximum_jiffies_at_index(i)))
 			return -ETIMEDOUT;
 #endif
 	}
 	return 0;
 }
 
-static __init int capacity_test(struct sk_buff *skb4, struct iphdr *hdr4,
-				int *test)
+static __init int capacity_test(struct sk_buff *skb4, struct iphdr *hdr4, int *test)
 {
 	int i;
 
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index f74b9341ab0f..182d5c81e7e7 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -22,61 +22,49 @@ static void wg_packet_send_handshake_initiation(struct wg_peer *peer)
 {
 	struct message_handshake_initiation packet;
 
-	if (!wg_birthdate_has_expired(atomic64_read(&peer->last_sent_handshake),
-				      REKEY_TIMEOUT))
+	if (!wg_birthdate_has_expired(atomic64_read(&peer->last_sent_handshake), REKEY_TIMEOUT))
 		return; /* This function is rate limited. */
 
 	atomic64_set(&peer->last_sent_handshake, ktime_get_coarse_boottime_ns());
 	net_dbg_ratelimited("%s: Sending handshake initiation to peer %llu (%pISpfsc)\n",
-			    peer->device->dev->name, peer->internal_id,
-			    &peer->endpoint.addr);
+			    peer->device->dev->name, peer->internal_id, &peer->endpoint.addr);
 
 	if (wg_noise_handshake_create_initiation(&packet, &peer->handshake)) {
 		wg_cookie_add_mac_to_packet(&packet, sizeof(packet), peer);
 		wg_timers_any_authenticated_packet_traversal(peer);
 		wg_timers_any_authenticated_packet_sent(peer);
-		atomic64_set(&peer->last_sent_handshake,
-			     ktime_get_coarse_boottime_ns());
-		wg_socket_send_buffer_to_peer(peer, &packet, sizeof(packet),
-					      HANDSHAKE_DSCP);
+		atomic64_set(&peer->last_sent_handshake, ktime_get_coarse_boottime_ns());
+		wg_socket_send_buffer_to_peer(peer, &packet, sizeof(packet), HANDSHAKE_DSCP);
 		wg_timers_handshake_initiated(peer);
 	}
 }
 
 void wg_packet_handshake_send_worker(struct work_struct *work)
 {
-	struct wg_peer *peer = container_of(work, struct wg_peer,
-					    transmit_handshake_work);
+	struct wg_peer *peer = container_of(work, struct wg_peer, transmit_handshake_work);
 
 	wg_packet_send_handshake_initiation(peer);
 	wg_peer_put(peer);
 }
 
-void wg_packet_send_queued_handshake_initiation(struct wg_peer *peer,
-						bool is_retry)
+void wg_packet_send_queued_handshake_initiation(struct wg_peer *peer, bool is_retry)
 {
 	if (!is_retry)
 		peer->timer_handshake_attempts = 0;
 
 	rcu_read_lock_bh();
-	/* We check last_sent_handshake here in addition to the actual function
-	 * we're queueing up, so that we don't queue things if not strictly
-	 * necessary:
+	/* We check last_sent_handshake here in addition to the actual function we're queueing up,
+	 * so that we don't queue things if not strictly necessary:
 	 */
-	if (!wg_birthdate_has_expired(atomic64_read(&peer->last_sent_handshake),
-				      REKEY_TIMEOUT) ||
-			unlikely(READ_ONCE(peer->is_dead)))
+	if (!wg_birthdate_has_expired(atomic64_read(&peer->last_sent_handshake), REKEY_TIMEOUT) ||
+	    unlikely(READ_ONCE(peer->is_dead)))
 		goto out;
 
 	wg_peer_get(peer);
-	/* Queues up calling packet_send_queued_handshakes(peer), where we do a
-	 * peer_put(peer) after:
-	 */
+	/* Queues up calling packet_send_queued_handshakes(peer), where we do a peer_put(peer) after: */
 	if (!queue_work(peer->device->handshake_send_wq,
 			&peer->transmit_handshake_work))
-		/* If the work was already queued, we want to drop the
-		 * extra reference:
-		 */
+		/* If the work was already queued, we want to drop the extra reference: */
 		wg_peer_put(peer);
 out:
 	rcu_read_unlock_bh();
@@ -88,21 +76,16 @@ void wg_packet_send_handshake_response(struct wg_peer *peer)
 
 	atomic64_set(&peer->last_sent_handshake, ktime_get_coarse_boottime_ns());
 	net_dbg_ratelimited("%s: Sending handshake response to peer %llu (%pISpfsc)\n",
-			    peer->device->dev->name, peer->internal_id,
-			    &peer->endpoint.addr);
+			    peer->device->dev->name, peer->internal_id, &peer->endpoint.addr);
 
 	if (wg_noise_handshake_create_response(&packet, &peer->handshake)) {
 		wg_cookie_add_mac_to_packet(&packet, sizeof(packet), peer);
-		if (wg_noise_handshake_begin_session(&peer->handshake,
-						     &peer->keypairs)) {
+		if (wg_noise_handshake_begin_session(&peer->handshake, &peer->keypairs)) {
 			wg_timers_session_derived(peer);
 			wg_timers_any_authenticated_packet_traversal(peer);
 			wg_timers_any_authenticated_packet_sent(peer);
-			atomic64_set(&peer->last_sent_handshake,
-				     ktime_get_coarse_boottime_ns());
-			wg_socket_send_buffer_to_peer(peer, &packet,
-						      sizeof(packet),
-						      HANDSHAKE_DSCP);
+			atomic64_set(&peer->last_sent_handshake,ktime_get_coarse_boottime_ns());
+			wg_socket_send_buffer_to_peer(peer, &packet, sizeof(packet), HANDSHAKE_DSCP);
 		}
 	}
 }
@@ -115,10 +98,8 @@ void wg_packet_send_handshake_cookie(struct wg_device *wg,
 
 	net_dbg_skb_ratelimited("%s: Sending cookie response for denied handshake message for %pISpfsc\n",
 				wg->dev->name, initiating_skb);
-	wg_cookie_message_create(&packet, initiating_skb, sender_index,
-				 &wg->cookie_checker);
-	wg_socket_send_buffer_as_reply_to_skb(wg, initiating_skb, &packet,
-					      sizeof(packet));
+	wg_cookie_message_create(&packet, initiating_skb, sender_index, &wg->cookie_checker);
+	wg_socket_send_buffer_as_reply_to_skb(wg, initiating_skb, &packet, sizeof(packet));
 }
 
 static void keep_key_fresh(struct wg_peer *peer)
@@ -145,17 +126,15 @@ static unsigned int calculate_skb_padding(struct sk_buff *skb)
 	if (unlikely(!PACKET_CB(skb)->mtu))
 		return ALIGN(last_unit, MESSAGE_PADDING_MULTIPLE) - last_unit;
 
-	/* We do this modulo business with the MTU, just in case the networking
-	 * layer gives us a packet that's bigger than the MTU. In that case, we
-	 * wouldn't want the final subtraction to overflow in the case of the
-	 * padded_size being clamped. Fortunately, that's very rarely the case,
-	 * so we optimize for that not happening.
+	/* We do this modulo business with the MTU, just in case the networking layer gives us a
+	 * packet that's bigger than the MTU. In that case, we wouldn't want the final subtraction
+	 * to overflow in the case of the padded_size being clamped. Fortunately, that's very rarely
+	 * the case, so we optimize for that not happening.
 	 */
 	if (unlikely(last_unit > PACKET_CB(skb)->mtu))
 		last_unit %= PACKET_CB(skb)->mtu;
 
-	padded_size = min(PACKET_CB(skb)->mtu,
-			  ALIGN(last_unit, MESSAGE_PADDING_MULTIPLE));
+	padded_size = min(PACKET_CB(skb)->mtu, ALIGN(last_unit, MESSAGE_PADDING_MULTIPLE));
 	return padded_size - last_unit;
 }
 
@@ -167,8 +146,8 @@ static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 	struct sk_buff *trailer;
 	int num_frags;
 
-	/* Force hash calculation before encryption so that flow analysis is
-	 * consistent over the inner packet.
+	/* Force hash calculation before encryption so that flow analysis is consistent over the
+	 * inner packet.
 	 */
 	skb_get_hash(skb);
 
@@ -182,25 +161,18 @@ static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 	if (unlikely(num_frags < 0 || num_frags > ARRAY_SIZE(sg)))
 		return false;
 
-	/* Set the padding to zeros, and make sure it and the auth tag are part
-	 * of the skb.
-	 */
+	/* Set the padding to zeros, and make sure it and the auth tag are part of the skb. */
 	memset(skb_tail_pointer(trailer), 0, padding_len);
 
-	/* Expand head section to have room for our header and the network
-	 * stack's headers.
-	 */
+	/* Expand head section to have room for our header and the network stack's headers. */
 	if (unlikely(skb_cow_head(skb, DATA_PACKET_HEAD_ROOM) < 0))
 		return false;
 
 	/* Finalize checksum calculation for the inner packet, if required. */
-	if (unlikely(skb->ip_summed == CHECKSUM_PARTIAL &&
-		     skb_checksum_help(skb)))
+	if (unlikely(skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb)))
 		return false;
 
-	/* Only after checksumming can we safely add on the padding at the end
-	 * and the header.
-	 */
+	/* Only after checksumming can we safely add on the padding at the end and the header. */
 	skb_set_inner_network_header(skb, 0);
 	header = (struct message_data *)skb_push(skb, sizeof(*header));
 	header->header.type = cpu_to_le32(MESSAGE_DATA);
@@ -210,11 +182,9 @@ static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 
 	/* Now we can encrypt the scattergather segments */
 	sg_init_table(sg, num_frags);
-	if (skb_to_sgvec(skb, sg, sizeof(struct message_data),
-			 noise_encrypted_len(plaintext_len)) <= 0)
+	if (skb_to_sgvec(skb, sg, sizeof(struct message_data), noise_encrypted_len(plaintext_len)) <= 0)
 		return false;
-	return chacha20poly1305_encrypt_sg_inplace(sg, plaintext_len, NULL, 0,
-						   PACKET_CB(skb)->nonce,
+	return chacha20poly1305_encrypt_sg_inplace(sg, plaintext_len, NULL, 0, PACKET_CB(skb)->nonce,
 						   keypair->sending.key);
 }
 
@@ -223,8 +193,7 @@ void wg_packet_send_keepalive(struct wg_peer *peer)
 	struct sk_buff *skb;
 
 	if (skb_queue_empty(&peer->staged_packet_queue)) {
-		skb = alloc_skb(DATA_PACKET_HEAD_ROOM + MESSAGE_MINIMUM_LENGTH,
-				GFP_ATOMIC);
+		skb = alloc_skb(DATA_PACKET_HEAD_ROOM + MESSAGE_MINIMUM_LENGTH, GFP_ATOMIC);
 		if (unlikely(!skb))
 			return;
 		skb_reserve(skb, DATA_PACKET_HEAD_ROOM);
@@ -232,15 +201,13 @@ void wg_packet_send_keepalive(struct wg_peer *peer)
 		PACKET_CB(skb)->mtu = skb->dev->mtu;
 		skb_queue_tail(&peer->staged_packet_queue, skb);
 		net_dbg_ratelimited("%s: Sending keepalive packet to peer %llu (%pISpfsc)\n",
-				    peer->device->dev->name, peer->internal_id,
-				    &peer->endpoint.addr);
+				    peer->device->dev->name, peer->internal_id, &peer->endpoint.addr);
 	}
 
 	wg_packet_send_staged_packets(peer);
 }
 
-static void wg_packet_create_data_done(struct sk_buff *first,
-				       struct wg_peer *peer)
+static void wg_packet_create_data_done(struct sk_buff *first, struct wg_peer *peer)
 {
 	struct sk_buff *skb, *next;
 	bool is_keepalive, data_sent = false;
@@ -249,8 +216,7 @@ static void wg_packet_create_data_done(struct sk_buff *first,
 	wg_timers_any_authenticated_packet_sent(peer);
 	skb_list_walk_safe(first, skb, next) {
 		is_keepalive = skb->len == message_data_len(0);
-		if (likely(!wg_socket_send_skb_to_peer(peer, skb,
-				PACKET_CB(skb)->ds) && !is_keepalive))
+		if (likely(!wg_socket_send_skb_to_peer(peer, skb, PACKET_CB(skb)->ds) && !is_keepalive))
 			data_sent = true;
 	}
 
@@ -262,16 +228,14 @@ static void wg_packet_create_data_done(struct sk_buff *first,
 
 void wg_packet_tx_worker(struct work_struct *work)
 {
-	struct crypt_queue *queue = container_of(work, struct crypt_queue,
-						 work);
+	struct crypt_queue *queue = container_of(work, struct crypt_queue, work);
 	struct noise_keypair *keypair;
 	enum packet_state state;
 	struct sk_buff *first;
 	struct wg_peer *peer;
 
 	while ((first = __ptr_ring_peek(&queue->ring)) != NULL &&
-	       (state = atomic_read_acquire(&PACKET_CB(first)->state)) !=
-		       PACKET_STATE_UNCRYPTED) {
+	       (state = atomic_read_acquire(&PACKET_CB(first)->state)) != PACKET_STATE_UNCRYPTED) {
 		__ptr_ring_discard_one(&queue->ring);
 		peer = PACKET_PEER(first);
 		keypair = PACKET_CB(first)->keypair;
@@ -290,24 +254,21 @@ void wg_packet_tx_worker(struct work_struct *work)
 
 void wg_packet_encrypt_worker(struct work_struct *work)
 {
-	struct crypt_queue *queue = container_of(work, struct multicore_worker,
-						 work)->ptr;
+	struct crypt_queue *queue = container_of(work, struct multicore_worker, work)->ptr;
 	struct sk_buff *first, *skb, *next;
 
 	while ((first = ptr_ring_consume_bh(&queue->ring)) != NULL) {
 		enum packet_state state = PACKET_STATE_CRYPTED;
 
 		skb_list_walk_safe(first, skb, next) {
-			if (likely(encrypt_packet(skb,
-					PACKET_CB(first)->keypair))) {
+			if (likely(encrypt_packet(skb, PACKET_CB(first)->keypair))) {
 				wg_reset_packet(skb, true);
 			} else {
 				state = PACKET_STATE_DEAD;
 				break;
 			}
 		}
-		wg_queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first,
-					  state);
+		wg_queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first, state);
 		if (need_resched())
 			cond_resched();
 	}
@@ -323,13 +284,10 @@ static void wg_packet_create_data(struct sk_buff *first)
 	if (unlikely(READ_ONCE(peer->is_dead)))
 		goto err;
 
-	ret = wg_queue_enqueue_per_device_and_peer(&wg->encrypt_queue,
-						   &peer->tx_queue, first,
-						   wg->packet_crypt_wq,
-						   &wg->encrypt_queue.last_cpu);
+	ret = wg_queue_enqueue_per_device_and_peer(&wg->encrypt_queue, &peer->tx_queue, first,
+						   wg->packet_crypt_wq, &wg->encrypt_queue.last_cpu);
 	if (unlikely(ret == -EPIPE))
-		wg_queue_enqueue_per_peer(&peer->tx_queue, first,
-					  PACKET_STATE_DEAD);
+		wg_queue_enqueue_per_peer(&peer->tx_queue, first, PACKET_STATE_DEAD);
 err:
 	rcu_read_unlock_bh();
 	if (likely(!ret || ret == -EPIPE))
@@ -363,29 +321,25 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
 
 	/* First we make sure we have a valid reference to a valid key. */
 	rcu_read_lock_bh();
-	keypair = wg_noise_keypair_get(
-		rcu_dereference_bh(peer->keypairs.current_keypair));
+	keypair = wg_noise_keypair_get(rcu_dereference_bh(peer->keypairs.current_keypair));
 	rcu_read_unlock_bh();
 	if (unlikely(!keypair))
 		goto out_nokey;
 	if (unlikely(!READ_ONCE(keypair->sending.is_valid)))
 		goto out_nokey;
-	if (unlikely(wg_birthdate_has_expired(keypair->sending.birthdate,
-					      REJECT_AFTER_TIME)))
+	if (unlikely(wg_birthdate_has_expired(keypair->sending.birthdate, REJECT_AFTER_TIME)))
 		goto out_invalid;
 
-	/* After we know we have a somewhat valid key, we now try to assign
-	 * nonces to all of the packets in the queue. If we can't assign nonces
-	 * for all of them, we just consider it a failure and wait for the next
-	 * handshake.
+	/* After we know we have a somewhat valid key, we now try to assign nonces to all of the
+	 * packets in the queue. If we can't assign nonces for all of them, we just consider it a
+	 * failure and wait for the next handshake.
 	 */
 	skb_queue_walk(&packets, skb) {
-		/* 0 for no outer TOS: no leak. TODO: at some later point, we
-		 * might consider using flowi->tos as outer instead.
+		/* 0 for no outer TOS: no leak. TODO: at some later point, we might consider using
+		 * flowi->tos as outer instead.
 		 */
 		PACKET_CB(skb)->ds = ip_tunnel_ecn_encap(0, ip_hdr(skb), skb);
-		PACKET_CB(skb)->nonce =
-				atomic64_inc_return(&keypair->sending_counter) - 1;
+		PACKET_CB(skb)->nonce =	atomic64_inc_return(&keypair->sending_counter) - 1;
 		if (unlikely(PACKET_CB(skb)->nonce >= REJECT_AFTER_MESSAGES))
 			goto out_invalid;
 	}
@@ -401,22 +355,21 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
 out_nokey:
 	wg_noise_keypair_put(keypair, false);
 
-	/* We orphan the packets if we're waiting on a handshake, so that they
-	 * don't block a socket's pool.
+	/* We orphan the packets if we're waiting on a handshake, so that they don't block a
+	 * socket's pool.
 	 */
 	skb_queue_walk(&packets, skb)
 		skb_orphan(skb);
-	/* Then we put them back on the top of the queue. We're not too
-	 * concerned about accidentally getting things a little out of order if
-	 * packets are being added really fast, because this queue is for before
-	 * packets can even be sent and it's small anyway.
+	/* Then we put them back on the top of the queue. We're not too concerned about accidentally
+	 * getting things a little out of order if packets are being added really fast, because this
+	 * queue is for before packets can even be sent and it's small anyway.
 	 */
 	spin_lock_bh(&peer->staged_packet_queue.lock);
 	skb_queue_splice(&packets, &peer->staged_packet_queue);
 	spin_unlock_bh(&peer->staged_packet_queue.lock);
 
-	/* If we're exiting because there's something wrong with the key, it
-	 * means we should initiate a new handshake.
+	/* If we're exiting because there's something wrong with the key, it means we should
+	 * initiate a new handshake.
 	 */
 	wg_packet_send_queued_handshake_initiation(peer, false);
 }
diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index f9018027fc13..ed7611133364 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -17,8 +17,8 @@
 #include <net/udp_tunnel.h>
 #include <net/ipv6.h>
 
-static int send4(struct wg_device *wg, struct sk_buff *skb,
-		 struct endpoint *endpoint, u8 ds, struct dst_cache *cache)
+static int send4(struct wg_device *wg, struct sk_buff *skb, struct endpoint *endpoint, u8 ds,
+		 struct dst_cache *cache)
 {
 	struct flowi4 fl = {
 		.saddr = endpoint->src4.s_addr,
@@ -50,8 +50,7 @@ static int send4(struct wg_device *wg, struct sk_buff *skb,
 
 	if (!rt) {
 		security_sk_classify_flow(sock, flowi4_to_flowi(&fl));
-		if (unlikely(!inet_confirm_addr(sock_net(sock), NULL, 0,
-						fl.saddr, RT_SCOPE_HOST))) {
+		if (unlikely(!inet_confirm_addr(sock_net(sock), NULL, 0, fl.saddr, RT_SCOPE_HOST))) {
 			endpoint->src4.s_addr = 0;
 			*(__force __be32 *)&endpoint->src_if4 = 0;
 			fl.saddr = 0;
@@ -59,9 +58,8 @@ static int send4(struct wg_device *wg, struct sk_buff *skb,
 				dst_cache_reset(cache);
 		}
 		rt = ip_route_output_flow(sock_net(sock), &fl, sock);
-		if (unlikely(endpoint->src_if4 && ((IS_ERR(rt) &&
-			     PTR_ERR(rt) == -EINVAL) || (!IS_ERR(rt) &&
-			     rt->dst.dev->ifindex != endpoint->src_if4)))) {
+		if (unlikely(endpoint->src_if4 && ((IS_ERR(rt) && PTR_ERR(rt) == -EINVAL) ||
+			     (!IS_ERR(rt) && rt->dst.dev->ifindex != endpoint->src_if4)))) {
 			endpoint->src4.s_addr = 0;
 			*(__force __be32 *)&endpoint->src_if4 = 0;
 			fl.saddr = 0;
@@ -82,9 +80,8 @@ static int send4(struct wg_device *wg, struct sk_buff *skb,
 	}
 
 	skb->ignore_df = 1;
-	udp_tunnel_xmit_skb(rt, sock, skb, fl.saddr, fl.daddr, ds,
-			    ip4_dst_hoplimit(&rt->dst), 0, fl.fl4_sport,
-			    fl.fl4_dport, false, false);
+	udp_tunnel_xmit_skb(rt, sock, skb, fl.saddr, fl.daddr, ds, ip4_dst_hoplimit(&rt->dst), 0,
+			    fl.fl4_sport, fl.fl4_dport, false, false);
 	goto out;
 
 err:
@@ -94,8 +91,8 @@ static int send4(struct wg_device *wg, struct sk_buff *skb,
 	return ret;
 }
 
-static int send6(struct wg_device *wg, struct sk_buff *skb,
-		 struct endpoint *endpoint, u8 ds, struct dst_cache *cache)
+static int send6(struct wg_device *wg, struct sk_buff *skb, struct endpoint *endpoint, u8 ds,
+		 struct dst_cache *cache)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	struct flowi6 fl = {
@@ -130,14 +127,13 @@ static int send6(struct wg_device *wg, struct sk_buff *skb,
 
 	if (!dst) {
 		security_sk_classify_flow(sock, flowi6_to_flowi(&fl));
-		if (unlikely(!ipv6_addr_any(&fl.saddr) &&
-			     !ipv6_chk_addr(sock_net(sock), &fl.saddr, NULL, 0))) {
+		if (unlikely(!ipv6_addr_any(&fl.saddr) && !ipv6_chk_addr(sock_net(sock), &fl.saddr,
+									 NULL, 0))) {
 			endpoint->src6 = fl.saddr = in6addr_any;
 			if (cache)
 				dst_cache_reset(cache);
 		}
-		dst = ipv6_stub->ipv6_dst_lookup_flow(sock_net(sock), sock, &fl,
-						      NULL);
+		dst = ipv6_stub->ipv6_dst_lookup_flow(sock_net(sock), sock, &fl, NULL);
 		if (unlikely(IS_ERR(dst))) {
 			ret = PTR_ERR(dst);
 			net_dbg_ratelimited("%s: No route to %pISpfsc, error %d\n",
@@ -150,8 +146,7 @@ static int send6(struct wg_device *wg, struct sk_buff *skb,
 
 	skb->ignore_df = 1;
 	udp_tunnel6_xmit_skb(dst, sock, skb, skb->dev, &fl.saddr, &fl.daddr, ds,
-			     ip6_dst_hoplimit(dst), 0, fl.fl6_sport,
-			     fl.fl6_dport, false);
+			     ip6_dst_hoplimit(dst), 0, fl.fl6_sport, fl.fl6_dport, false);
 	goto out;
 
 err:
@@ -171,11 +166,9 @@ int wg_socket_send_skb_to_peer(struct wg_peer *peer, struct sk_buff *skb, u8 ds)
 
 	read_lock_bh(&peer->endpoint_lock);
 	if (peer->endpoint.addr.sa_family == AF_INET)
-		ret = send4(peer->device, skb, &peer->endpoint, ds,
-			    &peer->endpoint_cache);
+		ret = send4(peer->device, skb, &peer->endpoint, ds, &peer->endpoint_cache);
 	else if (peer->endpoint.addr.sa_family == AF_INET6)
-		ret = send6(peer->device, skb, &peer->endpoint, ds,
-			    &peer->endpoint_cache);
+		ret = send6(peer->device, skb, &peer->endpoint, ds, &peer->endpoint_cache);
 	else
 		dev_kfree_skb(skb);
 	if (likely(!ret))
@@ -185,8 +178,7 @@ int wg_socket_send_skb_to_peer(struct wg_peer *peer, struct sk_buff *skb, u8 ds)
 	return ret;
 }
 
-int wg_socket_send_buffer_to_peer(struct wg_peer *peer, void *buffer,
-				  size_t len, u8 ds)
+int wg_socket_send_buffer_to_peer(struct wg_peer *peer, void *buffer, size_t len, u8 ds)
 {
 	struct sk_buff *skb = alloc_skb(len + SKB_HEADER_LEN, GFP_ATOMIC);
 
@@ -199,8 +191,7 @@ int wg_socket_send_buffer_to_peer(struct wg_peer *peer, void *buffer,
 	return wg_socket_send_skb_to_peer(peer, skb, ds);
 }
 
-int wg_socket_send_buffer_as_reply_to_skb(struct wg_device *wg,
-					  struct sk_buff *in_skb, void *buffer,
+int wg_socket_send_buffer_as_reply_to_skb(struct wg_device *wg, struct sk_buff *in_skb, void *buffer,
 					  size_t len)
 {
 	int ret = 0;
@@ -224,15 +215,12 @@ int wg_socket_send_buffer_as_reply_to_skb(struct wg_device *wg,
 		ret = send4(wg, skb, &endpoint, 0, NULL);
 	else if (endpoint.addr.sa_family == AF_INET6)
 		ret = send6(wg, skb, &endpoint, 0, NULL);
-	/* No other possibilities if the endpoint is valid, which it is,
-	 * as we checked above.
-	 */
+	/* No other possibilities if the endpoint is valid, which it is, as we checked above. */
 
 	return ret;
 }
 
-int wg_socket_endpoint_from_skb(struct endpoint *endpoint,
-				const struct sk_buff *skb)
+int wg_socket_endpoint_from_skb(struct endpoint *endpoint, const struct sk_buff *skb)
 {
 	memset(endpoint, 0, sizeof(*endpoint));
 	if (skb->protocol == htons(ETH_P_IP)) {
@@ -245,8 +233,7 @@ int wg_socket_endpoint_from_skb(struct endpoint *endpoint,
 		endpoint->addr6.sin6_family = AF_INET6;
 		endpoint->addr6.sin6_port = udp_hdr(skb)->source;
 		endpoint->addr6.sin6_addr = ipv6_hdr(skb)->saddr;
-		endpoint->addr6.sin6_scope_id = ipv6_iface_scope_id(
-			&ipv6_hdr(skb)->saddr, skb->skb_iif);
+		endpoint->addr6.sin6_scope_id = ipv6_iface_scope_id(&ipv6_hdr(skb)->saddr, skb->skb_iif);
 		endpoint->src6 = ipv6_hdr(skb)->daddr;
 	} else {
 		return -EINVAL;
@@ -260,8 +247,7 @@ static bool endpoint_eq(const struct endpoint *a, const struct endpoint *b)
 		a->addr4.sin_port == b->addr4.sin_port &&
 		a->addr4.sin_addr.s_addr == b->addr4.sin_addr.s_addr &&
 		a->src4.s_addr == b->src4.s_addr && a->src_if4 == b->src_if4) ||
-	       (a->addr.sa_family == AF_INET6 &&
-		b->addr.sa_family == AF_INET6 &&
+	       (a->addr.sa_family == AF_INET6 && b->addr.sa_family == AF_INET6 &&
 		a->addr6.sin6_port == b->addr6.sin6_port &&
 		ipv6_addr_equal(&a->addr6.sin6_addr, &b->addr6.sin6_addr) &&
 		a->addr6.sin6_scope_id == b->addr6.sin6_scope_id &&
@@ -269,13 +255,11 @@ static bool endpoint_eq(const struct endpoint *a, const struct endpoint *b)
 	       unlikely(!a->addr.sa_family && !b->addr.sa_family);
 }
 
-void wg_socket_set_peer_endpoint(struct wg_peer *peer,
-				 const struct endpoint *endpoint)
+void wg_socket_set_peer_endpoint(struct wg_peer *peer, const struct endpoint *endpoint)
 {
-	/* First we check unlocked, in order to optimize, since it's pretty rare
-	 * that an endpoint will change. If we happen to be mid-write, and two
-	 * CPUs wind up writing the same thing or something slightly different,
-	 * it doesn't really matter much either.
+	/* First we check unlocked, in order to optimize, since it's pretty rare that an endpoint
+	 * will change. If we happen to be mid-write, and two CPUs wind up writing the same thing or
+	 * something slightly different, it doesn't really matter much either.
 	 */
 	if (endpoint_eq(endpoint, &peer->endpoint))
 		return;
@@ -295,8 +279,7 @@ void wg_socket_set_peer_endpoint(struct wg_peer *peer,
 	write_unlock_bh(&peer->endpoint_lock);
 }
 
-void wg_socket_set_peer_endpoint_from_skb(struct wg_peer *peer,
-					  const struct sk_buff *skb)
+void wg_socket_set_peer_endpoint_from_skb(struct wg_peer *peer, const struct sk_buff *skb)
 {
 	struct endpoint endpoint;
 
@@ -410,10 +393,8 @@ void wg_socket_reinit(struct wg_device *wg, struct sock *new4,
 	struct sock *old4, *old6;
 
 	mutex_lock(&wg->socket_update_lock);
-	old4 = rcu_dereference_protected(wg->sock4,
-				lockdep_is_held(&wg->socket_update_lock));
-	old6 = rcu_dereference_protected(wg->sock6,
-				lockdep_is_held(&wg->socket_update_lock));
+	old4 = rcu_dereference_protected(wg->sock4, lockdep_is_held(&wg->socket_update_lock));
+	old6 = rcu_dereference_protected(wg->sock6, lockdep_is_held(&wg->socket_update_lock));
 	rcu_assign_pointer(wg->sock4, new4);
 	rcu_assign_pointer(wg->sock6, new6);
 	if (new4)
diff --git a/drivers/net/wireguard/socket.h b/drivers/net/wireguard/socket.h
index bab5848efbcd..e1e3f98800f0 100644
--- a/drivers/net/wireguard/socket.h
+++ b/drivers/net/wireguard/socket.h
@@ -12,30 +12,22 @@
 #include <linux/if_ether.h>
 
 int wg_socket_init(struct wg_device *wg, u16 port);
-void wg_socket_reinit(struct wg_device *wg, struct sock *new4,
-		      struct sock *new6);
-int wg_socket_send_buffer_to_peer(struct wg_peer *peer, void *data,
-				  size_t len, u8 ds);
-int wg_socket_send_skb_to_peer(struct wg_peer *peer, struct sk_buff *skb,
-			       u8 ds);
-int wg_socket_send_buffer_as_reply_to_skb(struct wg_device *wg,
-					  struct sk_buff *in_skb,
+void wg_socket_reinit(struct wg_device *wg, struct sock *new4, struct sock *new6);
+int wg_socket_send_buffer_to_peer(struct wg_peer *peer, void *data, size_t len, u8 ds);
+int wg_socket_send_skb_to_peer(struct wg_peer *peer, struct sk_buff *skb, u8 ds);
+int wg_socket_send_buffer_as_reply_to_skb(struct wg_device *wg, struct sk_buff *in_skb,
 					  void *out_buffer, size_t len);
 
-int wg_socket_endpoint_from_skb(struct endpoint *endpoint,
-				const struct sk_buff *skb);
-void wg_socket_set_peer_endpoint(struct wg_peer *peer,
-				 const struct endpoint *endpoint);
-void wg_socket_set_peer_endpoint_from_skb(struct wg_peer *peer,
-					  const struct sk_buff *skb);
+int wg_socket_endpoint_from_skb(struct endpoint *endpoint, const struct sk_buff *skb);
+void wg_socket_set_peer_endpoint(struct wg_peer *peer, const struct endpoint *endpoint);
+void wg_socket_set_peer_endpoint_from_skb(struct wg_peer *peer, const struct sk_buff *skb);
 void wg_socket_clear_peer_endpoint_src(struct wg_peer *peer);
 
 #if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
-#define net_dbg_skb_ratelimited(fmt, dev, skb, ...) do {                       \
-		struct endpoint __endpoint;                                    \
-		wg_socket_endpoint_from_skb(&__endpoint, skb);                 \
-		net_dbg_ratelimited(fmt, dev, &__endpoint.addr,                \
-				    ##__VA_ARGS__);                            \
+#define net_dbg_skb_ratelimited(fmt, dev, skb, ...) do {                          \
+		struct endpoint __endpoint;                                       \
+		wg_socket_endpoint_from_skb(&__endpoint, skb);                    \
+		net_dbg_ratelimited(fmt, dev, &__endpoint.addr,  ##__VA_ARGS__);  \
 	} while (0)
 #else
 #define net_dbg_skb_ratelimited(fmt, skb, ...)
diff --git a/drivers/net/wireguard/timers.c b/drivers/net/wireguard/timers.c
index d54d32ac9bc4..ac8bb6950957 100644
--- a/drivers/net/wireguard/timers.c
+++ b/drivers/net/wireguard/timers.c
@@ -10,21 +10,18 @@
 #include "socket.h"
 
 /*
- * - Timer for retransmitting the handshake if we don't hear back after
- * `REKEY_TIMEOUT + jitter` ms.
+ * - Timer for retransmitting the handshake if we don't hear back after `REKEY_TIMEOUT + jitter` ms.
  *
- * - Timer for sending empty packet if we have received a packet but after have
- * not sent one for `KEEPALIVE_TIMEOUT` ms.
+ * - Timer for sending empty packet if we have received a packet but after have not sent one for
+ *   `KEEPALIVE_TIMEOUT` ms.
  *
- * - Timer for initiating new handshake if we have sent a packet but after have
- * not received one (even empty) for `(KEEPALIVE_TIMEOUT + REKEY_TIMEOUT) +
- * jitter` ms.
+ * - Timer for initiating new handshake if we have sent a packet but after have not received one
+ *   (even empty) for `(KEEPALIVE_TIMEOUT + REKEY_TIMEOUT) + jitter` ms.
  *
- * - Timer for zeroing out all ephemeral keys after `(REJECT_AFTER_TIME * 3)` ms
- * if no new keys have been received.
+ * - Timer for zeroing out all ephemeral keys after `(REJECT_AFTER_TIME * 3)` ms if no new keys have
+ *   been received.
  *
- * - Timer for, if enabled, sending an empty authenticated packet every user-
- * specified seconds.
+ * - Timer for, if enabled, sending an empty authenticated packet every user- specified seconds.
  */
 
 static inline void mod_peer_timer(struct wg_peer *peer,
@@ -32,44 +29,37 @@ static inline void mod_peer_timer(struct wg_peer *peer,
 				  unsigned long expires)
 {
 	rcu_read_lock_bh();
-	if (likely(netif_running(peer->device->dev) &&
-		   !READ_ONCE(peer->is_dead)))
+	if (likely(netif_running(peer->device->dev) && !READ_ONCE(peer->is_dead)))
 		mod_timer(timer, expires);
 	rcu_read_unlock_bh();
 }
 
 static void wg_expired_retransmit_handshake(struct timer_list *timer)
 {
-	struct wg_peer *peer = from_timer(peer, timer,
-					  timer_retransmit_handshake);
+	struct wg_peer *peer = from_timer(peer, timer, timer_retransmit_handshake);
 
 	if (peer->timer_handshake_attempts > MAX_TIMER_HANDSHAKES) {
 		pr_debug("%s: Handshake for peer %llu (%pISpfsc) did not complete after %d attempts, giving up\n",
-			 peer->device->dev->name, peer->internal_id,
-			 &peer->endpoint.addr, MAX_TIMER_HANDSHAKES + 2);
+			 peer->device->dev->name, peer->internal_id, &peer->endpoint.addr,
+			 MAX_TIMER_HANDSHAKES + 2);
 
 		del_timer(&peer->timer_send_keepalive);
-		/* We drop all packets without a keypair and don't try again,
-		 * if we try unsuccessfully for too long to make a handshake.
+		/* We drop all packets without a keypair and don't try again, if we try
+		 * unsuccessfully for too long to make a handshake.
 		 */
 		wg_packet_purge_staged_packets(peer);
 
-		/* We set a timer for destroying any residue that might be left
-		 * of a partial exchange.
-		 */
+		/* We set a timer for destroying any residue that might be left of a partial exchange. */
 		if (!timer_pending(&peer->timer_zero_key_material))
 			mod_peer_timer(peer, &peer->timer_zero_key_material,
 				       jiffies + REJECT_AFTER_TIME * 3 * HZ);
 	} else {
 		++peer->timer_handshake_attempts;
 		pr_debug("%s: Handshake for peer %llu (%pISpfsc) did not complete after %d seconds, retrying (try %d)\n",
-			 peer->device->dev->name, peer->internal_id,
-			 &peer->endpoint.addr, REKEY_TIMEOUT,
-			 peer->timer_handshake_attempts + 1);
+			 peer->device->dev->name, peer->internal_id, &peer->endpoint.addr,
+			 REKEY_TIMEOUT, peer->timer_handshake_attempts + 1);
 
-		/* We clear the endpoint address src address, in case this is
-		 * the cause of trouble.
-		 */
+		/* We clear the endpoint address src address, in case this is the cause of trouble. */
 		wg_socket_clear_peer_endpoint_src(peer);
 
 		wg_packet_send_queued_handshake_initiation(peer, true);
@@ -83,8 +73,7 @@ static void wg_expired_send_keepalive(struct timer_list *timer)
 	wg_packet_send_keepalive(peer);
 	if (peer->timer_need_another_keepalive) {
 		peer->timer_need_another_keepalive = false;
-		mod_peer_timer(peer, &peer->timer_send_keepalive,
-			       jiffies + KEEPALIVE_TIMEOUT * HZ);
+		mod_peer_timer(peer, &peer->timer_send_keepalive, jiffies + KEEPALIVE_TIMEOUT * HZ);
 	}
 }
 
@@ -93,11 +82,9 @@ static void wg_expired_new_handshake(struct timer_list *timer)
 	struct wg_peer *peer = from_timer(peer, timer, timer_new_handshake);
 
 	pr_debug("%s: Retrying handshake with peer %llu (%pISpfsc) because we stopped hearing back after %d seconds\n",
-		 peer->device->dev->name, peer->internal_id,
-		 &peer->endpoint.addr, KEEPALIVE_TIMEOUT + REKEY_TIMEOUT);
-	/* We clear the endpoint address src address, in case this is the cause
-	 * of trouble.
-	 */
+		 peer->device->dev->name, peer->internal_id, &peer->endpoint.addr,
+		 KEEPALIVE_TIMEOUT + REKEY_TIMEOUT);
+	/* We clear the endpoint address src address, in case this is the cause of trouble. */
 	wg_socket_clear_peer_endpoint_src(peer);
 	wg_packet_send_queued_handshake_initiation(peer, false);
 }
@@ -109,11 +96,8 @@ static void wg_expired_zero_key_material(struct timer_list *timer)
 	rcu_read_lock_bh();
 	if (!READ_ONCE(peer->is_dead)) {
 		wg_peer_get(peer);
-		if (!queue_work(peer->device->handshake_send_wq,
-				&peer->clear_peer_work))
-			/* If the work was already on the queue, we want to drop
-			 * the extra reference.
-			 */
+		if (!queue_work(peer->device->handshake_send_wq, &peer->clear_peer_work))
+			/* If the work was already on the queue, we want to drop the extra reference. */
 			wg_peer_put(peer);
 	}
 	rcu_read_unlock_bh();
@@ -121,12 +105,10 @@ static void wg_expired_zero_key_material(struct timer_list *timer)
 
 static void wg_queued_expired_zero_key_material(struct work_struct *work)
 {
-	struct wg_peer *peer = container_of(work, struct wg_peer,
-					    clear_peer_work);
+	struct wg_peer *peer = container_of(work, struct wg_peer, clear_peer_work);
 
 	pr_debug("%s: Zeroing out all keys for peer %llu (%pISpfsc), since we haven't received a new one in %d seconds\n",
-		 peer->device->dev->name, peer->internal_id,
-		 &peer->endpoint.addr, REJECT_AFTER_TIME * 3);
+		 peer->device->dev->name, peer->internal_id, &peer->endpoint.addr, REJECT_AFTER_TIME * 3);
 	wg_noise_handshake_clear(&peer->handshake);
 	wg_noise_keypairs_clear(&peer->keypairs);
 	wg_peer_put(peer);
@@ -134,8 +116,7 @@ static void wg_queued_expired_zero_key_material(struct work_struct *work)
 
 static void wg_expired_send_persistent_keepalive(struct timer_list *timer)
 {
-	struct wg_peer *peer = from_timer(peer, timer,
-					  timer_persistent_keepalive);
+	struct wg_peer *peer = from_timer(peer, timer, timer_persistent_keepalive);
 
 	if (likely(peer->persistent_keepalive_interval))
 		wg_packet_send_keepalive(peer);
@@ -162,16 +143,16 @@ void wg_timers_data_received(struct wg_peer *peer)
 	}
 }
 
-/* Should be called after any type of authenticated packet is sent, whether
- * keepalive, data, or handshake.
+/* Should be called after any type of authenticated packet is sent, whether keepalive, data, or
+ * handshake.
  */
 void wg_timers_any_authenticated_packet_sent(struct wg_peer *peer)
 {
 	del_timer(&peer->timer_send_keepalive);
 }
 
-/* Should be called after any type of authenticated packet is received, whether
- * keepalive, data, or handshake.
+/* Should be called after any type of authenticated packet is received, whether keepalive, data, or
+ * handshake.
  */
 void wg_timers_any_authenticated_packet_received(struct wg_peer *peer)
 {
@@ -181,13 +162,12 @@ void wg_timers_any_authenticated_packet_received(struct wg_peer *peer)
 /* Should be called after a handshake initiation message is sent. */
 void wg_timers_handshake_initiated(struct wg_peer *peer)
 {
-	mod_peer_timer(peer, &peer->timer_retransmit_handshake,
-		       jiffies + REKEY_TIMEOUT * HZ +
-		       prandom_u32_max(REKEY_TIMEOUT_JITTER_MAX_JIFFIES));
+	mod_peer_timer(peer, &peer->timer_retransmit_handshake, jiffies + REKEY_TIMEOUT * HZ +
+						prandom_u32_max(REKEY_TIMEOUT_JITTER_MAX_JIFFIES));
 }
 
-/* Should be called after a handshake response message is received and processed
- * or when getting key confirmation via the first data message.
+/* Should be called after a handshake response message is received and processed or when getting key
+ * confirmation via the first data message.
  */
 void wg_timers_handshake_complete(struct wg_peer *peer)
 {
@@ -197,17 +177,16 @@ void wg_timers_handshake_complete(struct wg_peer *peer)
 	ktime_get_real_ts64(&peer->walltime_last_handshake);
 }
 
-/* Should be called after an ephemeral key is created, which is before sending a
- * handshake response or after receiving a handshake response.
+/* Should be called after an ephemeral key is created, which is before sending a handshake response
+ * or after receiving a handshake response.
  */
 void wg_timers_session_derived(struct wg_peer *peer)
 {
-	mod_peer_timer(peer, &peer->timer_zero_key_material,
-		       jiffies + REJECT_AFTER_TIME * 3 * HZ);
+	mod_peer_timer(peer, &peer->timer_zero_key_material, jiffies + REJECT_AFTER_TIME * 3 * HZ);
 }
 
-/* Should be called before a packet with authentication, whether
- * keepalive, data, or handshakem is sent, or after one is received.
+/* Should be called before a packet with authentication, whether keepalive, data, or handshakem is
+ * sent, or after one is received.
  */
 void wg_timers_any_authenticated_packet_traversal(struct wg_peer *peer)
 {
@@ -218,14 +197,11 @@ void wg_timers_any_authenticated_packet_traversal(struct wg_peer *peer)
 
 void wg_timers_init(struct wg_peer *peer)
 {
-	timer_setup(&peer->timer_retransmit_handshake,
-		    wg_expired_retransmit_handshake, 0);
+	timer_setup(&peer->timer_retransmit_handshake, wg_expired_retransmit_handshake, 0);
 	timer_setup(&peer->timer_send_keepalive, wg_expired_send_keepalive, 0);
 	timer_setup(&peer->timer_new_handshake, wg_expired_new_handshake, 0);
-	timer_setup(&peer->timer_zero_key_material,
-		    wg_expired_zero_key_material, 0);
-	timer_setup(&peer->timer_persistent_keepalive,
-		    wg_expired_send_persistent_keepalive, 0);
+	timer_setup(&peer->timer_zero_key_material, wg_expired_zero_key_material, 0);
+	timer_setup(&peer->timer_persistent_keepalive, wg_expired_send_persistent_keepalive, 0);
 	INIT_WORK(&peer->clear_peer_work, wg_queued_expired_zero_key_material);
 	peer->timer_handshake_attempts = 0;
 	peer->sent_lastminute_handshake = false;
diff --git a/drivers/net/wireguard/timers.h b/drivers/net/wireguard/timers.h
index f0653dcb1326..72fa1606c6f9 100644
--- a/drivers/net/wireguard/timers.h
+++ b/drivers/net/wireguard/timers.h
@@ -21,8 +21,7 @@ void wg_timers_handshake_complete(struct wg_peer *peer);
 void wg_timers_session_derived(struct wg_peer *peer);
 void wg_timers_any_authenticated_packet_traversal(struct wg_peer *peer);
 
-static inline bool wg_birthdate_has_expired(u64 birthday_nanoseconds,
-					    u64 expiration_seconds)
+static inline bool wg_birthdate_has_expired(u64 birthday_nanoseconds, u64 expiration_seconds)
 {
 	return (s64)(birthday_nanoseconds + expiration_seconds * NSEC_PER_SEC)
 		<= (s64)ktime_get_coarse_boottime_ns();
diff --git a/include/uapi/linux/wireguard.h b/include/uapi/linux/wireguard.h
index ae88be14c947..5bfc65c46664 100644
--- a/include/uapi/linux/wireguard.h
+++ b/include/uapi/linux/wireguard.h
@@ -5,23 +5,22 @@
  * Documentation
  * =============
  *
- * The below enums and macros are for interfacing with WireGuard, using generic
- * netlink, with family WG_GENL_NAME and version WG_GENL_VERSION. It defines two
- * methods: get and set. Note that while they share many common attributes,
- * these two functions actually accept a slightly different set of inputs and
- * outputs.
+ * The below enums and macros are for interfacing with WireGuard, using generic netlink, with family
+ * WG_GENL_NAME and version WG_GENL_VERSION. It defines two methods: get and set. Note that while
+ * they share many common attributes, these two functions actually accept a slightly different set
+ * of inputs and outputs.
  *
  * WG_CMD_GET_DEVICE
  * -----------------
  *
- * May only be called via NLM_F_REQUEST | NLM_F_DUMP. The command should contain
- * one but not both of:
+ * May only be called via NLM_F_REQUEST | NLM_F_DUMP. The command should contain one but not both
+ * of:
  *
  *    WGDEVICE_A_IFINDEX: NLA_U32
  *    WGDEVICE_A_IFNAME: NLA_NUL_STRING, maxlen IFNAMSIZ - 1
  *
- * The kernel will then return several messages (NLM_F_MULTI) containing the
- * following tree of nested items:
+ * The kernel will then return several messages (NLM_F_MULTI) containing the following tree of
+ * nested items:
  *
  *    WGDEVICE_A_IFINDEX: NLA_U32
  *    WGDEVICE_A_IFNAME: NLA_NUL_STRING, maxlen IFNAMSIZ - 1
@@ -53,46 +52,39 @@
  *            ...
  *        ...
  *
- * It is possible that all of the allowed IPs of a single peer will not
- * fit within a single netlink message. In that case, the same peer will
- * be written in the following message, except it will only contain
- * WGPEER_A_PUBLIC_KEY and WGPEER_A_ALLOWEDIPS. This may occur several
- * times in a row for the same peer. It is then up to the receiver to
- * coalesce adjacent peers. Likewise, it is possible that all peers will
- * not fit within a single message. So, subsequent peers will be sent
- * in following messages, except those will only contain WGDEVICE_A_IFNAME
- * and WGDEVICE_A_PEERS. It is then up to the receiver to coalesce these
- * messages to form the complete list of peers.
+ * It is possible that all of the allowed IPs of a single peer will not fit within a single netlink
+ * message. In that case, the same peer will be written in the following message, except it will
+ * only contain WGPEER_A_PUBLIC_KEY and WGPEER_A_ALLOWEDIPS. This may occur several times in a row
+ * for the same peer. It is then up to the receiver to coalesce adjacent peers. Likewise, it is
+ * possible that all peers will not fit within a single message. So, subsequent peers will be sent
+ * in following messages, except those will only contain WGDEVICE_A_IFNAME and WGDEVICE_A_PEERS. It
+ * is then up to the receiver to coalesce these messages to form the complete list of peers.
  *
- * Since this is an NLA_F_DUMP command, the final message will always be
- * NLMSG_DONE, even if an error occurs. However, this NLMSG_DONE message
- * contains an integer error code. It is either zero or a negative error
- * code corresponding to the errno.
+ * Since this is an NLA_F_DUMP command, the final message will always be NLMSG_DONE, even if an
+ * error occurs. However, this NLMSG_DONE message contains an integer error code. It is either zero
+ * or a negative error code corresponding to the errno.
  *
  * WG_CMD_SET_DEVICE
  * -----------------
  *
- * May only be called via NLM_F_REQUEST. The command should contain the
- * following tree of nested items, containing one but not both of
- * WGDEVICE_A_IFINDEX and WGDEVICE_A_IFNAME:
+ * May only be called via NLM_F_REQUEST. The command should contain the following tree of nested
+ * items, containing one but not both of WGDEVICE_A_IFINDEX and WGDEVICE_A_IFNAME:
  *
  *    WGDEVICE_A_IFINDEX: NLA_U32
  *    WGDEVICE_A_IFNAME: NLA_NUL_STRING, maxlen IFNAMSIZ - 1
- *    WGDEVICE_A_FLAGS: NLA_U32, 0 or WGDEVICE_F_REPLACE_PEERS if all current
- *                      peers should be removed prior to adding the list below.
+ *    WGDEVICE_A_FLAGS: NLA_U32, 0 or WGDEVICE_F_REPLACE_PEERS if all current peers should be
+ *                      removed prior to adding the list below.
  *    WGDEVICE_A_PRIVATE_KEY: len WG_KEY_LEN, all zeros to remove
  *    WGDEVICE_A_LISTEN_PORT: NLA_U16, 0 to choose randomly
  *    WGDEVICE_A_FWMARK: NLA_U32, 0 to disable
  *    WGDEVICE_A_PEERS: NLA_NESTED
  *        0: NLA_NESTED
  *            WGPEER_A_PUBLIC_KEY: len WG_KEY_LEN
- *            WGPEER_A_FLAGS: NLA_U32, 0 and/or WGPEER_F_REMOVE_ME if the
- *                            specified peer should not exist at the end of the
- *                            operation, rather than added/updated and/or
- *                            WGPEER_F_REPLACE_ALLOWEDIPS if all current allowed
- *                            IPs of this peer should be removed prior to adding
- *                            the list below and/or WGPEER_F_UPDATE_ONLY if the
- *                            peer should only be set if it already exists.
+ *            WGPEER_A_FLAGS: NLA_U32, 0 and/or WGPEER_F_REMOVE_ME if the specified peer should not
+ *                            exist at the end of the operation, rather than added/updated and/or
+ *                            WGPEER_F_REPLACE_ALLOWEDIPS if all current allowed IPs of this peer
+ *                            should be removed prior to adding the list below and/or WGPEER_F_UPDATE_ONLY
+ *                            if the peer should only be set if it already exists.
  *            WGPEER_A_PRESHARED_KEY: len WG_KEY_LEN, all zeros to remove
  *            WGPEER_A_ENDPOINT: struct sockaddr_in or struct sockaddr_in6
  *            WGPEER_A_PERSISTENT_KEEPALIVE_INTERVAL: NLA_U16, 0 to disable
@@ -106,24 +98,20 @@
  *                0: NLA_NESTED
  *                    ...
  *                ...
- *            WGPEER_A_PROTOCOL_VERSION: NLA_U32, should not be set or used at
- *                                       all by most users of this API, as the
- *                                       most recent protocol will be used when
- *                                       this is unset. Otherwise, must be set
- *                                       to 1.
+ *            WGPEER_A_PROTOCOL_VERSION: NLA_U32, should not be set or used at all by most users of
+ *                                       this API, as the most recent protocol will be used when
+ *                                       this is unset. Otherwise, must be set to 1.
  *        0: NLA_NESTED
  *            ...
  *        ...
  *
- * It is possible that the amount of configuration data exceeds that of
- * the maximum message length accepted by the kernel. In that case, several
- * messages should be sent one after another, with each successive one
- * filling in information not contained in the prior. Note that if
- * WGDEVICE_F_REPLACE_PEERS is specified in the first message, it probably
- * should not be specified in fragments that come after, so that the list
- * of peers is only cleared the first time but appended after. Likewise for
- * peers, if WGPEER_F_REPLACE_ALLOWEDIPS is specified in the first message
- * of a peer, it likely should not be specified in subsequent fragments.
+ * It is possible that the amount of configuration data exceeds that of the maximum message length
+ * accepted by the kernel. In that case, several messages should be sent one after another, with
+ * each successive one filling in information not contained in the prior. Note that if
+ * WGDEVICE_F_REPLACE_PEERS is specified in the first message, it probably should not be specified
+ * in fragments that come after, so that the list of peers is only cleared the first time but
+ * appended after. Likewise for peers, if WGPEER_F_REPLACE_ALLOWEDIPS is specified in the first
+ * message of a peer, it likely should not be specified in subsequent fragments.
  *
  * If an error occurs, NLMSG_ERROR will reply containing an errno.
  */
@@ -165,8 +153,7 @@ enum wgpeer_flag {
 	WGPEER_F_REMOVE_ME = 1U << 0,
 	WGPEER_F_REPLACE_ALLOWEDIPS = 1U << 1,
 	WGPEER_F_UPDATE_ONLY = 1U << 2,
-	__WGPEER_F_ALL = WGPEER_F_REMOVE_ME | WGPEER_F_REPLACE_ALLOWEDIPS |
-			 WGPEER_F_UPDATE_ONLY
+	__WGPEER_F_ALL = WGPEER_F_REMOVE_ME | WGPEER_F_REPLACE_ALLOWEDIPS | WGPEER_F_UPDATE_ONLY
 };
 enum wgpeer_attribute {
 	WGPEER_A_UNSPEC,
-- 
2.26.2

