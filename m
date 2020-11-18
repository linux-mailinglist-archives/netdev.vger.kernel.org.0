Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A5B2B871A
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgKRWEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgKRWEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:04:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F73C061A52
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 14:04:14 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYg-00058x-Dt; Wed, 18 Nov 2020 23:04:10 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kfVYe-0000yo-CV; Wed, 18 Nov 2020 23:04:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH 06/11] net: dsa: microchip: ksz8795: use phy_port_cnt where possible
Date:   Wed, 18 Nov 2020 23:03:52 +0100
Message-Id: <20201118220357.22292-7-m.grzeschik@pengutronix.de>
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

Since the driver can be used on more switches it needs
to use flexible port count where ever possible.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1: - based on "[PATCH v4 04/11] net: dsa: microchip: ksz8795: use port_cnt where possible"
    - lore: https://lore.kernel.org/netdev/20200803054442.20089-5-m.grzeschik@pengutronix.de/
---
 drivers/net/dsa/microchip/ksz8795.c     | 20 ++++++++++----------
 drivers/net/dsa/microchip/ksz8795_reg.h |  3 ---
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 6ddba2de2d3026e..7114902495a0ebb 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -418,8 +418,8 @@ static void ksz8795_r_vlan_entries(struct ksz_device *dev, u16 addr)
 	int i;
 
 	ksz8795_r_table(dev, TABLE_VLAN, addr, &data);
-	addr *= 4;
-	for (i = 0; i < 4; i++) {
+	addr *= dev->phy_port_cnt;
+	for (i = 0; i < dev->phy_port_cnt; i++) {
 		dev->vlan_cache[addr + i].table[0] = (u16)data;
 		data >>= VLAN_TABLE_S;
 	}
@@ -433,7 +433,7 @@ static void ksz8795_r_vlan_table(struct ksz_device *dev, u16 vid, u16 *vlan)
 	u64 buf;
 
 	data = (u16 *)&buf;
-	addr = vid / 4;
+	addr = vid / dev->phy_port_cnt;
 	index = vid & 3;
 	ksz8795_r_table(dev, TABLE_VLAN, addr, &buf);
 	*vlan = data[index];
@@ -447,7 +447,7 @@ static void ksz8795_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 	u64 buf;
 
 	data = (u16 *)&buf;
-	addr = vid / 4;
+	addr = vid / dev->phy_port_cnt;
 	index = vid & 3;
 	ksz8795_r_table(dev, TABLE_VLAN, addr, &buf);
 	data[index] = vlan;
@@ -691,12 +691,12 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 	switch (state) {
 	case BR_STATE_DISABLED:
 		data |= PORT_LEARN_DISABLE;
-		if (port < SWITCH_PORT_NUM)
+		if (port < dev->phy_port_cnt)
 			member = 0;
 		break;
 	case BR_STATE_LISTENING:
 		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
-		if (port < SWITCH_PORT_NUM &&
+		if (port < dev->phy_port_cnt &&
 		    p->stp_state == BR_STATE_DISABLED)
 			member = dev->host_mask | p->vid_member;
 		break;
@@ -720,7 +720,7 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 		break;
 	case BR_STATE_BLOCKING:
 		data |= PORT_LEARN_DISABLE;
-		if (port < SWITCH_PORT_NUM &&
+		if (port < dev->phy_port_cnt &&
 		    p->stp_state == BR_STATE_DISABLED)
 			member = dev->host_mask | p->vid_member;
 		break;
@@ -1005,7 +1005,7 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 	ksz8795_port_setup(dev, dev->cpu_port, true);
 	dev->member = dev->host_mask;
 
-	for (i = 0; i < SWITCH_PORT_NUM; i++) {
+	for (i = 0; i < dev->phy_port_cnt; i++) {
 		p = &dev->ports[i];
 
 		/* Initialize to non-zero so that ksz_cfg_port_member() will
@@ -1016,7 +1016,7 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 		ksz8795_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 
 		/* Last port may be disabled. */
-		if (i == dev->port_cnt)
+		if (i == dev->phy_port_cnt)
 			break;
 		p->on = 1;
 		p->phy = 1;
@@ -1239,7 +1239,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	dev->mib_cnt = ARRAY_SIZE(mib_names);
 
 	dev->mib_port_cnt = TOTAL_PORT_NUM;
-	dev->phy_port_cnt = SWITCH_PORT_NUM;
+	dev->phy_port_cnt = dev->port_cnt;
 
 	dev->cpu_port = dev->mib_port_cnt - 1;
 	dev->host_mask = BIT(dev->cpu_port);
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index c131224850135bd..6377165a236fdf3 100644
--- a/drivers/net/dsa/microchip/ksz8795_reg.h
+++ b/drivers/net/dsa/microchip/ksz8795_reg.h
@@ -848,9 +848,6 @@
 
 #define TOTAL_PORT_NUM			5
 
-/* Host port can only be last of them. */
-#define SWITCH_PORT_NUM			(TOTAL_PORT_NUM - 1)
-
 #define KSZ8795_COUNTER_NUM		0x20
 
 /* Common names used by other drivers */
-- 
2.29.2

