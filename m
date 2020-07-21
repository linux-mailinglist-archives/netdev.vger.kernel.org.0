Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626B52287C3
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbgGURqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgGURqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:46:36 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70272C0619DA
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:36 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id md7so2038845pjb.1
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mgf+Qy2LLyBQyvF7dW8j1WQ5+w2Idp48bbdEhTIkIJ4=;
        b=AT+z5LOFXwFmhInrYioomuGYCotlX7hqFEsCru6jR3EJUzItUxY/ZRoiwm61T3QVXX
         PWOjoM82uboTZk+p2buqpGBdFnhp6XxpraGfffokZd4IxkUvN+xYEeVyJiBINuhawSxi
         SA1Smc6nV6sth4DxoOdeFPFH7UhcIc+Hk9kUKFrEibjSB2u7y7MctEKQU6sE7LNCLWU+
         3uttU79B8azSabXGNnrEJW5TP26J8yJmtve0tD7eodslJlczzAMoTGd1bg6LFjWby5jV
         05KtRZ+PuLVbzN4nlF5nU672b8bUurIJ11gSo2Y2m+xBFHhmDju+/9LmYAAx0ICIhXkg
         5Bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mgf+Qy2LLyBQyvF7dW8j1WQ5+w2Idp48bbdEhTIkIJ4=;
        b=hpzwT9Dq+5L/3T1aFBNQ6XpCef913URg4mTafDfrTLViWZg4rfoITeMB2JxyDGMmGa
         7w5tED59idllzF/iI/uQxUHLFCkucTk1PFuWYWjRkKPjUYY9hNfiiSkcwfhU5QFona/g
         NIDCZwFrhVvhaXu/jBCr/qiBHOgklc+6hWtLXF9F2p8amQHLFRyMK65MWzt1EwkDtPAD
         YwjP5TOAfNA014FU7eYJPpPNjB6Mik92jCOF+mq4Fr41wpeDIpihetwtk2qAnkV332BM
         xut6HiFuEdPw7zPBlg2aKgW4tZvMDGFc4xmESaqVBBXJcYb//owSlNVV/E7PaprJA7UK
         Xh4w==
X-Gm-Message-State: AOAM532dyyIxJwULQ1o12JezpO/VemtC2HoYPgzTiZwFXtFl8+JZWZCT
        UOmADJX1E1HPA6t9isZL/kevZtTXE4I=
X-Google-Smtp-Source: ABdhPJzhJWsfTTn0l7iMH2GrjeyY1GzwTvY5IjqMfqQn3x1Cv48zMvDH6z3UX6kAMPtcvbAeB2MfYg==
X-Received: by 2002:a17:90b:30d7:: with SMTP id hi23mr5209056pjb.69.1595353595504;
        Tue, 21 Jul 2020 10:46:35 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c14sm4598712pgb.1.2020.07.21.10.46.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:46:34 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 6/6] ionic: use mutex to protect queue operations
Date:   Tue, 21 Jul 2020 10:46:19 -0700
Message-Id: <20200721174619.39860-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721174619.39860-1-snelson@pensando.io>
References: <20200721174619.39860-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ionic_wait_on_bit_lock() was a open-coded mutex knock-off
used only for protecting the queue reset operations, and there
was no reason not to use the real thing.  We can use the lock
more correctly and to better protect the queue stop and start
operations from cross threading.  We can also remove a useless
and expensive bit operation from the Rx path.

This fixes a case found where the link_status_check from a link
flap could run into an MTU change and cause a crash.

Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 28 +++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  8 +-----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  6 ----
 3 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index ddb9ad5b294c..5fd31ba56937 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -96,8 +96,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	u16 link_status;
 	bool link_up;
 
-	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state) ||
-	    test_bit(IONIC_LIF_F_QUEUE_RESET, lif->state))
+	if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
 		return;
 
 	link_status = le16_to_cpu(lif->info->status.link_status);
@@ -114,16 +113,22 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 			netif_carrier_on(netdev);
 		}
 
