Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFA8E0D41
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 22:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389153AbfJVUb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 16:31:28 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40267 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731256AbfJVUb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 16:31:28 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so8884872pll.7
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 13:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Yuw7YcwH8Dw2tAhvZv+UyUY+2BInkM5t58oJhGkHldI=;
        b=WnV+MdGDjXtskFwJA5fXgDwIh1wpj3AEwDjRIIaxiYJnRKNiDeNmRLVqZoyUc/Xq4h
         4tOVO74ob/3VopruNU3aNh+y4O3lkrwiIj27qtt58HL/SGZ+vPIqZJjf58G0UgLu60ru
         kS5SShWR4ATWJhQQqsqOrPwztzkA+zaSibasrOADkO/Ceg1R1QSUlqTx2czCVfeKG34+
         GnfbJtwDHwJxoEHjloDMVSxyQrjRl9lrvS7rXsYzfYSG/946p9ZRHNo5GD5to8LRFkVM
         9cTmEsGzm0r1mE+21tJlqSFHsny8ZYoR3bJa0sISEj1BY7xOBVDw3ZzZ0nBR1UH6ZgOM
         KLPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Yuw7YcwH8Dw2tAhvZv+UyUY+2BInkM5t58oJhGkHldI=;
        b=dTI9DHuqI6KMUedgWxQBjuohvidZxwBLB68yx4+Z1+nzPMStksRR0jkgvy26WfBzuT
         31Xh/+ljeP0YPdsCkpLsq4QiNtgk+ikpNKI3DaWt3HNklKWrZErYC7Y4dQATEk6Omvtc
         8x+8nj5wmBhRzm/ikyZKRutw2BGMvt9Mh2/1FEU6ews1Y9Y4Fe76opnmosckRfDcw/HE
         bEzwsiZMxpxgXoh2F4+/BhwHdkT1GoL2euv4MZJYUZW0I6VtjtNW4p2iGzV1M5aTt9/M
         IiroiajlDSKSjwwnk2g3kfErFXmjSvvXXMyp/sxy+37TJiSjDooE/I93H03CQ2sgVLx1
         GwMQ==
X-Gm-Message-State: APjAAAX1NkToD2U6s62pTSHB5YZkDa3kAVWroL0A5t3ww4uBH7rrCRhf
        vHpMDwtF+Rb1SfxR22g+f6LM86J0ArFs0w==
X-Google-Smtp-Source: APXvYqyQQc0rvZQIJ4qGbm98khREETSsxeqgRWY3Rm7TCFt9SGJJ8E37YyXxhi92zFBSVEmaITwJgg==
X-Received: by 2002:a17:902:322:: with SMTP id 31mr5480098pld.293.1571776286941;
        Tue, 22 Oct 2019 13:31:26 -0700 (PDT)
Received: from driver-dev1.pensando.io.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id q143sm20754530pfq.103.2019.10.22.13.31.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 13:31:26 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/6] ionic: add a watchdog timer to monitor heartbeat
Date:   Tue, 22 Oct 2019 13:31:11 -0700
Message-Id: <20191022203113.30015-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191022203113.30015-1-snelson@pensando.io>
References: <20191022203113.30015-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a watchdog to periodically monitor the NIC heartbeat.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  2 ++
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 19 +++++++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 7a7060677f15..5b013250f8c3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -46,6 +46,8 @@ struct ionic {
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
 	struct work_struct nb_work;
 	struct notifier_block nb;
+	struct timer_list watchdog_timer;
+	int watchdog_period;
 };
 
 struct ionic_admin_ctx {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 544a9f799afc..5f9d2ec70446 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -11,6 +11,16 @@
 #include "ionic_dev.h"
 #include "ionic_lif.h"
 
+static void ionic_watchdog_cb(struct timer_list *t)
+{
+	struct ionic *ionic = from_timer(ionic, t, watchdog_timer);
+
+	mod_timer(&ionic->watchdog_timer,
+		  round_jiffies(jiffies + ionic->watchdog_period));
+
+	ionic_heartbeat_check(ionic);
+}
+
 void ionic_init_devinfo(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
@@ -72,6 +82,11 @@ int ionic_dev_setup(struct ionic *ionic)
 		return -EFAULT;
 	}
 
+	timer_setup(&ionic->watchdog_timer, ionic_watchdog_cb, 0);
+	ionic->watchdog_period = IONIC_WATCHDOG_SECS * HZ;
+	mod_timer(&ionic->watchdog_timer,
+		  round_jiffies(jiffies + ionic->watchdog_period));
+
 	idev->db_pages = bar->vaddr;
 	idev->phy_db_pages = bar->bus_addr;
 
@@ -80,7 +95,7 @@ int ionic_dev_setup(struct ionic *ionic)
 
 void ionic_dev_teardown(struct ionic *ionic)
 {
-	/* place holder */
+	del_timer_sync(&ionic->watchdog_timer);
 }
 
 /* Devcmd Interface */
@@ -93,7 +108,7 @@ int ionic_heartbeat_check(struct ionic *ionic)
 
 	/* wait a little more than one second before testing again */
 	hb_time = jiffies;
-	if (time_before(hb_time, (idev->last_hb_time + (HZ * 2))))
+	if (time_before(hb_time, (idev->last_hb_time + ionic->watchdog_period)))
 		return 0;
 
 	/* firmware is useful only if fw_status is non-zero */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 1ffb3e4dec5d..78691c1ba20b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -16,6 +16,7 @@
 #define IONIC_MIN_TXRX_DESC		16
 #define IONIC_DEF_TXRX_DESC		4096
 #define IONIC_LIFS_MAX			1024
+#define IONIC_WATCHDOG_SECS		5
 #define IONIC_ITR_COAL_USEC_DEFAULT	64
 
 #define IONIC_DEV_CMD_REG_VERSION	1
-- 
2.17.1

