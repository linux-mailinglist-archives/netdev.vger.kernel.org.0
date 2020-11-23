Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618602C160A
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgKWUKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:10:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731968AbgKWUKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:10:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606162237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i6bH5TSYMCbQh0kjwN3AAAsgj04XcjPIr1FNcuSzsnU=;
        b=MZfuOlVkvwEomCJObMeYgjLJo/WI6GgRTmLZQ2S810p0c9q3isVu9RQXNz6Nun5HILPSb7
        L6S8hfUcDLR7OSdcAu2AdT3ngymJUzWO1ZOmMpheAKSWZ68E4MtGsWP+EWIc93y8QTIyLA
        duhvyA9DGYRZED5kZQh7szaVCRPbKGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-0M1xN2ioO1GXkEwsac1BWQ-1; Mon, 23 Nov 2020 15:10:35 -0500
X-MC-Unique: 0M1xN2ioO1GXkEwsac1BWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 654D71006C84;
        Mon, 23 Nov 2020 20:10:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72D155D6DC;
        Mon, 23 Nov 2020 20:10:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 04/17] rxrpc: Support keys with multiple
 authentication tokens
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 20:10:32 +0000
Message-ID: <160616223265.830164.2965559123196402669.stgit@warthog.procyon.org.uk>
In-Reply-To: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
References: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rxrpc-type keys can have multiple tokens attached for different security
classes.  Currently, rxrpc always picks the first one, whether or not the
security class it indicates is supported.

Add preliminary support for choosing which security class will be used
(this will need to be directed from a higher layer) and go through the
tokens to find one that's supported.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    4 +++-
 net/rxrpc/conn_event.c  |    3 ++-
 net/rxrpc/insecure.c    |    3 ++-
 net/rxrpc/rxkad.c       |    5 ++---
 net/rxrpc/security.c    |   15 ++++++++-------
 5 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index dce48162f6c2..3c417ec94e4c 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -12,6 +12,7 @@
 #include <net/netns/generic.h>
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
+#include <keys/rxrpc-type.h>
 #include "protocol.h"
 
 #if 0
@@ -217,7 +218,8 @@ struct rxrpc_security {
 	void (*exit)(void);
 
 	/* initialise a connection's security */
-	int (*init_connection_security)(struct rxrpc_connection *);
+	int (*init_connection_security)(struct rxrpc_connection *,
+					struct rxrpc_key_token *);
 
 	/* prime a connection's packet security */
 	int (*prime_packet_security)(struct rxrpc_connection *);
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index aff184145ffa..bbf86203ed25 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -333,7 +333,8 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 		if (ret < 0)
 			return ret;
 
-		ret = conn->security->init_connection_security(conn);
+		ret = conn->security->init_connection_security(
+			conn, conn->params.key->payload.data[0]);
 		if (ret < 0)
 			return ret;
 
diff --git a/net/rxrpc/insecure.c b/net/rxrpc/insecure.c
index f6c59f5fae9d..cf3ecffcf424 100644
--- a/net/rxrpc/insecure.c
+++ b/net/rxrpc/insecure.c
@@ -8,7 +8,8 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
-static int none_init_connection_security(struct rxrpc_connection *conn)
+static int none_init_connection_security(struct rxrpc_connection *conn,
+					 struct rxrpc_key_token *token)
 {
 	return 0;
 }
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index f114dc2af5cf..404d1323c239 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -49,15 +49,14 @@ static DEFINE_MUTEX(rxkad_ci_mutex);
 /*
  * initialise connection security
  */
-static int rxkad_init_connection_security(struct rxrpc_connection *conn)
+static int rxkad_init_connection_security(struct rxrpc_connection *conn,
+					  struct rxrpc_key_token *token)
 {
 	struct crypto_sync_skcipher *ci;
-	struct rxrpc_key_token *token;
 	int ret;
 
 	_enter("{%d},{%x}", conn->debug_id, key_serial(conn->params.key));
 
-	token = conn->params.key->payload.data[0];
 	conn->security_ix = token->security_index;
 
 	ci = crypto_alloc_sync_skcipher("pcbc(fcrypt)", 0, 0);
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index 9b1fb9ed0717..0c5168f52bd6 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -81,16 +81,17 @@ int rxrpc_init_client_conn_security(struct rxrpc_connection *conn)
 	if (ret < 0)
 		return ret;
 
-	token = key->payload.data[0];
-	if (!token)
-		return -EKEYREJECTED;
+	for (token = key->payload.data[0]; token; token = token->next) {
+		sec = rxrpc_security_lookup(token->security_index);
+		if (sec)
+			goto found;
+	}
+	return -EKEYREJECTED;
 
-	sec = rxrpc_security_lookup(token->security_index);
-	if (!sec)
-		return -EKEYREJECTED;
+found:
 	conn->security = sec;
 
-	ret = conn->security->init_connection_security(conn);
+	ret = conn->security->init_connection_security(conn, token);
 	if (ret < 0) {
 		conn->security = &rxrpc_no_security;
 		return ret;


