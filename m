Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B936161499
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgBQO13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:27:29 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:42986 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728848AbgBQO1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:27:22 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01HER5ni084812;
        Mon, 17 Feb 2020 08:27:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581949625;
        bh=MOTssjoB0GIV30lVcJaxAIVOL5DWVb4N01J+ze4pt64=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=mUDo/OGXVlzNFKGwEW1rIXWQYkfjSOHuH6Y8MLHM+cBsMqpHIOK6N55zKAoed6SmJ
         jXyevT2SOpBJR8jlfS62LsumwBhpZ/IvXVU0YEDdP8cJTztFPTn9EQCq3oZR2AvVJy
         RnwmPPjW6rFF/q+IblegAJ/i7bgvA37Q/0oEnjkQ=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01HER4Un117386
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Feb 2020 08:27:05 -0600
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 17
 Feb 2020 08:27:03 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 17 Feb 2020 08:27:04 -0600
Received: from a0230074-OptiPlex-7010.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01HEQoJN033875;
        Mon, 17 Feb 2020 08:26:59 -0600
From:   Faiz Abbas <faiz_abbas@ti.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC:     <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <robh+dt@kernel.org>, <mkl@pengutronix.de>, <wg@grandegger.com>,
        <sriram.dash@samsung.com>, <dmurphy@ti.com>, <faiz_abbas@ti.com>
Subject: [PATCH v2 2/3] can: m_can: m_can_platform: Add support for enabling transceiver
Date:   Mon, 17 Feb 2020 19:58:35 +0530
Message-ID: <20200217142836.23702-3-faiz_abbas@ti.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200217142836.23702-1-faiz_abbas@ti.com>
References: <20200217142836.23702-1-faiz_abbas@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CAN transceivers on some boards have a standby line which can be
toggled to enable/disable the transceiver. Model this as an optional
fixed xceiver regulator.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Acked-by: Sriram Dash <sriram.dash@samsung.com>
---
 drivers/net/can/m_can/m_can_platform.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 38ea5e600fb8..719468fab507 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -6,6 +6,7 @@
 // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
 
 #include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
 
 #include "m_can.h"
 
@@ -57,6 +58,7 @@ static int m_can_plat_probe(struct platform_device *pdev)
 {
 	struct m_can_classdev *mcan_class;
 	struct m_can_plat_priv *priv;
+	struct regulator *reg_xceiver;
 	struct resource *res;
 	void __iomem *addr;
 	void __iomem *mram_addr;
@@ -111,6 +113,10 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	m_can_init_ram(mcan_class);
 
+	reg_xceiver = devm_regulator_get_optional(&pdev->dev, "xceiver");
+	if (PTR_ERR(reg_xceiver) == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+
 	ret = m_can_class_register(mcan_class);
 
 failed_ret:
-- 
2.19.2

