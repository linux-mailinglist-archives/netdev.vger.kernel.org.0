Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0667049F379
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346329AbiA1GWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:22:48 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:35880 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiA1GWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:22:47 -0500
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JlS6B3261zcZxc;
        Fri, 28 Jan 2022 14:21:54 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 28 Jan 2022 14:22:45 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <gregkh@linuxfoundation.org>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <davem@davemloft.net>,
        <stable@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
Subject: [PATCH 4.9] can: bcm: fix UAF of bcm op
Date:   Fri, 28 Jan 2022 14:40:54 +0800
Message-ID: <20220128064054.2434068-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stopping tasklet and hrtimer rely on the active state of tasklet and
hrtimer sequentially in bcm_remove_op(), the op object will be freed
if they are all unactive. Assume the hrtimer timeout is short, the
hrtimer cb has been excuted after tasklet conditional judgment which
must be false after last round tasklet_kill() and before condition
hrtimer_active(), it is false when execute to hrtimer_active(). Bug
is triggerd, because the stopping action is end and the op object
will be freed, but the tasklet is scheduled. The resources of the op
object will occur UAF bug.

Move hrtimer_cancel() behind tasklet_kill() and switch 'while () {...}'
to 'do {...} while ()' to fix the op UAF problem.

Fixes: a06393ed0316 ("can: bcm: fix hrtimer/tasklet termination in bcm op removal")
Reported-by: syzbot+5ca851459ed04c778d1d@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/bcm.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 369326715b9c..bfb507223468 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -761,21 +761,21 @@ static struct bcm_op *bcm_find_op(struct list_head *ops,
 static void bcm_remove_op(struct bcm_op *op)
 {
 	if (op->tsklet.func) {
-		while (test_bit(TASKLET_STATE_SCHED, &op->tsklet.state) ||
-		       test_bit(TASKLET_STATE_RUN, &op->tsklet.state) ||
-		       hrtimer_active(&op->timer)) {
-			hrtimer_cancel(&op->timer);
+		do {
 			tasklet_kill(&op->tsklet);
-		}
+			hrtimer_cancel(&op->timer);
+		} while (test_bit(TASKLET_STATE_SCHED, &op->tsklet.state) ||
+			 test_bit(TASKLET_STATE_RUN, &op->tsklet.state) ||
+			 hrtimer_active(&op->timer));
 	}
 
 	if (op->thrtsklet.func) {
-		while (test_bit(TASKLET_STATE_SCHED, &op->thrtsklet.state) ||
-		       test_bit(TASKLET_STATE_RUN, &op->thrtsklet.state) ||
-		       hrtimer_active(&op->thrtimer)) {
-			hrtimer_cancel(&op->thrtimer);
+		do {
 			tasklet_kill(&op->thrtsklet);
-		}
+			hrtimer_cancel(&op->thrtimer);
+		} while (test_bit(TASKLET_STATE_SCHED, &op->thrtsklet.state) ||
+			 test_bit(TASKLET_STATE_RUN, &op->thrtsklet.state) ||
+			 hrtimer_active(&op->thrtimer));
 	}
 
 	if ((op->frames) && (op->frames != &op->sframe))
-- 
2.25.1