-		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev))
+		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) {
+			mutex_lock(&lif->queue_lock);
 			ionic_start_queues(lif);
+			mutex_unlock(&lif->queue_lock);
+		}
 	} else {
 		if (netif_carrier_ok(netdev)) {
 			netdev_info(netdev, "Link down\n");
 			netif_carrier_off(netdev);
 		}
 
-		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev))
+		if (lif->netdev->flags & IFF_UP && netif_running(lif->netdev)) {
+			mutex_lock(&lif->queue_lock);
 			ionic_stop_queues(lif);
+			mutex_unlock(&lif->queue_lock);
+		}
 	}
 
 	clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
@@ -1990,16 +1995,13 @@ int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 	bool running;
 	int err = 0;
 
-	err = ionic_wait_for_bit(lif, IONIC_LIF_F_QUEUE_RESET);
-	if (err)
-		return err;
-
+	mutex_lock(&lif->queue_lock);
 	running = netif_running(lif->netdev);
 	if (running) {
 		netif_device_detach(lif->netdev);
 		err = ionic_stop(lif->netdev);
 		if (err)
-			goto reset_out;
+			return err;
 	}
 
 	if (cb)
@@ -2009,9 +2011,7 @@ int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 		err = ionic_open(lif->netdev);
 		netif_device_attach(lif->netdev);
 	}
-
-reset_out:
-	clear_bit(IONIC_LIF_F_QUEUE_RESET, lif->state);
+	mutex_unlock(&lif->queue_lock);
 
 	return err;
 }
@@ -2158,7 +2158,9 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 
 	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 		dev_info(ionic->dev, "Surprise FW stop, stopping queues\n");
+		mutex_lock(&lif->queue_lock);
 		ionic_stop_queues(lif);
+		mutex_unlock(&lif->queue_lock);
 	}
 
 	if (netif_running(lif->netdev)) {
@@ -2285,6 +2287,7 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
+	mutex_destroy(&lif->queue_lock);
 	ionic_lif_reset(lif);
 }
 
@@ -2461,6 +2464,7 @@ static int ionic_lif_init(struct ionic_lif *lif)
 		return err;
 
 	lif->hw_index = le16_to_cpu(comp.hw_index);
+	mutex_init(&lif->queue_lock);
 
 	/* now that we have the hw_index we can figure out our doorbell page */
 	lif->dbid_count = le32_to_cpu(lif->ionic->ident.dev.ndbpgs_per_lif);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index ed126dd74e01..8dc2c5d77424 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -135,7 +135,6 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_SW_DEBUG_STATS,
 	IONIC_LIF_F_UP,
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
-	IONIC_LIF_F_QUEUE_RESET,
 	IONIC_LIF_F_FW_RESET,
 
 	/* leave this as last */
@@ -165,6 +164,7 @@ struct ionic_lif {
 	unsigned int hw_index;
 	unsigned int kern_pid;
 	u64 __iomem *kern_dbpage;
+	struct mutex queue_lock;	/* lock for queue structures */
 	spinlock_t adminq_lock;		/* lock for AdminQ operations */
 	struct ionic_qcq *adminqcq;
 	struct ionic_qcq *notifyqcq;
@@ -213,12 +213,6 @@ struct ionic_lif {
 #define lif_to_txq(lif, i)	(&lif_to_txqcq((lif), i)->q)
 #define lif_to_rxq(lif, i)	(&lif_to_txqcq((lif), i)->q)
 
-/* return 0 if successfully set the bit, else non-zero */
-static inline int ionic_wait_for_bit(struct ionic_lif *lif, int bitname)
-{
-	return wait_on_bit_lock(lif->state, bitname, TASK_INTERRUPTIBLE);
-}
-
 static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
 {
 	u32 mult = le32_to_cpu(ionic->ident.dev.intr_coal_mult);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index b7f900c11834..85eb8f276a37 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -161,12 +161,6 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		return;
 	}
 
-	/* no packet processing while resetting */
-	if (unlikely(test_bit(IONIC_LIF_F_QUEUE_RESET, q->lif->state))) {
-		stats->dropped++;
-		return;
-	}
-
 	stats->pkts++;
 	stats->bytes += le16_to_cpu(comp->len);
 
-- 
2.17.1

