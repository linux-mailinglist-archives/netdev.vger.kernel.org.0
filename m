Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B8A2120EC
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgGBKUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbgGBKUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 06:20:32 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4726207CD;
        Thu,  2 Jul 2020 10:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593685230;
        bh=0VWlPF65B36etpYEliENYzyvd3lQfUhUI+LiSrttQ9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=caibLeQSqBHxbdFxxeF/yq+R6w4/VsjInsPKWlgOUFlLU4k97Qxf5zJhWU7wjuzOq
         scHU2n5xSR2bY3ysWtmW+zsen/2rqlAbDeU7nOO8pCEpVYQ6i53f5TeJrVskBXPsEq
         64zuGOeUgz64IvVpweVtEdLzixR1pB2dJ3W94pWs=
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
Subject: [RFC PATCH 3/7] SUNRPC: remove RC4-HMAC-MD5 support from KerberosV
Date:   Thu,  2 Jul 2020 12:19:43 +0200
Message-Id: <20200702101947.682-4-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702101947.682-1-ardb@kernel.org>
References: <20200702101947.682-1-ardb@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RC4-HMAC-MD5 KerberosV algorithm is based on RFC 4757 [0], which
was specifically issued for interoperability with Windows 2000, but was
never intended to receive the same level of support. The RFC says

  The IETF Kerberos community supports publishing this specification as
  an informational document in order to describe this widely
  implemented technology.  However, while these encryption types
  provide the operations necessary to implement the base Kerberos
  specification [RFC4120], they do not provide all the required
  operations in the Kerberos cryptography framework [RFC3961].  As a
  result, it is not generally possible to implement potential
  extensions to Kerberos using these encryption types.  The Kerberos
  encryption type negotiation mechanism [RFC4537] provides one approach
  for using such extensions even when a Kerberos infrastructure uses
  long-term RC4 keys.  Because this specification does not implement
  operations required by RFC 3961 and because of security concerns with
  the use of RC4 and MD4 discussed in Section 8, this specification is
  not appropriate for publication on the standards track.

  The RC4-HMAC encryption types are used to ease upgrade of existing
  Windows NT environments, provide strong cryptography (128-bit key
  lengths), and provide exportable (meet United States government
  export restriction requirements) encryption.  This document describes
  the implementation of those encryption types.

Furthermore, this RFC was re-classified as 'historic' by RFC 8429 [1] in
2018, stating that 'none of the encryption types it specifies should be
used'

Note that other outdated algorithms are left in place (some of which are
guarded by CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES), so this should only
adversely affect interoperability with Windows NT/2000 systems that have
not received any updates since 2008 (but are connected to a network
nonetheless)

[0] https://tools.ietf.org/html/rfc4757
[1] https://tools.ietf.org/html/rfc8429

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/sunrpc/gss_krb5.h          |  11 -
 include/linux/sunrpc/gss_krb5_enctypes.h |   9 +-
 net/sunrpc/Kconfig                       |   1 -
 net/sunrpc/auth_gss/gss_krb5_crypto.c    | 276 --------------------
 net/sunrpc/auth_gss/gss_krb5_mech.c      |  95 -------
 net/sunrpc/auth_gss/gss_krb5_seal.c      |   1 -
 net/sunrpc/auth_gss/gss_krb5_seqnum.c    |  87 ------
 net/sunrpc/auth_gss/gss_krb5_unseal.c    |   1 -
 net/sunrpc/auth_gss/gss_krb5_wrap.c      |  65 +----
 9 files changed, 16 insertions(+), 530 deletions(-)

diff --git a/include/linux/sunrpc/gss_krb5.h b/include/linux/sunrpc/gss_krb5.h
index e8f8ffe7448b..91f43d86879d 100644
--- a/include/linux/sunrpc/gss_krb5.h
+++ b/include/linux/sunrpc/gss_krb5.h
@@ -141,14 +141,12 @@ enum sgn_alg {
 	SGN_ALG_MD2_5 = 0x0001,
 	SGN_ALG_DES_MAC = 0x0002,
 	SGN_ALG_3 = 0x0003,		/* not published */
-	SGN_ALG_HMAC_MD5 = 0x0011,	/* microsoft w2k; no support */
 	SGN_ALG_HMAC_SHA1_DES3_KD = 0x0004
 };
 enum seal_alg {
 	SEAL_ALG_NONE = 0xffff,
 	SEAL_ALG_DES = 0x0000,
 	SEAL_ALG_1 = 0x0001,		/* not published */
-	SEAL_ALG_MICROSOFT_RC4 = 0x0010,/* microsoft w2k; no support */
 	SEAL_ALG_DES3KD = 0x0002
 };
 
