Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0E8EAFF2
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 13:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfJaMNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 08:13:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24993 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726462AbfJaMNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 08:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572524031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Mpaz5iScARrazdtK8hPiRCxl6YGYTd9auym8Ja22A8M=;
        b=XOE8zmn1sHJ0Hv0UiuI4Yk2yttl76Xavw/dfGhPnWBne79xgTjiblk3opeaURQTkCSLWvo
        7ESORXopZeQPiBxLOVASvGlwc8BzXcH+Cz756f8pOAPXaNZOvwHZiAJxA9qySghDFbWdeZ
        P2Slq/l5MMa/L6lVrhBZ3twli25D3GM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-S5GbFTSyPsCvpNbgGufomQ-1; Thu, 31 Oct 2019 08:13:49 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A4811005500;
        Thu, 31 Oct 2019 12:13:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-40.rdu2.redhat.com [10.10.121.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 876905DA7B;
        Thu, 31 Oct 2019 12:13:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix handling of last subpacket of jumbo packet
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 31 Oct 2019 12:13:46 +0000
Message-ID: <157252402623.30237.12555934347853871645.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: S5GbFTSyPsCvpNbgGufomQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rxrpc_recvmsg_data() sets the return value to 1 because it's drained
all the data for the last packet, it checks the last-packet flag on the
whole packet - but this is wrong, since the last-packet flag is only set on
the final subpacket of the last jumbo packet.  This means that a call that
receives its last packet in a jumbo packet won't complete properly.

Fix this by having rxrpc_locate_data() determine the last-packet state of
the subpacket it's looking at and passing that back to the caller rather
than having the caller look in the packet header.  The caller then needs to
cache this in the rxrpc_call struct as rxrpc_locate_data() isn't then
called again for this packet.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Fixes: e2de6c404898 ("rxrpc: Use info in skbuff instead of reparsing a jumb=
o packet")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/recvmsg.c     |   18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index ecc17dabec8f..7c7d10f2e0c1 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -601,6 +601,7 @@ struct rxrpc_call {
 =09int=09=09=09debug_id;=09/* debug ID for printks */
 =09unsigned short=09=09rx_pkt_offset;=09/* Current recvmsg packet offset *=
/
 =09unsigned short=09=09rx_pkt_len;=09/* Current recvmsg packet len */
+=09bool=09=09=09rx_pkt_last;=09/* Current recvmsg packet is last */
=20
 =09/* Rx/Tx circular buffer, depending on phase.
 =09 *
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index a4090797c9b2..8578c39ec839 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -267,11 +267,13 @@ static int rxrpc_verify_packet(struct rxrpc_call *cal=
l, struct sk_buff *skb,
  */
 static int rxrpc_locate_data(struct rxrpc_call *call, struct sk_buff *skb,
 =09=09=09     u8 *_annotation,
-=09=09=09     unsigned int *_offset, unsigned int *_len)
+=09=09=09     unsigned int *_offset, unsigned int *_len,
+=09=09=09     bool *_last)
 {
 =09struct rxrpc_skb_priv *sp =3D rxrpc_skb(skb);
 =09unsigned int offset =3D sizeof(struct rxrpc_wire_header);
 =09unsigned int len;
+=09bool last =3D false;
 =09int ret;
 =09u8 annotation =3D *_annotation;
 =09u8 subpacket =3D annotation & RXRPC_RX_ANNO_SUBPACKET;
@@ -281,6 +283,8 @@ static int rxrpc_locate_data(struct rxrpc_call *call, s=
truct sk_buff *skb,
 =09len =3D skb->len - offset;
 =09if (subpacket < sp->nr_subpackets - 1)
 =09=09len =3D RXRPC_JUMBO_DATALEN;
+=09else if (sp->rx_flags & RXRPC_SKB_INCL_LAST)
+=09=09last =3D true;
=20
 =09if (!(annotation & RXRPC_RX_ANNO_VERIFIED)) {
 =09=09ret =3D rxrpc_verify_packet(call, skb, annotation, offset, len);
@@ -291,6 +295,7 @@ static int rxrpc_locate_data(struct rxrpc_call *call, s=
truct sk_buff *skb,
=20
 =09*_offset =3D offset;
 =09*_len =3D len;
+=09*_last =3D last;
 =09call->security->locate_data(call, skb, _offset, _len);
 =09return 0;
 }
@@ -309,7 +314,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, stru=
ct rxrpc_call *call,
 =09rxrpc_serial_t serial;
 =09rxrpc_seq_t hard_ack, top, seq;
 =09size_t remain;
-=09bool last;
+=09bool rx_pkt_last;
 =09unsigned int rx_pkt_offset, rx_pkt_len;
 =09int ix, copy, ret =3D -EAGAIN, ret2;
=20
@@ -319,6 +324,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, stru=
ct rxrpc_call *call,
=20
 =09rx_pkt_offset =3D call->rx_pkt_offset;
 =09rx_pkt_len =3D call->rx_pkt_len;
+=09rx_pkt_last =3D call->rx_pkt_last;
=20
 =09if (call->state >=3D RXRPC_CALL_SERVER_ACK_REQUEST) {
 =09=09seq =3D call->rx_hard_ack;
@@ -329,6 +335,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, stru=
ct rxrpc_call *call,
 =09/* Barriers against rxrpc_input_data(). */
 =09hard_ack =3D call->rx_hard_ack;
 =09seq =3D hard_ack + 1;
+
 =09while (top =3D smp_load_acquire(&call->rx_top),
 =09       before_eq(seq, top)
 =09       ) {
@@ -356,7 +363,8 @@ static int rxrpc_recvmsg_data(struct socket *sock, stru=
ct rxrpc_call *call,
 =09=09if (rx_pkt_offset =3D=3D 0) {
 =09=09=09ret2 =3D rxrpc_locate_data(call, skb,
 =09=09=09=09=09=09 &call->rxtx_annotations[ix],
-=09=09=09=09=09=09 &rx_pkt_offset, &rx_pkt_len);
+=09=09=09=09=09=09 &rx_pkt_offset, &rx_pkt_len,
+=09=09=09=09=09=09 &rx_pkt_last);
 =09=09=09trace_rxrpc_recvmsg(call, rxrpc_recvmsg_next, seq,
 =09=09=09=09=09    rx_pkt_offset, rx_pkt_len, ret2);
 =09=09=09if (ret2 < 0) {
@@ -396,13 +404,12 @@ static int rxrpc_recvmsg_data(struct socket *sock, st=
ruct rxrpc_call *call,
 =09=09}
=20
 =09=09/* The whole packet has been transferred. */
-=09=09last =3D sp->hdr.flags & RXRPC_LAST_PACKET;
 =09=09if (!(flags & MSG_PEEK))
 =09=09=09rxrpc_rotate_rx_window(call);
 =09=09rx_pkt_offset =3D 0;
 =09=09rx_pkt_len =3D 0;
=20
-=09=09if (last) {
+=09=09if (rx_pkt_last) {
 =09=09=09ASSERTCMP(seq, =3D=3D, READ_ONCE(call->rx_top));
 =09=09=09ret =3D 1;
 =09=09=09goto out;
@@ -415,6 +422,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, stru=
ct rxrpc_call *call,
 =09if (!(flags & MSG_PEEK)) {
 =09=09call->rx_pkt_offset =3D rx_pkt_offset;
 =09=09call->rx_pkt_len =3D rx_pkt_len;
+=09=09call->rx_pkt_last =3D rx_pkt_last;
 =09}
 done:
 =09trace_rxrpc_recvmsg(call, rxrpc_recvmsg_data_return, seq,

