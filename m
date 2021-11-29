Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE16462051
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347496AbhK2TYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377916AbhK2TWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:22:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E35EC09B108;
        Mon, 29 Nov 2021 07:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6092ECE12FE;
        Mon, 29 Nov 2021 15:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3A3C53FAD;
        Mon, 29 Nov 2021 15:39:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="iOmM5jwm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638200389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SZEgWodBLzbj8Z2U6w4Ybq2WYqWUzWPsSXssWhx4fKc=;
        b=iOmM5jwmAXDpnbrMCaGCZomX5HSpbEeDGj12XbDQ4200HpDGiCR4rzRx3M0WY9obZX//3n
        XqBDQ1hL1WVZVAO/o7p2W4dw8ggsCCqoZUpeUEuV0bO77oDj9G4qEJizlLgnYcyccH3RgS
        c63RrZ0vd3jG0vNJiAaqfkKZUDoaMmw=
Received: by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id 7ff1b6a5 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 29 Nov 2021 15:39:49 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Streun Fabio <fstreun@student.ethz.ch>,
        Joel Wanner <joel.wanner@inf.ethz.ch>, stable@vger.kernel.org
Subject: [PATCH net 07/10] wireguard: receive: use ring buffer for incoming handshakes
Date:   Mon, 29 Nov 2021 10:39:26 -0500
Message-Id: <20211129153929.3457-8-Jason@zx2c4.com>
In-Reply-To: <20211129153929.3457-1-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apparently the spinlock on incoming_handshake's skb_queue is highly
contended, and a torrent of handshake or cookie packets can bring the
data plane to its knees, simply by virtue of enqueueing the handshake
packets to be processed asynchronously. So, we try switching this to a
ring buffer to hopefully have less lock contention. This alleviates the
problem somewhat, though it still isn't perfect, so future patches will
have to improve this further. However, it at least doesn't completely
diminish the data plane.

Reported-by: Streun Fabio <fstreun@student.ethz.ch>
Reported-by: Joel Wanner <joel.wanner@inf.ethz.ch>
Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.c   | 36 ++++++++++++++++----------------
 drivers/net/wireguard/device.h   |  9 +++-----
 drivers/net/wireguard/queueing.c |  6 +++---
 drivers/net/wireguard/queueing.h |  2 +-
 drivers/net/wireguard/receive.c  | 27 +++++++++++-------------
 5 files changed, 37 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 77e64ea6be67..a46067c38bf5 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -98,6 +98,7 @@ static int wg_stop(struct net_device *dev)
 {
 	struct wg_device *wg = netdev_priv(dev);
 	struct wg_peer *peer;
+	struct sk_buff *skb;
 
 	mutex_lock(&wg->device_update_lock);
 	list_for_each_entry(peer, &wg->peer_list, peer_list) {
@@ -108,7 +109,9 @@ static int wg_stop(struct net_device *dev)
 		wg_noise_reset_last_sent_handshake(&peer->last_sent_handshake);
 	}
 	mutex_unlock(&wg->device_update_lock);
-	skb_queue_purge(&wg->incoming_handshakes);
+	while ((skb = ptr_ring_consume(&wg->handshake_queue.ring)) != NULL)
+		kfree_skb(skb);
+	atomic_set(&wg->handshake_queue_len, 0);
 	wg_socket_reinit(wg, NULL, NULL);
 	return 0;
 }
@@ -235,14 +238,13 @@ static void wg_destruct(struct net_device *dev)
 	destroy_workqueue(wg->handshake_receive_wq);
 	destroy_workqueue(wg->handshake_send_wq);
 	destroy_workqueue(wg->packet_crypt_wq);
-	wg_packet_queue_free(&wg->decrypt_queue);
-	wg_packet_queue_free(&wg->encrypt_queue);
+	wg_packet_queue_free(&wg->handshake_queue, true);
+	wg_packet_queue_free(&wg->decrypt_queue, false);
+	wg_packet_queue_free(&wg->encrypt_queue, false);
 	rcu_barrier(); /* Wait for all the peers to be actually freed. */
 	wg_ratelimiter_uninit();
 	memzero_explicit(&wg->static_identity, sizeof(wg->static_identity));
-	skb_queue_purge(&wg->incoming_handshakes);
 	free_percpu(dev->tstats);
-	free_percpu(wg->incoming_handshakes_worker);
 	kvfree(wg->index_hashtable);
 	kvfree(wg->peer_hashtable);
 	mutex_unlock(&wg->device_update_lock);
