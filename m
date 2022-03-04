Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1D94CD192
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239365AbiCDJqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239361AbiCDJqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:46:17 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E71D1A7DB4;
        Fri,  4 Mar 2022 01:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646387120; x=1677923120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bTf4pf5OL4GrYAo2t6ez51y4MZorJbckFqGdv0EmGuw=;
  b=bdVY4yqRjAgQ3bbTR6cwaMhcF2U6kEgt6EHRWz0OKXoJH1kNSELf/5es
   Id3wuZp9yV787TEJmzyC7Gejuhe3x8pwRnec5Ql8pEgosBLyyNRNlvB/K
   fGJXd+Ur/k/HOT7CPQVZ57603BQ6XTBEdIR66OW2tM73g3hL8mn6bBIXS
   cX6gtCTHybxpftS8QVgWZc35d7vwNu6ZhCFNDFLCiSThoiqSd3aqhblY2
   Y3BQk6A66c8joOL7OZuKLl5Vt+gROq/LcaQ8OOQmwaf+xlxhqx2+NwC6C
   uuK+YNrFMCTWI295PVt2Nm11aDKigL6tXgHH/kreFZIcpQO1igGmVHqq0
   w==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="150847725"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:45:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:45:19 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:45:15 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 6/6] net: phy: added ethtool master-slave configuration support
Date:   Fri, 4 Mar 2022 15:14:01 +0530
Message-ID: <20220304094401.31375-7-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304094401.31375-1-arun.ramadoss@microchip.com>
References: <20220304094401.31375-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To configure the T1 phy as master or slave using the ethtool -s <dev>
master-slave <forced-master/forced-slave>, the config_aneg and read
status functions are added.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 90 ++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 6a7836c2961a..8292f7305805 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -79,6 +79,9 @@
 #define T1_EQ_WT_FD_LCK_FRZ_CFG		0x6D
 #define T1_PST_EQ_LCK_STG1_FRZ_CFG	0x6E
 
+#define T1_MODE_STAT_REG		0x11
+#define T1_LINK_UP_MSK			BIT(0)
+
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
 #define DRIVER_DESC	"Microchip LAN87XX/LAN937x T1 PHY driver"
 
@@ -671,6 +674,89 @@ static int lan87xx_cable_test_get_status(struct phy_device *phydev,
 	return 0;
 }
 
+static int lan87xx_read_master_slave(struct phy_device *phydev)
+{
+	int rc = 0;
+
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
+
+	rc = phy_read(phydev, MII_CTRL1000);
+	if (rc < 0)
+		return rc;
+
+	if (rc & CTL1000_AS_MASTER)
+		phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
+	else
+		phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
+
+	rc = phy_read(phydev, MII_STAT1000);
+	if (rc < 0)
+		return rc;
+
+	if (rc & LPA_1000MSRES)
+		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
+	else
+		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
+
+	return rc;
+}
+
+static int lan87xx_read_status(struct phy_device *phydev)
+{
+	int rc = 0;
+
+	rc = phy_read(phydev, T1_MODE_STAT_REG);
+	if (rc < 0)
+		return rc;
+
+	if (rc & T1_LINK_UP_MSK)
+		phydev->link = 1;
+	else
+		phydev->link = 0;
+
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	rc = lan87xx_read_master_slave(phydev);
+	if (rc < 0)
+		return rc;
+
+	rc = genphy_read_status_fixed(phydev);
+	if (rc < 0)
+		return rc;
+
+	return rc;
+}
+
+static int lan87xx_config_aneg(struct phy_device *phydev)
+{
+	u16 ctl = 0;
+	int rc;
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+		ctl |= CTL1000_AS_MASTER;
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+		break;
+	case MASTER_SLAVE_CFG_UNKNOWN:
+	case MASTER_SLAVE_CFG_UNSUPPORTED:
+		return 0;
+	default:
+		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+		return -EOPNOTSUPP;
+	}
+
+	rc = phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
+	if (rc == 1)
+		rc = genphy_soft_reset(phydev);
+
+	return rc;
+}
+
 static struct phy_driver microchip_t1_phy_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_LAN87XX),
@@ -682,6 +768,8 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		.handle_interrupt = lan87xx_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.config_aneg    = lan87xx_config_aneg,
+		.read_status	= lan87xx_read_status,
 		.cable_test_start = lan87xx_cable_test_start,
 		.cable_test_get_status = lan87xx_cable_test_get_status,
 	},
@@ -692,6 +780,8 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		.config_init	= lan87xx_config_init,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+		.config_aneg    = lan87xx_config_aneg,
+		.read_status	= lan87xx_read_status,
 		.cable_test_start = lan87xx_cable_test_start,
 		.cable_test_get_status = lan87xx_cable_test_get_status,
 	}
-- 
2.33.0

