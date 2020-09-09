Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249D92639BB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbgIJCBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:01:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729986AbgIJBrU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 21:47:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG9z5-00Dzpc-UP; Thu, 10 Sep 2020 01:58:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 7/9] net: dsa: mv88e6xxx: Add devlink regions
Date:   Thu, 10 Sep 2020 01:58:25 +0200
Message-Id: <20200909235827.3335881-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200909235827.3335881-1-andrew@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the global registers, and the ATU to be snapshot via devlink
regions. It is later planned to add support for the port registers.

v2:
Remove left over debug prints
Comment ATU format is generic for mv88e6xxx, not wider

v3:
Make use of ops structure passed to snapshot function
Remove port regions

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  14 +-
 drivers/net/dsa/mv88e6xxx/chip.h    |  12 ++
 drivers/net/dsa/mv88e6xxx/devlink.c | 245 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/devlink.h |   2 +
 4 files changed, 272 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d8bb5e5e8583..8d1710c896ae 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2838,6 +2838,7 @@ static void mv88e6xxx_teardown(struct dsa_switch *ds)
 {
 	mv88e6xxx_teardown_devlink_params(ds);
 	dsa_devlink_resources_unregister(ds);
+	mv88e6xxx_teardown_devlink_regions(ds);
 }
 
 static int mv88e6xxx_setup(struct dsa_switch *ds)
@@ -2970,7 +2971,18 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	err = mv88e6xxx_setup_devlink_params(ds);
 	if (err)
