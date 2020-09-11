Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804302660E7
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 16:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgIKOFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 10:05:19 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:9457 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIKNSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 09:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599830332; x=1631366332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=JQDnu/cuqWy8rA4yBHOvQdV8XzXS1x+7uiyMAqpaxeU=;
  b=Mymmm7eYQZvxbnX3oxsCVtkGVMkAcG/ug5j7PZU+K3koU2s7bE0cV4lB
   arqd+ZLjk+aUojEU7hnB0LSBt8Yc/S5KSm9nkIotnYX9TAH2TY00vW8Q7
   PVWwyz/TmNRuvvCx5EAfzMRf32NRQmRFvTNxUSb1TmdtY5lL34cWs1C3y
   sUa0QUXh7ldvZ2waDxSngi6QqiNhPbl3CkUDclN1ursP+nGn8q+c0dC+l
   khPt4JYJP5i3hYOP8tmBys+S+vRauEcBMV7l4Njb4E0xlE40lcyx+NVNC
   p/g3eTRuKrc2jluU7ntB0+vOn6Qhy4GV+Dm2DLZifGkEuLalBD48H1/A6
   Q==;
IronPort-SDR: 69u4SKX5JGjKmVcsUQsAVXQLFrI69qNKRckhU6eCDPYWGPlNRTU5XDo1QFEuHYP00aQGY6aevZ
 L8DLMur+wXtmEi5uV5FIC9MY1yRXOFdnLJAVbNru1MkcFLHouEEGKoJXIE3Ru/zGP2h0eC2Vam
 gdjMw+PUzV3Ee5aocY4ZegyKkzE/Zx6RByia7ubnnUDo4tlSbeHRRL4S2nwFRc8KM2FjECXR1d
 hsyPIbJVTyzd3Lp51EBYFxIF3ZLmjZuHb4vlG5uQUMorx1HKKpbChl1MihR0UhmWZ9CU2UxDyy
 1UY=
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="88733632"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Sep 2020 06:18:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Sep 2020 06:18:07 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 11 Sep 2020 06:18:44 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <marex@denx.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v3 net-next] net: phy: mchp: Add support for LAN8814 QUAD PHY
Date:   Fri, 11 Sep 2020 18:48:44 +0530
Message-ID: <20200911131844.24371-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200911061020.22413-1-Divya.Koppera@microchip.com>
References: <20200911061020.22413-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN8814 is a low-power, quad-port triple-speed (10BASE-T/100BASETX/1000BASE-T)
Ethernet physical layer transceiver (PHY). It supports transmission and
reception of data on standard CAT-5, as well as CAT-5e and CAT-6, unshielded
twisted pair (UTP) cables.

LAN8814 supports industry-standard QSGMII (Quad Serial Gigabit Media
Independent Interface) and Q-USGMII (Quad Universal Serial Gigabit Media
Independent Interface) providing chip-to-chip connection to four Gigabit
Ethernet MACs using a single serialized link (differential pair) in each
direction.

The LAN8814 SKU supports high-accuracy timestamping functions to
support IEEE-1588 solutions using Microchip Ethernet switches, as well as
customer solutions based on SoCs and FPGAs.

The LAN8804 SKU has same features as that of LAN8814 SKU except that it does
not support 1588, SyncE, or Q-USGMII with PCH/MCH.

This adds support for 10BASE-T, 100BASE-TX, and 1000BASE-T,
QSGMII link with the MAC.

Signed-off-by: Divya Koppera<divya.koppera@microchip.com>
---
v1 -> v2:
* Removing get_features and config_init as the Errata mentioned and other
  functionality related things are not applicable for this phy.
  Addressed review comments.
---
v2 -> v3:
* As v2 contains only diff of v1 and v2, correcting mistake and sending
  whole patch with addressed comments in v2.
---
 drivers/net/phy/micrel.c   | 14 ++++++++++++++
 include/linux/micrel_phy.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 3fe552675dd2..a7f74b3b97af 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1314,6 +1314,19 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= kszphy_resume,
+}, {
+	.phy_id		= PHY_ID_LAN8814,
+	.phy_id_mask	= MICREL_PHY_ID_MASK,
+	.name		= "Microchip INDY Gigabit Quad PHY",
+	.driver_data	= &ksz9021_type,
+	.probe		= kszphy_probe,
+	.soft_reset	= genphy_soft_reset,
+	.read_status	= ksz9031_read_status,
+	.get_sset_count	= kszphy_get_sset_count,
+	.get_strings	= kszphy_get_strings,
+	.get_stats	= kszphy_get_stats,
+	.suspend	= genphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9131,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
@@ -1387,6 +1400,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
+	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ }
 };
 
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 75f880c25bb8..416ee6dd2574 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -27,6 +27,7 @@
 #define PHY_ID_KSZ8061		0x00221570
 #define PHY_ID_KSZ9031		0x00221620
 #define PHY_ID_KSZ9131		0x00221640
+#define PHY_ID_LAN8814		0x00221660
 
 #define PHY_ID_KSZ886X		0x00221430
 #define PHY_ID_KSZ8863		0x00221435
-- 
2.17.1

