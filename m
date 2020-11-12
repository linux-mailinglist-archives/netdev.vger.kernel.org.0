Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D949D2B0573
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgKLM7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:59:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728388AbgKLM7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605185939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eUE4adsOr6RUNRjKbFbF7nBnnBChKgq5c6GArq21E4o=;
        b=XvfZQ4vsfVFiElpWU6LZmgpf4UDYfC5D0X1d7B1PWf5divffuUoHMTBRmFLYpjxZxK/XeY
        XJJtw666amEcP2wU/T84nYCSUSvWBOLA1RFe81p5GihAQsdepRFlDmAtq6wMjdQK5uiXly
        E3dGoo9mLAWmqLJt42vHwbbaAp6sbEs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-MNgpOwYePUmFU_MqJ_q4DA-1; Thu, 12 Nov 2020 07:58:55 -0500
X-MC-Unique: MNgpOwYePUmFU_MqJ_q4DA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CBC786ABDD;
        Thu, 12 Nov 2020 12:58:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52B6D60C13;
        Thu, 12 Nov 2020 12:58:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 08/18] crypto/krb5: Implement crypto self-testing
From:   David Howells <dhowells@redhat.com>
To:     herbert@gondor.apana.org.au, bfields@fieldses.org
Cc:     dhowells@redhat.com, trond.myklebust@hammerspace.com,
        linux-crypto@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Nov 2020 12:58:50 +0000
Message-ID: <160518593050.2277919.4004451170398397487.stgit@warthog.procyon.org.uk>
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

Implement self-testing infrastructure to test the pseudo-random function,
key derivation, encryption and checksumming.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/krb5/Kconfig         |    4 
 crypto/krb5/Makefile        |    4 
 crypto/krb5/internal.h      |   48 ++++
 crypto/krb5/main.c          |   12 +
 crypto/krb5/selftest.c      |  543 +++++++++++++++++++++++++++++++++++++++++++
 crypto/krb5/selftest_data.c |   38 +++
 6 files changed, 649 insertions(+)
 create mode 100644 crypto/krb5/selftest.c
 create mode 100644 crypto/krb5/selftest_data.c

diff --git a/crypto/krb5/Kconfig b/crypto/krb5/Kconfig
index 881754500732..e2eba1d689ab 100644
--- a/crypto/krb5/Kconfig
+++ b/crypto/krb5/Kconfig
@@ -9,3 +9,7 @@ config CRYPTO_KRB5
 	select CRYPTO_AES
 	help
 	  Provide Kerberos-5-based security.
+
+config CRYPTO_KRB5_SELFTESTS
+	bool "Kerberos 5 crypto selftests"
+	depends on CRYPTO_KRB5
diff --git a/crypto/krb5/Makefile b/crypto/krb5/Makefile
index b81e2efac3c8..b7da03cae6d1 100644
--- a/crypto/krb5/Makefile
+++ b/crypto/krb5/Makefile
@@ -9,4 +9,8 @@ krb5-y += \
 	rfc3961_simplified.o \
 	rfc3962_aes.o
 
+krb5-$(CONFIG_CRYPTO_KRB5_SELFTESTS) += \
+	selftest.o \
+	selftest_data.o
+
 obj-$(CONFIG_CRYPTO_KRB5) += krb5.o
