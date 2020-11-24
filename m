Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217D22C2B39
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389717AbgKXPZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:25:21 -0500
Received: from novek.ru ([213.148.174.62]:47258 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389601AbgKXPZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:25:19 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 8C4845030CA;
        Tue, 24 Nov 2020 18:25:33 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 8C4845030CA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1606231534; bh=dCPVZa/fEtN9rhac85+KpaJ3wXE+OOenM3dWYEYPgXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wN9g57E98mWzblPLYDYFGv8X4CHe6tMeJylcl3rVlMCM3QcWiWSBA3NrKfQQ3qi7P
         nxgXxgUdI0y3/sXMo0JgBH+/iCGM/9iX0K3hS51oiZE/PPZ2IT8Ufm/jSwBy0OVFfV
         0pk14w9T3PLcN46/OddCfVie8x7Er5xWH3ac94Xw=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [net-next v2 4/5] net/tls: add CHACHA20-POLY1305 configuration
Date:   Tue, 24 Nov 2020 18:24:49 +0300
Message-Id: <1606231490-653-5-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
References: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ChaCha-Poly specific configuration code.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/tls/tls_main.c |  3 +++
 net/tls/tls_sw.c   | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 8d93cea..47b7c53 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -521,6 +521,9 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	case TLS_CIPHER_AES_CCM_128:
 		optsize = sizeof(struct tls12_crypto_info_aes_ccm_128);
 		break;
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		optsize = sizeof(struct tls12_crypto_info_chacha20_poly1305);
+		break;
 	default:
 		rc = -EINVAL;
 		goto err_crypto_info;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index b4eefdb..53106f0 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2290,6 +2290,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 	struct tls12_crypto_info_aes_gcm_128 *gcm_128_info;
 	struct tls12_crypto_info_aes_gcm_256 *gcm_256_info;
 	struct tls12_crypto_info_aes_ccm_128 *ccm_128_info;
+	struct tls12_crypto_info_chacha20_poly1305 *chacha20_poly1305_info;
 	struct tls_sw_context_tx *sw_ctx_tx = NULL;
 	struct tls_sw_context_rx *sw_ctx_rx = NULL;
 	struct cipher_context *cctx;
@@ -2402,6 +2403,21 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		cipher_name = "ccm(aes)";
 		break;
 	}
+	case TLS_CIPHER_CHACHA20_POLY1305: {
+		chacha20_poly1305_info = (void *)crypto_info;
+		nonce_size = 0;
+		tag_size = TLS_CIPHER_CHACHA20_POLY1305_TAG_SIZE;
+		iv_size = TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE;
+		iv = chacha20_poly1305_info->iv;
+		rec_seq_size = TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE;
+		rec_seq = chacha20_poly1305_info->rec_seq;
+		keysize = TLS_CIPHER_CHACHA20_POLY1305_KEY_SIZE;
+		key = chacha20_poly1305_info->key;
+		salt = chacha20_poly1305_info->salt;
+		salt_size = TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE;
+		cipher_name = "rfc7539(chacha20,poly1305)";
+		break;
+	}
 	default:
 		rc = -EINVAL;
 		goto free_priv;
-- 
1.8.3.1

