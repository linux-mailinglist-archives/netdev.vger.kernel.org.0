Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F356144CBB
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 09:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgAVICL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 03:02:11 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:44008 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgAVICK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 03:02:10 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00M81sgo059119;
        Wed, 22 Jan 2020 02:01:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1579680114;
        bh=7UOBwHxmUYxfqiqO99WZtNYVwWL8yFEFOypvW6QAPs4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=BjJ7Ofv09fQIGGvSb3Z2YQmpzCzQSSXuAXMGB6Cft+lyKzTwTP3bD5V+Rn/6k3LXJ
         8b1nUjbeWD8h2Of6LzRrI0rIf23K/32ImENz52Bu8vkFP/CNhTQiJfSWA1em9v4Ir1
         pzn1Jq+yh+bigpWCs0xjPo1ZWB88z/YsEDb9MOEk=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00M81s8C079187
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jan 2020 02:01:54 -0600
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 22
 Jan 2020 02:01:53 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 22 Jan 2020 02:01:53 -0600
Received: from a0230074-OptiPlex-7010.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00M81cto007984;
        Wed, 22 Jan 2020 02:01:49 -0600
From:   Faiz Abbas <faiz_abbas@ti.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC:     <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <robh+dt@kernel.org>, <davem@davemloft.net>, <mkl@pengutronix.de>,
        <wg@grandegger.com>, <sriram.dash@samsung.com>, <dmurphy@ti.com>,
        <faiz_abbas@ti.com>, <nm@ti.com>, <t-kristo@ti.com>
Subject: [PATCH 2/3] can: m_can: m_can_platform: Add support for enabling transceiver through the STB line
Date:   Wed, 22 Jan 2020 13:33:09 +0530
Message-ID: <20200122080310.24653-3-faiz_abbas@ti.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200122080310.24653-1-faiz_abbas@ti.com>
References: <20200122080310.24653-1-faiz_abbas@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CAN transceivers on some boards have an STB (standby) line which can be
toggled to enable/disable the transceiver. Add support for enabling the
transceiver using a GPIO connected to the STB line.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
---
 drivers/net/can/m_can/m_can_platform.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 38ea5e600fb8..b4e1423bd5d8 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -6,6 +6,7 @@
 // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
 
 #include <linux/platform_device.h>
+#include <linux/gpio/consumer.h>
 
 #include "m_can.h"
 
@@ -57,6 +58,7 @@ static int m_can_plat_probe(struct platform_device *pdev)
 {
 	struct m_can_classdev *mcan_class;
 	struct m_can_plat_priv *priv;
+	struct gpio_desc *stb;
 	struct resource *res;
 	void __iomem *addr;
 	void __iomem *mram_addr;
@@ -111,6 +113,16 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	m_can_init_ram(mcan_class);
 
+	stb = devm_gpiod_get_optional(&pdev->dev, "stb", GPIOD_OUT_HIGH);
+	if (IS_ERR(stb)) {
+		ret = PTR_ERR(stb);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"gpio request failed, ret %d\n", ret);
+
+		goto failed_ret;
+	}
+
 	ret = m_can_class_register(mcan_class);
 
 failed_ret:
-- 
2.19.2

