Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F13E635A06
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237541AbiKWKey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237390AbiKWKdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:33:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D362129C25
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Co/xyABOc5zMcoMWc18WDmKfwok5LtDdGpoHyxU1xR0=;
        b=X6eKRCrl+1jo/45H+4oqWpgjTLWYkdExQ+SmRmXlo7qwhTDHZWsWsTrcP/yZ1mrqePxxFO
        +IOOivjMm68A2AJ8l6x/mtHRFFTHETgReDT7DckILTFEDutkpq950VUGuumwU92tTaWNzP
        8UZLeK08mEurub0JDo0HtcT7BpHRBO0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-lTSy4wDAN4Kni01ujpVKyQ-1; Wed, 23 Nov 2022 05:16:12 -0500
X-MC-Unique: lTSy4wDAN4Kni01ujpVKyQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66DC61C0514A;
        Wed, 23 Nov 2022 10:16:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7707492B07;
        Wed, 23 Nov 2022 10:16:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 13/17] rxrpc: Trace/count transmission underflows and
 cwnd resets
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:16:11 +0000
Message-ID: <166919857110.1258552.8596135505379095195.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a tracepoint to log when a cwnd reset occurs due to lack of
transmission on a call.

Add stat counters to count transmission underflows (ie. when we have tx
window space, but sendmsg doesn't manage to keep up), cwnd resets and
transmission failures.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   38 ++++++++++++++++++++++++++++++++++++++
 net/rxrpc/ar-internal.h      |    3 +++
 net/rxrpc/call_event.c       |    4 +++-
 net/rxrpc/input.c            |    7 +++++--
 net/rxrpc/output.c           |    2 ++
 net/rxrpc/proc.c             |   14 ++++++++++----
 6 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 824b1a316715..27a002a66ea6 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1440,6 +1440,44 @@ TRACE_EVENT(rxrpc_congest,
 		      __entry->sum.retrans_timeo ? " rTxTo" : "")
 	    );
 
