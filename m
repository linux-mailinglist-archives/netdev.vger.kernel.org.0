Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADD327817E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgIYH0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:26:31 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:51512 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgIYH0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 03:26:31 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 08P7PU6j8009167, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 08P7PU6j8009167
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Sep 2020 15:25:30 +0800
Received: from localhost.localdomain (172.21.179.130) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 25 Sep 2020 15:25:29 +0800
From:   Willy Liu <willy.liu@realtek.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <fancer.lancer@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ryankao@realtek.com>,
        <kevans@FreeBSD.org>, Willy Liu <willy.liu@realtek.com>
Subject: [PATCH net] net: phy: realtek: fix rtl8211e rx/tx delay config
Date:   Fri, 25 Sep 2020 15:25:15 +0800
Message-ID: <1601018715-952-1-git-send-email-willy.liu@realtek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.179.130]
X-ClientProxiedBy: RTEXMB01.realtek.com.tw (172.21.6.94) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two chip pins named TXDLY and RXDLY which actually adds the 2ns
delays to TXC and RXC for TXD/RXD latching. These two pins can config via
4.7k-ohm resistor to 3.3V hw setting, but also config via software setting
(extension page 0xa4 register 0x1c bit13 12 and 11).

The configuration register definitions from table 13 official PHY datasheet:
PHYAD[2:0] = PHY Address
AN[1:0] = Auto-Negotiation
Mode = Interface Mode Select
RX Delay = RX Delay
TX Delay = TX Delay
SELRGV = RGMII/GMII Selection

This table describes how to config these hw pins via external pull-high or pull-
low resistor.

It is a misunderstanding that mapping it as register bits below:
8:6 = PHY Address
5:4 = Auto-Negotiation
3 = Interface Mode Select
2 = RX Delay
1 = TX Delay
0 = SELRGV
So I removed these descriptions above and add related settings as below:
14 = reserved
13 = force Tx RX Delay controlled by bit12 bit11
12 = Tx Delay
11 = Rx Delay
10:0 = Test && debug settings reserved by realtek

Test && debug settings are not recommend to modify by default.

Fixes: f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx delays config")
Signed-off-by: Willy Liu <willy.liu@realtek.com>
---
 drivers/net/phy/realtek.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)
 mode change 100644 => 100755 drivers/net/phy/realtek.c

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
old mode 100644
new mode 100755
index 95dbe5e..f5fce80
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
@@ -263,11 +263,12 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 
 	/* According to a sample driver there is a 0x1c config register on the
 	 * 0xa4 extension page (0x7) layout. It can be used to disable/enable
-	 * the RX/TX delays otherwise controlled by RXDLY/TXDLY pins. It can
-	 * also be used to customize the whole configuration register:
-	 * 8:6 = PHY Address, 5:4 = Auto-Negotiation, 3 = Interface Mode Select,
-	 * 2 = RX Delay, 1 = TX Delay, 0 = SELRGV (see original PHY datasheet
-	 * for details).
+	 * the RX/TX delays otherwise controlled by RXDLY/TXDLY pins. 
+	 * The configuration register definition:
+	 * 14 = reserved
+	 * 13 = Force Tx RX Delay controlled by bit12 bit11,
+	 * 12 = RX Delay, 11 = TX Delay
+	 * 10:0 = Test && debug settings reserved by realtek
 	 */
 	oldpage = phy_select_page(phydev, 0x7);
 	if (oldpage < 0)
@@ -277,7 +278,8 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	if (ret)
 		goto err_restore_page;
 
-	ret = __phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
+	ret = __phy_modify(phydev, 0x1c, RTL8211E_CTRL_DELAY
+			   | RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
 			   val);
 
 err_restore_page:
-- 
1.9.1

