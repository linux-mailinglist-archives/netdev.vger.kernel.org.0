Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA6F58F90
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 03:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfF1BOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 21:14:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52498 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726605AbfF1BOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 21:14:41 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D1238800C514BC90051C;
        Fri, 28 Jun 2019 09:14:38 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Jun 2019 09:14:35 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>
CC:     <hkallweit1@gmail.com>, <gregkh@linuxfoundation.org>,
        <tglx@linutronix.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <rkrcmar@redhat.com>, <kvm@vger.kernel.org>
Subject: [PATCH v3 net-next] net: link_watch: prevent starvation when processing linkwatch wq
Date:   Fri, 28 Jun 2019 09:13:19 +0800
Message-ID: <1561684399-235123-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user has configured a large number of virtual netdev, such
as 4K vlans, the carrier on/off operation of the real netdev
will also cause it's virtual netdev's link state to be processed
in linkwatch. Currently, the processing is done in a work queue,
which may cause rtnl locking starvation problem and worker
starvation problem for other work queue, such as irqfd_inject wq.

This patch releases the cpu when link watch worker has processed
a fixed number of netdev' link watch event, and schedule the
work queue again when there is still link watch event remaining.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
V2: use cond_resched and rtnl_unlock after processing a fixed
    number of events
V3: fall back to v1 and change commit log to reflect that.
---
---
 net/core/link_watch.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 04fdc95..f153e06 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -163,9 +163,16 @@ static void linkwatch_do_dev(struct net_device *dev)
 
 static void __linkwatch_run_queue(int urgent_only)
 {
+#define MAX_DO_DEV_PER_LOOP	100
+
+	int do_dev = MAX_DO_DEV_PER_LOOP;
 	struct net_device *dev;
 	LIST_HEAD(wrk);
 
+	/* Give urgent case more budget */
+	if (urgent_only)
+		do_dev += MAX_DO_DEV_PER_LOOP;
+
 	/*
 	 * Limit the number of linkwatch events to one
 	 * per second so that a runaway driver does not
@@ -184,7 +191,7 @@ static void __linkwatch_run_queue(int urgent_only)
 	spin_lock_irq(&lweventlist_lock);
 	list_splice_init(&lweventlist, &wrk);
 
-	while (!list_empty(&wrk)) {
+	while (!list_empty(&wrk) && do_dev > 0) {
 
 		dev = list_first_entry(&wrk, struct net_device, link_watch_list);
 		list_del_init(&dev->link_watch_list);
@@ -195,9 +202,13 @@ static void __linkwatch_run_queue(int urgent_only)
 		}
 		spin_unlock_irq(&lweventlist_lock);
 		linkwatch_do_dev(dev);
+		do_dev--;
 		spin_lock_irq(&lweventlist_lock);
 	}
 
+	/* Add the remaining work back to lweventlist */
+	list_splice_init(&wrk, &lweventlist);
+
 	if (!list_empty(&lweventlist))
 		linkwatch_schedule_work(0);
 	spin_unlock_irq(&lweventlist_lock);
-- 
2.8.1