+TRACE_EVENT(rxrpc_reset_cwnd,
+	    TP_PROTO(struct rxrpc_call *call, ktime_t now),
+
+	    TP_ARGS(call, now),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,			call		)
+		    __field(enum rxrpc_congest_mode,		mode		)
+		    __field(unsigned short,			cwnd		)
+		    __field(unsigned short,			extra		)
+		    __field(rxrpc_seq_t,			hard_ack	)
+		    __field(rxrpc_seq_t,			prepared	)
+		    __field(ktime_t,				since_last_tx	)
+		    __field(bool,				has_data	)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->call	= call->debug_id;
+		    __entry->mode	= call->cong_mode;
+		    __entry->cwnd	= call->cong_cwnd;
+		    __entry->extra	= call->cong_extra;
+		    __entry->hard_ack	= call->acks_hard_ack;
+		    __entry->prepared	= call->tx_prepared - call->tx_bottom;
+		    __entry->since_last_tx = ktime_sub(now, call->tx_last_sent);
+		    __entry->has_data	= !list_empty(&call->tx_sendmsg);
+			   ),
+
+	    TP_printk("c=%08x q=%08x %s cw=%u+%u pr=%u tm=%llu d=%u",
+		      __entry->call,
+		      __entry->hard_ack,
+		      __print_symbolic(__entry->mode, rxrpc_congest_modes),
+		      __entry->cwnd,
+		      __entry->extra,
+		      __entry->prepared,
+		      ktime_to_ns(__entry->since_last_tx),
+		      __entry->has_data)
+	    );
+
 TRACE_EVENT(rxrpc_disconnect_call,
 	    TP_PROTO(struct rxrpc_call *call),
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index b17ae8c975ae..40e8e360eaca 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -101,6 +101,9 @@ struct rxrpc_net {
 	atomic_t		stat_tx_data_retrans;
 	atomic_t		stat_tx_data_send;
 	atomic_t		stat_tx_data_send_frag;
+	atomic_t		stat_tx_data_send_fail;
+	atomic_t		stat_tx_data_underflow;
+	atomic_t		stat_tx_data_cwnd_reset;
 	atomic_t		stat_rx_data;
 	atomic_t		stat_rx_data_reqack;
 	atomic_t		stat_rx_data_jumbo;
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index e578706d2379..bfd378b1427b 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -310,8 +310,10 @@ static void rxrpc_transmit_some_data(struct rxrpc_call *call)
 	case RXRPC_CALL_CLIENT_AWAIT_REPLY:
 		if (rxrpc_tx_window_space(call) == 0)
 			return;
-		if (list_empty(&call->tx_sendmsg))
+		if (list_empty(&call->tx_sendmsg)) {
+			rxrpc_inc_stat(call->rxnet, stat_tx_data_underflow);
 			return;
+		}
 		rxrpc_decant_prepared_tx(call);
 		break;
 	default:
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 72ba34148cb5..e09ed9af97c0 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -27,6 +27,7 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 	enum rxrpc_congest_change change = rxrpc_cong_no_change;
 	unsigned int cumulative_acks = call->cong_cumul_acks;
 	unsigned int cwnd = call->cong_cwnd;
+	ktime_t now;
 	bool resend = false;
 
 	summary->flight_size =
@@ -59,13 +60,15 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 	/* If we haven't transmitted anything for >1RTT, we should reset the
 	 * congestion management state.
 	 */
+	now = ktime_get_real();
 	if ((call->cong_mode == RXRPC_CALL_SLOW_START ||
 	     call->cong_mode == RXRPC_CALL_CONGEST_AVOIDANCE) &&
 	    ktime_before(ktime_add_us(call->tx_last_sent,
-				      call->peer->srtt_us >> 3),
-			 ktime_get_real())
+				      call->peer->srtt_us >> 3), now)
 	    ) {
+		trace_rxrpc_reset_cwnd(call, now);
 		change = rxrpc_cong_idle_reset;
+		rxrpc_inc_stat(call->rxnet, stat_tx_data_cwnd_reset);
 		summary->mode = RXRPC_CALL_SLOW_START;
 		if (RXRPC_TX_SMSS > 2190)
 			summary->cwnd = 2;
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 15977421a688..d1c361c35ef9 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -485,6 +485,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 
 	up_read(&conn->local->defrag_sem);
 	if (ret < 0) {
+		rxrpc_inc_stat(call->rxnet, stat_tx_data_send_fail);
 		rxrpc_cancel_rtt_probe(call, serial, rtt_slot);
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_data_nofrag);
@@ -567,6 +568,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	}
 
 	if (ret < 0) {
+		rxrpc_inc_stat(call->rxnet, stat_tx_data_send_fail);
 		rxrpc_cancel_rtt_probe(call, serial, rtt_slot);
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_data_frag);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index b3bb984e0745..a3719ef3a9ab 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -408,13 +408,16 @@ int rxrpc_stats_show(struct seq_file *seq, void *v)
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_single_net(seq));
 
 	seq_printf(seq,
-		   "Data     : send=%u sendf=%u\n",
+		   "Data     : send=%u sendf=%u fail=%u\n",
 		   atomic_read(&rxnet->stat_tx_data_send),
-		   atomic_read(&rxnet->stat_tx_data_send_frag));
+		   atomic_read(&rxnet->stat_tx_data_send_frag),
+		   atomic_read(&rxnet->stat_tx_data_send_fail));
 	seq_printf(seq,
-		   "Data-Tx  : nr=%u retrans=%u\n",
+		   "Data-Tx  : nr=%u retrans=%u uf=%u cwr=%u\n",
 		   atomic_read(&rxnet->stat_tx_data),
-		   atomic_read(&rxnet->stat_tx_data_retrans));
+		   atomic_read(&rxnet->stat_tx_data_retrans),
+		   atomic_read(&rxnet->stat_tx_data_underflow),
+		   atomic_read(&rxnet->stat_tx_data_cwnd_reset));
 	seq_printf(seq,
 		   "Data-Rx  : nr=%u reqack=%u jumbo=%u\n",
 		   atomic_read(&rxnet->stat_rx_data),
@@ -482,8 +485,11 @@ int rxrpc_stats_clear(struct file *file, char *buf, size_t size)
 
 	atomic_set(&rxnet->stat_tx_data, 0);
 	atomic_set(&rxnet->stat_tx_data_retrans, 0);
+	atomic_set(&rxnet->stat_tx_data_underflow, 0);
+	atomic_set(&rxnet->stat_tx_data_cwnd_reset, 0);
 	atomic_set(&rxnet->stat_tx_data_send, 0);
 	atomic_set(&rxnet->stat_tx_data_send_frag, 0);
+	atomic_set(&rxnet->stat_tx_data_send_fail, 0);
 	atomic_set(&rxnet->stat_rx_data, 0);
 	atomic_set(&rxnet->stat_rx_data_reqack, 0);
 	atomic_set(&rxnet->stat_rx_data_jumbo, 0);


