Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59323FAEDF
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbhH2WRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 18:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbhH2WRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 18:17:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2112C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 15:16:21 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mq3so8176009pjb.5
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 15:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=swelTAQtQxKqymGLqfC04nJtJBqlKXlaH5+mLMbRKuc=;
        b=CozOLFTAepnkrCzoC1YZ9qkwxkyAsZ0lwdWRlZCGX1hAdlawCzKct9WZw1m67778fk
         YUUldJbf7jSToZwUoE2VHKAF6OnzpkrpTre8iaqHwBJ5G05aBJXTWVd56/sgbn43HVwd
         8lapT37/8oelEtkWbqhN5UpxL+mf9MKl+xCfhHgmCmrr3ylgQOoMkPJX+ORADAAjyuPm
         hrxnDz2HjPveFkYAxUhHfdmUlC3LkDZ003tytsZQGFAVUKpPRKpGriuyuYaaIR4ZD4Zz
         tKDo0JxmH+zNdPd20uJBCkPD7VG7IwkRRk5x+Xo5bwWr7TbjrkzFy1p9tG35LE/GtKkC
         V5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=swelTAQtQxKqymGLqfC04nJtJBqlKXlaH5+mLMbRKuc=;
        b=CssWXOSzyLxnpluo7WOBBL3XnlZrRD98wNjqIIwGqhqN8EmKFWVez1ONRWY7d+TNDz
         ZPqaN5zhUuTVq31/tmPeXM1Zgedv/b9Nu1Y88XAxJL6kLuz3QBYMspd6jWxBDM4Rq/cY
         aDVcrM+V4UeUIHlVWgItuc1Rk0bSfOzakQiVfCsmUsTMMQJGm6TaHH4y6p9dVMRQ8pHP
         0pFSnMmvkIFyJXlhfkzx5p6dL8NrJQTkkNWOQeeKosQVUCnQfz8IyFg6IRsvgyEVJE2U
         8onmUxobuXjIaW+LNMKvL23mkVPBbcllAV/dk12VRa9LrLn2GGt/Y5nVMWU/M6d1OFCP
         QE8A==
X-Gm-Message-State: AOAM532pgTWGJiQb7LBBZY7Egigo+QLTazHoaTnQpSbJ6qAu6yY6/reC
        CRPJ8BfKgLmPTAmIpNU6cKk=
X-Google-Smtp-Source: ABdhPJyG3Cx3ltOOY/Znnh/xy/2hW8r2SDWi+MXBqk0KCiMbl120xg9GMZVBOStUrUSSWZoRf5fESg==
X-Received: by 2002:a17:902:e8c2:b029:123:25ba:e443 with SMTP id v2-20020a170902e8c2b029012325bae443mr19106215plg.29.1630275381532;
        Sun, 29 Aug 2021 15:16:21 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:3934:d27b:77de:86b7])
        by smtp.gmail.com with ESMTPSA id o15sm1162735pjr.0.2021.08.29.15.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 15:16:21 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>,
        David Ahern <dsahern@kernel.org>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH net 1/2] ipv6: make exception cache less predictible
Date:   Sun, 29 Aug 2021 15:16:14 -0700
Message-Id: <20210829221615.2057201-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
In-Reply-To: <20210829221615.2057201-1-eric.dumazet@gmail.com>
References: <20210829221615.2057201-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Even after commit 4785305c05b2 ("ipv6: use siphash in rt6_exception_hash()"),
an attacker can still use brute force to learn some secrets from a victim
linux host.

One way to defeat these attacks is to make the max depth of the hash
table bucket a random value.

Before this patch, each bucket of the hash table used to store exceptions
could contain 6 items under attack.

After the patch, each bucket would contains a random number of items,
between 6 and 10. The attacker can no longer infer secrets.

This is slightly increasing memory size used by the hash table,
we do not expect this to be a problem.

Following patch is dealing with the same issue in IPv4.

Fixes: 35732d01fe31 ("ipv6: introduce a hash table to store dst cache")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Cc: Wei Wang <weiwan@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv6/route.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index c5e8ecb96426bda619fe242351e40dcf6ff68bcf..60334030210192660a7fa141163f36af7489d0ae 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1657,6 +1657,7 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	struct in6_addr *src_key = NULL;
 	struct rt6_exception *rt6_ex;
 	struct fib6_nh *nh = res->nh;
+	int max_depth;
 	int err = 0;
 
 	spin_lock_bh(&rt6_exception_lock);
@@ -1711,7 +1712,9 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	bucket->depth++;
 	net->ipv6.rt6_stats->fib_rt_cache++;
 
-	if (bucket->depth > FIB6_MAX_DEPTH)
+	/* Randomize max depth to avoid some side channels attacks. */
+	max_depth = FIB6_MAX_DEPTH + prandom_u32_max(FIB6_MAX_DEPTH);
+	while (bucket->depth > max_depth)
 		rt6_exception_remove_oldest(bucket);
 
 out:
-- 
2.33.0.259.gc128427fd7-goog

