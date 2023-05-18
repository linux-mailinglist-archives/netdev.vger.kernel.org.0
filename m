Return-Path: <netdev+bounces-3754-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A7E70886E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 21:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76DAE281AC3
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22629134B7;
	Thu, 18 May 2023 19:37:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA67134B3
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 19:37:03 +0000 (UTC)
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0293E67;
	Thu, 18 May 2023 12:36:57 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34IJaExK076173;
	Thu, 18 May 2023 14:36:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1684438574;
	bh=UGgsNdGUsEn3N+H5P2e/AnUaG77p3abjt1Oj19bLweM=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=nrhNCLUpoeLbFfV7tSq1tBP3wRtrHNAe48N0bHtvAj0s3CjM1Bz/KueuaFxQdxef4
	 2zvEi6yCHJbMwIGzs8wfJ9MK8vAbAz8ovSbCFPB3xXw9IgWNyc6tc3v6mskU2UjhAV
	 cXQTL63D13k67x1QnGQtbnSROSMSGnfWnwOXV3Bw=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34IJaESL021175
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 18 May 2023 14:36:14 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 18
 May 2023 14:36:13 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 18 May 2023 14:36:13 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34IJaDvV053146;
	Thu, 18 May 2023 14:36:13 -0500
From: Judith Mendez <jm@ti.com>
To: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        <linux-can@vger.kernel.org>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde
	<mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Schuyler Patton <spatton@ti.com>,
        Tero Kristo
	<kristo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Conor
 Dooley <conor+dt@kernel.org>
Subject: [PATCH v6 2/2] can: m_can: Add hrtimer to generate software interrupt
Date: Thu, 18 May 2023 14:36:13 -0500
Message-ID: <20230518193613.15185-3-jm@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230518193613.15185-1-jm@ti.com>
References: <20230518193613.15185-1-jm@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add an hrtimer to MCAN class device. Each MCAN will have its own
hrtimer instantiated if there is no hardware interrupt found and
poll-interval property is defined in device tree M_CAN node.

The hrtimer will generate a software interrupt every 1 ms. In
hrtimer callback, we check if there is a transaction pending by
reading a register, then process by calling the isr if there is.

Signed-off-by: Judith Mendez <jm@ti.com>
---
Changelog:
v6:
- Move hrtimer stop/start function calls to m_can_open and m_can_close to
support power suspend/resume
v5:
- Change dev_dbg to dev_info if hardware interrupt exists and polling
is enabled
v4:
- No changes
v3:
- Create a define for 1 ms polling interval
- Change plarform_get_irq to optional to not print error msg
v2:
- Add functionality to check for 'poll-interval' property in MCAN node 
- Add 'polling' flag in driver to check if device is using polling method
- Check for timer polling and hardware interrupt cases, default to
hardware interrupt method
- Change ns_to_ktime() to ms_to_ktime()
---
 drivers/net/can/m_can/m_can.c          | 31 ++++++++++++++++++++++-
 drivers/net/can/m_can/m_can.h          |  4 +++
 drivers/net/can/m_can/m_can_platform.c | 35 +++++++++++++++++++++++---
 3 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index a5003435802b..cfb3e433c0dd 100644
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
@@ -1414,6 +1418,12 @@ static int m_can_start(struct net_device *dev)
 
 	m_can_enable_all_interrupts(cdev);
 
+	if (cdev->polling) {
+		dev_dbg(cdev->dev, "Start hrtimer\n");
+		hrtimer_start(&cdev->hrtimer, ms_to_ktime(HRTIMER_POLL_INTERVAL),
+			      HRTIMER_MODE_REL_PINNED);
+	}
+
 	return 0;
 }
 
@@ -1571,6 +1581,11 @@ static void m_can_stop(struct net_device *dev)
 	/* disable all interrupts */
 	m_can_disable_all_interrupts(cdev);
 
+	if (cdev->polling) {
+		dev_dbg(cdev->dev, "Disabling the hrtimer\n");
+		hrtimer_cancel(&cdev->hrtimer);
+	}
+
 	/* Set init mode to disengage from the network */
 	m_can_config_endisable(cdev, true);
 
@@ -1793,6 +1808,18 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
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
@@ -1831,9 +1858,11 @@ static int m_can_open(struct net_device *dev)
 		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
 					   IRQF_ONESHOT,
 					   dev->name, dev);
-	} else {
+	} else if (!cdev->polling) {
 		err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
 				  dev);
+	} else {
+		cdev->hrtimer.function = &hrtimer_callback;
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
index 94dc82644113..3e60cebd9d12 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -5,6 +5,7 @@
 //
 // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
 
+#include <linux/hrtimer.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 
@@ -96,12 +97,40 @@ static int m_can_plat_probe(struct platform_device *pdev)
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
+	if (device_property_present(mcan_class->dev, "interrupts") ||
+	    device_property_present(mcan_class->dev, "interrupt-names"))
+		mcan_class->polling = false;
+	else
+		mcan_class->polling = true;
+
+	if (!mcan_class->polling && irq < 0) {
+		ret = -ENXIO;
+		dev_err_probe(mcan_class->dev, ret, "IRQ int0 not found, polling not activated\n");
+		goto probe_fail;
+	}
+
+	if (mcan_class->polling) {
+		if (irq > 0) {
+			mcan_class->polling = false;
+			dev_info(mcan_class->dev, "Polling enabled, using hardware IRQ\n");
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


