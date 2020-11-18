Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD32B871C
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgKRWEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgKRWEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:04:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91019C061A51
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:04:14 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYg-000591-E0; Wed, 18 Nov 2020 23:04:10 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYe-0000z0-EK; Wed, 18 Nov 2020 23:04:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH 10/11] net: dsa: microchip: ksz8795: dynamic allocate memory for flush_dyn_mac_table
Date:   Wed, 18 Nov 2020 23:03:56 +0100
Message-Id: <20201118220357.22292-11-m.grzeschik@pengutronix.de>
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

To get the driver working with other chips using different port counts
the dyn_mac_table should be flushed depending on the amount of physical
ports.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1: - based on "[PATCH v4 05/11] net: dsa: microchip: ksz8795: dynamica allocate memory for flush_dyn_mac_table"
    - lore: https://lore.kernel.org/netdev/20200803054442.20089-6-m.grzeschik@pengutronix.de/
---
 drivers/net/dsa/microchip/ksz8795.c     | 8 ++++++--
 drivers/net/dsa/microchip/ksz8795_reg.h | 2 --
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 9ea5ec61513023f..418f71e5b90761c 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -750,11 +750,14 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 
 static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
-	u8 learn[TOTAL_PORT_NUM];
 	int first, index, cnt;
 	struct ksz_port *p;
+	u8 *learn = kzalloc(dev->port_cnt, GFP_KERNEL);
 
-	if ((uint)port < TOTAL_PORT_NUM) {
+	if (!learn)
+		return;
+
+	if ((uint)port < dev->port_cnt) {
 		first = port;
 		cnt = port + 1;
 	} else {
@@ -779,6 +782,7 @@ static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
 		if (!(learn[index] & PORT_LEARN_DISABLE))
 			ksz_pwrite8(dev, index, P_STP_CTRL, learn[index]);
 	}
+	kfree(learn);
 }
 
 static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 6377165a236fdf3..681d19ab27b89da 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -846,8 +846,6 @@
 
 #define KS_PRIO_IN_REG			4
 
-#define TOTAL_PORT_NUM			5
-
 #define KSZ8795_COUNTER_NUM		0x20
 
 /* Common names used by other drivers */
-- 
2.29.2

