Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E866A76F7
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfICW25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:28:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39094 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbfICW24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:28:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id s12so4800807pfe.6
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=XM4qqvketDc7+jTWJt7cefKlRddPAZKNm5cv9VyEArk=;
        b=ILMWmjqekGayDdYS4M+cfNc8X0VjY1e63xtAlUd2TMcixQ5/wgXDlP0uHgcamz30nv
         w7xSDfXUz8NpgcC+j/GcAVUiX11Y2sR+0lMZKomuoF7mCh9bWlbTDS1dDn5bF0uwx90n
         edxsr0Dd/KLApWJCdIZQDvLBbLkauYf+AEuGUwlQl813Cwrp4xLK3Gc1tHsPldNFnvbO
         xy4hO9610f2jEfbseudT0WH2sxVtycpTZrxeKLlAVvG+TKRteookfo3t2FD543MaB7qR
         x3CmFsVQrp9UC7JnV6xX7nfFs56t51Dajle7DUYYv3vJ0RMDci3nkaEePJVaSjryCxNw
         iu5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=XM4qqvketDc7+jTWJt7cefKlRddPAZKNm5cv9VyEArk=;
        b=ZxOSsHZ9876SrA9PBhftYw7uCIBGzmOGr8rJ67st9i1+EsRk2ghZ0YjFGBHiUqZhgU
         8Ah0YmeOPHpP5OSE0hyiWoaTdcfmmyy5YiZ+GmWwdcl2Oa9wB8BpgImN05ME9qjyR/ZQ
         p3nq/T8a+A3Jzng0MV/K3H71Mx1VjYi3L/bX+Ab/01qhRdxqxVw4kG1l5BJgVucSWy0q
         8Rw//CG1ccjxvP8QlQgjjxO8PA05FPfrlZf3F9YwSNvuXtA7TrHlZWNV7tMdf7h/HYL4
         SgIRKKwR6hph/jzjk6RbHE8Qxx3/LNzjfrT13jwwL77Di8kXmMiOziB1UTjzm7ZsDjdo
         MF+A==
X-Gm-Message-State: APjAAAVREosmQ5xQ6Xs+L6XMB6Z8EnXdTpb5eqv0U6NMLh2nSYQP6uJa
        pdGfMwH5qwdTwW4LD1hAWvHOkA==
X-Google-Smtp-Source: APXvYqzk3+4rFAaJp3V4mXHuDPvfw3SMvAQhTacUt2qgRusibirtVYZactunXlgXb/JnrJZSnLOVkA==
X-Received: by 2002:a17:90a:ff08:: with SMTP id ce8mr1599613pjb.123.1567549735232;
        Tue, 03 Sep 2019 15:28:55 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.28.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:28:54 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 08/19] ionic: Add adminq action
Date:   Tue,  3 Sep 2019 15:28:10 -0700
Message-Id: <20190903222821.46161-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add AdminQ specific message requests and completion handling.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |   7 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  | 111 ++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 23d39be54064..16b1f054ebbe 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -44,9 +44,16 @@ struct ionic {
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
 };
 
+struct ionic_admin_ctx {
+	struct completion work;
+	union ionic_adminq_cmd cmd;
+	union ionic_adminq_comp comp;
+};
+
 int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
 	       ionic_cq_done_cb done_cb, void *done_arg);
 
+int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx);
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_wait);
 int ionic_set_dma_mask(struct ionic *ionic);
 int ionic_setup(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 56206fd3e3a5..5ec67f3f1853 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -169,6 +169,117 @@ static const char *ionic_opcode_to_str(enum ionic_cmd_opcode opcode)
 	}
 }
 
+static void ionic_adminq_flush(struct ionic_lif *lif)
+{
+	struct ionic_queue *adminq = &lif->adminqcq->q;
+
+	spin_lock(&lif->adminq_lock);
+
+	while (adminq->tail != adminq->head) {
+		memset(adminq->tail->desc, 0, sizeof(union ionic_adminq_cmd));
+		adminq->tail->cb = NULL;
+		adminq->tail->cb_arg = NULL;
+		adminq->tail = adminq->tail->next;
+	}
+	spin_unlock(&lif->adminq_lock);
+}
+
+static int ionic_adminq_check_err(struct ionic_lif *lif,
+				  struct ionic_admin_ctx *ctx,
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
+static void ionic_adminq_cb(struct ionic_queue *q,
+			    struct ionic_desc_info *desc_info,
+			    struct ionic_cq_info *cq_info, void *cb_arg)
+{
+	struct ionic_admin_ctx *ctx = cb_arg;
+	struct ionic_admin_comp *comp;
+	struct device *dev;
+
+	if (!ctx)
+		return;
+
+	comp = cq_info->cq_desc;
+	dev = &q->lif->netdev->dev;
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
+static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
+{
+	struct ionic_queue *adminq = &lif->adminqcq->q;
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
+int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
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
+						HZ * (ulong)DEVCMD_TIMEOUT);
+	return ionic_adminq_check_err(lif, ctx, (remaining == 0));
+}
+
 int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
 	       ionic_cq_done_cb done_cb, void *done_arg)
 {
-- 
2.17.1

