Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E221499342
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388480AbfHVMXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:23:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730804AbfHVMXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 08:23:44 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E6277F75C;
        Thu, 22 Aug 2019 12:23:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07FF660600;
        Thu, 22 Aug 2019 12:23:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 3/9] rxrpc: Use info in skbuff instead of reparsing a
 jumbo packet
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 22 Aug 2019 13:23:42 +0100
Message-ID: <156647662222.11061.5688053519089064346.stgit@warthog.procyon.org.uk>
In-Reply-To: <156647659913.11061.13764606104739742865.stgit@warthog.procyon.org.uk>
References: <156647659913.11061.13764606104739742865.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Thu, 22 Aug 2019 12:23:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the information now cached in the skbuff private data to avoid the need
to reparse a jumbo packet.  We can find all the subpackets by dead
reckoning, so it's only necessary to note how many there are, whether the
last one is flagged as LAST_PACKET and whether any have the REQUEST_ACK
flag set.

This is necessary as once recvmsg() can see the packet, it can start
modifying it, such as doing in-place decryption.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    3 -
 net/rxrpc/input.c       |  233 ++++++++++++++++++++++-------------------------
 net/rxrpc/recvmsg.c     |   41 +++++---
 3 files changed, 135 insertions(+), 142 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 87cff6c218b6..20d7907a5bc6 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -617,8 +617,7 @@ struct rxrpc_call {
 #define RXRPC_TX_ANNO_LAST	0x04
 #define RXRPC_TX_ANNO_RESENT	0x08
 
-#define RXRPC_RX_ANNO_JUMBO	0x3f		/* Jumbo subpacket number + 1 if not zero */
-#define RXRPC_RX_ANNO_JLAST	0x40		/* Set if last element of a jumbo packet */
+#define RXRPC_RX_ANNO_SUBPACKET	0x3f		/* Subpacket number in jumbogram */
 #define RXRPC_RX_ANNO_VERIFIED	0x80		/* Set if verified and decrypted */
 	rxrpc_seq_t		tx_hard_ack;	/* Dead slot in buffer; the first transmitted but
 						 * not hard-ACK'd packet follows this.
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index b24492e5e429..140cede77655 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -405,10 +405,10 @@ static bool rxrpc_validate_data(struct sk_buff *skb)
  * (that information is encoded in the ACK packet).
  */
 static void rxrpc_input_dup_data(struct rxrpc_call *call, rxrpc_seq_t seq,
-				 u8 annotation, bool *_jumbo_bad)
+				 bool is_jumbo, bool *_jumbo_bad)
 {
 	/* Discard normal packets that are duplicates. */
-	if (annotation == 0)
+	if (is_jumbo)
 		return;
 
 	/* Skip jumbo subpackets that are duplicates.  When we've had three or
@@ -429,19 +429,17 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	enum rxrpc_call_state state;
-	unsigned int offset = sizeof(struct rxrpc_wire_header);
-	unsigned int ix;
+	unsigned int j;
 	rxrpc_serial_t serial = sp->hdr.serial, ack_serial = 0;
-	rxrpc_seq_t seq0 = sp->hdr.seq, seq, hard_ack;
-	bool immediate_ack = false, jumbo_bad = false, queued;
-	u16 len;
-	u8 ack = 0, flags, jumbo_flags, annotation = 0;
+	rxrpc_seq_t seq0 = sp->hdr.seq, hard_ack;
+	bool immediate_ack = false, jumbo_bad = false;
+	u8 ack = 0;
 
 	_enter("{%u,%u},{%u,%u}",
-	       call->rx_hard_ack, call->rx_top, skb->len, seq);
+	       call->rx_hard_ack, call->rx_top, skb->len, seq0);
 
-	_proto("Rx DATA %%%u { #%u f=%02x }",
-	       sp->hdr.serial, seq0, sp->hdr.flags);
+	_proto("Rx DATA %%%u { #%u f=%02x n=%u }",
+	       sp->hdr.serial, seq0, sp->hdr.flags, sp->nr_subpackets);
 
 	state = READ_ONCE(call->state);
 	if (state >= RXRPC_CALL_COMPLETE) {
@@ -473,147 +471,136 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		goto unlock;
 
 	call->ackr_prev_seq = seq0;
-	seq = seq0;
-
 	hard_ack = READ_ONCE(call->rx_hard_ack);
-	if (after(seq, hard_ack + call->rx_winsize)) {
-		ack = RXRPC_ACK_EXCEEDS_WINDOW;
-		ack_serial = serial;
-		goto ack;
-	}
 
-	flags = sp->hdr.flags;
-	if (flags & RXRPC_JUMBO_PACKET) {
+	if (sp->nr_subpackets > 1) {
 		if (call->nr_jumbo_bad > 3) {
 			ack = RXRPC_ACK_NOSPACE;
 			ack_serial = serial;
 			goto ack;
 		}
-		annotation = 1;
 	}
 
-next_subpacket:
-	queued = false;
-	ix = seq & RXRPC_RXTX_BUFF_MASK;
-	len = skb->len;
-	if (flags & RXRPC_JUMBO_PACKET)
-		len = RXRPC_JUMBO_DATALEN;
-
-	if (flags & RXRPC_LAST_PACKET) {
-		if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
-		    seq != call->rx_top) {
-			rxrpc_proto_abort("LSN", call, seq);
-			goto unlock;
+	for (j = 0; j < sp->nr_subpackets; j++) {
+		rxrpc_serial_t serial = sp->hdr.serial + j;
+		rxrpc_seq_t seq = seq0 + j;
+		unsigned int ix = seq & RXRPC_RXTX_BUFF_MASK;
+		bool terminal = (j == sp->nr_subpackets - 1);
+		bool last = terminal && (sp->rx_flags & RXRPC_SKB_INCL_LAST);
+		u8 flags, annotation = j;
+
+		_proto("Rx DATA+%u %%%u { #%x t=%u l=%u }",
+		     j, serial, seq, terminal, last);
+
+		if (last) {
+			if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
+			    seq != call->rx_top) {
+				rxrpc_proto_abort("LSN", call, seq);
+				goto unlock;
+			}
+		} else {
+			if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
+			    after_eq(seq, call->rx_top)) {
+				rxrpc_proto_abort("LSA", call, seq);
+				goto unlock;
+			}
 		}
-	} else {
-		if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
-		    after_eq(seq, call->rx_top)) {
-			rxrpc_proto_abort("LSA", call, seq);
-			goto unlock;
+
+		flags = 0;
+		if (last)
+			flags |= RXRPC_LAST_PACKET;
+		if (!terminal)
+			flags |= RXRPC_JUMBO_PACKET;
+		if (test_bit(j, sp->rx_req_ack))
+			flags |= RXRPC_REQUEST_ACK;
+		trace_rxrpc_rx_data(call->debug_id, seq, serial, flags, annotation);
+
+		if (before_eq(seq, hard_ack)) {
+			ack = RXRPC_ACK_DUPLICATE;
+			ack_serial = serial;
+			continue;
 		}
-	}
 
-	trace_rxrpc_rx_data(call->debug_id, seq, serial, flags, annotation);
-	if (before_eq(seq, hard_ack)) {
-		ack = RXRPC_ACK_DUPLICATE;
-		ack_serial = serial;
-		goto skip;
-	}
+		if (call->rxtx_buffer[ix]) {
+			rxrpc_input_dup_data(call, seq, sp->nr_subpackets > 1,
+					     &jumbo_bad);
+			if (ack != RXRPC_ACK_DUPLICATE) {
+				ack = RXRPC_ACK_DUPLICATE;
+				ack_serial = serial;
+			}
+			immediate_ack = true;
+			continue;
+		}
 
-	if (flags & RXRPC_REQUEST_ACK && !ack) {
-		ack = RXRPC_ACK_REQUESTED;
-		ack_serial = serial;
-	}
+		if (after(seq, hard_ack + call->rx_winsize)) {
+			ack = RXRPC_ACK_EXCEEDS_WINDOW;
+			ack_serial = serial;
+			if (flags & RXRPC_JUMBO_PACKET) {
+				if (!jumbo_bad) {
+					call->nr_jumbo_bad++;
+					jumbo_bad = true;
+				}
+			}
 
-	if (call->rxtx_buffer[ix]) {
-		rxrpc_input_dup_data(call, seq, annotation, &jumbo_bad);
-		if (ack != RXRPC_ACK_DUPLICATE) {
-			ack = RXRPC_ACK_DUPLICATE;
+			goto ack;
+		}
+
+		if (flags & RXRPC_REQUEST_ACK && !ack) {
+			ack = RXRPC_ACK_REQUESTED;
 			ack_serial = serial;
 		}
-		immediate_ack = true;
-		goto skip;
-	}
 
-	/* Queue the packet.  We use a couple of memory barriers here as need
-	 * to make sure that rx_top is perceived to be set after the buffer
-	 * pointer and that the buffer pointer is set after the annotation and
-	 * the skb data.
-	 *
-	 * Barriers against rxrpc_recvmsg_data() and rxrpc_rotate_rx_window()
-	 * and also rxrpc_fill_out_ack().
-	 */
-	if (flags & RXRPC_JUMBO_PACKET) {
-		rxrpc_get_skb(skb, rxrpc_skb_rx_got);
-		if (skb_copy_bits(skb, offset, &jumbo_flags, 1) < 0) {
-			rxrpc_proto_abort("XJF", call, seq);
-			goto unlock;
+		/* Queue the packet.  We use a couple of memory barriers here as need
+		 * to make sure that rx_top is perceived to be set after the buffer
+		 * pointer and that the buffer pointer is set after the annotation and
+		 * the skb data.
+		 *
+		 * Barriers against rxrpc_recvmsg_data() and rxrpc_rotate_rx_window()
+		 * and also rxrpc_fill_out_ack().
+		 */
+		if (!terminal)
+			rxrpc_get_skb(skb, rxrpc_skb_rx_got);
+		call->rxtx_annotations[ix] = annotation;
+		smp_wmb();
+		call->rxtx_buffer[ix] = skb;
+		if (after(seq, call->rx_top)) {
+			smp_store_release(&call->rx_top, seq);
+		} else if (before(seq, call->rx_top)) {
+			/* Send an immediate ACK if we fill in a hole */
+			if (!ack) {
+				ack = RXRPC_ACK_DELAY;
+				ack_serial = serial;
+			}
+			immediate_ack = true;
 		}
-	}
-	call->rxtx_annotations[ix] = annotation;
-	smp_wmb();
-	call->rxtx_buffer[ix] = skb;
-	if (after(seq, call->rx_top)) {
-		smp_store_release(&call->rx_top, seq);
-		if (!(flags & RXRPC_JUMBO_PACKET)) {
+
+		if (terminal) {
 			/* From this point on, we're not allowed to touch the
 			 * packet any longer as its ref now belongs to the Rx
 			 * ring.
 			 */
 			skb = NULL;
 		}
-	} else if (before(seq, call->rx_top)) {
-		/* Send an immediate ACK if we fill in a hole */
-		if (!ack) {
-			ack = RXRPC_ACK_DELAY;
-			ack_serial = serial;
-		}
-		immediate_ack = true;
-	}
-	if (flags & RXRPC_LAST_PACKET) {
-		set_bit(RXRPC_CALL_RX_LAST, &call->flags);
-		trace_rxrpc_receive(call, rxrpc_receive_queue_last, serial, seq);
-	} else {
-		trace_rxrpc_receive(call, rxrpc_receive_queue, serial, seq);
-	}
-	queued = true;
 
-	if (after_eq(seq, call->rx_expect_next)) {
-		if (after(seq, call->rx_expect_next)) {
-			_net("OOS %u > %u", seq, call->rx_expect_next);
-			ack = RXRPC_ACK_OUT_OF_SEQUENCE;
-			ack_serial = serial;
+		if (last) {
+			set_bit(RXRPC_CALL_RX_LAST, &call->flags);
+			if (!ack) {
+				ack = RXRPC_ACK_DELAY;
+				ack_serial = serial;
+			}
+			trace_rxrpc_receive(call, rxrpc_receive_queue_last, serial, seq);
+		} else {
+			trace_rxrpc_receive(call, rxrpc_receive_queue, serial, seq);
 		}
-		call->rx_expect_next = seq + 1;
-	}
 
-skip:
-	offset += len;
-	if (flags & RXRPC_JUMBO_PACKET) {
-		flags = jumbo_flags;
-		offset += sizeof(struct rxrpc_jumbo_header);
-		seq++;
-		serial++;
-		annotation++;
-		if (flags & RXRPC_JUMBO_PACKET)
-			annotation |= RXRPC_RX_ANNO_JLAST;
-		if (after(seq, hard_ack + call->rx_winsize)) {
-			ack = RXRPC_ACK_EXCEEDS_WINDOW;
-			ack_serial = serial;
-			if (!jumbo_bad) {
-				call->nr_jumbo_bad++;
-				jumbo_bad = true;
+		if (after_eq(seq, call->rx_expect_next)) {
+			if (after(seq, call->rx_expect_next)) {
+				_net("OOS %u > %u", seq, call->rx_expect_next);
+				ack = RXRPC_ACK_OUT_OF_SEQUENCE;
+				ack_serial = serial;
 			}
-			goto ack;
+			call->rx_expect_next = seq + 1;
 		}
-
-		_proto("Rx DATA Jumbo %%%u", serial);
-		goto next_subpacket;
-	}
-
-	if (queued && flags & RXRPC_LAST_PACKET && !ack) {
-		ack = RXRPC_ACK_DELAY;
-		ack_serial = serial;
 	}
 
 ack:
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 9a7e1bc9791d..e49eacfaf4d6 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -177,7 +177,8 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	struct sk_buff *skb;
 	rxrpc_serial_t serial;
 	rxrpc_seq_t hard_ack, top;
-	u8 flags;
+	bool last = false;
+	u8 subpacket;
 	int ix;
 
 	_enter("%d", call->debug_id);
@@ -191,10 +192,13 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	skb = call->rxtx_buffer[ix];
 	rxrpc_see_skb(skb, rxrpc_skb_rx_rotated);
 	sp = rxrpc_skb(skb);
-	flags = sp->hdr.flags;
-	serial = sp->hdr.serial;
-	if (call->rxtx_annotations[ix] & RXRPC_RX_ANNO_JUMBO)
-		serial += (call->rxtx_annotations[ix] & RXRPC_RX_ANNO_JUMBO) - 1;
+
+	subpacket = call->rxtx_annotations[ix] & RXRPC_RX_ANNO_SUBPACKET;
+	serial = sp->hdr.serial + subpacket;
+
+	if (subpacket == sp->nr_subpackets - 1 &&
+	    sp->rx_flags & RXRPC_SKB_INCL_LAST)
+		last = true;
 
 	call->rxtx_buffer[ix] = NULL;
 	call->rxtx_annotations[ix] = 0;
@@ -203,9 +207,8 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 
 	rxrpc_free_skb(skb, rxrpc_skb_rx_freed);
 
-	_debug("%u,%u,%02x", hard_ack, top, flags);
 	trace_rxrpc_receive(call, rxrpc_receive_rotate, serial, hard_ack);
-	if (flags & RXRPC_LAST_PACKET) {
+	if (last) {
 		rxrpc_end_rx_phase(call, serial);
 	} else {
 		/* Check to see if there's an ACK that needs sending. */
@@ -233,18 +236,19 @@ static int rxrpc_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	rxrpc_seq_t seq = sp->hdr.seq;
 	u16 cksum = sp->hdr.cksum;
+	u8 subpacket = annotation & RXRPC_RX_ANNO_SUBPACKET;
 
 	_enter("");
 
 	/* For all but the head jumbo subpacket, the security checksum is in a
 	 * jumbo header immediately prior to the data.
 	 */
-	if ((annotation & RXRPC_RX_ANNO_JUMBO) > 1) {
+	if (subpacket > 0) {
 		__be16 tmp;
 		if (skb_copy_bits(skb, offset - 2, &tmp, 2) < 0)
 			BUG();
 		cksum = ntohs(tmp);
-		seq += (annotation & RXRPC_RX_ANNO_JUMBO) - 1;
+		seq += subpacket;
 	}
 
 	return call->conn->security->verify_packet(call, skb, offset, len,
@@ -265,19 +269,18 @@ static int rxrpc_locate_data(struct rxrpc_call *call, struct sk_buff *skb,
 			     u8 *_annotation,
 			     unsigned int *_offset, unsigned int *_len)
 {
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	unsigned int offset = sizeof(struct rxrpc_wire_header);
 	unsigned int len;
 	int ret;
 	u8 annotation = *_annotation;
+	u8 subpacket = annotation & RXRPC_RX_ANNO_SUBPACKET;
 
 	/* Locate the subpacket */
+	offset += subpacket * RXRPC_JUMBO_SUBPKTLEN;
 	len = skb->len - offset;
-	if ((annotation & RXRPC_RX_ANNO_JUMBO) > 0) {
-		offset += (((annotation & RXRPC_RX_ANNO_JUMBO) - 1) *
-			   RXRPC_JUMBO_SUBPKTLEN);
-		len = (annotation & RXRPC_RX_ANNO_JLAST) ?
-			skb->len - offset : RXRPC_JUMBO_SUBPKTLEN;
-	}
+	if (subpacket < sp->nr_subpackets - 1)
+		len = RXRPC_JUMBO_DATALEN;
 
 	if (!(annotation & RXRPC_RX_ANNO_VERIFIED)) {
 		ret = rxrpc_verify_packet(call, skb, annotation, offset, len);
@@ -303,6 +306,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 {
 	struct rxrpc_skb_priv *sp;
 	struct sk_buff *skb;
+	rxrpc_serial_t serial;
 	rxrpc_seq_t hard_ack, top, seq;
 	size_t remain;
 	bool last;
@@ -339,9 +343,12 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 		rxrpc_see_skb(skb, rxrpc_skb_rx_seen);
 		sp = rxrpc_skb(skb);
 
-		if (!(flags & MSG_PEEK))
+		if (!(flags & MSG_PEEK)) {
+			serial = sp->hdr.serial;
+			serial += call->rxtx_annotations[ix] & RXRPC_RX_ANNO_SUBPACKET;
 			trace_rxrpc_receive(call, rxrpc_receive_front,
-					    sp->hdr.serial, seq);
+					    serial, seq);
+		}
 
 		if (msg)
 			sock_recv_timestamp(msg, sock->sk, skb);

