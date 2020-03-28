Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2184196355
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgC1DPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:15:05 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37971 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbgC1DPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 23:15:03 -0400
Received: by mail-pl1-f196.google.com with SMTP id w3so4218608plz.5
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 20:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K8cx4hZHCaToTIUrAEOGKqq5lVMSIx0N3T966e2wslU=;
        b=y+eHpGTxPCjx/D9EEnlLmOoqDvhJHxjiNKvcZGtH+gl0lvDUW5bC77ujqK99uvl+dS
         ZDVaxoEuFIi/rENtLmKKIL9hnvOPKUhd/gJiopjiNgEhmTva08YakPlOrCGmy0xG4htK
         FTDu36bWGb1bheh1IX+CSLwXS+dyik1PlljpLz9MxNk6U0rJ6ugTzD7XnL2hFIXc/Xfj
         SoogTbSEdKw0gZyvyxOOblxNPvnXsycGZJnXod0mAHS8WhM+s3ESb4RLM+mwKOjHW5aH
         FtHgiPl/8UMvw29f3Dt+hXVUdnNaljPy7BxYsR58YxWoBZdGzmGT9EkneYUJf3rNSjjd
         AUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K8cx4hZHCaToTIUrAEOGKqq5lVMSIx0N3T966e2wslU=;
        b=bRqekLx9g/BMe4IWyCQSBvDzWGenzIFCDvdppfMFdiI1C8aSA99efVAN1Cq5wyyNxt
         GsXmgWtxsvz9ypVfsYl4xlOqMz+sTupM7mQj00G4FPHcl3mfAEO3UMVjsZuUzyIpBnkr
         PBLvXUSH3tATNe7OHgVY6KcEipX+WICHvwA/AUVNUdMilkk7VgRfdM6nIWKlpItJviIr
         n6JoOCGS43Mo/Fwuxy7U1acJjcYxzFaiR84uJUrWmU5I6hOC8ZZ+hRqqHxnN6gFbcRnS
         866gBnnLVPx19HUOAYPgMn20yHTA+ghjVbtCWDF2A30rnkEJWb7DNySVRPkk9rk+6P8z
         iVhw==
X-Gm-Message-State: ANhLgQ0tJ28nhGLSfC1Dr7ogDoy9HaJIZsqMNpfmNihH0JtHon2GHCu9
        4l0XUAiHl/ANdX+pQdCufBrXnw3v7JM=
X-Google-Smtp-Source: ADFU+vvkCx8bBDuV0dJS55E6gji1ly/3+ARcIE5FnUS4Pv1Mzu0yqOmMnhPy+o4CJSu0dGGjnd2sIA==
X-Received: by 2002:a17:902:ab83:: with SMTP id f3mr2149223plr.197.1585365300547;
        Fri, 27 Mar 2020 20:15:00 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o65sm5208391pfg.187.2020.03.27.20.14.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 20:15:00 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 7/8] ionic: disable the queues on link down
Date:   Fri, 27 Mar 2020 20:14:47 -0700
Message-Id: <20200328031448.50794-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328031448.50794-1-snelson@pensando.io>
References: <20200328031448.50794-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the link goes down, we need to disable the queues on the
NIC in addition to stopping the netdev stack.  This lets the
FW know that the driver has stopped queue activity, and then
the FW can do internal reconfiguration work, whether actually
Link related, or for other internal FW needs.  To do this,
we pull out the queue enable and disable from ionic_open()
and ionic_stop() so they can be used by other routines.

To help keep things sane, we swap the queue enables so that
the rx queue and its napi are enabled before the tx queue
which rides on the rx queues napi.

We also drop the ionic_lif_quiesce() as it doesn't do anything
more than what the queue disable has already taken care of.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 117 +++++++++---------
 1 file changed, 61 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e2281542644b..8584a7c51446 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -22,6 +22,9 @@ static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr);
 static int ionic_lif_addr_del(struct ionic_lif *lif, const u8 *addr);
 static void ionic_link_status_check(struct ionic_lif *lif);
 
+static int ionic_start_queues(struct ionic_lif *lif);
+static void ionic_stop_queues(struct ionic_lif *lif);
+
 static void ionic_lif_deferred_work(struct work_struct *work)
 {
 	struct ionic_lif *lif = container_of(work, struct ionic_lif, deferred.work);
@@ -73,6 +76,9 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	u16 link_status;
 	bool link_up;
 
+	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
+		return;
+
 	if (lif->ionic->is_mgmt_nic)
 		return;
 
@@ -90,16 +96,16 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 			netif_carrier_on(netdev);
 		}
 
-		if (test_bit(IONIC_LIF_F_UP, lif->state))
-			netif_tx_wake_all_queues(lif->netdev);
+		if (netif_running(lif->netdev))
+			ionic_start_queues(lif);
 	} else {
 		if (netif_carrier_ok(netdev)) {
 			netdev_info(netdev, "Link down\n");
 			netif_carrier_off(netdev);
 		}
 
-		if (test_bit(IONIC_LIF_F_UP, lif->state))
-			netif_tx_stop_all_queues(netdev);
+		if (netif_running(lif->netdev))
+			ionic_stop_queues(lif);
 	}
 
 	clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
@@ -248,21 +254,6 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq)
 	return ionic_adminq_post_wait(lif, &ctx);
 }
 
