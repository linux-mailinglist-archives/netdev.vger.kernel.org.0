Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE4D31C000
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 18:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhBORAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 12:00:55 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51253 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhBOQ7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 11:59:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613408388; x=1644944388;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=jL2ezx6qgtb4SK7w17XMevXRELUKkZVP94Q3IVwpnGE=;
  b=ATDYJgmMv4WwW/LFnspSquOtGYudxIR/HTteC41ty9/wZLirJTPPiQ69
   6H3E4JaspoOCCtOlo0zSFQKo3BMnr/JBw+5YyY/KaXoxav2znpxHzv/9Y
   MlSyW/GVlGBR5J2l55yjnfYKzX6YcsQGMWolYxnwWWkt9RsegMb4uj1pp
   kpSFoHdFjc7Q7S/ePtli5eYcnd1ls8Ji8eUBi+c/D7PLM9osE4yEfmvwC
   6k46OMsNhDPp00B7prb2yAq66L3akMdPkRtLPtP3SffmqqqbTcQLdaqVM
   SQ85rWMtnH5IYICa6VE9A9G3dhgucAUxTV0RZmgjEs4sdEvCehfz2FM4U
   w==;
IronPort-SDR: Z6US7YRMBg44prFp6iS05KbH2ztaxamGXJfa3n+nmsYn9wt8AdxdEl7lbVL3WwXNC6w8H9z7oZ
 MOgZiGrPjGvEmrxOglXbS7UBgD+FVIVu7RAhxIMSw9mrnnrcwatw3KuaGr6knyMRzA9cP5Dhjk
 nawn/wwSA3B+jvY4s3ryIuyQ3aTo3U9t+nvRIRVALvb/dwbbJq6vKBbhsgHBAjiMAMcJNkH0yj
 dYnEKlgq+w3KckuPsAAnUahEq7evO0dX5iR3W1SU2WRP4HvK3JKZ8NxgyAznQFy6AzRxDHtbT3
 lR8=
X-IronPort-AV: E=Sophos;i="5.81,181,1610434800"; 
   d="scan'208";a="44151688"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Feb 2021 09:58:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 15 Feb 2021 09:58:22 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 15 Feb 2021 09:58:19 -0700
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
Subject: [PATCH net-next v2 3/3]  net: phy: mscc: coma mode disabled for VSC8514
Date:   Mon, 15 Feb 2021 17:58:00 +0100
Message-ID: <20210215165800.14580-3-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210215165800.14580-1-bjarni.jonasson@microchip.com>
References: <20210215165800.14580-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'coma mode' (configurable through sw or hw) provides an
optional feature that may be used to control when the PHYs become active.
The typical usage is to synchronize the link-up time across
all PHY instances. This patch releases coma mode if not done by hardware,
otherwise the phys will not link-up

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
---
v1 -> v2:
  Modified coma mode config 
  Changed net to net-next

 drivers/net/phy/mscc/mscc.h      |  3 +++
 drivers/net/phy/mscc/mscc_main.c | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 9d8ee387739e..2b70ccd1b256 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -160,6 +160,9 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_PAGE_TR		  0x52b5 /* Token ring registers */
 #define MSCC_PHY_GPIO_CONTROL_2	  14
 
+#define MSCC_PHY_COMA_MODE		  0x2000 /* input(1) / output(0) */
+#define MSCC_PHY_COMA_OUTPUT		  0x1000 /* value to output */
+
 /* Extended Page 1 Registers */
 #define MSCC_PHY_CU_MEDIA_CRC_VALID_CNT	  18
 #define VALID_CRC_CNT_CRC_MASK		  GENMASK(13, 0)
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 03181542bcb7..29302ccf7e7b 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1520,6 +1520,21 @@ static void vsc8584_get_base_addr(struct phy_device *phydev)
 	vsc8531->addr = addr;
 }
 
+static void vsc85xx_coma_mode_release(struct phy_device *phydev)
+{
+	/* The coma mode (pin or reg) provides an optional feature that
+	 * may be used to control when the PHYs become active.
+	 * Alternatively the COMA_MODE pin may be connected low
+	 * so that the PHYs are fully active once out of reset.
+	 */
+	phy_unlock_mdio_bus(phydev);
+	/* Enable output (mode=0) and write zero to it */
+	phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_GPIO,
+			 MSCC_PHY_GPIO_CONTROL_2,
+			 MSCC_PHY_COMA_MODE | MSCC_PHY_COMA_OUTPUT, 0);
+	phy_lock_mdio_bus(phydev);
+}
+
 static int vsc8584_config_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
@@ -2604,6 +2619,7 @@ static int vsc8514_config_init(struct phy_device *phydev)
 		ret = vsc8514_config_host_serdes(phydev);
 		if (ret)
 			goto err;
+		vsc85xx_coma_mode_release(phydev);
 	}
 
 	phy_unlock_mdio_bus(phydev);
-- 
2.17.1

