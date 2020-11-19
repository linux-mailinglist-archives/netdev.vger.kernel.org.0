Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAA32B9C22
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 21:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgKSUfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 15:35:01 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:55632 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgKSUfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 15:35:01 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AJKYsx4062615;
        Thu, 19 Nov 2020 14:34:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605818094;
        bh=61iPk1aGKqeRJig3dLVfDUO3FiK2c1IwV08di/OTMes=;
        h=From:To:CC:Subject:Date;
        b=V+/E2mxXOvVDy2tIo/RcYPh44ZmDcQNv6sopm/G5MU6Bhe9LTBGwyiZsrJcBlq557
         6Le5YEuMOMOQir50d+KUXKzoKyLnVxhILEa7BGOYcS/KAAz19rjeluZVYJJdjAP49x
         mI58dM2obzMDlSn8NwRC2QUWnNbkd+8dRLaA9cZs=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AJKYsX4108917
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 14:34:54 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 19
 Nov 2020 14:34:54 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 19 Nov 2020 14:34:54 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AJKYriq090339;
        Thu, 19 Nov 2020 14:34:53 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2] mdio_bus: suppress err message for reset gpio EPROBE_DEFER
Date:   Thu, 19 Nov 2020 22:34:46 +0200
Message-ID: <20201119203446.20857-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mdio_bus may have dependencies from GPIO controller and so got
deferred. Now it will print error message every time -EPROBE_DEFER is
returned which from:
__mdiobus_register()
 |-devm_gpiod_get_optional()
without actually identifying error code.

"mdio_bus 4a101000.mdio: mii_bus 4a101000.mdio couldn't get reset GPIO"

Hence, suppress error message for devm_gpiod_get_optional() returning
-EPROBE_DEFER case by using dev_err_probe().

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/phy/mdio_bus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 757e950fb745..83cd61c3dd01 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -546,10 +546,10 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	/* de-assert bus level PHY GPIO reset */
 	gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(gpiod)) {
-		dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO\n",
-			bus->id);
+		err = dev_err_probe(&bus->dev, PTR_ERR(gpiod),
+				    "mii_bus %s couldn't get reset GPIO\n", bus->id);
 		device_del(&bus->dev);
-		return PTR_ERR(gpiod);
+		return err;
 	} else	if (gpiod) {
 		bus->reset_gpiod = gpiod;
 
-- 
2.17.1

