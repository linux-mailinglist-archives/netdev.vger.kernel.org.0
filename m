Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564A05A1A0F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243489AbiHYUK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243391AbiHYUK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:10:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A7BB99E5;
        Thu, 25 Aug 2022 13:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661458256; x=1692994256;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xoVBKI8vtRPLhTpfe9zpgP4YLTMRraRWqMv5jTZ2XKs=;
  b=2gIspUra4RtZEe4GdL8zWpRMyR0fy2rTSd+iOmHeNATqL9bVueu0rJUP
   YuBNYXx9xcjVOotdHJrg0jhIKN8Va6jEVaeYETfBcsVIEftT9dbC4Co9M
   P+hiihfhf9PU1XjsKJr6SGEPsyV+GmWOm8wOEmRNIFN4b5nofnPBTlk+7
   mvpmNR4fzRgzkQmVYPdolHk043Xd3Zm+MUmb3O5BQsej2VPrnd4tXmJnM
   BUNERaSgZmFI05sMx2iB5tx1Ml1YccVHMQuO4CHiQrv/jDbAnjV6GMKHK
   wWhdQX+slzu+bT9aVmPJdXhXywC9DdklLRf8gjjO54x2cbuiZa03EBVnZ
   g==;
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="171001056"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Aug 2022 13:10:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 25 Aug 2022 13:10:48 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 25 Aug 2022 13:10:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2] net: phy: micrel: Make the GPIO to be non-exclusive
Date:   Thu, 25 Aug 2022 22:14:47 +0200
Message-ID: <20220825201447.1444396-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same GPIO line can be shared by multiple phys for the coma mode pin.
If that is the case then, all the other phys that share the same line
will failed to be probed because the access to the gpio line is not
non-exclusive.
Fix this by making access to the gpio line to be nonexclusive using flag
GPIOD_FLAGS_BIT_NONEXCLUSIVE. This allows all the other PHYs to be
probed.

Fixes: 738871b09250ee ("net: phy: micrel: add coma mode GPIO")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v1->v2:
- add comment describing that there should not be anyone putting back
  the phy in coma mode.
---
 drivers/net/phy/micrel.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e78d0bf69bc3..6f52b4fb6888 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2873,12 +2873,18 @@ static int lan8814_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+/* It is expected that there will not be any 'lan8814_take_coma_mode'
+ * function called in suspend. Because the GPIO line can be shared, so if one of
+ * the phys goes back in coma mode, then all the other PHYs will go, which is
+ * wrong.
+ */
 static int lan8814_release_coma_mode(struct phy_device *phydev)
 {
 	struct gpio_desc *gpiod;
 
 	gpiod = devm_gpiod_get_optional(&phydev->mdio.dev, "coma-mode",
-					GPIOD_OUT_HIGH_OPEN_DRAIN);
+					GPIOD_OUT_HIGH_OPEN_DRAIN |
+					GPIOD_FLAGS_BIT_NONEXCLUSIVE);
 	if (IS_ERR(gpiod))
 		return PTR_ERR(gpiod);
 
-- 
2.33.0

