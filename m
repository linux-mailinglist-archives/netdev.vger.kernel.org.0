Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E60FA554F
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 13:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbfIBLwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 07:52:42 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:59716 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729918AbfIBLwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 07:52:42 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x82BqeTc030213, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x82BqeTc030213
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 2 Sep 2019 19:52:40 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Mon, 2 Sep 2019
 19:52:38 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: modify rtl8152_set_speed function
Date:   Mon, 2 Sep 2019 19:52:28 +0800
Message-ID: <1394712342-15778-326-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First, for AUTONEG_DISABLE, we only need to modify MII_BMCR.

Second, add advertising parameter for rtl8152_set_speed(). Add
RTL_ADVERTISED_xxx for advertising parameter of rtl8152_set_speed().
Then, the advertising settings from ethtool could be saved.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 196 +++++++++++++++++++++++++++-------------
 1 file changed, 132 insertions(+), 64 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c6fa0c17c13d..5d49d8dd93e1 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -757,6 +757,7 @@ struct r8152 {
 	u32 msg_enable;
 	u32 tx_qlen;
 	u32 coalesce;
+	u32 advertising;
 	u32 rx_buf_sz;
 	u32 rx_copybreak;
 	u32 rx_pending;
@@ -790,6 +791,13 @@ enum tx_csum_stat {
 	TX_CSUM_NONE
 };
 
+#define RTL_ADVERTISED_10_HALF			BIT(0)
+#define RTL_ADVERTISED_10_FULL			BIT(1)
+#define RTL_ADVERTISED_100_HALF			BIT(2)
+#define RTL_ADVERTISED_100_FULL			BIT(3)
+#define RTL_ADVERTISED_1000_HALF		BIT(4)
+#define RTL_ADVERTISED_1000_FULL		BIT(5)
+
 /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
  * The RTL chips use a 64 element hash table based on the Ethernet CRC.
  */
@@ -3801,90 +3809,117 @@ static void rtl8153b_disable(struct r8152 *tp)
 	r8153b_aldps_en(tp, true);
 }
 
