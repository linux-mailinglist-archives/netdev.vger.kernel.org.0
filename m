Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B302B05B4
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgKLNBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:01:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728275AbgKLM6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:58:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vlX81bfxkSnCx/kV2/K9DOewa6eFmGPkRqimXiZZar0=;
        b=fwO5y6k6zd03Ce/KDyFroReOuZ1euJ+jkRgXOWIjqTDhzwJ/mU7cBjKUcc9MC6QaRCNIaX
        Gy+VatQtMzCW+oobnaRL03Tig2cHOogJxjqevgwqxUHaUEvOWhwt6gJGeYAOX9x0mxGUOX
        byZtY2iCdvNVc5QaueLO1w6f5H/VwdI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-qb-NUw5ONfGnrv_CijFFuQ-1; Thu, 12 Nov 2020 07:58:14 -0500
X-MC-Unique: qb-NUw5ONfGnrv_CijFFuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79BE080364D;
        Thu, 12 Nov 2020 12:58:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74D5027BDC;
        Thu, 12 Nov 2020 12:58:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 03/18] crypto/krb5: Provide infrastructure and key derivation
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:58:09 +0000
Message-ID: <160518588968.2277919.3783200728891264713.stgit@warthog.procyon.org.uk>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide key derivation interface functions and a helper to implement the
PRF+ function from rfc4402.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/krb5/Makefile  |    1 
 crypto/krb5/kdf.c     |  223 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/krb5.h |   29 ++++++
 3 files changed, 253 insertions(+)
 create mode 100644 crypto/krb5/kdf.c

diff --git a/crypto/krb5/Makefile b/crypto/krb5/Makefile
index 071ce2ff82e5..b764c4d09bf2 100644
--- a/crypto/krb5/Makefile
+++ b/crypto/krb5/Makefile
@@ -4,6 +4,7 @@
 #
 
 krb5-y += \
+	kdf.o \
 	main.o
 
 obj-$(CONFIG_CRYPTO_KRB5) += krb5.o
