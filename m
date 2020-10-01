Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A05D2801E9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732860AbgJAO6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:58:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732811AbgJAO6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:58:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a+Rd/b32Wfchl3Hm23n7fCZXfky5k/9yq1S9kMdiugU=;
        b=HUhevk0GrB21jUHzZte77FuCEvDK1msgJ75MjGHIC8Ij7gWT9erai+Pviqtmgd/BHQatr+
        Sxx3JXuaDO0oa+k+Kl84/VQD5WPqUTHmlUjOLo/RIa60sLy9kW8CzK733ae63qcdotRKMl
        /RZouOreG3F9W/IOtbp8Roc/bNE7bpY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-3CriZKEePsq9h4zLD7AzCg-1; Thu, 01 Oct 2020 10:58:30 -0400
X-MC-Unique: 3CriZKEePsq9h4zLD7AzCg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02A39AE821;
        Thu,  1 Oct 2020 14:58:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F26176CE4D;
        Thu,  1 Oct 2020 14:58:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 15/23] rxrpc: Don't retain the server key in the
 connection
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:58:27 +0100
Message-ID: <160156430724.1728886.3228914863722869610.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't retain a pointer to the server key in the connection, but rather get
it on demand when the server has to deal with a response packet.

This is necessary to implement RxGK (GSSAPI-mediated transport class),
where we can't know which key we'll need until we've challenged the client
and got back the response.

This also means that we don't need to do a key search in the accept path in
softirq mode.

Also, whilst we're at it, allow the security class to ask for a kvno and
encoding-type variant of a server key as RxGK needs different keys for
different encoding types.  Keys of this type have an extra bit in the
description:

	"<service-id>:<security-index>:<kvno>:<enctype>"

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h  |   11 +++---
 net/rxrpc/call_accept.c  |   14 ++++----
 net/rxrpc/conn_event.c   |    1 -
 net/rxrpc/conn_object.c  |    1 -
 net/rxrpc/conn_service.c |    2 -
 net/rxrpc/rxkad.c        |   57 ++++++++++++++++++--------------
 net/rxrpc/security.c     |   81 ++++++++++++++++++++++++++++++++--------------
 7 files changed, 100 insertions(+), 67 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index c8f821c17d5b..1b39a2158ba3 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -439,7 +439,6 @@ struct rxrpc_connection {
 	struct list_head	link;		/* link in master connection list */
 	struct sk_buff_head	rx_queue;	/* received conn-level packets */
 	const struct rxrpc_security *security;	/* applied security module */
-	struct key		*server_key;	/* security for this service */
 	struct crypto_sync_skcipher *cipher;	/* encryption handle */
 	struct rxrpc_crypt	csum_iv;	/* packet checksum base */
 	unsigned long		flags;
@@ -889,8 +888,7 @@ struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *,
 						     struct sk_buff *);
 struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *, gfp_t);
 void rxrpc_new_incoming_connection(struct rxrpc_sock *, struct rxrpc_connection *,
-				   const struct rxrpc_security *, struct key *,
-				   struct sk_buff *);
+				   const struct rxrpc_security *, struct sk_buff *);
 void rxrpc_unpublish_service_conn(struct rxrpc_connection *);
 
 /*
@@ -1055,9 +1053,10 @@ extern const struct rxrpc_security rxkad;
 int __init rxrpc_init_security(void);
 void rxrpc_exit_security(void);
 int rxrpc_init_client_conn_security(struct rxrpc_connection *);
-bool rxrpc_look_up_server_security(struct rxrpc_local *, struct rxrpc_sock *,
-				   const struct rxrpc_security **, struct key **,
-				   struct sk_buff *);
+const struct rxrpc_security *rxrpc_get_incoming_security(struct rxrpc_sock *,
+							 struct sk_buff *);
+struct key *rxrpc_look_up_server_security(struct rxrpc_connection *,
+					  struct sk_buff *, u32, u32);
 
 /*
  * sendmsg.c
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 8df1964db333..382add72c66f 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -261,7 +261,6 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 						    struct rxrpc_peer *peer,
 						    struct rxrpc_connection *conn,
 						    const struct rxrpc_security *sec,
-						    struct key *key,
 						    struct sk_buff *skb)
 {
 	struct rxrpc_backlog *b = rx->backlog;
@@ -309,7 +308,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 		conn->params.local = rxrpc_get_local(local);
 		conn->params.peer = peer;
 		rxrpc_see_connection(conn);
-		rxrpc_new_incoming_connection(rx, conn, sec, key, skb);
+		rxrpc_new_incoming_connection(rx, conn, sec, skb);
 	} else {
 		rxrpc_get_connection(conn);
 	}
@@ -353,7 +352,6 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	struct rxrpc_connection *conn;
 	struct rxrpc_peer *peer = NULL;
 	struct rxrpc_call *call = NULL;
-	struct key *key = NULL;
 
 	_enter("");
 
@@ -374,11 +372,13 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	 */
 	conn = rxrpc_find_connection_rcu(local, skb, &peer);
 
