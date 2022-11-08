Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC17621F20
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiKHWWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiKHWVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:21:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C5364A28
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TVhyPEmAEzWCRPlec/juuMZN4kYWSGIx7dGRATpkDmU=;
        b=egcaJVIPWx5pAdmIptYi3BedqoLKE5Hz+SrQkyqcDAR6wXRU3A/rWkosApdIKMm5oWkY6j
        UCWfkVTqqWxAiikjY/TWg49sHiDjUwwgUGJcL7LPuw4rZ1QdiNp1yRC451lRdPeVxpF1er
        EYVd7PkTvDLhmHhdNAnPZXR9qyVWL14=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-ApbRr9OLOr62uQwWzNN-bg-1; Tue, 08 Nov 2022 17:19:55 -0500
X-MC-Unique: ApbRr9OLOr62uQwWzNN-bg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AA14101A52A;
        Tue,  8 Nov 2022 22:19:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5F1F2166B29;
        Tue,  8 Nov 2022 22:19:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 19/26] rxrpc: Clone received jumbo subpackets and
 queue separately
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:19:54 +0000
Message-ID: <166794599406.2389296.1963416007058584695.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split up received jumbo packets into separate skbuffs by cloning the
original skbuff for each subpacket and setting the offset and length of the
data in that subpacket in the skbuff's private data.  The subpackets are
then placed on the recvmsg queue separately.  The security class then gets
to revise the offset and length to remove its metadata.

If we fail to clone a packet, we just drop it and let the peer resend it.
The original packet gets used for the final subpacket.

This should make it easier to handle parallel decryption of the subpackets.
It also simplifies the handling of lost or misordered packets in the
queuing/buffering loop as the possibility of overlapping jumbo packets no
longer needs to be considered.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   12 +
 net/rxrpc/ar-internal.h      |   32 +--
 net/rxrpc/input.c            |  401 +++++++++++++++++++-----------------------
 net/rxrpc/insecure.c         |   13 -
 net/rxrpc/output.c           |    2 
 net/rxrpc/protocol.h         |    2 
 net/rxrpc/recvmsg.c          |  104 +----------
 net/rxrpc/rxkad.c            |   96 +++-------
 8 files changed, 245 insertions(+), 417 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 84464b29e54a..03a984e661bc 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -18,6 +18,7 @@
  */
 #define rxrpc_skb_traces \
 	EM(rxrpc_skb_cleaned,			"CLN") \
+	EM(rxrpc_skb_cloned_jumbo,		"CLJ") \
 	EM(rxrpc_skb_freed,			"FRE") \
 	EM(rxrpc_skb_got,			"GOT") \
 	EM(rxrpc_skb_lost,			"*L*") \
