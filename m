Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB287361F00
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 13:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243048AbhDPLnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 07:43:40 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:54008 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242997AbhDPLnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 07:43:33 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13GBh0vW111994;
        Fri, 16 Apr 2021 06:43:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618573380;
        bh=Ryko66IKKHG8clhvZB4lEXluQaivBm5g11UZcC934ok=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=RppKYSZyFj0r36v8+fFHuNTdLKmZWTshoLm3g74+OeGm5ygmPQ+UUQL+xsnQOrYH0
         ARgtTBGDpQa3YiGV1Li/m51YBHyqogkoZ2kX3WYZ6dx06wmSVt+NpvliGZilIBUXlc
         CxnyebjDtunEEz2EovTpysv4KJf1CzzhG/NaEf+M=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13GBh01D094516
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Apr 2021 06:43:00 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 16
 Apr 2021 06:42:59 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 16 Apr 2021 06:42:59 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13GBgj3E039401;
        Fri, 16 Apr 2021 06:42:55 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>
Subject: [PATCH v3 2/2] can: m_can: Add support for transceiver as phy
Date:   Fri, 16 Apr 2021 17:12:45 +0530
Message-ID: <20210416114245.24829-3-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416114245.24829-1-a-govindraju@ti.com>
References: <20210416114245.24829-1-a-govindraju@ti.com>
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
 drivers/net/can/m_can/m_can.c          | 10 ++++++++++
 drivers/net/can/m_can/m_can.h          |  2 ++
 drivers/net/can/m_can/m_can_platform.c | 13 +++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 34073cd077e4..7d31250446c2 100644
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
 
@@ -1720,6 +1726,10 @@ static int m_can_open(struct net_device *dev)
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int err;
 
+	err = phy_power_on(cdev->transceiver);
+	if (err)
+		return err;
+
 	err = m_can_clk_start(cdev);
 	if (err)
 		return err;
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

