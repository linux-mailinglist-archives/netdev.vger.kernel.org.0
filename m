Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386A32C2B37
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389703AbgKXPZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:25:19 -0500
Received: from novek.ru ([213.148.174.62]:47228 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389434AbgKXPZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:25:17 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 610CB5030C6;
        Tue, 24 Nov 2020 18:25:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 610CB5030C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1606231531; bh=Bv+hdH7fjyTLoJNNDryt7IIuhMR66vzunJw2y57lQdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OiMJ8CnbKkMDoEv74Wq96NFHvrraa4oBJLtDgr0OE09Z7I+ShfCnr6dPMQKkqOBGo
         tK1cTN/2qzUPOpwc1mzXjq7Og96GyKDhwstCrQ/zV/zVJonw+SoMnbe/mjhZnhOzuE
         ekIZRGh9ag3uMVIJ0916Yq2FE6ZhL7IOaHfCR3C8=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [net-next v2 2/5] net/tls: add CHACHA20-POLY1305 specific defines and structures
Date:   Tue, 24 Nov 2020 18:24:47 +0300
Message-Id: <1606231490-653-3-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
References: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To provide support for ChaCha-Poly cipher we need to define
specific constants and structures.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 include/net/tls.h        |  1 +
 include/uapi/linux/tls.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index d04ce73..e4e9c2a 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -211,6 +211,7 @@ struct cipher_context {
 	union {
 		struct tls12_crypto_info_aes_gcm_128 aes_gcm_128;
 		struct tls12_crypto_info_aes_gcm_256 aes_gcm_256;
+		struct tls12_crypto_info_chacha20_poly1305 chacha20_poly1305;
 	};
 };
 
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index bcd2869..0d54bae 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -77,6 +77,13 @@
 #define TLS_CIPHER_AES_CCM_128_TAG_SIZE		16
 #define TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE		8
 
+#define TLS_CIPHER_CHACHA20_POLY1305			54
+#define TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE		12
+#define TLS_CIPHER_CHACHA20_POLY1305_KEY_SIZE	32
+#define TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE		0
+#define TLS_CIPHER_CHACHA20_POLY1305_TAG_SIZE	16
+#define TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE	8
+
 #define TLS_SET_RECORD_TYPE	1
 #define TLS_GET_RECORD_TYPE	2
 
@@ -109,6 +116,14 @@ struct tls12_crypto_info_aes_ccm_128 {
 	unsigned char rec_seq[TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE];
 };
 
+struct tls12_crypto_info_chacha20_poly1305 {
+	struct tls_crypto_info info;
+	unsigned char iv[TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE];
+	unsigned char key[TLS_CIPHER_CHACHA20_POLY1305_KEY_SIZE];
+	unsigned char salt[TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE];
+	unsigned char rec_seq[TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE];
+};
+
 enum {
 	TLS_INFO_UNSPEC,
 	TLS_INFO_VERSION,
-- 
1.8.3.1

