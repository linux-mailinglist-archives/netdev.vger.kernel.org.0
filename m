Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997DD253523
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgHZQnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbgHZQme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:34 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066D7C061795
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:34 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 2so1135980pjx.5
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k2uVguxJCap3FPa/qV75ImuzQU5coo/g97UE/+e4hO0=;
        b=ZUHlLfSjhBpQlvieLGjXa1ACc8pV4VlZ+vy2l1CFee4n3Ju542l8hTgmU0elALDV57
         mrZvRh78+QPIYwhItQYhuRVzYchZvQ3tPVWtpNH/0DGMHi8M/FGCRXsn706RbXQJOltq
         ArDREg8bA4aBB5mJZIjbkBOmMKmUY3smg27MRurUJWE8SWTTgECKf1uaWK8LYhux4woZ
         F6QgEPU4DtWjLyObD4kJcWbwREORqIziWJHo3PnJKrDpDxoCf9g7uIb/Qz0fAMPf5sSj
         m6MbPLVXFeP37c5F8bZEgCMcJcm2jEtETGVUh8uiHi0rBuZR8LCUDB8/w1yQ8oOA30Uh
         oAVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=k2uVguxJCap3FPa/qV75ImuzQU5coo/g97UE/+e4hO0=;
        b=pgaMsv9Tm+prBaLkzoD77g8f2AW0pA1HW1h/D7EQUOUiraR+7D/odo505kP1wx5hPL
         4eBte37+63Q1YwNlnx6MxM1tiTrNti2FES4lH3NQ6/r2lMGzZslDvrItWif3fbySLJu1
         u7b3zbpX53t/E3Gfo1AXCMjhaIxhQVwhxwr4Zan9xZLNflf7c0xoYRCy1wUO12sX9gGb
         kWgPrYG4FzwDwiLUym8fvyceK0FtwTSijuc1t1JMn8m06WZfypA2bQ92B17VxDI7UmCh
         NHWhKdAW9eVSl0WMLIu9+YJcdwaFT79jZg+wBD7fb600/mBwAL4VL5QOL3/2B/BuSv6r
         PfzA==
X-Gm-Message-State: AOAM5305NfVlPhhlfzUa4JycCJwgdZXVUBw2y+J0YAGtZtxi/kl9rSeP
        220pZ7hpxTa/2KzQl7PwoDuu69CdXdp3Wg==
X-Google-Smtp-Source: ABdhPJwYhVqZYvqQU5GiNsQuDJ/5EnbHDqoTMG+b+Vj+KpRZezshsmKJDjdOkzvI20R2Ly+c+7ET0w==
X-Received: by 2002:a17:90a:6a05:: with SMTP id t5mr6471389pjj.26.1598460152168;
        Wed, 26 Aug 2020 09:42:32 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 09/12] ionic: change mtu without full queue rebuild
Date:   Wed, 26 Aug 2020 09:42:11 -0700
Message-Id: <20200826164214.31792-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826164214.31792-1-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We really don't need to tear down and rebuild the whole queue structure
when changing the MTU; we can simply stop the queues, clean and refill,
then restart the queues.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 45 ++++++++++++++++---
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index b77827e9355c..d82ae717bc6c 100644
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
@@ -1326,8 +1335,30 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 		return err;
 
 	netdev->mtu = new_mtu;
-	err = ionic_reset_queues(lif, NULL, NULL);
+	/* if we're not running, nothing more to do */
+	if (!netif_running(lif->netdev))
+		return 0;
+
+	/* stop and reinit the queues */
+	mutex_lock(&lif->queue_lock);
+	netif_device_detach(lif->netdev);
+	ionic_stop_queues(lif);
+	ionic_txrx_deinit(lif);
 
+	err = ionic_txrx_init(lif);
+	if (err)
+		goto err_out;
+
+	/* don't start the queues until we have link */
+	if (netif_carrier_ok(netdev)) {
+		err = ionic_start_queues(lif);
+		if (err)
+			goto err_out;
+	}
+
+err_out:
+	netif_device_attach(lif->netdev);
+	mutex_unlock(&lif->queue_lock);
 	return err;
 }
 
-- 
2.17.1