@@ -630,16 +631,15 @@ TRACE_EVENT(rxrpc_transmit,
 
 TRACE_EVENT(rxrpc_rx_data,
 	    TP_PROTO(unsigned int call, rxrpc_seq_t seq,
-		     rxrpc_serial_t serial, u8 flags, u8 anno),
+		     rxrpc_serial_t serial, u8 flags),
 
-	    TP_ARGS(call, seq, serial, flags, anno),
+	    TP_ARGS(call, seq, serial, flags),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
 		    __field(rxrpc_seq_t,		seq		)
 		    __field(rxrpc_serial_t,		serial		)
 		    __field(u8,				flags		)
-		    __field(u8,				anno		)
 			     ),
 
 	    TP_fast_assign(
@@ -647,15 +647,13 @@ TRACE_EVENT(rxrpc_rx_data,
 		    __entry->seq = seq;
 		    __entry->serial = serial;
 		    __entry->flags = flags;
-		    __entry->anno = anno;
 			   ),
 
-	    TP_printk("c=%08x DATA %08x q=%08x fl=%02x a=%02x",
+	    TP_printk("c=%08x DATA %08x q=%08x fl=%02x",
 		      __entry->call,
 		      __entry->serial,
 		      __entry->seq,
-		      __entry->flags,
-		      __entry->anno)
+		      __entry->flags)
 	    );
 
 TRACE_EVENT(rxrpc_rx_ack,
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 5a81545a58d5..e93ed18816b1 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -195,19 +195,14 @@ struct rxrpc_host_header {
  * - max 48 bytes (struct sk_buff::cb)
  */
 struct rxrpc_skb_priv {
-	atomic_t	nr_ring_pins;		/* Number of rxtx ring pins */
-	u8		nr_subpackets;		/* Number of subpackets */
-	u8		rx_flags;		/* Received packet flags */
-#define RXRPC_SKB_INCL_LAST	0x01		/* - Includes last packet */
-	union {
-		int		remain;		/* amount of space remaining for next write */
-
-		/* List of requested ACKs on subpackets */
-		unsigned long	rx_req_ack[(RXRPC_MAX_NR_JUMBO + BITS_PER_LONG - 1) /
-					   BITS_PER_LONG];
-	};
-
-	struct rxrpc_host_header hdr;		/* RxRPC packet header from this packet */
+	u16		remain;
+	u16		offset;		/* Offset of data */
+	u16		len;		/* Length of data */
+	u8		rx_flags;	/* Received packet flags */
+	u8		flags;
+#define RXRPC_RX_VERIFIED	0x01
+
+	struct rxrpc_host_header hdr;	/* RxRPC packet header from this packet */
 };
 
 #define rxrpc_skb(__skb) ((struct rxrpc_skb_priv *) &(__skb)->cb)
@@ -252,16 +247,11 @@ struct rxrpc_security {
 	int (*secure_packet)(struct rxrpc_call *, struct sk_buff *, size_t);
 
 	/* verify the security on a received packet */
-	int (*verify_packet)(struct rxrpc_call *, struct sk_buff *,
-			     unsigned int, unsigned int, rxrpc_seq_t, u16);
+	int (*verify_packet)(struct rxrpc_call *, struct sk_buff *);
 
 	/* Free crypto request on a call */
 	void (*free_call_crypto)(struct rxrpc_call *);
 
-	/* Locate the data in a received packet that has been verified. */
-	void (*locate_data)(struct rxrpc_call *, struct sk_buff *,
-			    unsigned int *, unsigned int *);
-
 	/* issue a challenge */
 	int (*issue_challenge)(struct rxrpc_connection *);
 
@@ -628,7 +618,6 @@ struct rxrpc_call {
 	int			debug_id;	/* debug ID for printks */
 	unsigned short		rx_pkt_offset;	/* Current recvmsg packet offset */
 	unsigned short		rx_pkt_len;	/* Current recvmsg packet len */
-	bool			rx_pkt_last;	/* Current recvmsg packet is last */
 
 	/* Rx/Tx circular buffer, depending on phase.
 	 *
@@ -652,8 +641,6 @@ struct rxrpc_call {
 #define RXRPC_TX_ANNO_LAST	0x04
 #define RXRPC_TX_ANNO_RESENT	0x08
 
-#define RXRPC_RX_ANNO_SUBPACKET	0x3f		/* Subpacket number in jumbogram */
-#define RXRPC_RX_ANNO_VERIFIED	0x80		/* Set if verified and decrypted */
 	rxrpc_seq_t		tx_hard_ack;	/* Dead slot in buffer; the first transmitted but
 						 * not hard-ACK'd packet follows this.
 						 */
@@ -681,7 +668,6 @@ struct rxrpc_call {
 	rxrpc_serial_t		rx_serial;	/* Highest serial received for this call */
 	u8			rx_winsize;	/* Size of Rx window */
 	u8			tx_winsize;	/* Maximum size of Tx window */
-	u8			nr_jumbo_bad;	/* Number of jumbo dups/exceeds-windows */
 
 	spinlock_t		input_lock;	/* Lock for packet input to this call */
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 4df1bdc4de6c..0e7545ed0128 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -313,78 +313,178 @@ static bool rxrpc_receiving_reply(struct rxrpc_call *call)
 }
 
 /*
- * Scan a data packet to validate its structure and to work out how many
- * subpackets it contains.
- *
- * A jumbo packet is a collection of consecutive packets glued together with
- * little headers between that indicate how to change the initial header for
- * each subpacket.
- *
- * RXRPC_JUMBO_PACKET must be set on all but the last subpacket - and all but
- * the last are RXRPC_JUMBO_DATALEN in size.  The last subpacket may be of any
- * size.
+ * Process a DATA packet, adding the packet to the Rx ring.  The caller's
+ * packet ref must be passed on or discarded.
  */
-static bool rxrpc_validate_data(struct sk_buff *skb)
+static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	unsigned int offset = sizeof(struct rxrpc_wire_header);
-	unsigned int len = skb->len;
-	u8 flags = sp->hdr.flags;
+	rxrpc_serial_t serial = sp->hdr.serial;
+	rxrpc_seq_t seq = sp->hdr.seq, hard_ack;
+	unsigned int ix = seq & RXRPC_RXTX_BUFF_MASK;
+	bool last = sp->hdr.flags & RXRPC_LAST_PACKET;
+	bool acked = false;
 
-	for (;;) {
-		if (flags & RXRPC_REQUEST_ACK)
-			__set_bit(sp->nr_subpackets, sp->rx_req_ack);
-		sp->nr_subpackets++;
+	rxrpc_inc_stat(call->rxnet, stat_rx_data);
+	if (sp->hdr.flags & RXRPC_REQUEST_ACK)
+		rxrpc_inc_stat(call->rxnet, stat_rx_data_reqack);
+	if (sp->hdr.flags & RXRPC_JUMBO_PACKET)
+		rxrpc_inc_stat(call->rxnet, stat_rx_data_jumbo);
 
-		if (!(flags & RXRPC_JUMBO_PACKET))
-			break;
+	hard_ack = READ_ONCE(call->rx_hard_ack);
 
-		if (len - offset < RXRPC_JUMBO_SUBPKTLEN)
-			goto protocol_error;
-		if (flags & RXRPC_LAST_PACKET)
-			goto protocol_error;
-		offset += RXRPC_JUMBO_DATALEN;
-		if (skb_copy_bits(skb, offset, &flags, 1) < 0)
-			goto protocol_error;
-		offset += sizeof(struct rxrpc_jumbo_header);
+	_proto("Rx DATA %%%u { #%x l=%u }", serial, seq, last);
+
+	if (last) {
+		if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
+		    seq != call->rx_top) {
+			rxrpc_proto_abort("LSN", call, seq);
+			goto out;
+		}
+	} else {
+		if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
+		    after_eq(seq, call->rx_top)) {
+			rxrpc_proto_abort("LSA", call, seq);
+			goto out;
+		}
 	}
 
-	if (flags & RXRPC_LAST_PACKET)
-		sp->rx_flags |= RXRPC_SKB_INCL_LAST;
-	return true;
+	trace_rxrpc_rx_data(call->debug_id, seq, serial, sp->hdr.flags);
 
-protocol_error:
-	return false;
+	if (before_eq(seq, hard_ack)) {
+		rxrpc_send_ACK(call, RXRPC_ACK_DUPLICATE, serial,
+			       rxrpc_propose_ack_input_data);
+		goto out;
+	}
+
+	if (call->rxtx_buffer[ix]) {
+		rxrpc_send_ACK(call, RXRPC_ACK_DUPLICATE, serial,
+			       rxrpc_propose_ack_input_data);
+		goto out;
+	}
+
+	if (after(seq, hard_ack + call->rx_winsize)) {
+		rxrpc_send_ACK(call, RXRPC_ACK_EXCEEDS_WINDOW, serial,
+			       rxrpc_propose_ack_input_data);
+		goto out;
+	}
+
+	if (sp->hdr.flags & RXRPC_REQUEST_ACK) {
+		rxrpc_send_ACK(call, RXRPC_ACK_REQUESTED, serial,
+			       rxrpc_propose_ack_input_data);
+		acked = true;
+	}
+
+	if (after(seq, call->ackr_highest_seq))
+		call->ackr_highest_seq = seq;
+
+	/* Queue the packet.  We use a couple of memory barriers here as need
+	 * to make sure that rx_top is perceived to be set after the buffer
+	 * pointer and that the buffer pointer is set after the annotation and
+	 * the skb data.
+	 *
+	 * Barriers against rxrpc_recvmsg_data() and rxrpc_rotate_rx_window()
+	 * and also rxrpc_fill_out_ack().
+	 */
+	call->rxtx_annotations[ix] = 1;
+	smp_wmb();
+	call->rxtx_buffer[ix] = skb;
+	if (after(seq, call->rx_top)) {
+		smp_store_release(&call->rx_top, seq);
+	} else if (before(seq, call->rx_top)) {
+		/* Send an immediate ACK if we fill in a hole */
+		if (!acked) {
+			rxrpc_send_ACK(call, RXRPC_ACK_DELAY, serial,
+				       rxrpc_propose_ack_input_data_hole);
+			acked = true;
+		}
+	}
+
+	/* From this point on, we're not allowed to touch the packet any longer
+	 * as its ref now belongs to the Rx ring.
+	 */
+	skb = NULL;
+	sp = NULL;
+
+	if (last) {
+		set_bit(RXRPC_CALL_RX_LAST, &call->flags);
+		trace_rxrpc_receive(call, rxrpc_receive_queue_last, serial, seq);
+	} else {
+		trace_rxrpc_receive(call, rxrpc_receive_queue, serial, seq);
+	}
+
+	if (after_eq(seq, call->rx_expect_next)) {
+		if (after(seq, call->rx_expect_next)) {
+			_net("OOS %u > %u", seq, call->rx_expect_next);
+			rxrpc_send_ACK(call, RXRPC_ACK_OUT_OF_SEQUENCE, serial,
+				       rxrpc_propose_ack_input_data);
+			acked = true;
+		}
+		call->rx_expect_next = seq + 1;
+	}
+
+out:
+	if (!acked &&
+	    atomic_inc_return(&call->ackr_nr_unacked) > 2)
+		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, serial,
+			       rxrpc_propose_ack_input_data);
+	else
+		rxrpc_propose_delay_ACK(call, serial,
+					rxrpc_propose_ack_input_data);
+
+	trace_rxrpc_notify_socket(call->debug_id, serial);
+	rxrpc_notify_socket(call);
+
+	rxrpc_free_skb(skb, rxrpc_skb_freed);
+	_leave(" [queued]");
 }
 
 /*
- * Handle reception of a duplicate packet.
- *
- * We have to take care to avoid an attack here whereby we're given a series of
- * jumbograms, each with a sequence number one before the preceding one and
- * filled up to maximum UDP size.  If they never send us the first packet in
- * the sequence, they can cause us to have to hold on to around 2MiB of kernel
- * space until the call times out.
- *
- * We limit the space usage by only accepting three duplicate jumbo packets per
- * call.  After that, we tell the other side we're no longer accepting jumbos
- * (that information is encoded in the ACK packet).
+ * Split a jumbo packet and file the bits separately.
  */
-static void rxrpc_input_dup_data(struct rxrpc_call *call, rxrpc_seq_t seq,
-				 bool is_jumbo, bool *_jumbo_bad)
+static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb)
 {
-	/* Discard normal packets that are duplicates. */
-	if (is_jumbo)
-		return;
+	struct rxrpc_jumbo_header jhdr;
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb), *jsp;
+	struct sk_buff *jskb;
+	unsigned int offset = sizeof(struct rxrpc_wire_header);
+	unsigned int len = skb->len - offset;
 
