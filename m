Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBD25ACC83
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbiIEHYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbiIEHYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:24:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D715143605;
        Mon,  5 Sep 2022 00:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662362439; x=1693898439;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ssnL7BukIcEKP701lJ9e0HtLSQIorRf9JYoiz28yTvU=;
  b=BWroLrIuRsIhgnE3JMgp9g9kipuDDGOVy9gJkzT7ujZlYnUMDst9VLan
   zY77+n9u0BNA1bxcUjQ89l3Fhfj7HecAfjd4OLOwLF4TK5NScuhNA3Tb7
   6PmxV8i5khdkH7Ky5Dq8kcyXI8ZCH2VmYlBlo7gZruQk7MAhO0/x4ATyg
   Py5Btz4bFk1PwuxJZ8anPXc5GOvQHu9ytHzJCyWOMSjxCcQ3ow/2DudjM
   PnwAXn9Bjt3dhfxvOF6wsnx0LTaShiqZm8Rz6R7C1NUKAHpIJEvaFFPGD
   sOTBk2Jx7CBWcq4wIlIPxS+MjP4CFZWJNR1MBfS4JISOEdgFHysTouEhR
   g==;
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="179049985"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Sep 2022 00:20:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Sep 2022 00:20:37 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 5 Sep 2022 00:20:33 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <arun.ramadoss@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [Patch net] net: phy: lan87xx: change interrupt src of link_up to comm_ready
Date:   Mon, 5 Sep 2022 12:50:17 +0530
Message-ID: <20220905072017.9839-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently phy link up/down interrupt is enabled using the
LAN87xx_INTERRUPT_MASK register. In the lan87xx_read_status function,
phy link is determined using the T1_MODE_STAT_REG register comm_ready bit.
comm_ready bit is set using the loc_rcvr_status & rem_rcvr_status.
Whenever the phy link is up, LAN87xx_INTERRUPT_SOURCE link_up bit is set
first but comm_ready bit takes some time to set based on local and
remote receiver status.
As per the current implementation, interrupt is triggered using link_up
but the comm_ready bit is still cleared in the read_status function. So,
link is always down.  Initially tested with the shared interrupt
mechanism with switch and internal phy which is working, but after
implementing interrupt controller it is not working.
It can fixed either by updating the read_status function to read from
LAN87XX_INTERRUPT_SOURCE register or enable the interrupt mask for
comm_ready bit. But the validation team recommends the use of comm_ready
for link detection.
This patch fixes by enabling the comm_ready bit for link_up in the
LAN87XX_INTERRUPT_MASK_2 register (MISC Bank) and link_down in
LAN87xx_INTERRUPT_MASK register.

Fixes: 8a1b415d70b7 ("net: phy: added ethtool master-slave configuration
		     support")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 58 +++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index d4c93d59bc53..8569a545e0a3 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -28,12 +28,16 @@
 
 /* Interrupt Source Register */
 #define LAN87XX_INTERRUPT_SOURCE                (0x18)
+#define LAN87XX_INTERRUPT_SOURCE_2              (0x08)
 
 /* Interrupt Mask Register */
 #define LAN87XX_INTERRUPT_MASK                  (0x19)
 #define LAN87XX_MASK_LINK_UP                    (0x0004)
 #define LAN87XX_MASK_LINK_DOWN                  (0x0002)
 
+#define LAN87XX_INTERRUPT_MASK_2                (0x09)
+#define LAN87XX_MASK_COMM_RDY			BIT(10)
+
 /* MISC Control 1 Register */
 #define LAN87XX_CTRL_1                          (0x11)
 #define LAN87XX_MASK_RGMII_TXC_DLY_EN           (0x4000)
@@ -424,17 +428,55 @@ static int lan87xx_phy_config_intr(struct phy_device *phydev)
 	int rc, val = 0;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
-		/* unmask all source and clear them before enable */
-		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, 0x7FFF);
+		/* clear all interrupt */
+		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
+		if (rc < 0)
+			return rc;
+
 		rc = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
-		val = LAN87XX_MASK_LINK_UP | LAN87XX_MASK_LINK_DOWN;
+		if (rc < 0)
+			return rc;
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+				 PHYACC_ATTR_BANK_MISC,
+				 LAN87XX_INTERRUPT_MASK_2, val);
+		if (rc < 0)
+			return rc;
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+				 PHYACC_ATTR_BANK_MISC,
+				 LAN87XX_INTERRUPT_SOURCE_2, 0);
+		if (rc < 0)
+			return rc;
+
+		/* enable link down and comm ready interrupt */
+		val = LAN87XX_MASK_LINK_DOWN;
 		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
+		if (rc < 0)
+			return rc;
+
+		val = LAN87XX_MASK_COMM_RDY;
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+				 PHYACC_ATTR_BANK_MISC,
+				 LAN87XX_INTERRUPT_MASK_2, val);
 	} else {
 		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
-		if (rc)
+		if (rc < 0)
 			return rc;
 
 		rc = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
+		if (rc < 0)
+			return rc;
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+				 PHYACC_ATTR_BANK_MISC,
+				 LAN87XX_INTERRUPT_MASK_2, val);
+		if (rc < 0)
+			return rc;
+
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+				 PHYACC_ATTR_BANK_MISC,
+				 LAN87XX_INTERRUPT_SOURCE_2, 0);
 	}
 
 	return rc < 0 ? rc : 0;
@@ -444,6 +486,14 @@ static irqreturn_t lan87xx_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status;
 
+	irq_status  = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+				  PHYACC_ATTR_BANK_MISC,
+				  LAN87XX_INTERRUPT_SOURCE_2, 0);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
 	irq_status = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
 	if (irq_status < 0) {
 		phy_error(phydev);

base-commit: aa51b80e1af47b3781abb1fb1666445a7616f0cd
-- 
2.36.1

