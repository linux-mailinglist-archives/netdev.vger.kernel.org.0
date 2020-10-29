Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B61F29EB4E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgJ2MJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:09:15 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:48790 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgJ2MJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 08:09:13 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 09TC8VI30020554, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 09TC8VI30020554
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Oct 2020 20:08:31 +0800
Received: from localhost.localdomain (172.21.179.130) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Thu, 29 Oct 2020 20:08:31 +0800
From:   Willy Liu <willy.liu@realtek.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>
Subject: [PATCH net-next 1/2] net: phy: realtek: Add phy ids for RTL8226-CG/RTL8226B-CG
Date:   Thu, 29 Oct 2020 20:07:57 +0800
Message-ID: <1603973277-1634-1-git-send-email-willy.liu@realtek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.179.130]
X-ClientProxiedBy: RTEXMB01.realtek.com.tw (172.21.6.94) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek single-port 2.5Gbps Ethernet PHY ids as below:
RTL8226-CG: 0x001cc800(ES)/0x001cc838(MP)
RTL8226B-CG/RTL8221B-CG: 0x001cc840(ES)/0x001cc848(MP)
ES: engineer sample
MP: mass production

Since above PHYs are already in mass production stage,
mass production id should be added.

Signed-off-by: Willy Liu <willy.liu@realtek.com>
---
 drivers/net/phy/realtek.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)
 mode change 100644 => 100755 drivers/net/phy/realtek.c

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
old mode 100644
new mode 100755
index fb1db71..988f075
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -57,6 +57,9 @@
 #define RTLGEN_SPEED_MASK			0x0630
 
 #define RTL_GENERIC_PHYID			0x001cc800
+#define RTL_8226_MP_PHYID			0x001cc838
+#define RTL_8221B_ES_PHYID			0x001cc840
+#define RTL_8221B_MP_PHYID			0x001cc848
 
 MODULE_DESCRIPTION("Realtek PHY driver");
 MODULE_AUTHOR("Johnson Leung");
@@ -533,10 +536,17 @@ static int rtlgen_match_phy_device(struct phy_device *phydev)
 
 static int rtl8226_match_phy_device(struct phy_device *phydev)
 {
-	return phydev->phy_id == RTL_GENERIC_PHYID &&
+	return (phydev->phy_id == RTL_GENERIC_PHYID) ||
+	       (phydev->phy_id == RTL_8226_MP_PHYID) &&
 	       rtlgen_supports_2_5gbps(phydev);
 }
 
+static int rtl8221b_match_phy_device(struct phy_device *phydev)
+{
+	return (phydev->phy_id == RTL_8221B_ES_PHYID) ||
+	       (phydev->phy_id == RTL_8221B_MP_PHYID);
+}
+
 static int rtlgen_resume(struct phy_device *phydev)
 {
 	int ret = genphy_resume(phydev);
@@ -636,7 +646,7 @@ static int rtlgen_resume(struct phy_device *phydev)
 		.read_mmd	= rtlgen_read_mmd,
 		.write_mmd	= rtlgen_write_mmd,
 	}, {
-		.name		= "RTL8226 2.5Gbps PHY",
+		.name		= "RTL8226-CG 2.5Gbps PHY",
 		.match_phy_device = rtl8226_match_phy_device,
 		.get_features	= rtl822x_get_features,
 		.config_aneg	= rtl822x_config_aneg,
@@ -648,8 +658,8 @@ static int rtlgen_resume(struct phy_device *phydev)
 		.read_mmd	= rtl822x_read_mmd,
 		.write_mmd	= rtl822x_write_mmd,
 	}, {
-		PHY_ID_MATCH_EXACT(0x001cc840),
-		.name		= "RTL8226B_RTL8221B 2.5Gbps PHY",
+		.name		= "RTL8226B-CG_RTL8221B-CG 2.5Gbps PHY",
+		.match_phy_device = rtl8221b_match_phy_device,
 		.get_features	= rtl822x_get_features,
 		.config_aneg	= rtl822x_config_aneg,
 		.read_status	= rtl822x_read_status,
-- 
1.9.1

