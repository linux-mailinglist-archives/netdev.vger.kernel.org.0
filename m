Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95525108A8F
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 10:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfKYJLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 04:11:53 -0500
Received: from mxhk.zte.com.cn ([63.217.80.70]:63590 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbfKYJLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 04:11:52 -0500
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id B92A2C55371D29A7F4C3;
        Mon, 25 Nov 2019 17:11:48 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notessmtp.zte.com.cn [10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id xAP8sTwk082701;
        Mon, 25 Nov 2019 16:54:29 +0800 (GMT-8)
        (envelope-from dong.menglong@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019112516543386-738004 ;
          Mon, 25 Nov 2019 16:54:33 +0800 
From:   Menglong Dong <dong.menglong@zte.com.cn>
To:     davem@davemloft.net
Cc:     petrm@mellanox.com, jiri@mellanox.com, gustavo@embeddedor.com,
        liuhangbin@gmail.com, ap420073@gmail.com, jwi@linux.ibm.com,
        mcroce@redhat.com, tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, jiang.xuexin@zte.com.cn,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH v2] macvlan: schedule bc_work even if error
Date:   Mon, 25 Nov 2019 16:58:09 +0800
Message-Id: <1574672289-26255-1-git-send-email-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-11-25 16:54:33,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-11-25 16:54:30,
        Serialize complete at 2019-11-25 16:54:30
X-MAIL: mse-fl1.zte.com.cn xAP8sTwk082701
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
port->bc_work is full in macvlan_broadcast_enqueue().

Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
changes:
v2:
- change "macvlan.c" to "macvlan" in Subject line.
- add "Fixs: 412ca1550cbe".
---
 drivers/net/macvlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 940192c..16b86fa 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -359,10 +359,11 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 	}
 	spin_unlock(&port->bc_queue.lock);
 
+	schedule_work(&port->bc_work);
+
 	if (err)
 		goto free_nskb;
 
-	schedule_work(&port->bc_work);
 	return;
 
 free_nskb:
-- 
2.11.0

