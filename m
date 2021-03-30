Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB4834F1D8
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 21:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhC3Twl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 15:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbhC3Tw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 15:52:29 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9401DC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 12:52:29 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id a12so3987532pfc.7
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 12:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0OmKx8ekCG10elPwxClm7fQHkDXsDBiqxtsKwxlhAf4=;
        b=kcxmgKK9mbvU0M+2UKRYnyfvKF7La3NeNbI0te1oSLPlfzrisrmAXmfY2Ef/mqa/pN
         IFNhD4p7Hr0HNAsO9ybiPAufK1+16OXkabVXYtCIRdeH7na79duHk1tclp30QfkalrAI
         jmqjp7sLULQR7Z0L/4ZDvyFAemVzQzJxbzwCyFqqWlP1ZM8pRj5YiFxDZ45X3tP2Bsrs
         bQucXLMatDc4hboUKaPc8Q34rFX2/YNp/zGKUjvKkno/p4Hm1dloEQMsjWI3Z61DhwDT
         xYwV9bE0qqUzbB5L4x+F08W+tOpRzv1Vs/94gYer4qmPJ3kGP/1OY9LeT76CVeEMCizF
         bm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0OmKx8ekCG10elPwxClm7fQHkDXsDBiqxtsKwxlhAf4=;
        b=mNDnp4aQ4Vaq0fYuGGFXZWpzfbTI9+qKVV6KjD0EIkySVqE1D7tE4Y1lnOCxhvxPo5
         TOOskGRi0W6qrIiHSzIwNmEaI9sL02zvzt8nlJzQgi3BxT2MCy0r24QyzHP6N907IufU
         spPg94fSzlrHuPXOifTCF6sjwJZde/oApMvg8Z1LQzH8k8ZqbgT+KQG0K4AvMC0cztsZ
         Nq6nsVdcMzS4NistAxW/f7uG+uMBiRYg5XBFLt32/DpXbm0ENPJ8Ir2oSCFAqDDnIYqj
         LpuF0k/X16YCwi7v+x3EHKqtBDjgMbK/Gw7HDYUWSulpHHff8A1phD/HHCaPgcvAuEWu
         SEaA==
X-Gm-Message-State: AOAM5326eUVL4NBmEc0kpATl3F1aGP+DpS8WduWWHYkPUqiiRitisIKa
        mSkcVmGuiMHmuytJ10hl3bDQLKPbHmTBmw==
X-Google-Smtp-Source: ABdhPJxeT67YXA8pdBXF5TFSRJgYDpDCIJ2no8kQ2lzGDdMNjBGNbV8uWY2JkGzOnlFvSOWsv+nDhQ==
X-Received: by 2002:a62:5e05:0:b029:20b:241e:4e18 with SMTP id s5-20020a625e050000b029020b241e4e18mr31634605pfb.1.1617133948808;
        Tue, 30 Mar 2021 12:52:28 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id y8sm20433pge.56.2021.03.30.12.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 12:52:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 3/4] ionic: avoid races in ionic_heartbeat_check
Date:   Tue, 30 Mar 2021 12:52:09 -0700
Message-Id: <20210330195210.49069-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210330195210.49069-1-snelson@pensando.io>
References: <20210330195210.49069-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rework the heartbeat checks to be sure that we're getting an
atomic operation.  Through testing we found occasions where a
separate thread could clash with this check and cause erroneous
heartbeat check results.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 93 ++++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  7 +-
 2 files changed, 63 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 0532f7cf086d..0e8e88c69e1c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -24,6 +24,9 @@ static void ionic_watchdog_cb(struct timer_list *t)
 		return;
 
 	hb = ionic_heartbeat_check(ionic);
+	dev_dbg(ionic->dev, "%s: hb %d running %d UP %d\n",
+		__func__, hb, netif_running(lif->netdev),
+		test_bit(IONIC_LIF_F_UP, lif->state));
 
 	if (hb >= 0 &&
 	    !test_bit(IONIC_LIF_F_FW_RESET, lif->state))
@@ -91,9 +94,17 @@ int ionic_dev_setup(struct ionic *ionic)
 		return -EFAULT;
 	}
 
-	idev->last_fw_status = 0xff;
 	timer_setup(&ionic->watchdog_timer, ionic_watchdog_cb, 0);
 	ionic->watchdog_period = IONIC_WATCHDOG_SECS * HZ;
+
+	/* set times to ensure the first check will proceed */
+	atomic_long_set(&idev->last_check_time, jiffies - 2 * HZ);
+	idev->last_hb_time = jiffies - 2 * ionic->watchdog_period;
+	/* init as ready, so no transition if the first check succeeds */
+	idev->last_fw_hb = 0;
+	idev->fw_hb_ready = true;
+	idev->fw_status_ready = true;
+
 	mod_timer(&ionic->watchdog_timer,
 		  round_jiffies(jiffies + ionic->watchdog_period));
 
