Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62685A5BF0
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 08:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiH3GiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 02:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiH3GiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 02:38:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF80772B43;
        Mon, 29 Aug 2022 23:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661841495; x=1693377495;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TLaqPVLrpojss4E0SFkXfjgiQtLN1ZQWbWlL778Wpzg=;
  b=hBKWKfGWyULSpfvvE2zmF+Fz+IIoIhH8g5ROvq5TeMx85tP0IJ2/zJR3
   p/5CE1R8urVFCy2cHiPkjTmwsUGnuBfX3MKc0FQUS6Ac/Z3WyCf19BQCJ
   ASIuReWMn/B5/kVi40lKhbkop/cX2tZvzt9QK0K+IeALZZ+pMsEUDvjO4
   6MIAmhru/O1I4XkbL5a3chi37wk7rN05lTzPHCsZ666Y2vBbOeG0uNqEw
   3Z1a6NiHV/2L9KPcaTRlNivkq8dlBkv/IF6DfZu8uJMFQI6W5f0SAJMTk
   +AUAHGkH1XFj4ZKJLPeJf/+xaPWc3WjkoGUe1mbuqbexKfjRI+9A18S57
   A==;
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="111327811"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2022 23:37:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 29 Aug 2022 23:37:58 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 29 Aug 2022 23:37:55 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <michael@walle.cc>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v3] net: phy: micrel: Make the GPIO to be non-exclusive
Date:   Tue, 30 Aug 2022 08:40:55 +0200
Message-ID: <20220830064055.2340403-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

The same GPIO line can be shared by multiple phys for the coma mode pin.
If that is the case then, all the other phys that share the same line
will failed to be probed because the access to the gpio line is not
non-exclusive.
Fix this by making access to the gpio line to be nonexclusive using flag
GPIOD_FLAGS_BIT_NONEXCLUSIVE. This allows all the other PHYs to be
probed.

Fixes: 738871b09250ee ("net: phy: micrel: add coma mode GPIO")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v2->v3:
- add Reviewed-by Andrew Lunn
- mark that the patch is for net and not net-next

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

