Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D0E2801FA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732906AbgJAO7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:59:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732834AbgJAO6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ApnBOfVnLGSF74zrtlr9kFhNwhHMyoLCU04IZwmC86M=;
        b=HOw2PA9isaDXnYPAj8ZFJ/eKYoktFkchxXIxNxYNLctOz4STdvFjJoK/qaV/Ar8aKQcpeU
        gr850PB/9MIak6VK5cKnDKPP/2hQN5FjAc86xv2dzMwU8pm/czDQgOUvtWENUDIHEiIJK6
        uO4Z5NZNYxnV7nmMb6RB/R4EpeJDfsQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-zEjqG8jqPd-Zd6Dx_uDDcQ-1; Thu, 01 Oct 2020 10:58:37 -0400
X-MC-Unique: zEjqG8jqPd-Zd6Dx_uDDcQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E855FAE825;
        Thu,  1 Oct 2020 14:58:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02D00702E7;
        Thu,  1 Oct 2020 14:58:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 16/23] rxrpc: Split the server key type (rxrpc_s)
 into its own file
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:58:34 +0100
Message-ID: <160156431421.1728886.625952293060933657.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the server private key type (rxrpc_s) out into its own file rather
than mingling it with the authentication/client key type (rxrpc) since they
don't really bear any relation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/Makefile      |    1 
 net/rxrpc/ar-internal.h |    9 ++-
 net/rxrpc/key.c         |  125 ------------------------------------------
 net/rxrpc/server_key.c  |  141 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 149 insertions(+), 127 deletions(-)
 create mode 100644 net/rxrpc/server_key.c

diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index ddd0f95713a9..b11281bed2a4 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -28,6 +28,7 @@ rxrpc-y := \
 	rtt.o \
 	security.o \
 	sendmsg.o \
+	server_key.o \
 	skbuff.o \
 	utils.o
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 1b39a2158ba3..982c9c2f9d77 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -905,10 +905,8 @@ extern const struct rxrpc_security rxrpc_no_security;
  * key.c
  */
 extern struct key_type key_type_rxrpc;
-extern struct key_type key_type_rxrpc_s;
 
 int rxrpc_request_key(struct rxrpc_sock *, sockptr_t , int);
-int rxrpc_server_keyring(struct rxrpc_sock *, sockptr_t, int);
 int rxrpc_get_server_data_key(struct rxrpc_connection *, const void *, time64_t,
 			      u32);
 
@@ -1063,6 +1061,13 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *,
  */
 int rxrpc_do_sendmsg(struct rxrpc_sock *, struct msghdr *, size_t);
 
+/*
+ * server_key.c
+ */
+extern struct key_type key_type_rxrpc_s;
+
+int rxrpc_server_keyring(struct rxrpc_sock *, sockptr_t, int);
+
 /*
  * skbuff.c
  */
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index b10b4db7c205..822152ce381f 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -23,15 +23,10 @@
 #include <keys/user-type.h>
 #include "ar-internal.h"
 
-static int rxrpc_vet_description_s(const char *);
 static int rxrpc_preparse(struct key_preparsed_payload *);
-static int rxrpc_preparse_s(struct key_preparsed_payload *);
 static void rxrpc_free_preparse(struct key_preparsed_payload *);
-static void rxrpc_free_preparse_s(struct key_preparsed_payload *);
 static void rxrpc_destroy(struct key *);
-static void rxrpc_destroy_s(struct key *);
 static void rxrpc_describe(const struct key *, struct seq_file *);
