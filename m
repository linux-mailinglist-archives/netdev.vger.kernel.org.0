Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073742D98F3
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 14:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439580AbgLNNf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 08:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407982AbgLNNdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 08:33:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9053C0611C5
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 05:31:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1konxF-0003VZ-DT
        for netdev@vger.kernel.org; Mon, 14 Dec 2020 14:31:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 923EC5AD2D1
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:31:54 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 015525AD298;
        Mon, 14 Dec 2020 13:31:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0a1d330d;
        Mon, 14 Dec 2020 13:31:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sean Nyekjaer <sean@geanix.com>, Dan Murphy <dmurphy@ti.com>
Subject: [net-next 7/7] can: m_can: use struct m_can_classdev as drvdata
Date:   Mon, 14 Dec 2020 14:31:45 +0100
Message-Id: <20201214133145.442472-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214133145.442472-1-mkl@pengutronix.de>
References: <20201214133145.442472-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The m_can driver's suspend and resume functions (m_can_class_suspend() and
m_can_class_resume()) make use of dev_get_drvdata() and assume that the drvdata
is a pointer to the struct net_device.

With upcoming conversion of the tcan4x5x driver to pm_runtime this assumption
is no longer valid. As the suspend and resume functions actually need a struct
m_can_classdev pointer, change the m_can_platform and the m_can_pci driver to
hold a pointer to struct m_can_classdev instead, as the tcan4x5x driver already
does.

Link: https://lore.kernel.org/r/20201212175518.139651-8-mkl@pengutronix.de
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c          |  8 ++++----
 drivers/net/can/m_can/m_can_pci.c      |  5 ++---
 drivers/net/can/m_can/m_can_platform.c | 14 +++++++-------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index cc7972a103dc..2c9f12401276 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1859,8 +1859,8 @@ EXPORT_SYMBOL_GPL(m_can_class_unregister);
 
 int m_can_class_suspend(struct device *dev)
 {
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_classdev *cdev = netdev_priv(ndev);
+	struct m_can_classdev *cdev = dev_get_drvdata(dev);
+	struct net_device *ndev = cdev->net;
 
 	if (netif_running(ndev)) {
 		netif_stop_queue(ndev);
@@ -1879,8 +1879,8 @@ EXPORT_SYMBOL_GPL(m_can_class_suspend);
 
 int m_can_class_resume(struct device *dev)
 {
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_classdev *cdev = netdev_priv(ndev);
+	struct m_can_classdev *cdev = dev_get_drvdata(dev);
+	struct net_device *ndev = cdev->net;
 
 	pinctrl_pm_select_default_state(dev);
 
diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index ebfbef25e3f9..128808605c3f 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -115,7 +115,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	mcan_class->can.clock.freq = id->driver_data;
 	mcan_class->ops = &m_can_pci_ops;
 
-	pci_set_drvdata(pci, mcan_class->net);
+	pci_set_drvdata(pci, mcan_class);
 
 	ret = m_can_class_register(mcan_class);
 	if (ret)
@@ -138,8 +138,7 @@ static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 
 static void m_can_pci_remove(struct pci_dev *pci)
 {
-	struct net_device *dev = pci_get_drvdata(pci);
-	struct m_can_classdev *mcan_class = netdev_priv(dev);
+	struct m_can_classdev *mcan_class = pci_get_drvdata(pci);
 	struct m_can_pci_priv *priv = cdev_to_priv(mcan_class);
 
 	pm_runtime_forbid(&pci->dev);
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 5758d25e42c8..599de0e08cd7 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -113,7 +113,7 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	mcan_class->is_peripheral = false;
 
-	platform_set_drvdata(pdev, mcan_class->net);
+	platform_set_drvdata(pdev, mcan_class);
 
 	m_can_init_ram(mcan_class);
 
@@ -143,8 +143,8 @@ static __maybe_unused int m_can_resume(struct device *dev)
 
 static int m_can_plat_remove(struct platform_device *pdev)
 {
-	struct net_device *dev = platform_get_drvdata(pdev);
-	struct m_can_classdev *mcan_class = netdev_priv(dev);
+	struct m_can_plat_priv *priv = platform_get_drvdata(pdev);
+	struct m_can_classdev *mcan_class = &priv->cdev;
 
 	m_can_class_unregister(mcan_class);
 
@@ -155,8 +155,8 @@ static int m_can_plat_remove(struct platform_device *pdev)
 
 static int __maybe_unused m_can_runtime_suspend(struct device *dev)
 {
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_classdev *mcan_class = netdev_priv(ndev);
+	struct m_can_plat_priv *priv = dev_get_drvdata(dev);
+	struct m_can_classdev *mcan_class = &priv->cdev;
 
 	clk_disable_unprepare(mcan_class->cclk);
 	clk_disable_unprepare(mcan_class->hclk);
@@ -166,8 +166,8 @@ static int __maybe_unused m_can_runtime_suspend(struct device *dev)
 
 static int __maybe_unused m_can_runtime_resume(struct device *dev)
 {
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_classdev *mcan_class = netdev_priv(ndev);
+	struct m_can_plat_priv *priv = dev_get_drvdata(dev);
+	struct m_can_classdev *mcan_class = &priv->cdev;
 	int err;
 
 	err = clk_prepare_enable(mcan_class->hclk);
-- 
2.29.2


