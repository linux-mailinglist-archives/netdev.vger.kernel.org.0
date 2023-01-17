Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98B2670CF9
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjAQXOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjAQXNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:13:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FF38CE72;
        Tue, 17 Jan 2023 12:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673989040; x=1705525040;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=l//9fOjFa2fPgl+Ydqe3nVGAlwfQjBnfvOtLXzxETz0=;
  b=ExtUB0+u2vyBYtLzZaRYG+kOq2ANdc1Bxhlwnr025aQioMHQgkMNV7Oo
   1w4kyw/Db5q2CzC8Htpecw74vHjofb7NWR4FyNHSSuD4zol3wRw1LqQ3j
   214kQ/s+KojdVL0j7zRcC8hZgKuv5K4kg487nJO609PSbAvQWfZ31MmKx
   1fuMn3/l8knVDQa+d1t/wll0UyffO/UUk3Td7e/WMX7ViTetfvhw5efGo
   Hkmwv+AM+1i5MKlyorFay8uTArAiraVljv/cdzP2YU5ctK0IylvBEy88c
   m2YiNCh67iBltKUYWXz6iyP42ZSL26Vplz8XN7wHLqfgUPlz90xJsMOWf
   A==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="197058703"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 13:57:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 13:57:10 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 13:57:08 -0700
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
Subject: [net-next: PATCH v7 2/7] dsa: lan9303: move Turbo Mode bit init
Date:   Tue, 17 Jan 2023 14:56:58 -0600
Message-ID: <20230117205703.25960-3-jerry.ray@microchip.com>
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

In preparing to remove the .adjust_link api, I am moving the one-time
initialization of the device's Turbo Mode bit into a different execution
path. This code clears (disables) the Turbo Mode bit which is never used
by this driver. Turbo Mode is a non-standard mode that would allow the
100Mbps RMII interface to run at 200Mbps.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index f8f6f79052e3..63f5c1ef65e2 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -902,6 +902,7 @@ static int lan9303_setup(struct dsa_switch *ds)
 {
 	struct lan9303 *chip = ds->priv;
 	int ret;
+	u32 reg;
 
 	/* Make sure that port 0 is the cpu port */
 	if (!dsa_is_cpu_port(ds, 0)) {
@@ -909,6 +910,12 @@ static int lan9303_setup(struct dsa_switch *ds)
 		return -EINVAL;
 	}
 
+	/* Virtual Phy: Remove Turbo 200Mbit mode */
+	lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &reg);
+
+	reg &= ~LAN9303_VIRT_SPECIAL_TURBO;
+	regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, reg);
+
 	ret = lan9303_setup_tagging(chip);
 	if (ret)
 		dev_err(chip->dev, "failed to setup port tagging %d\n", ret);
@@ -1052,7 +1059,6 @@ static int lan9303_phy_write(struct dsa_switch *ds, int phy, int regnum,
 static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 				struct phy_device *phydev)
 {
-	struct lan9303 *chip = ds->priv;
 	int ctl;
 
 	if (!phy_is_pseudo_fixed_link(phydev))
@@ -1075,14 +1081,6 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 		ctl &= ~BMCR_FULLDPLX;
 
 	lan9303_phy_write(ds, port, MII_BMCR, ctl);
-
-	if (port == chip->phy_addr_base) {
-		/* Virtual Phy: Remove Turbo 200Mbit mode */
-		lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ctl);
-
-		ctl &= ~LAN9303_VIRT_SPECIAL_TURBO;
-		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl);
-	}
 }
 
 static int lan9303_port_enable(struct dsa_switch *ds, int port,
-- 
2.17.1

