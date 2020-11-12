Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860102B0575
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgKLM7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:59:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728416AbgKLM7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:59:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnJhHrlydFaDDYDVAILjoCMJPy7l/G38vJ71iG4RtWQ=;
        b=WDZcoANBvWeQcISPnhPkMLoKlEoP9lWoQtscYoPS2tOwFm/EVjgGR0eHyYxSowBopZIC2t
        Q6GMvjrifWiRnA13JSDftfQke4VL2qPjOpkBYMYOWw6RtzNew4DfaAHtamrPuwJQeC6hU5
        wg1dUzVmOC+Wbk7uLjeJSGPDUFUtn1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-k4rmHDhkN72dmJfCls03fA-1; Thu, 12 Nov 2020 07:59:11 -0500
X-MC-Unique: k4rmHDhkN72dmJfCls03fA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1F2A879523;
        Thu, 12 Nov 2020 12:59:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B25D960C13;
        Thu, 12 Nov 2020 12:59:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 10/18] crypto/krb5: Implement the AES encrypt/decrypt from
 rfc8009
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:59:06 +0000
Message-ID: <160518594688.2277919.5319312384536950170.stgit@warthog.procyon.org.uk>
In-Reply-To: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
References: <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement encryption and decryption functions for AES + HMAC-SHA2 as
described in rfc8009 sec 5.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/krb5/rfc8009_aes2.c |  205 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 203 insertions(+), 2 deletions(-)

diff --git a/crypto/krb5/rfc8009_aes2.c b/crypto/krb5/rfc8009_aes2.c
index 9f0f0f410d91..df517435be73 100644
--- a/crypto/krb5/rfc8009_aes2.c
+++ b/crypto/krb5/rfc8009_aes2.c
@@ -10,6 +10,7 @@
 #include <crypto/skcipher.h>
 #include <crypto/hash.h>
 #include <linux/slab.h>
+#include <linux/random.h>
 #include "internal.h"
 
 static const struct krb5_buffer rfc8009_no_context = { .len = 0, .data = "" };
@@ -183,13 +184,213 @@ static int rfc8009_random_to_key(const struct krb5_enctype *krb5,
 	return 0;
 }
 
+/*
+ * Apply encryption and checksumming functions to part of an skbuff.
+ */
+static ssize_t rfc8009_encrypt(const struct krb5_enctype *krb5,
+			       struct krb5_enc_keys *keys,
+			       struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+			       size_t data_offset, size_t data_len,
+			       bool preconfounded)
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
+	base_len   = krb5->conf_len + data_len;
+	secure_len = base_len;
+	pad_len    = secure_len - base_len;
+	secure_offset = 0;
+	cksum_offset = secure_offset + secure_len;
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
+		done = sg_pcopy_to_buffer(sg, nr_sg, buffer, krb5->conf_len,
+					  secure_offset);
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
+	/* Calculate the checksum using key Ki */
+	cksum = buffer + krb5_shash_size(keys->Ki);
+
+	desc = buffer;
+	desc->tfm = keys->Ki;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error;
+
+	memset(iv, 0, crypto_sync_skcipher_ivsize(keys->Ke));
+	ret = crypto_shash_update(desc, iv, crypto_sync_skcipher_ivsize(keys->Ke));
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
+	sg_zero_buffer(sg, nr_sg, 3, cksum_offset);
+	done = sg_pcopy_from_buffer(sg, nr_sg, cksum, krb5->cksum_len, cksum_offset);
+	if (done != krb5->cksum_len)
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
+static int rfc8009_decrypt(const struct krb5_enctype *krb5,
+			   struct krb5_enc_keys *keys,
+			   struct scatterlist *sg, unsigned nr_sg,
+			   size_t *_offset, size_t *_len,
+			   int *_error_code)
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
+	cksum = buffer +
+		krb5_shash_size(keys->Ki);
+	cksum2 = buffer +
+		krb5_shash_size(keys->Ki) +
+		krb5_digest_size(keys->Ki);
+	req = buffer +
+		krb5_shash_size(keys->Ki) +
+		krb5_digest_size(keys->Ki) * 2;
+	iv = buffer +
+		krb5_shash_size(keys->Ki) +
+		krb5_digest_size(keys->Ki) * 2 +
+		krb5_sync_skcipher_size(keys->Ke);
+
+	/* Calculate the checksum using key Ki */
+	desc = buffer;
+	desc->tfm = keys->Ki;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error;
+
+	ret = crypto_shash_update(desc, iv, crypto_sync_skcipher_ivsize(keys->Ke));
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
+	/* Decrypt the secure region with key Ke. */
+	skcipher_request_set_sync_tfm(req, keys->Ke);
+	skcipher_request_set_callback(req, 0, NULL, NULL);
+	skcipher_request_set_crypt(req, sg, sg, secure_len, iv);
+	ret = crypto_skcipher_decrypt(req);
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
 static const struct krb5_crypto_profile rfc8009_crypto_profile = {
 	.calc_PRF	= rfc8009_calc_PRF,
 	.calc_Kc	= rfc8009_calc_Ki,
 	.calc_Ke	= rfc8009_calc_Ke,
 	.calc_Ki	= rfc8009_calc_Ki,
-	.encrypt	= NULL, //rfc8009_encrypt,
-	.decrypt	= NULL, //rfc8009_decrypt,
+	.encrypt	= rfc8009_encrypt,
+	.decrypt	= rfc8009_decrypt,
 	.get_mic	= rfc3961_get_mic,
 	.verify_mic	= rfc3961_verify_mic,
 };


