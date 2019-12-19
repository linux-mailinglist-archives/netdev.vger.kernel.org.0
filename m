Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA332125FF4
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfLSKwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:52:49 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:35306 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfLSKws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 05:52:48 -0500
Received: from cyclone.blr.asicdesigners.com (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBJAqL22010899;
        Thu, 19 Dec 2019 02:52:40 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 1/2] chtls: Add support for AES256-GCM based ciphers
Date:   Thu, 19 Dec 2019 16:21:47 +0530
Message-Id: <20191219105148.32456-2-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20191219105148.32456-1-vinay.yadav@chelsio.com>
References: <20191219105148.32456-1-vinay.yadav@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support to set 256 bit key to the hardware from
setsockopt for AES256-GCM based ciphers.

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls.h      |  7 ++-
 drivers/crypto/chelsio/chtls/chtls_hw.c   | 62 ++++++++++++++++-------
 drivers/crypto/chelsio/chtls/chtls_main.c | 23 ++++++++-
 3 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index d2bc655ab931..459442704eb1 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/crypto/chelsio/chtls/chtls.h
@@ -179,7 +179,10 @@ struct chtls_hws {
 	u32 copied_seq;
 	u64 tx_seq_no;
 	struct tls_scmd scmd;
-	struct tls12_crypto_info_aes_gcm_128 crypto_info;
+	union {
+		struct tls12_crypto_info_aes_gcm_128 aes_gcm_128;
+		struct tls12_crypto_info_aes_gcm_256 aes_gcm_256;
+	} crypto_info;
 };
 
 struct chtls_sock {
@@ -482,7 +485,7 @@ int send_tx_flowc_wr(struct sock *sk, int compl,
 void chtls_tcp_push(struct sock *sk, int flags);
 int chtls_push_frames(struct chtls_sock *csk, int comp);
 int chtls_set_tcb_tflag(struct sock *sk, unsigned int bit_pos, int val);
-int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 mode);
+int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 mode, int cipher_type);
 void skb_entail(struct sock *sk, struct sk_buff *skb, int flags);
 unsigned int keyid_to_addr(int start_addr, int keyid);
 void free_tls_keyid(struct sock *sk);
diff --git a/drivers/crypto/chelsio/chtls/chtls_hw.c b/drivers/crypto/chelsio/chtls/chtls_hw.c
index 2a34035d3cfb..14d82f4e3dcf 100644
--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -208,28 +208,53 @@ static void chtls_rxkey_ivauth(struct _key_ctx *kctx)
 
 static int chtls_key_info(struct chtls_sock *csk,
 			  struct _key_ctx *kctx,
-			  u32 keylen, u32 optname)
+			  u32 keylen, u32 optname,
+			  int cipher_type)
 {
-	unsigned char key[AES_KEYSIZE_128];
-	struct tls12_crypto_info_aes_gcm_128 *gcm_ctx;
+	unsigned char key[AES_MAX_KEY_SIZE];
+	unsigned char *key_p, *salt;
 	unsigned char ghash_h[AEAD_H_SIZE];
-	int ck_size, key_ctx_size;
+	int ck_size, key_ctx_size, kctx_mackey_size, salt_size;
 	struct crypto_aes_ctx aes;
 	int ret;
 
-	gcm_ctx = (struct tls12_crypto_info_aes_gcm_128 *)
-		  &csk->tlshws.crypto_info;
-
 	key_ctx_size = sizeof(struct _key_ctx) +
 		       roundup(keylen, 16) + AEAD_H_SIZE;
 
-	if (keylen == AES_KEYSIZE_128) {
-		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
-	} else {
+	/* GCM mode of AES supports 128 and 256 bit encryption, so
+	 * prepare key context base on GCM cipher type
+	 */
+	switch (cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *gcm_ctx_128 =
+			(struct tls12_crypto_info_aes_gcm_128 *)
+					&csk->tlshws.crypto_info;
+		memcpy(key, gcm_ctx_128->key, keylen);
+
+		key_p            = gcm_ctx_128->key;
+		salt             = gcm_ctx_128->salt;
+		ck_size          = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
+		salt_size        = TLS_CIPHER_AES_GCM_128_SALT_SIZE;
+		kctx_mackey_size = CHCR_KEYCTX_MAC_KEY_SIZE_128;
+		break;
+	}
+	case TLS_CIPHER_AES_GCM_256: {
+		struct tls12_crypto_info_aes_gcm_256 *gcm_ctx_256 =
+			(struct tls12_crypto_info_aes_gcm_256 *)
+					&csk->tlshws.crypto_info;
+		memcpy(key, gcm_ctx_256->key, keylen);
+
+		key_p            = gcm_ctx_256->key;
+		salt             = gcm_ctx_256->salt;
+		ck_size          = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
+		salt_size        = TLS_CIPHER_AES_GCM_256_SALT_SIZE;
+		kctx_mackey_size = CHCR_KEYCTX_MAC_KEY_SIZE_256;
+		break;
+	}
+	default:
 		pr_err("GCM: Invalid key length %d\n", keylen);
 		return -EINVAL;
 	}
-	memcpy(key, gcm_ctx->key, keylen);
 
 	/* Calculate the H = CIPH(K, 0 repeated 16 times).
 	 * It will go in key context
@@ -249,20 +274,20 @@ static int chtls_key_info(struct chtls_sock *csk,
 
 		key_ctx = ((key_ctx_size >> 4) << 3);
 		kctx->ctx_hdr = FILL_KEY_CRX_HDR(ck_size,
-						 CHCR_KEYCTX_MAC_KEY_SIZE_128,
+						 kctx_mackey_size,
 						 0, 0, key_ctx);
 		chtls_rxkey_ivauth(kctx);
 	} else {
 		kctx->ctx_hdr = FILL_KEY_CTX_HDR(ck_size,
-						 CHCR_KEYCTX_MAC_KEY_SIZE_128,
+						 kctx_mackey_size,
 						 0, 0, key_ctx_size >> 4);
 	}
 
-	memcpy(kctx->salt, gcm_ctx->salt, TLS_CIPHER_AES_GCM_128_SALT_SIZE);
-	memcpy(kctx->key, gcm_ctx->key, keylen);
+	memcpy(kctx->salt, salt, salt_size);
+	memcpy(kctx->key, key_p, keylen);
 	memcpy(kctx->key + keylen, ghash_h, AEAD_H_SIZE);
 	/* erase key info from driver */
-	memset(gcm_ctx->key, 0, keylen);
+	memset(key_p, 0, keylen);
 
 	return 0;
 }