-	/* Skip jumbo subpackets that are duplicates.  When we've had three or
-	 * more partially duplicate jumbo packets, we refuse to take any more
-	 * jumbos for this call.
-	 */
-	if (!*_jumbo_bad) {
-		call->nr_jumbo_bad++;
-		*_jumbo_bad = true;
+	while (sp->hdr.flags & RXRPC_JUMBO_PACKET) {
+		if (len < RXRPC_JUMBO_SUBPKTLEN)
+			goto protocol_error;
+		if (sp->hdr.flags & RXRPC_LAST_PACKET)
+			goto protocol_error;
+		if (skb_copy_bits(skb, offset + RXRPC_JUMBO_DATALEN,
+				  &jhdr, sizeof(jhdr)) < 0)
+			goto protocol_error;
+
+		jskb = skb_clone(skb, GFP_ATOMIC);
+		if (!jskb) {
+			kdebug("couldn't clone");
+			return false;
+		}
+		rxrpc_new_skb(jskb, rxrpc_skb_cloned_jumbo);
+		jsp = rxrpc_skb(jskb);
+		jsp->offset = offset;
+		jsp->len = RXRPC_JUMBO_DATALEN;
+		rxrpc_input_data_one(call, jskb);
+
+		sp->hdr.flags = jhdr.flags;
+		sp->hdr._rsvd = ntohs(jhdr._rsvd);
+		sp->hdr.seq++;
+		sp->hdr.serial++;
+		offset += RXRPC_JUMBO_SUBPKTLEN;
+		len -= RXRPC_JUMBO_SUBPKTLEN;
 	}
+
+	sp->offset = offset;
+	sp->len    = len;
+	rxrpc_input_data_one(call, skb);
+	return true;
+
+protocol_error:
+	return false;
 }
 
 /*
@@ -395,16 +495,14 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	enum rxrpc_call_state state;
-	unsigned int j, nr_subpackets, nr_unacked = 0;
-	rxrpc_serial_t serial = sp->hdr.serial, ack_serial = serial;
-	rxrpc_seq_t seq0 = sp->hdr.seq, hard_ack;
-	bool jumbo_bad = false;
+	rxrpc_serial_t serial = sp->hdr.serial;
+	rxrpc_seq_t seq0 = sp->hdr.seq;
 
 	_enter("{%u,%u},{%u,%u}",
 	       call->rx_hard_ack, call->rx_top, skb->len, seq0);
 
-	_proto("Rx DATA %%%u { #%u f=%02x n=%u }",
-	       sp->hdr.serial, seq0, sp->hdr.flags, sp->nr_subpackets);
+	_proto("Rx DATA %%%u { #%u f=%02x }",
+	       sp->hdr.serial, seq0, sp->hdr.flags);
 
 	state = READ_ONCE(call->state);
 	if (state >= RXRPC_CALL_COMPLETE) {
@@ -412,6 +510,24 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		return;
 	}
 
+	/* Unshare the packet so that it can be modified for in-place
+	 * decryption.
+	 */
+	if (sp->hdr.securityIndex != 0) {
+		struct sk_buff *nskb = skb_unshare(skb, GFP_ATOMIC);
+		if (!nskb) {
+			rxrpc_eaten_skb(skb, rxrpc_skb_unshared_nomem);
+			return;
+		}
+
+		if (nskb != skb) {
+			rxrpc_eaten_skb(skb, rxrpc_skb_received);
+			skb = nskb;
+			rxrpc_new_skb(skb, rxrpc_skb_unshared);
+			sp = rxrpc_skb(skb);
+		}
+	}
+
 	if (state == RXRPC_CALL_SERVER_RECV_REQUEST) {
 		unsigned long timo = READ_ONCE(call->next_req_timo);
 		unsigned long now, expect_req_by;
@@ -425,12 +541,6 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		}
 	}
 
