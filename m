Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133392C862F
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgK3OHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgK3OHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:07:09 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA6FC0613D4
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:06:29 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id t22so18120223ljk.0
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=6sgWC273TY1oKYrFjCdOYHZWsRciunikU35lTVS05AE=;
        b=uj5ZWxiS618fMNOHs0MjujXDOiOPPtSEtXA/U/5KsKgnSCgmG/O+T9sX4eZoDAAHuV
         SHVRJuN8K+U6LriwygJfSYiu3MEXHGyvCIqdvDmx89US/YXKZS5Fp7ejz3VxZM/7EaQa
         qeXCil0nY04C8IKOvJ+T8c0IjA7t+sMipIPzkm2w5WKWp2V71/VzECC/aMvnyP5D7eeF
         4rx/V5KLAsXH2hkp2NjjfFyrCLI133V1X7Xsa+LF0Zacb03hxMCFuFLk1XyZRdO+P1Xv
         pQEsUuBn9b3OEvznR3k/ZL+Q0Vf7QgsJXXNtbriRpyLG/bzDyK10I435pPx1juxEbANH
         PuXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=6sgWC273TY1oKYrFjCdOYHZWsRciunikU35lTVS05AE=;
        b=XidX/IZStN0WqwkWmuqq5wW9aj6JqPrniqnvkV8ZrgNqs9joRkTcEJBkZ4PujzBact
         0FyC5K/M4xEXeFYYOXI8kKD3OfpUpsXHy0cR5ICgSKsSP+/JmcOyHCBEzqo8+Ru3Wdl1
         CvAaKM2l48vq94tIg+KjR9mUZKo+xrb7dkj5XRzVcYGZ2v4nF5FChrDtTpzFqOurTtMf
         d32u6YVJA0K2GsTY3M/alROLD6vo5cBDuTKFAuZr0nKPfYxHU9cvsK+NAtehw1E7KSIO
         xb4WTAs5YDt9z8QOzra61HwFbbu4aLIzE6bDGw5NyhR9+1/O1m4y64DAcqN2OcxVnHOG
         Rp6A==
X-Gm-Message-State: AOAM531QHC9cE0XcS5TooBwwC6MU29Wzff9hHe+ori56aaKWZBLfGMN7
        0NyTd7uqgdbupmCLu6ie/ABkvA==
X-Google-Smtp-Source: ABdhPJxOzmxpol9Y6mapXPLPLXgNe9i/EW+UbjJbyl3GvydQdzNi5ei1G8oT6QLvQ/8Nk9D6T+qMLA==
X-Received: by 2002:a2e:a376:: with SMTP id i22mr10180854ljn.217.1606745187515;
        Mon, 30 Nov 2020 06:06:27 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v22sm2977292ljd.9.2020.11.30.06.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 06:06:26 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 3/4] net: dsa: mv88e6xxx: Link aggregation support
Date:   Mon, 30 Nov 2020 15:06:09 +0100
Message-Id: <20201130140610.4018-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130140610.4018-1-tobias@waldekranz.com>
References: <20201130140610.4018-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support offloading of LAGs to hardware. LAGs may be attached to a
bridge in which case VLANs, multicast groups, etc. are also offloaded
as usual.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 234 +++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |   4 +
 drivers/net/dsa/mv88e6xxx/global2.c |   8 +-
 drivers/net/dsa/mv88e6xxx/global2.h |   5 +
 drivers/net/dsa/mv88e6xxx/port.c    |  21 +++
 drivers/net/dsa/mv88e6xxx/port.h    |   5 +
 6 files changed, 269 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index e7f68ac0c7e3..3c4b795ac7e4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1189,7 +1189,8 @@ static int mv88e6xxx_set_mac_eee(struct dsa_switch *ds, int port,
 }
 
 /* Mask of the local ports allowed to receive frames from a given fabric port */
-static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
+static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port,
+			       struct dsa_lag **lag)
 {
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
@@ -1201,6 +1202,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dp->ds->index == dev && dp->index == port) {
 			found = true;
+
+			if (dp->lag && lag)
+				*lag = dp->lag;
 			break;
 		}
 	}
