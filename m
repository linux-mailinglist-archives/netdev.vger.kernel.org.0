Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCC32801F4
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732514AbgJAO7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:59:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732299AbgJAO7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:59:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y+JI7KWNi2VOJ84A4vmm95sPOKFV8bYNL8+REuBAaDU=;
        b=OpLeGURCVHyiPeDoL1PqaqyMrrsJeqv1OZk8vSifiBKtu1+x6jsgtiFBQrlwUuzVw7w1V9
        bODQ7kzyOW0SZSMmAyGXp8oRe7STPrQXx8RkxXePXGcGwJiS1hulDPeKw68I/GJBQpoIxA
        QLM/KrTgxQKRi/44mkjXg99soLW0QmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238--S7Mai-JNO6JFfAmLSIZCw-1; Thu, 01 Oct 2020 10:58:57 -0400
X-MC-Unique: -S7Mai-JNO6JFfAmLSIZCw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3E161062722;
        Thu,  1 Oct 2020 14:58:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F02A019C78;
        Thu,  1 Oct 2020 14:58:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 19/23] rxrpc: Organise connection security to use a
 union
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:58:55 +0100
Message-ID: <160156433519.1728886.13110365075593728765.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Organise the security information in the rxrpc_connection struct to use a
union to allow for different data for different security classes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |   11 ++++++++---
 net/rxrpc/rxkad.c       |   40 ++++++++++++++++++++--------------------
 2 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index f314b7a33d37..af4dfb2a23bf 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -445,9 +445,15 @@ struct rxrpc_connection {
 	struct list_head	proc_link;	/* link in procfs list */
 	struct list_head	link;		/* link in master connection list */
 	struct sk_buff_head	rx_queue;	/* received conn-level packets */
+
 	const struct rxrpc_security *security;	/* applied security module */
-	struct crypto_sync_skcipher *cipher;	/* encryption handle */
-	struct rxrpc_crypt	csum_iv;	/* packet checksum base */
+	union {
+		struct {
+			struct crypto_sync_skcipher *cipher;	/* encryption handle */
+			struct rxrpc_crypt csum_iv;	/* packet checksum base */
+			u32	nonce;		/* response re-use preventer */
+		} rxkad;
+	};
 	unsigned long		flags;
 	unsigned long		events;
 	unsigned long		idle_timestamp;	/* Time at which last became idle */
@@ -457,7 +463,6 @@ struct rxrpc_connection {
 	int			debug_id;	/* debug ID for printks */
 	atomic_t		serial;		/* packet serial number counter */
 	unsigned int		hi_serial;	/* highest serial number received */
-	u32			security_nonce;	/* response re-use preventer */
 	u32			service_id;	/* Service ID, possibly upgraded */
 	u8			size_align;	/* data size alignment (for security) */
 	u8			security_size;	/* security header size */
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 37335d887570..f3182edfcbae 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -137,7 +137,7 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn,
 	if (ret < 0)
 		goto error_ci;
 
-	conn->cipher = ci;
+	conn->rxkad.cipher = ci;
 	return 0;
 
 error_ci:
@@ -191,7 +191,7 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
 	crypto_skcipher_encrypt(req);
 	skcipher_request_free(req);
 
-	memcpy(&conn->csum_iv, tmpbuf + 2, sizeof(conn->csum_iv));
+	memcpy(&conn->rxkad.csum_iv, tmpbuf + 2, sizeof(conn->rxkad.csum_iv));
 	kfree(tmpbuf);
 	_leave(" = 0");
 	return 0;
@@ -203,7 +203,7 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
  */
 static struct skcipher_request *rxkad_get_call_crypto(struct rxrpc_call *call)
 {
-	struct crypto_skcipher *tfm = &call->conn->cipher->base;
+	struct crypto_skcipher *tfm = &call->conn->rxkad.cipher->base;
 	struct skcipher_request	*cipher_req = call->cipher_req;
 
 	if (!cipher_req) {
@@ -251,7 +251,7 @@ static int rxkad_secure_packet_auth(const struct rxrpc_call *call,
 	memset(&iv, 0, sizeof(iv));
 
 	sg_init_one(&sg, skb->head, 8);
-	skcipher_request_set_sync_tfm(req, call->conn->cipher);
+	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
 	crypto_skcipher_encrypt(req);
@@ -293,7 +293,7 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 	memcpy(&iv, token->kad->session_key, sizeof(iv));
 
 	sg_init_one(&sg[0], skb->head, sizeof(rxkhdr));
-	skcipher_request_set_sync_tfm(req, call->conn->cipher);
+	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg[0], &sg[0], sizeof(rxkhdr), iv.x);
 	crypto_skcipher_encrypt(req);
@@ -341,7 +341,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
 	       call->debug_id, key_serial(call->conn->params.key),
 	       sp->hdr.seq, data_size);
 
-	if (!call->conn->cipher)
+	if (!call->conn->rxkad.cipher)
 		return 0;
 
 	ret = key_validate(call->conn->params.key);
@@ -353,7 +353,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
 		return -ENOMEM;
 
 	/* continue encrypting from where we left off */
-	memcpy(&iv, call->conn->csum_iv.x, sizeof(iv));
+	memcpy(&iv, call->conn->rxkad.csum_iv.x, sizeof(iv));
 
 	/* calculate the security checksum */
 	x = (call->cid & RXRPC_CHANNELMASK) << (32 - RXRPC_CIDSHIFT);
@@ -362,7 +362,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call,
 	call->crypto_buf[1] = htonl(x);
 
 	sg_init_one(&sg, call->crypto_buf, 8);
-	skcipher_request_set_sync_tfm(req, call->conn->cipher);
+	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
 	crypto_skcipher_encrypt(req);
@@ -428,7 +428,7 @@ static int rxkad_verify_packet_1(struct rxrpc_call *call, struct sk_buff *skb,
 	/* start the decryption afresh */
 	memset(&iv, 0, sizeof(iv));
 
-	skcipher_request_set_sync_tfm(req, call->conn->cipher);
+	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, sg, 8, iv.x);
 	crypto_skcipher_decrypt(req);
@@ -520,7 +520,7 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	token = call->conn->params.key->payload.data[0];
 	memcpy(&iv, token->kad->session_key, sizeof(iv));
 
-	skcipher_request_set_sync_tfm(req, call->conn->cipher);
+	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, sg, len, iv.x);
 	crypto_skcipher_decrypt(req);
@@ -586,7 +586,7 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	_enter("{%d{%x}},{#%u}",
 	       call->debug_id, key_serial(call->conn->params.key), seq);
 
-	if (!call->conn->cipher)
+	if (!call->conn->rxkad.cipher)
 		return 0;
 
 	req = rxkad_get_call_crypto(call);
@@ -594,7 +594,7 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
 		return -ENOMEM;
 
 	/* continue encrypting from where we left off */
-	memcpy(&iv, call->conn->csum_iv.x, sizeof(iv));
+	memcpy(&iv, call->conn->rxkad.csum_iv.x, sizeof(iv));
 
 	/* validate the security checksum */
 	x = (call->cid & RXRPC_CHANNELMASK) << (32 - RXRPC_CIDSHIFT);
@@ -603,7 +603,7 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	call->crypto_buf[1] = htonl(x);
 
 	sg_init_one(&sg, call->crypto_buf, 8);
-	skcipher_request_set_sync_tfm(req, call->conn->cipher);
+	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
 	crypto_skcipher_encrypt(req);
@@ -698,10 +698,10 @@ static int rxkad_issue_challenge(struct rxrpc_connection *conn)
 
 	_enter("{%d}", conn->debug_id);
 
-	get_random_bytes(&conn->security_nonce, sizeof(conn->security_nonce));
+	get_random_bytes(&conn->rxkad.nonce, sizeof(conn->rxkad.nonce));
 
 	challenge.version	= htonl(2);
-	challenge.nonce		= htonl(conn->security_nonce);
+	challenge.nonce		= htonl(conn->rxkad.nonce);
 	challenge.min_level	= htonl(0);
 	challenge.__padding	= 0;
 
@@ -829,7 +829,7 @@ static int rxkad_encrypt_response(struct rxrpc_connection *conn,
 	struct rxrpc_crypt iv;
 	struct scatterlist sg[1];
 
-	req = skcipher_request_alloc(&conn->cipher->base, GFP_NOFS);
+	req = skcipher_request_alloc(&conn->rxkad.cipher->base, GFP_NOFS);
 	if (!req)
 		return -ENOMEM;
 
@@ -838,7 +838,7 @@ static int rxkad_encrypt_response(struct rxrpc_connection *conn,
 
 	sg_init_table(sg, 1);
 	sg_set_buf(sg, &resp->encrypted, sizeof(resp->encrypted));
-	skcipher_request_set_sync_tfm(req, conn->cipher);
+	skcipher_request_set_sync_tfm(req, conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, sg, sizeof(resp->encrypted), iv.x);
 	crypto_skcipher_encrypt(req);
@@ -1249,7 +1249,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 
 	eproto = tracepoint_string("rxkad_rsp_seq");
 	abort_code = RXKADOUTOFSEQUENCE;
-	if (ntohl(response->encrypted.inc_nonce) != conn->security_nonce + 1)
+	if (ntohl(response->encrypted.inc_nonce) != conn->rxkad.nonce + 1)
 		goto protocol_error_free;
 
 	eproto = tracepoint_string("rxkad_rsp_level");
@@ -1302,8 +1302,8 @@ static void rxkad_clear(struct rxrpc_connection *conn)
 {
 	_enter("");
 
-	if (conn->cipher)
-		crypto_free_sync_skcipher(conn->cipher);
+	if (conn->rxkad.cipher)
+		crypto_free_sync_skcipher(conn->rxkad.cipher);
 }
 
 /*


