Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0883E46AA93
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352154AbhLFVnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:43:13 -0500
Received: from novek.ru ([213.148.174.62]:39374 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352148AbhLFVnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 16:43:10 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 2FE51501050;
        Tue,  7 Dec 2021 00:34:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 2FE51501050
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1638826497; bh=ZlLVRzc3mPfTQe2uz/D7ccxZSwpQjvrPGYNWIip7wG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtTNVEBDYDftfxiJJ6p//RM6XSP+5tpl90EAOF5aWjn9bKqUw8ODiZ+4zYABvZtlQ
         lTOZPipTeytt6zz/oMR9EhXMjeqxHiA40pP/qrgQX0X4nc949f3M8lTSbJgt7msAS6
         eB324ImCVsKGYQLNlW+g4XVEE1MC0L6wgH7TPMoo=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [PATCH net 1/2] selftests: tls: add missing AES-CCM cipher tests
Date:   Tue,  7 Dec 2021 00:39:31 +0300
Message-Id: <20211206213932.7508-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20211206213932.7508-1-vfedorenko@novek.ru>
References: <20211206213932.7508-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for TLSv1.2 and TLSv1.3 with AES-CCM cipher.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 tools/testing/selftests/net/tls.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 8a22db0cca49..fb1bb402ee10 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -31,6 +31,7 @@ struct tls_crypto_info_keys {
 		struct tls12_crypto_info_chacha20_poly1305 chacha20;
 		struct tls12_crypto_info_sm4_gcm sm4gcm;
 		struct tls12_crypto_info_sm4_ccm sm4ccm;
+		struct tls12_crypto_info_aes_ccm_128 aesccm128;
 	};
 	size_t len;
 };
@@ -61,6 +62,11 @@ static void tls_crypto_info_init(uint16_t tls_version, uint16_t cipher_type,
 		tls12->sm4ccm.info.version = tls_version;
 		tls12->sm4ccm.info.cipher_type = cipher_type;
 		break;
+	case TLS_CIPHER_AES_CCM_128:
+		tls12->len = sizeof(struct tls12_crypto_info_aes_ccm_128);
+		tls12->aesccm128.info.version = tls_version;
+		tls12->aesccm128.info.cipher_type = cipher_type;
+		break;
 	default:
 		break;
 	}
@@ -261,6 +267,18 @@ FIXTURE_VARIANT_ADD(tls, 13_sm4_ccm)
 	.cipher_type = TLS_CIPHER_SM4_CCM,
 };
 
+FIXTURE_VARIANT_ADD(tls, 12_aes_ccm)
+{
+	.tls_version = TLS_1_2_VERSION,
+	.cipher_type = TLS_CIPHER_AES_CCM_128,
+};
+
+FIXTURE_VARIANT_ADD(tls, 13_aes_ccm)
+{
+	.tls_version = TLS_1_3_VERSION,
+	.cipher_type = TLS_CIPHER_AES_CCM_128,
+};
+
 FIXTURE_SETUP(tls)
 {
 	struct tls_crypto_info_keys tls12;
-- 
2.18.4

