Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF3D56CB95
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 23:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiGIVVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 17:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGIVV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 17:21:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89181A066;
        Sat,  9 Jul 2022 14:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A63FB8075B;
        Sat,  9 Jul 2022 21:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ED5C341CA;
        Sat,  9 Jul 2022 21:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657401684;
        bh=3PmXbYGfYxecOdWXGHi7rCtLqyl1SUnRBQY9cUsGOHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMOEim0jUbMLWcgmAuWmDN7gPOYQBP1x5E3XGsNAlt76YwEw3+WuZj4Ifvu2ahZPS
         p4R/+bJ7cl0FcTe/Lz9x4s7ZDnPbYSmu6b816rr4bMdFN8G+mmKod1Z1hyt7CdfO19
         iSTn4O88Ab/Fd1HgwFDgiQ11YyiBnOYhF3S+8fIpLmCz3Z71JbNaI/frrQTMY34gLU
         Bn0X4ztMSYxtrdYbdYJe2/UEifvw8L95wyFj/yvwnAgRwbCOy2RlJkx6uomyXwoQOx
         YllI/HvxrFBMf15rH9Ib24e8JbvnqfwrvPsnrWu8J+MF8JBmnUXk4a3ldLXEXndPPt
         90pbkS9eAgVww==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Jason A . Donenfeld " <Jason@zx2c4.com>
Subject: [PATCH 2/2] crypto: make the sha1 library optional
Date:   Sat,  9 Jul 2022 14:18:49 -0700
Message-Id: <20220709211849.210850-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220709211849.210850-1-ebiggers@kernel.org>
References: <20220709211849.210850-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since the Linux RNG no longer uses sha1_transform(), the SHA-1 library
is no longer needed unconditionally.  Make it possible to build the
Linux kernel without the SHA-1 library by putting it behind a kconfig
option, and selecting this new option from the kconfig options that gate
the remaining users: CRYPTO_SHA1 for crypto/sha1_generic.c, BPF for
kernel/bpf/core.c, and IPV6 for net/ipv6/addrconf.c.

Unfortunately, since BPF is selected by NET, for now this can only make
a difference for kernels built without networking support.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig      | 1 +
 init/Kconfig        | 1 +
 lib/crypto/Kconfig  | 3 +++
 lib/crypto/Makefile | 3 ++-
 net/ipv6/Kconfig    | 1 +
 5 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 59489a300cd100..bf15ca5eb9d367 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -880,6 +880,7 @@ config CRYPTO_RMD160
 config CRYPTO_SHA1
 	tristate "SHA1 digest algorithm"
 	select CRYPTO_HASH
+	select CRYPTO_LIB_SHA1
 	help
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
diff --git a/init/Kconfig b/init/Kconfig
index c984afc489dead..d8d0b4bdfe4195 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1472,6 +1472,7 @@ config HAVE_PCSPKR_PLATFORM
 # interpreter that classic socket filters depend on
 config BPF
 	bool
+	select CRYPTO_LIB_SHA1
 
 menuconfig EXPERT
 	bool "Configure standard kernel features (expert users)"
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 2082af43d51fbe..9ff549f63540fa 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -121,6 +121,9 @@ config CRYPTO_LIB_CHACHA20POLY1305
 	select CRYPTO_LIB_POLY1305
 	select CRYPTO_ALGAPI
 
+config CRYPTO_LIB_SHA1
+	tristate
+
 config CRYPTO_LIB_SHA256
 	tristate
 
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index d28111ba54fcb2..919cbb2c220d61 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -34,7 +34,8 @@ libpoly1305-y					:= poly1305-donna32.o
 libpoly1305-$(CONFIG_ARCH_SUPPORTS_INT128)	:= poly1305-donna64.o
 libpoly1305-y					+= poly1305.o
 
-obj-y						+= sha1.o
+obj-$(CONFIG_CRYPTO_LIB_SHA1)			+= libsha1.o
+libsha1-y					:= sha1.o
 
 obj-$(CONFIG_CRYPTO_LIB_SHA256)			+= libsha256.o
 libsha256-y					:= sha256.o
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index bf2e5e5fe14273..658bfed1df8b17 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -7,6 +7,7 @@
 menuconfig IPV6
 	tristate "The IPv6 protocol"
 	default y
+	select CRYPTO_LIB_SHA1
 	help
 	  Support for IP version 6 (IPv6).
 
-- 
2.37.0