@@ -298,7 +300,6 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 	init_rwsem(&wg->static_identity.lock);
 	mutex_init(&wg->socket_update_lock);
 	mutex_init(&wg->device_update_lock);
-	skb_queue_head_init(&wg->incoming_handshakes);
 	wg_allowedips_init(&wg->peer_allowedips);
 	wg_cookie_checker_init(&wg->cookie_checker, wg);
 	INIT_LIST_HEAD(&wg->peer_list);
@@ -316,16 +317,10 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 	if (!dev->tstats)
 		goto err_free_index_hashtable;
 
-	wg->incoming_handshakes_worker =
-		wg_packet_percpu_multicore_worker_alloc(
-				wg_packet_handshake_receive_worker, wg);
-	if (!wg->incoming_handshakes_worker)
-		goto err_free_tstats;
-
 	wg->handshake_receive_wq = alloc_workqueue("wg-kex-%s",
 			WQ_CPU_INTENSIVE | WQ_FREEZABLE, 0, dev->name);
 	if (!wg->handshake_receive_wq)
-		goto err_free_incoming_handshakes;
+		goto err_free_tstats;
 
 	wg->handshake_send_wq = alloc_workqueue("wg-kex-%s",
 			WQ_UNBOUND | WQ_FREEZABLE, 0, dev->name);
@@ -347,10 +342,15 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 	if (ret < 0)
 		goto err_free_encrypt_queue;
 
-	ret = wg_ratelimiter_init();
+	ret = wg_packet_queue_init(&wg->handshake_queue, wg_packet_handshake_receive_worker,
+				   MAX_QUEUED_INCOMING_HANDSHAKES);
 	if (ret < 0)
 		goto err_free_decrypt_queue;
 
+	ret = wg_ratelimiter_init();
+	if (ret < 0)
+		goto err_free_handshake_queue;
+
 	ret = register_netdevice(dev);
 	if (ret < 0)
 		goto err_uninit_ratelimiter;
