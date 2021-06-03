Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728A7399ADF
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 08:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhFCGg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 02:36:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229747AbhFCGg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 02:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622702111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XLtQKes8ZTh92+q2SW5s5JoeSgDQsIN6V+9PT1WhPFg=;
        b=Hy5ufcX4eItE6MDsxThkPCQjOGJiljfE0mpmPDCl2eZ1CaaEUf/OJ008cs8eASwiLWgOAo
        vtPWOXWz66yUWomCwdgQCEvCfsKY0KFaqKKUzyYOPXCcc/hzaHbtGdHo9+ZvcUftiKWzkX
        tmksVSCfJYTeXf/1O6mgHVkVNLk4lcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-8R-Q1i2sM2Cetsfm_jqMqw-1; Thu, 03 Jun 2021 02:35:10 -0400
X-MC-Unique: 8R-Q1i2sM2Cetsfm_jqMqw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 732AA8015F5;
        Thu,  3 Jun 2021 06:35:09 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-165.ams2.redhat.com [10.36.112.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E7A05D705;
        Thu,  3 Jun 2021 06:35:07 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivecera@redhat.com,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH 1/2] net:cxgb3: replace tasklets with works
Date:   Thu,  3 Jun 2021 08:34:29 +0200
Message-Id: <20210603063430.6613-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OFLD and CTRL TX queues can be stopped if there is no room in
their DMA rings. If this happens, they're tried to be restarted
later after having made some room in the corresponding ring.

The tasks of restarting these queues were triggered using
tasklets, but they can be replaced for workqueue works, getting
them out of softirq context.

