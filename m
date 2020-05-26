Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603BF1DA975
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgETEtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:49:45 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:33443 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgETEtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 00:49:42 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0e64e563;
        Wed, 20 May 2020 04:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=6OFmlunxw7raLosZyI6i6Fj7F
        m8=; b=FkDSCj9mEvTde6+UZeLY2krTECttY22klgPGDH7dHb8XDNQAHhgJkyi9e
        Jx8hpwEW7AFt4XVG6zc4C4MKuxV4+XgFdilGTcLVCF6ovIDFztdl52lM2AfiNsib
        gYdOvrtVqkNT9olOX/ieguWgUJucDIMCWuqOVkb/o3PU2fiJmldmjW3fSh5BYVZk
        zYmLOpXaVZaEMpf0s+sSZuspjO4jX80ztn5PbT0i8YVZ02/NJH+KqFsXwgvysgoq
        C0bTJpp4hbsnXTBvZP/Js5HVohu1DsZsitfGZ3AFnfXKUwJljuBlv7ifvA3js+np
        ClDXEAsu/VIHD/gxQzHqn6KRTp0yw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 63950f81 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 20 May 2020 04:35:14 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 4/4] wireguard: noise: separate receive counter from send counter
Date:   Tue, 19 May 2020 22:49:30 -0600
Message-Id: <20200520044930.8131-5-Jason@zx2c4.com>
In-Reply-To: <20200520044930.8131-1-Jason@zx2c4.com>
References: <20200520044930.8131-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In "wireguard: queueing: preserve flow hash across packet scrubbing", we
were required to slightly increase the size of the receive replay
counter to something still fairly small, but an increase nonetheless.
It turns out that we can recoup some of the additional memory overhead
by splitting up the prior union type into two distinct types. Before, we
used the same "noise_counter" union for both sending and receiving, with
sending just using a simple atomic64_t, while receiving used the full
replay counter checker. This meant that most of the memory being
allocated for the sending counter was being wasted. Since the old
"noise_counter" type increased in size in the prior commit, now is a
good time to split up that union type into a distinct "noise_replay_
counter" for receiving and a boring atomic64_t for sending, each using
neither more nor less memory than required.

Also, since sometimes the replay counter is accessed without
necessitating additional accesses to the bitmap, we can reduce cache
misses by hoisting the always-necessary lock above the bitmap in the
struct layout. We also change a "noise_replay_counter" stack allocation
to kmalloc in a -DDEBUG selftest so that KASAN doesn't trigger a stack
frame warning.

All and all, removing a bit of abstraction in this commit makes the code
simpler and smaller, in addition to the motivating memory usage
recuperation. For example, passing around raw "noise_symmetric_key"
structs is something that really only makes sense within noise.c, in the
one place where the sending and receiving keys can safely be thought of
as the same type of object; subsequent to that, it's important that we
uniformly access these through keypair->{sending,receiving}, where their
distinct roles are always made explicit. So this patch allows us to draw
that distinction clearly as well.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/noise.c            | 16 +++------
 drivers/net/wireguard/noise.h            | 14 ++++----
 drivers/net/wireguard/receive.c          | 42 ++++++++++++------------
 drivers/net/wireguard/selftest/counter.c | 17 +++++++---
 drivers/net/wireguard/send.c             | 12 +++----
 5 files changed, 48 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index 07eb438a6dee..626433690abb 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -104,6 +104,7 @@ static struct noise_keypair *keypair_create(struct wg_peer *peer)
 
 	if (unlikely(!keypair))
 		return NULL;
+	spin_lock_init(&keypair->receiving_counter.lock);
 	keypair->internal_id = atomic64_inc_return(&keypair_counter);
 	keypair->entry.type = INDEX_HASHTABLE_KEYPAIR;
 	keypair->entry.peer = peer;
@@ -358,25 +359,16 @@ static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
 	memzero_explicit(output, BLAKE2S_HASH_SIZE + 1);
 }
 
