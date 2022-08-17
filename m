Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECCF596E80
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 14:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239462AbiHQMdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 08:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238854AbiHQMdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:33:09 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043A0D54;
        Wed, 17 Aug 2022 05:33:06 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1F11A1C0008;
        Wed, 17 Aug 2022 12:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660739585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R3uwO/NLqiqs5GMimReLDw1QptwLULET5iPOIJMtdzQ=;
        b=XBLAAZdHdwZ2Gc2wWHfLLcWI6Z1cfEShR3sgmYiwpRft08s3YxbQynSx4gLAPRThBvk9oZ
        Mv3fLkZoVbzeNf+kKclkrWgasVxTwEMQjqrtEMX+69tDm8hX0cqUp/9HX/HCflLnSkYmZb
        Jpp24UVxD8aTzvSrs6S7+a5hzmhb9LnTGVaWfcvuyDDlYl91DS0e7LDpoccCA0FX4qRObB
        t3RTQEqUfLe1/O8ie3Io3dRv3bM+o7PH1PlYe7qmb1EWGQz+AieP1fw1RKLAP8QmAJ3VgR
        M//2EfGiM9lpTw4LKjtUuJohgACwB8YZ7rvqugpvO9XE739vkf/5CsEqz2/ASQ==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next RESEND v4 3/4] net: phy: Add helper to derive the number of ports from a phy mode
Date:   Wed, 17 Aug 2022 14:32:54 +0200
Message-Id: <20220817123255.111130-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220817123255.111130-1-maxime.chevallier@bootlin.com>
References: <20220817123255.111130-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some phy modes such as QSGMII multiplex several MAC<->PHY links on one
single physical interface. QSGMII used to be the only one supported, but
other modes such as QUSGMII also carry multiple links.

This helper allows getting the number of links that are multiplexed
on a given interface.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V1->V2 : New patch
V2->V3 : Made PHY_INTERFACE_MODE_INTERNAL 1 port, and added the MAX
case.
V3->V4 : No change

 drivers/net/phy/phy-core.c | 52 ++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h        |  2 ++
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 1f2531a1a876..f8ec12d3d6ae 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -74,6 +74,58 @@ const char *phy_duplex_to_str(unsigned int duplex)
 }
 EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 
+/**
+ * phy_interface_num_ports - Return the number of links that can be carried by
+ *			     a given MAC-PHY physical link. Returns 0 if this is
+ *			     unknown, the number of links else.
+ *
+ * @interface: The interface mode we want to get the number of ports
+ */
+int phy_interface_num_ports(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_NA:
+		return 0;
+	case PHY_INTERFACE_MODE_INTERNAL:
+	case PHY_INTERFACE_MODE_MII:
+	case PHY_INTERFACE_MODE_GMII:
+	case PHY_INTERFACE_MODE_TBI:
+	case PHY_INTERFACE_MODE_REVMII:
+	case PHY_INTERFACE_MODE_RMII:
+	case PHY_INTERFACE_MODE_REVRMII:
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_RTBI:
+	case PHY_INTERFACE_MODE_XGMII:
+	case PHY_INTERFACE_MODE_XLGMII:
+	case PHY_INTERFACE_MODE_MOCA:
+	case PHY_INTERFACE_MODE_TRGMII:
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_SMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+	case PHY_INTERFACE_MODE_5GBASER:
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_25GBASER:
+	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_100BASEX:
+	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_XAUI:
+		return 1;
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
+		return 4;
+	case PHY_INTERFACE_MODE_MAX:
+		WARN_ONCE(1, "PHY_INTERFACE_MODE_MAX isn't a valid interface mode");
+		return 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phy_interface_num_ports);
+
 /* A mapping of all SUPPORTED settings to speed/duplex.  This table
  * must be grouped by speed and sorted in descending match priority
  * - iow, descending speed.
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9eeab9b9a74c..7c49ab95441b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -968,6 +968,8 @@ struct phy_fixup {
 const char *phy_speed_to_str(int speed);
 const char *phy_duplex_to_str(unsigned int duplex);
 
+int phy_interface_num_ports(phy_interface_t interface);
+
 /* A structure for mapping a particular speed and duplex
  * combination to a particular SUPPORTED and ADVERTISED value
  */
-- 
2.37.1

