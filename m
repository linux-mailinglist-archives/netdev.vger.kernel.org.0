Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20202B056A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgKLM65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:58:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727899AbgKLM6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F9/Aivm7UY4Jytt/W9rNpmH3aylT9UiLECcuGtPXRFQ=;
        b=jO7zDhbDnu/moViO3cCQJGgGxUiaJ2IwbnRBwnb7vIcMSh0i4pzOCwKchJZfKIrSy7UPIr
        K0hH4KXMAWA+u85tqVXj5Wi+d2jl7FXVFwlnO88RW9r0eyRQyk1exPCjmbWGnytnvxs661
        QK1Se29puAZ3kE5wAnznB0tJ9jBWUY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-W4ve4Mf7PUSviEIJUghsjA-1; Thu, 12 Nov 2020 07:58:38 -0500
X-MC-Unique: W4ve4Mf7PUSviEIJUghsjA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08EF9804777;
        Thu, 12 Nov 2020 12:58:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D754127CC1;
        Thu, 12 Nov 2020 12:58:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 06/18] crypto/krb5: Implement the Kerberos5 rfc3961 get_mic
 and verify_mic
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:58:34 +0000
Message-ID: <160518591404.2277919.10560122154909780177.stgit@warthog.procyon.org.uk>
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

Add functions that sign and verify a piece of an skbuff according to
rfc3961 sec 5.4, using Kc to generate a checksum and insert it into the MIC
field in the skbuff in the sign phase then checksum the data and compare it
to the MIC in the verify phase.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/krb5/internal.h           |   11 +++
 crypto/krb5/main.c               |   70 ++++++++++++++++++++
 crypto/krb5/rfc3961_simplified.c |  134 ++++++++++++++++++++++++++++++++++++++
 include/crypto/krb5.h            |   12 +++
 4 files changed, 227 insertions(+)

diff --git a/crypto/krb5/internal.h b/crypto/krb5/internal.h
index ce07decf19f0..20b506327491 100644
--- a/crypto/krb5/internal.h
+++ b/crypto/krb5/internal.h
@@ -109,3 +109,14 @@ int rfc3961_decrypt(const struct krb5_enctype *krb5,
 		    struct scatterlist *sg, unsigned nr_sg,
 		    size_t *_offset, size_t *_len,
 		    int *_error_code);
+ssize_t rfc3961_get_mic(const struct krb5_enctype *krb5,
+			struct crypto_shash *shash,
+			const struct krb5_buffer *metadata,
+			struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+			size_t data_offset, size_t data_len);
+int rfc3961_verify_mic(const struct krb5_enctype *krb5,
+		       struct crypto_shash *shash,
+		       const struct krb5_buffer *metadata,
+		       struct scatterlist *sg, unsigned nr_sg,
+		       size_t *_offset, size_t *_len,
+		       int *_error_code);
diff --git a/crypto/krb5/main.c b/crypto/krb5/main.c
index db3fc34be272..97b28e40f6d7 100644
--- a/crypto/krb5/main.c
+++ b/crypto/krb5/main.c
@@ -142,3 +142,73 @@ int crypto_krb5_decrypt(const struct krb5_enctype *krb5,
 				      _offset, _len, _error_code);
 }
 EXPORT_SYMBOL(crypto_krb5_decrypt);
