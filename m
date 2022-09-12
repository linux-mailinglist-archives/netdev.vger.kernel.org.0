Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC555B61EB
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 21:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiILTwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 15:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiILTwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 15:52:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08FA40565;
        Mon, 12 Sep 2022 12:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663012353; x=1694548353;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aeF6mv0+/RcFmExnf1mbExEL9JtkGGpVBxUBvEWAbKk=;
  b=t1WbjrEWPvx9eSwsapMVhhjvkuH6z8mAYH2ljiCJMqnF3WvrG4T83SLb
   ypznEHALCCjf3zO3lh4ezkO9Lf5GbqepR8yWoNKd0Y5lMe1XYJWjgUepV
   KekWfbrkEVaePEEGBQAa+JeCY7j1ZrVggeAeUT27jTnnZGdiSqJ3fuUMS
   MkeUzLx9qIPywE8vXfFatU6JBYfH9dNOtfe85mQE4214o3t2kMZB1HgKP
   sGRkC/yeIHOj16lmtTlU3hi2bqNlE0hi1xjTJ4gPAn668wcuh5ZnmhXF2
   u6T05zihhtZzdvgpPUuMbRQpw96IWaYucZYGI39R0aiOuUXDoey4HdXrO
   w==;
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="190517800"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Sep 2022 12:52:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 12 Sep 2022 12:52:32 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 12 Sep 2022 12:52:30 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: phy: micrel: Add interrupts support for LAN8804 PHY
Date:   Mon, 12 Sep 2022 21:56:50 +0200
Message-ID: <20220912195650.466518-1-horatiu.vultur@microchip.com>
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

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 55 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 7b8c5c8d013e..98e9bc101d96 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2676,6 +2676,59 @@ static int lan8804_config_init(struct phy_device *phydev)
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
+	/* Change interrupt polarity */
+	phy_write(phydev, LAN8804_CONTROL, LAN8804_CONTROL_INTR_POLARITY);
+
+	/* Change interrupt buffer type */
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
@@ -3137,6 +3190,8 @@ static struct phy_driver ksphy_driver[] = {
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

