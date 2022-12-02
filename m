Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710F463FCCE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiLBAV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiLBAUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:20:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AF313EB5
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f0bYOASdO/Li33R/J7KbVGZP6aCzO4ecxhhHKkbaLSU=;
        b=hZ3/lBSaUTMcoK3jZU9FHfz++/hrpL0ccc2z1tK9y7KRg258qYr/VCRkkw0COTCCRCo0L2
        pC7mxuPRPUHKWik1BKNP2lk4FWMYI0KPwJHcPBtPjqN3BjZI9nC8kzTMA1dG88gEpe9HoY
        yIA20sWMnADj07pWFK7Z2qXc9kr2frM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-XOG9dyKYN3y2vIv4q7ktbQ-1; Thu, 01 Dec 2022 19:17:48 -0500
X-MC-Unique: XOG9dyKYN3y2vIv4q7ktbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01DEE800186;
        Fri,  2 Dec 2022 00:17:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 460EE40C6FA1;
        Fri,  2 Dec 2022 00:17:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 19/36] rxrpc: Create a per-local endpoint receive
 queue and I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:17:44 +0000
Message-ID: <166994026449.1732290.10318281297019188033.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a per-local receive queue to which, in a future patch, all incoming
packets will be directed and an I/O thread that will process those packets
and perform all transmission of packets.

Destruction of the local endpoint is also moved from the local processor
work item (which will be absorbed) to the thread.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h  |   10 +++++++++
 net/rxrpc/io_thread.c    |   51 +++++++++++++++++++++++++++++++++++++++++++++-
 net/rxrpc/local_object.c |   39 ++++++++++++++++++++---------------
 net/rxrpc/proc.c         |   12 ++++++++---
 4 files changed, 91 insertions(+), 21 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 523cc9c5ab12..de82c25956a6 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -110,6 +110,8 @@ struct rxrpc_net {
 	atomic_t		stat_rx_acks[256];
 
 	atomic_t		stat_why_req_ack[8];
+
+	atomic_t		stat_io_loop;
 };
 
 /*
@@ -280,12 +282,14 @@ struct rxrpc_local {
 	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct work_struct	processor;
+	struct task_struct	*io_thread;
 	struct list_head	ack_tx_queue;	/* List of ACKs that need sending */
 	spinlock_t		ack_tx_lock;	/* ACK list lock */
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 	struct sk_buff_head	reject_queue;	/* packets awaiting rejection */
 	struct sk_buff_head	event_queue;	/* endpoint event packets awaiting processing */
+	struct sk_buff_head	rx_queue;	/* Received packets */
 	struct rb_root		client_bundles;	/* Client connection bundles by socket params */
 	spinlock_t		client_bundles_lock; /* Lock for client_bundles */
 	spinlock_t		lock;		/* access lock */
@@ -954,6 +958,11 @@ void rxrpc_input_implicit_end_call(struct rxrpc_sock *, struct rxrpc_connection
  * io_thread.c
  */
 int rxrpc_input_packet(struct sock *, struct sk_buff *);
+int rxrpc_io_thread(void *data);
+static inline void rxrpc_wake_up_io_thread(struct rxrpc_local *local)
+{
+	wake_up_process(local->io_thread);
+}
 
 /*
  * insecure.c
@@ -984,6 +993,7 @@ void rxrpc_put_local(struct rxrpc_local *, enum rxrpc_local_trace);
 struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *, enum rxrpc_local_trace);
 void rxrpc_unuse_local(struct rxrpc_local *, enum rxrpc_local_trace);
 void rxrpc_queue_local(struct rxrpc_local *);
+void rxrpc_destroy_local(struct rxrpc_local *local);
 void rxrpc_destroy_all_locals(struct rxrpc_net *);
 
 static inline bool __rxrpc_unuse_local(struct rxrpc_local *local,
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index d2aaad5afa1d..0b3e096e3d50 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /* RxRPC packet reception
  *
- * Copyright (C) 2007, 2016 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2007, 2016, 2022 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  */
 
@@ -368,3 +368,52 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	_leave(" [badmsg]");
 	return 0;
 }
+
+/*
+ * I/O and event handling thread.
+ */
+int rxrpc_io_thread(void *data)
+{
+	struct sk_buff_head rx_queue;
+	struct rxrpc_local *local = data;
+	struct sk_buff *skb;
+
+	skb_queue_head_init(&rx_queue);
+
+	set_user_nice(current, MIN_NICE);
+
+	for (;;) {
+		rxrpc_inc_stat(local->rxnet, stat_io_loop);
+
+		/* Process received packets and errors. */
+		if ((skb = __skb_dequeue(&rx_queue))) {
+			// TODO: Input packet
+			rxrpc_free_skb(skb, rxrpc_skb_put_input);
+			continue;
+		}
+
+		if (!skb_queue_empty(&local->rx_queue)) {
+			spin_lock_irq(&local->rx_queue.lock);
+			skb_queue_splice_tail_init(&local->rx_queue, &rx_queue);
+			spin_unlock_irq(&local->rx_queue.lock);
+			continue;
+		}
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!skb_queue_empty(&local->rx_queue)) {
+			__set_current_state(TASK_RUNNING);
+			continue;
+		}
+
+		if (kthread_should_stop())
+			break;
+		schedule();
+	}
+
+	__set_current_state(TASK_RUNNING);
+	rxrpc_see_local(local, rxrpc_local_stop);
+	rxrpc_destroy_local(local);
+	local->io_thread = NULL;
+	rxrpc_see_local(local, rxrpc_local_stopped);
+	return 0;
+}
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 1617ce651b9b..7c61349984e3 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -103,6 +103,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		init_rwsem(&local->defrag_sem);
 		skb_queue_head_init(&local->reject_queue);
 		skb_queue_head_init(&local->event_queue);