-static void rxrpc_describe_s(const struct key *, struct seq_file *);
 static long rxrpc_read(const struct key *, char *, size_t);
 
 /*
@@ -50,38 +45,6 @@ struct key_type key_type_rxrpc = {
 };
 EXPORT_SYMBOL(key_type_rxrpc);
 
-/*
- * rxrpc server defined keys take "<serviceId>:<securityIndex>" as the
- * description and an 8-byte decryption key as the payload
- */
-struct key_type key_type_rxrpc_s = {
-	.name		= "rxrpc_s",
-	.flags		= KEY_TYPE_NET_DOMAIN,
-	.vet_description = rxrpc_vet_description_s,
-	.preparse	= rxrpc_preparse_s,
-	.free_preparse	= rxrpc_free_preparse_s,
-	.instantiate	= generic_key_instantiate,
-	.destroy	= rxrpc_destroy_s,
-	.describe	= rxrpc_describe_s,
-};
-
-/*
- * Vet the description for an RxRPC server key
- */
-static int rxrpc_vet_description_s(const char *desc)
-{
-	unsigned long num;
-	char *p;
-
-	num = simple_strtoul(desc, &p, 10);
-	if (*p != ':' || num > 65535)
-		return -EINVAL;
-	num = simple_strtoul(p + 1, &p, 10);
-	if (*p || num < 1 || num > 255)
-		return -EINVAL;
-	return 0;
-}
-
 /*
  * parse an RxKAD type XDR format token
  * - the caller guarantees we have at least 4 words
@@ -433,45 +396,6 @@ static void rxrpc_free_preparse(struct key_preparsed_payload *prep)
 	rxrpc_free_token_list(prep->payload.data[0]);
 }
 
-/*
- * Preparse a server secret key.
- *
- * The data should be the 8-byte secret key.
- */
-static int rxrpc_preparse_s(struct key_preparsed_payload *prep)
-{
-	struct crypto_skcipher *ci;
-
-	_enter("%zu", prep->datalen);
-
-	if (prep->datalen != 8)
-		return -EINVAL;
-
-	memcpy(&prep->payload.data[2], prep->data, 8);
-
-	ci = crypto_alloc_skcipher("pcbc(des)", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(ci)) {
-		_leave(" = %ld", PTR_ERR(ci));
-		return PTR_ERR(ci);
-	}
-
-	if (crypto_skcipher_setkey(ci, prep->data, 8) < 0)
-		BUG();
-
-	prep->payload.data[0] = ci;
-	_leave(" = 0");
-	return 0;
-}
-
-/*
- * Clean up preparse data.
- */
-static void rxrpc_free_preparse_s(struct key_preparsed_payload *prep)
-{
-	if (prep->payload.data[0])
-		crypto_free_skcipher(prep->payload.data[0]);
-}
-
 /*
  * dispose of the data dangling from the corpse of a rxrpc key
  */
@@ -480,17 +404,6 @@ static void rxrpc_destroy(struct key *key)
 	rxrpc_free_token_list(key->payload.data[0]);
 }
 
-/*
- * dispose of the data dangling from the corpse of a rxrpc key
- */
-static void rxrpc_destroy_s(struct key *key)
-{
-	if (key->payload.data[0]) {
-		crypto_free_skcipher(key->payload.data[0]);
-		key->payload.data[0] = NULL;
-	}
-}
-
 /*
  * describe the rxrpc key
  */
@@ -517,14 +430,6 @@ static void rxrpc_describe(const struct key *key, struct seq_file *m)
 	}
 }
 
-/*
- * describe the rxrpc server key
- */
-static void rxrpc_describe_s(const struct key *key, struct seq_file *m)
-{
-	seq_puts(m, key->description);
-}
-
 /*
  * grab the security key for a socket
  */
@@ -555,36 +460,6 @@ int rxrpc_request_key(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
 	return 0;
 }
 
