Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3066C47BA6A
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhLUHFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:05:10 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:50397 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbhLUHFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 02:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640070310; x=1671606310;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=5G6h9wxbqMm4Ivne7mWsugvtJBQ8wJiQSNIs3Ka0zaQ=;
  b=a+5Q311zm3BofWKODZ+4JtEzsDSFe1bfsnOLR9FcPJttYx0mhjkjKHSg
   8jQU+ciacV8LcnIDvvnSzKMlThFWsobqBPPjiohm2CrTltnqcKH6t/y9K
   1aX6Y12pwZYV+nYCeievP5vXqvBUcZ3BqHIKUCV9lphStzetVQe0OUbJe
   2brQFO4w4ME/A1Gn8vE2dgUt9yulhGzJiRd+HDeDhOWwm7HGRKN3XUWX3
   ZQYhvAi4i3D7S5sj8n0BmCz5yieQKVBJ/P/mD6pD0nEIbWhVWRgMX4FrD
   y40mOkFRLVgzM2tHuqRJQPzy9WNAABRhinmlE3jyl5AfmuPjQ4aqId445
   g==;
IronPort-SDR: shFspu9ocBnmkezWIIenpkT0W2B2dD1zXcHSZdnd3gi8EAkKUsLhlkTEgrFVhkaFNQ2357G44i
 rppUfFW7GNGTNGJuqR5wv4j06qqf3Fl+w6Vw8+/RwItoax6NbnEEyW9nrJF0vqb8s9oAsb+fj4
 LdJRjmWk7u5xNFPx0HaCs2DDhwT67cxkjzpoZIIexa/uqQu11O3Qu+OBSqBA+RBx8Yq7sZFWzk
 oJKi7Pl5yZ7Y123+cQshuSljO4GTHoBQn0Ss4XR6cTMEK7TvGomzQMuEOC+p3XWKH/p1Vp5WQM
 9WrNlpeIdM1/9ylqA2b0k/nh
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="147334244"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2021 00:05:09 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 21 Dec 2021 00:05:08 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 21 Dec 2021 00:05:06 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next] net: phy: micrel: Adding interrupt support for Link up/Link down in LAN8814 Quad phy
Date:   Tue, 21 Dec 2021 12:35:02 +0530
Message-ID: <20211221070502.14811-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for Link up or Link down
interrupt support in LAN8814 Quad phy.

Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
 drivers/net/phy/micrel.c | 71 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 44a24b99c894..46931020ef84 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -66,6 +66,23 @@
 #define KSZ8081_LMD_SHORT_INDICATOR		BIT(12)
 #define KSZ8081_LMD_DELTA_TIME_MASK		GENMASK(8, 0)
 
+/* Lan8814 general Interrupt control/status reg in GPHY specific block. */
+#define LAN8814_INTC				0x18
+#define LAN8814_INTC_LINK_DOWN			BIT(2)
+#define LAN8814_INTC_LINK_UP			BIT(0)
+#define LAN8814_INTC_LINK			(LAN8814_INTC_LINK_UP |\
+						 LAN8814_INTC_LINK_DOWN)
+
+#define LAN8814_INTS				0x1B
+#define LAN8814_INTS_LINK_DOWN			BIT(2)
+#define LAN8814_INTS_LINK_UP			BIT(0)
+#define LAN8814_INTS_LINK			(LAN8814_INTS_LINK_UP |\
+						 LAN8814_INTS_LINK_DOWN)
+
+#define LAN8814_INTR_CTRL_REG			0x34
+#define LAN8814_INTR_CTRL_REG_POLARITY		BIT(1)
+#define LAN8814_INTR_CTRL_REG_INTR_ENABLE	BIT(0)
+
 /* PHY Control 1 */
 #define MII_KSZPHY_CTRL_1			0x1e
 #define KSZ8081_CTRL1_MDIX_STAT			BIT(4)
@@ -1620,6 +1637,58 @@ static int lan8804_config_init(struct phy_device *phydev)
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
+	if (!(irq_status & LAN8814_INTS_LINK))
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
+		err =  phy_write(phydev, LAN8814_INTC, LAN8814_INTC_LINK);
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
@@ -1802,6 +1871,8 @@ static struct phy_driver ksphy_driver[] = {
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

