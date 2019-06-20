Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0355F4DB1E
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfFTUYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:24:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46565 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfFTUYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id 81so2274547pfy.13
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=53fLGP807dWgI5YkdBAnR8z/qLFfcY0ubkUQpMOAnQQ=;
        b=0MC3zX1qUN6I2ypgD977uESSCn3OKE7RruqX2hIyfbMBAYY05MwC7xeqB+AQ7T7Ls6
         MirPJxaWiSJZpkxhC1v2jUo8t6QWfJMgz5imteebsozK5R7tKWX84Ovp+ELH9a5b+Z6u
         6u8hP4zjL5s451fE/NNnbOT4CfgWRfGbpw0CGeObe1u5Id1AUY/br7KLhxsOEzF5Zt7/
         oM1/gL/sMf9Hsj4bLs8n9InXuwvV6Ir7JyjcT/RybCwW1/NMbLhY+fJiQQ8o60oqDhum
         +vkeca8yiDsOdu5MVb6RGCpMeykWttA2pfN5jHdFd80TaC3xHTnwHanlB56oVhzuLlE7
         SopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=53fLGP807dWgI5YkdBAnR8z/qLFfcY0ubkUQpMOAnQQ=;
        b=rUqpF49PxiS3mGNcSkUH4PJm6Z79vhF1TX27xFsL1+3bhzLNqtZAXQWrae+No3WCzA
         kaTSX7wAK9C7GD5DfxrJQ/mkrXjSnyHrHd7BAlkwHTVnCLLyxNQk8DwsSy67qgrxN/UJ
         Aj2KP5UDzM8ZXaYkJFN6Ac9/hC/5GcjWkVH9M/9e6TLRlxbfA1urIOC7WlMK6vVQe27D
         sU4Hu71UbB2tjDQz/U98jWt8E7IYht1vQrVw8AqsxuTRXUpMA4H+79JOLe/Godfct3+s
         dAUbIPa9aruYxMrOJXT47SrDeaDUJIYdjOc13aeDJUa1RF16fkCU7gVnhxyZoJu5CwCj
         l7aw==
X-Gm-Message-State: APjAAAWXkRm7nfn0tv/Ofh03aCSOEGrLiAN/Touvwbf4qZrpatR95e1E
        bOiGaZr/glFziJ/+80gMFfS5Mw==
X-Google-Smtp-Source: APXvYqz0AMP/BxTJQR0zEX1SA2hVNsJu737jHdTk340Tj47V7cEkaCPrX5Oqak8WteGTepypuvu4ZA==
X-Received: by 2002:a17:90a:cb18:: with SMTP id z24mr1460760pjt.108.1561062276805;
        Thu, 20 Jun 2019 13:24:36 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:36 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 07/18] ionic: Add adminq action
Date:   Thu, 20 Jun 2019 13:24:13 -0700
Message-Id: <20190620202424.23215-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
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
index f1e7c754bcda..c79bf5450495 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -46,9 +46,16 @@ struct ionic {
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
index 17d8802e69ae..9713e0f584aa 100644
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

