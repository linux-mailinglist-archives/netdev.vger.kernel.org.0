Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB3E20D25F
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbgF2Sss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:48:48 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:5895 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgF2Ssl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:48:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593456521; x=1624992521;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Run3GENLouqiI3KFuPSxjv38R2dIhbzS6TvTzsq3i0I=;
  b=DG6XkUqQBl41oUV7NXHXQm4PG5EwbPwzsWRCr8wJMsMWj6G4fIbDosuu
   7QbxwO79r2D9f7pdD347D8hOPp5fao2sYASCA2lWZPXNh/6CuFgok5Exd
   jIsHO388szr3DuM70BwWfa3iQwqo+phxbat+Omq9AmbDWc/sA/YviyhAh
   peADQvPQN/Th4w/Vqn9IITJ5rVdrTh5q47aWPlDv94SLRchVYcQEM8H8m
   gOlsQffSv9oL6ESQxYFOEyMHQynsfPoEAuX5qwzWoaFmI0naUZ2A5FVvT
   lRJ/0ZhICF8mmEv1GNPz/2wTaUX2nwQTtARox2tfnjIB+nZq4uNAPez3d
   Q==;
IronPort-SDR: rgltqBgr/JxVsqjfvmEX0jX2J7XKiIcvSnR/OTPgtT/PBNeK8WuC/8w4xWXnF4E5mXtJ9UQUNi
 +zAsn3D4FoF3uN16WTyvGajStdCFiXMFQeoQGkL6byEiDyvbPjMENoRSk7cAmay+IGBcgZdGMW
 V8Eu+Lt4PvEQibEGUi1VvN2rHU9UvKBnjCpZY0vpelgbpEs2JfKf6/A0OMJvnSflhXqZou5r2H
 OhQS+aK8RSKg1bD3fgp9QKIuj07d4Iq2VuOwiLGYHUwdpCv0I2qtpaz4QKebfZvZHEFbaOTmH1
 aYM=
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="17378207"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 00:26:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 00:26:26 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 29 Jun 2020 00:26:39 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <robh+dt@kernel.org>,
        <frowand.list@gmail.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH] of: of_mdio: count number of regitered phys
Date:   Mon, 29 Jun 2020 10:26:36 +0300
Message-ID: <1593415596-9487-1-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of_mdiobus_register_phy()/of_mdiobus_register_device()
returns -ENODEV for all PHYs in device tree or for all scanned
PHYs there is a chance that of_mdiobus_register() to
return success code although no PHY devices were registered.
Add a counter that increments every time a PHY was registered
to avoid the above scenario.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---

Though I haven't encountered the scenario described in commit
message. Just went through this code and seemed to me that it
could be enhanved by checking the number of successfuly
registered devices.

Thank you,
Claudiu Beznea

 drivers/of/of_mdio.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index eb84507de28a..bbf1d42d27f8 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -249,7 +249,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 {
 	struct device_node *child;
 	bool scanphys = false;
-	int addr, rc;
+	int addr, rc, devices = 0;
 
 	if (!np)
 		return mdiobus_register(mdio);
@@ -293,9 +293,11 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 				addr);
 		else if (rc)
 			goto unregister;
+		else
+			devices++;
 	}
 
-	if (!scanphys)
+	if (!scanphys && devices)
 		return 0;
 
 	/* auto scan for PHYs with empty reg property */
@@ -319,14 +321,21 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 				 * scanning should continue.
 				 */
 				rc = of_mdiobus_register_phy(mdio, child, addr);
-				if (!rc)
+				if (!rc) {
+					devices++;
 					break;
+				}
 				if (rc != -ENODEV)
 					goto unregister;
 			}
 		}
 	}
 
+	if (!devices) {
+		rc = -ENODEV;
+		goto unregister;
+	}
+
 	return 0;
 
 unregister:
-- 
2.7.4

