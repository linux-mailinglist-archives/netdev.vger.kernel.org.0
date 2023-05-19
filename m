Return-Path: <netdev+bounces-3847-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C88AE7091B3
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:29:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78D68281BC8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A650D568B;
	Fri, 19 May 2023 08:29:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CEE5686
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:29:13 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F7EE5F;
	Fri, 19 May 2023 01:29:11 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1pzvTX-00AnME-24; Fri, 19 May 2023 16:28:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 May 2023 16:28:35 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Fri, 19 May 2023 16:28:35 +0800
Subject: [PATCH 2/3] crypto: cipher - Add crypto_clone_cipher
References: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
To: Dmitry Safonov <dima@arista.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, Andy Lutomirski <luto@amacapital.net>, Ard Biesheuvel <ardb@kernel.org>, Bob Gilligan <gilligan@arista.com>, Dan Carpenter <error27@gmail.com>, David Laight <David.Laight@aculab.com>, Dmitry Safonov <0x7f454c46@gmail.com>, Eric Biggers <ebiggers@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Francesco Ruggeri <fruggeri05@gmail.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ivan Delalande <colona@arista.com>, Leonard Crestez <cdleonard@gmail.com>, Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
Message-Id: <E1pzvTX-00AnME-24@formenos.hmeau.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Allow simple ciphers to be cloned, if they don't have a cra_init
function.  This basically rules out those ciphers that require a
fallback.

In future simple ciphers will be eliminated, and replaced with a
linear skcipher interface.  When that happens this restriction will
disappear.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cipher.c                  |   23 +++++++++++++++++++++++
 include/crypto/internal/cipher.h |    2 ++
 2 files changed, 25 insertions(+)

diff --git a/crypto/cipher.c b/crypto/cipher.c
index b47141ed4a9f..d39ef5f72ab8 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -90,3 +90,26 @@ void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 	cipher_crypt_one(tfm, dst, src, false);
 }
 EXPORT_SYMBOL_NS_GPL(crypto_cipher_decrypt_one, CRYPTO_INTERNAL);
+
+struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher)
+{
+	struct crypto_tfm *tfm = crypto_cipher_tfm(cipher);
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct crypto_cipher *ncipher;
+	struct crypto_tfm *ntfm;
+
+	if (alg->cra_init)
+		return ERR_PTR(-ENOSYS);
+
+	ntfm = __crypto_alloc_tfm(alg, CRYPTO_ALG_TYPE_CIPHER,
+				  CRYPTO_ALG_TYPE_MASK);
+	if (IS_ERR(ntfm))
+		return ERR_CAST(ntfm);
+
+	ntfm->crt_flags = tfm->crt_flags;
+
+	ncipher = __crypto_cipher_cast(ntfm);
+
+	return ncipher;
+}
+EXPORT_SYMBOL_GPL(crypto_clone_cipher);
diff --git a/include/crypto/internal/cipher.h b/include/crypto/internal/cipher.h
index a9174ba90250..5030f6d2df31 100644
--- a/include/crypto/internal/cipher.h
+++ b/include/crypto/internal/cipher.h
@@ -176,6 +176,8 @@ void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
 void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 			       u8 *dst, const u8 *src);
 
+struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher);
+
 struct crypto_cipher_spawn {
 	struct crypto_spawn base;
 };

