Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EE141F458
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355694AbhJASIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355697AbhJASI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 14:08:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8A4C0613E5
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 11:06:44 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id g2so8638396pfc.6
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 11:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pYdwC3tyFN62O+NwJAqe54Jxsi4jVAh2HmKgrbPXqsg=;
        b=KuIzUyRoi4QfIIf/RTYgsL/7gyjQ5YzeaNUWzUQjvptMhGiAVgNgwK3DTUr2cpdMNt
         CtlgOACf93amL4/ec/C5wicPU5pjRsAKFIYC6LmbiI9fy9HZ01fYgeTU5lvvuXW8hJXw
         NxUldWOQTGV1ZtJ2kkw/9l6KzbCfTiPGXA6NXSGVr6ppqFLs6B5VJC/MsZ1T3dBIhyYT
         TCzi7ksRm7cooepgGYNk7KTvHteuVIIVp2IYCnQPtb2wg2yUfhwNtohAa/IS9ixhJ3uD
         oFuoaiUXlJ9yaYkUDdkNN9EtZ24tEGHA9nwIyiyVnt7R1HLBQBrhEDN181N06wUR2mj1
         4ipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pYdwC3tyFN62O+NwJAqe54Jxsi4jVAh2HmKgrbPXqsg=;
        b=aTz33HTLx06N0KFArJwcqFA+2Grm2lRA805zFFBMTCxsLcJ3HrUiSkAcQsJWlG6r8y
         6eqnrq4WQf9ML9dFhFnx8+haNLc4k77LDSWTRTLm2GQv1NoK2Q2Ku6BBlM0XZqQirykJ
         EL+YTDkzD9UFT+vDVJ51qvEfHY22koqDJGqTtjDPUvX3Q2cZNpPsEiJn7RFbiN20Fwde
         Fx/smUlHsDB/NmhOkCIzYTUUkcGsvpmxYLH+i1HFhx6tJ5tHjasHbuXM8ywEcz2O7mtt
         eXHXyczxAw7icPRhM1LqOR5vEXgOHgcJFc/U94zewaCZmt48/Em9rpXyCmff8Y1R+Mhn
         B08g==
X-Gm-Message-State: AOAM532WoYUdsqQdxIq49gSCll313WaSRxJZV5o3DVJSwBrCJAxZqeWR
        vQyv6JEDCGVpEfoRsmlD1F5bxg==
X-Google-Smtp-Source: ABdhPJyU0vBb0IONtOtVx2TAq8ag/ckQoon+M3gD4xa1e+Fatr8RkT/AX678OUc+LXmHbpmojah8NA==
X-Received: by 2002:a62:7592:0:b0:44c:153d:9114 with SMTP id q140-20020a627592000000b0044c153d9114mr5629504pfc.19.1633111603965;
        Fri, 01 Oct 2021 11:06:43 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm6409384pjd.33.2021.10.01.11.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 11:06:43 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 5/7] ionic: add polling to adminq wait
Date:   Fri,  1 Oct 2021 11:05:55 -0700
Message-Id: <20211001180557.23464-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001180557.23464-1-snelson@pensando.io>
References: <20211001180557.23464-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the adminq wait into smaller polling periods in order
to watch for broken firmware and not have to wait for the full
adminq devcmd_timeout.

Generally, adminq commands take fewer than 2 msecs.  If the
FW is busy they can take longer, but usually still under 100
msecs.  We set the polling period to 100 msecs in order to
start snooping on FW status when a command is taking longer
than usual.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_main.c  | 36 +++++++++++++++----
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 66204106f83e..d570d03b23f6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -19,6 +19,7 @@ struct ionic_lif;
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
 
 #define DEVCMD_TIMEOUT  10
+#define IONIC_ADMINQ_TIME_SLICE		msecs_to_jiffies(100)
 
 #define IONIC_PHC_UPDATE_NS	10000000000	    /* 10s in nanoseconds */
 #define NORMAL_PPB		1000000000	    /* one billion parts per billion */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index b6473c02c041..bb49f1b8ef67 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -301,21 +301,45 @@ int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx, int err)
 {
 	struct net_device *netdev = lif->netdev;
+	unsigned long time_limit;
+	unsigned long time_start;
+	unsigned long time_done;
 	unsigned long remaining;
 	const char *name;
 
+	name = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
+
 	if (err) {
-		if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
-			name = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
+		if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state))
 			netdev_err(netdev, "Posting of %s (%d) failed: %d\n",
 				   name, ctx->cmd.cmd.opcode, err);
-		}
 		return err;
 	}
 
-	remaining = wait_for_completion_timeout(&ctx->work,
-						HZ * (ulong)DEVCMD_TIMEOUT);
-	return ionic_adminq_check_err(lif, ctx, (remaining == 0));
+	time_start = jiffies;
+	time_limit = time_start + HZ * (ulong)DEVCMD_TIMEOUT;
+	do {
+		remaining = wait_for_completion_timeout(&ctx->work,
+							IONIC_ADMINQ_TIME_SLICE);
+
+		/* check for done */
+		if (remaining)
+			break;
+
+		/* interrupt the wait if FW stopped */
+		if (test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
+			netdev_err(netdev, "%s (%d) interrupted, FW in reset\n",
+				   name, ctx->cmd.cmd.opcode);
+			return -ENXIO;
+		}
+
+	} while (time_before(jiffies, time_limit));
+	time_done = jiffies;
+
+	dev_dbg(lif->ionic->dev, "%s: elapsed %d msecs\n",
+		__func__, jiffies_to_msecs(time_done - time_start));
+
+	return ionic_adminq_check_err(lif, ctx, time_after_eq(time_done, time_limit));
 }
 
 int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
-- 
2.17.1

