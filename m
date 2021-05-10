Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A76D377B81
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 07:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhEJF1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 01:27:32 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53424 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhEJF1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 01:27:23 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 14A5QAEu078564;
        Mon, 10 May 2021 00:26:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1620624370;
        bh=+LgbeEpcGAX1uaIBoLFr6F1+kThw6gjG8L/0QWGfkRY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=eSZHJG0wsxYsO7+qEgWymP9/SgPkv3IiMY4IJy3toL3JjIXqUHoKnklzmcCY/q8dF
         oqwEBX4UoS2yLab//TfZksBdHwqsafaEdLmT6XJ77KQ9RtdcsvBmNTiXkPQznquemV
         z/zAOlbSvjiFt1lG7NrKDnldv9ZVjuQVGjgWj3rU=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 14A5QAEE084465
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 May 2021 00:26:10 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 10
 May 2021 00:26:09 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Mon, 10 May 2021 00:26:09 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 14A5PfCo045426;
        Mon, 10 May 2021 00:26:01 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>
Subject: [PATCH v4 2/2] can: m_can: Add support for transceiver as phy
Date:   Mon, 10 May 2021 10:55:41 +0530
Message-ID: <20210510052541.14168-3-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210510052541.14168-1-a-govindraju@ti.com>
References: <20210510052541.14168-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

Add support for implementing transceiver node as phy. The max_bitrate is
obtained by getting a phy attribute.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---
 drivers/net/can/m_can/m_can.c          | 11 +++++++++++
 drivers/net/can/m_can/m_can.h          |  2 ++
 drivers/net/can/m_can/m_can_platform.c | 13 +++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 3cf6de21d19c..afbecc35d3b6 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -21,6 +21,7 @@
 #include <linux/iopoll.h>
 #include <linux/can/dev.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/phy/phy.h>
 
 #include "m_can.h"
 
@@ -1514,6 +1515,7 @@ static void m_can_stop(struct net_device *dev)
 static int m_can_close(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
+	int err;
 
 	netif_stop_queue(dev);
 
@@ -1536,6 +1538,10 @@ static int m_can_close(struct net_device *dev)
 	close_candev(dev);
 	can_led_event(dev, CAN_LED_EVENT_STOP);
 
+	err = phy_power_off(cdev->transceiver);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -1721,6 +1727,10 @@ static int m_can_open(struct net_device *dev)
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int err;
 
+	err = phy_power_on(cdev->transceiver);
+	if (err)
+		return err;
+
 	err = m_can_clk_start(cdev);
 	if (err)
 		return err;
@@ -1781,6 +1791,7 @@ static int m_can_open(struct net_device *dev)
 	close_candev(dev);
 exit_disable_clks:
 	m_can_clk_stop(cdev);
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
index 599de0e08cd7..f102d532b7f0 100644
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
+		return ret;
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
2.17.1