-		dsa_devlink_resources_unregister(ds);
+		goto out_resources;
+
+	err = mv88e6xxx_setup_devlink_regions(ds);
+	if (err)
+		goto out_params;
+
+	return 0;
+
+out_params:
+	mv88e6xxx_teardown_devlink_params(ds);
+out_resources:
+	dsa_devlink_resources_unregister(ds);
 
 	return err;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 77d81aa99f37..d8bd211afcec 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -238,6 +238,15 @@ struct mv88e6xxx_port {
 	bool mirror_egress;
 	unsigned int serdes_irq;
 	char serdes_irq_name[64];
+	struct devlink_region *region;
+};
+
+enum mv88e6xxx_region_id {
+	MV88E6XXX_REGION_GLOBAL1 = 0,
+	MV88E6XXX_REGION_GLOBAL2,
+	MV88E6XXX_REGION_ATU,
+
+	_MV88E6XXX_REGION_MAX,
 };
 
 struct mv88e6xxx_chip {
@@ -334,6 +343,9 @@ struct mv88e6xxx_chip {
 
 	/* Array of port structures. */
 	struct mv88e6xxx_port ports[DSA_MAX_PORTS];
+
+	/* devlink regions */
+	struct devlink_region *regions[_MV88E6XXX_REGION_MAX];
 };
 
 struct mv88e6xxx_bus_ops {
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 91e02024c5cf..e58f68bd17dc 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -5,6 +5,7 @@
 #include "devlink.h"
 #include "global1.h"
 #include "global2.h"
+#include "port.h"
 
 static int mv88e6xxx_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash)
 {
@@ -260,3 +261,247 @@ int mv88e6xxx_setup_devlink_resources(struct dsa_switch *ds)
 	return err;
 }
 
+static int mv88e6xxx_region_global_snapshot(struct devlink *dl,
+					    const struct devlink_region_ops *ops,
+					    struct netlink_ext_ack *extack,
+					    u8 **data)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+	struct mv88e6xxx_chip *chip = ds->priv;
+	u16 *registers;
+	int i, err;
+
+	registers = kmalloc_array(32, sizeof(u16), GFP_KERNEL);
+	if (!registers)
+		return -ENOMEM;
+
+	mv88e6xxx_reg_lock(chip);
+	for (i = 0; i < 32; i++) {
+		switch ((long)ops->priv) {
+		case 1:
+			err = mv88e6xxx_g1_read(chip, i, &registers[i]);
+			break;
+		case 2:
+			err = mv88e6xxx_g1_read(chip, i, &registers[i]);
+			break;
+		default:
+			err = -EOPNOTSUPP;
+		}
+
+		if (err) {
+			kfree(registers);
+			goto out;
+		}
+	}
+	*data = (u8 *)registers;
+out:
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+/* The ATU entry varies between mv88e6xxx chipset generations. Define
+ * a generic format which covers all the current and hopefully future
+ * mv88e6xxx generations
+ */
+
+struct mv88e6xxx_devlink_atu_entry {
+	/* The FID is scattered over multiple registers. */
+	u16 fid;
+	u16 atu_op;
+	u16 atu_data;
+	u16 atu_01;
+	u16 atu_23;
+	u16 atu_45;
+};
+
+static int mv88e6xxx_region_atu_snapshot_fid(struct mv88e6xxx_chip *chip,
+					     int fid,
+					     struct mv88e6xxx_devlink_atu_entry *table,
+					     int *count)
+{
+	u16 atu_op, atu_data, atu_01, atu_23, atu_45;
+	struct mv88e6xxx_atu_entry addr;
+	int err;
+
+	addr.state = 0;
+	eth_broadcast_addr(addr.mac);
+
+	do {
+		err = mv88e6xxx_g1_atu_getnext(chip, fid, &addr);
+		if (err)
+			return err;
+
+		if (!addr.state)
+			break;
+
+		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_OP, &atu_op);
+		if (err)
+			return err;
+
+		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_DATA, &atu_data);
+		if (err)
+			return err;
+
+		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_MAC01, &atu_01);
+		if (err)
+			return err;
+
+		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_MAC23, &atu_23);
+		if (err)
+			return err;
+
+		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_MAC45, &atu_45);
+		if (err)
+			return err;
+
+		table[*count].fid = fid;
+		table[*count].atu_op = atu_op;
+		table[*count].atu_data = atu_data;
+		table[*count].atu_01 = atu_01;
+		table[*count].atu_23 = atu_23;
+		table[*count].atu_45 = atu_45;
+		(*count)++;
+	} while (!is_broadcast_ether_addr(addr.mac));
+
+	return 0;
+}
+
+static int mv88e6xxx_region_atu_snapshot(struct devlink *dl,
+					 const struct devlink_region_ops *ops,
+					 struct netlink_ext_ack *extack,
+					 u8 **data)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+	DECLARE_BITMAP(fid_bitmap, MV88E6XXX_N_FID);
+	struct mv88e6xxx_devlink_atu_entry *table;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int fid = -1, count, err;
+
+	table = kmalloc_array(mv88e6xxx_num_databases(chip),
+			      sizeof(struct mv88e6xxx_devlink_atu_entry),
+			      GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	memset(table, 0, mv88e6xxx_num_databases(chip) *
+	       sizeof(struct mv88e6xxx_devlink_atu_entry));
+
+	count = 0;
+
+	mv88e6xxx_reg_lock(chip);
+
+	err = mv88e6xxx_fid_map(chip, fid_bitmap);
+	if (err)
+		goto out;
+
+	while (1) {
+		fid = find_next_bit(fid_bitmap, MV88E6XXX_N_FID, fid + 1);
+		if (fid == MV88E6XXX_N_FID)
+			break;
+
+		err =  mv88e6xxx_region_atu_snapshot_fid(chip, fid, table,
+							 &count);
+		if (err) {
+			kfree(table);
+			goto out;
+		}
+	}
+	*data = (u8 *)table;
+out:
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static struct devlink_region_ops mv88e6xxx_region_global1_ops = {
+	.name = "global1",
+	.snapshot = mv88e6xxx_region_global_snapshot,
+	.destructor = kfree,
+	.priv = (void *)1,
+};
+
+static struct devlink_region_ops mv88e6xxx_region_global2_ops = {
+	.name = "global2",
+	.snapshot = mv88e6xxx_region_global_snapshot,
+	.destructor = kfree,
+	.priv = (void *)2,
+};
+
+static struct devlink_region_ops mv88e6xxx_region_atu_ops = {
+	.name = "atu",
+	.snapshot = mv88e6xxx_region_atu_snapshot,
+	.destructor = kfree,
+};
+
+struct mv88e6xxx_region {
+	struct devlink_region_ops *ops;
+	u64 size;
+};
+
+static struct mv88e6xxx_region mv88e6xxx_regions[] = {
+	[MV88E6XXX_REGION_GLOBAL1] = {
+		.ops = &mv88e6xxx_region_global1_ops,
+		.size = 32 * sizeof(u16)
+	},
+	[MV88E6XXX_REGION_GLOBAL2] = {
+		.ops = &mv88e6xxx_region_global2_ops,
+		.size = 32 * sizeof(u16) },
+	[MV88E6XXX_REGION_ATU] = {
+		.ops = &mv88e6xxx_region_atu_ops
+	  /* calculated at runtime */
+	},
+};
+
+static void
+mv88e6xxx_teardown_devlink_regions_global(struct mv88e6xxx_chip *chip)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_regions); i++)
+		dsa_devlink_region_destroy(chip->regions[i]);
+}
+
+void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	mv88e6xxx_teardown_devlink_regions_global(chip);
+}
+
+static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
+						  struct mv88e6xxx_chip *chip)
+{
+	struct devlink_region_ops *ops;
+	struct devlink_region *region;
+	u64 size;
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_regions); i++) {
+		ops = mv88e6xxx_regions[i].ops;
+		size = mv88e6xxx_regions[i].size;
+
+		if (i == MV88E6XXX_REGION_ATU)
+			size = mv88e6xxx_num_databases(chip) *
+				sizeof(struct mv88e6xxx_devlink_atu_entry);
+
+		region = dsa_devlink_region_create(ds, ops, 1, size);
+		if (IS_ERR(region))
+			goto out;
+		chip->regions[i] = region;
+	}
+	return 0;
+
+out:
+	for (j = 0; j < i; j++)
+		dsa_devlink_region_destroy(chip->regions[j]);
+
+	return PTR_ERR(region);
+}
+
+int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	return mv88e6xxx_setup_devlink_regions_global(ds, chip);
+}
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.h b/drivers/net/dsa/mv88e6xxx/devlink.h
index f6254e049653..da83c25d944b 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.h
+++ b/drivers/net/dsa/mv88e6xxx/devlink.h
@@ -12,5 +12,7 @@ int mv88e6xxx_devlink_param_get(struct dsa_switch *ds, u32 id,
 				struct devlink_param_gset_ctx *ctx);
 int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
 				struct devlink_param_gset_ctx *ctx);
+int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds);
+void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds);
 
 #endif /* _MV88E6XXX_DEVLINK_H */
-- 
2.28.0