@@ -367,18 +367,18 @@ static int wg_newlink(struct net *src_net, struct net_device *dev,
 
 err_uninit_ratelimiter:
 	wg_ratelimiter_uninit();
+err_free_handshake_queue:
+	wg_packet_queue_free(&wg->handshake_queue, false);
 err_free_decrypt_queue:
-	wg_packet_queue_free(&wg->decrypt_queue);
+	wg_packet_queue_free(&wg->decrypt_queue, false);
 err_free_encrypt_queue:
-	wg_packet_queue_free(&wg->encrypt_queue);
+	wg_packet_queue_free(&wg->encrypt_queue, false);
 err_destroy_packet_crypt:
 	destroy_workqueue(wg->packet_crypt_wq);
 err_destroy_handshake_send:
 	destroy_workqueue(wg->handshake_send_wq);
 err_destroy_handshake_receive:
 	destroy_workqueue(wg->handshake_receive_wq);
-err_free_incoming_handshakes:
-	free_percpu(wg->incoming_handshakes_worker);
 err_free_tstats:
 	free_percpu(dev->tstats);
 err_free_index_hashtable:
diff --git a/drivers/net/wireguard/device.h b/drivers/net/wireguard/device.h
index 854bc3d97150..43c7cebbf50b 100644
--- a/drivers/net/wireguard/device.h
+++ b/drivers/net/wireguard/device.h
@@ -39,21 +39,18 @@ struct prev_queue {
 
 struct wg_device {
 	struct net_device *dev;
-	struct crypt_queue encrypt_queue, decrypt_queue;
+	struct crypt_queue encrypt_queue, decrypt_queue, handshake_queue;
 	struct sock __rcu *sock4, *sock6;
 	struct net __rcu *creating_net;
 	struct noise_static_identity static_identity;
-	struct workqueue_struct *handshake_receive_wq, *handshake_send_wq;
-	struct workqueue_struct *packet_crypt_wq;
-	struct sk_buff_head incoming_handshakes;
-	int incoming_handshake_cpu;
-	struct multicore_worker __percpu *incoming_handshakes_worker;
+	struct workqueue_struct *packet_crypt_wq,*handshake_receive_wq, *handshake_send_wq;
 	struct cookie_checker cookie_checker;
 	struct pubkey_hashtable *peer_hashtable;
 	struct index_hashtable *index_hashtable;
 	struct allowedips peer_allowedips;
 	struct mutex device_update_lock, socket_update_lock;
 	struct list_head device_list, peer_list;
+	atomic_t handshake_queue_len;
 	unsigned int num_peers, device_update_gen;
 	u32 fwmark;
 	u16 incoming_port;
diff --git a/drivers/net/wireguard/queueing.c b/drivers/net/wireguard/queueing.c
index 48e7b982a307..1de413b19e34 100644
--- a/drivers/net/wireguard/queueing.c
+++ b/drivers/net/wireguard/queueing.c
@@ -38,11 +38,11 @@ int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function,
 	return 0;
 }
 
-void wg_packet_queue_free(struct crypt_queue *queue)
+void wg_packet_queue_free(struct crypt_queue *queue, bool purge)
 {
 	free_percpu(queue->worker);
-	WARN_ON(!__ptr_ring_empty(&queue->ring));
-	ptr_ring_cleanup(&queue->ring, NULL);
+	WARN_ON(!purge && !__ptr_ring_empty(&queue->ring));
+	ptr_ring_cleanup(&queue->ring, purge ? (void(*)(void*))kfree_skb : NULL);
 }
 
 #define NEXT(skb) ((skb)->prev)
diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index 4ef2944a68bc..e2388107f7fd 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -23,7 +23,7 @@ struct sk_buff;
 /* queueing.c APIs: */
 int wg_packet_queue_init(struct crypt_queue *queue, work_func_t function,
 			 unsigned int len);
-void wg_packet_queue_free(struct crypt_queue *queue);
+void wg_packet_queue_free(struct crypt_queue *queue, bool purge);
 struct multicore_worker __percpu *
 wg_packet_percpu_multicore_worker_alloc(work_func_t function, void *ptr);
 
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 7dc84bcca261..f4e537e3e8ec 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -116,8 +116,8 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 		return;
 	}
 
-	under_load = skb_queue_len(&wg->incoming_handshakes) >=
-		     MAX_QUEUED_INCOMING_HANDSHAKES / 8;
+	under_load = atomic_read(&wg->handshake_queue_len) >=
+			MAX_QUEUED_INCOMING_HANDSHAKES / 8;
 	if (under_load) {
 		last_under_load = ktime_get_coarse_boottime_ns();
 	} else if (last_under_load) {
@@ -212,13 +212,14 @@ static void wg_receive_handshake_packet(struct wg_device *wg,
 
 void wg_packet_handshake_receive_worker(struct work_struct *work)
 {
-	struct wg_device *wg = container_of(work, struct multicore_worker,
-					    work)->ptr;
+	struct crypt_queue *queue = container_of(work, struct multicore_worker, work)->ptr;
+	struct wg_device *wg = container_of(queue, struct wg_device, handshake_queue);
 	struct sk_buff *skb;
 
-	while ((skb = skb_dequeue(&wg->incoming_handshakes)) != NULL) {
+	while ((skb = ptr_ring_consume_bh(&queue->ring)) != NULL) {
 		wg_receive_handshake_packet(wg, skb);
 		dev_kfree_skb(skb);
+		atomic_dec(&wg->handshake_queue_len);
 		cond_resched();
 	}
 }
@@ -554,21 +555,17 @@ void wg_packet_receive(struct wg_device *wg, struct sk_buff *skb)
 	case cpu_to_le32(MESSAGE_HANDSHAKE_RESPONSE):
 	case cpu_to_le32(MESSAGE_HANDSHAKE_COOKIE): {
 		int cpu;
-
-		if (skb_queue_len(&wg->incoming_handshakes) >
-			    MAX_QUEUED_INCOMING_HANDSHAKES ||
-		    unlikely(!rng_is_initialized())) {
+		if (unlikely(!rng_is_initialized() ||
+			     ptr_ring_produce_bh(&wg->handshake_queue.ring, skb))) {
 			net_dbg_skb_ratelimited("%s: Dropping handshake packet from %pISpfsc\n",
 						wg->dev->name, skb);
 			goto err;
 		}
-		skb_queue_tail(&wg->incoming_handshakes, skb);
-		/* Queues up a call to packet_process_queued_handshake_
-		 * packets(skb):
-		 */
-		cpu = wg_cpumask_next_online(&wg->incoming_handshake_cpu);
+		atomic_inc(&wg->handshake_queue_len);
+		cpu = wg_cpumask_next_online(&wg->handshake_queue.last_cpu);
+		/* Queues up a call to packet_process_queued_handshake_packets(skb): */
 		queue_work_on(cpu, wg->handshake_receive_wq,
-			&per_cpu_ptr(wg->incoming_handshakes_worker, cpu)->work);
+			      &per_cpu_ptr(wg->handshake_queue.worker, cpu)->work);
 		break;
 	}
 	case cpu_to_le32(MESSAGE_DATA):
-- 
2.34.1

