Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA19624FEF4
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgHXNcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgHXNcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 09:32:10 -0400
Received: from e123331-lin.arnhem.chello.nl (dhcp-077-251-017-237.chello.nl [77.251.17.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFA4B2065F;
        Mon, 24 Aug 2020 13:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598275909;
        bh=K1jpHm33Dkh6QUv4J3qctT+brWTrrCjnoswvkFtwurY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBQt4OLc2g/bSHV1ipBdXkEyUn2JxRkGCnIch6eb/omDEsHnqMyaNbmIwcorbQM2N
         Kd8Rjt7v2Ki/jMREy3msyNW4FDBh4SAtBXTDGr/N61WzVuoUYKRH/X7KoA3sR0soxt
         P/+RBDeqWk1p82umfXyvvYXMYGsSRq8A+v4iJppU=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-nfs@vger.kernel.org
Subject: [PATCH v2 7/7] crypto: arc4 - mark ecb(arc4) skcipher as obsolete
Date:   Mon, 24 Aug 2020 15:30:01 +0200
Message-Id: <20200824133001.9546-8-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200824133001.9546-1-ardb@kernel.org>
References: <20200824133001.9546-1-ardb@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cryptographic algorithms may have a lifespan that is significantly
shorter than Linux's, and so we need to start phasing out algorithms
that are known to be broken, and are no longer fit for general use.

RC4 (or arc4) is a good example here: there are a few areas where its
use is still somewhat acceptable, e.g., for interoperability with legacy
wifi hardware that can only use WEP or TKIP data encryption, but that
should not imply that, for instance, use of RC4 based EAP-TLS by the WPA
supplicant for negotiating TKIP keys is equally acceptable, or that RC4
should remain available as a general purpose cryptographic transform for
all in-kernel and user space clients.

Now that all in-kernel users that need to retain support have moved to
the arc4 library interface, and the known users of ecb(arc4) via the
socket API (iwd [0] and libell [1][2]) have been updated to switch to a
local implementation, we can take the next step, and mark the ecb(arc4)
skcipher as obsolete, and only provide it if the socket API is enabled in
the first place, as well as provide the option to disable all algorithms
that have been marked as obsolete.

[0] https://git.kernel.org/pub/scm/network/wireless/iwd.git/commit/?id=1db8a85a60c64523
[1] https://git.kernel.org/pub/scm/libs/ell/ell.git/commit/?id=53482ce421b727c2
[2] https://git.kernel.org/pub/scm/libs/ell/ell.git/commit/?id=7f6a137809d42f6b

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig | 10 ++++++++++
 crypto/arc4.c  | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1b57419fa2e7..89d63d240c2e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -136,6 +136,15 @@ config CRYPTO_USER
 	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
 
+config CRYPTO_USER_ENABLE_OBSOLETE
+	bool "Enable obsolete cryptographic algorithms for userspace"
+	depends on CRYPTO_USER
+	default y
+	help
+	  Allow obsolete cryptographic algorithms to be selected that have
+	  already been phased out from internal use by the kernel, and are
+	  only useful for userspace clients that still rely on them.
+
 config CRYPTO_MANAGER_DISABLE_TESTS
 	bool "Disable run-time self tests"
 	default y
@@ -1199,6 +1208,7 @@ config CRYPTO_ANUBIS
 
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
+	depends on CRYPTO_USER_ENABLE_OBSOLETE
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_ARC4
 	help
diff --git a/crypto/arc4.c b/crypto/arc4.c
index aa79571dbd49..923aa7a6cd60 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -12,6 +12,7 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 
 static int crypto_arc4_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			      unsigned int key_len)
@@ -39,6 +40,14 @@ static int crypto_arc4_crypt(struct skcipher_request *req)
 	return err;
 }
 
+static int crypto_arc4_init(struct crypto_skcipher *tfm)
+{
+	pr_warn_ratelimited("\"%s\" (%ld) uses obsolete ecb(arc4) skcipher\n",
+			    current->comm, (unsigned long)current->pid);
+
+	return 0;
+}
+
 static struct skcipher_alg arc4_alg = {
 	/*
 	 * For legacy reasons, this is named "ecb(arc4)", not "arc4".
@@ -55,6 +64,7 @@ static struct skcipher_alg arc4_alg = {
 	.setkey			=	crypto_arc4_setkey,
 	.encrypt		=	crypto_arc4_crypt,
 	.decrypt		=	crypto_arc4_crypt,
+	.init			=	crypto_arc4_init,
 };
 
 static int __init arc4_init(void)
-- 
2.17.1

