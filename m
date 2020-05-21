Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5681DC738
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 08:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgEUG5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 02:57:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56551 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728262AbgEUG5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 02:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590044223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIIcferyx3v8iJv6FNcaMyU6kKt78I4hYTeWRH84Yak=;
        b=iIAEOc0/AXffGJL54Mm2jj728yMMUdMlMqPQpQ49l8QXAo6GZ2EVlvQAPfpL4ig4CgAuQ2
        a5mdQrWk87NR7YJCBmkt88F9Y+gihXY6c8QLMqDfxv8YLW/itrqZAxn1MwoKRaxX4exz/j
        BxF454jiIeyawJU02ckNP+nGhrE8WLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-qpCS5VBUPNKSoQODLCurxw-1; Thu, 21 May 2020 02:57:00 -0400
X-MC-Unique: qpCS5VBUPNKSoQODLCurxw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6353387300F;
        Thu, 21 May 2020 06:56:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93DDE2E163;
        Thu, 21 May 2020 06:56:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 2/3] rxrpc: Trace discarded ACKs [ver #2]
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 May 2020 07:56:57 +0100
Message-ID: <159004421780.66254.7006799870996502371.stgit@warthog.procyon.org.uk>
In-Reply-To: <159004420353.66254.3034741691675793468.stgit@warthog.procyon.org.uk>
References: <159004420353.66254.3034741691675793468.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a tracepoint to track received ACKs that are discarded due to being
outside of the Tx window.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/trace/events/rxrpc.h |   35 +++++++++++++++++++++++++++++++++++
 net/rxrpc/input.c            |   12 ++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index ab75f261f04a..ba9efdc848f9 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1541,6 +1541,41 @@ TRACE_EVENT(rxrpc_notify_socket,
 		      __entry->serial)
 	    );
 
+TRACE_EVENT(rxrpc_rx_discard_ack,
+	    TP_PROTO(unsigned int debug_id, rxrpc_serial_t serial,
+		     rxrpc_seq_t first_soft_ack, rxrpc_seq_t call_ackr_first,
+		     rxrpc_seq_t prev_pkt, rxrpc_seq_t call_ackr_prev),
+
+	    TP_ARGS(debug_id, serial, first_soft_ack, call_ackr_first,
+		    prev_pkt, call_ackr_prev),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,	debug_id	)
+		    __field(rxrpc_serial_t,	serial		)
+		    __field(rxrpc_seq_t,	first_soft_ack)
+		    __field(rxrpc_seq_t,	call_ackr_first)
+		    __field(rxrpc_seq_t,	prev_pkt)
+		    __field(rxrpc_seq_t,	call_ackr_prev)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->debug_id		= debug_id;
+		    __entry->serial		= serial;
+		    __entry->first_soft_ack	= first_soft_ack;
+		    __entry->call_ackr_first	= call_ackr_first;
+		    __entry->prev_pkt		= prev_pkt;
+		    __entry->call_ackr_prev	= call_ackr_prev;
+			   ),
+
+	    TP_printk("c=%08x r=%08x %08x<%08x %08x<%08x",
+		      __entry->debug_id,
+		      __entry->serial,
+		      __entry->first_soft_ack,
+		      __entry->call_ackr_first,
+		      __entry->prev_pkt,
+		      __entry->call_ackr_prev)
+	    );
+
 #endif /* _TRACE_RXRPC_H */
 
 /* This part must be outside protection */
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index e438bfd3fdf5..2f22f082a66c 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -866,8 +866,12 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
 	if (before(first_soft_ack, call->ackr_first_seq) ||
-	    before(prev_pkt, call->ackr_prev_seq))
+	    before(prev_pkt, call->ackr_prev_seq)) {
+		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+					   first_soft_ack, call->ackr_first_seq,
+					   prev_pkt, call->ackr_prev_seq);
 		return;
+	}
 
 	buf.info.rxMTU = 0;
 	ioffset = offset + nr_acks + 3;
@@ -879,8 +883,12 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	/* Discard any out-of-order or duplicate ACKs (inside lock). */
 	if (before(first_soft_ack, call->ackr_first_seq) ||
-	    before(prev_pkt, call->ackr_prev_seq))
+	    before(prev_pkt, call->ackr_prev_seq)) {
+		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+					   first_soft_ack, call->ackr_first_seq,
+					   prev_pkt, call->ackr_prev_seq);
 		goto out;
+	}
 	call->acks_latest_ts = skb->tstamp;
 
 	call->ackr_first_seq = first_soft_ack;


