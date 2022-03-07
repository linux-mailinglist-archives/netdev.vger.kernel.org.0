Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FF44CFC0A
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 11:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbiCGK60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 05:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241618AbiCGK5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 05:57:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52BDB1A91;
        Mon,  7 Mar 2022 02:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646648301; x=1678184301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dh8PzIfJiPCzTN7WEamPmt35iPAGsg8PeFy1mRkWkWg=;
  b=f/UCfcPJIiBeedE+no0v6uZm0bFFiuWXtxxAMQbPkuMaJfovwo9IEQmu
   4fKFNxLdvw02PhJBLGfZMuJTZ0zw2QJLXUQGDg2ZGUJng33oFZ62iwODo
   FtWRLIM1pmCkn8B7ud4tk6lpGj1HQPKk0IW9tbJZqHg1kzDA8iZOto0tC
   b4Xv+fxKjD70Qbf02f7f/Hpb2k5bKZ2pz5fle8EvpWIFxggGeKRNjCFfm
   p9U/GrmvtsnPvEWaXauHJ84HFiDe5mkx7M3s7GIKm9Pop1Veg5FQNxWJc
   482bw3wIw65JQ4ll0qvg8bGND82JMYis2aaTD6ifCWCZb4oUxjW/hqd56
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,161,1643698800"; 
   d="scan'208";a="148311443"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2022 03:18:21 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Mar 2022 03:18:19 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Mar 2022 03:18:15 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [RFC PATCH net-next 1/2] net: phy: exported the genphy_read_master_slave function
Date:   Mon, 7 Mar 2022 15:47:42 +0530
Message-ID: <20220307101743.8567-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220307101743.8567-1-arun.ramadoss@microchip.com>
References: <20220307101743.8567-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

genphy_read_master_slave function allows to configure the master/slave
for gigabit phys only. In order to use this function irrespective of
speed, moved the speed check to the genphy_read_status call.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/phy_device.c | 20 ++++++++++----------
 include/linux/phy.h          |  1 +
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ce0bb5951b81..19d15a6d9b3e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2051,17 +2051,11 @@ static int genphy_setup_master_slave(struct phy_device *phydev)
 				   CTL1000_PREFER_MASTER), ctl);
 }
 
-static int genphy_read_master_slave(struct phy_device *phydev)
+int genphy_read_master_slave(struct phy_device *phydev)
 {
 	int cfg, state;
 	int val;
 
-	if (!phydev->is_gigabit_capable) {
-		phydev->master_slave_get = MASTER_SLAVE_CFG_UNSUPPORTED;
-		phydev->master_slave_state = MASTER_SLAVE_STATE_UNSUPPORTED;
-		return 0;
-	}
-
 	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
 	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
 
@@ -2102,6 +2096,7 @@ static int genphy_read_master_slave(struct phy_device *phydev)
 
 	return 0;
 }
+EXPORT_SYMBOL(genphy_read_master_slave);
 
 /**
  * genphy_restart_aneg - Enable and Restart Autonegotiation
@@ -2401,9 +2396,14 @@ int genphy_read_status(struct phy_device *phydev)
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
 
-	err = genphy_read_master_slave(phydev);
-	if (err < 0)
-		return err;
+	if (phydev->is_gigabit_capable) {
+		err = genphy_read_master_slave(phydev);
+		if (err < 0)
+			return err;
+	} else {
+		phydev->master_slave_get = MASTER_SLAVE_CFG_UNSUPPORTED;
+		phydev->master_slave_state = MASTER_SLAVE_STATE_UNSUPPORTED;
+	}
 
 	err = genphy_read_lpa(phydev);
 	if (err < 0)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index cd08cf1a8b0d..20beeaa7443b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1578,6 +1578,7 @@ int genphy_update_link(struct phy_device *phydev);
 int genphy_read_lpa(struct phy_device *phydev);
 int genphy_read_status_fixed(struct phy_device *phydev);
 int genphy_read_status(struct phy_device *phydev);
+int genphy_read_master_slave(struct phy_device *phydev);
 int genphy_suspend(struct phy_device *phydev);
 int genphy_resume(struct phy_device *phydev);
 int genphy_loopback(struct phy_device *phydev, bool enable);
-- 
2.33.0

