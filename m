Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C6A31CCFF
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 16:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhBPPbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 10:31:53 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:53478 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhBPPbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 10:31:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613489483; x=1645025483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=c6q6U2J/o4K8P/SEJ8skN9T6JNIZ8gsyd/TVCQ1EGCk=;
  b=wu/THPijAJgxfipZzgjL73/8+xtZSDdjeOBj10+ihgPdS6834ObMO41q
   L0/i2G3AJLwsXBY/MH7IOa9ZJTbKFyTgnUUty6BG1BWi4MeQIgyizvQc+
   DS/pxB7UNT2lWRyUVbQb+oRgtNcmNKsR1bCv2/ERLdegbAYA/N6eifsJe
   G4t6sGisGF+VmkPzYLTYuSoXfXRvilDx5oG8br/64hVQDvP25wgvOYfeK
   iJ1uPDMe6d7oCLuKESv+KO7EqbzY9XixqpF2lRu6dFFNCf3YymT5I23aV
   +m2LpeEHG2+aF+3FWdlhaLjYmS7Gevvl9P2q7LyMKnxdn393ZIMrhnYj3
   g==;
IronPort-SDR: bOW1WJQG7yM/6NYnUU4tqoXsQ3ru9Hhv/rmfuL99Ezjki+vZMLZwdvZbW67mwuCWUol4Iom3b0
 f/vvyOipbQ+8yD4LdXNdBnxOpLq2QDDsvSC8T9Rv2sjwFtZcP1zFosq8+K/b8Q8h1sA0KrjQ6p
 y06rkstFgQQXdBpCeeD4qThFKAyoh54WreO2FCMG2Yg/xP/GsM8BLbApbHr1opIwcLp4f7oHUY
 s+qO4DQKZxxjYwmVcgVhPL7bXJL/5BHYUKuiarOH/XfZRsce0YpWtP5ahhWOZDdJ3HaNpxAbAF
 EnI=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="109866433"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 08:30:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 08:30:06 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 16 Feb 2021 08:30:04 -0700
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
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: [PATCH net-next v3 3/3] net: phy: mscc: coma mode disabled for VSC8514
Date:   Tue, 16 Feb 2021 16:29:44 +0100
Message-ID: <20210216152944.27266-4-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210216152944.27266-1-bjarni.jonasson@microchip.com>
References: <20210216152944.27266-1-bjarni.jonasson@microchip.com>
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

Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 drivers/net/phy/mscc/mscc.h      |  4 ++++
 drivers/net/phy/mscc/mscc_main.c | 16 ++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 2028c319f14d..a50235fdf7d9 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -140,6 +140,10 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_PAGE_1588		  0x1588 /* PTP (1588) */
 #define MSCC_PHY_PAGE_TEST		  0x2a30 /* Test reg */
 #define MSCC_PHY_PAGE_TR		  0x52b5 /* Token ring registers */
+#define MSCC_PHY_GPIO_CONTROL_2           14
+
+#define MSCC_PHY_COMA_MODE		  0x2000 /* input(1) / output(0) */
+#define MSCC_PHY_COMA_OUTPUT		  0x1000 /* value to output */
 
 /* Extended Page 1 Registers */
 #define MSCC_PHY_CU_MEDIA_CRC_VALID_CNT	  18
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 0e6e7076a740..3a7705228ed5 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1516,6 +1516,21 @@ static void vsc8584_get_base_addr(struct phy_device *phydev)
 	vsc8531->addr = addr;
 }
 
+static void vsc85xx_coma_mode_release(struct phy_device *phydev)
+{
+	/* The coma mode (pin or reg) provides an optional feature that
+	 * may be used to control when the PHYs become active.
+	 * Alternatively the COMA_MODE pin may be connected low
+	 * so that the PHYs are fully active once out of reset.
+	 */
+
+	/* Enable output (mode=0) and write zero to it */
+	vsc85xx_phy_write_page(phydev, MSCC_PHY_PAGE_EXTENDED_GPIO);
+	__phy_modify(phydev, MSCC_PHY_GPIO_CONTROL_2,
+		     MSCC_PHY_COMA_MODE | MSCC_PHY_COMA_OUTPUT, 0);
+	vsc85xx_phy_write_page(phydev, MSCC_PHY_PAGE_STANDARD);
+}
+
 static int vsc8584_config_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
@@ -1962,6 +1977,7 @@ static int vsc8514_config_init(struct phy_device *phydev)
 		ret = vsc8514_config_host_serdes(phydev);
 		if (ret)
 			goto err;
+		vsc85xx_coma_mode_release(phydev);
 	}
 
 	phy_unlock_mdio_bus(phydev);
-- 
2.17.1

