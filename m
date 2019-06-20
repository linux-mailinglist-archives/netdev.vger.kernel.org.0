Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7840A4DB25
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfFTUYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:24:51 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36741 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbfFTUYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:45 -0400
Received: by mail-pl1-f194.google.com with SMTP id k8so1846080plt.3
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=/q5jcpjD+XaN2NV9RYvbvTUpUdqG7LgTFQYQR+5uYCA=;
        b=Z5Q1rar47odrQRqUhsOHRYztCzpiETTr2uMp7jcAE00e5yT+S4b1ZUnmuKuu4EpcE0
         UNae5IuPPHsahM/aSGlnzIlS2leJMUEYUNAxMlsIotqbvSC+dXyiiwYu7Kk73jNc0fVH
         94jnRR+8twZUBYhMOwmAy9kxit6uHlyVitl8iFoMGStZZHgco8qpvbPwxuBX1wYzArje
         4OwPkb2ECJYsCtYskR7w23PQIcfsjOPWxNHBOdQUw3hjf8A7g3c6+jlV7zdsOMaOCkN0
         b1HFeCApF/OVzgur/JG51PQLQvpeGxFakg9CH/mnV2evNN9bdtyjDlf0Xvg4rkAdG24a
         Mgzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=/q5jcpjD+XaN2NV9RYvbvTUpUdqG7LgTFQYQR+5uYCA=;
        b=YWB8sivzeHhZcBIijhlf33awIM9bA3G7K3ju57c+3quiXr/pTlLk00Si2QKrMQBqnV
         5DGeAwXa12K79X6sr0INLgWWBKa1+b9CaNyAEx1/v8UbnKKVYHQzH1ckgA0AYBCdYYa2
         QbJ8AhL7DnuvO8Kxs1mnY9rDXNF1oQoV/m7IeFIwaCD6SmNRGPQEVV6a0noY8NSFDXYY
         Q1RaohiTsgw3nvsVwsdUos0UK1sQJkaK3WHRM91DfhAR+ibrsgUkUdQ4rCclDd/i+5Jc
         XD90S+pWQhhEbz3/PHHT2avsgUDnEyBjszNEk7T8KN6ZNm6RXziKAeFT3t3w9fV8Wayp
         HsBA==
X-Gm-Message-State: APjAAAX3/DGTWEy8ZyySpbnHP+as7kNl69XKouSFLU6zHBRCAuSGv7et
        NLcYqm4ANtVevVkOk+gXGywPT/WnLJ8=
X-Google-Smtp-Source: APXvYqyqacUuSvCds3ORXov1yOMNfjHl5tEsCaZ4elZo3WcsVEWoPO2rYFlC4Myw97hBOfjjnyAqHw==
X-Received: by 2002:a17:902:bd0a:: with SMTP id p10mr51442278pls.134.1561062284687;
        Thu, 20 Jun 2019 13:24:44 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:44 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 15/18] ionic: Add netdev-event handling
Date:   Thu, 20 Jun 2019 13:24:21 -0700
Message-Id: <20190620202424.23215-16-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
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
index 90128a54d800..12f30427ea91 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -45,6 +45,8 @@ struct ionic {
 	DECLARE_BITMAP(lifbits, IONIC_LIFS_MAX);
 	unsigned int nintrs;
 	DECLARE_BITMAP(intrs, INTR_CTRL_REGS_MAX);
+	struct work_struct nb_work;
+	struct notifier_block nb;
 };
 
 struct ionic_admin_ctx {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 146c070c4f90..88fa9397e64a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1985,10 +1985,69 @@ int ionic_lifs_init(struct ionic *ionic)
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
@@ -2004,6 +2063,12 @@ int ionic_lifs_register(struct ionic *ionic)
 
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

