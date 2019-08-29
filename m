Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1344A2523
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbfH2S2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:28:40 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39548 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729462AbfH2S16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:27:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id y200so2625797pfb.6
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=GAGu66XunmwI5Pfvw1MPRyV6tp0PU82/n3KG/bGf/3k=;
        b=y7wFzdYppUXZIn1BepY+CMpHOZjq72N/akC0e17RF50m0sIB+DxDQ2Ch5xwyPu2yd1
         sjfQCwSM4ZM6whrbfYFh+To7VEduO31i5gCu8JV2CsvzT6kU1rEKrG4+aB9vLGsqG9W7
         rkV/x2LZgjGWMIO/HdWNgsUwILIwgGbKTKwn0S9oLosQEKdt87tvLYRnChkMrwVlpELr
         uVZtVgyM9pzSqkdZ/fZRPDsOCwI+dKn2P9mQx5VZ7Ix0YUvqo+/3moxYA/Q7ZajWj05Z
         vffMRLo+UIplxWvfWGwfd9sbR4P1QYtLCzLuQWZ0neANy+c4ahpYejT1Hly0VEGFmfs9
         212g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=GAGu66XunmwI5Pfvw1MPRyV6tp0PU82/n3KG/bGf/3k=;
        b=MC3TDAHjJR5+HvFEfS8MxwUlYCU1UVMbvFbMTRrKNc+P2LjXOtTbk9E5DiCTlSpRaC
         ylgjDpCjpHS7XVee60FmqkSowJKYCgG7R+rSsNANyafQjVMFuwVP+pchDdizgH/4hFjn
         3POabYWWoRyDs0PjRAWXgDHWx5jml3GxBoWx9tvXNLjKun/PnEDYABHEeON4ftPDQdqT
         t4E1ULZwQypEAOJmNj7iRuHSqKAsTTw9nbv5e4rUYUEGnkg7YZBEg2Nq2/qjvD1S4wQY
         EYLz5g3khxRXQXJk8rUwFGMMi1YrUKrU1cwbHRH3jLkXertvOzuj2zkyuZkic5luDHDq
         qXXA==
X-Gm-Message-State: APjAAAWzv++zQ3550c3M796jnDqTJYqjsSCVZNyqvg/lIVsCLwyhO+Sc
        OGnKQo9atRnQm+SBA/56K4GU3w==
X-Google-Smtp-Source: APXvYqy9zoXHQnaGamC12b7/Ra6uO8rmMKfK3tsU07K8pLnPaO4luiJrec6VLLuH+gJ+vxdk06MErg==
X-Received: by 2002:a17:90a:fc90:: with SMTP id ci16mr11498065pjb.48.1567103277998;
        Thu, 29 Aug 2019 11:27:57 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t70sm3082824pjb.2.2019.08.29.11.27.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 11:27:57 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v6 net-next 08/19] ionic: Add adminq action
Date:   Thu, 29 Aug 2019 11:27:09 -0700
Message-Id: <20190829182720.68419-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829182720.68419-1-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
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
index 647f4c3b8b49..b57dcae5bc4a 100644
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

