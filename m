Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190F1404689
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 09:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhIIHuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 03:50:44 -0400
Received: from mx419.baidu.com ([119.249.100.227]:37987 "EHLO mx421.baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229492AbhIIHum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 03:50:42 -0400
Received: from bjhw-sys-rpm015653cc5.bjhw.baidu.com (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by mx421.baidu.com (Postfix) with ESMTP id 8A0882F010DD;
        Thu,  9 Sep 2021 15:49:31 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by bjhw-sys-rpm015653cc5.bjhw.baidu.com (Postfix) with ESMTP id 8118FD9932;
        Thu,  9 Sep 2021 15:49:31 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, mst@redhat.com
Subject: [PATCH][net-next][v2] virtio_net: s/raw_smp_processor_id/smp_processor_id/ in virtnet_xdp_get_sq
Date:   Thu,  9 Sep 2021 15:49:31 +0800
Message-Id: <1631173771-43848-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtnet_xdp_get_sq() is called in non-preemptible context, so
it's safe to call the function smp_processor_id(), and keep
smp_processor_id(), and remove the calling of raw_smp_processor_id(),
this way we'll get a warning if this is ever called in a preemptible
context in the future

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v1: change log based on Michael S. Tsirkin's suggestion

 drivers/net/virtio_net.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2e42210..2a7b368 100644
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
1.7.1

