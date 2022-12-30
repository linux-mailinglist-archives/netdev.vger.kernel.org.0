Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194ED65500A
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 13:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbiLWMDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 07:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiLWMCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 07:02:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04BADDE
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 04:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671796850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0YqZwfDSEyQNuCV84zKbns9wEfchKBByvWIl6mYQjj0=;
        b=Qj6YHn3+f3mKfjWB4wD0A36cWmPl+ludlXAnj08FPYS1n4utq31l/nTMLV7ZISLLUbbHsg
        mneB0VcwXgLvhec8QmrYuxtokxCkNKOnBQUSN2nvy0qG3zP1hDD4Fq7j9yMaqzyU+y3rMX
        zdIdBHdz05/9bNUFAxAI2wKh0n9MKr0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-DMpiBwvBOBeMbq5jnadtEA-1; Fri, 23 Dec 2022 07:00:46 -0500
X-MC-Unique: DMpiBwvBOBeMbq5jnadtEA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A9B485CCE0;
        Fri, 23 Dec 2022 12:00:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F4D02166B33;
        Fri, 23 Dec 2022 12:00:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 07/19] rxrpc: Implement a mechanism to send an event
 notification to a connection
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 23 Dec 2022 12:00:45 +0000
Message-ID: <167179684498.2516210.4722775627125479087.stgit@warthog.procyon.org.uk>
In-Reply-To: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
References: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a means by which an event notification can be sent to a connection
through such that the I/O thread can pick it up and handle it rather than
doing it in a separate workqueue.

This is then used to move the deferred final ACK of a call into the I/O
thread rather than a separate work queue as part of the drive to do all
transmission from the I/O thread.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    5 ++---
 net/rxrpc/ar-internal.h      |    5 +++++
 net/rxrpc/conn_event.c       |   14 ++++++++++----
 net/rxrpc/conn_object.c      |   20 +++++++++++++++++++-
 net/rxrpc/io_thread.c        |   18 +++++++++++++++++-
 net/rxrpc/local_object.c     |    1 +
 6 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index eac513668e33..b969756f97fc 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -111,7 +111,7 @@
 	EM(rxrpc_conn_get_call_input,		"GET inp-call") \
 	EM(rxrpc_conn_get_conn_input,		"GET inp-conn") \
 	EM(rxrpc_conn_get_idle,			"GET idle    ") \
-	EM(rxrpc_conn_get_poke,			"GET poke    ") \
+	EM(rxrpc_conn_get_poke_timer,		"GET poke    ") \
 	EM(rxrpc_conn_get_service_conn,		"GET svc-conn") \
 	EM(rxrpc_conn_new_client,		"NEW client  ") \
 	EM(rxrpc_conn_new_service,		"NEW service ") \
@@ -126,10 +126,9 @@
 	EM(rxrpc_conn_put_service_reaped,	"PUT svc-reap") \
 	EM(rxrpc_conn_put_unbundle,		"PUT unbundle") \
 	EM(rxrpc_conn_put_unidle,		"PUT unidle  ") \
+	EM(rxrpc_conn_put_work,			"PUT work    ") \
 	EM(rxrpc_conn_queue_challenge,		"QUE chall   ") \
-	EM(rxrpc_conn_queue_retry_work,		"QUE retry-wk") \
 	EM(rxrpc_conn_queue_rx_work,		"QUE rx-work ") \