+
+/**
+ * crypto_krb5_get_mic - Apply Kerberos integrity checksum.
+ * @krb5: The encoding to use.
+ * @shash: The keyed hash to use.
+ * @metadata: Metadata to add into the hash before adding the data.
+ * @sg: Scatterlist defining the crypto buffer.
+ * @nr_sg: The number of elements in @sg.
+ * @sg_len: The size of the buffer.
+ * @data_offset: The offset of the data in the @sg buffer.
+ * @data_len: The length of the data.
+ *
+ * Using the specified Kerberos encoding, calculate and insert an integrity
+ * checksum into the buffer.
+ *
+ * The buffer must include space for the checksum at the front.
+ *
+ * Returns the size of the secure blob if successful, -ENOMEM on an allocation
+ * failure, -EFAULT if there is insufficient space, -EMSGSIZE if the gap for
+ * the checksum is too short.  Other errors may also be returned from the
+ * crypto layer.
+ */
+ssize_t crypto_krb5_get_mic(const struct krb5_enctype *krb5,
+			    struct crypto_shash *shash,
+			    const struct krb5_buffer *metadata,
+			    struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+			    size_t data_offset, size_t data_len)
+{
+	if (WARN_ON(data_offset > sg_len ||
+		    data_len > sg_len ||
+		    data_offset > sg_len - data_len))
+		return -EMSGSIZE;
+	return krb5->profile->get_mic(krb5, shash, metadata, sg, nr_sg, sg_len,
+				      data_offset, data_len);
+}
+EXPORT_SYMBOL(crypto_krb5_get_mic);
+
+/**
+ * crypto_krb5_verify_mic - Validate and remove Kerberos integrity checksum.
+ * @krb5: The encoding to use.
+ * @shash: The keyed hash to use.
+ * @metadata: Metadata to add into the hash before adding the data.
+ * @sg: Scatterlist defining the crypto buffer.
+ * @nr_sg: The number of elements in @sg.
+ * @_offset: Offset of the secure blob in the buffer; updated to data offset.
+ * @_len: The length of the secure blob; updated to data length.
+ * @_error_code: Set to a Kerberos error code for parsing/validation errors.
+ *
+ * Using the specified Kerberos encoding, check and remove the integrity
+ * checksum.
+ *
+ * If successful, @_offset and @_len are updated to outline the region in which
+ * the data is stored.
+ *
+ * Returns the 0 if successful, -ENOMEM on an allocation failure; sets
+ * *_error_code and returns -EPROTO if the data cannot be parsed or if the
+ * integrity checksum doesn't match).  Other errors may also be returned from
+ * the crypto layer.
+ */
+int crypto_krb5_verify_mic(const struct krb5_enctype *krb5,
+			   struct crypto_shash *shash,
+			   const struct krb5_buffer *metadata,
+			   struct scatterlist *sg, unsigned nr_sg,
+			   size_t *_offset, size_t *_len,
+			   int *_error_code)
+{
+	return krb5->profile->verify_mic(krb5, shash, metadata, sg, nr_sg,
+					 _offset, _len, _error_code);
+}
+EXPORT_SYMBOL(crypto_krb5_verify_mic);
diff --git a/crypto/krb5/rfc3961_simplified.c b/crypto/krb5/rfc3961_simplified.c
index 0a5c19b83f51..f779f962b921 100644
--- a/crypto/krb5/rfc3961_simplified.c
+++ b/crypto/krb5/rfc3961_simplified.c
@@ -588,6 +588,138 @@ int rfc3961_decrypt(const struct krb5_enctype *krb5,
 	return ret;
 }
 
