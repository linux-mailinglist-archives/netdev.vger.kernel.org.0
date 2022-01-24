Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2894989C7
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344124AbiAXS6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344518AbiAXSyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:46 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4281DC06178A
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:32 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id t18so16640147plg.9
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zOJ8SK7XOrM2AokhWaTdmBkoxMZYj4UY76hfY8D3EUE=;
        b=3vaFe1y00oK4gWOT4+qvi39LpHv7HWeAbrkO8yZoezKFtGffCJmDAQc/h1Jwtq2BbT
         mlKlGsnEsceUaOHuN9Vd3FtdT3oVVyPYA3g47LajiuGV8ofmLlIb07Tt276TMgLjAVbz
         ozkqUyeTET7IIdOP7cIi5gqlkfwgVNZiX+luVaVXMIYlERGSCQaTtnnx4W7Jr05mn/qV
         y8D/7YiEKH5KgFTVkkWoAWfHAe0/pE/0Kjt85drxiG/REbPd+5/JCwss3l2eAe3QTB61
         EO1vFwUmg6a3/42LPoEAxGLDp+LLF5Yg1ERWVKZPoYcbCf3msYH/oFuDa8Q6TBamRqnL
         pWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zOJ8SK7XOrM2AokhWaTdmBkoxMZYj4UY76hfY8D3EUE=;
        b=L/TopObBLNa9VowehstPi4g3hMkz7FE7aZjAeVOs6Z8SwRH5Mn2zOoHk7reaxSvSdX
         fkkN6i1R0zW1KqhBoYWz+xK3rEXMtVunTPNoCaYuqOMRsxuFvKw+OSgAahrgNwUK/J+x
         qRiRR+4hc9f/aQD5S+rCIaGahEopGg6iXV5GtxY8eFYf7wnnr3BkJzngsN1FslXamOTZ
         IaE6LcEEdAQETmYcwaXHYZbipyuCFXSsdEdCP+ESJutWQg8Xr7Ejlf4kJzcx+JVppF0C
         G1cGLMtVG74SU5uaP0AZyYHWtfO6X1njbBX7vBINV/Gyrd43rgTImUtqO6kJzaq1RAyZ
         aRvw==
X-Gm-Message-State: AOAM530WkJqK8ZF/ozhFs6JE6k2QH/3eqsW808mkkWV32FdWSVzxvBGc
        L9Wt66vG8JeZr6lQg+Lw86n6Fw==
X-Google-Smtp-Source: ABdhPJwpFn3T542CscWfuNIjuwNFJmMPLCauhaDgO6gMzgO0jEddt0nMit42LG7/UdIfqE+3s5lHAg==
X-Received: by 2002:a17:90a:2e09:: with SMTP id q9mr3281672pjd.2.1643050411755;
        Mon, 24 Jan 2022 10:53:31 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:31 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 05/16] ionic: add FW_STOPPING state
Date:   Mon, 24 Jan 2022 10:53:01 -0800
Message-Id: <20220124185312.72646-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Between fw running and fw actually stopped into reset, we need
a fw_stopping concept to catch and block some actions while
we're transitioning to FW_RESET state.  This will help to be
sure the fw_up task is not scheduled until after the fw_down
task has completed.

On some rare occasion timing, it is possible for the fw_up task
to try to run before the fw_down task, then not get run after
the fw_down task has run, leaving the device in a down state.
This is possible if the watchdog goes off in between finding the
down transition and starting the fw_down task, where the later
watchdog sees the FW is back up and schedules a fw_up task.

Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 25 +++++++++++--------
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  1 +
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |  4 ++-
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 86791e0f2d72..8edbd7c30ccc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -197,21 +197,24 @@ int ionic_heartbeat_check(struct ionic *ionic)
 		struct ionic_lif *lif = ionic->lif;
 		bool trigger = false;
 
-		idev->fw_status_ready = fw_status_ready;
-
-		if (!fw_status_ready) {
-			dev_info(ionic->dev, "FW stopped %u\n", fw_status);
-			if (lif && !test_bit(IONIC_LIF_F_FW_RESET, lif->state))
-				trigger = true;
-		} else {
-			dev_info(ionic->dev, "FW running %u\n", fw_status);
-			if (lif && test_bit(IONIC_LIF_F_FW_RESET, lif->state))
-				trigger = true;
+		if (!fw_status_ready && lif &&
+		    !test_bit(IONIC_LIF_F_FW_RESET, lif->state) &&
+		    !test_and_set_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
+			dev_info(ionic->dev, "FW stopped 0x%02x\n", fw_status);
+			trigger = true;
+
+		} else if (fw_status_ready && lif &&
+			   test_bit(IONIC_LIF_F_FW_RESET, lif->state) &&
+			   !test_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
+			dev_info(ionic->dev, "FW running 0x%02x\n", fw_status);
+			trigger = true;
 		}
 
 		if (trigger) {
 			struct ionic_deferred_work *work;
 
+			idev->fw_status_ready = fw_status_ready;
+
 			work = kzalloc(sizeof(*work), GFP_ATOMIC);
 			if (work) {
 				work->type = IONIC_DW_TYPE_LIF_RESET;
@@ -221,7 +224,7 @@ int ionic_heartbeat_check(struct ionic *ionic)
 		}
 	}
 
-	if (!fw_status_ready)
+	if (!idev->fw_status_ready)
 		return -ENXIO;
 
 	/* wait at least one watchdog period since the last heartbeat */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 2ff7be17e5af..08c8589e875a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2835,6 +2835,7 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 
 	mutex_unlock(&lif->queue_lock);
 
+	clear_bit(IONIC_LIF_F_FW_STOPPING, lif->state);
 	dev_info(ionic->dev, "FW Down: LIFs stopped\n");
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 9f7ab2f17f93..2db708df6b55 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -135,6 +135,7 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
 	IONIC_LIF_F_FILTER_SYNC_NEEDED,
 	IONIC_LIF_F_FW_RESET,
+	IONIC_LIF_F_FW_STOPPING,
 	IONIC_LIF_F_SPLIT_INTR,
 	IONIC_LIF_F_BROKEN,
 	IONIC_LIF_F_TX_DIM_INTR,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index a548f2a01806..449e9ee2acf0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -332,7 +332,9 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 			break;
 
 		/* interrupt the wait if FW stopped */
-		if (test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
+		if ((test_bit(IONIC_LIF_F_FW_RESET, lif->state) &&
+		     !lif->ionic->idev.fw_status_ready) ||
+		    test_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
 			if (do_msg)
 				netdev_err(netdev, "%s (%d) interrupted, FW in reset\n",
 					   name, ctx->cmd.cmd.opcode);
-- 
2.17.1

