Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E152B057F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgKLM7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:59:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728408AbgKLM7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SIMOin/av7q3MUxt47nGrwOjr3mQiZb4LuG2UAH2unI=;
        b=hr35b+1ib6ExD2PEG9+3tneDFoqJAjHmNO/1ZqGdOxcVaqktU7KPx3nVHRrEwUyfW3iPUU
        0SMnoVL0OwjQommqhy5/7MUKpqui9NZFGRi92LiQn+5xtjSfSwh4nueEcnQjb0lMiBA/pN
        5xHbXgUGw25lhdaUmp68MTN9rJFVqFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-jQGw346-PjuIWaBBSUW1BA-1; Thu, 12 Nov 2020 07:59:03 -0500
X-MC-Unique: jQGw346-PjuIWaBBSUW1BA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3C48801FDF;
        Thu, 12 Nov 2020 12:59:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1C3B5D9E4;
        Thu, 12 Nov 2020 12:58:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 09/18] crypto/krb5: Implement the AES enctypes from rfc8009
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:58:58 +0000
Message-ID: <160518593886.2277919.4740986612401034649.stgit@warthog.procyon.org.uk>
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

Implement the aes128-cts-hmac-sha256-128 and aes256-cts-hmac-sha384-192
enctypes from rfc8009, overriding the rfc3961 kerberos 5 simplified crypto
scheme.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/krb5/Kconfig        |    2 
 crypto/krb5/Makefile       |    3 -
 crypto/krb5/internal.h     |    6 +
 crypto/krb5/main.c         |    2 
 crypto/krb5/rfc8009_aes2.c |  239 ++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/krb5.h      |    4 +
 6 files changed, 255 insertions(+), 1 deletion(-)
 create mode 100644 crypto/krb5/rfc8009_aes2.c

diff --git a/crypto/krb5/Kconfig b/crypto/krb5/Kconfig
index e2eba1d689ab..5607c0c81049 100644
--- a/crypto/krb5/Kconfig
+++ b/crypto/krb5/Kconfig
@@ -4,6 +4,8 @@ config CRYPTO_KRB5
 	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH_INFO
 	select CRYPTO_SHA1
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	select CRYPTO_CBC
 	select CRYPTO_CTS
 	select CRYPTO_AES
diff --git a/crypto/krb5/Makefile b/crypto/krb5/Makefile
index b7da03cae6d1..85763131f7b6 100644
--- a/crypto/krb5/Makefile
+++ b/crypto/krb5/Makefile
@@ -7,7 +7,8 @@ krb5-y += \
 	kdf.o \
 	main.o \
 	rfc3961_simplified.o \
-	rfc3962_aes.o
+	rfc3962_aes.o \
+	rfc8009_aes2.o
 
 krb5-$(CONFIG_CRYPTO_KRB5_SELFTESTS) += \
 	selftest.o \
