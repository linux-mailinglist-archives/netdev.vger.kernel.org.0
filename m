Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2859F63FCF6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiLBAZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiLBAYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:24:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566BCD49D0
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VtdYwukbYgl0UpjEXIEIAmSWA1Q9LhbOt+7IbY0H2pY=;
        b=Iao2ry0UegWOfdrLUWli7J4B32dsipjiPgF5TTPIPe+DVeQ2oecgJCVnSgb17nno4gvMo/
        l+i5BJRchVyygdGtol40vAmjj1iqfwCNzlA8GAQiwe1ClMDs5uj4qTT5hZQbnwhWXNugND
        CTokrf3SU8vkbyiMdfY7mG7SaeMzWvs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647--bqb77arP8aFycDHfcTVxQ-1; Thu, 01 Dec 2022 19:19:47 -0500
X-MC-Unique: -bqb77arP8aFycDHfcTVxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0B853C025C1;
        Fri,  2 Dec 2022 00:19:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F87740C6FA1;
        Fri,  2 Dec 2022 00:19:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 33/36] rxrpc: Trace/count transmission underflows and
 cwnd resets
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:19:43 +0000
Message-ID: <166994038346.1732290.1422703717754094118.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
index c49b0c233594..b41e913ae78a 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1446,6 +1446,44 @@ TRACE_EVENT(rxrpc_congest,
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
index 6b993a3d4186..6cfe366ee224 100644
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
index 18591f9ecc6a..9f1e490ab976 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -317,8 +317,10 @@ static void rxrpc_transmit_some_data(struct rxrpc_call *call)
 	case RXRPC_CALL_CLIENT_AWAIT_REPLY:
 		if (!rxrpc_tx_window_has_space(call))
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
index dd2ac5d55e1c..2988e3d0c1f6 100644
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
index e5d715b855fc..8147a47d1702 100644
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
index 5af7c8ee4b1a..6816934cb4cf 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -398,13 +398,16 @@ int rxrpc_stats_show(struct seq_file *seq, void *v)
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
@@ -472,8 +475,11 @@ int rxrpc_stats_clear(struct file *file, char *buf, size_t size)
 
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


