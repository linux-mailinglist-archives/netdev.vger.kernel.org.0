Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FDA2DC3AD
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgLPQCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgLPQCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:02:40 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8126DC06179C
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:01:59 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id o17so46687950lfg.4
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=LC6JQO95Jsc0adJyk28jwo9e1BtZtfihGYmMu7K67wI=;
        b=nOnMs2yG2FeK1cHdVatCMN594+WeKv5O7N22Z/VmCNHURs5eiWSDCCIDfHZOd7JLI3
         AEwqTrxTMoMB9DN0ziekLjlOyl0f+rKBhyJVPgrzNpC6l8A2nOgSPiT+OxcX6Go8BRtU
         zpKIfWEphi+kHjaiLkHmNlNwx9hJkft57t27eMimliBuXgDo5CWHj09gnI8hcr+CX2Wi
         +FqehfoeOJ6EnK0n75iDOj9rLh0gYdgp1+L0lEhGaUsCXM2fOuCafg73VK3dK3BFhEGZ
         gvcZyuXNOODiSqpQy44sIdWZkdETD3sLWwGCNnjMZr+AZqs0xvMdN+dq+zzqVZu8XPTu
         /SVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=LC6JQO95Jsc0adJyk28jwo9e1BtZtfihGYmMu7K67wI=;
        b=uLah8Ikyj5LwAyjBKw1h5LIg1CqRksBBsRoT3JdkkZoi4UGBrq35EoZnuv4q32ORBi
         Y95JvqPGyhQI7aTN8PjIjTrsLcZf83pgdJTHd2PZ2iYknLq0uGTiHFqJaqHna2a4WInv
         mse1o9D5ohCNdB5KbmMeSLVyEtDGKD5qGMoPiqdQoGCjHfWntJjO2kreX0vzm+m5AK/f
         qGQT4Sn6WXdaciK3dSVqgn6IMiFr0brgVbCABowA/uxCOZF8QL8LNyedcsBuNRtuQj7u
         03iG23GUUgDpF8OABSjpgPCP2H7uUNtDGreOai8cwpVH/V63WKa8vokrPk1H2HDVms6m
         lxQw==
X-Gm-Message-State: AOAM533m7Hc62Ae4MNmEN0RplPEPOZ6+3mJCv1FbPzXHB+XaQiPQcKN8
        4bdEhR5Q+DUthJ5YiJOfAG0FcA==
X-Google-Smtp-Source: ABdhPJyIhAT9Vzn4Z6uXOfeGlHjk1icTfPf2vbvm1Ub60F8Ke+Qh57MRzaLGIw5d+5p3j6TDciSjyA==
X-Received: by 2002:a19:c018:: with SMTP id q24mr8899612lff.631.1608134516903;
        Wed, 16 Dec 2020 08:01:56 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id e25sm275877lfc.40.2020.12.16.08.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:01:52 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 4/5] net: dsa: mv88e6xxx: Link aggregation support
Date:   Wed, 16 Dec 2020 17:00:55 +0100
Message-Id: <20201216160056.27526-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201216160056.27526-1-tobias@waldekranz.com>
References: <20201216160056.27526-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support offloading of LAGs to hardware. LAGs may be attached to a
bridge in which case VLANs, multicast groups, etc. are also offloaded
as usual.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 298 +++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/global2.c |   8 +-
 drivers/net/dsa/mv88e6xxx/global2.h |   5 +
 drivers/net/dsa/mv88e6xxx/port.c    |  21 ++
 drivers/net/dsa/mv88e6xxx/port.h    |   5 +
 5 files changed, 329 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index eafe6bedc692..bd80b3939157 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1189,7 +1189,8 @@ static int mv88e6xxx_set_mac_eee(struct dsa_switch *ds, int port,
 }
 
 /* Mask of the local ports allowed to receive frames from a given fabric port */
-static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
+static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port,
+			       struct net_device **lag)
 {
 	struct dsa_switch *ds = chip->ds;
 	struct dsa_switch_tree *dst = ds->dst;
@@ -1201,6 +1202,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dp->ds->index == dev && dp->index == port) {
 			found = true;
+
+			if (dp->lag_dev && lag)
+				*lag = dp->lag_dev;
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
@@ -1396,14 +1402,21 @@ static int mv88e6xxx_mac_setup(struct mv88e6xxx_chip *chip)
 
 static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 {
+	struct net_device *lag = NULL;
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
+			port = dsa_lag_id(chip->ds->dst, lag);
+		}
+	}
 
 	return mv88e6xxx_g2_pvt_write(chip, dev, port, pvlan);
 }
