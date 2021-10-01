Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B614C41F33C
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355336AbhJARkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355072AbhJARkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:40:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF0BC0613E3
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:38:31 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id q23so8567868pfs.9
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pYdwC3tyFN62O+NwJAqe54Jxsi4jVAh2HmKgrbPXqsg=;
        b=o3OjMx2e5wpaVgxikj2F/s7efFOE5GroRapggaek13hX+j6U8oby/RqUIXqPLyaOD5
         yeO+meF30c1gLBqsGEU9JjGdhrVEZ4KDcuxURAD9Tp3skAlSbig9BYNSkhCVD2dQtEv5
         DX1TFasHTL46dp6o/uwQtbdOsqqGUkXd32Oyp1tQ47idLGT4Szv9k9IwwMWTzY+NckRU
         VNakgQYRgepiNO17EPbdmQass3OfGrulph1XZQUTNuFJwuF+FiLuS414xymDkokkOF+9
         rVEUeIBlM9YcyalxXF61Q8lwSY4thrAGSO2AFOThMcKhe8KLJr/ee8Lte0LQv3s53ca4
         UHeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pYdwC3tyFN62O+NwJAqe54Jxsi4jVAh2HmKgrbPXqsg=;
        b=p068K9IfsTDlVdVJkz6LFgiSjaGZ2DvyzufpX19mj30U4OOjsRAqxcM8KWa2WDq798
         i2wF64sAFxE7q+ZSw48P94N/NOLrULpEf3XW5pmXkp+BT/PY9+xXgd9PJYQtvEoOhNi3
         XhakVbQytV9C7XIYiQjWVw4zh50gWnKqqVjTUQaarNBVg0joGK/Wy5o06TsHSYoZUidc
         82cfvQ/zL42+Pi8MYIxlRGyRsy5d2zIUh/Ulbo8B3W6rCW/0uTdjC1jdLExO/GoDYi88
         pvJBLUN78vSujPH4DG0Oa+dWL02tntf+v1LxShym8YI1j7z1EINhfAa72j2z4N1iY25w
         7AIA==
X-Gm-Message-State: AOAM530I7Y/JiOHw5qxl6qhPAYPkqwE+d5RSrl5HpjWgVduOZXdOF2vX
        zkmwfGug4aq9c3rnTVM8jFGPptCk2LtXRQ==
X-Google-Smtp-Source: ABdhPJy571xzdpHs5boslEHcOWCxIQKAgNNc12ckhKeV8RaokDCiJmKFUJQoScc4vpWH6zZoa98GtA==
X-Received: by 2002:a63:b204:: with SMTP id x4mr10447889pge.212.1633109911516;
        Fri, 01 Oct 2021 10:38:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 26sm7854462pgx.72.2021.10.01.10.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:38:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/7] ionic: add polling to adminq wait
Date:   Fri,  1 Oct 2021 10:37:56 -0700
Message-Id: <20211001173758.22072-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001173758.22072-1-snelson@pensando.io>
References: <20211001173758.22072-1-snelson@pensando.io>
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

