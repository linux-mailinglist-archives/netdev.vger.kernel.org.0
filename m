Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34007351F4B
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbhDATFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236152AbhDATDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:03:22 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCC7C0F26F3
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:25 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p12so2018090pgj.10
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Xxa+nHBqtJM1J1c7RVcdOL1FdV+GgtiVvLrSOEJTxhU=;
        b=1FMGoXLJ2KCTeuFpFKXIWfaip1+iPA+fEvASZZQ3xyP3ES7lgzhi+f5v3Rid0J+cXL
         3yCmSjOgFUkkPAI5jNC5MN8wri0NGS4DGzfGBNYOzuQlhYT/Tln0vZ8N/2HRfboImpbw
         yrgkhrMVR2zDnFlQv02vNUPr9Xt9G/c1KXwXIKyY5Gq6tnssjv4VW9GetxyvrhDRSuxo
         z5v74FFKm8b4XABje05g541v1zZipFOn/UNS0ouHg83vaZO4/4kr98WUpFrvB3ptbGmv
         PudC8Y0ofGs6LnOPCWE7od3S6KLFZMqnQmsordtV+nV472IEvwGVor2ud00hCRiVneYk
         4gbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Xxa+nHBqtJM1J1c7RVcdOL1FdV+GgtiVvLrSOEJTxhU=;
        b=qfYEe7lW/GbJPO6suOVgDJ2Z7YP2XUWJUPioxpFUZB2S4lCJPtBO/2Q+87DCZxsH1+
         gqjqnvKR6X0Pu66rJY4EK/Q/Yc/fElLJDD+8JB04lle3RbLvN0N6FmwCMS+mGZDcver5
         I76baEc0uqF9pvzD+OhTfzUGoo3DZj46rJo3OmxBsuBt03FUGsRyQSsAzufOz4d+zmtY
         pIMYI7vLwlk+t3CNNkMNnHIiiE1Jc+Yf11Q2pebpbe1sE06i1htreeqNv7mdzEe45ioF
         YMyzh+GL0Xv8eoML+YQ4S2cviLs8FO0KkosejiPqCqJkvsVKjnYU5uyCFqPVaKFeI/0T
         8LRA==
X-Gm-Message-State: AOAM531pQln+seKbJRKUw8+x3xNdx9wK88rkAdSUXPOht3QULMtPTdeJ
        qaAzyyUWZg7riZ3yUb0OEIQ5pC49urRFCQ==
X-Google-Smtp-Source: ABdhPJxlXeySzGeWginonzD7pBl0wdj40qRd22dRm1hN88qX9TGNApjkS0QFxmCA9KrtBAEysGPaXQ==
X-Received: by 2002:a65:6a44:: with SMTP id o4mr8623191pgu.276.1617299785199;
        Thu, 01 Apr 2021 10:56:25 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 04/12] ionic: split adminq post and wait calls
Date:   Thu,  1 Apr 2021 10:56:02 -0700
Message-Id: <20210401175610.44431-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the wait part out of adminq_post_wait() into a separate
function so that a caller can have finer grain control over
the sequencing of operations and locking.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h      |  2 ++
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 15 +++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 084a924431d5..18e92103c711 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -64,6 +64,8 @@ struct ionic_admin_ctx {
 	union ionic_adminq_comp comp;
 };
 
+int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx);
+int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx, int err);
 int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx);
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_wait);
 int ionic_set_dma_mask(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index c4b2906a2ae6..8c27fbe0e312 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -256,7 +256,7 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 	complete_all(&ctx->work);
 }
 
-static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
+int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 {
 	struct ionic_desc_info *desc_info;
 	unsigned long irqflags;
@@ -295,14 +295,12 @@ static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 	return err;
 }
 
-int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
+int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx, int err)
 {
 	struct net_device *netdev = lif->netdev;
 	unsigned long remaining;
 	const char *name;
-	int err;
 
-	err = ionic_adminq_post(lif, ctx);
 	if (err) {
 		if (!test_bit(IONIC_LIF_F_FW_RESET, lif->state)) {
 			name = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
@@ -317,6 +315,15 @@ int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 	return ionic_adminq_check_err(lif, ctx, (remaining == 0));
 }
 
+int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
+{
+	int err;
+
+	err = ionic_adminq_post(lif, ctx);
+
+	return ionic_adminq_wait(lif, ctx, err);
+}
+
 static void ionic_dev_cmd_clean(struct ionic *ionic)
 {
 	union __iomem ionic_dev_cmd_regs *regs = ionic->idev.dev_cmd_regs;
-- 
2.17.1

