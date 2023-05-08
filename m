Return-Path: <netdev+bounces-817-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E52166FA07A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 09:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA8341C2091B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 07:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193F21548C;
	Mon,  8 May 2023 07:04:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C68A1095D
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:04:56 +0000 (UTC)
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAFA1E991;
	Mon,  8 May 2023 00:04:26 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3487440J112127;
	Mon, 8 May 2023 02:04:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683529444;
	bh=chEfS61x65xMVhUCjFBAUnEr02zz7hnvBnAi5qM39/g=;
	h=From:To:CC:Subject:Date;
	b=WfL/Z/Yom0nFGVEtslS333Z+GMddMog0YwPxr42Pfv+UtJNi4eZTKm/qePqzh+wq6
	 /SrSRiwhxRs6CDbo64FmWtqGHvI2xOeV5Xj/TJG4ztIFfdmYk/35cTrvNdUzb5K4eJ
	 k3h1IWoa8Z84GmVPRO/D6us0BVWV9OV3ToRlFZ6s=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3487440V029859
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 8 May 2023 02:04:04 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 8
 May 2023 02:04:03 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 8 May 2023 02:04:03 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34873xcx035885;
	Mon, 8 May 2023 02:04:00 -0500
From: Siddharth Vadapalli <s-vadapalli@ti.com>
To: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next] net: phy: dp83869: support mii mode when rgmii strap cfg is used
Date: Mon, 8 May 2023 12:33:59 +0530
Message-ID: <20230508070359.357474-1-s-vadapalli@ti.com>
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
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Grygorii Strashko <grygorii.strashko@ti.com>

The DP83869 PHY on TI's k3-am642-evm supports both MII and RGMII
interfaces and is configured by default to use RGMII interface (strap).
However, the board design allows switching dynamically to MII interface
for testing purposes by applying different set of pinmuxes.

To support switching to MII interface, update the DP83869 PHY driver to
configure OP_MODE_DECODE.RGMII_MII_SEL(bit 5) properly when MII PHY
interface mode is requested.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---

RFC patch at:
https://lore.kernel.org/r/20230425054429.3956535-3-s-vadapalli@ti.com/

Changes since RFC patch:
- Change patch subject to PATCH net-next.
- Reword commit message to indicate that the patch adds new support and
  is not intended to be a bug fix.
- Add check to ensure that MII mode is requested only with valid operational
  modes.


 drivers/net/phy/dp83869.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 9ab5eff502b7..fa8c6fdcf301 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -692,8 +692,19 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 	/* Below init sequence for each operational mode is defined in
 	 * section 9.4.8 of the datasheet.
 	 */
+	phy_ctrl_val = dp83869->mode;
+	if (phydev->interface == PHY_INTERFACE_MODE_MII) {
+		if (dp83869->mode == DP83869_100M_MEDIA_CONVERT ||
+		    dp83869->mode == DP83869_RGMII_100_BASE) {
+			phy_ctrl_val |= DP83869_OP_MODE_MII;
+		} else {
+			phydev_err(phydev, "selected op-mode is not valid with MII mode\n");
+			return -EINVAL;
+		}
+	}
+
 	ret = phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_OP_MODE,
-			    dp83869->mode);
+			    phy_ctrl_val);
 	if (ret)
 		return ret;
 
-- 
2.25.1


