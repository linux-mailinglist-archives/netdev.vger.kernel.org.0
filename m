Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5AC54AE7A
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355962AbiFNKfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355614AbiFNKe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:34:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A284889E;
        Tue, 14 Jun 2022 03:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655202894; x=1686738894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7GBSluqHMenb+8N9EjP0OAXPDpipZxZyBHYyAMOBbF8=;
  b=lPGc/vGFugMpYFwZJtK/kJT+0VcUaV21vRkQceei3VV1IU97GQ66VQUT
   HJX3dkbNUJsBhUespkk6odM37/LZeothNyBpnZ810AD5poBSZ/m+nBqes
   zT2we8R9mrIvqhshRSeM5wcPVNlSNqLdosWQsXx1lR1ErthG9rOmoWR+l
   aTV5bd+pFxyqqKCeWQOB74gy2NMyA0PuvNckP44aZAsAtSSbbw5yTXhoq
   AfG6Mv7ff6nfzZ8Pb+cbP2CPB+Bj+VbBvZXe0bVA99rq2Oyhypsfx0Mtl
   wYL/QBqsy+ypcPNdExbnxH15xrDZ/G33xbMwfQvcV8IfCKAW82mBLihSb
   g==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="163256596"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2022 03:34:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Jun 2022 03:34:53 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 14 Jun 2022 03:34:49 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <lxu@maxlinear.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next 5/5] net: phy: add support to get Master-Slave configuration
Date:   Tue, 14 Jun 2022 16:04:24 +0530
Message-ID: <20220614103424.58971-6-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
References: <20220614103424.58971-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement reporting the Master-Slave configuration and state

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/phy/mxl-gpy.c | 55 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 5ce1bf03bbd7..cf625ced4ec1 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -27,11 +27,19 @@
 #define PHY_ID_GPY241BM		0x67C9DE80
 #define PHY_ID_GPY245B		0x67C9DEC0
 
+#define PHY_STD_GCTRL		0x09	/* Gbit ctrl */
+#define PHY_STD_GSTAT		0x0A	/* Gbit status */
 #define PHY_MIISTAT		0x18	/* MII state */
 #define PHY_IMASK		0x19	/* interrupt mask */
 #define PHY_ISTAT		0x1A	/* interrupt status */
 #define PHY_FWV			0x1E	/* firmware version */
 
+#define PHY_STD_GCTRL_MS	BIT(11)
+#define PHY_STD_GCTRL_MSEN	BIT(12)
+
+#define PHY_STD_GSTAT_MSRES	BIT(14)
+#define PHY_STD_GSTAT_MSFAULT	BIT(15)
+
 #define PHY_MIISTAT_SPD_MASK	GENMASK(2, 0)
 #define PHY_MIISTAT_DPX		BIT(3)
 #define PHY_MIISTAT_LS		BIT(10)
@@ -160,6 +168,48 @@ static bool gpy_2500basex_chk(struct phy_device *phydev)
 	return true;
 }
 
+static int gpy_master_slave_cfg_get(struct phy_device *phydev)
+{
+	int state;
+	int cfg;
+	int ret;
+
+	ret = phy_read(phydev, PHY_STD_GCTRL);
+	if (ret < 0) {
+		phydev_err(phydev, "Error: MDIO register access failed: %d\n",
+			   ret);
+		return ret;
+	}
+
+	if (ret & PHY_STD_GCTRL_MSEN)
+		if (ret & PHY_STD_GCTRL_MS)
+			cfg = MASTER_SLAVE_CFG_MASTER_FORCE;
+		else
+			cfg = MASTER_SLAVE_CFG_SLAVE_FORCE;
+	else
+		cfg = MASTER_SLAVE_CFG_MASTER_PREFERRED;
+
+	ret = phy_read(phydev, PHY_STD_GSTAT);
+	if (ret < 0) {
+		phydev_err(phydev, "Error: MDIO register access failed: %d\n",
+			   ret);
+		return ret;
+	}
+
+	if (ret & PHY_STD_GSTAT_MSFAULT)
+		state = MASTER_SLAVE_STATE_ERR;
+	else
+		if (ret & PHY_STD_GSTAT_MSRES)
+			state = MASTER_SLAVE_STATE_MASTER;
+		else
+			state = MASTER_SLAVE_STATE_SLAVE;
+
+	phydev->master_slave_get = cfg;
+	phydev->master_slave_state = state;
+
+	return 0;
+}
+
 static bool gpy_sgmii_aneg_en(struct phy_device *phydev)
 {
 	int ret;
@@ -295,6 +345,9 @@ static void gpy_update_interface(struct phy_device *phydev)
 				   ret);
 		break;
 	}
+
+	if (phydev->speed == SPEED_2500 || phydev->speed == SPEED_1000)
+		gpy_master_slave_cfg_get(phydev);
 }
 
 static int gpy_read_status(struct phy_device *phydev)
@@ -309,6 +362,8 @@ static int gpy_read_status(struct phy_device *phydev)
 	phydev->duplex = DUPLEX_UNKNOWN;
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
 
 	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
 		ret = genphy_c45_read_lpa(phydev);
-- 
2.25.1

