Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31FD6F3AA5
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 00:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjEAWqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 18:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjEAWqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 18:46:53 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A623726BC;
        Mon,  1 May 2023 15:46:50 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 341MkPxG017724;
        Mon, 1 May 2023 17:46:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682981185;
        bh=78aZBVaBmXp56A5c13T+/iX7Mc3xXRvxdaXT+leWWmE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=x+d3JVb6rq1WShwhM3Mkk1dL0m4NT9ku9+HplSKUPSoHiN3FmQnXjZYB2RTnRCneh
         W4xDk4tyMOxUnJnW8LC40HyZ/TOn+ozCSHCS0jVr8cD46xq8egWGUUXdfdL55THfKM
         Y/wj/w/khIOn7AHvuw9Xqw/Rw0NttWkYw+6GeWe4=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 341MkPvX066902
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 May 2023 17:46:25 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 1
 May 2023 17:46:24 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 1 May 2023 17:46:24 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 341MkOhf002097;
        Mon, 1 May 2023 17:46:24 -0500
From:   Judith Mendez <jm@ti.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4 2/4] can: m_can: Add hrtimer to generate software interrupt
Date:   Mon, 1 May 2023 17:46:22 -0500
Message-ID: <20230501224624.13866-3-jm@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230501224624.13866-1-jm@ti.com>
References: <20230501224624.13866-1-jm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an hrtimer to MCAN class device. Each MCAN will have its own
hrtimer instantiated if there is no hardware interrupt found and
poll-interval property is defined in device tree M_CAN node.

The hrtimer will generate a software interrupt every 1 ms. In
hrtimer callback, we check if there is a transaction pending by
reading a register, then process by calling the isr if there is.

Signed-off-by: Judith Mendez <jm@ti.com>
---
Changelog:
v1:
 1. Sort list of includes
 2. Create a define for HR_TIMER_POLL_INTERVAL
 3. Fix indentations and style issues/warnings
 4. Change polling variable to type bool
 5. Change platform_get_irq to optional so not to print error msg
 6. Move error check for addr directly after assignment
 7. Print appropriate error msg with dev_err_probe insead of dev_dbg

v2:
 1. Add poll-interval to MCAN class device to check if poll-interval propery is
    present in MCAN node, this enables timer polling method
 2. Add 'polling' flag to MCAN class device to check if a device is using timer
    polling method
 3. Check if both timer polling and hardware interrupt are enabled for a MCAN
    device, default to hardware interrupt mode if both are enabled
 4. Change ms_to_ktime() to ns_to_ktime()
 5. Remove newlines, tabs, and restructure if/else section
 
 drivers/net/can/m_can/m_can.c          | 29 +++++++++++++++++++++--
 drivers/net/can/m_can/m_can.h          |  4 ++++
 drivers/net/can/m_can/m_can_platform.c | 32 +++++++++++++++++++++++---
 3 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index a5003435802b..e1ac0c1d85a3 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -11,6 +11,7 @@
 #include <linux/bitfield.h>
 #include <linux/can/dev.h>
 #include <linux/ethtool.h>
+#include <linux/hrtimer.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
@@ -308,6 +309,9 @@ enum m_can_reg {
 #define TX_EVENT_MM_MASK	GENMASK(31, 24)
 #define TX_EVENT_TXTS_MASK	GENMASK(15, 0)
 
+/* Hrtimer polling interval */
+#define HRTIMER_POLL_INTERVAL		1
+
 /* The ID and DLC registers are adjacent in M_CAN FIFO memory,
  * and we can save a (potentially slow) bus round trip by combining
  * reads and writes to them.
@@ -1587,6 +1591,11 @@ static int m_can_close(struct net_device *dev)
 	if (!cdev->is_peripheral)
 		napi_disable(&cdev->napi);
 
+	if (cdev->polling) {
+		dev_dbg(cdev->dev, "Disabling the hrtimer\n");
+		hrtimer_cancel(&cdev->hrtimer);
+	}
+
 	m_can_stop(dev);
 	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
@@ -1793,6 +1802,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
+{
+	struct m_can_classdev *cdev = container_of(timer, struct
+						   m_can_classdev, hrtimer);
+
+	m_can_isr(0, cdev->net);
+
+	hrtimer_forward_now(timer, ms_to_ktime(HRTIMER_POLL_INTERVAL));
+
+	return HRTIMER_RESTART;
+}
+
 static int m_can_open(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
@@ -1827,13 +1848,17 @@ static int m_can_open(struct net_device *dev)
 		}
 
 		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
-
 		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
 					   IRQF_ONESHOT,
 					   dev->name, dev);
-	} else {
+	} else if (!cdev->polling) {
 		err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
 				  dev);
+	} else {
+		dev_dbg(cdev->dev, "Start hrtimer\n");
+		cdev->hrtimer.function = &hrtimer_callback;
+		hrtimer_start(&cdev->hrtimer, ms_to_ktime(HRTIMER_POLL_INTERVAL),
+			      HRTIMER_MODE_REL_PINNED);
 	}
 
 	if (err < 0) {
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index a839dc71dc9b..e9db5cce4e68 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/freezer.h>
+#include <linux/hrtimer.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
@@ -93,6 +94,9 @@ struct m_can_classdev {
 	int is_peripheral;
 
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
+
+	struct hrtimer hrtimer;
+	bool polling;
 };
 
 struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 9c1dcf838006..0fcb436298f8 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -5,6 +5,7 @@
 //
 // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
 
+#include <linux/hrtimer.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 
@@ -96,12 +97,37 @@ static int m_can_plat_probe(struct platform_device *pdev)
 		goto probe_fail;
 
 	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
-	irq = platform_get_irq_byname(pdev, "int0");
-	if (IS_ERR(addr) || irq < 0) {
-		ret = -EINVAL;
+	if (IS_ERR(addr)) {
+		ret = PTR_ERR(addr);
 		goto probe_fail;
 	}
 
+	irq = platform_get_irq_byname_optional(pdev, "int0");
+	if (irq == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto probe_fail;
+	}
+
+	if (device_property_present(mcan_class->dev, "poll-interval"))
+		mcan_class->polling = 1;
+
+	if (!mcan_class->polling && irq < 0) {
+		ret = -ENXIO;
+		dev_err_probe(mcan_class->dev, ret, "IRQ int0 not found and polling not activated\n");
+		goto probe_fail;
+	}
+
+	if (mcan_class->polling) {
+		if (irq > 0) {
+			mcan_class->polling = 0;
+			dev_dbg(mcan_class->dev, "Polling enabled and hardware IRQ found, use hardware IRQ\n");
+		} else {
+			dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
+			hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC,
+				     HRTIMER_MODE_REL_PINNED);
+		}
+	}
+
 	/* message ram could be shared */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
 	if (!res) {
-- 
2.17.1

