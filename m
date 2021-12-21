Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EAB47BECE
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 12:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbhLULWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 06:22:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25992 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhLULWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 06:22:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640085745; x=1671621745;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=xXxa9lxh+lcHQD/PM+FEPQljZ3NTW38sGBoGucSqFLg=;
  b=kqkFjHGvtY6KWWM6dbo8BN2UX0YMLc2MSY21puunpAiY0hNBiO7hsbTU
   sfZcjNcIpLMCiDONYIjp7BqVmxBrU25u6E6Er2/wMIOn27zAWJJZy9Tc3
   6NnYV2hIAdwW2aIivpLhMFmR/2kEfqenCL/4+qxn6Chps8qcy3JL3if07
   mZ4EJbVF9fhN/3jc2Bh9HD/JY5wm2tFcLemeIzpBzAuIUqiUibUuiZNgp
   B6GRECI1FHowJJ9C953dKf99WvJ1rhLy3u6fz/Z+rs+PlEMOYGjESIgl4
   rcZ2CBY1ayrMk4EISomnTJ6QatFGZQ3cQsNS8CH19Yvoy+8Z1sqChmRSf
   A==;
IronPort-SDR: hwrpSQBm71ZkeVij1/i15FECQaLCKoMatKhW/qhgDMBlqKABR6QchprxedpzMGTKjAf9uxZrtX
 DiVDx0L8S6sJdbnSuxTA9Lz9UgO7UjtVqYo1sLPdcwp1QvwnwmM6edk0zn2ufSrBxtITdlGqh7
 j8WF7SSAi+sextZti36oGbGYgXYTJ5jfZ1TXFQJ8ODmoIUN8dP+XiZb+5p8eQ9emesB+qP+pYv
 N/WeJCqF6dLxDc/55XJ4uZ4ar3DXZusxL0e3UMwbZTly0em1e8jFEcxWj6GBc+SGpqdeHlRoZY
 1qAFcT73M3hZHcUo0h6hQ7zX
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="147359666"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2021 04:22:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 21 Dec 2021 04:22:23 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 21 Dec 2021 04:22:20 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v2 net-next] net: phy: micrel: Adding interrupt support for Link up/Link down in LAN8814 Quad phy
Date:   Tue, 21 Dec 2021 16:52:17 +0530
Message-ID: <20211221112217.9502-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for Link up or Link down
interrupt support in LAN8814 Quad phy

Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
v1 -> v2
* Defining Common Macro for Control and status bits of
  Link up, Link Down and sharing them across Interrupt
  control and Interrupt status registers.
---
 drivers/net/phy/micrel.c | 67 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 44a24b99c894..c6a97fcca0e6 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -66,6 +66,19 @@
 #define KSZ8081_LMD_SHORT_INDICATOR		BIT(12)
 #define KSZ8081_LMD_DELTA_TIME_MASK		GENMASK(8, 0)
 
+/* Lan8814 general Interrupt control/status reg in GPHY specific block. */
+#define LAN8814_INTC				0x18
+#define LAN8814_INTS				0x1B
+
+#define LAN8814_INT_LINK_DOWN			BIT(2)
+#define LAN8814_INT_LINK_UP			BIT(0)
+#define LAN8814_INT_LINK			(LAN8814_INT_LINK_UP |\
+						 LAN8814_INT_LINK_DOWN)
+
+#define LAN8814_INTR_CTRL_REG			0x34
+#define LAN8814_INTR_CTRL_REG_POLARITY		BIT(1)
+#define LAN8814_INTR_CTRL_REG_INTR_ENABLE	BIT(0)
+
 /* PHY Control 1 */
 #define MII_KSZPHY_CTRL_1			0x1e
 #define KSZ8081_CTRL1_MDIX_STAT			BIT(4)
@@ -1620,6 +1633,58 @@ static int lan8804_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, LAN8814_INTS);
+	if (irq_status < 0)
+		return IRQ_NONE;
+
+	if (!(irq_status & LAN8814_INT_LINK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
+static int lan8814_ack_interrupt(struct phy_device *phydev)
+{
+	/* bit[12..0] int status, which is a read and clear register. */
+	int rc;
+
+	rc = phy_read(phydev, LAN8814_INTS);
+
+	return (rc < 0) ? rc : 0;
+}
+
+static int lan8814_config_intr(struct phy_device *phydev)
+{
+	int err;
+
+	lanphy_write_page_reg(phydev, 4, LAN8814_INTR_CTRL_REG,
+			      LAN8814_INTR_CTRL_REG_POLARITY |
+			      LAN8814_INTR_CTRL_REG_INTR_ENABLE);
+
+	/* enable / disable interrupts */
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = lan8814_ack_interrupt(phydev);
+		if (err)
+			return err;
+
+		err =  phy_write(phydev, LAN8814_INTC, LAN8814_INT_LINK);
+	} else {
+		err =  phy_write(phydev, LAN8814_INTC, 0);
+		if (err)
+			return err;
+
+		err = lan8814_ack_interrupt(phydev);
+	}
+
+	return err;
+}
+
 static struct phy_driver ksphy_driver[] = {
 {
 	.phy_id		= PHY_ID_KS8737,
@@ -1802,6 +1867,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= kszphy_resume,
+	.config_intr	= lan8814_config_intr,
+	.handle_interrupt = lan8814_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_LAN8804,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.17.1