@@ -1231,7 +1235,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 
 static int mv88e6xxx_port_vlan_map(struct mv88e6xxx_chip *chip, int port)
 {
-	u16 output_ports = mv88e6xxx_port_vlan(chip, chip->ds->index, port);
+	u16 output_ports;
+
+	output_ports = mv88e6xxx_port_vlan(chip, chip->ds->index, port, NULL);
 
 	/* prevent frames from going back out of the port they came in on */
 	output_ports &= ~BIT(port);
@@ -1389,14 +1395,21 @@ static int mv88e6xxx_mac_setup(struct mv88e6xxx_chip *chip)
 
 static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 {
+	struct dsa_lag *lag = NULL;
 	u16 pvlan = 0;
 
 	if (!mv88e6xxx_has_pvt(chip))
 		return 0;
 
 	/* Skip the local source device, which uses in-chip port VLAN */
-	if (dev != chip->ds->index)
-		pvlan = mv88e6xxx_port_vlan(chip, dev, port);
+	if (dev != chip->ds->index) {
+		pvlan = mv88e6xxx_port_vlan(chip, dev, port, &lag);
+
+		if (lag) {
+			dev = MV88E6XXX_G2_PVT_ADRR_DEV_TRUNK;
+			port = lag->id;
+		}
+	}
 
 	return mv88e6xxx_g2_pvt_write(chip, dev, port, pvlan);
 }
@@ -5368,6 +5381,207 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds, struct dsa_lag *lag)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct dsa_port *dp;
+	u16 map = 0;
+
+	/* Build the map of all ports to distribute flows destined for
+	 * this LAG. This can be either a local user port, or a DSA
+	 * port if the LAG port is on a remote chip.
+	 */
+	list_for_each_entry(dp, &lag->ports, lag_list) {
+		map |= BIT(dsa_towards_port(ds, dp->ds->index, dp->index));
+	}
+
+	return mv88e6xxx_g2_trunk_mapping_write(chip, lag->id, map);
+}
+
+static const u8 mv88e6xxx_lag_mask_table[8][8] = {
+	/* Row number corresponds to the number of active members in a
+	 * LAG. Each column states which of the eight hash buckets are
+	 * mapped to the column:th port in the LAG.
+	 *
+	 * Example: In a LAG with three active ports, the second port
+	 * ([2][1]) would be selected for traffic mapped to buckets
+	 * 3,4,5 (0x38).
+	 */
+	{ 0xff,    0,    0,    0,    0,    0,    0,    0 },
+	{ 0x0f, 0xf0,    0,    0,    0,    0,    0,    0 },
+	{ 0x07, 0x38, 0xc0,    0,    0,    0,    0,    0 },
+	{ 0x03, 0x0c, 0x30, 0xc0,    0,    0,    0,    0 },
+	{ 0x03, 0x0c, 0x30, 0x40, 0x80,    0,    0,    0 },
+	{ 0x03, 0x0c, 0x10, 0x20, 0x40, 0x80,    0,    0 },
+	{ 0x03, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80,    0 },
+	{ 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 },
+};
+
+static void mv88e6xxx_lag_set_port_mask(u16 *mask, int port,
+					int num_tx, int nth)
+{
+	u8 active = 0;
+	int i;
+
+	num_tx = num_tx <= 8 ? num_tx : 8;
+	if (nth < num_tx)
+		active = mv88e6xxx_lag_mask_table[num_tx - 1][nth];
+
+	for (i = 0; i < 8; i++) {
+		if (BIT(i) & active)
+			mask[i] |= BIT(port);
+	}
+}
+
+static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct dsa_port *dp;
+	struct dsa_lag *lag;
+	int i, id, err, nth;
+	u16 mask[8] = { 0 };
+	u16 ivec;
+
+	/* Assume no port is a member of any LAG. */
+	ivec = BIT(mv88e6xxx_num_ports(chip)) - 1;
+
+	/* Disable all masks for ports that _are_ members of a LAG. */
+	dsa_lag_foreach(id, ds->dst) {
+		lag = dsa_lag_by_id(ds->dst, id);
+		list_for_each_entry(dp, &lag->ports, lag_list) {
+			if (dp->ds != ds)
+				continue;
+
+			ivec &= ~BIT(dp->index);
+		}
+	}
+
+	for (i = 0; i < 8; i++)
+		mask[i] = ivec;
+
+	/* Enable the correct subset of masks for all LAG ports that
+	 * are in the Tx set.
+	 */
+	dsa_lag_foreach(id, ds->dst) {
+		lag = dsa_lag_by_id(ds->dst, id);
+		if (!lag->num_tx)
+			continue;
+
+		nth = 0;
+		list_for_each_entry(dp, &lag->tx_ports, lag_tx_list) {
+			if (dp->ds == ds)
+				mv88e6xxx_lag_set_port_mask(mask, dp->index,
+							    lag->num_tx, nth);
+
+			nth++;
+		}
+	}
+
+	for (i = 0; i < 8; i++) {
+		err = mv88e6xxx_g2_trunk_mask_write(chip, i, true, mask[i]);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int mv88e6xxx_lag_sync_masks_map(struct dsa_switch *ds,
+					struct dsa_lag *lag)
+{
+	int err;
+
+	err = mv88e6xxx_lag_sync_masks(ds);
+
+	if (!err)
+		err = mv88e6xxx_lag_sync_map(ds, lag);
+
+	return err;
+}
+
+static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port,
+				     struct netdev_lag_lower_state_info *info)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_lag_sync_masks(ds);
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
+static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
+				   struct net_device *lag_dev)
+{
+	struct dsa_lag *lag = dsa_to_port(ds, port)->lag;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+
+	err = mv88e6xxx_port_set_trunk(chip, port, true, lag->id);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	if (err)
+		mv88e6xxx_port_set_trunk(chip, port, false, 0);
+
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
+static void mv88e6xxx_port_lag_leave(struct dsa_switch *ds, int port,
+				     struct net_device *lag_dev)
+{
+	struct dsa_lag *lag = dsa_to_port(ds, port)->lag;
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	mv88e6xxx_reg_lock(chip);
+	mv88e6xxx_lag_sync_masks_map(ds, lag);
+	mv88e6xxx_port_set_trunk(chip, port, false, 0);
+	mv88e6xxx_reg_unlock(chip);
+}
+
+static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
+					  int port, struct net_device *lag_dev,
+					  struct netdev_lag_lower_state_info *info)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_lag_sync_masks(ds);
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
+static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
+					int port, struct net_device *lag_dev)
+{
+	struct dsa_lag *lag = dsa_lag_by_dev(ds->dst, lag_dev);
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
+static void mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
+					  int port, struct net_device *lag_dev)
+{
+	struct dsa_lag *lag = dsa_lag_by_dev(ds->dst, lag_dev);
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	mv88e6xxx_reg_lock(chip);
+	mv88e6xxx_lag_sync_masks_map(ds, lag);
+	mv88e6xxx_reg_unlock(chip);
+}
+
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
 	.setup			= mv88e6xxx_setup,
