Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155961B38AB
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 09:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgDVHRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 03:17:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2867 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725786AbgDVHRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 03:17:22 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C87CA4BAF0B0A7AC6E70;
        Wed, 22 Apr 2020 15:17:13 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 22 Apr 2020
 15:17:07 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <yanaijie@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: caif: use true,false for bool variables
Date:   Wed, 22 Apr 2020 15:16:36 +0800
Message-ID: <20200422071636.48356-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

net/caif/caif_dev.c:410:2-13: WARNING: Assignment of 0/1 to bool
variable
net/caif/caif_dev.c:445:2-13: WARNING: Assignment of 0/1 to bool
variable
net/caif/caif_dev.c:145:1-12: WARNING: Assignment of 0/1 to bool
variable
net/caif/caif_dev.c:223:1-12: WARNING: Assignment of 0/1 to bool
variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 net/caif/caif_dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index 195d2d67be8a..c10e5a55758d 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -142,7 +142,7 @@ static void caif_flow_cb(struct sk_buff *skb)
 
 	spin_lock_bh(&caifd->flow_lock);
 	send_xoff = caifd->xoff;
-	caifd->xoff = 0;
+	caifd->xoff = false;
 	dtor = caifd->xoff_skb_dtor;
 
 	if (WARN_ON(caifd->xoff_skb != skb))
@@ -220,7 +220,7 @@ static int transmit(struct cflayer *layer, struct cfpkt *pkt)
 	pr_debug("queue has stopped(%d) or is full (%d > %d)\n",
 			netif_queue_stopped(caifd->netdev),
 			qlen, high);
-	caifd->xoff = 1;
+	caifd->xoff = true;
 	caifd->xoff_skb = skb;
 	caifd->xoff_skb_dtor = skb->destructor;
 	skb->destructor = caif_flow_cb;
@@ -407,7 +407,7 @@ static int caif_device_notify(struct notifier_block *me, unsigned long what,
 			break;
 		}
 
-		caifd->xoff = 0;
+		caifd->xoff = false;
 		cfcnfg_set_phy_state(cfg, &caifd->layer, true);
 		rcu_read_unlock();
 
@@ -442,7 +442,7 @@ static int caif_device_notify(struct notifier_block *me, unsigned long what,
 		if (caifd->xoff_skb_dtor != NULL && caifd->xoff_skb != NULL)
 			caifd->xoff_skb->destructor = caifd->xoff_skb_dtor;
 
-		caifd->xoff = 0;
+		caifd->xoff = false;
 		caifd->xoff_skb_dtor = NULL;
 		caifd->xoff_skb = NULL;
 
-- 
2.21.1

