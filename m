Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553893D5B31
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhGZNcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbhGZNbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:31:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6744C061389
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:14 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81L3-0001Jt-42
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:13 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BCE7C6581FB
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:03 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 54917658188;
        Mon, 26 Jul 2021 14:11:50 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f3983bd5;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Faiz Abbas <faiz_abbas@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 14/46] can: m_can: Add support for transceiver as phy
Date:   Mon, 26 Jul 2021 16:11:12 +0200
Message-Id: <20210726141144.862529-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

Add support for implementing transceiver node as phy. The max_bitrate
is obtained by getting a phy attribute.

Link: https://lore.kernel.org/r/20210724174001.553047-1-mkl@pengutronix.de
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c          | 11 ++++++++++-
 drivers/net/can/m_can/m_can.h          |  2 ++
 drivers/net/can/m_can/m_can_platform.c | 13 +++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 317cdc98c539..c430432c28ec 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -21,6 +21,7 @@
 #include <linux/iopoll.h>
 #include <linux/can/dev.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/phy/phy.h>
 
 #include "m_can.h"
 
@@ -1521,6 +1522,8 @@ static int m_can_close(struct net_device *dev)
 	close_candev(dev);
 	can_led_event(dev, CAN_LED_EVENT_STOP);
 
+	phy_power_off(cdev->transceiver);
+
 	return 0;
 }
 
@@ -1706,10 +1709,14 @@ static int m_can_open(struct net_device *dev)
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int err;
 
-	err = m_can_clk_start(cdev);
+	err = phy_power_on(cdev->transceiver);
 	if (err)
 		return err;
 
+	err = m_can_clk_start(cdev);
+	if (err)
+		goto out_phy_power_off;
+
 	/* open the can device */
 	err = open_candev(dev);
 	if (err) {
@@ -1766,6 +1773,8 @@ static int m_can_open(struct net_device *dev)
 	close_candev(dev);
 exit_disable_clks:
 	m_can_clk_stop(cdev);
+out_phy_power_off:
+	phy_power_off(cdev->transceiver);
 	return err;
 }
 
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index ace071c3e58c..38cad068abad 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -28,6 +28,7 @@
 #include <linux/iopoll.h>
 #include <linux/can/dev.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/phy/phy.h>
 
 /* m_can lec values */
 enum m_can_lec_type {
@@ -82,6 +83,7 @@ struct m_can_classdev {
 	struct workqueue_struct *tx_wq;
 	struct work_struct tx_work;
 	struct sk_buff *tx_skb;
+	struct phy *transceiver;
 
 	struct can_bittiming_const *bit_timing;
 	struct can_bittiming_const *data_timing;
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 599de0e08cd7..8b5819cd4b80 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -6,6 +6,7 @@
 // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
 
 #include <linux/platform_device.h>
+#include <linux/phy/phy.h>
 
 #include "m_can.h"
 
@@ -67,6 +68,7 @@ static int m_can_plat_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *addr;
 	void __iomem *mram_addr;
+	struct phy *transceiver;
 	int irq, ret = 0;
 
 	mcan_class = m_can_class_allocate_dev(&pdev->dev,
@@ -101,6 +103,16 @@ static int m_can_plat_probe(struct platform_device *pdev)
 		goto probe_fail;
 	}
 
+	transceiver = devm_phy_optional_get(&pdev->dev, NULL);
+	if (IS_ERR(transceiver)) {
+		ret = PTR_ERR(transceiver);
+		dev_err_probe(&pdev->dev, ret, "failed to get phy\n");
+		goto probe_fail;
+	}
+
+	if (transceiver)
+		mcan_class->can.bitrate_max = transceiver->attrs.max_link_rate;
+
 	priv->base = addr;
 	priv->mram_base = mram_addr;
 
@@ -108,6 +120,7 @@ static int m_can_plat_probe(struct platform_device *pdev)
 	mcan_class->pm_clock_support = 1;
 	mcan_class->can.clock.freq = clk_get_rate(mcan_class->cclk);
 	mcan_class->dev = &pdev->dev;
+	mcan_class->transceiver = transceiver;
 
 	mcan_class->ops = &m_can_plat_ops;
 
-- 
2.30.2


