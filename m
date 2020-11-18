Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188732B8717
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgKRWEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgKRWEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:04:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D40C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:04:15 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYk-00058z-1h; Wed, 18 Nov 2020 23:04:14 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYe-0000yu-DQ; Wed, 18 Nov 2020 23:04:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH 08/11] net: dsa: microchip: ksz8795: align port_cnt usage with other microchip drivers
Date:   Wed, 18 Nov 2020 23:03:54 +0100
Message-Id: <20201118220357.22292-9-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
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

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 17dc720df2340b0..10c9b301833dd59 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1183,7 +1183,7 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 4,		/* total physical port count */
+		.port_cnt = 5,
 	},
 	{
 		.chip_id = 0x8794,
@@ -1192,7 +1192,7 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 3,		/* total physical port count */
+		.port_cnt = 4,
 	},
 	{
 		.chip_id = 0x8765,
@@ -1201,7 +1201,7 @@ static const struct ksz_chip_data ksz8795_switch_chips[] = {
 		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
-		.port_cnt = 4,		/* total physical port count */
+		.port_cnt = 5,
 	},
 };
 
@@ -1237,7 +1237,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	dev->mib_cnt = ARRAY_SIZE(mib_names);
 
 	dev->mib_port_cnt = TOTAL_PORT_NUM;
-	dev->phy_port_cnt = dev->port_cnt;
+	dev->phy_port_cnt = dev->port_cnt - 1;
 
 	dev->cpu_port = dev->mib_port_cnt - 1;
 	dev->host_mask = BIT(dev->cpu_port);
@@ -1259,7 +1259,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	}
 
 	/* set the real number of ports */
-	dev->ds->num_ports = dev->port_cnt + 1;
+	dev->ds->num_ports = dev->port_cnt;
 
 	return 0;
 }
-- 
2.29.2

