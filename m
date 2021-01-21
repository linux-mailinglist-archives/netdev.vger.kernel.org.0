Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E0F2FE4A1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 09:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbhAUIF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 03:05:59 -0500
Received: from esa4.hc1455-7.c3s2.iphmx.com ([68.232.139.117]:63406 "EHLO
        esa4.hc1455-7.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726889AbhAUIFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 03:05:31 -0500
IronPort-SDR: KfWOJS+7p7kS+GNoShMuMFRuyc/4m00oomVullZdUfRA5QBLoO+W1aA2yN4z+6xyCS1XL09VB0
 KlBPg0IeLf4uYSiUM9UzACmo6zxo4ctMu8ZVMglD828aBvWhT/ioEb93r5ooU279ytaNfdkzEV
 yuY+qRa9azh5IayAFlLKA9aHLFw48mbXvMjN6gNPers5F/v3P+FmsSlc/fjkhF4mrYQ8LiMJlz
 TZC8t0ekhuzlqG9vg0aomrOpuHABX7ICS8YxRdZBqfVPU1O4KEjRYoDby9jTxRy5cN5uQdBwQ/
 t5o=
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="15951723"
X-IronPort-AV: E=Sophos;i="5.79,363,1602514800"; 
   d="scan'208";a="15951723"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP; 21 Jan 2021 17:03:00 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
        by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id DE611147F0
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 17:02:58 +0900 (JST)
Received: from durio.utsfd.cs.fujitsu.co.jp (durio.utsfd.cs.fujitsu.co.jp [10.24.20.112])
        by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 21C5FC9CFF
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 17:02:58 +0900 (JST)
Received: by durio.utsfd.cs.fujitsu.co.jp (Postfix, from userid 1006)
        id BE2F21FF206; Thu, 21 Jan 2021 17:02:57 +0900 (JST)
From:   Yuusuke Ashizuka <ashiduka@fujitsu.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ashiduka@fujitsu.com,
        torii.ken1@fujitsu.com
Subject: [PATCH v3] net: phy: realtek: Add support for RTL9000AA/AN
Date:   Thu, 21 Jan 2021 17:02:54 +0900
Message-Id: <20210121080254.21286-1-ashiduka@fujitsu.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL9000AA/AN as 100BASE-T1 is following:
- 100 Mbps
- Full duplex
- Link Status Change Interrupt
- Master/Slave configuration

Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
Signed-off-by: Torii Kenichi <torii.ken1@fujitsu.com>
---
v3:
-  Support for master-slave configuration

v2:
- Remove the use of .ack_interrupt()
- Implement .handle_interrupt() callback
- Remove the slash from driver name
---
 drivers/net/phy/realtek.c | 132 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 99ecd6c4c15a..821e85a97367 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -60,6 +60,9 @@
 #define RTL_LPADV_5000FULL			BIT(6)
 #define RTL_LPADV_2500FULL			BIT(5)
 
+#define RTL9000A_GINMR				0x14
+#define RTL9000A_GINMR_LINK_STATUS		BIT(4)
+
 #define RTLGEN_SPEED_MASK			0x0630
 
 #define RTL_GENERIC_PHYID			0x001cc800
@@ -655,6 +658,122 @@ static int rtlgen_resume(struct phy_device *phydev)
 	return ret;
 }
 
+static int rtl9000a_config_init(struct phy_device *phydev)
+{
+	phydev->autoneg = AUTONEG_DISABLE;
+	phydev->speed = SPEED_100;
+	phydev->duplex = DUPLEX_FULL;
+
+	return 0;
+}
+
+static int rtl9000a_config_aneg(struct phy_device *phydev)
+{
+	int ret;
+	u16 ctl = 0;
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+		ctl |= CTL1000_AS_MASTER;
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		break;
+	case MASTER_SLAVE_CFG_UNKNOWN:
+	case MASTER_SLAVE_CFG_UNSUPPORTED:
+		return 0;
+	default:
+		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+		return -EOPNOTSUPP;
+	}
+
+	ret = phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
+	if (ret == 1)
+		ret = genphy_soft_reset(phydev);
+
+	return ret;
+}
+
+static int rtl9000a_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
+
+	ret = genphy_update_link(phydev);
+	if (ret)
+		return ret;
+
+	ret = phy_read(phydev, MII_CTRL1000);
+	if (ret < 0)
+		return ret;
+	if (ret & CTL1000_AS_MASTER)
+		phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
+	else
+		phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
+
+	ret = phy_read(phydev, MII_STAT1000);
+	if (ret < 0)
+		return ret;
+	if (ret & LPA_1000MSRES)
+		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
+	else
+		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
+
+	return 0;
+}
+
+static int rtl9000a_ack_interrupt(struct phy_device *phydev)
+{
+	int err;
+
+	err = phy_read(phydev, RTL8211F_INSR);
+
+	return (err < 0) ? err : 0;
+}
+
+static int rtl9000a_config_intr(struct phy_device *phydev)
+{
+	u16 val;
+	int err;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = rtl9000a_ack_interrupt(phydev);
+		if (err)
+			return err;
+
+		val = (u16)~RTL9000A_GINMR_LINK_STATUS;
+		err = phy_write_paged(phydev, 0xa42, RTL9000A_GINMR, val);
+	} else {
+		val = ~0;
+		err = phy_write_paged(phydev, 0xa42, RTL9000A_GINMR, val);
+		if (err)
+			return err;
+
+		err = rtl9000a_ack_interrupt(phydev);
+	}
+
+	return phy_write_paged(phydev, 0xa42, RTL9000A_GINMR, val);
+}
+
+static irqreturn_t rtl9000a_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, RTL8211F_INSR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & RTL8211F_INER_LINK_STATUS))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static struct phy_driver realtek_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x00008201),
@@ -823,6 +942,19 @@ static struct phy_driver realtek_drvs[] = {
 		.handle_interrupt = genphy_handle_interrupt_no_ack,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+	}, {
+		PHY_ID_MATCH_EXACT(0x001ccb00),
+		.name		= "RTL9000AA_RTL9000AN Ethernet",
+		.features       = PHY_BASIC_T1_FEATURES,
+		.config_init	= rtl9000a_config_init,
+		.config_aneg	= rtl9000a_config_aneg,
+		.read_status	= rtl9000a_read_status,
+		.config_intr	= rtl9000a_config_intr,
+		.handle_interrupt = rtl9000a_handle_interrupt,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	},
 };
 
-- 
2.29.2

