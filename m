Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639FC2801F7
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732891AbgJAO7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:59:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732811AbgJAO6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:58:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oyu0sfrKLANQajYK7BJjX36TEaYjLSlp3kf97UpK/xY=;
        b=OTJuQVEsOBFUasyINN9O4v+Akh857RHbUXNBfRqIr5x7u5Ae/KXecswObVDlFQGpPtxCDF
        hA9GBsK4PdSTtryjrreibGshnUSF1sNOR9bg2X/L8+9u/enMtgNn+mKT8V15jzzYKVjIy7
        AHyyTLymZHazs4ZxR8P1Qvyv7aNTr6o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-pM-WdnDlNCKL6vzUs9PbTA-1; Thu, 01 Oct 2020 10:58:43 -0400
X-MC-Unique: pM-WdnDlNCKL6vzUs9PbTA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBD95AEB25;
        Thu,  1 Oct 2020 14:58:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA8847367D;
        Thu,  1 Oct 2020 14:58:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 17/23] rxrpc: Hand server key parsing off to the
 security class
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:58:41 +0100
Message-ID: <160156432116.1728886.8082845336783053993.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hand responsibility for parsing a server key off to the security class.  We
can determine which class from the description.  This is necessary as rxgk
server keys have different lookup requirements and different content
requirements (dependent on crypto type) to those of rxkad server keys.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |   11 +++++++++
 net/rxrpc/rxkad.c       |   47 +++++++++++++++++++++++++++++++++++++++
 net/rxrpc/security.c    |    2 +-
 net/rxrpc/server_key.c  |   56 +++++++++++++++++++++++------------------------
 4 files changed, 86 insertions(+), 30 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 982c9c2f9d77..047587ffe7bb 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -35,6 +35,7 @@ struct rxrpc_crypt {
 #define rxrpc_queue_delayed_work(WS,D)	\
 	queue_delayed_work(rxrpc_workqueue, (WS), (D))
 
+struct key_preparsed_payload;
 struct rxrpc_connection;
 
 /*
@@ -217,6 +218,15 @@ struct rxrpc_security {
 	/* Clean up a security service */
 	void (*exit)(void);
 
+	/* Parse the information from a server key */
+	int (*preparse_server_key)(struct key_preparsed_payload *);
+
+	/* Clean up the preparse buffer after parsing a server key */
+	void (*free_preparse_server_key)(struct key_preparsed_payload *);
+
+	/* Destroy the payload of a server key */
+	void (*destroy_server_key)(struct key *);
+
 	/* initialise a connection's security */
 	int (*init_connection_security)(struct rxrpc_connection *,
 					struct rxrpc_key_token *);
@@ -1049,6 +1059,7 @@ extern const struct rxrpc_security rxkad;
  * security.c
  */
 int __init rxrpc_init_security(void);
+const struct rxrpc_security *rxrpc_security_lookup(u8);
 void rxrpc_exit_security(void);
 int rxrpc_init_client_conn_security(struct rxrpc_connection *);
 const struct rxrpc_security *rxrpc_get_incoming_security(struct rxrpc_sock *,
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 554c8b931867..301894857473 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -15,6 +15,7 @@
 #include <linux/scatterlist.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/key-type.h>
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
 #include <keys/rxrpc-type.h>
@@ -49,6 +50,49 @@ static struct crypto_sync_skcipher *rxkad_ci;
 static struct skcipher_request *rxkad_ci_req;
 static DEFINE_MUTEX(rxkad_ci_mutex);
 
+/*
+ * Parse the information from a server key
+ *
+ * The data should be the 8-byte secret key.
+ */
+static int rxkad_preparse_server_key(struct key_preparsed_payload *prep)
+{
+	struct crypto_skcipher *ci;
+
+	if (prep->datalen != 8)
+		return -EINVAL;
+
+	memcpy(&prep->payload.data[2], prep->data, 8);
+
+	ci = crypto_alloc_skcipher("pcbc(des)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(ci)) {
+		_leave(" = %ld", PTR_ERR(ci));
+		return PTR_ERR(ci);
+	}
+
+	if (crypto_skcipher_setkey(ci, prep->data, 8) < 0)
+		BUG();
+
+	prep->payload.data[0] = ci;
+	_leave(" = 0");
+	return 0;
+}
+
+static void rxkad_free_preparse_server_key(struct key_preparsed_payload *prep)
+{
+	
+	if (prep->payload.data[0])
+		crypto_free_skcipher(prep->payload.data[0]);
+}
+
+static void rxkad_destroy_server_key(struct key *key)
+{
+	if (key->payload.data[0]) {
+		crypto_free_skcipher(key->payload.data[0]);
+		key->payload.data[0] = NULL;
+	}
+}
+
 /*
  * initialise connection security
  */
@@ -1313,6 +1357,9 @@ const struct rxrpc_security rxkad = {
 	.no_key_abort			= RXKADUNKNOWNKEY,
 	.init				= rxkad_init,
 	.exit				= rxkad_exit,
+	.preparse_server_key		= rxkad_preparse_server_key,
+	.free_preparse_server_key	= rxkad_free_preparse_server_key,
+	.destroy_server_key		= rxkad_destroy_server_key,
 	.init_connection_security	= rxkad_init_connection_security,
 	.secure_packet			= rxkad_secure_packet,
 	.verify_packet			= rxkad_verify_packet,
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index bef9971e15cd..50cb5f1ee0c0 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -55,7 +55,7 @@ void rxrpc_exit_security(void)
 /*
  * look up an rxrpc security module
  */
-static const struct rxrpc_security *rxrpc_security_lookup(u8 security_index)
+const struct rxrpc_security *rxrpc_security_lookup(u8 security_index)
 {
 	if (security_index >= ARRAY_SIZE(rxrpc_security_types))
 		return NULL;
diff --git a/net/rxrpc/server_key.c b/net/rxrpc/server_key.c
index b75bda05120d..1a2f0b63ee1d 100644
--- a/net/rxrpc/server_key.c
+++ b/net/rxrpc/server_key.c
@@ -30,8 +30,8 @@ static void rxrpc_destroy_s(struct key *);
 static void rxrpc_describe_s(const struct key *, struct seq_file *);
 
 /*
- * rxrpc server defined keys take "<serviceId>:<securityIndex>" as the
- * description and an 8-byte decryption key as the payload
+ * rxrpc server keys take "<serviceId>:<securityIndex>[:<sec-specific>]" as the
+ * description and the key material as the payload.
  */
 struct key_type key_type_rxrpc_s = {
 	.name		= "rxrpc_s",
@@ -45,64 +45,62 @@ struct key_type key_type_rxrpc_s = {
 };
 
 /*
- * Vet the description for an RxRPC server key
+ * Vet the description for an RxRPC server key.
  */
 static int rxrpc_vet_description_s(const char *desc)
 {
-	unsigned long num;
+	unsigned long service, sec_class;
 	char *p;
 
-	num = simple_strtoul(desc, &p, 10);
-	if (*p != ':' || num > 65535)
+	service = simple_strtoul(desc, &p, 10);
+	if (*p != ':' || service > 65535)
 		return -EINVAL;
-	num = simple_strtoul(p + 1, &p, 10);
-	if (*p || num < 1 || num > 255)
+	sec_class = simple_strtoul(p + 1, &p, 10);
+	if ((*p && *p != ':') || sec_class < 1 || sec_class > 255)
 		return -EINVAL;
 	return 0;
 }
 
 /*
  * Preparse a server secret key.
- *
- * The data should be the 8-byte secret key.
  */
 static int rxrpc_preparse_s(struct key_preparsed_payload *prep)
 {
-	struct crypto_skcipher *ci;
+	const struct rxrpc_security *sec;
+	unsigned int service, sec_class;
+	int n;
 
 	_enter("%zu", prep->datalen);
 
-	if (prep->datalen != 8)
+	if (!prep->orig_description)
 		return -EINVAL;
 
-	memcpy(&prep->payload.data[2], prep->data, 8);
+	if (sscanf(prep->orig_description, "%u:%u%n", &service, &sec_class, &n) != 2)
+		return -EINVAL;
 
-	ci = crypto_alloc_skcipher("pcbc(des)", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(ci)) {
-		_leave(" = %ld", PTR_ERR(ci));
-		return PTR_ERR(ci);
-	}
+	sec = rxrpc_security_lookup(sec_class);
+	if (!sec)
+		return -ENOPKG;
 
-	if (crypto_skcipher_setkey(ci, prep->data, 8) < 0)
-		BUG();
+	prep->payload.data[1] = (struct rxrpc_security *)sec;
 
-	prep->payload.data[0] = ci;
-	_leave(" = 0");
-	return 0;
+	return sec->preparse_server_key(prep);
 }
 
 static void rxrpc_free_preparse_s(struct key_preparsed_payload *prep)
 {
-	if (prep->payload.data[0])
-		crypto_free_skcipher(prep->payload.data[0]);
+	const struct rxrpc_security *sec = prep->payload.data[1];
+
+	if (sec)
+		sec->free_preparse_server_key(prep);
 }
 
 static void rxrpc_destroy_s(struct key *key)
 {
-	if (key->payload.data[0]) {
-		crypto_free_skcipher(key->payload.data[0]);
-		key->payload.data[0] = NULL;
-	}
+	const struct rxrpc_security *sec = key->payload.data[1];
+
+	if (sec)
+		sec->destroy_server_key(key);
 }
 
 static void rxrpc_describe_s(const struct key *key, struct seq_file *m)


