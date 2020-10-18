Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A28291D3F
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbgJRToB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730309AbgJRTX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58460222EB;
        Sun, 18 Oct 2020 19:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049007;
        bh=NmE6hQ/3FioMCYKCOFbaQxX06Kh6L1zhoofrRgH5x+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMTQfMv/MWuNHfszp5bIuY9AeL+UWWifgigw2In7cyilQ/hTGymJqI0dfNhnBchP+
         IHyHOol5rE9lfmvL+Ln5JoeLo/ZKjQLYE/5umhcfZxlrH3NQeRlKUpGK9yBeVb+OWR
         x1/aF69CkNBZTQfXZCKJXLsbsQpGR7sjxOy/F+Ug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 43/80] can: flexcan: flexcan_chip_stop(): add error handling and propagate error value
Date:   Sun, 18 Oct 2020 15:21:54 -0400
Message-Id: <20201018192231.4054535-43-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit 9ad02c7f4f279504bdd38ab706fdc97d5f2b2a9c ]

This patch implements error handling and propagates the error value of
flexcan_chip_stop(). This function will be called from flexcan_suspend()
in an upcoming patch in some SoCs which support LPSR mode.

Add a new function flexcan_chip_stop_disable_on_error() that tries to
disable the chip even in case of errors.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
[mkl: introduce flexcan_chip_stop_disable_on_error() and use it in flexcan_close()]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20200922144429.2613631-11-mkl@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/flexcan.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e5c207ad3c77d..aaa7ed1dc97ee 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1232,18 +1232,23 @@ static int flexcan_chip_start(struct net_device *dev)
 	return err;
 }
 
-/* flexcan_chip_stop
+/* __flexcan_chip_stop
  *
- * this functions is entered with clocks enabled
+ * this function is entered with clocks enabled
  */
-static void flexcan_chip_stop(struct net_device *dev)
+static int __flexcan_chip_stop(struct net_device *dev, bool disable_on_error)
 {
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->regs;
+	int err;
 
 	/* freeze + disable module */
-	flexcan_chip_freeze(priv);
-	flexcan_chip_disable(priv);
+	err = flexcan_chip_freeze(priv);
+	if (err && !disable_on_error)
+		return err;
+	err = flexcan_chip_disable(priv);
+	if (err && !disable_on_error)
+		goto out_chip_unfreeze;
 
 	/* Disable all interrupts */
 	priv->write(0, &regs->imask2);
@@ -1253,6 +1258,23 @@ static void flexcan_chip_stop(struct net_device *dev)
 
 	flexcan_transceiver_disable(priv);
 	priv->can.state = CAN_STATE_STOPPED;
+
+	return 0;
+
+ out_chip_unfreeze:
+	flexcan_chip_unfreeze(priv);
+
+	return err;
+}
+
+static inline int flexcan_chip_stop_disable_on_error(struct net_device *dev)
+{
+	return __flexcan_chip_stop(dev, true);
+}
+
+static inline int flexcan_chip_stop(struct net_device *dev)
+{
+	return __flexcan_chip_stop(dev, false);
 }
 
 static int flexcan_open(struct net_device *dev)
@@ -1341,7 +1363,7 @@ static int flexcan_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 	can_rx_offload_disable(&priv->offload);
-	flexcan_chip_stop(dev);
+	flexcan_chip_stop_disable_on_error(dev);
 
 	can_rx_offload_del(&priv->offload);
 	free_irq(dev->irq, dev);
-- 
2.25.1

