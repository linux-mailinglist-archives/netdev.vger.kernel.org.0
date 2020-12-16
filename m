Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A7A2DC312
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 16:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgLPP0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 10:26:51 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47353 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgLPP0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 10:26:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608132412; x=1639668412;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=NZRXzJLvFSlGvYY7382RbNj9Q3tzcWrpRK50jncbSOU=;
  b=2Z5uQu1J0DBcyPwLdZkgkx/5v7+X8KXmbNrCWbXFtrnUKWQ7sTvjULAP
   mrIjANZ/RoGQG9yFFZfo4G/QT43e2PSzYonXHCN2twkAMp41jdqSQxAV6
   nm4WWTsxCMxiLxlACe+MAFgH1TyCXxtlrjpi2RQrlu6gfzwx/4shSI6za
   kTdWlaCft5piPdPO77ohFQsQd1h6bqkbmULetMadvvhmFFa+fIMJbKwLF
   WS5jrI+zlEjjTTALc54vvGmB1Eb9FyYWEav3Fkx6zRFDjeP+0Rr4gkXy4
   7C7joDZmP9Xe6xx8p49Xw9ckaC4aQfIzs5JOwvj2MMaa6ruW6VyndpwPc
   A==;
IronPort-SDR: sQJlFaes5K8nxlu0yN7CKS0ax9uoLbe2aUhTWJQxWwaXAbkxI1U8t9N/TFJqV09xMVzty524DP
 edOWP68+f4EkI7Cc5+zHFdjnNWErek93DNmSnmkJed3WPy2A75os5znaT+4iysAsyPsn1BWQpq
 Y0ULLwzwblLW97xLspXLoioFVqCXbI/s2Xa+DrOn68R9p0oPFDASNgif62rYU2pP9b5+XGo1LR
 r5nf+umm/i2hp4Gt9WYmkA5lcazoCR4IWVGFBTg30a69LE4FGzn2vawh8iyBQTqWaLjIQFYm1h
 ZQg=
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="102440265"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Dec 2020 08:25:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 08:25:35 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 16 Dec 2020 08:25:31 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <marex@denx.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v3 net-next 1/2] net: phy: mchp: Add interrupt support for Link up and Link down to LAN8814 phy
Date:   Wed, 16 Dec 2020 20:55:28 +0530
Message-ID: <20201216152528.6457-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add supports for Link up and Link down interrupts
to LAN8814 phy.

Signed-off-by: Divya Koppera<divya.koppera@microchip.com>
---
v1 -> v2
* Fixed warnings
  Reported-by: kernel test robot <lkp@intel.com>

v2 -> v3
* Splitting 1588 support patch to Link up/down patch
  and 1588 support patch.
---
 drivers/net/phy/micrel.c | 65 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 54e0d75203da..10cb2c45be36 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -27,6 +27,14 @@
 #include <linux/of.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/ptp_clock.h>
+#include <linux/ptp_classify.h>
+#include <linux/net_tstamp.h>
+#include <linux/netdevice.h>
+#include <linux/if_vlan.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
 
 /* Operation Mode Strap Override */
 #define MII_KSZPHY_OMSO				0x16
@@ -53,6 +61,31 @@
 #define	KSZPHY_INTCS_STATUS			(KSZPHY_INTCS_LINK_DOWN_STATUS |\
 						 KSZPHY_INTCS_LINK_UP_STATUS)
 
+/* Lan8814 general Interrupt control/status reg in GPHY specific block. */
+#define LAN8814_INTC				0x18
+#define LAN8814_INTC_JABBER			BIT(7)
+#define LAN8814_INTC_RECEIVE_ERR		BIT(6)
+#define LAN8814_INTC_PAGE_RECEIVE		BIT(5)
+#define LAN8814_INTC_PARELLEL			BIT(4)
+#define LAN8814_INTC_LINK_PARTNER_ACK		BIT(3)
+#define LAN8814_INTC_LINK_DOWN			BIT(2)
+#define LAN8814_INTC_REMOTE_FAULT		BIT(1)
+#define LAN8814_INTC_LINK_UP			BIT(0)
+#define LAN8814_INTC_ALL			(LAN8814_INTC_LINK_UP |\
+						 LAN8814_INTC_LINK_DOWN)
+
+#define LAN8814_INTS				0x1B
+#define LAN8814_INTS_JABBER			BIT(7)
+#define LAN8814_INTS_RECEIVE_ERR		BIT(6)
+#define LAN8814_INTS_PAGE_RECEIVE		BIT(5)
+#define LAN8814_INTS_PARELLEL			BIT(4)
+#define LAN8814_INTS_LINK_PARTNER_ACK		BIT(3)
+#define LAN8814_INTS_LINK_DOWN			BIT(2)
+#define LAN8814_INTS_REMOTE_FAULT		BIT(1)
+#define LAN8814_INTS_LINK_UP			BIT(0)
+#define LAN8814_INTS_ALL			(LAN8814_INTS_LINK_UP |\
+						 LAN8814_INTS_LINK_DOWN)
+
 /* PHY Control 1 */
 #define	MII_KSZPHY_CTRL_1			0x1e
 
@@ -76,6 +109,9 @@
 #define MII_KSZPHY_TX_DATA_PAD_SKEW             0x106
 
 #define PS_TO_REG				200
+#define KSZ_EXT_PAGE_ACCESS_CONTROL		0x16
+#define KSZ_EXT_PAGE_ACCESS_ADDRESS_DATA	0x17
+#define OFF_PTP_CONTROL				32 /* PTPv1 only */
 
 struct kszphy_hw_stat {
 	const char *string;
@@ -149,6 +185,33 @@ static int kszphy_extended_read(struct phy_device *phydev,
 	return phy_read(phydev, MII_KSZPHY_EXTREG_READ);
 }
 
+static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, LAN8814_INTS);
+	if (irq_status < 0)
+		return IRQ_NONE;
+
+	if (irq_status & LAN8814_INTS_ALL)
+		phy_mac_interrupt(phydev);
+
+	return IRQ_HANDLED;
+}
+
+static int lan8814_config_intr(struct phy_device *phydev)
+{
+	int temp;
+
+	/* enable / disable interrupts */
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		temp = LAN8814_INTC_ALL;
+	else
+		temp = 0;
+
+	return phy_write(phydev, LAN8814_INTC, temp);
+}
+
 static int kszphy_ack_interrupt(struct phy_device *phydev)
 {
 	/* bit[7..0] int status, which is a read and clear register. */
@@ -1360,6 +1423,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= kszphy_resume,
+	.config_intr	= lan8814_config_intr,
+	.handle_interrupt = lan8814_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_KSZ9131,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.17.1