@@ -288,7 +313,8 @@ static void chtls_set_scmd(struct chtls_sock *csk)
 		SCMD_TLS_FRAG_ENABLE_V(1);
 }
 
-int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 optname)
+int chtls_setkey(struct chtls_sock *csk, u32 keylen,
+		 u32 optname, int cipher_type)
 {
 	struct tls_key_req *kwr;
 	struct chtls_dev *cdev;
@@ -352,7 +378,7 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 optname)
 
 	/* key info */
 	kctx = (struct _key_ctx *)(kwr + 1);
-	ret = chtls_key_info(csk, kctx, keylen, optname);
+	ret = chtls_key_info(csk, kctx, keylen, optname, cipher_type);
 	if (ret)
 		goto out_notcb;
 
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 18996935d8ba..a148f5c6621b 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -486,6 +486,7 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
 	struct tls_crypto_info *crypto_info, tmp_crypto_info;
 	struct chtls_sock *csk;
 	int keylen;
+	int cipher_type;
 	int rc = 0;
 
 	csk = rcu_dereference_sk_user_data(sk);
@@ -509,6 +510,9 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
 
 	crypto_info = (struct tls_crypto_info *)&csk->tlshws.crypto_info;
 
+	/* GCM mode of AES supports 128 and 256 bit encryption, so
+	 * copy keys from user based on GCM cipher type.
+	 */
 	switch (tmp_crypto_info.cipher_type) {
 	case TLS_CIPHER_AES_GCM_128: {
 		/* Obtain version and type from previous copy */
@@ -525,13 +529,30 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
 		}
 
 		keylen = TLS_CIPHER_AES_GCM_128_KEY_SIZE;
-		rc = chtls_setkey(csk, keylen, optname);
+		cipher_type = TLS_CIPHER_AES_GCM_128;
+		break;
+	}
+	case TLS_CIPHER_AES_GCM_256: {
+		crypto_info[0] = tmp_crypto_info;
+		rc = copy_from_user((char *)crypto_info + sizeof(*crypto_info),
+				    optval + sizeof(*crypto_info),
+				sizeof(struct tls12_crypto_info_aes_gcm_256)
+				- sizeof(*crypto_info));
+
+		if (rc) {
+			rc = -EFAULT;
+			goto out;
+		}
+
+		keylen = TLS_CIPHER_AES_GCM_256_KEY_SIZE;
+		cipher_type = TLS_CIPHER_AES_GCM_256;
 		break;
 	}
 	default:
 		rc = -EINVAL;
 		goto out;
 	}
+	rc = chtls_setkey(csk, keylen, optname, cipher_type);
 out:
 	return rc;
 }
-- 
2.18.1