@@ -316,14 +314,5 @@ gss_krb5_aes_decrypt(struct krb5_ctx *kctx, u32 offset, u32 len,
 		     struct xdr_buf *buf, u32 *plainoffset,
 		     u32 *plainlen);
 
-int
-krb5_rc4_setup_seq_key(struct krb5_ctx *kctx,
-		       struct crypto_sync_skcipher *cipher,
-		       unsigned char *cksum);
-
-int
-krb5_rc4_setup_enc_key(struct krb5_ctx *kctx,
-		       struct crypto_sync_skcipher *cipher,
-		       s32 seqnum);
 void
 gss_krb5_make_confounder(char *p, u32 conflen);
diff --git a/include/linux/sunrpc/gss_krb5_enctypes.h b/include/linux/sunrpc/gss_krb5_enctypes.h
index 981c89cef19d..87eea679d750 100644
--- a/include/linux/sunrpc/gss_krb5_enctypes.h
+++ b/include/linux/sunrpc/gss_krb5_enctypes.h
@@ -13,15 +13,13 @@
 #ifdef CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES
 
 /*
- * NB: This list includes encryption types that were deprecated
- * by RFC 8429 (DES3_CBC_SHA1 and ARCFOUR_HMAC).
+ * NB: This list includes DES3_CBC_SHA1, which was deprecated by RFC 8429.
  *
  * ENCTYPE_AES256_CTS_HMAC_SHA1_96
  * ENCTYPE_AES128_CTS_HMAC_SHA1_96
  * ENCTYPE_DES3_CBC_SHA1
- * ENCTYPE_ARCFOUR_HMAC
  */
-#define KRB5_SUPPORTED_ENCTYPES "18,17,16,23"
+#define KRB5_SUPPORTED_ENCTYPES "18,17,16"
 
 #else	/* CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES */
 
@@ -32,12 +30,11 @@
  * ENCTYPE_AES256_CTS_HMAC_SHA1_96
  * ENCTYPE_AES128_CTS_HMAC_SHA1_96
  * ENCTYPE_DES3_CBC_SHA1
- * ENCTYPE_ARCFOUR_HMAC
  * ENCTYPE_DES_CBC_MD5
  * ENCTYPE_DES_CBC_CRC
  * ENCTYPE_DES_CBC_MD4
  */
-#define KRB5_SUPPORTED_ENCTYPES "18,17,16,23,3,1,2"
+#define KRB5_SUPPORTED_ENCTYPES "18,17,16,3,1,2"
 
 #endif	/* CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES */
 
diff --git a/net/sunrpc/Kconfig b/net/sunrpc/Kconfig
index 3bcf985507be..bbbb5af0af13 100644
--- a/net/sunrpc/Kconfig
+++ b/net/sunrpc/Kconfig
@@ -21,7 +21,6 @@ config RPCSEC_GSS_KRB5
 	depends on SUNRPC && CRYPTO
 	depends on CRYPTO_MD5 && CRYPTO_DES && CRYPTO_CBC && CRYPTO_CTS
 	depends on CRYPTO_ECB && CRYPTO_HMAC && CRYPTO_SHA1 && CRYPTO_AES
-	depends on CRYPTO_ARC4
 	default y
 	select SUNRPC_GSS
 	help
diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index e7180da1fc6a..634b6c6e0dcb 100644
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -138,135 +138,6 @@ checksummer(struct scatterlist *sg, void *data)
 	return crypto_ahash_update(req);
 }
 
