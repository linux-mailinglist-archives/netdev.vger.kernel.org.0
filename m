Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC2B68337A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbjAaROK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbjAaROA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:14:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2538735AC
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oeonJ8a+8qbwSPtqneYlX3y7pBQBMbPBzLLzshZErfQ=;
        b=b0VTgzY2FqXrFdVPsp/qFSVbzbDXGoJvZcdc8mwqv2qyClc0+mMKDtgTUeXFReE859MYB6
        ZD1txRBVhKJZl5rkLR4ibybavDRyw45mSkEEkvJxxoK6Eb4uez95WR5lV6FiSTTMddXmwz
        Xg+32MUoNVn/k22T9zQqxZmVOOjrGY0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-Pu98Ejj2MQWxdfef95PicQ-1; Tue, 31 Jan 2023 12:12:49 -0500
X-MC-Unique: Pu98Ejj2MQWxdfef95PicQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AFC5380408A;
        Tue, 31 Jan 2023 17:12:43 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EE1E40C2064;
        Tue, 31 Jan 2023 17:12:42 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/13] rxrpc: De-atomic call->ackr_window and call->ackr_nr_unacked
Date:   Tue, 31 Jan 2023 17:12:21 +0000
Message-Id: <20230131171227.3912130-8-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

call->ackr_window doesn't need to be atomic as ACK generation and ACK
transmission are now done in the same thread, so drop the atomic64 handling
and split it into two separate members.