-static void symmetric_key_init(struct noise_symmetric_key *key)
-{
-	spin_lock_init(&key->counter.receive.lock);
-	atomic64_set(&key->counter.counter, 0);
-	memset(key->counter.receive.backtrack, 0,
-	       sizeof(key->counter.receive.backtrack));
-	key->birthdate = ktime_get_coarse_boottime_ns();
-	key->is_valid = true;
-}
-
 static void derive_keys(struct noise_symmetric_key *first_dst,
 			struct noise_symmetric_key *second_dst,
 			const u8 chaining_key[NOISE_HASH_LEN])
 {
+	u64 birthdate = ktime_get_coarse_boottime_ns();
 	kdf(first_dst->key, second_dst->key, NULL, NULL,
 	    NOISE_SYMMETRIC_KEY_LEN, NOISE_SYMMETRIC_KEY_LEN, 0, 0,
 	    chaining_key);
-	symmetric_key_init(first_dst);
-	symmetric_key_init(second_dst);
+	first_dst->birthdate = second_dst->birthdate = birthdate;
+	first_dst->is_valid = second_dst->is_valid = true;
 }
 
 static bool __must_check mix_dh(u8 chaining_key[NOISE_HASH_LEN],
diff --git a/drivers/net/wireguard/noise.h b/drivers/net/wireguard/noise.h
index f532d59d3f19..c527253dba80 100644
--- a/drivers/net/wireguard/noise.h
+++ b/drivers/net/wireguard/noise.h
@@ -15,18 +15,14 @@
 #include <linux/mutex.h>
 #include <linux/kref.h>
 
-union noise_counter {
-	struct {
-		u64 counter;
-		unsigned long backtrack[COUNTER_BITS_TOTAL / BITS_PER_LONG];
-		spinlock_t lock;
-	} receive;
-	atomic64_t counter;
+struct noise_replay_counter {
+	u64 counter;
+	spinlock_t lock;
+	unsigned long backtrack[COUNTER_BITS_TOTAL / BITS_PER_LONG];
 };
 
 struct noise_symmetric_key {
 	u8 key[NOISE_SYMMETRIC_KEY_LEN];
-	union noise_counter counter;
 	u64 birthdate;
 	bool is_valid;
 };
@@ -34,7 +30,9 @@ struct noise_symmetric_key {
 struct noise_keypair {
 	struct index_hashtable_entry entry;
 	struct noise_symmetric_key sending;
+	atomic64_t sending_counter;
 	struct noise_symmetric_key receiving;
+	struct noise_replay_counter receiving_counter;
 	__le32 remote_index;
 	bool i_am_the_initiator;
 	struct kref refcount;
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index d0eebd90c9d5..91438144e4f7 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -245,20 +245,20 @@ static void keep_key_fresh(struct wg_peer *peer)
 	}
 }
 
-static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key)
+static bool decrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 {
 	struct scatterlist sg[MAX_SKB_FRAGS + 8];
 	struct sk_buff *trailer;
 	unsigned int offset;
 	int num_frags;
 
-	if (unlikely(!key))
+	if (unlikely(!keypair))
 		return false;
 
-	if (unlikely(!READ_ONCE(key->is_valid) ||
-		  wg_birthdate_has_expired(key->birthdate, REJECT_AFTER_TIME) ||
-		  key->counter.receive.counter >= REJECT_AFTER_MESSAGES)) {
-		WRITE_ONCE(key->is_valid, false);
+	if (unlikely(!READ_ONCE(keypair->receiving.is_valid) ||
+		  wg_birthdate_has_expired(keypair->receiving.birthdate, REJECT_AFTER_TIME) ||
+		  keypair->receiving_counter.counter >= REJECT_AFTER_MESSAGES)) {
+		WRITE_ONCE(keypair->receiving.is_valid, false);
 		return false;
 	}
 
@@ -283,7 +283,7 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key)
 
 	if (!chacha20poly1305_decrypt_sg_inplace(sg, skb->len, NULL, 0,
 					         PACKET_CB(skb)->nonce,
-						 key->key))
+						 keypair->receiving.key))
 		return false;
 
 	/* Another ugly situation of pushing and pulling the header so as to
@@ -298,41 +298,41 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key)
 }
 
 /* This is RFC6479, a replay detection bitmap algorithm that avoids bitshifts */
