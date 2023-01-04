Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B82C65DCE2
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240142AbjADThf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbjADThe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:37:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC53F6;
        Wed,  4 Jan 2023 11:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672861052; x=1704397052;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FdK1P59eiaaPYotGf2Hn1FrUkMeoO0z3NBfLunufFTw=;
  b=AJz8jZBz/Wo1n73Ko4w75TTx7sDvuXb5NiYqUE5AXxtjP6OtRFoQGZHH
   17J+0kGBxtARuWJcdy9YSz1GmDUL1bo4p2FeK8KhQZ++CFDj3mIM7YXPO
   OF/MzG4Lau6Fd/0l2LA/Erv3lE3xSZsd/zT/i3Ow1Cx0dy5dV9YTvlyCJ
   c7c2bPpqq5KRxzBrQA26dozuzaPrJcWoSkQcuDMPnwq+05ifsggy2wSXJ
   ZdjRP5kZO36jG467z/3Za/jYQ+I3jG+yp8YhT9ID5fh5dRwQDmVY2PFn3
   BjYZV2q8V9pVYIsJvflUKn30ZJSqCorBMWKhsAXd5eldnVJehEXcfsKdK
   A==;
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="194266433"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2023 12:37:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 12:37:28 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 12:37:26 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        "Horatiu Vultur" <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: phy: micrel: Change handler interrupt for lan8814
Date:   Wed, 4 Jan 2023 20:42:18 +0100
Message-ID: <20230104194218.3785229-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lan8814 represents a package of 4 PHYs. All of them are sharing the
same interrupt line. So when a link was going down/up or a frame was
timestamped, then the interrupt handler of all the PHYs was called.
Which is all fine and expected but the problem is the way the handler
interrupt works.
Basically if one of the PHYs timestamp a frame, then all the other 3
PHYs were polling the status of the interrupt until that PHY actually
cleared the interrupt by reading the timestamp.
The reason of polling was in case another PHY was also timestamping a
frame at the same time, it could miss this interrupt. But this is not
the right approach, because it is the interrupt controller who needs to
call the interrupt handlers again if the interrupt line is still
active.
Therefore change this such when the interrupt handler is called check
only if the interrupt is for itself, otherwise just exit. In this way
save CPU usage.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 26ce0c5defcdd..2243ad1b88e70 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2794,13 +2794,11 @@ static void lan8814_get_rx_ts(struct kszphy_ptp_priv *ptp_priv)
 	} while (PTP_CAP_INFO_RX_TS_CNT_GET_(reg) > 0);
 }
 
-static void lan8814_handle_ptp_interrupt(struct phy_device *phydev)
+static void lan8814_handle_ptp_interrupt(struct phy_device *phydev, u16 status)
 {
 	struct kszphy_priv *priv = phydev->priv;
 	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
-	u16 status;
 
-	status = lanphy_read_page_reg(phydev, 5, PTP_TSU_INT_STS);
 	if (status & PTP_TSU_INT_STS_PTP_TX_TS_EN_)
 		lan8814_get_tx_ts(ptp_priv);
 
@@ -2899,8 +2897,8 @@ static int lan8804_config_intr(struct phy_device *phydev)
 
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
-	int irq_status, tsu_irq_status;
 	int ret = IRQ_NONE;
+	int irq_status;
 
 	irq_status = phy_read(phydev, LAN8814_INTS);
 	if (irq_status < 0) {
@@ -2913,20 +2911,13 @@ static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 		ret = IRQ_HANDLED;
 	}
 
-	while (1) {
-		tsu_irq_status = lanphy_read_page_reg(phydev, 4,
-						      LAN8814_INTR_STS_REG);
-
-		if (tsu_irq_status > 0 &&
-		    (tsu_irq_status & (LAN8814_INTR_STS_REG_1588_TSU0_ |
-				       LAN8814_INTR_STS_REG_1588_TSU1_ |
-				       LAN8814_INTR_STS_REG_1588_TSU2_ |
-				       LAN8814_INTR_STS_REG_1588_TSU3_))) {
-			lan8814_handle_ptp_interrupt(phydev);
-			ret = IRQ_HANDLED;
-		} else {
+	while (true) {
+		irq_status = lanphy_read_page_reg(phydev, 5, PTP_TSU_INT_STS);
+		if (!irq_status)
 			break;
-		}
+
+		lan8814_handle_ptp_interrupt(phydev, irq_status);
+		ret = IRQ_HANDLED;
 	}
 
 	return ret;
-- 
2.38.0

