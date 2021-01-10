Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8DF2F061D
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 10:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbhAJJCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 04:02:36 -0500
Received: from esa8.hc1455-7.c3s2.iphmx.com ([139.138.61.253]:43947 "EHLO
        esa8.hc1455-7.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbhAJJCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 04:02:36 -0500
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2021 04:02:34 EST
IronPort-SDR: Y0cDX8R5mVCsP4AqtL+ufDaMFSseijlChHTVsz9Uo2Gds7GsiDxWkN91/qPdmghx2hNloL3oBy
 8Nwz/RRmC9uhthcATLEBGM06aMDXZ+e7H6kbjXVDUeSHs8E+CYdieRJYVhyO5yl11nRdD42PlA
 VwPnWAhdipO8G/5zD5j6Mty9oDa2fM1XueC04Wd1as+K8pFVWdXCAe5kBbY57WENRLO2O12KmC
 hOVzXtpduYav+tCOJHdboMFGj36MM14vVS+ZX//VxGfWkH93yI172WGyU2snUXXGtM+34NKW0c
 Qus=
X-IronPort-AV: E=McAfee;i="6000,8403,9859"; a="2287011"
X-IronPort-AV: E=Sophos;i="5.79,336,1602514800"; 
   d="scan'208";a="2287011"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP; 10 Jan 2021 17:52:42 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
        by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 7DF32E0369
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 17:52:41 +0900 (JST)
Received: from durio.utsfd.cs.fujitsu.co.jp (durio.utsfd.cs.fujitsu.co.jp [10.24.20.112])
        by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id C684C6CBC6
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 17:52:40 +0900 (JST)
Received: by durio.utsfd.cs.fujitsu.co.jp (Postfix, from userid 1006)
        id 765001FF21B; Sun, 10 Jan 2021 17:52:40 +0900 (JST)
From:   Yuusuke Ashizuka <ashiduka@fujitsu.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ashiduka@fujitsu.com,
        torii.ken1@fujitsu.com
Subject: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Date:   Sun, 10 Jan 2021 17:52:21 +0900
Message-Id: <20210110085221.5881-1-ashiduka@fujitsu.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL9000AA/AN as 100BASE-T1 is following:
- 100 Mbps
- Full duplex
- Link Status Change Interrupt

Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
Signed-off-by: Torii Kenichi <torii.ken1@fujitsu.com>
---
v2:
- Remove the use of .ack_interrupt()
- Implement .handle_interrupt() callback
- Remove the slash from driver name
---
 drivers/net/phy/realtek.c | 81 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 99ecd6c4c15a..1312e0eeecfa 100644
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
@@ -655,6 +658,71 @@ static int rtlgen_resume(struct phy_device *phydev)
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
@@ -823,6 +891,19 @@ static struct phy_driver realtek_drvs[] = {
 		.handle_interrupt = genphy_handle_interrupt_no_ack,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+	}, {
+		PHY_ID_MATCH_EXACT(0x001ccb00),
+		.name		= "RTL9000AA_RTL9000AN Ethernet",
+		.features       = PHY_BASIC_T1_FEATURES,
+		.config_init	= rtl9000a_config_init,
+		.config_aneg	= rtl9000a_config_aneg,
+		.read_status	= genphy_update_link,
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

