Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F6964488A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiLFQBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiLFQBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:01:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E462ED5F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h65fxFXgwEwBJ/pZOtw1EZM2S77bNXNr+HJdRpw+4N8=;
        b=jG5oATEgBSpX5tQ5+k/3kJihOS+jB0H3tlPvkcswvEAFgYUh/4ZZb5SLof2T1UW602/60O
        idicr40dRSiLGh7fZFdbyWSD40XzlY/H/SbY96x1zSuFRdiY+0fEFIui05qcXohd964jIc
        kO3kct8j9xui3ErsqYUWkJedOOnNyOs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-JStW6hYKMn2u0sPvpORjhw-1; Tue, 06 Dec 2022 10:59:55 -0500
X-MC-Unique: JStW6hYKMn2u0sPvpORjhw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC8618027ED;
        Tue,  6 Dec 2022 15:59:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECD194A9254;
        Tue,  6 Dec 2022 15:59:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 09/32] rxrpc: Allow a delay to be injected into
 packet reception
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 15:59:51 +0000
Message-ID: <167034239131.1105287.15054038294627892172.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

 net/rxrpc/Kconfig        |    9 +++++++++
 net/rxrpc/ar-internal.h  |    6 ++++++
 net/rxrpc/io_thread.c    |   44 +++++++++++++++++++++++++++++++++++++++++++-
 net/rxrpc/local_object.c |    6 ++++++
 net/rxrpc/misc.c         |    7 +++++++
 net/rxrpc/sysctl.c       |   17 ++++++++++++++++-
 6 files changed, 87 insertions(+), 2 deletions(-)

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
index ca99e94318fc..ddba8048b7cb 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -289,6 +289,9 @@ struct rxrpc_local {
 	struct task_struct	*io_thread;
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+	struct sk_buff_head	rx_delay_queue;	/* Delay injection queue */
+#endif
 	struct sk_buff_head	rx_queue;	/* Received packets */
 	struct list_head	call_attend_q;	/* Calls requiring immediate attention */
 	struct rb_root		client_bundles;	/* Client connection bundles by socket params */
@@ -1034,6 +1037,9 @@ extern unsigned long rxrpc_idle_ack_delay;
 extern unsigned int rxrpc_rx_window_size;
 extern unsigned int rxrpc_rx_mtu;
 extern unsigned int rxrpc_rx_jumbo_max;
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+extern unsigned long rxrpc_inject_rx_delay;
+#endif
 
 /*
  * net_ns.c
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index c0751ff3712b..163b3414563c 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -36,7 +36,14 @@ int rxrpc_encap_rcv(struct sock *udp_sk, struct sk_buff *skb)
 
 	skb->mark = RXRPC_SKB_MARK_PACKET;
 	rxrpc_new_skb(skb, rxrpc_skb_new_encap_rcv);
-	skb_queue_tail(&local->rx_queue, skb);
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+	if (rxrpc_inject_rx_delay ||
+	    !skb_queue_empty(&local->rx_delay_queue)) {
+		skb->tstamp = ktime_add_ms(skb->tstamp, rxrpc_inject_rx_delay);
+		skb_queue_tail(&local->rx_delay_queue, skb);
+	} else
+#endif
+		skb_queue_tail(&local->rx_queue, skb);
 	rxrpc_wake_up_io_thread(local);
 	return 0;
 }
@@ -425,6 +432,9 @@ int rxrpc_io_thread(void *data)
 	struct rxrpc_local *local = data;
 	struct rxrpc_call *call;
 	struct sk_buff *skb;
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+	ktime_t now;
+#endif
 
 	skb_queue_head_init(&rx_queue);
 
@@ -468,6 +478,17 @@ int rxrpc_io_thread(void *data)
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
@@ -484,6 +505,27 @@ int rxrpc_io_thread(void *data)
 
 		if (kthread_should_stop())
 			break;
+
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+		if ((skb = skb_peek(&local->rx_delay_queue))) {
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
index 44222923c0d1..b35628ca57a5 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -97,6 +97,9 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		local->rxnet = rxnet;
 		INIT_HLIST_NODE(&local->link);
 		init_rwsem(&local->defrag_sem);
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+		skb_queue_head_init(&local->rx_delay_queue);
+#endif
 		skb_queue_head_init(&local->rx_queue);
 		INIT_LIST_HEAD(&local->call_attend_q);
 		local->client_bundles = RB_ROOT;
@@ -403,6 +406,9 @@ void rxrpc_destroy_local(struct rxrpc_local *local)
 	/* At this point, there should be no more packets coming in to the
 	 * local endpoint.
 	 */
+#ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
+	rxrpc_purge_queue(&local->rx_delay_queue);
+#endif
 	rxrpc_purge_queue(&local->rx_queue);
 }
 
diff --git a/net/rxrpc/misc.c b/net/rxrpc/misc.c
index 056c428d8bf3..658a2b7bf94e 100644
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
+unsigned long rxrpc_inject_rx_delay = 0;
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
 


