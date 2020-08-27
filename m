Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A713254848
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgH0PEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:04:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39295 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726924AbgH0PEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 11:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598540638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I6kX0oyXemx/xr6wdJryauq9QXkP9zKyeSXxyISE2yI=;
        b=CUDRoKIgRkwFEcXdAfwH2K94fE7NfM5jcdkJfUg41SGZ82pnGiotPxTxjsdynA+IBN4kyu
        rhZXtCIjNXl0WpanwfKaAvjy2361tmXiLEGC/IUPQdI9KakS1Mfv3eqfNpaJnqNXIe/hFg
        rjmNngoq/ZJjGUDueVfmDCjiO3G2i4Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-4osYSCdHMCO_6WU7PQIQOQ-1; Thu, 27 Aug 2020 11:03:54 -0400
X-MC-Unique: 4osYSCdHMCO_6WU7PQIQOQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15DB11054F91;
        Thu, 27 Aug 2020 15:03:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-127.rdu2.redhat.com [10.10.120.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35F055D9E8;
        Thu, 27 Aug 2020 15:03:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/7] rxrpc: Keep the ACK serial in a var in
 rxrpc_input_ack()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 27 Aug 2020 16:03:40 +0100
Message-ID: <159854062042.1382667.9932448813528186182.stgit@warthog.procyon.org.uk>
In-Reply-To: <159854061331.1382667.9693163318506702951.stgit@warthog.procyon.org.uk>
References: <159854061331.1382667.9693163318506702951.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep the ACK serial number in a variable in rxrpc_input_ack() as it's used
frequently.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/input.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 767579328a06..a7699e56eac8 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -843,7 +843,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		struct rxrpc_ackinfo info;
 		u8 acks[RXRPC_MAXACKS];
 	} buf;
-	rxrpc_serial_t acked_serial;
+	rxrpc_serial_t ack_serial, acked_serial;
 	rxrpc_seq_t first_soft_ack, hard_ack, prev_pkt;
 	int nr_acks, offset, ioffset;
 
@@ -856,6 +856,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 	offset += sizeof(buf.ack);
 
+	ack_serial = sp->hdr.serial;
 	acked_serial = ntohl(buf.ack.serial);
 	first_soft_ack = ntohl(buf.ack.firstPacket);
 	prev_pkt = ntohl(buf.ack.previousPacket);
@@ -864,31 +865,31 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	summary.ack_reason = (buf.ack.reason < RXRPC_ACK__INVALID ?
 			      buf.ack.reason : RXRPC_ACK__INVALID);
 
-	trace_rxrpc_rx_ack(call, sp->hdr.serial, acked_serial,
+	trace_rxrpc_rx_ack(call, ack_serial, acked_serial,
 			   first_soft_ack, prev_pkt,
 			   summary.ack_reason, nr_acks);
 
 	if (buf.ack.reason == RXRPC_ACK_PING_RESPONSE)
 		rxrpc_input_ping_response(call, skb->tstamp, acked_serial,
-					  sp->hdr.serial);
+					  ack_serial);
 	if (buf.ack.reason == RXRPC_ACK_REQUESTED)
 		rxrpc_input_requested_ack(call, skb->tstamp, acked_serial,
-					  sp->hdr.serial);
+					  ack_serial);
 
 	if (buf.ack.reason == RXRPC_ACK_PING) {
-		_proto("Rx ACK %%%u PING Request", sp->hdr.serial);
+		_proto("Rx ACK %%%u PING Request", ack_serial);
 		rxrpc_propose_ACK(call, RXRPC_ACK_PING_RESPONSE,
-				  sp->hdr.serial, true, true,
+				  ack_serial, true, true,
 				  rxrpc_propose_ack_respond_to_ping);
 	} else if (sp->hdr.flags & RXRPC_REQUEST_ACK) {
 		rxrpc_propose_ACK(call, RXRPC_ACK_REQUESTED,
-				  sp->hdr.serial, true, true,
+				  ack_serial, true, true,
 				  rxrpc_propose_ack_respond_to_ack);
 	}
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
 	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
-		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
 					   first_soft_ack, call->ackr_first_seq,
 					   prev_pkt, call->ackr_prev_seq);
 		return;
@@ -904,7 +905,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 
 	/* Discard any out-of-order or duplicate ACKs (inside lock). */
 	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
-		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
+		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
 					   first_soft_ack, call->ackr_first_seq,
 					   prev_pkt, call->ackr_prev_seq);
 		goto out;
@@ -964,7 +965,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	    RXRPC_TX_ANNO_LAST &&
 	    summary.nr_acks == call->tx_top - hard_ack &&
 	    rxrpc_is_client_call(call))
-		rxrpc_propose_ACK(call, RXRPC_ACK_PING, sp->hdr.serial,
+		rxrpc_propose_ACK(call, RXRPC_ACK_PING, ack_serial,
 				  false, true,
 				  rxrpc_propose_ack_ping_for_lost_reply);
 


