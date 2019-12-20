Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D6F12855C
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 00:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfLTXGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 18:06:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31802 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726129AbfLTXGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 18:06:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576883160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I4hdYlMK6WBSjpJr/8E5qXKfSqEggOH1BqMglYJakSU=;
        b=RlZMGuVUwxtv+l36HKLmAQvQu6SZUYftB+eSWWP9vpn3B3YYa+HOBNgbwfKBznnfKjpOoY
        4fvGNE9Cu0ORcNdMVGu0m/6jhOk73GvkOdxM1piyA5ZxFCqJJOqJCHW85+MuKMxJJcyXLM
        lc3QFOx/agecBzANTdQtimDROxDz6wo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-qKNi1jamPTymTAjxnNe8FQ-1; Fri, 20 Dec 2019 18:05:58 -0500
X-MC-Unique: qKNi1jamPTymTAjxnNe8FQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98D831005502;
        Fri, 20 Dec 2019 23:05:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-52.rdu2.redhat.com [10.10.120.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F6245D727;
        Fri, 20 Dec 2019 23:05:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 3/3] rxrpc: Fix missing security check on incoming calls
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 20 Dec 2019 23:05:55 +0000
Message-ID: <157688315586.18782.17209540659953040432.stgit@warthog.procyon.org.uk>
In-Reply-To: <157688313527.18782.11664545318996365146.stgit@warthog.procyon.org.uk>
References: <157688313527.18782.11664545318996365146.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix rxrpc_new_incoming_call() to check that we have a suitable service key
available for the combination of service ID and security class of a new
incoming call - and to reject calls for which we don't.

This causes an assertion like the following to appear:

	rxrpc: Assertion failed - 6(0x6) == 12(0xc) is false
	kernel BUG at net/rxrpc/call_object.c:456!

