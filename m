Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B0E15842
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 06:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbfEGEDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 00:03:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbfEGEDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 00:03:43 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04AF481F25;
        Tue,  7 May 2019 04:03:43 +0000 (UTC)
Received: from hp-dl380pg8-02.lab.eng.pek2.redhat.com (hp-dl380pg8-02.lab.eng.pek2.redhat.com [10.73.8.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E9A81A4D9;
        Tue,  7 May 2019 04:03:38 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mst@redhat.com, Jason Wang <jasowang@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net V2] tuntap: synchronize through tfiles array instead of tun->numqueues
Date:   Tue,  7 May 2019 00:03:36 -0400
Message-Id: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 07 May 2019 04:03:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a queue(tfile) is detached through __tun_detach(), we move the
last enabled tfile to the position where detached one sit but don't
NULL out last position. We expect to synchronize the datapath through
tun->numqueues. Unfortunately, this won't work since we're lacking
sufficient mechanism to order or synchronize the access to
tun->numqueues.

To fix this, NULL out the last position during detaching and check
RCU protected tfile against NULL instead of checking tun->numqueues in
datapath.

Cc: YueHaibing <yuehaibing@huawei.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: weiyongjun (A) <weiyongjun1@huawei.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: c8d68e6be1c3b ("tuntap: multiqueue support")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from V1:
- keep the check in tun_xdp_xmit()
---
 drivers/net/tun.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e9ca1c0..32a0b23 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -700,6 +700,8 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 				   tun->tfiles[tun->numqueues - 1]);
 		ntfile = rtnl_dereference(tun->tfiles[index]);
 		ntfile->queue_index = index;
+		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
+				   NULL);
 
 		--tun->numqueues;
 		if (clean) {
@@ -1082,7 +1084,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	tfile = rcu_dereference(tun->tfiles[txq]);
 
 	/* Drop packet if interface is not attached */
-	if (txq >= tun->numqueues)
+	if (!tfile)
 		goto drop;
 
 	if (!rcu_dereference(tun->steering_prog))
@@ -1313,6 +1315,10 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
 
 	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
 					    numqueues]);
+	if (!tfile) {
+		rcu_read_unlock();
+		return -ENXIO; /* Caller will free/return all frames */
+	}
 
 	spin_lock(&tfile->tx_ring.producer_lock);
 	for (i = 0; i < n; i++) {
-- 
1.8.3.1

