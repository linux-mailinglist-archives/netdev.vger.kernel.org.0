Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4555F2C1633
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgKWUMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:12:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729541AbgKWUMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:12:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606162328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dfxv3QcmFHs1I2mjNacxbzxJx1eMOaWYZUkPYi+8U7Q=;
        b=ezhOBed36XNijWKauFD1Om+YWdAXwLP8yw2814hv3QiMoq7zv3Emf8CctQRe69PpHiCnOL
        BRywFLIrCkK9LIiU4PJdh0mJc/IfW/I8/NxYecu+ivsHltXXa1DcHdcs4Xe4kpfBastzWZ
        0VOomoIdqO8c39cpwrni68fotw7QaRg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-lxpJ95T9MTyP2SteubFOEQ-1; Mon, 23 Nov 2020 15:12:05 -0500
X-MC-Unique: lxpJ95T9MTyP2SteubFOEQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 854748042AD;
        Mon, 23 Nov 2020 20:12:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F6E160864;
        Mon, 23 Nov 2020 20:12:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 17/17] rxrpc: Ask the security class how much space
 to allow in a packet
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 20:12:02 +0000
Message-ID: <160616232289.830164.8109948390569677552.stgit@warthog.procyon.org.uk>
In-Reply-To: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
References: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ask the security class how much header and trailer space to allow for when
allocating a packet, given how much data is remaining.