-static void ionic_lif_quiesce(struct ionic_lif *lif)
-{
-	struct ionic_admin_ctx ctx = {
-		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
-		.cmd.lif_setattr = {
-			.opcode = IONIC_CMD_LIF_SETATTR,
-			.attr = IONIC_LIF_ATTR_STATE,
-			.index = lif->index,
-			.state = IONIC_LIF_DISABLE
-		},
-	};
-
-	ionic_adminq_post_wait(lif, &ctx);
-}
-
 static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
@@ -615,6 +606,10 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
 	dev_dbg(dev, "txq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
 
+	q->tail = q->info;
+	q->head = q->tail;
+	cq->tail = cq->info;
+
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
 		return err;
@@ -660,6 +655,10 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
 	dev_dbg(dev, "rxq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
 
+	q->tail = q->info;
+	q->head = q->tail;
+	cq->tail = cq->info;
+
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
 		return err;
@@ -1473,6 +1472,7 @@ static void ionic_txrx_deinit(struct ionic_lif *lif)
 			ionic_rx_empty(&lif->rxqcqs[i].qcq->q);
 		}
 	}
+	lif->rx_mode = 0;
 }
 
 static void ionic_txrx_free(struct ionic_lif *lif)
@@ -1582,15 +1582,15 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 	int i, err;
 
 	for (i = 0; i < lif->nxqs; i++) {
-		err = ionic_qcq_enable(lif->txqcqs[i].qcq);
+		ionic_rx_fill(&lif->rxqcqs[i].qcq->q);
+		err = ionic_qcq_enable(lif->rxqcqs[i].qcq);
 		if (err)
 			goto err_out;
 
-		ionic_rx_fill(&lif->rxqcqs[i].qcq->q);
-		err = ionic_qcq_enable(lif->rxqcqs[i].qcq);
+		err = ionic_qcq_enable(lif->txqcqs[i].qcq);
 		if (err) {
 			if (err != -ETIMEDOUT)
-				ionic_qcq_disable(lif->txqcqs[i].qcq);
+				ionic_qcq_disable(lif->rxqcqs[i].qcq);
 			goto err_out;
 		}
 	}
@@ -1599,10 +1599,10 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 err_out:
 	while (i--) {
-		err = ionic_qcq_disable(lif->rxqcqs[i].qcq);
+		err = ionic_qcq_disable(lif->txqcqs[i].qcq);
 		if (err == -ETIMEDOUT)
 			break;
-		err = ionic_qcq_disable(lif->txqcqs[i].qcq);
+		err = ionic_qcq_disable(lif->rxqcqs[i].qcq);
 		if (err == -ETIMEDOUT)
 			break;
 	}
@@ -1610,6 +1610,23 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 	return err;
 }
 
+static int ionic_start_queues(struct ionic_lif *lif)
+{
+	int err;
+
+	if (test_and_set_bit(IONIC_LIF_F_UP, lif->state))
+		return 0;
+
+	err = ionic_txrx_enable(lif);
+	if (err) {
+		clear_bit(IONIC_LIF_F_UP, lif->state);
+		return err;
+	}
+	netif_tx_wake_all_queues(lif->netdev);
+
+	return 0;
+}
+
 int ionic_open(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
@@ -1621,54 +1638,42 @@ int ionic_open(struct net_device *netdev)
 
 	err = ionic_txrx_init(lif);
 	if (err)
-		goto err_txrx_free;
-
-	err = ionic_txrx_enable(lif);
-	if (err)
-		goto err_txrx_deinit;
-
-	netif_set_real_num_tx_queues(netdev, lif->nxqs);
-	netif_set_real_num_rx_queues(netdev, lif->nxqs);
-
-	set_bit(IONIC_LIF_F_UP, lif->state);
+		goto err_out;
 
-	ionic_link_status_check_request(lif);
-	if (netif_carrier_ok(netdev))
-		netif_tx_wake_all_queues(netdev);
+	/* don't start the queues until we have link */
+	if (netif_carrier_ok(netdev)) {
+		err = ionic_start_queues(lif);
+		if (err)
+			goto err_txrx_deinit;
+	}
 
 	return 0;
 
 err_txrx_deinit:
 	ionic_txrx_deinit(lif);
-err_txrx_free:
+err_out:
 	ionic_txrx_free(lif);
 	return err;
 }
 
-int ionic_stop(struct net_device *netdev)
+static void ionic_stop_queues(struct ionic_lif *lif)
 {
-	struct ionic_lif *lif = netdev_priv(netdev);
-	int err = 0;
+	if (!test_and_clear_bit(IONIC_LIF_F_UP, lif->state))
+		return;
 
-	if (!test_bit(IONIC_LIF_F_UP, lif->state)) {
-		dev_dbg(lif->ionic->dev, "%s: %s state=DOWN\n",
-			__func__, lif->name);
-		return 0;
-	}
-	dev_dbg(lif->ionic->dev, "%s: %s state=UP\n", __func__, lif->name);
-	clear_bit(IONIC_LIF_F_UP, lif->state);
+	ionic_txrx_disable(lif);
+	netif_tx_disable(lif->netdev);
+}
 
-	/* carrier off before disabling queues to avoid watchdog timeout */
-	netif_carrier_off(netdev);
-	netif_tx_stop_all_queues(netdev);
-	netif_tx_disable(netdev);
+int ionic_stop(struct net_device *netdev)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
 
-	ionic_txrx_disable(lif);
-	ionic_lif_quiesce(lif);
+	ionic_stop_queues(lif);
 	ionic_txrx_deinit(lif);
 	ionic_txrx_free(lif);
 
-	return err;
+	return 0;
 }
 
 static int ionic_get_vf_config(struct net_device *netdev,
-- 
2.17.1

