Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30363536C46
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 12:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbiE1KQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 06:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354955AbiE1KQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 06:16:42 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046883A4
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 03:16:39 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=gjfang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VEazmYe_1653732990;
Received: from i32f12254.sqa.eu95.tbsite.net(mailfrom:gjfang@linux.alibaba.com fp:SMTPD_---0VEazmYe_1653732990)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 28 May 2022 18:16:35 +0800
From:   Guoju Fang <gjfang@linux.alibaba.com>
To:     linyunsheng@huawei.com
Cc:     davem@davemloft.net, edumazet@google.com, eric.dumazet@gmail.com,
        gjfang@linux.alibaba.com, guoju.fgj@alibaba-inc.com,
        kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
        rgauguey@kalrayinc.com, sjones@kalrayinc.com,
        vladimir.oltean@nxp.com, vray@kalrayinc.com, will@kernel.org
Subject: [PATCH v4 net] net: sched: add barrier to fix packet stuck problem for lockless qdisc
Date:   Sat, 28 May 2022 18:16:28 +0800
Message-Id: <20220528101628.120193-1-gjfang@linux.alibaba.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <64b3c3dc-e36d-45b6-4b3a-45e3d26e8315@huawei.com>
References: <64b3c3dc-e36d-45b6-4b3a-45e3d26e8315@huawei.com>
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
the subsequent test_bit() has no barrier semantics so may be reordered
ahead of the spin_unlock(). The store-load reordering may cause a packet
stuck problem.

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

This patch fix this by adding one explicit barrier. As spin_unlock() and
test_bit() ordering is a store-load ordering, a full memory barrier
smp_mb() is needed here.

Fixes: a90c57f2cedd ("net: sched: fix packet stuck problem for lockless qdisc")
Signed-off-by: Guoju Fang <gjfang@linux.alibaba.com>
---
V3 -> V4: Clarified why a full memory barrier is needed
V2 -> V3: Not split the Fixes tag across multiple lines
V1 -> V2: Rewrite comments
---
 include/net/sch_generic.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9bab396c1f3b..93c808bd39aa 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -229,6 +229,12 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		spin_unlock(&qdisc->seqlock);
 
+		/* spin_unlock() only has store-release semantic. The unlock
+		 * and test_bit() ordering is a store-load ordering, so a full
+		 * memory barrier is needed here.
+		 */
+		smp_mb();
+
 		if (unlikely(test_bit(__QDISC_STATE_MISSED,
 				      &qdisc->state)))
 			__netif_schedule(qdisc);
-- 
2.34.0

