Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F76683377
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbjAaROG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjAaRN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:13:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F201BE4
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wKjr7qnWxjH4XTeXvZSSSd1nCI7NXk7SJJ/Lhly59Jg=;
        b=eAafQR5zWA5YjlSID7V8QWmsJS48eMsoT61YYyMdTM6clit3cGgVXNyVkID2HNaE3yA1Nk
        rKYudKu1sQexVBwXZBH848dCxSMcv0RKCGUw6uj9KHG7zfgZED9UuavfZ8MfgPfM/ya1Kg
        KJv5mnzJt2C7uE3T02aQ6UHD2uS7bbA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-33-VXloMYMSOUWJxcjCQwk5wg-1; Tue, 31 Jan 2023 12:12:49 -0500
X-MC-Unique: VXloMYMSOUWJxcjCQwk5wg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C27D100B377;
        Tue, 31 Jan 2023 17:12:40 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E35FF112132C;
        Tue, 31 Jan 2023 17:12:38 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/13] rxrpc: Allow a delay to be injected into packet reception
Date:   Tue, 31 Jan 2023 17:12:19 +0000
Message-Id: <20230131171227.3912130-6-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_AF_RXRPC_DEBUG_RX_DELAY=y, then a delay is injected between
packets and errors being received and them being made available to the
processing code, thereby allowing the RTT to be artificially increased.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 net/rxrpc/Kconfig        |  9 ++++++++
 net/rxrpc/ar-internal.h  |  6 +++++
 net/rxrpc/io_thread.c    | 48 +++++++++++++++++++++++++++++++++++++++-
 net/rxrpc/local_object.c |  6 +++++
 net/rxrpc/misc.c         |  7 ++++++
 net/rxrpc/sysctl.c       | 17 +++++++++++++-
 6 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index 7ae023b37a83..a20986806fea 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -36,6 +36,15 @@ config AF_RXRPC_INJECT_LOSS
 	  Say Y here to inject packet loss by discarding some received and some
 	  transmitted packets.
 