@@ -5375,6 +5388,271 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
+				      struct net_device *lag,
+				      struct netdev_lag_upper_info *info)
+{
+	struct dsa_port *dp;
+	int id, members = 0;
+
+	id = dsa_lag_id(ds->dst, lag);
+	if (id < 0 || id >= ds->num_lag_ids)
+		return false;
+
+	dsa_lag_foreach_port(dp, ds->dst, lag)
+		/* Includes the port joining the LAG */
+		members++;
+
+	if (members > 8)
+		return false;
+
+	/* We could potentially relax this to include active
+	 * backup in the future.
+	 */
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return false;
+
+	/* Ideally we would also validate that the hash type matches
+	 * the hardware. Alas, this is always set to unknown on team
+	 * interfaces.
+	 */
+	return true;
+}
+
+static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds, struct net_device *lag)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct dsa_port *dp;
+	u16 map = 0;
+	int id;
+
+	id = dsa_lag_id(ds->dst, lag);
+
+	/* Build the map of all ports to distribute flows destined for
+	 * this LAG. This can be either a local user port, or a DSA
+	 * port if the LAG port is on a remote chip.
+	 */
+	dsa_lag_foreach_port(dp, ds->dst, lag)
+		map |= BIT(dsa_towards_port(ds, dp->ds->index, dp->index));
+
+	return mv88e6xxx_g2_trunk_mapping_write(chip, id, map);
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
+	unsigned int id, num_tx;
+	struct net_device *lag;
+	struct dsa_port *dp;
+	int i, err, nth;
+	u16 mask[8];
+	u16 ivec;
+
+	/* Assume no port is a member of any LAG. */
+	ivec = BIT(mv88e6xxx_num_ports(chip)) - 1;
+
+	/* Disable all masks for ports that _are_ members of a LAG. */
+	list_for_each_entry(dp, &ds->dst->ports, list) {
+		if (!dp->lag_dev || dp->ds != ds)
+			continue;
+
+		ivec &= ~BIT(dp->index);
+	}
+
+	for (i = 0; i < 8; i++)
+		mask[i] = ivec;
+
+	/* Enable the correct subset of masks for all LAG ports that
+	 * are in the Tx set.
+	 */
+	dsa_lags_foreach_id(id, ds->dst) {
+		lag = dsa_lag_dev(ds->dst, id);
+		if (!lag)
+			continue;
+
+		num_tx = 0;
+		dsa_lag_foreach_port(dp, ds->dst, lag) {
+			if (dp->lag_tx_enabled)
+				num_tx++;
+		}
+
+		if (!num_tx)
+			continue;
+
+		nth = 0;
+		dsa_lag_foreach_port(dp, ds->dst, lag) {
+			if (!dp->lag_tx_enabled)
+				continue;
+
+			if (dp->ds == ds)
+				mv88e6xxx_lag_set_port_mask(mask, dp->index,
+							    num_tx, nth);
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
+					struct net_device *lag)
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
+static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
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
+				   struct net_device *lag,
+				   struct netdev_lag_upper_info *info)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err, id;
+
+	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
+		return -EOPNOTSUPP;
+
+	id = dsa_lag_id(ds->dst, lag);
+
+	mv88e6xxx_reg_lock(chip);
+
+	err = mv88e6xxx_port_set_trunk(chip, port, true, id);
+	if (err)
+		goto err_unlock;
+
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	if (err)
+		goto err_clear_trunk;
+
+	mv88e6xxx_reg_unlock(chip);
+	return 0;
+
+err_clear_trunk:
+	mv88e6xxx_port_set_trunk(chip, port, false, 0);
+err_unlock:
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
+static int mv88e6xxx_port_lag_leave(struct dsa_switch *ds, int port,
+				    struct net_device *lag)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err_sync, err_trunk;
+
+	mv88e6xxx_reg_lock(chip);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err_trunk = mv88e6xxx_port_set_trunk(chip, port, false, 0);
+	mv88e6xxx_reg_unlock(chip);
+	return err_sync ? : err_trunk;
+}
+
+static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
+					  int port)
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
+					int port, struct net_device *lag,
+					struct netdev_lag_upper_info *info)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
+		return -EOPNOTSUPP;
+
+	mv88e6xxx_reg_lock(chip);
+
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_pvt_map(chip, sw_index, port);
+
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
+static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
+					 int port, struct net_device *lag)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err_sync, err_pvt;
+
+	mv88e6xxx_reg_lock(chip);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
+	err_pvt = mv88e6xxx_pvt_map(chip, sw_index, port);
+	mv88e6xxx_reg_unlock(chip);
+	return err_sync ? : err_pvt;
+}
+
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
 	.setup			= mv88e6xxx_setup,
@@ -5429,6 +5707,12 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
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
@@ -5448,6 +5732,12 @@ static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
 	ds->ageing_time_min = chip->info->age_time_coeff;
 	ds->ageing_time_max = chip->info->age_time_coeff * U8_MAX;
 
+	/* Some chips support up to 32, but that requires enabling the
+	 * 5-bit port mode, which we do not support. 640k^W16 ought to
+	 * be enough for anyone.
+	 */
+	ds->num_lag_ids = 16;
+
 	dev_set_drvdata(dev, ds);
 
 	return dsa_register_switch(ds);
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