This queues stop/restart probably doesn't happen often and they
can be quite lengthy because they try to send all pending skbs.
Moreover, given that probably the ring is not empty yet, so the
DMA still has work to do, we don't need to be so fast to justify
using tasklets/softirq instead of running in a thread.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/chelsio/cxgb3/adapter.h |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/common.h  |  2 ++
 drivers/net/ethernet/chelsio/cxgb3/sge.c     | 38 +++++++++++---------
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/adapter.h b/drivers/net/ethernet/chelsio/cxgb3/adapter.h
index f80fbd81b609..6d682b7c7aac 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/adapter.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/adapter.h
@@ -178,7 +178,7 @@ struct sge_txq {		/* state for an SGE Tx queue */
 	unsigned int token;	/* WR token */
 	dma_addr_t phys_addr;	/* physical address of the ring */
 	struct sk_buff_head sendq;	/* List of backpressured offload packets */
-	struct tasklet_struct qresume_tsk;	/* restarts the queue */
+	struct work_struct qresume_task;	/* restarts the queue */
 	unsigned int cntxt_id;	/* SGE context id for the Tx q */
 	unsigned long stops;	/* # of times q has been stopped */
 	unsigned long restarts;	/* # of queue restarts */
diff --git a/drivers/net/ethernet/chelsio/cxgb3/common.h b/drivers/net/ethernet/chelsio/cxgb3/common.h
index 1bd7d89666c4..b706f2fbe4f4 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/common.h
+++ b/drivers/net/ethernet/chelsio/cxgb3/common.h
@@ -770,4 +770,6 @@ int t3_xaui_direct_phy_prep(struct cphy *phy, struct adapter *adapter,
 			    int phy_addr, const struct mdio_ops *mdio_ops);
 int t3_aq100x_phy_prep(struct cphy *phy, struct adapter *adapter,
 			    int phy_addr, const struct mdio_ops *mdio_ops);
+
+extern struct workqueue_struct *cxgb3_wq;
 #endif				/* __CHELSIO_COMMON_H */
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 1cc3c51eff71..fa91aa57b50a 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -1518,14 +1518,15 @@ static int ctrl_xmit(struct adapter *adap, struct sge_txq *q,
 
 /**
  *	restart_ctrlq - restart a suspended control queue
- *	@t: pointer to the tasklet associated with this handler
+ *	@w: pointer to the work associated with this handler
  *
  *	Resumes transmission on a suspended Tx control queue.
  */
-static void restart_ctrlq(struct tasklet_struct *t)
+static void restart_ctrlq(struct work_struct *w)
 {
 	struct sk_buff *skb;
-	struct sge_qset *qs = from_tasklet(qs, t, txq[TXQ_CTRL].qresume_tsk);
+	struct sge_qset *qs = container_of(w, struct sge_qset,
+					   txq[TXQ_CTRL].qresume_task);
 	struct sge_txq *q = &qs->txq[TXQ_CTRL];
 
 	spin_lock(&q->lock);
@@ -1736,14 +1737,15 @@ again:	reclaim_completed_tx(adap, q, TX_RECLAIM_CHUNK);
 
 /**
  *	restart_offloadq - restart a suspended offload queue
- *	@t: pointer to the tasklet associated with this handler
+ *	@w: pointer to the work associated with this handler
  *
  *	Resumes transmission on a suspended Tx offload queue.
  */
-static void restart_offloadq(struct tasklet_struct *t)
+static void restart_offloadq(struct work_struct *w)
 {
 	struct sk_buff *skb;
-	struct sge_qset *qs = from_tasklet(qs, t, txq[TXQ_OFLD].qresume_tsk);
+	struct sge_qset *qs = container_of(w, struct sge_qset,
+					   txq[TXQ_OFLD].qresume_task);
 	struct sge_txq *q = &qs->txq[TXQ_OFLD];
 	const struct port_info *pi = netdev_priv(qs->netdev);
 	struct adapter *adap = pi->adapter;
@@ -1998,13 +2000,17 @@ static void restart_tx(struct sge_qset *qs)
 	    should_restart_tx(&qs->txq[TXQ_OFLD]) &&
 	    test_and_clear_bit(TXQ_OFLD, &qs->txq_stopped)) {
 		qs->txq[TXQ_OFLD].restarts++;
-		tasklet_schedule(&qs->txq[TXQ_OFLD].qresume_tsk);
+
+		/* The work can be quite lengthy so we use driver's own queue */
+		queue_work(cxgb3_wq, &qs->txq[TXQ_OFLD].qresume_task);
 	}
 	if (test_bit(TXQ_CTRL, &qs->txq_stopped) &&
 	    should_restart_tx(&qs->txq[TXQ_CTRL]) &&
 	    test_and_clear_bit(TXQ_CTRL, &qs->txq_stopped)) {
 		qs->txq[TXQ_CTRL].restarts++;
-		tasklet_schedule(&qs->txq[TXQ_CTRL].qresume_tsk);
+
+		/* The work can be quite lengthy so we use driver's own queue */
+		queue_work(cxgb3_wq, &qs->txq[TXQ_CTRL].qresume_task);
 	}
 }
 
@@ -3085,8 +3091,8 @@ int t3_sge_alloc_qset(struct adapter *adapter, unsigned int id, int nports,
 		skb_queue_head_init(&q->txq[i].sendq);
 	}
 
-	tasklet_setup(&q->txq[TXQ_OFLD].qresume_tsk, restart_offloadq);
-	tasklet_setup(&q->txq[TXQ_CTRL].qresume_tsk, restart_ctrlq);
+	INIT_WORK(&q->txq[TXQ_OFLD].qresume_task, restart_offloadq);
+	INIT_WORK(&q->txq[TXQ_CTRL].qresume_task, restart_ctrlq);
 
 	q->fl[0].gen = q->fl[1].gen = 1;
 	q->fl[0].size = p->fl_size;
@@ -3276,11 +3282,11 @@ void t3_sge_start(struct adapter *adap)
  *
  *	Can be invoked from interrupt context e.g.  error handler.
  *
- *	Note that this function cannot disable the restart of tasklets as
+ *	Note that this function cannot disable the restart of works as
  *	it cannot wait if called from interrupt context, however the
- *	tasklets will have no effect since the doorbells are disabled. The
+ *	works will have no effect since the doorbells are disabled. The
  *	driver will call tg3_sge_stop() later from process context, at
- *	which time the tasklets will be stopped if they are still running.
+ *	which time the works will be stopped if they are still running.
  */
 void t3_sge_stop_dma(struct adapter *adap)
 {
@@ -3292,7 +3298,7 @@ void t3_sge_stop_dma(struct adapter *adap)
  *	@adap: the adapter
  *
  *	Called from process context. Disables the DMA engine and any
- *	pending queue restart tasklets.
+ *	pending queue restart works.
  */
 void t3_sge_stop(struct adapter *adap)
 {
@@ -3303,8 +3309,8 @@ void t3_sge_stop(struct adapter *adap)
 	for (i = 0; i < SGE_QSETS; ++i) {
 		struct sge_qset *qs = &adap->sge.qs[i];
 
-		tasklet_kill(&qs->txq[TXQ_OFLD].qresume_tsk);
-		tasklet_kill(&qs->txq[TXQ_CTRL].qresume_tsk);
+		cancel_work_sync(&qs->txq[TXQ_OFLD].qresume_task);
+		cancel_work_sync(&qs->txq[TXQ_OFLD].qresume_task);
 	}
 }
 
-- 
2.31.1

