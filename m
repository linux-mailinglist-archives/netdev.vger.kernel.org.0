Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975C02120FE
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgGBKWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgGBKUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 06:20:41 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DA5F206DD;
        Thu,  2 Jul 2020 10:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593685240;
        bh=BEFjNdvfKyJ+hPtNF3BSTZhE6Ir6RlgKVVjkC2LTMeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJTrFCj+Qh571w+IHsFYe2TV3F68N0RGr7kIRZkuBPliIy4OdnkwbHqa8rgJkrgX8
         Lf7Or6HJTANuH8xtK2IJ0yhEwkEE3mjT6NLvycD4u+QN0bLKko96If6+9QuvyajoTz
         cTflrIwZ808In3u57ckCUp3pQW6Y6xRwWw9FG+5E=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-nfs@vger.kernel.org
Subject: [RFC PATCH 6/7] crypto: bcm-iproc - remove ecb(arc4) support
Date:   Thu,  2 Jul 2020 12:19:46 +0200
Message-Id: <20200702101947.682-7-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702101947.682-1-ardb@kernel.org>
References: <20200702101947.682-1-ardb@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/bcm/cipher.c | 96 +-------------------
 drivers/crypto/bcm/cipher.h |  1 -
 drivers/crypto/bcm/spu.c    | 23 +----
 drivers/crypto/bcm/spu.h    |  1 -
 drivers/crypto/bcm/spu2.c   | 12 +--
 drivers/crypto/bcm/spu2.h   |  1 -
 6 files changed, 6 insertions(+), 128 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index a353217a0d33..f73b4bd86482 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -165,10 +165,6 @@ spu_skcipher_rx_sg_create(struct brcm_message *mssg,
 		return -EFAULT;
 	}
 
-	if (ctx->cipher.alg == CIPHER_ALG_RC4)
-		/* Add buffer to catch 260-byte SUPDT field for RC4 */
-		sg_set_buf(sg++, rctx->msg_buf.c.supdt_tweak, SPU_SUPDT_LEN);
-
 	if (stat_pad_len)
 		sg_set_buf(sg++, rctx->msg_buf.rx_stat_pad, stat_pad_len);
 
@@ -317,7 +313,6 @@ static int handle_skcipher_req(struct iproc_reqctx_s *rctx)
 	u8 local_iv_ctr[MAX_IV_SIZE];
 	u32 stat_pad_len;	/* num bytes to align status field */
 	u32 pad_len;		/* total length of all padding */
-	bool update_key = false;
 	struct brcm_message *mssg;	/* mailbox message */
 
 	/* number of entries in src and dst sg in mailbox message. */
@@ -391,28 +386,6 @@ static int handle_skcipher_req(struct iproc_reqctx_s *rctx)
 		}
 	}
 
-	if (ctx->cipher.alg == CIPHER_ALG_RC4) {
-		rx_frag_num++;
-		if (chunk_start) {
-			/*
-			 * for non-first RC4 chunks, use SUPDT from previous
-			 * response as key for this chunk.
-			 */
-			cipher_parms.key_buf = rctx->msg_buf.c.supdt_tweak;
-			update_key = true;
-			cipher_parms.type = CIPHER_TYPE_UPDT;
-		} else if (!rctx->is_encrypt) {
-			/*
-			 * First RC4 chunk. For decrypt, key in pre-built msg
-			 * header may have been changed if encrypt required
-			 * multiple chunks. So revert the key to the
-			 * ctx->enckey value.
-			 */
-			update_key = true;
-			cipher_parms.type = CIPHER_TYPE_INIT;
-		}
-	}
-
 	if (ctx->max_payload == SPU_MAX_PAYLOAD_INF)
 		flow_log("max_payload infinite\n");
 	else
@@ -425,14 +398,9 @@ static int handle_skcipher_req(struct iproc_reqctx_s *rctx)
 	memcpy(rctx->msg_buf.bcm_spu_req_hdr, ctx->bcm_spu_req_hdr,
 	       sizeof(rctx->msg_buf.bcm_spu_req_hdr));
 
