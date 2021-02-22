Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B96321D03
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhBVQaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:30:19 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:32820 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231816AbhBVQ2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 11:28:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614011163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+grUblbK7VAJc9eNG0TZW74b0x/WCD5IH7WBY+fHDzU=;
        b=Gkp6gLOQ3er25X/IOxPjEmwNENCClMi1tt8HXsfal4jkl/tmZAF3dh1O/Lw0ZXk3uD4uf3
        I6fDTBKDuxwZogr/rChwh9gwrccSI0cNPBsPDz7r3yN9svCL4RuLUbIlJe9ZE6mLUn0GM7
        vjEXIZ8Ul4/b5LvWsumRbaxTmefNAyg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 73e5786c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 22 Feb 2021 16:26:03 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH net 6/7] wireguard: queueing: get rid of per-peer ring buffers
Date:   Mon, 22 Feb 2021 17:25:48 +0100
Message-Id: <20210222162549.3252778-7-Jason@zx2c4.com>
In-Reply-To: <20210222162549.3252778-1-Jason@zx2c4.com>
References: <20210222162549.3252778-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having two ring buffers per-peer means that every peer results in two
massive ring allocations. On an 8-core x86_64 machine, this commit
reduces the per-peer allocation from 18,688 bytes to 1,856 bytes, which
is an 90% reduction. Ninety percent! With some single-machine
deployments approaching 500,000 peers, we're talking about a reduction
from 7 gigs of memory down to 700 megs of memory.

In order to get rid of these per-peer allocations, this commit switches
to using a list-based queueing approach. Currently GSO fragments are
chained together using the skb->next pointer (the skb_list_* singly
linked list approach), so we form the per-peer queue around the unused
skb->prev pointer (which sort of makes sense because the links are
pointing backwards). Use of skb_queue_* is not possible here, because
that is based on doubly linked lists and spinlocks. Multiple cores can
write into the queue at any given time, because its writes occur in the
start_xmit path or in the udp_recv path. But reads happen in a single
workqueue item per-peer, amounting to a multi-producer, single-consumer
paradigm.

The MPSC queue is implemented locklessly and never blocks. However, it
is not linearizable (though it is serializable), with a very tight and
unlikely race on writes, which, when hit (some tiny fraction of the
0.15% of partial adds on a fully loaded 16-core x86_64 system), causes
the queue reader to terminate early. However, because every packet sent
queues up the same workqueue item after it is fully added, the worker
resumes again, and stopping early isn't actually a problem, since at
that point the packet wouldn't have yet been added to the encryption
queue. These properties allow us to avoid disabling interrupts or
spinning. The design is based on Dmitry Vyukov's algorithm [1].

Performance-wise, ordinarily list-based queues aren't preferable to
ringbuffers, because of cache misses when following pointers around.
However, we *already* have to follow the adjacent pointers when working
through fragments, so there shouldn't actually be any change there. A
potential downside is that dequeueing is a bit more complicated, but the
ptr_ring structure used prior had a spinlock when dequeueing, so all and
all the difference appears to be a wash.

Actually, from profiling, the biggest performance hit, by far, of this
commit winds up being atomic_add_unless(count, 1, max) and atomic_
dec(count), which account for the majority of CPU time, according to
perf. In that sense, the previous ring buffer was superior in that it
could check if it was full by head==tail, which the list-based approach
cannot do.

But all and all, this enables us to get massive memory savings, allowing
WireGuard to scale for real world deployments, without taking much of a
performance hit.

[1] http://www.1024cores.net/home/lock-free-algorithms/queues/intrusive-mpsc-node-based-queue

Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.c   | 12 ++---
 drivers/net/wireguard/device.h   | 15 +++---
 drivers/net/wireguard/peer.c     | 28 ++++-------
 drivers/net/wireguard/peer.h     |  4 +-
 drivers/net/wireguard/queueing.c | 86 +++++++++++++++++++++++++-------
 drivers/net/wireguard/queueing.h | 45 ++++++++++++-----
 drivers/net/wireguard/receive.c  | 16 +++---
 drivers/net/wireguard/send.c     | 31 ++++--------
 8 files changed, 144 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 8502e1b083ff..551ddaaaf540 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -235,8 +235,8 @@ static void wg_destruct(struct net_device *dev)
 	destroy_workqueue(wg->handshake_receive_wq);
 	destroy_workqueue(wg->handshake_send_wq);
 	destroy_workqueue(wg->packet_crypt_wq);
