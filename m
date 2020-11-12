Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADBC2B0588
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgKLM7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:59:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728384AbgKLM7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:59:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZU2g8g29AVG00nrqXhuF7WHQTv1UssjpwVpqGofl5Y=;
        b=avafvUOYRgUXpy+QStoM7SbxKud8XFCJ69t7IAifiQzqMQzLpZD7kaU/Ye70nTsrfg3Syq
        MoOsr8+35EaRAqPHmjGePKYjDIo4LjTh4Pafj4gKpzwen2/NvoD9qoLVE+PaedlVgCC2fI
        lPoSKysxlxuy3inwR2qbNZF20bc7pIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-UogHpdO7NX-KFKp1tTijVQ-1; Thu, 12 Nov 2020 07:59:27 -0500
X-MC-Unique: UogHpdO7NX-KFKp1tTijVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4772D1868405;
        Thu, 12 Nov 2020 12:59:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E559F5D9E4;
        Thu, 12 Nov 2020 12:59:23 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 12/18] crypto/krb5: Implement the Camellia enctypes from
 rfc6803
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:59:23 +0000
Message-ID: <160518596309.2277919.13684602434679285313.stgit@warthog.procyon.org.uk>
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

Implement the camellia128-cts-cmac and camellia256-cts-cmac enctypes from
rfc6803.

Note that the test vectors in rfc6803 for encryption are incomplete,
lacking the key usage number needed to derive Ke and Ki, and there are
errata for this:

	https://www.rfc-editor.org/errata_search.php?rfc=6803

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/krb5/Kconfig            |    3 
 crypto/krb5/Makefile           |    3 
 crypto/krb5/internal.h         |    6 +
 crypto/krb5/main.c             |    2 
 crypto/krb5/rfc6803_camellia.c |  249 ++++++++++++++++++++++++++++++++++++++++
 crypto/krb5/selftest_data.c    |  135 ++++++++++++++++++++++
 include/crypto/krb5.h          |    4 +
 7 files changed, 401 insertions(+), 1 deletion(-)
 create mode 100644 crypto/krb5/rfc6803_camellia.c

diff --git a/crypto/krb5/Kconfig b/crypto/krb5/Kconfig
index 5607c0c81049..6c0edf659c8f 100644
--- a/crypto/krb5/Kconfig
+++ b/crypto/krb5/Kconfig
@@ -3,12 +3,15 @@ config CRYPTO_KRB5
 	select CRYPTO_MANAGER
 	select CRYPTO_SKCIPHER
 	select CRYPTO_HASH_INFO
+	select CRYPTO_HMAC
+	select CRYPTO_CMAC
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	select CRYPTO_CBC
 	select CRYPTO_CTS
 	select CRYPTO_AES
+	select CRYPTO_CAMELLIA
 	help
 	  Provide Kerberos-5-based security.
 
diff --git a/crypto/krb5/Makefile b/crypto/krb5/Makefile
index 85763131f7b6..974e0bcef91d 100644
--- a/crypto/krb5/Makefile
+++ b/crypto/krb5/Makefile
@@ -8,7 +8,8 @@ krb5-y += \
 	main.o \
 	rfc3961_simplified.o \
 	rfc3962_aes.o \
-	rfc8009_aes2.o
+	rfc8009_aes2.o \
+	rfc6803_camellia.o
 
 krb5-$(CONFIG_CRYPTO_KRB5_SELFTESTS) += \
 	selftest.o \
