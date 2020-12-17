Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426432DD19D
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 13:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgLQMmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 07:42:42 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:36117 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgLQMmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 07:42:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608208961; x=1639744961;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=bRNn2cKKVkP687Vsu0s5gvc3xzb16ardnOkQSullQtk=;
  b=LuBL/sQ4/SFftLjSj5DanR8uIfqOrf/QABYZXYaH1mLCeTAN9dslH7wd
   FirvzWo++eIq8NEIVVJNbJCGQivt3Sal24+NaMOamv8kXKnlZL5lpATv+
   IMts40btBs0wZQHfsda64ELso7l1q67086WWaX1i29CJrhGVBdGEpgu9x
   wQWzlz6L4IGQ8TO7rl4ZUncp0a9roOTwzEB/gTiAwirv8Swtm46Mhqn9N
   oogjTQpDOvd6Vn4Gxf2pXaQ9XlerswtkKAuXWR4h8NDi19eoVb5KiGKa+
   fnGuJHuThAsBZlA6FMIhBXlHg0+nyqiGBZZ01SLYoussvoFqWkkWanNZz
   w==;
IronPort-SDR: hdChS8Y01z+zs6M6xBJeP2FXGGKCvKw0j+fcnxOlXrD/zvqdoQYq1RlqoTUmZxP6GVtNwbGmpq
 O4zj7zAOoGbk0w+jFWhmxG0IthYFNTKm5iW/qpSzmF/AzdU9WgzdYo7j8JB5V2o5neM8RMmZwu
 gWcFPDgN3b/grubdVr/tpkKYRKNC8j0yedz/HsTNne0XzJ7nqZpNV/z/aB2/abXQjElhZNc5wV
 qpnpPgWWFXZr2ODsZjOT+z5+pSs6GHpgAcf1XIIiNf67RtBIOMjZXtOLRalDQBfCEcnMXyc9yJ
 2q8=
X-IronPort-AV: E=Sophos;i="5.78,428,1599548400"; 
   d="scan'208";a="97451871"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2020 05:41:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 17 Dec 2020 05:41:25 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 17 Dec 2020 05:41:22 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <marex@denx.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <richardcochran@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v4 net-next 1/2] net: phy: mchp: Add interrupt support for Link up and Link down to LAN8814 phy
Date:   Thu, 17 Dec 2020 18:11:19 +0530
Message-ID: <20201217124119.8347-1-Divya.Koppera@microchip.com>
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

v3 -> v4
* Changed MAC API call to phy_trigger_machine.
---
 drivers/net/phy/micrel.c | 65 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 54e0d75203da..3a9d87f5d7c5 100644
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
+		phy_trigger_machine(phydev);
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

