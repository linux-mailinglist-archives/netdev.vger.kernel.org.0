Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D868E6ED5AB
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbjDXTyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbjDXTyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:54:33 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B965FE6;
        Mon, 24 Apr 2023 12:54:30 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33OJs34u068408;
        Mon, 24 Apr 2023 14:54:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682366043;
        bh=zIXeC4hIhHfA+7+hynKun3pURp7FrMeSpwNXYa56f+0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=szUh/77ZpzW0X+OCyMLfV81cFb57YbneVTBCE3eUpERVWEW+jV/ghHfnLnkCcW09q
         tJJ4eZP3eo60v5Do08SVscI+MCXctELZ0uGOpshwWI4J7mZqewxZrOe2n84oCkppkF
         SUX5evXJh3LeYOjzvj4bdO4kZQu+gSHZ+iBWJFlc=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33OJs3nu057911
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Apr 2023 14:54:03 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 24
 Apr 2023 14:54:02 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 24 Apr 2023 14:54:02 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33OJs23G009344;
        Mon, 24 Apr 2023 14:54:02 -0500
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
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v2 1/4] can: m_can: Add hrtimer to generate software interrupt
Date:   Mon, 24 Apr 2023 14:53:59 -0500
Message-ID: <20230424195402.516-2-jm@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230424195402.516-1-jm@ti.com>
References: <20230424195402.516-1-jm@ti.com>
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
v2:
	1. Add poll-interval to MCAN class device to check if poll-interval propery is
	present in MCAN node, this enables timer polling method.
	2. Add 'polling' flag to MCAN class device to check if a device is using timer
	polling method
	3. Check if both timer polling and hardware interrupt are enabled for a MCAN
	device, default to hardware interrupt mode if both are enabled.
	4. Changed ms_to_ktime() to ns_to_ktime()
	5. Removed newlines, tabs, and restructure if/else section.

 drivers/net/can/m_can/m_can.c          | 30 ++++++++++++++++++++-----
 drivers/net/can/m_can/m_can.h          |  5 +++++
 drivers/net/can/m_can/m_can_platform.c | 31 ++++++++++++++++++++++++--
 3 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index a5003435802b..33e094f88da1 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -23,6 +23,7 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/hrtimer.h>
 
 #include "m_can.h"
 
@@ -1587,6 +1588,11 @@ static int m_can_close(struct net_device *dev)
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
@@ -1793,6 +1799,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
+{
+	struct m_can_classdev *cdev =
+		container_of(timer, struct m_can_classdev, hrtimer);
+
+	m_can_isr(0, cdev->net);
+
+	hrtimer_forward_now(timer, ms_to_ktime(1));
+
+	return HRTIMER_RESTART;
+}
+
 static int m_can_open(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
@@ -1827,13 +1845,15 @@ static int m_can_open(struct net_device *dev)
 		}
 
 		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
-
 		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
-					   IRQF_ONESHOT,
-					   dev->name, dev);
-	} else {
-		err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
+					   IRQF_ONESHOT, dev->name, dev);
+	} else if (!cdev->polling) {
+			err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
 				  dev);
+	} else {
+		dev_dbg(cdev->dev, "Start hrtimer\n");
+		cdev->hrtimer.function = &hrtimer_callback;
+		hrtimer_start(&cdev->hrtimer, ms_to_ktime(cdev->poll_interval), HRTIMER_MODE_REL_PINNED);
 	}
 
 	if (err < 0) {
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index a839dc71dc9b..1ba87eb23f8e 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -28,6 +28,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/hrtimer.h>
 
 /* m_can lec values */
 enum m_can_lec_type {
@@ -93,6 +94,10 @@ struct m_can_classdev {
 	int is_peripheral;
 
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
+
+	struct hrtimer hrtimer;
+	u32 poll_interval;
+	u8 polling;
 };
 
 struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 9c1dcf838006..e899c04edc01 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -7,6 +7,7 @@
 
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/hrtimer.h>
 
 #include "m_can.h"
 
@@ -97,11 +98,37 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
 	irq = platform_get_irq_byname(pdev, "int0");
-	if (IS_ERR(addr) || irq < 0) {
-		ret = -EINVAL;
+	if (irq == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
 		goto probe_fail;
 	}
 
+	if (IS_ERR(addr)) {
+		ret = PTR_ERR(addr);
+		goto probe_fail;
+	}
+
+	mcan_class->polling = 0;
+	if (device_property_present(mcan_class->dev, "poll-interval")) {
+		mcan_class->polling = 1;
+	}
+
+	if (!mcan_class->polling && irq < 0) {
+		ret = -ENODATA;
+		dev_dbg(mcan_class->dev, "Polling not enabled\n");
+		goto probe_fail;
+	}
+
+	if (mcan_class->polling && irq > 0) {
+		mcan_class->polling = 0;
+		dev_dbg(mcan_class->dev, "Polling not enabled, hardware interrupt exists\n");
+	}
+
+	if (mcan_class->polling && irq < 0) {
+		dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
+		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
+	}
+
 	/* message ram could be shared */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
 	if (!res) {
-- 
2.17.1

