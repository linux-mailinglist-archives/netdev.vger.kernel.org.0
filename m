Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683984CD12F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbiCDJhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbiCDJgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:36:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ACD1A6375;
        Fri,  4 Mar 2022 01:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646386546; x=1677922546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=54M4w1EDLE8QNkdXmAR9uZulKSEVc54n/sn/k/7upUQ=;
  b=p59rbIlBuCRGI8t4FRSqcQ5if+Mj+elUqTyMRsjYDjNnGJVv85egmM1H
   mbzF0mdUTyO96BSkzOeI87CydbeElqqlNSMtjOv0VuAInVlc8VLBC5ux9
   SgCXgX8335Y8M98fEj9MLs5zzyY3hDrwWNpTXM8XZF3BVmxcWX3X71y8a
   zNU13QtSfLNaIRgnjDEll7DKdb8LrJRBrsnqSHWS2nQvmJ6fAVkW30rwp
   7OWq7btTSpgdeg+N/VzmrR9GDtmWB7hjKS9oS/TsXJvRqcXyx6f0RdpLe
   nR5D4PhAN2P1Nf6beFhuDCokr1GMU7gMaUMDxv3M35XJ70DOj7ai+QLnA
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="148080784"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:35:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:35:43 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:35:39 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <richardcochran@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <madhuri.sripada@microchip.com>, <manohar.puri@microchip.com>
Subject: [PATCH net-next 1/3] net: phy: micrel: Fix concurrent register access
Date:   Fri, 4 Mar 2022 15:04:16 +0530
Message-ID: <20220304093418.31645-2-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304093418.31645-1-Divya.Koppera@microchip.com>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
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

Make Extended page register accessing atomic,
to overcome unexpected output from register
reads/writes.

Fixes: 7c2dcfa295b1 ("net: phy: micrel: Add support for LAN8804 PHY")
Signed-off-by: Divya Koppera<Divya.Koppera@microchip.com>
---
 drivers/net/phy/micrel.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a7ebcdab415b..281cebc3d00c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1596,11 +1596,13 @@ static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
 {
 	u32 data;
 
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
-		  (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
-	data = phy_read(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA);
+	phy_lock_mdio_bus(phydev);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
+		    (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
+	data = __phy_read(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA);
+	phy_unlock_mdio_bus(phydev);
 
 	return data;
 }
@@ -1608,18 +1610,18 @@ static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
 static int lanphy_write_page_reg(struct phy_device *phydev, int page, u16 addr,
 				 u16 val)
 {
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
-	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
-		  (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
+	phy_lock_mdio_bus(phydev);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
+		    page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC);
 
-	val = phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, val);
-	if (val) {
+	val = __phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, val);
+	if (val != 0)
 		phydev_err(phydev, "Error: phy_write has returned error %d\n",
 			   val);
-		return val;
-	}
-	return 0;
+	phy_unlock_mdio_bus(phydev);
+	return val;
 }
 
 static int lan8814_config_init(struct phy_device *phydev)
-- 
2.17.1

