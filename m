Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A764048C479
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353415AbiALNMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:12:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44464 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353395AbiALNMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 08:12:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51B6B61919;
        Wed, 12 Jan 2022 13:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D7EC36AE5;
        Wed, 12 Jan 2022 13:12:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bpi5Ljpz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1641993142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ACiCoxGwtTWuBvroNZW3ALXnH1pqDhtmmMKZfIh188=;
        b=bpi5Ljpz+BM0ViMX5o3eoyyF9lGqSnSvmGgbp/6rjmMaGygRj6lw2vR0bftIOeanmLrnyX
        vcUX9SQm1/aVPeqHmGA9Tc+m88VRd2wz23N256axUfSfyITmsjPLcIH0b0KVEAqVX/D36h
        vgUC06TWRTc4DpNCfWxRN3Vn+0TbgRs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aaccd1a8 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 12 Jan 2022 13:12:21 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
Date:   Wed, 12 Jan 2022 14:12:03 +0100
Message-Id: <20220112131204.800307-3-Jason@zx2c4.com>
In-Reply-To: <20220112131204.800307-1-Jason@zx2c4.com>
References: <20220112131204.800307-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BLAKE2s is faster and more secure. SHA-1 has been broken for a long time
now. This also removes some code complexity, and lets us potentially
remove sha1 from lib, which would further reduce vmlinux size.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv6/addrconf.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3445f8017430..f5cb534aa261 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -61,7 +61,7 @@
 #include <linux/delay.h>
 #include <linux/notifier.h>
 #include <linux/string.h>
-#include <linux/hash.h>
+#include <crypto/blake2s.h>
 
 #include <net/net_namespace.h>
 #include <net/sock.h>
@@ -3225,25 +3225,16 @@ static int ipv6_generate_stable_address(struct in6_addr *address,
 					const struct inet6_dev *idev)
 {
 	static DEFINE_SPINLOCK(lock);
-	static __u32 digest[SHA1_DIGEST_WORDS];
-	static __u32 workspace[SHA1_WORKSPACE_WORDS];
-
-	static union {
-		char __data[SHA1_BLOCK_SIZE];
-		struct {
-			struct in6_addr secret;
-			__be32 prefix[2];
-			unsigned char hwaddr[MAX_ADDR_LEN];
-			u8 dad_count;
-		} __packed;
-	} data;
-
+	struct {
+		struct in6_addr secret;
+		__be32 prefix[2];
+		unsigned char hwaddr[MAX_ADDR_LEN];
+		u8 dad_count;
+	} __packed data;
 	struct in6_addr secret;
 	struct in6_addr temp;
 	struct net *net = dev_net(idev->dev);
 
-	BUILD_BUG_ON(sizeof(data.__data) != sizeof(data));
-
 	if (idev->cnf.stable_secret.initialized)
 		secret = idev->cnf.stable_secret.secret;
 	else if (net->ipv6.devconf_dflt->stable_secret.initialized)
@@ -3254,20 +3245,16 @@ static int ipv6_generate_stable_address(struct in6_addr *address,
 retry:
 	spin_lock_bh(&lock);
 
-	sha1_init(digest);
 	memset(&data, 0, sizeof(data));
-	memset(workspace, 0, sizeof(workspace));
 	memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
 	data.prefix[0] = address->s6_addr32[0];
 	data.prefix[1] = address->s6_addr32[1];
 	data.secret = secret;
 	data.dad_count = dad_count;
 
-	sha1_transform(digest, data.__data, workspace);
-
 	temp = *address;
-	temp.s6_addr32[2] = (__force __be32)digest[0];
-	temp.s6_addr32[3] = (__force __be32)digest[1];
+	blake2s((u8 *)&temp.s6_addr32[2], (u8 *)&data, NULL,
+		sizeof(temp.s6_addr32[2]) * 2, sizeof(data), 0);
 
 	spin_unlock_bh(&lock);
 
-- 
2.34.1

