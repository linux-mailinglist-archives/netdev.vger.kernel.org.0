Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297493FAEE0
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 00:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbhH2WRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 18:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbhH2WRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 18:17:16 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C52C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 15:16:23 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id x4so11635084pgh.1
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 15:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2P6Dq11oFmZoL/VG2LQAN2UkgpqwLgZxozUHmwuft8o=;
        b=aLw19W/3yzYbmZxyucocC9W9wl36+5aBs9/+rpnDA7h8aCJeLpirtrRGUHR/mbd31O
         9ZsFNrDQN2y7iQ3dY88zh6yxzzSABN9X2+gMln+Kzz7WEvdrcq0CVBTmHPqacmDMwAtG
         WYifre5a4YnaV31SwPn1urUj8G79ijAMBfdCjLY95vM9unXYulGYHbFOb4+5By1HMDxJ
         HmTjQIH3nFKlRugFeZduidWXrSoI5vz+jI24XEdlVA2rVjdnWVDHBfvwnmUuQiL5RIMY
         VMje3v+0MkP0RWXth6KZX0ZTccPDU54ooXirhL4BFcpWlEnRE8XEPsy9Fi4ByM+USt1o
         xcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2P6Dq11oFmZoL/VG2LQAN2UkgpqwLgZxozUHmwuft8o=;
        b=SYP4PcfWvPp62YOZWvDa/EXe8edtTe3rzzTbfGwUdhrBtrd+KRgGBSn24rIe4pXvSA
         hBzBqboKMsDUeF1wWkO0ndbSbxjF+rIBswZ8i+cyA+KE4TAC9llrIHWDByPCBwt3ou0f
         FRIFIfLvBi1B6S1g1fr/IDZDds5Mec7qRvifHvv0bNzw0dbAL0R7fC5y/TdIRohin6/Y
         SrLwinSuI/QKijlZvUR2og+NdM3CKMTKJBi27RxxYSqdfFt+C7HPmN+Lb6Vrg5LerkHq
         CjoEJa6eIo4vFuD7FBEQLB4bbZV8uMaME/VdtAFehzgzlpFDknOqh5s6xglJvkD1IsPy
         LCMw==
X-Gm-Message-State: AOAM530lHuYGT3RMfUOGndtKn4NqQanwCx3BHF2c0OyKr2lFVSZler6F
        M/yMcP44YCs46vWZQFIf+Vs=
X-Google-Smtp-Source: ABdhPJyNUWFDWe5u8Jr/1PGQbzF9v1GEC6VPV2WqkqQtUk+FxZE7PDqlwEXq79UBr6lQivjvEweXhw==
X-Received: by 2002:a62:3887:0:b0:3f2:6c5a:8a92 with SMTP id f129-20020a623887000000b003f26c5a8a92mr18020014pfa.8.1630275383271;
        Sun, 29 Aug 2021 15:16:23 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3934:d27b:77de:86b7])
        by smtp.gmail.com with ESMTPSA id o15sm1162735pjr.0.2021.08.29.15.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 15:16:22 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net 2/2] ipv4: make exception cache less predictible
Date:   Sun, 29 Aug 2021 15:16:15 -0700
Message-Id: <20210829221615.2057201-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
In-Reply-To: <20210829221615.2057201-1-eric.dumazet@gmail.com>
References: <20210829221615.2057201-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Even after commit 6457378fe796 ("ipv4: use siphash instead of Jenkins in
fnhe_hashfun()"), an attacker can still use brute force to learn
some secrets from a victim linux host.

One way to defeat these attacks is to make the max depth of the hash
table bucket a random value.

Before this patch, each bucket of the hash table used to store exceptions
could contain 6 items under attack.

After the patch, each bucket would contains a random number of items,
between 6 and 10. The attacker can no longer infer secrets.

This is slightly increasing memory size used by the hash table,
by 50% in average, we do not expect this to be a problem.

This patch is more complex than the prior one (IPv6 equivalent),
because IPv4 was reusing the oldest entry.
Since we need to be able to evict more than one entry per
update_or_create_fnhe() call, I had to replace
fnhe_oldest() with fnhe_remove_oldest().

Also note that we will queue extra kfree_rcu() calls under stress,
which hopefully wont be a too big issue.

Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/route.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a6f20ee3533554b210d27c4ab6637ca7a05b148b..225714b5efc0b9c6bcd2d58a62d4656cdc5a1cde 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -586,18 +586,25 @@ static void fnhe_flush_routes(struct fib_nh_exception *fnhe)
 	}
 }
 
