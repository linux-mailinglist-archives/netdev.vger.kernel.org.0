Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F03B2E29E6
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 06:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgLYFpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 00:45:51 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:53766 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725681AbgLYFpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 00:45:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=weichen.chen@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UJi-oZZ_1608875106;
Received: from localhost(mailfrom:weichen.chen@linux.alibaba.com fp:SMTPD_---0UJi-oZZ_1608875106)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 25 Dec 2020 13:45:06 +0800
From:   weichenchen <weichen.chen@linux.alibaba.com>
To:     eric.dumazet@gmail.com, kuba@kernel.org, davem@davemloft.net
Cc:     splendidsky.cwc@alibaba-inc.com, yanxu.zw@alibaba-inc.com,
        weichenchen <weichen.chen@linux.alibaba.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jeff Dike <jdike@akamai.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Li RongQing <lirongqing@baidu.com>,
        Roman Mashak <mrv@mojatatu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] net: neighbor: fix a crash caused by mod zero
Date:   Fri, 25 Dec 2020 13:44:45 +0800
Message-Id: <20201225054448.73256-1-weichen.chen@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <dbc6cd85-c58b-add2-5801-06e8e94b7d6b@gmail.com>
References: <dbc6cd85-c58b-add2-5801-06e8e94b7d6b@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pneigh_enqueue() tries to obtain a random delay by mod
NEIGH_VAR(p, PROXY_DELAY). However, NEIGH_VAR(p, PROXY_DELAY)
migth be zero at that point because someone could write zero
to /proc/sys/net/ipv4/neigh/[device]/proxy_delay after the
callers check it.

This patch uses prandom_u32_max() to get a random delay instead
which avoids potential division by zero.

Signed-off-by: weichenchen <weichen.chen@linux.alibaba.com>
---
V4:
    - Use prandom_u32_max() to get a random delay in
      pneigh_enqueue().
V3:
    - Callers need to pass the delay time to pneigh_enqueue()
      now and they should guarantee it is not zero.
    - Use READ_ONCE() to read NEIGH_VAR(p, PROXY_DELAY) in both
      of the existing callers of pneigh_enqueue() and then pass
      it to pneigh_enqueue().
V2:
    - Use READ_ONCE() to prevent the complier from re-reading
      NEIGH_VAR(p, PROXY_DELAY).
    - Give a hint to the complier that delay <= 0 is unlikely
      to happen.

V4 is quite concise and works well.
Thanks for Eric's and Jakub's advice.
---
 net/core/neighbour.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9500d28a43b0..277ed854aef1 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1569,10 +1569,8 @@ static void neigh_proxy_process(struct timer_list *t)
 void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
 		    struct sk_buff *skb)
 {
-	unsigned long now = jiffies;
-
-	unsigned long sched_next = now + (prandom_u32() %
-					  NEIGH_VAR(p, PROXY_DELAY));
+	unsigned long sched_next = jiffies +
+			prandom_u32_max(NEIGH_VAR(p, PROXY_DELAY));
 
 	if (tbl->proxy_queue.qlen > NEIGH_VAR(p, PROXY_QLEN)) {
 		kfree_skb(skb);
-- 
2.20.1 (Apple Git-117)

