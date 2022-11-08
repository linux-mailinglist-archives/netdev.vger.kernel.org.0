Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FFF621F33
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiKHWYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiKHWWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:22:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392E864A24
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667946036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NC4GE1rRhDM6mgGpkViUVDupIy4agqIs8EII4RfcX5g=;
        b=DU1NzumizqYEwjNhVEuCQ09WKEr6kOCZPM+ujDonPjNCWeuvAWb7SPCUnEJtELDz8GNbiP
        L/QWuMFIh+Jc3hfUt3S/w90NlRQDZZfN3M0/foTvso4yBWvr7jjb3MShoH+WDDrz7vt1ku
        Em8BnTnQ28JlFgZLSbBGp7ZV1hgTL8I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-zSVN7sMGMP2HVwSZdiQu5A-1; Tue, 08 Nov 2022 17:20:34 -0500
X-MC-Unique: zSVN7sMGMP2HVwSZdiQu5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B856101A56D;
        Tue,  8 Nov 2022 22:20:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0508D140EBF3;
        Tue,  8 Nov 2022 22:20:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 25/26] rxrpc: Fix congestion management
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:20:33 +0000
Message-ID: <166794603342.2389296.12363215406403504827.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rxrpc has a problem in its congestion management in that it saves the
congestion window size (cwnd) from one call to another, but if this is 0 at
the time is saved, then the next call may not actually manage to ever
transmit anything.

To this end:

 (1) Don't save cwnd between calls, but rather reset back down to the
     initial cwnd and re-enter slow-start if data transmission is idle for
     more than an RTT.

 (2) Preserve ssthresh instead, as that is a handy estimate of pipe
     capacity.  Knowing roughly when to stop slow start and enter
     congestion avoidance can reduce the tendency to overshoot and drop
     larger amounts of packets when probing.

In future, cwind growth also needs to be constrained when the window isn't
being filled due to being application limited.

Reported-by: Simon Wilkinson <sxw@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    1 +
 net/rxrpc/ar-internal.h      |    9 +++++----
 net/rxrpc/call_accept.c      |    3 ++-
 net/rxrpc/call_object.c      |    7 ++++++-
 net/rxrpc/conn_client.c      |    3 ++-
 net/rxrpc/conn_object.c      |    2 +-
 net/rxrpc/input.c            |   21 ++++++++++++++++++++-
 net/rxrpc/output.c           |    1 +
 net/rxrpc/peer_object.c      |    7 +------
 net/rxrpc/proc.c             |    4 ++--
 net/rxrpc/sendmsg.c          |   22 +++++++++++++++++++---
 11 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index a11de55c3c14..b9886d1df825 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -193,6 +193,7 @@
 	EM(rxrpc_cong_new_low_nack,		" NewLowN") \
 	EM(rxrpc_cong_no_change,		" -") \
 	EM(rxrpc_cong_progress,			" Progres") \
+	EM(rxrpc_cong_idle_reset,		" IdleRes") \
 	EM(rxrpc_cong_retransmit_again,		" ReTxAgn") \
 	EM(rxrpc_cong_rtt_window_end,		" RttWinE") \
 	E_(rxrpc_cong_saw_nack,			" SawNack")
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 775eb91aabb2..6bbe28ecf583 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -332,7 +332,7 @@ struct rxrpc_peer {
 	u32			rto_j;		/* Retransmission timeout in jiffies */
 	u8			backoff;	/* Backoff timeout */
 
-	u8			cong_cwnd;	/* Congestion window size */
+	u8			cong_ssthresh;	/* Congestion slow-start threshold */
 };
 
 /*
@@ -626,6 +626,7 @@ struct rxrpc_call {
 	u16			tx_backoff;	/* Delay to insert due to Tx failure */
 	u8			tx_winsize;	/* Maximum size of Tx window */
 #define RXRPC_TX_MAX_WINDOW	128
