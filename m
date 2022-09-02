Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E075ABA0C
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiIBVac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiIBVab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:30:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3540FE398C;
        Fri,  2 Sep 2022 14:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662154228; x=1693690228;
  h=from:to:subject:date:message-id:mime-version;
  bh=KOTH4JPhMsOiAZR2ZzLX0VQD5TijJ7XjKW80Z9C78Wc=;
  b=R+t6FRkH9dcQKaBeYJiB56k1Zah3bdu92MDIkfXaQBBtqj2fXnnIIptw
   anlT1K5JHTYDLB0/cFJQlkmFFX8h7wZdBwURsJqKK2i2T91EEWen4+wnZ
   v2bWoPQPHpB18c7UK+VlfFj8Nsw7hM78LUZIOXHQCROYgRwFyxIfMcQB/
   Zs7sYnLsj8fwFwYiCdO5agvbbbSwSPcjWeVU2IrDVSTSs8rcCOpX2Jko8
   NlMnVHQBQxxhCLWZgyQqaC3eipDzaKCYMIiDsKC4d3FJo5z1zazNpzWAm
   TsGZ1PEeLuSPCqSyq+XqKYL9z8IGhWDYowEzRoT5boZVdVF4TNvxF8TfN
   A==;
X-IronPort-AV: E=Sophos;i="5.93,285,1654585200"; 
   d="scan'208";a="111997240"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 14:30:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 14:30:23 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Sep 2022 14:30:21 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH v2 1/2] net: dsa: LAN9303: Add early read to sync
Date:   Fri, 2 Sep 2022 16:30:20 -0500
Message-ID: <20220902213021.23151-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
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

Add initial BYTE_ORDER read to sync the 32-bit accesses over the 16-bit
mdio bus to improve driver robustness.

The lan9303 expects two mdio read transactions back-to-back to read a
32-bit register. The first read transaction causes the other half of the
32-bit register to get latched.  The subsequent read returns the latched
second half of the 32-bit read. The BYTE_ORDER register is an exception to
this rule. As it is a constant value, there is no need to latch the second
half. We read this register first in case there were reads during the boot
loader process that might have occurred prior to this driver taking over
ownership of accessing this device.

This patch has been tested on the SAMA5D3-EDS with a LAN9303 RMII daughter
card.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index e03ff1f267bb..9d5302001abf 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -32,6 +32,7 @@
 #define LAN9303_INT_EN 0x17
 # define LAN9303_INT_EN_PHY_INT2_EN BIT(27)
 # define LAN9303_INT_EN_PHY_INT1_EN BIT(26)
+#define LAN9303_BYTE_ORDER 0x19
 #define LAN9303_HW_CFG 0x1D
 # define LAN9303_HW_CFG_READY BIT(27)
 # define LAN9303_HW_CFG_AMDX_EN_PORT2 BIT(26)
@@ -851,10 +852,6 @@ static int lan9303_check_device(struct lan9303 *chip)
 	if (ret) {
 		dev_err(chip->dev, "failed to read chip revision register: %d\n",
 			ret);
-		if (!chip->reset_gpio) {
-			dev_dbg(chip->dev,
-				"hint: maybe failed due to missing reset GPIO\n");
-		}
 		return ret;
 	}
 
@@ -1349,6 +1346,7 @@ static int lan9303_probe_reset_gpio(struct lan9303 *chip,
 int lan9303_probe(struct lan9303 *chip, struct device_node *np)
 {
 	int ret;
+	u32 reg;
 
 	mutex_init(&chip->indirect_mutex);
 	mutex_init(&chip->alr_mutex);
@@ -1359,6 +1357,19 @@ int lan9303_probe(struct lan9303 *chip, struct device_node *np)
 
 	lan9303_handle_reset(chip);
 
+	/* First read to the device.  This is a Dummy read to ensure MDIO */
+	/* access is in 32-bit sync. */
+	ret = lan9303_read(chip->regmap, LAN9303_BYTE_ORDER, &reg);
+	if (ret) {
+		dev_err(chip->dev, "failed to access the device: %d\n",
+			ret);
+		if (!chip->reset_gpio) {
+			dev_dbg(chip->dev,
+				"hint: maybe failed due to missing reset GPIO\n");
+		}
+		return ret;
+	}
+
 	ret = lan9303_check_device(chip);
 	if (ret)
 		return ret;
-- 
2.17.1

