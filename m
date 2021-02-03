Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5438A30E423
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 21:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhBCUiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 15:38:05 -0500
Received: from novek.ru ([213.148.174.62]:40692 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232001AbhBCUiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 15:38:05 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id B808C5033A1;
        Wed,  3 Feb 2021 23:37:21 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru B808C5033A1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1612384643; bh=ZvbYwwjqO2fGrp+q7CfISVULFkxNGBocFgzysYt0Mbg=;
        h=From:To:Cc:Subject:Date:From;
        b=vRtwzMwkLKJId0Wn8q4QDITk3EuNZ2CR+q/qocI3xktw+rneiNCMikfjZlvel9eci
         L9nnQMerf7dgPmes2pCkJ2NVdlS8z++JCy2JXnGrforoky9/YJSn/Vck6Q3kFKEXSh
         cXRek95Pwm5EsOoqNr1TX8b66+D631bde0zf5DLg=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Rong Chen <rong.a.chen@intel.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net-next] selftests/tls: fix selftest with CHACHA20-POLY1305
Date:   Wed,  3 Feb 2021 23:37:14 +0300
Message-Id: <1612384634-5377-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS selftests were broken also because of use of structure that
was not exported to UAPI. Fix by defining the union in tests.

Fixes: 3502bd9b5762 (selftests/tls: fix selftests after adding ChaCha20-Poly1305)
Fixes: 4f336e88a870 (selftests/tls: add CHACHA20-POLY1305 to tls selftests)
Reported-by: Rong Chen <rong.a.chen@intel.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 tools/testing/selftests/net/tls.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index e0088c2..426d078 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -133,7 +133,10 @@
 
 FIXTURE_SETUP(tls)
 {
-	union tls_crypto_context tls12;
+	union {
+		struct tls12_crypto_info_aes_gcm_128 aes128;
+		struct tls12_crypto_info_chacha20_poly1305 chacha20;
+	} tls12;
 	struct sockaddr_in addr;
 	socklen_t len;
 	int sfd, ret;
@@ -143,14 +146,16 @@
 	len = sizeof(addr);
 
 	memset(&tls12, 0, sizeof(tls12));
-	tls12.info.version = variant->tls_version;
-	tls12.info.cipher_type = variant->cipher_type;
 	switch (variant->cipher_type) {
 	case TLS_CIPHER_CHACHA20_POLY1305:
-		tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
+		tls12_sz = sizeof(struct tls12_crypto_info_chacha20_poly1305);
+		tls12.chacha20.info.version = variant->tls_version;
+		tls12.chacha20.info.cipher_type = variant->cipher_type;
 		break;
 	case TLS_CIPHER_AES_GCM_128:
-		tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);
+		tls12_sz = sizeof(struct tls12_crypto_info_aes_gcm_128);
+		tls12.aes128.info.version = variant->tls_version;
+		tls12.aes128.info.cipher_type = variant->cipher_type;
 		break;
 	default:
 		tls12_sz = 0;
-- 
1.8.3.1

