Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5F4A7701
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfICW3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:29:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39327 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfICW3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:29:04 -0400
Received: by mail-pl1-f194.google.com with SMTP id bd8so2253814plb.6
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=1ZM3S8YJeRaaI/XVCQ/MGdutRbZgTHfnx8R9SuVyIjw=;
        b=n/RHGDmkc3rTv5gFsjhfmERDE5AKqzTIL2kjK1dDVSZMhGZSHHhRRyW5S6XMJSn62T
         QHQZ/5WUa9ShefK0fZXXfDvQYqgJGGqUkJP8yj4/SXDygJgHT3hqBZTMryM1lPt5gIn7
         g1A/ihebxEho5tEZXLfi1iUGv8p2rOKG3mQAl4hNtlofIJgTyf+qObPuYA9vlxPC45DB
         tNJugPGmAgBCnZs9gR5ynjy4LrUGyh3XdqpNvn3jWJbYG9tpCqRabUIywMlQCM6022hG
         0O/e6WAHYQwKBPGMyK28vtmvtAeCFVh2yMQts/F36g0zvTeqdIubSk8YFaJtOFScWl3f
         uRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=1ZM3S8YJeRaaI/XVCQ/MGdutRbZgTHfnx8R9SuVyIjw=;
        b=orqh2r5U2mBU321O4pnfJRyJguAkQRwoetoQGxBfDbGGONuEIarRY5+1Jasn0NLgdM
         jM6hUo/xzLSY0nNd7wtL+Aqz4XWnje+oqS/DFeQPqmW7YQhnNxJ6g7UXKQZGzCPabMEz
         I8DrCDPF/Ac/pcd95w2/mohsfMzeBiIbtOIPY3HfgJwQ64RU8fuwm93c+91EwaB10KCs
         hoSgi4LIdzHNR1VuQ8V0oe6MWwF8fVXV1gGqg9MRrA3PsxIhemXN/Ksj3Wauc9eMmJFo
         igs2/KDLm/sim+oW+SFCmxWTSX9FNICdQdlIAaBeJ5MLKG2W2ka6z2uRpmjJshk9rhJi
         Wg0g==
X-Gm-Message-State: APjAAAU225Iur1V9T/K8plAfyDq9regX/xsD57x+J9Ow8JE0n3iYr/r9
        P+Dm2POVfMfKnY+xO51XoCfWndfJSPUbpw==
X-Google-Smtp-Source: APXvYqxLA1+F3wZ56IJWpl4Cu5XMRad7+X1K5LHHRgQlndNOmtk4JGm1pS3BOZzcXDGjAdKzyGEQcg==
X-Received: by 2002:a17:902:bb88:: with SMTP id m8mr4098314pls.127.1567549743730;
        Tue, 03 Sep 2019 15:29:03 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.29.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:29:03 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 16/19] ionic: Add netdev-event handling
Date:   Tue,  3 Sep 2019 15:28:18 -0700
Message-Id: <20190903222821.46161-17-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the netdev gets a new name from userland, pass that name
down to the NIC for internal tracking.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 62 +++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 8269ea24bd79..7a7060677f15 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -44,6 +44,8 @@ struct ionic {
 	DECLARE_BITMAP(lifbits, IONIC_LIFS_MAX);
 	unsigned int nintrs;
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
+	struct work_struct nb_work;
+	struct notifier_block nb;
 };
 
 struct ionic_admin_ctx {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f574359cb956..025ad6a6fce4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1955,10 +1955,66 @@ int ionic_lifs_init(struct ionic *ionic)
 	return 0;
 }
 
+static void ionic_lif_notify_work(struct work_struct *ws)
+{
+}
+
+static void ionic_lif_set_netdev_info(struct ionic_lif *lif)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_NAME,
+		},
+	};
+
+	strlcpy(ctx.cmd.lif_setattr.name, lif->netdev->name,
+		sizeof(ctx.cmd.lif_setattr.name));
+
+	ionic_adminq_post_wait(lif, &ctx);
+}
+
+static struct ionic_lif *ionic_netdev_lif(struct net_device *netdev)
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
+	struct ionic_lif *lif = ionic_netdev_lif(ndev);
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
@@ -1974,6 +2030,12 @@ int ionic_lifs_register(struct ionic *ionic)
 
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

