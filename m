Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D08D4989A5
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245752AbiAXS5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344591AbiAXSyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:51 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16432C061361
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:44 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d18so3963307plg.2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LDiJ4O9YgSkrxT2JnPNMqnuvU7WYXCkaM3BNfwrpAdc=;
        b=fHPBknhuLvoz6SHTLBa70TtjGR49UMyqoi2r2uar1ka0DatPD+I4UUhiqpa5LbN3lm
         52f3UMfCmztQNOmF9yaXm/hUKuvKwNwqwSUfzaw3kmsBHX/dx4SQh1/N/bjoenKW/USL
         4rawtvYGk0PVioQlUabyogDOX4IpzU0ZMP0oWAp/7hXk6fwH9TmNq6OyEMGKBdDVM2ah
         yL4CH4/EYJCMi9uPbiQt4poqMCWCOAbdSHdgwsUZQG8EERw3jnLqJW+ljgXc3eh4btmX
         hlXG1cZpzZ2nYRkmsy30BYYKU/t7Z1DLFgNsrOKEMg7AHV/soGtN7FSc6LdsKgneSzr6
         fspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LDiJ4O9YgSkrxT2JnPNMqnuvU7WYXCkaM3BNfwrpAdc=;
        b=T8CmAGSC0ELiuYrr9SNXNa/O36BKhU6dcxjk4DNgsKEDAjgh42ZzJ5CQpaKBibjrcR
         F2Q7dydDM/n7KJZf/4ofxfhyvZmEQ8grvGwxplOI9nz1kBXP/bpk3TzDQFBGElxdM5Ra
         h6XHqVwP7MYUIpDe63MCq1wNLqbHeN1JktLwIw/YjCBO2eT9bAGUAHvYbtP69GMyT0Lv
         AwOTa3lru/Q7WCblsAJiE+nXEtklTcCMczfnSqGC56tzKH9Ha4cm4JFLHN2c83pt12x7
         HuVclKAAEDnUg5gTrdyC20lWthYWIiiVpeTupeixxBycFXyG12wTT9npTeHC7yFvi1l8
         /2JQ==
X-Gm-Message-State: AOAM531l495WZAw3WGl7N0GR1Mg/AQJlud2wKnaorxQB2Exr3y3RpnG6
        Rsp/Np8dIA106AJcoN4Mkg7faA==
X-Google-Smtp-Source: ABdhPJwjiiDDr9foIUX9zVWNrEEAVdN8rv+KZpkfrr0IrpN80n+jWV95SspZu5ikJlTA5vHfXH68xg==
X-Received: by 2002:a17:903:2443:b0:14b:3758:f07b with SMTP id l3-20020a170903244300b0014b3758f07bmr9390302pls.28.1643050423555;
        Mon, 24 Jan 2022 10:53:43 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:42 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Brett Creeley <brett@pensando.io>
Subject: [PATCH net 15/16] ionic: stretch heartbeat detection
Date:   Mon, 24 Jan 2022 10:53:11 -0800
Message-Id: <20220124185312.72646-16-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can be premature in detecting stalled firmware
when the heartbeat is not updated because the firmware can
occasionally take a long time (more than 2 seconds) to service
a request, and doesn't update the heartbeat during that time.

The firmware heartbeat is not necessarily a steady 1 second
periodic beat, but better described as something that should
progress at least once in every DECVMD_TIMEOUT period.
The single-threaded design in the FW means that if a devcmd
or adminq request launches a large internal job, it is stuck
waiting for that job to finish before it can get back to
updating the heartbeat.  Since all requests are "guaranteed"
to finish within the DEVCMD_TIMEOUT period, the driver needs
to less aggressive in checking the heartbeat progress.

We change our current 2 second window to something bigger than
DEVCMD_TIMEOUT which should take care of most of the issue.
We stop checking for the heartbeat while waiting for a request,
as long as we're still watching for the FW status.  Lastly,
we make sure our FW status is up to date before running a
devcmd request.

Once we do this, we need to not check the heartbeat on DEV
commands because it may be stalled while we're on the fw_down
path.  Instead, we can rely on the is_fw_running check.

Fixes: b2b9a8d7ed13 ("ionic: avoid races in ionic_heartbeat_check")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  2 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  6 ++--
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  2 +-
 .../net/ethernet/pensando/ionic/ionic_main.c  | 34 ++++++++-----------
 4 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 04fdaf5c1a02..602f4d45d529 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -18,7 +18,7 @@ struct ionic_lif;
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
 