-	wg_packet_queue_free(&wg->decrypt_queue, true);
-	wg_packet_queue_free(&wg->encrypt_queue, true);
+	wg_packet_queue_free(&wg->decrypt_queue);
+	wg_packet_queue_free(&wg->encrypt_queue);
 	rcu_barrier(); /* Wait for all the peers to be actually freed. */
 	wg_ratelimiter_uninit();
 	memzero_explicit(&wg->static_identity, sizeof(wg->static_identity));
@@ -338,12 +338,12 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 		goto err_destroy_handshake_send;
 
 	ret = wg_packet_queue_init(&wg->encrypt_queue, wg_packet_encrypt_worker,
-				   true, MAX_QUEUED_PACKETS);
+				   MAX_QUEUED_PACKETS);
 	if (ret < 0)
 		goto err_destroy_packet_crypt;
 
 	ret = wg_packet_queue_init(&wg->decrypt_queue, wg_packet_decrypt_worker,
-				   true, MAX_QUEUED_PACKETS);
+				   MAX_QUEUED_PACKETS);
 	if (ret < 0)
 		goto err_free_encrypt_queue;
 
@@ -368,9 +368,9 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 err_uninit_ratelimiter:
 	wg_ratelimiter_uninit();
 err_free_decrypt_queue:
-	wg_packet_queue_free(&wg->decrypt_queue, true);
+	wg_packet_queue_free(&wg->decrypt_queue);
 err_free_encrypt_queue:
-	wg_packet_queue_free(&wg->encrypt_queue, true);
+	wg_packet_queue_free(&wg->encrypt_queue);
 err_destroy_packet_crypt:
 	destroy_workqueue(wg->packet_crypt_wq);
 err_destroy_handshake_send:
diff --git a/drivers/net/wireguard/device.h b/drivers/net/wireguard/device.h
index 4d0144e16947..854bc3d97150 100644
--- a/drivers/net/wireguard/device.h
+++ b/drivers/net/wireguard/device.h
@@ -27,13 +27,14 @@ struct multicore_worker {
 
 struct crypt_queue {
 	struct ptr_ring ring;
-	union {
-		struct {
-			struct multicore_worker __percpu *worker;
-			int last_cpu;
-		};
-		struct work_struct work;
-	};
+	struct multicore_worker __percpu *worker;
+	int last_cpu;
+};
+
+struct prev_queue {
+	struct sk_buff *head, *tail, *peeked;
+	struct { struct sk_buff *next, *prev; } empty; // Match first 2 members of struct sk_buff.
+	atomic_t count;
 };
 
 struct wg_device {
diff --git a/drivers/net/wireguard/peer.c b/drivers/net/wireguard/peer.c
index b3b6370e6b95..cd5cb0292cb6 100644
--- a/drivers/net/wireguard/peer.c
+++ b/drivers/net/wireguard/peer.c
@@ -32,27 +32,22 @@ struct wg_peer *wg_peer_create(struct wg_device *wg,
 	peer = kzalloc(sizeof(*peer), GFP_KERNEL);
 	if (unlikely(!peer))
 		return ERR_PTR(ret);
-	peer->device = wg;
+	if (dst_cache_init(&peer->endpoint_cache, GFP_KERNEL))
+		goto err;
 
+	peer->device = wg;
 	wg_noise_handshake_init(&peer->handshake, &wg->static_identity,
 				public_key, preshared_key, peer);
-	if (dst_cache_init(&peer->endpoint_cache, GFP_KERNEL))
-		goto err_1;
-	if (wg_packet_queue_init(&peer->tx_queue, wg_packet_tx_worker, false,
-				 MAX_QUEUED_PACKETS))
-		goto err_2;
-	if (wg_packet_queue_init(&peer->rx_queue, NULL, false,
-				 MAX_QUEUED_PACKETS))
-		goto err_3;
-
 	peer->internal_id = atomic64_inc_return(&peer_counter);
 	peer->serial_work_cpu = nr_cpumask_bits;
 	wg_cookie_init(&peer->latest_cookie);
 	wg_timers_init(peer);
 	wg_cookie_checker_precompute_peer_keys(peer);
 	spin_lock_init(&peer->keypairs.keypair_update_lock);
-	INIT_WORK(&peer->transmit_handshake_work,
-		  wg_packet_handshake_send_worker);
+	INIT_WORK(&peer->transmit_handshake_work, wg_packet_handshake_send_worker);
+	INIT_WORK(&peer->transmit_packet_work, wg_packet_tx_worker);
+	wg_prev_queue_init(&peer->tx_queue);
+	wg_prev_queue_init(&peer->rx_queue);
 	rwlock_init(&peer->endpoint_lock);
 	kref_init(&peer->refcount);
 	skb_queue_head_init(&peer->staged_packet_queue);
@@ -68,11 +63,7 @@ struct wg_peer *wg_peer_create(struct wg_device *wg,
 	pr_debug("%s: Peer %llu created\n", wg->dev->name, peer->internal_id);
 	return peer;
 
-err_3:
-	wg_packet_queue_free(&peer->tx_queue, false);
-err_2:
-	dst_cache_destroy(&peer->endpoint_cache);
-err_1:
+err:
 	kfree(peer);
 	return ERR_PTR(ret);
 }
@@ -197,8 +188,7 @@ static void rcu_release(struct rcu_head *rcu)
 	struct wg_peer *peer = container_of(rcu, struct wg_peer, rcu);
 
 	dst_cache_destroy(&peer->endpoint_cache);
-	wg_packet_queue_free(&peer->rx_queue, false);
-	wg_packet_queue_free(&peer->tx_queue, false);
+	WARN_ON(wg_prev_queue_peek(&peer->tx_queue) || wg_prev_queue_peek(&peer->rx_queue));
 
 	/* The final zeroing takes care of clearing any remaining handshake key
 	 * material and other potentially sensitive information.
diff --git a/drivers/net/wireguard/peer.h b/drivers/net/wireguard/peer.h
index aaff8de6e34b..8d53b687a1d1 100644
--- a/drivers/net/wireguard/peer.h
+++ b/drivers/net/wireguard/peer.h
@@ -36,7 +36,7 @@ struct endpoint {
 
 struct wg_peer {
 	struct wg_device *device;
-	struct crypt_queue tx_queue, rx_queue;
+	struct prev_queue tx_queue, rx_queue;
 	struct sk_buff_head staged_packet_queue;
 	int serial_work_cpu;
 	bool is_dead;
@@ -46,7 +46,7 @@ struct wg_peer {
 	rwlock_t endpoint_lock;
 	struct noise_handshake handshake;
 	atomic64_t last_sent_handshake;
-	struct work_struct transmit_handshake_work, clear_peer_work;
+	struct work_struct transmit_handshake_work, clear_peer_work, transmit_packet_work;
 	struct cookie latest_cookie;
 	struct hlist_node pubkey_hash;
 	u64 rx_bytes, tx_bytes;
diff --git a/drivers/net/wireguard/queueing.c b/drivers/net/wireguard/queueing.c
index 71b8e80b58e1..48e7b982a307 100644
--- a/drivers/net/wireguard/queueing.c
+++ b/drivers/net/wireguard/queueing.c
@@ -9,8 +9,7 @@ struct multicore_worker __percpu *
 wg_packet_percpu_multicore_worker_alloc(work_func_t function, void *ptr)
 {
 	int cpu;
-	struct multicore_worker __percpu *worker =
-		alloc_percpu(struct multicore_worker);
+	struct multicore_worker __percpu *worker = alloc_percpu(struct multicore_worker);
 
 	if (!worker)
 		return NULL;
@@ -23,7 +22,7 @@ wg_packet_percpu_multicore_worker_alloc(work_func_t function, void *ptr)
 }
 
 int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function,
-			 bool multicore, unsigned int len)
+			 unsigned int len)
 {
 	int ret;
 
@@ -31,25 +30,78 @@ int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function,
 	ret = ptr_ring_init(&queue->ring, len, GFP_KERNEL);
 	if (ret)
 		return ret;
-	if (function) {
-		if (multicore) {
-			queue->worker = wg_packet_percpu_multicore_worker_alloc(
-				function, queue);
-			if (!queue->worker) {
-				ptr_ring_cleanup(&queue->ring, NULL);
-				return -ENOMEM;
-			}
-		} else {
-			INIT_WORK(&queue->work, function);
-		}
+	queue->worker = wg_packet_percpu_multicore_worker_alloc(function, queue);
+	if (!queue->worker) {
+		ptr_ring_cleanup(&queue->ring, NULL);
+		return -ENOMEM;
 	}
 	return 0;
 }
 
-void wg_packet_queue_free(struct crypt_queue *queue, bool multicore)
+void wg_packet_queue_free(struct crypt_queue *queue)
 {
-	if (multicore)
-		free_percpu(queue->worker);
+	free_percpu(queue->worker);
 	WARN_ON(!__ptr_ring_empty(&queue->ring));
 	ptr_ring_cleanup(&queue->ring, NULL);
 }
+
+#define NEXT(skb) ((skb)->prev)
+#define STUB(queue) ((struct sk_buff *)&queue->empty)
+
+void wg_prev_queue_init(struct prev_queue *queue)
+{
+	NEXT(STUB(queue)) = NULL;
+	queue->head = queue->tail = STUB(queue);
+	queue->peeked = NULL;
+	atomic_set(&queue->count, 0);
+	BUILD_BUG_ON(
+		offsetof(struct sk_buff, next) != offsetof(struct prev_queue, empty.next) -
+							offsetof(struct prev_queue, empty) ||
+		offsetof(struct sk_buff, prev) != offsetof(struct prev_queue, empty.prev) -
+							 offsetof(struct prev_queue, empty));
+}
+
+static void __wg_prev_queue_enqueue(struct prev_queue *queue, struct sk_buff *skb)
+{
+	WRITE_ONCE(NEXT(skb), NULL);
+	WRITE_ONCE(NEXT(xchg_release(&queue->head, skb)), skb);
+}
+
+bool wg_prev_queue_enqueue(struct prev_queue *queue, struct sk_buff *skb)
+{
+	if (!atomic_add_unless(&queue->count, 1, MAX_QUEUED_PACKETS))
+		return false;
+	__wg_prev_queue_enqueue(queue, skb);
+	return true;
+}
+
+struct sk_buff *wg_prev_queue_dequeue(struct prev_queue *queue)
+{
+	struct sk_buff *tail = queue->tail, *next = smp_load_acquire(&NEXT(tail));
+
+	if (tail == STUB(queue)) {
+		if (!next)
+			return NULL;
+		queue->tail = next;
+		tail = next;
+		next = smp_load_acquire(&NEXT(next));
+	}
+	if (next) {
+		queue->tail = next;
+		atomic_dec(&queue->count);
+		return tail;
+	}
+	if (tail != READ_ONCE(queue->head))
+		return NULL;
+	__wg_prev_queue_enqueue(queue, STUB(queue));
+	next = smp_load_acquire(&NEXT(tail));
+	if (next) {
+		queue->tail = next;
+		atomic_dec(&queue->count);
+		return tail;
+	}
+	return NULL;
+}
+
+#undef NEXT
+#undef STUB
diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index dfb674e03076..4ef2944a68bc 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -17,12 +17,13 @@ struct wg_device;
 struct wg_peer;
 struct multicore_worker;
 struct crypt_queue;
+struct prev_queue;
 struct sk_buff;
 
 /* queueing.c APIs: */
 int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function,
-			 bool multicore, unsigned int len);
-void wg_packet_queue_free(struct crypt_queue *queue, bool multicore);
+			 unsigned int len);
+void wg_packet_queue_free(struct crypt_queue *queue);
 struct multicore_worker __percpu *
 wg_packet_percpu_multicore_worker_alloc(work_func_t function, void *ptr);
 
@@ -135,8 +136,31 @@ static inline int wg_cpumask_next_online(int *next)
 	return cpu;
 }
 
