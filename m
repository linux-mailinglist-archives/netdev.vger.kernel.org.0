Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D069B761AF
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfGZJTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:19:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbfGZJTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 05:19:43 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C2D0C9EE189CFEC56772;
        Fri, 26 Jul 2019 17:19:41 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 26 Jul 2019 17:19:31 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Yang Guo <guoyang2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH] Revert "net: get rid of an signed integer overflow in ip_idents_reserve()"
Date:   Fri, 26 Jul 2019 17:17:15 +0800
Message-ID: <1564132635-57634-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guo <guoyang2@huawei.com>

There is an significant performance regression with the following
commit-id <adb03115f459>
("net: get rid of an signed integer overflow in ip_idents_reserve()").

Both on x86 server(Skylake) and ARM64 server, when cpu core number
increase, the function ip_idents_reserve() of cpu usage is very high, 
and the performance will become bad. After revert the patch, we can
avoid this problem when cpu core number increases.

With the patch on x86, ip_idents_reserve() cpu usage is 63.05% when
iperf3 is run with 32 cpu cores.
Samples: 18K of event 'cycles:ppp', Event count (approx.)
  Children      Self  Command  Shared Object      Symbol
    63.18%    63.05%  iperf3   [kernel.vmlinux]   [k] ip_idents_reserve

And the IOPS is 4483830pps.
10:46:13 AM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
10:46:14 AM        lo 4483830.00 4483830.00 192664.57 192664.57

Resert the patch, ip_idents_reserve() cpu usage is 17.05%.
Samples: 37K of event 'cycles:ppp', 4000 Hz, Event count (approx.)
  Children      Self  Shared Object      Symbol
    17.07%    17.05%  [kernel]           [k] ip_idents_reserve

And the IOPS is 1160021pps.
05:03:15 PM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
05:03:16 PM        lo 11600213.00 11600213.00 498446.65 498446.65

The performance regression was also found on ARM64 server and discussed
a few days ago:
https://lore.kernel.org/netdev/98b95fbe-adcc-c95f-7f3d-6c57122f4586
@pengutronix.de/T/#t

Cc: "David S. Miller" <davem@davemloft.net> 
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru> 
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Yang Guo <guoyang2@huawei.com>
---
 net/ipv4/route.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 517300d..dff457b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -489,18 +489,12 @@ u32 ip_idents_reserve(u32 hash, int segs)
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
+	return atomic_add_return(segs + delta, p_id) - segs;
 }
 EXPORT_SYMBOL(ip_idents_reserve);
 
-- 
1.8.3.1

