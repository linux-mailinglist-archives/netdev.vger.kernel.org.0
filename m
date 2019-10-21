Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86600DE3BE
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfJUFbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:31:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:50124 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725926AbfJUFbJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 01:31:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AAF56AD63;
        Mon, 21 Oct 2019 05:31:07 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] xen/netback: cleanup init and deinit code
Date:   Mon, 21 Oct 2019 07:30:52 +0200
Message-Id: <20191021053052.31690-1-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do some cleanup of the netback init and deinit code:

- add an omnipotent queue deinit function usable from
  xenvif_disconnect_data() and the error path of xenvif_connect_data()
- only install the irq handlers after initializing all relevant items
  (especially the kthreads related to the queue)
- there is no need to use get_task_struct() after creating a kthread
  and using put_task_struct() again after having stopped it.
- use kthread_run() instead of kthread_create() to spare the call of
  wake_up_process().

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Paul Durrant <pdurrant@gmail.com>
---
 drivers/net/xen-netback/interface.c | 114 +++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 60 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 103ed00775eb..68dd7bb07ca6 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -626,6 +626,38 @@ int xenvif_connect_ctrl(struct xenvif *vif, grant_ref_t ring_ref,
 	return err;
 }
 
+static void xenvif_disconnect_queue(struct xenvif_queue *queue)
+{
+	if (queue->tx_irq) {
+		unbind_from_irqhandler(queue->tx_irq, queue);
+		if (queue->tx_irq == queue->rx_irq)
+			queue->rx_irq = 0;
+		queue->tx_irq = 0;
+	}
+
+	if (queue->rx_irq) {
+		unbind_from_irqhandler(queue->rx_irq, queue);
+		queue->rx_irq = 0;
+	}
+
+	if (queue->task) {
+		kthread_stop(queue->task);
+		queue->task = NULL;
+	}
+
+	if (queue->dealloc_task) {
+		kthread_stop(queue->dealloc_task);
+		queue->dealloc_task = NULL;
+	}
+
+	if (queue->napi.poll) {
+		netif_napi_del(&queue->napi);
+		queue->napi.poll = NULL;
+	}
+
+	xenvif_unmap_frontend_data_rings(queue);
+}
+
 int xenvif_connect_data(struct xenvif_queue *queue,
 			unsigned long tx_ring_ref,
 			unsigned long rx_ring_ref,
@@ -651,13 +683,27 @@ int xenvif_connect_data(struct xenvif_queue *queue,
 	netif_napi_add(queue->vif->dev, &queue->napi, xenvif_poll,
 			XENVIF_NAPI_WEIGHT);
 
+	queue->stalled = true;
+
+	task = kthread_run(xenvif_kthread_guest_rx, queue,
+			   "%s-guest-rx", queue->name);
+	if (IS_ERR(task))
+		goto kthread_err;
+	queue->task = task;
+
+	task = kthread_run(xenvif_dealloc_kthread, queue,
+			   "%s-dealloc", queue->name);
+	if (IS_ERR(task))
+		goto kthread_err;
+	queue->dealloc_task = task;
+
 	if (tx_evtchn == rx_evtchn) {
 		/* feature-split-event-channels == 0 */
 		err = bind_interdomain_evtchn_to_irqhandler(
 			queue->vif->domid, tx_evtchn, xenvif_interrupt, 0,
 			queue->name, queue);
 		if (err < 0)
-			goto err_unmap;
+			goto err;
 		queue->tx_irq = queue->rx_irq = err;
 		disable_irq(queue->tx_irq);
 	} else {
@@ -668,7 +714,7 @@ int xenvif_connect_data(struct xenvif_queue *queue,
 			queue->vif->domid, tx_evtchn, xenvif_tx_interrupt, 0,
 			queue->tx_irq_name, queue);
 		if (err < 0)
-			goto err_unmap;
+			goto err;
 		queue->tx_irq = err;
 		disable_irq(queue->tx_irq);
 
@@ -678,47 +724,18 @@ int xenvif_connect_data(struct xenvif_queue *queue,
 			queue->vif->domid, rx_evtchn, xenvif_rx_interrupt, 0,
 			queue->rx_irq_name, queue);
 		if (err < 0)
-			goto err_tx_unbind;
+			goto err;
 		queue->rx_irq = err;
 		disable_irq(queue->rx_irq);
 	}
 
-	queue->stalled = true;
-
-	task = kthread_create(xenvif_kthread_guest_rx,
-			      (void *)queue, "%s-guest-rx", queue->name);
-	if (IS_ERR(task)) {
-		pr_warn("Could not allocate kthread for %s\n", queue->name);
-		err = PTR_ERR(task);
-		goto err_rx_unbind;
-	}
-	queue->task = task;
-	get_task_struct(task);
-
-	task = kthread_create(xenvif_dealloc_kthread,
-			      (void *)queue, "%s-dealloc", queue->name);
-	if (IS_ERR(task)) {
-		pr_warn("Could not allocate kthread for %s\n", queue->name);
-		err = PTR_ERR(task);
-		goto err_rx_unbind;
-	}
-	queue->dealloc_task = task;
-
-	wake_up_process(queue->task);
-	wake_up_process(queue->dealloc_task);
-
 	return 0;
 
-err_rx_unbind:
-	unbind_from_irqhandler(queue->rx_irq, queue);
-	queue->rx_irq = 0;
-err_tx_unbind:
-	unbind_from_irqhandler(queue->tx_irq, queue);
-	queue->tx_irq = 0;
-err_unmap:
-	xenvif_unmap_frontend_data_rings(queue);
-	netif_napi_del(&queue->napi);
+kthread_err:
+	pr_warn("Could not allocate kthread for %s\n", queue->name);
+	err = PTR_ERR(task);
 err:
+	xenvif_disconnect_queue(queue);
 	return err;
 }
 
@@ -746,30 +763,7 @@ void xenvif_disconnect_data(struct xenvif *vif)
 	for (queue_index = 0; queue_index < num_queues; ++queue_index) {
 		queue = &vif->queues[queue_index];
 
-		netif_napi_del(&queue->napi);
-
-		if (queue->task) {
-			kthread_stop(queue->task);
-			put_task_struct(queue->task);
-			queue->task = NULL;
-		}
-
-		if (queue->dealloc_task) {
-			kthread_stop(queue->dealloc_task);
-			queue->dealloc_task = NULL;
-		}
-
-		if (queue->tx_irq) {
-			if (queue->tx_irq == queue->rx_irq)
-				unbind_from_irqhandler(queue->tx_irq, queue);
-			else {
-				unbind_from_irqhandler(queue->tx_irq, queue);
-				unbind_from_irqhandler(queue->rx_irq, queue);
-			}
-			queue->tx_irq = 0;
-		}
-
-		xenvif_unmap_frontend_data_rings(queue);
+		xenvif_disconnect_queue(queue);
 	}
 
 	xenvif_mcast_addr_list_free(vif);
-- 
2.16.4