+void wg_prev_queue_init(struct prev_queue *queue);
+
+/* Multi producer */
+bool wg_prev_queue_enqueue(struct prev_queue *queue, struct sk_buff *skb);
+
+/* Single consumer */
+struct sk_buff *wg_prev_queue_dequeue(struct prev_queue *queue);
+
+/* Single consumer */
+static inline struct sk_buff *wg_prev_queue_peek(struct prev_queue *queue)
+{
+	if (queue->peeked)
+		return queue->peeked;
+	queue->peeked = wg_prev_queue_dequeue(queue);
+	return queue->peeked;
+}
+
+/* Single consumer */
+static inline void wg_prev_queue_drop_peeked(struct prev_queue *queue)
+{
+	queue->peeked = NULL;
+}
+
 static inline int wg_queue_enqueue_per_device_and_peer(
-	struct crypt_queue *device_queue, struct crypt_queue *peer_queue,
+	struct crypt_queue *device_queue, struct prev_queue *peer_queue,
 	struct sk_buff *skb, struct workqueue_struct *wq, int *next_cpu)
 {
 	int cpu;
@@ -145,8 +169,9 @@ static inline int wg_queue_enqueue_per_device_and_peer(
 	/* We first queue this up for the peer ingestion, but the consumer
 	 * will wait for the state to change to CRYPTED or DEAD before.
 	 */
-	if (unlikely(ptr_ring_produce_bh(&peer_queue->ring, skb)))
+	if (unlikely(!wg_prev_queue_enqueue(peer_queue, skb)))
 		return -ENOSPC;
+
 	/* Then we queue it up in the device queue, which consumes the
 	 * packet as soon as it can.
 	 */
@@ -157,9 +182,7 @@ static inline int wg_queue_enqueue_per_device_and_peer(
 	return 0;
 }
 
-static inline void wg_queue_enqueue_per_peer(struct crypt_queue *queue,
-					     struct sk_buff *skb,
-					     enum packet_state state)
+static inline void wg_queue_enqueue_per_peer_tx(struct sk_buff *skb, enum packet_state state)
 {
 	/* We take a reference, because as soon as we call atomic_set, the
 	 * peer can be freed from below us.
@@ -167,14 +190,12 @@ static inline void wg_queue_enqueue_per_peer(struct crypt_queue *queue,
 	struct wg_peer *peer = wg_peer_get(PACKET_PEER(skb));
 
 	atomic_set_release(&PACKET_CB(skb)->state, state);
-	queue_work_on(wg_cpumask_choose_online(&peer->serial_work_cpu,
-					       peer->internal_id),
-		      peer->device->packet_crypt_wq, &queue->work);
+	queue_work_on(wg_cpumask_choose_online(&peer->serial_work_cpu, peer->internal_id),
+		      peer->device->packet_crypt_wq, &peer->transmit_packet_work);
 	wg_peer_put(peer);
 }
 
-static inline void wg_queue_enqueue_per_peer_napi(struct sk_buff *skb,
-						  enum packet_state state)
+static inline void wg_queue_enqueue_per_peer_rx(struct sk_buff *skb, enum packet_state state)
 {
 	/* We take a reference, because as soon as we call atomic_set, the
 	 * peer can be freed from below us.
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 2c9551ea6dc7..7dc84bcca261 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -444,7 +444,6 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 int wg_packet_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct wg_peer *peer = container_of(napi, struct wg_peer, napi);
-	struct crypt_queue *queue = &peer->rx_queue;
 	struct noise_keypair *keypair;
 	struct endpoint endpoint;
 	enum packet_state state;
@@ -455,11 +454,10 @@ int wg_packet_rx_poll(struct napi_struct *napi, int budget)
 	if (unlikely(budget <= 0))
 		return 0;
 
-	while ((skb = __ptr_ring_peek(&queue->ring)) != NULL &&
+	while ((skb = wg_prev_queue_peek(&peer->rx_queue)) != NULL &&
 	       (state = atomic_read_acquire(&PACKET_CB(skb)->state)) !=
 		       PACKET_STATE_UNCRYPTED) {
-		__ptr_ring_discard_one(&queue->ring);
-		peer = PACKET_PEER(skb);
+		wg_prev_queue_drop_peeked(&peer->rx_queue);
 		keypair = PACKET_CB(skb)->keypair;
 		free = true;
 
@@ -508,7 +506,7 @@ void wg_packet_decrypt_worker(struct work_struct *work)
 		enum packet_state state =
 			likely(decrypt_packet(skb, PACKET_CB(skb)->keypair)) ?
 				PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
-		wg_queue_enqueue_per_peer_napi(skb, state);
+		wg_queue_enqueue_per_peer_rx(skb, state);
 		if (need_resched())
 			cond_resched();
 	}
@@ -531,12 +529,10 @@ static void wg_packet_consume_data(struct wg_device *wg, struct sk_buff *skb)
 	if (unlikely(READ_ONCE(peer->is_dead)))
 		goto err;
 
-	ret = wg_queue_enqueue_per_device_and_peer(&wg->decrypt_queue,
-						   &peer->rx_queue, skb,
-						   wg->packet_crypt_wq,
-						   &wg->decrypt_queue.last_cpu);
+	ret = wg_queue_enqueue_per_device_and_peer(&wg->decrypt_queue, &peer->rx_queue, skb,
+						   wg->packet_crypt_wq, &wg->decrypt_queue.last_cpu);
 	if (unlikely(ret == -EPIPE))
-		wg_queue_enqueue_per_peer_napi(skb, PACKET_STATE_DEAD);
+		wg_queue_enqueue_per_peer_rx(skb, PACKET_STATE_DEAD);
 	if (likely(!ret || ret == -EPIPE)) {
 		rcu_read_unlock_bh();
 		return;
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index f74b9341ab0f..5368f7c35b4b 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -239,8 +239,7 @@ void wg_packet_send_keepalive(struct wg_peer *peer)
 	wg_packet_send_staged_packets(peer);
 }
 
-static void wg_packet_create_data_done(struct sk_buff *first,
-				       struct wg_peer *peer)
+static void wg_packet_create_data_done(struct wg_peer *peer, struct sk_buff *first)
 {
 	struct sk_buff *skb, *next;
 	bool is_keepalive, data_sent = false;
@@ -262,22 +261,19 @@ static void wg_packet_create_data_done(struct sk_buff *first,
 
 void wg_packet_tx_worker(struct work_struct *work)
 {
-	struct crypt_queue *queue = container_of(work, struct crypt_queue,
-						 work);
+	struct wg_peer *peer = container_of(work, struct wg_peer, transmit_packet_work);
 	struct noise_keypair *keypair;
 	enum packet_state state;
 	struct sk_buff *first;
-	struct wg_peer *peer;
 
-	while ((first = __ptr_ring_peek(&queue->ring)) != NULL &&
+	while ((first = wg_prev_queue_peek(&peer->tx_queue)) != NULL &&
 	       (state = atomic_read_acquire(&PACKET_CB(first)->state)) !=
 		       PACKET_STATE_UNCRYPTED) {
-		__ptr_ring_discard_one(&queue->ring);
-		peer = PACKET_PEER(first);
+		wg_prev_queue_drop_peeked(&peer->tx_queue);
 		keypair = PACKET_CB(first)->keypair;
 
 		if (likely(state == PACKET_STATE_CRYPTED))
-			wg_packet_create_data_done(first, peer);
+			wg_packet_create_data_done(peer, first);
 		else
 			kfree_skb_list(first);
 
@@ -306,16 +302,14 @@ void wg_packet_encrypt_worker(struct work_struct *work)
 				break;
 			}
 		}
-		wg_queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first,
-					  state);
+		wg_queue_enqueue_per_peer_tx(first, state);
 		if (need_resched())
 			cond_resched();
 	}
 }
 
-static void wg_packet_create_data(struct sk_buff *first)
+static void wg_packet_create_data(struct wg_peer *peer, struct sk_buff *first)
 {
-	struct wg_peer *peer = PACKET_PEER(first);
 	struct wg_device *wg = peer->device;
 	int ret = -EINVAL;
 
@@ -323,13 +317,10 @@ static void wg_packet_create_data(struct sk_buff *first)
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
+		wg_queue_enqueue_per_peer_tx(first, PACKET_STATE_DEAD);
 err:
 	rcu_read_unlock_bh();
 	if (likely(!ret || ret == -EPIPE))
@@ -393,7 +384,7 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
 	packets.prev->next = NULL;
 	wg_peer_get(keypair->entry.peer);
 	PACKET_CB(packets.next)->keypair = keypair;
-	wg_packet_create_data(packets.next);
+	wg_packet_create_data(peer, packets.next);
 	return;
 
 out_invalid:
-- 
2.30.1

