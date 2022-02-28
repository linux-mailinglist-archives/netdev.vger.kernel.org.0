Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252DF4C6ED8
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 15:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbiB1OGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 09:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiB1OGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 09:06:51 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707777E0BE;
        Mon, 28 Feb 2022 06:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646057170; x=1677593170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aB6tsQO5NdtWQGgRcFJZBuZsgZEyzxfsClecSYXpeRg=;
  b=tYLhYC3Ur1+xEkjIPhno+d1DHi2jHyGVmamu298Ymv/KvGEz1NP7J2n+
   odLWLZMlfNJlGYYnrmfs3uCfMlvxPihrdh9kZD4cPNdxi+nCbObMrbn6K
   PvXXr6azzxVnAb4j6aqOPpYVujQDlBhSRAiqyMa5Jd76QYXOJoofn/3+b
   KEZJQEb4wYT295I0eqt0opEVgOCKRmI5MWdIxKUw2nT/qtQiZc0DKvPZ3
   jgOK0psrzI54+tAKq7pa5kteH+l1OljhVsW895QsFehVQfvZkE1ASuiJj
   cwGUgZOKL8z+tiEig5m2AWEC12lqAs0FrvBjU9iko917sSdEei8aKhK0u
   g==;
X-IronPort-AV: E=Sophos;i="5.90,142,1643698800"; 
   d="scan'208";a="150238011"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Feb 2022 07:06:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Feb 2022 07:06:09 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 28 Feb 2022 07:06:05 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH net-next 4/4] net: phy: added master-slave config and cable diagnostics for Lan937x
Date:   Mon, 28 Feb 2022 19:35:10 +0530
Message-ID: <20220228140510.20883-5-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220228140510.20883-1-arun.ramadoss@microchip.com>
References: <20220228140510.20883-1-arun.ramadoss@microchip.com>
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

To configure the Lan937x T1 phy as master or slave using the ethtool -s
<dev> master-slave <forced-master/forced-slave>, the config_aneg and
read status functions are added. And for the cable-diagnostics, used the
lan87xx routines.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 75 ++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 634a1423182a..3a0d4c4fab0a 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -81,6 +81,9 @@
 #define T1_REG_BANK_SEL			8
 #define T1_REG_ADDR_MASK		0xFF
 
+#define T1_MODE_STAT_REG		0x11
+#define T1_LINK_UP_MSK			BIT(0)
+
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
 #define DRIVER_DESC	"Microchip LAN87XX/LAN937x T1 PHY driver"
 
@@ -435,6 +438,11 @@ static int lan_phy_config_init(struct phy_device *phydev)
 	if (rc < 0)
 		phydev_err(phydev, "failed to initialize phy\n");
 
+	phydev->duplex = DUPLEX_FULL;
+	phydev->speed = SPEED_100;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
 	return rc < 0 ? rc : 0;
 }
 
@@ -666,6 +674,69 @@ static int lan87xx_cable_test_get_status(struct phy_device *phydev,
 	return 0;
 }
 
+static int lan937x_read_status(struct phy_device *phydev)
+{
+	int rc;
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
+	return 0;
+}
+
+static int lan937x_config_aneg(struct phy_device *phydev)
+{
+	int rc;
+	u16 ctl = 0;
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
 		.phy_id         = LAN87XX_PHY_ID,
@@ -689,6 +760,10 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 		.config_init	= lan_phy_config_init,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+		.config_aneg    = lan937x_config_aneg,
+		.read_status	= lan937x_read_status,
+		.cable_test_start = lan87xx_cable_test_start,
+		.cable_test_get_status = lan87xx_cable_test_get_status,
 	}
 };
 
-- 
2.33.0