diff --git a/crypto/krb5/internal.h b/crypto/krb5/internal.h
index e64f5e58199f..83662abc0765 100644
--- a/crypto/krb5/internal.h
+++ b/crypto/krb5/internal.h
@@ -158,6 +158,12 @@ int rfc3961_verify_mic(const struct krb5_enctype *krb5,
 extern const struct krb5_enctype krb5_aes128_cts_hmac_sha1_96;
 extern const struct krb5_enctype krb5_aes256_cts_hmac_sha1_96;
 
+/*
+ * rfc6803_camellia.c
+ */
+extern const struct krb5_enctype krb5_camellia128_cts_cmac;
+extern const struct krb5_enctype krb5_camellia256_cts_cmac;
+
 /*
  * rfc8009_aes2.c
  */
diff --git a/crypto/krb5/main.c b/crypto/krb5/main.c
index 9914d3417c21..b531eafb6db2 100644
--- a/crypto/krb5/main.c
+++ b/crypto/krb5/main.c
@@ -22,6 +22,8 @@ static const struct krb5_enctype *const krb5_supported_enctypes[] = {
 	&krb5_aes256_cts_hmac_sha1_96,
 	&krb5_aes128_cts_hmac_sha256_128,
 	&krb5_aes256_cts_hmac_sha384_192,
+	&krb5_camellia128_cts_cmac,
+	&krb5_camellia256_cts_cmac,
 };
 
 /**
diff --git a/crypto/krb5/rfc6803_camellia.c b/crypto/krb5/rfc6803_camellia.c
new file mode 100644
index 000000000000..adcb9c6481a3
--- /dev/null
+++ b/crypto/krb5/rfc6803_camellia.c
@@ -0,0 +1,249 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* rfc6803 Camellia Encryption for Kerberos 5
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
+/*
+ * Calculate the key derivation function KDF-FEEDBACK_CMAC(key, constant)
+ *
+ *	n = ceiling(k / 128)
+ *	K(0) = zeros
+ *	K(i) = CMAC(key, K(i-1) | i | constant | 0x00 | k)
+ *	DR(key, constant) = k-truncate(K(1) | K(2) | ... | K(n))
+ *	KDF-FEEDBACK-CMAC(key, constant) = random-to-key(DR(key, constant))
+ *
+ *	[rfc6803 sec 3]
+ */
+static int rfc6803_calc_KDF_FEEDBACK_CMAC(const struct krb5_enctype *krb5,
+					  const struct krb5_buffer *key,
+					  const struct krb5_buffer *constant,
+					  struct krb5_buffer *result,
+					  gfp_t gfp)
+{
+	struct crypto_shash *shash;
+	struct krb5_buffer K, data;
+	struct shash_desc *desc;
+	__be32 tmp;
+	size_t bsize, offset, seg;
+	void *buffer;
+	u32 i = 0, k = result->len * 8;
+	u8 *p;
+	int ret = -ENOMEM;
+
+	shash = crypto_alloc_shash(krb5->cksum_name, 0, 0);
+	if (IS_ERR(shash))
+		return (PTR_ERR(shash) == -ENOENT) ? -ENOPKG : PTR_ERR(shash);
+	ret = crypto_shash_setkey(shash, key->data, key->len);
+	if (ret < 0)
+		goto error_shash;
+
+	ret = -ENOMEM;
+	K.len = crypto_shash_digestsize(shash);
+	data.len = K.len + 4 + constant->len + 1 + 4;
+	bsize = krb5_shash_size(shash) +
+		krb5_digest_size(shash) +
+		crypto_roundup(K.len) +
+		crypto_roundup(data.len);
+	buffer = kzalloc(bsize, GFP_NOFS);
+	if (!buffer)
+		goto error_shash;
+
+	desc = buffer;
+	desc->tfm = shash;
+
+	K.data = buffer +
+		krb5_shash_size(shash) +
+		krb5_digest_size(shash);
+	data.data = buffer +
+		krb5_shash_size(shash) +
+		krb5_digest_size(shash) +
+		crypto_roundup(K.len);
+
+	p = data.data + K.len + 4;
+	memcpy(p, constant->data, constant->len);
+	p += constant->len;
+	*p++ = 0x00;
+	tmp = htonl(k);
+	memcpy(p, &tmp, 4);
+	p += 4;
+
+	ret = -EINVAL;
+	if (WARN_ON(p - (u8 *)data.data != data.len))
+		goto error;
+
+	offset = 0;
+	do {
+		i++;
+		p = data.data;
+		memcpy(p, K.data, K.len);
+		p += K.len;
+		*(__be32 *)p = htonl(i);
+
+		ret = crypto_shash_init(desc);
+		if (ret < 0)
+			goto error;
+		ret = crypto_shash_finup(desc, data.data, data.len, K.data);
+		if (ret < 0)
+			goto error;
+
+		seg = min_t(size_t, result->len - offset, K.len);
+		memcpy(result->data + offset, K.data, seg);
+		offset += seg;
+	} while (offset < result->len);
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
+ *	Kp = KDF-FEEDBACK-CMAC(protocol-key, "prf")
+ *	PRF = CMAC(Kp, octet-string)
+ *      [rfc6803 sec 6]
+ */
+static int rfc6803_calc_PRF(const struct krb5_enctype *krb5,
+			    const struct krb5_buffer *protocol_key,
+			    const struct krb5_buffer *octet_string,
+			    struct krb5_buffer *result,
+			    gfp_t gfp)
+{
+	static const struct krb5_buffer prfconstant = { 3, "prf" };
+	struct crypto_shash *shash;
+	struct krb5_buffer Kp;
+	struct shash_desc *desc;
+	size_t bsize;
+	void *buffer;
+	int ret;
+
+	Kp.len = krb5->prf_len;
+
+	shash = crypto_alloc_shash(krb5->cksum_name, 0, 0);
+	if (IS_ERR(shash))
+		return (PTR_ERR(shash) == -ENOENT) ? -ENOPKG : PTR_ERR(shash);
+
+	ret = -EINVAL;
+	if (result->len != crypto_shash_digestsize(shash))
+		goto out_shash;
+
+	ret = -ENOMEM;
+	bsize = krb5_shash_size(shash) +
+		krb5_digest_size(shash) +
+		crypto_roundup(Kp.len);
+	buffer = kzalloc(bsize, GFP_NOFS);
+	if (!buffer)
+		goto out_shash;
+
+	Kp.data = buffer +
+		krb5_shash_size(shash) +
+		krb5_digest_size(shash);
+
+	ret = rfc6803_calc_KDF_FEEDBACK_CMAC(krb5, protocol_key, &prfconstant,
+					     &Kp, gfp);
+	if (ret < 0)
+		goto out;
+
+	ret = crypto_shash_setkey(shash, Kp.data, Kp.len);
+	if (ret < 0)
+		goto out;
+
+	desc = buffer;
+	desc->tfm = shash;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto out;
+
+	ret = crypto_shash_finup(desc, octet_string->data, octet_string->len, result->data);
+	if (ret < 0)
+		goto out;
+
+out:
+	kfree_sensitive(buffer);
+out_shash:
+	crypto_free_shash(shash);
+	return ret;
+}
+
+/*
+ * Camellia random-to-key function.  This is an identity operation.
+ */
+static int rfc6803_random_to_key(const struct krb5_enctype *krb5,
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
+static const struct krb5_crypto_profile rfc6803_crypto_profile = {
+	.calc_PRF	= rfc6803_calc_PRF,
+	.calc_Kc	= rfc6803_calc_KDF_FEEDBACK_CMAC,
+	.calc_Ke	= rfc6803_calc_KDF_FEEDBACK_CMAC,
+	.calc_Ki	= rfc6803_calc_KDF_FEEDBACK_CMAC,
+	.encrypt	= rfc3961_encrypt,
+	.decrypt	= rfc3961_decrypt,
+	.get_mic	= rfc3961_get_mic,
+	.verify_mic	= rfc3961_verify_mic,
+};
+
+const struct krb5_enctype krb5_camellia128_cts_cmac = {
+	.etype		= KRB5_ENCTYPE_CAMELLIA128_CTS_CMAC,
+	.ctype		= KRB5_CKSUMTYPE_CMAC_CAMELLIA128,
+	.name		= "camellia128-cts-cmac",
+	.encrypt_name	= "cts(cbc(camellia))",
+	.cksum_name	= "cmac(camellia)",
+	.hash_name	= NULL,
+	.key_bytes	= 16,
+	.key_len	= 16,
+	.Kc_len		= 16,
+	.Ke_len		= 16,
+	.Ki_len		= 16,
+	.block_len	= 16,
+	.conf_len	= 16,
+	.cksum_len	= 16,
+	.hash_len	= 16,
+	.prf_len	= 16,
+	.keyed_cksum	= true,
+	.random_to_key	= rfc6803_random_to_key,
+	.profile	= &rfc6803_crypto_profile,
+};
+
+const struct krb5_enctype krb5_camellia256_cts_cmac = {
+	.etype		= KRB5_ENCTYPE_CAMELLIA256_CTS_CMAC,
+	.ctype		= KRB5_CKSUMTYPE_CMAC_CAMELLIA256,
+	.name		= "camellia256-cts-cmac",
+	.encrypt_name	= "cts(cbc(camellia))",
+	.cksum_name	= "cmac(camellia)",
+	.hash_name	= NULL,
+	.key_bytes	= 32,
+	.key_len	= 32,
+	.Kc_len		= 32,
+	.Ke_len		= 32,
+	.Ki_len		= 32,
+	.block_len	= 16,
+	.conf_len	= 16,
+	.cksum_len	= 16,
+	.hash_len	= 16,
+	.prf_len	= 16,
+	.keyed_cksum	= true,
+	.random_to_key	= rfc6803_random_to_key,
+	.profile	= &rfc6803_crypto_profile,
+};
diff --git a/crypto/krb5/selftest_data.c b/crypto/krb5/selftest_data.c
index 00c3b38c01d8..f71023463b7f 100644
--- a/crypto/krb5/selftest_data.c
+++ b/crypto/krb5/selftest_data.c
@@ -56,6 +56,29 @@ const struct krb5_key_test krb5_key_tests[] = {
 		.Ki.use	= 0x00000002,
 		.Ki.key	= "69B16514E3CD8E56B82010D5C73012B622C4D00FFC23ED1F",
 	},
+	/* rfc6803 sec 10 */
+	{
+		.krb5	= &krb5_camellia128_cts_cmac,
+		.name	= "key",
+		.key	= "57D0297298FFD9D35DE5A47FB4BDE24B",
+		.Kc.use	= 0x00000002,
+		.Kc.key	= "D155775A209D05F02B38D42A389E5A56",
+		.Ke.use	= 0x00000002,
+		.Ke.key	= "64DF83F85A532F17577D8C37035796AB",
+		.Ki.use	= 0x00000002,
+		.Ki.key	= "3E4FBDF30FB8259C425CB6C96F1F4635",
+	},
+	{
+		.krb5	= &krb5_camellia256_cts_cmac,
+		.name	= "key",
+		.key	= "B9D6828B2056B7BE656D88A123B1FAC68214AC2B727ECF5F69AFE0C4DF2A6D2C",
+		.Kc.use	= 0x00000002,
+		.Kc.key	= "E467F9A9552BC7D3155A6220AF9C19220EEED4FF78B0D1E6A1544991461A9E50",
+		.Ke.use	= 0x00000002,
+		.Ke.key	= "412AEFC362A7285FC3966C6A5181E7605AE675235B6D549FBFC9AB6630A4C604",
+		.Ki.use	= 0x00000002,
+		.Ki.key	= "FA624FA0E523993FA388AEFDC67E67EBCD8C08E8A0246B1D73B0D1DD9FC582B0",
+	},
 	{/* END */}
 };
 
@@ -129,6 +152,88 @@ const struct krb5_enc_test krb5_enc_tests[] = {
 		.Ki	= "69B16514E3CD8E56B82010D5C73012B622C4D00FFC23ED1F",
 		.ct	= "40013E2DF58E8751957D2878BCD2D6FE101CCFD556CB1EAE79DB3C3EE86429F2B2A602AC86FEF6ECB647D6295FAE077A1FEB517508D2C16B4192E01F62",
 	},
+	/* rfc6803 sec 10 */
+	{
+		.krb5	= &krb5_camellia128_cts_cmac,
+		.name	= "enc no plain",
+		.plain	= "",
+		.conf	= "B69822A19A6B09C0EBC8557D1F1B6C0A",
+		.K0	= "1DC46A8D763F4F93742BCBA3387576C3",
+		.usage	= htonl(0),
+		.ct	= "C466F1871069921EDB7C6FDE244A52DB0BA10EDC197BDB8006658CA3CCCE6EB8",
+	}, {
+		.krb5	= &krb5_camellia128_cts_cmac,
+		.name	= "enc 1 plain",
+		.plain	= "'1",
+		.conf	= "6F2FC3C2A166FD8898967A83DE9596D9",
+		.K0	= "5027BC231D0F3A9D23333F1CA6FDBE7C",
+		.usage	= htonl(1),
+		.ct	= "842D21FD950311C0DD464A3F4BE8D6DA88A56D559C9B47D3F9A85067AF661559B8",
+	}, {
+		.krb5	= &krb5_camellia128_cts_cmac,
+		.name	= "enc 9 plain",
+		.plain	= "'9 bytesss",
+		.conf	= "A5B4A71E077AEEF93C8763C18FDB1F10",
+		.K0	= "A1BB61E805F9BA6DDE8FDBDDC05CDEA0",
+		.usage	= htonl(2),
+		.ct	= "619FF072E36286FF0A28DEB3A352EC0D0EDF5C5160D663C901758CCF9D1ED33D71DB8F23AABF8348A0",
+	}, {
+		.krb5	= &krb5_camellia128_cts_cmac,
+		.name	= "enc 13 plain",
+		.plain	= "'13 bytes byte",
+		.conf	= "19FEE40D810C524B5B22F01874C693DA",
+		.K0	= "2CA27A5FAF5532244506434E1CEF6676",
+		.usage	= htonl(3),
+		.ct	= "B8ECA3167AE6315512E59F98A7C500205E5F63FF3BB389AF1C41A21D640D8615C9ED3FBEB05AB6ACB67689B5EA",
+	}, {
+		.krb5	= &krb5_camellia128_cts_cmac,
+		.name	= "enc 30 plain",
+		.plain	= "'30 bytes bytes bytes bytes byt",
+		.conf	= "CA7A7AB4BE192DABD603506DB19C39E2",
+		.K0	= "7824F8C16F83FF354C6BF7515B973F43",
+		.usage	= htonl(4),
+		.ct	= "A26A3905A4FFD5816B7B1E27380D08090C8EC1F304496E1ABDCD2BDCD1DFFC660989E117A713DDBB57A4146C1587CBA4356665591D2240282F5842B105A5",
+	}, {
+		.krb5	= &krb5_camellia256_cts_cmac,
+		.name	= "enc no plain",
+		.plain	= "",
+		.conf	= "3CBBD2B45917941067F96599BB98926C",
+		.K0	= "B61C86CC4E5D2757545AD423399FB7031ECAB913CBB900BD7A3C6DD8BF92015B",
+		.usage	= htonl(0),
+		.ct	= "03886D03310B47A6D8F06D7B94D1DD837ECCE315EF652AFF620859D94A259266",
+	}, {
+		.krb5	= &krb5_camellia256_cts_cmac,
+		.name	= "enc 1 plain",
+		.plain	= "'1",
+		.conf	= "DEF487FCEBE6DE6346D4DA4521BBA2D2",
+		.K0	= "1B97FE0A190E2021EB30753E1B6E1E77B0754B1D684610355864104963463833",
+		.usage	= htonl(1),
+		.ct	= "2C9C1570133C99BF6A34BC1B0212002FD194338749DB4135497A347CFCD9D18A12",
+	}, {
+		.krb5	= &krb5_camellia256_cts_cmac,
+		.name	= "enc 9 plain",
+		.plain	= "'9 bytesss",
+		.conf	= "AD4FF904D34E555384B14100FC465F88",
+		.K0	= "32164C5B434D1D1538E4CFD9BE8040FE8C4AC7ACC4B93D3314D2133668147A05",
+		.usage	= htonl(2),
+		.ct	= "9C6DE75F812DE7ED0D28B2963557A115640998275B0AF5152709913FF52A2A9C8E63B872F92E64C839",
+	}, {
+		.krb5	= &krb5_camellia256_cts_cmac,
+		.name	= "enc 13 plain",
+		.plain	= "'13 bytes byte",
+		.conf	= "CF9BCA6DF1144E0C0AF9B8F34C90D514",
+		.K0	= "B038B132CD8E06612267FAB7170066D88AECCBA0B744BFC60DC89BCA182D0715",
+		.usage	= htonl(3),
+		.ct	= "EEEC85A9813CDC536772AB9B42DEFC5706F726E975DDE05A87EB5406EA324CA185C9986B42AABE794B84821BEE",
+	}, {
+		.krb5	= &krb5_camellia256_cts_cmac,
+		.name	= "enc 30 plain",
+		.plain	= "'30 bytes bytes bytes bytes byt",
+		.conf	= "644DEF38DA35007275878D216855E228",
+		.K0	= "CCFCD349BF4C6677E86E4B02B8EAB924A546AC731CF9BF6989B996E7D6BFBBA7",
+		.usage	= htonl(4),
+		.ct	= "0E44680985855F2D1F1812529CA83BFD8E349DE6FD9ADA0BAAA048D68E265FEBF34AD1255A344999AD37146887A6C6845731AC7F46376A0504CD06571474",
+	},
 	{/* END */}
 };
 
@@ -150,5 +255,35 @@ const struct krb5_mic_test krb5_mic_tests[] = {
 		.Kc	= "EF5718BE86CC84963D8BBB5031E9F5C4BA41F28FAF69E73D",
 		.mic	= "45EE791567EEFCA37F4AC1E0222DE80D43C3BFA06699672A",
 	},
+	/* rfc6803 sec 10 */
+	{
+		.krb5	= &krb5_camellia128_cts_cmac,
+		.name	= "mic abc",
+		.plain	= "'abcdefghijk",
+		.K0	= "1DC46A8D763F4F93742BCBA3387576C3",
+		.usage	= htonl(7),
+		.mic	= "1178E6C5C47A8C1AE0C4B9C7D4EB7B6B",
+	}, {
+		.krb5	= &krb5_camellia128_cts_cmac,
+		.name	= "mic ABC",
+		.plain	= "'ABCDEFGHIJKLMNOPQRSTUVWXYZ",
+		.K0	= "5027BC231D0F3A9D23333F1CA6FDBE7C",
+		.usage	= htonl(8),
+		.mic	= "D1B34F7004A731F23A0C00BF6C3F753A",
+	}, {
+		.krb5	= &krb5_camellia256_cts_cmac,
+		.name	= "mic 123",
+		.plain	= "'123456789",
+		.K0	= "B61C86CC4E5D2757545AD423399FB7031ECAB913CBB900BD7A3C6DD8BF92015B",
+		.usage	= htonl(9),
+		.mic	= "87A12CFD2B96214810F01C826E7744B1",
+	}, {
+		.krb5	= &krb5_camellia256_cts_cmac,
+		.name	= "mic !@#",
+		.plain	= "'!@#$%^&*()!@#$%^&*()!@#$%^&*()",
+		.K0	= "32164C5B434D1D1538E4CFD9BE8040FE8C4AC7ACC4B93D3314D2133668147A05",
+		.usage	= htonl(10),
+		.mic	= "3FA0B42355E52B189187294AA252AB64",
+	},
 	{/* END */}
 };
