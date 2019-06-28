Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA0755A67B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfF1VkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:40:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42514 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfF1Vj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:39:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so3614545pff.9
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=G4s6K2gNtK5sdz2QQKvl3Cpp608YhRphEO4Lx4uSUuw=;
        b=RxQD7KIHVInDjQhf6IV+aF1NF0t5CH70Zy+W9u1GqxbnZ6m6KGiqQQiT/iIgP6yMoX
         Y2S6pHB5iyo9qD2KxUaS9EXmAeHWhUcYp9zUQBj60n66GF1i+/LS/gIxecrF8UduWkrX
         gVfx4NTzsdWc2C28PF3qjMy4NlTbhD74p1Es6zxrdtLnw57pZpYwxs4kXi4+IncV+jiV
         OF4v6yvZZq1HDIaApGXKW+PLlmAHxt7QdNtWRnpSdSBb8JgU7G/LQEGzHz5+tJ9P+HcN
         Aiajx9bMohci4/IpRWdkMA4UE7ia4gW6+TcEyHu6Cq8ofdelMHn+EHcFiMSYAEhEd0/J
         vEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=G4s6K2gNtK5sdz2QQKvl3Cpp608YhRphEO4Lx4uSUuw=;
        b=KRF58ewKUhLsNv8/h9E9AE4z4QZue9ibrJ03fvWTWe1PydMslWL8k5WQpEQSMPhKyk
         KGoOVvBzPndbeQ6zfwLfYvPG8P7HvRq9nTw4IZkFgZ4ncaZ24zkvz2AhZcd7MI7rq0Wi
         FVVwM69uEaLrKmGwFdYM24k7b/KrY2bJNi966o4HvvSaNodZQQugNCh/6wZWCH+LCxNv
         CsCkN3ylxb9FHW7QrHEHhBm2GyGzhz15ZrCdc41/79TeSfzyARQeJwP+9teoCFEIChqn
         /qJL3pdgkTayQJgbS9io+XkwPQFD5nHTS9enhJQiXWI5KmKNiirzizTl8hx1EMWvAX65
         fpxQ==
X-Gm-Message-State: APjAAAVL64R/hDE4humQOiUKNwCOwWNWmCRIrMd0GGijp6YjcPL/LhwR
        o+ihtN/EXPlGHlQ22ViIrFQuwQ==
X-Google-Smtp-Source: APXvYqwMyMbTGI2F3qWoGRVXVaY6NVd13CNC/tuc/p+a1QINXSBlNKNA/1sX5zl3FrXqnoM52aY6oA==
X-Received: by 2002:a17:90a:8984:: with SMTP id v4mr15582083pjn.133.1561757998568;
        Fri, 28 Jun 2019 14:39:58 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 135sm3516920pfb.137.2019.06.28.14.39.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 14:39:58 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 15/19] ionic: Add netdev-event handling
Date:   Fri, 28 Jun 2019 14:39:30 -0700
Message-Id: <20190628213934.8810-16-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628213934.8810-1-snelson@pensando.io>
References: <20190628213934.8810-1-snelson@pensando.io>
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
index b47ed322496f..76974c61c306 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1956,10 +1956,69 @@ int ionic_lifs_init(struct ionic *ionic)
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
@@ -1975,6 +2034,12 @@ int ionic_lifs_register(struct ionic *ionic)
 
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

