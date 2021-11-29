Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28884613AD
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 12:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243406AbhK2LPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:15:35 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:34687 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354197AbhK2LNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 06:13:35 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Uyj07Kr_1638184215;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Uyj07Kr_1638184215)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 29 Nov 2021 19:10:16 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] net/tls: simplify the tls_set_sw_offload function
Date:   Mon, 29 Nov 2021 19:10:14 +0800
Message-Id: <20211129111014.4910-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assigning crypto_info variables in advance can simplify the logic
of accessing value and move related local variables to a smaller
scope.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 net/tls/tls_sw.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index dfe623a4e72f..3f271e29812f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2328,10 +2328,6 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct tls_crypto_info *crypto_info;
-	struct tls12_crypto_info_aes_gcm_128 *gcm_128_info;
-	struct tls12_crypto_info_aes_gcm_256 *gcm_256_info;
-	struct tls12_crypto_info_aes_ccm_128 *ccm_128_info;
-	struct tls12_crypto_info_chacha20_poly1305 *chacha20_poly1305_info;
 	struct tls_sw_context_tx *sw_ctx_tx = NULL;
 	struct tls_sw_context_rx *sw_ctx_rx = NULL;
 	struct cipher_context *cctx;
@@ -2394,15 +2390,15 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 
 	switch (crypto_info->cipher_type) {
 	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *gcm_128_info;
+
+		gcm_128_info = (void *)crypto_info;
 		nonce_size = TLS_CIPHER_AES_GCM_128_IV_SIZE;
 		tag_size = TLS_CIPHER_AES_GCM_128_TAG_SIZE;
 		iv_size = TLS_CIPHER_AES_GCM_128_IV_SIZE;
-		iv = ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->iv;
+		iv = gcm_128_info->iv;
 		rec_seq_size = TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE;
-		rec_seq =
-		 ((struct tls12_crypto_info_aes_gcm_128 *)crypto_info)->rec_seq;
-		gcm_128_info =
-			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+		rec_seq = gcm_128_info->rec_seq;
 		keysize = TLS_CIPHER_AES_GCM_128_KEY_SIZE;
 		key = gcm_128_info->key;
 		salt = gcm_128_info->salt;
@@ -2411,15 +2407,15 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		break;
 	}
 	case TLS_CIPHER_AES_GCM_256: {
+		struct tls12_crypto_info_aes_gcm_256 *gcm_256_info;
+
+		gcm_256_info = (void *)crypto_info;
 		nonce_size = TLS_CIPHER_AES_GCM_256_IV_SIZE;
 		tag_size = TLS_CIPHER_AES_GCM_256_TAG_SIZE;
 		iv_size = TLS_CIPHER_AES_GCM_256_IV_SIZE;
-		iv = ((struct tls12_crypto_info_aes_gcm_256 *)crypto_info)->iv;
+		iv = gcm_256_info->iv;
 		rec_seq_size = TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE;
-		rec_seq =
-		 ((struct tls12_crypto_info_aes_gcm_256 *)crypto_info)->rec_seq;
-		gcm_256_info =
-			(struct tls12_crypto_info_aes_gcm_256 *)crypto_info;
+		rec_seq = gcm_256_info->rec_seq;
 		keysize = TLS_CIPHER_AES_GCM_256_KEY_SIZE;
 		key = gcm_256_info->key;
 		salt = gcm_256_info->salt;
@@ -2428,15 +2424,15 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		break;
 	}
 	case TLS_CIPHER_AES_CCM_128: {
+		struct tls12_crypto_info_aes_ccm_128 *ccm_128_info;
+
+		ccm_128_info = (void *)crypto_info;
 		nonce_size = TLS_CIPHER_AES_CCM_128_IV_SIZE;
 		tag_size = TLS_CIPHER_AES_CCM_128_TAG_SIZE;
 		iv_size = TLS_CIPHER_AES_CCM_128_IV_SIZE;
-		iv = ((struct tls12_crypto_info_aes_ccm_128 *)crypto_info)->iv;
+		iv = ccm_128_info->iv;
 		rec_seq_size = TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE;
-		rec_seq =
-		((struct tls12_crypto_info_aes_ccm_128 *)crypto_info)->rec_seq;
-		ccm_128_info =
-		(struct tls12_crypto_info_aes_ccm_128 *)crypto_info;
+		rec_seq = ccm_128_info->rec_seq;
 		keysize = TLS_CIPHER_AES_CCM_128_KEY_SIZE;
 		key = ccm_128_info->key;
 		salt = ccm_128_info->salt;
@@ -2445,6 +2441,8 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		break;
 	}
 	case TLS_CIPHER_CHACHA20_POLY1305: {
+		struct tls12_crypto_info_chacha20_poly1305 *chacha20_poly1305_info;
+
 		chacha20_poly1305_info = (void *)crypto_info;
 		nonce_size = 0;
 		tag_size = TLS_CIPHER_CHACHA20_POLY1305_TAG_SIZE;
-- 
2.32.0

