Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF63635A0B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbiKWKfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbiKWKdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:33:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC2D5D6B6
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHW23ejjhjyvRpmP5w2UjGozo4bf+iiWNO2xV3+Fuzo=;
        b=XVyBZXQuHasDjyDnbeWDHHIAyOyfEHjibqdF54GneM0+ZuvSf0rmLdshiRBy2bVwsrq0E+
        quuQsoOgMnLOjpCx879t1/ph4x9VuM7Jx+jQwQ4PruBZm1zVGHS29gm1y3Hij1zfkQdML+
        mbIfmyNzrVgyN6S1rq7mccESSSYSiDE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-TKjIWnxBOQ-HxPzU2MWSog-1; Wed, 23 Nov 2022 05:16:19 -0500
X-MC-Unique: TKjIWnxBOQ-HxPzU2MWSog-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6EC61C0514A;
        Wed, 23 Nov 2022 10:16:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 259F240C6EC5;
        Wed, 23 Nov 2022 10:16:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 14/17] rxrpc: Move the cwnd degradation after
 transmitting packets
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:16:17 +0000
Message-ID: <166919857756.1258552.4076044570600351747.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
index 40e8e360eaca..070635174b1c 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -658,6 +658,7 @@ struct rxrpc_call {
 	 * packets) rather than bytes.
 	 */
 #define RXRPC_TX_SMSS		RXRPC_JUMBO_DATALEN
+#define RXRPC_MIN_CWND		(RXRPC_TX_SMSS > 2190 ? 2 : RXRPC_TX_SMSS > 1095 ? 3 : 4)
 	u8			cong_cwnd;	/* Congestion window size */
 	u8			cong_extra;	/* Extra to send for congestion management */
 	u8			cong_ssthresh;	/* Slow-start threshold */
@@ -958,6 +959,7 @@ void rxrpc_unpublish_service_conn(struct rxrpc_connection *);
 /*
  * input.c
  */
+void rxrpc_congestion_degrade(struct rxrpc_call *);
 void rxrpc_input_call_packet(struct rxrpc_call *, struct sk_buff *);
 void rxrpc_implicit_end_call(struct rxrpc_call *, struct sk_buff *);
 
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index bfd378b1427b..2e08a8e3a8f8 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -420,6 +420,13 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 
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
index e09ed9af97c0..f5a3b1e4f284 100644
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
index a3719ef3a9ab..752a15b11f7e 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -63,7 +63,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 			 "Proto Local                                          "
 			 " Remote                                         "
 			 " SvID ConnID   CallID   End Use State    Abort   "
-			 " DebugId  TxSeq    TW RxSeq    RW RxSerial RxTimo\n");
+			 " DebugId  TxSeq    TW RxSeq    RW RxSerial CW RxTimo\n");
 		return 0;
 	}
 
@@ -95,7 +95,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 	wtmp   = atomic64_read_acquire(&call->ackr_window);
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %4x %08x %08x %s %3u"
-		   " %-8.8s %08x %08x %08x %02x %08x %02x %08x %06lx\n",
+		   " %-8.8s %08x %08x %08x %02x %08x %02x %08x %02x %06lx\n",
 		   lbuff,
 		   rbuff,
 		   call->service_id,
@@ -109,6 +109,7 @@ static int rxrpc_call_seq_show(struct seq_file *seq, void *v)
 		   acks_hard_ack, READ_ONCE(call->tx_top) - acks_hard_ack,
 		   lower_32_bits(wtmp), upper_32_bits(wtmp) - lower_32_bits(wtmp),
 		   call->rx_serial,
+		   call->cong_cwnd,
 		   timeout);
 
 	return 0;


