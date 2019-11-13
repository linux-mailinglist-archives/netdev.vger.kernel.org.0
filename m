Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99BFFB55A
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 17:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbfKMQkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 11:40:21 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:16047 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbfKMQkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 11:40:20 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Bryan.Whitehead@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Bryan.Whitehead@microchip.com";
  x-sender="Bryan.Whitehead@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Bryan.Whitehead@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Bryan.Whitehead@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 9WQyMp6bX4qsb4D4LSryhEPrJZ9QgbFHIvpzMT3xkyYqNZcuQyRHeHZYAjxChHjcE8a43D2YO7
 GoAVSR16uDT5BhAPCHSp4ub6uo0dEjXt137XLnDDCUY5HFUts/CvNCsTuJd0n0o3PTxE3L9k+X
 9SC4h0yY7OduB41bO7V73ExSQDokolN4F6EO5H3Qi3NridGUVP97srcf8KZ2NTcemuWfSqKXBb
 LtXeXH28Nit+9ZLVioT+rSRQKKRGF18yAIlWcU+9jWZ0jO6KNLiy145BywP6I2syQB3Q5kmEwS
 JIo=
X-IronPort-AV: E=Sophos;i="5.68,301,1569308400"; 
   d="scan'208";a="56941621"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2019 09:40:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 Nov 2019 09:40:15 -0700
Received: from BW-Ubuntu-tester.mchp-main.com (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 13 Nov 2019 09:40:14 -0700
From:   Bryan Whitehead <Bryan.Whitehead@microchip.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: [PATCH v2 net-next] mscc.c: Add support for additional VSC PHYs
Date:   Wed, 13 Nov 2019 11:33:15 -0500
Message-ID: <1573662795-3672-1-git-send-email-Bryan.Whitehead@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the following VSC PHYs
	VSC8504, VSC8552, VSC8572
	VSC8562, VSC8564, VSC8575, VSC8582

Updates for v2:
	Checked for NULL on input to container_of
	Changed a large if else series to a switch statement.
	Added a WARN_ON to make sure lowest nibble of mask is 0

Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>
---
 drivers/net/phy/mscc.c | 194 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 188 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 805cda3..aadee8d 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -252,13 +252,21 @@ enum rgmii_rx_clock_delay {
 #define MSCC_PHY_TR_LSB			  17
 #define MSCC_PHY_TR_MSB			  18
 
-/* Microsemi PHY ID's */
+/* Microsemi PHY ID's
+ *   Code assumes lowest nibble is 0
+ */
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
@@ -1595,6 +1603,9 @@ static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
 		else
 			addr = vsc8531->base_addr + i;
 
+		if (!map[addr])
+			continue;
+
 		phy = container_of(map[addr], struct phy_device, mdio);
 
 		if ((phy->phy_id & phydev->drv->phy_id_mask) !=
@@ -1647,14 +1658,29 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	 * in this pre-init function.
 	 */
 	if (!vsc8584_is_pkg_init(phydev, val & PHY_ADDR_REVERSED ? 1 : 0)) {
-		if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
-		    (PHY_ID_VSC8574 & phydev->drv->phy_id_mask))
+		/* The following switch statement assumes that the lowest
+		 * nibble of the phy_id_mask is always 0. This works because
+		 * the lowest nibble of the PHY_ID's below are also 0.
+		 */
+		WARN_ON(phydev->drv->phy_id_mask & 0xf);
+
+		switch (phydev->phy_id & phydev->drv->phy_id_mask) {
+		case PHY_ID_VSC8504:
+		case PHY_ID_VSC8552:
+		case PHY_ID_VSC8572:
+		case PHY_ID_VSC8574:
 			ret = vsc8574_config_pre_init(phydev);
-		else if ((phydev->phy_id & phydev->drv->phy_id_mask) ==
-			 (PHY_ID_VSC8584 & phydev->drv->phy_id_mask))
+			break;
+		case PHY_ID_VSC856X:
+		case PHY_ID_VSC8575:
+		case PHY_ID_VSC8582:
+		case PHY_ID_VSC8584:
 			ret = vsc8584_config_pre_init(phydev);
-		else
+			break;
+		default:
 			ret = -EINVAL;
+			break;
+		};
 
 		if (ret)
 			goto err;
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

