Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E95246AA94
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352155AbhLFVnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:43:14 -0500
Received: from novek.ru ([213.148.174.62]:39384 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236606AbhLFVnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 16:43:12 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 559B750130B;
        Tue,  7 Dec 2021 00:34:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 559B750130B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1638826498; bh=k59tG2edr70tWcYrX1TXkQS/I+2eac+8fhzrxlpRx50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1a9N9FvZQ+8cXdrHv5gnJMbm94Z3LwzgOJ82b2M7e/ypKXrFOgnTNyVejlZHZ/DG
         EAto8WI3fuoDgRRZYvydDpP4GEzqCtcju3y5JqUVum10PA65iYc1FFrMZhWX4Et44z
         AhVVRIZuDKS2ddQTf/um3GEHYR4UxRJn+XpfN5gI=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [PATCH net 2/2] selftests: tls: add missing AES256-GCM cipher
Date:   Tue,  7 Dec 2021 00:39:32 +0300
Message-Id: <20211206213932.7508-3-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20211206213932.7508-1-vfedorenko@novek.ru>
References: <20211206213932.7508-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for TLSv1.2 and TLSv1.3 with AES256-GCM cipher

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 tools/testing/selftests/net/tls.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index fb1bb402ee10..6e468e0f42f7 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -32,6 +32,7 @@ struct tls_crypto_info_keys {
 		struct tls12_crypto_info_sm4_gcm sm4gcm;
 		struct tls12_crypto_info_sm4_ccm sm4ccm;
 		struct tls12_crypto_info_aes_ccm_128 aesccm128;
+		struct tls12_crypto_info_aes_gcm_256 aesgcm256;
 	};
 	size_t len;
 };
@@ -67,6 +68,11 @@ static void tls_crypto_info_init(uint16_t tls_version, uint16_t cipher_type,
 		tls12->aesccm128.info.version = tls_version;
 		tls12->aesccm128.info.cipher_type = cipher_type;
 		break;
+	case TLS_CIPHER_AES_GCM_256:
+		tls12->len = sizeof(struct tls12_crypto_info_aes_gcm_256);
+		tls12->aesgcm256.info.version = tls_version;
+		tls12->aesgcm256.info.cipher_type = cipher_type;
+		break;
 	default:
 		break;
 	}
@@ -279,6 +285,18 @@ FIXTURE_VARIANT_ADD(tls, 13_aes_ccm)
 	.cipher_type = TLS_CIPHER_AES_CCM_128,
 };
 
+FIXTURE_VARIANT_ADD(tls, 12_aes_gcm_256)
+{
+	.tls_version = TLS_1_2_VERSION,
+	.cipher_type = TLS_CIPHER_AES_GCM_256,
+};
+
+FIXTURE_VARIANT_ADD(tls, 13_aes_gcm_256)
+{
+	.tls_version = TLS_1_3_VERSION,
+	.cipher_type = TLS_CIPHER_AES_GCM_256,
+};
+
 FIXTURE_SETUP(tls)
 {
 	struct tls_crypto_info_keys tls12;
-- 
2.18.4

