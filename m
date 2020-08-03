Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8571239F3E
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgHCFpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgHCFpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:45:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAB3C0617A3
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 22:45:02 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THQ-0005J7-F6; Mon, 03 Aug 2020 07:45:00 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1k2THK-0005U5-UX; Mon, 03 Aug 2020 07:44:54 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de
Subject: [PATCH v4 04/11] net: dsa: microchip: ksz8795: use port_cnt where possible
Date:   Mon,  3 Aug 2020 07:44:35 +0200
Message-Id: <20200803054442.20089-5-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver can be used on more switches it needs
to use flexible port count whereever possible.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

---
v1 -> v4: - extracted this change from bigger previous patch

 drivers/net/dsa/microchip/ksz8795.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 8f1d15ea15d9a75..947ea1e45f5b2c6 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -418,8 +418,8 @@ static void ksz8795_r_vlan_entries(struct ksz_device *dev, u16 addr)
 	int i;
 
 	ksz8795_r_table(dev, TABLE_VLAN, addr, &data);
-	addr *= 4;
-	for (i = 0; i < 4; i++) {
+	addr *= dev->port_cnt;
+	for (i = 0; i < dev->port_cnt; i++) {
 		dev->vlan_cache[addr + i].table[0] = (u16)data;
 		data >>= VLAN_TABLE_S;
 	}
@@ -433,7 +433,7 @@ static void ksz8795_r_vlan_table(struct ksz_device *dev, u16 vid, u16 *vlan)
 	u64 buf;
 
 	data = (u16 *)&buf;
-	addr = vid / 4;
+	addr = vid / dev->port_cnt;
 	index = vid & 3;
 	ksz8795_r_table(dev, TABLE_VLAN, addr, &buf);
 	*vlan = data[index];
@@ -447,7 +447,7 @@ static void ksz8795_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 	u64 buf;
 
 	data = (u16 *)&buf;
-	addr = vid / 4;
+	addr = vid / dev->port_cnt;
 	index = vid & 3;
 	ksz8795_r_table(dev, TABLE_VLAN, addr, &buf);
 	data[index] = vlan;
@@ -691,12 +691,12 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 	switch (state) {
 	case BR_STATE_DISABLED:
 		data |= PORT_LEARN_DISABLE;
-		if (port < SWITCH_PORT_NUM)
+		if (port < dev->port_cnt)
 			member = 0;
 		break;
 	case BR_STATE_LISTENING:
 		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
-		if (port < SWITCH_PORT_NUM &&
+		if (port < dev->port_cnt &&
 		    p->stp_state == BR_STATE_DISABLED)
 			member = dev->host_mask | p->vid_member;
 		break;
@@ -720,7 +720,7 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 		break;
 	case BR_STATE_BLOCKING:
 		data |= PORT_LEARN_DISABLE;
-		if (port < SWITCH_PORT_NUM &&
+		if (port < dev->port_cnt &&
 		    p->stp_state == BR_STATE_DISABLED)
 			member = dev->host_mask | p->vid_member;
 		break;
@@ -993,7 +993,7 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 	ksz8795_port_setup(dev, dev->cpu_port, true);
 	dev->member = dev->host_mask;
 
-	for (i = 0; i < SWITCH_PORT_NUM; i++) {
+	for (i = 0; i < dev->port_cnt; i++) {
 		p = &dev->ports[i];
 
 		/* Initialize to non-zero so that ksz_cfg_port_member() will
-- 
2.28.0

