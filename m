Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CEC427CC2
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhJISrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhJISrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:47:36 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A791AC061765
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 11:45:39 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y1so8327644plk.10
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 11:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KFVrmI+VwxARD0YXtleUXOZ2XB+QWxCC2EAnTr4D6Sw=;
        b=lGCCoonBWaj+qv4Spu4e1wFex4JzXSZ8w1abDEb+a522m+9NxJgh8hvLy6AAhpeV9m
         QMw4LkTGeey1sGnyqR8iVu6sIyb5n2lKjB1ZJx9t5+80BYKYSeErsZiZTH3LoKAaJY4o
         DL9+9StyNXG1ClSXgjUwIfFq6nS1LTEZ9bIvW28cP4VvF8C+7+hBTjH71n28ofCzX6YE
         PrRihlMbn5u9pPtwGM3Z+0UrLPUay9RObaFQfu92yFDJpqMPp0or6l6LASlhMYNJQPTH
         kmIZeIkiwA45p/SpdMszjeD9UhlHSaS2vRYTiZ0smtJqHP3iVLMwOhyIUSRtPtASg0tv
         NKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KFVrmI+VwxARD0YXtleUXOZ2XB+QWxCC2EAnTr4D6Sw=;
        b=AyQZhe70r38vhqqeUHBaRRVsyJEMowgtgJxfmJi0fBy9YgYxDp7y5J3yfBUlJDPHUJ
         m2kCZ9Sgc9XbfMxa3fpry4IrJBWjzpbbx/csZJYoUGMt/hcJ5H2DWJnhBMStU6q0gPf6
         2+cE4edMuHp/UGfAtbFoxAMrzowxNtqSneCFjQczXNToCLlLYaeOVpK21zpufYzcKk6R
         KOUbUjZeVOPId83U9Vvj7Q6jrNBVS1w1lJO09S82iIVABVO3hS8HyrL+Fqtmta2Gd+8n
         +0oeARBc0YsGwD23n1vX21Ab2iAgRd9xSzhPlNfg8ANR0eEh+28A9HpMsH8uv05C6fVH
         9HWA==
X-Gm-Message-State: AOAM532aQQZt9ziPipCqmH0IHp7IlMyTYQIlTyUrA3nSxsJcf1YOpWH8
        Mq+75J+UXh6sPL6EUw2OSBttJw==
X-Google-Smtp-Source: ABdhPJy5SJlJk5tf8f9rDlyoP49EOYn/mUmxGeFIGpbci1mcC+DdrZthphh6gRrczfcBG3mp3CSbVg==
X-Received: by 2002:a17:902:760b:b0:13b:122:5ff0 with SMTP id k11-20020a170902760b00b0013b01225ff0mr15959678pll.22.1633805139182;
        Sat, 09 Oct 2021 11:45:39 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s30sm3368433pgo.39.2021.10.09.11.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:45:38 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 8/9] ionic: allow adminq requests to override default error message
Date:   Sat,  9 Oct 2021 11:45:22 -0700
Message-Id: <20211009184523.73154-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009184523.73154-1-snelson@pensando.io>
References: <20211009184523.73154-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AdminQ handler has an error handler that automatically prints
an error message when the request has failed.  However, there are
situations where the caller can expect that it might fail and has
an alternative strategy, thus may not want the error message sent
to the log, such as hitting -ENOSPC when adding a new vlan id.

We add a new interface to the AdminQ API to allow for override of
the default behavior, and an interface to the use standard error
message formatting.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  7 ++-
 .../net/ethernet/pensando/ionic/ionic_main.c  | 47 +++++++++++++------
 .../net/ethernet/pensando/ionic/ionic_phc.c   |  8 ++--
 3 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index d570d03b23f6..5e25411ff02f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -70,8 +70,13 @@ struct ionic_admin_ctx {
 };
 
 int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx);
-int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx, int err);
+int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
+		      const int err, const bool do_msg);
 int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx);
+int ionic_adminq_post_wait_nomsg(struct ionic_lif *lif, struct ionic_admin_ctx *ctx);
+void ionic_adminq_netdev_err_print(struct ionic_lif *lif, u8 opcode,
+				   u8 status, int err);
+
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_wait);
 int ionic_set_dma_mask(struct ionic *ionic);
 int ionic_setup(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index bb49f1b8ef67..875f4ec42efe 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -212,24 +212,28 @@ static void ionic_adminq_flush(struct ionic_lif *lif)
 	spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
 }
 
