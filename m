Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A0530AF0
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfEaJBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:01:35 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18065 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfEaJBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 05:01:34 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 22DB7808011AFE2CD3FA;
        Fri, 31 May 2019 17:01:32 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 31 May 2019 17:01:25 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>
CC:     <hkallweit1@gmail.com>, <f.fainelli@gmail.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v2 net-next] net: link_watch: prevent starvation when processing linkwatch wq
Date:   Fri, 31 May 2019 17:00:33 +0800
Message-ID: <1559293233-43017-1-git-send-email-linyunsheng@huawei.com>
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
which may cause cpu and rtnl locking starvation problem.

This patch releases the cpu and rtnl lock when link watch worker
has processed a fixed number of netdev' link watch event.

Currently __linkwatch_run_queue is called with rtnl lock, so
enfore it with ASSERT_RTNL();

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
V2: use cond_resched and rtnl_unlock after processing a fixed
    number of events
---
 net/core/link_watch.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 7f51efb..07eebfb 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -168,9 +168,18 @@ static void linkwatch_do_dev(struct net_device *dev)
 
 static void __linkwatch_run_queue(int urgent_only)
 {
+#define MAX_DO_DEV_PER_LOOP	100
+
+	int do_dev = MAX_DO_DEV_PER_LOOP;
 	struct net_device *dev;
 	LIST_HEAD(wrk);
 
+	ASSERT_RTNL();
+
+	/* Give urgent case more budget */
+	if (urgent_only)
+		do_dev += MAX_DO_DEV_PER_LOOP;
+
 	/*
 	 * Limit the number of linkwatch events to one
 	 * per second so that a runaway driver does not
@@ -200,6 +209,14 @@ static void __linkwatch_run_queue(int urgent_only)
 		}
 		spin_unlock_irq(&lweventlist_lock);
 		linkwatch_do_dev(dev);
+
+		if (--do_dev < 0) {
+			rtnl_unlock();
+			cond_resched();
+			do_dev = MAX_DO_DEV_PER_LOOP;
+			rtnl_lock();
+		}
+
 		spin_lock_irq(&lweventlist_lock);
 	}
 
-- 
2.8.1

