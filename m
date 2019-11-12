Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCBBF94F8
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfKLQAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:00:14 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:53927 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfKLQAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 11:00:13 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Bryan.Whitehead@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Bryan.Whitehead@microchip.com";
  x-sender="Bryan.Whitehead@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Bryan.Whitehead@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Bryan.Whitehead@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: acEvPi9lxLteHBLMYQk8dFsiKJUsm7/JZUUtk2vA+IGhetNmRRROn0kznDq818PVvnMfXp91N/
 H0dE+R3uxtYCvgo5npFMP0tkrVGc6tUOCQtg8B6HX9GXDLZrTsCyk3nSrmDGAOfU6/AJQ95vzD
 qyzyGx3Ad52JQxlgLdMEwO7UTOEgUDJXsjmF3PHWwNcpGL+EPzPSv4lcsLxMVS/J4LmN7zTL3i
 mrUHwjjJx+Ax070sw7QiYeogw+fiexx/1CZOQr6WhEXccoWXzuHe0Wdj4NwR/wFV7ZOxtf10/N
 RuE=
X-IronPort-AV: E=Sophos;i="5.68,297,1569308400"; 
   d="scan'208";a="53946206"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2019 09:00:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 09:00:10 -0700
Received: from BW-Ubuntu-tester.mchp-main.com (10.10.85.251) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 12 Nov 2019 09:00:10 -0700
From:   Bryan Whitehead <Bryan.Whitehead@microchip.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: [PATCH v1 net-next] mscc.c: Add support for additional VSC PHYs
Date:   Tue, 12 Nov 2019 10:54:08 -0500
Message-ID: <1573574048-12251-1-git-send-email-Bryan.Whitehead@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the following VSC PHYs
	VSC8504, VSC8552, VSC8572,
	VSC8562, VSC8564, VSC8575, VSC8582

Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>
---
 drivers/net/phy/mscc.c | 182 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 182 insertions(+)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 805cda3..8933681 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -253,12 +253,18 @@ enum rgmii_rx_clock_delay {
 #define MSCC_PHY_TR_MSB			  18
 
 /* Microsemi PHY ID's */
+#define PHY_ID_VSC8504			  0x000704c0
 #define PHY_ID_VSC8514			  0x00070670
 #define PHY_ID_VSC8530			  0x00070560
 #define PHY_ID_VSC8531			  0x00070570
 #define PHY_ID_VSC8540			  0x00070760
 #define PHY_ID_VSC8541			  0x00070770
+#define PHY_ID_VSC8552			  0x000704e0
+#define PHY_ID_VSC856X			  0x000707e0
+#define PHY_ID_VSC8572			  0x000704d0
 #define PHY_ID_VSC8574			  0x000704a0
+#define PHY_ID_VSC8575			  0x000707d0
+#define PHY_ID_VSC8582			  0x000707b0
 #define PHY_ID_VSC8584			  0x000707c0
 
 #define MSCC_VDDMAC_1500		  1500
@@ -1597,6 +1603,8 @@ static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
 
 		phy = container_of(map[addr], struct phy_device, mdio);
 
+		if (!phy)
+			continue;
+
 		if ((phy->phy_id & phydev->drv->phy_id_mask) !=
 		    (phydev->drv->phy_id & phydev->drv->phy_id_mask))
 			continue;
@@ -1648,9 +1656,27 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	 */
 	if (!vsc8584_is_pkg_init(phydev, val & PHY_ADDR_REVERSED ? 1 : 0)) {
 		if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
+		    (PHY_ID_VSC8504 & phydev->drv->phy_id_mask))
+			ret = vsc8574_config_pre_init(phydev);
+		else if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
+		    (PHY_ID_VSC8552 & phydev->drv->phy_id_mask))
+			ret = vsc8574_config_pre_init(phydev);
+		else if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
+		    (PHY_ID_VSC856X & phydev->drv->phy_id_mask))
+			ret = vsc8584_config_pre_init(phydev);
+		else if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
+		    (PHY_ID_VSC8572 & phydev->drv->phy_id_mask))
+			ret = vsc8574_config_pre_init(phydev);
+		else if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
 		    (PHY_ID_VSC8574 & phydev->drv->phy_id_mask))
 			ret = vsc8574_config_pre_init(phydev);
 		else if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
+		    (PHY_ID_VSC8575 & phydev->drv->phy_id_mask))
+			ret = vsc8584_config_pre_init(phydev);
+		else if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
+		    (PHY_ID_VSC8582 & phydev->drv->phy_id_mask))
+			ret = vsc8584_config_pre_init(phydev);
+		else if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
 			 (PHY_ID_VSC8584 & phydev->drv->phy_id_mask))
 			ret = vsc8584_config_pre_init(phydev);
 		else
