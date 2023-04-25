Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3162F6EDB48
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 07:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbjDYFpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 01:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbjDYFpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 01:45:03 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F4F83EC;
        Mon, 24 Apr 2023 22:45:00 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33P5ifmp104119;
        Tue, 25 Apr 2023 00:44:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682401481;
        bh=3wDxwAR+CCOnwWR6upvy6Zihsi8yqla39FCimDo+1BM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=BV74RoKdPWYIXkTDAic5TBueevO2QWIMX8XZ6Bagx8t6RJ8jpKD88H9U+d9PcdMtx
         c1Xgp40xzaq7Mzsg1HOH+2ipGSi8w7BgLK6LVNdO+bMd9xABEJHUa9faV3v3r5A/dP
         2vFPp3l8XcP+jE73IOwxCvj9uF/8Ulg9lv0kszmM=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33P5if1g112335
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Apr 2023 00:44:41 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 25
 Apr 2023 00:44:41 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 25 Apr 2023 00:44:41 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33P5iURp124283;
        Tue, 25 Apr 2023 00:44:38 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [RFC PATCH 2/2] net: phy: dp83869: fix mii mode when rgmii strap cfg is used
Date:   Tue, 25 Apr 2023 11:14:29 +0530
Message-ID: <20230425054429.3956535-3-s-vadapalli@ti.com>
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
 drivers/net/phy/dp83869.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 9ab5eff502b7..8dbc502bcd9e 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -692,8 +692,11 @@ static int dp83869_configure_mode(struct phy_device *phydev,
 	/* Below init sequence for each operational mode is defined in
 	 * section 9.4.8 of the datasheet.
 	 */
+	phy_ctrl_val = dp83869->mode;
+	if (phydev->interface == PHY_INTERFACE_MODE_MII)
+		phy_ctrl_val |= DP83869_OP_MODE_MII;
 	ret = phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_OP_MODE,
-			    dp83869->mode);
+			    phy_ctrl_val);
 	if (ret)
 		return ret;
 
-- 
2.25.1

