Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB5A5A2370
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245298AbiHZIpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245175AbiHZIpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:45:22 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F4D402E7;
        Fri, 26 Aug 2022 01:45:20 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MDYFl0rS9zYcnb;
        Fri, 26 Aug 2022 16:40:59 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 26 Aug 2022 16:45:18 +0800
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 26 Aug
 2022 16:45:17 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <kuba@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>, <brouer@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] net/sched: fix netdevice reference leaks in attach_default_qdiscs()
Date:   Fri, 26 Aug 2022 17:00:55 +0800
Message-ID: <20220826090055.24424-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In attach_default_qdiscs(), if a dev has multiple queues and queue 0 fails
to attach qdisc because there is no memory in attach_one_default_qdisc().
Then dev->qdisc will be noop_qdisc by default. But the other queues may be
able to successfully attach to default qdisc.

In this case, the fallback to noqueue process will be triggered. If the
original attached qdisc is not released and a new one is directly
attached, this will cause netdevice reference leaks.

The following is the bug log:

veth0: default qdisc (fq_codel) fail, fallback to noqueue
unregister_netdevice: waiting for veth0 to become free. Usage count = 32
leaked reference.
 qdisc_alloc+0x12e/0x210
 qdisc_create_dflt+0x62/0x140
 attach_one_default_qdisc.constprop.41+0x44/0x70
 dev_activate+0x128/0x290
 __dev_open+0x12a/0x190
 __dev_change_flags+0x1a2/0x1f0
 dev_change_flags+0x23/0x60
 do_setlink+0x332/0x1150
 __rtnl_newlink+0x52f/0x8e0
 rtnl_newlink+0x43/0x70
 rtnetlink_rcv_msg+0x140/0x3b0
 netlink_rcv_skb+0x50/0x100
 netlink_unicast+0x1bb/0x290
 netlink_sendmsg+0x37c/0x4e0
 sock_sendmsg+0x5f/0x70
 ____sys_sendmsg+0x208/0x280

Fix this bug by clearing any non-noop qdiscs that may have been assigned
before trying to re-attach.

Fixes: bf6dba76d278 ("net: sched: fallback to qdisc noqueue if default qdisc setup fail")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
v1->v2: Clean up under the failed path to fix this bug.
 net/sched/sch_generic.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d47b9689eba6..f58a22945145 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1122,6 +1122,21 @@ struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
 }
 EXPORT_SYMBOL(dev_graft_qdisc);
 
+static void shutdown_scheduler_queue(struct net_device *dev,
+				     struct netdev_queue *dev_queue,
+				     void *_qdisc_default)
+{
+	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
+	struct Qdisc *qdisc_default = _qdisc_default;
+
+	if (qdisc) {
+		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
+		dev_queue->qdisc_sleeping = qdisc_default;
+
+		qdisc_put(qdisc);
+	}
+}
+
 static void attach_one_default_qdisc(struct net_device *dev,
 				     struct netdev_queue *dev_queue,
 				     void *_unused)
@@ -1169,6 +1184,7 @@ static void attach_default_qdiscs(struct net_device *dev)
 	if (qdisc == &noop_qdisc) {
 		netdev_warn(dev, "default qdisc (%s) fail, fallback to %s\n",
 			    default_qdisc_ops->id, noqueue_qdisc_ops.id);
+		netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
 		dev->priv_flags |= IFF_NO_QUEUE;
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
 		qdisc = txq->qdisc_sleeping;
@@ -1447,21 +1463,6 @@ void dev_init_scheduler(struct net_device *dev)
 	timer_setup(&dev->watchdog_timer, dev_watchdog, 0);
 }
 
-static void shutdown_scheduler_queue(struct net_device *dev,
-				     struct netdev_queue *dev_queue,
-				     void *_qdisc_default)
-{
-	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
-	struct Qdisc *qdisc_default = _qdisc_default;
-
-	if (qdisc) {
-		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
-		dev_queue->qdisc_sleeping = qdisc_default;
-
-		qdisc_put(qdisc);
-	}
-}
-
 void dev_shutdown(struct net_device *dev)
 {
 	netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
-- 
2.17.1

