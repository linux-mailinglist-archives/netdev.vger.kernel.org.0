Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B159DDDC1F
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfJTDUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:11 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39942 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfJTDUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:10 -0400
Received: by mail-qt1-f193.google.com with SMTP id o49so7424862qta.7;
        Sat, 19 Oct 2019 20:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M+I23v7vRUOHSFl8o9HSH8ieKzrkDCU5Wa1l5MDsipw=;
        b=pyx4Eg4BvLaFc8mdLCm1KKJ2uVs5aOkpWEvufluCo4/U0WAWDtglMFEUjgsmKkAWRf
         eB0kizVLVObMEmQ8o3u1gwC118hzpNL0+0csR6g3X9o8g/QB7GJbHCgHFCNS4P9Nb5Dz
         XSM9KKrRURL85ySFyKKsJCc4pIrG63X8xmH3/VwInRaIWVyBgtNLRhss2ZJaFNr9c9Kw
         9c/XLjlHqs4DWGIe6f2geSyMwQ1c5HiqN2xHDbXlRuU5Fw9qcTRXjOacvw7PBrrgx5FC
         meMfeGvrasf+6txDvZNEz/oLc/QhuuXBvSMsejwbbb2K4RFVMI97noYg6MI4lDStzhXD
         OWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M+I23v7vRUOHSFl8o9HSH8ieKzrkDCU5Wa1l5MDsipw=;
        b=GahZ4KLVT0GU25ambl3ob03aLxyK5QlvGxY223r/x+Fxg7aoK2td/KHgeJOw2UCl5k
         OjctlUmAS63pJwN2kfRd20GmBOxJ0mWGZF7ZeMtvviHGJqQ7IbXPgXO64d99wPuHfEE1
         POOI7vfGZAuQ1+e7O6WAcuQknRUp+YNRddhjadcMKYr1dq4junQ7okw32WbxytnHC/gw
         0mTavMcHzwJvTtQYPmk3ccRrHwrVa6v97NOVrtg7cgjAjcSk0ekNjlDgqkhaXa7XiiaB
         NXRC1yLKJE3AuivW6oVmj3iXGtvHCsiImLFIy/y4JmZf4/KwqA8QWgjGgChqmz3L+syG
         vc7Q==
X-Gm-Message-State: APjAAAXnhkX+htJauxbXl739TnBuEERYMSs07W9M/6aPsigG8UqMgN3k
        HU9UBTykzq4lpVq3ST8U2ho=
X-Google-Smtp-Source: APXvYqwMF+OuPaO798kvAiqptvwh1j9oqrxDWx9VKAMx/cRj1pKFxew+Ohy6qTwIoehFJgCYXBGvBg==
X-Received: by 2002:a0c:d645:: with SMTP id e5mr1858145qvj.176.1571541608669;
        Sat, 19 Oct 2019 20:20:08 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t17sm9622088qtt.57.2019.10.19.20.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:08 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 01/16] net: dsa: use dsa_to_port helper everywhere
Date:   Sat, 19 Oct 2019 23:19:26 -0400
Message-Id: <20191020031941.3805884-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not let the drivers access the ds->ports static array directly
while there is a dsa_to_port helper for this purpose.

At the same time, un-const this helper since the SJA1105 driver
assigns the priv member of the returned dsa_port structure.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c       |  6 +++---
 drivers/net/dsa/bcm_sf2.c              |  8 ++++----
 drivers/net/dsa/bcm_sf2_cfp.c          |  6 +++---
 drivers/net/dsa/mt7530.c               | 12 ++++++------
 drivers/net/dsa/mv88e6xxx/chip.c       | 10 +++++-----
 drivers/net/dsa/qca8k.c                |  2 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 18 +++++++++---------
 include/net/dsa.h                      |  2 +-
 net/dsa/dsa.c                          |  8 +++++---
 net/dsa/dsa2.c                         |  4 ++--
 net/dsa/switch.c                       |  4 ++--
 net/dsa/tag_8021q.c                    |  6 +++---
 12 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 526ba2ab66f1..9ba91f1370ac 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -524,7 +524,7 @@ int b53_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 	if (!dsa_is_user_port(ds, port))
 		return 0;
 
-	cpu_port = ds->ports[port].cpu_dp->index;
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 
 	if (dev->ops->irq_enable)
 		ret = dev->ops->irq_enable(dev, port);
@@ -1629,7 +1629,7 @@ EXPORT_SYMBOL(b53_fdb_dump);
 int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct b53_device *dev = ds->priv;
-	s8 cpu_port = ds->ports[port].cpu_dp->index;
+	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	u16 pvlan, reg;
 	unsigned int i;
 
