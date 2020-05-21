Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B308B1DD4CB
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgEURrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:47:55 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:57168 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729972AbgEURrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 13:47:53 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04LHljok017997;
        Thu, 21 May 2020 12:47:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590083265;
        bh=Flh0goqgDng7jM1nNd4yAiC2nJe1NMBBFdYh80Rm9b0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Y3U3iIHdZYPzFloiaxDopEXYQhzkHzqWn+u4IGF3yrAzw9+TYEahnAEt9C96Xch/3
         nshi3Jb9SW2MeCRO0xjF1tnKsInNe3P2R/TWajLtDr6qufN17QyVo0ZSH1B8sJ/Ksz
         JwpBWLerXtw9nvVG4BKJ7afgMNYlXg5snS+jIw4o=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04LHljre119194;
        Thu, 21 May 2020 12:47:45 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 21
 May 2020 12:47:45 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 21 May 2020 12:47:45 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04LHlj0F037554;
        Thu, 21 May 2020 12:47:45 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 1/2] net: phy: dp83869: Update port-mirroring to read straps
Date:   Thu, 21 May 2020 12:47:37 -0500
Message-ID: <20200521174738.3151-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521174738.3151-1-dmurphy@ti.com>
References: <20200521174738.3151-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device tree may not have the property set for port mirroring
because the hardware may have it strapped. If the property is not in the
DT then check the straps and set the port mirroring bit appropriately.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/net/phy/dp83869.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 7996a4aea8d2..073a0f7754a5 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -66,6 +66,7 @@
 
 /* STRAP_STS1 bits */
 #define DP83869_STRAP_STS1_RESERVED		BIT(11)
+#define DP83869_STRAP_MIRROR_ENABLED           BIT(12)
 
 /* PHYCTRL bits */
 #define DP83869_RX_FIFO_SHIFT	12
@@ -191,10 +192,18 @@ static int dp83869_of_init(struct phy_device *phydev)
 	else if (of_property_read_bool(of_node, "ti,min-output-impedance"))
 		dp83869->io_impedance = DP83869_IO_MUX_CFG_IO_IMPEDANCE_MIN;
 
-	if (of_property_read_bool(of_node, "enet-phy-lane-swap"))
+	if (of_property_read_bool(of_node, "enet-phy-lane-swap")) {
 		dp83869->port_mirroring = DP83869_PORT_MIRRORING_EN;
-	else
-		dp83869->port_mirroring = DP83869_PORT_MIRRORING_DIS;
+	} else {
+		/* If the lane swap is not in the DT then check the straps */
+		ret = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_STRAP_STS1);
+		if (ret < 0)
+			return ret;
+		if (ret & DP83869_STRAP_MIRROR_ENABLED)
+			dp83869->port_mirroring = DP83869_PORT_MIRRORING_EN;
+		else
+			dp83869->port_mirroring = DP83869_PORT_MIRRORING_DIS;
+	}
 
 	if (of_property_read_u32(of_node, "rx-fifo-depth",
 				 &dp83869->rx_fifo_depth))
-- 
2.26.2

