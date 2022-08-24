Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636725A020F
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 21:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239703AbiHXTYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 15:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239605AbiHXTYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 15:24:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4496CF40;
        Wed, 24 Aug 2022 12:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661369057; x=1692905057;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lGwWmzJrwJTpaXz+zD0EomUCGqQi3iai0u1JFi8zc3Q=;
  b=pV97T3HG/y+TD7WO+ULR6cowlA/6C188U/WV2j/t5O1s5EQJLwmjFYHr
   wR8dfDQQ+GSqK45aLbVX3dkYXdQ/k6DPEogccavYMjjqiKwMijMloZrj/
   OkeW9KHpUsVvnbcD3Pxdl4grnlmTEnt09c84Xp7CBS+b/kCqrFpLaqxI3
   edu+f2xOHNofmpytadx0GVViR77kx9ki1akxl31UeD0OCV/Mcye/fa8/g
   fag4D/KKnF43RVudrBPI4whsCFHlNFIMJpE22hr7N587SqWnmkeoDQ4V/
   410DSjm2KaLeISzcjMSih7sJU3AI+ZYXvERjwUKENYYOjqvXl0tIiv93U
   A==;
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="173994307"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Aug 2022 12:24:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 24 Aug 2022 12:24:16 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 24 Aug 2022 12:24:14 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: phy: micrel: Make the GPIO to be non-exclusive
Date:   Wed, 24 Aug 2022 21:28:27 +0200
Message-ID: <20220824192827.437095-1-horatiu.vultur@microchip.com>
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
 drivers/net/phy/micrel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e78d0bf69bc3..ea72ff64ad33 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2878,7 +2878,8 @@ static int lan8814_release_coma_mode(struct phy_device *phydev)
 	struct gpio_desc *gpiod;
 
 	gpiod = devm_gpiod_get_optional(&phydev->mdio.dev, "coma-mode",
-					GPIOD_OUT_HIGH_OPEN_DRAIN);
+					GPIOD_OUT_HIGH_OPEN_DRAIN |
+					GPIOD_FLAGS_BIT_NONEXCLUSIVE);
 	if (IS_ERR(gpiod))
 		return PTR_ERR(gpiod);
 
-- 
2.33.0

