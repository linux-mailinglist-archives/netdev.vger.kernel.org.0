Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA2F2B0561
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgKLM6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:58:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728339AbgKLM6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:58:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SySPm7r+Xs/nsq8dnyoEL5ZEMshgWivB2CrExFwxAHM=;
        b=Z9hBglv6U5FlKln9X0/IjEbJ1B9Iz5K9dZ5t60Bmjq2er6Axls9Mn577p4iwfgi6WlJYyP
        MuIX7L7Blv1M8wgLzFUrZNIjFjbwsVQx9n5+0bZoPPQx9a4OWN3bgthgAj0J0J/vs3VrpW
        M7TzoXagGuHH+t6ZBlpUk64Ypqs7gOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-6asMlXxbMB2Dc-JzdtiQKA-1; Thu, 12 Nov 2020 07:58:30 -0500
X-MC-Unique: 6asMlXxbMB2Dc-JzdtiQKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD60C1882FA3;
        Thu, 12 Nov 2020 12:58:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C87D910013BD;
        Thu, 12 Nov 2020 12:58:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 05/18] crypto/krb5: Implement the Kerberos5 rfc3961 encrypt
 and decrypt functions
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:58:26 +0000
Message-ID: <160518590606.2277919.18393717448457481276.stgit@warthog.procyon.org.uk>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add functions that encrypt and decrypt a piece of an skbuff according to
rfc3961 sec 5.3, using Ki to checksum the data to be secured and Ke to
encrypt it during the encryption phase, then decrypting with Ke and
verifying the checksum with Ki in the decryption phase.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/krb5/internal.h           |   18 +++
 crypto/krb5/main.c               |  102 +++++++++++++++++++
 crypto/krb5/rfc3961_simplified.c |  204 ++++++++++++++++++++++++++++++++++++++
 include/crypto/krb5.h            |   12 ++
 4 files changed, 336 insertions(+)

diff --git a/crypto/krb5/internal.h b/crypto/krb5/internal.h
index 874dddada713..ce07decf19f0 100644
--- a/crypto/krb5/internal.h
+++ b/crypto/krb5/internal.h
@@ -7,6 +7,7 @@
 
 #include <linux/scatterlist.h>
 #include <crypto/krb5.h>
+#include <crypto/hash.h>
 
 /*
  * Profile used for key derivation and encryption.
@@ -87,7 +88,24 @@ struct krb5_crypto_profile {
 	crypto_roundup(crypto_sync_skcipher_ivsize(TFM))
 #define round16(x) (((x) + 15) & ~15)
 
+/*
+ * main.c
+ */
+int crypto_shash_update_sg(struct shash_desc *desc, struct scatterlist *sg,
+			   size_t offset, size_t len);
+
 /*
  * rfc3961_simplified.c
  */
 extern const struct krb5_crypto_profile rfc3961_simplified_profile;
+
+ssize_t rfc3961_encrypt(const struct krb5_enctype *krb5,
+			struct krb5_enc_keys *keys,
+			struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+			size_t data_offset, size_t data_len,
+			bool preconfounded);
+int rfc3961_decrypt(const struct krb5_enctype *krb5,
+		    struct krb5_enc_keys *keys,
+		    struct scatterlist *sg, unsigned nr_sg,
+		    size_t *_offset, size_t *_len,
+		    int *_error_code);
diff --git a/crypto/krb5/main.c b/crypto/krb5/main.c
index 58d40252adc9..db3fc34be272 100644
--- a/crypto/krb5/main.c
+++ b/crypto/krb5/main.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
+#include <linux/highmem.h>
 #include "internal.h"
 
 MODULE_DESCRIPTION("Kerberos 5 crypto");
@@ -40,3 +41,104 @@ const struct krb5_enctype *crypto_krb5_find_enctype(u32 enctype)
 	return NULL;
 }
 EXPORT_SYMBOL(crypto_krb5_find_enctype);
