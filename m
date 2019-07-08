Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4FC62975
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404106AbfGHTZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:25:48 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44351 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404094AbfGHTZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:46 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so8056620pfe.11
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=IGPZQfLW2UWcth5nB36u1X0JrT10nAzAWRTVOqxMha4=;
        b=1KdgivsgtIoTDsMn8qdSkC4v7KcOgELjysLkLuRv/HhnUPgPamlmNXGBVHTiK27kge
         3ft21Br2SzuWg8F+3QYd0rcF4hxTfPXuLn5Q71wqdYtxxBOAQ5uiOIf1FABwk3M3sPs8
         CKhlkOsredPdbYsSMSfnZtHA0c0GZl84Y7ixqSujtPCWXQEJt1qAzF84xo6G/y2qvFFw
         gVVmYCBSqH1wI6QbQ5Cx2uCE046Hx2d03qTNtyZecvG8K+Z/T5ur3V6PQpaO+B0qQCRn
         CcZLhAwykWb+zH3pZSs4UoEasPbN1oaQgliEpQilmTYwjE/+jDwA5M04rts6uNOG38Qx
         rUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=IGPZQfLW2UWcth5nB36u1X0JrT10nAzAWRTVOqxMha4=;
        b=pFMwOpK3TEcvVRLAxT/cMq55hLfKwEMvOw2XscY5rpCM4d0zFOrrt2OZcSZIuxaM7U
         +NnVuiChhd6qG0HUoew16MZdcwOhakXRaCzA4E7tVY5LMfqSiTfKrsWVrduC6ttOIJH3
         Jv1HC5NrtU0cVK/BmqhFbO39nsi8kxfUn4RAIgrZG6TaDzhXjfEc/EQcqqLCO2vOJHh3
         dtrtHj7uYpJpMF02aNk9Zcf3YxYCHpvMltlNir59T0pL+GyJdEn/VKLlKH+bsFAghHGH
         aCvgyH6Fhxr78lLD+idqbfh4YJ2n01wTQdEs9mBSNdmNnvhKpbLl9O3qDFAAe2pZNf9Y
         C00Q==
X-Gm-Message-State: APjAAAWQFJb/BeMKzPtlhSJoVyt62tlyTekseVDPmtN4xk/64LaDjNWf
        4YoGQWSMcJEZh41OC7FkmC8b2DmYL2s=
X-Google-Smtp-Source: APXvYqzMSs7lO3i2J8t4azfNP8BB9XXT1nSUHFV6+gfz5SeLeofP7/7bD/O0gwaObf7M6BFODVhlig==
X-Received: by 2002:a17:90a:3401:: with SMTP id o1mr27730324pjb.7.1562613945448;
        Mon, 08 Jul 2019 12:25:45 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id n19sm20006770pfa.11.2019.07.08.12.25.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:44 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 07/19] ionic: Add adminq action
Date:   Mon,  8 Jul 2019 12:25:20 -0700
Message-Id: <20190708192532.27420-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190708192532.27420-1-snelson@pensando.io>
References: <20190708192532.27420-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add AdminQ specific message requests and completion handling.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |   7 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  | 106 ++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index c8c93e9efb39..87ab13aee89e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -43,9 +43,16 @@ struct ionic {
 	DECLARE_BITMAP(intrs, INTR_CTRL_REGS_MAX);
 };
 
+struct ionic_admin_ctx {
+	struct completion work;
+	union adminq_cmd cmd;
+	union adminq_comp comp;
+};
+
 int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
 	       ionic_cq_done_cb done_cb, void *done_arg);
 
+int ionic_adminq_post_wait(struct lif *lif, struct ionic_admin_ctx *ctx);
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_wait);
 int ionic_set_dma_mask(struct ionic *ionic);
 int ionic_setup(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index aa73ea81a4b2..3b44e1752258 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -169,6 +169,112 @@ static const char *ionic_opcode_to_str(enum cmd_opcode opcode)
 	}
 }
 
