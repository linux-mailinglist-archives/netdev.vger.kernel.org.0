Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F4D4989C8
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343503AbiAXS6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344473AbiAXSyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:43 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06336C061775
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:31 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j16so6102030plx.4
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gftFiybPsp4f/ef4q6t+0YuKdfevzxGi9+2OMOJ+pwg=;
        b=2x9pcnyh3b2USGCuoe8PSCyJHLq2R3qdX+YtnkJXrTRkcT2amT/mn/m4YQSdCl5nsv
         PQ6qCzQPhxdkjfgvb2k/AHSg5nDV9fIG9n/SSeyTAsxav73ftnM4xEIPTvM4defzdLYs
         HvCbCrPA67y4IeCAKS0r/N28aU6EebHeCX3bm+dn0Vhm3IQ1ZfCNvnWwpiC8XmmWXHKI
         0dCWmJNu0snCggFH9WhHs1N3Bj68qPFc5evF7cBkvjD8qFvORSpLyCIVsq6BczWoaxWv
         Xa6R6PKGmIaUmIrSeJxYe1EAZm+sRTwzB5UvziP1UJN6F2CNpz07cc676V7tbVbQc9Z+
         dtBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gftFiybPsp4f/ef4q6t+0YuKdfevzxGi9+2OMOJ+pwg=;
        b=fqQkhNT8lQQERSNSo2Cu53WDMdEKXF9ZBmFUMyTcinKhF7fxYUrs3vFYrl6Ylk9INu
         IM2cbh1OgMsTyYSjrVwa4VTxmc0sH33thKjuf8RUJpUXok08+TfTKrs0cM2QSn+eqbpo
         QrMiwRV6CIavQso4oW3dkWGR89hoaW2+NCoMpoLdPA8fzkwQPb/aKqAfE+9D2mPn5RLN
         nf+ALKztNVuwzar5ypKLyp2lIDBgHPUU/+UP/67O0Bh/ualfL+v0bJo03YrqAE2biM3c
         akx28rYqijwsABshauHI4CReDgOsRe6RoRUP2/9bYsdf4Lg1EzrkFDxz9N+oCedAJLaP
         9DMg==
X-Gm-Message-State: AOAM530jT6wGWpGMKB95oV0lyr+RecwVhNvoLfyqCKolb0ZA+yA4CzWp
        UNnE/LOeovngtHgqNzsltehXPw==
X-Google-Smtp-Source: ABdhPJw+jlrZvYFsvHdD1Hb2YR/eJfEZzcAi6XR6Kr5X+GS2HJkcKx064rKaH3VE1K9DDpT8ZQCMAw==
X-Received: by 2002:a17:90a:7bce:: with SMTP id d14mr3212300pjl.7.1643050410511;
        Mon, 24 Jan 2022 10:53:30 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:30 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 04/16] ionic: Don't send reset commands if FW isn't running
Date:   Mon, 24 Jan 2022 10:53:00 -0800
Message-Id: <20220124185312.72646-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett@pensando.io>

It's possible the FW is already shutting down while the driver is being
removed and/or when the driver is going through reset. This can cause
unexpected/unnecessary errors to be printed:

eth0: DEV_CMD IONIC_CMD_PORT_RESET (12) error, IONIC_RC_ERROR (29) failed
eth1: DEV_CMD IONIC_CMD_RESET (3) error, IONIC_RC_ERROR (29) failed

Fix this by checking the FW status register before issuing the reset
commands.

Also, since err may not be assigned in ionic_port_reset(), assign it a
default value of 0, and remove an unnecessary log message.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c    | 17 ++++++++++++-----
 .../net/ethernet/pensando/ionic/ionic_dev.h    |  1 +
 .../net/ethernet/pensando/ionic/ionic_main.c   | 18 ++++++++++--------
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 34b7708917d1..86791e0f2d72 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -136,6 +136,16 @@ int ionic_dev_setup(struct ionic *ionic)
 }
 
 /* Devcmd Interface */
+bool ionic_is_fw_running(struct ionic_dev *idev)
+{
+	u8 fw_status = ioread8(&idev->dev_info_regs->fw_status);
+
+	/* firmware is useful only if the running bit is set and
+	 * fw_status != 0xff (bad PCI read)
+	 */
+	return (fw_status != 0xff) && (fw_status & IONIC_FW_STS_F_RUNNING);
+}
+
 int ionic_heartbeat_check(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
@@ -159,13 +169,10 @@ int ionic_heartbeat_check(struct ionic *ionic)
 		goto do_check_time;
 	}
 
-	/* firmware is useful only if the running bit is set and
-	 * fw_status != 0xff (bad PCI read)
-	 * If fw_status is not ready don't bother with the generation.
-	 */
 	fw_status = ioread8(&idev->dev_info_regs->fw_status);
 
-	if (fw_status == 0xff || !(fw_status & IONIC_FW_STS_F_RUNNING)) {
+	/* If fw_status is not ready don't bother with the generation */
+	if (!ionic_is_fw_running(idev)) {
 		fw_status_ready = false;
 	} else {
 		fw_generation = fw_status & IONIC_FW_STS_F_GENERATION;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index e5acf3bd62b2..73b950ac1272 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -353,5 +353,6 @@ void ionic_q_rewind(struct ionic_queue *q, struct ionic_desc_info *start);
 void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 		     unsigned int stop_index);
 int ionic_heartbeat_check(struct ionic *ionic);
+bool ionic_is_fw_running(struct ionic_dev *idev);
 
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index a89ad768e4a0..a548f2a01806 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -540,6 +540,9 @@ int ionic_reset(struct ionic *ionic)
 	struct ionic_dev *idev = &ionic->idev;
 	int err;
 
+	if (!ionic_is_fw_running(idev))
+		return 0;
+
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_reset(idev);
 	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
@@ -612,15 +615,17 @@ int ionic_port_init(struct ionic *ionic)
 int ionic_port_reset(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
-	int err;
+	int err = 0;
 
 	if (!idev->port_info)
 		return 0;
 
-	mutex_lock(&ionic->dev_cmd_lock);
-	ionic_dev_cmd_port_reset(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
-	mutex_unlock(&ionic->dev_cmd_lock);
+	if (ionic_is_fw_running(idev)) {
+		mutex_lock(&ionic->dev_cmd_lock);
+		ionic_dev_cmd_port_reset(idev);
+		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		mutex_unlock(&ionic->dev_cmd_lock);
+	}
 
 	dma_free_coherent(ionic->dev, idev->port_info_sz,
 			  idev->port_info, idev->port_info_pa);
@@ -628,9 +633,6 @@ int ionic_port_reset(struct ionic *ionic)
 	idev->port_info = NULL;
 	idev->port_info_pa = 0;
 
-	if (err)
-		dev_err(ionic->dev, "Failed to reset port\n");
-
 	return err;
 }
 
-- 
2.17.1

