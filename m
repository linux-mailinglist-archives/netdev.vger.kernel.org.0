Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2694129AA0A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421124AbgJ0KwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:52:12 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46972 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420875AbgJ0KwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:52:01 -0400
Received: by mail-lj1-f196.google.com with SMTP id 2so1136898ljj.13
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 03:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=f1RSjXh0AcThDYVlF5BaWS3ol8ZodBtcppIpRMqimtI=;
        b=0SgVvpx32iOw9pK5Yp+opD6mRyh2Iro7w2XUeiH67Kvz3tpDyLxqpMUY21viq7aCrJ
         1JSi7aDSD6eEC0juGlRq5hOjs0m9udYuFPK1Rk13oKBBzhl1O2ZJiBrIHHY5ANO1I3uY
         2mIyolKss0durSsaXpy639etXZTKtb6E3zakUR+4/va5RRJZohtWC4lTv9YNDQVDIGQ6
         EvqCn6Ci8h2yaD4QSl27w0OEugTIJInzi0V2LjdYERt+SuG4bp+mfIYU7DZ0YabGnw7v
         Kiybk8zU4IK3dJFRUwjJIeyLCy9lsCQePTETkIP0zdoYCUwM00utLx26Jah8acrdqItw
         CKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=f1RSjXh0AcThDYVlF5BaWS3ol8ZodBtcppIpRMqimtI=;
        b=cNccXjnL+nkiccYv3lfc5rCGhbXRlJ497SQTiUAlIiTYAwn3bQ5nAOcwnH0zLyD89T
         22MoqudKnevBbstyJdHXYnVf8FB4QeQ803BaNf/oM3RxmhGWpwwwNMPtVmIfW5UNSPom
         IFgWgtIQ3A7J50hK0sTSrZWO5KB4bDyzIS1hJx2cHshSMOjBFowSU/Resd5HHOQtHgFF
         HARn2h5W4bJsDj7zcXD992oG4hGBWoO9PnhvUZe4vnRC15DIuhc+ju/efdQipIfvNAmb
         6oMFGNEJFenzGSDrKufDpL59Mo1hjNyH8/zCQrCXqAEvv2XZCkiUO25rdg+g2qc3B8JO
         Mfhw==
X-Gm-Message-State: AOAM5300YkVasOOF4pa/GVceAFonIOA0xIxlf/wvu71fAobfXP9saHw8
        dbHD6+wHdoacZqkYIHkShoJsGg==
X-Google-Smtp-Source: ABdhPJxSaFtLZRr+J438NTdpTi55cSMURL5zzMTGKd2K0OD4QZlYDZJgxEsRzDc8mpeywDsFCBuRLg==
X-Received: by 2002:a2e:8799:: with SMTP id n25mr878834lji.348.1603795915683;
        Tue, 27 Oct 2020 03:51:55 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s19sm134385lfb.224.2020.10.27.03.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 03:51:55 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [RFC PATCH 3/4] net: dsa: mv88e6xxx: link aggregation support
Date:   Tue, 27 Oct 2020 11:51:16 +0100
Message-Id: <20201027105117.23052-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201027105117.23052-1-tobias@waldekranz.com>
References: <20201027105117.23052-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support offloading of LAGs to hardware. LAGs may be attached to a
bridge in which case VLANs, multicast groups, etc. is also offloaded
as usual.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 228 +++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |   4 +
 drivers/net/dsa/mv88e6xxx/global2.c |   8 +-
 drivers/net/dsa/mv88e6xxx/global2.h |   5 +
 drivers/net/dsa/mv88e6xxx/port.c    |  21 +++
 drivers/net/dsa/mv88e6xxx/port.h    |   5 +
 6 files changed, 263 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 536ee6cff779..92874d53ba18 100644
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
@@ -5326,6 +5339,207 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
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
+	int i, err, nth;
+	u16 mask[8] = { 0 };
+	u16 ivec;
+
+	/* Assume no port is a member of any LAG. */
+	ivec = BIT(mv88e6xxx_num_ports(chip)) - 1;
+
+	/* Disable all masks for ports that _are_ members of a LAG. */
+	list_for_each_entry(lag, &ds->dst->lags, list) {
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
+	list_for_each_entry(lag, &ds->dst->lags, list) {
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
+		return err;
+
+	err = mv88e6xxx_lag_sync_map(ds, lag);
+	if (err)
+		mv88e6xxx_port_set_trunk(chip, port, false, 0);
+
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
+static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds,
+					  int tree_index, int sw_index,
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
+static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds,
+					int tree_index, int sw_index,
+					int port, struct net_device *lag_dev)
+{
+	struct dsa_lag *lag = dsa_lag_by_dev(ds->dst, lag_dev);
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_lag_sync_map(ds, lag);
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
+static void mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds,
+					  int tree_index, int sw_index,
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
@@ -5380,6 +5594,12 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
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
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 81c244fc0419..c460992166f7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -572,6 +572,10 @@ struct mv88e6xxx_ops {
 
 	/* Max Frame Size */
 	int (*set_max_frame_size)(struct mv88e6xxx_chip *chip, int mtu);
+
+	/* Link aggregation */
+	int (*lag_set_map)(struct mv88e6xxx_chip *chip, struct dsa_lag *lag);
+	int (*lag_set_masks)(struct mv88e6xxx_chip *chip, struct dsa_lag *lag);
 };
 
 struct mv88e6xxx_irq_ops {
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 75b227d0f73b..da8bac8813e1 100644
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
index 1f42ee656816..60febaf4da76 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -101,6 +101,7 @@
 #define MV88E6XXX_G2_PVT_ADDR_OP_WRITE_PVLAN	0x3000
 #define MV88E6XXX_G2_PVT_ADDR_OP_READ		0x4000
 #define MV88E6XXX_G2_PVT_ADDR_PTR_MASK		0x01ff
+#define MV88E6XXX_G2_PVT_ADRR_DEV_TRUNK		0x1f
 
 /* Offset 0x0C: Cross-chip Port VLAN Data Register */
 #define MV88E6XXX_G2_PVT_DATA		0x0c
@@ -345,6 +346,10 @@ int mv88e6352_g2_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
 
 int mv88e6xxx_g2_pot_clear(struct mv88e6xxx_chip *chip);
 
+int mv88e6xxx_g2_trunk_mask_write(struct mv88e6xxx_chip *chip, int num,
+				  bool hash, u16 mask);
+int mv88e6xxx_g2_trunk_mapping_write(struct mv88e6xxx_chip *chip, int id,
+				     u16 map);
 int mv88e6xxx_g2_trunk_clear(struct mv88e6xxx_chip *chip);
 
 int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip, int target,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 8128dc607cf4..7bf5ba55bf81 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -815,6 +815,27 @@ int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
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
index 44d76ac973f6..e6a61be7dff9 100644
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
@@ -348,6 +351,8 @@ int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
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