-static int
-arcfour_hmac_md5_usage_to_salt(unsigned int usage, u8 salt[4])
-{
-	unsigned int ms_usage;
-
-	switch (usage) {
-	case KG_USAGE_SIGN:
-		ms_usage = 15;
-		break;
-	case KG_USAGE_SEAL:
-		ms_usage = 13;
-		break;
-	default:
-		return -EINVAL;
-	}
-	salt[0] = (ms_usage >> 0) & 0xff;
-	salt[1] = (ms_usage >> 8) & 0xff;
-	salt[2] = (ms_usage >> 16) & 0xff;
-	salt[3] = (ms_usage >> 24) & 0xff;
-
-	return 0;
-}
-
-static u32
-make_checksum_hmac_md5(struct krb5_ctx *kctx, char *header, int hdrlen,
-		       struct xdr_buf *body, int body_offset, u8 *cksumkey,
-		       unsigned int usage, struct xdr_netobj *cksumout)
-{
-	struct scatterlist              sg[1];
-	int err = -1;
-	u8 *checksumdata;
-	u8 *rc4salt;
-	struct crypto_ahash *md5;
-	struct crypto_ahash *hmac_md5;
-	struct ahash_request *req;
-
-	if (cksumkey == NULL)
-		return GSS_S_FAILURE;
-
-	if (cksumout->len < kctx->gk5e->cksumlength) {
-		dprintk("%s: checksum buffer length, %u, too small for %s\n",
-			__func__, cksumout->len, kctx->gk5e->name);
-		return GSS_S_FAILURE;
-	}
-
-	rc4salt = kmalloc_array(4, sizeof(*rc4salt), GFP_NOFS);
-	if (!rc4salt)
-		return GSS_S_FAILURE;
-
-	if (arcfour_hmac_md5_usage_to_salt(usage, rc4salt)) {
-		dprintk("%s: invalid usage value %u\n", __func__, usage);
-		goto out_free_rc4salt;
-	}
-
-	checksumdata = kmalloc(GSS_KRB5_MAX_CKSUM_LEN, GFP_NOFS);
-	if (!checksumdata)
-		goto out_free_rc4salt;
-
-	md5 = crypto_alloc_ahash("md5", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(md5))
-		goto out_free_cksum;
-
-	hmac_md5 = crypto_alloc_ahash(kctx->gk5e->cksum_name, 0,
-				      CRYPTO_ALG_ASYNC);
-	if (IS_ERR(hmac_md5))
-		goto out_free_md5;
-
-	req = ahash_request_alloc(md5, GFP_NOFS);
-	if (!req)
-		goto out_free_hmac_md5;
-
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
-
-	err = crypto_ahash_init(req);
-	if (err)
-		goto out;
-	sg_init_one(sg, rc4salt, 4);
-	ahash_request_set_crypt(req, sg, NULL, 4);
-	err = crypto_ahash_update(req);
-	if (err)
-		goto out;
-
-	sg_init_one(sg, header, hdrlen);
-	ahash_request_set_crypt(req, sg, NULL, hdrlen);
-	err = crypto_ahash_update(req);
-	if (err)
-		goto out;
-	err = xdr_process_buf(body, body_offset, body->len - body_offset,
-			      checksummer, req);
-	if (err)
-		goto out;
-	ahash_request_set_crypt(req, NULL, checksumdata, 0);
-	err = crypto_ahash_final(req);
-	if (err)
-		goto out;
-
-	ahash_request_free(req);
-	req = ahash_request_alloc(hmac_md5, GFP_NOFS);
-	if (!req)
-		goto out_free_hmac_md5;
-
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
-
-	err = crypto_ahash_setkey(hmac_md5, cksumkey, kctx->gk5e->keylength);
-	if (err)
-		goto out;
-
-	sg_init_one(sg, checksumdata, crypto_ahash_digestsize(md5));
-	ahash_request_set_crypt(req, sg, checksumdata,
-				crypto_ahash_digestsize(md5));
-	err = crypto_ahash_digest(req);
-	if (err)
-		goto out;
-
-	memcpy(cksumout->data, checksumdata, kctx->gk5e->cksumlength);
-	cksumout->len = kctx->gk5e->cksumlength;
-out:
-	ahash_request_free(req);
-out_free_hmac_md5:
-	crypto_free_ahash(hmac_md5);
-out_free_md5:
-	crypto_free_ahash(md5);
-out_free_cksum:
-	kfree(checksumdata);
-out_free_rc4salt:
-	kfree(rc4salt);
-	return err ? GSS_S_FAILURE : 0;
-}
-
 /*
  * checksum the plaintext data and hdrlen bytes of the token header
  * The checksum is performed over the first 8 bytes of the
@@ -284,11 +155,6 @@ make_checksum(struct krb5_ctx *kctx, char *header, int hdrlen,
 	u8 *checksumdata;
 	unsigned int checksumlen;
 
-	if (kctx->gk5e->ctype == CKSUMTYPE_HMAC_MD5_ARCFOUR)
-		return make_checksum_hmac_md5(kctx, header, hdrlen,
-					      body, body_offset,
-					      cksumkey, usage, cksumout);
-
 	if (cksumout->len < kctx->gk5e->cksumlength) {
 		dprintk("%s: checksum buffer length, %u, too small for %s\n",
 			__func__, cksumout->len, kctx->gk5e->name);
@@ -942,145 +808,3 @@ gss_krb5_aes_decrypt(struct krb5_ctx *kctx, u32 offset, u32 len,
 		ret = GSS_S_FAILURE;
 	return ret;
 }
-
-/*
- * Compute Kseq given the initial session key and the checksum.
- * Set the key of the given cipher.
- */
-int
-krb5_rc4_setup_seq_key(struct krb5_ctx *kctx,
-		       struct crypto_sync_skcipher *cipher,
-		       unsigned char *cksum)
-{
-	struct crypto_shash *hmac;
-	struct shash_desc *desc;
-	u8 Kseq[GSS_KRB5_MAX_KEYLEN];
-	u32 zeroconstant = 0;
-	int err;
-
-	dprintk("%s: entered\n", __func__);
-
-	hmac = crypto_alloc_shash(kctx->gk5e->cksum_name, 0, 0);
-	if (IS_ERR(hmac)) {
-		dprintk("%s: error %ld, allocating hash '%s'\n",
-			__func__, PTR_ERR(hmac), kctx->gk5e->cksum_name);
-		return PTR_ERR(hmac);
-	}
-
-	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(hmac),
-		       GFP_NOFS);
-	if (!desc) {
-		dprintk("%s: failed to allocate shash descriptor for '%s'\n",
-			__func__, kctx->gk5e->cksum_name);
-		crypto_free_shash(hmac);
-		return -ENOMEM;
-	}
-
-	desc->tfm = hmac;
-
-	/* Compute intermediate Kseq from session key */
-	err = crypto_shash_setkey(hmac, kctx->Ksess, kctx->gk5e->keylength);
-	if (err)
-		goto out_err;
-
-	err = crypto_shash_digest(desc, (u8 *)&zeroconstant, 4, Kseq);
-	if (err)
-		goto out_err;
-
-	/* Compute final Kseq from the checksum and intermediate Kseq */
-	err = crypto_shash_setkey(hmac, Kseq, kctx->gk5e->keylength);
-	if (err)
-		goto out_err;
-
-	err = crypto_shash_digest(desc, cksum, 8, Kseq);
-	if (err)
-		goto out_err;
-
-	err = crypto_sync_skcipher_setkey(cipher, Kseq, kctx->gk5e->keylength);
-	if (err)
-		goto out_err;
-
-	err = 0;
-
-out_err:
-	kzfree(desc);
-	crypto_free_shash(hmac);
-	dprintk("%s: returning %d\n", __func__, err);
-	return err;
-}
-
-/*
- * Compute Kcrypt given the initial session key and the plaintext seqnum.
- * Set the key of cipher kctx->enc.
- */
-int
-krb5_rc4_setup_enc_key(struct krb5_ctx *kctx,
-		       struct crypto_sync_skcipher *cipher,
-		       s32 seqnum)
-{
-	struct crypto_shash *hmac;
-	struct shash_desc *desc;
-	u8 Kcrypt[GSS_KRB5_MAX_KEYLEN];
-	u8 zeroconstant[4] = {0};
-	u8 seqnumarray[4];
-	int err, i;
-
-	dprintk("%s: entered, seqnum %u\n", __func__, seqnum);
-
-	hmac = crypto_alloc_shash(kctx->gk5e->cksum_name, 0, 0);
-	if (IS_ERR(hmac)) {
-		dprintk("%s: error %ld, allocating hash '%s'\n",
-			__func__, PTR_ERR(hmac), kctx->gk5e->cksum_name);
-		return PTR_ERR(hmac);
-	}
-
-	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(hmac),
-		       GFP_NOFS);
-	if (!desc) {
-		dprintk("%s: failed to allocate shash descriptor for '%s'\n",
-			__func__, kctx->gk5e->cksum_name);
-		crypto_free_shash(hmac);
-		return -ENOMEM;
-	}
-
-	desc->tfm = hmac;
-
-	/* Compute intermediate Kcrypt from session key */
-	for (i = 0; i < kctx->gk5e->keylength; i++)
-		Kcrypt[i] = kctx->Ksess[i] ^ 0xf0;
-
-	err = crypto_shash_setkey(hmac, Kcrypt, kctx->gk5e->keylength);
-	if (err)
-		goto out_err;
-
-	err = crypto_shash_digest(desc, zeroconstant, 4, Kcrypt);
-	if (err)
-		goto out_err;
-
-	/* Compute final Kcrypt from the seqnum and intermediate Kcrypt */
-	err = crypto_shash_setkey(hmac, Kcrypt, kctx->gk5e->keylength);
-	if (err)
-		goto out_err;
-
-	seqnumarray[0] = (unsigned char) ((seqnum >> 24) & 0xff);
-	seqnumarray[1] = (unsigned char) ((seqnum >> 16) & 0xff);
-	seqnumarray[2] = (unsigned char) ((seqnum >> 8) & 0xff);
-	seqnumarray[3] = (unsigned char) ((seqnum >> 0) & 0xff);
-
-	err = crypto_shash_digest(desc, seqnumarray, 4, Kcrypt);
-	if (err)
-		goto out_err;
-
-	err = crypto_sync_skcipher_setkey(cipher, Kcrypt,
-					  kctx->gk5e->keylength);
-	if (err)
-		goto out_err;
-
-	err = 0;
-
-out_err:
-	kzfree(desc);
-	crypto_free_shash(hmac);
-	dprintk("%s: returning %d\n", __func__, err);
-	return err;
-}
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 75b3c2e9e8f8..ae9acf3a7389 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -51,27 +51,6 @@ static const struct gss_krb5_enctype supported_gss_krb5_enctypes[] = {
 	  .keyed_cksum = 0,
 	},
 #endif	/* CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES */
-	/*
-	 * RC4-HMAC
-	 */
-	{
-	  .etype = ENCTYPE_ARCFOUR_HMAC,
-	  .ctype = CKSUMTYPE_HMAC_MD5_ARCFOUR,
-	  .name = "rc4-hmac",
-	  .encrypt_name = "ecb(arc4)",
-	  .cksum_name = "hmac(md5)",
-	  .encrypt = krb5_encrypt,
-	  .decrypt = krb5_decrypt,
-	  .mk_key = NULL,
-	  .signalg = SGN_ALG_HMAC_MD5,
-	  .sealalg = SEAL_ALG_MICROSOFT_RC4,
-	  .keybytes = 16,
-	  .keylength = 16,
-	  .blocksize = 1,
-	  .conflen = 8,
-	  .cksumlength = 8,
-	  .keyed_cksum = 1,
-	},
 	/*
 	 * 3DES
 	 */
@@ -401,78 +380,6 @@ context_derive_keys_des3(struct krb5_ctx *ctx, gfp_t gfp_mask)
 	return -EINVAL;
 }
 
-/*
- * Note that RC4 depends on deriving keys using the sequence
- * number or the checksum of a token.  Therefore, the final keys
- * cannot be calculated until the token is being constructed!
- */
-static int
-context_derive_keys_rc4(struct krb5_ctx *ctx)
-{
-	struct crypto_shash *hmac;
-	char sigkeyconstant[] = "signaturekey";
-	int slen = strlen(sigkeyconstant) + 1;	/* include null terminator */
-	struct shash_desc *desc;
-	int err;
-
-	dprintk("RPC:       %s: entered\n", __func__);
-	/*
-	 * derive cksum (aka Ksign) key
-	 */
-	hmac = crypto_alloc_shash(ctx->gk5e->cksum_name, 0, 0);
-	if (IS_ERR(hmac)) {
-		dprintk("%s: error %ld allocating hash '%s'\n",
-			__func__, PTR_ERR(hmac), ctx->gk5e->cksum_name);
-		err = PTR_ERR(hmac);
-		goto out_err;
-	}
-
-	err = crypto_shash_setkey(hmac, ctx->Ksess, ctx->gk5e->keylength);
-	if (err)
-		goto out_err_free_hmac;
-
-
-	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(hmac), GFP_NOFS);
-	if (!desc) {
-		dprintk("%s: failed to allocate hash descriptor for '%s'\n",
-			__func__, ctx->gk5e->cksum_name);
-		err = -ENOMEM;
-		goto out_err_free_hmac;
-	}
-
-	desc->tfm = hmac;
-
-	err = crypto_shash_digest(desc, sigkeyconstant, slen, ctx->cksum);
-	kzfree(desc);
-	if (err)
-		goto out_err_free_hmac;
-	/*
-	 * allocate hash, and skciphers for data and seqnum encryption
-	 */
-	ctx->enc = crypto_alloc_sync_skcipher(ctx->gk5e->encrypt_name, 0, 0);
-	if (IS_ERR(ctx->enc)) {
-		err = PTR_ERR(ctx->enc);
-		goto out_err_free_hmac;
-	}
-
-	ctx->seq = crypto_alloc_sync_skcipher(ctx->gk5e->encrypt_name, 0, 0);
-	if (IS_ERR(ctx->seq)) {
-		crypto_free_sync_skcipher(ctx->enc);
-		err = PTR_ERR(ctx->seq);
-		goto out_err_free_hmac;
-	}
-
-	dprintk("RPC:       %s: returning success\n", __func__);
-
-	err = 0;
-
-out_err_free_hmac:
-	crypto_free_shash(hmac);
-out_err:
-	dprintk("RPC:       %s: returning %d\n", __func__, err);
-	return err;
-}
-
 static int
 context_derive_keys_new(struct krb5_ctx *ctx, gfp_t gfp_mask)
 {
@@ -649,8 +556,6 @@ gss_import_v2_context(const void *p, const void *end, struct krb5_ctx *ctx,
 	switch (ctx->enctype) {
 	case ENCTYPE_DES3_CBC_RAW:
 		return context_derive_keys_des3(ctx, gfp_mask);
-	case ENCTYPE_ARCFOUR_HMAC:
-		return context_derive_keys_rc4(ctx);
 	case ENCTYPE_AES128_CTS_HMAC_SHA1_96:
 	case ENCTYPE_AES256_CTS_HMAC_SHA1_96:
 		return context_derive_keys_new(ctx, gfp_mask);
diff --git a/net/sunrpc/auth_gss/gss_krb5_seal.c b/net/sunrpc/auth_gss/gss_krb5_seal.c
index f1d280accf43..33061417ec97 100644
--- a/net/sunrpc/auth_gss/gss_krb5_seal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_seal.c
@@ -214,7 +214,6 @@ gss_get_mic_kerberos(struct gss_ctx *gss_ctx, struct xdr_buf *text,
 		BUG();
 	case ENCTYPE_DES_CBC_RAW:
 	case ENCTYPE_DES3_CBC_RAW:
-	case ENCTYPE_ARCFOUR_HMAC:
 		return gss_get_mic_v1(ctx, text, token);
 	case ENCTYPE_AES128_CTS_HMAC_SHA1_96:
 	case ENCTYPE_AES256_CTS_HMAC_SHA1_96:
diff --git a/net/sunrpc/auth_gss/gss_krb5_seqnum.c b/net/sunrpc/auth_gss/gss_krb5_seqnum.c
index 507105127095..fb117817ff5d 100644
--- a/net/sunrpc/auth_gss/gss_krb5_seqnum.c
+++ b/net/sunrpc/auth_gss/gss_krb5_seqnum.c
@@ -39,42 +39,6 @@
 # define RPCDBG_FACILITY        RPCDBG_AUTH
 #endif
 
-static s32
-krb5_make_rc4_seq_num(struct krb5_ctx *kctx, int direction, s32 seqnum,
-		      unsigned char *cksum, unsigned char *buf)
-{
-	struct crypto_sync_skcipher *cipher;
-	unsigned char *plain;
-	s32 code;
-
-	dprintk("RPC:       %s:\n", __func__);
-	cipher = crypto_alloc_sync_skcipher(kctx->gk5e->encrypt_name, 0, 0);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	plain = kmalloc(8, GFP_NOFS);
-	if (!plain)
-		return -ENOMEM;
-
-	plain[0] = (unsigned char) ((seqnum >> 24) & 0xff);
-	plain[1] = (unsigned char) ((seqnum >> 16) & 0xff);
-	plain[2] = (unsigned char) ((seqnum >> 8) & 0xff);
-	plain[3] = (unsigned char) ((seqnum >> 0) & 0xff);
-	plain[4] = direction;
-	plain[5] = direction;
-	plain[6] = direction;
-	plain[7] = direction;
-
-	code = krb5_rc4_setup_seq_key(kctx, cipher, cksum);
-	if (code)
-		goto out;
-
-	code = krb5_encrypt(cipher, cksum, plain, buf, 8);
-out:
-	kfree(plain);
-	crypto_free_sync_skcipher(cipher);
-	return code;
-}
 s32
 krb5_make_seq_num(struct krb5_ctx *kctx,
 		struct crypto_sync_skcipher *key,
@@ -85,10 +49,6 @@ krb5_make_seq_num(struct krb5_ctx *kctx,
 	unsigned char *plain;
 	s32 code;
 
-	if (kctx->enctype == ENCTYPE_ARCFOUR_HMAC)
-		return krb5_make_rc4_seq_num(kctx, direction, seqnum,
-					     cksum, buf);
-
 	plain = kmalloc(8, GFP_NOFS);
 	if (!plain)
 		return -ENOMEM;
@@ -108,50 +68,6 @@ krb5_make_seq_num(struct krb5_ctx *kctx,
 	return code;
 }
 
-static s32
-krb5_get_rc4_seq_num(struct krb5_ctx *kctx, unsigned char *cksum,
-		     unsigned char *buf, int *direction, s32 *seqnum)
-{
-	struct crypto_sync_skcipher *cipher;
-	unsigned char *plain;
-	s32 code;
-
-	dprintk("RPC:       %s:\n", __func__);
-	cipher = crypto_alloc_sync_skcipher(kctx->gk5e->encrypt_name, 0, 0);
-	if (IS_ERR(cipher))
-		return PTR_ERR(cipher);
-
-	code = krb5_rc4_setup_seq_key(kctx, cipher, cksum);
-	if (code)
-		goto out;
-
-	plain = kmalloc(8, GFP_NOFS);
-	if (!plain) {
-		code = -ENOMEM;
-		goto out;
-	}
-
-	code = krb5_decrypt(cipher, cksum, buf, plain, 8);
-	if (code)
-		goto out_plain;
-
-	if ((plain[4] != plain[5]) || (plain[4] != plain[6])
-				   || (plain[4] != plain[7])) {
-		code = (s32)KG_BAD_SEQ;
-		goto out_plain;
-	}
-
-	*direction = plain[4];
-
-	*seqnum = ((plain[0] << 24) | (plain[1] << 16) |
-					(plain[2] << 8) | (plain[3]));
-out_plain:
-	kfree(plain);
-out:
-	crypto_free_sync_skcipher(cipher);
-	return code;
-}
-
 s32
 krb5_get_seq_num(struct krb5_ctx *kctx,
 	       unsigned char *cksum,
@@ -164,9 +80,6 @@ krb5_get_seq_num(struct krb5_ctx *kctx,
 
 	dprintk("RPC:       krb5_get_seq_num:\n");
 
-	if (kctx->enctype == ENCTYPE_ARCFOUR_HMAC)
-		return krb5_get_rc4_seq_num(kctx, cksum, buf,
-					    direction, seqnum);
 	plain = kmalloc(8, GFP_NOFS);
 	if (!plain)
 		return -ENOMEM;
diff --git a/net/sunrpc/auth_gss/gss_krb5_unseal.c b/net/sunrpc/auth_gss/gss_krb5_unseal.c
index aaab91cf24c8..ba04e3ec970a 100644
--- a/net/sunrpc/auth_gss/gss_krb5_unseal.c
+++ b/net/sunrpc/auth_gss/gss_krb5_unseal.c
@@ -218,7 +218,6 @@ gss_verify_mic_kerberos(struct gss_ctx *gss_ctx,
 		BUG();
 	case ENCTYPE_DES_CBC_RAW:
 	case ENCTYPE_DES3_CBC_RAW:
-	case ENCTYPE_ARCFOUR_HMAC:
 		return gss_verify_mic_v1(ctx, message_buffer, read_token);
 	case ENCTYPE_AES128_CTS_HMAC_SHA1_96:
 	case ENCTYPE_AES256_CTS_HMAC_SHA1_96:
diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c b/net/sunrpc/auth_gss/gss_krb5_wrap.c
index cf0fd170ac18..a412a734ee17 100644
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -236,26 +236,9 @@ gss_wrap_kerberos_v1(struct krb5_ctx *kctx, int offset,
 			       seq_send, ptr + GSS_KRB5_TOK_HDR_LEN, ptr + 8)))
 		return GSS_S_FAILURE;
 
-	if (kctx->enctype == ENCTYPE_ARCFOUR_HMAC) {
-		struct crypto_sync_skcipher *cipher;
-		int err;
-		cipher = crypto_alloc_sync_skcipher(kctx->gk5e->encrypt_name,
-						    0, 0);
-		if (IS_ERR(cipher))
-			return GSS_S_FAILURE;
-
-		krb5_rc4_setup_enc_key(kctx, cipher, seq_send);
-
-		err = gss_encrypt_xdr_buf(cipher, buf,
-					  offset + headlen - conflen, pages);
-		crypto_free_sync_skcipher(cipher);
-		if (err)
-			return GSS_S_FAILURE;
-	} else {
-		if (gss_encrypt_xdr_buf(kctx->enc, buf,
-					offset + headlen - conflen, pages))
-			return GSS_S_FAILURE;
-	}
+	if (gss_encrypt_xdr_buf(kctx->enc, buf,
+				offset + headlen - conflen, pages))
+		return GSS_S_FAILURE;
 
 	return (kctx->endtime < now) ? GSS_S_CONTEXT_EXPIRED : GSS_S_COMPLETE;
 }
@@ -316,37 +299,9 @@ gss_unwrap_kerberos_v1(struct krb5_ctx *kctx, int offset, int len,
 	crypt_offset = ptr + (GSS_KRB5_TOK_HDR_LEN + kctx->gk5e->cksumlength) -
 					(unsigned char *)buf->head[0].iov_base;
 
-	/*
-	 * Need plaintext seqnum to derive encryption key for arcfour-hmac
-	 */
-	if (krb5_get_seq_num(kctx, ptr + GSS_KRB5_TOK_HDR_LEN,
-			     ptr + 8, &direction, &seqnum))
-		return GSS_S_BAD_SIG;
-
-	if ((kctx->initiate && direction != 0xff) ||
-	    (!kctx->initiate && direction != 0))
-		return GSS_S_BAD_SIG;
-
 	buf->len = len;
-	if (kctx->enctype == ENCTYPE_ARCFOUR_HMAC) {
-		struct crypto_sync_skcipher *cipher;
-		int err;
-
-		cipher = crypto_alloc_sync_skcipher(kctx->gk5e->encrypt_name,
-						    0, 0);
-		if (IS_ERR(cipher))
-			return GSS_S_FAILURE;
-
-		krb5_rc4_setup_enc_key(kctx, cipher, seqnum);
-
-		err = gss_decrypt_xdr_buf(cipher, buf, crypt_offset);
-		crypto_free_sync_skcipher(cipher);
-		if (err)
-			return GSS_S_DEFECTIVE_TOKEN;
-	} else {
-		if (gss_decrypt_xdr_buf(kctx->enc, buf, crypt_offset))
-			return GSS_S_DEFECTIVE_TOKEN;
-	}
+	if (gss_decrypt_xdr_buf(kctx->enc, buf, crypt_offset))
+		return GSS_S_DEFECTIVE_TOKEN;
 
 	if (kctx->gk5e->keyed_cksum)
 		cksumkey = kctx->cksum;
@@ -370,6 +325,14 @@ gss_unwrap_kerberos_v1(struct krb5_ctx *kctx, int offset, int len,
 
 	/* do sequencing checks */
 
+	if (krb5_get_seq_num(kctx, ptr + GSS_KRB5_TOK_HDR_LEN,
+			     ptr + 8, &direction, &seqnum))
+		return GSS_S_BAD_SIG;
+
+	if ((kctx->initiate && direction != 0xff) ||
+	    (!kctx->initiate && direction != 0))
+		return GSS_S_BAD_SIG;
+
 	/* Copy the data back to the right position.  XXX: Would probably be
 	 * better to copy and encrypt at the same time. */
 
@@ -605,7 +568,6 @@ gss_wrap_kerberos(struct gss_ctx *gctx, int offset,
 		BUG();
 	case ENCTYPE_DES_CBC_RAW:
 	case ENCTYPE_DES3_CBC_RAW:
-	case ENCTYPE_ARCFOUR_HMAC:
 		return gss_wrap_kerberos_v1(kctx, offset, buf, pages);
 	case ENCTYPE_AES128_CTS_HMAC_SHA1_96:
 	case ENCTYPE_AES256_CTS_HMAC_SHA1_96:
@@ -624,7 +586,6 @@ gss_unwrap_kerberos(struct gss_ctx *gctx, int offset,
 		BUG();
 	case ENCTYPE_DES_CBC_RAW:
 	case ENCTYPE_DES3_CBC_RAW:
-	case ENCTYPE_ARCFOUR_HMAC:
 		return gss_unwrap_kerberos_v1(kctx, offset, len, buf,
 					      &gctx->slack, &gctx->align);
 	case ENCTYPE_AES128_CTS_HMAC_SHA1_96:
-- 
2.17.1