-	/*
-	 * Pass SUPDT field as key. Key field in finish() call is only used
-	 * when update_key has been set above for RC4. Will be ignored in
-	 * all other cases.
-	 */
 	spu->spu_cipher_req_finish(rctx->msg_buf.bcm_spu_req_hdr + BCM_HDR_LEN,
 				   ctx->spu_req_hdr_len, !(rctx->is_encrypt),
-				   &cipher_parms, update_key, chunksize);
+				   &cipher_parms, chunksize);
 
 	atomic64_add(chunksize, &iproc_priv.bytes_out);
 
@@ -527,9 +495,6 @@ static void handle_skcipher_resp(struct iproc_reqctx_s *rctx)
 		 __func__, rctx->total_received, payload_len);
 
 	dump_sg(req->dst, rctx->total_received, payload_len);
-	if (ctx->cipher.alg == CIPHER_ALG_RC4)
-		packet_dump("  supdt ", rctx->msg_buf.c.supdt_tweak,
-			    SPU_SUPDT_LEN);
 
 	rctx->total_received += payload_len;
 	if (rctx->total_received == rctx->total_todo) {
@@ -1853,26 +1818,6 @@ static int aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	return 0;
 }
 
-static int rc4_setkey(struct crypto_skcipher *cipher, const u8 *key,
-		      unsigned int keylen)
-{
-	struct iproc_ctx_s *ctx = crypto_skcipher_ctx(cipher);
-	int i;
-
-	ctx->enckeylen = ARC4_MAX_KEY_SIZE + ARC4_STATE_SIZE;
-
-	ctx->enckey[0] = 0x00;	/* 0x00 */
-	ctx->enckey[1] = 0x00;	/* i    */
-	ctx->enckey[2] = 0x00;	/* 0x00 */
-	ctx->enckey[3] = 0x00;	/* j    */
-	for (i = 0; i < ARC4_MAX_KEY_SIZE; i++)
-		ctx->enckey[i + ARC4_STATE_SIZE] = key[i % keylen];
-
-	ctx->cipher_type = CIPHER_TYPE_INIT;
-
-	return 0;
-}
-
 static int skcipher_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			     unsigned int keylen)
 {
@@ -1895,9 +1840,6 @@ static int skcipher_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	case CIPHER_ALG_AES:
 		err = aes_setkey(cipher, key, keylen);
 		break;
-	case CIPHER_ALG_RC4:
-		err = rc4_setkey(cipher, key, keylen);
-		break;
 	default:
 		pr_err("%s() Error: unknown cipher alg\n", __func__);
 		err = -EINVAL;
@@ -1905,11 +1847,9 @@ static int skcipher_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	if (err)
 		return err;
 
-	/* RC4 already populated ctx->enkey */
-	if (ctx->cipher.alg != CIPHER_ALG_RC4) {
-		memcpy(ctx->enckey, key, keylen);
-		ctx->enckeylen = keylen;
-	}
+	memcpy(ctx->enckey, key, keylen);
+	ctx->enckeylen = keylen;
+
 	/* SPU needs XTS keys in the reverse order the crypto API presents */
 	if ((ctx->cipher.alg == CIPHER_ALG_AES) &&
 	    (ctx->cipher.mode == CIPHER_MODE_XTS)) {
@@ -2872,9 +2812,6 @@ static int aead_authenc_setkey(struct crypto_aead *cipher,
 			goto badkey;
 		}
 		break;
-	case CIPHER_ALG_RC4:
-		ctx->cipher_type = CIPHER_TYPE_INIT;
-		break;
 	default:
 		pr_err("%s() Error: Unknown cipher alg\n", __func__);
 		return -EINVAL;
@@ -3573,25 +3510,6 @@ static struct iproc_alg_s driver_algs[] = {
 	 },
 
 /* SKCIPHER algorithms. */
-	{
-	 .type = CRYPTO_ALG_TYPE_SKCIPHER,
-	 .alg.skcipher = {
-			.base.cra_name = "ecb(arc4)",
-			.base.cra_driver_name = "ecb-arc4-iproc",
-			.base.cra_blocksize = ARC4_BLOCK_SIZE,
-			.min_keysize = ARC4_MIN_KEY_SIZE,
-			.max_keysize = ARC4_MAX_KEY_SIZE,
-			.ivsize = 0,
-			},
-	 .cipher_info = {
-			 .alg = CIPHER_ALG_RC4,
-			 .mode = CIPHER_MODE_NONE,
-			 },
-	 .auth_info = {
-		       .alg = HASH_ALG_NONE,
-		       .mode = HASH_MODE_NONE,
-		       },
-	 },
 	{
 	 .type = CRYPTO_ALG_TYPE_SKCIPHER,
 	 .alg.skcipher = {
@@ -4495,15 +4413,9 @@ static void spu_counters_init(void)
 
 static int spu_register_skcipher(struct iproc_alg_s *driver_alg)
 {
-	struct spu_hw *spu = &iproc_priv.spu;
 	struct skcipher_alg *crypto = &driver_alg->alg.skcipher;
 	int err;
 
-	/* SPU2 does not support RC4 */
-	if ((driver_alg->cipher_info.alg == CIPHER_ALG_RC4) &&
-	    (spu->spu_type == SPU_TYPE_SPU2))
-		return 0;
-
 	crypto->base.cra_module = THIS_MODULE;
 	crypto->base.cra_priority = cipher_pri;
 	crypto->base.cra_alignmask = 0;
diff --git a/drivers/crypto/bcm/cipher.h b/drivers/crypto/bcm/cipher.h
index b6d83e3aa46c..035c8389cb3d 100644
--- a/drivers/crypto/bcm/cipher.h
+++ b/drivers/crypto/bcm/cipher.h
@@ -388,7 +388,6 @@ struct spu_hw {
 				      u16 spu_req_hdr_len,
 				      unsigned int is_inbound,
 				      struct spu_cipher_parms *cipher_parms,
-				      bool update_key,
 				      unsigned int data_size);
 	void (*spu_request_pad)(u8 *pad_start, u32 gcm_padding,
 				u32 hash_pad_len, enum hash_alg auth_alg,
diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
index e7562e9bf396..fe126f95c702 100644
--- a/drivers/crypto/bcm/spu.c
+++ b/drivers/crypto/bcm/spu.c
@@ -222,10 +222,6 @@ void spum_dump_msg_hdr(u8 *buf, unsigned int buf_len)
 				cipher_key_len = 24;
 				name = "3DES";
 				break;
-			case CIPHER_ALG_RC4:
-				cipher_key_len = 260;
-				name = "ARC4";
-				break;
 			case CIPHER_ALG_AES:
 				switch (cipher_type) {
 				case CIPHER_TYPE_AES128:
@@ -919,21 +915,16 @@ u16 spum_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms)
  * @spu_req_hdr_len: Length in bytes of the SPU request header
  * @isInbound:       0 encrypt, 1 decrypt
  * @cipher_parms:    Parameters describing cipher operation to be performed
- * @update_key:      If true, rewrite the cipher key in SCTX
  * @data_size:       Length of the data in the BD field
  *
  * Assumes much of the header was already filled in at setkey() time in
  * spum_cipher_req_init().
- * spum_cipher_req_init() fills in the encryption key. For RC4, when submitting
- * a request for a non-first chunk, we use the 260-byte SUPDT field from the
- * previous response as the key. update_key is true for this case. Unused in all
- * other cases.
+ * spum_cipher_req_init() fills in the encryption key.
  */
 void spum_cipher_req_finish(u8 *spu_hdr,
 			    u16 spu_req_hdr_len,
 			    unsigned int is_inbound,
 			    struct spu_cipher_parms *cipher_parms,
-			    bool update_key,
 			    unsigned int data_size)
 {
 	struct SPUHEADER *spuh;
@@ -948,11 +939,6 @@ void spum_cipher_req_finish(u8 *spu_hdr,
 	flow_log(" in: %u\n", is_inbound);
 	flow_log(" cipher alg: %u, cipher_type: %u\n", cipher_parms->alg,
 		 cipher_parms->type);
-	if (update_key) {
-		flow_log(" cipher key len: %u\n", cipher_parms->key_len);
-		flow_dump("  key: ", cipher_parms->key_buf,
-			  cipher_parms->key_len);
-	}
 
 	/*
 	 * In XTS mode, API puts "i" parameter (block tweak) in IV.  For
@@ -981,13 +967,6 @@ void spum_cipher_req_finish(u8 *spu_hdr,
 	else
 		cipher_bits &= ~CIPHER_INBOUND;
 
-	/* update encryption key for RC4 on non-first chunk */
-	if (update_key) {
-		spuh->sa.cipher_flags |=
-			cipher_parms->type << CIPHER_TYPE_SHIFT;
-		memcpy(spuh + 1, cipher_parms->key_buf, cipher_parms->key_len);
-	}
-
 	if (cipher_parms->alg && cipher_parms->iv_buf && cipher_parms->iv_len)
 		/* cipher iv provided so put it in here */
 		memcpy(bdesc_ptr - cipher_parms->iv_len, cipher_parms->iv_buf,
diff --git a/drivers/crypto/bcm/spu.h b/drivers/crypto/bcm/spu.h
index b247bc5b9354..dd132389bcaa 100644
--- a/drivers/crypto/bcm/spu.h
+++ b/drivers/crypto/bcm/spu.h
@@ -251,7 +251,6 @@ void spum_cipher_req_finish(u8 *spu_hdr,
 			    u16 spu_req_hdr_len,
 			    unsigned int is_inbound,
 			    struct spu_cipher_parms *cipher_parms,
-			    bool update_key,
 			    unsigned int data_size);
 
 void spum_request_pad(u8 *pad_start,
diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
index 59abb5ecefa4..c860ffb0b4c3 100644
--- a/drivers/crypto/bcm/spu2.c
+++ b/drivers/crypto/bcm/spu2.c
@@ -1170,21 +1170,16 @@ u16 spu2_cipher_req_init(u8 *spu_hdr, struct spu_cipher_parms *cipher_parms)
  * @spu_req_hdr_len: Length in bytes of the SPU request header
  * @isInbound:       0 encrypt, 1 decrypt
  * @cipher_parms:    Parameters describing cipher operation to be performed
- * @update_key:      If true, rewrite the cipher key in SCTX
  * @data_size:       Length of the data in the BD field
  *
  * Assumes much of the header was already filled in at setkey() time in
  * spu_cipher_req_init().
- * spu_cipher_req_init() fills in the encryption key. For RC4, when submitting a
- * request for a non-first chunk, we use the 260-byte SUPDT field from the
- * previous response as the key. update_key is true for this case. Unused in all
- * other cases.
+ * spu_cipher_req_init() fills in the encryption key.
  */
 void spu2_cipher_req_finish(u8 *spu_hdr,
 			    u16 spu_req_hdr_len,
 			    unsigned int is_inbound,
 			    struct spu_cipher_parms *cipher_parms,
-			    bool update_key,
 			    unsigned int data_size)
 {
 	struct SPU2_FMD *fmd;
@@ -1196,11 +1191,6 @@ void spu2_cipher_req_finish(u8 *spu_hdr,
 	flow_log(" in: %u\n", is_inbound);
 	flow_log(" cipher alg: %u, cipher_type: %u\n", cipher_parms->alg,
 		 cipher_parms->type);
-	if (update_key) {
-		flow_log(" cipher key len: %u\n", cipher_parms->key_len);
-		flow_dump("  key: ", cipher_parms->key_buf,
-			  cipher_parms->key_len);
-	}
 	flow_log(" iv len: %d\n", cipher_parms->iv_len);
 	flow_dump("    iv: ", cipher_parms->iv_buf, cipher_parms->iv_len);
 	flow_log(" data_size: %u\n", data_size);
diff --git a/drivers/crypto/bcm/spu2.h b/drivers/crypto/bcm/spu2.h
index 03af6c38df7f..6e666bfb3cfc 100644
--- a/drivers/crypto/bcm/spu2.h
+++ b/drivers/crypto/bcm/spu2.h
@@ -200,7 +200,6 @@ void spu2_cipher_req_finish(u8 *spu_hdr,
 			    u16 spu_req_hdr_len,
 			    unsigned int is_inbound,
 			    struct spu_cipher_parms *cipher_parms,
-			    bool update_key,
 			    unsigned int data_size);
 void spu2_request_pad(u8 *pad_start, u32 gcm_padding, u32 hash_pad_len,
 		      enum hash_alg auth_alg, enum hash_mode auth_mode,
-- 
2.17.1

