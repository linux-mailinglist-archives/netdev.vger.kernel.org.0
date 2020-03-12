Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC724183BBD
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgCLVuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:50:37 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53479 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbgCLVug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:50:36 -0400
Received: by mail-pj1-f66.google.com with SMTP id l36so3097414pjb.3
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1sr/4g4Q1cQnzUEDN5BpVtg+06CiQzgIx2eChhETje4=;
        b=nt7Z269820Ii0G5zCZp0YPT/PWt+py9sYPSCUefkupycROerizJPB94/i9I8YyOrYm
         ePXEXIXFYt4Fd0rLM5aGQ8RluV8hc2gQsjAmWndv/2NNRlnT8JDV94+mH2aKI3FlbMqO
         k/kKNnj0wpy8K5kh9O3+pxuACJMrzcXUYaxIrXgwCOcdzURtupdb367uf7HWyUEIqx80
         8loT/Y7I/+exLOoHyuRgBjLr1H3VEOO8araHSdC4uI9jN4sq7xC1GGohCh763SffiLGA
         G23Gjc/C0qoF1jNptvVElTJkmtqP7lwKQJDG9Usj6YlYQm2v9dag19DgtHRlQegd2DrM
         01VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1sr/4g4Q1cQnzUEDN5BpVtg+06CiQzgIx2eChhETje4=;
        b=C9Cz4neVjpvTC3DDmQemp0gWiV+H7rai05M4JDcKfrY5CQmkVvQPq2RoFxgpo16eQI
         P3qpwkVsM8ZGhLF9apLy8hec5Oy2nE2TvN+GgWTAv2OLiA8v9fOOexcA5dlnk4MaGt44
         zgHfMST4UQA7KD1hB+5Q9QYs3jW4MRwwFFVrDeqpx7wWt9AvVBJD1Q+riag84em647he
         fzLk3yGK3eAhcBnMJ80b6fC3MIQt0wOwIZWZjHC9wQVpsFJFXknv3V78MmDeOtuFRJQx
         OG42trWKoI0vGNKsY1EBfeIbmXqmcSdzFfd/HjHcMxjBSAplFB4TWsAvSwrsJhOHMvS0
         Dr+g==
X-Gm-Message-State: ANhLgQ0PtYf16k4VOynOaKH57iBbRNj1xfHcI3USpd7/zI+NIkTO1f0f
        yHnlmurT1Cn7Yb4Y4AufZlgja1roPDk=
X-Google-Smtp-Source: ADFU+vtaoDOBmexFuSnYXYuNPEMduq1t9uVQY15JUWKWBGs4nUu9LN7eyge0Fut0DHAFDKGNh1Ky2A==
X-Received: by 2002:a17:90a:e7c8:: with SMTP id kb8mr6248210pjb.113.1584049834554;
        Thu, 12 Mar 2020 14:50:34 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p2sm38281203pfb.41.2020.03.12.14.50.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 14:50:33 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/7] ionic: trigger fw reset response on fw_status
Date:   Thu, 12 Mar 2020 14:50:14 -0700
Message-Id: <20200312215015.69547-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312215015.69547-1-snelson@pensando.io>
References: <20200312215015.69547-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the fw_status goes to 0 (stopped) or to 0xff (no PCI
connection), then shut down the driver activity.  Normally
the driver will have received a RESET event to stop its
activity, but if the events weren't sent, or the firmware
was rebooted or crashed, this will catch the issue and
quiesce the driver.

When the fw_status goes back to IONIC_FW_STS_F_RUNNING
we can restart the driver operations.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 46 ++++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 +
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 46107de5e6c3..bb513db7163c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -82,6 +82,7 @@ int ionic_dev_setup(struct ionic *ionic)
 		return -EFAULT;
 	}
 
+	idev->last_fw_status = 0xff;
 	timer_setup(&ionic->watchdog_timer, ionic_watchdog_cb, 0);
 	ionic->watchdog_period = IONIC_WATCHDOG_SECS * HZ;
 	mod_timer(&ionic->watchdog_timer,
@@ -115,8 +116,49 @@ int ionic_heartbeat_check(struct ionic *ionic)
 	 * fw_status != 0xff (bad PCI read)
 	 */
 	fw_status = ioread8(&idev->dev_info_regs->fw_status);
-	if (fw_status == 0xff ||
-	    !(fw_status & IONIC_FW_STS_F_RUNNING))
+	if (fw_status != 0xff)
+		fw_status &= IONIC_FW_STS_F_RUNNING;  /* use only the run bit */
+
+	/* is this a transition? */
+	if (fw_status != idev->last_fw_status &&
+	    idev->last_fw_status != 0xff) {
+		struct ionic_lif *lif = ionic->master_lif;
+		bool trigger = false;
+
+		if (!fw_status || fw_status == 0xff) {
+			dev_info(ionic->dev, "FW stopped %u\n", fw_status);
+			if (lif &&
+			    !test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
+				dev_info(ionic->dev, "... stopping queues\n");
+				trigger = true;
+			}
+		} else {
+			dev_info(ionic->dev, "FW running %u\n", fw_status);
+			if (lif &&
+			    test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
+				dev_info(ionic->dev, "... starting queues\n");
+				trigger = true;
+			}
+		}
+
+		if (trigger) {
+			struct ionic_deferred_work *work;
+
+			work = kzalloc(sizeof(*work), GFP_ATOMIC);
+			if (!work) {
+				dev_err(ionic->dev, "%s OOM\n", __func__);
+			} else {
+				work->type = IONIC_DW_TYPE_LIF_RESET;
+				if (fw_status & IONIC_FW_STS_F_RUNNING &&
+				    fw_status != 0xff)
+					work->fw_status = 1;
+				ionic_lif_deferred_enqueue(&lif->deferred, work);
+			}
+		}
+	}
+	idev->last_fw_status = fw_status;
+
+	if (!fw_status || fw_status == 0xff)
 		return -ENXIO;
 
 	/* early FW has no heartbeat, else FW will return non-zero */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 7838e342c4fd..587398b01997 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -132,6 +132,7 @@ struct ionic_dev {
 
 	unsigned long last_hb_time;
 	u32 last_hb;
+	u8 last_fw_status;
 
 	u64 __iomem *db_pages;
 	dma_addr_t phy_db_pages;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index a6af75031347..8027b72835b6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -67,8 +67,8 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 	}
 }
 
-static void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
-				       struct ionic_deferred_work *work)
+void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
+				struct ionic_deferred_work *work)
 {
 	spin_lock_bh(&def->lock);
 	list_add_tail(&work->list, &def->list);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 732dc1f99d24..fdbb25774755 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -226,6 +226,8 @@ static inline u32 ionic_coal_hw_to_usec(struct ionic *ionic, u32 units)
 	return (units * div) / mult;
 }
 
+void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
+				struct ionic_deferred_work *work);
 int ionic_lifs_alloc(struct ionic *ionic);
 void ionic_lifs_free(struct ionic *ionic);
 void ionic_lifs_deinit(struct ionic *ionic);
-- 
2.17.1