+static void ionic_adminq_flush(struct lif *lif)
+{
+	struct queue *adminq = &lif->adminqcq->q;
+
+	spin_lock(&lif->adminq_lock);
+
+	while (adminq->tail != adminq->head) {
+		memset(adminq->tail->desc, 0, sizeof(union adminq_cmd));
+		adminq->tail->cb = NULL;
+		adminq->tail->cb_arg = NULL;
+		adminq->tail = adminq->tail->next;
+	}
+	spin_unlock(&lif->adminq_lock);
+}
+
+static int ionic_adminq_check_err(struct lif *lif, struct ionic_admin_ctx *ctx,
+				  bool timeout)
+{
+	struct net_device *netdev = lif->netdev;
+	const char *opcode_str;
+	const char *status_str;
+	int err = 0;
+
+	if (ctx->comp.comp.status || timeout) {
+		opcode_str = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
+		status_str = ionic_error_to_str(ctx->comp.comp.status);
+		err = timeout ? -ETIMEDOUT :
+				ionic_error_to_errno(ctx->comp.comp.status);
+
+		netdev_err(netdev, "%s (%d) failed: %s (%d)\n",
+			   opcode_str, ctx->cmd.cmd.opcode,
+			   timeout ? "TIMEOUT" : status_str, err);
+
+		if (timeout)
+			ionic_adminq_flush(lif);
+	}
+
+	return err;
+}
+
+static void ionic_adminq_cb(struct queue *q, struct desc_info *desc_info,
+			    struct cq_info *cq_info, void *cb_arg)
+{
+	struct ionic_admin_ctx *ctx = cb_arg;
+	struct admin_comp *comp = cq_info->cq_desc;
+	struct device *dev = &q->lif->netdev->dev;
+
+	if (!ctx)
+		return;
+
+	memcpy(&ctx->comp, comp, sizeof(*comp));
+
+	dev_dbg(dev, "comp admin queue command:\n");
+	dynamic_hex_dump("comp ", DUMP_PREFIX_OFFSET, 16, 1,
+			 &ctx->comp, sizeof(ctx->comp), true);
+
+	complete_all(&ctx->work);
+}
+
+static int ionic_adminq_post(struct lif *lif, struct ionic_admin_ctx *ctx)
+{
+	struct queue *adminq = &lif->adminqcq->q;
+	int err = 0;
+
+	WARN_ON(in_interrupt());
+
+	spin_lock(&lif->adminq_lock);
+	if (!ionic_q_has_space(adminq, 1)) {
+		err = -ENOSPC;
+		goto err_out;
+	}
+
+	memcpy(adminq->head->desc, &ctx->cmd, sizeof(ctx->cmd));
+
+	dev_dbg(&lif->netdev->dev, "post admin queue command:\n");
+	dynamic_hex_dump("cmd ", DUMP_PREFIX_OFFSET, 16, 1,
+			 &ctx->cmd, sizeof(ctx->cmd), true);
+
+	ionic_q_post(adminq, true, ionic_adminq_cb, ctx);
+
+err_out:
+	spin_unlock(&lif->adminq_lock);
+
+	return err;
+}
+
+int ionic_adminq_post_wait(struct lif *lif, struct ionic_admin_ctx *ctx)
+{
+	struct net_device *netdev = lif->netdev;
+	unsigned long remaining;
+	const char *name;
+	int err;
+
+	err = ionic_adminq_post(lif, ctx);
+	if (err) {
+		name = ionic_opcode_to_str(ctx->cmd.cmd.opcode);
+		netdev_err(netdev, "Posting of %s (%d) failed: %d\n",
+			   name, ctx->cmd.cmd.opcode, err);
+		return err;
+	}
+
+	remaining = wait_for_completion_timeout(&ctx->work,
+						HZ * (ulong)devcmd_timeout);
+	return ionic_adminq_check_err(lif, ctx, (remaining == 0));
+}
+
 int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
 	       ionic_cq_done_cb done_cb, void *done_arg)
 {
-- 
2.17.1

