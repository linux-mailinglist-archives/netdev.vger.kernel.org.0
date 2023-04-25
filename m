Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE8C6EDB4B
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 07:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbjDYFpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 01:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbjDYFpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 01:45:07 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99AD8693;
        Mon, 24 Apr 2023 22:45:02 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33P5icUB070100;
        Tue, 25 Apr 2023 00:44:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682401478;
        bh=ubG6hdaNwuct5+wLN4lzFka6yc1X3H82cDBK9I9zdzE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=MaruJQXhA2LQceHPz5ct3gypNn8jcswkA8KwlsRkOjRqaOE6FxWhK9dzzr8qOURcd
         LNQKPIRR5DAO0tWnrT4s+7zHLJuanoQRhlxBAuNLPnY8t6eR7BJDbbI36sFdQUw4Y1
         +EYKw5asToDJsYOvJdXdNL8ztDowiPxd0xc1kNFM=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33P5icCE025786
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Apr 2023 00:44:38 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 25
 Apr 2023 00:44:37 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 25 Apr 2023 00:44:37 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33P5iURo124283;
        Tue, 25 Apr 2023 00:44:34 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [RFC PATCH 1/2] net: phy: dp83867: add w/a for packet errors seen with short cables
Date:   Tue, 25 Apr 2023 11:14:28 +0530
Message-ID: <20230425054429.3956535-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230425054429.3956535-1-s-vadapalli@ti.com>
References: <20230425054429.3956535-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Introduce the W/A for packet errors seen with short cables (<1m) between
two DP83867 PHYs.

The W/A recommended by DM requires FFE Equalizer Configuration tuning by
writing value 0x0E81 to DSP_FFE_CFG register (0x012C), surrounded by hard
and soft resets as follows:

write_reg(0x001F, 0x8000); //hard reset
write_reg(DSP_FFE_CFG, 0x0E81);
write_reg(0x001F, 0x4000); //soft reset

Since  DP83867 PHY DM says "Changing this register to 0x0E81, will not
affect Long Cable performance.", enable the W/A by default.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/net/phy/dp83867.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 5821f04c69dc..ba60cf35872e 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -42,6 +42,7 @@
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_STRAP_STS2	0x006f
 #define DP83867_RGMIIDCTL	0x0086
+#define DP83867_DSP_FFE_CFG	0X012C
 #define DP83867_RXFCFG		0x0134
 #define DP83867_RXFPMD1	0x0136
 #define DP83867_RXFPMD2	0x0137
@@ -934,8 +935,20 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 
 	usleep_range(10, 20);
 
-	return phy_modify(phydev, MII_DP83867_PHYCTRL,
+	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
 			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
+	if (err < 0)
+		return err;
+
+	phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG, 0X0E81);
+
+	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
+	if (err < 0)
+		return err;
+
+	usleep_range(10, 20);
+
+	return 0;
 }
 
 static void dp83867_link_change_notify(struct phy_device *phydev)
-- 
2.25.1

