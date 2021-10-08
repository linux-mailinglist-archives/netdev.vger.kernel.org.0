Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4986C426692
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 11:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhJHJTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 05:19:44 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:57816 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhJHJTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 05:19:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Ur-Ab74_1633684665;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Ur-Ab74_1633684665)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 Oct 2021 17:17:45 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] selftests/tls: add SM4 GCM/CCM to tls selftests
Date:   Fri,  8 Oct 2021 17:17:45 +0800
Message-Id: <20211008091745.42917-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new cipher as a variant of standard tls selftests.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 tools/testing/selftests/net/tls.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 97fceb9be9ed..d3047e251fe9 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -29,6 +29,8 @@ struct tls_crypto_info_keys {
 	union {
 		struct tls12_crypto_info_aes_gcm_128 aes128;
 		struct tls12_crypto_info_chacha20_poly1305 chacha20;
+		struct tls12_crypto_info_sm4_gcm sm4gcm;
+		struct tls12_crypto_info_sm4_ccm sm4ccm;
 	};
 	size_t len;
 };
@@ -49,6 +51,16 @@ static void tls_crypto_info_init(uint16_t tls_version, uint16_t cipher_type,
 		tls12->aes128.info.version = tls_version;
 		tls12->aes128.info.cipher_type = cipher_type;
 		break;
+	case TLS_CIPHER_SM4_GCM:
+		tls12->len = sizeof(struct tls12_crypto_info_sm4_gcm);
+		tls12->sm4gcm.info.version = tls_version;
+		tls12->sm4gcm.info.cipher_type = cipher_type;
+		break;
+	case TLS_CIPHER_SM4_CCM:
+		tls12->len = sizeof(struct tls12_crypto_info_sm4_ccm);
+		tls12->sm4ccm.info.version = tls_version;
+		tls12->sm4ccm.info.cipher_type = cipher_type;
+		break;
 	default:
 		break;
 	}
@@ -148,13 +160,13 @@ FIXTURE_VARIANT(tls)
 	uint16_t cipher_type;
 };
 
-FIXTURE_VARIANT_ADD(tls, 12_gcm)
+FIXTURE_VARIANT_ADD(tls, 12_aes_gcm)
 {
 	.tls_version = TLS_1_2_VERSION,
 	.cipher_type = TLS_CIPHER_AES_GCM_128,
 };
 
-FIXTURE_VARIANT_ADD(tls, 13_gcm)
+FIXTURE_VARIANT_ADD(tls, 13_aes_gcm)
 {
 	.tls_version = TLS_1_3_VERSION,
 	.cipher_type = TLS_CIPHER_AES_GCM_128,
@@ -172,6 +184,18 @@ FIXTURE_VARIANT_ADD(tls, 13_chacha)
 	.cipher_type = TLS_CIPHER_CHACHA20_POLY1305,
 };
 
+FIXTURE_VARIANT_ADD(tls, 13_sm4_gcm)
+{
+	.tls_version = TLS_1_3_VERSION,
+	.cipher_type = TLS_CIPHER_SM4_GCM,
+};
+
+FIXTURE_VARIANT_ADD(tls, 13_sm4_ccm)
+{
+	.tls_version = TLS_1_3_VERSION,
+	.cipher_type = TLS_CIPHER_SM4_CCM,
+};
+
 FIXTURE_SETUP(tls)
 {
 	struct tls_crypto_info_keys tls12;
-- 
2.19.1.3.ge56e4f7

