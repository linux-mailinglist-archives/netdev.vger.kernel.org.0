Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B1C670CF6
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjAQXOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjAQXNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:13:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FD58C929;
        Tue, 17 Jan 2023 12:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673989041; x=1705525041;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=1dySa7UmdtWanwrXlbKGP1PlLBaLqOsIW6dN4IkvW+c=;
  b=ZeHAp0yG1xcZoVuel4+QlpbmX3Ke80Y53snRSSKx0XWCHhRslUIyHjg1
   pGvQl4jSdBEGsk1m/i9//agYLLCmImQxuD3h+iKQKcfLFLao18vTjez+e
   W8Sx6GvtINHMMp/sAgdExVI+PLoSb+JaBMoauvAcYhH93hwkpqJPcHIKf
   VvnaEQ8BpTzhqNqIJXBzolm7oYoBCgniZ6bGQBZ7KKiEDzr1eguCwacOx
   XJGBkByS68yDKRgcujB8TLOi9/Oi2Nonrz5UpBOgJLfNpqEEElNLr0a4F
   wC/+/RPxWdBgjtMqmi52ef07wMn1LNuCqn4Em4eMtHrZMR7K6iT7nNbjx
   w==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="132797669"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 13:57:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 13:57:17 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 13:57:15 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [net-next: PATCH v7 5/7] dsa: lan9303: Port 0 is xMII port
Date:   Tue, 17 Jan 2023 14:57:01 -0600
Message-ID: <20230117205703.25960-6-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230117205703.25960-1-jerry.ray@microchip.com>
References: <20230117205703.25960-1-jerry.ray@microchip.com>
MIME-Version: 1.0
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

In preparing to move the adjust_link logic into the phylink_mac_link_up
api, change the macro used to check for the cpu port. In
phylink_mac_link_up, the phydev pointer passed in for the CPU port is
NULL, so we can't keep using phy_is_pseudo_fixed_link(phydev).

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index a4decf42a002..a4cc76423d4b 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -15,6 +15,9 @@
 
 #include "lan9303.h"
 
+/* For the LAN9303 and LAN9354, only port 0 is an XMII port. */
+#define IS_PORT_XMII(port)	((port) == 0)
+
 #define LAN9303_NUM_PORTS 3
 
 /* 13.2 System Control and Status Registers
@@ -1066,7 +1069,11 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 {
 	int ctl;
 
-	if (!phy_is_pseudo_fixed_link(phydev))
+	/* On this device, we are only interested in doing something here if
+	 * this is an xMII port. All other ports are 10/100 phys using MDIO
+	 * to control there link settings.
+	 */
+	if (!IS_PORT_XMII(port))
 		return;
 
 	ctl = lan9303_phy_read(ds, port, MII_BMCR);
-- 
2.17.1

