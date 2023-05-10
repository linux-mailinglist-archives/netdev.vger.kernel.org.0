Return-Path: <netdev+bounces-1475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 649DC6FDE1D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 282A62814E3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313C2F9F6;
	Wed, 10 May 2023 12:52:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253B420B23
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:52:06 +0000 (UTC)
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCB66188;
	Wed, 10 May 2023 05:52:02 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34ACpiLG001859;
	Wed, 10 May 2023 07:51:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683723104;
	bh=2RMALsxCD9vv+3SY36ICjcgswL3/hso7mKW8Q7aCQGc=;
	h=From:To:CC:Subject:Date;
	b=wYnla6Aub9v10PjLTXMjAyLHh6nnvjLp+/E5NrlJ3UROaQvFAomSvSLguhpzkIuGy
	 g94ahy8crx9heecSoCAS9Do4fMHrHxe2rw0SLfpHlz8/W/gcCi4aAMGLd5aA3thiN7
	 Ny+sGPhHYNbYn5iTgS7fty4pnSVQueTLex8Yl0jw=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34ACpiZx022718
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 10 May 2023 07:51:44 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 10
 May 2023 07:51:44 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 10 May 2023 07:51:44 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34ACpeZY006649;
	Wed, 10 May 2023 07:51:41 -0500
From: Siddharth Vadapalli <s-vadapalli@ti.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net v3] net: phy: dp83867: add w/a for packet errors seen with short cables
Date: Wed, 10 May 2023 18:21:39 +0530
Message-ID: <20230510125139.646222-1-s-vadapalli@ti.com>
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

V2 patch at:
https://lore.kernel.org/r/20230509052124.611875-1-s-vadapalli@ti.com/

Changes since v2 patch:
- Add comment describing the short cable w/a register configuration.

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

 drivers/net/phy/dp83867.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index d75f526a20a4..76f5a2402fb0 100644
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
@@ -941,8 +942,27 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 
 	usleep_range(10, 20);
 
-	return phy_modify(phydev, MII_DP83867_PHYCTRL,
+	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
 			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
+	if (err < 0)
+		return err;
+
+	/* Configure the DSP Feedforward Equalizer Configuration register to
+	 * improve short cable (< 1 meter) performance. This will not affect
+	 * long cable performance.
+	 */
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


