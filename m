Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5013E281F
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244922AbhHFKJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:09:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244905AbhHFKJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 06:09:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628244540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tDHQ9Ulm3F1gZvDZHi0UnxkFYVqUZuhtyF1seBl2e04=;
        b=hI0adXF8EColLVHDP6+tmaYddTKmY72NI0uP7bik1i4heEYHG7P0by2xSjrNPbA62S+x0K
        gxnnZrD0Fcdaejek9Le+Pp0EkJ2EbOVXo3A9t6ptWgjORWnqdyxz8UiyBS3ls6SsJss+xi
        QDHEINC+k0IYMyXDGZBuZ/JTByf8wTM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-fJyrQIvZNpemSWHwaQcnZg-1; Fri, 06 Aug 2021 06:08:58 -0400
X-MC-Unique: fJyrQIvZNpemSWHwaQcnZg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A9C087180C;
        Fri,  6 Aug 2021 10:08:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.22.32.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 566597A8D7;
        Fri,  6 Aug 2021 10:08:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     Jeffrey E Altman <jaltman@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>
cc:     dhowells@redhat.com, Benjamin Kaduk <kaduk@mit.edu>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] rxrpc: Support reception of extended-SACK ACK packet
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1290707.1628244534.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 06 Aug 2021 11:08:54 +0100
Message-ID: <1290708.1628244534@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    =

The RxRPC ACK packet supports selective ACK of up to 255 DATA packets.  It
contains a variable length array with one octet allocated for each DATA
packet to be ACK'd.  Each octet is either 0 or 1 depending on whether it i=
s
a negative or positive ACK.  7 bits in each octet are effectively unused
and, further, there are three reserved octets following the ACK array that
are all set to 0.

To extend the ACK window up to 2048 ACKs, it is proposed[1]:

 (1) that the ACKs for DATA packets first+0...first+254 in the Rx window
     are in bit 0 of the octets in the array, ie. acks[0...254], pretty
     much as now; and

 (2) that if the ACK count is >=3D256, the first reserved byte after the A=
CK
     table is annexed to the ACK table as acks[255] and contains the ACK
     for packet first+255 in bit 0; and

 (3) that if the ACK count is >256, horizontal striping be employed such
     that the ACK for packet first+256 in the window is then in bit 1 of
     acks[0], first+257 is in bit 1 of acks[1], up to first+511 being in
     bit 1 of the borrowed reserved byte (ie. acks[255]).

     first+512 is then in bit 2 of acks[0], going all the way up to
     first+2048 being in bit 7 of acks[255].

If extended SACK is employed in an ACK packet, it should have EXTENDED-SAC=
K
(0x08) set in the RxRPC packet header.

Alter rxrpc_input_ack() to sanity check the ACK count.

Alter rxrpc_input_ack() to limit the number of bytes it extracts from the
packet for the ack array to 256.

