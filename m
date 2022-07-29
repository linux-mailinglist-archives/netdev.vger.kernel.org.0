Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC9D5852BD
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbiG2PeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237652AbiG2PeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:34:10 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4628584EE2;
        Fri, 29 Jul 2022 08:34:09 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 86A77240008;
        Fri, 29 Jul 2022 15:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1659108847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQW6R5n4PbUrnKfCwrdu8zgZtIeSu3WZ+b/uNL8c/jY=;
        b=EYKLysbOZOzKdi5Pi2aKkS0GLzWiMYcfX/U5Q2VTHeSzktzusLaNRxFIQER5MnX8nHCbQF
        9vcu84zCewHCvtgPQyDQuv/RTmfr6pgVcm8gmorVv1If+tGl1q+lOCsOqn0lPUOiXN1GuQ
        ZprH1DjqV0fFKBC5gBlujIEzsBv/N2aXnWr92n05RxMurh3r94u/5y6lGUbwFp2mN86K4N
        1EUotaVfmvEq6Nl27LkwQLrkRAXy2u+/0SwyzRPQ6EMK/nGivHTtwv9Jh/l1eSpTjZlZ1t
        rBXbPLs0p9YQ8y7l1arCG2zGDbKeVWHCDEpsfAvEt1uEFmNPr5tedp3puXrdpw==
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
Subject: [PATCH net-next v3 3/4] net: phy: Add helper to derive the number of ports from a phy mode
Date:   Fri, 29 Jul 2022 17:33:55 +0200
Message-Id: <20220729153356.581444-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220729153356.581444-1-maxime.chevallier@bootlin.com>
References: <20220729153356.581444-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

