Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5835B7318
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 17:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbiIMO7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 10:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235092AbiIMO7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 10:59:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBFC63F13;
        Tue, 13 Sep 2022 07:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663079323; x=1694615323;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r++yIB0Zi49RlX5j8upgavcrEl7RW8kP06fMbAaKCzc=;
  b=T+RhTZ4CQ+tv6TyfQqYRHHv2AHu9iygKCxN5Dzi/YXkyxTC08ZGdg4cH
   08BYxhsjs7S5f63sJkcS5zhHjYuTeok9q02DgfDgZdZ43GBqKyV9r8q1P
   GU+tWJKcDRTdQ2Bf/lxUCp5WMjEcKL/VUxLi2n0ens+3E3brwNA548cJv
   goZB2soJqGHEtPIKcfHIuP0/5E3G51M6h/tX3+bPCIoVPY24eGwJxPc8j
   KDKpsP9vDgOw83k4/UEs2DaIMaUILbbe46/3iJr3x6gwjImv0+VJY+kU9
   vQa6kIMUctzsn7/hkLqwOwa4XKYAxEyIqCc2iabtClYGRzQnUh2F8v9zU
   A==;
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="173638038"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 07:25:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 07:25:15 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 13 Sep 2022 07:25:12 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2] net: phy: micrel: Add interrupts support for LAN8804 PHY
Date:   Tue, 13 Sep 2022 16:29:26 +0200
Message-ID: <20220913142926.816746-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
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

Add support for interrupts for LAN8804 PHY.

Tested-by: Michael Walle <michael@walle.cc> # on kontron-kswitch-d10
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v1->v2:
- add Tested-by and Reviewed-by tags
- add better comments
---
 drivers/net/phy/micrel.c | 62 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 7b8c5c8d013e..6ec2d8fec78a 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2676,6 +2676,66 @@ static int lan8804_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+static irqreturn_t lan8804_handle_interrupt(struct phy_device *phydev)
+{
+	int status;
+
+	status = phy_read(phydev, LAN8814_INTS);
+	if (status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (status > 0)
+		phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
+#define LAN8804_OUTPUT_CONTROL			25
+#define LAN8804_OUTPUT_CONTROL_INTR_BUFFER	BIT(14)
+#define LAN8804_CONTROL				31
+#define LAN8804_CONTROL_INTR_POLARITY		BIT(14)
+
+static int lan8804_config_intr(struct phy_device *phydev)
+{
+	int err;
+
+	/* This is an internal PHY of lan966x and is not possible to change the
+	 * polarity on the GIC found in lan966x, therefore change the polarity
+	 * of the interrupt in the PHY from being active low instead of active
+	 * high.
+	 */
+	phy_write(phydev, LAN8804_CONTROL, LAN8804_CONTROL_INTR_POLARITY);
+
+	/* By default interrupt buffer is open-drain in which case the interrupt
+	 * can be active only low. Therefore change the interrupt buffer to be
+	 * push-pull to be able to change interrupt polarity
+	 */
+	phy_write(phydev, LAN8804_OUTPUT_CONTROL,
+		  LAN8804_OUTPUT_CONTROL_INTR_BUFFER);
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		err = phy_read(phydev, LAN8814_INTS);
+		if (err < 0)
+			return err;
+
+		err =  phy_write(phydev, LAN8814_INTC, LAN8814_INT_LINK);
+		if (err)
+			return err;
+	} else {
+		err =  phy_write(phydev, LAN8814_INTC, 0);
+		if (err)
+			return err;
+
+		err = phy_read(phydev, LAN8814_INTS);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status, tsu_irq_status;
@@ -3137,6 +3197,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= kszphy_resume,
+	.config_intr	= lan8804_config_intr,
+	.handle_interrupt = lan8804_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_KSZ9131,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.33.0

