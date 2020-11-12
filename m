Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AA52B054C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgKLM6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:58:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24699 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728155AbgKLM6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:58:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKLlZYAbQMt1tMpfeGrxE8DYlcnIAOJnTTrk+3E2Iec=;
        b=VDAtS6ZaCfS2mrd+8qwsXWkFG6lRyuiAC5EsNJC3wB60oq2+yShNwe1YTJHJaPDxvCjYBT
        MDzl6Fa//f6/d6YGeIJCz8Qbls0PSkoMdRrKfsJKPr5ymycV2Av4kNCZD0qwveMnZ/oR84
        CgTJyGvWhyI0li7mnJIPf2MpvYd4WcM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-kZ4_MPqZPryJ8JMNzo8XtA-1; Thu, 12 Nov 2020 07:57:58 -0500
X-MC-Unique: kZ4_MPqZPryJ8JMNzo8XtA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 961031007B2A;
        Thu, 12 Nov 2020 12:57:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 921AF5D9E8;
        Thu, 12 Nov 2020 12:57:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 01/18] crypto/krb5: Implement Kerberos crypto core
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:57:53 +0000
Message-ID: <160518587378.2277919.8315623921666827993.stgit@warthog.procyon.org.uk>
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

Provide core structures, an encoding-type registry and basic module and
config bits for a generic Kerberos crypto library.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/Kconfig         |    1 +
 crypto/Makefile        |    1 +
 crypto/krb5/Kconfig    |   11 ++++++
 crypto/krb5/Makefile   |    9 +++++
 crypto/krb5/internal.h |   87 ++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/krb5/main.c     |   42 +++++++++++++++++++++++
 include/crypto/krb5.h  |   67 +++++++++++++++++++++++++++++++++++++
 7 files changed, 218 insertions(+)
 create mode 100644 crypto/krb5/Kconfig
 create mode 100644 crypto/krb5/Makefile
 create mode 100644 crypto/krb5/internal.h
 create mode 100644 crypto/krb5/main.c
 create mode 100644 include/crypto/krb5.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 094ef56ab7b4..0d5ca023bb77 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1940,5 +1940,6 @@ source "lib/crypto/Kconfig"
 source "drivers/crypto/Kconfig"
 source "crypto/asymmetric_keys/Kconfig"
 source "certs/Kconfig"
+source "crypto/krb5/Kconfig"
 
 endif	# if CRYPTO
diff --git a/crypto/Makefile b/crypto/Makefile
index b279483fba50..732467ed3c94 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -197,3 +197,4 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys/
 obj-$(CONFIG_CRYPTO_HASH_INFO) += hash_info.o
 crypto_simd-y := simd.o
 obj-$(CONFIG_CRYPTO_SIMD) += crypto_simd.o
