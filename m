Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76AB3F7EF2
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 01:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhHYXSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 19:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbhHYXSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 19:18:23 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EDAC0613C1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 16:17:37 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id v123so975831pfb.11
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 16:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=grElHCeWG42mSCpLrJvrvmI/9gP3g+wI733Q+bGGDGg=;
        b=E3pRRjGeUzH6eCSHlRSMbsBmtdS7GlDx7DZ0x/AbpF0D+OsD10SXb6wRw5RqKwI+Yx
         sNwJgDPikuzywHYIADiYfsZwl7i5dbzyRaoR7z6vcfichGPrXnDh3sjr58zx5Ft8YyOF
         4523zmMQ2sfWNBnlt2drMAAnEvIm5SEwT/m2sfNpgCF6GC1OkY0XvQ4t1k5bX9dA7Gp1
         BdgevTQKIKNpVYl4gkeLfriWSCe3uaTy6rNOHHp6Kbglp/7Aik1WjwObYhlak+dOreHC
         evDChat9BDRXanVl/DwvJijDpRN7Ozb1Lha7kOj99wsHEl0HY39Nd2wYTlyke25gVcOs
         E+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=grElHCeWG42mSCpLrJvrvmI/9gP3g+wI733Q+bGGDGg=;
        b=knpyQPVVF/GElnVTQ/gDTgFohouvXbANROlpkkhVlEpIaMipsQvoIygyystBC6xMMg
         QT3x8HpjqcLpmI78qKDLJyFOxta47Tvs3ESoj5rGQhZwvu8xoWV59gd5DZ3ttERVfedg
         klSHCGR2oYMoC4k3a2d+6adJdT7x3iIByocvrtG4oMLcPSp+xazucvCIq7YuGL11P6PM
         TVioB14RJvSx5leJqk2yEC9CWFEnnuxcwcMxJwplFjxkepCxXo5keHWn24xU8Ln8jbk+
         SBK+qRedcHVE3ooF7Exs7QKYZoMyvcFnlLrh/PMqEF4UrawbksRE3rhsqCTEg4otI4Sk
         vHug==
X-Gm-Message-State: AOAM532Zj79eslX7pmcPzX5BSRVfl34QIuz0v62BNB4BFHOFMJB8vulj
        rfVCKhhm/Dl5559RBHzmVtI=
X-Google-Smtp-Source: ABdhPJy+WAikEW5Ya4hbIatvcNuEVY8ynbRdMf7E5FkRbRY61a2aMMIyLwSW7NCZqx6dJtHMr6xq4Q==
X-Received: by 2002:a65:5086:: with SMTP id r6mr566906pgp.65.1629933457180;
        Wed, 25 Aug 2021 16:17:37 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d4a1:c5c4:fef5:2e3e])
        by smtp.gmail.com with ESMTPSA id mv1sm6625035pjb.29.2021.08.25.16.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 16:17:36 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>
Subject: [PATCH net 2/2] ipv4: use siphash instead of Jenkins in fnhe_hashfun()
Date:   Wed, 25 Aug 2021 16:17:29 -0700
Message-Id: <20210825231729.401676-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
In-Reply-To: <20210825231729.401676-1-eric.dumazet@gmail.com>
References: <20210825231729.401676-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

A group of security researchers brought to our attention
the weakness of hash function used in fnhe_hashfun().

Lets use siphash instead of Jenkins Hash, to considerably
reduce security risks.

Also remove the inline keyword, this really is distracting.

Fixes: d546c621542d ("ipv4: harden fnhe_hashfun()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/route.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 99c06944501ab1a8de0960acfdc9f1825b7079b1..a6f20ee3533554b210d27c4ab6637ca7a05b148b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -600,14 +600,14 @@ static struct fib_nh_exception *fnhe_oldest(struct fnhe_hash_bucket *hash)
 	return oldest;
 }
 
-static inline u32 fnhe_hashfun(__be32 daddr)
+static u32 fnhe_hashfun(__be32 daddr)
 {
-	static u32 fnhe_hashrnd __read_mostly;
-	u32 hval;
+	static siphash_key_t fnhe_hash_key __read_mostly;
+	u64 hval;
 
-	net_get_random_once(&fnhe_hashrnd, sizeof(fnhe_hashrnd));
-	hval = jhash_1word((__force u32)daddr, fnhe_hashrnd);
-	return hash_32(hval, FNHE_HASH_SHIFT);
+	net_get_random_once(&fnhe_hash_key, sizeof(fnhe_hash_key));
+	hval = siphash_1u32((__force u32)daddr, &fnhe_hash_key);
+	return hash_64(hval, FNHE_HASH_SHIFT);
 }
 
 static void fill_route_from_fnhe(struct rtable *rt, struct fib_nh_exception *fnhe)
-- 
2.33.0.rc2.250.ged5fa647cd-goog

