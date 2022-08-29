Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56F65A53A8
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 20:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiH2SAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 14:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiH2SAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 14:00:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC0E5E572;
        Mon, 29 Aug 2022 11:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661796041; x=1693332041;
  h=from:to:subject:date:message-id:mime-version;
  bh=Y5MEnh+bRbV7ieDRxLzSjjlv+IJ4TX4m3JyHj4Q4D4U=;
  b=jPFA7Ymj42yR+klq154hPYjmVExOsUozUDl+RgUdw8sbanhEQc4Pj/SW
   Be3T4cQsyzS83+oE+HWjjDgRFCDVKgislj7Rm1ZwPEQ6Appx3M/9NQze3
   m4SJrXAPG32ODTy5T7VVV/EFrfdRLlBbFojncNA6uPcJPgImT3fmOXyxJ
   c+x1i7YbobdA5882LUS8+weunk+nNpGys9B3N0pECLP9ly9chg7GiJ8C+
   SRLKVZLxQzBQkYjd5r30XbPuEa9jxFWO6kZb1RBabqfqUU9TfcBarFTUm
   xt0dokz+Nkd40LK23DT6lnSppMOkBwssnxvKE7bZBy0pxA5ZZ8y/Cnbl8
   A==;
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="188516850"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2022 11:00:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 29 Aug 2022 11:00:40 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 29 Aug 2022 11:00:38 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH 1/2] net: dsa: LAN9303: Add basic support for LAN9354
Date:   Mon, 29 Aug 2022 13:00:36 -0500
Message-ID: <20220829180037.31078-1-jerry.ray@microchip.com>
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

Add initial BYTE_ORDER read to sync to improve driver robustness

The lan9303 expects two mdio read transactions back-to-back to read a 32-bit
register. The first read transaction causes the other half of the 32-bit
register to get latched.  The subsequent read returns the latched second half
of the 32-bit read. The BYTE_ORDER register is an exception to this rule. As
it is a constant value, there is no need to latch the second half. We read
this register first in case there were reads during the boot loader process
that might have occurred prior to this driver taking over ownership of
accessing this device.

This patch has been tested on the SAMA5D3-EDS with a LAN9303 RMII daughter
card.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index e03ff1f267bb..17ae02a56bfe 100644
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
@@ -847,9 +848,10 @@ static int lan9303_check_device(struct lan9303 *chip)
 	int ret;
 	u32 reg;
 
-	ret = lan9303_read(chip->regmap, LAN9303_CHIP_REV, &reg);
+	// Dummy read to ensure MDIO access is in 32-bit sync.
+	ret = lan9303_read(chip->regmap, LAN9303_BYTE_ORDER, &reg);
 	if (ret) {
-		dev_err(chip->dev, "failed to read chip revision register: %d\n",
+		dev_err(chip->dev, "failed to access the device: %d\n",
 			ret);
 		if (!chip->reset_gpio) {
 			dev_dbg(chip->dev,
@@ -858,6 +860,13 @@ static int lan9303_check_device(struct lan9303 *chip)
 		return ret;
 	}
 
+	ret = lan9303_read(chip->regmap, LAN9303_CHIP_REV, &reg);
+	if (ret) {
+		dev_err(chip->dev, "failed to read chip revision register: %d\n",
+			ret);
+		return ret;
+	}
+
 	if ((reg >> 16) != LAN9303_CHIP_ID) {
 		dev_err(chip->dev, "expecting LAN9303 chip, but found: %X\n",
 			reg >> 16);
-- 
2.17.1

