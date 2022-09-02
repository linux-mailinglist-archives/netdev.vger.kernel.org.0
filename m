Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5ECB5AAD32
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbiIBLMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbiIBLL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:11:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5A1CEB1B;
        Fri,  2 Sep 2022 04:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662117096; x=1693653096;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UDTJXTdSb4+Qwcn0yisNuqnbyrqohrF1M6uvyun7ndw=;
  b=NWM446OmVjsvezPWPPkzES6UylZcVS3D5yoeNXZnGbeWJA3mfACtG56c
   ewWNqMEh5w6yLHf9EY2kd12GhIFf1x5SPI7SGcRxGhXDuV/yncU/wapfK
   MHcIr+u5IhSyLBgxfR9wBiKmyovjtj8eqSmce4bkpUgFAyBSmjZF1T9om
   6v7whwzO5mVtYtsI+tU54kPQv8RrqJ57ldPBNakG1HI9cg5tYKgyrPOcI
   JBK+jIfZKVnQN6QF5lWO2uHUZlaI/uHCiUFpfXBlCvh6kcYP5XtBzigzF
   1KrqDoPxECMBU25Sei4cs1Askyg15kxSjkKumHizuthNHl5qPwteLYvNc
   w==;
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="111908933"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 04:11:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 04:11:34 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Sep 2022 04:11:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux@armlinux.org.uk>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2] net: lan966x: Extend lan966x with RGMII support
Date:   Fri, 2 Sep 2022 13:15:48 +0200
Message-ID: <20220902111548.614525-1-horatiu.vultur@microchip.com>
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
v1->v2:
- use phy_interface_set_rgmii instead of setting each individual
  variant
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c    | 1 +
 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1d6e3b641b2e..d838f6b9e2a6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -770,6 +770,7 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 	port->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 		MAC_10 | MAC_100 | MAC_1000FD | MAC_2500FD;
 
+	phy_interface_set_rgmii(port->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_MII,
 		  port->phylink_config.supported_interfaces);
 	__set_bit(PHY_INTERFACE_MODE_GMII,
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

