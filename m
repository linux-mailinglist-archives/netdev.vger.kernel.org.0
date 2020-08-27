Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC211254C9B
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgH0SIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgH0SIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:08:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F8BC061232
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:08:00 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l191so3919725pgd.5
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tSmDAHkMXPl++bPa2UOx3xd09BIuBlF3M4vk4WxfH9Q=;
        b=cAgnGd3IvWM97tUnpqgNiUCL4Ddhjxq2AuUEb8TLozydJ4n0gzlhWoozUi1rDXyeXM
         oNd6/XiaPu5GHNTv+XQV6NudeIsLr2PCCuf29x73AeIxcmAVcUoGPgN4wOhG6uyFNY1q
         Ym0nAuy/5hehscgAlWidTsx/Nge6cmgFAqe6l2sNA+9lyiI4aaxJUxL9Y36fJ5aLnixL
         ic1Ykyzjvi7JgurbVLe9ywcsx+9VafvJYn0qgb0lTtT2JWnVc3oBvxBFWwaLBbncQjLu
         TSD/1a74XmR1le8Mvrs5A1z7sWzYBLRZSjCSkAcv3FvTecpLN0LJ4ZptrhJNDLAY0qRe
         GxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tSmDAHkMXPl++bPa2UOx3xd09BIuBlF3M4vk4WxfH9Q=;
        b=QUpj4OYPng7ULTClmhvICbENylHt87EGq5XzOZyVMWN86GFOVeD04uYsReReNJlBV4
         UzdS1VhBlRygePzvg0TY57bPArW053yn4cvD12dk9XVWWjSIH6/e+CU2WSNYRpA91Tp3
         GNakyzLW6FmxHbS77dCkGgIMqp5cQEVkkJe7KN7ACOkF3iqN3ZBjFUnn5BIiq5kNAcay
         8k0xKSDj0Km0JGSpt0kuR8ho0e4bfXsrcjtIFkSUIvKVWo48YVBE8KB2J0uzZD6KTTGp
         JMIUNrfUEMBFFIIRObriiIssC7+OPVWkKa9xdOwwL6yZjaGPzy1ksR9Di26xU2BYAIzR
         Na5g==
X-Gm-Message-State: AOAM532OuEAyPW3zQLn7XhcWA+3jbI2l2+j6FM1dNhlAxE83iuLpNm17
        NEaM6W64QycNW5x1D892vLzyFIMQ4V3ZdQ==
X-Google-Smtp-Source: ABdhPJz8yrAGq21LwDSRuk7MDYFxVOqkvL9nySvSTwvaL5QxPEE4eFJSinNeggpRo3ZijMYKaToDWg==
X-Received: by 2002:a17:902:8f8f:: with SMTP id z15mr17072564plo.221.1598551679160;
        Thu, 27 Aug 2020 11:07:59 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n1sm3480249pfu.2.2020.08.27.11.07.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 11:07:58 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 09/12] ionic: change mtu without full queue rebuild
Date:   Thu, 27 Aug 2020 11:07:32 -0700
Message-Id: <20200827180735.38166-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827180735.38166-1-snelson@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
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
index 4699a54bb6d6..581eeb822f90 100644
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