-static struct fib_nh_exception *fnhe_oldest(struct fnhe_hash_bucket *hash)
+static void fnhe_remove_oldest(struct fnhe_hash_bucket *hash)
 {
-	struct fib_nh_exception *fnhe, *oldest;
+	struct fib_nh_exception __rcu **fnhe_p, **oldest_p;
+	struct fib_nh_exception *fnhe, *oldest = NULL;
 
-	oldest = rcu_dereference(hash->chain);
-	for (fnhe = rcu_dereference(oldest->fnhe_next); fnhe;
-	     fnhe = rcu_dereference(fnhe->fnhe_next)) {
-		if (time_before(fnhe->fnhe_stamp, oldest->fnhe_stamp))
+	for (fnhe_p = &hash->chain; ; fnhe_p = &fnhe->fnhe_next) {
+		fnhe = rcu_dereference_protected(*fnhe_p,
+						 lockdep_is_held(&fnhe_lock));
+		if (!fnhe)
+			break;
+		if (!oldest ||
+		    time_before(fnhe->fnhe_stamp, oldest->fnhe_stamp)) {
 			oldest = fnhe;
+			oldest_p = fnhe_p;
+		}
 	}
 	fnhe_flush_routes(oldest);
-	return oldest;
+	*oldest_p = oldest->fnhe_next;
+	kfree_rcu(oldest, rcu);
 }
 
 static u32 fnhe_hashfun(__be32 daddr)
@@ -676,16 +683,21 @@ static void update_or_create_fnhe(struct fib_nh_common *nhc, __be32 daddr,
 		if (rt)
 			fill_route_from_fnhe(rt, fnhe);
 	} else {
-		if (depth > FNHE_RECLAIM_DEPTH)
-			fnhe = fnhe_oldest(hash);
-		else {
-			fnhe = kzalloc(sizeof(*fnhe), GFP_ATOMIC);
-			if (!fnhe)
-				goto out_unlock;
+		/* Randomize max depth to avoid some side channels attacks. */
+		int max_depth = FNHE_RECLAIM_DEPTH +
+				prandom_u32_max(FNHE_RECLAIM_DEPTH);
 
-			fnhe->fnhe_next = hash->chain;
-			rcu_assign_pointer(hash->chain, fnhe);
+		while (depth > max_depth) {
+			fnhe_remove_oldest(hash);
+			depth--;
 		}
+
+		fnhe = kzalloc(sizeof(*fnhe), GFP_ATOMIC);
+		if (!fnhe)
+			goto out_unlock;
+
+		fnhe->fnhe_next = hash->chain;
+
 		fnhe->fnhe_genid = genid;
 		fnhe->fnhe_daddr = daddr;
 		fnhe->fnhe_gw = gw;
@@ -693,6 +705,8 @@ static void update_or_create_fnhe(struct fib_nh_common *nhc, __be32 daddr,
 		fnhe->fnhe_mtu_locked = lock;
 		fnhe->fnhe_expires = max(1UL, expires);
 
+		rcu_assign_pointer(hash->chain, fnhe);
+
 		/* Exception created; mark the cached routes for the nexthop
 		 * stale, so anyone caching it rechecks if this exception
 		 * applies to them.
-- 
2.33.0.259.gc128427fd7-goog

