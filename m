Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F172F6E8558
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 00:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjDSW4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 18:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjDSW4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 18:56:14 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8931113;
        Wed, 19 Apr 2023 15:56:12 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33JMXOWl117876;
        Wed, 19 Apr 2023 17:33:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681943604;
        bh=+0GoZhNulQJ5to302kKOEYuwOpVd4qY+OKEXXTzt2gs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=AEnDSCjU1YevQKm6vSblyj0zz13b0JtUg70o9nr7Rd3QjO+enGPd4pw7Lx6Axl2hD
         WtGTyC+XSJ0IdtLW6iBjB7fi/9TUFoNyjxbsbCTzuybqC41RkAyioWtTgqTYpe9Sym
         spPnJJbHGgsNdn7/ZK3tRRQzdUV3EyPuJ/ztIM58=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33JMXONe102532
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Apr 2023 17:33:24 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 19
 Apr 2023 17:33:23 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 19 Apr 2023 17:33:23 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33JMXNLW015736;
        Wed, 19 Apr 2023 17:33:23 -0500
From:   Judith Mendez <jm@ti.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Judith Mendez <jm@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 1/4] can: m_can: Add hrtimer to generate software interrupt
Date:   Wed, 19 Apr 2023 17:33:20 -0500
Message-ID: <20230419223323.20384-2-jm@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419223323.20384-1-jm@ti.com>
References: <20230419223323.20384-1-jm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an hrtimer to MCAN struct. Each MCAN will have its own
hrtimer instantiated if there is no hardware interrupt found.

The hrtimer will generate a software interrupt every 1 ms. In
hrtimer callback, we check if there is a transaction pending by
reading a register, then process by calling the isr if there is.

Signed-off-by: Judith Mendez <jm@ti.com>
---
 drivers/net/can/m_can/m_can.c          | 30 ++++++++++++++++++++++++--
 drivers/net/can/m_can/m_can.h          |  3 +++
 drivers/net/can/m_can/m_can_platform.c | 13 +++++++++--
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index a5003435802b..8784bdea300a 100644
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
 
+	if (dev->irq < 0) {
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
@@ -1827,13 +1845,21 @@ static int m_can_open(struct net_device *dev)
 		}
 
 		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
-
 		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
 					   IRQF_ONESHOT,
 					   dev->name, dev);
+
 	} else {
-		err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
+		if (dev->irq > 0)	{
+			err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
 				  dev);
+		}
+
+		else	{
+			dev_dbg(cdev->dev, "Enabling the hrtimer\n");
+			cdev->hrtimer.function = &hrtimer_callback;
+			hrtimer_start(&cdev->hrtimer, ns_to_ktime(0), HRTIMER_MODE_REL_PINNED);
+		}
 	}
 
 	if (err < 0) {
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index a839dc71dc9b..ed046d77fdb9 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -28,6 +28,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/hrtimer.h>
 
 /* m_can lec values */
 enum m_can_lec_type {
@@ -93,6 +94,8 @@ struct m_can_classdev {
 	int is_peripheral;
 
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
+
+	struct hrtimer hrtimer;
 };
 
 struct m_can_classdev *m_can_class_allocate_dev(struct device *dev, int sizeof_priv);
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 9c1dcf838006..7540db74b7d0 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -7,6 +7,7 @@
 
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/hrtimer.h>
 
 #include "m_can.h"
 
@@ -98,8 +99,16 @@ static int m_can_plat_probe(struct platform_device *pdev)
 	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
 	irq = platform_get_irq_byname(pdev, "int0");
 	if (IS_ERR(addr) || irq < 0) {
-		ret = -EINVAL;
-		goto probe_fail;
+		if (irq == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto probe_fail;
+		}
+		if (IS_ERR(addr)) {
+			ret = PTR_ERR(addr);
+			goto probe_fail;
+		}
+		dev_dbg(mcan_class->dev, "Failed to get irq, initialize hrtimer\n");
+		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
 	}
 
 	/* message ram could be shared */
-- 
2.17.1

