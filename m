Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B714F7859
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242425AbiDGH6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242618AbiDGH6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:58:18 -0400
Received: from twspam01.aspeedtech.com (twspam01.aspeedtech.com [211.20.114.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563FF12748
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:56:19 -0700 (PDT)
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 2377ieII045434;
        Thu, 7 Apr 2022 15:44:40 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from DylanHung-PC.aspeed.com (192.168.2.216) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Apr
 2022 15:56:00 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <robh+dt@kernel.org>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <p.zabel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <BMC-SW@aspeedtech.com>
Subject: [PATCH RESEND v3 2/3] net: mdio: add reset control for Aspeed MDIO
Date:   Thu, 7 Apr 2022 15:57:33 +0800
Message-ID: <20220407075734.19644-3-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407075734.19644-1-dylan_hung@aspeedtech.com>
References: <20220407075734.19644-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.2.216]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 2377ieII045434
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reset assertion/deassertion for Aspeed MDIO.  There are 4 MDIO
controllers embedded in Aspeed AST2600 SOC and share one reset control
register SCU50[3].  To work with old DT blobs which don't have the reset
property, devm_reset_control_get_optional_shared is used in this change.

Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/net/mdio/mdio-aspeed.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index e2273588c75b..1afb58ccc524 100644
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
 
+	ctx->reset = devm_reset_control_get_optional_shared(&pdev->dev, NULL);
+	if (IS_ERR(ctx->reset))
+		return PTR_ERR(ctx->reset);
+
+	reset_control_deassert(ctx->reset);
+
 	bus->name = DRV_NAME;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s%d", pdev->name, pdev->id);
 	bus->parent = &pdev->dev;
@@ -129,6 +137,7 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
 	rc = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (rc) {
 		dev_err(&pdev->dev, "Cannot register MDIO bus!\n");
+		reset_control_assert(ctx->reset);
 		return rc;
 	}
 
@@ -139,7 +148,11 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
 
 static int aspeed_mdio_remove(struct platform_device *pdev)
 {
-	mdiobus_unregister(platform_get_drvdata(pdev));
+	struct mii_bus *bus = (struct mii_bus *)platform_get_drvdata(pdev);
+	struct aspeed_mdio *ctx = bus->priv;
+
+	reset_control_assert(ctx->reset);
+	mdiobus_unregister(bus);
 
 	return 0;
 }
-- 
2.25.1