+/*
+ * Generate a checksum over some metadata and part of an skbuff and insert the
+ * MIC into the skbuff immediately prior to the data.
+ */
+ssize_t rfc3961_get_mic(const struct krb5_enctype *krb5,
+			struct crypto_shash *shash,
+			const struct krb5_buffer *metadata,
+			struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+			size_t data_offset, size_t data_len)
+{
+	struct shash_desc *desc;
+	ssize_t ret, done;
+	size_t bsize;
+	void *buffer, *digest;
+
+	if (WARN_ON(data_offset != krb5->cksum_len))
+		return -EMSGSIZE;
+
+	bsize = krb5_shash_size(shash) +
+		krb5_digest_size(shash);
+	buffer = kzalloc(bsize, GFP_NOFS);
+	if (!buffer)
+		return -ENOMEM;
+
+	/* Calculate the MIC with key Kc and store it into the skb */
+	desc = buffer;
+	desc->tfm = shash;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error;
+
+	if (metadata) {
+		ret = crypto_shash_update(desc, metadata->data, metadata->len);
+		if (ret < 0)
+			goto error;
+	}
+
+	ret = crypto_shash_update_sg(desc, sg, data_offset, data_len);
+	if (ret < 0)
+		goto error;
+
+	digest = buffer + krb5_shash_size(shash);
+	ret = crypto_shash_final(desc, digest);
+	if (ret < 0)
+		goto error;
+
+	ret = -EFAULT;
+	done = sg_pcopy_from_buffer(sg, nr_sg, digest, krb5->cksum_len,
+				    data_offset - krb5->cksum_len);
+	if (done != krb5->cksum_len)
+		goto error;
+
+	ret = krb5->cksum_len + data_len;
+
+error:
+	kfree_sensitive(buffer);
+	return ret;
+}
+
+/*
+ * Check the MIC on a region of an skbuff.  The offset and length are updated
+ * to reflect the actual content of the secure region.
+ */
+int rfc3961_verify_mic(const struct krb5_enctype *krb5,
+		       struct crypto_shash *shash,
+		       const struct krb5_buffer *metadata,
+		       struct scatterlist *sg, unsigned nr_sg,
+		       size_t *_offset, size_t *_len,
+		       int *_error_code)
+{
+	struct shash_desc *desc;
+	ssize_t done;
+	size_t bsize, data_offset, data_len, offset = *_offset, len = *_len;
+	void *buffer = NULL;
+	int ret;
+	u8 *cksum, *cksum2;
+
+	if (len < krb5->cksum_len) {
+		*_error_code = 1; //RXGK_SEALED_INCON;
+		return -EPROTO;
+	}
+	data_offset = offset + krb5->cksum_len;
+	data_len = len - krb5->cksum_len;
+
+	bsize = krb5_shash_size(shash) +
+		krb5_digest_size(shash) * 2;
+	buffer = kzalloc(bsize, GFP_NOFS);
+	if (!buffer)
+		return -ENOMEM;
+
+	cksum = buffer +
+		krb5_shash_size(shash);
+	cksum2 = buffer +
+		krb5_shash_size(shash) +
+		krb5_digest_size(shash);
+
+	/* Calculate the MIC */
+	desc = buffer;
+	desc->tfm = shash;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error;
+
+	if (metadata) {
+		ret = crypto_shash_update(desc, metadata->data, metadata->len);
+		if (ret < 0)
+			goto error;
+	}
+
+	crypto_shash_update_sg(desc, sg, data_offset, data_len);
+	crypto_shash_final(desc, cksum);
+
+	ret = -EFAULT;
+	done = sg_pcopy_to_buffer(sg, nr_sg, cksum2, krb5->cksum_len, offset);
+	if (done != krb5->cksum_len)
+		goto error;
+
+	if (memcmp(cksum, cksum2, krb5->cksum_len) != 0) {
+		*_error_code = 1; //RXGK_SEALED_INCON;
+		ret = -EPROTO;
+		goto error;
+	}
+
+	*_offset += krb5->cksum_len;
+	*_len -= krb5->cksum_len;
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
@@ -595,4 +727,6 @@ const struct krb5_crypto_profile rfc3961_simplified_profile = {
 	.calc_Ki	= rfc3961_calc_DK,
 	.encrypt	= rfc3961_encrypt,
 	.decrypt	= rfc3961_decrypt,
+	.get_mic	= rfc3961_get_mic,
+	.verify_mic	= rfc3961_verify_mic,
 };
diff --git a/include/crypto/krb5.h b/include/crypto/krb5.h
index fb77f70117c1..b83d3d487753 100644
--- a/include/crypto/krb5.h
+++ b/include/crypto/krb5.h
@@ -115,6 +115,18 @@ extern int crypto_krb5_decrypt(const struct krb5_enctype *krb5,
 			       struct scatterlist *sg, unsigned nr_sg,
 			       size_t *_offset, size_t *_len,
 			       int *_error_code);
+extern ssize_t crypto_krb5_get_mic(const struct krb5_enctype *krb5,
+				   struct crypto_shash *shash,
+				   const struct krb5_buffer *metadata,
+				   struct scatterlist *sg, unsigned nr_sg, size_t sg_len,
+				   size_t data_offset, size_t data_len);
+extern int crypto_krb5_verify_mic(const struct krb5_enctype *krb5,
+				  struct crypto_shash *shash,
+				  const struct krb5_buffer *metadata,
+				  struct scatterlist *sg, unsigned nr_sg,
+				  size_t *_offset, size_t *_len,
+				  int *_error_code);
+
 /*
  * kdf.c
  */


