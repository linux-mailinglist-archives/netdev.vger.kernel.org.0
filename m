Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C816C2CADA6
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgLAUq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgLAUqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:46:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF11C061A49
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 12:45:13 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWN-0002so-38; Tue, 01 Dec 2020 21:45:11 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWK-0002bg-3H; Tue, 01 Dec 2020 21:45:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 03/11] net: dsa: microchip: ksz8795: move variable assignments from detect to init
Date:   Tue,  1 Dec 2020 21:44:58 +0100
Message-Id: <20201201204506.13473-4-m.grzeschik@pengutronix.de>
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

This patch moves all variable assignments to the init function. It
leaves the detect function for its single purpose to detect which chip
version is found.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1 -> v2: - unchanged
---
 drivers/net/dsa/microchip/ksz8795.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 853a0805e08f2..1164c745ce940 100644
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