diff --git a/crypto/krb5/internal.h b/crypto/krb5/internal.h
index 5d55a574536e..47424b433778 100644
--- a/crypto/krb5/internal.h
+++ b/crypto/krb5/internal.h
@@ -88,6 +88,37 @@ struct krb5_crypto_profile {
 	crypto_roundup(crypto_sync_skcipher_ivsize(TFM))
 #define round16(x) (((x) + 15) & ~15)
 
+/*
+ * Self-testing data.
+ */
+struct krb5_prf_test {
+	const struct krb5_enctype *krb5;
+	const char *name, *key, *octet, *prf;
+};
+
+struct krb5_key_test_one {
+	u32 use;
+	const char *key;
+};
+
+struct krb5_key_test {
+	const struct krb5_enctype *krb5;
+	const char *name, *key;
+	struct krb5_key_test_one Kc, Ke, Ki;
+};
+
+struct krb5_enc_test {
+	const struct krb5_enctype *krb5;
+	const char *name, *plain, *conf, *K0, *Ke, *Ki, *ct;
+	__be32 usage;
+};
+
+struct krb5_mic_test {
+	const struct krb5_enctype *krb5;
+	const char *name, *plain, *K0, *Kc, *mic;
+	__be32 usage;
+};
+
 /*
  * main.c
  */
@@ -126,3 +157,20 @@ int rfc3961_verify_mic(const struct krb5_enctype *krb5,
  */
 extern const struct krb5_enctype krb5_aes128_cts_hmac_sha1_96;
 extern const struct krb5_enctype krb5_aes256_cts_hmac_sha1_96;
+
+/*
+ * selftest.c
+ */
+#ifdef CONFIG_CRYPTO_KRB5_SELFTESTS
+void krb5_selftest(void);
+#else
+static inline void krb5_selftest(void) {}
+#endif
+
+/*
+ * selftest_data.c
+ */
+extern const struct krb5_prf_test krb5_prf_tests[];
+extern const struct krb5_key_test krb5_key_tests[];
+extern const struct krb5_enc_test krb5_enc_tests[];
+extern const struct krb5_mic_test krb5_mic_tests[];
diff --git a/crypto/krb5/main.c b/crypto/krb5/main.c
index bce47580c33f..b79127027551 100644
--- a/crypto/krb5/main.c
+++ b/crypto/krb5/main.c
@@ -214,3 +214,15 @@ int crypto_krb5_verify_mic(const struct krb5_enctype *krb5,
 					 _offset, _len, _error_code);
 }
 EXPORT_SYMBOL(crypto_krb5_verify_mic);
+
+static int __init crypto_krb5_init(void)
+{
+	krb5_selftest();
+	return 0;
+}
+module_init(crypto_krb5_init);
+
+static void __exit crypto_krb5_exit(void)
+{
+}
+module_exit(crypto_krb5_exit);
diff --git a/crypto/krb5/selftest.c b/crypto/krb5/selftest.c
new file mode 100644
index 000000000000..df57ab24cc6e
--- /dev/null
+++ b/crypto/krb5/selftest.c
@@ -0,0 +1,543 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* RxGK self-testing
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/slab.h>
+#include <crypto/skcipher.h>
+#include <crypto/hash.h>
+#include "internal.h"
+
+#define VALID(X) \
+	({								\
+		bool __x = (X);						\
+		if (__x) {						\
+			pr_warn("!!! TESTINVAL %s:%u\n", __FILE__, __LINE__); \
+		}							\
+		__x;							\
+	})
+
+#define CHECK(X) \
+	({								\
+		bool __x = (X);						\
+		if (__x) {						\
+			pr_warn("!!! TESTFAIL %s:%u\n", __FILE__, __LINE__); \
+		}							\
+		__x;							\
+	})
+
+enum which_key {
+	TEST_KC, TEST_KE, TEST_KI,
+};
+
+static int prep_buf(struct krb5_buffer *buf)
+{
+	buf->data = kmalloc(buf->len, GFP_KERNEL);
+	if (!buf->data)
+		return -ENOMEM;
+	return 0;
+}
+
+#define PREP_BUF(BUF, LEN)					\
+	do {							\
+		(BUF)->len = (LEN);				\
+		if ((ret = prep_buf((BUF))) < 0)		\
+			goto out;				\
+	} while(0)
+
+static int load_buf(struct krb5_buffer *buf, const char *from)
+{
+	size_t len = strlen(from);
+	int ret;
+
+	if (len > 1 && from[0] == '\'') {
+		PREP_BUF(buf, len - 1);
+		memcpy(buf->data, from + 1, len - 1);
+		ret = 0;
+		goto out;
+	}
+
+	if (VALID(len & 1))
+		return -EINVAL;
+
+	PREP_BUF(buf, len / 2);
+	if ((ret = hex2bin(buf->data, from, buf->len)) < 0) {
+		VALID(1);
+		goto out;
+	}
+out:
+	return ret;
+}
+
+#define LOAD_BUF(BUF, FROM) do { if ((ret = load_buf(BUF, FROM)) < 0) goto out; } while(0)
+
+static void clear_buf(struct krb5_buffer *buf)
+{
+	kfree(buf->data);
+	buf->len = 0;
+	buf->data = NULL;
+}
+
+/*
+ * Perform a pseudo-random function check.
+ */
+static int krb5_test_one_prf(const struct krb5_prf_test *test)
+{
+	const struct krb5_enctype *krb5 = test->krb5;
+	struct krb5_buffer key = {}, octet = {}, result = {}, prf = {};
+	int ret;
+
+	pr_notice("Running %s %s\n", krb5->name, test->name);
+
+	LOAD_BUF(&key,   test->key);
+	LOAD_BUF(&octet, test->octet);
+	LOAD_BUF(&prf,   test->prf);
+	PREP_BUF(&result, krb5->prf_len);
+
+	if (VALID(result.len != prf.len)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if ((ret = krb5->profile->calc_PRF(krb5, &key, &octet, &result, GFP_KERNEL)) < 0) {
+		CHECK(1);
+		pr_warn("PRF calculation failed %d\n", ret);
+		goto out;
+	}
+
+	if (memcmp(result.data, prf.data, result.len) != 0) {
+		CHECK(1);
+		ret = -EKEYREJECTED;
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	clear_buf(&result);
+	clear_buf(&octet);
+	clear_buf(&key);
+	return ret;
+}
+
+/*
+ * Perform a key derivation check.
+ */
+static int krb5_test_key(const struct krb5_enctype *krb5,
+			 const struct krb5_buffer *base_key,
+			 const struct krb5_key_test_one *test,
+			 enum which_key which)
+{
+	struct krb5_buffer key = {}, result = {};
+	int ret;
+
+	LOAD_BUF(&key,   test->key);
+	PREP_BUF(&result, key.len);
+
+	switch (which) {
+	case TEST_KC:
+		ret = crypto_krb5_get_Kc(krb5, base_key, test->use, &result,
+					 NULL, GFP_KERNEL);
+		break;
+	case TEST_KE:
+		ret = crypto_krb5_get_Ke(krb5, base_key, test->use, &result,
+					 NULL, GFP_KERNEL);
+		break;
+	case TEST_KI:
+		ret = crypto_krb5_get_Ki(krb5, base_key, test->use, &result,
+					 NULL, GFP_KERNEL);
+		break;
+	default:
+		VALID(1);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (ret < 0) {
+		CHECK(1);
+		pr_warn("Key derivation failed %d\n", ret);
+		goto out;
+	}
+
+	if (memcmp(result.data, key.data, result.len) != 0) {
+		CHECK(1);
+		ret = -EKEYREJECTED;
+		goto out;
+	}
+
+out:
+	clear_buf(&key);
+	clear_buf(&result);
+	return ret;
+}
+
+static int krb5_test_one_key(const struct krb5_key_test *test)
+{
+	const struct krb5_enctype *krb5 = test->krb5;
+	struct krb5_buffer base_key = {};
+	int ret;
+
+	pr_notice("Running %s %s\n", krb5->name, test->name);
+
+	LOAD_BUF(&base_key, test->key);
+
+	if ((ret = krb5_test_key(krb5, &base_key, &test->Kc, TEST_KC)) < 0)
+		goto out;
+	if ((ret = krb5_test_key(krb5, &base_key, &test->Ke, TEST_KE)) < 0)
+		goto out;
+	if ((ret = krb5_test_key(krb5, &base_key, &test->Ki, TEST_KI)) < 0)
+		goto out;
+
+out:
+	clear_buf(&base_key);
+	return ret;
+}
+
+static int krb5_test_get_Kc(const struct krb5_mic_test *test,
+			    struct crypto_shash **_Kc)
+{
+	const struct krb5_enctype *krb5 = test->krb5;
+	struct crypto_shash *shash;
+	struct krb5_buffer K0 = {}, key = {};
+	int ret;
+
+	shash = crypto_alloc_shash(krb5->cksum_name, 0, 0);
+	if (IS_ERR(shash))
+		return (PTR_ERR(shash) == -ENOENT) ? -ENOPKG : PTR_ERR(shash);
+	*_Kc = shash;
+
+	if (test->Kc) {
+		LOAD_BUF(&key, test->Kc);
+	} else {
+		char usage_data[5];
+		struct krb5_buffer usage = { .len = 5, .data = usage_data };
+		memcpy(usage_data, &test->usage, 4);
+		usage_data[4] = 0x99;
+		LOAD_BUF(&K0, test->K0);
+		PREP_BUF(&key, krb5->Kc_len);
+		ret = krb5->profile->calc_Kc(krb5, &K0, &usage, &key, GFP_KERNEL);
+	}
+
+	ret = crypto_shash_setkey(shash, key.data, key.len);
+out:
+	clear_buf(&key);
+	clear_buf(&K0);
+	return ret;
+}
+
+static int krb5_test_get_Ke(const struct krb5_enc_test *test,
+			    struct krb5_enc_keys *keys)
+{
+	const struct krb5_enctype *krb5 = test->krb5;
+	struct crypto_sync_skcipher *ci;
+	struct krb5_buffer K0 = {}, key = {};
+	int ret;
+
+	ci = crypto_alloc_sync_skcipher(krb5->encrypt_name, 0, 0);
+	if (IS_ERR(ci))
+		return (PTR_ERR(ci) == -ENOENT) ? -ENOPKG : PTR_ERR(ci);
+	keys->Ke = ci;
+
+	if (test->Ke) {
+		LOAD_BUF(&key, test->Ke);
+	} else {
+		char usage_data[5];
+		struct krb5_buffer usage = { .len = 5, .data = usage_data };
+		memcpy(usage_data, &test->usage, 4);
+		usage_data[4] = 0xAA;
+		LOAD_BUF(&K0, test->K0);
+		PREP_BUF(&key, krb5->Ke_len);
+		ret = krb5->profile->calc_Ke(krb5, &K0, &usage, &key, GFP_KERNEL);
+	}
+
+	ret = crypto_sync_skcipher_setkey(ci, key.data, key.len);
+out:
+	clear_buf(&key);
+	clear_buf(&K0);
+	return ret;
+}
+
+static int krb5_test_get_Ki(const struct krb5_enc_test *test,
+			    struct krb5_enc_keys *keys)
+{
+	const struct krb5_enctype *krb5 = test->krb5;
+	struct crypto_shash *shash;
+	struct krb5_buffer K0 = {}, key = {};
+	int ret;
+
+	shash = crypto_alloc_shash(krb5->cksum_name, 0, 0);
+	if (IS_ERR(shash))
+		return (PTR_ERR(shash) == -ENOENT) ? -ENOPKG : PTR_ERR(shash);
+	keys->Ki = shash;
+
+	if (test->Ki) {
+		LOAD_BUF(&key, test->Ki);
+	} else {
+		char usage_data[5];
+		struct krb5_buffer usage = { .len = 5, .data = usage_data };
+		memcpy(usage_data, &test->usage, 4);
+		usage_data[4] = 0x55;
+		LOAD_BUF(&K0, test->K0);
+		PREP_BUF(&key, krb5->Ki_len);
+		ret = krb5->profile->calc_Ki(krb5, &K0, &usage, &key, GFP_KERNEL);
+	}
+
+	ret = crypto_shash_setkey(shash, key.data, key.len);
+out:
+	clear_buf(&key);
+	clear_buf(&K0);
+	return ret;
+}
+
+/*
+ * Generate a buffer containing encryption test data.
+ */
+static int krb5_load_enc_buf(const struct krb5_enc_test *test,
+			     const struct krb5_buffer *plain,
+			     void *buf)
+{
+	const struct krb5_enctype *krb5 = test->krb5;
+	unsigned int conf_len, pad_len, enc_len, ct_len;
+	int ret;
+
+	conf_len = strlen(test->conf);
+	if (VALID((conf_len & 1) || conf_len / 2 != krb5->conf_len))
+		return -EINVAL;
+
+	if (krb5->pad) {
+		enc_len = round_up(krb5->conf_len + plain->len, krb5->block_len);
+		pad_len = enc_len - (krb5->conf_len + plain->len);
+	} else {
+		enc_len = krb5->conf_len + plain->len;
+		pad_len = 0;
+	}
+
+	ct_len = strlen(test->ct);
+	if (VALID((ct_len & 1) || ct_len / 2 != enc_len + krb5->cksum_len))
+		return -EINVAL;
+	ct_len = enc_len + krb5->cksum_len;
+
+	if ((ret = hex2bin(buf, test->conf, krb5->conf_len)) < 0)
+		return ret;
+	buf += krb5->conf_len;
+	memcpy(buf, plain->data, plain->len);
+	return 0;
+}
+
+/*
+ * Load checksum test data into a buffer.
+ */
+static int krb5_load_mic_buf(const struct krb5_mic_test *test,
+			     const struct krb5_buffer *plain,
+			     void *buf)
+{
+	const struct krb5_enctype *krb5 = test->krb5;
+
+	memcpy(buf + krb5->cksum_len, plain->data, plain->len);
+	return 0;
+}
+
+/*
+ * Perform an encryption test.
+ */
+static int krb5_test_one_enc(const struct krb5_enc_test *test, void *buf)
+{
+	const struct krb5_enctype *krb5 = test->krb5;
+	struct krb5_enc_keys keys = {};
+	struct krb5_buffer plain = {}, ct = {};
+	struct scatterlist sg[1];
+	size_t offset, len;
+	int ret, error_code;
+
+	pr_notice("Running %s %s\n", krb5->name, test->name);
+
+	if ((ret = krb5_test_get_Ke(test, &keys)) < 0 ||
+	    (ret = krb5_test_get_Ki(test, &keys)) < 0)
+		goto out;
+
+	LOAD_BUF(&plain, test->plain);
+	LOAD_BUF(&ct, test->ct);
+
+	ret = krb5_load_enc_buf(test, &plain, buf);
+	if (ret < 0)
+		goto out;
+
+	sg_init_one(sg, buf, 1024);
+	ret = crypto_krb5_encrypt(krb5, &keys, sg, 1, 1024,
+				  krb5->conf_len, plain.len, true);
+	if (ret < 0) {
+		CHECK(1);
+		pr_warn("Encryption failed %d\n", ret);
+		goto out;
+	}
+	len = ret;
+
+	if (CHECK(len != ct.len)) {
+		pr_warn("Encrypted length mismatch %zu != %u\n", len, ct.len);
+		goto out;
+	}
+
+	if (memcmp(buf, ct.data, ct.len) != 0) {
+		CHECK(1);
+		pr_warn("Ciphertext mismatch\n");
+		pr_warn("BUF %*phN\n", ct.len, buf);
+		pr_warn("CT  %*phN\n", ct.len, ct.data);
+		ret = -EKEYREJECTED;
+		goto out;
+	}
+
+	offset = 0;
+	ret = crypto_krb5_decrypt(krb5, &keys, sg, 1, &offset, &len, &error_code);
+	if (ret < 0) {
+		CHECK(1);
+		pr_warn("Decryption failed %d\n", ret);
+		goto out;
+	}
+
+	if (CHECK(len != plain.len))
+		goto out;
+
+	if (memcmp(buf + offset, plain.data, plain.len) != 0) {
+		CHECK(1);
+		pr_warn("Plaintext mismatch\n");
+		pr_warn("BUF %*phN\n", plain.len, buf + offset);
+		pr_warn("PT  %*phN\n", plain.len, plain.data);
+		ret = -EKEYREJECTED;
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	clear_buf(&ct);
+	clear_buf(&plain);
+	crypto_krb5_free_enc_keys(&keys);
+	return ret;
+}
+
+static int krb5_test_one_mic(const struct krb5_mic_test *test, void *buf)
+{
+	const struct krb5_enctype *krb5 = test->krb5;
+	struct crypto_shash *Kc = NULL;
+	struct scatterlist sg[1];
+	struct krb5_buffer plain = {}, mic = {};
+	size_t offset, len;
+	int ret, error_code;
+
+	pr_notice("Running %s %s\n", krb5->name, test->name);
+
+	if ((ret = krb5_test_get_Kc(test, &Kc)) < 0)
+		goto out;
+
+	LOAD_BUF(&plain, test->plain);
+	LOAD_BUF(&mic, test->mic);
+
+	ret = krb5_load_mic_buf(test, &plain, buf);
+	if (ret < 0)
+		goto out;
+
+	sg_init_one(sg, buf, 1024);
+
+	ret = crypto_krb5_get_mic(krb5, Kc, NULL, sg, 1, 1024,
+				  krb5->cksum_len, plain.len);
+	if (ret < 0) {
+		CHECK(1);
+		pr_warn("Get MIC failed %d\n", ret);
+		goto out;
+	}
+	len = ret;
+
+	if (CHECK(len != plain.len + mic.len)) {
+		pr_warn("MIC length mismatch %zu != %u\n", len, plain.len + mic.len);
+		goto out;
+	}
+
+	if (memcmp(buf, mic.data, mic.len) != 0) {
+		CHECK(1);
+		pr_warn("MIC mismatch\n");
+		pr_warn("BUF %*phN\n", mic.len, buf);
+		pr_warn("MIC %*phN\n", mic.len, mic.data);
+		ret = -EKEYREJECTED;
+		goto out;
+	}
+
+	offset = 0;
+	ret = crypto_krb5_verify_mic(krb5, Kc, NULL, sg, 1,
+				     &offset, &len, &error_code);
+	if (ret < 0) {
+		CHECK(1);
+		pr_warn("Verify MIC failed %d\n", ret);
+		goto out;
+	}
+
+	if (CHECK(len != plain.len))
+		goto out;
+	if (CHECK(offset != mic.len))
+		goto out;
+
+	if (memcmp(buf + offset, plain.data, plain.len) != 0) {
+		CHECK(1);
+		pr_warn("Plaintext mismatch\n");
+		pr_warn("BUF %*phN\n", plain.len, buf + offset);
+		pr_warn("PT  %*phN\n", plain.len, plain.data);
+		ret = -EKEYREJECTED;
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	clear_buf(&mic);
+	clear_buf(&plain);
+	if (Kc)
+		crypto_free_shash(Kc);
+	return ret;
+}
+
+void krb5_selftest(void)
+{
+	void *buf;
+	bool fail = false;
+	int i;
+
+	buf = kmalloc(1024, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	printk("\n");
+	pr_notice("Running selftests\n");
+
+	for (i = 0; krb5_prf_tests[i].krb5; i++) {
+		fail |= krb5_test_one_prf(&krb5_prf_tests[i]) < 0;
+		if (fail)
+			goto out;
+	}
+
+	for (i = 0; krb5_key_tests[i].krb5; i++) {
+		fail |= krb5_test_one_key(&krb5_key_tests[i]) < 0;
+		if (fail)
+			goto out;
+	}
+
+	for (i = 0; krb5_enc_tests[i].krb5; i++) {
+		memset(buf, 0x5a, 1024);
+		fail |= krb5_test_one_enc(&krb5_enc_tests[i], buf) < 0;
+		if (fail)
+			goto out;
+	}
+
+	for (i = 0; krb5_mic_tests[i].krb5; i++) {
+		memset(buf, 0x5a, 1024);
+		fail |= krb5_test_one_mic(&krb5_mic_tests[i], buf) < 0;
+		if (fail)
+			goto out;
+	}
+
+out:
+	pr_notice("Selftests %s\n", fail ? "failed" : "succeeded");
+	kfree(buf);
+}
diff --git a/crypto/krb5/selftest_data.c b/crypto/krb5/selftest_data.c
new file mode 100644
index 000000000000..9085723b730b
--- /dev/null
+++ b/crypto/krb5/selftest_data.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Data for RxGK self-testing
+ *
+ * Copyright (C) 2020 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "internal.h"
+
+/*
+ * Pseudo-random function tests.
+ */
+const struct krb5_prf_test krb5_prf_tests[] = {
+	{/* END */}
+};
+
+/*
+ * Key derivation tests.
+ */
+const struct krb5_key_test krb5_key_tests[] = {
+	{/* END */}
+};
+
+/*
+ * Encryption tests.
+ */
+const struct krb5_enc_test krb5_enc_tests[] = {
+	{/* END */}
+};
+
+/*
+ * Checksum generation tests.
+ */
+const struct krb5_mic_test krb5_mic_tests[] = {
+	{/* END */}
+};


