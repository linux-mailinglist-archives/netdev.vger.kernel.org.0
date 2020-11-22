Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C5B2BC318
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 02:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgKVB6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 20:58:07 -0500
Received: from novek.ru ([213.148.174.62]:39812 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgKVB6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 20:58:06 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C09305030B4;
        Sun, 22 Nov 2020 04:58:18 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C09305030B4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1606010299; bh=GljAg3QQXboAjYpsM2BWlg6gzxpk0obfOH1AfDF/twc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scpCj2BOuv+UZ8ttZyhTMXIXb3eUrzBqaFgALHzwhf2a8xUtbaeKRTRm18FJO4StW
         Cb1pGa3KK0eWfUwJkKlP2SWhlWXaFv8HAaK1Bu2nhkQz5p9cvQfNi+MLdwj5KBTrhi
         y+QusHiBh5yFJ439VQTSZl7Ne9U+tistB/l0o3ek=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net-next 5/5] selftests/tls: add CHACHA20-POLY1305 to tls selftests
Date:   Sun, 22 Nov 2020 04:57:45 +0300
Message-Id: <1606010265-30471-6-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606010265-30471-1-git-send-email-vfedorenko@novek.ru>
References: <1606010265-30471-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new cipher as a variant of standart tls selftests

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 tools/testing/selftests/net/tls.c | 40 ++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index b599f1f..49d8ade 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -103,32 +103,58 @@
 
 FIXTURE_VARIANT(tls)
 {
-	unsigned int tls_version;
+	u16 tls_version;
+	u16 cipher_type;
 };
 
-FIXTURE_VARIANT_ADD(tls, 12)
+FIXTURE_VARIANT_ADD(tls, 12_gcm)
 {
 	.tls_version = TLS_1_2_VERSION,
+	.cipher_type = TLS_CIPHER_AES_GCM_128,
 };
 
-FIXTURE_VARIANT_ADD(tls, 13)
+FIXTURE_VARIANT_ADD(tls, 13_gcm)
 {
 	.tls_version = TLS_1_3_VERSION,
+	.cipher_type = TLS_CIPHER_AES_GCM_128,
+};
+
+FIXTURE_VARIANT_ADD(tls, 12_chacha)
+{
+	.tls_version = TLS_1_2_VERSION,
+	.cipher_type = TLS_CIPHER_CHACHA20_POLY1305,
+};
+
+FIXTURE_VARIANT_ADD(tls, 13_chacha)
+{
+	.tls_version = TLS_1_3_VERSION,
+	.cipher_type = TLS_CIPHER_CHACHA20_POLY1305,
 };
 
 FIXTURE_SETUP(tls)
 {
-	struct tls12_crypto_info_aes_gcm_128 tls12;
+	union tls_crypto_context tls12;
 	struct sockaddr_in addr;
 	socklen_t len;
 	int sfd, ret;
+	size_t tls12_sz;
 
 	self->notls = false;
 	len = sizeof(addr);
 
 	memset(&tls12, 0, sizeof(tls12));
 	tls12.info.version = variant->tls_version;
-	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
+	tls12.info.cipher_type = variant->cipher_type;
+	switch(variant->cipher_type) {
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
+		break;
+	case TLS_CIPHER_AES_GCM_128:
+		tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);
+		break;
+	default:
+		tls12_sz = 0;
+	}
 
 	addr.sin_family = AF_INET;
 	addr.sin_addr.s_addr = htonl(INADDR_ANY);
@@ -156,7 +182,7 @@
 
 	if (!self->notls) {
 		ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12,
-				 sizeof(tls12));
+				 tls12_sz);
 		ASSERT_EQ(ret, 0);
 	}
 
@@ -169,7 +195,7 @@
 		ASSERT_EQ(ret, 0);
 
 		ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12,
-				 sizeof(tls12));
+				 tls12_sz);
 		ASSERT_EQ(ret, 0);
 	}
 
-- 
1.8.3.1

