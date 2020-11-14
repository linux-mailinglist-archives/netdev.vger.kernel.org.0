Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65C42B2F1A
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgKNRet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgKNRen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 12:34:43 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADA6C0617A7
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 09:34:43 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kdzRh-0000mY-OS; Sat, 14 Nov 2020 18:34:41 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 14/15] can: m_can: Fix freeing of can device from peripherials
Date:   Sat, 14 Nov 2020 18:33:58 +0100
Message-Id: <20201114173358.2058600-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201114173358.2058600-1-mkl@pengutronix.de>
References: <20201114173358.2058600-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

Fix leaking netdev device from peripherial devices. The call to allocate the
netdev device is made from and managed by the peripherial.

Fixes: d42f4e1d06d9 ("can: m_can: Create a m_can platform framework")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Link: http://lore.kernel.org/r/20200227183829.21854-2-dmurphy@ti.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c          |  3 ---
 drivers/net/can/m_can/m_can_platform.c | 23 +++++++++++++++--------
 drivers/net/can/m_can/tcan4x5x.c       | 26 ++++++++++++++++++--------
 3 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f2c87b76e569..645101d19989 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1856,7 +1856,6 @@ int m_can_class_register(struct m_can_classdev *m_can_dev)
 	if (ret) {
 		if (m_can_dev->pm_clock_support)
 			pm_runtime_disable(m_can_dev->dev);
-		free_candev(m_can_dev->net);
 	}
 
 	return ret;
@@ -1914,8 +1913,6 @@ void m_can_class_unregister(struct m_can_classdev *m_can_dev)
 	unregister_candev(m_can_dev->net);
 
 	m_can_clk_stop(m_can_dev);
-
-	free_candev(m_can_dev->net);
 }
 EXPORT_SYMBOL_GPL(m_can_class_unregister);
 
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index e6d0cb9ee02f..161cb9be018c 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -67,32 +67,36 @@ static int m_can_plat_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		ret = -ENOMEM;
+		goto probe_fail;
+	}
 
 	mcan_class->device_data = priv;
 
-	m_can_class_get_clocks(mcan_class);
+	ret = m_can_class_get_clocks(mcan_class);
+	if (ret)
+		goto probe_fail;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "m_can");
 	addr = devm_ioremap_resource(&pdev->dev, res);
 	irq = platform_get_irq_byname(pdev, "int0");
 	if (IS_ERR(addr) || irq < 0) {
 		ret = -EINVAL;
-		goto failed_ret;
+		goto probe_fail;
 	}
 
 	/* message ram could be shared */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
 	if (!res) {
 		ret = -ENODEV;
-		goto failed_ret;
+		goto probe_fail;
 	}
 
 	mram_addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!mram_addr) {
 		ret = -ENOMEM;
-		goto failed_ret;
+		goto probe_fail;
 	}
 
 	priv->base = addr;
@@ -111,9 +115,10 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	m_can_init_ram(mcan_class);
 
-	ret = m_can_class_register(mcan_class);
+	return m_can_class_register(mcan_class);
 
-failed_ret:
+probe_fail:
+	m_can_class_free_dev(mcan_class->net);
 	return ret;
 }
 
@@ -134,6 +139,8 @@ static int m_can_plat_remove(struct platform_device *pdev)
 
 	m_can_class_unregister(mcan_class);
 
+	m_can_class_free_dev(mcan_class->net);
+
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index 4fdb7121403a..e5d7d85e0b6d 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -440,14 +440,18 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 		return -ENOMEM;
 
 	priv = devm_kzalloc(&spi->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		ret = -ENOMEM;
+		goto out_m_can_class_free_dev;
+	}
 
 	priv->power = devm_regulator_get_optional(&spi->dev, "vsup");
-	if (PTR_ERR(priv->power) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
-	else
+	if (PTR_ERR(priv->power) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto out_m_can_class_free_dev;
+	} else {
 		priv->power = NULL;
+	}
 
 	mcan_class->device_data = priv;
 
@@ -460,8 +464,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	}
 
 	/* Sanity check */
-	if (freq < 20000000 || freq > TCAN4X5X_EXT_CLK_DEF)
-		return -ERANGE;
+	if (freq < 20000000 || freq > TCAN4X5X_EXT_CLK_DEF) {
+		ret = -ERANGE;
+		goto out_m_can_class_free_dev;
+	}
 
 	priv->reg_offset = TCAN4X5X_MCAN_OFFSET;
 	priv->mram_start = TCAN4X5X_MRAM_START;
@@ -518,8 +524,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 		clk_disable_unprepare(mcan_class->cclk);
 		clk_disable_unprepare(mcan_class->hclk);
 	}
-
+ out_m_can_class_free_dev:
+	m_can_class_free_dev(mcan_class->net);
 	dev_err(&spi->dev, "Probe failed, err=%d\n", ret);
+
 	return ret;
 }
 
@@ -531,6 +539,8 @@ static int tcan4x5x_can_remove(struct spi_device *spi)
 
 	tcan4x5x_power_enable(priv->power, 0);
 
+	m_can_class_free_dev(priv->mcan_dev->net);
+
 	return 0;
 }
 
-- 
2.29.2