-static int rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u16 speed, u8 duplex)
+static int rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u32 speed, u8 duplex,
+			     u32 advertising)
 {
-	u16 bmcr, anar, gbcr;
 	enum spd_duplex speed_duplex;
+	u16 bmcr;
 	int ret = 0;
 
-	anar = r8152_mdio_read(tp, MII_ADVERTISE);
-	anar &= ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
-		  ADVERTISE_100HALF | ADVERTISE_100FULL);
-	if (tp->mii.supports_gmii) {
-		gbcr = r8152_mdio_read(tp, MII_CTRL1000);
-		gbcr &= ~(ADVERTISE_1000FULL | ADVERTISE_1000HALF);
-	} else {
-		gbcr = 0;
-	}
-
 	if (autoneg == AUTONEG_DISABLE) {
-		if (speed == SPEED_10) {
-			bmcr = 0;
-			anar |= ADVERTISE_10HALF | ADVERTISE_10FULL;
-			speed_duplex = FORCE_10M_HALF;
-		} else if (speed == SPEED_100) {
-			bmcr = BMCR_SPEED100;
-			anar |= ADVERTISE_100HALF | ADVERTISE_100FULL;
-			speed_duplex = FORCE_100M_HALF;
-		} else if (speed == SPEED_1000 && tp->mii.supports_gmii) {
-			bmcr = BMCR_SPEED1000;
-			gbcr |= ADVERTISE_1000FULL | ADVERTISE_1000HALF;
-			speed_duplex = NWAY_1000M_FULL;
-		} else {
-			ret = -EINVAL;
-			goto out;
-		}
+		if (duplex != DUPLEX_HALF && duplex != DUPLEX_FULL)
+			return -EINVAL;
 
-		if (duplex == DUPLEX_FULL) {
-			bmcr |= BMCR_FULLDPLX;
-			if (speed != SPEED_1000)
-				speed_duplex++;
-		}
-	} else {
-		if (speed == SPEED_10) {
+		switch (speed) {
+		case SPEED_10:
+			bmcr = BMCR_SPEED10;
 			if (duplex == DUPLEX_FULL) {
-				anar |= ADVERTISE_10HALF | ADVERTISE_10FULL;
-				speed_duplex = NWAY_10M_FULL;
+				bmcr |= BMCR_FULLDPLX;
+				speed_duplex = FORCE_10M_FULL;
 			} else {
-				anar |= ADVERTISE_10HALF;
-				speed_duplex = NWAY_10M_HALF;
+				speed_duplex = FORCE_10M_HALF;
 			}
-		} else if (speed == SPEED_100) {
+			break;
+		case SPEED_100:
+			bmcr = BMCR_SPEED100;
 			if (duplex == DUPLEX_FULL) {
-				anar |= ADVERTISE_10HALF | ADVERTISE_10FULL;
-				anar |= ADVERTISE_100HALF | ADVERTISE_100FULL;
-				speed_duplex = NWAY_100M_FULL;
+				bmcr |= BMCR_FULLDPLX;
+				speed_duplex = FORCE_100M_FULL;
 			} else {
-				anar |= ADVERTISE_10HALF;
-				anar |= ADVERTISE_100HALF;
-				speed_duplex = NWAY_100M_HALF;
+				speed_duplex = FORCE_100M_HALF;
 			}
-		} else if (speed == SPEED_1000 && tp->mii.supports_gmii) {
-			if (duplex == DUPLEX_FULL) {
-				anar |= ADVERTISE_10HALF | ADVERTISE_10FULL;
-				anar |= ADVERTISE_100HALF | ADVERTISE_100FULL;
-				gbcr |= ADVERTISE_1000FULL | ADVERTISE_1000HALF;
-			} else {
-				anar |= ADVERTISE_10HALF;
-				anar |= ADVERTISE_100HALF;
-				gbcr |= ADVERTISE_1000HALF;
+			break;
+		case SPEED_1000:
+			if (tp->mii.supports_gmii) {
+				bmcr = BMCR_SPEED1000 | BMCR_FULLDPLX;
+				speed_duplex = NWAY_1000M_FULL;
+				break;
 			}
-			speed_duplex = NWAY_1000M_FULL;
-		} else {
+			/* fall through */
+		default:
 			ret = -EINVAL;
 			goto out;
 		}
 
+		if (duplex == DUPLEX_FULL)
+			tp->mii.full_duplex = 1;
+		else
+			tp->mii.full_duplex = 0;
+
+		tp->mii.force_media = 1;
+	} else {
+		u16 anar, tmp1;
+		u32 support;
+
+		support = RTL_ADVERTISED_10_HALF | RTL_ADVERTISED_10_FULL |
+			  RTL_ADVERTISED_100_HALF | RTL_ADVERTISED_100_FULL;
+
+		if (tp->mii.supports_gmii)
+			support |= RTL_ADVERTISED_1000_FULL;
+
+		if (!(advertising & support))
+			return -EINVAL;
+
+		anar = r8152_mdio_read(tp, MII_ADVERTISE);
+		tmp1 = anar & ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
+				ADVERTISE_100HALF | ADVERTISE_100FULL);
+		if (advertising & RTL_ADVERTISED_10_HALF) {
+			tmp1 |= ADVERTISE_10HALF;
+			speed_duplex = NWAY_10M_HALF;
+		}
+		if (advertising & RTL_ADVERTISED_10_FULL) {
+			tmp1 |= ADVERTISE_10FULL;
+			speed_duplex = NWAY_10M_FULL;
+		}
+
+		if (advertising & RTL_ADVERTISED_100_HALF) {
+			tmp1 |= ADVERTISE_100HALF;
+			speed_duplex = NWAY_100M_HALF;
+		}
+		if (advertising & RTL_ADVERTISED_100_FULL) {
+			tmp1 |= ADVERTISE_100FULL;
+			speed_duplex = NWAY_100M_FULL;
+		}
+
+		if (anar != tmp1) {
+			r8152_mdio_write(tp, MII_ADVERTISE, tmp1);
+			tp->mii.advertising = tmp1;
+		}
+
+		if (tp->mii.supports_gmii) {
+			u16 gbcr;
+
+			gbcr = r8152_mdio_read(tp, MII_CTRL1000);
+			tmp1 = gbcr & ~(ADVERTISE_1000FULL |
+					ADVERTISE_1000HALF);
+
+			if (advertising & RTL_ADVERTISED_1000_FULL) {
+				tmp1 |= ADVERTISE_1000FULL;
+				speed_duplex = NWAY_1000M_FULL;
+			}
+
+			if (gbcr != tmp1)
+				r8152_mdio_write(tp, MII_CTRL1000, tmp1);
+		}
+
 		bmcr = BMCR_ANENABLE | BMCR_ANRESTART;
+
+		tp->mii.force_media = 0;
 	}
 
 	if (test_and_clear_bit(PHY_RESET, &tp->flags))
 		bmcr |= BMCR_RESET;
 
-	if (tp->mii.supports_gmii)
-		r8152_mdio_write(tp, MII_CTRL1000, gbcr);
-
-	r8152_mdio_write(tp, MII_ADVERTISE, anar);
 	r8152_mdio_write(tp, MII_BMCR, bmcr);
 
 	switch (tp->version) {
@@ -4122,7 +4157,8 @@ static void rtl_hw_phy_work_func_t(struct work_struct *work)
 
 	tp->rtl_ops.hw_phy_cfg(tp);
 
-	rtl8152_set_speed(tp, tp->autoneg, tp->speed, tp->duplex);
+	rtl8152_set_speed(tp, tp->autoneg, tp->speed, tp->duplex,
+			  tp->advertising);
 
 	mutex_unlock(&tp->control);
 
@@ -4841,20 +4877,46 @@ static int rtl8152_set_link_ksettings(struct net_device *dev,
 				      const struct ethtool_link_ksettings *cmd)
 {
 	struct r8152 *tp = netdev_priv(dev);
+	u32 advertising = 0;
 	int ret;
 
 	ret = usb_autopm_get_interface(tp->intf);
 	if (ret < 0)
 		goto out;
 
+	if (test_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+		     cmd->link_modes.advertising))
+		advertising |= RTL_ADVERTISED_10_HALF;
+
+	if (test_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+		     cmd->link_modes.advertising))
+		advertising |= RTL_ADVERTISED_10_FULL;
+
+	if (test_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+		     cmd->link_modes.advertising))
+		advertising |= RTL_ADVERTISED_100_HALF;
+
+	if (test_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+		     cmd->link_modes.advertising))
+		advertising |= RTL_ADVERTISED_100_FULL;
+
+	if (test_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
+		     cmd->link_modes.advertising))
+		advertising |= RTL_ADVERTISED_1000_HALF;
+
+	if (test_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+		     cmd->link_modes.advertising))
+		advertising |= RTL_ADVERTISED_1000_FULL;
+
 	mutex_lock(&tp->control);
 
 	ret = rtl8152_set_speed(tp, cmd->base.autoneg, cmd->base.speed,
-				cmd->base.duplex);
+				cmd->base.duplex, advertising);
 	if (!ret) {
 		tp->autoneg = cmd->base.autoneg;
 		tp->speed = cmd->base.speed;
 		tp->duplex = cmd->base.duplex;
+		tp->advertising = advertising;
 	}
 
 	mutex_unlock(&tp->control);
@@ -5569,7 +5631,13 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tp->mii.phy_id = R8152_PHY_ID;
 
 	tp->autoneg = AUTONEG_ENABLE;
-	tp->speed = tp->mii.supports_gmii ? SPEED_1000 : SPEED_100;
+	tp->speed = SPEED_100;
+	tp->advertising = RTL_ADVERTISED_10_HALF | RTL_ADVERTISED_10_FULL |
+			  RTL_ADVERTISED_100_HALF | RTL_ADVERTISED_100_FULL;
+	if (tp->mii.supports_gmii) {
+		tp->speed = SPEED_1000;
+		tp->advertising |= RTL_ADVERTISED_1000_FULL;
+	}
 	tp->duplex = DUPLEX_FULL;
 
 	tp->rx_copybreak = RTL8152_RXFG_HEADSZ;
-- 
2.21.0

