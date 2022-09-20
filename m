Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FFF5BE88F
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiITOTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiITOS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:18:57 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D504D12D37;
        Tue, 20 Sep 2022 07:16:25 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 99DFE1CAC;
        Tue, 20 Sep 2022 16:16:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1663683383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gh3D8swvqj5TQg2FPjFgtqo6TQ5NaUzedsXmtNZ0YwI=;
        b=GkjdknO2rhXnFqOdG4acwaiusMPPj4fsgTGv1x7Gwt7aVx5aWmx0M7Anje21KgbvgSr62g
        PwbUP5GCVy3RgzLHFj2yox1fHJ61IvHKoxoJyBcLP+9Hkp1a/GnyUC23wpK4UUnl4CsTUH
        Kb9Jqe7GiKJemJFQOyCLoC5BOCxP2wvHjxVU+s0VUJu/7SAv2jgpWJk6blTWswduv7R5GN
        bxuz/WpXgx3txiJTxFifmj6RPOis8vdNHKM+2gIRjn3P4gbAP63UzMQEfmvEGIAm4ZhRCg
        qgD2XEcO5nZZxcDc689ZiofYQmE9/J7O3mZhs/dN+F9FEkYq2zP6Ld89GOVlTg==
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Divya Koppera <Divya.Koppera@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net] net: phy: micrel: fix shared interrupt on LAN8814
Date:   Tue, 20 Sep 2022 16:16:19 +0200
Message-Id: <20220920141619.808117-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ece19502834d ("net: phy: micrel: 1588 support for LAN8814
phy") the handler always returns IRQ_HANDLED, except in an error case.
Before that commit, the interrupt status register was checked and if
it was empty, IRQ_NONE was returned. Restore that behavior to play nice
with the interrupt line being shared with others.

Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/micrel.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 98e9bc101d96..21b6facf6e76 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2732,16 +2732,19 @@ static int lan8804_config_intr(struct phy_device *phydev)
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status, tsu_irq_status;
+	int ret = IRQ_NONE;
 
 	irq_status = phy_read(phydev, LAN8814_INTS);
-	if (irq_status > 0 && (irq_status & LAN8814_INT_LINK))
-		phy_trigger_machine(phydev);
-
 	if (irq_status < 0) {
 		phy_error(phydev);
 		return IRQ_NONE;
 	}
 
+	if (irq_status & LAN8814_INT_LINK) {
+		phy_trigger_machine(phydev);
+		ret = IRQ_HANDLED;
+	}
+
 	while (1) {
 		tsu_irq_status = lanphy_read_page_reg(phydev, 4,
 						      LAN8814_INTR_STS_REG);
@@ -2750,12 +2753,15 @@ static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 		    (tsu_irq_status & (LAN8814_INTR_STS_REG_1588_TSU0_ |
 				       LAN8814_INTR_STS_REG_1588_TSU1_ |
 				       LAN8814_INTR_STS_REG_1588_TSU2_ |
-				       LAN8814_INTR_STS_REG_1588_TSU3_)))
+				       LAN8814_INTR_STS_REG_1588_TSU3_))) {
 			lan8814_handle_ptp_interrupt(phydev);
-		else
+			ret = IRQ_HANDLED;
+		} else {
 			break;
+		}
 	}
-	return IRQ_HANDLED;
+
+	return ret;
 }
 
 static int lan8814_ack_interrupt(struct phy_device *phydev)
-- 
2.30.2

