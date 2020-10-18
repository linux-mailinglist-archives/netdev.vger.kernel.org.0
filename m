Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C8F291ABC
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbgJRT0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731567AbgJRT0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3372D22314;
        Sun, 18 Oct 2020 19:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049169;
        bh=D520WNrr0uWEc7SIFgK6phE/cBpAaUU6XSAVxI02Nh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbEVDWXqSU4vpXwtdtm+A+tD5lz1jb5QCAUoq4RgbHpWSEyDA4Lnx6zqRV418b3RC
         +sf43iU0nYgaWwC2vfGC2PASOpT9W2I6co90SxnL+FmSIw1ppO29RI9KWw+i2rrpNP
         Mhm6F6IliKBJSzwtOnU6Y49CpZ41uDo7St3/Y9aY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 32/52] can: flexcan: flexcan_chip_stop(): add error handling and propagate error value
Date:   Sun, 18 Oct 2020 15:25:09 -0400
Message-Id: <20201018192530.4055730-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
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
index 84dd79041285a..94468a883f369 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1055,18 +1055,23 @@ static int flexcan_chip_start(struct net_device *dev)
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
 	flexcan_write(0, &regs->imask2);
@@ -1076,6 +1081,23 @@ static void flexcan_chip_stop(struct net_device *dev)
 
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
@@ -1129,7 +1151,7 @@ static int flexcan_close(struct net_device *dev)
 
 	netif_stop_queue(dev);
 	can_rx_offload_disable(&priv->offload);
-	flexcan_chip_stop(dev);
+	flexcan_chip_stop_disable_on_error(dev);
 
 	free_irq(dev->irq, dev);
 	clk_disable_unprepare(priv->clk_per);
-- 
2.25.1