@@ -5422,6 +5636,12 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.devlink_param_get	= mv88e6xxx_devlink_param_get,
 	.devlink_param_set	= mv88e6xxx_devlink_param_set,
 	.devlink_info_get	= mv88e6xxx_devlink_info_get,
+	.port_lag_change	= mv88e6xxx_port_lag_change,
+	.port_lag_join		= mv88e6xxx_port_lag_join,
+	.port_lag_leave		= mv88e6xxx_port_lag_leave,
+	.crosschip_lag_change	= mv88e6xxx_crosschip_lag_change,
+	.crosschip_lag_join	= mv88e6xxx_crosschip_lag_join,
+	.crosschip_lag_leave	= mv88e6xxx_crosschip_lag_leave,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
@@ -5441,6 +5661,12 @@ static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
 	ds->ageing_time_min = chip->info->age_time_coeff;
 	ds->ageing_time_max = chip->info->age_time_coeff * U8_MAX;
 
+	/* Some chips support up to 32, but that requires enabling the
+	 * 5-bit port mode, which we do not support. 640k^W16 ought to
+	 * be enough for anyone.
+	 */
+	ds->num_lags = 16;
+
 	dev_set_drvdata(dev, ds);
 
 	return dsa_register_switch(ds);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e196d7270606..fc7625593c81 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -580,6 +580,10 @@ struct mv88e6xxx_ops {
 
 	/* Max Frame Size */
 	int (*set_max_frame_size)(struct mv88e6xxx_chip *chip, int mtu);
+
+	/* Link aggregation */
+	int (*lag_set_map)(struct mv88e6xxx_chip *chip, struct dsa_lag *lag);
+	int (*lag_set_masks)(struct mv88e6xxx_chip *chip, struct dsa_lag *lag);
 };
 
 struct mv88e6xxx_irq_ops {
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 8dbb1ae723ae..fa65ecd9cb85 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -126,8 +126,8 @@ int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip, int target,
 
 /* Offset 0x07: Trunk Mask Table register */
 
-static int mv88e6xxx_g2_trunk_mask_write(struct mv88e6xxx_chip *chip, int num,
-					 bool hash, u16 mask)
+int mv88e6xxx_g2_trunk_mask_write(struct mv88e6xxx_chip *chip, int num,
+				  bool hash, u16 mask)
 {
 	u16 val = (num << 12) | (mask & mv88e6xxx_port_mask(chip));
 
@@ -140,8 +140,8 @@ static int mv88e6xxx_g2_trunk_mask_write(struct mv88e6xxx_chip *chip, int num,
 
 /* Offset 0x08: Trunk Mapping Table register */
 
-static int mv88e6xxx_g2_trunk_mapping_write(struct mv88e6xxx_chip *chip, int id,
-					    u16 map)
+int mv88e6xxx_g2_trunk_mapping_write(struct mv88e6xxx_chip *chip, int id,
+				     u16 map)
 {
 	const u16 port_mask = BIT(mv88e6xxx_num_ports(chip)) - 1;
 	u16 val = (id << 11) | (map & port_mask);
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 1510a1c810c8..621bbc4a1d80 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -101,6 +101,7 @@
 #define MV88E6XXX_G2_PVT_ADDR_OP_WRITE_PVLAN	0x3000
 #define MV88E6XXX_G2_PVT_ADDR_OP_READ		0x4000
 #define MV88E6XXX_G2_PVT_ADDR_PTR_MASK		0x01ff
+#define MV88E6XXX_G2_PVT_ADRR_DEV_TRUNK		0x1f
 
 /* Offset 0x0C: Cross-chip Port VLAN Data Register */
 #define MV88E6XXX_G2_PVT_DATA		0x0c
@@ -347,6 +348,10 @@ int mv88e6352_g2_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
 
 int mv88e6xxx_g2_pot_clear(struct mv88e6xxx_chip *chip);
 
+int mv88e6xxx_g2_trunk_mask_write(struct mv88e6xxx_chip *chip, int num,
+				  bool hash, u16 mask);
+int mv88e6xxx_g2_trunk_mapping_write(struct mv88e6xxx_chip *chip, int id,
+				     u16 map);
 int mv88e6xxx_g2_trunk_clear(struct mv88e6xxx_chip *chip);
 
 int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip, int target,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 77a5fd1798cd..4b46e10a2dde 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -851,6 +851,27 @@ int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL1, val);
 }
 
+int mv88e6xxx_port_set_trunk(struct mv88e6xxx_chip *chip, int port,
+			     bool trunk, u8 id)
+{
+	u16 val;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL1, &val);
+	if (err)
+		return err;
+
+	val &= ~MV88E6XXX_PORT_CTL1_TRUNK_ID_MASK;
+
+	if (trunk)
+		val |= MV88E6XXX_PORT_CTL1_TRUNK_PORT |
+			(id << MV88E6XXX_PORT_CTL1_TRUNK_ID_SHIFT);
+	else
+		val &= ~MV88E6XXX_PORT_CTL1_TRUNK_PORT;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL1, val);
+}
+
 /* Offset 0x06: Port Based VLAN Map */
 
 int mv88e6xxx_port_set_vlan_map(struct mv88e6xxx_chip *chip, int port, u16 map)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 500e1d4896ff..a729bba050df 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -168,6 +168,9 @@
 /* Offset 0x05: Port Control 1 */
 #define MV88E6XXX_PORT_CTL1			0x05
 #define MV88E6XXX_PORT_CTL1_MESSAGE_PORT	0x8000
+#define MV88E6XXX_PORT_CTL1_TRUNK_PORT		0x4000
+#define MV88E6XXX_PORT_CTL1_TRUNK_ID_MASK	0x0f00
+#define MV88E6XXX_PORT_CTL1_TRUNK_ID_SHIFT	8
 #define MV88E6XXX_PORT_CTL1_FID_11_4_MASK	0x00ff
 
 /* Offset 0x06: Port Based VLAN Map */
@@ -351,6 +354,8 @@ int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
 				  u16 etype);
 int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
 				    bool message_port);
+int mv88e6xxx_port_set_trunk(struct mv88e6xxx_chip *chip, int port,
+			     bool trunk, u8 id);
 int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 				  size_t size);
 int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
-- 
2.17.1

