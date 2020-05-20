Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5341DC2D1
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 01:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgETXWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 19:22:19 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43461 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728792AbgETXWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 19:22:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590016929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+Mv5i8MSKtHCvpHZZreAZlo0OINtZUjUsAoIOF5LUM=;
        b=HWG2QGdqswbdzdLP5kTYtPLh5IWC61pf1IVZR1MYlTVtp4XNotaL0NB0blrf/5x+X7tMju
        M0gEymchf0DFrGVyawO48nQolTvR432oTU5ySEZ5qG0cFbBiULgvk8UqeMXCi3HitiwTwF
        E+hc/ZJZL2L4iwkrLNKV9y1QXofLRug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-8fUOUOb2Oyi-IJNDdaVw5w-1; Wed, 20 May 2020 19:22:06 -0400
X-MC-Unique: 8fUOUOb2Oyi-IJNDdaVw5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BB54835B40;
        Wed, 20 May 2020 23:22:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18D1D6EA26;
        Wed, 20 May 2020 23:22:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 3/3] rxrpc: Fix ack discard
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 May 2020 00:22:03 +0100
Message-ID: <159001692327.18663.7422193729175092836.stgit@warthog.procyon.org.uk>
In-Reply-To: <159001690181.18663.663730118645460940.stgit@warthog.procyon.org.uk>
References: <159001690181.18663.663730118645460940.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.22
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Rx protocol has a "previousPacket" field in it that is not handled in
the same way by all protocol implementations.  Sometimes it contains the
serial number of the last DATA packet received, sometimes the sequence
number of the last DATA packet received and sometimes the highest sequence
number so far received.

AF_RXRPC is using this to weed out ACKs that are out of date (it's possible
for ACK packets to get reordered on the wire), but this does not work with
OpenAFS which will just stick the sequence number of the last packet seen
into previousPacket.

The issue being seen is that big AFS FS.StoreData RPC (eg. of ~256MiB) are
timing out when partly sent.  A trace was captured, with an additional
tracepoint to show ACKs being discarded in rxrpc_input_ack().  Here's an
excerpt showing the problem.

 52873.203230: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 0002449c q=00024499 fl=09

A DATA packet with sequence number 00024499 has been transmitted (the "q="
field).

 ...
 52873.243296: rxrpc_rx_ack: c=000004ae 00012a2b DLY r=00024499 f=00024497 p=00024496 n=0
 52873.243376: rxrpc_rx_ack: c=000004ae 00012a2c IDL r=0002449b f=00024499 p=00024498 n=0
 52873.243383: rxrpc_rx_ack: c=000004ae 00012a2d OOS r=0002449d f=00024499 p=0002449a n=2

The Out-Of-Sequence ACK indicates that the server didn't see DATA sequence
number 00024499, but did see seq 0002449a (previousPacket, shown as "p=",
skipped the number, but firstPacket, "f=", which shows the bottom of the
window is set at that point).

 52873.252663: rxrpc_retransmit: c=000004ae q=24499 a=02 xp=14581537
 52873.252664: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 000244bc q=00024499 fl=0b *RETRANS*

The packet has been retransmitted.  Retransmission recurs until the peer
says it got the packet.

 52873.271013: rxrpc_rx_ack: c=000004ae 00012a31 OOS r=000244a1 f=00024499 p=0002449e n=6

More OOS ACKs indicate that the other packets that are already in the
transmission pipeline are being received.  The specific-ACK list is up to 6
ACKs and NAKs.

 ...
 52873.284792: rxrpc_rx_ack: c=000004ae 00012a49 OOS r=000244b9 f=00024499 p=000244b6 n=30
 52873.284802: rxrpc_retransmit: c=000004ae q=24499 a=0a xp=63505500
 52873.284804: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 000244c2 q=00024499 fl=0b *RETRANS*
 52873.287468: rxrpc_rx_ack: c=000004ae 00012a4a OOS r=000244ba f=00024499 p=000244b7 n=31
 52873.287478: rxrpc_rx_ack: c=000004ae 00012a4b OOS r=000244bb f=00024499 p=000244b8 n=32

