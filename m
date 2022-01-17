Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EED149114E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 22:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiAQVTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 16:19:02 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:55042 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiAQVTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 16:19:01 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 5A35F20A4D72
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
To:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     <linux-renesas-soc@vger.kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH RFC] phy: make phy_set_max_speed() *void*
Organization: Open Mobile Platform
Message-ID: <a2296c4e-884b-334a-570f-901831bfea3c@omp.ru>
Date:   Tue, 18 Jan 2022 00:18:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After following the call tree of phy_set_max_speed(), it became clear
that this function never returns anything but 0, so we can change its
result type to *void* and drop the result checks from the three drivers
that actually bothered to do it...

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

---
This patch is against the DaveM's 'net-next.git' repo.

 drivers/net/ethernet/renesas/ravb_main.c |    8 +-------
 drivers/net/ethernet/renesas/sh_eth.c    |   10 ++--------
 drivers/net/phy/aquantia_main.c          |    4 +---
 drivers/net/phy/phy-core.c               |   22 ++++++++--------------
 include/linux/phy.h                      |    2 +-
 5 files changed, 13 insertions(+), 33 deletions(-)

Index: net-next/drivers/net/ethernet/renesas/ravb_main.c
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/ravb_main.c
+++ net-next/drivers/net/ethernet/renesas/ravb_main.c
@@ -1432,11 +1432,7 @@ static int ravb_phy_init(struct net_devi
 	 * at this time.
 	 */
 	if (soc_device_match(r8a7795es10)) {
-		err = phy_set_max_speed(phydev, SPEED_100);
-		if (err) {
-			netdev_err(ndev, "failed to limit PHY to 100Mbit/s\n");
-			goto err_phy_disconnect;
-		}
+		phy_set_max_speed(phydev, SPEED_100);
 
 		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
 	}
@@ -1457,8 +1453,6 @@ static int ravb_phy_init(struct net_devi
 
 	return 0;
 
-err_phy_disconnect:
-	phy_disconnect(phydev);
 err_deregister_fixed_link:
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
Index: net-next/drivers/net/ethernet/renesas/sh_eth.c
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.c
+++ net-next/drivers/net/ethernet/renesas/sh_eth.c
@@ -2026,14 +2026,8 @@ static int sh_eth_phy_init(struct net_de
 	}
 
 	/* mask with MAC supported features */
-	if (mdp->cd->register_type != SH_ETH_REG_GIGABIT) {
-		int err = phy_set_max_speed(phydev, SPEED_100);
-		if (err) {
-			netdev_err(ndev, "failed to limit PHY to 100 Mbit/s\n");
-			phy_disconnect(phydev);
-			return err;
-		}
-	}
+	if (mdp->cd->register_type != SH_ETH_REG_GIGABIT)
+		phy_set_max_speed(phydev, SPEED_100);
 
 	phy_attached_info(phydev);
 
Index: net-next/drivers/net/phy/aquantia_main.c
===================================================================
--- net-next.orig/drivers/net/phy/aquantia_main.c
+++ net-next/drivers/net/phy/aquantia_main.c
@@ -533,9 +533,7 @@ static int aqcs109_config_init(struct ph
 	 * PMA speed ability bits are the same for all members of the family,
 	 * AQCS109 however supports speeds up to 2.5G only.
 	 */
-	ret = phy_set_max_speed(phydev, SPEED_2500);
-	if (ret)
-		return ret;
+	phy_set_max_speed(phydev, SPEED_2500);
 
 	return aqr107_set_downshift(phydev, MDIO_AN_VEND_PROV_DOWNSHIFT_DFLT);
 }
Index: net-next/drivers/net/phy/phy-core.c
===================================================================
--- net-next.orig/drivers/net/phy/phy-core.c
+++ net-next/drivers/net/phy/phy-core.c
@@ -243,7 +243,7 @@ size_t phy_speeds(unsigned int *speeds,
 	return count;
 }
 
-static int __set_linkmode_max_speed(u32 max_speed, unsigned long *addr)
+static void __set_linkmode_max_speed(u32 max_speed, unsigned long *addr)
 {
 	const struct phy_setting *p;
 	int i;
@@ -254,13 +254,11 @@ static int __set_linkmode_max_speed(u32
 		else
 			break;
 	}
-
-	return 0;
 }
 
-static int __set_phy_supported(struct phy_device *phydev, u32 max_speed)
+static void __set_phy_supported(struct phy_device *phydev, u32 max_speed)
 {
-	return __set_linkmode_max_speed(max_speed, phydev->supported);
+	__set_linkmode_max_speed(max_speed, phydev->supported);
 }
 
 /**
@@ -273,17 +271,11 @@ static int __set_phy_supported(struct ph
  * is connected to a 1G PHY. This function allows the MAC to indicate its
  * maximum speed, and so limit what the PHY will advertise.
  */
-int phy_set_max_speed(struct phy_device *phydev, u32 max_speed)
+void phy_set_max_speed(struct phy_device *phydev, u32 max_speed)
 {
-	int err;
-
-	err = __set_phy_supported(phydev, max_speed);
-	if (err)
-		return err;
+	__set_phy_supported(phydev, max_speed);
 
 	phy_advertise_supported(phydev);
-
-	return 0;
 }
 EXPORT_SYMBOL(phy_set_max_speed);
 
@@ -440,7 +432,9 @@ int phy_speed_down_core(struct phy_devic
 	if (min_common_speed == SPEED_UNKNOWN)
 		return -EINVAL;
 
-	return __set_linkmode_max_speed(min_common_speed, phydev->advertising);
+	__set_linkmode_max_speed(min_common_speed, phydev->advertising);
+
+	return 0;
 }
 
 static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
Index: net-next/include/linux/phy.h
===================================================================
--- net-next.orig/include/linux/phy.h
+++ net-next/include/linux/phy.h
@@ -1661,7 +1661,7 @@ int phy_disable_interrupts(struct phy_de
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
-int phy_set_max_speed(struct phy_device *phydev, u32 max_speed);
+void phy_set_max_speed(struct phy_device *phydev, u32 max_speed);
 void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode);
 void phy_advertise_supported(struct phy_device *phydev);
 void phy_support_sym_pause(struct phy_device *phydev);