@@ -1675,7 +1675,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct b53_device *dev = ds->priv;
 	struct b53_vlan *vl = &dev->vlans[0];
-	s8 cpu_port = ds->ports[port].cpu_dp->index;
+	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	unsigned int i;
 	u16 pvlan, reg, pvid;
 
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 26509fa37a50..c068a3b7207b 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -662,7 +662,7 @@ static void bcm_sf2_sw_fixed_state(struct dsa_switch *ds, int port,
 		 * state machine and make it go in PHY_FORCING state instead.
 		 */
 		if (!status->link)
-			netif_carrier_off(ds->ports[port].slave);
+			netif_carrier_off(dsa_to_port(ds, port)->slave);
 		status->duplex = DUPLEX_FULL;
 	} else {
 		status->link = true;
@@ -728,7 +728,7 @@ static int bcm_sf2_sw_resume(struct dsa_switch *ds)
 static void bcm_sf2_sw_get_wol(struct dsa_switch *ds, int port,
 			       struct ethtool_wolinfo *wol)
 {
-	struct net_device *p = ds->ports[port].cpu_dp->master;
+	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_wolinfo pwol = { };
 
@@ -752,9 +752,9 @@ static void bcm_sf2_sw_get_wol(struct dsa_switch *ds, int port,
 static int bcm_sf2_sw_set_wol(struct dsa_switch *ds, int port,
 			      struct ethtool_wolinfo *wol)
 {
-	struct net_device *p = ds->ports[port].cpu_dp->master;
+	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
-	s8 cpu_port = ds->ports[port].cpu_dp->index;
+	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	struct ethtool_wolinfo pwol =  { };
 
 	if (p->ethtool_ops->get_wol)
diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index d264776a95a3..f3f0c3f07391 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -821,7 +821,7 @@ static int bcm_sf2_cfp_rule_insert(struct dsa_switch *ds, int port,
 				   struct ethtool_rx_flow_spec *fs)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
-	s8 cpu_port = ds->ports[port].cpu_dp->index;
+	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	__u64 ring_cookie = fs->ring_cookie;
 	unsigned int queue_num, port_num;
 	int ret;
@@ -1049,7 +1049,7 @@ static int bcm_sf2_cfp_rule_get_all(struct bcm_sf2_priv *priv,
 int bcm_sf2_get_rxnfc(struct dsa_switch *ds, int port,
 		      struct ethtool_rxnfc *nfc, u32 *rule_locs)
 {
-	struct net_device *p = ds->ports[port].cpu_dp->master;
+	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	int ret = 0;
 
@@ -1092,7 +1092,7 @@ int bcm_sf2_get_rxnfc(struct dsa_switch *ds, int port,
 int bcm_sf2_set_rxnfc(struct dsa_switch *ds, int port,
 		      struct ethtool_rxnfc *nfc)
 {
-	struct net_device *p = ds->ports[port].cpu_dp->master;
+	struct net_device *p = dsa_to_port(ds, port)->cpu_dp->master;
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	int ret = 0;
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 1d8d36de4d20..a91293e47a57 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -862,7 +862,7 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		if (dsa_is_user_port(ds, i) &&
-		    dsa_port_is_vlan_filtering(&ds->ports[i])) {
+		    dsa_port_is_vlan_filtering(dsa_to_port(ds, i))) {
 			all_user_ports_removed = false;
 			break;
 		}
@@ -922,7 +922,7 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 		 * other port is still a VLAN-aware port.
 		 */
 		if (dsa_is_user_port(ds, i) && i != port &&
-		   !dsa_port_is_vlan_filtering(&ds->ports[i])) {
+		   !dsa_port_is_vlan_filtering(dsa_to_port(ds, i))) {
 			if (dsa_to_port(ds, i)->bridge_dev != bridge)
 				continue;
 			if (priv->ports[i].enable)
@@ -1165,7 +1165,7 @@ mt7530_port_vlan_add(struct dsa_switch *ds, int port,
 	/* The port is kept as VLAN-unaware if bridge with vlan_filtering not
 	 * being set.
 	 */
-	if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
+	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
 		return;
 
 	mutex_lock(&priv->reg_mutex);
@@ -1196,7 +1196,7 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 	/* The port is kept as VLAN-unaware if bridge with vlan_filtering not
 	 * being set.
 	 */
-	if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
+	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
 		return 0;
 
 	mutex_lock(&priv->reg_mutex);
@@ -1252,7 +1252,7 @@ mt7530_setup(struct dsa_switch *ds)
 	 * controller also is the container for two GMACs nodes representing
 	 * as two netdev instances.
 	 */
-	dn = ds->ports[MT7530_CPU_PORT].master->dev.of_node->parent;
+	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
 
 	if (priv->id == ID_MT7530) {
 		priv->ethernet = syscon_node_to_regmap(dn);
@@ -1340,7 +1340,7 @@ mt7530_setup(struct dsa_switch *ds)
 
 	if (!dsa_is_unused_port(ds, 5)) {
 		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
-		interface = of_get_phy_mode(ds->ports[5].dn);
+		interface = of_get_phy_mode(dsa_to_port(ds, 5)->dn);
 	} else {
 		/* Scan the ethernet nodes. look for GMAC1, lookup used phy */
 		for_each_child_of_node(dn, mac_np) {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6787d560e9e3..d67deec77452 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1075,7 +1075,7 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
 		return mv88e6xxx_port_mask(chip);
 
-	br = ds->ports[port].bridge_dev;
+	br = dsa_to_port(ds, port)->bridge_dev;
 	pvlan = 0;
 
 	/* Frames from user ports can egress any local DSA links and CPU ports,
@@ -1402,7 +1402,7 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 			if (dsa_is_dsa_port(ds, i) || dsa_is_cpu_port(ds, i))
 				continue;
 
-			if (!ds->ports[i].slave)
+			if (!dsa_to_port(ds, i)->slave)
 				continue;
 
 			if (vlan.member[i] ==
@@ -1410,7 +1410,7 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 				continue;
 
 			if (dsa_to_port(ds, i)->bridge_dev ==
-			    ds->ports[port].bridge_dev)
+			    dsa_to_port(ds, port)->bridge_dev)
 				break; /* same bridge, check next VLAN */
 
 			if (!dsa_to_port(ds, i)->bridge_dev)
@@ -2042,7 +2042,7 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 
 	/* Remap the Port VLAN of each local bridge group member */
 	for (port = 0; port < mv88e6xxx_num_ports(chip); ++port) {
-		if (chip->ds->ports[port].bridge_dev == br) {
+		if (dsa_to_port(chip->ds, port)->bridge_dev == br) {
 			err = mv88e6xxx_port_vlan_map(chip, port);
 			if (err)
 				return err;
@@ -2059,7 +2059,7 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 			break;
 
 		for (port = 0; port < ds->num_ports; ++port) {
-			if (ds->ports[port].bridge_dev == br) {
+			if (dsa_to_port(ds, port)->bridge_dev == br) {
 				err = mv88e6xxx_pvt_map(chip, dev, port);
 				if (err)
 					return err;
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index b00274caae4f..71e44c8763b8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -661,7 +661,7 @@ qca8k_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Initialize CPU port pad mode (xMII type, delays...) */
-	phy_mode = of_get_phy_mode(ds->ports[QCA8K_CPU_PORT].dn);
+	phy_mode = of_get_phy_mode(dsa_to_port(ds, QCA8K_CPU_PORT)->dn);
 	if (phy_mode < 0) {
 		pr_err("Can't find phy-mode for master device\n");
 		return phy_mode;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2ffe642cf54b..4b0cb779f187 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1058,7 +1058,7 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	if (dsa_port_is_vlan_filtering(&ds->ports[port])) {
+	if (dsa_port_is_vlan_filtering(dsa_to_port(ds, port))) {
 		l2_lookup.mask_vlanid = VLAN_VID_MASK;
 		l2_lookup.mask_iotag = BIT(0);
 	} else {
@@ -1121,7 +1121,7 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	if (dsa_port_is_vlan_filtering(&ds->ports[port])) {
+	if (dsa_port_is_vlan_filtering(dsa_to_port(ds, port))) {
 		l2_lookup.mask_vlanid = VLAN_VID_MASK;
 		l2_lookup.mask_iotag = BIT(0);
 	} else {
@@ -1167,7 +1167,7 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 	 * for what gets printed in 'bridge fdb show'.  In the case of zero,
 	 * no VID gets printed at all.
 	 */
-	if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
+	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
 		vid = 0;
 
 	return priv->info->fdb_add_cmd(ds, port, addr, vid);
@@ -1178,7 +1178,7 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
-	if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
+	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
 		vid = 0;
 
 	return priv->info->fdb_del_cmd(ds, port, addr, vid);
@@ -1217,7 +1217,7 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
 		/* We need to hide the dsa_8021q VLANs from the user. */
-		if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
+		if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
 			l2_lookup.vlanid = 0;
 		cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
 	}
@@ -1704,7 +1704,7 @@ static int sja1105_port_enable(struct dsa_switch *ds, int port,
 	if (!dsa_is_user_port(ds, port))
 		return 0;
 
-	slave = ds->ports[port].slave;
+	slave = dsa_to_port(ds, port)->slave;
 
 	slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
@@ -1736,7 +1736,7 @@ static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
 	}
 
 	/* Transfer skb to the host port. */
-	dsa_enqueue_skb(skb, ds->ports[port].slave);
+	dsa_enqueue_skb(skb, dsa_to_port(ds, port)->slave);
 
 	/* Wait until the switch has processed the frame */
 	do {
@@ -2061,8 +2061,8 @@ static int sja1105_probe(struct spi_device *spi)
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
 		struct sja1105_port *sp = &priv->ports[i];
 
-		ds->ports[i].priv = sp;
-		sp->dp = &ds->ports[i];
+		dsa_to_port(ds, i)->priv = sp;
+		sp->dp = dsa_to_port(ds, i);
 		sp->data = tagger_data;
 	}
 	mutex_init(&priv->ptp_data.lock);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8c3ea0530f65..2e4fe2f8962b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -278,7 +278,7 @@ struct dsa_switch {
 	struct dsa_port ports[];
 };
 
-static inline const struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
+static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
 {
 	return &ds->ports[p];
 }
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 43120a3fb06f..a5545762f5e7 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -246,7 +246,9 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 #ifdef CONFIG_PM_SLEEP
 static bool dsa_is_port_initialized(struct dsa_switch *ds, int p)
 {
-	return dsa_is_user_port(ds, p) && ds->ports[p].slave;
+	const struct dsa_port *dp = dsa_to_port(ds, p);
+
+	return dp->type == DSA_PORT_TYPE_USER && dp->slave;
 }
 
 int dsa_switch_suspend(struct dsa_switch *ds)
@@ -258,7 +260,7 @@ int dsa_switch_suspend(struct dsa_switch *ds)
 		if (!dsa_is_port_initialized(ds, i))
 			continue;
 
-		ret = dsa_slave_suspend(ds->ports[i].slave);
+		ret = dsa_slave_suspend(dsa_to_port(ds, i)->slave);
 		if (ret)
 			return ret;
 	}
@@ -285,7 +287,7 @@ int dsa_switch_resume(struct dsa_switch *ds)
 		if (!dsa_is_port_initialized(ds, i))
 			continue;
 
-		ret = dsa_slave_resume(ds->ports[i].slave);
+		ret = dsa_slave_resume(dsa_to_port(ds, i)->slave);
 		if (ret)
 			return ret;
 	}
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 716d265ba8ca..1716535167ee 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -708,7 +708,7 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 			goto out_put_node;
 		}
 
-		dp = &ds->ports[reg];
+		dp = dsa_to_port(ds, reg);
 
 		err = dsa_port_parse_of(dp, port);
 		if (err)
@@ -787,7 +787,7 @@ static int dsa_switch_parse_ports(struct dsa_switch *ds,
 	for (i = 0; i < DSA_MAX_PORTS; i++) {
 		name = cd->port_names[i];
 		dev = cd->netdev[i];
-		dp = &ds->ports[i];
+		dp = dsa_to_port(ds, i);
 
 		if (!name)
 			continue;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 6a9607518823..df4abe897ed6 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -20,7 +20,7 @@ static unsigned int dsa_switch_fastest_ageing_time(struct dsa_switch *ds,
 	int i;
 
 	for (i = 0; i < ds->num_ports; ++i) {
-		struct dsa_port *dp = &ds->ports[i];
+		struct dsa_port *dp = dsa_to_port(ds, i);
 
 		if (dp->ageing_time && dp->ageing_time < ageing_time)
 			ageing_time = dp->ageing_time;
@@ -98,7 +98,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	if (unset_vlan_filtering) {
 		struct switchdev_trans trans = {0};
 
-		err = dsa_port_vlan_filtering(&ds->ports[info->port],
+		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
 					      false, &trans);
 		if (err && err != EOPNOTSUPP)
 			return err;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 9c1cc2482b68..bf91fc55fc44 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -103,7 +103,7 @@ static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
 	if (!dsa_is_user_port(ds, port))
 		return 0;
 
-	slave = ds->ports[port].slave;
+	slave = dsa_to_port(ds, port)->slave;
 
 	err = br_vlan_get_pvid(slave, &pvid);
 	if (err < 0)
@@ -118,7 +118,7 @@ static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
 		return err;
 	}
 
-	return dsa_port_vid_add(&ds->ports[port], pvid, vinfo.flags);
+	return dsa_port_vid_add(dsa_to_port(ds, port), pvid, vinfo.flags);
 }
 
 /* If @enabled is true, installs @vid with @flags into the switch port's HW
@@ -130,7 +130,7 @@ static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
 static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
 			       u16 flags, bool enabled)
 {
-	struct dsa_port *dp = &ds->ports[port];
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct bridge_vlan_info vinfo;
 	int err;
 
-- 
2.23.0

