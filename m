Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A964E20EA
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 08:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244492AbiCUHEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 03:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344719AbiCUHEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 03:04:37 -0400
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8C41F620
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 00:03:04 -0700 (PDT)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 22L6ofA0062512;
        Mon, 21 Mar 2022 14:50:41 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from DylanHung-PC.aspeed.com (192.168.2.216) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Mar
 2022 15:01:06 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <robh+dt@kernel.org>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <p.zabel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <BMC-SW@aspeedtech.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] net: mdio: add reset deassertion for Aspeed MDIO
Date:   Mon, 21 Mar 2022 15:01:30 +0800
Message-ID: <20220321070131.23363-2-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220321070131.23363-1-dylan_hung@aspeedtech.com>
References: <20220321070131.23363-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.2.216]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 22L6ofA0062512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reset deassertion for Aspeed MDIO.  There are 4 MDIO controllers
embedded in Aspeed AST2600 SOC and share one reset control register
SCU50[3]. So devm_reset_control_get_shared is used in this change.

Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Cc: stable@vger.kernel.org
---
 drivers/net/mdio/mdio-aspeed.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index e2273588c75b..8ac262a12d13 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -3,6 +3,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/delay.h>
+#include <linux/reset.h>
 #include <linux/iopoll.h>
 #include <linux/mdio.h>
 #include <linux/module.h>
@@ -37,6 +38,7 @@
 
 struct aspeed_mdio {
 	void __iomem *base;
+	struct reset_control *reset;
 };
 
 static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
@@ -120,6 +122,12 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
 	if (IS_ERR(ctx->base))
 		return PTR_ERR(ctx->base);
 
+	ctx->reset = devm_reset_control_get_shared(&pdev->dev, NULL);
+	if (IS_ERR(ctx->reset))
+		return PTR_ERR(ctx->reset);
+
+	reset_control_deassert(ctx->reset);
+
 	bus->name = DRV_NAME;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s%d", pdev->name, pdev->id);
 	bus->parent = &pdev->dev;
-- 
2.25.1