-#define DEVCMD_TIMEOUT  10
+#define DEVCMD_TIMEOUT			5
 #define IONIC_ADMINQ_TIME_SLICE		msecs_to_jiffies(100)
 
 #define IONIC_PHC_UPDATE_NS	10000000000	    /* 10s in nanoseconds */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 1535a40a5fab..51d36a549ef7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -236,9 +236,11 @@ int ionic_heartbeat_check(struct ionic *ionic)
 	if (!idev->fw_status_ready)
 		return -ENXIO;
 
-	/* wait at least one watchdog period since the last heartbeat */
+	/* Because of some variability in the actual FW heartbeat, we
+	 * wait longer than the DEVCMD_TIMEOUT before checking again.
+	 */
 	last_check_time = idev->last_hb_time;
-	if (time_before(check_time, last_check_time + ionic->watchdog_period))
+	if (time_before(check_time, last_check_time + DEVCMD_TIMEOUT * 2 * HZ))
 		return 0;
 
 	fw_hb = ioread32(&idev->dev_info_regs->fw_heartbeat);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e84a01edc4e4..05dd8c4f5466 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1787,7 +1787,7 @@ static void ionic_lif_quiesce(struct ionic_lif *lif)
 
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
-		netdev_err(lif->netdev, "lif quiesce failed %d\n", err);
+		netdev_dbg(lif->netdev, "lif quiesce failed %d\n", err);
 }
 
 static void ionic_txrx_disable(struct ionic_lif *lif)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 78771663808a..4029b4e021f8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -358,13 +358,14 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 		if (remaining)
 			break;
 
-		/* interrupt the wait if FW stopped */
+		/* force a check of FW status and break out if FW reset */
+		(void)ionic_heartbeat_check(lif->ionic);
 		if ((test_bit(IONIC_LIF_F_FW_RESET, lif->state) &&
 		     !lif->ionic->idev.fw_status_ready) ||
 		    test_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
 			if (do_msg)
-				netdev_err(netdev, "%s (%d) interrupted, FW in reset\n",
-					   name, ctx->cmd.cmd.opcode);
+				netdev_warn(netdev, "%s (%d) interrupted, FW in reset\n",
+					    name, ctx->cmd.cmd.opcode);
 			ctx->comp.comp.status = IONIC_RC_ERROR;
 			return -ENXIO;
 		}
@@ -425,9 +426,9 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 	unsigned long start_time;
 	unsigned long max_wait;
 	unsigned long duration;
+	int done = 0;
+	bool fw_up;
 	int opcode;
-	int hb = 0;
-	int done;
 	int err;
 
 	/* Wait for dev cmd to complete, retrying if we get EAGAIN,
@@ -437,31 +438,24 @@ static int __ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds,
 try_again:
 	opcode = readb(&idev->dev_cmd_regs->cmd.cmd.opcode);
 	start_time = jiffies;
-	do {
+	for (fw_up = ionic_is_fw_running(idev);
+	     !done && fw_up && time_before(jiffies, max_wait);
+	     fw_up = ionic_is_fw_running(idev)) {
 		done = ionic_dev_cmd_done(idev);
 		if (done)
 			break;
 		usleep_range(100, 200);
-
-		/* Don't check the heartbeat on FW_CONTROL commands as they are
-		 * notorious for interrupting the firmware's heartbeat update.
-		 */
-		if (opcode != IONIC_CMD_FW_CONTROL)
-			hb = ionic_heartbeat_check(ionic);
-	} while (!done && !hb && time_before(jiffies, max_wait));
+	}
 	duration = jiffies - start_time;
 
 	dev_dbg(ionic->dev, "DEVCMD %s (%d) done=%d took %ld secs (%ld jiffies)\n",
 		ionic_opcode_to_str(opcode), opcode,
 		done, duration / HZ, duration);
 
-	if (!done && hb) {
-		/* It is possible (but unlikely) that FW was busy and missed a
-		 * heartbeat check but is still alive and will process this
-		 * request, so don't clean the dev_cmd in this case.
-		 */
-		dev_dbg(ionic->dev, "DEVCMD %s (%d) failed - FW halted\n",
-			ionic_opcode_to_str(opcode), opcode);
+	if (!done && !fw_up) {
+		ionic_dev_cmd_clean(ionic);
+		dev_warn(ionic->dev, "DEVCMD %s (%d) interrupted - FW is down\n",
+			 ionic_opcode_to_str(opcode), opcode);
 		return -ENXIO;
 	}
 
-- 
2.17.1

