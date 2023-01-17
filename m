Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F52D673505
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjASKDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjASKCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:02:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB58467796;
        Thu, 19 Jan 2023 02:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674122551; x=1705658551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t2d822SisjWrAgMVP+CU+3S3ocEmxglFWNbEHNbMl9M=;
  b=RiUTPqaylPW6iZzKPgU8X3OlfsK7bcbmpcDzb1RkHj/FQ5Pk1q6nKlGZ
   RIZb9jiCwIUG2ch4M0R9i3fappUio9C9dypTBk18g33Q0+cCtYmoiitF+
   IQIuVzsUU4Py0rMq3XVba6mH8+KSG0D8ECJpq9uypB//pFvCJwN7MVIzv
   guteerVL/F5SknlkPN5zd8FdUGhhPrBLzd1qZsC6CqJObxS2EEOj/CPjn
   O+2JyUv4LAW2NQu+0Gpq6TBLG1QghvenK2FdtokJkyodKDwVSkuvilQd5
   0cOvYPrfDFnPpJ2XU1hMPKbf5y2I6Zqo22bRgYRcsFhE0rLmivNmgHCLU
   A==;
X-IronPort-AV: E=Sophos;i="5.97,228,1669100400"; 
   d="scan'208";a="133088692"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jan 2023 03:02:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 03:02:29 -0700
Received: from che-dk-unglab44lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 03:02:26 -0700
From:   Pavithra Sathyanarayanan <Pavithra.Sathyanarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH net-next 3/3] net: lan743x: add fixed phy support for LAN7431 device
Date:   Tue, 17 Jan 2023 19:46:14 +0530
Message-ID: <20230117141614.4411-4-Pavithra.Sathyanarayanan@microchip.com>
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

Add fixed_phy support at 1Gbps full duplex for the lan7431 device
if a phy not found over MDIO. Tested with a MAC to MAC connection
from LAN7431 to a KSZ9893 switch. This avoids the Driver open error
in LAN743x. TX delay and internal CLK125 generation is already
enabled in EEPROM.

Signed-off-by: Pavithra Sathyanarayanan <Pavithra.Sathyanarayanan@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index fe3026ed6f03..b5add1c5fa06 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1491,6 +1491,11 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	struct lan743x_phy *phy = &adapter->phy;
+	struct fixed_phy_status fphy_status = {
+		.link = 1,
+		.speed = SPEED_1000,
+		.duplex = DUPLEX_FULL,
+	};
 	struct phy_device *phydev;
 	int ret = -EIO;
 
@@ -1501,8 +1506,19 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 	if (!phydev) {
 		/* try internal phy */
 		phydev = phy_find_first(adapter->mdiobus);
-		if (!phydev)
-			goto return_error;
+		if (!phydev)	{
+			if ((adapter->csr.id_rev & ID_REV_ID_MASK_) ==
+					ID_REV_ID_LAN7431_) {
+				phydev = fixed_phy_register(PHY_POLL,
+							    &fphy_status, NULL);
+				if (IS_ERR(phydev)) {
+					netdev_err(netdev, "No PHY/fixed_PHY found\n");
+					return -EIO;
+				}
+			} else {
+				goto return_error;
+				}
+		}
 
 		lan743x_phy_interface_select(adapter);
 
-- 
2.25.1