diff --git a/include/crypto/krb5.h b/include/crypto/krb5.h
index f38a5b4d97ee..0b811fe27fec 100644
--- a/include/crypto/krb5.h
+++ b/include/crypto/krb5.h
@@ -36,6 +36,8 @@ struct scatterlist;
 #define KRB5_ENCTYPE_AES256_CTS_HMAC_SHA384_192	0x0014
 #define KRB5_ENCTYPE_ARCFOUR_HMAC		0x0017
 #define KRB5_ENCTYPE_ARCFOUR_HMAC_EXP		0x0018
+#define KRB5_ENCTYPE_CAMELLIA128_CTS_CMAC	0x0019
+#define KRB5_ENCTYPE_CAMELLIA256_CTS_CMAC	0x001a
 #define KRB5_ENCTYPE_UNKNOWN			0x01ff
 
 #define KRB5_CKSUMTYPE_CRC32			0x0001
@@ -48,6 +50,8 @@ struct scatterlist;
 #define KRB5_CKSUMTYPE_HMAC_SHA1_DES3		0x000c
 #define KRB5_CKSUMTYPE_HMAC_SHA1_96_AES128	0x000f
 #define KRB5_CKSUMTYPE_HMAC_SHA1_96_AES256	0x0010
+#define KRB5_CKSUMTYPE_CMAC_CAMELLIA128		0x0011
+#define KRB5_CKSUMTYPE_CMAC_CAMELLIA256		0x0012
 #define KRB5_CKSUMTYPE_HMAC_SHA256_128_AES128	0x0013
 #define KRB5_CKSUMTYPE_HMAC_SHA384_192_AES256	0x0014
 #define KRB5_CKSUMTYPE_HMAC_MD5_ARCFOUR		-138 /* Microsoft md5 hmac cksumtype */


