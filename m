Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121915268D6
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383199AbiEMR5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbiEMR5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:57:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7D41312AA;
        Fri, 13 May 2022 10:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652464619; x=1684000619;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=E5uYlfEx8G4vbMsaJMA/1PseB1AhKPjUjBAp4ujFeuU=;
  b=WWvlxcSpA6jB93VD3WUTxsrEM7s+EMZ7nWH/JfJBQodNZ7KiRpRju9MD
   CYZwb+QnriF/kjL1uizh0OjBOMdIY6I9ZDNN3ynl1nGjdA58bHIYUJYy1
   HT8a4aJcPp/t3faiRmaYnxNHJiHi0xEQqZtTCYxuvIkZ22vNLmC1V3Lh3
   XaAsd7Z4+Ti2kBoh3LJfUQMO8FuKV8llxXuwB1JtX6a423A1i9eforSyh
   e/2GU45TKwzCeUIRN8GjT+d/z0VMzzsNz4YlZwkZuFiIHYTrztXNY1zTk
   kpuyRv3gPBNaCaK1DBE2o2hETeA3G5+noRkLbN//lrLjVD+ZLDT3LnUns
   w==;
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="95725549"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 May 2022 10:56:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 13 May 2022 10:56:58 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 13 May 2022 10:56:56 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: lan966x: Fix assignment of the MAC address
Date:   Fri, 13 May 2022 20:00:30 +0200
Message-ID: <20220513180030.3076793-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following two scenarios were failing for lan966x.
1. If the port had the address X and then trying to assign the same
   address, then the HW was just removing this address because first it
   tries to learn new address and then delete the old one. As they are
   the same the HW remove it.
2. If the port eth0 was assigned the same address as one of the other
   ports eth1 then when assigning back the address to eth0 then the HW
   was deleting the address of eth1.

The case 1. is fixed by checking if the port has already the same
address while case 2. is fixed by checking if the address is used by any
other port.

Fixes: e18aba8941b40b ("net: lan966x: add mactable support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 95830e3e2b1f..05f6dcc9dfd5 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -103,6 +103,24 @@ static int lan966x_create_targets(struct platform_device *pdev,
 	return 0;
 }
 
+static bool lan966x_port_unique_address(struct net_device *dev)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	int p;
+
+	for (p = 0; p < lan966x->num_phys_ports; ++p) {
+		port = lan966x->ports[p];
+		if (!port || port->dev == dev)
+			continue;
+
+		if (ether_addr_equal(dev->dev_addr, port->dev->dev_addr))
+			return false;
+	}
+
+	return true;
+}
+
 static int lan966x_port_set_mac_address(struct net_device *dev, void *p)
 {
 	struct lan966x_port *port = netdev_priv(dev);
@@ -110,16 +128,26 @@ static int lan966x_port_set_mac_address(struct net_device *dev, void *p)
 	const struct sockaddr *addr = p;
 	int ret;
 
+	if (ether_addr_equal(addr->sa_data, dev->dev_addr))
+		return 0;
+
 	/* Learn the new net device MAC address in the mac table. */
 	ret = lan966x_mac_cpu_learn(lan966x, addr->sa_data, HOST_PVID);
 	if (ret)
 		return ret;
 
+	/* If there is another port with the same address as the dev, then don't
+	 * delete it from the MAC table
+	 */
+	if (!lan966x_port_unique_address(dev))
+		goto out;
+
 	/* Then forget the previous one. */
 	ret = lan966x_mac_cpu_forget(lan966x, dev->dev_addr, HOST_PVID);
 	if (ret)
 		return ret;
 
+out:
 	eth_hw_addr_set(dev, addr->sa_data);
 	return ret;
 }
-- 
2.33.0

