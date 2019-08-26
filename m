Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 698F19D880
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfHZVd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:33:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33116 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729131AbfHZVd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:33:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so12646332pfq.0
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=YfV2ILdjm31FtsWwEgE/G55s+VrR3AVbH2QgfTNEri0=;
        b=yTXPvJPIkSbQBsbkcW3buDjRsFpw1nZZTTd+5cNXI+lZ7DURJpgUT6WKwkiktaaHTs
         At/uk/VeyYg3V3V+H+cIY3u66jUutBbWUgiHX6N/Ot8WVRnDbedgPvnSBnrHNeTlcGBh
         83ELiVbyFtvf1uIHztfQmgBplwTxgTB6MGYzVEJ0srNAetxQb8lX0dLFoZo+Au9mZvxw
         3Io1bIHiUAGt7x601gVySynL9bnZg5s8UgliQzzmMU2Wpq7IgR8c2GqiwOI8ItcXqOxT
         sz3ECNWVhHHUvhidO6XmI89dEplxPEDhw+FiBkjZhFPRoMjIF1T+FG8ull46EqeDsJe3
         VvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=YfV2ILdjm31FtsWwEgE/G55s+VrR3AVbH2QgfTNEri0=;
        b=qi+iIgPEt0n4UBu3Cv11duqf5rq9rmJsmjHmalv9oX1TYcdLnG1D5zHjqWmjIBt+qY
         MuIV/DZzULqlTsU4yDybgjwJZpRGPGUByxtJ8HFMBb9D2DQFGBLj0pcPFG6lxsI5djhg
         0sIvxdmYi5FTDCE9UoRlNpR7Rum4eZErGxJmktHnNWeJjSa5PmLGPi0wct3bPTFbuS/s
         d8qCDiX7Hxc8e8s04UeF41EmPbvRJ+v/f2n9qzpfZ/uWr7b2xO8TswJdt8O10IJQ4kMj
         XTne/H/e94nvwzcvWtGxxfSu00vp0A5gozZtXS6DQJ93fREARh1512EQEVrT8bf1cJmS
         TK1g==
X-Gm-Message-State: APjAAAVyFwcZzLX0AxxSfkNuM/ybcFWkcZuaXPdd+WcD8XofWkE6enAg
        l69yZOU/zQET0vn5wOuG87bbY9NT+4o=
X-Google-Smtp-Source: APXvYqwqaeMzdZg0gIbyYCkwAbvwYXJTpGftZtL5kkHrWXyxieXIW0WHvAd5RGGyvjNPYvXhqANCZA==
X-Received: by 2002:aa7:9524:: with SMTP id c4mr23064704pfp.225.1566855237166;
        Mon, 26 Aug 2019 14:33:57 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.33.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:33:56 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 07/18] ionic: Add adminq action
Date:   Mon, 26 Aug 2019 14:33:28 -0700
Message-Id: <20190826213339.56909-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826213339.56909-1-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
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
index 3e39bd76f3c8..5a705233449a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -46,9 +46,16 @@ struct ionic {
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
index a9d2bac7e02d..a1583c1b22a9 100644
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
+						HZ * (ulong)devcmd_timeout);
+	return ionic_adminq_check_err(lif, ctx, (remaining == 0));
+}
+
 int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
 	       ionic_cq_done_cb done_cb, void *done_arg)
 {
-- 
2.17.1

