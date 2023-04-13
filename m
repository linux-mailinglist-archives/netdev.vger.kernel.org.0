Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A706E1765
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjDMWbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDMWbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:31:13 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BE583DB;
        Thu, 13 Apr 2023 15:31:12 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33DMUq5Z016668;
        Thu, 13 Apr 2023 17:30:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681425052;
        bh=QKx0x//24n9yfpt3AvoZRngZsGzu0JmQ1ZYdl2ypn6w=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=q9BV75dhC2oOvdtNSjt/xsmzsF3maJKCLNdhVa42kSMuKIkNEq7neRf/KRlk4WUkL
         rw0rYudVUzes8IBH8f8apYgd5Jkbh4KZDZwccZ0Tm43JvrN5T8UJn+m7weJeSdYHEV
         d/ZJL4GqRYH5cJb2yn3LiJeIV8Gxcgv+pDIvNvAs=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33DMUq5h019453
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Apr 2023 17:30:52 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 13
 Apr 2023 17:30:52 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 13 Apr 2023 17:30:52 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33DMUpa8063427;
        Thu, 13 Apr 2023 17:30:52 -0500
From:   Judith Mendez <jm@ti.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>
CC:     Nishanth Menon <nm@ti.com>, Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>
Subject: [RFC PATCH 5/5] can: m_can: Add hrtimer to generate software interrupt
Date:   Thu, 13 Apr 2023 17:30:51 -0500
Message-ID: <20230413223051.24455-6-jm@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230413223051.24455-1-jm@ti.com>
References: <20230413223051.24455-1-jm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a hrtimer to MCAN struct. Each MCAN will have its own
hrtimer instantiated if there is no hardware interrupt found.

The hrtimer will generate a software interrupt every 1 ms. In
hrtimer callback, we check if there is a transaction pending by
reading a register, then process by calling the isr if there is.

Signed-off-by: Judith Mendez <jm@ti.com>
---
 drivers/net/can/m_can/m_can.c          | 24 ++++++++++++++++++++++--
 drivers/net/can/m_can/m_can.h          |  3 +++
 drivers/net/can/m_can/m_can_platform.c |  9 +++++++--
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 8e83d6963d85..bb9d53f4d3cc 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -23,6 +23,7 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/hrtimer.h>
 
 #include "m_can.h"
 
@@ -1584,6 +1585,11 @@ static int m_can_close(struct net_device *dev)
 	if (!cdev->is_peripheral)
 		napi_disable(&cdev->napi);
 
+	if (dev->irq < 0) {
+		dev_info(cdev->dev, "Disabling the hrtimer\n");
+		hrtimer_cancel(&cdev->hrtimer);
+	}
+
 	m_can_stop(dev);
 	m_can_clk_stop(cdev);
 	free_irq(dev->irq, dev);
@@ -1792,6 +1798,19 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
+{
+	irqreturn_t ret;
+	struct m_can_classdev *cdev =
+		container_of(timer, struct m_can_classdev, hrtimer);
+
+	ret = m_can_isr(0, cdev->net);
+
+	hrtimer_forward_now(timer, ns_to_ktime(5 * NSEC_PER_MSEC));
+
+	return HRTIMER_RESTART;
+}
+
 static int m_can_open(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
@@ -1836,8 +1855,9 @@ static int m_can_open(struct net_device *dev)
 	}
 
 	if (err < 0) {
-		netdev_err(dev, "failed to request interrupt\n");
-		goto exit_irq_fail;
+		dev_info(cdev->dev, "Enabling the hrtimer\n");
+		cdev->hrtimer.function = &hrtimer_callback;
+		hrtimer_start(&cdev->hrtimer, ns_to_ktime(0), HRTIMER_MODE_REL_PINNED);
 	}
 
 	/* start the m_can controller */
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
index 9c1dcf838006..53e1648e9dab 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -7,6 +7,7 @@
 
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/hrtimer.h>
 
 #include "m_can.h"
 
@@ -98,8 +99,12 @@ static int m_can_plat_probe(struct platform_device *pdev)
 	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
 	irq = platform_get_irq_byname(pdev, "int0");
 	if (IS_ERR(addr) || irq < 0) {
-		ret = -EINVAL;
-		goto probe_fail;
+		if (irq == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto probe_fail;
+		}
+		dev_info(mcan_class->dev, "Failed to get irq, initialize hrtimer\n");
+		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
 	}
 
 	/* message ram could be shared */
-- 
2.17.1

