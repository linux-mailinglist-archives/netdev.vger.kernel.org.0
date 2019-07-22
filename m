Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D89570BA4
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732821AbfGVVkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:40:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40921 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732779AbfGVVkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:37 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so17987790pfp.7
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=IGPZQfLW2UWcth5nB36u1X0JrT10nAzAWRTVOqxMha4=;
        b=bwQx4xfKEvFv+i3EXTCourZ6hMPpk1j9nms28Cdnwb4L9AQQfqZBMlW5QiE5sZebI6
         W5RVmHqcA9BA2Ru4VYcjEm4Wq0wT3GMOZUHcxUvp7YLeZ7Ouyj/veijBxeiE1TjwVD6H
         bMWlbAuau7h8bZvIdsmCvzWOny7F7p33ilHe5Drn+ncNprW4sq5czPtt0uq7QE0sFvtW
         JUcMi8lgtYs1vsCYFzrPEBmLF0bwWTMb4vmYojFtY5SEkg70GhZIl4W9l3ERAftga0fb
         t83d5fxhCAEadG49j2ZFCSU64hbvv3YllnFCtJbdIlp8nxFKsAXmG6x1YRpeYzitO2MN
         gu7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=IGPZQfLW2UWcth5nB36u1X0JrT10nAzAWRTVOqxMha4=;
        b=fDABE98zI4vt48AkWajKjvzNvuyr8znb41vuSmwUtJsm26ETtqV5r8Y2dH1EVc1agV
         NNluSnkpz7cfThl6CYlbSFxk28aJe6ma0QSxbTCjKI1JkQHsMLPuf3bgBW4wySy58l0s
         A0yh+helMkgHLjsRPcX3gDHu+mJuJPfQovsKrA+xcHQnRZP8KvT7OR1LwtbsxbIJqrLs
         5yPFyRbUCIcJi1zywt7BRZjTWpqCIsdhK0nKJdYPXK7KLmgH1RsJ0E9/VOmwk9d7XyD8
         Wt73FeaEw6JDuQW4QCJFnVBqVRlPvGzS7hdC5nkP0uz7uZxtROcfO0cz3GJrBfMazexY
         qlyQ==
X-Gm-Message-State: APjAAAWzwKf/7WlbvAhZXxi0DedmYv+pNhj4HxIpjlf6mhKBJ5xr9K/g
        3tYp8R724FEaHg1WYjnzFqTYzg==
X-Google-Smtp-Source: APXvYqxl+9u825kTiwfd0taEizDX1cNnUVmwiiz3aoa37Wt+4iAsXBSngMZIxz/NiCHZZAv7k/G7iQ==
X-Received: by 2002:a62:764d:: with SMTP id r74mr2400831pfc.110.1563831636259;
        Mon, 22 Jul 2019 14:40:36 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:35 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 07/19] ionic: Add adminq action
Date:   Mon, 22 Jul 2019 14:40:11 -0700
Message-Id: <20190722214023.9513-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722214023.9513-1-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
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

