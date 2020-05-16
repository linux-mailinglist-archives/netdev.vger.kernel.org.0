Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2475C1D5E47
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 05:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgEPDsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 23:48:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42620 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgEPDsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 23:48:20 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E748392A9D799AE0A1EB;
        Sat, 16 May 2020 11:48:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Sat, 16 May 2020 11:48:10 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Yuqi Jin <jinyuqi@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        Jiong Wang <jiongwang@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [PATCH v2] net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"
Date:   Sat, 16 May 2020 11:46:49 +0800
Message-ID: <1589600809-18001-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuqi Jin <jinyuqi@huawei.com>

Commit adb03115f459 ("net: get rid of an signed integer overflow in ip_idents_reserve()")
used atomic_cmpxchg to replace "atomic_add_return" inside the function
"ip_idents_reserve". The reason was to avoid UBSAN warning.
However, this change has caused performance degrade and in GCC-8,
fno-strict-overflow is now mapped to -fwrapv -fwrapv-pointer
and signed integer overflow is now undefined by default at all
optimization levels[1]. Moreover, it was a bug in UBSAN vs -fwrapv
/-fno-strict-overflow, so Let's revert it safely.

[1] https://gcc.gnu.org/gcc-8/changes.html

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jiong Wang <jiongwang@huawei.com>
Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
ChangLog:
    * Revise the commit log
    * Add some comments. If it's wholly unnecessary, we
can remove it.

Patch v1: https://patchwork.ozlabs.org/project/netdev/patch/1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com/

 net/ipv4/route.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 788c69d9bfe0..455871d6b3a0 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -491,18 +491,16 @@ u32 ip_idents_reserve(u32 hash, int segs)
 	atomic_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
 	u32 old = READ_ONCE(*p_tstamp);
 	u32 now = (u32)jiffies;
-	u32 new, delta = 0;
+	u32 delta = 0;
 
 	if (old != now && cmpxchg(p_tstamp, old, now) == old)
 		delta = prandom_u32_max(now - old);
 
-	/* Do not use atomic_add_return() as it makes UBSAN unhappy */
-	do {
-		old = (u32)atomic_read(p_id);
-		new = old + delta + segs;
-	} while (atomic_cmpxchg(p_id, old, new) != old);
-
-	return new - segs;
+	/* If UBSAN reports an error there, please make sure your compiler
+	 * supports -fno-strict-overflow before reporting it that was a bug
+	 * in UBSAN, and it has been fixed in GCC-8.
+	 */
+	return atomic_add_return(segs + delta, p_id) - segs;
 }
 EXPORT_SYMBOL(ip_idents_reserve);
 
-- 
2.7.4