@@ -2322,6 +2348,32 @@ static int vsc85xx_probe(struct phy_device *phydev)
 /* Microsemi VSC85xx PHYs */
 static struct phy_driver vsc85xx_driver[] = {
 {
+	.phy_id		= PHY_ID_VSC8504,
+	.name		= "Microsemi GE VSC8504 SyncE",
+	.phy_id_mask	= 0xfffffff0,
+	/* PHY_GBIT_FEATURES */
+	.soft_reset	= &genphy_soft_reset,
+	.config_init    = &vsc8584_config_init,
+	.config_aneg    = &vsc85xx_config_aneg,
+	.aneg_done	= &genphy_aneg_done,
+	.read_status	= &vsc85xx_read_status,
+	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.config_intr    = &vsc85xx_config_intr,
+	.did_interrupt  = &vsc8584_did_interrupt,
+	.suspend	= &genphy_suspend,
+	.resume		= &genphy_resume,
+	.probe		= &vsc8574_probe,
+	.set_wol	= &vsc85xx_wol_set,
+	.get_wol	= &vsc85xx_wol_get,
+	.get_tunable	= &vsc85xx_get_tunable,
+	.set_tunable	= &vsc85xx_set_tunable,
+	.read_page	= &vsc85xx_phy_read_page,
+	.write_page	= &vsc85xx_phy_write_page,
+	.get_sset_count = &vsc85xx_get_sset_count,
+	.get_strings    = &vsc85xx_get_strings,
+	.get_stats      = &vsc85xx_get_stats,
+},
+{
 	.phy_id		= PHY_ID_VSC8514,
 	.name		= "Microsemi GE VSC8514 SyncE",
 	.phy_id_mask	= 0xfffffff0,
@@ -2445,6 +2497,82 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_stats      = &vsc85xx_get_stats,
 },
 {
+	.phy_id		= PHY_ID_VSC8552,
+	.name		= "Microsemi GE VSC8552 SyncE",
+	.phy_id_mask	= 0xfffffff0,
+	/* PHY_GBIT_FEATURES */
+	.soft_reset	= &genphy_soft_reset,
+	.config_init    = &vsc8584_config_init,
+	.config_aneg    = &vsc85xx_config_aneg,
+	.aneg_done	= &genphy_aneg_done,
+	.read_status	= &vsc85xx_read_status,
+	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.config_intr    = &vsc85xx_config_intr,
+	.did_interrupt  = &vsc8584_did_interrupt,
+	.suspend	= &genphy_suspend,
+	.resume		= &genphy_resume,
+	.probe		= &vsc8574_probe,
+	.set_wol	= &vsc85xx_wol_set,
+	.get_wol	= &vsc85xx_wol_get,
+	.get_tunable	= &vsc85xx_get_tunable,
+	.set_tunable	= &vsc85xx_set_tunable,
+	.read_page	= &vsc85xx_phy_read_page,
+	.write_page	= &vsc85xx_phy_write_page,
+	.get_sset_count = &vsc85xx_get_sset_count,
+	.get_strings    = &vsc85xx_get_strings,
+	.get_stats      = &vsc85xx_get_stats,
+},
+{
+	.phy_id		= PHY_ID_VSC856X,
+	.name		= "Microsemi GE VSC856X SyncE",
+	.phy_id_mask	= 0xfffffff0,
+	/* PHY_GBIT_FEATURES */
+	.soft_reset	= &genphy_soft_reset,
+	.config_init    = &vsc8584_config_init,
+	.config_aneg    = &vsc85xx_config_aneg,
+	.aneg_done	= &genphy_aneg_done,
+	.read_status	= &vsc85xx_read_status,
+	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.config_intr    = &vsc85xx_config_intr,
+	.did_interrupt  = &vsc8584_did_interrupt,
+	.suspend	= &genphy_suspend,
+	.resume		= &genphy_resume,
+	.probe		= &vsc8584_probe,
+	.get_tunable	= &vsc85xx_get_tunable,
+	.set_tunable	= &vsc85xx_set_tunable,
+	.read_page	= &vsc85xx_phy_read_page,
+	.write_page	= &vsc85xx_phy_write_page,
+	.get_sset_count = &vsc85xx_get_sset_count,
+	.get_strings    = &vsc85xx_get_strings,
+	.get_stats      = &vsc85xx_get_stats,
+},
+{
+	.phy_id		= PHY_ID_VSC8572,
+	.name		= "Microsemi GE VSC8572 SyncE",
+	.phy_id_mask	= 0xfffffff0,
+	/* PHY_GBIT_FEATURES */
+	.soft_reset	= &genphy_soft_reset,
+	.config_init    = &vsc8584_config_init,
+	.config_aneg    = &vsc85xx_config_aneg,
+	.aneg_done	= &genphy_aneg_done,
+	.read_status	= &vsc85xx_read_status,
+	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.config_intr    = &vsc85xx_config_intr,
+	.did_interrupt  = &vsc8584_did_interrupt,
+	.suspend	= &genphy_suspend,
+	.resume		= &genphy_resume,
+	.probe		= &vsc8574_probe,
+	.set_wol	= &vsc85xx_wol_set,
+	.get_wol	= &vsc85xx_wol_get,
+	.get_tunable	= &vsc85xx_get_tunable,
+	.set_tunable	= &vsc85xx_set_tunable,
+	.read_page	= &vsc85xx_phy_read_page,
+	.write_page	= &vsc85xx_phy_write_page,
+	.get_sset_count = &vsc85xx_get_sset_count,
+	.get_strings    = &vsc85xx_get_strings,
+	.get_stats      = &vsc85xx_get_stats,
+},
+{
 	.phy_id		= PHY_ID_VSC8574,
 	.name		= "Microsemi GE VSC8574 SyncE",
 	.phy_id_mask	= 0xfffffff0,
@@ -2471,6 +2599,54 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_stats      = &vsc85xx_get_stats,
 },
 {
+	.phy_id		= PHY_ID_VSC8575,
+	.name		= "Microsemi GE VSC8575 SyncE",
+	.phy_id_mask	= 0xfffffff0,
+	/* PHY_GBIT_FEATURES */
+	.soft_reset	= &genphy_soft_reset,
+	.config_init    = &vsc8584_config_init,
+	.config_aneg    = &vsc85xx_config_aneg,
+	.aneg_done	= &genphy_aneg_done,
+	.read_status	= &vsc85xx_read_status,
+	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.config_intr    = &vsc85xx_config_intr,
+	.did_interrupt  = &vsc8584_did_interrupt,
+	.suspend	= &genphy_suspend,
+	.resume		= &genphy_resume,
+	.probe		= &vsc8584_probe,
+	.get_tunable	= &vsc85xx_get_tunable,
+	.set_tunable	= &vsc85xx_set_tunable,
+	.read_page	= &vsc85xx_phy_read_page,
+	.write_page	= &vsc85xx_phy_write_page,
+	.get_sset_count = &vsc85xx_get_sset_count,
+	.get_strings    = &vsc85xx_get_strings,
+	.get_stats      = &vsc85xx_get_stats,
+},
+{
+	.phy_id		= PHY_ID_VSC8582,
+	.name		= "Microsemi GE VSC8582 SyncE",
+	.phy_id_mask	= 0xfffffff0,
+	/* PHY_GBIT_FEATURES */
+	.soft_reset	= &genphy_soft_reset,
+	.config_init    = &vsc8584_config_init,
+	.config_aneg    = &vsc85xx_config_aneg,
+	.aneg_done	= &genphy_aneg_done,
+	.read_status	= &vsc85xx_read_status,
+	.ack_interrupt  = &vsc85xx_ack_interrupt,
+	.config_intr    = &vsc85xx_config_intr,
+	.did_interrupt  = &vsc8584_did_interrupt,
+	.suspend	= &genphy_suspend,
+	.resume		= &genphy_resume,
+	.probe		= &vsc8584_probe,
+	.get_tunable	= &vsc85xx_get_tunable,
+	.set_tunable	= &vsc85xx_set_tunable,
+	.read_page	= &vsc85xx_phy_read_page,
+	.write_page	= &vsc85xx_phy_write_page,
+	.get_sset_count = &vsc85xx_get_sset_count,
+	.get_strings    = &vsc85xx_get_strings,
+	.get_stats      = &vsc85xx_get_stats,
+},
+{
 	.phy_id		= PHY_ID_VSC8584,
 	.name		= "Microsemi GE VSC8584 SyncE",
 	.phy_id_mask	= 0xfffffff0,
@@ -2500,12 +2676,18 @@ static struct phy_driver vsc85xx_driver[] = {
 module_phy_driver(vsc85xx_driver);
 
 static struct mdio_device_id __maybe_unused vsc85xx_tbl[] = {
+	{ PHY_ID_VSC8504, 0xfffffff0, },
 	{ PHY_ID_VSC8514, 0xfffffff0, },
 	{ PHY_ID_VSC8530, 0xfffffff0, },
 	{ PHY_ID_VSC8531, 0xfffffff0, },
 	{ PHY_ID_VSC8540, 0xfffffff0, },
 	{ PHY_ID_VSC8541, 0xfffffff0, },
+	{ PHY_ID_VSC8552, 0xfffffff0, },
+	{ PHY_ID_VSC856X, 0xfffffff0, },
+	{ PHY_ID_VSC8572, 0xfffffff0, },
 	{ PHY_ID_VSC8574, 0xfffffff0, },
+	{ PHY_ID_VSC8575, 0xfffffff0, },
+	{ PHY_ID_VSC8582, 0xfffffff0, },
 	{ PHY_ID_VSC8584, 0xfffffff0, },
 	{ }
 };
-- 
2.7.4

