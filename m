Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E55652E8A
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 10:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbiLUJ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 04:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbiLUJ24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 04:28:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3481921888;
        Wed, 21 Dec 2022 01:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671614935; x=1703150935;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3WKvHVDNb03Jat865yIQb6SOcxCvC//LGxrFtZRCdxA=;
  b=ik8SCtyhafgY0cAUORZ1yXAnW+rbMUdXh3ZC/f7msrp0gf15wDswnd+C
   FVCGmAjlIA/6uVAP5LpBR1AapP0GYrFIIigygDeNT+XF3V3seb+rT/okw
   Kjd0PKb3lxHWpHpgDZf0sAA2nWUYy/cbU8DV6xjwmloWjKRaxe/UX27pw
   xeIWw3r/w/z7/Mp8ou8AZvXFbwjFWoFot0kMTELwJqH1AVdlHoxKEWGtZ
   xEiLeTjVaw2biFYjJZya8PVEOQvL7OcTuMErEFx9w7UeMsrok6pJItKzx
   Fg2pKOj68k4vX19g8kALoyjWdlsgVVJewyW0yxROADya+rQCbtiySCCUT
   A==;
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="193885296"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2022 02:28:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 21 Dec 2022 02:28:53 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 21 Dec 2022 02:28:51 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: lan966x: Fix configuration of the PCS
Date:   Wed, 21 Dec 2022 10:33:15 +0100
Message-ID: <20221221093315.939133-1-horatiu.vultur@microchip.com>
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

When the PCS was taken out of reset, we were changing by mistake also
the speed to 100 Mbit. But in case the link was going down, the link
up routine was setting correctly the link speed. If the link was not
getting down then the speed was forced to run at 100 even if the
speed was something else.
On lan966x, to set the speed link to 1G or 2.5G a value of 1 needs to be
written in DEV_CLOCK_CFG_LINK_SPEED. This is similar to the procedure in
lan966x_port_init.

The issue was reproduced using 1000base-x sfp module using the commands:
ip link set dev eth2 up
ip link addr add 10.97.10.2/24 dev eth2
ethtool -s eth2 speed 1000 autoneg off

Fixes: d28d6d2e37d1 ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 1a61c6cdb0779..0050fcb988b75 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -381,7 +381,7 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 	}
 
 	/* Take PCS out of reset */
-	lan_rmw(DEV_CLOCK_CFG_LINK_SPEED_SET(2) |
+	lan_rmw(DEV_CLOCK_CFG_LINK_SPEED_SET(LAN966X_SPEED_1000) |
 		DEV_CLOCK_CFG_PCS_RX_RST_SET(0) |
 		DEV_CLOCK_CFG_PCS_TX_RST_SET(0),
 		DEV_CLOCK_CFG_LINK_SPEED |
-- 
2.38.0