+
+int crypto_shash_update_sg(struct shash_desc *desc, struct scatterlist *sg,
+			   size_t offset, size_t len)
+{
+	for (;; sg++) {
+		int ret;
+
+		if (offset < sg->length) {
+			struct page *page = sg_page(sg);
+			void *p = kmap_atomic(page);
+			size_t seg = min_t(size_t, len, sg->length - offset);
+
+			ret = crypto_shash_update(desc, p + sg->offset + offset, seg);
+			kunmap_atomic(p);
+			if (ret < 0)
+				return ret;
+			len -= seg;
+			offset = 0;
+		} else {
+			offset -= sg->length;
+		}
+		if (sg_is_last(sg) || len > 0)
+			break;
+	}
+
+	return 0;
+}
+
+/**
+ * crypto_krb5_encrypt - Apply Kerberos encryption and integrity.
+ * @krb5: The encoding to use.
+ * @keys: The encryption and integrity keys to use.
+ * @sg: Scatterlist defining the crypto buffer.
+ * @nr_sg: The number of elements in @sg.
+ * @sg_len: The size of the buffer.
+ * @data_offset: The offset of the data in the @sg buffer.
+ * @data_len: The length of the data.
+ * @preconfounded: True if the confounder is already inserted.
+ *
+ * Using the specified Kerberos encoding, insert a confounder and padding as
+ * needed, encrypt this and the data in place and insert an integrity checksum
+ * into the buffer.
+ *
+ * The buffer must include space for the confounder, the checksum and any
+ * padding required.  The caller can preinsert the confounder into the buffer
+ * (for testing, for example).
+ *
+ * The resulting secured blob may be less than the size of the buffer.
+ *
+ * Returns the size of the secure blob if successful, -ENOMEM on an allocation
+ * failure, -EFAULT if there is insufficient space, -EMSGSIZE if the confounder
+ * is too short or the data is misaligned.  Other errors may also be returned
+ * from the crypto layer.
+ */
+ssize_t crypto_krb5_encrypt(const struct krb5_enctype *krb5,
+			    struct krb5_enc_keys *keys,
+			    struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+			    size_t data_offset, size_t data_len,
+			    bool preconfounded)
+{
+	if (WARN_ON(data_offset > sg_len ||
+		    data_len > sg_len ||
+		    data_offset > sg_len - data_len))
+		return -EMSGSIZE;
+	return krb5->profile->encrypt(krb5, keys, sg, nr_sg, sg_len,
+				      data_offset, data_len, preconfounded);
+}
+EXPORT_SYMBOL(crypto_krb5_encrypt);
+
+/**
+ * crypto_krb5_decrypt - Validate and remove Kerberos encryption and integrity.
+ * @krb5: The encoding to use.
+ * @keys: The encryption and integrity keys to use.
+ * @sg: Scatterlist defining the crypto buffer.
+ * @nr_sg: The number of elements in @sg.
+ * @_offset: Offset of the secure blob in the buffer; updated to data offset.
+ * @_len: The length of the secure blob; updated to data length.
+ * @_error_code: Set to a Kerberos error code for parsing/validation errors.
+ *
+ * Using the specified Kerberos encoding, check and remove the integrity
+ * checksum and decrypt the secure region, stripping off the confounder.
+ *
+ * If successful, @_offset and @_len are updated to outline the region in which
+ * the data plus the trailing padding are stored.  The caller is responsible
+ * for working out how much padding there is and removing it.
+ *
+ * Returns the 0 if successful, -ENOMEM on an allocation failure; sets
+ * *_error_code and returns -EPROTO if the data cannot be parsed or if the
+ * integrity checksum doesn't match).  Other errors may also be returned from
+ * the crypto layer.
+ */
+int crypto_krb5_decrypt(const struct krb5_enctype *krb5,
+			struct krb5_enc_keys *keys,
+			struct scatterlist *sg, unsigned nr_sg,
+			size_t *_offset, size_t *_len,
+			int *_error_code)
+{
+	return krb5->profile->decrypt(krb5, keys, sg, nr_sg,
+				      _offset, _len, _error_code);
+}
+EXPORT_SYMBOL(crypto_krb5_decrypt);
diff --git a/crypto/krb5/rfc3961_simplified.c b/crypto/krb5/rfc3961_simplified.c
index 0a5c689f6354..0a5c19b83f51 100644
--- a/crypto/krb5/rfc3961_simplified.c
+++ b/crypto/krb5/rfc3961_simplified.c
@@ -65,6 +65,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/random.h>
+#include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/lcm.h>
 #include <crypto/skcipher.h>
@@ -386,9 +388,211 @@ static int rfc3961_calc_PRF(const struct krb5_enctype *krb5,
 	return ret;
 }
 
