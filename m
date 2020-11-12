Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467012B0595
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgKLNAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:00:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28240 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728511AbgKLNAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:00:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9hW4vk0aUFoz9XSByNK9zQsdYKTcMJtnyt/J9ELSBT8=;
        b=LeOVMiwoIVf5vfNgR6SqmPTN7eHZeBmFumroTDCyUOq92aPYIZM+ad/lNoy7j4Dq1f4HC8
        NJvn56k6PBNuf2owHOnLPjSR2ggmWdI5w2VoSi6e308SxX0jsEifJ4f8ImTcTJJiJttWku
        xzFLP58dP6LOv+A5gd4onL2jvpb/LRg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-65z7sS4zOAebOuYLBdY60w-1; Thu, 12 Nov 2020 07:59:52 -0500
X-MC-Unique: 65z7sS4zOAebOuYLBdY60w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B36801017DC3;
        Thu, 12 Nov 2020 12:59:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64E315D9E8;
        Thu, 12 Nov 2020 12:59:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 15/18] rxrpc: rxgk: Provide infrastructure and key derivation
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:59:47 +0000
Message-ID: <160518598756.2277919.7065060398620916059.stgit@warthog.procyon.org.uk>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide some infrastructure for implementing the RxGK transport security
class:

 (1) A definition of an encoding type, including:

	- Relevant crypto-layer names
	- Lengths of the crypto keys and checksums involved
	- Crypto functions specific to the encoding type
	- Crypto scheme used for that type

 (2) A definition of a crypto scheme, including:

	- Underlying crypto handlers
	- The pseudo-random function, PRF, used in base key derivation
	- Functions for deriving usage keys Kc, Ke and Ki
	- Functions for en/decrypting parts of an sk_buff

 (3) A key context, with the usage keys required for a derivative of a
     transport key for a specific key number.  This includes keys for
     securing packets for transmission, extracting received packets and
     dealing with response packets.

 (3) A function to look up an encoding type by number.

 (4) A function to set up a key context and derive the keys.

 (5) A function to set up the keys required to extract the ticket obtained
     from the GSS negotiation in the server.

 (6) Miscellaneous functions for context handling.

The keys and key derivation functions are described in:

	tools.ietf.org/html/draft-wilkinson-afs3-rxgk-11

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/Kconfig       |   10 ++
 net/rxrpc/Makefile      |    3 +
 net/rxrpc/ar-internal.h |    3 +
 net/rxrpc/rxgk_common.h |   44 ++++++++
 net/rxrpc/rxgk_kdf.c    |  271 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 331 insertions(+)
 create mode 100644 net/rxrpc/rxgk_common.h
 create mode 100644 net/rxrpc/rxgk_kdf.c

diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index d706bb408365..62ff4b373d03 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -57,3 +57,13 @@ config RXKAD
 	  through the use of the key retention service.
 
 	  See Documentation/networking/rxrpc.rst.
+
+config RXGK
+	bool "RxRPC GSSAPI security"
+	depends on AF_RXRPC
+	depends on CRYPTO_KRB5
+	help
+	  Provide the GSSAPI-based RxGK security class for AFS.  Keys are added
+	  with add_key().
+
+	  See Documentation/networking/rxrpc.rst.
diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index b11281bed2a4..08636858e77f 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -35,3 +35,6 @@ rxrpc-y := \
 rxrpc-$(CONFIG_PROC_FS) += proc.o
 rxrpc-$(CONFIG_RXKAD) += rxkad.o
 rxrpc-$(CONFIG_SYSCTL) += sysctl.o
+
+rxrpc-$(CONFIG_RXGK) += \
+	rxgk_kdf.o
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index a3091a10b7c5..4e0766b4a714 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -456,6 +456,9 @@ struct rxrpc_connection {
 			struct rxrpc_crypt csum_iv;	/* packet checksum base */
 			u32	nonce;		/* response re-use preventer */
 		} rxkad;
+		struct {
+			u64	start_time;	/* The start time for TK derivation */
+		} rxgk;
 	};
 	unsigned long		flags;
 	unsigned long		events;
