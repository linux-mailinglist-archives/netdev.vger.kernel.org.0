Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317B72E78B3
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 13:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgL3MzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 07:55:21 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:51509 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgL3MzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 07:55:21 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D5WSh3gmbz1qs3D;
        Wed, 30 Dec 2020 13:54:12 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D5WSh3BWPz1tYWG;
        Wed, 30 Dec 2020 13:54:12 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id qociLUD-jNfU; Wed, 30 Dec 2020 13:54:11 +0100 (CET)
X-Auth-Info: SehLCSFW8ydQHslG9EwSMBZNtSGSqlAE5+eyQ33+yMo=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 30 Dec 2020 13:54:11 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 1/2] net: phy: micrel: Add KS8851 PHY support
Date:   Wed, 30 Dec 2020 13:53:57 +0100
Message-Id: <20201230125358.1023502-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KS8851 has a reduced internal PHY, which is accessible through its
registers at offset 0xe4. The PHY is compatible with KS886x PHY present
in Micrel switches, except the PHY ID Low/High registers are swapped.
Add PHY ID for this KS8851 PHY and use custom PHY ID mask due to the swap.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>
To: netdev@vger.kernel.org
---
 drivers/net/phy/micrel.c   | 9 +++++++++
 include/linux/micrel_phy.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 54e0d75203da..ca6da128e37a 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1386,6 +1386,14 @@ static struct phy_driver ksphy_driver[] = {
 	.read_status	= ksz8873mll_read_status,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
+}, {
+	.phy_id		= PHY_ID_KSZ8851,
+	.phy_id_mask	= 0xfff000ff,
+	.name		= "Micrel KSZ8851 Ethernet MAC",
+	/* PHY_BASIC_FEATURES */
+	.config_init	= kszphy_config_init,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ886X,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
@@ -1432,6 +1440,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8061, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
+	{ PHY_ID_KSZ8851, 0xfff000ff },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ }
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 416ee6dd2574..1c26e4ac0dc9 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -29,6 +29,8 @@
 #define PHY_ID_KSZ9131		0x00221640
 #define PHY_ID_LAN8814		0x00221660
 
+/* The PHY ID Low/High registers are swapped on KSZ8851 */
+#define PHY_ID_KSZ8851		0x14300022
 #define PHY_ID_KSZ886X		0x00221430
 #define PHY_ID_KSZ8863		0x00221435
 
-- 
2.29.2