+/*
+ * Apply encryption and checksumming functions to part of a scatterlist.
+ */
+ssize_t rfc3961_encrypt(const struct krb5_enctype *krb5,
+			struct krb5_enc_keys *keys,
+			struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+			size_t data_offset, size_t data_len,
+			bool preconfounded)
+{
+	struct skcipher_request	*req;
+	struct shash_desc *desc;
+	ssize_t ret, done;
+	size_t bsize, base_len, secure_offset, secure_len, pad_len, cksum_offset;
+	void *buffer;
+	u8 *cksum, *iv;
+
+	if (WARN_ON(data_offset != krb5->conf_len))
+		return -EINVAL; /* Can't set offset on skcipher */
+
+	secure_offset = 0;
+	base_len = krb5->conf_len + data_len;
+	if (krb5->pad) {
+		secure_len = round_up(base_len, krb5->block_len);
+		pad_len    = secure_len - base_len;
+	} else {
+		secure_len = base_len;
+		pad_len    = 0;
+	}
+	cksum_offset = secure_len;
+	if (WARN_ON(cksum_offset + krb5->cksum_len > sg_len))
+		return -EFAULT;
+
+	bsize = krb5_shash_size(keys->Ki) +
+		krb5_digest_size(keys->Ki) +
+		krb5_sync_skcipher_size(keys->Ke) +
+		krb5_sync_skcipher_ivsize(keys->Ke);
+	bsize = max_t(size_t, bsize, krb5->conf_len);
+	bsize = max_t(size_t, bsize, krb5->block_len);
+	buffer = kzalloc(bsize, GFP_NOFS);
+	if (!buffer)
+		return -ENOMEM;
+
+	/* Insert the confounder into the skb */
+	ret = -EFAULT;
+	if (!preconfounded) {
+		get_random_bytes(buffer, krb5->conf_len);
+		done = sg_pcopy_from_buffer(sg, nr_sg, buffer, krb5->conf_len,
+					    secure_offset);
+		if (done != krb5->conf_len)
+			goto error;
+	}
+
+	/* We need to pad out to the crypto blocksize. */
+	if (pad_len) {
+		done = sg_zero_buffer(sg, nr_sg, pad_len, data_offset + data_len);
+		if (done != pad_len)
+			goto error;
+	}
+
+	/* Calculate the checksum using key Ki */
+	cksum = buffer + krb5_shash_size(keys->Ki);
+
+	desc = buffer;
+	desc->tfm = keys->Ki;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error;
+
+	ret = crypto_shash_update_sg(desc, sg, secure_offset, secure_len);
+	if (ret < 0)
+		goto error;
+
+	ret = crypto_shash_final(desc, cksum);
+	if (ret < 0)
+		goto error;
+
+	/* Append the checksum into the buffer. */
+	ret = -EFAULT;
+	done = sg_pcopy_from_buffer(sg, nr_sg, cksum, krb5->cksum_len, cksum_offset);
+	if (done != krb5->cksum_len)
+		goto error;
+
+	/* Encrypt the secure region with key Ke. */
+	req = buffer +
+		krb5_shash_size(keys->Ki) +
+		krb5_digest_size(keys->Ki);
+	iv = buffer +
+		krb5_shash_size(keys->Ki) +
+		krb5_digest_size(keys->Ki) +
+		krb5_sync_skcipher_size(keys->Ke);
+
+	skcipher_request_set_sync_tfm(req, keys->Ke);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, sg, sg, secure_len, iv);
+	ret = crypto_skcipher_encrypt(req);
+	if (ret < 0)
+		goto error;
+
+	ret = secure_len + krb5->cksum_len;
+
+error:
+	kfree_sensitive(buffer);
+	return ret;
+}
+
+/*
+ * Apply decryption and checksumming functions to part of an skbuff.  The
+ * offset and length are updated to reflect the actual content of the encrypted
+ * region.
+ */
+int rfc3961_decrypt(const struct krb5_enctype *krb5,
+		    struct krb5_enc_keys *keys,
+		    struct scatterlist *sg, unsigned nr_sg,
+		    size_t *_offset, size_t *_len,
+		    int *_error_code)
+{
+	struct skcipher_request	*req;
+	struct shash_desc *desc;
+	ssize_t done;
+	size_t bsize, secure_len, offset = *_offset, len = *_len;
+	void *buffer = NULL;
+	int ret;
+	u8 *cksum, *cksum2, *iv;
+
+	if (WARN_ON(*_offset != 0))
+		return -EINVAL; /* Can't set offset on skcipher */
+
+	if (len < krb5->conf_len + krb5->cksum_len) {
+		*_error_code = 1; //RXGK_SEALED_INCON;
+		return -EPROTO;
+	}
+	secure_len = len - krb5->cksum_len;
+
+	bsize = krb5_shash_size(keys->Ki) +
+		krb5_digest_size(keys->Ki) * 2 +
+		krb5_sync_skcipher_size(keys->Ke) +
+		krb5_sync_skcipher_ivsize(keys->Ke);
+	buffer = kzalloc(bsize, GFP_NOFS);
+	if (!buffer)
+		return -ENOMEM;
+
+	/* Decrypt the secure region with key Ke. */
+	req = buffer +
+		krb5_shash_size(keys->Ki) +
+		krb5_digest_size(keys->Ki) * 2;
+	iv = buffer +
+		krb5_shash_size(keys->Ki) +
+		krb5_digest_size(keys->Ki) * 2 +
+		krb5_sync_skcipher_size(keys->Ke);
+
+	skcipher_request_set_sync_tfm(req, keys->Ke);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, sg, sg, secure_len, iv);
+	ret = crypto_skcipher_decrypt(req);
+	if (ret < 0)
+		goto error;
+
+	/* Calculate the checksum using key Ki */
+	cksum = buffer +
+		krb5_shash_size(keys->Ki);
+	cksum2 = buffer +
+		krb5_shash_size(keys->Ki) +
+		krb5_digest_size(keys->Ki);
+
+	desc = buffer;
+	desc->tfm = keys->Ki;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error;
+
+	ret = crypto_shash_update_sg(desc, sg, 0, secure_len);
+	if (ret < 0)
+		goto error;
+
+	ret = crypto_shash_final(desc, cksum);
+	if (ret < 0)
+		goto error;
+
+	/* Get the checksum from the buffer. */
+	ret = -EFAULT;
+	done = sg_pcopy_to_buffer(sg, nr_sg, cksum2, krb5->cksum_len,
+				  offset + len - krb5->cksum_len);
+	if (done != krb5->cksum_len)
+		goto error;
+
+	if (memcmp(cksum, cksum2, krb5->cksum_len) != 0) {
+		*_error_code = 1; //RXGK_SEALED_INCON;
+		ret = -EPROTO;
+		goto error;
+	}
+
+	*_offset += krb5->conf_len;
+	*_len -= krb5->conf_len + krb5->cksum_len;
+	ret = 0;
+
+error:
+	kfree_sensitive(buffer);
+	return ret;
+}
+
 const struct krb5_crypto_profile rfc3961_simplified_profile = {
 	.calc_PRF	= rfc3961_calc_PRF,
 	.calc_Kc	= rfc3961_calc_DK,
 	.calc_Ke	= rfc3961_calc_DK,
 	.calc_Ki	= rfc3961_calc_DK,
+	.encrypt	= rfc3961_encrypt,
+	.decrypt	= rfc3961_decrypt,
 };
diff --git a/include/crypto/krb5.h b/include/crypto/krb5.h
index 04286bacaf06..fb77f70117c1 100644
--- a/include/crypto/krb5.h
+++ b/include/crypto/krb5.h
@@ -12,6 +12,8 @@
 #ifndef _CRYPTO_KRB5_H
 #define _CRYPTO_KRB5_H
 
+#include <linux/crypto.h>
+
 struct crypto_shash;
 struct scatterlist;
 
@@ -103,6 +105,16 @@ struct krb5_enctype {
  */
 extern const struct krb5_enctype *crypto_krb5_find_enctype(u32 enctype);
 
+extern ssize_t crypto_krb5_encrypt(const struct krb5_enctype *krb5,
+				   struct krb5_enc_keys *keys,
+				   struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+				   size_t data_offset, size_t data_len,
+				   bool preconfounded);
+extern int crypto_krb5_decrypt(const struct krb5_enctype *krb5,
+			       struct krb5_enc_keys *keys,
+			       struct scatterlist *sg, unsigned nr_sg,
+			       size_t *_offset, size_t *_len,
+			       int *_error_code);
 /*
  * kdf.c
  */


