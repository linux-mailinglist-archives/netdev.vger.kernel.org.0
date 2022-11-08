Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620BF621F2C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiKHWXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiKHWWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:22:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1632657CE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667946013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iRbIsl1+XIG1+Z2rKrJcsmcQhf6FogksMXe2XfpFT5Q=;
        b=LmC8nblF+uJpdLf7nnNePbZv1SCyaBKi/ve/lbNhyygwlI9UM22bZ/0NNZpBl4vbtL+a//
        quqFIeoVU3fwyXGmJvef1TpaQ/Fcx13yGn/bEiVgvhcicr2byorYLGyWW3Q8XJ8rI8fBa4
        ottgyxGFj0ZphCRPUlcDnXKSAdwB6w8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-1OD1bwRqNE-zL05WNcoPzQ-1; Tue, 08 Nov 2022 17:20:09 -0500
X-MC-Unique: 1OD1bwRqNE-zL05WNcoPzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC223811E7A;
        Tue,  8 Nov 2022 22:20:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B958200BA7B;
        Tue,  8 Nov 2022 22:20:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 21/26] rxrpc: Don't use a ring buffer for call Tx
 queue
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:20:07 +0000
Message-ID: <166794600736.2389296.12213701143010549598.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the way the Tx queueing works to make the following ends easier to
achieve:

 (1) The filling of packets, the encryption of packets and the transmission
     of packets can be handled in parallel by separate threads, rather than
     rxrpc_sendmsg() allocating, filling, encrypting and transmitting each
     packet before moving onto the next one.

 (2) Get rid of the fixed-size ring which sets a hard limit on the number
     of packets that can be retained in the ring.  This allows the number
     of packets to increase without having to allocate a very large ring or
     having variable-sized rings.

     [Note: the downside of this is that it's then less efficient to locate
     a packet for retransmission as we then have to step through a list and
     examine each buffer in the list.]

 (3) Allow the filler/encrypter to run ahead of the transmission window.

 (4) Make it easier to do zero copy UDP from the packet buffers.

 (5) Make it easier to do zero copy from userspace to the packet buffers -
     and thence to UDP (only if for unauthenticated connections).

To that end, the following changes are made:

 (1) Use the new rxrpc_txbuf struct instead of sk_buff for keeping packets
     to be transmitted in.  This allows them to be placed on multiple
     queues simultaneously.  An sk_buff isn't really necessary as it's
     never passed on to lower-level networking code.

 (2) Keep the transmissable packets in a linked list on the call struct
     rather than in a ring.  As a consequence, the annotation buffer isn't
     used either; rather a flag is set on the packet to indicate ackedness.

 (3) Use the RXRPC_CALL_TX_LAST flag to indicate that the last packet to be
     transmitted has been queued.  Add RXRPC_CALL_TX_ALL_ACKED to indicate
     that all packets up to and including the last got hard acked.

 (4) Wire headers are now stored in the txbuf rather than being concocted
     on the stack and they're stored immediately before the data, thereby
     allowing zerocopy of a single span.

 (5) Don't bother with instant-resend on transmission failure; rather,
     leave it for a timer or an ACK packet to trigger.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   78 +++++++++--------
 net/rxrpc/af_rxrpc.c         |    5 -
 net/rxrpc/ar-internal.h      |   31 +++----
 net/rxrpc/call_event.c       |  111 ++++++++-----------------
 net/rxrpc/call_object.c      |   15 +++
 net/rxrpc/input.c            |  145 ++++++++++++++------------------
 net/rxrpc/insecure.c         |    3 -
 net/rxrpc/output.c           |   89 ++++++++------------
 net/rxrpc/proc.c             |    9 +-
 net/rxrpc/rxkad.c            |  102 ++++++++---------------
 net/rxrpc/sendmsg.c          |  188 ++++++++++++++++--------------------------
 net/rxrpc/txbuf.c            |   34 ++++++++
 12 files changed, 349 insertions(+), 461 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 284a1560b0a8..71ca74e40ec8 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -75,6 +75,7 @@
 	EM(rxrpc_call_got,			"GOT") \
 	EM(rxrpc_call_got_kernel,		"Gke") \
 	EM(rxrpc_call_got_timer,		"GTM") \
+	EM(rxrpc_call_got_tx,			"Gtx") \
 	EM(rxrpc_call_got_userid,		"Gus") \
 	EM(rxrpc_call_new_client,		"NWc") \
 	EM(rxrpc_call_new_service,		"NWs") \
@@ -83,20 +84,22 @@
 	EM(rxrpc_call_put_noqueue,		"PnQ") \
 	EM(rxrpc_call_put_notimer,		"PnT") \
 	EM(rxrpc_call_put_timer,		"PTM") \
+	EM(rxrpc_call_put_tx,			"Ptx") \
 	EM(rxrpc_call_put_userid,		"Pus") \
 	EM(rxrpc_call_queued,			"QUE") \
 	EM(rxrpc_call_queued_ref,		"QUR") \
 	EM(rxrpc_call_release,			"RLS") \
 	E_(rxrpc_call_seen,			"SEE")
 
-#define rxrpc_transmit_traces \
-	EM(rxrpc_transmit_await_reply,		"AWR") \
-	EM(rxrpc_transmit_end,			"END") \
-	EM(rxrpc_transmit_queue,		"QUE") \
-	EM(rxrpc_transmit_queue_last,		"QLS") \
-	EM(rxrpc_transmit_rotate,		"ROT") \
-	EM(rxrpc_transmit_rotate_last,		"RLS") \
-	E_(rxrpc_transmit_wait,			"WAI")
+#define rxrpc_txqueue_traces \
+	EM(rxrpc_txqueue_await_reply,		"AWR") \
+	EM(rxrpc_txqueue_dequeue,		"DEQ") \
+	EM(rxrpc_txqueue_end,			"END") \
+	EM(rxrpc_txqueue_queue,			"QUE") \
+	EM(rxrpc_txqueue_queue_last,		"QLS") \
+	EM(rxrpc_txqueue_rotate,		"ROT") \
+	EM(rxrpc_txqueue_rotate_last,		"RLS") \
+	E_(rxrpc_txqueue_wait,			"WAI")
 
 #define rxrpc_receive_traces \
 	EM(rxrpc_receive_end,			"END") \
@@ -259,6 +262,7 @@
 	EM(rxrpc_txbuf_alloc_ack,		"ALLOC ACK  ")	\
 	EM(rxrpc_txbuf_alloc_data,		"ALLOC DATA ")	\
 	EM(rxrpc_txbuf_free,			"FREE       ")	\
+	EM(rxrpc_txbuf_get_buffer,		"GET BUFFER ")	\
 	EM(rxrpc_txbuf_get_trans,		"GET TRANS  ")	\
 	EM(rxrpc_txbuf_get_retrans,		"GET RETRANS")	\
 	EM(rxrpc_txbuf_put_ack_tx,		"PUT ACK TX ")	\
@@ -266,6 +270,7 @@
 	EM(rxrpc_txbuf_put_nomem,		"PUT NOMEM  ")	\
 	EM(rxrpc_txbuf_put_rotated,		"PUT ROTATED")	\
 	EM(rxrpc_txbuf_put_send_aborted,	"PUT SEND-X ")	\
+	EM(rxrpc_txbuf_put_trans,		"PUT TRANS  ")	\
 	EM(rxrpc_txbuf_see_send_more,		"SEE SEND+  ")	\
 	E_(rxrpc_txbuf_see_unacked,		"SEE UNACKED")
 
@@ -295,9 +300,9 @@ enum rxrpc_rtt_rx_trace		{ rxrpc_rtt_rx_traces } __mode(byte);
 enum rxrpc_rtt_tx_trace		{ rxrpc_rtt_tx_traces } __mode(byte);
 enum rxrpc_skb_trace		{ rxrpc_skb_traces } __mode(byte);
 enum rxrpc_timer_trace		{ rxrpc_timer_traces } __mode(byte);
-enum rxrpc_transmit_trace	{ rxrpc_transmit_traces } __mode(byte);
 enum rxrpc_tx_point		{ rxrpc_tx_points } __mode(byte);
 enum rxrpc_txbuf_trace		{ rxrpc_txbuf_traces } __mode(byte);
+enum rxrpc_txqueue_trace	{ rxrpc_txqueue_traces } __mode(byte);
 
 #endif /* end __RXRPC_DECLARE_TRACE_ENUMS_ONCE_ONLY */
 
@@ -323,9 +328,9 @@ rxrpc_rtt_rx_traces;
 rxrpc_rtt_tx_traces;
 rxrpc_skb_traces;
 rxrpc_timer_traces;
-rxrpc_transmit_traces;
 rxrpc_tx_points;
 rxrpc_txbuf_traces;