-	if (!conn && !rxrpc_look_up_server_security(local, rx, &sec, &key, skb))
-		goto no_call;
+	if (!conn) {
+		sec = rxrpc_get_incoming_security(rx, skb);
+		if (!sec)
+			goto no_call;
+	}
 
-	call = rxrpc_alloc_incoming_call(rx, local, peer, conn, sec, key, skb);
-	key_put(key);
+	call = rxrpc_alloc_incoming_call(rx, local, peer, conn, sec, skb);
 	if (!call) {
 		skb->mark = RXRPC_SKB_MARK_REJECT_BUSY;
 		goto no_call;
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 75139a3d015a..aab069701398 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -374,7 +374,6 @@ static void rxrpc_secure_connection(struct rxrpc_connection *conn)
 	_enter("{%d}", conn->debug_id);
 
 	ASSERT(conn->security_ix != 0);
-	ASSERT(conn->server_key);
 
 	if (conn->security->issue_challenge(conn) < 0) {
 		abort_code = RX_CALL_DEAD;
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index d84db9eb9a85..b0d27ad21063 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -363,7 +363,6 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 
 	conn->security->clear(conn);
 	key_put(conn->params.key);
-	key_put(conn->server_key);
 	rxrpc_put_bundle(conn->bundle);
 	rxrpc_put_peer(conn->params.peer);
 
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 6c847720494f..e1966dfc9152 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -156,7 +156,6 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
 				   struct rxrpc_connection *conn,
 				   const struct rxrpc_security *sec,
-				   struct key *key,
 				   struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -170,7 +169,6 @@ void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
 	conn->security_ix	= sp->hdr.securityIndex;
 	conn->out_clientflag	= 0;
 	conn->security		= sec;
-	conn->server_key	= key_get(key);
 	if (conn->security_ix)
 		conn->state	= RXRPC_CONN_SERVICE_UNSECURED;
 	else
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 4ca9ca95d2bf..554c8b931867 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -658,11 +658,7 @@ static int rxkad_issue_challenge(struct rxrpc_connection *conn)
 	u32 serial;
 	int ret;
 
-	_enter("{%d,%x}", conn->debug_id, key_serial(conn->server_key));
-
-	ret = key_validate(conn->server_key);
-	if (ret < 0)
-		return ret;
+	_enter("{%d}", conn->debug_id);
 
 	get_random_bytes(&conn->security_nonce, sizeof(conn->security_nonce));
 
@@ -902,6 +898,7 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
  * decrypt the kerberos IV ticket in the response
  */
 static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
+				struct key *server_key,
 				struct sk_buff *skb,
 				void *ticket, size_t ticket_len,
 				struct rxrpc_crypt *_session_key,
@@ -921,30 +918,17 @@ static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
 	u32 abort_code;
 	u8 *p, *q, *name, *end;
 
-	_enter("{%d},{%x}", conn->debug_id, key_serial(conn->server_key));
+	_enter("{%d},{%x}", conn->debug_id, key_serial(server_key));
 
 	*_expiry = 0;
 
-	ret = key_validate(conn->server_key);
-	if (ret < 0) {
-		switch (ret) {
-		case -EKEYEXPIRED:
-			abort_code = RXKADEXPIRED;
-			goto other_error;
-		default:
-			abort_code = RXKADNOAUTH;
-			goto other_error;
-		}
-	}
-
-	ASSERT(conn->server_key->payload.data[0] != NULL);
+	ASSERT(server_key->payload.data[0] != NULL);
 	ASSERTCMP((unsigned long) ticket & 7UL, ==, 0);
 
-	memcpy(&iv, &conn->server_key->payload.data[2], sizeof(iv));
+	memcpy(&iv, &server_key->payload.data[2], sizeof(iv));
 
 	ret = -ENOMEM;
-	req = skcipher_request_alloc(conn->server_key->payload.data[0],
-				     GFP_NOFS);
+	req = skcipher_request_alloc(server_key->payload.data[0], GFP_NOFS);
 	if (!req)
 		goto temporary_error;
 
@@ -1100,6 +1084,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	struct rxkad_response *response;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_crypt session_key;
+	struct key *server_key;
 	const char *eproto;
 	time64_t expiry;
 	void *ticket;
@@ -1107,7 +1092,27 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	__be32 csum;
 	int ret, i;
 
-	_enter("{%d,%x}", conn->debug_id, key_serial(conn->server_key));
+	_enter("{%d}", conn->debug_id);
+
+	server_key = rxrpc_look_up_server_security(conn, skb, 0, 0);
+	if (IS_ERR(server_key)) {
+		switch (PTR_ERR(server_key)) {
+		case -ENOKEY:
+			abort_code = RXKADUNKNOWNKEY;
+			break;
+		case -EKEYEXPIRED:
+			abort_code = RXKADEXPIRED;
+			break;
+		default:
+			abort_code = RXKADNOAUTH;
+			break;
+		}
+		trace_rxrpc_abort(0, "SVK",
+				  sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+				  abort_code, PTR_ERR(server_key));
+		*_abort_code = abort_code;
+		return -EPROTO;
+	}
 
 	ret = -ENOMEM;
 	response = kzalloc(sizeof(struct rxkad_response), GFP_NOFS);
@@ -1155,8 +1160,8 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 			  ticket, ticket_len) < 0)
 		goto protocol_error_free;
 
