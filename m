Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB96E06DF
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjDMGYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjDMGYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:24:52 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B466583;
        Wed, 12 Apr 2023 23:24:51 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pmqNV-00FNVI-Fs; Thu, 13 Apr 2023 14:24:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Apr 2023 14:24:17 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 13 Apr 2023 14:24:17 +0800
Subject: [PATCH 2/6] crypto: api - Add crypto_clone_tfm
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
Message-Id: <E1pmqNV-00FNVI-Fs@formenos.hmeau.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the helper crypto_clone_tfm.  The purpose is to
allocate a tfm object with GFP_ATOMIC.  As we cannot sleep, the
object has to be cloned from an existing tfm object.

This allows code paths that cannot otherwise allocate a crypto_tfm
object to do so.  Once a new tfm has been obtained its key could
then be changed without impacting other users.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/api.c      |   59 +++++++++++++++++++++++++++++++++++++++++++++---------
 crypto/internal.h |    2 +
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index f509d73fa682..d375e8cd770d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -488,28 +488,44 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_base);
 
-void *crypto_create_tfm_node(struct crypto_alg *alg,
-			const struct crypto_type *frontend,
-			int node)
+static void *crypto_alloc_tfmmem(struct crypto_alg *alg,
+				 const struct crypto_type *frontend, int node,
+				 gfp_t gfp)
 {
-	char *mem;
-	struct crypto_tfm *tfm = NULL;
+	struct crypto_tfm *tfm;
 	unsigned int tfmsize;
 	unsigned int total;
-	int err = -ENOMEM;
+	char *mem;
 
 	tfmsize = frontend->tfmsize;
 	total = tfmsize + sizeof(*tfm) + frontend->extsize(alg);
 
-	mem = kzalloc_node(total, GFP_KERNEL, node);
+	mem = kzalloc_node(total, gfp, node);
 	if (mem == NULL)
-		goto out_err;
+		return ERR_PTR(-ENOMEM);
 
 	tfm = (struct crypto_tfm *)(mem + tfmsize);
 	tfm->__crt_alg = alg;
 	tfm->node = node;
 	refcount_set(&tfm->refcnt, 1);
 
+	return mem;
+}
+
+void *crypto_create_tfm_node(struct crypto_alg *alg,
+			     const struct crypto_type *frontend,
+			     int node)
+{
+	struct crypto_tfm *tfm;
+	char *mem;
+	int err;
+
+	mem = crypto_alloc_tfmmem(alg, frontend, node, GFP_KERNEL);
+	if (IS_ERR(mem))
+		goto out;
+
+	tfm = (struct crypto_tfm *)(mem + frontend->tfmsize);
+
 	err = frontend->init_tfm(tfm);
 	if (err)
 		goto out_free_tfm;
@@ -525,13 +541,38 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 	if (err == -EAGAIN)
 		crypto_shoot_alg(alg);
 	kfree(mem);
-out_err:
 	mem = ERR_PTR(err);
 out:
 	return mem;
 }
 EXPORT_SYMBOL_GPL(crypto_create_tfm_node);
 
+void *crypto_clone_tfm(const struct crypto_type *frontend,
+		       struct crypto_tfm *otfm)
+{
+	struct crypto_alg *alg = otfm->__crt_alg;
+	struct crypto_tfm *tfm;
+	char *mem;
+
+	mem = ERR_PTR(-ESTALE);
+	if (unlikely(!crypto_mod_get(alg)))
+		goto out;
+
+	mem = crypto_alloc_tfmmem(alg, frontend, otfm->node, GFP_ATOMIC);
+	if (IS_ERR(mem)) {
+		crypto_mod_put(alg);
+		goto out;
+	}
+
+	tfm = (struct crypto_tfm *)(mem + frontend->tfmsize);
+	tfm->crt_flags = otfm->crt_flags;
+	tfm->exit = otfm->exit;
+
+out:
+	return mem;
+}
+EXPORT_SYMBOL_GPL(crypto_clone_tfm);
+
 struct crypto_alg *crypto_find_alg(const char *alg_name,
 				   const struct crypto_type *frontend,
 				   u32 type, u32 mask)
diff --git a/crypto/internal.h b/crypto/internal.h
index 5eee009ee494..8dd746b1130b 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -106,6 +106,8 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm_node(struct crypto_alg *alg,
 			const struct crypto_type *frontend, int node);
+void *crypto_clone_tfm(const struct crypto_type *frontend,
+		       struct crypto_tfm *otfm);
 
 static inline void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend)
