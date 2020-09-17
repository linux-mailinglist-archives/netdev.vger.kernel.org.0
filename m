Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834BF26D0CD
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 03:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgIQBsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 21:48:10 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:47945 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIQBsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 21:48:05 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 08H1lhPL3025255, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 08H1lhPL3025255
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Sep 2020 09:47:43 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Thu, 17 Sep 2020 09:47:43 +0800
Received: from localhost.localdomain (172.21.179.130) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Thu, 17 Sep 2020 09:47:42 +0800
From:   Willy Liu <willy.liu@realtek.com>
To:     <fancer.lancer@gmail.com>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ryankao@realtek.com>,
        Willy Liu <willy.liu@realtek.com>
Subject: [PATCH] net: phy: realtek: fix rtl8211e rx/tx delay config
Date:   Thu, 17 Sep 2020 09:47:33 +0800
Message-ID: <1600307253-3538-1-git-send-email-willy.liu@realtek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.179.130]
X-ClientProxiedBy: RTEXMB01.realtek.com.tw (172.21.6.94) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGMII RX Delay and TX Delay settings will not applied if Force TX RX Delay
Control bit is not set.
Register bit for configuration pins:
13 = force Tx RX Delay controlled by bit12 bit11
12 = Tx Delay
11 = Rx Delay

Fixes: f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx delays config")
Signed-off-by: Willy Liu <willy.liu@realtek.com>
---
 drivers/net/phy/realtek.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)
 mode change 100644 => 100755 drivers/net/phy/realtek.c

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
old mode 100644
new mode 100755
index 95dbe5e..3fddd57
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -32,9 +32,9 @@
 #define RTL8211F_TX_DELAY			BIT(8)
 #define RTL8211F_RX_DELAY			BIT(3)
 
-#define RTL8211E_TX_DELAY			BIT(1)
-#define RTL8211E_RX_DELAY			BIT(2)
-#define RTL8211E_MODE_MII_GMII			BIT(3)
+#define RTL8211E_CTRL_DELAY			BIT(13)
+#define RTL8211E_TX_DELAY			BIT(12)
+#define RTL8211E_RX_DELAY			BIT(11)
 
 #define RTL8201F_ISR				0x1e
 #define RTL8201F_IER				0x13
@@ -249,13 +249,13 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 		val = 0;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_ID:
-		val = RTL8211E_TX_DELAY | RTL8211E_RX_DELAY;
+		val = RTL8211E_CTRL_DELAY | RTL8211E_TX_DELAY | RTL8211E_RX_DELAY;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		val = RTL8211E_RX_DELAY;
+		val = RTL8211E_CTRL_DELAY | RTL8211E_RX_DELAY;
 		break;
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		val = RTL8211E_TX_DELAY;
+		val = RTL8211E_CTRL_DELAY | RTL8211E_TX_DELAY;
 		break;
 	default: /* the rest of the modes imply leaving delays as is. */
 		return 0;
@@ -265,9 +265,8 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	 * 0xa4 extension page (0x7) layout. It can be used to disable/enable
 	 * the RX/TX delays otherwise controlled by RXDLY/TXDLY pins. It can
 	 * also be used to customize the whole configuration register:
-	 * 8:6 = PHY Address, 5:4 = Auto-Negotiation, 3 = Interface Mode Select,
-	 * 2 = RX Delay, 1 = TX Delay, 0 = SELRGV (see original PHY datasheet
-	 * for details).
+	 * 13 = Force Tx RX Delay controlled by bit12 bit11,
+	 * 12 = RX Delay, 11 = TX Delay
 	 */
 	oldpage = phy_select_page(phydev, 0x7);
 	if (oldpage < 0)
@@ -277,7 +276,8 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	if (ret)
 		goto err_restore_page;
 
-	ret = __phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
+	ret = __phy_modify(phydev, 0x1c, RTL8211E_CTRL_DELAY
+			   | RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
 			   val);
 
 err_restore_page:
-- 
1.9.1

