Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD16245FCF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgHQIZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgHQIZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:31 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A96C061388;
        Mon, 17 Aug 2020 01:25:30 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 189so7127443pgg.13;
        Mon, 17 Aug 2020 01:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D1aAuZf9AutjEPnD50DCVOQS+d/LorwrTFVRcP8QmrM=;
        b=JKs6NWf0vnjktIoAD+8hDbWr3FtmUc9bzqVlfLCwWBZjwHv+2lkp9Dt5867df+0KPJ
         qN52iAZFSKF+EgP/Gopv2oJH282/a9k3AvH1cnmLwxpmykSQf4fvLr0yK2WvpaPcmMy/
         kxqiGDTf/ypIINy/9AsP+FHMdmLfIFBch/HVd95MzP8G+CQiqVfQKVQVKiDhM0SLuFwx
         3nQi8/X/5Aq9X8hhpX+lla4EEOd0bc53ZlDlHwg0ORo0MOPb5wTNtyKPFGFr8wQZyikm
         996XaRO/oaL27tvInl/efvr+UsIX4+NTP72lLp5aEqbcp8B4q1+vqK0wet9HbRFeQBnP
         tvIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D1aAuZf9AutjEPnD50DCVOQS+d/LorwrTFVRcP8QmrM=;
        b=XsJTq6cFrdmnulhLXd3mJm9rm0ROKTdIV6rNUxK6mikPU3u1vcvl3bpS7MOo/LYVrw
         6qD4K2KSJy6QQRkFgd9MmFHZUvC61x/SisPA8KmNNRMfg9oWbDV9Yr+F5ME5/cfXdlaC
         5ncJX6AqdI9DjOD2A2tq5l3cA7dCdcGsNvtgWXB1XlI3Sd88JHeVpimFxqqvpEwHUBOe
         IShVzi+oY+H81f0rqDCyIgwbxFdubTnZNaZwxXTWv6SEuyNE4cs0elJk+zYQOk6+XfZb
         n8JcAbgFtmNIjv4Zb4MdgPeAEjmf1lRtQYThg/MFmfS8e7ebHqhhKuz9vQXVpcyt1QXz
         98Tg==
X-Gm-Message-State: AOAM5335fZPZNd6C5qmvaaY6de1p3SNY+geGPSBS7imdQ4omEce+kJb3
        d6Op6e9cZJDzIoz0/4k1G6Q=
X-Google-Smtp-Source: ABdhPJwRNhGVFfrT+4KXAK4vpPuqUG4S51cq+a0x5Buc2BD841a4hjMMe5sXIW8wgdf6LPNclkcTlg==
X-Received: by 2002:a63:544e:: with SMTP id e14mr9101091pgm.90.1597652730383;
        Mon, 17 Aug 2020 01:25:30 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:29 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 06/20] ethernet: chelsio: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:20 +0530
Message-Id: <20200817082434.21176-8-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb/sge.c  | 12 ++++++++----
 drivers/net/ethernet/chelsio/cxgb3/sge.c | 14 ++++++--------
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 12 ++++++------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index 47b5c8e2104b..5f999187038c 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -239,8 +239,10 @@ struct sched {
 	unsigned int	num;		/* num skbs in per port queues */
 	struct sched_port p[MAX_NPORTS];
 	struct tasklet_struct sched_tsk;/* tasklet used to run scheduler */
+	struct sge *sge;
 };
-static void restart_sched(unsigned long);
+
+static void restart_sched(struct tasklet_struct *t);
 
 
 /*
@@ -378,7 +380,8 @@ static int tx_sched_init(struct sge *sge)
 		return -ENOMEM;
 
 	pr_debug("tx_sched_init\n");
-	tasklet_init(&s->sched_tsk, restart_sched, (unsigned long) sge);
+	tasklet_setup(&s->sched_tsk, restart_sched);
+	s->sge = sge;
 	sge->tx_sched = s;
 
 	for (i = 0; i < MAX_NPORTS; i++) {
@@ -1301,9 +1304,10 @@ static inline void reclaim_completed_tx(struct sge *sge, struct cmdQ *q)
  * Called from tasklet. Checks the scheduler for any
  * pending skbs that can be sent.
  */