-	rxrpc_inc_stat(call->rxnet, stat_rx_data);
-	if (sp->hdr.flags & RXRPC_REQUEST_ACK)
-		rxrpc_inc_stat(call->rxnet, stat_rx_data_reqack);
-	if (sp->hdr.flags & RXRPC_JUMBO_PACKET)
-		rxrpc_inc_stat(call->rxnet, stat_rx_data_jumbo);
-
 	spin_lock(&call->input_lock);
 
 	/* Received data implicitly ACKs all of the request packets we sent
@@ -439,154 +549,15 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	if ((state == RXRPC_CALL_CLIENT_SEND_REQUEST ||
 	     state == RXRPC_CALL_CLIENT_AWAIT_REPLY) &&
 	    !rxrpc_receiving_reply(call))
-		goto unlock;
-
-	hard_ack = READ_ONCE(call->rx_hard_ack);
-
-	nr_subpackets = sp->nr_subpackets;
-	if (nr_subpackets > 1) {
-		if (call->nr_jumbo_bad > 3) {
-			rxrpc_send_ACK(call, RXRPC_ACK_NOSPACE, serial,
-				       rxrpc_propose_ack_input_data);
-			goto unlock;
-		}
-	}
-
-	for (j = 0; j < nr_subpackets; j++) {
-		rxrpc_serial_t serial = sp->hdr.serial + j;
-		rxrpc_seq_t seq = seq0 + j;
-		unsigned int ix = seq & RXRPC_RXTX_BUFF_MASK;
-		bool terminal = (j == nr_subpackets - 1);
-		bool last = terminal && (sp->rx_flags & RXRPC_SKB_INCL_LAST);
-		bool acked = false;
-		u8 flags, annotation = j;
-
-		_proto("Rx DATA+%u %%%u { #%x t=%u l=%u }",
-		     j, serial, seq, terminal, last);
-
-		if (last) {
-			if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
-			    seq != call->rx_top) {
-				rxrpc_proto_abort("LSN", call, seq);
-				goto unlock;
-			}
-		} else {
-			if (test_bit(RXRPC_CALL_RX_LAST, &call->flags) &&
-			    after_eq(seq, call->rx_top)) {
-				rxrpc_proto_abort("LSA", call, seq);
-				goto unlock;
-			}
-		}
-
-		flags = 0;
-		if (last)
-			flags |= RXRPC_LAST_PACKET;
-		if (!terminal)
-			flags |= RXRPC_JUMBO_PACKET;
-		if (test_bit(j, sp->rx_req_ack))
-			flags |= RXRPC_REQUEST_ACK;
-		trace_rxrpc_rx_data(call->debug_id, seq, serial, flags, annotation);
-
-		if (before_eq(seq, hard_ack)) {
-			rxrpc_send_ACK(call, RXRPC_ACK_DUPLICATE, serial,
-				       rxrpc_propose_ack_input_data);
-			continue;
-		}
-
-		if (call->rxtx_buffer[ix]) {
-			rxrpc_input_dup_data(call, seq, nr_subpackets > 1,
-					     &jumbo_bad);
-			rxrpc_send_ACK(call, RXRPC_ACK_DUPLICATE, serial,
-				       rxrpc_propose_ack_input_data);
-			continue;
-		}
-
-		if (after(seq, hard_ack + call->rx_winsize)) {
-			rxrpc_send_ACK(call, RXRPC_ACK_EXCEEDS_WINDOW, serial,
-				       rxrpc_propose_ack_input_data);
-			if (flags & RXRPC_JUMBO_PACKET) {
-				if (!jumbo_bad) {
-					call->nr_jumbo_bad++;
-					jumbo_bad = true;
-				}
-			}
-
-			goto unlock;
-		}
-
-		if (flags & RXRPC_REQUEST_ACK) {
-			rxrpc_send_ACK(call, RXRPC_ACK_REQUESTED, serial,
-				       rxrpc_propose_ack_input_data);
-			acked = true;
-		}
-
-		if (after(seq0, call->ackr_highest_seq))
-			call->ackr_highest_seq = seq0;
-
-		/* Queue the packet.  We use a couple of memory barriers here as need
-		 * to make sure that rx_top is perceived to be set after the buffer
-		 * pointer and that the buffer pointer is set after the annotation and
-		 * the skb data.
-		 *
-		 * Barriers against rxrpc_recvmsg_data() and rxrpc_rotate_rx_window()
-		 * and also rxrpc_fill_out_ack().
-		 */
-		if (!terminal)
-			rxrpc_get_skb(skb, rxrpc_skb_got);
-		call->rxtx_annotations[ix] = annotation;
-		smp_wmb();
-		call->rxtx_buffer[ix] = skb;
-		if (after(seq, call->rx_top)) {
-			smp_store_release(&call->rx_top, seq);
-		} else if (before(seq, call->rx_top)) {
-			/* Send an immediate ACK if we fill in a hole */
-			if (!acked) {
-				rxrpc_send_ACK(call, RXRPC_ACK_DELAY, serial,
-					       rxrpc_propose_ack_input_data_hole);
-				acked = true;
-			}
-		}
-
-		if (terminal) {
-			/* From this point on, we're not allowed to touch the
-			 * packet any longer as its ref now belongs to the Rx
-			 * ring.
-			 */
-			skb = NULL;
-			sp = NULL;
-		}
-
-		if (last) {
-			set_bit(RXRPC_CALL_RX_LAST, &call->flags);
-			trace_rxrpc_receive(call, rxrpc_receive_queue_last, serial, seq);
-		} else {
-			trace_rxrpc_receive(call, rxrpc_receive_queue, serial, seq);
-		}
-
-		if (after_eq(seq, call->rx_expect_next)) {
-			if (after(seq, call->rx_expect_next)) {
-				_net("OOS %u > %u", seq, call->rx_expect_next);
-				rxrpc_send_ACK(call, RXRPC_ACK_OUT_OF_SEQUENCE, serial,
-					       rxrpc_propose_ack_input_data);
-				acked = true;
-			}
-			call->rx_expect_next = seq + 1;
-		}
+		goto out;
 
