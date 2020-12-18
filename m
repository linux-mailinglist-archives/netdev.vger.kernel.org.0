Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD9F2DDDB0
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 05:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731537AbgLREVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 23:21:48 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:60751 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727017AbgLREVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 23:21:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=weichen.chen@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UIz3wKA_1608265250;
Received: from localhost(mailfrom:weichen.chen@linux.alibaba.com fp:SMTPD_---0UIz3wKA_1608265250)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 18 Dec 2020 12:21:04 +0800
From:   weichenchen <weichen.chen@linux.alibaba.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     liuhangbin@gmail.com, dsahern@kernel.org, jdike@akamai.com,
        mrv@mojatatu.com, lirongqing@baidu.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        splendidsky.cwc@alibaba-inc.com, yanxu.zw@alibaba-inc.com,
        weichenchen <weichen.chen@linux.alibaba.com>
Subject: [PATCH] net: neighbor: fix a crash caused by mod zero
Date:   Fri, 18 Dec 2020 12:20:19 +0800
Message-Id: <20201218042019.52096-1-weichen.chen@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
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

This patch double-checks NEIGH_VAR(p, PROXY_DELAY) in
pneigh_enqueue() to ensure not to take zero as modulus.

Signed-off-by: weichenchen <weichen.chen@linux.alibaba.com>
---
 net/core/neighbour.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9500d28a43b0..eb5d015c53d3 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1570,9 +1570,14 @@ void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
 		    struct sk_buff *skb)
 {
 	unsigned long now = jiffies;
+	unsigned long sched_next;
 
-	unsigned long sched_next = now + (prandom_u32() %
-					  NEIGH_VAR(p, PROXY_DELAY));
+	int delay = NEIGH_VAR(p, PROXY_DELAY);
+
+	if (delay <= 0)
+		sched_next = now;
+	else
+		sched_next = now + (prandom_u32() % delay);
 
 	if (tbl->proxy_queue.qlen > NEIGH_VAR(p, PROXY_QLEN)) {
 		kfree_skb(skb);
-- 
2.20.1 (Apple Git-117)

