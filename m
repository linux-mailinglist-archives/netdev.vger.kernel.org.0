Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8A35A969A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiIAMUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbiIAMUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:20:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1A2474F7;
        Thu,  1 Sep 2022 05:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662034807; x=1693570807;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=53b9EBspOpKrf/YGZr2ZNHUm/X4axsD5jzJZykL/iEU=;
  b=IWtpa9QjZEnDwWqIXDFHxQu5whIj89DJipdapaNPbBTpJ1cwOiM45QKB
   1dtJl4i4o3TeRAAeYSYKGPO7ytAYuScrwlgNth599BHhZjqiButw9KjDw
   F6XyoJuTUCQfaC7hm00+WHFxTUQJjiSxgDTx1pMEJpjpPi5jRxBO1LL6i
   4jHFcDvEY1R1qKvRcqU+9QQ/L7RSaTas3PQcYYPGQJdusMTECqgun7OFL
   0DKcYdR9CPQpYR8+s9ypB+5jqXk9vINiqcjG6cia5+ciIDvLYu4bHOruM
   2DZAt/VTpW+R0zZYbxirz73O2l9foB2qdOBkMHYltcaZ1bzFsO/pXaTXn
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="111735865"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Sep 2022 05:19:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Sep 2022 05:19:56 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 1 Sep 2022 05:19:54 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux@armlinux.org.uk>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Extend lan966x with RGMII support
Date:   Thu, 1 Sep 2022 14:23:46 +0200
Message-ID: <20220901122346.245786-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend lan966x with RGMII support. The MAC supports all RGMII_* modes.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c    | 8 ++++++++
 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1d6e3b641b2e..e2d250ed976b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -772,6 +772,14 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 
 	__set_bit(PHY_INTERFACE_MODE_MII,
 		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_RGMII,
+		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_RGMII_ID,
+		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_RGMII_RXID,
+		  port->phylink_config.supported_interfaces);
+	__set_bit(PHY_INTERFACE_MODE_RGMII_TXID,
+		  port->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_GMII,
 		  port->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_SGMII,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
index 38a7e95d69b4..fb6aee509656 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
@@ -59,6 +59,9 @@ static void lan966x_phylink_mac_link_up(struct phylink_config *config,
 	port_config->pause |= tx_pause ? MLO_PAUSE_TX : 0;
 	port_config->pause |= rx_pause ? MLO_PAUSE_RX : 0;
 
+	if (phy_interface_mode_is_rgmii(interface))
+		phy_set_speed(port->serdes, speed);
+
 	lan966x_port_config_up(port);
 }
 
-- 
2.33.0

