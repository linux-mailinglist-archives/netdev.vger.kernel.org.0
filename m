Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CFA52F0CD
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351766AbiETQe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351759AbiETQen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:34:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A9AA18541E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653064465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DK0SAajG/TJcxOWS+cQ31l+UPExFSP3wmD0TKCGxiF0=;
        b=E5hQFnhSeXwan2u/nmz/o4/GD9NGgROXoqSC8fkMj4i4P9YbPDat3Lo8xCEqzxuvxraj9K
        fpNtJhQeIiMELYMYM3B+WUHdLLXMS+xxE1xrSAtTcbu/IaXaDIfnweDA9Euh9iGI5Ey5nr
        3qTdsrOrXH+3GyW2TPzSCz8+aP1N0gg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-4b26uAIAOMiYWcS3v1XITg-1; Fri, 20 May 2022 12:34:23 -0400
X-MC-Unique: 4b26uAIAOMiYWcS3v1XITg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67B4C29AB3F8;
        Fri, 20 May 2022 16:34:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95C442026D6A;
        Fri, 20 May 2022 16:34:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 6/6] rxrpc: Fix decision on when to generate an IDLE ACK
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 20 May 2022 17:34:21 +0100
Message-ID: <165306446189.34086.4230022096487746478.stgit@warthog.procyon.org.uk>
In-Reply-To: <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk>
References: <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the decision on when to generate an IDLE ACK by keeping a count of the
number of packets we've received, but not yet soft-ACK'd, and the number of
packets we've processed, but not yet hard-ACK'd, rather than trying to keep
track of which DATA sequence numbers correspond to those points.

We then generate an ACK when either counter exceeds 2.  The counters are
both cleared when we transcribe the information into any sort of ACK packet
for transmission.  IDLE and DELAY ACKs are skipped if both counters are 0
(ie. no change).

Fixes: 805b21b929e2 ("rxrpc: Send an ACK after every few DATA packets we receive")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    2 +-
 net/rxrpc/ar-internal.h      |    4 ++--
 net/rxrpc/input.c            |   11 +++++++++--
 net/rxrpc/output.c           |   18 +++++++++++-------
 net/rxrpc/recvmsg.c          |    8 +++-----
 5 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 4a3ab0ed6e06..1c714336b863 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1509,7 +1509,7 @@ TRACE_EVENT(rxrpc_call_reset,
 		    __entry->call_serial = call->rx_serial;
 		    __entry->conn_serial = call->conn->hi_serial;
 		    __entry->tx_seq = call->tx_hard_ack;
-		    __entry->rx_seq = call->ackr_seen;
+		    __entry->rx_seq = call->rx_hard_ack;
 			   ),
 
 	    TP_printk("c=%08x %08x:%08x r=%08x/%08x tx=%08x rx=%08x",
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 8465985a4cb6..dce056adb78c 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -680,8 +680,8 @@ struct rxrpc_call {
 	u8			ackr_reason;	/* reason to ACK */
 	rxrpc_serial_t		ackr_serial;	/* serial of packet being ACK'd */
 	rxrpc_seq_t		ackr_highest_seq; /* Higest sequence number received */
-	rxrpc_seq_t		ackr_consumed;	/* Highest packet shown consumed */
-	rxrpc_seq_t		ackr_seen;	/* Highest packet shown seen */
+	atomic_t		ackr_nr_unacked; /* Number of unacked packets */
+	atomic_t		ackr_nr_consumed; /* Number of packets needing hard ACK */
 
 	/* RTT management */
 	rxrpc_serial_t		rtt_serial[4];	/* Serial number of DATA or PING sent */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 2e61545ad8ca..1145cb14d86f 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -412,8 +412,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	enum rxrpc_call_state state;
-	unsigned int j, nr_subpackets;
-	rxrpc_serial_t serial = sp->hdr.serial, ack_serial = 0;
+	unsigned int j, nr_subpackets, nr_unacked = 0;
+	rxrpc_serial_t serial = sp->hdr.serial, ack_serial = serial;
 	rxrpc_seq_t seq0 = sp->hdr.seq, hard_ack;
 	bool immediate_ack = false, jumbo_bad = false;
 	u8 ack = 0;
@@ -569,6 +569,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			sp = NULL;
 		}
 
+		nr_unacked++;
+
 		if (last) {
 			set_bit(RXRPC_CALL_RX_LAST, &call->flags);
 			if (!ack) {
@@ -588,9 +590,14 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			}
 			call->rx_expect_next = seq + 1;
 		}
+		if (!ack)
+			ack_serial = serial;
 	}
 
 ack:
+	if (atomic_add_return(nr_unacked, &call->ackr_nr_unacked) > 2 && !ack)
+		ack = RXRPC_ACK_IDLE;
+
 	if (ack)
 		rxrpc_propose_ACK(call, ack, ack_serial,
 				  immediate_ack, true,
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 46aae9b7006f..9683617db704 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -74,11 +74,18 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 				 u8 reason)
 {
 	rxrpc_serial_t serial;
+	unsigned int tmp;
 	rxrpc_seq_t hard_ack, top, seq;
 	int ix;
 	u32 mtu, jmax;
 	u8 *ackp = pkt->acks;
 
+	tmp = atomic_xchg(&call->ackr_nr_unacked, 0);
+	tmp |= atomic_xchg(&call->ackr_nr_consumed, 0);
+	if (!tmp && (reason == RXRPC_ACK_DELAY ||
+		     reason == RXRPC_ACK_IDLE))
+		return 0;
+
 	/* Barrier against rxrpc_input_data(). */
 	serial = call->ackr_serial;
 	hard_ack = READ_ONCE(call->rx_hard_ack);
@@ -223,6 +230,10 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 	n = rxrpc_fill_out_ack(conn, call, pkt, &hard_ack, &top, reason);
 
 	spin_unlock_bh(&call->lock);
+	if (n == 0) {
+		kfree(pkt);
+		return 0;
+	}
 
 	iov[0].iov_base	= pkt;
 	iov[0].iov_len	= sizeof(pkt->whdr) + sizeof(pkt->ack) + n;
@@ -259,13 +270,6 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 					  ntohl(pkt->ack.serial),
 					  false, true,
 					  rxrpc_propose_ack_retry_tx);
-		} else {
-			spin_lock_bh(&call->lock);
-			if (after(hard_ack, call->ackr_consumed))
-				call->ackr_consumed = hard_ack;
-			if (after(top, call->ackr_seen))
-				call->ackr_seen = top;
-			spin_unlock_bh(&call->lock);
 		}
 
 		rxrpc_set_keepalive(call);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index eca6dda26c77..250f23bc1c07 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -260,11 +260,9 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 		rxrpc_end_rx_phase(call, serial);
 	} else {
 		/* Check to see if there's an ACK that needs sending. */
-		if (after_eq(hard_ack, call->ackr_consumed + 2) ||
-		    after_eq(top, call->ackr_seen + 2) ||
-		    (hard_ack == top && after(hard_ack, call->ackr_consumed)))
-			rxrpc_propose_ACK(call, RXRPC_ACK_DELAY, serial,
-					  true, true,
+		if (atomic_inc_return(&call->ackr_nr_consumed) > 2)
+			rxrpc_propose_ACK(call, RXRPC_ACK_IDLE, serial,
+					  true, false,
 					  rxrpc_propose_ack_rotate_rx);
 		if (call->ackr_reason && call->ackr_reason != RXRPC_ACK_DELAY)
 			rxrpc_send_ack_packet(call, false, NULL);