diff --git a/crypto/krb5/kdf.c b/crypto/krb5/kdf.c
new file mode 100644
index 000000000000..8ef7ea31ee8a
--- /dev/null
+++ b/crypto/krb5/kdf.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Kerberos key derivation.
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <crypto/skcipher.h>
+#include <crypto/hash.h>
+#include "internal.h"
+
+/**
+ * crypto_krb5_free_enc_keys - Free an encryption keypair
+ * @e: The key pair to free.
+ */
+void crypto_krb5_free_enc_keys(struct krb5_enc_keys *e)
+{
+	if (e->Ke)
+		crypto_free_sync_skcipher(e->Ke);
+	if (e->Ki)
+		crypto_free_shash(e->Ki);
+	e->Ke = NULL;
+	e->Ki = NULL;
+}
+EXPORT_SYMBOL(crypto_krb5_free_enc_keys);
+
+/**
+ * crypto_krb5_calc_PRFplus - Calculate PRF+ [RFC4402]
+ * @krb5: The encryption type to use
+ * @K: The protocol key for the pseudo-random function
+ * @L: The length of the output
+ * @S: The input octet string
+ * @result: Result buffer, sized to krb5->prf_len
+ * @gfp: Allocation restrictions
+ *
+ * Calculate the kerberos pseudo-random function, PRF+() by the following
+ * method:
+ *
+ *      PRF+(K, L, S) = truncate(L, T1 || T2 || .. || Tn)
+ *      Tn = PRF(K, n || S)
+ *      [rfc4402 sec 2]
+ */
+int crypto_krb5_calc_PRFplus(const struct krb5_enctype *krb5,
+			     const struct krb5_buffer *K,
+			     unsigned int L,
+			     const struct krb5_buffer *S,
+			     struct krb5_buffer *result,
+			     gfp_t gfp)
+{
+	struct krb5_buffer T_series, Tn, n_S;
+	void *buffer;
+	int ret, n = 1;
+
+	Tn.len = krb5->prf_len;
+	T_series.len = 0;
+	n_S.len = 4 + S->len;
+
+	buffer = kzalloc(round16(L + Tn.len) + round16(n_S.len), gfp);
+	if (!buffer)
+		return -ENOMEM;
+
+	T_series.data = buffer;
+	n_S.data = buffer + round16(L + Tn.len);
+	memcpy(n_S.data + 4, S->data, S->len);
+
+	while (T_series.len < L) {
+		*(__be32 *)(n_S.data) = htonl(n);
+		Tn.data = T_series.data + Tn.len * (n - 1);
+		ret = krb5->profile->calc_PRF(krb5, K, &n_S, &Tn, gfp);
+		if (ret < 0)
+			goto err;
+		T_series.len += Tn.len;
+		n++;
+	}
+
+	/* Truncate to L */
+	memcpy(result->data, T_series.data, L);
+	ret = 0;
+
+err:
+	kfree_sensitive(buffer);
+	return ret;
+}
+EXPORT_SYMBOL(crypto_krb5_calc_PRFplus);
+
+/**
+ * crypto_krb5_get_Kc - Derive key Kc and install into a hash
+ * @krb5: The encryption type to use
+ * @TK: The base key
+ * @usage: The key usage number
+ * @key: Prepped buffer to store the key into
+ * @_shash: Where to put the hash (or NULL if not wanted)
+ * @gfp: Allocation restrictions
+ *
+ * Derive the Kerberos Kc checksumming key and, optionally, allocate a hash and
+ * install the key into it, returning the hash.  The key is stored into the
+ * prepared buffer.
+ */
+int crypto_krb5_get_Kc(const struct krb5_enctype *krb5,
+		       const struct krb5_buffer *TK,
+		       u32 usage,
+		       struct krb5_buffer *key,
+		       struct crypto_shash **_shash,
+		       gfp_t gfp)
+{
+	struct crypto_shash *shash;
+	int ret;
+	u8 buf[CRYPTO_MINALIGN] __aligned(CRYPTO_MINALIGN);
+	struct krb5_buffer usage_constant = { .len = 5, .data = buf };
+
+	*(__be32 *)buf = cpu_to_be32(usage);
+	buf[4] = KEY_USAGE_SEED_CHECKSUM;
+
+	key->len = krb5->Kc_len;
+	ret = krb5->profile->calc_Kc(krb5, TK, &usage_constant, key, gfp);
+	if (ret < 0)
+		return ret;
+
+	if (_shash) {
+		shash = crypto_alloc_shash(krb5->cksum_name, 0, 0);
+		if (IS_ERR(shash))
+			return (PTR_ERR(shash) == -ENOENT) ? -ENOPKG : PTR_ERR(shash);
+		*_shash = shash;
+		ret = crypto_shash_setkey(shash, key->data, key->len);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(crypto_krb5_get_Kc);
+
+/**
+ * crypto_krb5_get_Ke - Derive key Ke and install into an skcipher
+ * @krb5: The encryption type to use
+ * @TK: The base key
+ * @usage: The key usage number
+ * @key: Prepped buffer to store the key into
+ * @_ci: Where to put the cipher (or NULL if not wanted)
+ * @gfp: Allocation restrictions
+ *
+ * Derive the Kerberos Ke encryption key and, optionally, allocate an skcipher
+ * and install the key into it, returning the cipher.  The key is stored into
+ * the prepared buffer.
+ */
+int crypto_krb5_get_Ke(const struct krb5_enctype *krb5,
+		       const struct krb5_buffer *TK,
+		       u32 usage,
+		       struct krb5_buffer *key,
+		       struct crypto_sync_skcipher **_ci,
+		       gfp_t gfp)
+{
+	struct crypto_sync_skcipher *ci;
+	int ret;
+	u8 buf[CRYPTO_MINALIGN] __aligned(CRYPTO_MINALIGN);
+	struct krb5_buffer usage_constant = { .len = 5, .data = buf };
+
+	*(__be32 *)buf = cpu_to_be32(usage);
+	buf[4] = KEY_USAGE_SEED_ENCRYPTION;
+
+	key->len = krb5->Ke_len;
+	ret = krb5->profile->calc_Ke(krb5, TK, &usage_constant, key, gfp);
+	if (ret < 0)
+		return ret;
+
+	if (_ci) {
+		ci = crypto_alloc_sync_skcipher(krb5->encrypt_name, 0, 0);
+		if (IS_ERR(ci))
+			return (PTR_ERR(ci) == -ENOENT) ? -ENOPKG : PTR_ERR(ci);
+		*_ci = ci;
+		ret = crypto_sync_skcipher_setkey(ci, key->data, key->len);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(crypto_krb5_get_Ke);
+
+/**
+ * crypto_krb5_get_Ki - Derive key Ki and install into a hash
+ * @krb5: The encryption type to use
+ * @TK: The base key
+ * @usage: The key usage number
+ * @key: Prepped buffer to store the key into
+ * @_shash: Where to put the hash (or NULL if not wanted)
+ * @gfp: Allocation restrictions
+ *
+ * Derive the Kerberos Ki integrity checksum key and, optionally, allocate a
+ * hash and install the key into it, returning the hash.  The key is stored
+ * into the prepared buffer.
+ */
+int crypto_krb5_get_Ki(const struct krb5_enctype *krb5,
+		       const struct krb5_buffer *TK,
+		       u32 usage,
+		       struct krb5_buffer *key,
+		       struct crypto_shash **_shash,
+		       gfp_t gfp)
+{
+	struct crypto_shash *shash;
+	int ret;
+	u8 buf[CRYPTO_MINALIGN] __aligned(CRYPTO_MINALIGN);
+	struct krb5_buffer usage_constant = { .len = 5, .data = buf };
+
+	*(__be32 *)buf = cpu_to_be32(usage);
+	buf[4] = KEY_USAGE_SEED_INTEGRITY;
+
+	key->len = krb5->Ki_len;
+	ret = krb5->profile->calc_Kc(krb5, TK, &usage_constant, key, gfp);
+	if (ret < 0)
+		return ret;
+
+	if (_shash) {
+		shash = crypto_alloc_shash(krb5->cksum_name, 0, 0);
+		if (IS_ERR(shash))
+			return (PTR_ERR(shash) == -ENOENT) ? -ENOPKG : PTR_ERR(shash);
+		*_shash = shash;
+		ret = crypto_shash_setkey(shash, key->data, key->len);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(crypto_krb5_get_Ki);
diff --git a/include/crypto/krb5.h b/include/crypto/krb5.h
index a7e4ab4e1348..04286bacaf06 100644
--- a/include/crypto/krb5.h
+++ b/include/crypto/krb5.h
@@ -103,4 +103,33 @@ struct krb5_enctype {
  */
 extern const struct krb5_enctype *crypto_krb5_find_enctype(u32 enctype);
 
+/*
+ * kdf.c
+ */
+extern void crypto_krb5_free_enc_keys(struct krb5_enc_keys *e);
+extern int crypto_krb5_calc_PRFplus(const struct krb5_enctype *krb5,
+				    const struct krb5_buffer *K,
+				    unsigned int L,
+				    const struct krb5_buffer *S,
+				    struct krb5_buffer *result,
+				    gfp_t gfp);
+extern int crypto_krb5_get_Kc(const struct krb5_enctype *krb5,
+			      const struct krb5_buffer *TK,
+			      u32 usage,
+			      struct krb5_buffer *key,
+			      struct crypto_shash **_shash,
+			      gfp_t gfp);
+extern int crypto_krb5_get_Ke(const struct krb5_enctype *krb5,
+			      const struct krb5_buffer *TK,
+			      u32 usage,
+			      struct krb5_buffer *key,
+			      struct crypto_sync_skcipher **_ci,
+			      gfp_t gfp);
+extern int crypto_krb5_get_Ki(const struct krb5_enctype *krb5,
+			      const struct krb5_buffer *TK,
+			      u32 usage,
+			      struct krb5_buffer *key,
+			      struct crypto_shash **_shash,
+			      gfp_t gfp);
+
 #endif /* _CRYPTO_KRB5_H */


