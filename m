Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41D0621F34
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiKHWYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiKHWWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:22:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234FC66CB6
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667946045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3D1ia0m8AB/mDYS6FkJb9nbysD705Rdesn/URHcv754=;
        b=OHtENbPFGWYkiWAKgax/YG0mQjjhrq70HZ5ZRBLse58JCv5mKOVZBTvo7vymYETSztJc8n
        0iFc05MIaD+GHV8MQVeOFoHsf7Lmb61JXE7SWCzyZaqtTAUO2WerWpXlsTxfN12oWjlvXi
        WMihcMS9S7DxeDqMxIadt+7nyuvnKMU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-URkEfA27MPqAzUYusPKYnw-1; Tue, 08 Nov 2022 17:20:41 -0500
X-MC-Unique: URkEfA27MPqAzUYusPKYnw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13F6F811E75;
        Tue,  8 Nov 2022 22:20:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FC3C492B05;
        Tue,  8 Nov 2022 22:20:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 26/26] rxrpc: Allocate an skcipher each time needed
 rather than reusing
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:20:39 +0000
Message-ID: <166794603977.2389296.8740762925692565028.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the rxkad security class, allocate the skcipher used to do packet
encryption and decription rather than allocating one up front and reusing
it for each packet.  Reusing the skcipher precludes doing crypto in
parallel.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    2 --
 net/rxrpc/rxkad.c       |   52 +++++++++++++++++++++++++----------------------
 2 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 6bbe28ecf583..0273a9029229 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -583,7 +583,6 @@ struct rxrpc_call {
 	unsigned long		expect_term_by;	/* When we expect call termination by */
 	u32			next_rx_timo;	/* Timeout for next Rx packet (jif) */
 	u32			next_req_timo;	/* Timeout for next Rx request packet (jif) */
-	struct skcipher_request	*cipher_req;	/* Packet cipher request buffer */
 	struct timer_list	timer;		/* Combined event timer */
 	struct work_struct	processor;	/* Event processor */
 	rxrpc_notify_rx_t	notify_rx;	/* kernel service Rx notification function */
@@ -597,7 +596,6 @@ struct rxrpc_call {
 	struct rxrpc_txbuf	*tx_pending;	/* Tx buffer being filled */
 	wait_queue_head_t	waitq;		/* Wait queue for channel or Tx */
 	s64			tx_total_len;	/* Total length left to be transmitted (or -1) */
-	__be32			crypto_buf[2];	/* Temporary packet crypto buffer */
 	unsigned long		user_call_ID;	/* user-defined call ID */
 	unsigned long		flags;
 	unsigned long		events;
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 8fc055587f0e..2706e59bf992 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -233,16 +233,8 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
 static struct skcipher_request *rxkad_get_call_crypto(struct rxrpc_call *call)
 {
 	struct crypto_skcipher *tfm = &call->conn->rxkad.cipher->base;
-	struct skcipher_request	*cipher_req = call->cipher_req;
 
-	if (!cipher_req) {
-		cipher_req = skcipher_request_alloc(tfm, GFP_NOFS);
-		if (!cipher_req)
-			return NULL;
-		call->cipher_req = cipher_req;
-	}
-
-	return cipher_req;
+	return skcipher_request_alloc(tfm, GFP_NOFS);
 }
 
 /*
@@ -250,9 +242,6 @@ static struct skcipher_request *rxkad_get_call_crypto(struct rxrpc_call *call)
  */
 static void rxkad_free_call_crypto(struct rxrpc_call *call)
 {
-	if (call->cipher_req)
-		skcipher_request_free(call->cipher_req);
-	call->cipher_req = NULL;
 }
 
 /*
@@ -348,6 +337,9 @@ static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	struct skcipher_request	*req;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg;
+	union {
+		__be32 buf[2];
+	} crypto __aligned(8);
 	u32 x, y;
 	int ret;
 
@@ -372,17 +364,17 @@ static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	/* calculate the security checksum */
 	x = (ntohl(txb->wire.cid) & RXRPC_CHANNELMASK) << (32 - RXRPC_CIDSHIFT);
 	x |= txb->seq & 0x3fffffff;
-	call->crypto_buf[0] = txb->wire.callNumber;
-	call->crypto_buf[1] = htonl(x);
+	crypto.buf[0] = txb->wire.callNumber;
+	crypto.buf[1] = htonl(x);
 
-	sg_init_one(&sg, call->crypto_buf, 8);
+	sg_init_one(&sg, crypto.buf, 8);
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
 	crypto_skcipher_encrypt(req);
 	skcipher_request_zero(req);
 
-	y = ntohl(call->crypto_buf[1]);
+	y = ntohl(crypto.buf[1]);
 	y = (y >> 16) & 0xffff;
 	if (y == 0)
 		y = 1; /* zero checksums are not permitted */
@@ -403,6 +395,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 		break;
 	}
 
+	skcipher_request_free(req);
 	_leave(" = %d [set %x]", ret, y);
 	return ret;
 }
@@ -593,8 +586,12 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 	struct skcipher_request	*req;
 	struct rxrpc_crypt iv;
 	struct scatterlist sg;
+	union {
+		__be32 buf[2];
+	} crypto __aligned(8);
 	rxrpc_seq_t seq = sp->hdr.seq;
 	bool aborted;
+	int ret;
 	u16 cksum;
 	u32 x, y;
 
@@ -614,17 +611,17 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 	/* validate the security checksum */
 	x = (call->cid & RXRPC_CHANNELMASK) << (32 - RXRPC_CIDSHIFT);
 	x |= seq & 0x3fffffff;
-	call->crypto_buf[0] = htonl(call->call_id);
-	call->crypto_buf[1] = htonl(x);
+	crypto.buf[0] = htonl(call->call_id);
+	crypto.buf[1] = htonl(x);
 
-	sg_init_one(&sg, call->crypto_buf, 8);
+	sg_init_one(&sg, crypto.buf, 8);
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, 8, iv.x);
 	crypto_skcipher_encrypt(req);
 	skcipher_request_zero(req);
 
-	y = ntohl(call->crypto_buf[1]);
+	y = ntohl(crypto.buf[1]);
 	cksum = (y >> 16) & 0xffff;
 	if (cksum == 0)
 		cksum = 1; /* zero checksums are not permitted */
@@ -637,15 +634,22 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 
 	switch (call->conn->params.security_level) {
 	case RXRPC_SECURITY_PLAIN:
-		return 0;
+		ret = 0;
+		break;
 	case RXRPC_SECURITY_AUTH:
-		return rxkad_verify_packet_1(call, skb, seq, req);
+		ret = rxkad_verify_packet_1(call, skb, seq, req);
+		break;
 	case RXRPC_SECURITY_ENCRYPT:
-		return rxkad_verify_packet_2(call, skb, seq, req);
+		ret = rxkad_verify_packet_2(call, skb, seq, req);
+		break;
 	default:
-		return -ENOANO;
+		ret = -ENOANO;
+		break;
 	}
 
+	skcipher_request_free(req);
+	return ret;
+
 protocol_error:
 	if (aborted)
 		rxrpc_send_abort_packet(call);


