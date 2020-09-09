Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6834262AC2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgIIIp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728936AbgIIIpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:45:45 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2B1C061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:45:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z19so1543894pfn.8
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1YHBKbKXVonra1FrmypkxMUNqk0ty60Q+d3VYi9UEnM=;
        b=tGIg/cIqpu3HSMhRr1nP4af7ith9BHAX3tcQBgXguf0mnX2CLpB27PTXLcLXVGMWl6
         /UE14Suilwt/8SkUS4UWlTVKaOdNIlR7pL/YVQdDlKI1JaUGsbRzG8/nkyN3ZA9aTJQz
         6+1WBfo/mhzm8v6/cvewEVbKJ8ystDofIWCHMrfxvwCJjPoMbAfoFqR32qRyRgN/id0i
         weBBWwUjkIEfFsS1SEDnnir9SzTd9gHMuL8zcojq3v0g5o3Tsxipl/m41weEuvD4kINt
         f7MVUlTjftisre0LPC0GtvLzg+j9AFwt6ntfmKT5fIWRRwTWbDP/YdsprIUdnABJgS8Y
         604Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1YHBKbKXVonra1FrmypkxMUNqk0ty60Q+d3VYi9UEnM=;
        b=kEuqkJSyeEez5Xh7xAdgBl0RAFICajbdjQTJzPb4tCU/dgDMPNc4JVxj3u/q8faBV/
         OA1Rli4Yr2KppW+jSF1Hpndoi6JECISVwaB5nyIpS8Wh8F5Z30JpDknpGUP81SJtjwn6
         At9hMCzEm7Q8loCQGF1WXrujOXkLF9bgmM9JdB8IiI3NLOA31PIPljfF/3keyrx0Akwx
         sI4DccetIDPqg1LqTboYODr2Zvat3VwKndvh4/B+WcbacWlY2mr6dhsqeh45co2zhdWf
         WRuHmSnHSshxhlOz2cSLCjLZrHq0LFLG4mWx+No0/AFdS5YBg+r/SDZkB3fA1qSD0/+a
         eLRQ==
X-Gm-Message-State: AOAM530dWoqQaO9xob487kOZG1UOLP8J2dIENjgXRgzskFLlgj85jeVA
        5gPD9+Q/fEfjb73p6mR6dZg=
X-Google-Smtp-Source: ABdhPJwcZT6Cj/HKRsrBZz986uJMJRUGsui7paZcVL9dtOkUQttPbc8YVTOrkiDQB+zM2IC1w0TK1g==
X-Received: by 2002:a17:902:59d8:b029:d0:89f1:9e2d with SMTP id d24-20020a17090259d8b02900d089f19e2dmr3193368plj.9.1599641144501;
        Wed, 09 Sep 2020 01:45:44 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:45:44 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 06/20] ethernet: chelsio: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:14:56 +0530
Message-Id: <20200909084510.648706-7-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 drivers/net/ethernet/chelsio/cxgb3/sge.c | 18 ++++++++----------
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 16 ++++++++--------
 3 files changed, 24 insertions(+), 22 deletions(-)

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
index 6dabbf1502c7..4dadb04276d5 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -1516,14 +1516,14 @@ static int ctrl_xmit(struct adapter *adap, struct sge_txq *q,
 
 /**
  *	restart_ctrlq - restart a suspended control queue
- *	@qs: the queue set cotaining the control queue
+ *	@t: pointer to the tasklet associated with this handler
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
@@ -1733,14 +1733,14 @@ again:	reclaim_completed_tx(adap, q, TX_RECLAIM_CHUNK);
 
 /**
  *	restart_offloadq - restart a suspended offload queue
- *	@qs: the queue set cotaining the offload queue
+ *	@t: pointer to the tasklet associated with this handler
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
index 869431a1eedd..af4839e7c07e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2660,15 +2660,15 @@ static int ctrl_xmit(struct sge_ctrl_txq *q, struct sk_buff *skb)
 
 /**
  *	restart_ctrlq - restart a suspended control queue
- *	@data: the control queue to restart
+ *	@t: pointer to the tasklet associated with this handler
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
@@ -2961,13 +2961,13 @@ static int ofld_xmit(struct sge_uld_txq *q, struct sk_buff *skb)
 
 /**
  *	restart_ofldq - restart a suspended offload queue
- *	@data: the offload queue to restart
+ *	@t: pointer to the tasklet associated with this handler
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
@@ -4580,7 +4580,7 @@ int t4_sge_alloc_ctrl_txq(struct adapter *adap, struct sge_ctrl_txq *txq,
 	init_txq(adap, &txq->q, FW_EQ_CTRL_CMD_EQID_G(ntohl(c.cmpliqid_eqid)));
 	txq->adap = adap;
 	skb_queue_head_init(&txq->sendq);
-	tasklet_init(&txq->qresume_tsk, restart_ctrlq, (unsigned long)txq);
+	tasklet_setup(&txq->qresume_tsk, restart_ctrlq);
 	txq->full = 0;
 	return 0;
 }
@@ -4670,7 +4670,7 @@ int t4_sge_alloc_uld_txq(struct adapter *adap, struct sge_uld_txq *txq,
 	txq->q.q_type = CXGB4_TXQ_ULD;
 	txq->adap = adap;
 	skb_queue_head_init(&txq->sendq);
-	tasklet_init(&txq->qresume_tsk, restart_ofldq, (unsigned long)txq);
+	tasklet_setup(&txq->qresume_tsk, restart_ofldq);
 	txq->full = 0;
 	txq->mapping_err = 0;
 	return 0;
-- 
2.25.1

