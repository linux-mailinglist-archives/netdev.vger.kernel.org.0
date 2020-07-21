Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401A1227ABD
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 10:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgGUIdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 04:33:14 -0400
Received: from mail.intenta.de ([178.249.25.132]:36471 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgGUIdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 04:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=Content-Type:MIME-Version:Message-ID:Subject:CC:To:From:Date; bh=KpJYWd9W1Ir0tlWJVN8GlWdeMZHt+y4Q6iTdJpkbmsY=;
        b=EdBLu8U/HG3M9V8k/qXjrcMIGxXEZEN7kRnUVfymMj9tLxNzklVB/8R+2Zv859HOeEav4ZelaLEkGtHk3T1MjPtp9sdacJ3lSNSFAN/+qvFqwi/4UsjW76BXl6PyMZDiA95CY1iazCJDFOqkXyCB32fdnrNYHYbtKB3UOAdTBK2+xT6AF/8LQkzMyOKmW2iZwYIofaiL0P5bwPvAjr2NECIS4otuYEhAw16ncI+pbywVrvsBSjIV+cQiMG7nn/83nY9eyAPcGHRPQ2SKtjCcFsgGvlAKw+OnPChSTOgYptzUsP+Z9gW4zsKNUX7hIQ3ejThilQHT+Y09WM8usc07eA==;
Date:   Tue, 21 Jul 2020 10:33:01 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [RFC PATCH] net: dsa: microchip: delete dead code
Message-ID: <20200721083300.GA12970@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

None of the removed assignments is ever read back and never influences
logic.

Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
---
 drivers/net/dsa/microchip/ksz8795.c    | 26 ++--------------------
 drivers/net/dsa/microchip/ksz9477.c    | 30 +-------------------------
 drivers/net/dsa/microchip/ksz_common.c | 23 --------------------
 drivers/net/dsa/microchip/ksz_common.h | 11 ----------
 4 files changed, 3 insertions(+), 87 deletions(-)

While working on the driver (e.g.
https://lore.kernel.org/netdev/20200720210449.GP1339445@lunn.ch/), it
became clear that we don't have a good understanding of what all that
code does. It turns out that part of the code simply does nothing useful
and this patch attempts to figure out whether it can be simply removed.

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 7c17b0f705ec..545cb7871712 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -731,14 +731,6 @@ static void ksz8795_port_stp_state_set(struct dsa_switch *ds, int port,
 
 	ksz_pwrite8(dev, port, P_STP_CTRL, data);
 	p->stp_state = state;
-	if (data & PORT_RX_ENABLE)
-		dev->rx_ports |= BIT(port);
-	else
-		dev->rx_ports &= ~BIT(port);
-	if (data & PORT_TX_ENABLE)
-		dev->tx_ports |= BIT(port);
-	else
-		dev->tx_ports &= ~BIT(port);
 
 	/* Port membership may share register with STP state. */
 	if (member >= 0 && member != p->member)
@@ -976,15 +968,8 @@ static void ksz8795_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		p->phydev.duplex = 1;
 
 		member = dev->port_mask;
-		dev->on_ports = dev->host_mask;
-		dev->live_ports = dev->host_mask;
 	} else {
 		member = dev->host_mask | p->vid_member;
-		dev->on_ports |= BIT(port);
-
-		/* Link was detected before port is enabled. */
-		if (p->phydev.link)
-			dev->live_ports |= BIT(port);
 	}
 	ksz8795_cfg_port_member(dev, port, member);
 }
@@ -1023,7 +1008,6 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 		if (i == dev->port_cnt)
 			break;
 		p->on = 1;
-		p->phy = 1;
 	}
 	for (i = 0; i < dev->phy_port_cnt; i++) {
 		p = &dev->ports[i];
@@ -1032,12 +1016,8 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 		ksz_pread8(dev, i, P_REMOTE_STATUS, &remote);
 		if (remote & PORT_FIBER_MODE)
 			p->fiber = 1;
-		if (p->fiber)
-			ksz_port_cfg(dev, i, P_STP_CTRL, PORT_FORCE_FLOW_CTRL,
-				     true);
-		else
-			ksz_port_cfg(dev, i, P_STP_CTRL, PORT_FORCE_FLOW_CTRL,
-				     false);
+		ksz_port_cfg(dev, i, P_STP_CTRL, PORT_FORCE_FLOW_CTRL,
+			     !!p->fiber);
 	}
 }
 
@@ -1113,7 +1093,6 @@ static const struct dsa_switch_ops ksz8795_switch_ops = {
 	.phy_write		= ksz_phy_write16,
 	.adjust_link		= ksz_adjust_link,
 	.port_enable		= ksz_enable_port,
-	.port_disable		= ksz_disable_port,
 	.get_strings		= ksz8795_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
 	.get_sset_count		= ksz_sset_count,
@@ -1168,7 +1147,6 @@ static int ksz8795_switch_detect(struct ksz_device *dev)
 			id2 = 0x65;
 	} else if (id2 == CHIP_ID_94) {
 		dev->port_cnt--;
-		dev->last_port = dev->port_cnt;
 		id2 = 0x94;
 	}
 	id16 &= ~0xff;
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 8d15c3016024..db2e8f95fa65 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -452,14 +452,6 @@ static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
 	ksz_pwrite8(dev, port, P_STP_CTRL, data);
 	p->stp_state = state;
 	mutex_lock(&dev->dev_mutex);