+		skb_queue_head_init(&local->rx_queue);
 		local->client_bundles = RB_ROOT;
 		spin_lock_init(&local->client_bundles_lock);
 		spin_lock_init(&local->lock);
@@ -126,6 +127,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 	struct udp_tunnel_sock_cfg tuncfg = {NULL};
 	struct sockaddr_rxrpc *srx = &local->srx;
 	struct udp_port_cfg udp_conf = {0};
+	struct task_struct *io_thread;
 	struct sock *usk;
 	int ret;
 
@@ -185,8 +187,23 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 		BUG();
 	}
 
+	io_thread = kthread_run(rxrpc_io_thread, local,
+				"krxrpcio/%u", ntohs(udp_conf.local_udp_port));
+	if (IS_ERR(io_thread)) {
+		ret = PTR_ERR(io_thread);
+		goto error_sock;
+	}
+
+	local->io_thread = io_thread;
 	_leave(" = 0");
 	return 0;
+
+error_sock:
+	kernel_sock_shutdown(local->socket, SHUT_RDWR);
+	local->socket->sk->sk_user_data = NULL;
+	sock_release(local->socket);
+	local->socket = NULL;
+	return ret;
 }
 
 /*
@@ -360,19 +377,8 @@ struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local,
  */
 void rxrpc_unuse_local(struct rxrpc_local *local, enum rxrpc_local_trace why)
 {
-	unsigned int debug_id;
-	int r, u;
-
-	if (local) {
-		debug_id = local->debug_id;
-		r = refcount_read(&local->ref);
-		u = atomic_dec_return(&local->active_users);
-		trace_rxrpc_local(debug_id, why, r, u);
-		if (u == 0) {
-			rxrpc_get_local(local, rxrpc_local_get_queue);
-			rxrpc_queue_local(local);
-		}
-	}
+	if (local && __rxrpc_unuse_local(local, why))
+		kthread_stop(local->io_thread);
 }
 
 /*
@@ -382,7 +388,7 @@ void rxrpc_unuse_local(struct rxrpc_local *local, enum rxrpc_local_trace why)
  * Closing the socket cannot be done from bottom half context or RCU callback
  * context because it might sleep.
  */
-static void rxrpc_local_destroyer(struct rxrpc_local *local)
+void rxrpc_destroy_local(struct rxrpc_local *local)
 {
 	struct socket *socket = local->socket;
 	struct rxrpc_net *rxnet = local->rxnet;
@@ -411,6 +417,7 @@ static void rxrpc_local_destroyer(struct rxrpc_local *local)
 	 */
 	rxrpc_purge_queue(&local->reject_queue);
 	rxrpc_purge_queue(&local->event_queue);
+	rxrpc_purge_queue(&local->rx_queue);
 }
 
 /*
@@ -430,10 +437,8 @@ static void rxrpc_local_processor(struct work_struct *work)
 
 	do {
 		again = false;
-		if (!__rxrpc_use_local(local, rxrpc_local_use_work)) {
-			rxrpc_local_destroyer(local);
+		if (!__rxrpc_use_local(local, rxrpc_local_use_work))
 			break;
-		}
 
 		if (!list_empty(&local->ack_tx_queue)) {
 			rxrpc_transmit_ack_packets(local);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index d3a6d24cf871..35d5b43c677e 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -342,7 +342,7 @@ static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq,
 			 "Proto Local                                          "
-			 " Use Act\n");
+			 " Use Act RxQ\n");
 		return 0;
 	}
 
@@ -351,10 +351,11 @@ static int rxrpc_local_seq_show(struct seq_file *seq, void *v)
 	sprintf(lbuff, "%pISpc", &local->srx.transport);
 
 	seq_printf(seq,
-		   "UDP   %-47.47s %3u %3u\n",
+		   "UDP   %-47.47s %3u %3u %3u\n",
 		   lbuff,
 		   refcount_read(&local->ref),
-		   atomic_read(&local->active_users));
+		   atomic_read(&local->active_users),
+		   local->rx_queue.qlen);
 
 	return 0;
 }
@@ -463,6 +464,9 @@ int rxrpc_stats_show(struct seq_file *seq, void *v)
 		   "Buffers  : txb=%u rxb=%u\n",
 		   atomic_read(&rxrpc_nr_txbuf),
 		   atomic_read(&rxrpc_n_rx_skbs));
+	seq_printf(seq,
+		   "IO-thread: loops=%u\n",
+		   atomic_read(&rxnet->stat_io_loop));
 	return 0;
 }
 
@@ -492,5 +496,7 @@ int rxrpc_stats_clear(struct file *file, char *buf, size_t size)
 	memset(&rxnet->stat_rx_acks, 0, sizeof(rxnet->stat_rx_acks));
 
 	memset(&rxnet->stat_why_req_ack, 0, sizeof(rxnet->stat_why_req_ack));
+
+	atomic_set(&rxnet->stat_io_loop, 0);
 	return size;
 }


