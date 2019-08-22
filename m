Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EADC99355
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 14:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388599AbfHVMYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 08:24:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731402AbfHVMYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 08:24:32 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 023AA308427C;
        Thu, 22 Aug 2019 12:24:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F382C60BF3;
        Thu, 22 Aug 2019 12:24:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 9/9] rxrpc: Only call skb_cow_data() once per packet
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 22 Aug 2019 13:24:30 +0100
Message-ID: <156647667024.11061.16703783428256799077.stgit@warthog.procyon.org.uk>
In-Reply-To: <156647659913.11061.13764606104739742865.stgit@warthog.procyon.org.uk>
References: <156647659913.11061.13764606104739742865.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 22 Aug 2019 12:24:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the call of skb_cow_data() from rxkad into rxrpc_recvmsg_data() and do
it as soon as the packet is first seen.  This means that we only call this
function once per packet, even for a jumbo packet with a bunch of
subpackets.

In rxkad, we then have to guess how large a scatter-gather table we need
for decryption, particularly in rxkad_verify_packet_2().  We do this either
by creating an sg table that should be large enough, or by looking at
nr_frags on the skb.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/input.c       |    1 +
 net/rxrpc/recvmsg.c     |   11 ++++++++++-
 net/rxrpc/rxkad.c       |   32 +++++++++-----------------------
 4 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index d784d58e0a0d..a42d6b833675 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -190,6 +190,7 @@ struct rxrpc_skb_priv {
 	u8		rx_flags;		/* Received packet flags */
 #define RXRPC_SKB_INCL_LAST	0x01		/* - Includes last packet */
 #define RXRPC_SKB_TX_BUFFER	0x02		/* - Is transmit buffer */
+#define RXRPC_SKB_NEEDS_COW	0x04		/* - Needs skb_cow_data() calling */
 	union {
 		int		remain;		/* amount of space remaining for next write */
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 660b7eed39b7..4df39f391e9d 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -448,6 +448,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 
 	atomic_set(&sp->nr_ring_pins, 1);
+	sp->rx_flags |= RXRPC_SKB_NEEDS_COW;
 
 	if (call->state == RXRPC_CALL_SERVER_RECV_REQUEST) {
 		unsigned long timo = READ_ONCE(call->next_req_timo);
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 82bb48d96526..ef50580b5295 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -305,7 +305,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 			      size_t len, int flags, size_t *_offset)
 {
 	struct rxrpc_skb_priv *sp;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *trailer;
 	rxrpc_serial_t serial;
 	rxrpc_seq_t hard_ack, top, seq;
 	size_t remain;
@@ -343,6 +343,15 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 		rxrpc_see_skb(skb, rxrpc_skb_seen);
 		sp = rxrpc_skb(skb);
 
+		if (sp->rx_flags & RXRPC_SKB_NEEDS_COW) {
+			ret2 = skb_cow_data(skb, 0, &trailer);
+			if (ret2 < 0) {
+				ret = ret2;
+				goto out;
+			}
+			sp->rx_flags &= ~RXRPC_SKB_NEEDS_COW;
+		}
+
 		if (!(flags & MSG_PEEK)) {
 			serial = sp->hdr.serial;
 			serial += call->rxtx_annotations[ix] & RXRPC_RX_ANNO_SUBPACKET;
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index ae8cd8926456..c60c520fde7c 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -187,10 +187,8 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 	struct rxrpc_skb_priv *sp;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[16];
-	struct sk_buff *trailer;
 	unsigned int len;
 	u16 check;
-	int nsg;
 	int err;
 
 	sp = rxrpc_skb(skb);
@@ -214,15 +212,14 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 	crypto_skcipher_encrypt(req);
 
 	/* we want to encrypt the skbuff in-place */
-	nsg = skb_cow_data(skb, 0, &trailer);
-	err = -ENOMEM;
-	if (nsg < 0 || nsg > 16)
+	err = -EMSGSIZE;
+	if (skb_shinfo(skb)->nr_frags > 16)
 		goto out;
 
 	len = data_size + call->conn->size_align - 1;
 	len &= ~(call->conn->size_align - 1);
 
-	sg_init_table(sg, nsg);
+	sg_init_table(sg, ARRAY_SIZE(sg));
 	err = skb_to_sgvec(skb, sg, 0, len);
 	if (unlikely(err < 0))
 		goto out;
@@ -319,11 +316,10 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	struct rxkad_level1_hdr sechdr;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[16];
-	struct sk_buff *trailer;
 	bool aborted;
 	u32 data_size, buf;
 	u16 check;
-	int nsg, ret;
+	int ret;
 
 	_enter("");
 
@@ -336,11 +332,7 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
 	 * directly into the target buffer.
 	 */
-	nsg = skb_cow_data(skb, 0, &trailer);
-	if (nsg < 0 || nsg > 16)
-		goto nomem;
-
-	sg_init_table(sg, nsg);
+	sg_init_table(sg, ARRAY_SIZE(sg));
 	ret = skb_to_sgvec(skb, sg, offset, 8);
 	if (unlikely(ret < 0))
 		return ret;
@@ -388,10 +380,6 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	if (aborted)
 		rxrpc_send_abort_packet(call);
 	return -EPROTO;
-
-nomem:
-	_leave(" = -ENOMEM");
-	return -ENOMEM;
 }
 
 /*
@@ -406,7 +394,6 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	struct rxkad_level2_hdr sechdr;
 	struct rxrpc_crypt iv;
 	struct scatterlist _sg[4], *sg;
-	struct sk_buff *trailer;
 	bool aborted;
 	u32 data_size, buf;
 	u16 check;
@@ -423,12 +410,11 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	/* Decrypt the skbuff in-place.  TODO: We really want to decrypt
 	 * directly into the target buffer.
 	 */
-	nsg = skb_cow_data(skb, 0, &trailer);
-	if (nsg < 0)
-		goto nomem;
-
 	sg = _sg;
-	if (unlikely(nsg > 4)) {
+	nsg = skb_shinfo(skb)->nr_frags;
+	if (nsg <= 4) {
+		nsg = 4;
+	} else {
 		sg = kmalloc_array(nsg, sizeof(*sg), GFP_NOIO);
 		if (!sg)
 			goto nomem;

