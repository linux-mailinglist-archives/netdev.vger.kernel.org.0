Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2F31A4265
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 08:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgDJGKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 02:10:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46778 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgDJGKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 02:10:35 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jMmrG-0004BP-PQ; Fri, 10 Apr 2020 16:09:43 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Apr 2020 16:09:42 +1000
Date:   Fri, 10 Apr 2020 16:09:42 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: crypto: api - Fix use-after-free and race in crypto_spawn_alg
Message-ID: <20200410060942.GA4048@gondor.apana.org.au>
References: <0000000000002656a605a2a34356@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002656a605a2a34356@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two problems in crypto_spawn_alg.  First of all it may
return spawn->alg even if spawn->dead is set.  This results in a
double-free as detected by syzbot.

Secondly the setting of the DYING flag is racy because we hold
the read-lock instead of the write-lock.  We should instead call
crypto_shoot_alg in a safe manner by gaining a refcount, dropping
the lock, and then releasing the refcount.

This patch fixes both problems.

Reported-by: syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com
Fixes: 4f87ee118d16 ("crypto: api - Do not zap spawn->alg")
Fixes: 73669cc55646 ("crypto: api - Fix race condition in...")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 69605e21af92..f8b4dc161c02 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -716,17 +716,27 @@ EXPORT_SYMBOL_GPL(crypto_drop_spawn);
 
 static struct crypto_alg *crypto_spawn_alg(struct crypto_spawn *spawn)
 {
-	struct crypto_alg *alg;
+	struct crypto_alg *alg = ERR_PTR(-EAGAIN);
+	struct crypto_alg *target;
+	bool shoot = false;
 
 	down_read(&crypto_alg_sem);
-	alg = spawn->alg;
-	if (!spawn->dead && !crypto_mod_get(alg)) {
-		alg->cra_flags |= CRYPTO_ALG_DYING;
-		alg = NULL;
+	if (!spawn->dead) {
+		alg = spawn->alg;
+		if (!crypto_mod_get(alg)) {
+			target = crypto_alg_get(alg);
+			shoot = true;
+			alg = ERR_PTR(-EAGAIN);
+		}
 	}
 	up_read(&crypto_alg_sem);
 
-	return alg ?: ERR_PTR(-EAGAIN);
+	if (shoot) {
+		crypto_shoot_alg(target);
+		crypto_alg_put(target);
+	}
+
+	return alg;
 }
 
 struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
diff --git a/crypto/api.c b/crypto/api.c
index 7d71a9b10e5f..edcf690800d4 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -333,12 +333,13 @@ static unsigned int crypto_ctxsize(struct crypto_alg *alg, u32 type, u32 mask)
 	return len;
 }
 
-static void crypto_shoot_alg(struct crypto_alg *alg)
+void crypto_shoot_alg(struct crypto_alg *alg)
 {
 	down_write(&crypto_alg_sem);
 	alg->cra_flags |= CRYPTO_ALG_DYING;
 	up_write(&crypto_alg_sem);
 }
+EXPORT_SYMBOL_GPL(crypto_shoot_alg);
 
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask)
diff --git a/crypto/internal.h b/crypto/internal.h
index d5ebc60c5143..ff06a3bd1ca1 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -65,6 +65,7 @@ void crypto_alg_tested(const char *name, int err);
 void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 			  struct crypto_alg *nalg);
 void crypto_remove_final(struct list_head *list);
+void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
 void *crypto_create_tfm(struct crypto_alg *alg,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