+	ktime_t			tx_last_sent;	/* Last time a transmission occurred */
 
 	/* Received data tracking */
 	struct sk_buff_head	recvmsg_queue;	/* Queue of packets ready for recvmsg() */
@@ -687,10 +688,10 @@ struct rxrpc_call {
  * Summary of a new ACK and the changes it made to the Tx buffer packet states.
  */
 struct rxrpc_ack_summary {
+	u16			nr_acks;		/* Number of ACKs in packet */
+	u16			nr_new_acks;		/* Number of new ACKs in packet */
+	u16			nr_rot_new_acks;	/* Number of rotated new ACKs */
 	u8			ack_reason;
-	u8			nr_acks;		/* Number of ACKs in packet */
-	u8			nr_new_acks;		/* Number of new ACKs in packet */
-	u8			nr_rot_new_acks;	/* Number of rotated new ACKs */
 	bool			saw_nacks;		/* Saw NACKs in packet */
 	bool			new_low_nack;		/* T if new low NACK found */
 	bool			retrans_timeo;		/* T if reTx due to timeout happened */
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index d8db277d5ebe..48790ee77019 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -324,7 +324,8 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 	call->security = conn->security;
 	call->security_ix = conn->security_ix;
 	call->peer = rxrpc_get_peer(conn->params.peer);
-	call->cong_cwnd = call->peer->cong_cwnd;
+	call->cong_ssthresh = call->peer->cong_ssthresh;
+	call->tx_last_sent = ktime_get_real();
 	return call;
 }
 
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index aa19daaa487b..1befe22cd301 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -166,7 +166,12 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	call->rx_winsize = rxrpc_rx_window_size;
 	call->tx_winsize = 16;
 
-	call->cong_cwnd = 2;
+	if (RXRPC_TX_SMSS > 2190)
+		call->cong_cwnd = 2;
+	else if (RXRPC_TX_SMSS > 1095)
+		call->cong_cwnd = 3;
+	else
+		call->cong_cwnd = 4;
 	call->cong_ssthresh = RXRPC_TX_MAX_WINDOW;
 
 	call->rxnet = rxnet;
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 3c9eeb5b750c..f020f308ed9e 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -363,7 +363,8 @@ static struct rxrpc_bundle *rxrpc_prep_call(struct rxrpc_sock *rx,
 	if (!cp->peer)
 		goto error;
 
-	call->cong_cwnd = cp->peer->cong_cwnd;
+	call->tx_last_sent = ktime_get_real();
+	call->cong_ssthresh = cp->peer->cong_ssthresh;
 	if (call->cong_cwnd >= call->cong_ssthresh)
 		call->cong_mode = RXRPC_CALL_CONGEST_AVOIDANCE;
 	else
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index f7ea71ae6159..156bd26daf74 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -207,7 +207,7 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 {
 	struct rxrpc_connection *conn = call->conn;
 
-	call->peer->cong_cwnd = call->cong_cwnd;
+	call->peer->cong_ssthresh = call->cong_ssthresh;
 
 	if (!hlist_unhashed(&call->error_link)) {
 		spin_lock_bh(&call->peer->lock);
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 5c17fed4b60f..bdf70b81addc 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -58,6 +58,25 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 	summary->cumulative_acks = cumulative_acks;
 	summary->dup_acks = call->cong_dup_acks;
 
+	/* If we haven't transmitted anything for >1RTT, we should reset the
+	 * congestion management state.
+	 */
+	if ((call->cong_mode == RXRPC_CALL_SLOW_START ||
+	     call->cong_mode == RXRPC_CALL_CONGEST_AVOIDANCE) &&
+	    ktime_before(ktime_add_us(call->tx_last_sent,
+				      call->peer->srtt_us >> 3),
+			 ktime_get_real())
+	    ) {
+		change = rxrpc_cong_idle_reset;
+		summary->mode = RXRPC_CALL_SLOW_START;
+		if (RXRPC_TX_SMSS > 2190)
+			summary->cwnd = 2;
+		else if (RXRPC_TX_SMSS > 1095)
+			summary->cwnd = 3;
+		else
+			summary->cwnd = 4;
+	}
+
 	switch (call->cong_mode) {
 	case RXRPC_CALL_SLOW_START:
 		if (summary->saw_nacks)
@@ -205,7 +224,7 @@ static bool rxrpc_rotate_tx_window(struct rxrpc_call *call, rxrpc_seq_t to,
 
 	if (call->acks_lowest_nak == call->acks_hard_ack) {
 		call->acks_lowest_nak = to;
-	} else if (before_eq(call->acks_lowest_nak, to)) {
+	} else if (after(to, call->acks_lowest_nak)) {
 		summary->new_low_nack = true;
 		call->acks_lowest_nak = to;
 	}
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 2c3f7e4e30d7..46432e70a16b 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -501,6 +501,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 
 done:
 	if (ret >= 0) {
+		call->tx_last_sent = txb->last_sent;
 		if (txb->wire.flags & RXRPC_REQUEST_ACK) {
 			call->peer->rtt_last_req = txb->last_sent;
 			if (call->peer->rtt_count > 1) {
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 26d2ae9baaf2..041a51225c5f 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -227,12 +227,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 
 		rxrpc_peer_init_rtt(peer);
 
-		if (RXRPC_TX_SMSS > 2190)
-			peer->cong_cwnd = 2;
-		else if (RXRPC_TX_SMSS > 1095)
-			peer->cong_cwnd = 3;
-		else
-			peer->cong_cwnd = 4;
+		peer->cong_ssthresh = RXRPC_TX_MAX_WINDOW;
 		trace_rxrpc_peer(peer->debug_id, rxrpc_peer_new, 1, here);
 	}
 
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 0807753ec2dc..fae22a8b38d6 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -217,7 +217,7 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 		seq_puts(seq,
 			 "Proto Local                                          "
 			 " Remote                                         "
-			 " Use  CW   MTU LastUse      RTT      RTO\n"
+			 " Use SST   MTU LastUse      RTT      RTO\n"
 			 );
 		return 0;
 	}
@@ -235,7 +235,7 @@ static int rxrpc_peer_seq_show(struct seq_file *seq, void *v)
 		   lbuff,
 		   rbuff,
 		   refcount_read(&peer->ref),
-		   peer->cong_cwnd,
+		   peer->cong_ssthresh,
 		   peer->mtu,
 		   now - peer->last_tx_at,
 		   peer->srtt_us >> 3,
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 9b567aff3e84..e5fd8a95bf71 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -22,11 +22,27 @@
  */
 static bool rxrpc_check_tx_space(struct rxrpc_call *call, rxrpc_seq_t *_tx_win)
 {
-	unsigned int win_size =
-		min_t(unsigned int, call->tx_winsize,
-		      call->cong_cwnd + call->cong_extra);
+	unsigned int win_size;
 	rxrpc_seq_t tx_win = smp_load_acquire(&call->acks_hard_ack);
 
+	/* If we haven't transmitted anything for >1RTT, we should reset the
+	 * congestion management state.
+	 */
+	if (ktime_before(ktime_add_us(call->tx_last_sent,
+				      call->peer->srtt_us >> 3),
+			 ktime_get_real())) {
+		if (RXRPC_TX_SMSS > 2190)
+			win_size = 2;
+		else if (RXRPC_TX_SMSS > 1095)
+			win_size = 3;
+		else
+			win_size = 4;
+		win_size += call->cong_extra;
+	} else {
+		win_size = min_t(unsigned int, call->tx_winsize,
+				 call->cong_cwnd + call->cong_extra);
+	}
+
 	if (_tx_win)
 		*_tx_win = tx_win;
 	return call->tx_top - tx_win < win_size;


