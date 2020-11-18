Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0354A2B871B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgKRWEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgKRWEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:04:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFC0C061A53
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:04:14 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYg-00058w-E2; Wed, 18 Nov 2020 23:04:10 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYe-0000yl-C2; Wed, 18 Nov 2020 23:04:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH 05/11] net: dsa: microchip: ksz8795: use mib_cnt where possible
Date:   Wed, 18 Nov 2020 23:03:51 +0100
Message-Id: <20201118220357.22292-6-m.grzeschik@pengutronix.de>
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

The variable mib_cnt is assigned with TOTAL_SWITCH_COUNTER_NUM. This
value can also be derived from the array size of mib_names. This patch
uses this calculated value instead, removes the extra define and uses
mib_cnt everywhere possible instead of the static define
TOTAL_SWITCH_COUNTER_NUM.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c     | 8 ++++----
 drivers/net/dsa/microchip/ksz8795_reg.h | 3 ---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 04a571bde7e6a4f..6ddba2de2d3026e 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -23,7 +23,7 @@
 
 static const struct {
 	char string[ETH_GSTRING_LEN];
-} mib_names[TOTAL_SWITCH_COUNTER_NUM] = {
+} mib_names[] = {
 	{ "rx_hi" },
 	{ "rx_undersize" },
 	{ "rx_fragments" },
@@ -656,7 +656,7 @@ static void ksz8795_get_strings(struct dsa_switch *ds, int port,
 {
 	int i;
 
-	for (i = 0; i < TOTAL_SWITCH_COUNTER_NUM; i++) {
+	for (i = 0; i < dev->mib_cnt; i++) {
 		memcpy(buf + i * ETH_GSTRING_LEN, mib_names[i].string,
 		       ETH_GSTRING_LEN);
 	}
@@ -1236,7 +1236,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	dev->port_mask |= dev->host_mask;
 
 	dev->reg_mib_cnt = KSZ8795_COUNTER_NUM;
-	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
+	dev->mib_cnt = ARRAY_SIZE(mib_names);
 
 	dev->mib_port_cnt = TOTAL_PORT_NUM;
 	dev->phy_port_cnt = SWITCH_PORT_NUM;
@@ -1254,7 +1254,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 		dev->ports[i].mib.counters =
 			devm_kzalloc(dev->dev,
 				     sizeof(u64) *
-				     (TOTAL_SWITCH_COUNTER_NUM + 1),
+				     (dev->mib_cnt + 1),
 				     GFP_KERNEL);
 		if (!dev->ports[i].mib.counters)
 			return -ENOMEM;
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 25840719b936650..c131224850135bd 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -852,9 +852,6 @@
 #define SWITCH_PORT_NUM			(TOTAL_PORT_NUM - 1)
 
 #define KSZ8795_COUNTER_NUM		0x20
-#define TOTAL_KSZ8795_COUNTER_NUM	(KSZ8795_COUNTER_NUM + 4)
-
-#define TOTAL_SWITCH_COUNTER_NUM	TOTAL_KSZ8795_COUNTER_NUM
 
 /* Common names used by other drivers */
 
-- 
2.29.2

