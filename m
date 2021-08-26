Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835EA3F83C3
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 10:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240498AbhHZIbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 04:31:51 -0400
Received: from mx433.baidu.com ([119.249.100.169]:26219 "EHLO mx423.baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236028AbhHZIbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 04:31:51 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Aug 2021 04:31:50 EDT
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx423.baidu.com (Postfix) with ESMTP id 575F216E0100E;
        Thu, 26 Aug 2021 16:21:35 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 4E9C1D9932;
        Thu, 26 Aug 2021 16:21:35 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio_net: reduce raw_smp_processor_id() calling in virtnet_xdp_get_sq
Date:   Thu, 26 Aug 2021 16:21:35 +0800
Message-Id: <1629966095-16341-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smp_processor_id()/raw* will be called once each when not
more queues in virtnet_xdp_get_sq() which is called in
non-preemptible context, so it's safe to call the function
smp_processor_id() once.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/virtio_net.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2e42210a6503..2a7b368c1da2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -528,19 +528,20 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
  * functions to perfectly solve these three problems at the same time.
  */
 #define virtnet_xdp_get_sq(vi) ({                                       \
+	int cpu = smp_processor_id();                                   \
 	struct netdev_queue *txq;                                       \
 	typeof(vi) v = (vi);                                            \
 	unsigned int qp;                                                \
 									\
 	if (v->curr_queue_pairs > nr_cpu_ids) {                         \
 		qp = v->curr_queue_pairs - v->xdp_queue_pairs;          \
-		qp += smp_processor_id();                               \
+		qp += cpu;                                              \
 		txq = netdev_get_tx_queue(v->dev, qp);                  \
 		__netif_tx_acquire(txq);                                \
 	} else {                                                        \
-		qp = smp_processor_id() % v->curr_queue_pairs;          \
+		qp = cpu % v->curr_queue_pairs;                         \
 		txq = netdev_get_tx_queue(v->dev, qp);                  \
-		__netif_tx_lock(txq, raw_smp_processor_id());           \
+		__netif_tx_lock(txq, cpu);                              \
 	}                                                               \
 	v->sq + qp;                                                     \
 })
-- 
2.33.0.69.gc420321.dirty

