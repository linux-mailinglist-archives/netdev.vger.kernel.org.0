Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0122431A058
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhBLOIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:08:52 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:49643 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhBLOIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 09:08:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613138918; x=1644674918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=vAYW4qo3Qvlqa2VUgb51oz0/GLMDjoE2lLe68XlNwcU=;
  b=ySPwcrPvr71BENK7ub0hpxwPaiK2jw20YpC7/QnSASqNbVfu7CIFekMD
   tpXSWz7l4R1haBAJGpAUTnKD63UbTd6VNJOaSD38eG9VM7Bn/9ApwZ9n7
   xBN1qZcG2SQO4wrIjv9Ljflv4OZ0k+o/Ftb5FvlnIUBqJVL7XFv1y4t7m
   Xw8Mw2Nw05plrED4UNPqkcJ+wdJbnjD6XojMPLTvvJ7EkRavZR4lpF12w
   Po/G7DZtK1pL//07+0j7+8osWx7/HOm8TIJ15admjuypXbzvCKER84NiN
   elM2ZF2R/YsZg+GocPqGEyefhqaTHKwbLNcj0IYpq17lKv8Eu/PMKb1Bj
   A==;
IronPort-SDR: B3Gu9ulERBeYJUjvVr0Rn5Ks2Ucv01PC/emlovtoBYDSKeWnt8HRG8e6nm4LPEsGfo2zVwRmg/
 Om8321sgZzunuk2DIa3NiAMdT51XFRqHp4/lVV1vbpKpsErHNPbVJi+akh2NCUUhTPO2fNOMSW
 Ao025kHP22B/DzMVt6pr8kK8kmpdf133aCQ0Hu7qVMV9U3GD2QLrR3cnbK4otFw5DS00kdZwe1
 KV2RU9t8mtGu5WdcebqYbH01cmDQFuR/0tQY6MNtKGHgNwpxUuYJFotN0NC8R3me5K/7s00jhH
 hBM=
X-IronPort-AV: E=Sophos;i="5.81,173,1610434800"; 
   d="scan'208";a="106384129"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Feb 2021 07:07:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 12 Feb 2021 07:07:39 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 12 Feb 2021 07:07:36 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH net v1 3/3] net: phy: mscc: coma mode disabled for VSC8514
Date:   Fri, 12 Feb 2021 15:06:43 +0100
Message-ID: <20210212140643.23436-3-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'coma mode' (configurable through sw or hw) provides an
optional feature that may be used to control when the PHYs become active.
The typical usage is to synchronize the link-up time across
all PHY instances. This patch releases coma mode if not done by hardware,
otherwise the phys will not link-up.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
---
 drivers/net/phy/mscc/mscc_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 7546d9cc3abd..0600b592618b 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1418,6 +1418,18 @@ static void vsc8584_get_base_addr(struct phy_device *phydev)
 	vsc8531->addr = addr;
 }
 
+static void vsc85xx_coma_mode_release(struct phy_device *phydev)
+{
+	/* The coma mode (pin or reg) provides an optional feature that
+	 * may be used to control when the PHYs become active.
+	 * Alternatively the COMA_MODE pin may be connected low
+	 * so that the PHYs are fully active once out of reset.
+	 */
+	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED_GPIO);
+	__phy_write(phydev, MSCC_PHY_GPIO_CONTROL_2, 0x0600);
+	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
+}
+
 static int vsc8584_config_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
@@ -2610,6 +2622,7 @@ static int vsc8514_config_init(struct phy_device *phydev)
 		ret = vsc8514_config_host_serdes(phydev);
 		if (ret)
 			goto err;
+		vsc85xx_coma_mode_release(phydev);
 	}
 
 	phy_unlock_mdio_bus(phydev);
-- 
2.17.1

