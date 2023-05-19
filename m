Return-Path: <netdev+bounces-3846-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 759907091B2
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 604641C210BB
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3165676;
	Fri, 19 May 2023 08:29:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6475F5673
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:29:13 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E321E58;
	Fri, 19 May 2023 01:29:11 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1pzvTZ-00AnMQ-5M; Fri, 19 May 2023 16:28:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 May 2023 16:28:37 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Fri, 19 May 2023 16:28:37 +0800
Subject: [PATCH 3/3] crypto: cmac - Add support for cloning
References: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
To: Dmitry Safonov <dima@arista.com>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, Andy Lutomirski <luto@amacapital.net>, Ard Biesheuvel <ardb@kernel.org>, Bob Gilligan <gilligan@arista.com>, Dan Carpenter <error27@gmail.com>, David Laight <David.Laight@aculab.com>, Dmitry Safonov <0x7f454c46@gmail.com>, Eric Biggers <ebiggers@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Francesco Ruggeri <fruggeri05@gmail.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ivan Delalande <colona@arista.com>, Leonard Crestez <cdleonard@gmail.com>, Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
Message-Id: <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Allow hmac to be cloned.  The underlying cipher needs to support
cloning by not having a cra_init function (all implementations of
aes that do not require a fallback can be cloned).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cmac.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/crypto/cmac.c b/crypto/cmac.c
index bcc6f19a4f64..fce6b0f58e88 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -213,7 +213,22 @@ static int cmac_init_tfm(struct crypto_shash *tfm)
 	ctx->child = cipher;
 
 	return 0;
-};
+}
+
+static int cmac_clone_tfm(struct crypto_shash *tfm, struct crypto_shash *otfm)
+{
+	struct cmac_tfm_ctx *octx = crypto_shash_ctx(otfm);
+	struct cmac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
+	struct crypto_cipher *cipher;
+
+	cipher = crypto_clone_cipher(octx->child);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	ctx->child = cipher;
+
+	return 0;
+}
 
 static void cmac_exit_tfm(struct crypto_shash *tfm)
 {
@@ -280,6 +295,7 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.final = crypto_cmac_digest_final;
 	inst->alg.setkey = crypto_cmac_digest_setkey;
 	inst->alg.init_tfm = cmac_init_tfm;
+	inst->alg.clone_tfm = cmac_clone_tfm;
 	inst->alg.exit_tfm = cmac_exit_tfm;
 
 	inst->free = shash_free_singlespawn_instance;

