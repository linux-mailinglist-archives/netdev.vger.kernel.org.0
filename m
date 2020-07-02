Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB1D2120FC
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgGBKWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728367AbgGBKUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 06:20:35 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 621BD20884;
        Thu,  2 Jul 2020 10:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593685234;
        bh=kaueKEmWjbH4Y/IsmnyUJSukPLRE5+XfMcf0ophHf3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rR5cI1xEq2UaIXRaKecu6AAFsz50MEvbYusJVXJWxesdyTbKDZFlfBve8q5pJZ/WW
         57JV7VDH8b2vk15TQIb7Pz6PYBW2RB4UWb+EiI0glP4IU25Q2/iuGvWCRC9aqE1sAB
         Va8Yj8C6MSaQP5jQi63frRgN0IyLgdlPODrzvMrs=
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
Subject: [RFC PATCH 4/7] crypto: remove ARC4 support from the skcipher API
Date:   Thu,  2 Jul 2020 12:19:44 +0200
Message-Id: <20200702101947.682-5-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702101947.682-1-ardb@kernel.org>
References: <20200702101947.682-1-ardb@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the generic ecb(arc4) skcipher, which is slightly cumbersome from
a maintenance perspective, since it does not quite behave like other
skciphers do in terms of key vs IV lifetime. Since we are leaving the
library interface in place, which is used by the various WEP and TKIP
implementations we have in the tree, we can safely drop this code now
it no longer has any users.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig                               | 12 ----
 crypto/Makefile                              |  1 -
 crypto/arc4.c                                | 76 --------------------
 drivers/net/wireless/intel/ipw2x00/Kconfig   |  1 -
 drivers/net/wireless/intersil/hostap/Kconfig |  1 -
 5 files changed, 91 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 091c0a0bbf26..fd0d1f78ac47 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1197,18 +1197,6 @@ config CRYPTO_ANUBIS
 	  <https://www.cosic.esat.kuleuven.be/nessie/reports/>
 	  <http://www.larc.usp.br/~pbarreto/AnubisPage.html>
 
-config CRYPTO_ARC4
-	tristate "ARC4 cipher algorithm"
-	select CRYPTO_SKCIPHER
-	select CRYPTO_LIB_ARC4
-	help
-	  ARC4 cipher algorithm.
-
-	  ARC4 is a stream cipher using keys ranging from 8 bits to 2048
-	  bits in length.  This algorithm is required for driver-based
-	  WEP, but it should not be for other purposes because of the
-	  weakness of the algorithm.
-
 config CRYPTO_BLOWFISH
 	tristate "Blowfish cipher algorithm"
 	select CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
index 4ca12b6044f7..af88c7e30b3c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -128,7 +128,6 @@ obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia_generic.o
 obj-$(CONFIG_CRYPTO_CAST_COMMON) += cast_common.o
 obj-$(CONFIG_CRYPTO_CAST5) += cast5_generic.o
 obj-$(CONFIG_CRYPTO_CAST6) += cast6_generic.o
-obj-$(CONFIG_CRYPTO_ARC4) += arc4.o
 obj-$(CONFIG_CRYPTO_TEA) += tea.o
 obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
 obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
diff --git a/crypto/arc4.c b/crypto/arc4.c
deleted file mode 100644
index aa79571dbd49..000000000000
--- a/crypto/arc4.c
+++ /dev/null
@@ -1,76 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Cryptographic API
- *
- * ARC4 Cipher Algorithm
- *
- * Jon Oberheide <jon@oberheide.org>
- */
-
-#include <crypto/algapi.h>
-#include <crypto/arc4.h>
-#include <crypto/internal/skcipher.h>
-#include <linux/init.h>
-#include <linux/module.h>
-
-static int crypto_arc4_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
-			      unsigned int key_len)
-{
-	struct arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return arc4_setkey(ctx, in_key, key_len);
-}
-
-static int crypto_arc4_crypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while (walk.nbytes > 0) {
-		arc4_crypt(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			   walk.nbytes);
-		err = skcipher_walk_done(&walk, 0);
-	}
-
-	return err;
-}
-
-static struct skcipher_alg arc4_alg = {
-	/*
-	 * For legacy reasons, this is named "ecb(arc4)", not "arc4".
-	 * Nevertheless it's actually a stream cipher, not a block cipher.
-	 */
-	.base.cra_name		=	"ecb(arc4)",
-	.base.cra_driver_name	=	"ecb(arc4)-generic",
-	.base.cra_priority	=	100,
-	.base.cra_blocksize	=	ARC4_BLOCK_SIZE,
-	.base.cra_ctxsize	=	sizeof(struct arc4_ctx),
-	.base.cra_module	=	THIS_MODULE,
-	.min_keysize		=	ARC4_MIN_KEY_SIZE,
-	.max_keysize		=	ARC4_MAX_KEY_SIZE,
-	.setkey			=	crypto_arc4_setkey,
-	.encrypt		=	crypto_arc4_crypt,
-	.decrypt		=	crypto_arc4_crypt,
-};
-
-static int __init arc4_init(void)
-{
-	return crypto_register_skcipher(&arc4_alg);
-}
-
-static void __exit arc4_exit(void)
-{
-	crypto_unregister_skcipher(&arc4_alg);
-}
-
-subsys_initcall(arc4_init);
-module_exit(arc4_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
-MODULE_AUTHOR("Jon Oberheide <jon@oberheide.org>");
-MODULE_ALIAS_CRYPTO("ecb(arc4)");
diff --git a/drivers/net/wireless/intel/ipw2x00/Kconfig b/drivers/net/wireless/intel/ipw2x00/Kconfig
index d00386915a9d..82b7eea3495f 100644
--- a/drivers/net/wireless/intel/ipw2x00/Kconfig
+++ b/drivers/net/wireless/intel/ipw2x00/Kconfig
@@ -160,7 +160,6 @@ config LIBIPW
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select CRYPTO
-	select CRYPTO_ARC4
 	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_MICHAEL_MIC
diff --git a/drivers/net/wireless/intersil/hostap/Kconfig b/drivers/net/wireless/intersil/hostap/Kconfig
index 6ad88299432f..428fb6f55f51 100644
--- a/drivers/net/wireless/intersil/hostap/Kconfig
+++ b/drivers/net/wireless/intersil/hostap/Kconfig
@@ -5,7 +5,6 @@ config HOSTAP
 	select WEXT_SPY
 	select WEXT_PRIV
 	select CRYPTO
-	select CRYPTO_ARC4
 	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_MICHAEL_MIC
-- 
2.17.1