-	ret = rxkad_decrypt_ticket(conn, skb, ticket, ticket_len, &session_key,
-				   &expiry, _abort_code);
+	ret = rxkad_decrypt_ticket(conn, server_key, skb, ticket, ticket_len,
+				   &session_key, &expiry, _abort_code);
 	if (ret < 0)
 		goto temporary_error_free_ticket;
 
@@ -1235,6 +1240,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 protocol_error:
 	kfree(response);
 	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial, eproto);
+	key_put(server_key);
 	*_abort_code = abort_code;
 	return -EPROTO;
 
@@ -1247,6 +1253,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	 * ENOMEM.  We just want to send the challenge again.  Note that we
 	 * also come out this way if the ticket decryption fails.
 	 */
+	key_put(server_key);
 	return ret;
 }
 
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index 0c5168f52bd6..bef9971e15cd 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -102,22 +102,16 @@ int rxrpc_init_client_conn_security(struct rxrpc_connection *conn)
 }
 
 /*
- * Find the security key for a server connection.
+ * Set the ops a server connection.
  */
-bool rxrpc_look_up_server_security(struct rxrpc_local *local, struct rxrpc_sock *rx,
-				   const struct rxrpc_security **_sec,
-				   struct key **_key,
-				   struct sk_buff *skb)
+const struct rxrpc_security *rxrpc_get_incoming_security(struct rxrpc_sock *rx,
+							 struct sk_buff *skb)
 {
 	const struct rxrpc_security *sec;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	key_ref_t kref = NULL;
-	char kdesc[5 + 1 + 3 + 1];
 
 	_enter("");
 
-	sprintf(kdesc, "%u:%u", sp->hdr.serviceId, sp->hdr.securityIndex);
-
 	sec = rxrpc_security_lookup(sp->hdr.securityIndex);
 	if (!sec) {
 		trace_rxrpc_abort(0, "SVS",
@@ -125,35 +119,72 @@ bool rxrpc_look_up_server_security(struct rxrpc_local *local, struct rxrpc_sock
 				  RX_INVALID_OPERATION, EKEYREJECTED);
 		skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
 		skb->priority = RX_INVALID_OPERATION;
-		return false;
+		return NULL;
 	}
 
-	if (sp->hdr.securityIndex == RXRPC_SECURITY_NONE)
-		goto out;
-
-	if (!rx->securities) {
+	if (sp->hdr.securityIndex != RXRPC_SECURITY_NONE &&
+	    !rx->securities) {
 		trace_rxrpc_abort(0, "SVR",
 				  sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
 				  RX_INVALID_OPERATION, EKEYREJECTED);
 		skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
-		skb->priority = RX_INVALID_OPERATION;
-		return false;
+		skb->priority = sec->no_key_abort;
+		return NULL;
 	}
 
+	return sec;
+}
+
+/*
+ * Find the security key for a server connection.
+ */
+struct key *rxrpc_look_up_server_security(struct rxrpc_connection *conn,
+					  struct sk_buff *skb,
+					  u32 kvno, u32 enctype)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	struct rxrpc_sock *rx;
+	struct key *key = ERR_PTR(-EKEYREJECTED);
+	key_ref_t kref = NULL;
+	char kdesc[5 + 1 + 3 + 1 + 12 + 1 + 12 + 1];
+	int ret;
+
+	_enter("");
+
+	if (enctype)
+		sprintf(kdesc, "%u:%u:%u:%u",
+			sp->hdr.serviceId, sp->hdr.securityIndex, kvno, enctype);
+	else if (kvno)
+		sprintf(kdesc, "%u:%u:%u",
+			sp->hdr.serviceId, sp->hdr.securityIndex, kvno);
+	else
+		sprintf(kdesc, "%u:%u",
+			sp->hdr.serviceId, sp->hdr.securityIndex);
+
+	rcu_read_lock();
+
+	rx = rcu_dereference(conn->params.local->service);
+	if (!rx)
+		goto out;
+
 	/* look through the service's keyring */
 	kref = keyring_search(make_key_ref(rx->securities, 1UL),
 			      &key_type_rxrpc_s, kdesc, true);
 	if (IS_ERR(kref)) {
-		trace_rxrpc_abort(0, "SVK",
-				  sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-				  sec->no_key_abort, EKEYREJECTED);
-		skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
-		skb->priority = sec->no_key_abort;
-		return false;
+		key = ERR_CAST(kref);
+		goto out;
+	}
+
+	key = key_ref_to_ptr(kref);
+
+	ret = key_validate(key);
+	if (ret < 0) {
+		key_put(key);
+		key = ERR_PTR(ret);
+		goto out;
 	}
 
 out:
-	*_sec = sec;
-	*_key = key_ref_to_ptr(kref);
-	return true;
+	rcu_read_unlock();
+	return key;
 }


