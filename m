Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A3F6E06DD
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDMGYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDMGYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:24:51 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A78A61A1;
        Wed, 12 Apr 2023 23:24:50 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pmqNT-00FNV9-CK; Thu, 13 Apr 2023 14:24:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Apr 2023 14:24:15 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 13 Apr 2023 14:24:15 +0800
Subject: [PATCH 1/6] crypto: api - Add crypto_tfm_get
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
Message-Id: <E1pmqNT-00FNV9-CK@formenos.hmeau.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a crypto_tfm_get interface to allow tfm objects to be shared.
They can still be freed in the usual way.

This should only be done with tfm objects with no keys.  You must
also not modify the tfm flags in any way once it becomes shared.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/api.c           |    4 ++++
 crypto/internal.h      |    6 ++++++
 include/linux/crypto.h |    1 +
 3 files changed, 11 insertions(+)

diff --git a/crypto/api.c b/crypto/api.c
index e67cc63368ed..f509d73fa682 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -408,6 +408,7 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 		goto out_err;
 
 	tfm->__crt_alg = alg;
+	refcount_set(&tfm->refcnt, 1);
 
 	err = crypto_init_ops(tfm, type, mask);
 	if (err)
@@ -507,6 +508,7 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 	tfm = (struct crypto_tfm *)(mem + tfmsize);
 	tfm->__crt_alg = alg;
 	tfm->node = node;
+	refcount_set(&tfm->refcnt, 1);
 
 	err = frontend->init_tfm(tfm);
 	if (err)
@@ -619,6 +621,8 @@ void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
 	if (IS_ERR_OR_NULL(mem))
 		return;
 
+	if (!refcount_dec_and_test(&tfm->refcnt))
+		return;
 	alg = tfm->__crt_alg;
 
 	if (!tfm->exit && alg->cra_exit)
diff --git a/crypto/internal.h b/crypto/internal.h
index f84dfe6491e5..5eee009ee494 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -10,6 +10,7 @@
 
 #include <crypto/algapi.h>
 #include <linux/completion.h>
+#include <linux/err.h>
 #include <linux/jump_label.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -186,5 +187,10 @@ static inline int crypto_is_test_larval(struct crypto_larval *larval)
 	return larval->alg.cra_driver_name[0];
 }
 
+static inline struct crypto_tfm *crypto_tfm_get(struct crypto_tfm *tfm)
+{
+	return refcount_inc_not_zero(&tfm->refcnt) ? tfm : ERR_PTR(-EOVERFLOW);
+}
+
 #endif	/* _CRYPTO_INTERNAL_H */
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index fdfa3e8eda43..fa310ac1db59 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -419,6 +419,7 @@ int crypto_has_alg(const char *name, u32 type, u32 mask);
  */
 
 struct crypto_tfm {
+	refcount_t refcnt;
 
 	u32 crt_flags;
 
