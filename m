Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600D5649DCE
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiLLLcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiLLLbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DD264D0
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:08 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1W-0000bJ-KX
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:06 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2427613CC3A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:57 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1907913CBE7;
        Mon, 12 Dec 2022 11:30:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ed81f713;
        Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Vivek Yadav <vivek.2311@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 26/39] can: m_can: Call the RAM init directly from m_can_chip_config
Date:   Mon, 12 Dec 2022 12:30:32 +0100
Message-Id: <20221212113045.222493-27-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivek Yadav <vivek.2311@samsung.com>

When we try to access the mcan message ram addresses during the probe,
hclk is gated by any other drivers or disabled, because of that probe
gets failed.

Move the mram init functionality to mcan chip config called by
m_can_start from mcan open function, by that time clocks are
enabled.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
Link: https://lore.kernel.org/all/20221207100632.96200-2-vivek.2311@samsung.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c          | 32 +++++++++++++++++++++-----
 drivers/net/can/m_can/m_can_platform.c |  4 ----
 drivers/net/can/m_can/tcan4x5x-core.c  |  5 ----
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index b1893bb27d59..be8f4b662f95 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1243,10 +1243,17 @@ static int m_can_set_bittiming(struct net_device *dev)
  * - setup bittiming
  * - configure timestamp generation
  */
-static void m_can_chip_config(struct net_device *dev)
+static int m_can_chip_config(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 cccr, test;
+	int err;
+
+	err = m_can_init_ram(cdev);
+	if (err) {
+		dev_err(cdev->dev, "Message RAM configuration failed\n");
+		return err;
+	}
 
 	m_can_config_endisable(cdev, true);
 
@@ -1370,18 +1377,25 @@ static void m_can_chip_config(struct net_device *dev)
 
 	if (cdev->ops->init)
 		cdev->ops->init(cdev);
+
+	return 0;
 }
 
-static void m_can_start(struct net_device *dev)
+static int m_can_start(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
+	int ret;
 
 	/* basic m_can configuration */
-	m_can_chip_config(dev);
+	ret = m_can_chip_config(dev);
+	if (ret)
+		return ret;
 
 	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
 
 	m_can_enable_all_interrupts(cdev);
+
+	return 0;
 }
 
 static int m_can_set_mode(struct net_device *dev, enum can_mode mode)
@@ -1809,7 +1823,9 @@ static int m_can_open(struct net_device *dev)
 	}
 
 	/* start the m_can controller */
-	m_can_start(dev);
+	err = m_can_start(dev);
+	if (err)
+		goto exit_irq_fail;
 
 	if (!cdev->is_peripheral)
 		napi_enable(&cdev->napi);
@@ -2068,9 +2084,13 @@ int m_can_class_resume(struct device *dev)
 		ret = m_can_clk_start(cdev);
 		if (ret)
 			return ret;
+		ret  = m_can_start(ndev);
+		if (ret) {
+			m_can_clk_stop(cdev);
+
+			return ret;
+		}
 
-		m_can_init_ram(cdev);
-		m_can_start(ndev);
 		netif_device_attach(ndev);
 		netif_start_queue(ndev);
 	}
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index b5a5bedb3116..9c1dcf838006 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -140,10 +140,6 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mcan_class);
 
-	ret = m_can_init_ram(mcan_class);
-	if (ret)
-		goto probe_fail;
-
 	pm_runtime_enable(mcan_class->dev);
 	ret = m_can_class_register(mcan_class);
 	if (ret)
diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index 41645a24384c..a3aeb83de152 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -234,11 +234,6 @@ static int tcan4x5x_init(struct m_can_classdev *cdev)
 	if (ret)
 		return ret;
 
-	/* Zero out the MCAN buffers */
-	ret = m_can_init_ram(cdev);
-	if (ret)
-		return ret;
-
 	ret = regmap_update_bits(tcan4x5x->regmap, TCAN4X5X_CONFIG,
 				 TCAN4X5X_MODE_SEL_MASK, TCAN4X5X_MODE_NORMAL);
 	if (ret)
-- 
2.35.1


