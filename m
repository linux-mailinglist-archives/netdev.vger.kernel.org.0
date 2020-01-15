Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF7A13B81C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 04:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgAODXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 22:23:53 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9175 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728879AbgAODXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 22:23:52 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 60212E03A4F264E77DEC;
        Wed, 15 Jan 2020 11:23:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Wed, 15 Jan 2020 11:23:40 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Yuqi Jin <jinyuqi@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Yang Guo <guoyang2@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [PATCH] net: optimize cmpxchg in ip_idents_reserve
Date:   Wed, 15 Jan 2020 11:23:40 +0800
Message-ID: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
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

atomic_try_cmpxchg is called instead of atomic_cmpxchg that can reduce
the access number of the global variable @p_id in the loop. Let's
optimize it for performance.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Yang Guo <guoyang2@huawei.com>
Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 net/ipv4/route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 87e979f2b74a..7e28c7121c20 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -496,10 +496,10 @@ u32 ip_idents_reserve(u32 hash, int segs)
 		delta = prandom_u32_max(now - old);
 
 	/* Do not use atomic_add_return() as it makes UBSAN unhappy */
+	old = (u32)atomic_read(p_id);
 	do {
-		old = (u32)atomic_read(p_id);
 		new = old + delta + segs;
-	} while (atomic_cmpxchg(p_id, old, new) != old);
+	} while (!atomic_try_cmpxchg(p_id, &old, new));
 
 	return new - segs;
 }
-- 
2.7.4

