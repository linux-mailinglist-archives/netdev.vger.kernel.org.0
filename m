Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC1E2801EB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732812AbgJAO6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:58:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732529AbgJAO6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TzZuaqthOs9w/abIr+5uJdBSacaQOWMkEyuo71c+Wyc=;
        b=N11dVF8/Q4wP3Bz3hhuV1OkovfRC68Y9Ko1hWhSPS05CwV55JJeT3DreSGt8zTqu+UGfNv
        JpcZQjb2AqI48b8zIB3FGmx30Mi2GIO/bR93v91Ly9bFHKBz2Y34hHFfa/aoX2+4yj97N4
        3PlJp9629PvxqUaxYbGVgntWHkkp8sw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-yUJx6x3VMmKBhayAVElXsw-1; Thu, 01 Oct 2020 10:58:16 -0400
X-MC-Unique: yUJx6x3VMmKBhayAVElXsw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1560918CBC43;
        Thu,  1 Oct 2020 14:58:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 258C95C1D0;
        Thu,  1 Oct 2020 14:58:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 13/23] rxrpc: Merge prime_packet_security into
 init_connection_security
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:58:13 +0100
Message-ID: <160156429325.1728886.13596879825837068396.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 5aacd6d7cf28..a3b3901bc7f7 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -219,8 +219,6 @@ struct rxrpc_security {
 	/* initialise a connection's security */
 	int (*init_connection_security)(struct rxrpc_connection *);
 
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
index aff184145ffa..abe761c66f67 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -337,10 +337,6 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 		if (ret < 0)
 			return ret;
 
-		ret = conn->security->prime_packet_security(conn);
-		if (ret < 0)
-			return ret;
-
 		spin_lock(&conn->bundle->channel_lock);
 		spin_lock_bh(&conn->state_lock);
 
diff --git a/net/rxrpc/insecure.c b/net/rxrpc/insecure.c
index f6c59f5fae9d..a9c3959810ea 100644
--- a/net/rxrpc/insecure.c
+++ b/net/rxrpc/insecure.c
@@ -13,11 +13,6 @@ static int none_init_connection_security(struct rxrpc_connection *conn)
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
@@ -86,7 +81,6 @@ const struct rxrpc_security rxrpc_no_security = {
 	.init				= none_init,
 	.exit				= none_exit,
 	.init_connection_security	= none_init_connection_security,
-	.prime_packet_security		= none_prime_packet_security,
 	.free_call_crypto		= none_free_call_crypto,
 	.secure_packet			= none_secure_packet,
 	.verify_packet			= none_verify_packet,
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index f114dc2af5cf..5e10e0f9d7b7 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -37,6 +37,9 @@ struct rxkad_level2_hdr {
 	__be32	checksum;	/* decrypted data checksum */
 };
 
+static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
+				       struct crypto_sync_skcipher *ci);
+
 /*
  * this holds a pinned cipher so that keventd doesn't get called by the cipher
  * alloc routine, but since we have it to hand, we use it to decrypt RESPONSE
@@ -87,8 +90,15 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn)
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
@@ -98,7 +108,8 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn)
  * prime the encryption state with the invariant parts of a connection's
  * description
  */
-static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
+static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
+				       struct crypto_sync_skcipher *ci)
 {
 	struct skcipher_request *req;
 	struct rxrpc_key_token *token;
@@ -116,7 +127,7 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
 	if (!tmpbuf)
 		return -ENOMEM;
 
-	req = skcipher_request_alloc(&conn->cipher->base, GFP_NOFS);
+	req = skcipher_request_alloc(&ci->base, GFP_NOFS);
 	if (!req) {
 		kfree(tmpbuf);
 		return -ENOMEM;
@@ -131,7 +142,7 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn)
 	tmpbuf[3] = htonl(conn->security_ix);
 
 	sg_init_one(&sg, tmpbuf, tmpsize);
-	skcipher_request_set_sync_tfm(req, conn->cipher);
+	skcipher_request_set_sync_tfm(req, ci);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, tmpsize, iv.x);
 	crypto_skcipher_encrypt(req);
@@ -1297,7 +1308,6 @@ const struct rxrpc_security rxkad = {
 	.init				= rxkad_init,
 	.exit				= rxkad_exit,
 	.init_connection_security	= rxkad_init_connection_security,
-	.prime_packet_security		= rxkad_prime_packet_security,
 	.secure_packet			= rxkad_secure_packet,
 	.verify_packet			= rxkad_verify_packet,
 	.free_call_crypto		= rxkad_free_call_crypto,