-		if (!acked) {
-			nr_unacked++;
-			ack_serial = serial;
-		}
+	if (!rxrpc_input_split_jumbo(call, skb)) {
+		rxrpc_proto_abort("VLD", call, sp->hdr.seq);
+		goto out;
 	}
+	skb = NULL;
 
-unlock:
-	if (atomic_add_return(nr_unacked, &call->ackr_nr_unacked) > 2)
-		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, ack_serial,
-			       rxrpc_propose_ack_input_data);
-	else
-		rxrpc_propose_delay_ACK(call, ack_serial,
-					rxrpc_propose_ack_input_data);
-
+out:
 	trace_rxrpc_notify_socket(call->debug_id, serial);
 	rxrpc_notify_socket(call);
 
@@ -1288,8 +1259,6 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 		if (sp->hdr.callNumber == 0 ||
 		    sp->hdr.seq == 0)
 			goto bad_message;
-		if (!rxrpc_validate_data(skb))
-			goto bad_message;
 
 		/* Unshare the packet so that it can be modified for in-place
 		 * decryption.
@@ -1403,7 +1372,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 				trace_rxrpc_rx_data(chan->call_debug_id,
 						    sp->hdr.seq,
 						    sp->hdr.serial,
-						    sp->hdr.flags, 0);
+						    sp->hdr.flags);
 			rxrpc_post_packet_to_conn(conn, skb);
 			goto out;
 		}
diff --git a/net/rxrpc/insecure.c b/net/rxrpc/insecure.c
index 9aae99d67833..fd68f0e3af27 100644
--- a/net/rxrpc/insecure.c
+++ b/net/rxrpc/insecure.c
@@ -31,10 +31,11 @@ static int none_secure_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	return 0;
 }
 
-static int none_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
-			      unsigned int offset, unsigned int len,
-			      rxrpc_seq_t seq, u16 expected_cksum)
+static int none_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 {
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+
+	sp->flags |= RXRPC_RX_VERIFIED;
 	return 0;
 }
 
@@ -42,11 +43,6 @@ static void none_free_call_crypto(struct rxrpc_call *call)
 {
 }
 
-static void none_locate_data(struct rxrpc_call *call, struct sk_buff *skb,
-			     unsigned int *_offset, unsigned int *_len)
-{
-}
-
 static int none_respond_to_challenge(struct rxrpc_connection *conn,
 				     struct sk_buff *skb,
 				     u32 *_abort_code)
@@ -95,7 +91,6 @@ const struct rxrpc_security rxrpc_no_security = {
 	.how_much_data			= none_how_much_data,
 	.secure_packet			= none_secure_packet,
 	.verify_packet			= none_verify_packet,
-	.locate_data			= none_locate_data,
 	.respond_to_challenge		= none_respond_to_challenge,
 	.verify_response		= none_verify_response,
 	.clear				= none_clear,
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index d35657b659ad..f7bb792c8aa1 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -121,7 +121,7 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 
 	mtu = conn->params.peer->if_mtu;
 	mtu -= conn->params.peer->hdrsize;
-	jmax = (call->nr_jumbo_bad > 3) ? 1 : rxrpc_rx_jumbo_max;
+	jmax = rxrpc_rx_jumbo_max;
 	ackinfo.rxMTU		= htonl(rxrpc_rx_mtu);
 	ackinfo.maxMTU		= htonl(mtu);
 	ackinfo.rwind		= htonl(call->rx_winsize);
diff --git a/net/rxrpc/protocol.h b/net/rxrpc/protocol.h
index f3d4e2700901..6760cb99c6d6 100644
--- a/net/rxrpc/protocol.h
+++ b/net/rxrpc/protocol.h
@@ -84,7 +84,7 @@ struct rxrpc_jumbo_header {
 		__be16	_rsvd;		/* reserved */
 		__be16	cksum;		/* kerberos security checksum */
 	};
