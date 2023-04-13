Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A183C6E06EA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjDMGZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjDMGZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:25:00 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608E77AA7;
        Wed, 12 Apr 2023 23:24:56 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pmqNb-00FNVu-SO; Thu, 13 Apr 2023 14:24:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Apr 2023 14:24:23 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 13 Apr 2023 14:24:23 +0800
Subject: [PATCH 5/6] crypto: cryptd - Convert hash to use modern init_tfm/exit_tfm
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
Message-Id: <E1pmqNb-00FNVu-SO@formenos.hmeau.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cryptd hash template was still using the obsolete cra_init/cra_exit
interface.  Make it use the modern ahash init_tfm/exit_tfm instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 37365ed30b38..43ce347ccba0 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -427,12 +427,12 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 	return err;
 }
 
-static int cryptd_hash_init_tfm(struct crypto_tfm *tfm)
+static int cryptd_hash_init_tfm(struct crypto_ahash *tfm)
 {
-	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct hashd_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct ahash_instance *inst = ahash_alg_instance(tfm);
+	struct hashd_instance_ctx *ictx = ahash_instance_ctx(inst);
 	struct crypto_shash_spawn *spawn = &ictx->spawn;
-	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct crypto_shash *hash;
 
 	hash = crypto_spawn_shash(spawn);
@@ -440,15 +440,15 @@ static int cryptd_hash_init_tfm(struct crypto_tfm *tfm)
 		return PTR_ERR(hash);
 
 	ctx->child = hash;
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+	crypto_ahash_set_reqsize(tfm,
 				 sizeof(struct cryptd_hash_request_ctx) +
 				 crypto_shash_descsize(hash));
 	return 0;
 }
 
-static void cryptd_hash_exit_tfm(struct crypto_tfm *tfm)
+static void cryptd_hash_exit_tfm(struct crypto_ahash *tfm)
 {
-	struct cryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct cryptd_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	crypto_free_shash(ctx->child);
 }
@@ -677,8 +677,8 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.halg.statesize = alg->statesize;
 	inst->alg.halg.base.cra_ctxsize = sizeof(struct cryptd_hash_ctx);
 
-	inst->alg.halg.base.cra_init = cryptd_hash_init_tfm;
-	inst->alg.halg.base.cra_exit = cryptd_hash_exit_tfm;
+	inst->alg.init_tfm = cryptd_hash_init_tfm;
+	inst->alg.exit_tfm = cryptd_hash_exit_tfm;
 
 	inst->alg.init   = cryptd_hash_init_enqueue;
 	inst->alg.update = cryptd_hash_update_enqueue;