-static bool counter_validate(union noise_counter *counter, u64 their_counter)
+static bool counter_validate(struct noise_replay_counter *counter, u64 their_counter)
 {
 	unsigned long index, index_current, top, i;
 	bool ret = false;
 
-	spin_lock_bh(&counter->receive.lock);
+	spin_lock_bh(&counter->lock);
 
-	if (unlikely(counter->receive.counter >= REJECT_AFTER_MESSAGES + 1 ||
+	if (unlikely(counter->counter >= REJECT_AFTER_MESSAGES + 1 ||
 		     their_counter >= REJECT_AFTER_MESSAGES))
 		goto out;
 
 	++their_counter;
 
 	if (unlikely((COUNTER_WINDOW_SIZE + their_counter) <
-		     counter->receive.counter))
+		     counter->counter))
 		goto out;
 
 	index = their_counter >> ilog2(BITS_PER_LONG);
 
-	if (likely(their_counter > counter->receive.counter)) {
-		index_current = counter->receive.counter >> ilog2(BITS_PER_LONG);
+	if (likely(their_counter > counter->counter)) {
+		index_current = counter->counter >> ilog2(BITS_PER_LONG);
 		top = min_t(unsigned long, index - index_current,
 			    COUNTER_BITS_TOTAL / BITS_PER_LONG);
 		for (i = 1; i <= top; ++i)
-			counter->receive.backtrack[(i + index_current) &
+			counter->backtrack[(i + index_current) &
 				((COUNTER_BITS_TOTAL / BITS_PER_LONG) - 1)] = 0;
-		counter->receive.counter = their_counter;
+		counter->counter = their_counter;
 	}
 
 	index &= (COUNTER_BITS_TOTAL / BITS_PER_LONG) - 1;
 	ret = !test_and_set_bit(their_counter & (BITS_PER_LONG - 1),
-				&counter->receive.backtrack[index]);
+				&counter->backtrack[index]);
 
 out:
-	spin_unlock_bh(&counter->receive.lock);
+	spin_unlock_bh(&counter->lock);
 	return ret;
 }
 
@@ -472,12 +472,12 @@ int wg_packet_rx_poll(struct napi_struct *napi, int budget)
 		if (unlikely(state != PACKET_STATE_CRYPTED))
 			goto next;
 
-		if (unlikely(!counter_validate(&keypair->receiving.counter,
+		if (unlikely(!counter_validate(&keypair->receiving_counter,
 					       PACKET_CB(skb)->nonce))) {
 			net_dbg_ratelimited("%s: Packet has invalid nonce %llu (max %llu)\n",
 					    peer->device->dev->name,
 					    PACKET_CB(skb)->nonce,
-					    keypair->receiving.counter.receive.counter);
+					    keypair->receiving_counter.counter);
 			goto next;
 		}
 
@@ -511,8 +511,8 @@ void wg_packet_decrypt_worker(struct work_struct *work)
 	struct sk_buff *skb;
 
 	while ((skb = ptr_ring_consume_bh(&queue->ring)) != NULL) {
-		enum packet_state state = likely(decrypt_packet(skb,
-				&PACKET_CB(skb)->keypair->receiving)) ?
+		enum packet_state state =
+			likely(decrypt_packet(skb, PACKET_CB(skb)->keypair)) ?
 				PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
 		wg_queue_enqueue_per_peer_napi(skb, state);
 		if (need_resched())
diff --git a/drivers/net/wireguard/selftest/counter.c b/drivers/net/wireguard/selftest/counter.c
index f4fbb9072ed7..ec3c156bf91b 100644
--- a/drivers/net/wireguard/selftest/counter.c
+++ b/drivers/net/wireguard/selftest/counter.c
@@ -6,18 +6,24 @@
 #ifdef DEBUG
 bool __init wg_packet_counter_selftest(void)
 {
+	struct noise_replay_counter *counter;
 	unsigned int test_num = 0, i;
-	union noise_counter counter;
 	bool success = true;
 
-#define T_INIT do {                                               \
-		memset(&counter, 0, sizeof(union noise_counter)); \
-		spin_lock_init(&counter.receive.lock);            \
+	counter = kmalloc(sizeof(*counter), GFP_KERNEL);
+	if (unlikely(!counter)) {
+		pr_err("nonce counter self-test malloc: FAIL\n");
+		return false;
+	}
+
+#define T_INIT do {                                    \
+		memset(counter, 0, sizeof(*counter));  \
+		spin_lock_init(&counter->lock);        \
 	} while (0)
 #define T_LIM (COUNTER_WINDOW_SIZE + 1)
 #define T(n, v) do {                                                  \
 		++test_num;                                           \
-		if (counter_validate(&counter, n) != (v)) {           \
+		if (counter_validate(counter, n) != (v)) {            \
 			pr_err("nonce counter self-test %u: FAIL\n",  \
 			       test_num);                             \
 			success = false;                              \
@@ -99,6 +105,7 @@ bool __init wg_packet_counter_selftest(void)
 
 	if (success)
 		pr_info("nonce counter self-tests: pass\n");
+	kfree(counter);
 	return success;
 }
 #endif
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index 2f5119ff93d8..f74b9341ab0f 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -129,7 +129,7 @@ static void keep_key_fresh(struct wg_peer *peer)
 	rcu_read_lock_bh();
 	keypair = rcu_dereference_bh(peer->keypairs.current_keypair);
 	send = keypair && READ_ONCE(keypair->sending.is_valid) &&
-	       (atomic64_read(&keypair->sending.counter.counter) > REKEY_AFTER_MESSAGES ||
+	       (atomic64_read(&keypair->sending_counter) > REKEY_AFTER_MESSAGES ||
 		(keypair->i_am_the_initiator &&
 		 wg_birthdate_has_expired(keypair->sending.birthdate, REKEY_AFTER_TIME)));
 	rcu_read_unlock_bh();
@@ -349,7 +349,6 @@ void wg_packet_purge_staged_packets(struct wg_peer *peer)
 
 void wg_packet_send_staged_packets(struct wg_peer *peer)
 {
-	struct noise_symmetric_key *key;
 	struct noise_keypair *keypair;
 	struct sk_buff_head packets;
 	struct sk_buff *skb;
@@ -369,10 +368,9 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
 	rcu_read_unlock_bh();
 	if (unlikely(!keypair))
 		goto out_nokey;
-	key = &keypair->sending;
-	if (unlikely(!READ_ONCE(key->is_valid)))
+	if (unlikely(!READ_ONCE(keypair->sending.is_valid)))
 		goto out_nokey;
-	if (unlikely(wg_birthdate_has_expired(key->birthdate,
+	if (unlikely(wg_birthdate_has_expired(keypair->sending.birthdate,
 					      REJECT_AFTER_TIME)))
 		goto out_invalid;
 
@@ -387,7 +385,7 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
 		 */
 		PACKET_CB(skb)->ds = ip_tunnel_ecn_encap(0, ip_hdr(skb), skb);
 		PACKET_CB(skb)->nonce =
-				atomic64_inc_return(&key->counter.counter) - 1;
+				atomic64_inc_return(&keypair->sending_counter) - 1;
 		if (unlikely(PACKET_CB(skb)->nonce >= REJECT_AFTER_MESSAGES))
 			goto out_invalid;
 	}
@@ -399,7 +397,7 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
 	return;
 
 out_invalid:
-	WRITE_ONCE(key->is_valid, false);
+	WRITE_ONCE(keypair->sending.is_valid, false);
 out_nokey:
 	wg_noise_keypair_put(keypair, false);
 
-- 
2.26.2

