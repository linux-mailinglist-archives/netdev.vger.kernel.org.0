Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A20968EE2F
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjBHLon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjBHLom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:44:42 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6124615B;
        Wed,  8 Feb 2023 03:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675856680; x=1707392680;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z1IbDELn3EAaZaLU4TNEjPVAR6fEvO0fS+Iyr7LDl2c=;
  b=SFt5HzB+FmU7qZ+BgYVxYliJzgtwKzOqJ70LO7pyEQDHph9A2qcZ0S19
   eg2vgE2U5A++nuXjVZDcCP8vSiMxjig2ez9XF0D3iDCcw5jNlZ5LAi7Ct
   gA14KU3gNSwtZ1M+Ps+/dQiQMlA+0eb3aXSJT32qy8mUKzvI+NWXJXxKg
   dRG5qtkpDnZj5Ef/V8m/1CZ8GwqVvLiyiNIUNrwJACQs/daNN0jpQ7OVf
   dUYEpXqy4zmEMCAEgOYVBziB+Xdil86p/6ztWlkevIU9heNoUZAw1gSlU
   b6tOi3day0/nceBEGKHkqVv7pxY/EFLMNyUJ0JQSj/C6RCGvHcQrVnQdn
   w==;
X-IronPort-AV: E=Sophos;i="5.97,280,1669100400"; 
   d="scan'208";a="211079237"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Feb 2023 04:44:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 04:44:38 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 04:44:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: micrel: Cable Diagnostics feature for lan8841 PHY
Date:   Wed, 8 Feb 2023 12:44:06 +0100
Message-ID: <20230208114406.1666671-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for cable diagnostics in lan8841 PHY. It has the same
registers layout as lan8814 PHY, therefore reuse the functionality.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 01677c28e4079..727de4f4a14db 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -378,6 +378,8 @@ static const struct kszphy_type lan8841_type = {
 	.disable_dll_tx_bit	= BIT(14),
 	.disable_dll_rx_bit	= BIT(14),
 	.disable_dll_mask	= BIT_MASK(14),
+	.cable_diag_reg		= LAN8814_CABLE_DIAG,
+	.pair_mask		= LAN8814_WIRE_PAIR_MASK,
 };
 
 static int kszphy_extended_write(struct phy_device *phydev,
@@ -3520,6 +3522,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id		= PHY_ID_LAN8841,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip LAN8841 Gigabit PHY",
+	.flags		= PHY_POLL_CABLE_TEST,
 	.driver_data	= &lan8841_type,
 	.config_init	= lan8841_config_init,
 	.probe		= lan8841_probe,
@@ -3531,6 +3534,8 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
+	.cable_test_start	= lan8814_cable_test_start,
+	.cable_test_get_status	= ksz886x_cable_test_get_status,
 }, {
 	.phy_id		= PHY_ID_KSZ9131,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.38.0

