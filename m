Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E666BA251B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfH2S22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:28:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46940 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729624AbfH2S2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:28:07 -0400
Received: by mail-pf1-f196.google.com with SMTP id q139so2606418pfc.13
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=KFTr0XkVk2VmfrrUkIVhYCbi16w2KtNebevMzTNYLMY=;
        b=Icf6ayLqqPStnnsNOLzPNG7YteA95wavaZVx9GKeDTYjiOnLWLnk1It8K83JQrOT2u
         c9/JxQuhkvhbUh/wQbV8/jfzGnwyLR2vRoy/PK/pSVref1qgoFNqJlUmOW7YYY69MUq7
         bggNFtX52Nlnuax+e7r8VfChvcoxDUcLjZ4QgsMq3kWpezBtV2c6q+ojI/RIKWjqFJcN
         EhWGac2MP0fSblueWsfwQIte7s1GcChVJvyb8DZhJ8uwDKd0PaeP+uYHdEsG5Yy2XKIU
         v67d8PyGOtJf8iCmr3dAyIgqv3TxttqscARL19ulPwNOaPrPOWpNLy77JHWm/PQ9ETnE
         Dn+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=KFTr0XkVk2VmfrrUkIVhYCbi16w2KtNebevMzTNYLMY=;
        b=Sc90iK0RMmyeIAT13NlFUNSf+pPaN1kMkv13shStOBh69DOO2P49SbVvErEDlEMrwo
         QHajLq7nM3TiowjEpilqLRN3MQZPge+n8LoObwmsXfQw7jFJ8XrhqtHH3Zs9XmJ4YVPh
         UA/MSJ33BAd2O9tfPRwXK/phABZccshAQmTS/caoMuxOQN8VlBQnPmYjfdPKNGi29FbS
         cDaPVEybpvV+mlAIZ2yUiufEkDvY5rawC5QrTk8iuOJnvF6l4FEtxsEoWuhvD8dGEOBG
         ZSpPKuoQXNVSxlU3oyir4cxSdHYwXGpt+HFG6rFRVnWG1hbckNVg00a3pb/YKhmnlfFm
         xtaA==
X-Gm-Message-State: APjAAAWQBv5rjuvAVUN+uYN+410X48G9tGOQ7Mvy+7eRbY+P132WqiOs
        c6WkoIRGq65t+9bdbmMXT8AZmw==
X-Google-Smtp-Source: APXvYqz8f4mXH1lqNLdklFBtFiHEE0ZHP/I4swPrO7o+x3ceTzrIuxVRRnoI9u1r8/XiNYRgX4i/zw==
X-Received: by 2002:aa7:9477:: with SMTP id t23mr13398819pfq.29.1567103287099;
        Thu, 29 Aug 2019 11:28:07 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t70sm3082824pjb.2.2019.08.29.11.28.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 11:28:06 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v6 net-next 16/19] ionic: Add netdev-event handling
Date:   Thu, 29 Aug 2019 11:27:17 -0700
Message-Id: <20190829182720.68419-17-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829182720.68419-1-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
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
index 575c571d7b5e..1f2b826fbb54 100644
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

