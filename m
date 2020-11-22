Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EFE2BC315
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 02:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgKVB6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 20:58:04 -0500
Received: from novek.ru ([213.148.174.62]:39812 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgKVB6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 20:58:03 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C6DF5502E21;
        Sun, 22 Nov 2020 04:58:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C6DF5502E21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1606010295; bh=Bv+hdH7fjyTLoJNNDryt7IIuhMR66vzunJw2y57lQdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6sNdMdKnR844SH+C7/R+Bx7f38It7i3z0es910S4pON4DcKsh0IojDp1eek7UAtV
         WexPVULEcc60iXzxwJWguGnSifvGpPRHHwcIfuSoEk7EJsiczpUOFJCjNghEUR6A8E
         IePbJufPopN4DxeHue0m6tMjSxSV2SifPGw9wkhw=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net-next 2/5] net/tls: add CHACHA20-POLY1305 specific defines and structures
Date:   Sun, 22 Nov 2020 04:57:42 +0300
Message-Id: <1606010265-30471-3-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606010265-30471-1-git-send-email-vfedorenko@novek.ru>
References: <1606010265-30471-1-git-send-email-vfedorenko@novek.ru>
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

