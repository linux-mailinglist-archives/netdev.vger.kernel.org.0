Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68206C033D
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfI0KPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:15:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:57916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727729AbfI0KPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:15:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B69F7AF92;
        Fri, 27 Sep 2019 10:15:44 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/17] staging: qlge: Refill empty buffer queues from wq
Date:   Fri, 27 Sep 2019 19:12:11 +0900
Message-Id: <20190927101210.23856-18-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When operating at mtu 9000, qlge does order-1 allocations for rx buffers in
atomic context. This is especially unreliable when free memory is low or
fragmented. Add an approach similar to commit 3161e453e496 ("virtio: net
refill on out-of-memory") to qlge so that the device doesn't lock up if
there are allocation failures.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/staging/qlge/TODO        |  3 --
 drivers/staging/qlge/qlge.h      |  8 ++++
 drivers/staging/qlge/qlge_main.c | 80 +++++++++++++++++++++++++-------
 3 files changed, 72 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index 51c509084e80..f93f7428f5d5 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -1,6 +1,3 @@
-* reception stalls permanently (until admin intervention) if the rx buffer
-  queues become empty because of allocation failures (ex. under memory
-  pressure)
 * commit 7c734359d350 ("qlge: Size RX buffers based on MTU.", v2.6.33-rc1)
   introduced dead code in the receive routines, which should be rewritten
   anyways by the admission of the author himself, see the comment above
diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index e5a352df8228..6ec7e3ce3863 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1452,6 +1452,13 @@ struct qlge_bq {
 
 #define QLGE_BQ_WRAP(index) ((index) & (QLGE_BQ_LEN - 1))
 
+#define QLGE_BQ_HW_OWNED(bq) \
+({ \
+	typeof(bq) _bq = bq; \
+	QLGE_BQ_WRAP(QLGE_BQ_ALIGN((_bq)->next_to_use) - \
+		     (_bq)->next_to_clean); \
+})
+
 struct rx_ring {
 	struct cqicb cqicb;	/* The chip's completion queue init control block. */
 
@@ -1479,6 +1486,7 @@ struct rx_ring {
 	/* Misc. handler elements. */
 	u32 irq;		/* Which vector this ring is assigned. */
 	u32 cpu;		/* Which CPU this should run on. */
+	struct delayed_work refill_work;
 	char name[IFNAMSIZ + 5];
 	struct napi_struct napi;
 	u8 reserved;
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 02ad0cdf4856..0c381d91faa6 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1029,7 +1029,7 @@ static const char * const bq_type_name[] = {
 
 /* return 0 or negative error */
 static int qlge_refill_sb(struct rx_ring *rx_ring,
-			  struct qlge_bq_desc *sbq_desc)
+			  struct qlge_bq_desc *sbq_desc, gfp_t gfp)
 {
 	struct ql_adapter *qdev = rx_ring->qdev;
 	struct sk_buff *skb;
@@ -1041,7 +1041,7 @@ static int qlge_refill_sb(struct rx_ring *rx_ring,
 		     "ring %u sbq: getting new skb for index %d.\n",
 		     rx_ring->cq_id, sbq_desc->index);
 
-	skb = netdev_alloc_skb(qdev->ndev, SMALL_BUFFER_SIZE);
+	skb = __netdev_alloc_skb(qdev->ndev, SMALL_BUFFER_SIZE, gfp);
 	if (!skb)
 		return -ENOMEM;
 	skb_reserve(skb, QLGE_SB_PAD);
@@ -1062,7 +1062,7 @@ static int qlge_refill_sb(struct rx_ring *rx_ring,
 
 /* return 0 or negative error */
 static int qlge_refill_lb(struct rx_ring *rx_ring,
-			  struct qlge_bq_desc *lbq_desc)
+			  struct qlge_bq_desc *lbq_desc, gfp_t gfp)
 {
 	struct ql_adapter *qdev = rx_ring->qdev;
 	struct qlge_page_chunk *master_chunk = &rx_ring->master_chunk;
@@ -1071,8 +1071,7 @@ static int qlge_refill_lb(struct rx_ring *rx_ring,
 		struct page *page;
 		dma_addr_t dma_addr;
 
-		page = alloc_pages(__GFP_COMP | GFP_ATOMIC,
-				   qdev->lbq_buf_order);
+		page = alloc_pages(gfp | __GFP_COMP, qdev->lbq_buf_order);
 		if (unlikely(!page))
 			return -ENOMEM;
 		dma_addr = pci_map_page(qdev->pdev, page, 0,
@@ -1109,33 +1108,33 @@ static int qlge_refill_lb(struct rx_ring *rx_ring,
 	return 0;
 }
 
-static void qlge_refill_bq(struct qlge_bq *bq)
+/* return 0 or negative error */
+static int qlge_refill_bq(struct qlge_bq *bq, gfp_t gfp)
 {
 	struct rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
 	struct ql_adapter *qdev = rx_ring->qdev;
 	struct qlge_bq_desc *bq_desc;
 	int refill_count;
+	int retval;
 	int i;
 
 	refill_count = QLGE_BQ_WRAP(QLGE_BQ_ALIGN(bq->next_to_clean - 1) -
 				    bq->next_to_use);
 	if (!refill_count)
-		return;
+		return 0;
 
 	i = bq->next_to_use;
 	bq_desc = &bq->queue[i];
 	i -= QLGE_BQ_LEN;
 	do {
-		int retval;
-
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 			     "ring %u %s: try cleaning idx %d\n",
 			     rx_ring->cq_id, bq_type_name[bq->type], i);
 
 		if (bq->type == QLGE_SB)
-			retval = qlge_refill_sb(rx_ring, bq_desc);
+			retval = qlge_refill_sb(rx_ring, bq_desc, gfp);
 		else
-			retval = qlge_refill_lb(rx_ring, bq_desc);
+			retval = qlge_refill_lb(rx_ring, bq_desc, gfp);
 		if (retval < 0) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "ring %u %s: Could not get a page chunk, idx %d\n",
@@ -1163,12 +1162,52 @@ static void qlge_refill_bq(struct qlge_bq *bq)
 		}
 		bq->next_to_use = i;
 	}
+
+	return retval;
+}
+
+static void ql_update_buffer_queues(struct rx_ring *rx_ring, gfp_t gfp,
+				    unsigned long delay)
+{
+	bool sbq_fail, lbq_fail;
+
+	sbq_fail = !!qlge_refill_bq(&rx_ring->sbq, gfp);
+	lbq_fail = !!qlge_refill_bq(&rx_ring->lbq, gfp);
+
+	/* Minimum number of buffers needed to be able to receive at least one
+	 * frame of any format:
+	 * sbq: 1 for header + 1 for data
+	 * lbq: mtu 9000 / lb size
+	 * Below this, the queue might stall.
+	 */
+	if ((sbq_fail && QLGE_BQ_HW_OWNED(&rx_ring->sbq) < 2) ||
+	    (lbq_fail && QLGE_BQ_HW_OWNED(&rx_ring->lbq) <
+	     DIV_ROUND_UP(9000, LARGE_BUFFER_MAX_SIZE)))
+		/* Allocations can take a long time in certain cases (ex.
+		 * reclaim). Therefore, use a workqueue for long-running
+		 * work items.
+		 */
+		queue_delayed_work_on(smp_processor_id(), system_long_wq,
+				      &rx_ring->refill_work, delay);
 }
 
-static void ql_update_buffer_queues(struct rx_ring *rx_ring)
+static void qlge_slow_refill(struct work_struct *work)
 {
-	qlge_refill_bq(&rx_ring->sbq);
-	qlge_refill_bq(&rx_ring->lbq);
+	struct rx_ring *rx_ring = container_of(work, struct rx_ring,
+					       refill_work.work);
+	struct napi_struct *napi = &rx_ring->napi;
+
+	napi_disable(napi);
+	ql_update_buffer_queues(rx_ring, GFP_KERNEL, HZ / 2);
+	napi_enable(napi);
+
+	local_bh_disable();
+	/* napi_disable() might have prevented incomplete napi work from being
+	 * rescheduled.
+	 */
+	napi_schedule(napi);
+	/* trigger softirq processing */
+	local_bh_enable();
 }
 
 /* Unmaps tx buffers.  Can be called from send() if a pci mapping
@@ -2168,7 +2207,7 @@ static int ql_clean_inbound_rx_ring(struct rx_ring *rx_ring, int budget)
 		if (count == budget)
 			break;
 	}
-	ql_update_buffer_queues(rx_ring);
+	ql_update_buffer_queues(rx_ring, GFP_ATOMIC, 0);
 	ql_write_cq_idx(rx_ring);
 	return count;
 }
@@ -2778,7 +2817,8 @@ static void ql_alloc_rx_buffers(struct ql_adapter *qdev)
 	int i;
 
 	for (i = 0; i < qdev->rss_ring_count; i++)
-		ql_update_buffer_queues(&qdev->rx_ring[i]);
+		ql_update_buffer_queues(&qdev->rx_ring[i], GFP_KERNEL,
+					HZ / 2);
 }
 
 static int qlge_init_bq(struct qlge_bq *bq)
@@ -3883,6 +3923,7 @@ static int ql_get_adapter_resources(struct ql_adapter *qdev)
 static int qlge_close(struct net_device *ndev)
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
+	int i;
 
 	/* If we hit pci_channel_io_perm_failure
 	 * failure condition, then we already
@@ -3900,6 +3941,11 @@ static int qlge_close(struct net_device *ndev)
 	 */
 	while (!test_bit(QL_ADAPTER_UP, &qdev->flags))
 		msleep(1);
+
+	/* Make sure refill_work doesn't re-enable napi */
+	for (i = 0; i < qdev->rss_ring_count; i++)
+		cancel_delayed_work_sync(&qdev->rx_ring[i].refill_work);
+
 	ql_adapter_down(qdev);
 	ql_release_adapter_resources(qdev);
 	return 0;
@@ -3966,6 +4012,8 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			    rx_ring->cq_len * sizeof(struct ql_net_rsp_iocb);
 			rx_ring->lbq.type = QLGE_LB;
 			rx_ring->sbq.type = QLGE_SB;
+			INIT_DELAYED_WORK(&rx_ring->refill_work,
+					  &qlge_slow_refill);
 		} else {
 			/*
 			 * Outbound queue handles outbound completions only.
-- 
2.23.0