At this point, the server's receive window is full (n=32) with presumably 1
NAK'd packet and 31 ACK'd packets.  We can't transmit any more packets.

 52873.287488: rxrpc_retransmit: c=000004ae q=24499 a=0a xp=61327980
 52873.287489: rxrpc_tx_data: c=000004ae DATA ed1a3584:00000002 000244c3 q=00024499 fl=0b *RETRANS*
 52873.293850: rxrpc_rx_ack: c=000004ae 00012a4c DLY r=000244bc f=000244a0 p=00024499 n=25

And now we've received an ACK indicating that a DATA retransmission was
received.  7 packets have been processed (the occupied part of the window
moved, as indicated by f= and n=).

 52873.293853: rxrpc_rx_discard_ack: c=000004ae r=00012a4c 000244a0<00024499 00024499<000244b8

However, the DLY ACK gets discarded because its previousPacket has gone
backwards (from p=000244b8, in the ACK at 52873.287478 to p=00024499 in the
ACK at 52873.293850).

We then end up in a continuous cycle of retransmit/discard.  kafs fails to
update its window because it's discarding the ACKs and can't transmit an
extra packet that would clear the issue because the window is full.
OpenAFS doesn't change the previousPacket value in the ACKs because no new
DATA packets are received with a different previousPacket number.

Fix this by altering the discard check to only discard an ACK based on
previousPacket if there was no advance in the firstPacket.  This allows us
to transmit a new packet which will cause previousPacket to advance in the
next ACK.

The check, however, needs to allow for the possibility that previousPacket
may actually have had the serial number placed in it instead - in which
case it will go outside the window and we should ignore it.

Fixes: 1a2391c30c0b ("rxrpc: Fix detection of out of order acks")
Reported-by: Dave Botsch <botsch@cnf.cornell.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/input.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 2f22f082a66c..3be4177baf70 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -802,6 +802,30 @@ static void rxrpc_input_soft_acks(struct rxrpc_call *call, u8 *acks,
 	}
 }
 
+/*
+ * Return true if the ACK is valid - ie. it doesn't appear to have regressed
+ * with respect to the ack state conveyed by preceding ACKs.
+ */
+static bool rxrpc_is_ack_valid(struct rxrpc_call *call,
+			       rxrpc_seq_t first_pkt, rxrpc_seq_t prev_pkt)
+{
+	rxrpc_seq_t base = READ_ONCE(call->ackr_first_seq);
+
+	if (after(first_pkt, base))
+		return true; /* The window advanced */
+
+	if (before(first_pkt, base))
+		return false; /* firstPacket regressed */
+
+	if (after_eq(prev_pkt, call->ackr_prev_seq))
+		return true; /* previousPacket hasn't regressed. */
+
+	/* Some rx implementations put a serial number in previousPacket. */
+	if (after_eq(prev_pkt, base + call->tx_winsize))
+		return false;
+	return true;
+}
+
 /*
  * Process an ACK packet.
  *
@@ -865,8 +889,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
-	if (before(first_soft_ack, call->ackr_first_seq) ||
-	    before(prev_pkt, call->ackr_prev_seq)) {
+	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
 		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
 					   first_soft_ack, call->ackr_first_seq,
 					   prev_pkt, call->ackr_prev_seq);
@@ -882,8 +905,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	spin_lock(&call->input_lock);
 
 	/* Discard any out-of-order or duplicate ACKs (inside lock). */
-	if (before(first_soft_ack, call->ackr_first_seq) ||
-	    before(prev_pkt, call->ackr_prev_seq)) {
+	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
 		trace_rxrpc_rx_discard_ack(call->debug_id, sp->hdr.serial,
 					   first_soft_ack, call->ackr_first_seq,
 					   prev_pkt, call->ackr_prev_seq);


