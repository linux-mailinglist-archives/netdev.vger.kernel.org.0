Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28CC1088D0
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 07:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfKYGzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 01:55:51 -0500
Received: from out1.zte.com.cn ([202.103.147.172]:62792 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfKYGzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 01:55:51 -0500
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id C52E119180CE6A9A69DF;
        Mon, 25 Nov 2019 14:55:45 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notes_smtp.zte.com.cn [10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id xAP6tSDA049700;
        Mon, 25 Nov 2019 14:55:28 +0800 (GMT-8)
        (envelope-from dong.menglong@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019112514553215-735049 ;
          Mon, 25 Nov 2019 14:55:32 +0800 
From:   Menglong Dong <dong.menglong@zte.com.cn>
To:     davem@davemloft.net
Cc:     petrm@mellanox.com, jiri@mellanox.com, gustavo@embeddedor.com,
        liuhangbin@gmail.com, ap420073@gmail.com, jwi@linux.ibm.com,
        mcroce@redhat.com, tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, jiang.xuexin@zte.com.cn,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] macvlan.c: schedule port->bc_work even if error
Date:   Mon, 25 Nov 2019 14:59:03 +0800
Message-Id: <1574665143-21650-1-git-send-email-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-11-25 14:55:32,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-11-25 14:55:29,
        Serialize complete at 2019-11-25 14:55:29
X-MAIL: mse-fl2.zte.com.cn xAP6tSDA049700
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While enqueueing a broadcast skb to port->bc_queue, schedule_work()
is called to add port->bc_work, which processes the skbs in
bc_queue, to "events" work queue. If port->bc_queue is full, the
skb will be discarded and schedule_work(&port->bc_work) won't be
called. However, if port->bc_queue is full and port->bc_work is not
running or pending, port->bc_queue will keep full and schedule_work()
won't be called any more, and all broadcast skbs to macvlan will be
discarded. This case can happen:

macvlan_process_broadcast() is the pending function of port->bc_work,
it moves all the skbs in port->bc_queue to the queue "list", and
processes the skbs in "list". During this, new skbs will keep being
added to port->bc_queue in macvlan_broadcast_enqueue(), and
port->bc_queue may already full when macvlan_process_broadcast()
return. This may happen, especially when there are a lot of real-time
threads and the process is preempted.

Fix this by calling schedule_work(&port->bc_work) even if
port->bc_work is full in macvlan_broadcast_enqueue()

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 drivers/net/macvlan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 940192c..ef2c4f7 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -359,10 +359,11 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 	}
 	spin_unlock(&port->bc_queue.lock);
 
+	schedule_work(&port->bc_work);
+
 	if (err)
 		goto free_nskb;
-
-	schedule_work(&port->bc_work);
+
 	return;
 
 free_nskb:
-- 
2.11.0

