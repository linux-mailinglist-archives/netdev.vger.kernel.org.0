Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811962CADB0
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgLAUqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgLAUqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:46:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C13C061A4C
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 12:45:16 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWP-0002sw-Up; Tue, 01 Dec 2020 21:45:13 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWK-0002by-5o; Tue, 01 Dec 2020 21:45:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 08/11] net: dsa: microchip: ksz8795: align port_cnt usage with other microchip drivers
Date:   Tue,  1 Dec 2020 21:45:03 +0100
Message-Id: <20201201204506.13473-9-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201204506.13473-1-m.grzeschik@pengutronix.de>
References: <20201201204506.13473-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ksz8795 driver is using port_cnt differently to the other microchip
DSA drivers. It sets it to the external physical port count, than the
whole port count (including the cpu port). This patch is aligning the
variables purpose with the other microchip drivers.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1 -> v2: - improved comment in port_cnt assignment, rather than removing it
---
 drivers/net/dsa/microchip/ksz8795.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 5cb05ae08f849..96029e5a914fb 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1184,7 +1184,7 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 4,		/* total physical port count */
+		.port_cnt = 5,		/* total cpu and user ports */
 	},
 	{
 		.chip_id = 0x8794,
@@ -1193,7 +1193,7 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 3,		/* total physical port count */
+		.port_cnt = 4,		/* total cpu and user ports */
 	},
 	{
 		.chip_id = 0x8765,
@@ -1202,7 +1202,7 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 4,		/* total physical port count */
+		.port_cnt = 5,		/* total cpu and user ports */
 	},
 };
 
@@ -1238,7 +1238,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	dev->mib_cnt = ARRAY_SIZE(mib_names);
 
 	dev->mib_port_cnt = TOTAL_PORT_NUM;
-	dev->phy_port_cnt = dev->port_cnt;
+	dev->phy_port_cnt = dev->port_cnt - 1;
 
 	dev->cpu_port = dev->mib_port_cnt - 1;
 	dev->host_mask = BIT(dev->cpu_port);
@@ -1260,7 +1260,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	}
 
 	/* set the real number of ports */
-	dev->ds->num_ports = dev->port_cnt + 1;
+	dev->ds->num_ports = dev->port_cnt;
 
 	return 0;
 }
-- 
2.29.2

