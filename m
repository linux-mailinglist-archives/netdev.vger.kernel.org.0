Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737E047671E
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhLPArT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbhLPArS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:47:18 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F668C06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:18 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id u4-20020a056a00098400b004946fc3e863so14394626pfg.8
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Zqx+JA+CCY/r+M4FLeWBHWKil1+lASrhKANf0oGDSpI=;
        b=BK0scwODexi3tOrUA8ZFajw9+BTlUaZ9ecdlnTXBJmItu33yl/H9heYdMCS7gjb7qx
         Qm7C5po0Lf/cLdwO23icsgNXlWqXzYHoB7cFxYuRUXPu4slskQEQ1Vn3q5grPQ40lshx
         BUagssHJauIC+haNtW9pNcyUTSUd/Us6nAKrrrxDLy6zqj5s3cvr5rHqPCYBTg3BNC+s
         YdjCh/MtMlCCHRDAosnpPRQmS0BfcXxDbDDBL9bl/rf/ifoeG3CazZ/Uzws68HLeuBkp
         sTO254V5xWBpzn2Tbb6bZhzO6y1y7QFfdQXbYCQN55qiUtwyQDQqnFedCBCOHSrMy3Wz
         fTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Zqx+JA+CCY/r+M4FLeWBHWKil1+lASrhKANf0oGDSpI=;
        b=ZLZnivtJ6j+sAPFJzGRkZNBtYPHoRWNeoYcEdVd8f41QWE6Jqs+Coqy4m0rM975DcK
         c1sLaPeE7yNkjRN9IsT8gXMDqPl7YJsotbT8Oo7hAUPevwYXsItu9npsaURrzN5y3ow3
         x/VHC1WNA6R5sKKZNsqSSTccphjCSwI88IzxZ8dGvPwBbQSpFvs6qBTKqOVc46eWcOgp
         DB07ehMlgpXuiZNVEksgO/4cyyvvdqp9jONhDAw0QYcqB8GdNOXjpwYab4WrxV2KOkZ0
         r20s6PfH61x3OX96WH1sVZcmVwtw26HxJjSWkDKnU40EO0uXjEm3M5lzkJjWwapAXfeW
         9zTw==
X-Gm-Message-State: AOAM531IqpH7UOSlRCiKfb4xzoMy/o3Lfijgw877e3605Ro59Bblr5iS
        DY5mZ4CzzENCqSZbKGXviclTb36ymo5rc2ObxGXDex/bePQIosun8Ap9BKS6AAjQVxdM1OqJ8kR
        RBy9wr07P8rG8fobRJ4tWpbdSbAEJvLSaWyQcWpxf378wTTqnKiebEKLbp/MJpgvT9qI=
X-Google-Smtp-Source: ABdhPJxfsvWdq1MTVKcyMKNCjSWm0xpqvyMCR1SZzZnSK+J14FVMDIyZMpakH0s7GojJ8qosFccZ6CVgrGmfrw==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:964d:9084:bbdd:97a9])
 (user=jeroendb job=sendgmr) by 2002:a17:90a:c203:: with SMTP id
 e3mr213356pjt.0.1639615637411; Wed, 15 Dec 2021 16:47:17 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:46:50 -0800
In-Reply-To: <20211216004652.1021911-1-jeroendb@google.com>
Message-Id: <20211216004652.1021911-7-jeroendb@google.com>
Mime-Version: 1.0
References: <20211216004652.1021911-1-jeroendb@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH net-next 6/8] gve: Implement suspend/resume/shutdown
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Add support for suspend, resume and shutdown.

Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h      |  3 ++
 drivers/net/ethernet/google/gve/gve_main.c | 57 ++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index ed43b8ece5a2..950dff787269 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -557,6 +557,8 @@ struct gve_priv {
 	u32 page_alloc_fail; /* count of page alloc fails */
 	u32 dma_mapping_error; /* count of dma mapping errors */
 	u32 stats_report_trigger_cnt; /* count of device-requested stats-reports since last reset */
+	u32 suspend_cnt; /* count of times suspended */
+	u32 resume_cnt; /* count of times resumed */
 	struct workqueue_struct *gve_wq;
 	struct work_struct service_task;
 	struct work_struct stats_report_task;
@@ -573,6 +575,7 @@ struct gve_priv {
 
 	/* Gvnic device link speed from hypervisor. */
 	u64 link_speed;
+	bool up_before_suspend; /* True if dev was up before suspend */
 
 	struct gve_options_dqo_rda options_dqo_rda;
 	struct gve_ptype_lut *ptype_lut_dqo;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 086424518ecc..e5456187b3f2 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1676,6 +1676,58 @@ static void gve_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static void gve_shutdown(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct gve_priv *priv = netdev_priv(netdev);
+	bool was_up = netif_carrier_ok(priv->dev);
+
+	rtnl_lock();
+	if (was_up && gve_close(priv->dev)) {
+		/* If the dev was up, attempt to close, if close fails, reset */
+		gve_reset_and_teardown(priv, was_up);
+	} else {
+		/* If the dev wasn't up or close worked, finish tearing down */
+		gve_teardown_priv_resources(priv);
+	}
+	rtnl_unlock();
+}
+
+#ifdef CONFIG_PM
+static int gve_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct gve_priv *priv = netdev_priv(netdev);
+	bool was_up = netif_carrier_ok(priv->dev);
+
+	priv->suspend_cnt++;
+	rtnl_lock();
+	if (was_up && gve_close(priv->dev)) {
+		/* If the dev was up, attempt to close, if close fails, reset */
+		gve_reset_and_teardown(priv, was_up);
+	} else {
+		/* If the dev wasn't up or close worked, finish tearing down */
+		gve_teardown_priv_resources(priv);
+	}
+	priv->up_before_suspend = was_up;
+	rtnl_unlock();
+	return 0;
+}
+
+static int gve_resume(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct gve_priv *priv = netdev_priv(netdev);
+	int err;
+
+	priv->resume_cnt++;
+	rtnl_lock();
+	err = gve_reset_recovery(priv, priv->up_before_suspend);
+	rtnl_unlock();
+	return err;
+}
+#endif /* CONFIG_PM */
+
 static const struct pci_device_id gve_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_GOOGLE, PCI_DEV_ID_GVNIC) },
 	{ }
@@ -1686,6 +1738,11 @@ static struct pci_driver gvnic_driver = {
 	.id_table	= gve_id_table,
 	.probe		= gve_probe,
 	.remove		= gve_remove,
+	.shutdown	= gve_shutdown,
+#ifdef CONFIG_PM
+	.suspend        = gve_suspend,
+	.resume         = gve_resume,
+#endif
 };
 
 module_pci_driver(gvnic_driver);
-- 
2.34.1.173.g76aa8bc2d0-goog

