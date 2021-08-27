Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06713F9F4E
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhH0S41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhH0S4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:56:18 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F873C061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e1so4489983plt.11
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9l2wt6OwJGcugjZsy/yl2WnDB+W5MZOOMtJkPLOAVNY=;
        b=UBKwNIJU709NSLtbx+MGb3wwZO5CxGg5+2u9Yei02VeOU0k/iK9yW6iCDjOfTG7eLn
         DUKStBF7DZcx3B+XqEzyGrtILzkU6lQEJnVZ27g74U0QA4lUGBbolCLa/v228FLQaHVF
         ltETxlMMsttroqU6v8Yk0RpFGfuPfdMxG87vrnd52zZW+0MsxRz1d7cto/BFw2h7If4R
         hfRjt0ZUEDIIi2uDiewAcazi551NaIVSIgPvVclRe/IUMpvnl6r/fsSI3JnKQsGhHIFq
         5qUbBi5VRuD9gu2XiJWD9SsDHMeLSvPa4fpubVRcJpdi8bAH8aF4c2GaR0aTmFxZykx1
         izAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9l2wt6OwJGcugjZsy/yl2WnDB+W5MZOOMtJkPLOAVNY=;
        b=AGm12dEBvW25ZCMyrgnYrzN6T7vX4yb/1ZP5ARbST00dCQTdNShC6v+MLgZl5wSUBt
         l2eDgk07Zc98saz9gL67mdp184HQGdeNmkamSBf6Ff0HLFfHZ/DSlovLc9RsLSvcxvF/
         5m7VuaJVIRzfQbTKXUIjpDUHfJ00SaRJL9GGZSXcxuUJD7lkcWRRXKcgjCqFzAP2qhHA
         9b3kE0ZxoU8thVg9cJYQD+iQZQ7xO1pqK2oPCr14n7Vp2vqqaGpK6CR7jJjMIck+VveK
         pYbd4Dd27AYrdtzhQ8MqPfVxntNRNY9tfuMBUAqi5IXVoFvIyxnv+S1RUPvMjtzvFIMg
         P6aw==
X-Gm-Message-State: AOAM531f9cBKOPi7mnCe9IkZn8LRyYS7bMm91c/MSDrzdSyoYVT60PgH
        brSWrSGJdqsEavZfj2SSFrEFkA==
X-Google-Smtp-Source: ABdhPJwhHIbTyQrPWk2VyhpAwvVEke+B3xF0F6CGixcmDwIGaNIxXvc9KfH4+5cMCOwOd932a+XXFg==
X-Received: by 2002:a17:902:ea89:b0:134:7eb7:b4d7 with SMTP id x9-20020a170902ea8900b001347eb7b4d7mr9921470plb.43.1630090529087;
        Fri, 27 Aug 2021 11:55:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f10sm7565975pgm.77.2021.08.27.11.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 11:55:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 6/6] ionic: recreate hwstamp queues on ifup
Date:   Fri, 27 Aug 2021 11:55:12 -0700
Message-Id: <20210827185512.50206-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210827185512.50206-1-snelson@pensando.io>
References: <20210827185512.50206-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The queues can be freed in ionic_close().  They need to be recreated
after ionic_open().  It doesn't need to replay the whole config.  It
only needs to create the timestamping queues again.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  6 +++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 ++
 .../net/ethernet/pensando/ionic/ionic_phc.c   | 24 +++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 96e7e289b7d3..23c9e196a784 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2246,7 +2246,13 @@ static int ionic_open(struct net_device *netdev)
 			goto err_txrx_deinit;
 	}
 
+	/* If hardware timestamping is enabled, but the queues were freed by
+	 * ionic_stop, those need to be reallocated and initialized, too.
+	 */
+	ionic_lif_hwstamp_recreate_queues(lif);
+
 	mutex_unlock(&lif->queue_lock);
+
 	return 0;
 
 err_txrx_deinit:
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index cad193d358e8..4915184f3efb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -306,6 +306,7 @@ int ionic_lif_size(struct ionic *ionic);
 
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
 void ionic_lif_hwstamp_replay(struct ionic_lif *lif);
+void ionic_lif_hwstamp_recreate_queues(struct ionic_lif *lif);
 int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr);
 int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr);
 ktime_t ionic_lif_phc_ktime(struct ionic_lif *lif, u64 counter);
@@ -315,6 +316,7 @@ void ionic_lif_alloc_phc(struct ionic_lif *lif);
 void ionic_lif_free_phc(struct ionic_lif *lif);
 #else
 static inline void ionic_lif_hwstamp_replay(struct ionic_lif *lif) {}
+static inline void ionic_lif_hwstamp_recreate_queues(struct ionic_lif *lif) {}
 
 static inline int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index c39790a6c436..eed2db69d708 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -222,6 +222,30 @@ void ionic_lif_hwstamp_replay(struct ionic_lif *lif)
 		netdev_info(lif->netdev, "hwstamp replay failed: %d\n", err);
 }
 
+void ionic_lif_hwstamp_recreate_queues(struct ionic_lif *lif)
+{
+	int err;
+
+	if (!lif->phc || !lif->phc->ptp)
+		return;
+
+	mutex_lock(&lif->phc->config_lock);
+
+	if (lif->phc->ts_config_tx_mode) {
+		err = ionic_lif_create_hwstamp_txq(lif);
+		if (err)
+			netdev_info(lif->netdev, "hwstamp recreate txq failed: %d\n", err);
+	}
+
+	if (lif->phc->ts_config_rx_filt) {
+		err = ionic_lif_create_hwstamp_rxq(lif);
+		if (err)
+			netdev_info(lif->netdev, "hwstamp recreate rxq failed: %d\n", err);
+	}
+
+	mutex_unlock(&lif->phc->config_lock);
+}
+
 int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr)
 {
 	struct hwtstamp_config config;
-- 
2.17.1