Alter rxrpc_input_soft_acks() to handle an extended SACK table.

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://gerrit.openafs.org/#/c/14693/3 [1]
---
 net/rxrpc/input.c    |   21 ++++++++++++++-------
 net/rxrpc/protocol.h |    7 +++++--
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index dc201363f2c4..0a7f7462b617 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -767,15 +767,17 @@ static void rxrpc_input_soft_acks(struct rxrpc_call =
*call, u8 *acks,
 				  rxrpc_seq_t seq, int nr_acks,
 				  struct rxrpc_ack_summary *summary)
 {
-	int ix;
-	u8 annotation, anno_type;
+	int ix, i;
+	u8 annotation, anno_type, ack;
 =

-	for (; nr_acks > 0; nr_acks--, seq++) {
+	for (i =3D 0; i < nr_acks; i++, seq++) {
 		ix =3D seq & RXRPC_RXTX_BUFF_MASK;
 		annotation =3D call->rxtx_annotations[ix];
 		anno_type =3D annotation & RXRPC_TX_ANNO_MASK;
 		annotation &=3D ~RXRPC_TX_ANNO_MASK;
-		switch (*acks++) {
+		ack =3D acks[i % RXRPC_EXTENDED_SACK_SIZE];
+		ack >>=3D i / RXRPC_EXTENDED_SACK_SIZE;
+		switch (ack) {
 		case RXRPC_ACK_TYPE_ACK:
 			summary->nr_acks++;
 			if (anno_type =3D=3D RXRPC_TX_ANNO_ACK)
@@ -846,7 +848,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, s=
truct sk_buff *skb)
 	union {
 		struct rxrpc_ackpacket ack;
 		struct rxrpc_ackinfo info;
-		u8 acks[RXRPC_MAXACKS];
+		u8 acks[RXRPC_EXTENDED_SACK_SIZE];
 	} buf;
 	rxrpc_serial_t ack_serial, acked_serial;
 	rxrpc_seq_t first_soft_ack, hard_ack, prev_pkt;
@@ -874,6 +876,10 @@ static void rxrpc_input_ack(struct rxrpc_call *call, =
struct sk_buff *skb)
 			   first_soft_ack, prev_pkt,
 			   summary.ack_reason, nr_acks);
 =

+	if ((nr_acks > RXRPC_MAXACKS && !(sp->hdr.flags & RXRPC_EXTENDED_SACK)) =
||
+	    (nr_acks > RXRPC_MAXACKS_EXTENDED))
+		return rxrpc_proto_abort("AKC", call, 0);
+	=

 	switch (buf.ack.reason) {
 	case RXRPC_ACK_PING_RESPONSE:
 		rxrpc_input_ping_response(call, skb->tstamp, acked_serial,
@@ -912,7 +918,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, s=
truct sk_buff *skb)
 	}
 =

 	buf.info.rxMTU =3D 0;
-	ioffset =3D offset + nr_acks + 3;
+	ioffset =3D offset + min(nr_acks, RXRPC_MAXACKS) + 3;
 	if (skb->len >=3D ioffset + sizeof(buf.info) &&
 	    skb_copy_bits(skb, ioffset, &buf.info, sizeof(buf.info)) < 0)
 		return rxrpc_proto_abort("XAI", call, 0);
@@ -969,7 +975,8 @@ static void rxrpc_input_ack(struct rxrpc_call *call, s=
truct sk_buff *skb)
 	}
 =

 	if (nr_acks > 0) {
-		if (skb_copy_bits(skb, offset, buf.acks, nr_acks) < 0) {
+		if (skb_copy_bits(skb, offset, buf.acks,
+				  min_t(unsigned int, nr_acks, sizeof(buf.acks))) < 0) {
 			rxrpc_proto_abort("XSA", call, 0);
 			goto out;
 		}
diff --git a/net/rxrpc/protocol.h b/net/rxrpc/protocol.h
index 49bb972539aa..287986012cd9 100644
--- a/net/rxrpc/protocol.h
+++ b/net/rxrpc/protocol.h
@@ -51,7 +51,8 @@ struct rxrpc_wire_header {
 #define RXRPC_CLIENT_INITIATED	0x01		/* signifies a packet generated by a=
 client */
 #define RXRPC_REQUEST_ACK	0x02		/* request an unconditional ACK of this p=
acket */
 #define RXRPC_LAST_PACKET	0x04		/* the last packet from this side for thi=
s call */
-#define RXRPC_MORE_PACKETS	0x08		/* more packets to come */
+#define RXRPC_MORE_PACKETS	0x08		/* [DATA] More packets to come */
+#define RXRPC_EXTENDED_SACK	0x08		/* [ACK] Extended SACK table */
 #define RXRPC_JUMBO_PACKET	0x20		/* [DATA] this is a jumbo packet */
 #define RXRPC_SLOW_START_OK	0x20		/* [ACK] slow start supported */
 =

@@ -124,7 +125,9 @@ struct rxrpc_ackpacket {
 #define RXRPC_ACK__INVALID		10	/* Representation of invalid ACK reason */
 =

 	uint8_t		nAcks;		/* number of ACKs */
-#define RXRPC_MAXACKS	255
+#define RXRPC_MAXACKS	255		/* Normal maximum number of ACKs */
+#define RXRPC_EXTENDED_SACK_SIZE 256	/* Size of the extended SACK table *=
/
+#define RXRPC_MAXACKS_EXTENDED	2048	/* Maximum number of ACKs in extended=
 SACK table */
 =

 	uint8_t		acks[0];	/* list of ACK/NAKs */
 #define RXRPC_ACK_TYPE_NACK		0