diff --git a/crypto/krb5/internal.h b/crypto/krb5/internal.h
index 47424b433778..e64f5e58199f 100644
--- a/crypto/krb5/internal.h
+++ b/crypto/krb5/internal.h
@@ -158,6 +158,12 @@ int rfc3961_verify_mic(const struct krb5_enctype *krb5,
 extern const struct krb5_enctype krb5_aes128_cts_hmac_sha1_96;
 extern const struct krb5_enctype krb5_aes256_cts_hmac_sha1_96;
 
+/*
+ * rfc8009_aes2.c
+ */
+extern const struct krb5_enctype krb5_aes128_cts_hmac_sha256_128;
+extern const struct krb5_enctype krb5_aes256_cts_hmac_sha384_192;
+
 /*
  * selftest.c
  */
diff --git a/crypto/krb5/main.c b/crypto/krb5/main.c
index b79127027551..9914d3417c21 100644
--- a/crypto/krb5/main.c
+++ b/crypto/krb5/main.c
@@ -20,6 +20,8 @@ MODULE_LICENSE("GPL");
 static const struct krb5_enctype *const krb5_supported_enctypes[] = {
 	&krb5_aes128_cts_hmac_sha1_96,
 	&krb5_aes256_cts_hmac_sha1_96,
+	&krb5_aes128_cts_hmac_sha256_128,
+	&krb5_aes256_cts_hmac_sha384_192,
 };
 
 /**
diff --git a/crypto/krb5/rfc8009_aes2.c b/crypto/krb5/rfc8009_aes2.c
new file mode 100644
index 000000000000..9f0f0f410d91
--- /dev/null
+++ b/crypto/krb5/rfc8009_aes2.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* rfc8009 AES Encryption with HMAC-SHA2 for Kerberos 5
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/skcipher.h>
+#include <crypto/hash.h>
+#include <linux/slab.h>
+#include "internal.h"
+
+static const struct krb5_buffer rfc8009_no_context = { .len = 0, .data = "" };
+
+/*
+ * Calculate the key derivation function KDF-HMAC-SHA2(key, label, [context,] k)
+ *
+ *	KDF-HMAC-SHA2(key, label, [context,] k) = k-truncate(K1)
+ *
+ *	Using the appropriate one of:
+ *		K1 = HMAC-SHA-256(key, 0x00000001 | label | 0x00 | k)
+ *		K1 = HMAC-SHA-384(key, 0x00000001 | label | 0x00 | k)
+ *		K1 = HMAC-SHA-256(key, 0x00000001 | label | 0x00 | context | k)
+ *		K1 = HMAC-SHA-384(key, 0x00000001 | label | 0x00 | context | k)
+ *	[rfc8009 sec 3]
+ */
+static int rfc8009_calc_KDF_HMAC_SHA2(const struct krb5_enctype *krb5,
+				      const struct krb5_buffer *key,
+				      const struct krb5_buffer *label,
+				      const struct krb5_buffer *context,
+				      unsigned int k,
+				      struct krb5_buffer *result,
+				      gfp_t gfp)
+{
+	struct crypto_shash *shash;
+	struct krb5_buffer K1, data;
+	struct shash_desc *desc;
+	__be32 tmp;
+	size_t bsize;
+	void *buffer;
+	u8 *p;
+	int ret = -ENOMEM;
+
+	if (WARN_ON(result->len != k / 8))
+		return -EINVAL;
+
+	shash = crypto_alloc_shash(krb5->cksum_name, 0, 0);
+	if (IS_ERR(shash))
+		return (PTR_ERR(shash) == -ENOENT) ? -ENOPKG : PTR_ERR(shash);
+	ret = crypto_shash_setkey(shash, key->data, key->len);
+	if (ret < 0)
+		goto error_shash;
+
+	ret = -EINVAL;
+	if (WARN_ON(crypto_shash_digestsize(shash) * 8 < k))
+		goto error_shash;
+
+	ret = -ENOMEM;
+	data.len = 4 + label->len + 1 + context->len + 4;
+	bsize = krb5_shash_size(shash) +
+		krb5_digest_size(shash) +
+		crypto_roundup(data.len);
+	buffer = kzalloc(bsize, GFP_NOFS);
+	if (!buffer)
+		goto error_shash;
+
+	desc = buffer;
+	desc->tfm = shash;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error;
+
+	p = data.data = buffer +
+		krb5_shash_size(shash) +
+		krb5_digest_size(shash);
+	*(__be32 *)p = htonl(0x00000001);
+	p += 4;
+	memcpy(p, label->data, label->len);
+	p += label->len;
+	*p++ = 0;
+	memcpy(p, context->data, context->len);
+	p += context->len;
+	tmp = htonl(k);
+	memcpy(p, &tmp, 4);
+	p += 4;
+
+	ret = -EINVAL;
+	if (WARN_ON(p - (u8 *)data.data != data.len))
+		goto error;
+
+	K1.len = crypto_shash_digestsize(shash);
+	K1.data = buffer +
+		krb5_shash_size(shash);
+
+	ret = crypto_shash_finup(desc, data.data, data.len, K1.data);
+	if (ret < 0)
+		goto error;
+
+	memcpy(result->data, K1.data, result->len);
+
+error:
+	kfree_sensitive(buffer);
+error_shash:
+	crypto_free_shash(shash);
+	return ret;
+}
+
+/*
+ * Calculate the pseudo-random function, PRF().
+ *
+ *	PRF = KDF-HMAC-SHA2(input-key, "prf", octet-string, 256)
+ *	PRF = KDF-HMAC-SHA2(input-key, "prf", octet-string, 384)
+ *
+ *      The "prfconstant" used in the PRF operation is the three-octet string
+ *      "prf".
+ *      [rfc8009 sec 5]
+ */
+static int rfc8009_calc_PRF(const struct krb5_enctype *krb5,
+			    const struct krb5_buffer *input_key,
+			    const struct krb5_buffer *octet_string,
+			    struct krb5_buffer *result,
+			    gfp_t gfp)
+{
+	static const struct krb5_buffer prfconstant = { 3, "prf" };
+
+	return rfc8009_calc_KDF_HMAC_SHA2(krb5, input_key, &prfconstant,
+					  octet_string, krb5->prf_len * 8,
+					  result, gfp);
+}
+
+/*
+ * Derive Ke.
+ *	Ke = KDF-HMAC-SHA2(base-key, usage | 0xAA, 128)
+ *	Ke = KDF-HMAC-SHA2(base-key, usage | 0xAA, 256)
+ *      [rfc8009 sec 5]
+ */
+static int rfc8009_calc_Ke(const struct krb5_enctype *krb5,
+			   const struct krb5_buffer *base_key,
+			   const struct krb5_buffer *usage_constant,
+			   struct krb5_buffer *result,
+			   gfp_t gfp)
+{
+	return rfc8009_calc_KDF_HMAC_SHA2(krb5, base_key, usage_constant,
+					  &rfc8009_no_context, krb5->key_bytes * 8,
+					  result, gfp);
+}
+
+/*
+ * Derive Kc/Ki
+ *	Kc = KDF-HMAC-SHA2(base-key, usage | 0x99, 128)
+ *	Ki = KDF-HMAC-SHA2(base-key, usage | 0x55, 128)
+ *	Kc = KDF-HMAC-SHA2(base-key, usage | 0x99, 192)
+ *	Ki = KDF-HMAC-SHA2(base-key, usage | 0x55, 192)
+ *      [rfc8009 sec 5]
+ */
+static int rfc8009_calc_Ki(const struct krb5_enctype *krb5,
+			   const struct krb5_buffer *base_key,
+			   const struct krb5_buffer *usage_constant,
+			   struct krb5_buffer *result,
+			   gfp_t gfp)
+{
+	return rfc8009_calc_KDF_HMAC_SHA2(krb5, base_key, usage_constant,
+					  &rfc8009_no_context, krb5->cksum_len * 8,
+					  result, gfp);
+}
+
+/*
+ * AES random-to-key function.  For AES, this is an identity operation.
+ */
+static int rfc8009_random_to_key(const struct krb5_enctype *krb5,
+				 const struct krb5_buffer *randombits,
+				 struct krb5_buffer *result)
+{
+	if (randombits->len != 16 && randombits->len != 32)
+		return -EINVAL;
+
+	if (result->len != randombits->len)
+		return -EINVAL;
+
+	memcpy(result->data, randombits->data, randombits->len);
+	return 0;
+}
+
+static const struct krb5_crypto_profile rfc8009_crypto_profile = {
+	.calc_PRF	= rfc8009_calc_PRF,
+	.calc_Kc	= rfc8009_calc_Ki,
+	.calc_Ke	= rfc8009_calc_Ke,
+	.calc_Ki	= rfc8009_calc_Ki,
+	.encrypt	= NULL, //rfc8009_encrypt,
+	.decrypt	= NULL, //rfc8009_decrypt,
+	.get_mic	= rfc3961_get_mic,
+	.verify_mic	= rfc3961_verify_mic,
+};
+
+const struct krb5_enctype krb5_aes128_cts_hmac_sha256_128 = {
+	.etype		= KRB5_ENCTYPE_AES128_CTS_HMAC_SHA256_128,
+	.ctype		= KRB5_CKSUMTYPE_HMAC_SHA256_128_AES128,
+	.name		= "aes128-cts-hmac-sha256-128",
+	.encrypt_name	= "cts(cbc(aes))",
+	.cksum_name	= "hmac(sha256)",
+	.hash_name	= "sha256",
+	.key_bytes	= 16,
+	.key_len	= 16,
+	.Kc_len		= 16,
+	.Ke_len		= 16,
+	.Ki_len		= 16,
+	.block_len	= 16,
+	.conf_len	= 16,
+	.cksum_len	= 16,
+	.hash_len	= 20,
+	.prf_len	= 32,
+	.keyed_cksum	= true,
+	.random_to_key	= rfc8009_random_to_key,
+	.profile	= &rfc8009_crypto_profile,
+};
+
+const struct krb5_enctype krb5_aes256_cts_hmac_sha384_192 = {
+	.etype		= KRB5_ENCTYPE_AES256_CTS_HMAC_SHA384_192,
+	.ctype		= KRB5_CKSUMTYPE_HMAC_SHA384_192_AES256,
+	.name		= "aes256-cts-hmac-sha384-192",
+	.encrypt_name	= "cts(cbc(aes))",
+	.cksum_name	= "hmac(sha384)",
+	.hash_name	= "sha384",
+	.key_bytes	= 32,
+	.key_len	= 32,
+	.Kc_len		= 24,
+	.Ke_len		= 32,
+	.Ki_len		= 24,
+	.block_len	= 16,
+	.conf_len	= 16,
+	.cksum_len	= 24,
+	.hash_len	= 20,
+	.prf_len	= 48,
+	.keyed_cksum	= true,
+	.random_to_key	= rfc8009_random_to_key,
+	.profile	= &rfc8009_crypto_profile,
+};
diff --git a/include/crypto/krb5.h b/include/crypto/krb5.h
index b83d3d487753..f38a5b4d97ee 100644
--- a/include/crypto/krb5.h
+++ b/include/crypto/krb5.h
@@ -32,6 +32,8 @@ struct scatterlist;
 #define KRB5_ENCTYPE_DES3_CBC_SHA1		0x0010
 #define KRB5_ENCTYPE_AES128_CTS_HMAC_SHA1_96	0x0011
 #define KRB5_ENCTYPE_AES256_CTS_HMAC_SHA1_96	0x0012
+#define KRB5_ENCTYPE_AES128_CTS_HMAC_SHA256_128	0x0013
+#define KRB5_ENCTYPE_AES256_CTS_HMAC_SHA384_192	0x0014
 #define KRB5_ENCTYPE_ARCFOUR_HMAC		0x0017
 #define KRB5_ENCTYPE_ARCFOUR_HMAC_EXP		0x0018
 #define KRB5_ENCTYPE_UNKNOWN			0x01ff
@@ -46,6 +48,8 @@ struct scatterlist;
 #define KRB5_CKSUMTYPE_HMAC_SHA1_DES3		0x000c
 #define KRB5_CKSUMTYPE_HMAC_SHA1_96_AES128	0x000f
 #define KRB5_CKSUMTYPE_HMAC_SHA1_96_AES256	0x0010
+#define KRB5_CKSUMTYPE_HMAC_SHA256_128_AES128	0x0013
+#define KRB5_CKSUMTYPE_HMAC_SHA384_192_AES256	0x0014
 #define KRB5_CKSUMTYPE_HMAC_MD5_ARCFOUR		-138 /* Microsoft md5 hmac cksumtype */
 
 /*


