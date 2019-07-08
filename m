Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F126662979
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404126AbfGHTZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:25:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42789 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404113AbfGHTZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:53 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so8062096pff.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=8op+FA7Hwni2HXiOOLSambgM9SHO2CZrw0EFPNQBx24=;
        b=cVGi8AkuTWT9vRlisfhuueaJ4jTFyyA11mXJF/22izycWpDp1qMO0kk6ku+uiVxwAs
         oSg34dluJEp6lYvxDIzdMqiHQklBNpLKEc9i9QRRSfWGeHodnkLjspOfE7N+Hx3ACxlP
         o7EM/GyVnignwPCxTZSj3MGQaTVGqF4NFZTV321Ykc7qMFVDl5WhJpxiKE3gk2B7KDfC
         UM0bCcrT7zjMLdyYsjzpaIsW6+I1cp+HQoNwXG8rCIUt/ziiy8Hz5sOAqGicwHxC7s+Q
         GroWDbJcPqI214pHCQYXzcd1xuKM9v/Nj7tBkkP9hGdtBvIsFdzIE3VQr6Pf/TvuvgIl
         P9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=8op+FA7Hwni2HXiOOLSambgM9SHO2CZrw0EFPNQBx24=;
        b=r242Fs9OtYlyr0HfJAlHUVgxwivRZyqx5d3R2d4SVe5+8f1K2I6KjPQrw4pnwXIYdY
         Oux2JW0bMTcxJEkvGzHGzdyQ81juH2/uiuM/V0ADa2m5p4+Ejm8JJXjoW54tc0gYn98+
         JtHIU0WN3rdhta+NTjzrahX00YyX80S2+IM5x4PhAcCCs3NrAIgA7P32WV2T/fKA81sc
         Vw91gpZq7C44QnTmjs9KK/Uo8dQHQXhzl16l/+BPywcoU6hYtbQhHg94tVjucVShGzzo
         llJJ/RCI30733Z5b99GHrKNusfmE3SF1+0q6WZyP5OI7nzYqe9hp8+EqnChRYWHms6L6
         hBYg==
X-Gm-Message-State: APjAAAULDjECKEZI1iOATeEhhvcJtGjISXku74zDm9ua+b9sIXiRjmXk
        fY6cPCPWT3V42XDxALk4oXBL0uaiXBg=
X-Google-Smtp-Source: APXvYqzDZtH/r13qex0UGYTSTKX4BUn2tbv8RnKbGTikUApD3qMpUmJwvbDS4QLmqblwZVJwBZ1fOA==
X-Received: by 2002:a17:90a:2648:: with SMTP id l66mr27458441pje.65.1562613953249;
        Mon, 08 Jul 2019 12:25:53 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id n19sm20006770pfa.11.2019.07.08.12.25.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:52 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 15/19] ionic: Add netdev-event handling
Date:   Mon,  8 Jul 2019 12:25:28 -0700
Message-Id: <20190708192532.27420-16-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190708192532.27420-1-snelson@pensando.io>
References: <20190708192532.27420-1-snelson@pensando.io>
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

