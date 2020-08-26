Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB23253529
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgHZQoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbgHZQmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4743C061797
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:39 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u128so1262428pfb.6
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cvnm9Fng0FoTsyTeKhv4fK4J0DmtFZsHWVw6ISw+sAo=;
        b=BBjPXCgv4hQByn0VObUN6P2geI6OwgT2WJYZOtM8iIMz4NfqGwcmSgB7KN6I5GnCtZ
         M9ncyPLvcVHTTS47kjLsnQnyj5GyinU3leYAuj8Zu8Z5RB+yR8sG77/o4A2I88hcbJDM
         GT5cAS26zN1QJz5ziy0k/7B+UsaH8AHUthmcICJbFnppfeV8nliEeDfkAj3kOJtzCajI
         JY+s4ZxOTxxUVzElD7F0HVPDo8JUXwzrcaa1C+UfikjABrCFfE3MyneaB8T7w/m+lulj
         Z0ctdd4sQp3gPqaX6ysD++pCucqN+v4jfDnJ3/Qt2onuMWnXgCKK4gK8PxJm56D49Bfh
         xBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cvnm9Fng0FoTsyTeKhv4fK4J0DmtFZsHWVw6ISw+sAo=;
        b=kpE3iBzwQb+nd2uZHOL1YnommGn733yVLucLcbxxEdZMHviefDI/T7i4+siOD6Z0hN
         FbDhN2v3prKU6Hi5mssuE+1soEipDL2q8YrrYwpueoiZ62Xf5NBlHr/NtPtynFkoST8i
         pk4mCZ6KMM3Y7RlgHRfW56ypOB4ujDyPXKdvc5cpY+AT6AlNGOCCrT3NQK1XHtGr2Wgs
         kZQID4O0n1hBA5El2SW+JnW19gUqXiKCkTPSbuT5ws/BRw+lt139V2overprjUx3uiVr
         DUHfkVkbi3IMSLG96kn8Clkdrkb8n83eROWzMdawUOTDG7oR1YMT7g1djmuIau7lNFeg
         kSiQ==
X-Gm-Message-State: AOAM532g2YF3B3f6YuVs6jIfaXV9jGAAVFhr7b3SYcPNV6inEH/FWuIx
        K17wSur/NYJTidDZ6x5aVeL4iqkKvJhV9w==
X-Google-Smtp-Source: ABdhPJz5RTe5Xv2ovLBpONtahEBY5o07xQebn82oY/Lm9bIlC96S3NGE/0abFYRKHj/kTepsSI2XXQ==
X-Received: by 2002:a63:6a47:: with SMTP id f68mr11072277pgc.170.1598460159067;
        Wed, 26 Aug 2020 09:42:39 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:38 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 12/12] ionic: pull reset_queues into tx_timeout handler
Date:   Wed, 26 Aug 2020 09:42:14 -0700
Message-Id: <20200826164214.31792-13-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826164214.31792-1-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert tx_timeout handler to not do the full reset.  As this was
the last user of ionic_reset_queues(), we can drop it.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 51 ++++++++-----------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  1 -
 2 files changed, 20 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0da975a45692..10165dd198c1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1393,12 +1393,29 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 static void ionic_tx_timeout_work(struct work_struct *ws)
 {
 	struct ionic_lif *lif = container_of(ws, struct ionic_lif, tx_timeout_work);
+	int err;
 
 	netdev_info(lif->netdev, "Tx Timeout recovery\n");
 
-	rtnl_lock();
-	ionic_reset_queues(lif, NULL, NULL);
-	rtnl_unlock();
+	/* if we were stopped before this scheduled job was launched,
+	 * don't bother the queues as they are already stopped.
+	 */
+	if (!netif_running(lif->netdev))
+		return;
+
+	/* stop and clean the queues */
+	mutex_lock(&lif->queue_lock);
+	netif_device_detach(lif->netdev);
+	ionic_stop_queues(lif);
+	ionic_txrx_deinit(lif);
+
+	/* re-init the queues */
+	err = ionic_txrx_init(lif);
+	if (!err)
+		ionic_start_queues(lif);
+
+	netif_device_attach(lif->netdev);
+	mutex_unlock(&lif->queue_lock);
 }
 
 static void ionic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
@@ -2280,34 +2297,6 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	return err;
 }
 
-int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
-{
-	bool running;
-	int err = 0;
-
-	mutex_lock(&lif->queue_lock);
-	running = netif_running(lif->netdev);
-	if (running) {
-		netif_device_detach(lif->netdev);
-		err = ionic_stop(lif->netdev);
-		if (err)
-			goto reset_out;
-	}
-
-	if (cb)
-		cb(lif, arg);
-
-	if (running) {
-		err = ionic_open(lif->netdev);
-		netif_device_attach(lif->netdev);
-	}
-
-reset_out:
-	mutex_unlock(&lif->queue_lock);
-
-	return err;
-}
-
 int ionic_lif_alloc(struct ionic *ionic)
 {
 	struct device *dev = ionic->dev;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 1df3e1e4107b..e1e6ff1a0918 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -259,7 +259,6 @@ int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 			 const u8 *key, const u32 *indir);
 int ionic_reconfigure_queues(struct ionic_lif *lif,
 			     struct ionic_queue_params *qparam);
-int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg);
 
 static inline void debug_stats_txq_post(struct ionic_queue *q, bool dbell)
 {
-- 
2.17.1