+void ionic_adminq_netdev_err_print(struct ionic_lif *lif, u8 opcode,
+				   u8 status, int err)
+{
+	netdev_err(lif->netdev, "%s (%d) failed: %s (%d)\n",
+		   ionic_opcode_to_str(opcode), opcode,
+		   ionic_error_to_str(status), err);
+}
+
 static int ionic_adminq_check_err(struct ionic_lif *lif,
 				  struct ionic_admin_ctx *ctx,
-				  bool timeout)
+				  const bool timeout,
+				  const bool do_msg)
 {
-	struct net_device *netdev = lif->netdev;
-	const char *opcode_str;
-	const char *status_str;
 	int err = 0;
 
 	if (ctx->comp.comp.status || timeout) {
-		opcode_str = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
-		status_str = ionic_error_to_str(ctx->comp.comp.status);
 		err = timeout ? -ETIMEDOUT :
 				ionic_error_to_errno(ctx->comp.comp.status);
 
-		netdev_err(netdev, "%s (%d) failed: %s (%d)\n",
-			   opcode_str, ctx->cmd.cmd.opcode,
-			   timeout ? "TIMEOUT" : status_str, err);
+		if (do_msg)
+			ionic_adminq_netdev_err_print(lif, ctx->cmd.cmd.opcode,
+						      ctx->comp.comp.status, err);
 
 		if (timeout)
 			ionic_adminq_flush(lif);
@@ -298,7 +302,8 @@ int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 	return err;
 }
 
-int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx, int err)
+int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
+		      const int err, const bool do_msg)
 {
 	struct net_device *netdev = lif->netdev;
 	unsigned long time_limit;
@@ -310,7 +315,7 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx, int er
 	name = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
 
 	if (err) {
-		if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state))
+		if (do_msg && !test_bit(IONIC_LIF_F_FW_RESET, lif->state))
 			netdev_err(netdev, "Posting of %s (%d) failed: %d\n",
 				   name, ctx->cmd.cmd.opcode, err);
 		return err;
@@ -328,8 +333,9 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx, int er
 
 		/* interrupt the wait if FW stopped */
 		if (test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
-			netdev_err(netdev, "%s (%d) interrupted, FW in reset\n",
-				   name, ctx->cmd.cmd.opcode);
+			if (do_msg)
+				netdev_err(netdev, "%s (%d) interrupted, FW in reset\n",
+					   name, ctx->cmd.cmd.opcode);
 			return -ENXIO;
 		}
 
@@ -339,7 +345,9 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx, int er
 	dev_dbg(lif->ionic->dev, "%s: elapsed %d msecs\n",
 		__func__, jiffies_to_msecs(time_done - time_start));
 
-	return ionic_adminq_check_err(lif, ctx, time_after_eq(time_done, time_limit));
+	return ionic_adminq_check_err(lif, ctx,
+				      time_after_eq(time_done, time_limit),
+				      do_msg);
 }
 
 int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
@@ -348,7 +356,16 @@ int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 
 	err = ionic_adminq_post(lif, ctx);
 
-	return ionic_adminq_wait(lif, ctx, err);
+	return ionic_adminq_wait(lif, ctx, err, true);
+}
+
+int ionic_adminq_post_wait_nomsg(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
+{
+	int err;
+
+	err = ionic_adminq_post(lif, ctx);
+
+	return ionic_adminq_wait(lif, ctx, err, false);
 }
 
 static void ionic_dev_cmd_clean(struct ionic *ionic)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index eed2db69d708..887046838b3b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -348,7 +348,7 @@ static int ionic_phc_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 
 	spin_unlock_irqrestore(&phc->lock, irqflags);
 
-	return ionic_adminq_wait(phc->lif, &ctx, err);
+	return ionic_adminq_wait(phc->lif, &ctx, err, true);
 }
 
 static int ionic_phc_adjtime(struct ptp_clock_info *info, s64 delta)
@@ -373,7 +373,7 @@ static int ionic_phc_adjtime(struct ptp_clock_info *info, s64 delta)
 
 	spin_unlock_irqrestore(&phc->lock, irqflags);
 
-	return ionic_adminq_wait(phc->lif, &ctx, err);
+	return ionic_adminq_wait(phc->lif, &ctx, err, true);
 }
 
 static int ionic_phc_settime64(struct ptp_clock_info *info,
@@ -402,7 +402,7 @@ static int ionic_phc_settime64(struct ptp_clock_info *info,
 
 	spin_unlock_irqrestore(&phc->lock, irqflags);
 
-	return ionic_adminq_wait(phc->lif, &ctx, err);
+	return ionic_adminq_wait(phc->lif, &ctx, err, true);
 }
 
 static int ionic_phc_gettimex64(struct ptp_clock_info *info,
@@ -459,7 +459,7 @@ static long ionic_phc_aux_work(struct ptp_clock_info *info)
 
 	spin_unlock_irqrestore(&phc->lock, irqflags);
 
-	ionic_adminq_wait(phc->lif, &ctx, err);
+	ionic_adminq_wait(phc->lif, &ctx, err, true);
 
 	return phc->aux_work_delay;
 }
-- 
2.17.1

