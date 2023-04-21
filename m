Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0949F6EA5CB
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 10:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjDUI01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 04:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjDUI00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 04:26:26 -0400
Received: from out-23.mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7956455B2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:26:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682065582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SHe/jzCqewm2DDzl3v2vI3vnMZWQOaTgzDjtGP1hSHE=;
        b=KC+8xr4DqFayZ9uHezyBxBEJRGhGyHjWU0OIUIuzxlBD+1em15tVTQ39Moa4Ow837/YDR7
        f5DdKiZiL4S8ASSZTLXT9RZjW5duqYpTvKtqPJ7N//SZiQe9/iiWwY50u0W4AJgccc4sKZ
        gKAeURTkRp03G56RuSy9CVsqq2MYvDY=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] net: sched: Print msecs when transmit queue time out
Date:   Fri, 21 Apr 2023 16:26:06 +0800
Message-Id: <20230421082606.551411-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel will print several warnings in a short period of time
when it stalls. Like this:

First warning:
[ 7100.097547] ------------[ cut here ]------------
[ 7100.097550] NETDEV WATCHDOG: eno2 (xxx): transmit queue 8 timed out
[ 7100.097571] WARNING: CPU: 8 PID: 0 at net/sched/sch_generic.c:467
                       dev_watchdog+0x260/0x270
...

Second warning:
[ 7147.756952] rcu: INFO: rcu_preempt self-detected stall on CPU
[ 7147.756958] rcu:   24-....: (59999 ticks this GP) idle=546/1/0x400000000000000
                      softirq=367      3137/3673146 fqs=13844
[ 7147.756960]        (t=60001 jiffies g=4322709 q=133381)
[ 7147.756962] NMI backtrace for cpu 24
...

We calculate that the transmit queue start stall should occur before
7095s according to watchdog_timeo, the rcu start stall at 7087s.
These two times are close together, it is difficult to confirm which
happened first.

To let users know the exact time the stall started, print msecs when
the transmit queue time out.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/sched/sch_generic.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a9aadc4e6858..37e41f972f69 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -502,7 +502,7 @@ static void dev_watchdog(struct timer_list *t)
 		if (netif_device_present(dev) &&
 		    netif_running(dev) &&
 		    netif_carrier_ok(dev)) {
-			int some_queue_timedout = 0;
+			unsigned int timedout_ms = 0;
 			unsigned int i;
 			unsigned long trans_start;
 
@@ -514,16 +514,16 @@ static void dev_watchdog(struct timer_list *t)
 				if (netif_xmit_stopped(txq) &&
 				    time_after(jiffies, (trans_start +
 							 dev->watchdog_timeo))) {
-					some_queue_timedout = 1;
+					timedout_ms = jiffies_to_msecs(jiffies - trans_start);
 					atomic_long_inc(&txq->trans_timeout);
 					break;
 				}
 			}
 
-			if (unlikely(some_queue_timedout)) {
+			if (unlikely(timedout_ms)) {
 				trace_net_dev_xmit_timeout(dev, i);
-				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
-				       dev->name, netdev_drivername(dev), i);
+				WARN_ONCE(1, "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out %u ms\n",
+					  dev->name, netdev_drivername(dev), i, timedout_ms);
 				netif_freeze_queues(dev);
 				dev->netdev_ops->ndo_tx_timeout(dev, i);
 				netif_unfreeze_queues(dev);
-- 
2.25.1