-};
+} __packed;
 
 #define RXRPC_JUMBO_DATALEN	1412	/* non-terminal jumbo packet data length */
 #define RXRPC_JUMBO_SUBPKTLEN	(RXRPC_JUMBO_DATALEN + sizeof(struct rxrpc_jumbo_header))
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 77cde6311559..401aae687830 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -222,7 +222,6 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	rxrpc_serial_t serial;
 	rxrpc_seq_t hard_ack, top;
 	bool last = false;
-	u8 subpacket;
 	int ix;
 
 	_enter("%d", call->debug_id);
@@ -237,11 +236,9 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	rxrpc_see_skb(skb, rxrpc_skb_rotated);
 	sp = rxrpc_skb(skb);
 
-	subpacket = call->rxtx_annotations[ix] & RXRPC_RX_ANNO_SUBPACKET;
-	serial = sp->hdr.serial + subpacket;
+	serial = sp->hdr.serial;
 
-	if (subpacket == sp->nr_subpackets - 1 &&
-	    sp->rx_flags & RXRPC_SKB_INCL_LAST)
+	if (sp->hdr.flags & RXRPC_LAST_PACKET)
 		last = true;
 
 	call->rxtx_buffer[ix] = NULL;
@@ -266,80 +263,15 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 }
 
 /*
- * Decrypt and verify a (sub)packet.  The packet's length may be changed due to
- * padding, but if this is the case, the packet length will be resident in the
- * socket buffer.  Note that we can't modify the master skb info as the skb may
- * be the home to multiple subpackets.
+ * Decrypt and verify a DATA packet.
  */
-static int rxrpc_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
-			       u8 annotation,
-			       unsigned int offset, unsigned int len)
+static int rxrpc_verify_data(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	rxrpc_seq_t seq = sp->hdr.seq;
-	u16 cksum = sp->hdr.cksum;
-	u8 subpacket = annotation & RXRPC_RX_ANNO_SUBPACKET;
 
-	_enter("");
-
-	/* For all but the head jumbo subpacket, the security checksum is in a
-	 * jumbo header immediately prior to the data.
-	 */
-	if (subpacket > 0) {
-		__be16 tmp;
-		if (skb_copy_bits(skb, offset - 2, &tmp, 2) < 0)
-			BUG();
-		cksum = ntohs(tmp);
-		seq += subpacket;
-	}
-
-	return call->security->verify_packet(call, skb, offset, len,
-					     seq, cksum);
-}
-
-/*
- * Locate the data within a packet.  This is complicated by:
- *
- * (1) An skb may contain a jumbo packet - so we have to find the appropriate
- *     subpacket.
- *
- * (2) The (sub)packets may be encrypted and, if so, the encrypted portion
- *     contains an extra header which includes the true length of the data,
- *     excluding any encrypted padding.
- */
-static int rxrpc_locate_data(struct rxrpc_call *call, struct sk_buff *skb,
-			     u8 *_annotation,
-			     unsigned int *_offset, unsigned int *_len,
-			     bool *_last)
-{
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	unsigned int offset = sizeof(struct rxrpc_wire_header);
-	unsigned int len;
-	bool last = false;
-	int ret;
-	u8 annotation = *_annotation;
-	u8 subpacket = annotation & RXRPC_RX_ANNO_SUBPACKET;
-
-	/* Locate the subpacket */
-	offset += subpacket * RXRPC_JUMBO_SUBPKTLEN;
-	len = skb->len - offset;
-	if (subpacket < sp->nr_subpackets - 1)
-		len = RXRPC_JUMBO_DATALEN;
-	else if (sp->rx_flags & RXRPC_SKB_INCL_LAST)
-		last = true;
-
-	if (!(annotation & RXRPC_RX_ANNO_VERIFIED)) {
-		ret = rxrpc_verify_packet(call, skb, annotation, offset, len);
-		if (ret < 0)
-			return ret;
-		*_annotation |= RXRPC_RX_ANNO_VERIFIED;
-	}
-
-	*_offset = offset;
-	*_len = len;
-	*_last = last;
-	call->security->locate_data(call, skb, _offset, _len);
-	return 0;
+	if (sp->flags & RXRPC_RX_VERIFIED)
+		return 0;
+	return call->security->verify_packet(call, skb);
 }
 
 /*
@@ -356,13 +288,11 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 	rxrpc_serial_t serial;
 	rxrpc_seq_t hard_ack, top, seq;
 	size_t remain;
-	bool rx_pkt_last;
 	unsigned int rx_pkt_offset, rx_pkt_len;
 	int ix, copy, ret = -EAGAIN, ret2;
 
 	rx_pkt_offset = call->rx_pkt_offset;
 	rx_pkt_len = call->rx_pkt_len;
-	rx_pkt_last = call->rx_pkt_last;
 
 	if (call->state >= RXRPC_CALL_SERVER_ACK_REQUEST) {
 		seq = call->rx_hard_ack;
@@ -391,7 +321,6 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 
 		if (!(flags & MSG_PEEK)) {
 			serial = sp->hdr.serial;
-			serial += call->rxtx_annotations[ix] & RXRPC_RX_ANNO_SUBPACKET;
 			trace_rxrpc_receive(call, rxrpc_receive_front,
 					    serial, seq);
 		}
@@ -400,10 +329,9 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 			sock_recv_timestamp(msg, sock->sk, skb);
 
 		if (rx_pkt_offset == 0) {
-			ret2 = rxrpc_locate_data(call, skb,
-						 &call->rxtx_annotations[ix],
-						 &rx_pkt_offset, &rx_pkt_len,
-						 &rx_pkt_last);
+			ret2 = rxrpc_verify_data(call, skb);
+			rx_pkt_offset = sp->offset;
+			rx_pkt_len = sp->len;
 			trace_rxrpc_recvdata(call, rxrpc_recvmsg_next, seq,
 					     rx_pkt_offset, rx_pkt_len, ret2);
 			if (ret2 < 0) {
@@ -443,16 +371,13 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 		}
 
 		/* The whole packet has been transferred. */
