Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F64C2ACD6
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 03:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfE0Bs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 21:48:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42436 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbfE0Bsz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 May 2019 21:48:55 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3BBB134096C981AB2BCB;
        Mon, 27 May 2019 09:48:52 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Mon, 27 May 2019 09:48:42 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>
CC:     <hkallweit1@gmail.com>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] net: link_watch: prevent starvation when processing linkwatch wq
Date:   Mon, 27 May 2019 09:47:54 +0800
Message-ID: <1558921674-158349-1-git-send-email-linyunsheng@huawei.com>
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
which may cause worker starvation problem for other work queue.

This patch releases the cpu when link watch worker has processed
a fixed number of netdev' link watch event, and schedule the
work queue again when there is still link watch event remaining.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/link_watch.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 7f51efb..06276ff 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -168,9 +168,16 @@ static void linkwatch_do_dev(struct net_device *dev)
 
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
@@ -189,7 +196,7 @@ static void __linkwatch_run_queue(int urgent_only)
 	spin_lock_irq(&lweventlist_lock);
 	list_splice_init(&lweventlist, &wrk);
 
-	while (!list_empty(&wrk)) {
+	while (!list_empty(&wrk) && do_dev > 0) {
 
 		dev = list_first_entry(&wrk, struct net_device, link_watch_list);
 		list_del_init(&dev->link_watch_list);
@@ -201,8 +208,13 @@ static void __linkwatch_run_queue(int urgent_only)
 		spin_unlock_irq(&lweventlist_lock);
 		linkwatch_do_dev(dev);
 		spin_lock_irq(&lweventlist_lock);
+
+		do_dev--;
 	}
 
+	/* Add the remaining work back to lweventlist */
+	list_splice_init(&wrk, &lweventlist);
+
 	if (!list_empty(&lweventlist))
 		linkwatch_schedule_work(0);
 	spin_unlock_irq(&lweventlist_lock);
-- 
2.8.1

