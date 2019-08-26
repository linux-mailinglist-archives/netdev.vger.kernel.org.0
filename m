Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6992D9D885
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfHZVeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:34:08 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41430 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfHZVeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:34:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id m9so10648913pls.8
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=C0oeyzcarKa89xVLlBWN3685Ou+lneXMHEY5/fSuoyY=;
        b=MIP3knMwtvBsdkvkBVBohI1rLKsvA36kEzqy7tSEBuiGaLPzHByTTeo13g9odpv7Kr
         +ZOFbrxgDie3quFVJEAHLCiI+OrwvROfHEw2ZxnhanJ+hFjIH0lmsqbVoGrgZh3zCb73
         kSuH8ZUbwKiIDSl6H2Zx2mDK9rpmFv/S8Z2x4hLZeu6/VuY5udH5smrBnTjoTOzHiu3V
         9PIkwgHzbdp0QQKTz3KII2B+bQL787TXfeHlOgTUU9kvkQ2izBk9XS9LP7aJQh7lVNXh
         3X8u1kZ/Nu4uBMnGXJ1RowNhlIB3Sq0S6/02y76kOhdCl60eZgqJDVyI/qMbVxCicWFv
         s7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=C0oeyzcarKa89xVLlBWN3685Ou+lneXMHEY5/fSuoyY=;
        b=GvgKaBLgenfXNFs3FLMEKDhD4VYJuns5+J4nDoUd8DQOQcmThsW3WiFhpZxY5OyL0C
         HekafhGyp6v7S/yRhOSiTdhJWRIbRFMkyg1ZS6rXKh9mCnjkhix5NHO/FzYoWyvA/MOn
         eL2ecTDhHJ8pnsqcFXQg7UHxSSjXDshTQRWW1VAAdvm5TFDSaHLSswg9McskOKbMuamy
         jC8zag/zSqeIQCVc9YSur4YlR1cU53s4Pw4mrHG0tie4AFpcyWerqr4VOTr7eJfEiB+E
         1M5YbF+Yq5X188OXDp3gHfPXLB2IburUYCmj/kzCWw5TRyJ7rAa2qblYbbpSj4xxjHe/
         9abg==
X-Gm-Message-State: APjAAAWAyeVWFlGVbEScErH2taWuc7T+TtusL+9oZAcoIpiEG/xgNFNx
        KHGx9bHxUcRN+XUbqyNmHWKVrhgB8ts=
X-Google-Smtp-Source: APXvYqyI3tFYacFJYpwxS5xzgPNgN1LTXAlr45nweDeAc/n8VfntjEPeqGkT6C1zFaaHGhuFocgoQg==
X-Received: by 2002:a17:902:449:: with SMTP id 67mr21639472ple.105.1566855246438;
        Mon, 26 Aug 2019 14:34:06 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.34.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:34:05 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 15/18] ionic: Add netdev-event handling
Date:   Mon, 26 Aug 2019 14:33:36 -0700
Message-Id: <20190826213339.56909-16-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826213339.56909-1-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
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
index 82b45e3384c3..d46103cb3a13 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -45,6 +45,8 @@ struct ionic {
 	DECLARE_BITMAP(lifbits, IONIC_LIFS_MAX);
 	unsigned int nintrs;
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
+	struct work_struct nb_work;
+	struct notifier_block nb;
 };
 
 struct ionic_admin_ctx {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 61572823e993..41e2768ea47b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1947,10 +1947,66 @@ int ionic_lifs_init(struct ionic *ionic)
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
@@ -1966,6 +2022,12 @@ int ionic_lifs_register(struct ionic *ionic)
 
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

