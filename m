Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDA33C3FC9
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 00:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhGKWen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 18:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKWem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 18:34:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4B4C0613DD;
        Sun, 11 Jul 2021 15:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=H7RHC9PAGo7nFqGD22lHzISKCO3dCV+vM/OnCERLMj0=; b=0tg9x+gIqCAtRRWK4CGLvarT1M
        FwzOnutPg7Isls3CQeaHSgUlMGUH768rgd+x6J/sKo2k+cA/CpXJmoAwhxchiBY17ZPBYBIEoq+Q0
        2FxMAVdvtYvkFu3urD+szA6LmlFn+3RYeoLqPw+ciReHsPbXWE9ZEFULxMDgCDgPJtrGiaB+bmgGk
        q6dAXvzyJvTi/JCucxpK7meGmk9n6/oNUcL028PlBl+PZn0opSdYUGGBHx76tYZo1YjPMvuJoMQ1V
        Xhqko7QjQcExEKk50ttJ1ME+t1lucqDoujFAGH4Smgr+BO1fG5Q+dVNKqb5SLP3fp7siUsI9Fe4mT
        IFJzp0jw==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2hzN-005U4u-1u; Sun, 11 Jul 2021 22:31:53 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Salomon <dilinger@queued.net>,
        linux-geode@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>, linux-x25@vger.kernel.org,
        wireguard@lists.zx2c4.com
Subject: [PATCH 3/6 v2] lib: crypto: rename 'mod_init' & 'mod_exit' functions to be module-specific
Date:   Sun, 11 Jul 2021 15:31:45 -0700
Message-Id: <20210711223148.5250-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210711223148.5250-1-rdunlap@infradead.org>
References: <20210711223148.5250-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename module_init & module_exit functions that are named
"mod_init" and "mod_exit" so that they are unique in both the
System.map file and in initcall_debug output instead of showing
up as almost anonymous "mod_init".

This is helpful for debugging and in determining how long certain
module_init calls take to execute.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
---
v2: no change

 lib/crypto/blake2s.c          |    8 ++++----
 lib/crypto/chacha20poly1305.c |    8 ++++----
 lib/crypto/curve25519.c       |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

--- linux-next-20210708.orig/lib/crypto/blake2s.c
+++ linux-next-20210708/lib/crypto/blake2s.c
@@ -73,7 +73,7 @@ void blake2s256_hmac(u8 *out, const u8 *
 }
 EXPORT_SYMBOL(blake2s256_hmac);
 
-static int __init mod_init(void)
+static int __init blake2s_mod_init(void)
 {
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
 	    WARN_ON(!blake2s_selftest()))
@@ -81,12 +81,12 @@ static int __init mod_init(void)
 	return 0;
 }
 
-static void __exit mod_exit(void)
+static void __exit blake2s_mod_exit(void)
 {
 }
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(blake2s_mod_init);
+module_exit(blake2s_mod_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("BLAKE2s hash function");
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
--- linux-next-20210708.orig/lib/crypto/chacha20poly1305.c
+++ linux-next-20210708/lib/crypto/chacha20poly1305.c
@@ -354,7 +354,7 @@ bool chacha20poly1305_decrypt_sg_inplace
 }
 EXPORT_SYMBOL(chacha20poly1305_decrypt_sg_inplace);
 
-static int __init mod_init(void)
+static int __init chacha20poly1305_init(void)
 {
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
 	    WARN_ON(!chacha20poly1305_selftest()))
@@ -362,12 +362,12 @@ static int __init mod_init(void)
 	return 0;
 }
 
-static void __exit mod_exit(void)
+static void __exit chacha20poly1305_exit(void)
 {
 }
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(chacha20poly1305_init);
+module_exit(chacha20poly1305_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("ChaCha20Poly1305 AEAD construction");
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
--- linux-next-20210708.orig/lib/crypto/curve25519.c
+++ linux-next-20210708/lib/crypto/curve25519.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
-static int __init mod_init(void)
+static int __init curve25519_init(void)
 {
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
 	    WARN_ON(!curve25519_selftest()))
@@ -21,12 +21,12 @@ static int __init mod_init(void)
 	return 0;
 }
 
-static void __exit mod_exit(void)
+static void __exit curve25519_exit(void)
 {
 }
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(curve25519_init);
+module_exit(curve25519_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Curve25519 scalar multiplication");