+rxrpc_txqueue_traces;
 
 /*
  * Now redefine the EM() and E_() macros to map the enums to the strings that
@@ -605,15 +610,16 @@ TRACE_EVENT(rxrpc_call_complete,
 		      __entry->abort_code)
 	    );
 
-TRACE_EVENT(rxrpc_transmit,
-	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_transmit_trace why),
+TRACE_EVENT(rxrpc_txqueue,
+	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_txqueue_trace why),
 
 	    TP_ARGS(call, why),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
-		    __field(enum rxrpc_transmit_trace,	why		)
-		    __field(rxrpc_seq_t,		tx_hard_ack	)
+		    __field(enum rxrpc_txqueue_trace,	why		)
+		    __field(rxrpc_seq_t,		acks_hard_ack	)
+		    __field(rxrpc_seq_t,		tx_bottom	)
 		    __field(rxrpc_seq_t,		tx_top		)
 		    __field(int,			tx_winsize	)
 			     ),
@@ -621,16 +627,19 @@ TRACE_EVENT(rxrpc_transmit,
 	    TP_fast_assign(
 		    __entry->call = call->debug_id;
 		    __entry->why = why;
-		    __entry->tx_hard_ack = call->tx_hard_ack;
+		    __entry->acks_hard_ack = call->acks_hard_ack;
+		    __entry->tx_bottom = call->tx_bottom;
 		    __entry->tx_top = call->tx_top;
 		    __entry->tx_winsize = call->tx_winsize;
 			   ),
 
-	    TP_printk("c=%08x %s f=%08x n=%u/%u",
+	    TP_printk("c=%08x %s f=%08x h=%08x n=%u/%u/%u",
 		      __entry->call,
-		      __print_symbolic(__entry->why, rxrpc_transmit_traces),
-		      __entry->tx_hard_ack + 1,
-		      __entry->tx_top - __entry->tx_hard_ack,
+		      __print_symbolic(__entry->why, rxrpc_txqueue_traces),
+		      __entry->tx_bottom,
+		      __entry->acks_hard_ack,
+		      __entry->tx_top - __entry->tx_bottom,
+		      __entry->tx_top - __entry->acks_hard_ack,
 		      __entry->tx_winsize)
 	    );
 
@@ -1200,29 +1209,25 @@ TRACE_EVENT(rxrpc_drop_ack,
 	    );
 
 TRACE_EVENT(rxrpc_retransmit,
-	    TP_PROTO(struct rxrpc_call *call, rxrpc_seq_t seq, u8 annotation,
-		     s64 expiry),
+	    TP_PROTO(struct rxrpc_call *call, rxrpc_seq_t seq, s64 expiry),
 
-	    TP_ARGS(call, seq, annotation, expiry),
+	    TP_ARGS(call, seq, expiry),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
 		    __field(rxrpc_seq_t,		seq		)
-		    __field(u8,				annotation	)
 		    __field(s64,			expiry		)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->call = call->debug_id;
 		    __entry->seq = seq;
-		    __entry->annotation = annotation;
 		    __entry->expiry = expiry;
 			   ),
 
-	    TP_printk("c=%08x q=%x a=%02x xp=%lld",
+	    TP_printk("c=%08x q=%x xp=%lld",
 		      __entry->call,
 		      __entry->seq,
-		      __entry->annotation,
 		      __entry->expiry)
 	    );
 
@@ -1245,14 +1250,14 @@ TRACE_EVENT(rxrpc_congest,
 	    TP_fast_assign(
 		    __entry->call	= call->debug_id;
 		    __entry->change	= change;
-		    __entry->hard_ack	= call->tx_hard_ack;
+		    __entry->hard_ack	= call->acks_hard_ack;
 		    __entry->top	= call->tx_top;
 		    __entry->lowest_nak	= call->acks_lowest_nak;
 		    __entry->ack_serial	= ack_serial;
 		    memcpy(&__entry->sum, summary, sizeof(__entry->sum));
 			   ),
 
-	    TP_printk("c=%08x r=%08x %s q=%08x %s cw=%u ss=%u nr=%u,%u nw=%u,%u r=%u b=%u u=%u d=%u l=%x%s%s%s",
+	    TP_printk("c=%08x r=%08x %s q=%08x %s cw=%u ss=%u nA=%u,%u+%u,%u r=%u b=%u u=%u d=%u l=%x%s%s%s",
 		      __entry->call,
 		      __entry->ack_serial,
 		      __print_symbolic(__entry->sum.ack_reason, rxrpc_ack_names),
@@ -1362,26 +1367,23 @@ TRACE_EVENT(rxrpc_connect_call,
 	    );
 
 TRACE_EVENT(rxrpc_resend,
-	    TP_PROTO(struct rxrpc_call *call, int ix),
+	    TP_PROTO(struct rxrpc_call *call),
 
-	    TP_ARGS(call, ix),
+	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
-		    __field(int,			ix		)
-		    __array(u8,				anno, 64	)
+		    __field(rxrpc_seq_t,		seq		)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->call = call->debug_id;
-		    __entry->ix = ix;
-		    memcpy(__entry->anno, call->rxtx_annotations, 64);
+		    __entry->seq = call->acks_hard_ack;
 			   ),
 
-	    TP_printk("c=%08x ix=%u a=%64phN",
+	    TP_printk("c=%08x q=%x",
 		      __entry->call,
-		      __entry->ix,
-		      __entry->anno)
+		      __entry->seq)
 	    );
 
 TRACE_EVENT(rxrpc_rx_icmp,
@@ -1461,7 +1463,7 @@ TRACE_EVENT(rxrpc_call_reset,
 		    __entry->call_id = call->call_id;
 		    __entry->call_serial = call->rx_serial;
 		    __entry->conn_serial = call->conn->hi_serial;
-		    __entry->tx_seq = call->tx_hard_ack;
+		    __entry->tx_seq = call->acks_hard_ack;
 		    __entry->rx_seq = call->rx_highest_seq;
 			   ),
 
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index ceba28e9dce6..2f3991cf8715 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -39,7 +39,7 @@ atomic_t rxrpc_debug_id;
 EXPORT_SYMBOL(rxrpc_debug_id);
 
 /* count of skbs currently in use */
-atomic_t rxrpc_n_tx_skbs, rxrpc_n_rx_skbs;
+atomic_t rxrpc_n_rx_skbs;
 
 struct workqueue_struct *rxrpc_workqueue;
 
@@ -979,7 +979,7 @@ static int __init af_rxrpc_init(void)
 		goto error_call_jar;
 	}
 