Where call->state is RXRPC_CALL_SERVER_SECURING (6) rather than
RXRPC_CALL_COMPLETE (12).

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h  |   10 +++++--
 net/rxrpc/call_accept.c  |   14 +++++++--
 net/rxrpc/conn_event.c   |   16 +----------
 net/rxrpc/conn_service.c |    4 +++
 net/rxrpc/rxkad.c        |    5 ++-
 net/rxrpc/security.c     |   70 ++++++++++++++++++++++------------------------
 6 files changed, 59 insertions(+), 60 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 7c7d10f2e0c1..5e99df80e80a 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -209,6 +209,7 @@ struct rxrpc_skb_priv {
 struct rxrpc_security {
 	const char		*name;		/* name of this service */
 	u8			security_index;	/* security type provided */
+	u32			no_key_abort;	/* Abort code indicating no key */
 
 	/* Initialise a security service */
 	int (*init)(void);
@@ -977,8 +978,9 @@ static inline void rxrpc_reduce_conn_timer(struct rxrpc_connection *conn,
 struct rxrpc_connection *rxrpc_find_service_conn_rcu(struct rxrpc_peer *,
 						     struct sk_buff *);
 struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *, gfp_t);
-void rxrpc_new_incoming_connection(struct rxrpc_sock *,
-				   struct rxrpc_connection *, struct sk_buff *);
+void rxrpc_new_incoming_connection(struct rxrpc_sock *, struct rxrpc_connection *,
+				   const struct rxrpc_security *, struct key *,
+				   struct sk_buff *);
 void rxrpc_unpublish_service_conn(struct rxrpc_connection *);
 
 /*
@@ -1103,7 +1105,9 @@ extern const struct rxrpc_security rxkad;
 int __init rxrpc_init_security(void);
 void rxrpc_exit_security(void);
 int rxrpc_init_client_conn_security(struct rxrpc_connection *);
-int rxrpc_init_server_conn_security(struct rxrpc_connection *);
+bool rxrpc_look_up_server_security(struct rxrpc_local *, struct rxrpc_sock *,
+				   const struct rxrpc_security **, struct key **,
+				   struct sk_buff *);
 
 /*
  * sendmsg.c
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 44fa22b020ef..70e44abf106c 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -263,6 +263,8 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 						    struct rxrpc_local *local,
 						    struct rxrpc_peer *peer,
 						    struct rxrpc_connection *conn,
+						    const struct rxrpc_security *sec,
+						    struct key *key,
 						    struct sk_buff *skb)
 {
 	struct rxrpc_backlog *b = rx->backlog;
@@ -310,7 +312,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 		conn->params.local = rxrpc_get_local(local);
 		conn->params.peer = peer;
 		rxrpc_see_connection(conn);
-		rxrpc_new_incoming_connection(rx, conn, skb);
+		rxrpc_new_incoming_connection(rx, conn, sec, key, skb);
 	} else {
 		rxrpc_get_connection(conn);
 	}
@@ -349,9 +351,11 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 					   struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	const struct rxrpc_security *sec = NULL;
 	struct rxrpc_connection *conn;
 	struct rxrpc_peer *peer = NULL;
-	struct rxrpc_call *call;
+	struct rxrpc_call *call = NULL;
+	struct key *key = NULL;
 
 	_enter("");
 
@@ -372,7 +376,11 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	 */
 	conn = rxrpc_find_connection_rcu(local, skb, &peer);
 
-	call = rxrpc_alloc_incoming_call(rx, local, peer, conn, skb);
+	if (!conn && !rxrpc_look_up_server_security(local, rx, &sec, &key, skb))
+		goto no_call;
+
+	call = rxrpc_alloc_incoming_call(rx, local, peer, conn, sec, key, skb);
+	key_put(key);
 	if (!call) {
 		skb->mark = RXRPC_SKB_MARK_REJECT_BUSY;
 		goto no_call;
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index a1ceef4f5cd0..808a4723f868 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -376,21 +376,7 @@ static void rxrpc_secure_connection(struct rxrpc_connection *conn)
 	_enter("{%d}", conn->debug_id);
 
 	ASSERT(conn->security_ix != 0);
-
-	if (!conn->params.key) {
-		_debug("set up security");
-		ret = rxrpc_init_server_conn_security(conn);
-		switch (ret) {
-		case 0:
-			break;
-		case -ENOENT:
-			abort_code = RX_CALL_DEAD;
-			goto abort;
-		default:
-			abort_code = RXKADNOAUTH;
-			goto abort;
-		}
-	}
+	ASSERT(conn->server_key);
 
 	if (conn->security->issue_challenge(conn) < 0) {
 		abort_code = RX_CALL_DEAD;
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 123d6ceab15c..21da48e3d2e5 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -148,6 +148,8 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
  */
 void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
 				   struct rxrpc_connection *conn,
+				   const struct rxrpc_security *sec,
+				   struct key *key,
 				   struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -160,6 +162,8 @@ void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
 	conn->service_id	= sp->hdr.serviceId;
 	conn->security_ix	= sp->hdr.securityIndex;
 	conn->out_clientflag	= 0;
+	conn->security		= sec;
+	conn->server_key	= key_get(key);
 	if (conn->security_ix)
 		conn->state	= RXRPC_CONN_SERVICE_UNSECURED;
 	else
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 8d8aa3c230b5..098f1f9ec53b 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -648,9 +648,9 @@ static int rxkad_issue_challenge(struct rxrpc_connection *conn)
 	u32 serial;
 	int ret;
 
-	_enter("{%d,%x}", conn->debug_id, key_serial(conn->params.key));
+	_enter("{%d,%x}", conn->debug_id, key_serial(conn->server_key));
 
-	ret = key_validate(conn->params.key);
+	ret = key_validate(conn->server_key);
 	if (ret < 0)
 		return ret;
 
@@ -1293,6 +1293,7 @@ static void rxkad_exit(void)
 const struct rxrpc_security rxkad = {
 	.name				= "rxkad",
 	.security_index			= RXRPC_SECURITY_RXKAD,
+	.no_key_abort			= RXKADUNKNOWNKEY,
 	.init				= rxkad_init,
 	.exit				= rxkad_exit,
 	.init_connection_security	= rxkad_init_connection_security,
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index a4c47d2b7054..9b1fb9ed0717 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -101,62 +101,58 @@ int rxrpc_init_client_conn_security(struct rxrpc_connection *conn)
 }
 
 /*
- * initialise the security on a server connection
+ * Find the security key for a server connection.
  */
-int rxrpc_init_server_conn_security(struct rxrpc_connection *conn)
+bool rxrpc_look_up_server_security(struct rxrpc_local *local, struct rxrpc_sock *rx,
+				   const struct rxrpc_security **_sec,
+				   struct key **_key,
+				   struct sk_buff *skb)
 {
 	const struct rxrpc_security *sec;
-	struct rxrpc_local *local = conn->params.local;
-	struct rxrpc_sock *rx;
-	struct key *key;
-	key_ref_t kref;
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	key_ref_t kref = NULL;
 	char kdesc[5 + 1 + 3 + 1];
 
 	_enter("");
 
-	sprintf(kdesc, "%u:%u", conn->service_id, conn->security_ix);
+	sprintf(kdesc, "%u:%u", sp->hdr.serviceId, sp->hdr.securityIndex);
 
-	sec = rxrpc_security_lookup(conn->security_ix);
+	sec = rxrpc_security_lookup(sp->hdr.securityIndex);
 	if (!sec) {
-		_leave(" = -ENOKEY [lookup]");
-		return -ENOKEY;
+		trace_rxrpc_abort(0, "SVS",
+				  sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+				  RX_INVALID_OPERATION, EKEYREJECTED);
+		skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
+		skb->priority = RX_INVALID_OPERATION;
+		return false;
 	}
 
-	/* find the service */
-	read_lock(&local->services_lock);
-	rx = rcu_dereference_protected(local->service,
-				       lockdep_is_held(&local->services_lock));
-	if (rx && (rx->srx.srx_service == conn->service_id ||
-		   rx->second_service == conn->service_id))
-		goto found_service;
+	if (sp->hdr.securityIndex == RXRPC_SECURITY_NONE)
+		goto out;
 
-	/* the service appears to have died */
-	read_unlock(&local->services_lock);
-	_leave(" = -ENOENT");
-	return -ENOENT;
-
-found_service:
 	if (!rx->securities) {
-		read_unlock(&local->services_lock);
-		_leave(" = -ENOKEY");
-		return -ENOKEY;
+		trace_rxrpc_abort(0, "SVR",
+				  sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+				  RX_INVALID_OPERATION, EKEYREJECTED);
+		skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
+		skb->priority = RX_INVALID_OPERATION;
+		return false;
 	}
 
 	/* look through the service's keyring */
 	kref = keyring_search(make_key_ref(rx->securities, 1UL),
 			      &key_type_rxrpc_s, kdesc, true);
 	if (IS_ERR(kref)) {
-		read_unlock(&local->services_lock);
-		_leave(" = %ld [search]", PTR_ERR(kref));
-		return PTR_ERR(kref);
+		trace_rxrpc_abort(0, "SVK",
+				  sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+				  sec->no_key_abort, EKEYREJECTED);
+		skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
+		skb->priority = sec->no_key_abort;
+		return false;
 	}
 
-	key = key_ref_to_ptr(kref);
-	read_unlock(&local->services_lock);
-
-	conn->server_key = key;
-	conn->security = sec;
-
-	_leave(" = 0");
-	return 0;
+out:
+	*_sec = sec;
+	*_key = key_ref_to_ptr(kref);
+	return true;
 }

