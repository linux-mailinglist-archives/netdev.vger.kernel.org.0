Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBC02CADA1
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgLAUpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729173AbgLAUpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:45:53 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC79C061A04
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 12:45:13 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWN-0002st-38; Tue, 01 Dec 2020 21:45:11 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kkCWK-0002bp-4o; Tue, 01 Dec 2020 21:45:08 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 06/11] net: dsa: microchip: ksz8795: use phy_port_cnt where possible
Date:   Tue,  1 Dec 2020 21:45:01 +0100
Message-Id: <20201201204506.13473-7-m.grzeschik@pengutronix.de>
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

The driver is currently hard coded to SWITCH_PORT_NUM being
(TOTAL_PORT_NUM - 1) which is limited to 4 user ports for the ksz8795.
The phy_port_cnt is referring to its user ports. The patch removes the
extra define and use the assigned variable phy_port_cnt instead so the
driver can be used on different switches.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1:       - based on "[PATCH v4 04/11] net: dsa: microchip: ksz8795: use port_cnt where possible"
          - lore: https://lore.kernel.org/netdev/20200803054442.20089-5-m.grzeschik@pengutronix.de/
v1 -> v2: - being more precise in the patch description about its purpose
---
 drivers/net/dsa/microchip/ksz8795.c     | 20 ++++++++++----------
 drivers/net/dsa/microchip/ksz8795_reg.h |  3 ---
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index abdfc7f4d70ca..ee8e82dda3142 100644
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
@@ -692,12 +692,12 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
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
@@ -721,7 +721,7 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 		break;
 	case BR_STATE_BLOCKING:
 		data |= PORT_LEARN_DISABLE;
-		if (port < SWITCH_PORT_NUM &&
+		if (port < dev->phy_port_cnt &&
 		    p->stp_state == BR_STATE_DISABLED)
 			member = dev->host_mask | p->vid_member;
 		break;
@@ -1006,7 +1006,7 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 	ksz8795_port_setup(dev, dev->cpu_port, true);
 	dev->member = dev->host_mask;
 
-	for (i = 0; i < SWITCH_PORT_NUM; i++) {
+	for (i = 0; i < dev->phy_port_cnt; i++) {
 		p = &dev->ports[i];
 
 		/* Initialize to non-zero so that ksz_cfg_port_member() will
@@ -1017,7 +1017,7 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 		ksz8795_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 
 		/* Last port may be disabled. */
-		if (i == dev->port_cnt)
+		if (i == dev->phy_port_cnt)
 			break;
 		p->on = 1;
 		p->phy = 1;
@@ -1240,7 +1240,7 @@ static int ksz8795_switch_init(struct ksz_device *dev)
 	dev->mib_cnt = ARRAY_SIZE(mib_names);
 
 	dev->mib_port_cnt = TOTAL_PORT_NUM;
-	dev->phy_port_cnt = SWITCH_PORT_NUM;
+	dev->phy_port_cnt = dev->port_cnt;
 
 	dev->cpu_port = dev->mib_port_cnt - 1;
 	dev->host_mask = BIT(dev->cpu_port);
diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h b/drivers/net/dsa/microchip/ksz8795_reg.h
index c131224850135..6377165a236fd 100644
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

