Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96FD673506
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjASKDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjASKCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:02:36 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B9A53E41;
        Thu, 19 Jan 2023 02:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674122548; x=1705658548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QjW6uTTrCngsKFsBw4FCaTlM6YMMp5h8Uj4gd/whf9E=;
  b=UVzXsZOEZYEiJy1Kq1giAw5fN35pfhIMBYj4t0KztkGwkse47HJSGxLo
   qhtI6OhVWagaLHfANci6nMBDxlHFxO/UOUggRNBR/MsCW5kJrnxmq95kd
   3EfZOTAXMbNBWoGUMQDQB6cMLoIEisbpg7DLdyGcBHKlV5flaKn+rSRIf
   spxQmqXWoCJua02SEyBZA35rNCUA3GHXXJtraJme/0NOKEh0OljUHDOCm
   sGdGn/vGVfTxarewHnyGv4BsnaTuSkREza6YtMcsdViHz9dsQWDAFZTtC
   m4ncpxkHhteW56szIp87zKgV6ijfWC0FtWkS28LrH0Ri2I147xms7Ui6n
   g==;
X-IronPort-AV: E=Sophos;i="5.97,228,1669100400"; 
   d="scan'208";a="133088671"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2023 03:02:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 03:02:25 -0700
Received: from che-dk-unglab44lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 03:02:22 -0700
From:   Pavithra Sathyanarayanan <Pavithra.Sathyanarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH net-next 2/3] net: lan743x: add generic implementation for phy interface selection
Date:   Tue, 17 Jan 2023 19:46:13 +0530
Message-ID: <20230117141614.4411-3-Pavithra.Sathyanarayanan@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230117141614.4411-1-Pavithra.Sathyanarayanan@microchip.com>
References: <20230117141614.4411-1-Pavithra.Sathyanarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add logic to read the Phy interface from MAC_CR register for LAN743x
driver.

Checks for the LAN7430/31 or pci11x1x devices and the adapter
interface is updated accordingly. For LAN7431, adapter interface is set
based on Bit 19 of MAC_CR register as MII or RGMII which removes the
forced RGMII/GMII configurations in lan743x_phy_open().

Signed-off-by: Pavithra Sathyanarayanan <Pavithra.Sathyanarayanan@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 31 ++++++++++++++-----
 drivers/net/ethernet/microchip/lan743x_main.h |  1 +
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index c4d16f4654b5..fe3026ed6f03 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1469,6 +1469,24 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 	netdev->phydev = NULL;
 }
 
+static void lan743x_phy_interface_select(struct lan743x_adapter *adapter)
+{
+	u32 id_rev;
+	u32 data;
+
+	data = lan743x_csr_read(adapter, MAC_CR);
+	id_rev = adapter->csr.id_rev & ID_REV_ID_MASK_;
+
+	if (adapter->is_pci11x1x && adapter->is_sgmii_en)
+		adapter->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	else if (id_rev == ID_REV_ID_LAN7430_)
+		adapter->phy_interface = PHY_INTERFACE_MODE_GMII;
+	else if ((id_rev == ID_REV_ID_LAN7431_) && (data & MAC_CR_MII_EN_))
+		adapter->phy_interface = PHY_INTERFACE_MODE_MII;
+	else
+		adapter->phy_interface = PHY_INTERFACE_MODE_RGMII;
+}
+
 static int lan743x_phy_open(struct lan743x_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
@@ -1486,14 +1504,11 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 		if (!phydev)
 			goto return_error;
 
-		if (adapter->is_pci11x1x)
-			ret = phy_connect_direct(netdev, phydev,
-						 lan743x_phy_link_status_change,
-						 PHY_INTERFACE_MODE_RGMII);
-		else
-			ret = phy_connect_direct(netdev, phydev,
-						 lan743x_phy_link_status_change,
-						 PHY_INTERFACE_MODE_GMII);
+		lan743x_phy_interface_select(adapter);
+
+		ret = phy_connect_direct(netdev, phydev,
+					 lan743x_phy_link_status_change,
+					 adapter->phy_interface);
 		if (ret)
 			goto return_error;
 	}
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 8438c3dbcf36..52609fc13ad9 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -1042,6 +1042,7 @@ struct lan743x_adapter {
 #define LAN743X_ADAPTER_FLAG_OTP		BIT(0)
 	u32			flags;
 	u32			hw_cfg;
+	phy_interface_t		phy_interface;
 };
 
 #define LAN743X_COMPONENT_FLAG_RX(channel)  BIT(20 + (channel))
-- 
2.25.1