@@ -107,29 +118,38 @@ int ionic_dev_setup(struct ionic *ionic)
 int ionic_heartbeat_check(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
-	unsigned long hb_time;
+	unsigned long check_time, last_check_time;
+	bool fw_status_ready, fw_hb_ready;
 	u8 fw_status;
-	u32 hb;
+	u32 fw_hb;
 
-	/* wait a little more than one second before testing again */
-	hb_time = jiffies;
-	if (time_before(hb_time, (idev->last_hb_time + ionic->watchdog_period)))
+	/* wait a least one second before testing again */
+	check_time = jiffies;
+	last_check_time = atomic_long_read(&idev->last_check_time);
+do_check_time:
+	if (time_before(check_time, last_check_time + HZ))
 		return 0;
+	if (!atomic_long_try_cmpxchg_relaxed(&idev->last_check_time,
+					     &last_check_time, check_time)) {
+		/* if called concurrently, only the first should proceed. */
+		dev_dbg(ionic->dev, "%s: do_check_time again\n", __func__);
+		goto do_check_time;
+	}
 
 	/* firmware is useful only if the running bit is set and
 	 * fw_status != 0xff (bad PCI read)
 	 */
 	fw_status = ioread8(&idev->dev_info_regs->fw_status);
-	if (fw_status != 0xff)
-		fw_status &= IONIC_FW_STS_F_RUNNING;  /* use only the run bit */
+	fw_status_ready = (fw_status != 0xff) && (fw_status & IONIC_FW_STS_F_RUNNING);
 
 	/* is this a transition? */
-	if (fw_status != idev->last_fw_status &&
-	    idev->last_fw_status != 0xff) {
+	if (fw_status_ready != idev->fw_status_ready) {
 		struct ionic_lif *lif = ionic->lif;
 		bool trigger = false;
 
-		if (!fw_status || fw_status == 0xff) {
+		idev->fw_status_ready = fw_status_ready;
+
+		if (!fw_status_ready) {
 			dev_info(ionic->dev, "FW stopped %u\n", fw_status);
 			if (lif && !test_bit(IONIC_LIF_F_FW_RESET, lif->state))
 				trigger = true;
@@ -143,44 +163,47 @@ int ionic_heartbeat_check(struct ionic *ionic)
 			struct ionic_deferred_work *work;
 
 			work = kzalloc(sizeof(*work), GFP_ATOMIC);
-			if (!work) {
-				dev_err(ionic->dev, "LIF reset trigger dropped\n");
-			} else {
+			if (work) {
 				work->type = IONIC_DW_TYPE_LIF_RESET;
-				if (fw_status & IONIC_FW_STS_F_RUNNING &&
-				    fw_status != 0xff)
-					work->fw_status = 1;
+				work->fw_status = fw_status_ready;
 				ionic_lif_deferred_enqueue(&lif->deferred, work);
 			}
 		}
 	}
-	idev->last_fw_status = fw_status;
 
-	if (!fw_status || fw_status == 0xff)
+	if (!fw_status_ready)
 		return -ENXIO;
 
-	/* early FW has no heartbeat, else FW will return non-zero */
-	hb = ioread32(&idev->dev_info_regs->fw_heartbeat);
-	if (!hb)
+	/* wait at least one watchdog period since the last heartbeat */
+	last_check_time = idev->last_hb_time;
+	if (time_before(check_time, last_check_time + ionic->watchdog_period))
 		return 0;
 
-	/* are we stalled? */
-	if (hb == idev->last_hb) {
-		/* only complain once for each stall seen */
-		if (idev->last_hb_time != 1) {
-			dev_info(ionic->dev, "FW heartbeat stalled at %d\n",
-				 idev->last_hb);
-			idev->last_hb_time = 1;
-		}
+	fw_hb = ioread32(&idev->dev_info_regs->fw_heartbeat);
+	fw_hb_ready = fw_hb != idev->last_fw_hb;
 
-		return -ENXIO;
+	/* early FW version had no heartbeat, so fake it */
+	if (!fw_hb_ready && !fw_hb)
+		fw_hb_ready = true;
+
+	dev_dbg(ionic->dev, "%s: fw_hb %u last_fw_hb %u ready %u\n",
+		__func__, fw_hb, idev->last_fw_hb, fw_hb_ready);
+
+	idev->last_fw_hb = fw_hb;
+
+	/* log a transition */
+	if (fw_hb_ready != idev->fw_hb_ready) {
+		idev->fw_hb_ready = fw_hb_ready;
+		if (!fw_hb_ready)
+			dev_info(ionic->dev, "FW heartbeat stalled at %d\n", fw_hb);
+		else
+			dev_info(ionic->dev, "FW heartbeat restored at %d\n", fw_hb);
 	}
 
-	if (idev->last_hb_time == 1)
-		dev_info(ionic->dev, "FW heartbeat restored at %d\n", hb);
+	if (!fw_hb_ready)
+		return -ENXIO;
 
-	idev->last_hb = hb;
-	idev->last_hb_time = hb_time;
+	idev->last_hb_time = check_time;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index ca7e55455165..0c0533737b2b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -4,6 +4,7 @@
 #ifndef _IONIC_DEV_H_
 #define _IONIC_DEV_H_
 
+#include <linux/atomic.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 
@@ -135,9 +136,11 @@ struct ionic_dev {
 	union ionic_dev_info_regs __iomem *dev_info_regs;
 	union ionic_dev_cmd_regs __iomem *dev_cmd_regs;
 
+	atomic_long_t last_check_time;
 	unsigned long last_hb_time;
-	u32 last_hb;
-	u8 last_fw_status;
+	u32 last_fw_hb;
+	bool fw_hb_ready;
+	bool fw_status_ready;
 
 	u64 __iomem *db_pages;
 	dma_addr_t phy_db_pages;
-- 
2.17.1

