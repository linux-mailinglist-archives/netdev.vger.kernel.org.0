Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133D52B7F57
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 15:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgKROYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 09:24:42 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:33238 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgKROYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 09:24:42 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AIEOY39102501;
        Wed, 18 Nov 2020 08:24:34 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605709474;
        bh=5E8YooyCihFwVv7oYAz75wqjXHOAj38SOo/gntocg68=;
        h=From:To:CC:Subject:Date;
        b=lMvKjfN49o3TtzvgwmGjNNUFmVQAugLuksAFhXuy1lR/+SZpEUmUXjObZnxFDXZOE
         hBOttzFsSpY9hmbWW4KKjHYZF2RN+usr/+yiSIqq335ZEQT6zO4GSdhGILOujZiASL
         uODe44hJvb+ky2zsXcyKd8YxbzTNohXxLZpdHAWc=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AIEOYuf013451
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 18 Nov 2020 08:24:34 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 18
 Nov 2020 08:24:34 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 18 Nov 2020 08:24:34 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AIEOXRv064321;
        Wed, 18 Nov 2020 08:24:33 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] mdio_bus: suppress err message for reset gpio EPROBE_DEFER
Date:   Wed, 18 Nov 2020 16:24:26 +0200
Message-ID: <20201118142426.25369-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mdio_bus may have dependencies from GPIO controller and so got
deferred. Now it will print error message every time -EPROBE_DEFER is
returned from:
__mdiobus_register()
 |-devm_gpiod_get_optional()
without actually identifying error code.

"mdio_bus 4a101000.mdio: mii_bus 4a101000.mdio couldn't get reset GPIO"

Hence, suppress error message when devm_gpiod_get_optional() returning
-EPROBE_DEFER case.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/phy/mdio_bus.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 757e950fb745..54fc13043656 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -546,10 +546,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	/* de-assert bus level PHY GPIO reset */
 	gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(gpiod)) {
-		dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO\n",
-			bus->id);
+		err = PTR_ERR(gpiod);
+		if (err != -EPROBE_DEFER)
+			dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO %d\n", bus->id, err);
 		device_del(&bus->dev);
-		return PTR_ERR(gpiod);
+		return err;
 	} else	if (gpiod) {
 		bus->reset_gpiod = gpiod;
 
-- 
2.17.1

