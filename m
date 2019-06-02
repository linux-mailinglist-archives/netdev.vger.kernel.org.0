Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8827F3230F
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 13:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFBLKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 07:10:55 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42725 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfFBLKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 07:10:55 -0400
Received: by mail-pg1-f193.google.com with SMTP id e6so5340986pgd.9
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 04:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3x7NDeHlDCA9j8foSgI2/SwaoOOyyAL1Z2z0/P5/q0Y=;
        b=p7KihpUMBjhBdE9scVSnmOX35w11zj93wY96YMAFEPLDYIYRyBmGrHAt0EXpwjhr5a
         NDDCzWpbp78h9bEbVIEEPd9J6pSqjXuW5HymKwWIng4sx216MyGdnFJzJzYqOg+V7s3y
         4UQ522OG3yNGHE1gygWinGhYInOGeYYtheVJWazar9la+4qKp5gbEDtK2F0vf5FxsgeE
         gWiuOg3la9VufgK3+6PLSCyeBZmWBOubMJ72aEB1CZ52M6vCFOHcQwmCP/koCxgOrKJU
         yA416hYe613xq0MNhzMfn8XnPE2euP7gPF8CjaDRLeKzFpxoJsvYDVUQoykCluYwKMGO
         2wcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3x7NDeHlDCA9j8foSgI2/SwaoOOyyAL1Z2z0/P5/q0Y=;
        b=lN889Th20sUcK9DdJGU0gHJBC85rysFXmj2i1Z7mruKGylpXGmmWuZySfpfRbj8emF
         lg9a/qQfHPtEM4CX8jb5Op1pZcnTBZAJkjdf8237QB7C9A174PoMtwgmibx+9krnYofr
         dNT53PF5D+4YPu0XsXXv3aRhY4w6MEZpOAVAJTjlhqU95YlGELQwPpxEke+uTkoQG0Ze
         OMPywuCXr6l7/Ocy/M5ts/lCqq2BBrRh9GF9NHQch7rRCNr06SynGbw4oBFLfK/Y/JWA
         +NnJ3YuQPHl8jHwDe765aFDBOO5QBzAVOkfFRCaWRzWDw64irUta65QrXi2UDhp76Wop
         SKAg==
X-Gm-Message-State: APjAAAWrCSYd4MdYLIXd+9LvQKdO0mGJX8bWsse4t86wcqi78ryy93KK
        tiILgazBnmfOHP4kzvld31x2YPCn
X-Google-Smtp-Source: APXvYqzqPYsa10McosUBO4VYePNQsXLSbEcAlN91O0h7BqQoASXOLWcCgufw01Y8DNmRItgaJxC/Kw==
X-Received: by 2002:a63:8dc4:: with SMTP id z187mr10979637pgd.337.1559473854296;
        Sun, 02 Jun 2019 04:10:54 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j15sm14399095pfn.187.2019.06.02.04.10.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 04:10:53 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv6: fix the check before getting the cookie in rt6_get_cookie
Date:   Sun,  2 Jun 2019 19:10:46 +0800
Message-Id: <49388c263f652f91bad8a0d3687df7bb4a18f0da.1559473846.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In Jianlin's testing, netperf was broken with 'Connection reset by peer',
as the cookie check failed in rt6_check() and ip6_dst_check() always
returned NULL.

It's caused by Commit 93531c674315 ("net/ipv6: separate handling of FIB
entries from dst based routes"), where the cookie can be got only when
'c1'(see below) for setting dst_cookie whereas rt6_check() is called
when !'c1' for checking dst_cookie, as we can see in ip6_dst_check().

Since in ip6_dst_check() both rt6_dst_from_check() (c1) and rt6_check()
(!c1) will check the 'from' cookie, this patch is to remove the c1 check
in rt6_get_cookie(), so that the dst_cookie can always be set properly.

c1:
  (rt->rt6i_flags & RTF_PCPU || unlikely(!list_empty(&rt->rt6i_uncached)))

Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/ip6_fib.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 525f701..d6d936c 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -263,8 +263,7 @@ static inline u32 rt6_get_cookie(const struct rt6_info *rt)
 	rcu_read_lock();
 
 	from = rcu_dereference(rt->from);
-	if (from && (rt->rt6i_flags & RTF_PCPU ||
-	    unlikely(!list_empty(&rt->rt6i_uncached))))
+	if (from)
 		fib6_get_cookie_safe(from, &cookie);
 
 	rcu_read_unlock();
-- 
2.1.0

