Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665F52E295A
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 02:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgLYA7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 19:59:37 -0500
Received: from esa9.hc1455-7.c3s2.iphmx.com ([139.138.36.223]:50829 "EHLO
        esa9.hc1455-7.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728989AbgLYA7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 19:59:37 -0500
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Dec 2020 19:59:36 EST
IronPort-SDR: d7IXgYJDrjgDNb5IO15YzNax0Vri7SVVA0vyxWrZeSCvxXSQNCdZ0SDtGhz/LnapuJS4SQqpLs
 cwfzVZ3k+Rky6kMjxfzsY35HtccQDeXg3zKGMZ9CaD4PzM59YZdqhi8tSI8JIzgdFra/mHMk+o
 WwL7kFDAZKphYOR9dHiTGaCzyQyH+0tnQijaz9o82/wWdlXw1Rinm8I0IxRh2JbWJsgQe/HW41
 VtHXIPBFlpyuiu0jzTme78B1EmiRMT8xwR4oFtt5vdktNjj1cAC9eDWhgUCSaM5DWzQ0dU9Wbu
 RZM=
X-IronPort-AV: E=McAfee;i="6000,8403,9845"; a="607538"
X-IronPort-AV: E=Sophos;i="5.78,446,1599490800"; 
   d="scan'208";a="607538"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP; 25 Dec 2020 09:49:43 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
        by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 12587EF95D
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 09:49:43 +0900 (JST)
Received: from durio.utsfd.cs.fujitsu.co.jp (durio.utsfd.cs.fujitsu.co.jp [10.24.20.112])
        by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 4833244AB37
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 09:49:42 +0900 (JST)
Received: by durio.utsfd.cs.fujitsu.co.jp (Postfix, from userid 1006)
        id DE2541FF263; Fri, 25 Dec 2020 09:49:41 +0900 (JST)
From:   Yuusuke Ashizuka <ashiduka@fujitsu.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ashiduka@fujitsu.com,
        torii.ken1@fujitsu.com
Subject: [PATCH] net: phy: realtek: Add support for RTL9000AA/AN
Date:   Fri, 25 Dec 2020 09:47:51 +0900
Message-Id: <20201225004751.26075-1-ashiduka@fujitsu.com>
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
 drivers/net/phy/realtek.c | 51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 575580d3ffe0..ccd3368ba14e 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -54,6 +54,9 @@
 #define RTL_LPADV_5000FULL			BIT(6)
 #define RTL_LPADV_2500FULL			BIT(5)
 
+#define RTL9000A_GINMR				0x14
+#define RTL9000A_GINMR_LINK_STATUS		BIT(4)
+
 #define RTLGEN_SPEED_MASK			0x0630
 
 #define RTL_GENERIC_PHYID			0x001cc800
@@ -547,6 +550,41 @@ static int rtlgen_resume(struct phy_device *phydev)
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
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		val = (u16)~RTL9000A_GINMR_LINK_STATUS;
+	else
+		val = ~0;
+
+	return phy_write_paged(phydev, 0xa42, RTL9000A_GINMR, val);
+}
+
 static struct phy_driver realtek_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(0x00008201),
@@ -674,6 +712,19 @@ static struct phy_driver realtek_drvs[] = {
 		.config_intr	= genphy_no_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+	}, {
+		PHY_ID_MATCH_EXACT(0x001ccb00),
+		.name		= "RTL9000AA/AN Ethernet",
+		.features       = PHY_BASIC_T1_FEATURES,
+		.config_init	= rtl9000a_config_init,
+		.config_aneg	= rtl9000a_config_aneg,
+		.read_status	= genphy_update_link,
+		.ack_interrupt	= rtl9000a_ack_interrupt,
+		.config_intr	= rtl9000a_config_intr,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	},
 };
 
-- 
2.29.2

