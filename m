Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EE86E06E3
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjDMGZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjDMGY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:24:59 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48BA8688;
        Wed, 12 Apr 2023 23:24:55 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pmqNZ-00FNVh-O9; Thu, 13 Apr 2023 14:24:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Apr 2023 14:24:21 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 13 Apr 2023 14:24:21 +0800
Subject: [PATCH 4/6] crypto: hmac - Add support for cloning
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
Message-Id: <E1pmqNZ-00FNVh-O9@formenos.hmeau.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow hmac to be cloned.  The underlying hash can be used directly
with a reference count.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/hmac.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 3610ff0b6739..09a7872b4060 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -160,6 +160,20 @@ static int hmac_init_tfm(struct crypto_shash *parent)
 	return 0;
 }
 
+static int hmac_clone_tfm(struct crypto_shash *dst, struct crypto_shash *src)
+{
+	struct hmac_ctx *sctx = hmac_ctx(src);
+	struct hmac_ctx *dctx = hmac_ctx(dst);
+	struct crypto_shash *hash;
+
+	hash = crypto_clone_shash(sctx->hash);
+	if (IS_ERR(hash))
+		return PTR_ERR(hash);
+
+	dctx->hash = hash;
+	return 0;
+}
+
 static void hmac_exit_tfm(struct crypto_shash *parent)
 {
 	struct hmac_ctx *ctx = hmac_ctx(parent);
@@ -227,6 +241,7 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.import = hmac_import;
 	inst->alg.setkey = hmac_setkey;
 	inst->alg.init_tfm = hmac_init_tfm;
+	inst->alg.clone_tfm = hmac_clone_tfm;
 	inst->alg.exit_tfm = hmac_exit_tfm;
 
 	inst->free = shash_free_singlespawn_instance;