+config AF_RXRPC_INJECT_RX_DELAY
+	bool "Inject delay into packet reception"
+	depends on SYSCTL
+	help
+	  Say Y here to inject a delay into packet reception, allowing an
+	  extended RTT time to be modelled.  The delay can be configured using
+	  /proc/sys/net/rxrpc/rxrpc_inject_rx_delay, setting a number of
+	  milliseconds up to 0.5s (note that the granularity is actually in
+	  jiffies).
 
 config AF_RXRPC_DEBUG
 	bool "RxRPC dynamic debugging"
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 808c08cb2ae5..bfae4a87626f 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -285,6 +285,9 @@ struct rxrpc_local {
 	struct completion	io_thread_ready; /* Indication that the I/O thread started */
 	struct rxrpc_sock	*service;	/* Service(s) listening on this endpoint */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+	struct sk_buff_head	rx_delay_queue;	/* Delay injection queue */
+#endif
 	struct sk_buff_head	rx_queue;	/* Received packets */
 	struct list_head	conn_attend_q;	/* Conns requiring immediate attention */
 	struct list_head	call_attend_q;	/* Calls requiring immediate attention */
@@ -1109,6 +1112,9 @@ extern unsigned long rxrpc_idle_ack_delay;
 extern unsigned int rxrpc_rx_window_size;
 extern unsigned int rxrpc_rx_mtu;
 extern unsigned int rxrpc_rx_jumbo_max;
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+extern unsigned long rxrpc_inject_rx_delay;
+#endif
 
 /*
  * net_ns.c
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 9e9dfb2fc559..4a3a08a0e2cd 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -25,6 +25,7 @@ static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
  */
 int rxrpc_encap_rcv(struct sock *udp_sk, struct sk_buff *skb)
 {
+	struct sk_buff_head *rx_queue;
 	struct rxrpc_local *local = rcu_dereference_sk_user_data(udp_sk);
 
 	if (unlikely(!local)) {
@@ -36,7 +37,16 @@ int rxrpc_encap_rcv(struct sock *udp_sk, struct sk_buff *skb)
 
 	skb->mark = RXRPC_SKB_MARK_PACKET;
 	rxrpc_new_skb(skb, rxrpc_skb_new_encap_rcv);
-	skb_queue_tail(&local->rx_queue, skb);
+	rx_queue = &local->rx_queue;
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+	if (rxrpc_inject_rx_delay ||
+	    !skb_queue_empty(&local->rx_delay_queue)) {
+		skb->tstamp = ktime_add_ms(skb->tstamp, rxrpc_inject_rx_delay);
+		rx_queue = &local->rx_delay_queue;
+	}
+#endif
+
+	skb_queue_tail(rx_queue, skb);
 	rxrpc_wake_up_io_thread(local);
 	return 0;
 }
@@ -407,6 +417,9 @@ int rxrpc_io_thread(void *data)
 	struct rxrpc_local *local = data;
 	struct rxrpc_call *call;
 	struct sk_buff *skb;
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+	ktime_t now;
+#endif
 	bool should_stop;
 
 	complete(&local->io_thread_ready);
@@ -481,6 +494,17 @@ int rxrpc_io_thread(void *data)
 			continue;
 		}
 
+		/* Inject a delay into packets if requested. */
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+		now = ktime_get_real();
+		while ((skb = skb_peek(&local->rx_delay_queue))) {
+			if (ktime_before(now, skb->tstamp))
+				break;
+			skb = skb_dequeue(&local->rx_delay_queue);
+			skb_queue_tail(&local->rx_queue, skb);
+		}
+#endif
+
 		if (!skb_queue_empty(&local->rx_queue)) {
 			spin_lock_irq(&local->rx_queue.lock);
 			skb_queue_splice_tail_init(&local->rx_queue, &rx_queue);
@@ -502,6 +526,28 @@ int rxrpc_io_thread(void *data)
 
 		if (should_stop)
 			break;
+
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+		skb = skb_peek(&local->rx_delay_queue);
+		if (skb) {
+			unsigned long timeout;
+			ktime_t tstamp = skb->tstamp;
+			ktime_t now = ktime_get_real();
+			s64 delay_ns = ktime_to_ns(ktime_sub(tstamp, now));
+
+			if (delay_ns <= 0) {
+				__set_current_state(TASK_RUNNING);
+				continue;
+			}
+
+			timeout = nsecs_to_jiffies(delay_ns);
+			timeout = max(timeout, 1UL);
+			schedule_timeout(timeout);
+			__set_current_state(TASK_RUNNING);
+			continue;
+		}
+#endif
+
 		schedule();
 	}
 
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index b8eaca5d9f22..07d83a4e5841 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -110,6 +110,9 @@ static struct rxrpc_local *rxrpc_alloc_local(struct net *net,
 		INIT_HLIST_NODE(&local->link);
 		init_rwsem(&local->defrag_sem);
 		init_completion(&local->io_thread_ready);
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+		skb_queue_head_init(&local->rx_delay_queue);
+#endif
 		skb_queue_head_init(&local->rx_queue);
 		INIT_LIST_HEAD(&local->conn_attend_q);
 		INIT_LIST_HEAD(&local->call_attend_q);
@@ -434,6 +437,9 @@ void rxrpc_destroy_local(struct rxrpc_local *local)
 	/* At this point, there should be no more packets coming in to the
 	 * local endpoint.
 	 */
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+	rxrpc_purge_queue(&local->rx_delay_queue);
+#endif
 	rxrpc_purge_queue(&local->rx_queue);
 	rxrpc_purge_client_connections(local);
 }
diff --git a/net/rxrpc/misc.c b/net/rxrpc/misc.c
index 056c428d8bf3..825b81183046 100644
--- a/net/rxrpc/misc.c
+++ b/net/rxrpc/misc.c
@@ -53,3 +53,10 @@ unsigned int rxrpc_rx_mtu = 5692;
  * sender that we're willing to handle.
  */
 unsigned int rxrpc_rx_jumbo_max = 4;
+
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+/*
+ * The delay to inject into packet reception.
+ */
+unsigned long rxrpc_inject_rx_delay;
+#endif
diff --git a/net/rxrpc/sysctl.c b/net/rxrpc/sysctl.c
index cde3224a5cd2..ecaeb4ecfb58 100644
--- a/net/rxrpc/sysctl.c
+++ b/net/rxrpc/sysctl.c
@@ -17,6 +17,9 @@ static const unsigned int n_65535 = 65535;
 static const unsigned int n_max_acks = 255;
 static const unsigned long one_jiffy = 1;
 static const unsigned long max_jiffies = MAX_JIFFY_OFFSET;
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+static const unsigned long max_500 = 500;
+#endif
 
 /*
  * RxRPC operating parameters.
@@ -63,6 +66,19 @@ static struct ctl_table rxrpc_sysctl_table[] = {
 		.extra2		= (void *)&max_jiffies,
 	},
 
+	/* Values used in milliseconds */
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+	{
+		.procname	= "inject_rx_delay",
+		.data		= &rxrpc_inject_rx_delay,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= (void *)SYSCTL_LONG_ZERO,
+		.extra2		= (void *)&max_500,
+	},
+#endif
+
 	/* Non-time values */
 	{
 		.procname	= "reap_client_conns",
@@ -109,7 +125,6 @@ static struct ctl_table rxrpc_sysctl_table[] = {
 		.extra1		= (void *)SYSCTL_ONE,
 		.extra2		= (void *)&four,
 	},
-
 	{ }
 };
 

