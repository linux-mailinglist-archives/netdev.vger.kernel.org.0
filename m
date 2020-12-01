Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E172CADA2
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgLAUpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbgLAUpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:45:53 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C501C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 12:45:13 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWN-0002sr-37; Tue, 01 Dec 2020 21:45:11 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWK-0002bj-3n; Tue, 01 Dec 2020 21:45:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 04/11] net: dsa: microchip: ksz8795: use reg_mib_cnt where possible
Date:   Tue,  1 Dec 2020 21:44:59 +0100
Message-Id: <20201201204506.13473-5-m.grzeschik@pengutronix.de>
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

The extra define SWITCH_COUNTER_NUM is a copy of the KSZ8795_COUNTER_NUM
define. This patch initializes reg_mib_cnt with KSZ8795_COUNTER_NUM,
makes use of reg_mib_cnt everywhere instead and removes the extra
define.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1 -> v2: - unchanged
---
 drivers/net/dsa/microchip/ksz8795.c     | 6 +++---
 drivers/net/dsa/microchip/ksz8795_reg.h | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 1164c745ce940..04a571bde7e6a 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -125,7 +125,7 @@ static void ksz8795_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
 	u8 check;
 	int loop;
 
-	ctrl_addr = addr + SWITCH_COUNTER_NUM * port;
+	ctrl_addr = addr + dev->reg_mib_cnt * port;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
@@ -156,7 +156,7 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	u8 check;
 	int loop;
 
-	addr -= SWITCH_COUNTER_NUM;
+	addr -= dev->reg_mib_cnt;
 	ctrl_addr = (KS_MIB_TOTAL_RX_1 - KS_MIB_TOTAL_RX_0) * port;
 	ctrl_addr += addr + KS_MIB_TOTAL_RX_0;
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
@@ -1235,7 +1235,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	dev->port_mask = BIT(dev->port_cnt) - 1;
 	dev->port_mask |= dev->host_mask;
 
-	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
+	dev->reg_mib_cnt = KSZ8795_COUNTER_NUM;
 	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
 
 	dev->mib_port_cnt = TOTAL_PORT_NUM;
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index 3a50462df8fa9..25840719b9366 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -854,7 +854,6 @@
 #define KSZ8795_COUNTER_NUM		0x20
 #define TOTAL_KSZ8795_COUNTER_NUM	(KSZ8795_COUNTER_NUM + 4)
 
-#define SWITCH_COUNTER_NUM		KSZ8795_COUNTER_NUM
 #define TOTAL_SWITCH_COUNTER_NUM	TOTAL_KSZ8795_COUNTER_NUM
 
 /* Common names used by other drivers */
-- 
2.29.2