Similarly, call->ackr_nr_unacked doesn't need to be atomic now either.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 include/trace/events/rxrpc.h | 10 ++++++----
 net/rxrpc/ar-internal.h      |  5 +++--
 net/rxrpc/call_event.c       |  2 +-
 net/rxrpc/call_object.c      |  3 ++-
 net/rxrpc/input.c            | 14 +++++++-------
 net/rxrpc/output.c           | 13 +++++--------
 net/rxrpc/proc.c             |  4 +---
 net/rxrpc/recvmsg.c          |  6 +++---
 8 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 450b8f345814..e51a84f349d8 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1152,7 +1152,8 @@ TRACE_EVENT(rxrpc_receive,
 		    __field(enum rxrpc_receive_trace,	why)
 		    __field(rxrpc_serial_t,		serial)
 		    __field(rxrpc_seq_t,		seq)
-		    __field(u64,			window)
+		    __field(rxrpc_seq_t,		window)
+		    __field(rxrpc_seq_t,		wtop)
 			     ),
 
 	    TP_fast_assign(
@@ -1160,7 +1161,8 @@ TRACE_EVENT(rxrpc_receive,
 		    __entry->why = why;
 		    __entry->serial = serial;
 		    __entry->seq = seq;
-		    __entry->window = atomic64_read(&call->ackr_window);
+		    __entry->window = call->ackr_window;
+		    __entry->wtop = call->ackr_wtop;
 			   ),
 
 	    TP_printk("c=%08x %s r=%08x q=%08x w=%08x-%08x",
@@ -1168,8 +1170,8 @@ TRACE_EVENT(rxrpc_receive,
 		      __print_symbolic(__entry->why, rxrpc_receive_traces),
 		      __entry->serial,
 		      __entry->seq,
-		      lower_32_bits(__entry->window),
-		      upper_32_bits(__entry->window))
+		      __entry->window,
+		      __entry->wtop)
 	    );
 
 TRACE_EVENT(rxrpc_recvmsg,
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index bfae4a87626f..2ca99688f7f0 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -692,8 +692,9 @@ struct rxrpc_call {
 	/* Receive-phase ACK management (ACKs we send). */
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
-	atomic64_t		ackr_window;	/* Base (in LSW) and top (in MSW) of SACK window */
-	atomic_t		ackr_nr_unacked; /* Number of unacked packets */
+	rxrpc_seq_t		ackr_window;	/* Base of SACK window */
+	rxrpc_seq_t		ackr_wtop;	/* Base of SACK window */
+	unsigned int		ackr_nr_unacked; /* Number of unacked packets */
 	atomic_t		ackr_nr_consumed; /* Number of packets needing hard ACK */
 	struct {
 #define RXRPC_SACK_SIZE 256
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index cf9799be4286..e363f21a2014 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -498,7 +498,7 @@ bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, 0,
 			       rxrpc_propose_ack_rx_idle);
 
-	if (atomic_read(&call->ackr_nr_unacked) > 2) {
+	if (call->ackr_nr_unacked > 2) {
 		if (call->peer->rtt_count < 3)
 			rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
 				       rxrpc_propose_ack_ping_for_rtt);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 0012589f2aad..6eaffb0d8fdc 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -167,7 +167,8 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	call->tx_total_len = -1;
 	call->next_rx_timo = 20 * HZ;
 	call->next_req_timo = 1 * HZ;
-	atomic64_set(&call->ackr_window, 0x100000001ULL);
+	call->ackr_window = 1;
+	call->ackr_wtop = 1;
 
 	memset(&call->sock_node, 0xed, sizeof(call->sock_node));
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 367927a99881..7e65c7d5bff0 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -338,7 +338,8 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 static void rxrpc_input_update_ack_window(struct rxrpc_call *call,
 					  rxrpc_seq_t window, rxrpc_seq_t wtop)
 {
-	atomic64_set_release(&call->ackr_window, ((u64)wtop) << 32 | window);
+	call->ackr_window = window;
+	call->ackr_wtop = wtop;
 }
 
 /*
@@ -367,9 +368,8 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct sk_buff *oos;
 	rxrpc_serial_t serial = sp->hdr.serial;
-	u64 win = atomic64_read(&call->ackr_window);
-	rxrpc_seq_t window = lower_32_bits(win);
-	rxrpc_seq_t wtop = upper_32_bits(win);
+	rxrpc_seq_t window = call->ackr_window;
+	rxrpc_seq_t wtop = call->ackr_wtop;
 	rxrpc_seq_t wlimit = window + call->rx_winsize - 1;
 	rxrpc_seq_t seq = sp->hdr.seq;
 	bool last = sp->hdr.flags & RXRPC_LAST_PACKET;
@@ -419,7 +419,7 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 		else if (!skb_queue_empty(&call->rx_oos_queue))
 			ack_reason = RXRPC_ACK_DELAY;
 		else
-			atomic_inc_return(&call->ackr_nr_unacked);
+			call->ackr_nr_unacked++;
 
 		window++;
 		if (after(window, wtop))
@@ -567,8 +567,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	rxrpc_serial_t serial = sp->hdr.serial;
 	rxrpc_seq_t seq0 = sp->hdr.seq;
 
-	_enter("{%llx,%x},{%u,%x}",
-	       atomic64_read(&call->ackr_window), call->rx_highest_seq,
+	_enter("{%x,%x,%x},{%u,%x}",
+	       call->ackr_window, call->ackr_wtop, call->rx_highest_seq,
 	       skb->len, seq0);
 
 	if (__rxrpc_call_is_complete(call))
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 98b5d0db7761..b6bd5e6ccb4c 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -86,20 +86,18 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	unsigned int qsize;
 	rxrpc_seq_t window, wtop, wrap_point, ix, first;
 	int rsize;
-	u64 wtmp;
 	u32 mtu, jmax;
 	u8 *ackp = txb->acks;
 	u8 sack_buffer[sizeof(call->ackr_sack_table)] __aligned(8);
 
-	atomic_set(&call->ackr_nr_unacked, 0);
+	call->ackr_nr_unacked = 0;
 	atomic_set(&call->ackr_nr_consumed, 0);
 	rxrpc_inc_stat(call->rxnet, stat_tx_ack_fill);
 
 	/* Barrier against rxrpc_input_data(). */
 retry:
-	wtmp   = atomic64_read_acquire(&call->ackr_window);
-	window = lower_32_bits(wtmp);
-	wtop   = upper_32_bits(wtmp);
+	window = call->ackr_window;
+	wtop   = call->ackr_wtop;
 	txb->ack.firstPacket = htonl(window);
 	txb->ack.nAcks = 0;
 
@@ -111,9 +109,8 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 		 */
 		memcpy(sack_buffer, call->ackr_sack_table, sizeof(sack_buffer));
 		wrap_point = window + RXRPC_SACK_SIZE - 1;
-		wtmp   = atomic64_read_acquire(&call->ackr_window);
-		window = lower_32_bits(wtmp);
-		wtop   = upper_32_bits(wtmp);
+		window = call->ackr_window;
+		wtop   = call->ackr_wtop;
 		if (after(wtop, wrap_point)) {
 			cond_resched();
 			goto retry;
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 750158a085cd..682636d3b060 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -55,7 +55,6 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	unsigned long timeout = 0;
 	rxrpc_seq_t acks_hard_ack;
 	char lbuff[50], rbuff[50];
-	u64 wtmp;
 
 	if (v == &rxnet->calls) {
 		seq_puts(seq,
@@ -83,7 +82,6 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	}
 
 	acks_hard_ack = READ_ONCE(call->acks_hard_ack);
-	wtmp   = atomic64_read_acquire(&call->ackr_window);
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %4x %08x %08x %s %3u"
 		   " %-8.8s %08x %08x %08x %02x %08x %02x %08x %02x %06lx\n",
@@ -98,7 +96,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   call->abort_code,
 		   call->debug_id,
 		   acks_hard_ack, READ_ONCE(call->tx_top) - acks_hard_ack,
-		   lower_32_bits(wtmp), upper_32_bits(wtmp) - lower_32_bits(wtmp),
+		   call->ackr_window, call->ackr_wtop - call->ackr_window,
 		   call->rx_serial,
 		   call->cong_cwnd,
 		   timeout);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index b7545fdc0401..50d263a6359d 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -95,7 +95,7 @@ static int rxrpc_recvmsg_term(struct rxrpc_call *call, struct msghdr *msg)
 	}
 
 	trace_rxrpc_recvdata(call, rxrpc_recvmsg_terminal,
-			     lower_32_bits(atomic64_read(&call->ackr_window)) - 1,
+			     call->ackr_window - 1,
 			     call->rx_pkt_offset, call->rx_pkt_len, ret);
 	return ret;
 }
@@ -175,13 +175,13 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 	rx_pkt_len = call->rx_pkt_len;
 
 	if (rxrpc_call_has_failed(call)) {
-		seq = lower_32_bits(atomic64_read(&call->ackr_window)) - 1;
+		seq = call->ackr_window - 1;
 		ret = -EIO;
 		goto done;
 	}
 
 	if (test_bit(RXRPC_CALL_RECVMSG_READ_ALL, &call->flags)) {
-		seq = lower_32_bits(atomic64_read(&call->ackr_window)) - 1;
+		seq = call->ackr_window - 1;
 		ret = 1;
 		goto done;
 	}