-/*
- * grab the security keyring for a server socket
- */
-int rxrpc_server_keyring(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
-{
-	struct key *key;
-	char *description;
-
-	_enter("");
-
-	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
-		return -EINVAL;
-
-	description = memdup_sockptr_nul(optval, optlen);
-	if (IS_ERR(description))
-		return PTR_ERR(description);
-
-	key = request_key(&key_type_keyring, description, NULL);
-	if (IS_ERR(key)) {
-		kfree(description);
-		_leave(" = %ld", PTR_ERR(key));
-		return PTR_ERR(key);
-	}
-
-	rx->securities = key;
-	kfree(description);
-	_leave(" = 0 [key %x]", key->serial);
-	return 0;
-}
-
 /*
  * generate a server data key
  */
diff --git a/net/rxrpc/server_key.c b/net/rxrpc/server_key.c
new file mode 100644
index 000000000000..b75bda05120d
--- /dev/null
+++ b/net/rxrpc/server_key.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* RxRPC key management
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * RxRPC keys should have a description of describing their purpose:
+ *	"afs@CAMBRIDGE.REDHAT.COM>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/skcipher.h>
+#include <linux/module.h>
+#include <linux/net.h>
+#include <linux/skbuff.h>
+#include <linux/key-type.h>
+#include <linux/ctype.h>
+#include <linux/slab.h>
+#include <net/sock.h>
+#include <net/af_rxrpc.h>
+#include <keys/rxrpc-type.h>
+#include <keys/user-type.h>
+#include "ar-internal.h"
+
+static int rxrpc_vet_description_s(const char *);
+static int rxrpc_preparse_s(struct key_preparsed_payload *);
+static void rxrpc_free_preparse_s(struct key_preparsed_payload *);
+static void rxrpc_destroy_s(struct key *);
+static void rxrpc_describe_s(const struct key *, struct seq_file *);
+
+/*
+ * rxrpc server defined keys take "<serviceId>:<securityIndex>" as the
+ * description and an 8-byte decryption key as the payload
+ */
+struct key_type key_type_rxrpc_s = {
+	.name		= "rxrpc_s",
+	.flags		= KEY_TYPE_NET_DOMAIN,
+	.vet_description = rxrpc_vet_description_s,
+	.preparse	= rxrpc_preparse_s,
+	.free_preparse	= rxrpc_free_preparse_s,
+	.instantiate	= generic_key_instantiate,
+	.destroy	= rxrpc_destroy_s,
+	.describe	= rxrpc_describe_s,
+};
+
+/*
+ * Vet the description for an RxRPC server key
+ */
+static int rxrpc_vet_description_s(const char *desc)
+{
+	unsigned long num;
+	char *p;
+
+	num = simple_strtoul(desc, &p, 10);
+	if (*p != ':' || num > 65535)
+		return -EINVAL;
+	num = simple_strtoul(p + 1, &p, 10);
+	if (*p || num < 1 || num > 255)
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * Preparse a server secret key.
+ *
+ * The data should be the 8-byte secret key.
+ */
+static int rxrpc_preparse_s(struct key_preparsed_payload *prep)
+{
+	struct crypto_skcipher *ci;
+
+	_enter("%zu", prep->datalen);
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
+static void rxrpc_free_preparse_s(struct key_preparsed_payload *prep)
+{
+	if (prep->payload.data[0])
+		crypto_free_skcipher(prep->payload.data[0]);
+}
+
+static void rxrpc_destroy_s(struct key *key)
+{
+	if (key->payload.data[0]) {
+		crypto_free_skcipher(key->payload.data[0]);
+		key->payload.data[0] = NULL;
+	}
+}
+
+static void rxrpc_describe_s(const struct key *key, struct seq_file *m)
+{
+	seq_puts(m, key->description);
+}
+
+/*
+ * grab the security keyring for a server socket
+ */
+int rxrpc_server_keyring(struct rxrpc_sock *rx, sockptr_t optval, int optlen)
+{
+	struct key *key;
+	char *description;
+
+	_enter("");
+
+	if (optlen <= 0 || optlen > PAGE_SIZE - 1)
+		return -EINVAL;
+
+	description = memdup_sockptr_nul(optval, optlen);
+	if (IS_ERR(description))
+		return PTR_ERR(description);
+
+	key = request_key(&key_type_keyring, description, NULL);
+	if (IS_ERR(key)) {
+		kfree(description);
+		_leave(" = %ld", PTR_ERR(key));
+		return PTR_ERR(key);
+	}
+
+	rx->securities = key;
+	kfree(description);
+	_leave(" = 0 [key %x]", key->serial);
+	return 0;
+}


