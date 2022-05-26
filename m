Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C469534A9D
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 09:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiEZHCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 03:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240673AbiEZHCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 03:02:04 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB83D25C41
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 00:02:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=gjfang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VERAVTZ_1653548506;
Received: from i32f12254.sqa.eu95.tbsite.net(mailfrom:gjfang@linux.alibaba.com fp:SMTPD_---0VERAVTZ_1653548506)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 26 May 2022 15:01:56 +0800
From:   Guoju Fang <gjfang@linux.alibaba.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, eric.dumazet@gmail.com,
        gjfang@linux.alibaba.com, guoju.fgj@alibaba-inc.com,
        kuba@kernel.org, linyunsheng@huawei.com, netdev@vger.kernel.org,
        pabeni@redhat.com, rgauguey@kalrayinc.com, sjones@kalrayinc.com,
        vladimir.oltean@nxp.com, vray@kalrayinc.com, will@kernel.org
Subject: [PATCH v2] net: sched: add barrier to fix packet stuck problem for lockless qdisc
Date:   Thu, 26 May 2022 15:01:45 +0800
Message-Id: <20220526070145.127019-1-gjfang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <CANn89iKTv9nGqnUerWKm-GZvCQGoTrDA_HNZda3REwo0pLwXrg@mail.gmail.com>
References: <CANn89iKTv9nGqnUerWKm-GZvCQGoTrDA_HNZda3REwo0pLwXrg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In qdisc_run_end(), the spin_unlock() only has store-release semantic,
which guarantees all earlier memory access are visible before it. But
the subsequent test_bit() may be reordered ahead of the spin_unlock(),
and may cause a packet stuck problem.

The concurrent operations can be described as below,
         CPU 0                      |          CPU 1
   qdisc_run_end()                  |     qdisc_run_begin()
          .                         |           .
 ----> /* may be reorderd here */   |           .
|         .                         |           .
|     spin_unlock()                 |         set_bit()
|         .                         |         smp_mb__after_atomic()
 ---- test_bit()                    |         spin_trylock()
          .                         |          .

Consider the following sequence of events:
    CPU 0 reorder test_bit() ahead and see MISSED = 0
    CPU 1 calls set_bit()
    CPU 1 calls spin_trylock() and return fail
    CPU 0 executes spin_unlock()

At the end of the sequence, CPU 0 calls spin_unlock() and does nothing
because it see MISSED = 0. The skb on CPU 1 has beed enqueued but no one
take it, until the next cpu pushing to the qdisc (if ever ...) will
notice and dequeue it.

So one explicit barrier is needed between spin_unlock() and
test_bit() to ensure the correct order.

Fixes: 89837eb4b246 ("net: sched: add barrier to ensure correct ordering
for lockless qdisc")
Signed-off-by: Guoju Fang <gjfang@linux.alibaba.com>
---
 include/net/sch_generic.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9bab396c1f3b..8a8738642ca0 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -229,6 +229,9 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		spin_unlock(&qdisc->seqlock);
 
+		/* ensure ordering between spin_unlock() and test_bit() */
+		smp_mb();
+
 		if (unlikely(test_bit(__QDISC_STATE_MISSED,
 				      &qdisc->state)))
 			__netif_schedule(qdisc);
-- 
2.32.0.3.g01195cf9f

