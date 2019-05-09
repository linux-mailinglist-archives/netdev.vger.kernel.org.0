Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C67218411
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 05:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfEIDU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 23:20:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfEIDUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 23:20:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 69F688665F;
        Thu,  9 May 2019 03:20:25 +0000 (UTC)
Received: from hp-dl380pg8-02.lab.eng.pek2.redhat.com (hp-dl380pg8-02.lab.eng.pek2.redhat.com [10.73.8.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48A355C221;
        Thu,  9 May 2019 03:20:23 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yuehaibing@huawei.com, xiyou.wangcong@gmail.com,
        weiyongjun1@huawei.com, eric.dumazet@gmail.com,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH net V3 2/2] tuntap: synchronize through tfiles array instead of tun->numqueues
Date:   Wed,  8 May 2019 23:20:18 -0400
Message-Id: <1557372018-18544-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1557372018-18544-1-git-send-email-jasowang@redhat.com>
References: <1557372018-18544-1-git-send-email-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 09 May 2019 03:20:25 +0000 (UTC)
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
Changes from V2:
- resample during detach in tun_xdp_xmit()
Changes from V1:
- keep the check in tun_xdp_xmit()
---
 drivers/net/tun.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index dc62fc3..f4c933a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -705,6 +705,8 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 				   tun->tfiles[tun->numqueues - 1]);
 		ntfile = rtnl_dereference(tun->tfiles[index]);
 		ntfile->queue_index = index;
+		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
+				   NULL);
 
 		--tun->numqueues;
 		if (clean) {
@@ -1087,7 +1089,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	tfile = rcu_dereference(tun->tfiles[txq]);
 
 	/* Drop packet if interface is not attached */
-	if (txq >= tun->numqueues)
+	if (!tfile)
 		goto drop;
 
 	if (!rcu_dereference(tun->steering_prog))
@@ -1310,6 +1312,7 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
 
 	rcu_read_lock();
 
+resample:
 	numqueues = READ_ONCE(tun->numqueues);
 	if (!numqueues) {
 		rcu_read_unlock();
@@ -1318,6 +1321,8 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
 
 	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
 					    numqueues]);
+	if (unlikely(!tfile))
+		goto resample;
 
 	spin_lock(&tfile->tx_ring.producer_lock);
 	for (i = 0; i < n; i++) {
-- 
1.8.3.1

