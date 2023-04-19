Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684B66E7924
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 13:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjDSL6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 07:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbjDSL6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 07:58:44 -0400
X-Greylist: delayed 71 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Apr 2023 04:58:26 PDT
Received: from out-15.mta1.migadu.com (out-15.mta1.migadu.com [IPv6:2001:41d0:203:375::f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DF710C6
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:58:25 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681905407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kQMy059N3s1atSzVKA/d/rtaeGTHOWIXN8OS6g3STNA=;
        b=UYRfGj+Kl9pg6QfmfJnJT4KL/GQlRMQ1iLAOp+nSoqOMtXivQlQQT/C9Q1ML96IqrnUvF0
        zbzkEFTD56/czGh+hZA9aSs8CcCfxuPyvxDqrbkLE2plOVjt8QZlogFa/Ea5lnGApN5mED
        w9ZKeZl/x5VwOCsi4nZsHcAMli34bzY=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] net: sched: print jiffies when transmit queue time out
Date:   Wed, 19 Apr 2023 19:56:32 +0800
Message-Id: <20230419115632.738730-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although there is watchdog_timeo to let users know when the transmit queue
begin stall, but dev_watchdog() is called with an interval. The jiffies
will always be greater than watchdog_timeo.

To let users know the exact time the stall started, print jiffies when
the transmit queue time out.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/sched/sch_generic.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a9aadc4e6858..67b78e260d28 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -502,7 +502,7 @@ static void dev_watchdog(struct timer_list *t)
 		if (netif_device_present(dev) &&
 		    netif_running(dev) &&
 		    netif_carrier_ok(dev)) {
-			int some_queue_timedout = 0;
+			unsigned long some_queue_timedout = 0;
 			unsigned int i;
 			unsigned long trans_start;
 
@@ -514,7 +514,7 @@ static void dev_watchdog(struct timer_list *t)
 				if (netif_xmit_stopped(txq) &&
 				    time_after(jiffies, (trans_start +
 							 dev->watchdog_timeo))) {
-					some_queue_timedout = 1;
+					some_queue_timedout = jiffies - trans_start;
 					atomic_long_inc(&txq->trans_timeout);
 					break;
 				}
@@ -522,8 +522,9 @@ static void dev_watchdog(struct timer_list *t)
 
 			if (unlikely(some_queue_timedout)) {
 				trace_net_dev_xmit_timeout(dev, i);
-				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
-				       dev->name, netdev_drivername(dev), i);
+				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): \
+					  transmit queue %u timed out %lu jiffies\n",
+					  dev->name, netdev_drivername(dev), i, some_queue_timedout);
 				netif_freeze_queues(dev);
 				dev->netdev_ops->ndo_tx_timeout(dev, i);
 				netif_unfreeze_queues(dev);
-- 
2.25.1

