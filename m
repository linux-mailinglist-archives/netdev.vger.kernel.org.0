Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C7625517C
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgH0XBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbgH0XAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:00:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F175BC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:48 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u20so4675246pfn.0
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KOvLl/oWtciChh3wt/XG0QAr1FEp9SLzRadLtsOwBSQ=;
        b=PCjJoq1d3DZ0bO13q83grxHZFn+0QjF2zkas638p+mW8yfhIvCJAGt6u6+v7NyAihm
         ildgInAvx2jPFiMoI57/++UQ6XSbsz28mHBEwZtzZ+333P3b+GsvnoxPgUYNTqAHAn1I
         cpbUnN2bZz0zLB53JFMHeGkXLALCsst8sAoanGaD5mwQeCsc25ymcHVW8GWRqYyaJoot
         xdFoRxe0vSIU2TvdOF6aYxMqBgilvNno7itiDYV9wKxxp7GxbSvNOrxjQ8+C42JEqOHi
         KWa8I0iIstyb3B3Od38wHmobMhGS262qWOLWOU/UVWLS7Cf9kn1CG1dfgdk6l9g1tOPe
         D/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KOvLl/oWtciChh3wt/XG0QAr1FEp9SLzRadLtsOwBSQ=;
        b=JgrzRV9ht9LmBMg0rZvllQw8CdWAZgLgFRH4n6a18s0ETWJ53RxA75HkwrG+gfsfF1
         POggZe+LNV3K3IShjEuwnfGB2OijTuXxgFG0bxlca+OHc+SrpX+lqKMuzuk18HeQc4Cc
         xqs8RZeLXsEOlPZ9FzhaegFWAT7s/0Yri3s1BIUL1l5NYdV8irCXQU5HU852Q/iOS322
         bId0zO7tXw39BovNRkDpwI8ipHlOPmvIpxXw2d2HxMjUPnH/DHJhRK5CBDRlbqFv3tan
         1tlb3FYEaH8tJNKgEF5BXGtElNGn18ad70GLDKwVG6pnAYjkBThP+LkMQ9yhjkKOt+mL
         W5SQ==
X-Gm-Message-State: AOAM530LJS8dE3y8dAjfC2O/kAayeRydzFWHcuKsm3/APhvpntxXYJ3O
        pdL+tCa0rbp7qGIzfXhV8y/qdeNyn9FzKw==
X-Google-Smtp-Source: ABdhPJzAzgCjNvLFSwgxjFzHsd/0CVGuWjFIy4tUY1N/4lBUggzaGEeUNkmuXuju91yw5DGb5zVeaw==
X-Received: by 2002:a17:902:a714:: with SMTP id w20mr18222849plq.8.1598569247803;
        Thu, 27 Aug 2020 16:00:47 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n22sm3137534pjq.25.2020.08.27.16.00.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 16:00:47 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 09/12] ionic: change mtu without full queue rebuild
Date:   Thu, 27 Aug 2020 16:00:27 -0700
Message-Id: <20200827230030.43343-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827230030.43343-1-snelson@pensando.io>
References: <20200827230030.43343-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We really don't need to tear down and rebuild the whole queue structure
when changing the MTU; we can simply stop the queues, clean and refill,
then restart the queues.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 57 ++++++++++++++++---
 1 file changed, 49 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 2637eb83ae1f..176ffc1c16c6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -36,6 +36,8 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif);
 static void ionic_lif_handle_fw_up(struct ionic_lif *lif);
 static void ionic_lif_set_netdev_info(struct ionic_lif *lif);
 
+static void ionic_txrx_deinit(struct ionic_lif *lif);
+static int ionic_txrx_init(struct ionic_lif *lif);
 static int ionic_start_queues(struct ionic_lif *lif);
 static void ionic_stop_queues(struct ionic_lif *lif);
 static void ionic_lif_queue_identify(struct ionic_lif *lif);
@@ -593,6 +595,17 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 	return err;
 }
 
+static void ionic_qcq_sanitize(struct ionic_qcq *qcq)
+{
+	qcq->q.tail_idx = 0;
+	qcq->q.head_idx = 0;
+	qcq->cq.tail_idx = 0;
+	qcq->cq.done_color = 1;
+	memset(qcq->q_base, 0, qcq->q_size);
+	memset(qcq->cq_base, 0, qcq->cq_size);
+	memset(qcq->sg_base, 0, qcq->sg_size);
+}
+
 static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
 	struct device *dev = lif->ionic->dev;
@@ -632,9 +645,7 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq_init.ver %d\n", ctx.cmd.q_init.ver);
 	dev_dbg(dev, "txq_init.intr_index %d\n", ctx.cmd.q_init.intr_index);
 
-	q->tail_idx = 0;
-	q->head_idx = 0;
-	cq->tail_idx = 0;
+	ionic_qcq_sanitize(qcq);
 
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
@@ -689,9 +700,7 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq_init.ver %d\n", ctx.cmd.q_init.ver);
 	dev_dbg(dev, "rxq_init.intr_index %d\n", ctx.cmd.q_init.intr_index);
 
-	q->tail_idx = 0;
-	q->head_idx = 0;
-	cq->tail_idx = 0;
+	ionic_qcq_sanitize(qcq);
 
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
@@ -1307,6 +1316,35 @@ static int ionic_set_mac_address(struct net_device *netdev, void *sa)
 	return ionic_addr_add(netdev, mac);
 }
 
+static void ionic_stop_queues_reconfig(struct ionic_lif *lif)
+{
+	/* Stop and clean the queues before reconfiguration */
+	mutex_lock(&lif->queue_lock);
+	netif_device_detach(lif->netdev);
+	ionic_stop_queues(lif);
+	ionic_txrx_deinit(lif);
+}
+
+static int ionic_start_queues_reconfig(struct ionic_lif *lif)
+{
+	int err;
+
+	/* Re-init the queues after reconfiguration */
+
+	/* The only way txrx_init can fail here is if communication
+	 * with FW is suddenly broken.  There's not much we can do
+	 * at this point - error messages have already been printed,
+	 * so we can continue on and the user can eventually do a
+	 * DOWN and UP to try to reset and clear the issue.
+	 */
+	err = ionic_txrx_init(lif);
+	mutex_unlock(&lif->queue_lock);
+	ionic_link_status_check_request(lif);
+	netif_device_attach(lif->netdev);
+
+	return err;
+}
+
 static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
@@ -1326,9 +1364,12 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 		return err;
 
 	netdev->mtu = new_mtu;
-	err = ionic_reset_queues(lif, NULL, NULL);
+	/* if we're not running, nothing more to do */
+	if (!netif_running(netdev))
+		return 0;
 
-	return err;
+	ionic_stop_queues_reconfig(lif);
+	return ionic_start_queues_reconfig(lif);
 }
 
 static void ionic_tx_timeout_work(struct work_struct *ws)
-- 
2.17.1

