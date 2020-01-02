Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D239312E45C
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 10:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgABJWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 04:22:05 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:12303 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727801AbgABJWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 04:22:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TmbxYO7_1577956905;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0TmbxYO7_1577956905)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 02 Jan 2020 17:21:53 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sch_cake: avoid possible divide by zero in cake_enqueue()
Date:   Thu,  2 Jan 2020 17:21:43 +0800
Message-Id: <20200102092143.8971-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variables 'window_interval' is u64 and do_div()
truncates it to 32 bits, which means it can test
non-zero and be truncated to zero for division.
The unit of window_interval is nanoseconds,
so its lower 32-bit is relatively easy to exceed.
Fix this issue by using div64_u64() instead.

Fixes: 7298de9cd725 ("sch_cake: Add ingress mode")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: cake@lists.bufferbloat.net
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 net/sched/sch_cake.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 6cc3ab1..90ef7cc 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1768,7 +1768,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 						      q->avg_window_begin));
 			u64 b = q->avg_window_bytes * (u64)NSEC_PER_SEC;
 
-			do_div(b, window_interval);
+			b = div64_u64(b, window_interval);
 			q->avg_peak_bandwidth =
 				cake_ewma(q->avg_peak_bandwidth, b,
 					  b > q->avg_peak_bandwidth ? 2 : 8);
-- 
1.8.3.1