+obj-$(CONFIG_CRYPTO_KRB5) += krb5/
diff --git a/crypto/krb5/Kconfig b/crypto/krb5/Kconfig
new file mode 100644
index 000000000000..881754500732
--- /dev/null
+++ b/crypto/krb5/Kconfig
@@ -0,0 +1,11 @@
+config CRYPTO_KRB5
+	tristate "Kerberos 5 crypto"
+	select CRYPTO_MANAGER
+	select CRYPTO_SKCIPHER
+	select CRYPTO_HASH_INFO
+	select CRYPTO_SHA1
+	select CRYPTO_CBC
+	select CRYPTO_CTS
+	select CRYPTO_AES
+	help
+	  Provide Kerberos-5-based security.
diff --git a/crypto/krb5/Makefile b/crypto/krb5/Makefile
new file mode 100644
index 000000000000..071ce2ff82e5
--- /dev/null
+++ b/crypto/krb5/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for asymmetric cryptographic keys
+#
+
+krb5-y += \
+	main.o
+
+obj-$(CONFIG_CRYPTO_KRB5) += krb5.o
diff --git a/crypto/krb5/internal.h b/crypto/krb5/internal.h
new file mode 100644
index 000000000000..d2e3da7f101e
--- /dev/null
+++ b/crypto/krb5/internal.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Kerberos5 crypto internals
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include <crypto/krb5.h>
+
+/*
+ * Profile used for key derivation and encryption.
+ */
+struct krb5_crypto_profile {
+	 /* Pseudo-random function */
+	int (*calc_PRF)(const struct krb5_enctype *krb5,
+			const struct krb5_buffer *protocol_key,
+			const struct krb5_buffer *octet_string,
+			struct krb5_buffer *result,
+			gfp_t gfp);
+
+	/* Checksum key derivation */
+	int (*calc_Kc)(const struct krb5_enctype *krb5,
+		       const struct krb5_buffer *TK,
+		       const struct krb5_buffer *usage_constant,
+		       struct krb5_buffer *Kc,
+		       gfp_t gfp);
+
+	/* Encryption key derivation */
+	int (*calc_Ke)(const struct krb5_enctype *krb5,
+		       const struct krb5_buffer *TK,
+		       const struct krb5_buffer *usage_constant,
+		       struct krb5_buffer *Ke,
+		       gfp_t gfp);
+
+	 /* Integrity key derivation */
+	int (*calc_Ki)(const struct krb5_enctype *krb5,
+		       const struct krb5_buffer *TK,
+		       const struct krb5_buffer *usage_constant,
+		       struct krb5_buffer *Ki,
+		       gfp_t gfp);
+
+	/* Encrypt data in-place, inserting confounder and checksum. */
+	ssize_t (*encrypt)(const struct krb5_enctype *krb5,
+			   struct krb5_enc_keys *keys,
+			   struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+			   size_t data_offset, size_t data_len,
+			   bool preconfounded);
+
+	/* Decrypt data in-place, removing confounder and checksum */
+	int (*decrypt)(const struct krb5_enctype *krb5,
+		       struct krb5_enc_keys *keys,
+		       struct scatterlist *sg, unsigned nr_sg,
+		       size_t *_offset, size_t *_len,
+		       int *_error_code);
+
+	/* Generate a MIC on part of a packet, inserting the checksum */
+	ssize_t (*get_mic)(const struct krb5_enctype *krb5,
+			   struct crypto_shash *shash,
+			   const struct krb5_buffer *metadata,
+			   struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+			   size_t data_offset, size_t data_len);
+
+	/* Verify the MIC on a piece of data, removing the checksum */
+	int (*verify_mic)(const struct krb5_enctype *krb5,
+			  struct crypto_shash *shash,
+			  const struct krb5_buffer *metadata,
+			  struct scatterlist *sg, unsigned nr_sg,
+			  size_t *_offset, size_t *_len,
+			  int *_error_code);
+};
+
+/*
+ * Crypto size/alignment rounding convenience macros.
+ */
+#define crypto_roundup(X) round_up((X), CRYPTO_MINALIGN)
+
+#define krb5_shash_size(TFM) \
+	crypto_roundup(sizeof(struct shash_desc) + crypto_shash_descsize(TFM))
+#define krb5_skcipher_size(TFM) \
+	crypto_roundup(sizeof(struct skcipher_request) + crypto_skcipher_reqsize(TFM))
+#define krb5_digest_size(TFM) \
+	crypto_roundup(crypto_shash_digestsize(TFM))
+#define krb5_sync_skcipher_size(TFM) \
+	krb5_skcipher_size(&(TFM)->base)
+#define krb5_sync_skcipher_ivsize(TFM) \
+	crypto_roundup(crypto_sync_skcipher_ivsize(TFM))
+#define round16(x) (((x) + 15) & ~15)
diff --git a/crypto/krb5/main.c b/crypto/krb5/main.c
new file mode 100644
index 000000000000..58d40252adc9
--- /dev/null
+++ b/crypto/krb5/main.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* RxGK transport key derivation.
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include "internal.h"
+
+MODULE_DESCRIPTION("Kerberos 5 crypto");
+MODULE_AUTHOR("Red Hat, Inc.");
+MODULE_LICENSE("GPL");
+
+static const struct krb5_enctype *const krb5_supported_enctypes[] = {
+};
+
+/**
+ * crypto_krb5_find_enctype - Find the handler for a Kerberos5 encryption type
+ * @enctype: The standard Kerberos encryption type number
+ *
+ * Look up a Kerberos encryption type by number.  If successful, returns a
+ * pointer to the type tables; returns NULL otherwise.
+ */
+const struct krb5_enctype *crypto_krb5_find_enctype(u32 enctype)
+{
+	const struct krb5_enctype *krb5;
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(krb5_supported_enctypes); i++) {
+		krb5 = krb5_supported_enctypes[i];
+		if (krb5->etype == enctype)
+			return krb5;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(crypto_krb5_find_enctype);
diff --git a/include/crypto/krb5.h b/include/crypto/krb5.h
new file mode 100644
index 000000000000..2bd6cfe50b85
--- /dev/null
+++ b/include/crypto/krb5.h
@@ -0,0 +1,67 @@
+/* Kerberos 5 crypto
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _CRYPTO_KRB5_H
+#define _CRYPTO_KRB5_H
+
+struct crypto_shash;
+struct scatterlist;
+
+struct krb5_buffer {
+	unsigned int	len;
+	void		*data;
+};
+
+/*
+ * Encryption key and checksum for RxGK encryption.  These always come
+ * as a pair as per RFC3961 encrypt().
+ */
+struct krb5_enc_keys {
+	struct crypto_sync_skcipher	*Ke; /* Encryption key */
+	struct crypto_shash		*Ki; /* Checksum key */
+};
+
+/*
+ * Kerberos encoding type definition.
+ */
+struct krb5_enctype {
+	int		etype;		/* Encryption (key) type */
+	int		ctype;		/* Checksum type */
+	const char	*name;		/* "Friendly" name */
+	const char	*encrypt_name;	/* Crypto encrypt name */
+	const char	*cksum_name;	/* Crypto checksum name */
+	const char	*hash_name;	/* Crypto hash name */
+	u16		block_len;	/* Length of encryption block */
+	u16		conf_len;	/* Length of confounder (normally == block_len) */
+	u16		cksum_len;	/* Length of checksum */
+	u16		key_bytes;	/* Length of raw key, in bytes */
+	u16		key_len;	/* Length of final key, in bytes */
+	u16		hash_len;	/* Length of hash in bytes */
+	u16		prf_len;	/* Length of PRF() result in bytes */
+	u16		Kc_len;		/* Length of Kc in bytes */
+	u16		Ke_len;		/* Length of Ke in bytes */
+	u16		Ki_len;		/* Length of Ki in bytes */
+	bool		keyed_cksum;	/* T if a keyed cksum */
+	bool		pad;		/* T if should pad */
+
+	const struct krb5_crypto_profile *profile;
+
+	int (*random_to_key)(const struct krb5_enctype *krb5,
+			     const struct krb5_buffer *in,
+			     struct krb5_buffer *out);	/* complete key generation */
+};
+
+/*
+ * main.c
+ */
+extern const struct krb5_enctype *crypto_krb5_find_enctype(u32 enctype);
+
+#endif /* _CRYPTO_KRB5_H */


