Return-Path: <netdev+bounces-3855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0332709295
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACDF5281C18
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 002E6610A;
	Fri, 19 May 2023 09:05:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68035698
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:05:42 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653FE1723;
	Fri, 19 May 2023 02:05:15 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1pzw1s-00AoNA-Ne; Fri, 19 May 2023 17:04:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 May 2023 17:04:04 +0800
Date: Fri, 19 May 2023 17:04:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Dmitry Safonov <dima@arista.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Lutomirski <luto@amacapital.net>,
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
	Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
Subject: [PATCH] crypto: shash - Allow cloning on algorithms with no init_tfm
Message-ID: <ZGc7hCaDrnEFG8Lr@gondor.apana.org.au>
References: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
 <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
 <CAMj1kXGwS03zUBTGb7jmk1-6r+=a-HH+A-S9ZFTYRyJSzN0Xcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGwS03zUBTGb7jmk1-6r+=a-HH+A-S9ZFTYRyJSzN0Xcg@mail.gmail.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 10:54:11AM +0200, Ard Biesheuvel wrote:
>
> Does this imply that the cmac-aes-ce and cmac-aes-neon implementations
> for arm64 need a similar treatment?

Good catch.  Since these don't have init functions we can deal
with them at a higher level:

---8<---
Some shash algorithms are so simple that they don't have an init_tfm
function.  These can be cloned trivially.  Check this before failing
in crypto_clone_shash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/shash.c b/crypto/shash.c
index 717b42df3495..1fadb6b59bdc 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -597,7 +597,7 @@ struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
 		return hash;
 	}
 
-	if (!alg->clone_tfm)
+	if (!alg->clone_tfm && (alg->init_tfm || alg->base.cra_init))
 		return ERR_PTR(-ENOSYS);
 
 	nhash = crypto_clone_tfm(&crypto_shash_type, tfm);
@@ -606,10 +606,12 @@ struct crypto_shash *crypto_clone_shash(struct crypto_shash *hash)
 
 	nhash->descsize = hash->descsize;
 
-	err = alg->clone_tfm(nhash, hash);
-	if (err) {
-		crypto_free_shash(nhash);
-		return ERR_PTR(err);
+	if (alg->clone_tfm) {
+		err = alg->clone_tfm(nhash, hash);
+		if (err) {
+			crypto_free_shash(nhash);
+			return ERR_PTR(err);
+		}
 	}
 
 	return nhash;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