diff --git a/net/rxrpc/rxgk_common.h b/net/rxrpc/rxgk_common.h
new file mode 100644
index 000000000000..3047ad531877
--- /dev/null
+++ b/net/rxrpc/rxgk_common.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* rxgk common bits
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include <crypto/krb5.h>
+#include <crypto/skcipher.h>
+#include <crypto/hash.h>
+
+/*
+ * Per-key number context.  This is replaced when the connection is rekeyed.
+ */
+struct rxgk_context {
+	refcount_t		usage;
+	unsigned int		key_number;	/* Rekeying number (goes in the rx header) */
+	unsigned long		flags;
+#define RXGK_TK_NEEDS_REKEY	0		/* Set if this needs rekeying */
+	unsigned long		expiry;		/* Expiration time of this key */
+	long long		bytes_remaining; /* Remaining Tx lifetime of this key */
+	const struct krb5_enctype *krb5;	/* RxGK encryption type */
+	const struct rxgk_key	*key;
+
+	/* We need up to 7 keys derived from the transport key, but we don't
+	 * actually need the transport key.  Each key is derived by
+	 * DK(TK,constant).
+	 */
+	struct krb5_enc_keys	tx_enc;		/* Transmission key */
+	struct krb5_enc_keys	rx_enc;		/* Reception key */
+	struct crypto_shash	*tx_Kc;		/* Transmission checksum key */
+	struct crypto_shash	*rx_Kc;		/* Reception checksum key */
+	struct krb5_enc_keys	resp_enc;	/* Response packet enc key */
+};
+
+/*
+ * rxgk_kdf.c
+ */
+struct rxgk_context *rxgk_generate_transport_key(struct rxrpc_connection *,
+						 const struct rxgk_key *, unsigned int, gfp_t);
+int rxgk_set_up_token_cipher(const struct krb5_buffer *, struct krb5_enc_keys *,
+			     unsigned int, const struct krb5_enctype **,
+			     gfp_t);
+void rxgk_put(struct rxgk_context *);
diff --git a/net/rxrpc/rxgk_kdf.c b/net/rxrpc/rxgk_kdf.c
new file mode 100644
index 000000000000..2d9353c1dee3
--- /dev/null
+++ b/net/rxrpc/rxgk_kdf.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* RxGK transport key derivation.
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/key-type.h>
+#include <linux/slab.h>
+#include <keys/rxrpc-type.h>
+#include "ar-internal.h"
+#include "rxgk_common.h"
+
+#define round16(x) (((x) + 15) & ~15)
+
+static void rxgk_free(struct rxgk_context *gk)
+{
+	if (gk->tx_Kc)
+		crypto_free_shash(gk->tx_Kc);
+	if (gk->rx_Kc)
+		crypto_free_shash(gk->rx_Kc);
+	crypto_krb5_free_enc_keys(&gk->tx_enc);
+	crypto_krb5_free_enc_keys(&gk->rx_enc);
+	crypto_krb5_free_enc_keys(&gk->resp_enc);
+	kfree(gk);
+}
+
+void rxgk_put(struct rxgk_context *gk)
+{
+	if (gk && refcount_dec_and_test(&gk->usage))
+		rxgk_free(gk);
+}
+
+/*
+ * Transport key derivation function.
+ *
+ *      TK = random-to-key(PRF+(K0, L,
+ *                         epoch || cid || start_time || key_number))
+ *      [tools.ietf.org/html/draft-wilkinson-afs3-rxgk-11 sec 8.3]
+ */
+static int rxgk_derive_transport_key(struct rxrpc_connection *conn,
+				     struct rxgk_context *gk,
+				     const struct rxgk_key *rxgk,
+				     struct krb5_buffer *TK,
+				     gfp_t gfp)
+{
+	const struct krb5_enctype *krb5 = gk->krb5;
+	struct krb5_buffer conn_info;
+	unsigned int L = krb5->key_bytes;
+	__be32 *info;
+	u8 *buffer;
+	int ret;
+
+	_enter("");
+
+	conn_info.len = sizeof(__be32) * 5;
+
+	buffer = kzalloc(round16(conn_info.len), gfp);
+	if (!buffer)
+		return -ENOMEM;
+
+	conn_info.data = buffer;
+
+	info = (__be32 *)conn_info.data;
+	info[0] = htonl(conn->proto.epoch);
+	info[1] = htonl(conn->proto.cid);
+	info[2] = htonl(conn->rxgk.start_time >> 32);
+	info[3] = htonl(conn->rxgk.start_time >>  0);
+	info[4] = htonl(gk->key_number);
+
+	ret = crypto_krb5_calc_PRFplus(krb5, &rxgk->key, L, &conn_info, TK, gfp);
+	kfree_sensitive(buffer);
+	_leave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * Constants used to derive the keys and hmacs actually used for doing stuff.
+ */
+#define RXGK_CLIENT_ENC_PACKET		1026U // 0x402
+#define RXGK_CLIENT_MIC_PACKET          1027U // 0x403
+#define RXGK_SERVER_ENC_PACKET          1028U // 0x404
+#define RXGK_SERVER_MIC_PACKET          1029U // 0x405
+#define RXGK_CLIENT_ENC_RESPONSE        1030U // 0x406
+#define RXGK_SERVER_ENC_TOKEN           1036U // 0x40c
+
+/*
+ * Set up the ciphers for the usage keys.
+ */
+static int rxgk_set_up_ciphers(struct rxrpc_connection *conn,
+			       struct rxgk_context *gk,
+			       const struct rxgk_key *rxgk,
+			       gfp_t gfp)
+{
+	const struct krb5_enctype *krb5 = gk->krb5;
+	struct krb5_buffer TK, key;
+	bool service = rxrpc_conn_is_service(conn);
+	int ret;
+	u8 *buffer;
+
+	buffer = kzalloc(krb5->key_bytes * 2, gfp);
+	if (!buffer)
+		return -ENOMEM;
+
+	TK.len = krb5->key_bytes;
+	TK.data = buffer;
+	key.len = krb5->key_bytes;
+	key.data = buffer + krb5->key_bytes;
+
+	ret = rxgk_derive_transport_key(conn, gk, rxgk, &TK, gfp);
+	if (ret < 0)
+		goto out;
+
+#define DERIVE_Kc(KEY, USAGE, KC)				   \
+	ret = crypto_krb5_get_Kc(krb5, KEY, USAGE, &key, KC, gfp); \
+	if (ret < 0) goto out;
+#define DERIVE_Ke(KEY, USAGE, KE)				   \
+	ret = crypto_krb5_get_Ke(krb5, KEY, USAGE, &key, KE, gfp); \
+	if (ret < 0) goto out;
+#define DERIVE_Ki(KEY, USAGE, KI)				   \
+	ret = crypto_krb5_get_Ki(krb5, KEY, USAGE, &key, KI, gfp); \
+	if (ret < 0) goto out;
+
+	DERIVE_Ke(&TK, RXGK_CLIENT_ENC_RESPONSE, &gk->resp_enc.Ke);
+	DERIVE_Ki(&TK, RXGK_CLIENT_ENC_RESPONSE, &gk->resp_enc.Ki);
+
+	if (crypto_sync_skcipher_blocksize(gk->resp_enc.Ke) != krb5->block_len ||
+	    crypto_shash_digestsize(gk->resp_enc.Ki) < krb5->cksum_len) {
+		pr_notice("algo inconsistent with krb5 table %u!=%u or %u!=%u\n",
+			  crypto_sync_skcipher_blocksize(gk->resp_enc.Ke), krb5->block_len,
+			  crypto_shash_digestsize(gk->resp_enc.Ki), krb5->cksum_len);
+		return -EINVAL;
+	}
+
+	if (service) {
+		switch (conn->params.security_level) {
+		case RXRPC_SECURITY_AUTH:
+			DERIVE_Kc(&TK, RXGK_CLIENT_MIC_PACKET, &gk->rx_Kc);
+			DERIVE_Kc(&TK, RXGK_SERVER_MIC_PACKET, &gk->tx_Kc);
+			break;
+		case RXRPC_SECURITY_ENCRYPT:
+			DERIVE_Ke(&TK, RXGK_CLIENT_ENC_PACKET, &gk->rx_enc.Ke);
+			DERIVE_Ki(&TK, RXGK_CLIENT_ENC_PACKET, &gk->rx_enc.Ki);
+			DERIVE_Ke(&TK, RXGK_SERVER_ENC_PACKET, &gk->tx_enc.Ke);
+			DERIVE_Ki(&TK, RXGK_SERVER_ENC_PACKET, &gk->tx_enc.Ki);
+			break;
+		}
+	} else {
+		switch (conn->params.security_level) {
+		case RXRPC_SECURITY_AUTH:
+			DERIVE_Kc(&TK, RXGK_CLIENT_MIC_PACKET, &gk->tx_Kc);
+			DERIVE_Kc(&TK, RXGK_SERVER_MIC_PACKET, &gk->rx_Kc);
+			break;
+		case RXRPC_SECURITY_ENCRYPT:
+			DERIVE_Ke(&TK, RXGK_CLIENT_ENC_PACKET, &gk->tx_enc.Ke);
+			DERIVE_Ki(&TK, RXGK_CLIENT_ENC_PACKET, &gk->tx_enc.Ki);
+			DERIVE_Ke(&TK, RXGK_SERVER_ENC_PACKET, &gk->rx_enc.Ke);
+			DERIVE_Ki(&TK, RXGK_SERVER_ENC_PACKET, &gk->rx_enc.Ki);
+			break;
+		}
+	}
+
+	ret = 0;
+out:
+	kfree_sensitive(buffer);
+	return ret;
+}
+
+/*
+ * Derive a transport key for a connection and then derive a bunch of usage
+ * keys from it and set up ciphers using them.
+ */
+struct rxgk_context *rxgk_generate_transport_key(struct rxrpc_connection *conn,
+						 const struct rxgk_key *key,
+						 unsigned int key_number,
+						 gfp_t gfp)
+{
+	struct rxgk_context *gk;
+	unsigned long lifetime;
+	int ret;
+
+	_enter("");
+
+	gk = kzalloc(sizeof(struct rxgk_context), GFP_KERNEL);
+	if (!gk)
+		return ERR_PTR(-ENOMEM);
+	refcount_set(&gk->usage, 1);
+	gk->key		= key;
+	gk->key_number	= key_number;
+
+	gk->krb5 = crypto_krb5_find_enctype(key->enctype);
+	if (!gk->krb5) {
+		ret = -ENOPKG;
+		goto err_tk;
+	}
+
+	ret = rxgk_set_up_ciphers(conn, gk, key, gfp);
+	if (ret)
+		goto err_tk;
+
+	/* Set the remaining number of bytes encrypted with this key that may
+	 * be transmitted before rekeying.  Note that the spec has been
+	 * interpreted differently on this point... */
+	switch (key->bytelife) {
+	case 0:
+	case 63:
+		gk->bytes_remaining = LLONG_MAX;
+		break;
+	case 1 ... 62:
+		gk->bytes_remaining = 1LL << key->bytelife;
+		break;
+	default:
+		gk->bytes_remaining = key->bytelife;
+		break;
+	}
+
+	/* Set the time after which rekeying must occur */
+	if (key->lifetime) {
+		lifetime = min_t(u64, key->lifetime, INT_MAX / HZ);
+		lifetime *= HZ;
+	} else {
+		lifetime = MAX_JIFFY_OFFSET;
+	}
+	gk->expiry = jiffies + lifetime;
+	return gk;
+
+err_tk:
+	rxgk_put(gk);
+	_leave(" = %d", ret);
+	return ERR_PTR(ret);
+}
+
+/*
+ * Use the server secret key to set up the ciphers that will be used to extract
+ * the token from a response packet.
+ */
+int rxgk_set_up_token_cipher(const struct krb5_buffer *server_key,
+			     struct krb5_enc_keys *token_key,
+			     unsigned int enctype,
+			     const struct krb5_enctype **_krb5,
+			     gfp_t gfp)
+{
+	const struct krb5_enctype *krb5;
+	struct krb5_buffer key;
+	int ret;
+
+	ret = -ENOPKG;
+	krb5 = crypto_krb5_find_enctype(enctype);
+	if (!krb5)
+		goto out_buf;
+
+	*_krb5 = krb5;
+
+	key.len = krb5->key_bytes;
+	key.data = kzalloc(krb5->key_bytes, gfp);
+	if (!key.data)
+		return -ENOMEM;
+
+	DERIVE_Ke(server_key, RXGK_SERVER_ENC_TOKEN, &token_key->Ke);
+	DERIVE_Ki(server_key, RXGK_SERVER_ENC_TOKEN, &token_key->Ki);
+	ret = 0;
+out_buf:
+	kfree_sensitive(key.data);
+	return ret;
+
+out:
+	crypto_krb5_free_enc_keys(token_key);
+	goto out;
+}


