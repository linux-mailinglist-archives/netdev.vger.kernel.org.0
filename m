Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EC11F2C89
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgFIAYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730392AbgFHXRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:17:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E92620814;
        Mon,  8 Jun 2020 23:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658221;
        bh=+TcgT78npKn9VMqKDNBMmUor9hgNRC2OV7K4FxsJqdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKbXWK16abSGzzHz2blATR0rSIChLsC1DmZom2Ga8CHI/M5rsqpHkJ2tOYHtKsUTP
         /7/7gt9X7XvfGGO8vRet3MoP1vc/TSA5N3bMe8e+2CczGxvnMlUeAtWig9wNLhMQtt
         twkda64mzbV7nH6zLtFiPfWmGTgx33xiIyjbQWSY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 236/606] wireguard: noise: separate receive counter from send counter
Date:   Mon,  8 Jun 2020 19:06:01 -0400
Message-Id: <20200608231211.3363633-236-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit a9e90d9931f3a474f04bab782ccd9d77904941e9 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
index 758d6a019184..474bb69f0e1b 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -246,20 +246,20 @@ static void keep_key_fresh(struct wg_peer *peer)
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
 
@@ -284,7 +284,7 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key)
 
 	if (!chacha20poly1305_decrypt_sg_inplace(sg, skb->len, NULL, 0,
 					         PACKET_CB(skb)->nonce,
-						 key->key))
+						 keypair->receiving.key))
 		return false;
 
 	/* Another ugly situation of pushing and pulling the header so as to
@@ -299,41 +299,41 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key)
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
 
@@ -473,12 +473,12 @@ int wg_packet_rx_poll(struct napi_struct *napi, int budget)
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
 
@@ -512,8 +512,8 @@ void wg_packet_decrypt_worker(struct work_struct *work)
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
index 0d64a7531f64..485d5d7a217b 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -129,7 +129,7 @@ static void keep_key_fresh(struct wg_peer *peer)
 	rcu_read_lock_bh();
 	keypair = rcu_dereference_bh(peer->keypairs.current_keypair);
 	if (likely(keypair && READ_ONCE(keypair->sending.is_valid)) &&
-	    (unlikely(atomic64_read(&keypair->sending.counter.counter) >
+	    (unlikely(atomic64_read(&keypair->sending_counter) >
 		      REKEY_AFTER_MESSAGES) ||
 	     (keypair->i_am_the_initiator &&
 	      unlikely(wg_birthdate_has_expired(keypair->sending.birthdate,
@@ -353,7 +353,6 @@ void wg_packet_purge_staged_packets(struct wg_peer *peer)
 
 void wg_packet_send_staged_packets(struct wg_peer *peer)
 {
-	struct noise_symmetric_key *key;
 	struct noise_keypair *keypair;
 	struct sk_buff_head packets;
 	struct sk_buff *skb;
@@ -373,10 +372,9 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
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
 
@@ -391,7 +389,7 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
 		 */
 		PACKET_CB(skb)->ds = ip_tunnel_ecn_encap(0, ip_hdr(skb), skb);
 		PACKET_CB(skb)->nonce =
-				atomic64_inc_return(&key->counter.counter) - 1;
+				atomic64_inc_return(&keypair->sending_counter) - 1;
 		if (unlikely(PACKET_CB(skb)->nonce >= REJECT_AFTER_MESSAGES))
 			goto out_invalid;
 	}
@@ -403,7 +401,7 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
 	return;
 
 out_invalid:
-	WRITE_ONCE(key->is_valid, false);
+	WRITE_ONCE(keypair->sending.is_valid, false);
 out_nokey:
 	wg_noise_keypair_put(keypair, false);
 
-- 
2.25.1

