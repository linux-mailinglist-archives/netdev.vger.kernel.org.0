Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48B925617
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 18:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfEUQw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 12:52:59 -0400
Received: from inva020.nxp.com ([92.121.34.13]:60004 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbfEUQw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 12:52:59 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7894B1A01D3;
        Tue, 21 May 2019 18:52:56 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6C3CD1A01C4;
        Tue, 21 May 2019 18:52:56 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2B6A720612;
        Tue, 21 May 2019 18:52:56 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Pavel Machek <pavel@denx.de>, UNGLinuxDriver@microchip.com
Subject: [PATCH net] ocelot: Dont allocate another multicast list, use __dev_mc_sync
Date:   Tue, 21 May 2019 19:52:55 +0300
Message-Id: <1558457575-13784-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doing kmalloc in atomic context is always an issue,
more so for a list that can grow significantly.
Turns out that the driver only uses the duplicated
list of multicast mac addresses to keep track of
what addresses to delete from h/w before committing
the new list from kernel to h/w back again via set_rx_mode,
every time this list gets updated by the kernel.
Given that the h/w knows how to add and delete mac addresses
based on the mac address value alone, __dev_mc_sync should be
the much better choice of kernel API for these operations
avoiding the considerable overhead of maintaining a duplicated
list in the driver.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
Maybe this should go to net, since there were objections
for abusing kmalloc(GFP_ATOMIC).

 drivers/net/ethernet/mscc/ocelot.c | 43 ++++++------------------------
 drivers/net/ethernet/mscc/ocelot.h |  4 ---
 2 files changed, 8 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d715ef4fc92f..02ad11e0b0d8 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -593,45 +593,25 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-static void ocelot_mact_mc_reset(struct ocelot_port *port)
+static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
 {
-	struct ocelot *ocelot = port->ocelot;
-	struct netdev_hw_addr *ha, *n;
+	struct ocelot_port *port = netdev_priv(dev);
 
-	/* Free and forget all the MAC addresses stored in the port private mc
-	 * list. These are mc addresses that were previously added by calling
-	 * ocelot_mact_mc_add().
-	 */
-	list_for_each_entry_safe(ha, n, &port->mc, list) {
-		ocelot_mact_forget(ocelot, ha->addr, port->pvid);
-		list_del(&ha->list);
-		kfree(ha);
-	}
+	return ocelot_mact_forget(port->ocelot, addr, port->pvid);
 }
 
-static int ocelot_mact_mc_add(struct ocelot_port *port,
-			      struct netdev_hw_addr *hw_addr)
+static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
 {
-	struct ocelot *ocelot = port->ocelot;
-	struct netdev_hw_addr *ha = kzalloc(sizeof(*ha), GFP_ATOMIC);
-
-	if (!ha)
-		return -ENOMEM;
-
-	memcpy(ha, hw_addr, sizeof(*ha));
-	list_add_tail(&ha->list, &port->mc);
-
-	ocelot_mact_learn(ocelot, PGID_CPU, ha->addr, port->pvid,
-			  ENTRYTYPE_LOCKED);
+	struct ocelot_port *port = netdev_priv(dev);
 
-	return 0;
+	return ocelot_mact_learn(port->ocelot, PGID_CPU, addr, port->pvid,
+				 ENTRYTYPE_LOCKED);
 }
 
 static void ocelot_set_rx_mode(struct net_device *dev)
 {
 	struct ocelot_port *port = netdev_priv(dev);
 	struct ocelot *ocelot = port->ocelot;
-	struct netdev_hw_addr *ha;
 	int i;
 	u32 val;
 
@@ -643,13 +623,7 @@ static void ocelot_set_rx_mode(struct net_device *dev)
 	for (i = ocelot->num_phys_ports + 1; i < PGID_CPU; i++)
 		ocelot_write_rix(ocelot, val, ANA_PGID_PGID, i);
 
-	/* Handle the device multicast addresses. First remove all the
-	 * previously installed addresses and then add the latest ones to the
-	 * mac table.
-	 */
-	ocelot_mact_mc_reset(port);
-	netdev_for_each_mc_addr(ha, dev)
-		ocelot_mact_mc_add(port, ha);
+	__dev_mc_sync(dev, ocelot_mc_sync, ocelot_mc_unsync);
 }
 
 static int ocelot_port_get_phys_port_name(struct net_device *dev,
@@ -1657,7 +1631,6 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 	ocelot_port->regs = regs;
 	ocelot_port->chip_port = port;
 	ocelot_port->phy = phy;
-	INIT_LIST_HEAD(&ocelot_port->mc);
 	ocelot->ports[port] = ocelot_port;
 
 	dev->netdev_ops = &ocelot_port_netdev_ops;
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index ba3b3380b4d0..541fe41e60b0 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -441,10 +441,6 @@ struct ocelot_port {
 	struct phy_device *phy;
 	void __iomem *regs;
 	u8 chip_port;
-	/* Keep a track of the mc addresses added to the mac table, so that they
-	 * can be removed when needed.
-	 */
-	struct list_head mc;
 
 	/* Ingress default VLAN (pvid) */
 	u16 pvid;
-- 
2.17.1

