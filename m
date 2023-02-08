Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3C568ECD9
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbjBHK3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjBHK2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:28:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90C646727
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675852084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5w/Gjj7DW5ecxl8zA3551kkbDeon6m1PThZoUo8b6x8=;
        b=A0m+ROQCBo+7uL9SSgS5iboO+fZEzJKfAJ0w6XH+Csa4Rz2lD5QzxSASomic3H59NYwZlv
        Np7HyMkZEBqzZGAPhp1IDQ6XR5hXglAr3pEephNilXnGFVrfs45vHR3D4RKEcGkw3EMnh/
        T7uHf+oUvSVj5/jRUep1/BbeLYYlWU0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-Ppae9fkXOSCdYx20j-_rMQ-1; Wed, 08 Feb 2023 05:27:59 -0500
X-MC-Unique: Ppae9fkXOSCdYx20j-_rMQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23DB9101A521;
        Wed,  8 Feb 2023 10:27:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08F4E140EBF4;
        Wed,  8 Feb 2023 10:27:57 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] rxrpc: Trace ack.rwind
Date:   Wed,  8 Feb 2023 10:27:49 +0000
Message-Id: <20230208102750.18107-4-dhowells@redhat.com>
In-Reply-To: <20230208102750.18107-1-dhowells@redhat.com>
References: <20230208102750.18107-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Log ack.rwind in the rxrpc_tx_ack tracepoint.  This value is useful to see
as it represents flow-control information to the peer.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 include/trace/events/rxrpc.h | 11 +++++++----
 net/rxrpc/conn_event.c       |  2 +-
 net/rxrpc/output.c           | 10 +++++++---
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index d7bb4acf4580..c3c0b0aa8381 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1118,9 +1118,9 @@ TRACE_EVENT(rxrpc_tx_data,
 TRACE_EVENT(rxrpc_tx_ack,
 	    TP_PROTO(unsigned int call, rxrpc_serial_t serial,
 		     rxrpc_seq_t ack_first, rxrpc_serial_t ack_serial,
-		     u8 reason, u8 n_acks),
+		     u8 reason, u8 n_acks, u16 rwind),
 
-	    TP_ARGS(call, serial, ack_first, ack_serial, reason, n_acks),
+	    TP_ARGS(call, serial, ack_first, ack_serial, reason, n_acks, rwind),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,	call)
@@ -1129,6 +1129,7 @@ TRACE_EVENT(rxrpc_tx_ack,
 		    __field(rxrpc_serial_t,	ack_serial)
 		    __field(u8,			reason)
 		    __field(u8,			n_acks)
+		    __field(u16,		rwind)
 			     ),
 
 	    TP_fast_assign(
@@ -1138,15 +1139,17 @@ TRACE_EVENT(rxrpc_tx_ack,
 		    __entry->ack_serial = ack_serial;
 		    __entry->reason = reason;
 		    __entry->n_acks = n_acks;
+		    __entry->rwind = rwind;
 			   ),
 
-	    TP_printk(" c=%08x ACK  %08x %s f=%08x r=%08x n=%u",
+	    TP_printk(" c=%08x ACK  %08x %s f=%08x r=%08x n=%u rw=%u",
 		      __entry->call,
 		      __entry->serial,
 		      __print_symbolic(__entry->reason, rxrpc_ack_names),
 		      __entry->ack_first,
 		      __entry->ack_serial,
-		      __entry->n_acks)
+		      __entry->n_acks,
+		      __entry->rwind)
 	    );
 
 TRACE_EVENT(rxrpc_receive,
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 44414e724415..95f4bc206b3d 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -163,7 +163,7 @@ void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 		trace_rxrpc_tx_ack(chan->call_debug_id, serial,
 				   ntohl(pkt.ack.firstPacket),
 				   ntohl(pkt.ack.serial),
-				   pkt.ack.reason, 0);
+				   pkt.ack.reason, 0, rxrpc_rx_window_size);
 		break;
 
 	default:
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 6b2022240076..5e53429c6922 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -80,7 +80,8 @@ static void rxrpc_set_keepalive(struct rxrpc_call *call)
  */
 static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 				 struct rxrpc_call *call,
-				 struct rxrpc_txbuf *txb)
+				 struct rxrpc_txbuf *txb,
+				 u16 *_rwind)
 {
 	struct rxrpc_ackinfo ackinfo;
 	unsigned int qsize, sack, wrap, to;
@@ -124,6 +125,7 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 	jmax = rxrpc_rx_jumbo_max;
 	qsize = (window - 1) - call->rx_consumed;
 	rsize = max_t(int, call->rx_winsize - qsize, 0);
+	*_rwind = rsize;
 	ackinfo.rxMTU		= htonl(rxrpc_rx_mtu);
 	ackinfo.maxMTU		= htonl(mtu);
 	ackinfo.rwind		= htonl(rsize);
@@ -190,6 +192,7 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	rxrpc_serial_t serial;
 	size_t len, n;
 	int ret, rtt_slot = -1;
+	u16 rwind;
 
 	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		return -ECONNRESET;
@@ -205,7 +208,7 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	if (txb->ack.reason == RXRPC_ACK_PING)
 		txb->wire.flags |= RXRPC_REQUEST_ACK;
 
-	n = rxrpc_fill_out_ack(conn, call, txb);
+	n = rxrpc_fill_out_ack(conn, call, txb, &rwind);
 	if (n == 0)
 		return 0;
 
@@ -217,7 +220,8 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	txb->wire.serial = htonl(serial);
 	trace_rxrpc_tx_ack(call->debug_id, serial,
 			   ntohl(txb->ack.firstPacket),
-			   ntohl(txb->ack.serial), txb->ack.reason, txb->ack.nAcks);
+			   ntohl(txb->ack.serial), txb->ack.reason, txb->ack.nAcks,
+			   rwind);
 
 	if (txb->ack.reason == RXRPC_ACK_PING)
 		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_ping);

