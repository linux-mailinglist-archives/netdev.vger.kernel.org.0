Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFBA48EB90
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiANOUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:20:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56628 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237549AbiANOUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 09:20:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AD05B825FD;
        Fri, 14 Jan 2022 14:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6F8C36AF3;
        Fri, 14 Jan 2022 14:20:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UpmILH5D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642170040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cncAl1lhYlaogYKmR5zQjCe3rwFoN6Y6kAe4crZ9kvU=;
        b=UpmILH5DoSXmwuy6cHRdFXeBPVq/cj/NSwzm10lYJ3bJ5PSjhNLkisMY3OxAnV0Ue73wTs
        +r5+f8RZURvO9Zxq59N7Qb4WUOmzKZcYP+Savgy+8IB7WwC/ZWhyq+a8yt9CJlpKno2dMw
        81DdppmXajYhlwMDlAX/KZezx1DdFds=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 378e8146 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 14 Jan 2022 14:20:40 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Fernando Gont <fgont@si6networks.com>,
        Erik Kline <ek@google.com>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH RFC v2 2/3] ipv6: move from sha1 to blake2s in address calculation
Date:   Fri, 14 Jan 2022 15:20:14 +0100
Message-Id: <20220114142015.87974-3-Jason@zx2c4.com>
In-Reply-To: <20220114142015.87974-1-Jason@zx2c4.com>
References: <20220114142015.87974-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BLAKE2s is faster and more secure. SHA-1 has been broken for a long time
now. This also removes some code complexity, and lets us potentially
remove sha1 from lib, which would further reduce vmlinux size. This also
lets us use the secret in the proper field for a secret, rather than the
prepending done in the prior construction.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Fernando Gont <fgont@si6networks.com>
Cc: Erik Kline <ek@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv6/addrconf.c | 56 ++++++++++++---------------------------------
 1 file changed, 14 insertions(+), 42 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3eee17790a82..47048aafebd3 100644
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
@@ -3224,61 +3224,33 @@ static int ipv6_generate_stable_address(struct in6_addr *address,
 					u8 dad_count,
 					const struct inet6_dev *idev)
 {
-	static DEFINE_SPINLOCK(lock);
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
-	struct in6_addr secret;
-	struct in6_addr temp;
 	struct net *net = dev_net(idev->dev);
-
-	BUILD_BUG_ON(sizeof(data.__data) != sizeof(data));
+	const struct in6_addr *secret;
+	struct blake2s_state hash;
+	struct in6_addr proposal;
 
 	if (idev->cnf.stable_secret.initialized)
-		secret = idev->cnf.stable_secret.secret;
+		secret = &idev->cnf.stable_secret.secret;
 	else if (net->ipv6.devconf_dflt->stable_secret.initialized)
-		secret = net->ipv6.devconf_dflt->stable_secret.secret;
+		secret = &net->ipv6.devconf_dflt->stable_secret.secret;
 	else
 		return -1;
 
 retry:
-	spin_lock_bh(&lock);
-
-	sha1_init(digest);
-	memset(&data, 0, sizeof(data));
-	memset(workspace, 0, sizeof(workspace));
-	memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
-	data.prefix[0] = address->s6_addr32[0];
-	data.prefix[1] = address->s6_addr32[1];
-	data.secret = secret;
-	data.dad_count = dad_count;
-
-	sha1_transform(digest, data.__data, workspace);
-
-	temp = *address;
-	temp.s6_addr32[2] = (__force __be32)digest[0];
-	temp.s6_addr32[3] = (__force __be32)digest[1];
-
-	spin_unlock_bh(&lock);
+	blake2s_init_key(&hash, sizeof(proposal.s6_addr32[2]) * 2, secret, sizeof(*secret));
+	blake2s_update(&hash, (u8 *)&address->s6_addr32[0], sizeof(address->s6_addr32[0]) * 2);
+	blake2s_update(&hash, idev->dev->perm_addr, idev->dev->addr_len);
+	blake2s_update(&hash, (u8 *)&dad_count, sizeof(dad_count));
+	blake2s_final(&hash, (u8 *)&proposal.s6_addr32[2]);
 
-	if (ipv6_reserved_interfaceid(temp)) {
+	if (ipv6_reserved_interfaceid(proposal)) {
 		dad_count++;
-		if (dad_count > dev_net(idev->dev)->ipv6.sysctl.idgen_retries)
+		if (dad_count > net->ipv6.sysctl.idgen_retries)
 			return -1;
 		goto retry;
 	}
 
-	*address = temp;
+	*address = proposal;
 	return 0;
 }
 
-- 
2.34.1

