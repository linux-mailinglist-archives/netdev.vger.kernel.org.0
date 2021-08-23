Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D92C3F4419
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 06:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhHWEVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 00:21:52 -0400
Received: from mail-m963.mail.126.com ([123.126.96.3]:56370 "EHLO
        mail-m963.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhHWEVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 00:21:52 -0400
X-Greylist: delayed 1892 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2021 00:21:51 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=bLhi3x2BRyUWAiafje
        v5SWx5KYU1bHlvlbbBzV4bLnE=; b=FY7fauIIqcnAlOmbWnbp7Va3q+/qJNzUV3
        FoVNwe7Rswat5MLYow+aiHGnCkIeFYhqy1vQgN+HCD2RpKMh/Iv2Y6BHXUfgDpXm
        WUXtEVt6AtN5NX0OgSBJ3DdoBIpd7nHNxTopijQkmvwb0gM7Ds74nZAFQjst4afJ
        VK2GhoT2k=
Received: from localhost.localdomain (unknown [222.128.173.92])
        by smtp8 (Coremail) with SMTP id NORpCgD3zFy9GiNhsulwOg--.5885S4;
        Mon, 23 Aug 2021 11:49:18 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] ipv6: correct comments about fib6_node sernum
Date:   Mon, 23 Aug 2021 11:49:00 +0800
Message-Id: <20210823034900.22967-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: NORpCgD3zFy9GiNhsulwOg--.5885S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur4rtFy3Kr1xCF1DKFy8Xwb_yoW8XFyfpF
        4qkrs7KrnruFyYkrWkJF18Zr13WanrCFW3Ww4fAayvkw1vqw18XF1kKr1SvF18GFWSvanx
        JF42qrWfJF45uw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U59N3UUUUU=
X-Originating-IP: [222.128.173.92]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbi1x73-l53W4+6DgAAsJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

correct comments in set and get fn_sernum

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 include/net/ip6_fib.h | 4 ++--
 net/ipv6/ip6_fib.c    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 15b7fbe6b..c412dde4d 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -267,7 +267,7 @@ static inline bool fib6_check_expired(const struct fib6_info *f6i)
 	return false;
 }
 
-/* Function to safely get fn->sernum for passed in rt
+/* Function to safely get fn->fn_sernum for passed in rt
  * and store result in passed in cookie.
  * Return true if we can get cookie safely
  * Return false if not
@@ -282,7 +282,7 @@ static inline bool fib6_get_cookie_safe(const struct fib6_info *f6i,
 
 	if (fn) {
 		*cookie = fn->fn_sernum;
-		/* pairs with smp_wmb() in fib6_update_sernum_upto_root() */
+		/* pairs with smp_wmb() in __fib6_update_sernum_upto_root() */
 		smp_rmb();
 		status = true;
 	}
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 679699e95..4d7b93baa 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1340,7 +1340,7 @@ static void __fib6_update_sernum_upto_root(struct fib6_info *rt,
 	struct fib6_node *fn = rcu_dereference_protected(rt->fib6_node,
 				lockdep_is_held(&rt->fib6_table->tb6_lock));
 
-	/* paired with smp_rmb() in rt6_get_cookie_safe() */
+	/* paired with smp_rmb() in fib6_get_cookie_safe() */
 	smp_wmb();
 	while (fn) {
 		fn->fn_sernum = sernum;
-- 
2.17.1