-	rxrpc_workqueue = alloc_workqueue("krxrpcd", 0, 1);
+	rxrpc_workqueue = alloc_workqueue("krxrpcd", WQ_HIGHPRI | WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
 	if (!rxrpc_workqueue) {
 		pr_notice("Failed to allocate work queue\n");
 		goto error_work_queue;
@@ -1059,7 +1059,6 @@ static void __exit af_rxrpc_exit(void)
 	sock_unregister(PF_RXRPC);
 	proto_unregister(&rxrpc_proto);
 	unregister_pernet_device(&rxrpc_net_ops);
-	ASSERTCMP(atomic_read(&rxrpc_n_tx_skbs), ==, 0);
 	ASSERTCMP(atomic_read(&rxrpc_n_rx_skbs), ==, 0);
 
 	/* Make sure the local and peer records pinned by any dying connections
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index c6c5bb3d3688..d7aebe82e17c 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -195,7 +195,6 @@ struct rxrpc_host_header {
  * - max 48 bytes (struct sk_buff::cb)
  */
 struct rxrpc_skb_priv {
-	u16		remain;
 	u16		offset;		/* Offset of data */
 	u16		len;		/* Length of data */
 	u8		flags;
@@ -243,7 +242,7 @@ struct rxrpc_security {
 			     size_t *, size_t *, size_t *);
 
 	/* impose security on a packet */
-	int (*secure_packet)(struct rxrpc_call *, struct sk_buff *, size_t);
+	int (*secure_packet)(struct rxrpc_call *, struct rxrpc_txbuf *);
 
 	/* verify the security on a received packet */
 	int (*verify_packet)(struct rxrpc_call *, struct sk_buff *);
@@ -497,6 +496,7 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_EXPOSED,		/* The call was exposed to the world */
 	RXRPC_CALL_RX_LAST,		/* Received the last packet (at rxtx_top) */
 	RXRPC_CALL_TX_LAST,		/* Last packet in Tx buffer (at rxtx_top) */
+	RXRPC_CALL_TX_ALL_ACKED,	/* Last packet has been hard-acked */
 	RXRPC_CALL_SEND_PING,		/* A ping will need to be sent */
 	RXRPC_CALL_RETRANS_TIMEOUT,	/* Retransmission due to timeout occurred */
 	RXRPC_CALL_BEGAN_RX_TIMER,	/* We began the expect_rx_by timer */
@@ -594,7 +594,7 @@ struct rxrpc_call {
 	struct list_head	recvmsg_link;	/* Link in rx->recvmsg_q */
 	struct list_head	sock_link;	/* Link in rx->sock_calls */
 	struct rb_node		sock_node;	/* Node in rx->calls */
-	struct sk_buff		*tx_pending;	/* Tx socket buffer being filled */
+	struct rxrpc_txbuf	*tx_pending;	/* Tx buffer being filled */
 	wait_queue_head_t	waitq;		/* Wait queue for channel or Tx */
 	s64			tx_total_len;	/* Total length left to be transmitted (or -1) */
 	__be32			crypto_buf[2];	/* Temporary packet crypto buffer */
@@ -632,22 +632,16 @@ struct rxrpc_call {
 #define RXRPC_INIT_RX_WINDOW_SIZE 63
 	struct sk_buff		**rxtx_buffer;
 	u8			*rxtx_annotations;
-#define RXRPC_TX_ANNO_ACK	0
-#define RXRPC_TX_ANNO_UNACK	1
-#define RXRPC_TX_ANNO_NAK	2
-#define RXRPC_TX_ANNO_RETRANS	3
-#define RXRPC_TX_ANNO_MASK	0x03
-#define RXRPC_TX_ANNO_LAST	0x04
-#define RXRPC_TX_ANNO_RESENT	0x08
-
-	rxrpc_seq_t		tx_hard_ack;	/* Dead slot in buffer; the first transmitted but
-						 * not hard-ACK'd packet follows this.
-						 */
 
 	/* Transmitted data tracking. */
+	spinlock_t		tx_lock;	/* Transmit queue lock */
+	struct list_head	tx_buffer;	/* Buffer of transmissible packets */
+	rxrpc_seq_t		tx_bottom;	/* First packet in buffer */
+	rxrpc_seq_t		tx_transmitted;	/* Highest packet transmitted */
 	rxrpc_seq_t		tx_top;		/* Highest Tx slot allocated. */
 	u16			tx_backoff;	/* Delay to insert due to Tx failure */
 	u8			tx_winsize;	/* Maximum size of Tx window */
+#define RXRPC_TX_MAX_WINDOW	128
 
 	/* Received data tracking */
 	struct sk_buff_head	recvmsg_queue;	/* Queue of packets ready for recvmsg() */
@@ -657,6 +651,7 @@ struct rxrpc_call {
 	rxrpc_seq_t		rx_consumed;	/* Highest packet consumed */
 	rxrpc_serial_t		rx_serial;	/* Highest serial received for this call */
 	u8			rx_winsize;	/* Size of Rx window */
+	spinlock_t		input_lock;	/* Lock for packet input to this call */
 
 	/* TCP-style slow-start congestion control [RFC5681].  Since the SMSS
 	 * is fixed, we keep these numbers in terms of segments (ie. DATA
@@ -671,8 +666,6 @@ struct rxrpc_call {
 	u8			cong_cumul_acks; /* Cumulative ACK count */
 	ktime_t			cong_tstamp;	/* Last time cwnd was changed */
 
-	spinlock_t		input_lock;	/* Lock for packet input to this call */
-
 	/* Receive-phase ACK management (ACKs we send). */
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
@@ -697,6 +690,7 @@ struct rxrpc_call {
 	ktime_t			acks_latest_ts;	/* Timestamp of latest ACK received */
 	rxrpc_seq_t		acks_first_seq;	/* first sequence number received */
 	rxrpc_seq_t		acks_prev_seq;	/* Highest previousPacket received */
+	rxrpc_seq_t		acks_hard_ack;	/* Latest hard-ack point */
 	rxrpc_seq_t		acks_lowest_nak; /* Lowest NACK in the buffer (or ==tx_hard_ack) */
 	rxrpc_seq_t		acks_lost_top;	/* tx_top at the time lost-ack ping sent */
 	rxrpc_serial_t		acks_lost_ping;	/* Serial number of probe ACK */
@@ -809,7 +803,7 @@ static inline bool rxrpc_sending_to_client(const struct rxrpc_txbuf *txb)
 /*
  * af_rxrpc.c
  */
-extern atomic_t rxrpc_n_tx_skbs, rxrpc_n_rx_skbs;
+extern atomic_t rxrpc_n_rx_skbs;
 extern struct workqueue_struct *rxrpc_workqueue;
 
 /*
@@ -831,6 +825,7 @@ void rxrpc_propose_ping(struct rxrpc_call *call, u32 serial,
 void rxrpc_send_ACK(struct rxrpc_call *, u8, rxrpc_serial_t, enum rxrpc_propose_ack_trace);
 void rxrpc_propose_delay_ACK(struct rxrpc_call *, rxrpc_serial_t,
 			     enum rxrpc_propose_ack_trace);
+void rxrpc_shrink_call_tx_buffer(struct rxrpc_call *);
 void rxrpc_process_call(struct work_struct *);
 
 void rxrpc_reduce_call_timer(struct rxrpc_call *call,
@@ -1034,7 +1029,7 @@ static inline struct rxrpc_net *rxrpc_net(struct net *net)
  */
 void rxrpc_transmit_ack_packets(struct rxrpc_local *);
 int rxrpc_send_abort_packet(struct rxrpc_call *);
-int rxrpc_send_data_packet(struct rxrpc_call *, struct sk_buff *, bool);
+int rxrpc_send_data_packet(struct rxrpc_call *, struct rxrpc_txbuf *);
 void rxrpc_reject_packets(struct rxrpc_local *);
 void rxrpc_send_keepalive(struct rxrpc_peer *);
 
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 36f60ac1d95d..3c37b280eb20 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -148,62 +148,52 @@ static void rxrpc_congestion_timeout(struct rxrpc_call *call)
  */
 static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 {
-	struct sk_buff *skb;
+	struct rxrpc_txbuf *txb;
 	unsigned long resend_at;
-	rxrpc_seq_t cursor, seq, top;
+	rxrpc_seq_t transmitted = READ_ONCE(call->tx_transmitted);
 	ktime_t now, max_age, oldest, ack_ts;
-	int ix;
-	u8 annotation, anno_type, retrans = 0, unacked = 0;
+	bool unacked = false;
+	LIST_HEAD(retrans_queue);
 
-	_enter("{%d,%d}", call->tx_hard_ack, call->tx_top);
+	_enter("{%d,%d}", call->acks_hard_ack, call->tx_top);
 
 	now = ktime_get_real();
 	max_age = ktime_sub_us(now, jiffies_to_usecs(call->peer->rto_j));
 
-	spin_lock_bh(&call->lock);
-
-	cursor = call->tx_hard_ack;
-	top = call->tx_top;
-	ASSERT(before_eq(cursor, top));
-	if (cursor == top)
-		goto out_unlock;
+	spin_lock(&call->tx_lock);
 
 	/* Scan the packet list without dropping the lock and decide which of
 	 * the packets in the Tx buffer we're going to resend and what the new
 	 * resend timeout will be.
 	 */
-	trace_rxrpc_resend(call, (cursor + 1) & RXRPC_RXTX_BUFF_MASK);
+	trace_rxrpc_resend(call);
 	oldest = now;
-	for (seq = cursor + 1; before_eq(seq, top); seq++) {
-		ix = seq & RXRPC_RXTX_BUFF_MASK;
-		annotation = call->rxtx_annotations[ix];
-		anno_type = annotation & RXRPC_TX_ANNO_MASK;
-		annotation &= ~RXRPC_TX_ANNO_MASK;
-		if (anno_type == RXRPC_TX_ANNO_ACK)
+	list_for_each_entry(txb, &call->tx_buffer, call_link) {
+		if (test_bit(RXRPC_TXBUF_ACKED, &txb->flags))
 			continue;
+		if (after(txb->seq, transmitted))
+			break;
 
-		skb = call->rxtx_buffer[ix];
-		rxrpc_see_skb(skb, rxrpc_skb_seen);
+		rxrpc_see_txbuf(txb, rxrpc_txbuf_see_unacked);
 
-		if (anno_type == RXRPC_TX_ANNO_UNACK) {
-			if (ktime_after(skb->tstamp, max_age)) {
-				if (ktime_before(skb->tstamp, oldest))
-					oldest = skb->tstamp;
+		if (test_bit(RXRPC_TXBUF_RESENT, &txb->flags)) {
+			if (ktime_after(txb->last_sent, max_age)) {
+				if (ktime_before(txb->last_sent, oldest))
+					oldest = txb->last_sent;
 				continue;
 			}
-			if (!(annotation & RXRPC_TX_ANNO_RESENT))
-				unacked++;
+			unacked = true;
 		}
 
-		/* Okay, we need to retransmit a packet. */
-		call->rxtx_annotations[ix] = RXRPC_TX_ANNO_RETRANS | annotation;
-		retrans++;
-		trace_rxrpc_retransmit(call, seq, annotation | anno_type,
-				       ktime_to_ns(ktime_sub(skb->tstamp, max_age)));
+		rxrpc_get_txbuf(txb, rxrpc_txbuf_get_retrans);
+		list_move_tail(&txb->tx_link, &retrans_queue);
 	}
 
+	spin_unlock(&call->tx_lock);
+
 	resend_at = nsecs_to_jiffies(ktime_to_ns(ktime_sub(now, oldest)));
-	resend_at += jiffies + rxrpc_get_rto_backoff(call->peer, retrans);
+	resend_at += jiffies + rxrpc_get_rto_backoff(call->peer,
+						     !list_empty(&retrans_queue));
 	WRITE_ONCE(call->resend_at, resend_at);
 
 	if (unacked)
@@ -213,7 +203,8 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	 * that an ACK got lost somewhere.  Send a ping to find out instead of
 	 * retransmitting data.
 	 */
-	if (!retrans) {
+	if (list_empty(&retrans_queue)) {
+		spin_lock_bh(&call->lock);
 		rxrpc_reduce_call_timer(call, resend_at, now_j,
 					rxrpc_timer_set_for_resend);
 		spin_unlock_bh(&call->lock);
@@ -225,50 +216,19 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 		goto out;
 	}
 
-	/* Now go through the Tx window and perform the retransmissions.  We
-	 * have to drop the lock for each send.  If an ACK comes in whilst the
-	 * lock is dropped, it may clear some of the retransmission markers for
-	 * packets that it soft-ACKs.
-	 */
-	for (seq = cursor + 1; before_eq(seq, top); seq++) {
-		ix = seq & RXRPC_RXTX_BUFF_MASK;
-		annotation = call->rxtx_annotations[ix];
-		anno_type = annotation & RXRPC_TX_ANNO_MASK;
-		if (anno_type != RXRPC_TX_ANNO_RETRANS)
-			continue;
-
-		/* We need to reset the retransmission state, but we need to do
-		 * so before we drop the lock as a new ACK/NAK may come in and
-		 * confuse things
-		 */
-		annotation &= ~RXRPC_TX_ANNO_MASK;
-		annotation |= RXRPC_TX_ANNO_UNACK | RXRPC_TX_ANNO_RESENT;
-		call->rxtx_annotations[ix] = annotation;
-
-		skb = call->rxtx_buffer[ix];
-		if (!skb)
-			continue;
-
-		rxrpc_get_skb(skb, rxrpc_skb_got);
-		spin_unlock_bh(&call->lock);
-
+	while ((txb = list_first_entry_or_null(&retrans_queue,
+					       struct rxrpc_txbuf, tx_link))) {
+		list_del_init(&txb->tx_link);
+		set_bit(RXRPC_TXBUF_RESENT, &txb->flags);
 		rxrpc_inc_stat(call->rxnet, stat_tx_data_retrans);
-		if (rxrpc_send_data_packet(call, skb, true) < 0) {
-			rxrpc_free_skb(skb, rxrpc_skb_freed);
-			return;
-		}
+		rxrpc_send_data_packet(call, txb);
+		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_trans);
 
-		if (rxrpc_is_client_call(call))
-			rxrpc_expose_client_call(call);
-
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
-		spin_lock_bh(&call->lock);
-		if (after(call->tx_hard_ack, seq))
-			seq = call->tx_hard_ack;
+		trace_rxrpc_retransmit(call, txb->seq,
+				       ktime_to_ns(ktime_sub(txb->last_sent,
+							     max_age)));
 	}
 
-out_unlock:
-	spin_unlock_bh(&call->lock);
 out:
 	_leave("");
 }
@@ -301,6 +261,9 @@ void rxrpc_process_call(struct work_struct *work)
 		goto recheck_state;
 	}
 
+	if (READ_ONCE(call->acks_hard_ack) != call->tx_bottom)
+		rxrpc_shrink_call_tx_buffer(call);
+
 	if (call->state == RXRPC_CALL_COMPLETE) {
 		rxrpc_delete_call_timer(call);
 		goto out_put;
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 4d8601c6a32d..ed5f6f0e4286 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -155,11 +155,13 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	INIT_LIST_HEAD(&call->accept_link);
 	INIT_LIST_HEAD(&call->recvmsg_link);
 	INIT_LIST_HEAD(&call->sock_link);
+	INIT_LIST_HEAD(&call->tx_buffer);
 	skb_queue_head_init(&call->recvmsg_queue);
 	skb_queue_head_init(&call->rx_oos_queue);
 	init_waitqueue_head(&call->waitq);
 	spin_lock_init(&call->lock);
 	spin_lock_init(&call->notify_lock);
+	spin_lock_init(&call->tx_lock);
 	spin_lock_init(&call->input_lock);
 	rwlock_init(&call->state_lock);
 	refcount_set(&call->ref, 1);
@@ -175,7 +177,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	call->tx_winsize = 16;
 
 	call->cong_cwnd = 2;
-	call->cong_ssthresh = RXRPC_RXTX_BUFF_SIZE - 1;
+	call->cong_ssthresh = RXRPC_TX_MAX_WINDOW;
 
 	call->rxnet = rxnet;
 	call->rtt_avail = RXRPC_CALL_RTT_AVAIL_MASK;
@@ -510,7 +512,7 @@ void rxrpc_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 }
 
 /*
- * Clean up the RxTx skb ring.
+ * Clean up the Rx skb ring.
  */
 static void rxrpc_cleanup_ring(struct rxrpc_call *call)
 {
@@ -686,6 +688,8 @@ static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
  */
 void rxrpc_cleanup_call(struct rxrpc_call *call)
 {
+	struct rxrpc_txbuf *txb;
+
 	_net("DESTROY CALL %d", call->debug_id);
 
 	memset(&call->sock_node, 0xcd, sizeof(call->sock_node));
@@ -694,7 +698,12 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
 
 	rxrpc_cleanup_ring(call);
-	rxrpc_free_skb(call->tx_pending, rxrpc_skb_cleaned);
+	while ((txb = list_first_entry_or_null(&call->tx_buffer,
+					       struct rxrpc_txbuf, call_link))) {
+		list_del(&txb->call_link);
+		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_cleaned);
+	}
+	rxrpc_put_txbuf(call->tx_pending, rxrpc_txbuf_put_cleaned);
 
 	call_rcu(&call->rcu, rxrpc_rcu_destroy_call);
 }
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 947e7196e2be..b1f7debd4f3e 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -32,7 +32,7 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 	bool resend = false;
 
 	summary->flight_size =
-		(call->tx_top - call->tx_hard_ack) - summary->nr_acks;
+		(call->tx_top - call->acks_hard_ack) - summary->nr_acks;
 
 	if (test_and_clear_bit(RXRPC_CALL_RETRANS_TIMEOUT, &call->flags)) {
 		summary->retrans_timeo = true;
@@ -150,8 +150,8 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 out:
 	cumulative_acks = 0;
 out_no_clear_ca:
-	if (cwnd >= RXRPC_RXTX_BUFF_SIZE - 1)
-		cwnd = RXRPC_RXTX_BUFF_SIZE - 1;
+	if (cwnd >= RXRPC_TX_MAX_WINDOW)
+		cwnd = RXRPC_TX_MAX_WINDOW;
 	call->cong_cwnd = cwnd;
 	call->cong_cumul_acks = cumulative_acks;
 	trace_rxrpc_congest(call, summary, acked_serial, change);
@@ -169,9 +169,8 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 	/* Send some previously unsent DATA if we have some to advance the ACK
 	 * state.
 	 */
-	if (call->rxtx_annotations[call->tx_top & RXRPC_RXTX_BUFF_MASK] &
-	    RXRPC_TX_ANNO_LAST ||
-	    summary->nr_acks != call->tx_top - call->tx_hard_ack) {
+	if (test_bit(RXRPC_CALL_TX_LAST, &call->flags) ||
+	    summary->nr_acks != call->tx_top - call->acks_hard_ack) {
 		call->cong_extra++;
 		wake_up(&call->waitq);
 	}
@@ -184,53 +183,40 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 static bool rxrpc_rotate_tx_window(struct rxrpc_call *call, rxrpc_seq_t to,
 				   struct rxrpc_ack_summary *summary)
 {
-	struct sk_buff *skb, *list = NULL;
+	struct rxrpc_txbuf *txb;
 	bool rot_last = false;
-	int ix;
-	u8 annotation;
 
-	if (call->acks_lowest_nak == call->tx_hard_ack) {
-		call->acks_lowest_nak = to;
-	} else if (before_eq(call->acks_lowest_nak, to)) {
-		summary->new_low_nack = true;
-		call->acks_lowest_nak = to;
-	}
-
-	spin_lock(&call->lock);
-
-	while (before(call->tx_hard_ack, to)) {
-		call->tx_hard_ack++;
-		ix = call->tx_hard_ack & RXRPC_RXTX_BUFF_MASK;
-		skb = call->rxtx_buffer[ix];
-		annotation = call->rxtx_annotations[ix];
-		rxrpc_see_skb(skb, rxrpc_skb_rotated);
-		call->rxtx_buffer[ix] = NULL;
-		call->rxtx_annotations[ix] = 0;
-		skb->next = list;
-		list = skb;
-
-		if (annotation & RXRPC_TX_ANNO_LAST) {
+	list_for_each_entry_rcu(txb, &call->tx_buffer, call_link, false) {
+		if (before_eq(txb->seq, call->acks_hard_ack))
+			continue;
+		if (!test_bit(RXRPC_TXBUF_ACKED, &txb->flags))
+			summary->nr_rot_new_acks++;
+		if (test_bit(RXRPC_TXBUF_LAST, &txb->flags)) {
 			set_bit(RXRPC_CALL_TX_LAST, &call->flags);
 			rot_last = true;
 		}
-		if ((annotation & RXRPC_TX_ANNO_MASK) != RXRPC_TX_ANNO_ACK)
-			summary->nr_rot_new_acks++;
+		if (txb->seq == to)
+			break;
 	}
 
-	spin_unlock(&call->lock);
+	if (rot_last)
+		set_bit(RXRPC_CALL_TX_ALL_ACKED, &call->flags);
 
-	trace_rxrpc_transmit(call, (rot_last ?
-				    rxrpc_transmit_rotate_last :
-				    rxrpc_transmit_rotate));
-	wake_up(&call->waitq);
+	_enter("%x,%x,%x,%d", to, call->acks_hard_ack, call->tx_top, rot_last);
 
-	while (list) {
-		skb = list;
-		list = skb->next;
-		skb_mark_not_on_list(skb);
-		rxrpc_free_skb(skb, rxrpc_skb_freed);
+	if (call->acks_lowest_nak == call->acks_hard_ack) {
+		call->acks_lowest_nak = to;
+	} else if (before_eq(call->acks_lowest_nak, to)) {
+		summary->new_low_nack = true;
+		call->acks_lowest_nak = to;
 	}
 
+	smp_store_release(&call->acks_hard_ack, to);
+
+	trace_rxrpc_txqueue(call, (rot_last ?
+				   rxrpc_txqueue_rotate_last :
+				   rxrpc_txqueue_rotate));
+	wake_up(&call->waitq);
 	return rot_last;
 }
 
@@ -270,9 +256,9 @@ static bool rxrpc_end_tx_phase(struct rxrpc_call *call, bool reply_begun,
 
 	write_unlock(&call->state_lock);
 	if (state == RXRPC_CALL_CLIENT_AWAIT_REPLY)
-		trace_rxrpc_transmit(call, rxrpc_transmit_await_reply);
+		trace_rxrpc_txqueue(call, rxrpc_txqueue_await_reply);
 	else
-		trace_rxrpc_transmit(call, rxrpc_transmit_end);
+		trace_rxrpc_txqueue(call, rxrpc_txqueue_end);
 	_leave(" = ok");
 	return true;
 
@@ -678,30 +664,21 @@ static void rxrpc_complete_rtt_probe(struct rxrpc_call *call,
  */
 static void rxrpc_input_check_for_lost_ack(struct rxrpc_call *call)
 {
-	rxrpc_seq_t top, bottom, seq;
+	struct rxrpc_txbuf *txb;
+	rxrpc_seq_t top, bottom;
 	bool resend = false;
 
-	spin_lock_bh(&call->lock);
-
-	bottom = call->tx_hard_ack + 1;
-	top = call->acks_lost_top;
+	bottom = READ_ONCE(call->acks_hard_ack) + 1;
+	top = READ_ONCE(call->acks_lost_top);
 	if (before(bottom, top)) {
-		for (seq = bottom; before_eq(seq, top); seq++) {
-			int ix = seq & RXRPC_RXTX_BUFF_MASK;
-			u8 annotation = call->rxtx_annotations[ix];
-			u8 anno_type = annotation & RXRPC_TX_ANNO_MASK;
-
-			if (anno_type != RXRPC_TX_ANNO_UNACK)
+		list_for_each_entry_rcu(txb, &call->tx_buffer, call_link, false) {
+			if (test_bit(RXRPC_TXBUF_ACKED, &txb->flags))
 				continue;
-			annotation &= ~RXRPC_TX_ANNO_MASK;
-			annotation |= RXRPC_TX_ANNO_RETRANS;
-			call->rxtx_annotations[ix] = annotation;
+			set_bit(RXRPC_TXBUF_RETRANS, &txb->flags);
 			resend = true;
 		}
 	}
 
-	spin_unlock_bh(&call->lock);
-
 	if (resend && !test_and_set_bit(RXRPC_CALL_EV_RESEND, &call->events))
 		rxrpc_queue_call(call);
 }
@@ -735,8 +712,8 @@ static void rxrpc_input_ackinfo(struct rxrpc_call *call, struct sk_buff *skb,
 	       ntohl(ackinfo->rxMTU), ntohl(ackinfo->maxMTU),
 	       rwind, ntohl(ackinfo->jumbo_max));
 
-	if (rwind > RXRPC_RXTX_BUFF_SIZE - 1)
-		rwind = RXRPC_RXTX_BUFF_SIZE - 1;
+	if (rwind > RXRPC_TX_MAX_WINDOW)
+		rwind = RXRPC_TX_MAX_WINDOW;
 	if (call->tx_winsize != rwind) {
 		if (rwind > call->tx_winsize)
 			wake = true;
@@ -775,22 +752,24 @@ static void rxrpc_input_soft_acks(struct rxrpc_call *call, u8 *acks,
 				  rxrpc_seq_t seq, int nr_acks,
 				  struct rxrpc_ack_summary *summary)
 {
-	int ix;
-	u8 annotation, anno_type;
-
-	for (; nr_acks > 0; nr_acks--, seq++) {
-		ix = seq & RXRPC_RXTX_BUFF_MASK;
-		annotation = call->rxtx_annotations[ix];
-		anno_type = annotation & RXRPC_TX_ANNO_MASK;
-		annotation &= ~RXRPC_TX_ANNO_MASK;
-		switch (*acks++) {
+	struct rxrpc_txbuf *txb;
+
+	list_for_each_entry_rcu(txb, &call->tx_buffer, call_link, false) {
+		if (before(txb->seq, seq))
+			continue;
+		if (after_eq(txb->seq, seq + nr_acks))
+			break;
+		switch (acks[txb->seq - seq]) {
 		case RXRPC_ACK_TYPE_ACK:
 			summary->nr_acks++;
-			if (anno_type == RXRPC_TX_ANNO_ACK)
+			if (test_bit(RXRPC_TXBUF_ACKED, &txb->flags))
 				continue;
+			/* A lot of the time the packet is going to
+			 * have been ACK.'d already.
+			 */
+			clear_bit(RXRPC_TXBUF_NACKED, &txb->flags);
+			set_bit(RXRPC_TXBUF_ACKED, &txb->flags);
 			summary->nr_new_acks++;
-			call->rxtx_annotations[ix] =
-				RXRPC_TX_ANNO_ACK | annotation;
 			break;
 		case RXRPC_ACK_TYPE_NACK:
 			if (!summary->nr_nacks &&
@@ -799,13 +778,12 @@ static void rxrpc_input_soft_acks(struct rxrpc_call *call, u8 *acks,
 				summary->new_low_nack = true;
 			}
 			summary->nr_nacks++;
-			if (anno_type == RXRPC_TX_ANNO_NAK)
+			if (test_bit(RXRPC_TXBUF_NACKED, &txb->flags))
 				continue;
 			summary->nr_new_nacks++;
-			if (anno_type == RXRPC_TX_ANNO_RETRANS)
-				continue;
-			call->rxtx_annotations[ix] =
-				RXRPC_TX_ANNO_NAK | annotation;
+			clear_bit(RXRPC_TXBUF_ACKED, &txb->flags);
+			set_bit(RXRPC_TXBUF_NACKED, &txb->flags);
+			set_bit(RXRPC_TXBUF_RETRANS, &txb->flags);
 			break;
 		default:
 			return rxrpc_proto_abort("SFT", call, 0);
@@ -930,7 +908,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	if (unlikely(buf.ack.reason == RXRPC_ACK_OUT_OF_SEQUENCE) &&
 	    first_soft_ack == 1 &&
 	    prev_pkt == 0 &&
-	    call->tx_hard_ack == 0 &&
+	    call->acks_hard_ack == 0 &&
 	    rxrpc_is_client_call(call)) {
 		rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
 					  0, -ENETRESET);
@@ -989,7 +967,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		goto out;
 	}
 
-	if (before(hard_ack, call->tx_hard_ack) ||
+	if (before(hard_ack, call->acks_hard_ack) ||
 	    after(hard_ack, call->tx_top)) {
 		rxrpc_proto_abort("AKW", call, 0);
 		goto out;
@@ -999,7 +977,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		goto out;
 	}
 
-	if (after(hard_ack, call->tx_hard_ack)) {
+	if (after(hard_ack, call->acks_hard_ack)) {
 		if (rxrpc_rotate_tx_window(call, hard_ack, &summary)) {
 			rxrpc_end_tx_phase(call, false, "ETA");
 			goto out;
@@ -1015,8 +993,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 				      &summary);
 	}
 
-	if (call->rxtx_annotations[call->tx_top & RXRPC_RXTX_BUFF_MASK] &
-	    RXRPC_TX_ANNO_LAST &&
+	if (test_bit(RXRPC_CALL_TX_LAST, &call->flags) &&
 	    summary.nr_acks == call->tx_top - hard_ack &&
 	    rxrpc_is_client_call(call))
 		rxrpc_propose_ping(call, ack_serial,
diff --git a/net/rxrpc/insecure.c b/net/rxrpc/insecure.c
index fd68f0e3af27..0eb8471bfc53 100644
--- a/net/rxrpc/insecure.c
+++ b/net/rxrpc/insecure.c
@@ -25,8 +25,7 @@ static int none_how_much_data(struct rxrpc_call *call, size_t remain,
 	return 0;
 }
 
-static int none_secure_packet(struct rxrpc_call *call, struct sk_buff *skb,
-			      size_t data_size)
+static int none_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 {
 	return 0;
 }
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 0a4f37d7b6b5..e2f501cef040 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -335,7 +335,7 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 	 * channel instead, thereby closing off this call.
 	 */
 	if (rxrpc_is_client_call(call) &&
-	    test_bit(RXRPC_CALL_TX_LAST, &call->flags))
+	    test_bit(RXRPC_CALL_TX_ALL_ACKED, &call->flags))
 		return 0;
 
 	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
@@ -383,20 +383,17 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 /*
  * send a packet through the transport endpoint
  */
-int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
-			   bool retrans)
+int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 {
 	enum rxrpc_req_ack_trace why;
 	struct rxrpc_connection *conn = call->conn;
-	struct rxrpc_wire_header whdr;
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct msghdr msg;
-	struct kvec iov[2];
+	struct kvec iov[1];
 	rxrpc_serial_t serial;
 	size_t len;
 	int ret, rtt_slot = -1;
 
-	_enter(",{%d}", skb->len);
+	_enter("%x,{%d}", txb->seq, txb->len);
 
 	if (hlist_unhashed(&call->error_link)) {
 		spin_lock_bh(&call->peer->lock);
@@ -406,29 +403,16 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 
 	/* Each transmission of a Tx packet needs a new serial number */
 	serial = atomic_inc_return(&conn->serial);
-
-	whdr.epoch	= htonl(conn->proto.epoch);
-	whdr.cid	= htonl(call->cid);
-	whdr.callNumber	= htonl(call->call_id);
-	whdr.seq	= htonl(sp->hdr.seq);
-	whdr.serial	= htonl(serial);
-	whdr.type	= RXRPC_PACKET_TYPE_DATA;
-	whdr.flags	= sp->hdr.flags;
-	whdr.userStatus	= 0;
-	whdr.securityIndex = call->security_ix;
-	whdr._rsvd	= htons(sp->hdr._rsvd);
-	whdr.serviceId	= htons(call->service_id);
+	txb->wire.serial = htonl(serial);
 
 	if (test_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags) &&
-	    sp->hdr.seq == 1)
-		whdr.userStatus	= RXRPC_USERSTATUS_SERVICE_UPGRADE;
+	    txb->seq == 1)
+		txb->wire.userStatus = RXRPC_USERSTATUS_SERVICE_UPGRADE;
 
-	iov[0].iov_base = &whdr;
-	iov[0].iov_len = sizeof(whdr);
-	iov[1].iov_base = skb->head;
-	iov[1].iov_len = skb->len;
-	len = iov[0].iov_len + iov[1].iov_len;
-	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 2, len);
+	iov[0].iov_base = &txb->wire;
+	iov[0].iov_len = sizeof(txb->wire) + txb->len;
+	len = iov[0].iov_len;
+	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
 
 	msg.msg_name = &call->peer->srx.transport;
 	msg.msg_namelen = call->peer->srx.transport_len;
@@ -443,19 +427,19 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	 * service call, lest OpenAFS incorrectly send us an ACK with some
 	 * soft-ACKs in it and then never follow up with a proper hard ACK.
 	 */
-	if (whdr.flags & RXRPC_REQUEST_ACK)
+	if (txb->wire.flags & RXRPC_REQUEST_ACK)
 		why = rxrpc_reqack_already_on;
-	else if ((whdr.flags & RXRPC_LAST_PACKET) && rxrpc_to_client(sp))
+	else if (test_bit(RXRPC_TXBUF_LAST, &txb->flags) && rxrpc_sending_to_client(txb))
 		why = rxrpc_reqack_no_srv_last;
 	else if (test_and_clear_bit(RXRPC_CALL_EV_ACK_LOST, &call->events))
 		why = rxrpc_reqack_ack_lost;
-	else if (retrans)
+	else if (test_bit(RXRPC_TXBUF_RESENT, &txb->flags))
 		why = rxrpc_reqack_retrans;
 	else if (call->cong_mode == RXRPC_CALL_SLOW_START && call->cong_cwnd <= 2)
 		why = rxrpc_reqack_slow_start;
 	else if (call->tx_winsize <= 2)
 		why = rxrpc_reqack_small_txwin;
-	else if (call->peer->rtt_count < 3 && sp->hdr.seq & 1)
+	else if (call->peer->rtt_count < 3 && txb->seq & 1)
 		why = rxrpc_reqack_more_rtt;
 	else if (ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000), ktime_get_real()))
 		why = rxrpc_reqack_old_rtt;
@@ -463,35 +447,36 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 		goto dont_set_request_ack;
 
 	rxrpc_inc_stat(call->rxnet, stat_why_req_ack[why]);
-	trace_rxrpc_req_ack(call->debug_id, sp->hdr.seq, why);
+	trace_rxrpc_req_ack(call->debug_id, txb->seq, why);
 	if (why != rxrpc_reqack_no_srv_last)
-		whdr.flags |= RXRPC_REQUEST_ACK;
+		txb->wire.flags |= RXRPC_REQUEST_ACK;
 dont_set_request_ack:
 
 	if (IS_ENABLED(CONFIG_AF_RXRPC_INJECT_LOSS)) {
 		static int lose;
 		if ((lose++ & 7) == 7) {
 			ret = 0;
-			trace_rxrpc_tx_data(call, sp->hdr.seq, serial,
-					    whdr.flags, retrans, true);
+			trace_rxrpc_tx_data(call, txb->seq, serial,
+					    txb->wire.flags,
+					    test_bit(RXRPC_TXBUF_RESENT, &txb->flags),
+					    true);
 			goto done;
 		}
 	}
 
-	trace_rxrpc_tx_data(call, sp->hdr.seq, serial, whdr.flags, retrans,
-			    false);
+	trace_rxrpc_tx_data(call, txb->seq, serial, txb->wire.flags,
+			    test_bit(RXRPC_TXBUF_RESENT, &txb->flags), false);
+	cmpxchg(&call->tx_transmitted, txb->seq - 1, txb->seq);
 
 	/* send the packet with the don't fragment bit set if we currently
 	 * think it's small enough */
-	if (iov[1].iov_len >= call->peer->maxdata)
+	if (txb->len >= call->peer->maxdata)
 		goto send_fragmentable;
 
 	down_read(&conn->params.local->defrag_sem);
 
-	sp->hdr.serial = serial;
-	smp_wmb(); /* Set serial before timestamp */
-	skb->tstamp = ktime_get_real();
-	if (whdr.flags & RXRPC_REQUEST_ACK)
+	txb->last_sent = ktime_get_real();
+	if (txb->wire.flags & RXRPC_REQUEST_ACK)
 		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_data);
 
 	/* send the packet by UDP
@@ -510,7 +495,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_data_nofrag);
 	} else {
-		trace_rxrpc_tx_packet(call->debug_id, &whdr,
+		trace_rxrpc_tx_packet(call->debug_id, &txb->wire,
 				      rxrpc_tx_point_call_data_nofrag);
 	}
 
@@ -520,8 +505,8 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 
 done:
 	if (ret >= 0) {
-		if (whdr.flags & RXRPC_REQUEST_ACK) {
-			call->peer->rtt_last_req = skb->tstamp;
+		if (txb->wire.flags & RXRPC_REQUEST_ACK) {
+			call->peer->rtt_last_req = txb->last_sent;
 			if (call->peer->rtt_count > 1) {
 				unsigned long nowj = jiffies, ack_lost_at;
 
@@ -533,7 +518,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 			}
 		}
 
-		if (sp->hdr.seq == 1 &&
+		if (txb->seq == 1 &&
 		    !test_and_set_bit(RXRPC_CALL_BEGAN_RX_TIMER,
 				      &call->flags)) {
 			unsigned long nowj = jiffies, expect_rx_by;
@@ -565,23 +550,21 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 
 	down_write(&conn->params.local->defrag_sem);
 
-	sp->hdr.serial = serial;
-	smp_wmb(); /* Set serial before timestamp */
-	skb->tstamp = ktime_get_real();
-	if (whdr.flags & RXRPC_REQUEST_ACK)
+	txb->last_sent = ktime_get_real();
+	if (txb->wire.flags & RXRPC_REQUEST_ACK)
 		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_data);
 
 	switch (conn->params.local->srx.transport.family) {
 	case AF_INET6:
 	case AF_INET:
 		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
-				IP_PMTUDISC_DONT);
+					 IP_PMTUDISC_DONT);
 		rxrpc_inc_stat(call->rxnet, stat_tx_data_send_frag);
 		ret = do_udp_sendmsg(conn->params.local->socket, &msg, len);
 		conn->params.peer->last_tx_at = ktime_get_seconds();
 
 		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
-				IP_PMTUDISC_DO);
+					 IP_PMTUDISC_DO);
 		break;
 
 	default:
@@ -593,7 +576,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_data_frag);
 	} else {
-		trace_rxrpc_tx_packet(call->debug_id, &whdr,
+		trace_rxrpc_tx_packet(call->debug_id, &txb->wire,
 				      rxrpc_tx_point_call_data_frag);
 	}
 	rxrpc_tx_backoff(call, ret);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index d48af0178866..0807753ec2dc 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -54,7 +54,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	struct rxrpc_call *call;
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
 	unsigned long timeout = 0;
-	rxrpc_seq_t tx_hard_ack;
+	rxrpc_seq_t acks_hard_ack;
 	char lbuff[50], rbuff[50];
 	u64 wtmp;
 
@@ -91,7 +91,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		timeout -= jiffies;
 	}
 
-	tx_hard_ack = READ_ONCE(call->tx_hard_ack);
+	acks_hard_ack = READ_ONCE(call->acks_hard_ack);
 	wtmp   = atomic64_read_acquire(&call->ackr_window);
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %4x %08x %08x %s %3u"
@@ -106,7 +106,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   rxrpc_call_states[call->state],
 		   call->abort_code,
 		   call->debug_id,
-		   tx_hard_ack, READ_ONCE(call->tx_top) - tx_hard_ack,
+		   acks_hard_ack, READ_ONCE(call->tx_top) - acks_hard_ack,
 		   lower_32_bits(wtmp), upper_32_bits(wtmp) - lower_32_bits(wtmp),
 		   call->rx_serial,
 		   timeout);
@@ -459,9 +459,8 @@ int rxrpc_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_slow_start]),
 		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_small_txwin]));
 	seq_printf(seq,
-		   "Buffers  : txb=%u,%u rxb=%u\n",
+		   "Buffers  : txb=%u rxb=%u\n",
 		   atomic_read(&rxrpc_nr_txbuf),
-		   atomic_read(&rxrpc_n_tx_skbs),
 		   atomic_read(&rxrpc_n_rx_skbs));
 	return 0;
 }
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index d87c99b36e01..8fc055587f0e 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -259,11 +259,10 @@ static void rxkad_free_call_crypto(struct rxrpc_call *call)
  * partially encrypt a packet (level 1 security)
  */
 static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
-				    struct sk_buff *skb, u32 data_size,
+				    struct rxrpc_txbuf *txb,
 				    struct skcipher_request *req)
 {
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	struct rxkad_level1_hdr hdr;
+	struct rxkad_level1_hdr *hdr = (void *)txb->data;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg;
 	size_t pad;
@@ -271,22 +270,22 @@ static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
 
 	_enter("");
 
-	check = sp->hdr.seq ^ call->call_id;
-	data_size |= (u32)check << 16;
-
-	hdr.data_size = htonl(data_size);
-	memcpy(skb->head, &hdr, sizeof(hdr));
+	check = txb->seq ^ ntohl(txb->wire.callNumber);
+	hdr->data_size = htonl((u32)check << 16 | txb->len);
 
-	pad = sizeof(struct rxkad_level1_hdr) + data_size;
+	txb->len += sizeof(struct rxkad_level1_hdr);
+	pad = txb->len;
 	pad = RXKAD_ALIGN - pad;
 	pad &= RXKAD_ALIGN - 1;
-	if (pad)
-		skb_put_zero(skb, pad);
+	if (pad) {
+		memset(txb->data + txb->offset, 0, pad);
+		txb->len += pad;
+	}
 
 	/* start the encryption afresh */
 	memset(&iv, 0, sizeof(iv));
 
-	sg_init_one(&sg, skb->head, 8);
+	sg_init_one(&sg, txb->data, 8);
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
@@ -301,87 +300,60 @@ static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
  * wholly encrypt a packet (level 2 security)
  */
 static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
-				       struct sk_buff *skb,
-				       u32 data_size,
+				       struct rxrpc_txbuf *txb,
 				       struct skcipher_request *req)
 {
 	const struct rxrpc_key_token *token;
-	struct rxkad_level2_hdr rxkhdr;
-	struct rxrpc_skb_priv *sp;
+	struct rxkad_level2_hdr *rxkhdr = (void *)txb->data;
 	struct rxrpc_crypt iv;
-	struct scatterlist sg[16];
-	unsigned int len;
+	struct scatterlist sg;
 	size_t pad;
 	u16 check;
-	int err;
-
-	sp = rxrpc_skb(skb);
+	int ret;
 
 	_enter("");
 
-	check = sp->hdr.seq ^ call->call_id;
+	check = txb->seq ^ ntohl(txb->wire.callNumber);
 
-	rxkhdr.data_size = htonl(data_size | (u32)check << 16);
-	rxkhdr.checksum = 0;
-	memcpy(skb->head, &rxkhdr, sizeof(rxkhdr));
+	rxkhdr->data_size = htonl(txb->len | (u32)check << 16);
+	rxkhdr->checksum = 0;
 
-	pad = sizeof(struct rxkad_level2_hdr) + data_size;
+	txb->len += sizeof(struct rxkad_level2_hdr);
+	pad = txb->len;
 	pad = RXKAD_ALIGN - pad;
 	pad &= RXKAD_ALIGN - 1;
-	if (pad)
-		skb_put_zero(skb, pad);
+	if (pad) {
+		memset(txb->data + txb->offset, 0, pad);
+		txb->len += pad;
+	}
 
 	/* encrypt from the session key */
 	token = call->conn->params.key->payload.data[0];
 	memcpy(&iv, token->kad->session_key, sizeof(iv));
 
-	sg_init_one(&sg[0], skb->head, sizeof(rxkhdr));
+	sg_init_one(&sg, txb->data, txb->len);
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sg[0], &sg[0], sizeof(rxkhdr), iv.x);
-	crypto_skcipher_encrypt(req);
-
-	/* we want to encrypt the skbuff in-place */
-	err = -EMSGSIZE;
-	if (skb_shinfo(skb)->nr_frags > 16)
-		goto out;
-
-	len = round_up(data_size, RXKAD_ALIGN);
-
-	sg_init_table(sg, ARRAY_SIZE(sg));
-	err = skb_to_sgvec(skb, sg, 8, len);
-	if (unlikely(err < 0))
-		goto out;
-	skcipher_request_set_crypt(req, sg, sg, len, iv.x);
-	crypto_skcipher_encrypt(req);
-
-	_leave(" = 0");
-	err = 0;
-
-out:
+	skcipher_request_set_crypt(req, &sg, &sg, txb->len, iv.x);
+	ret = crypto_skcipher_encrypt(req);
 	skcipher_request_zero(req);
-	return err;
+	return ret;
 }
 
 /*
  * checksum an RxRPC packet header
  */
-static int rxkad_secure_packet(struct rxrpc_call *call,
-			       struct sk_buff *skb,
-			       size_t data_size)
+static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 {
-	struct rxrpc_skb_priv *sp;
 	struct skcipher_request	*req;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg;
 	u32 x, y;
 	int ret;
 
-	sp = rxrpc_skb(skb);
-
-	_enter("{%d{%x}},{#%u},%zu,",
+	_enter("{%d{%x}},{#%u},%u,",
 	       call->debug_id, key_serial(call->conn->params.key),
-	       sp->hdr.seq, data_size);
+	       txb->seq, txb->len);
 
 	if (!call->conn->rxkad.cipher)
 		return 0;
@@ -398,9 +370,9 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
 	memcpy(&iv, call->conn->rxkad.csum_iv.x, sizeof(iv));
 
 	/* calculate the security checksum */
-	x = (call->cid & RXRPC_CHANNELMASK) << (32 - RXRPC_CIDSHIFT);
-	x |= sp->hdr.seq & 0x3fffffff;
-	call->crypto_buf[0] = htonl(call->call_id);
+	x = (ntohl(txb->wire.cid) & RXRPC_CHANNELMASK) << (32 - RXRPC_CIDSHIFT);
+	x |= txb->seq & 0x3fffffff;
+	call->crypto_buf[0] = txb->wire.callNumber;
 	call->crypto_buf[1] = htonl(x);
 
 	sg_init_one(&sg, call->crypto_buf, 8);
@@ -414,17 +386,17 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
 	y = (y >> 16) & 0xffff;
 	if (y == 0)
 		y = 1; /* zero checksums are not permitted */
-	sp->hdr.cksum = y;
+	txb->wire.cksum = htons(y);
 
 	switch (call->conn->params.security_level) {
 	case RXRPC_SECURITY_PLAIN:
 		ret = 0;
 		break;
 	case RXRPC_SECURITY_AUTH:
-		ret = rxkad_secure_packet_auth(call, skb, data_size, req);
+		ret = rxkad_secure_packet_auth(call, txb, req);
 		break;
 	case RXRPC_SECURITY_ENCRYPT:
-		ret = rxkad_secure_packet_encrypt(call, skb, data_size, req);
+		ret = rxkad_secure_packet_encrypt(call, txb, req);
 		break;
 	default:
 		ret = -EPERM;
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index e32805a49324..a96ae7f58148 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -25,7 +25,7 @@ static bool rxrpc_check_tx_space(struct rxrpc_call *call, rxrpc_seq_t *_tx_win)
 	unsigned int win_size =
 		min_t(unsigned int, call->tx_winsize,
 		      call->cong_cwnd + call->cong_extra);
-	rxrpc_seq_t tx_win = READ_ONCE(call->tx_hard_ack);
+	rxrpc_seq_t tx_win = smp_load_acquire(&call->acks_hard_ack);
 
 	if (_tx_win)
 		*_tx_win = tx_win;
@@ -50,7 +50,12 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 		if (signal_pending(current))
 			return sock_intr_errno(*timeo);
 
-		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
+		if (READ_ONCE(call->acks_hard_ack) != call->tx_bottom) {
+			rxrpc_shrink_call_tx_buffer(call);
+			continue;
+		}
+
+		trace_rxrpc_txqueue(call, rxrpc_txqueue_wait);
 		*timeo = schedule_timeout(*timeo);
 	}
 }
@@ -71,12 +76,11 @@ static int rxrpc_wait_for_tx_window_waitall(struct rxrpc_sock *rx,
 		rtt = 2;
 
 	timeout = rtt;
-	tx_start = READ_ONCE(call->tx_hard_ack);
+	tx_start = smp_load_acquire(&call->acks_hard_ack);
 
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 
-		tx_win = READ_ONCE(call->tx_hard_ack);
 		if (rxrpc_check_tx_space(call, &tx_win))
 			return 0;
 
@@ -87,12 +91,17 @@ static int rxrpc_wait_for_tx_window_waitall(struct rxrpc_sock *rx,
 		    tx_win == tx_start && signal_pending(current))
 			return -EINTR;
 
+		if (READ_ONCE(call->acks_hard_ack) != call->tx_bottom) {
+			rxrpc_shrink_call_tx_buffer(call);
+			continue;
+		}
+
 		if (tx_win != tx_start) {
 			timeout = rtt;
 			tx_start = tx_win;
 		}
 
-		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
+		trace_rxrpc_txqueue(call, rxrpc_txqueue_wait);
 		timeout = schedule_timeout(timeout);
 	}
 }
@@ -112,7 +121,12 @@ static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
 		if (call->state >= RXRPC_CALL_COMPLETE)
 			return call->error;
 
-		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
+		if (READ_ONCE(call->acks_hard_ack) != call->tx_bottom) {
+			rxrpc_shrink_call_tx_buffer(call);
+			continue;
+		}
+
+		trace_rxrpc_txqueue(call, rxrpc_txqueue_wait);
 		*timeo = schedule_timeout(*timeo);
 	}
 }
@@ -129,8 +143,8 @@ static int rxrpc_wait_for_tx_window(struct rxrpc_sock *rx,
 	DECLARE_WAITQUEUE(myself, current);
 	int ret;
 
-	_enter(",{%u,%u,%u}",
-	       call->tx_hard_ack, call->tx_top, call->tx_winsize);
+	_enter(",{%u,%u,%u,%u}",
+	       call->tx_bottom, call->acks_hard_ack, call->tx_top, call->tx_winsize);
 
 	add_wait_queue(&call->waitq, &myself);
 
@@ -154,24 +168,6 @@ static int rxrpc_wait_for_tx_window(struct rxrpc_sock *rx,
 	return ret;
 }
 
-/*
- * Schedule an instant Tx resend.
- */
-static inline void rxrpc_instant_resend(struct rxrpc_call *call, int ix)
-{
-	spin_lock_bh(&call->lock);
-
-	if (call->state < RXRPC_CALL_COMPLETE) {
-		call->rxtx_annotations[ix] =
-			(call->rxtx_annotations[ix] & RXRPC_TX_ANNO_LAST) |
-			RXRPC_TX_ANNO_RETRANS;
-		if (!test_and_set_bit(RXRPC_CALL_EV_RESEND, &call->events))
-			rxrpc_queue_call(call);
-	}
-
-	spin_unlock_bh(&call->lock);
-}
-
 /*
  * Notify the owner of the call that the transmit phase is ended and the last
  * packet has been queued.
@@ -188,40 +184,35 @@ static void rxrpc_notify_end_tx(struct rxrpc_sock *rx, struct rxrpc_call *call,
  * the packet immediately.  Returns the error from rxrpc_send_data_packet()
  * in case the caller wants to do something with it.
  */
-static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
-			      struct sk_buff *skb, bool last,
-			      rxrpc_notify_end_tx_t notify_end_tx)
+static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
+			       struct rxrpc_txbuf *txb,
+			       rxrpc_notify_end_tx_t notify_end_tx)
 {
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	unsigned long now;
-	rxrpc_seq_t seq = sp->hdr.seq;
-	int ret, ix;
-	u8 annotation = RXRPC_TX_ANNO_UNACK;
-
-	_net("queue skb %p [%d]", skb, seq);
+	rxrpc_seq_t seq = txb->seq;
+	bool last = test_bit(RXRPC_TXBUF_LAST, &txb->flags);
+	int ret;
 
 	rxrpc_inc_stat(call->rxnet, stat_tx_data);
 
 	ASSERTCMP(seq, ==, call->tx_top + 1);
 
-	if (last)
-		annotation |= RXRPC_TX_ANNO_LAST;
-
 	/* We have to set the timestamp before queueing as the retransmit
 	 * algorithm can see the packet as soon as we queue it.
 	 */
-	skb->tstamp = ktime_get_real();
+	txb->last_sent = ktime_get_real();
 
-	ix = seq & RXRPC_RXTX_BUFF_MASK;
-	rxrpc_get_skb(skb, rxrpc_skb_got);
-	call->rxtx_annotations[ix] = annotation;
-	smp_wmb();
-	call->rxtx_buffer[ix] = skb;
+	/* Add the packet to the call's output buffer */
+	rxrpc_get_txbuf(txb, rxrpc_txbuf_get_buffer);
+	spin_lock(&call->tx_lock);
+	list_add_tail(&txb->call_link, &call->tx_buffer);
 	call->tx_top = seq;
+	spin_unlock(&call->tx_lock);
+
 	if (last)
-		trace_rxrpc_transmit(call, rxrpc_transmit_queue_last);
+		trace_rxrpc_txqueue(call, rxrpc_txqueue_queue_last);
 	else
-		trace_rxrpc_transmit(call, rxrpc_transmit_queue);
+		trace_rxrpc_txqueue(call, rxrpc_txqueue_queue);
 
 	if (last || call->state == RXRPC_CALL_SERVER_ACK_REQUEST) {
 		_debug("________awaiting reply/ACK__________");
@@ -254,7 +245,7 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 	if (seq == 1 && rxrpc_is_client_call(call))
 		rxrpc_expose_client_call(call);
 
-	ret = rxrpc_send_data_packet(call, skb, false);
+	ret = rxrpc_send_data_packet(call, txb);
 	if (ret < 0) {
 		switch (ret) {
 		case -ENETUNREACH:
@@ -264,8 +255,6 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 						  0, ret);
 			goto out;
 		}
-		_debug("need instant resend %d", ret);
-		rxrpc_instant_resend(call, ix);
 	} else {
 		unsigned long now = jiffies;
 		unsigned long resend_at = now + call->peer->rto_j;
@@ -276,9 +265,7 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 	}
 
 out:
-	rxrpc_free_skb(skb, rxrpc_skb_freed);
-	_leave(" = %d", ret);
-	return ret;
+	rxrpc_put_txbuf(txb, rxrpc_txbuf_put_trans);
 }
 
 /*
@@ -292,8 +279,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			   rxrpc_notify_end_tx_t notify_end_tx,
 			   bool *_dropped_lock)
 {
-	struct rxrpc_skb_priv *sp;
-	struct sk_buff *skb;
+	struct rxrpc_txbuf *txb;
 	struct sock *sk = &rx->sk;
 	enum rxrpc_call_state state;
 	long timeo;
@@ -327,14 +313,15 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			goto maybe_error;
 	}
 
-	skb = call->tx_pending;
+	txb = call->tx_pending;
 	call->tx_pending = NULL;
-	rxrpc_see_skb(skb, rxrpc_skb_seen);
+	if (txb)
+		rxrpc_see_txbuf(txb, rxrpc_txbuf_see_send_more);
 
 	do {
 		rxrpc_transmit_ack_packets(call->peer->local);
 
-		if (!skb) {
+		if (!txb) {
 			size_t remain, bufsize, chunk, offset;
 
 			_debug("alloc");
@@ -355,52 +342,31 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			_debug("SIZE: %zu/%zu @%zu", chunk, bufsize, offset);
 
 			/* create a buffer that we can retain until it's ACK'd */
-			skb = sock_alloc_send_skb(
-				sk, bufsize, msg->msg_flags & MSG_DONTWAIT, &ret);
-			if (!skb)
+			ret = -ENOMEM;
+			txb = rxrpc_alloc_txbuf(call, RXRPC_PACKET_TYPE_DATA,
+						GFP_KERNEL);
+			if (!txb)
 				goto maybe_error;
 
-			sp = rxrpc_skb(skb);
-			rxrpc_new_skb(skb, rxrpc_skb_new);
-
-			_debug("ALLOC SEND %p", skb);
-
-			ASSERTCMP(skb->mark, ==, 0);
-
-			__skb_put(skb, offset);
-
-			sp->remain = chunk;
-			if (sp->remain > skb_tailroom(skb))
-				sp->remain = skb_tailroom(skb);
-
-			_net("skb: hr %d, tr %d, hl %d, rm %d",
-			       skb_headroom(skb),
-			       skb_tailroom(skb),
-			       skb_headlen(skb),
-			       sp->remain);
-
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			txb->offset = offset;
+			txb->space -= offset;
+			txb->space = min_t(size_t, chunk, txb->space);
 		}
 
 		_debug("append");
-		sp = rxrpc_skb(skb);
 
 		/* append next segment of data to the current buffer */
 		if (msg_data_left(msg) > 0) {
-			int copy = skb_tailroom(skb);
-			ASSERTCMP(copy, >, 0);
-			if (copy > msg_data_left(msg))
-				copy = msg_data_left(msg);
-			if (copy > sp->remain)
-				copy = sp->remain;
-
-			_debug("add");
-			ret = skb_add_data(skb, &msg->msg_iter, copy);
-			_debug("added");
-			if (ret < 0)
+			size_t copy = min_t(size_t, txb->space, msg_data_left(msg));
+
+			_debug("add %zu", copy);
+			if (!copy_from_iter_full(txb->data + txb->offset, copy,
+						 &msg->msg_iter))
 				goto efault;
-			sp->remain -= copy;
-			skb->mark += copy;
+			_debug("added");
+			txb->space -= copy;
+			txb->len += copy;
+			txb->offset += copy;
 			copied += copy;
 			if (call->tx_total_len != -1)
 				call->tx_total_len -= copy;
@@ -412,32 +378,22 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			goto call_terminated;
 
 		/* add the packet to the send queue if it's now full */
-		if (sp->remain <= 0 ||
+		if (!txb->space ||
 		    (msg_data_left(msg) == 0 && !more)) {
-			struct rxrpc_connection *conn = call->conn;
-			uint32_t seq;
-
-			seq = call->tx_top + 1;
-
-			sp->hdr.seq	= seq;
-			sp->hdr._rsvd	= 0;
-			sp->hdr.flags	= conn->out_clientflag;
-
-			if (msg_data_left(msg) == 0 && !more)
-				sp->hdr.flags |= RXRPC_LAST_PACKET;
-			else if (call->tx_top - call->tx_hard_ack <
+			if (msg_data_left(msg) == 0 && !more) {
+				txb->wire.flags |= RXRPC_LAST_PACKET;
+				__set_bit(RXRPC_TXBUF_LAST, &txb->flags);
+			}
+			else if (call->tx_top - call->acks_hard_ack <
 				 call->tx_winsize)
-				sp->hdr.flags |= RXRPC_MORE_PACKETS;
+				txb->wire.flags |= RXRPC_MORE_PACKETS;
 
-			ret = call->security->secure_packet(call, skb, skb->mark);
+			ret = call->security->secure_packet(call, txb);
 			if (ret < 0)
 				goto out;
 
-			ret = rxrpc_queue_packet(rx, call, skb,
-						 !msg_data_left(msg) && !more,
-						 notify_end_tx);
-			/* Should check for failure here */
-			skb = NULL;
+			rxrpc_queue_packet(rx, call, txb, notify_end_tx);
+			txb = NULL;
 		}
 	} while (msg_data_left(msg) > 0);
 
@@ -450,12 +406,12 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 		read_unlock_bh(&call->state_lock);
 	}
 out:
-	call->tx_pending = skb;
+	call->tx_pending = txb;
 	_leave(" = %d", ret);
 	return ret;
 
 call_terminated:
-	rxrpc_free_skb(skb, rxrpc_skb_freed);
+	rxrpc_put_txbuf(txb, rxrpc_txbuf_put_send_aborted);
 	_leave(" = %d", call->error);
 	return call->error;
 
diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
index 45a7b48a5e10..96bfee89927b 100644
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -99,3 +99,37 @@ void rxrpc_put_txbuf(struct rxrpc_txbuf *txb, enum rxrpc_txbuf_trace what)
 			call_rcu(&txb->rcu, rxrpc_free_txbuf);
 	}
 }
+
+/*
+ * Shrink the transmit buffer.
+ */
+void rxrpc_shrink_call_tx_buffer(struct rxrpc_call *call)
+{
+	struct rxrpc_txbuf *txb;
+	rxrpc_seq_t hard_ack = smp_load_acquire(&call->acks_hard_ack);
+
+	_enter("%x/%x/%x", call->tx_bottom, call->acks_hard_ack, call->tx_top);
+
+	for (;;) {
+		spin_lock(&call->tx_lock);
+		txb = list_first_entry_or_null(&call->tx_buffer,
+					       struct rxrpc_txbuf, call_link);
+		if (!txb)
+			break;
+		hard_ack = smp_load_acquire(&call->acks_hard_ack);
+		if (before(hard_ack, txb->seq))
+			break;
+
+		ASSERTCMP(txb->seq, ==, call->tx_bottom + 1);
+		call->tx_bottom++;
+		list_del_rcu(&txb->call_link);
+
+		trace_rxrpc_txqueue(call, rxrpc_txqueue_dequeue);
+
+		spin_unlock(&call->tx_lock);
+
+		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_rotated);
+	}
+
+	spin_unlock(&call->tx_lock);
+}


