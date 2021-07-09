Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBC53C1D5E
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhGICUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhGICUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 22:20:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3605C061766;
        Thu,  8 Jul 2021 19:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=d+8/yiZu3L6P8B8KGhlE8N/aoGjld+tQjqmLrEW8N7I=; b=2upCU0SvCtNVlT5M+Ewo4m8Xk7
        w3Tc6jfNlf9YWdPluWHekPTO6s0p3hgDWxCG19jcsqNLu6SbLdiFBSpvqQGltufSQNIxLgNcS2WlM
        rgM6IAakdgAgHU7ZHoo/oqyfz9ocgEG+MF7r45nScZP9cXFBHAHfDkJIdsHxkMJpHNb5sYjpc2MbM
        QraSo4ox+vT07/iJiZECgNAkT6VZwNgq+eAmW714EW1sA4f06itWeCS8ALaIn/3wc9U3bhaRek5Ta
        g9jNFDz+nB9qcPjV3bzdhE0HZFzTPEdU5RG/lcg7nS5IwBM3aYlfeuLlcYmG3E/RYYlWfrwp3PEJe
        rJj174cA==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1g5Q-000Wlc-3d; Fri, 09 Jul 2021 02:17:52 +0000
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
Subject: [PATCH 3/6] lib: crypto: rename 'mod_init' & 'mod_exit' functions to be module-specific
Date:   Thu,  8 Jul 2021 19:17:44 -0700
Message-Id: <20210709021747.32737-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210709021747.32737-1-rdunlap@infradead.org>
References: <20210709021747.32737-1-rdunlap@infradead.org>
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
