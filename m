Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189F12FC1B2
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbhASU5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403965AbhASU4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 15:56:36 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4799C061573
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 12:55:30 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DL1Bm6sWhz1rwDY;
        Tue, 19 Jan 2021 21:55:28 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DL1Bm68tKz1qrQ6;
        Tue, 19 Jan 2021 21:55:28 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 2QBX1DN4UZcZ; Tue, 19 Jan 2021 21:55:27 +0100 (CET)
X-Auth-Info: mE9jFYEW+pdblXjJks0ozHqlLxAocmHNNAvEuTnsuOM=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 19 Jan 2021 21:55:27 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: dsa: microchip: ksz8795: Fix KSZ8794 port map again
Date:   Tue, 19 Jan 2021 21:55:18 +0100
Message-Id: <20210119205518.470974-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ8795 switch has 4 external ports {0,1,2,3} and 1 CPU port {4}, so
does the KSZ8765. The KSZ8794 seems to be repackaged KSZ8795 with different
ID and port 3 not routed out, however the port 3 registers are present in
the silicon, so the KSZ8794 switch has 3 external ports {0,1,2} and 1 CPU
port {4}. Currently the driver always uses the last port as CPU port, on
KSZ8795/KSZ8765 that is port 4 and that is OK, but on KSZ8794 that is port
3 and that is not OK, as it must also be port 4.

This patch adjusts the driver such that it always registers a switch with
5 ports total (4 external ports, 1 CPU port), always sets the CPU port to
switch port 4, and then configures the external port mask according to
the switch model -- 3 ports for KSZ8794 and 4 for KSZ8795/KSZ8765.

Fixes: 68a1b676db52 ("net: dsa: microchip: ksz8795: remove superfluous port_cnt assignment")
Fixes: 4ce2a984abd8 ("net: dsa: microchip: ksz8795: use phy_port_cnt where possible")
Fixes: 241ed719bc98 ("net: dsa: microchip: ksz8795: use port_cnt instead of TOTOAL_PORT_NUM")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Jakub Kicinski <kuba@kernel.org>
---
NOTE: In case of KSZ8794, the DT node port@4 is the CPU port and
      port@3 should not be defined.
---
 drivers/net/dsa/microchip/ksz8795.c | 30 +++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index c973db101b72..a4570ba29c83 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1187,6 +1187,20 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.port_cnt = 5,		/* total cpu and user ports */
 	},
 	{
+		/*
+		 * WARNING
+		 * =======
+		 * KSZ8794 is similar to KSZ8795, except the port map
+		 * contains a gap between external and CPU ports, the
+		 * port map is NOT continuous. The per-port register
+		 * map is shifted accordingly too, i.e. registers at
+		 * offset 0x40 are NOT used on KSZ8794 and they ARE
+		 * used on KSZ8795 for external port 3.
+		 *           external  cpu
+		 * KSZ8794   0,1,2      4
+		 * KSZ8795   0,1,2,3    4
+		 * KSZ8765   0,1,2,3    4
+		 */
 		.chip_id = 0x8794,
 		.dev_name = "KSZ8794",
 		.num_vlans = 4096,
@@ -1220,9 +1234,13 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 			dev->num_vlans = chip->num_vlans;
 			dev->num_alus = chip->num_alus;
 			dev->num_statics = chip->num_statics;
-			dev->port_cnt = chip->port_cnt;
+			dev->port_cnt = fls(chip->cpu_ports);
+			dev->cpu_port = fls(chip->cpu_ports) - 1;
+			dev->phy_port_cnt = dev->port_cnt - 1;
 			dev->cpu_ports = chip->cpu_ports;
-
+			dev->host_mask = chip->cpu_ports;
+			dev->port_mask = (BIT(dev->phy_port_cnt) - 1) |
+					 chip->cpu_ports;
 			break;
 		}
 	}
@@ -1231,17 +1249,9 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	if (!dev->cpu_ports)
 		return -ENODEV;
 
-	dev->port_mask = BIT(dev->port_cnt) - 1;
-	dev->port_mask |= dev->host_mask;
-
 	dev->reg_mib_cnt = KSZ8795_COUNTER_NUM;
 	dev->mib_cnt = ARRAY_SIZE(mib_names);
 
-	dev->phy_port_cnt = dev->port_cnt - 1;
-
-	dev->cpu_port = dev->port_cnt - 1;
-	dev->host_mask = BIT(dev->cpu_port);
-
 	dev->ports = devm_kzalloc(dev->dev,
 				  dev->port_cnt * sizeof(struct ksz_port),
 				  GFP_KERNEL);
-- 
2.29.2

