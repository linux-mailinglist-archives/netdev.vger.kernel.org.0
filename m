Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245413AD38D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhFRU1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230430AbhFRU1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 16:27:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 700E5610CD;
        Fri, 18 Jun 2021 20:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624047907;
        bh=qWOaz0k+A/bVTWqocwPF3OR0T3dcDZ2Xe+Pt0p8BbGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGXT4ju7pBbmB4NABQAQKHCyHH6n4VT00/YRKwJYvZUr7Ow3VgktTGfAYbrB5QoaR
         a9+LmMN+sv00o+67gpsMYHUAR9fg0nJo7ak2UA3fZM6G9Afu3tFUaYeMv/txJf0eFe
         j8yiAdL7L5APQyw18UF2tCVrZaRwWMHqjErDOCaSy/VHE6dBR//ajb6PWVDNv17ydn
         RYDNO4xlYL7A/d7lg8Lx6j6Ap5CJZYJPTYgrbo65sVSxf04PsbLn8yzcDKWFNpVs74
         1IXx1sDA8whlkBNI+NBBXRhJprxEA/ieqtdR227TUloo51KfgAlh1kLFkVE4ogUJch
         lUJC9WgCYqPBA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/2] selftests: tls: fix chacha+bidir tests
Date:   Fri, 18 Jun 2021 13:25:04 -0700
Message-Id: <20210618202504.1435179-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210618202504.1435179-1-kuba@kernel.org>
References: <20210618202504.1435179-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ChaCha support did not adjust the bidirectional test.
We need to set up KTLS in reverse direction correctly,
otherwise these two cases will fail:

  tls.12_chacha.bidir
  tls.13_chacha.bidir

Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls selftests")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 67 ++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 58fea6eb588d..112d41d01b12 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -25,6 +25,35 @@
 #define TLS_PAYLOAD_MAX_LEN 16384
 #define SOL_TLS 282
 
+struct tls_crypto_info_keys {
+	union {
+		struct tls12_crypto_info_aes_gcm_128 aes128;
+		struct tls12_crypto_info_chacha20_poly1305 chacha20;
+	};
+	size_t len;
+};
+
+static void tls_crypto_info_init(uint16_t tls_version, uint16_t cipher_type,
+				 struct tls_crypto_info_keys *tls12)
+{
+	memset(tls12, 0, sizeof(*tls12));
+
+	switch (cipher_type) {
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		tls12->len = sizeof(struct tls12_crypto_info_chacha20_poly1305);
+		tls12->chacha20.info.version = tls_version;
+		tls12->chacha20.info.cipher_type = cipher_type;
+		break;
+	case TLS_CIPHER_AES_GCM_128:
+		tls12->len = sizeof(struct tls12_crypto_info_aes_gcm_128);
+		tls12->aes128.info.version = tls_version;
+		tls12->aes128.info.cipher_type = cipher_type;
+		break;
+	default:
+		break;
+	}
+}
+
 static void memrnd(void *s, size_t n)
 {
 	int *dword = s;
@@ -145,33 +174,16 @@ FIXTURE_VARIANT_ADD(tls, 13_chacha)
 
 FIXTURE_SETUP(tls)
 {
-	union {
-		struct tls12_crypto_info_aes_gcm_128 aes128;
-		struct tls12_crypto_info_chacha20_poly1305 chacha20;
-	} tls12;
+	struct tls_crypto_info_keys tls12;
 	struct sockaddr_in addr;
 	socklen_t len;
 	int sfd, ret;
-	size_t tls12_sz;
 
 	self->notls = false;
 	len = sizeof(addr);
 
-	memset(&tls12, 0, sizeof(tls12));
-	switch (variant->cipher_type) {
-	case TLS_CIPHER_CHACHA20_POLY1305:
-		tls12_sz = sizeof(struct tls12_crypto_info_chacha20_poly1305);
-		tls12.chacha20.info.version = variant->tls_version;
-		tls12.chacha20.info.cipher_type = variant->cipher_type;
-		break;
-	case TLS_CIPHER_AES_GCM_128:
-		tls12_sz = sizeof(struct tls12_crypto_info_aes_gcm_128);
-		tls12.aes128.info.version = variant->tls_version;
-		tls12.aes128.info.cipher_type = variant->cipher_type;
-		break;
-	default:
-		tls12_sz = 0;
-	}
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type,
+			     &tls12);
 
 	addr.sin_family = AF_INET;
 	addr.sin_addr.s_addr = htonl(INADDR_ANY);
@@ -199,7 +211,7 @@ FIXTURE_SETUP(tls)
 
 	if (!self->notls) {
 		ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12,
-				 tls12_sz);
+				 tls12.len);
 		ASSERT_EQ(ret, 0);
 	}
 
@@ -212,7 +224,7 @@ FIXTURE_SETUP(tls)
 		ASSERT_EQ(ret, 0);
 
 		ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12,
-				 tls12_sz);
+				 tls12.len);
 		ASSERT_EQ(ret, 0);
 	}
 
@@ -854,18 +866,17 @@ TEST_F(tls, bidir)
 	int ret;
 
 	if (!self->notls) {
-		struct tls12_crypto_info_aes_gcm_128 tls12;
+		struct tls_crypto_info_keys tls12;
 
-		memset(&tls12, 0, sizeof(tls12));
-		tls12.info.version = variant->tls_version;
-		tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
+		tls_crypto_info_init(variant->tls_version, variant->cipher_type,
+				     &tls12);
 
 		ret = setsockopt(self->fd, SOL_TLS, TLS_RX, &tls12,
-				 sizeof(tls12));
+				 tls12.len);
 		ASSERT_EQ(ret, 0);
 
 		ret = setsockopt(self->cfd, SOL_TLS, TLS_TX, &tls12,
-				 sizeof(tls12));
+				 tls12.len);
 		ASSERT_EQ(ret, 0);
 	}
 
-- 
2.31.1

