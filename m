Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD425A67E
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfF1VkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:40:21 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38450 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfF1Vjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:39:51 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so3629088pfn.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=IGPZQfLW2UWcth5nB36u1X0JrT10nAzAWRTVOqxMha4=;
        b=3Zul7m7F4pRF/IDfDePEIesePEaTEx3dDm4+byNWGH7Aj+0RWHBKxd5Ng/tbmdrg1v
         cbRZZtGC+UxiTQgqOvanYXShQMXZariMxNxXwTMSbsBuurOiZB3mlPFJy75c08lHCX2G
         KV5Udp0o2cnN+d2j9Ufj8XwYyOqQWioIV4W7zkOfSDObRT5vNgCCVaE47RcBZA7yQCvS
         5t7ggAhpmbT68bhV4X5C7ukZCc+tc5ap/MutZGsRMafBwJeLQCA0regLgZpusMTC+CUH
         WUcoqILVLuOMdKsdViL0Zgi/PniLeH0+pb9MYHzmrFYWHtTmswjlRfZOncnIrd0q+Gr2
         J96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=IGPZQfLW2UWcth5nB36u1X0JrT10nAzAWRTVOqxMha4=;
        b=M/dpTiHPdIv5aMio+ItcmGkclrkRc5wKc8fVHaqo47hY5MGH6mSS8yBdhsnCRKPpOO
         pij2cjCpzaQ/3IJ9I8yor2WuR+VmT4muazejC+jJuIhenGZKPSw/tGhWnPVlW+9s9spY
         nGH6zao6xk3WdkTAz0UCD/ukb/+OTnpDozE0OWJJpYxn5wNxDFQ2acTYIhd0gnYdpcJu
         gzBdgN7EwRlOhAIOcz71I0qw5kikyHjxcAQrrO6z4lwEFsI+T68hTw7HYKoa7gxBx32I
         LZ6tLvFDTNHwLRX+2yuP21CcNliNPNS70JzucND1hVlK0qOfkxwsa3WTONGGU5hdvfwB
         vJpQ==
X-Gm-Message-State: APjAAAUnaGKEveR3Z+5oZoHl1XVzazQObbJyX6Bml4e5Dop/DqNCfnFF
        qb03Tfsg2pS9moUUxlIM8f3d+3DlhHE=
X-Google-Smtp-Source: APXvYqzLAEo63/KJasze7jk89Tzkc0wVG/UUlZS/frEBBlUeq8nKTJYu1c8uUNdAdgPkK4l8H1RLrg==
X-Received: by 2002:a65:538d:: with SMTP id x13mr11406254pgq.190.1561757990168;
        Fri, 28 Jun 2019 14:39:50 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 135sm3516920pfb.137.2019.06.28.14.39.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 14:39:49 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 07/19] ionic: Add adminq action
Date:   Fri, 28 Jun 2019 14:39:22 -0700
Message-Id: <20190628213934.8810-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628213934.8810-1-snelson@pensando.io>
References: <20190628213934.8810-1-snelson@pensando.io>
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