-		if (!(flags & MSG_PEEK))
-			rxrpc_rotate_rx_window(call);
+		if (sp->hdr.flags & RXRPC_LAST_PACKET)
+			ret = 1;
 		rx_pkt_offset = 0;
 		rx_pkt_len = 0;
 
-		if (rx_pkt_last) {
-			ASSERTCMP(seq, ==, READ_ONCE(call->rx_top));
-			ret = 1;
-			goto out;
-		}
+		if (!(flags & MSG_PEEK))
+			rxrpc_rotate_rx_window(call);
 
 		seq++;
 	}
@@ -461,7 +386,6 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 	if (!(flags & MSG_PEEK)) {
 		call->rx_pkt_offset = rx_pkt_offset;
 		call->rx_pkt_len = rx_pkt_len;
-		call->rx_pkt_last = rx_pkt_last;
 	}
 done:
 	trace_rxrpc_recvdata(call, rxrpc_recvmsg_data_return, seq,
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 78fa0524156f..b19937776aa9 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -439,11 +439,11 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
  * decrypt partial encryption on a packet (level 1 security)
  */
 static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
-				 unsigned int offset, unsigned int len,
 				 rxrpc_seq_t seq,
 				 struct skcipher_request *req)
 {
 	struct rxkad_level1_hdr sechdr;
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[16];
 	bool aborted;
@@ -453,9 +453,9 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 
 	_enter("");
 
-	if (len < 8) {
+	if (sp->len < 8) {
 		aborted = rxrpc_abort_eproto(call, skb, "rxkad_1_hdr", "V1H",
-					   RXKADSEALEDINCON);
+					     RXKADSEALEDINCON);
 		goto protocol_error;
 	}
 
@@ -463,7 +463,7 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	 * directly into the target buffer.
 	 */
 	sg_init_table(sg, ARRAY_SIZE(sg));
-	ret = skb_to_sgvec(skb, sg, offset, 8);
+	ret = skb_to_sgvec(skb, sg, sp->offset, 8);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -477,12 +477,13 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	skcipher_request_zero(req);
 
 	/* Extract the decrypted packet length */
-	if (skb_copy_bits(skb, offset, &sechdr, sizeof(sechdr)) < 0) {
+	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0) {
 		aborted = rxrpc_abort_eproto(call, skb, "rxkad_1_len", "XV1",
 					     RXKADDATALEN);
 		goto protocol_error;
 	}
-	len -= sizeof(sechdr);
+	sp->offset += sizeof(sechdr);
+	sp->len    -= sizeof(sechdr);
 
 	buf = ntohl(sechdr.data_size);
 	data_size = buf & 0xffff;
@@ -496,11 +497,12 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 		goto protocol_error;
 	}
 