-	if (data & PORT_RX_ENABLE)
-		dev->rx_ports |= (1 << port);
-	else
-		dev->rx_ports &= ~(1 << port);
-	if (data & PORT_TX_ENABLE)
-		dev->tx_ports |= (1 << port);
-	else
-		dev->tx_ports &= ~(1 << port);
 
 	/* Port membership may share register with STP state. */
 	if (member >= 0 && member != p->member)
@@ -1268,18 +1260,7 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 		p->phydev.duplex = 1;
 	}
 	mutex_lock(&dev->dev_mutex);
-	if (cpu_port) {
-		member = dev->port_mask;
-		dev->on_ports = dev->host_mask;
-		dev->live_ports = dev->host_mask;
-	} else {
-		member = dev->host_mask | p->vid_member;
-		dev->on_ports |= (1 << port);
-
-		/* Link was detected before port is enabled. */
-		if (p->phydev.link)
-			dev->live_ports |= (1 << port);
-	}
+	member = cpu_port ? dev->port_mask : (dev->host_mask | p->vid_member);
 	mutex_unlock(&dev->dev_mutex);
 	ksz9477_cfg_port_member(dev, port, member);
 
@@ -1339,14 +1320,6 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 		p->member = dev->port_mask;
 		ksz9477_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 		p->on = 1;
-		if (i < dev->phy_port_cnt)
-			p->phy = 1;
-		if (dev->chip_id == 0x00947700 && i == 6) {
-			p->sgmii = 1;
-
-			/* SGMII PHY detection code is not implemented yet. */
-			p->phy = 0;
-		}
 	}
 }
 
@@ -1401,7 +1374,6 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.phy_write		= ksz9477_phy_write16,
 	.adjust_link		= ksz_adjust_link,
 	.port_enable		= ksz_enable_port,
-	.port_disable		= ksz_disable_port,
 	.get_strings		= ksz9477_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
 	.get_sset_count		= ksz_sset_count,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fd1d6676ae4f..d39644bec85e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -146,13 +146,6 @@ void ksz_adjust_link(struct dsa_switch *ds, int port,
 		p->read = true;
 		schedule_delayed_work(&dev->mib_read, 0);
 	}
-	mutex_lock(&dev->dev_mutex);
-	if (!phydev->link)
-		dev->live_ports &= ~(1 << port);
-	else
-		/* Remember which port is connected and active. */
-		dev->live_ports |= (1 << port) & dev->on_ports;
-	mutex_unlock(&dev->dev_mutex);
 }
 EXPORT_SYMBOL_GPL(ksz_adjust_link);
 
@@ -369,22 +362,6 @@ int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 }
 EXPORT_SYMBOL_GPL(ksz_enable_port);
 
-void ksz_disable_port(struct dsa_switch *ds, int port)
-{
-	struct ksz_device *dev = ds->priv;
-
-	if (!dsa_is_user_port(ds, port))
-		return;
-
-	dev->on_ports &= ~(1 << port);
-	dev->live_ports &= ~(1 << port);
-
-	/* port_stp_state_set() will be called after to disable the port so
-	 * there is no need to do anything.
-	 */
-}
-EXPORT_SYMBOL_GPL(ksz_disable_port);
-
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
 	struct dsa_switch *ds;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index f2c9bb68fd33..80b56448d7d9 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -31,10 +31,7 @@ struct ksz_port {
 	struct phy_device phydev;
 
 	u32 on:1;			/* port is not disabled by hardware */
-	u32 phy:1;			/* port has a PHY */
 	u32 fiber:1;			/* port is fiber */
-	u32 sgmii:1;			/* port is SGMII */
-	u32 force:1;
 	u32 read:1;			/* read MIB counters in background */
 	u32 freeze:1;			/* MIB counter freeze is enabled */
 
@@ -71,9 +68,7 @@ struct ksz_device {
 	int reg_mib_cnt;
 	int mib_cnt;
 	int mib_port_cnt;
-	int last_port;			/* ports after that not used */
 	phy_interface_t interface;
-	u32 regs_size;
 	bool phy_errata_9477;
 	bool synclko_125;
 
@@ -84,14 +79,9 @@ struct ksz_device {
 	unsigned long mib_read_interval;
 	u16 br_member;
 	u16 member;
-	u16 live_ports;
-	u16 on_ports;			/* ports enabled by DSA */
-	u16 rx_ports;
-	u16 tx_ports;
 	u16 mirror_rx;
 	u16 mirror_tx;
 	u32 features;			/* chip specific features */
-	u32 overrides;			/* chip functions set by user */
 	u16 host_mask;
 	u16 port_mask;
 };
@@ -179,7 +169,6 @@ void ksz_port_mdb_add(struct dsa_switch *ds, int port,
 int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_mdb *mdb);
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
-void ksz_disable_port(struct dsa_switch *ds, int port);
 
 /* Common register access functions */
 
-- 
2.20.1

