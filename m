Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53CC63DB75
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiK3REz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiK3REP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:04:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6D78B1BF
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aq4DkxpZC2p4fY6FSUmjQGcB/Am9rAKQ2JZKLZqwp+8=;
        b=VcRoYYnW8fmXWzdWZt/1bHCKwSswWhRDh0vAVMyVCNJ4CFmW85+xm4rlLQnF/Ptlm5YvEf
        /7qAVrxS4Vo0eihwRYyFIJSkLJhWtPGrlEIlXzsb5AjnYRXIhaaLrlHpY8+aLZ7ZOM8CNA
        g18cfcTgHzB5M7kYrifTxfEIvwbe/a0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-I5nMLBL9O5C-4EMW0-zemQ-1; Wed, 30 Nov 2022 11:59:07 -0500
X-MC-Unique: I5nMLBL9O5C-4EMW0-zemQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3933E81114C;
        Wed, 30 Nov 2022 16:59:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77A7E40C83D9;
        Wed, 30 Nov 2022 16:59:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 33/35] rxrpc: Move the cwnd degradation after
 transmitting packets
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:59:03 +0000
Message-ID: <166982754368.621383.8337942706520370774.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

When we've gone for >1RTT without transmitting a packet, we should reduce
the ssthresh and cut the cwnd by half (as suggested in RFC2861 sec 3.1).

However, we may receive ACK packets in a batch and the first of these may
cut the cwnd, preventing further transmission, and each subsequent one cuts
the cwnd yet further, reducing it to the floor and killing performance.

Fix this by moving the cwnd reset to after doing the transmission and
resetting the base time such that we don't cut the cwnd by half again for
at least another RTT.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    2 ++
 net/rxrpc/call_event.c  |    7 +++++++
 net/rxrpc/input.c       |   49 ++++++++++++++++++++++++++---------------------
 net/rxrpc/proc.c        |    5 +++--
 4 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 6cfe366ee224..785cd0dd1eea 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -666,6 +666,7 @@ struct rxrpc_call {
 	 * packets) rather than bytes.
 	 */
 #define RXRPC_TX_SMSS		RXRPC_JUMBO_DATALEN
+#define RXRPC_MIN_CWND		(RXRPC_TX_SMSS > 2190 ? 2 : RXRPC_TX_SMSS > 1095 ? 3 : 4)
 	u8			cong_cwnd;	/* Congestion window size */
 	u8			cong_extra;	/* Extra to send for congestion management */
 	u8			cong_ssthresh;	/* Slow-start threshold */
@@ -953,6 +954,7 @@ void rxrpc_unpublish_service_conn(struct rxrpc_connection *);
 /*
  * input.c
  */
+void rxrpc_congestion_degrade(struct rxrpc_call *);
 void rxrpc_input_call_packet(struct rxrpc_call *, struct sk_buff *);
 void rxrpc_implicit_end_call(struct rxrpc_call *, struct sk_buff *);
 
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 9f1e490ab976..fd122e3726bd 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -427,6 +427,13 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 
 	rxrpc_transmit_some_data(call);
 
+	if (skb) {
+		struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+
+		if (sp->hdr.type == RXRPC_PACKET_TYPE_ACK)
+			rxrpc_congestion_degrade(call);
+	}
+
 	if (test_and_clear_bit(RXRPC_CALL_EV_INITIAL_PING, &call->events))
 		rxrpc_send_initial_ping(call);
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 2988e3d0c1f6..d0e20e946e48 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -27,7 +27,6 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 	enum rxrpc_congest_change change = rxrpc_cong_no_change;
 	unsigned int cumulative_acks = call->cong_cumul_acks;
 	unsigned int cwnd = call->cong_cwnd;
-	ktime_t now;
 	bool resend = false;
 
 	summary->flight_size =
@@ -57,27 +56,6 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 	summary->cumulative_acks = cumulative_acks;
 	summary->dup_acks = call->cong_dup_acks;
 
-	/* If we haven't transmitted anything for >1RTT, we should reset the
-	 * congestion management state.
-	 */
-	now = ktime_get_real();
-	if ((call->cong_mode == RXRPC_CALL_SLOW_START ||
-	     call->cong_mode == RXRPC_CALL_CONGEST_AVOIDANCE) &&
-	    ktime_before(ktime_add_us(call->tx_last_sent,
-				      call->peer->srtt_us >> 3), now)
-	    ) {
-		trace_rxrpc_reset_cwnd(call, now);
-		change = rxrpc_cong_idle_reset;
-		rxrpc_inc_stat(call->rxnet, stat_tx_data_cwnd_reset);
-		summary->mode = RXRPC_CALL_SLOW_START;
-		if (RXRPC_TX_SMSS > 2190)
-			summary->cwnd = 2;
-		else if (RXRPC_TX_SMSS > 1095)
-			summary->cwnd = 3;
-		else
-			summary->cwnd = 4;
-	}
-
 	switch (call->cong_mode) {
 	case RXRPC_CALL_SLOW_START:
 		if (summary->saw_nacks)
@@ -197,6 +175,33 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 	goto out_no_clear_ca;
 }
 
+/*
+ * Degrade the congestion window if we haven't transmitted a packet for >1RTT.
+ */
+void rxrpc_congestion_degrade(struct rxrpc_call *call)
+{
+	ktime_t rtt, now;
+
+	if (call->cong_mode != RXRPC_CALL_SLOW_START &&
+	    call->cong_mode != RXRPC_CALL_CONGEST_AVOIDANCE)
+		return;
+	if (call->state == RXRPC_CALL_CLIENT_AWAIT_REPLY)
+		return;
+
+	rtt = ns_to_ktime(call->peer->srtt_us * (1000 / 8));
+	now = ktime_get_real();
+	if (!ktime_before(ktime_add(call->tx_last_sent, rtt), now))
+		return;
+
+	trace_rxrpc_reset_cwnd(call, now);
+	rxrpc_inc_stat(call->rxnet, stat_tx_data_cwnd_reset);
+	call->tx_last_sent = now;
+	call->cong_mode = RXRPC_CALL_SLOW_START;
+	call->cong_ssthresh = max_t(unsigned int, call->cong_ssthresh,
+				    call->cong_cwnd * 3 / 4);
+	call->cong_cwnd = max_t(unsigned int, call->cong_cwnd / 2, RXRPC_MIN_CWND);
+}
+
 /*
  * Apply a hard ACK by advancing the Tx window.
  */
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 6816934cb4cf..3a59591ec061 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -61,7 +61,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 			 "Proto Local                                          "
 			 " Remote                                         "
 			 " SvID ConnID   CallID   End Use State    Abort   "
-			 " DebugId  TxSeq    TW RxSeq    RW RxSerial RxTimo\n");
+			 " DebugId  TxSeq    TW RxSeq    RW RxSerial CW RxTimo\n");
 		return 0;
 	}
 
@@ -84,7 +84,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	wtmp   = atomic64_read_acquire(&call->ackr_window);
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %4x %08x %08x %s %3u"
-		   " %-8.8s %08x %08x %08x %02x %08x %02x %08x %06lx\n",
+		   " %-8.8s %08x %08x %08x %02x %08x %02x %08x %02x %06lx\n",
 		   lbuff,
 		   rbuff,
 		   call->dest_srx.srx_service,
@@ -98,6 +98,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   acks_hard_ack, READ_ONCE(call->tx_top) - acks_hard_ack,
 		   lower_32_bits(wtmp), upper_32_bits(wtmp) - lower_32_bits(wtmp),
 		   call->rx_serial,
+		   call->cong_cwnd,
 		   timeout);
 
 	return 0;


