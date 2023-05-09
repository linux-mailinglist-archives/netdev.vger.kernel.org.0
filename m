Return-Path: <netdev+bounces-1035-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 060AE6FBEA1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:22:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C753B1C20ADC
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 05:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4294220FE;
	Tue,  9 May 2023 05:22:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F6820EF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:22:04 +0000 (UTC)
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF6D6187;
	Mon,  8 May 2023 22:22:01 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3495LTLp011976;
	Tue, 9 May 2023 00:21:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683609689;
	bh=FaHeUjnucih418Ur8PV/2ZSUSUsKfveQTe6yIr3uQrc=;
	h=From:To:CC:Subject:Date;
	b=vMGtVkAdDAeqsfumXOCtzPOOiCwbqf5cFMoGSdA+q12MuL5PdBDZRQpGu0JyJuoBI
	 l10TDG5GdmOF5qg8SjwpaddiZJj7PuvZl5plwyOVYa+jy9yz7q64NuIXxe/zFbAMfM
	 2htIn8oWgf5hntRvk59YlHJOCx2NHiyJD+3ifYSw=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3495LTUi009596
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 9 May 2023 00:21:29 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 9
 May 2023 00:21:28 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 9 May 2023 00:21:28 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3495LOd3024283;
	Tue, 9 May 2023 00:21:25 -0500
From: Siddharth Vadapalli <s-vadapalli@ti.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net v2] net: phy: dp83867: add w/a for packet errors seen with short cables
Date: Tue, 9 May 2023 10:51:24 +0530
Message-ID: <20230509052124.611875-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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

Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---

V1 patch at:
https://lore.kernel.org/r/20230508070019.356548-1-s-vadapalli@ti.com

Changes since v1 patch:
- Wrap the line invoking phy_write_mmd(), limiting it to 80 characters.
- Replace 0X0E81 with 0x0e81 in the call to phy_write_mmd().
- Replace 0X012C with 0x012c in the new define for DP83867_DSP_FFE_CFG.

RFC patch at:
https://lore.kernel.org/r/20230425054429.3956535-2-s-vadapalli@ti.com/

Changes since RFC patch:
- Change patch subject to PATCH net.
- Add Fixes tag.
- Check return value of phy_write_mmd().

 drivers/net/phy/dp83867.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index d75f526a20a4..bbdcc595715d 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -44,6 +44,7 @@
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_STRAP_STS2	0x006f
 #define DP83867_RGMIIDCTL	0x0086
+#define DP83867_DSP_FFE_CFG	0x012c
 #define DP83867_RXFCFG		0x0134
 #define DP83867_RXFPMD1	0x0136
 #define DP83867_RXFPMD2	0x0137
@@ -941,8 +942,23 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 
 	usleep_range(10, 20);
 
-	return phy_modify(phydev, MII_DP83867_PHYCTRL,
+	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
 			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
+	if (err < 0)
+		return err;
+
+	err = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG,
+			    0x0e81);
+	if (err < 0)
+		return err;
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


