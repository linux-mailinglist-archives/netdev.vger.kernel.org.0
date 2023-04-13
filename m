Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17216E06E8
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjDMGZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjDMGZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:25:03 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7B761A1;
        Wed, 12 Apr 2023 23:24:56 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pmqNX-00FNVU-KA; Thu, 13 Apr 2023 14:24:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Apr 2023 14:24:19 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 13 Apr 2023 14:24:19 +0800
Subject: [PATCH 3/6] crypto: hash - Add crypto_clone_ahash/shash
References: <ZDefxOq6Ax0JeTRH@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Message-Id: <E1pmqNX-00FNVU-KA@formenos.hmeau.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the helpers crypto_clone_ahash and crypto_clone_shash.
They are the hash-specific counterparts of crypto_clone_tfm.

This allows code paths that cannot otherwise allocate a hash tfm
object to do so.  Once a new tfm has been obtained its key could
then be changed without impacting other users.

Note that only algorithms that implement clone_tfm can be cloned.
However, all keyless hashes can be cloned by simply reusing the
tfm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |   51 ++++++++++++++++++++++++++++++++++++++++
 crypto/hash.h                  |    4 +++
 crypto/shash.c                 |   52 +++++++++++++++++++++++++++++++++++++++++
 include/crypto/hash.h          |    8 ++++++
 include/crypto/internal/hash.h |    2 -
 5 files changed, 115 insertions(+), 2 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 2d858d7fd1bb..b8a607928e72 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -543,6 +543,57 @@ int crypto_has_ahash(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_ahash);
 
+struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
+{
+	struct hash_alg_common *halg = crypto_hash_alg_common(hash);
+	struct crypto_tfm *tfm = crypto_ahash_tfm(hash);
+	struct crypto_ahash *nhash;
+	struct ahash_alg *alg;
+	int err;
+
+	if (!crypto_hash_alg_has_setkey(halg)) {
+		tfm = crypto_tfm_get(tfm);
+		if (IS_ERR(tfm))
+			return ERR_CAST(tfm);
+
+		return hash;
+	}
+
+	nhash = crypto_clone_tfm(&crypto_ahash_type, tfm);
+
+	if (IS_ERR(nhash))
+		return nhash;
+
+	nhash->init = hash->init;
+	nhash->update = hash->update;
+	nhash->final = hash->final;
+	nhash->finup = hash->finup;
+	nhash->digest = hash->digest;
+	nhash->export = hash->export;
+	nhash->import = hash->import;
+	nhash->setkey = hash->setkey;
+	nhash->reqsize = hash->reqsize;
+
+	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
+		return crypto_clone_shash_ops_async(nhash, hash);
+
+	err = -ENOSYS;
+	alg = crypto_ahash_alg(hash);
+	if (!alg->clone_tfm)
+		goto out_free_nhash;
+
+	err = alg->clone_tfm(nhash, hash);
+	if (err)
+		goto out_free_nhash;
+
+	return nhash;
+
+out_free_nhash:
+	crypto_free_ahash(nhash);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(crypto_clone_ahash);
+
 static int ahash_prepare_alg(struct ahash_alg *alg)
 {
 	struct crypto_alg *base = &alg->halg.base;
diff --git a/crypto/hash.h b/crypto/hash.h
index 57b28a986d69..7e6c1a948692 100644
--- a/crypto/hash.h
+++ b/crypto/hash.h
@@ -31,6 +31,10 @@ static inline int crypto_hash_report_stat(struct sk_buff *skb,
 	return nla_put(skb, CRYPTOCFGA_STAT_HASH, sizeof(rhash), &rhash);
 }
 
+int crypto_init_shash_ops_async(struct crypto_tfm *tfm);
+struct crypto_ahash *crypto_clone_shash_ops_async(struct crypto_ahash *nhash,
+						  struct crypto_ahash *hash);
+
 int hash_prepare_alg(struct hash_alg_common *alg);
 
 #endif	/* _LOCAL_CRYPTO_HASH_H */
diff --git a/crypto/shash.c b/crypto/shash.c
index 4cefa614dbbd..5845b7d59b2f 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -445,6 +445,24 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	return 0;
 }
 
+struct crypto_ahash *crypto_clone_shash_ops_async(struct crypto_ahash *nhash,
+						  struct crypto_ahash *hash)
+{
+	struct crypto_shash **nctx = crypto_ahash_ctx(nhash);
+	struct crypto_shash **ctx = crypto_ahash_ctx(hash);
+	struct crypto_shash *shash;
+
+	shash = crypto_clone_shash(*ctx);
+	if (IS_ERR(shash)) {
+		crypto_free_ahash(nhash);
+		return ERR_CAST(shash);
+	}
+
+	*nctx = shash;
+
+	return nhash;
+}
+
 static void crypto_shash_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_shash *hash = __crypto_shash_cast(tfm);
@@ -564,6 +582,40 @@ int crypto_has_shash(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_shash);
 
+struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
+{
+	struct crypto_tfm *tfm = crypto_shash_tfm(hash);
+	struct shash_alg *alg = crypto_shash_alg(hash);
+	struct crypto_shash *nhash;
+	int err;
+
+	if (!crypto_shash_alg_has_setkey(alg)) {
+		tfm = crypto_tfm_get(tfm);
+		if (IS_ERR(tfm))
+			return ERR_CAST(tfm);
+
+		return hash;
+	}
+
+	if (!alg->clone_tfm)
+		return ERR_PTR(-ENOSYS);
+
+	nhash = crypto_clone_tfm(&crypto_shash_type, tfm);
+	if (IS_ERR(nhash))
+		return nhash;
+
+	nhash->descsize = hash->descsize;
+
+	err = alg->clone_tfm(nhash, hash);
+	if (err) {
+		crypto_free_shash(nhash);
+		return ERR_PTR(err);
+	}
+
+	return nhash;
+}
+EXPORT_SYMBOL_GPL(crypto_clone_shash);
+
 int hash_prepare_alg(struct hash_alg_common *alg)
 {
 	struct crypto_istat_hash *istat = hash_get_stat(alg);
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 3a04e601ad6a..e69542d86a2b 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -152,6 +152,7 @@ struct ahash_request {
  * @exit_tfm: Deinitialize the cryptographic transformation object.
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
+ * @clone_tfm: Copy transform into new object, may allocate memory.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
@@ -166,6 +167,7 @@ struct ahash_alg {
 		      unsigned int keylen);
 	int (*init_tfm)(struct crypto_ahash *tfm);
 	void (*exit_tfm)(struct crypto_ahash *tfm);
+	int (*clone_tfm)(struct crypto_ahash *dst, struct crypto_ahash *src);
 
 	struct hash_alg_common halg;
 };
@@ -209,6 +211,7 @@ struct shash_desc {
  * @exit_tfm: Deinitialize the cryptographic transformation object.
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
+ * @clone_tfm: Copy transform into new object, may allocate memory.
  * @digestsize: see struct ahash_alg
  * @statesize: see struct ahash_alg
  * @descsize: Size of the operational state for the message digest. This state
@@ -234,6 +237,7 @@ struct shash_alg {
 		      unsigned int keylen);
 	int (*init_tfm)(struct crypto_shash *tfm);
 	void (*exit_tfm)(struct crypto_shash *tfm);
+	int (*clone_tfm)(struct crypto_shash *dst, struct crypto_shash *src);
 
 	unsigned int descsize;
 
@@ -297,6 +301,8 @@ static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
 struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
 					u32 mask);
 
+struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *tfm);
+
 static inline struct crypto_tfm *crypto_ahash_tfm(struct crypto_ahash *tfm)
 {
 	return &tfm->base;
@@ -761,6 +767,8 @@ static inline void ahash_request_set_crypt(struct ahash_request *req,
 struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
 					u32 mask);
 
+struct crypto_shash *crypto_clone_shash(struct crypto_shash *tfm);
+
 int crypto_has_shash(const char *alg_name, u32 type, u32 mask);
 
 static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 0b259dbb97af..37edf3f4e8af 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -133,8 +133,6 @@ int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
 int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc);
 int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc);
 
-int crypto_init_shash_ops_async(struct crypto_tfm *tfm);
-
 static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_ctx(crypto_ahash_tfm(tfm));
