Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF35F4989CB
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344230AbiAXS6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344447AbiAXSyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:41 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF94C061771
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:29 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y17so6299290plg.7
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TCopsfaOKUODS6k02BcpS9IBDbiEXYmHn8QmS/l7mUQ=;
        b=z0UL7hmHOjq1ZcxJ8yCjFualQ/143EO/hWqASfVYg7zz64NW5bv67vOzsMpanDJvRg
         Wagm4gaFb/lvI3IBCdlPBRl7NXCUH3jkpTlXEIz49pDnJjhUPWmj/A5roNlWRdfDqImg
         +3AA+VOcGhUHRHlNYOSnS7Jcn6cMO2MT/sqn2Gq66HXaD/gOqhseYmk/QcFTTprDbBj+
         Rv1uFO0jrthY5qXLXg3RX2/6+Qxz5UqMv9T/V+JYB2bfNuqJ/jOpQxIRBa38xrV3BL3T
         W3rEjNo3W4DMyTUyiwVgMyUojb00s2MLF5fP9+JryTo0baV72RroHsI4JgGCgiIkx4pl
         pExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TCopsfaOKUODS6k02BcpS9IBDbiEXYmHn8QmS/l7mUQ=;
        b=w/jITWOG9jzOpLUjnLlGnL69yT3DrJrnjgNKRqYkCN3rUHeUuPqWb7Er0dVYy+buTM
         J1ivPvpYpUcVFNrhj7NQGfClBLmkFLUe9uoLtcFZ3s7LBOUY7t3vJJPMdLGu+2BoORVv
         57uvkc8qy1zSx0Y4b3soTcPFCJi/DdwRyLgHigRsEU0E0/kCh5vevGKHy3HE8zn5tmqu
         BnenjdVVgUTS9LP95dwG1rla9hIyauePd0RuC9QHgc7DqYb5H1Hizi+2uzekpMYCzwWl
         NzARyHxTm3WVgKMx/by1DaFWyFPg7GqCSjJiVyWuWPLCb+mHBb7RNgU6xSOjCZUYCih6
         1z6A==
X-Gm-Message-State: AOAM531mbGW6LNdtC42DVkt1RUGDmuYvVlL/e4QOgADJKiAPzU8jTiNG
        nwb2c9Gee6Lwyre1qYwD0kWqbw==
X-Google-Smtp-Source: ABdhPJzMqZO/13GSr2HdBPvKL5aPSIJRPw6fU0IolTvD7iWm4q+MnqHcmVcBwi9r1H19mhvl4S6wTg==
X-Received: by 2002:a17:90b:1646:: with SMTP id il6mr3263363pjb.12.1643050409466;
        Mon, 24 Jan 2022 10:53:29 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:29 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 03/16] ionic: separate function for watchdog init
Date:   Mon, 24 Jan 2022 10:52:59 -0800
Message-Id: <20220124185312.72646-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pull the watchdog init code out to a separate bite-sized
function.  Code cleaning for now, will be a useful change in
the near future.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 31 ++++++++++++-------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 4044c630f8b4..34b7708917d1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -46,6 +46,24 @@ static void ionic_watchdog_cb(struct timer_list *t)
 	}
 }
 
+static void ionic_watchdog_init(struct ionic *ionic)
+{
+	struct ionic_dev *idev = &ionic->idev;
+
+	timer_setup(&ionic->watchdog_timer, ionic_watchdog_cb, 0);
+	ionic->watchdog_period = IONIC_WATCHDOG_SECS * HZ;
+
+	/* set times to ensure the first check will proceed */
+	atomic_long_set(&idev->last_check_time, jiffies - 2 * HZ);
+	idev->last_hb_time = jiffies - 2 * ionic->watchdog_period;
+	/* init as ready, so no transition if the first check succeeds */
+	idev->last_fw_hb = 0;
+	idev->fw_hb_ready = true;
+	idev->fw_status_ready = true;
+	idev->fw_generation = IONIC_FW_STS_F_GENERATION &
+			      ioread8(&idev->dev_info_regs->fw_status);
+}
+
 void ionic_init_devinfo(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
@@ -109,18 +127,7 @@ int ionic_dev_setup(struct ionic *ionic)
 		return -EFAULT;
 	}
 
-	timer_setup(&ionic->watchdog_timer, ionic_watchdog_cb, 0);
-	ionic->watchdog_period = IONIC_WATCHDOG_SECS * HZ;
-
-	/* set times to ensure the first check will proceed */
-	atomic_long_set(&idev->last_check_time, jiffies - 2 * HZ);
-	idev->last_hb_time = jiffies - 2 * ionic->watchdog_period;
-	/* init as ready, so no transition if the first check succeeds */
-	idev->last_fw_hb = 0;
-	idev->fw_hb_ready = true;
-	idev->fw_status_ready = true;
-	idev->fw_generation = IONIC_FW_STS_F_GENERATION &
-			      ioread8(&idev->dev_info_regs->fw_status);
+	ionic_watchdog_init(ionic);
 
 	idev->db_pages = bar->vaddr;
 	idev->phy_db_pages = bar->bus_addr;
-- 
2.17.1

