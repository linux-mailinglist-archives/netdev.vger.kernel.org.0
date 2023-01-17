Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54375670CF8
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjAQXOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjAQXNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:13:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD239AA8B;
        Tue, 17 Jan 2023 12:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673989044; x=1705525044;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=C5fCOlZ75pNlYBnCtI5JbqlChvo+KMflLyhKJDLKe4o=;
  b=v/LjfrMxThpW+NkUmEcSMLl1bpKgxyFav9UPZ2xWIaDTAlY0DFTlaKhd
   EfTi5eMqhNjCDfOj+QOTaLx5debiYqVs7MLKXZ5sin+df6hl+mgcIvqxH
   R7oP5wQzJ6EoZFWKh8YYdRZI7j3xwX1iP7iaqLQybrLZ4kwKeDftTBPxG
   KU4/8BkWoQ1SrUhCENFGoCMNIiEgO4ydgeX62Ytgi0OIfGVJ/fKVzXrtI
   7e+8oMbIpc/F51JXKOzuHZ6mIk4Ka/UfeyiphCrPlueYLJBND+kJrJOuv
   qKdHJ+Kh1/0dsXIhS/oWxLrqgXN16CsVgAEIf0kiIarXrgIjMFT2yVYsB
   g==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="196226791"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 13:57:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 13:57:21 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 13:57:19 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [net-next: PATCH v7 7/7] dsa: lan9303: Add flow ctrl in link_up
Date:   Tue, 17 Jan 2023 14:57:03 -0600
Message-ID: <20230117205703.25960-8-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230117205703.25960-1-jerry.ray@microchip.com>
References: <20230117205703.25960-1-jerry.ray@microchip.com>
MIME-Version: 1.0
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

While the prior patch moved the adjust_link code into the
phylink_mac_link_up api, this patch cleans it up and adds the setting the
port's flow control based on the phylink_mac_link_up input parameters.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 93ece212cac8..fe8bf0faf6b7 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -53,6 +53,9 @@
 #define LAN9303_MANUAL_FC_1 0x68
 #define LAN9303_MANUAL_FC_2 0x69
 #define LAN9303_MANUAL_FC_0 0x6a
+# define LAN9303_BP_EN BIT(6)
+# define LAN9303_RX_FC_EN BIT(2)
+# define LAN9303_TX_FC_EN BIT(1)
 #define LAN9303_SWITCH_CSR_DATA 0x6b
 #define LAN9303_SWITCH_CSR_CMD 0x6c
 #define LAN9303_SWITCH_CSR_CMD_BUSY BIT(31)
@@ -228,6 +231,13 @@ const struct regmap_access_table lan9303_register_set = {
 };
 EXPORT_SYMBOL(lan9303_register_set);
 
+/* Flow Control registers indexed by port number */
+static unsigned int flow_ctl_reg[] = {
+	LAN9303_MANUAL_FC_0,
+	LAN9303_MANUAL_FC_1,
+	LAN9303_MANUAL_FC_2
+};
+
 static int lan9303_read(struct regmap *regmap, unsigned int offset, u32 *reg)
 {
 	int ret, i;
@@ -1299,7 +1309,9 @@ static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
 					int duplex, bool tx_pause,
 					bool rx_pause)
 {
+	struct lan9303 *chip = ds->priv;
 	u32 ctl;
+	u32 reg;
 
 	/* On this device, we are only interested in doing something here if
 	 * this is the xMII port. All other ports are 10/100 phys using MDIO
@@ -1308,23 +1320,23 @@ static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	if (!IS_PORT_XMII(port))
 		return;
 
+	/* Disable auto-negotiation and force the speed/duplex settings. */
 	ctl = lan9303_phy_read(ds, port, MII_BMCR);
-
-	ctl &= ~BMCR_ANENABLE;
-
+	ctl &= ~(BMCR_ANENABLE | BMCR_SPEED100 | BMCR_FULLDPLX);
 	if (speed == SPEED_100)
 		ctl |= BMCR_SPEED100;
-	else if (speed == SPEED_10)
-		ctl &= ~BMCR_SPEED100;
-	else
-		dev_err(ds->dev, "unsupported speed: %d\n", speed);
-
 	if (duplex == DUPLEX_FULL)
 		ctl |= BMCR_FULLDPLX;
-	else
-		ctl &= ~BMCR_FULLDPLX;
-
 	lan9303_phy_write(ds, port, MII_BMCR, ctl);
+
+	/* Force the flow control settings. */
+	lan9303_read(chip->regmap, flow_ctl_reg[port], &reg);
+	reg &= ~(LAN9303_BP_EN | LAN9303_RX_FC_EN | LAN9303_TX_FC_EN);
+	if (rx_pause)
+		reg |= (LAN9303_RX_FC_EN | LAN9303_BP_EN);
+	if (tx_pause)
+		reg |= LAN9303_TX_FC_EN;
+	regmap_write(chip->regmap, flow_ctl_reg[port], reg);
 }
 
 static const struct dsa_switch_ops lan9303_switch_ops = {
-- 
2.17.1