-	if (data_size > len) {
+	if (data_size > sp->len) {
 		aborted = rxrpc_abort_eproto(call, skb, "rxkad_1_datalen", "V1L",
 					     RXKADDATALEN);
 		goto protocol_error;
 	}
+	sp->len = data_size;
 
 	_leave(" = 0 [dlen=%x]", data_size);
 	return 0;
@@ -515,12 +517,12 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
  * wholly decrypt a packet (level 2 security)
  */
 static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
-				 unsigned int offset, unsigned int len,
 				 rxrpc_seq_t seq,
 				 struct skcipher_request *req)
 {
 	const struct rxrpc_key_token *token;
 	struct rxkad_level2_hdr sechdr;
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_crypt iv;
 	struct scatterlist _sg[4], *sg;
 	bool aborted;
@@ -528,9 +530,9 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	u16 check;
 	int nsg, ret;
 
-	_enter(",{%d}", skb->len);
+	_enter(",{%d}", sp->len);
 
-	if (len < 8) {
+	if (sp->len < 8) {
 		aborted = rxrpc_abort_eproto(call, skb, "rxkad_2_hdr", "V2H",
 					     RXKADSEALEDINCON);
 		goto protocol_error;
@@ -550,7 +552,7 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	}
 
 	sg_init_table(sg, nsg);
-	ret = skb_to_sgvec(skb, sg, offset, len);
+	ret = skb_to_sgvec(skb, sg, sp->offset, sp->len);
 	if (unlikely(ret < 0)) {
 		if (sg != _sg)
 			kfree(sg);
@@ -563,19 +565,20 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, sg, sg, len, iv.x);
+	skcipher_request_set_crypt(req, sg, sg, sp->len, iv.x);
 	crypto_skcipher_decrypt(req);
 	skcipher_request_zero(req);
 	if (sg != _sg)
 		kfree(sg);
 
 	/* Extract the decrypted packet length */
-	if (skb_copy_bits(skb, offset, &sechdr, sizeof(sechdr)) < 0) {
+	if (skb_copy_bits(skb, sp->offset, &sechdr, sizeof(sechdr)) < 0) {
 		aborted = rxrpc_abort_eproto(call, skb, "rxkad_2_len", "XV2",
 					     RXKADDATALEN);
 		goto protocol_error;
 	}
-	len -= sizeof(sechdr);
+	sp->offset += sizeof(sechdr);
+	sp->len    -= sizeof(sechdr);
 
 	buf = ntohl(sechdr.data_size);
 	data_size = buf & 0xffff;
@@ -589,12 +592,13 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 		goto protocol_error;
 	}
 
-	if (data_size > len) {
+	if (data_size > sp->len) {
 		aborted = rxrpc_abort_eproto(call, skb, "rxkad_2_datalen", "V2L",
 					     RXKADDATALEN);
 		goto protocol_error;
 	}
 
+	sp->len = data_size;
 	_leave(" = 0 [dlen=%x]", data_size);
 	return 0;
 
@@ -609,16 +613,15 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 }
 
 /*
- * Verify the security on a received packet or subpacket (if part of a
- * jumbo packet).
+ * Verify the security on a received packet and the subpackets therein.
  */
-static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
-			       unsigned int offset, unsigned int len,
-			       rxrpc_seq_t seq, u16 expected_cksum)
+static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 {
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct skcipher_request	*req;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg;
+	rxrpc_seq_t seq = sp->hdr.seq;
 	bool aborted;
 	u16 cksum;
 	u32 x, y;
@@ -654,7 +657,7 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	if (cksum == 0)
 		cksum = 1; /* zero checksums are not permitted */
 
-	if (cksum != expected_cksum) {
+	if (cksum != sp->hdr.cksum) {
 		aborted = rxrpc_abort_eproto(call, skb, "rxkad_csum", "VCK",
 					     RXKADSEALEDINCON);
 		goto protocol_error;
@@ -664,9 +667,9 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	case RXRPC_SECURITY_PLAIN:
 		return 0;
 	case RXRPC_SECURITY_AUTH:
-		return rxkad_verify_packet_1(call, skb, offset, len, seq, req);
+		return rxkad_verify_packet_1(call, skb, seq, req);
 	case RXRPC_SECURITY_ENCRYPT:
-		return rxkad_verify_packet_2(call, skb, offset, len, seq, req);
+		return rxkad_verify_packet_2(call, skb, seq, req);
 	default:
 		return -ENOANO;
 	}
@@ -677,52 +680,6 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	return -EPROTO;
 }
 
-/*
- * Locate the data contained in a packet that was partially encrypted.
- */
-static void rxkad_locate_data_1(struct rxrpc_call *call, struct sk_buff *skb,
-				unsigned int *_offset, unsigned int *_len)
-{
-	struct rxkad_level1_hdr sechdr;
-
-	if (skb_copy_bits(skb, *_offset, &sechdr, sizeof(sechdr)) < 0)
-		BUG();
-	*_offset += sizeof(sechdr);
-	*_len = ntohl(sechdr.data_size) & 0xffff;
-}
-
-/*
- * Locate the data contained in a packet that was completely encrypted.
- */
-static void rxkad_locate_data_2(struct rxrpc_call *call, struct sk_buff *skb,
-				unsigned int *_offset, unsigned int *_len)
-{
-	struct rxkad_level2_hdr sechdr;
-
-	if (skb_copy_bits(skb, *_offset, &sechdr, sizeof(sechdr)) < 0)
-		BUG();
-	*_offset += sizeof(sechdr);
-	*_len = ntohl(sechdr.data_size) & 0xffff;
-}
-
-/*
- * Locate the data contained in an already decrypted packet.
- */
-static void rxkad_locate_data(struct rxrpc_call *call, struct sk_buff *skb,
-			      unsigned int *_offset, unsigned int *_len)
-{
-	switch (call->conn->params.security_level) {
-	case RXRPC_SECURITY_AUTH:
-		rxkad_locate_data_1(call, skb, _offset, _len);
-		return;
-	case RXRPC_SECURITY_ENCRYPT:
-		rxkad_locate_data_2(call, skb, _offset, _len);
-		return;
-	default:
-		return;
-	}
-}
-
 /*
  * issue a challenge
  */
@@ -1397,7 +1354,6 @@ const struct rxrpc_security rxkad = {
 	.secure_packet			= rxkad_secure_packet,
 	.verify_packet			= rxkad_verify_packet,
 	.free_call_crypto		= rxkad_free_call_crypto,
-	.locate_data			= rxkad_locate_data,
 	.issue_challenge		= rxkad_issue_challenge,
 	.respond_to_challenge		= rxkad_respond_to_challenge,
 	.verify_response		= rxkad_verify_response,


