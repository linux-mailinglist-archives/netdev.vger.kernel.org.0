Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A8730D617
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhBCJRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:17:38 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44190 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbhBCJPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:15:42 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1139Ew3J2008969, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 1139Ew3J2008969
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 3 Feb 2021 17:14:58 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 3 Feb 2021
 17:14:57 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 2/2] r8152: adjust the flow of power cut for RTL8153B
Date:   Wed, 3 Feb 2021 17:14:29 +0800
Message-ID: <1394712342-15778-400-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-398-Taiwan-albertk@realtek.com>
References: <1394712342-15778-398-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For runtime resuming, the RTL8153B may be resumed from the state
of power cut, when enabling the feature of UPS. Then, the PHY
would be reset, so it is necessary to be initailized again.

Besides, the USB_U1U2_TIMER also has to be set again, so I move
it from r8153b_init() to r8153b_hw_phy_cfg().

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 68 ++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e792c1c69f14..d0048ebc114a 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1371,6 +1371,10 @@ void write_mii_word(struct net_device *netdev, int phy_id, int reg, int val)
 static int
 r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags);
 
+static int
+rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u32 speed, u8 duplex,
+		  u32 advertising);
+
 static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 {
 	struct r8152 *tp = netdev_priv(netdev);
@@ -3207,8 +3211,6 @@ static void r8153b_ups_en(struct r8152 *tp, bool enable)
 		ocp_data |= BIT(0);
 		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfff, ocp_data);
 	} else {
-		u16 data;
-
 		ocp_data &= ~(UPS_EN | USP_PREWAKE);
 		ocp_write_byte(tp, MCU_TYPE_USB, USB_POWER_CUT, ocp_data);
 
@@ -3216,31 +3218,20 @@ static void r8153b_ups_en(struct r8152 *tp, bool enable)
 		ocp_data &= ~BIT(0);
 		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfff, ocp_data);
 
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
-		ocp_data &= ~PCUT_STATUS;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_MISC_0, ocp_data);
-
-		data = r8153_phy_status(tp, 0);
-
-		switch (data) {
-		case PHY_STAT_PWRDN:
-		case PHY_STAT_EXT_INIT:
-			r8153b_green_en(tp,
-					test_bit(GREEN_ETHERNET, &tp->flags));
+		if (ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0) & PCUT_STATUS) {
+			int i;
 
-			data = r8152_mdio_read(tp, MII_BMCR);
-			data &= ~BMCR_PDOWN;
-			data |= BMCR_RESET;
-			r8152_mdio_write(tp, MII_BMCR, data);
+			for (i = 0; i < 500; i++) {
+				if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
+				    AUTOLOAD_DONE)
+					break;
+				msleep(20);
+			}
 
-			data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
-			fallthrough;
+			tp->rtl_ops.hw_phy_cfg(tp);
 
-		default:
-			if (data != PHY_STAT_LAN_ON)
-				netif_warn(tp, link, tp->netdev,
-					   "PHY not ready");
-			break;
+			rtl8152_set_speed(tp, tp->autoneg, tp->speed,
+					  tp->duplex, tp->advertising);
 		}
 	}
 }
@@ -4614,13 +4605,37 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 	u32 ocp_data;
 	u16 data;
 
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
+	if (ocp_data & PCUT_STATUS) {
+		ocp_data &= ~PCUT_STATUS;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_MISC_0, ocp_data);
+	}
+
 	/* disable ALDPS before updating the PHY parameters */
 	r8153_aldps_en(tp, false);
 
 	/* disable EEE before updating the PHY parameters */
 	rtl_eee_enable(tp, false);
 
-	rtl8152_apply_firmware(tp, false);
+	/* U1/U2/L1 idle timer. 500 us */
+	ocp_write_word(tp, MCU_TYPE_USB, USB_U1U2_TIMER, 500);
+
+	data = r8153_phy_status(tp, 0);
+
+	switch (data) {
+	case PHY_STAT_PWRDN:
+	case PHY_STAT_EXT_INIT:
+		rtl8152_apply_firmware(tp, true);
+
+		data = r8152_mdio_read(tp, MII_BMCR);
+		data &= ~BMCR_PDOWN;
+		r8152_mdio_write(tp, MII_BMCR, data);
+		break;
+	case PHY_STAT_LAN_ON:
+	default:
+		rtl8152_apply_firmware(tp, false);
+		break;
+	}
 
 	r8153b_green_en(tp, test_bit(GREEN_ETHERNET, &tp->flags));
 
@@ -5546,9 +5561,6 @@ static void r8153b_init(struct r8152 *tp)
 	/* MSC timer = 0xfff * 8ms = 32760 ms */
 	ocp_write_word(tp, MCU_TYPE_USB, USB_MSC_TIMER, 0x0fff);
 
-	/* U1/U2/L1 idle timer. 500 us */
-	ocp_write_word(tp, MCU_TYPE_USB, USB_U1U2_TIMER, 500);
-
 	r8153b_power_cut_en(tp, false);
 	r8153b_ups_en(tp, false);
 	r8153_queue_wake(tp, false);
-- 
2.26.2

