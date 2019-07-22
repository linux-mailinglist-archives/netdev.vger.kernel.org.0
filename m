Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD7370BA7
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732835AbfGVVks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:40:48 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34633 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732826AbfGVVkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so12061897pgc.1
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=8op+FA7Hwni2HXiOOLSambgM9SHO2CZrw0EFPNQBx24=;
        b=ol9LNZNHKcV4m2UmmqGtJuwuMBP0Mcuonmrld40p6GWy07AOmDZXnSpHtvkXsx4vke
         d7ztE1uvencPMyPAe5v86cSrkFWSE4tAVuBQTlHLLICtgntQ9u8lHIYMDkFJXWiPyOU1
         UX5BYih7NYJMfaV+q9xguUB9VzjQGfWGRPPAJZalXpoerNzmZwGeRfmKYn5tTdtsr1Jo
         IiRgYqi7vs60aA7A0pR3PaAoqYnj4CKMNvZPMlfDq0uL7ymk79j3Z52PlTpKEBIwZxrA
         EiOR92tEovKgiqBkdx6zhxH1CEPYCseFhi3nCb34P6ao0v52XezileCCRa51xYj9HoIh
         qsmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=8op+FA7Hwni2HXiOOLSambgM9SHO2CZrw0EFPNQBx24=;
        b=OiG8Ngnsww4EBqoyhZakRu8P3rJK/Vq/yqboBWS2R8pSXGB6vyaaz5OFXM7Q4SI1VL
         5xVFZdiGYIV5ntoXiwRLRIUsvoJ9vftxDOdfHuXVnSaQyGcXQVuQRXd7N+s3eUDGqvX0
         /ltPxLLQFHzBRcC5Z7D/qyN02ooYVSPYBLlEYiRVbMxE0mgODcx4Yk9Kq3xzUGznqyam
         zMxfb0DC45COzuQDO2RoxObQv+c6cQDByAq8U6qKzUBHYL+qud76oT6IFJhFCStmjmdR
         ZE2O9KwLil9XOdPgKGSLULihUVq+yjpvhI/Sb6eL5u1DDeASLJTyKej8Z4HtLkviTpsZ
         SoOQ==
X-Gm-Message-State: APjAAAVApoiz08nHqv3+qs4fVGV0NMV7iBB+xK1Mpbp8fq4pPSpaTqFh
        usSmHGcYFXzrnHBSsxru8U7aAw==
X-Google-Smtp-Source: APXvYqyK2imZmCqgQr6mYUE1jYBz2CQiGHqhb52DYsNSFg1l7RvZPqZgBZKUL6UwdPE23I1Xu8dnVw==
X-Received: by 2002:a63:a302:: with SMTP id s2mr3902310pge.125.1563831644603;
        Mon, 22 Jul 2019 14:40:44 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:44 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 15/19] ionic: Add netdev-event handling
Date:   Mon, 22 Jul 2019 14:40:19 -0700
Message-Id: <20190722214023.9513-16-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722214023.9513-1-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the netdev gets a new name from userland, pass that name
down to the NIC for internal tracking.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 65 +++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index d7eee79b2a10..9b720187b549 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -42,6 +42,8 @@ struct ionic {
 	DECLARE_BITMAP(lifbits, IONIC_LIFS_MAX);
 	unsigned int nintrs;
 	DECLARE_BITMAP(intrs, INTR_CTRL_REGS_MAX);
+	struct work_struct nb_work;
+	struct notifier_block nb;
 };
 
 struct ionic_admin_ctx {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 40d3b1cb362a..9e032d813269 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1954,10 +1954,69 @@ int ionic_lifs_init(struct ionic *ionic)
 	return 0;
 }
 
+static void ionic_lif_notify_work(struct work_struct *ws)
+{
+}
+
+static void ionic_lif_set_netdev_info(struct lif *lif)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = CMD_OPCODE_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_NAME,
+		},
+	};
+
+	strlcpy(ctx.cmd.lif_setattr.name, lif->netdev->name,
+		sizeof(ctx.cmd.lif_setattr.name));
+
+	dev_info(lif->ionic->dev, "NETDEV_CHANGENAME %s %s\n",
+		 lif->name, ctx.cmd.lif_setattr.name);
+
+	ionic_adminq_post_wait(lif, &ctx);
+}
+
+static struct lif *ionic_netdev_lif(struct net_device *netdev)
+{
+	if (!netdev || netdev->netdev_ops->ndo_start_xmit != ionic_start_xmit)
+		return NULL;
+
+	return netdev_priv(netdev);
+}
+
+static int ionic_lif_notify(struct notifier_block *nb,
+			    unsigned long event, void *info)
+{
+	struct net_device *ndev = netdev_notifier_info_to_dev(info);
+	struct ionic *ionic = container_of(nb, struct ionic, nb);
+	struct lif *lif = ionic_netdev_lif(ndev);
+
+	if (!lif || lif->ionic != ionic)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_CHANGENAME:
+		ionic_lif_set_netdev_info(lif);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 int ionic_lifs_register(struct ionic *ionic)
 {
 	int err;
 
+	INIT_WORK(&ionic->nb_work, ionic_lif_notify_work);
+
+	ionic->nb.notifier_call = ionic_lif_notify;
+
+	err = register_netdevice_notifier(&ionic->nb);
+	if (err)
+		ionic->nb.notifier_call = NULL;
+
 	/* only register LIF0 for now */
 	err = register_netdev(ionic->master_lif->netdev);
 	if (err) {
@@ -1973,6 +2032,12 @@ int ionic_lifs_register(struct ionic *ionic)
 
 void ionic_lifs_unregister(struct ionic *ionic)
 {
+	if (ionic->nb.notifier_call) {
+		unregister_netdevice_notifier(&ionic->nb);
+		cancel_work_sync(&ionic->nb_work);
+		ionic->nb.notifier_call = NULL;
+	}
+
 	/* There is only one lif ever registered in the
 	 * current model, so don't bother searching the
 	 * ionic->lif for candidates to unregister
-- 
2.17.1

