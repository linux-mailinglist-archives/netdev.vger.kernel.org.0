Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03524183BB9
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCLVu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:50:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36184 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:50:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id g2so702654plo.3
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6lmGBSPUfVIaACv+X8H3ofoFkhY/4KtRsO+aBb8AcPI=;
        b=uYDe71jscbUKjLsToOiSNloTaA+XUdjzFLxCZeVuaJetmGtN2/RzmwHAeY2sl6Ot7B
         f5H98DwYP0s0XSPUKh4TU1G/4cDlqg+nD4UHi8/Qyr0lzQXdhBw9kr7KOYCPY37AkAix
         drvMD5NArUERCE6yG7GwNv9cPOoK7zWNY4UtzZefr5nqNwWmhEjXPxHZf2a2u7OGi899
         zlCcZkMa8cC1zPx2lpcGjOXyB+vhi/ExyndZc484Q6SjvdzdaPvM2wjVQnYqjFfn50AJ
         /5CmL8aOMKaHMQbnZPJUMIU8/+vdG90+WvL4SrmeFSMi+YZfDkgWA4rTKo+Dn+2Wxcm0
         J7UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6lmGBSPUfVIaACv+X8H3ofoFkhY/4KtRsO+aBb8AcPI=;
        b=YShYfOdOpz1Ecb/HwWRDEIn7asbMQO2BZOJr8rEDkzcdcE99pdlYtPkGqFjHKUsSzw
         h2ldSHH/9zyUq9L/VzQzCmPgzcEVeJ4pxfFzZEwWWOOQ5DTQ0EWfvHfdh0Y3g3hqAXti
         KW/ffwQrrIheD3S03n/8J6qS4SDzfwyOfk4TqZW4pKjdjKcNHK03A1C4pZvPyO/M/uoz
         H93VsMIcD6gd8JLDl5o4an6B8wO+2Bc1zm7kIeMoJ88Mj/iz3Dss9VjlN79u23LsoWk7
         uOitK6WpoBI/15nXwTMOilTPNnY3clzF4s9yT8oURPlsWYIhSmHnoh4IUtZEEvA3Uq7M
         r0FQ==
X-Gm-Message-State: ANhLgQ1kTC/Xh+BqeZ0mQ1IX+0SEs4SCxKHWQ1CJ1CKyIl6lf9hIvQcK
        0EGO2S8Dv49mwiN7tsxYOllzeKjkRl0=
X-Google-Smtp-Source: ADFU+vufYP0lo/+e07bHWowsp2SY181MOVqPUpGqQ3i3D+IEhJ1S+qnipYowltBItS8VZz8csjwGIQ==
X-Received: by 2002:a17:902:14b:: with SMTP id 69mr10120942plb.121.1584049827662;
        Thu, 12 Mar 2020 14:50:27 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p2sm38281203pfb.41.2020.03.12.14.50.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 14:50:26 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/7] ionic: tx and rx queues state follows link state
Date:   Thu, 12 Mar 2020 14:50:09 -0700
Message-Id: <20200312215015.69547-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312215015.69547-1-snelson@pensando.io>
References: <20200312215015.69547-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When link goes down, tear down the Tx and Rx queues.  When
link comes back up, rebuild the queues.  This lets us release
memory resources for devices that aren't going to use them,
and prepares us for support of fw upgrade.  We also add a
couple of checks on tear down to watch out for structs
already torn down.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 76 +++++++++++++------
 .../net/ethernet/pensando/ionic/ionic_main.c  |  7 +-
 2 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index aaf4a40fa98b..682f4b5af704 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -73,6 +73,11 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	u16 link_status;
 	bool link_up;
 
+	if (lif->ionic->is_mgmt_nic) {
+		clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
+		return;
+	}
+
 	link_status = le16_to_cpu(lif->info->status.link_status);
 	link_up = link_status == IONIC_PORT_OPER_STATUS_UP;
 
@@ -81,20 +86,28 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 		goto link_out;
 
 	if (link_up) {
-		netdev_info(netdev, "Link up - %d Gbps\n",
-			    le32_to_cpu(lif->info->status.link_speed) / 1000);
+		u32 link_speed;
 
-		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
-			netif_tx_wake_all_queues(lif->netdev);
-			netif_carrier_on(netdev);
+		link_speed = le16_to_cpu(lif->info->status.link_speed);
+		netdev_info(netdev, "Link up - %d Gbps\n", link_speed / 1000);
+
+		if (!test_bit(IONIC_LIF_F_UP, lif->state) &&
+		    netif_running(netdev)) {
+			rtnl_lock();
+			ionic_open(netdev);
+			rtnl_unlock();
 		}
+
+		netif_carrier_on(netdev);
 	} else {
 		netdev_info(netdev, "Link down\n");
-
-		/* carrier off first to avoid watchdog timeout */
 		netif_carrier_off(netdev);
-		if (test_bit(IONIC_LIF_F_UP, lif->state))
-			netif_tx_stop_all_queues(netdev);
+
+		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
+			rtnl_lock();
+			ionic_stop(netdev);
+			rtnl_unlock();
+		}
 	}
 
 link_out:
@@ -275,8 +288,10 @@ static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_SET);
+		irq_set_affinity_hint(qcq->intr.vector, NULL);
 		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
 		netif_napi_del(&qcq->napi);
+		qcq->intr.vector = 0;
 	}
 
 	qcq->flags &= ~IONIC_QCQ_F_INITED;
@@ -318,19 +333,21 @@ static void ionic_qcqs_free(struct ionic_lif *lif)
 		lif->adminqcq = NULL;
 	}
 
-	for (i = 0; i < lif->nxqs; i++)
-		if (lif->rxqcqs[i].stats)
-			devm_kfree(dev, lif->rxqcqs[i].stats);
-
-	devm_kfree(dev, lif->rxqcqs);
-	lif->rxqcqs = NULL;
-
-	for (i = 0; i < lif->nxqs; i++)
-		if (lif->txqcqs[i].stats)
-			devm_kfree(dev, lif->txqcqs[i].stats);
+	if (lif->rxqcqs) {
+		for (i = 0; i < lif->nxqs; i++)
+			if (lif->rxqcqs[i].stats)
+				devm_kfree(dev, lif->rxqcqs[i].stats);
+		devm_kfree(dev, lif->rxqcqs);
+		lif->rxqcqs = NULL;
+	}
 
-	devm_kfree(dev, lif->txqcqs);
-	lif->txqcqs = NULL;
+	if (lif->txqcqs) {
+		for (i = 0; i < lif->nxqs; i++)
+			if (lif->txqcqs[i].stats)
+				devm_kfree(dev, lif->txqcqs[i].stats);
+		devm_kfree(dev, lif->txqcqs);
+		lif->txqcqs = NULL;
+	}
 }
 
 static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
@@ -1573,7 +1590,17 @@ int ionic_open(struct net_device *netdev)
 	struct ionic_lif *lif = netdev_priv(netdev);
 	int err;
 
-	netif_carrier_off(netdev);
+	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
+		dev_dbg(lif->ionic->dev, "%s: %s called when state=UP\n",
+			__func__, lif->name);
+		return 0;
+	}
+
+	ionic_link_status_check_request(lif);
+
+	/* wait until carrier is up before creating rx and tx queues */
+	if (!netif_carrier_ok(lif->netdev))
+		return 0;
 
 	err = ionic_txrx_alloc(lif);
 	if (err)
@@ -1592,7 +1619,6 @@ int ionic_open(struct net_device *netdev)
 
 	set_bit(IONIC_LIF_F_UP, lif->state);
 
-	ionic_link_status_check_request(lif);
 	if (netif_carrier_ok(netdev))
 		netif_tx_wake_all_queues(netdev);
 
@@ -1611,7 +1637,7 @@ int ionic_stop(struct net_device *netdev)
 	int err = 0;
 
 	if (!test_bit(IONIC_LIF_F_UP, lif->state)) {
-		dev_dbg(lif->ionic->dev, "%s: %s state=DOWN\n",
+		dev_dbg(lif->ionic->dev, "%s: %s called when state=DOWN\n",
 			__func__, lif->name);
 		return 0;
 	}
@@ -1922,6 +1948,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	ionic_ethtool_set_ops(netdev);
 
 	netdev->watchdog_timeo = 2 * HZ;
+	netif_carrier_off(netdev);
+
 	netdev->min_mtu = IONIC_MIN_MTU;
 	netdev->max_mtu = IONIC_MAX_MTU;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index e4a76e66f542..40345281b2c9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -240,11 +240,16 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 
 static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 {
-	struct ionic_queue *adminq = &lif->adminqcq->q;
+	struct ionic_queue *adminq;
 	int err = 0;
 
 	WARN_ON(in_interrupt());
 
+	if (!lif->adminqcq)
+		return -EIO;
+
+	adminq = &lif->adminqcq->q;
+
 	spin_lock(&lif->adminq_lock);
 	if (!ionic_q_has_space(adminq, 1)) {
 		err = -ENOSPC;
-- 
2.17.1