This will allow the rxgk security class to stick both a trailer in as well
as a header as appropriate in the future.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    7 ++++-
 net/rxrpc/conn_object.c |    1 -
 net/rxrpc/insecure.c    |   12 +++++++++
 net/rxrpc/rxkad.c       |   61 ++++++++++++++++++++++++++++++++++++++++-------
 net/rxrpc/sendmsg.c     |   41 ++++++++++----------------------
 5 files changed, 82 insertions(+), 40 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index fda6618df1cc..7bd6f8a66a3e 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -234,6 +234,11 @@ struct rxrpc_security {
 	int (*init_connection_security)(struct rxrpc_connection *,
 					struct rxrpc_key_token *);
 
+	/* Work out how much data we can store in a packet, given an estimate
+	 * of the amount of data remaining.
+	 */
+	int (*how_much_data)(struct rxrpc_call *, size_t,
+			     size_t *, size_t *, size_t *);
 
 	/* impose security on a packet */
 	int (*secure_packet)(struct rxrpc_call *, struct sk_buff *, size_t);
@@ -467,8 +472,6 @@ struct rxrpc_connection {
 	atomic_t		serial;		/* packet serial number counter */
 	unsigned int		hi_serial;	/* highest serial number received */
 	u32			service_id;	/* Service ID, possibly upgraded */
-	u8			size_align;	/* data size alignment (for security) */
-	u8			security_size;	/* security header size */
 	u8			security_ix;	/* security type */
 	u8			out_clientflag;	/* RXRPC_CLIENT_INITIATED if we are client */
 	u8			bundle_shift;	/* Index into bundle->avail_chans */
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 8dd1ef25b98f..b2159dbf5412 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -49,7 +49,6 @@ struct rxrpc_connection *rxrpc_alloc_connection(gfp_t gfp)
 		conn->security = &rxrpc_no_security;
 		spin_lock_init(&conn->state_lock);
 		conn->debug_id = atomic_inc_return(&rxrpc_debug_id);
-		conn->size_align = 4;
 		conn->idle_timestamp = jiffies;
 	}
 
diff --git a/net/rxrpc/insecure.c b/net/rxrpc/insecure.c
index e06725e21c05..9aae99d67833 100644
--- a/net/rxrpc/insecure.c
+++ b/net/rxrpc/insecure.c
@@ -14,6 +14,17 @@ static int none_init_connection_security(struct rxrpc_connection *conn,
 	return 0;
 }
 
+/*
+ * Work out how much data we can put in an unsecured packet.
+ */
+static int none_how_much_data(struct rxrpc_call *call, size_t remain,
+			       size_t *_buf_size, size_t *_data_size, size_t *_offset)
+{
+	*_buf_size = *_data_size = min_t(size_t, remain, RXRPC_JUMBO_DATALEN);
+	*_offset = 0;
+	return 0;
+}
+
 static int none_secure_packet(struct rxrpc_call *call, struct sk_buff *skb,
 			      size_t data_size)
 {
@@ -81,6 +92,7 @@ const struct rxrpc_security rxrpc_no_security = {
 	.exit				= none_exit,
 	.init_connection_security	= none_init_connection_security,
 	.free_call_crypto		= none_free_call_crypto,
+	.how_much_data			= none_how_much_data,
 	.secure_packet			= none_secure_packet,
 	.verify_packet			= none_verify_packet,
 	.locate_data			= none_locate_data,
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index e5b4bbdd0f34..e2e9e9b0a6d7 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -28,6 +28,7 @@
 #define INST_SZ				40	/* size of principal's instance */
 #define REALM_SZ			40	/* size of principal's auth domain */
 #define SNAME_SZ			40	/* size of service name */
+#define RXKAD_ALIGN			8
 
 struct rxkad_level1_hdr {
 	__be32	data_size;	/* true data size (excluding padding) */
@@ -80,7 +81,7 @@ static int rxkad_preparse_server_key(struct key_preparsed_payload *prep)
 
 static void rxkad_free_preparse_server_key(struct key_preparsed_payload *prep)
 {
-	
+
 	if (prep->payload.data[0])
 		crypto_free_skcipher(prep->payload.data[0]);
 }
@@ -119,14 +120,8 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn,
 
 	switch (conn->params.security_level) {
 	case RXRPC_SECURITY_PLAIN:
-		break;
 	case RXRPC_SECURITY_AUTH:
-		conn->size_align = 8;
-		conn->security_size = sizeof(struct rxkad_level1_hdr);
-		break;
 	case RXRPC_SECURITY_ENCRYPT:
-		conn->size_align = 8;
-		conn->security_size = sizeof(struct rxkad_level2_hdr);
 		break;
 	default:
 		ret = -EKEYREJECTED;
@@ -147,6 +142,40 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn,
 	return ret;
 }
 
+/*
+ * Work out how much data we can put in a packet.
+ */
+static int rxkad_how_much_data(struct rxrpc_call *call, size_t remain,
+			       size_t *_buf_size, size_t *_data_size, size_t *_offset)
+{
+	size_t shdr, buf_size, chunk;
+
+	switch (call->conn->params.security_level) {
+	default:
+		buf_size = chunk = min_t(size_t, remain, RXRPC_JUMBO_DATALEN);
+		shdr = 0;
+		goto out;
+	case RXRPC_SECURITY_AUTH:
+		shdr = sizeof(struct rxkad_level1_hdr);
+		break;
+	case RXRPC_SECURITY_ENCRYPT:
+		shdr = sizeof(struct rxkad_level2_hdr);
+		break;
+	}
+
+	buf_size = round_down(RXRPC_JUMBO_DATALEN, RXKAD_ALIGN);
+
+	chunk = buf_size - shdr;
+	if (remain < chunk)
+		buf_size = round_up(shdr + remain, RXKAD_ALIGN);
+
+out:
+	*_buf_size = buf_size;
+	*_data_size = chunk;
+	*_offset = shdr;
+	return 0;
+}
+
 /*
  * prime the encryption state with the invariant parts of a connection's
  * description
@@ -237,6 +266,7 @@ static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
 	struct rxkad_level1_hdr hdr;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg;
+	size_t pad;
 	u16 check;
 
 	_enter("");
@@ -247,6 +277,12 @@ static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
 	hdr.data_size = htonl(data_size);
 	memcpy(skb->head, &hdr, sizeof(hdr));
 
+	pad = sizeof(struct rxkad_level1_hdr) + data_size;
+	pad = RXKAD_ALIGN - pad;
+	pad &= RXKAD_ALIGN - 1;
+	if (pad)
+		skb_put_zero(skb, pad);
+
 	/* start the encryption afresh */
 	memset(&iv, 0, sizeof(iv));
 
@@ -275,6 +311,7 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[16];
 	unsigned int len;
+	size_t pad;
 	u16 check;
 	int err;
 
@@ -288,6 +325,12 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 	rxkhdr.checksum = 0;
 	memcpy(skb->head, &rxkhdr, sizeof(rxkhdr));
 
+	pad = sizeof(struct rxkad_level2_hdr) + data_size;
+	pad = RXKAD_ALIGN - pad;
+	pad &= RXKAD_ALIGN - 1;
+	if (pad)
+		skb_put_zero(skb, pad);
+
 	/* encrypt from the session key */
 	token = call->conn->params.key->payload.data[0];
 	memcpy(&iv, token->kad->session_key, sizeof(iv));
@@ -303,8 +346,7 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 	if (skb_shinfo(skb)->nr_frags > 16)
 		goto out;
 
-	len = data_size + call->conn->size_align - 1;
-	len &= ~(call->conn->size_align - 1);
+	len = round_up(data_size, RXKAD_ALIGN);
 
 	sg_init_table(sg, ARRAY_SIZE(sg));
 	err = skb_to_sgvec(skb, sg, 8, len);
@@ -1353,6 +1395,7 @@ const struct rxrpc_security rxkad = {
 	.free_preparse_server_key	= rxkad_free_preparse_server_key,
 	.destroy_server_key		= rxkad_destroy_server_key,
 	.init_connection_security	= rxkad_init_connection_security,
+	.how_much_data			= rxkad_how_much_data,
 	.secure_packet			= rxkad_secure_packet,
 	.verify_packet			= rxkad_verify_packet,
 	.free_call_crypto		= rxkad_free_call_crypto,
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 367654a558c2..af8ad6c30b9f 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -327,7 +327,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			rxrpc_send_ack_packet(call, false, NULL);
 
 		if (!skb) {
-			size_t size, chunk, max, space;
+			size_t remain, bufsize, chunk, offset;
 
 			_debug("alloc");
 
@@ -342,24 +342,21 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 					goto maybe_error;
 			}
 
-			max = RXRPC_JUMBO_DATALEN;
-			max -= call->conn->security_size;
-			max &= ~(call->conn->size_align - 1UL);
-
-			chunk = max;
-			if (chunk > msg_data_left(msg) && !more)
-				chunk = msg_data_left(msg);
-
-			space = chunk + call->conn->size_align;
-			space &= ~(call->conn->size_align - 1UL);
-
-			size = space + call->conn->security_size;
+			/* Work out the maximum size of a packet.  Assume that
+			 * the security header is going to be in the padded
+			 * region (enc blocksize), but the trailer is not.
+			 */
+			remain = more ? INT_MAX : msg_data_left(msg);
+			ret = call->conn->security->how_much_data(call, remain,
+								  &bufsize, &chunk, &offset);
+			if (ret < 0)
+				goto maybe_error;
 
-			_debug("SIZE: %zu/%zu/%zu", chunk, space, size);
+			_debug("SIZE: %zu/%zu @%zu", chunk, bufsize, offset);
 
 			/* create a buffer that we can retain until it's ACK'd */
 			skb = sock_alloc_send_skb(
-				sk, size, msg->msg_flags & MSG_DONTWAIT, &ret);
+				sk, bufsize, msg->msg_flags & MSG_DONTWAIT, &ret);
 			if (!skb)
 				goto maybe_error;
 
@@ -371,8 +368,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 			ASSERTCMP(skb->mark, ==, 0);
 
-			_debug("HS: %u", call->conn->security_size);
-			__skb_put(skb, call->conn->security_size);
+			__skb_put(skb, offset);
 
 			sp->remain = chunk;
 			if (sp->remain > skb_tailroom(skb))
@@ -421,17 +417,6 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 		    (msg_data_left(msg) == 0 && !more)) {
 			struct rxrpc_connection *conn = call->conn;
 			uint32_t seq;
-			size_t pad;
-
-			/* pad out if we're using security */
-			if (conn->security_ix) {
-				pad = conn->security_size + skb->mark;
-				pad = conn->size_align - pad;
-				pad &= conn->size_align - 1;
-				_debug("pad %zu", pad);
-				if (pad)
-					skb_put_zero(skb, pad);
-			}
 
 			seq = call->tx_top + 1;
 