-	EM(rxrpc_conn_queue_timer,		"QUE timer   ") \
 	EM(rxrpc_conn_see_new_service_conn,	"SEE new-svc ") \
 	EM(rxrpc_conn_see_reap_service,		"SEE reap-svc") \
 	E_(rxrpc_conn_see_work,			"SEE work    ")
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index b7023ae360e7..1a9822aa3592 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -202,6 +202,7 @@ struct rxrpc_host_header {
  * - max 48 bytes (struct sk_buff::cb)
  */
 struct rxrpc_skb_priv {
+	struct rxrpc_connection *conn;	/* Connection referred to (poke packet) */
 	u16		offset;		/* Offset of data */
 	u16		len;		/* Length of data */
 	u8		flags;
@@ -292,6 +293,7 @@ struct rxrpc_local {
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 	struct sk_buff_head	rx_queue;	/* Received packets */
+	struct list_head	conn_attend_q;	/* Conns requiring immediate attention */
 	struct list_head	call_attend_q;	/* Calls requiring immediate attention */
 	struct rb_root		client_bundles;	/* Client connection bundles by socket params */
 	spinlock_t		client_bundles_lock; /* Lock for client_bundles */
@@ -441,6 +443,7 @@ struct rxrpc_connection {
 	struct rxrpc_peer	*peer;		/* Remote endpoint */
 	struct rxrpc_net	*rxnet;		/* Network namespace to which call belongs */
 	struct key		*key;		/* Security details */
+	struct list_head	attend_link;	/* Link in local->conn_attend_q */
 
 	refcount_t		ref;
 	atomic_t		active;		/* Active count for service conns */
@@ -905,6 +908,7 @@ void rxrpc_conn_retransmit_call(struct rxrpc_connection *, struct sk_buff *,
 void rxrpc_process_connection(struct work_struct *);
 void rxrpc_process_delayed_final_acks(struct rxrpc_connection *, bool);
 int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb);
+void rxrpc_input_conn_event(struct rxrpc_connection *, struct sk_buff *);
 
 /*
  * conn_object.c
@@ -912,6 +916,7 @@ int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb);
 extern unsigned int rxrpc_connection_expiry;
 extern unsigned int rxrpc_closed_conn_expiry;
 
+void rxrpc_poke_conn(struct rxrpc_connection *, enum rxrpc_conn_trace);
 struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *, gfp_t);
 struct rxrpc_connection *rxrpc_find_client_connection_rcu(struct rxrpc_local *,
 							  struct sockaddr_rxrpc *,
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index dfd29882126f..7a980a32344f 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -412,10 +412,6 @@ static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 	if (test_and_clear_bit(RXRPC_CONN_EV_CHALLENGE, &conn->events))
 		rxrpc_secure_connection(conn);
 
-	/* Process delayed ACKs whose time has come. */
-	if (conn->flags & RXRPC_CONN_FINAL_ACK_MASK)
-		rxrpc_process_delayed_final_acks(conn, false);
-
 	/* go through the conn-level event packets, releasing the ref on this
 	 * connection that each one has when we've finished with it */
 	while ((skb = skb_dequeue(&conn->rx_queue))) {
@@ -515,3 +511,13 @@ int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
 		return -EPROTO;
 	}
 }
+
+/*
+ * Input a connection event.
+ */
+void rxrpc_input_conn_event(struct rxrpc_connection *conn, struct sk_buff *skb)
+{
+	/* Process delayed ACKs whose time has come. */
+	if (conn->flags & RXRPC_CONN_FINAL_ACK_MASK)
+		rxrpc_process_delayed_final_acks(conn, false);
+}
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 354a5ecb34ee..649c7fc94658 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -23,12 +23,30 @@ static void rxrpc_clean_up_connection(struct work_struct *work);
 static void rxrpc_set_service_reap_timer(struct rxrpc_net *rxnet,
 					 unsigned long reap_at);
 
+void rxrpc_poke_conn(struct rxrpc_connection *conn, enum rxrpc_conn_trace why)
+{
+	struct rxrpc_local *local = conn->local;
+	bool busy;
+
+	if (WARN_ON_ONCE(!local))
+		return;
+
+	spin_lock_bh(&local->lock);
+	busy = !list_empty(&conn->attend_link);
+	if (!busy) {
+		rxrpc_get_connection(conn, why);
+		list_add_tail(&conn->attend_link, &local->conn_attend_q);
+	}
+	spin_unlock_bh(&local->lock);
+	rxrpc_wake_up_io_thread(local);
+}
+
 static void rxrpc_connection_timer(struct timer_list *timer)
 {
 	struct rxrpc_connection *conn =
 		container_of(timer, struct rxrpc_connection, timer);
 
-	rxrpc_queue_conn(conn, rxrpc_conn_queue_timer);
+	rxrpc_poke_conn(conn, rxrpc_conn_get_poke_timer);
 }
 
 /*
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 0e1a548d35f8..dcf1ade0abdd 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -421,6 +421,7 @@ static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
  */
 int rxrpc_io_thread(void *data)
 {
+	struct rxrpc_connection *conn;
 	struct sk_buff_head rx_queue;
 	struct rxrpc_local *local = data;
 	struct rxrpc_call *call;
@@ -436,6 +437,19 @@ int rxrpc_io_thread(void *data)
 	for (;;) {
 		rxrpc_inc_stat(local->rxnet, stat_io_loop);
 
+		/* Deal with connections that want immediate attention. */
+		if ((conn = list_first_entry_or_null(&local->conn_attend_q,
+						     struct rxrpc_connection,
+						     attend_link))) {
+			spin_lock_bh(&local->lock);
+			list_del_init(&conn->attend_link);
+			spin_unlock_bh(&local->lock);
+
+			rxrpc_input_conn_event(conn, NULL);
+			rxrpc_put_connection(conn, rxrpc_conn_put_poke);
+			continue;
+		}
+
 		/* Deal with calls that want immediate attention. */
 		if ((call = list_first_entry_or_null(&local->call_attend_q,
 						     struct rxrpc_call,
@@ -463,6 +477,7 @@ int rxrpc_io_thread(void *data)
 				rxrpc_input_error(local, skb);
 				rxrpc_free_skb(skb, rxrpc_skb_put_error_report);
 				break;
+				break;
 			default:
 				WARN_ON_ONCE(1);
 				rxrpc_free_skb(skb, rxrpc_skb_put_unknown);
@@ -481,7 +496,8 @@ int rxrpc_io_thread(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 		should_stop = kthread_should_stop();
 		if (!skb_queue_empty(&local->rx_queue) ||
-		    !list_empty(&local->call_attend_q)) {
+		    !list_empty(&local->call_attend_q) ||
+		    !list_empty(&local->conn_attend_q)) {
 			__set_current_state(TASK_RUNNING);
 			continue;
 		}
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index c0ac2fe07ec4..8ef6cd8defa4 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -100,6 +100,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct net *net,
 		init_rwsem(&local->defrag_sem);
 		init_completion(&local->io_thread_ready);
 		skb_queue_head_init(&local->rx_queue);
+		INIT_LIST_HEAD(&local->conn_attend_q);
 		INIT_LIST_HEAD(&local->call_attend_q);
 		local->client_bundles = RB_ROOT;
 		spin_lock_init(&local->client_bundles_lock);


