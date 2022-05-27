Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B5B535839
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 06:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiE0ERp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 00:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240897AbiE0ERn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 00:17:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6775A22BE8;
        Thu, 26 May 2022 21:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1653625061; x=1685161061;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=48BhHJDKMqxcf9JijWKD4BBNU2yVtVD9EUhV8PmRrwI=;
  b=fBmFDYZgm3wtxK6Q8rc4QP75v7YIpdQmf16O03V2EzUVcXqFTo+5+XU3
   VNniv9vFzme7l5EIFqaGyvqk6HuNNhIQzRwYhOYPRmTb9AOlAlG3wLRcU
   WZ6vjht4HCKrUb+d9LRoqpwt+5yJspZJR4bESn/SnQmeaI2XT0gSd8lqq
   qcLNj/w0EOY94gMlJtjT/8qktk8fVz7QUyFOZ4R1sVkayZXKyhn8mpo5H
   c5Iyfa4jk4EiczvZjz1EZUp8NTR59em81gxLYOs06O/dy5AKqD3ib4GNo
   62IDC5HmW60YZRqQjAm5VGFpIC/tEiqIN6n/hqDPTyrzg512sBXAPAopm
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="175335209"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 May 2022 21:17:39 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 26 May 2022 21:17:39 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 26 May 2022 21:17:36 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: [PATCH net-next] net: lan743x: PCI11010 / PCI11414 fix
Date:   Fri, 27 May 2022 09:47:28 +0530
Message-ID: <20220527041728.3257-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the MDIO interface declarations to reflect what is currently supported by
the PCI11010 / PCI11414 devices (C22 for RGMII and C22_C45 for SGMII)

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 32 +++++++++++++------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index efbddf24ba31..af81236b4b4e 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1164,9 +1164,14 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
 		if (!phydev)
 			goto return_error;
 
-		ret = phy_connect_direct(netdev, phydev,
-					 lan743x_phy_link_status_change,
-					 PHY_INTERFACE_MODE_GMII);
+		if (adapter->is_pci11x1x)
+			ret = phy_connect_direct(netdev, phydev,
+						 lan743x_phy_link_status_change,
+						 PHY_INTERFACE_MODE_RGMII);
+		else
+			ret = phy_connect_direct(netdev, phydev,
+						 lan743x_phy_link_status_change,
+						 PHY_INTERFACE_MODE_GMII);
 		if (ret)
 			goto return_error;
 	}
@@ -2936,20 +2941,27 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 			netif_dbg(adapter, drv, adapter->netdev,
 				  "SGMII operation\n");
+			adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
+			adapter->mdiobus->read = lan743x_mdiobus_c45_read;
+			adapter->mdiobus->write = lan743x_mdiobus_c45_write;
+			adapter->mdiobus->name = "lan743x-mdiobus-c45";
+			netif_dbg(adapter, drv, adapter->netdev,
+				  "lan743x-mdiobus-c45\n");
 		} else {
 			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
 			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
 			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
 			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 			netif_dbg(adapter, drv, adapter->netdev,
-					  "(R)GMII operation\n");
+				  "RGMII operation\n");
+			// Only C22 support when RGMII I/F
+			adapter->mdiobus->probe_capabilities = MDIOBUS_C22;
+			adapter->mdiobus->read = lan743x_mdiobus_read;
+			adapter->mdiobus->write = lan743x_mdiobus_write;
+			adapter->mdiobus->name = "lan743x-mdiobus";
+			netif_dbg(adapter, drv, adapter->netdev,
+				  "lan743x-mdiobus\n");
 		}
-
-		adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
-		adapter->mdiobus->read = lan743x_mdiobus_c45_read;
-		adapter->mdiobus->write = lan743x_mdiobus_c45_write;
-		adapter->mdiobus->name = "lan743x-mdiobus-c45";
-		netif_dbg(adapter, drv, adapter->netdev, "lan743x-mdiobus-c45\n");
 	} else {
 		adapter->mdiobus->read = lan743x_mdiobus_read;
 		adapter->mdiobus->write = lan743x_mdiobus_write;
-- 
2.25.1