-static void restart_sched(unsigned long arg)
+static void restart_sched(struct tasklet_struct *t)
 {
-	struct sge *sge = (struct sge *) arg;
+	struct sched *s = from_tasklet(s, t, sched_tsk);
+	struct sge *sge = s->sge;
 	struct adapter *adapter = sge->adapter;
 	struct cmdQ *q = &sge->cmdQ[0];
 	struct sk_buff *skb;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 6dabbf1502c7..f2c5da465db5 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -1520,10 +1520,10 @@ static int ctrl_xmit(struct adapter *adap, struct sge_txq *q,
  *
  *	Resumes transmission on a suspended Tx control queue.
  */
-static void restart_ctrlq(unsigned long data)
+static void restart_ctrlq(struct tasklet_struct *t)
 {
 	struct sk_buff *skb;
-	struct sge_qset *qs = (struct sge_qset *)data;
+	struct sge_qset *qs = from_tasklet(qs, t, txq[TXQ_CTRL].qresume_tsk);
 	struct sge_txq *q = &qs->txq[TXQ_CTRL];
 
 	spin_lock(&q->lock);
@@ -1737,10 +1737,10 @@ again:	reclaim_completed_tx(adap, q, TX_RECLAIM_CHUNK);
  *
  *	Resumes transmission on a suspended Tx offload queue.
  */
-static void restart_offloadq(unsigned long data)
+static void restart_offloadq(struct tasklet_struct *t)
 {
 	struct sk_buff *skb;
-	struct sge_qset *qs = (struct sge_qset *)data;
+	struct sge_qset *qs = from_tasklet(qs, t, txq[TXQ_OFLD].qresume_tsk);
 	struct sge_txq *q = &qs->txq[TXQ_OFLD];
 	const struct port_info *pi = netdev_priv(qs->netdev);
 	struct adapter *adap = pi->adapter;
@@ -3084,10 +3084,8 @@ int t3_sge_alloc_qset(struct adapter *adapter, unsigned int id, int nports,
 		skb_queue_head_init(&q->txq[i].sendq);
 	}
 
-	tasklet_init(&q->txq[TXQ_OFLD].qresume_tsk, restart_offloadq,
-		     (unsigned long)q);
-	tasklet_init(&q->txq[TXQ_CTRL].qresume_tsk, restart_ctrlq,
-		     (unsigned long)q);
+	tasklet_setup(&q->txq[TXQ_OFLD].qresume_tsk, restart_offloadq);
+	tasklet_setup(&q->txq[TXQ_CTRL].qresume_tsk, restart_ctrlq);
 
 	q->fl[0].gen = q->fl[1].gen = 1;
 	q->fl[0].size = p->fl_size;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index d2b587d1670a..e668e17711c8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2660,11 +2660,11 @@ static int ctrl_xmit(struct sge_ctrl_txq *q, struct sk_buff *skb)
  *
  *	Resumes transmission on a suspended Tx control queue.
  */
-static void restart_ctrlq(unsigned long data)
+static void restart_ctrlq(struct tasklet_struct *t)
 {
 	struct sk_buff *skb;
 	unsigned int written = 0;
-	struct sge_ctrl_txq *q = (struct sge_ctrl_txq *)data;
+	struct sge_ctrl_txq *q = from_tasklet(q, t, qresume_tsk);
 
 	spin_lock(&q->sendq.lock);
 	reclaim_completed_tx_imm(&q->q);
@@ -2961,9 +2961,9 @@ static int ofld_xmit(struct sge_uld_txq *q, struct sk_buff *skb)
  *
  *	Resumes transmission on a suspended Tx offload queue.
  */
-static void restart_ofldq(unsigned long data)
+static void restart_ofldq(struct tasklet_struct *t)
 {
-	struct sge_uld_txq *q = (struct sge_uld_txq *)data;
+	struct sge_uld_txq *q = from_tasklet(q, t, qresume_tsk);
 
 	spin_lock(&q->sendq.lock);
 	q->full = 0;            /* the queue actually is completely empty now */
@@ -4576,7 +4576,7 @@ int t4_sge_alloc_ctrl_txq(struct adapter *adap, struct sge_ctrl_txq *txq,
 	init_txq(adap, &txq->q, FW_EQ_CTRL_CMD_EQID_G(ntohl(c.cmpliqid_eqid)));
 	txq->adap = adap;
 	skb_queue_head_init(&txq->sendq);
-	tasklet_init(&txq->qresume_tsk, restart_ctrlq, (unsigned long)txq);
+	tasklet_setup(&txq->qresume_tsk, restart_ctrlq);
 	txq->full = 0;
 	return 0;
 }
@@ -4666,7 +4666,7 @@ int t4_sge_alloc_uld_txq(struct adapter *adap, struct sge_uld_txq *txq,
 	txq->q.q_type = CXGB4_TXQ_ULD;
 	txq->adap = adap;
 	skb_queue_head_init(&txq->sendq);
-	tasklet_init(&txq->qresume_tsk, restart_ofldq, (unsigned long)txq);
+	tasklet_setup(&txq->qresume_tsk, restart_ofldq);
 	txq->full = 0;
 	txq->mapping_err = 0;
 	return 0;
-- 
2.17.1

