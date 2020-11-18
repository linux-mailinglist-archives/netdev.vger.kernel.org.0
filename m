Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28002B8714
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgKRWEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgKRWEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:04:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83086C061A48
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:04:14 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYg-00058u-E0; Wed, 18 Nov 2020 23:04:10 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYe-0000yf-B9; Wed, 18 Nov 2020 23:04:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH 03/11] net: dsa: microchip: ksz8795: move variable assignments from detect to init
Date:   Wed, 18 Nov 2020 23:03:49 +0100
Message-Id: <20201118220357.22292-4-m.grzeschik@pengutronix.de>
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

This patch moves all variable assignments to the init function. It
leaves the detect function for its single purpose to detect which chip
version is found.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 853a0805e08f239..1164c745ce940d0 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1150,9 +1150,6 @@ static int ksz8795_switch_detect(struct ksz_device *dev)
 	    (id2 != CHIP_ID_94 && id2 != CHIP_ID_95))
 		return -ENODEV;
 
-	dev->mib_port_cnt = TOTAL_PORT_NUM;
-	dev->phy_port_cnt = SWITCH_PORT_NUM;
-
 	if (id2 == CHIP_ID_95) {
 		u8 val;
 
@@ -1167,9 +1164,6 @@ static int ksz8795_switch_detect(struct ksz_device *dev)
 	id16 |= id2;
 	dev->chip_id = id16;
 
-	dev->cpu_port = dev->mib_port_cnt - 1;
-	dev->host_mask = BIT(dev->cpu_port);
-
 	return 0;
 }
 
@@ -1244,6 +1238,12 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
 	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
 
+	dev->mib_port_cnt = TOTAL_PORT_NUM;
+	dev->phy_port_cnt = SWITCH_PORT_NUM;
+
+	dev->cpu_port = dev->mib_port_cnt - 1;
+	dev->host_mask = BIT(dev->cpu_port);
+
 	i = dev->mib_port_cnt;
 	dev->ports = devm_kzalloc(dev->dev, sizeof(struct ksz_port) * i,
 				  GFP_KERNEL);
-- 
2.29.2

