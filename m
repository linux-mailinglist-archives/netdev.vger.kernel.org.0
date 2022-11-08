Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E47621EF9
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiKHWTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiKHWTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:19:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C146D627D6
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3XJk8Wr1snOgsU8aI5nCQBTUd1R9WRxpVJBgI/Dg93I=;
        b=jWaSoln0U4jUGPlahsQurQaUulTurysyaZLGxYol+irAFMylqQkM69EzFmhtdhtGoEHZ3N
        3wDTs0HiKjWTvzAa4rV1ckqte02NlY/AspEtEMjuSmqULJ0Alb9eYHqGnO3MKwY3X74Z52
        ZlJjHe3VGAEb9TUL9HcqU+EliAaHj58=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-v3t4YxpKPN6Bfd3Ag_9meQ-1; Tue, 08 Nov 2022 17:18:06 -0500
X-MC-Unique: v3t4YxpKPN6Bfd3Ag_9meQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 249E085A59D;
        Tue,  8 Nov 2022 22:18:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82E6E2028E90;
        Tue,  8 Nov 2022 22:18:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 02/26] rxrpc: Trace setting of the request-ack flag
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:18:04 +0000
Message-ID: <166794588485.2389296.15468805742011055264.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a tracepoint to log why the request-ack flag is set on an outgoing DATA
packet, allowing debugging as to why.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   36 ++++++++++++++++++++++++++++++++++++
 net/rxrpc/output.c           |   32 +++++++++++++++++++++++---------
 2 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index d20bf4aa0204..4c501c660123 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -242,6 +242,16 @@
 	EM(rxrpc_tx_point_version_keepalive,	"VerKeepalive") \
 	E_(rxrpc_tx_point_version_reply,	"VerReply")
 
+#define rxrpc_req_ack_traces \
+	EM(rxrpc_reqack_ack_lost,		"ACK-LOST  ")	\
+	EM(rxrpc_reqack_already_on,		"ALREADY-ON")	\
+	EM(rxrpc_reqack_more_rtt,		"MORE-RTT  ")	\
+	EM(rxrpc_reqack_no_srv_last,		"NO-SRVLAST")	\
+	EM(rxrpc_reqack_old_rtt,		"OLD-RTT   ")	\
+	EM(rxrpc_reqack_retrans,		"RETRANS   ")	\
+	EM(rxrpc_reqack_slow_start,		"SLOW-START")	\
+	E_(rxrpc_reqack_small_txwin,		"SMALL-TXWN")
+
 /*
  * Generate enums for tracing information.
  */
@@ -263,6 +273,7 @@ enum rxrpc_propose_ack_outcome	{ rxrpc_propose_ack_outcomes } __mode(byte);
 enum rxrpc_propose_ack_trace	{ rxrpc_propose_ack_traces } __mode(byte);
 enum rxrpc_receive_trace	{ rxrpc_receive_traces } __mode(byte);
 enum rxrpc_recvmsg_trace	{ rxrpc_recvmsg_traces } __mode(byte);
+enum rxrpc_req_ack_trace	{ rxrpc_req_ack_traces } __mode(byte);
 enum rxrpc_rtt_rx_trace		{ rxrpc_rtt_rx_traces } __mode(byte);
 enum rxrpc_rtt_tx_trace		{ rxrpc_rtt_tx_traces } __mode(byte);
 enum rxrpc_skb_trace		{ rxrpc_skb_traces } __mode(byte);
@@ -290,6 +301,7 @@ rxrpc_propose_ack_outcomes;
 rxrpc_propose_ack_traces;
 rxrpc_receive_traces;
 rxrpc_recvmsg_traces;
+rxrpc_req_ack_traces;
 rxrpc_rtt_rx_traces;
 rxrpc_rtt_tx_traces;
 rxrpc_skb_traces;
@@ -1395,6 +1407,30 @@ TRACE_EVENT(rxrpc_rx_discard_ack,
 		      __entry->call_ackr_prev)
 	    );
 
+TRACE_EVENT(rxrpc_req_ack,
+	    TP_PROTO(unsigned int call_debug_id, rxrpc_seq_t seq,
+		     enum rxrpc_req_ack_trace why),
+
+	    TP_ARGS(call_debug_id, seq, why),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		call_debug_id	)
+		    __field(rxrpc_seq_t,		seq		)
+		    __field(enum rxrpc_req_ack_trace,	why		)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->call_debug_id = call_debug_id;
+		    __entry->seq = seq;
+		    __entry->why = why;
+			   ),
+
+	    TP_printk("c=%08x q=%08x REQ-%s",
+		      __entry->call_debug_id,
+		      __entry->seq,
+		      __print_symbolic(__entry->why, rxrpc_req_ack_traces))
+	    );
+
 #undef EM
 #undef E_
 #endif /* _TRACE_RXRPC_H */
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 9683617db704..2922c10bd500 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -350,6 +350,7 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 			   bool retrans)
 {
+	enum rxrpc_req_ack_trace why;
 	struct rxrpc_connection *conn = call->conn;
 	struct rxrpc_wire_header whdr;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -405,16 +406,29 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	 * service call, lest OpenAFS incorrectly send us an ACK with some
 	 * soft-ACKs in it and then never follow up with a proper hard ACK.
 	 */
-	if ((!(sp->hdr.flags & RXRPC_LAST_PACKET) ||
-	     rxrpc_to_server(sp)
-	     ) &&
-	    (test_and_clear_bit(RXRPC_CALL_EV_ACK_LOST, &call->events) ||
-	     retrans ||
-	     call->cong_mode == RXRPC_CALL_SLOW_START ||
-	     (call->peer->rtt_count < 3 && sp->hdr.seq & 1) ||
-	     ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000),
-			  ktime_get_real())))
+	if (whdr.flags & RXRPC_REQUEST_ACK)
+		why = rxrpc_reqack_already_on;
+	else if ((whdr.flags & RXRPC_LAST_PACKET) && rxrpc_to_client(sp))
+		why = rxrpc_reqack_no_srv_last;
+	else if (test_and_clear_bit(RXRPC_CALL_EV_ACK_LOST, &call->events))
+		why = rxrpc_reqack_ack_lost;
+	else if (retrans)
+		why = rxrpc_reqack_retrans;
+	else if (call->cong_mode == RXRPC_CALL_SLOW_START && call->cong_cwnd <= 2)
+		why = rxrpc_reqack_slow_start;
+	else if (call->tx_winsize <= 2)
+		why = rxrpc_reqack_small_txwin;
+	else if (call->peer->rtt_count < 3 && sp->hdr.seq & 1)
+		why = rxrpc_reqack_more_rtt;
+	else if (ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000), ktime_get_real()))
+		why = rxrpc_reqack_old_rtt;
+	else
+		goto dont_set_request_ack;
+
+	trace_rxrpc_req_ack(call->debug_id, sp->hdr.seq, why);
+	if (why != rxrpc_reqack_no_srv_last)
 		whdr.flags |= RXRPC_REQUEST_ACK;
+dont_set_request_ack:
 
 	if (IS_ENABLED(CONFIG_AF_RXRPC_INJECT_LOSS)) {
 		static int lose;


