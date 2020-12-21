Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD9C2DFC39
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 14:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgLUNJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 08:09:26 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:43068 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbgLUNJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 08:09:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=weichen.chen@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UJJwcON_1608556101;
Received: from localhost(mailfrom:weichen.chen@linux.alibaba.com fp:SMTPD_---0UJJwcON_1608556101)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Dec 2020 21:08:41 +0800
From:   weichenchen <weichen.chen@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     splendidsky.cwc@alibaba-inc.com, yanxu.zw@alibaba-inc.com,
        weichenchen <weichen.chen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Jeff Dike <jdike@akamai.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: neighbor: fix a crash caused by mod zero
Date:   Mon, 21 Dec 2020 21:07:44 +0800
Message-Id: <20201221130754.12628-1-weichen.chen@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20201219102116.3cc0d74c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201219102116.3cc0d74c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
V2:
    - Use READ_ONCE() to prevent the complier from re-reading
      NEIGH_VAR(p, PROXY_DELAY).
    - Give a hint to the complier that delay <= 0 is unlikely
      to happen.

Note: I don't think having the caller pass in the value is a
good idea mainly because delay should be only decided by
/proc/sys/net/ipv4/neigh/[device]/proxy_delay rather than the
caller.
---
 net/core/neighbour.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9500d28a43b0..7b03d3f129c0 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1570,9 +1570,14 @@ void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
 		    struct sk_buff *skb)
 {
 	unsigned long now = jiffies;
+	unsigned long sched_next;
 
-	unsigned long sched_next = now + (prandom_u32() %
-					  NEIGH_VAR(p, PROXY_DELAY));
+	int delay = READ_ONCE(NEIGH_VAR(p, PROXY_DELAY));
+
+	if (unlikely(delay <= 0))
+		sched_next = now;
+	else
+		sched_next = now + (prandom_u32() % delay);
 
 	if (tbl->proxy_queue.qlen > NEIGH_VAR(p, PROXY_QLEN)) {
 		kfree_skb(skb);
-- 
2.20.1 (Apple Git-117)

