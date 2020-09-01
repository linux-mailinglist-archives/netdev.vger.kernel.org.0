Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB262584F7
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 02:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgIAA7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 20:59:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44932 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbgIAA7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 20:59:02 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 740091D2606C0AE80B4C;
        Tue,  1 Sep 2020 08:58:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 1 Sep 2020 08:58:51 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc
Date:   Tue, 1 Sep 2020 08:55:18 +0800
Message-ID: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there is concurrent reset and enqueue operation for the
same lockless qdisc when there is no lock to synchronize the
q->enqueue() in __dev_xmit_skb() with the qdisc reset operation in
qdisc_deactivate() called by dev_deactivate_queue(), which may cause
out-of-bounds access for priv->ring[] in hns3 driver if user has
requested a smaller queue num when __dev_xmit_skb() still enqueue a
skb with a larger queue_mapping after the corresponding qdisc is
reset, and call hns3_nic_net_xmit() with that skb later.

Avoid the above concurrent op by calling synchronize_rcu_tasks()
after assigning new qdisc to dev_queue->qdisc and before calling
qdisc_deactivate() to make sure skb with larger queue_mapping
enqueued to old qdisc will always be reset when qdisc_deactivate()
is called.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/sched/sch_generic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 265a61d..6e42237 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1160,8 +1160,13 @@ static void dev_deactivate_queue(struct net_device *dev,
 
 	qdisc = rtnl_dereference(dev_queue->qdisc);
 	if (qdisc) {
-		qdisc_deactivate(qdisc);
 		rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
+
+		/* Make sure lockless qdisc enqueuing is done with the
+		 * old qdisc in __dev_xmit_skb().
+		 */
+		synchronize_rcu_tasks();
+		qdisc_deactivate(qdisc);
 	}
 }
 
-- 
2.8.1

