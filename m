Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AC82C1629
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732937AbgKWULn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:11:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732597AbgKWULm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:11:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606162300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VILtSbrWguqcwGbYs1fq5uCRIgrhXgGibPCBbk+7Iu4=;
        b=h4/4e5lwFp3X6lyWfi8kyn2pOe8GYOis/uZrahVTS95ywYxUIh56s2+edSibyulSpgYkjO
        arIrAHLPAClUQThhOZRB4So/Ji50WbK7KL/uAkl5SnQqVLAX3eZs15bZlMIFqOv6/EeipP
        w8QIJa1QujZo1zZG4HF49u4Z1mY7mVI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-uEUwuNUiM7iVnqCz3QpfQg-1; Mon, 23 Nov 2020 15:11:37 -0500
X-MC-Unique: uEUwuNUiM7iVnqCz3QpfQg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C24A61084C81;
        Mon, 23 Nov 2020 20:11:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A92E819D9F;
        Mon, 23 Nov 2020 20:11:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 13/17] rxrpc: Merge prime_packet_security into
 init_connection_security
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 20:11:34 +0000
Message-ID: <160616229484.830164.5485017699725233871.stgit@warthog.procyon.org.uk>
In-Reply-To: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
References: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge the ->prime_packet_security() into the ->init_connection_security()
hook as they're always called together.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    2 --
 net/rxrpc/conn_client.c |    6 ------
 net/rxrpc/conn_event.c  |    4 ----
 net/rxrpc/insecure.c    |    6 ------
 net/rxrpc/rxkad.c       |   20 +++++++++++++++-----
 5 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 0fb294725ff2..6aaa0f49dab0 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -234,8 +234,6 @@ struct rxrpc_security {
 	int (*init_connection_security)(struct rxrpc_connection *,
 					struct rxrpc_key_token *);
 
-	/* prime a connection's packet security */
-	int (*prime_packet_security)(struct rxrpc_connection *);
 
 	/* impose security on a packet */
 	int (*secure_packet)(struct rxrpc_call *,
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 7e574c75be8e..dbea0bfee48e 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -180,10 +180,6 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 	if (ret < 0)
 		goto error_1;
 
-	ret = conn->security->prime_packet_security(conn);
-	if (ret < 0)
-		goto error_2;
-
 	atomic_inc(&rxnet->nr_conns);
 	write_lock(&rxnet->conn_lock);
 	list_add_tail(&conn->proc_link, &rxnet->conn_proc_list);
@@ -203,8 +199,6 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 	_leave(" = %p", conn);
 	return conn;
 
-error_2:
-	conn->security->clear(conn);
 error_1:
 	rxrpc_put_client_connection_id(conn);
 error_0:
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 03a482ba770f..aab069701398 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -338,10 +338,6 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 		if (ret < 0)
 			return ret;
 
-		ret = conn->security->prime_packet_security(conn);
-		if (ret < 0)
-			return ret;
-
 		spin_lock(&conn->bundle->channel_lock);
 		spin_lock_bh(&conn->state_lock);
 
diff --git a/net/rxrpc/insecure.c b/net/rxrpc/insecure.c
index cf3ecffcf424..914e2f2e2990 100644
--- a/net/rxrpc/insecure.c
+++ b/net/rxrpc/insecure.c
@@ -14,11 +14,6 @@ static int none_init_connection_security(struct rxrpc_connection *conn,
 	return 0;
 }
 
-static int none_prime_packet_security(struct rxrpc_connection *conn)
-{
-	return 0;
-}
-
 static int none_secure_packet(struct rxrpc_call *call,
 			      struct sk_buff *skb,
 			      size_t data_size,
@@ -87,7 +82,6 @@ const struct rxrpc_security rxrpc_no_security = {
 	.init				= none_init,
 	.exit				= none_exit,
 	.init_connection_security	= none_init_connection_security,
-	.prime_packet_security		= none_prime_packet_security,
 	.free_call_crypto		= none_free_call_crypto,
 	.secure_packet			= none_secure_packet,
 	.verify_packet			= none_verify_packet,
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 3057f00a6978..301894857473 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -38,6 +38,9 @@ struct rxkad_level2_hdr {
 	__be32	checksum;	/* decrypted data checksum */
 };
 
+static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
+				       struct crypto_sync_skcipher *ci);
+
 /*
  * this holds a pinned cipher so that keventd doesn't get called by the cipher
  * alloc routine, but since we have it to hand, we use it to decrypt RESPONSE
@@ -130,8 +133,15 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn,
 		goto error;
 	}
 
+	ret = rxkad_prime_packet_security(conn, ci);
+	if (ret < 0)
+		goto error_ci;
+
 	conn->cipher = ci;
-	ret = 0;
+	return 0;
+
+error_ci:
+	crypto_free_sync_skcipher(ci);
 error:
 	_leave(" = %d", ret);
 	return ret;
@@ -141,7 +151,8 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn,
  * prime the encryption state with the invariant parts of a connection's
  * description
  */
-static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
+static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
+				       struct crypto_sync_skcipher *ci)
 {
 	struct skcipher_request *req;
 	struct rxrpc_key_token *token;
@@ -159,7 +170,7 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
 	if (!tmpbuf)
 		return -ENOMEM;
 
-	req = skcipher_request_alloc(&conn->cipher->base, GFP_NOFS);
+	req = skcipher_request_alloc(&ci->base, GFP_NOFS);
 	if (!req) {
 		kfree(tmpbuf);
 		return -ENOMEM;
@@ -174,7 +185,7 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
 	tmpbuf[3] = htonl(conn->security_ix);
 
 	sg_init_one(&sg, tmpbuf, tmpsize);
-	skcipher_request_set_sync_tfm(req, conn->cipher);
+	skcipher_request_set_sync_tfm(req, ci);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, tmpsize, iv.x);
 	crypto_skcipher_encrypt(req);
@@ -1350,7 +1361,6 @@ const struct rxrpc_security rxkad = {
 	.free_preparse_server_key	= rxkad_free_preparse_server_key,
 	.destroy_server_key		= rxkad_destroy_server_key,
 	.init_connection_security	= rxkad_init_connection_security,
-	.prime_packet_security		= rxkad_prime_packet_security,
 	.secure_packet			= rxkad_secure_packet,
 	.verify_packet			= rxkad_verify_packet,
 	.free_call_crypto		= rxkad_free_call_crypto,


