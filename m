Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4428C263AD6
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgIJCAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:00:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729860AbgIJBpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 21:45:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG9z5-00DzpW-RT; Thu, 10 Sep 2020 01:58:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 5/9] net: dsa: mv88e6xxx: Move devlink code into its own file
Date:   Thu, 10 Sep 2020 01:58:23 +0200
Message-Id: <20200909235827.3335881-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200909235827.3335881-1-andrew@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There will soon be more devlink code. Move the existing code into a
file of its own, before we start adding this new code.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/Makefile  |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c    | 255 +--------------------------
 drivers/net/dsa/mv88e6xxx/devlink.c | 262 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/devlink.h |  16 ++
 4 files changed, 280 insertions(+), 254 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.h

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index aa645ff86f64..4b080b448ce7 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_NET_DSA_MV88E6XXX) += mv88e6xxx.o
 mv88e6xxx-objs := chip.o
+mv88e6xxx-objs += devlink.o
 mv88e6xxx-objs += global1.o
 mv88e6xxx-objs += global1_atu.o
 mv88e6xxx-objs += global1_vtu.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 15b97a4f8d93..984bdcaff1ea 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -32,6 +32,7 @@
 #include <net/dsa.h>
 
 #include "chip.h"
+#include "devlink.h"
 #include "global1.h"
 #include "global2.h"
 #include "hwtstamp.h"
@@ -1508,22 +1509,6 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 	return mv88e6xxx_g1_atu_flush(chip, *fid, true);
 }
 
-static int mv88e6xxx_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash)
-{
-	if (chip->info->ops->atu_get_hash)
-		return chip->info->ops->atu_get_hash(chip, hash);
-
-	return -EOPNOTSUPP;
-}
-
-static int mv88e6xxx_atu_set_hash(struct mv88e6xxx_chip *chip, u8 hash)
-{
-	if (chip->info->ops->atu_set_hash)
-		return chip->info->ops->atu_set_hash(chip, hash);
-
-	return -EOPNOTSUPP;
-}
-
 static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 					u16 vid_begin, u16 vid_end)
 {
@@ -2837,244 +2822,6 @@ static int mv88e6390_setup_errata(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_software_reset(chip);
 }
 
-enum mv88e6xxx_devlink_param_id {
-	MV88E6XXX_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
-	MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH,
-};
-
-static int mv88e6xxx_devlink_param_get(struct dsa_switch *ds, u32 id,
-				       struct devlink_param_gset_ctx *ctx)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	mv88e6xxx_reg_lock(chip);
-
-	switch (id) {
-	case MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH:
-		err = mv88e6xxx_atu_get_hash(chip, &ctx->val.vu8);
-		break;
-	default:
-		err = -EOPNOTSUPP;
-		break;
-	}
-
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
-}
-
-static int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
-				       struct devlink_param_gset_ctx *ctx)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	mv88e6xxx_reg_lock(chip);
-
-	switch (id) {
-	case MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH:
-		err = mv88e6xxx_atu_set_hash(chip, ctx->val.vu8);
-		break;
-	default:
-		err = -EOPNOTSUPP;
-		break;
-	}
-
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
-}
-
-static const struct devlink_param mv88e6xxx_devlink_params[] = {
-	DSA_DEVLINK_PARAM_DRIVER(MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH,
-				 "ATU_hash", DEVLINK_PARAM_TYPE_U8,
-				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
-};
-
-static int mv88e6xxx_setup_devlink_params(struct dsa_switch *ds)
-{
-	return dsa_devlink_params_register(ds, mv88e6xxx_devlink_params,
-					   ARRAY_SIZE(mv88e6xxx_devlink_params));
-}
-
-static void mv88e6xxx_teardown_devlink_params(struct dsa_switch *ds)
-{
-	dsa_devlink_params_unregister(ds, mv88e6xxx_devlink_params,
-				      ARRAY_SIZE(mv88e6xxx_devlink_params));
-}
-
-enum mv88e6xxx_devlink_resource_id {
-	MV88E6XXX_RESOURCE_ID_ATU,
-	MV88E6XXX_RESOURCE_ID_ATU_BIN_0,
-	MV88E6XXX_RESOURCE_ID_ATU_BIN_1,
-	MV88E6XXX_RESOURCE_ID_ATU_BIN_2,
-	MV88E6XXX_RESOURCE_ID_ATU_BIN_3,
-};
-
-static u64 mv88e6xxx_devlink_atu_bin_get(struct mv88e6xxx_chip *chip,
-					 u16 bin)
-{
-	u16 occupancy = 0;
-	int err;
-
-	mv88e6xxx_reg_lock(chip);
-
-	err = mv88e6xxx_g2_atu_stats_set(chip, MV88E6XXX_G2_ATU_STATS_MODE_ALL,
-					 bin);
-	if (err) {
-		dev_err(chip->dev, "failed to set ATU stats kind/bin\n");
-		goto unlock;
-	}
-
-	err = mv88e6xxx_g1_atu_get_next(chip, 0);
-	if (err) {
-		dev_err(chip->dev, "failed to perform ATU get next\n");
-		goto unlock;
-	}
-
-	err = mv88e6xxx_g2_atu_stats_get(chip, &occupancy);
-	if (err) {
-		dev_err(chip->dev, "failed to get ATU stats\n");
-		goto unlock;
-	}
-
-	occupancy &= MV88E6XXX_G2_ATU_STATS_MASK;
-
-unlock:
-	mv88e6xxx_reg_unlock(chip);
-
-	return occupancy;
-}
-
-static u64 mv88e6xxx_devlink_atu_bin_0_get(void *priv)
-{
-	struct mv88e6xxx_chip *chip = priv;
-
-	return mv88e6xxx_devlink_atu_bin_get(chip,
-					     MV88E6XXX_G2_ATU_STATS_BIN_0);
-}
-
-static u64 mv88e6xxx_devlink_atu_bin_1_get(void *priv)
-{
-	struct mv88e6xxx_chip *chip = priv;
-
-	return mv88e6xxx_devlink_atu_bin_get(chip,
-					     MV88E6XXX_G2_ATU_STATS_BIN_1);
-}
-
-static u64 mv88e6xxx_devlink_atu_bin_2_get(void *priv)
-{
-	struct mv88e6xxx_chip *chip = priv;
-
-	return mv88e6xxx_devlink_atu_bin_get(chip,
-					     MV88E6XXX_G2_ATU_STATS_BIN_2);
-}
-
-static u64 mv88e6xxx_devlink_atu_bin_3_get(void *priv)
-{
-	struct mv88e6xxx_chip *chip = priv;
-
-	return mv88e6xxx_devlink_atu_bin_get(chip,
-					     MV88E6XXX_G2_ATU_STATS_BIN_3);
-}
-
-static u64 mv88e6xxx_devlink_atu_get(void *priv)
-{
-	return mv88e6xxx_devlink_atu_bin_0_get(priv) +
-		mv88e6xxx_devlink_atu_bin_1_get(priv) +
-		mv88e6xxx_devlink_atu_bin_2_get(priv) +
-		mv88e6xxx_devlink_atu_bin_3_get(priv);
-}
-
-static int mv88e6xxx_setup_devlink_resources(struct dsa_switch *ds)
-{
-	struct devlink_resource_size_params size_params;
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	devlink_resource_size_params_init(&size_params,
-					  mv88e6xxx_num_macs(chip),
-					  mv88e6xxx_num_macs(chip),
-					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
-
-	err = dsa_devlink_resource_register(ds, "ATU",
-					    mv88e6xxx_num_macs(chip),
-					    MV88E6XXX_RESOURCE_ID_ATU,
-					    DEVLINK_RESOURCE_ID_PARENT_TOP,
-					    &size_params);
-	if (err)
-		goto out;
-
-	devlink_resource_size_params_init(&size_params,
-					  mv88e6xxx_num_macs(chip) / 4,
-					  mv88e6xxx_num_macs(chip) / 4,
-					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
-
-	err = dsa_devlink_resource_register(ds, "ATU_bin_0",
-					    mv88e6xxx_num_macs(chip) / 4,
-					    MV88E6XXX_RESOURCE_ID_ATU_BIN_0,
-					    MV88E6XXX_RESOURCE_ID_ATU,
-					    &size_params);
-	if (err)
-		goto out;
-
-	err = dsa_devlink_resource_register(ds, "ATU_bin_1",
-					    mv88e6xxx_num_macs(chip) / 4,
-					    MV88E6XXX_RESOURCE_ID_ATU_BIN_1,
-					    MV88E6XXX_RESOURCE_ID_ATU,
-					    &size_params);
-	if (err)
-		goto out;
-
-	err = dsa_devlink_resource_register(ds, "ATU_bin_2",
-					    mv88e6xxx_num_macs(chip) / 4,
-					    MV88E6XXX_RESOURCE_ID_ATU_BIN_2,
-					    MV88E6XXX_RESOURCE_ID_ATU,
-					    &size_params);
-	if (err)
-		goto out;
-
-	err = dsa_devlink_resource_register(ds, "ATU_bin_3",
-					    mv88e6xxx_num_macs(chip) / 4,
-					    MV88E6XXX_RESOURCE_ID_ATU_BIN_3,
-					    MV88E6XXX_RESOURCE_ID_ATU,
-					    &size_params);
-	if (err)
-		goto out;
-
-	dsa_devlink_resource_occ_get_register(ds,
-					      MV88E6XXX_RESOURCE_ID_ATU,
-					      mv88e6xxx_devlink_atu_get,
-					      chip);
-
-	dsa_devlink_resource_occ_get_register(ds,
-					      MV88E6XXX_RESOURCE_ID_ATU_BIN_0,
-					      mv88e6xxx_devlink_atu_bin_0_get,
-					      chip);
-
-	dsa_devlink_resource_occ_get_register(ds,
-					      MV88E6XXX_RESOURCE_ID_ATU_BIN_1,
-					      mv88e6xxx_devlink_atu_bin_1_get,
-					      chip);
-
-	dsa_devlink_resource_occ_get_register(ds,
-					      MV88E6XXX_RESOURCE_ID_ATU_BIN_2,
-					      mv88e6xxx_devlink_atu_bin_2_get,
-					      chip);
-
-	dsa_devlink_resource_occ_get_register(ds,
-					      MV88E6XXX_RESOURCE_ID_ATU_BIN_3,
-					      mv88e6xxx_devlink_atu_bin_3_get,
-					      chip);
-
-	return 0;
-
-out:
-	dsa_devlink_resources_unregister(ds);
-	return err;
-}
-
 static void mv88e6xxx_teardown(struct dsa_switch *ds)
 {
 	mv88e6xxx_teardown_devlink_params(ds);
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
new file mode 100644
index 000000000000..91e02024c5cf
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -0,0 +1,262 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <net/dsa.h>
+
+#include "chip.h"
+#include "devlink.h"
+#include "global1.h"
+#include "global2.h"
+
+static int mv88e6xxx_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash)
+{
+	if (chip->info->ops->atu_get_hash)
+		return chip->info->ops->atu_get_hash(chip, hash);
+
+	return -EOPNOTSUPP;
+}
+
+static int mv88e6xxx_atu_set_hash(struct mv88e6xxx_chip *chip, u8 hash)
+{
+	if (chip->info->ops->atu_set_hash)
+		return chip->info->ops->atu_set_hash(chip, hash);
+
+	return -EOPNOTSUPP;
+}
+
+enum mv88e6xxx_devlink_param_id {
+	MV88E6XXX_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH,
+};
+
+int mv88e6xxx_devlink_param_get(struct dsa_switch *ds, u32 id,
+				struct devlink_param_gset_ctx *ctx)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+
+	switch (id) {
+	case MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH:
+		err = mv88e6xxx_atu_get_hash(chip, &ctx->val.vu8);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
+				struct devlink_param_gset_ctx *ctx)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+
+	switch (id) {
+	case MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH:
+		err = mv88e6xxx_atu_set_hash(chip, ctx->val.vu8);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static const struct devlink_param mv88e6xxx_devlink_params[] = {
+	DSA_DEVLINK_PARAM_DRIVER(MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH,
+				 "ATU_hash", DEVLINK_PARAM_TYPE_U8,
+				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
+};
+
+int mv88e6xxx_setup_devlink_params(struct dsa_switch *ds)
+{
+	return dsa_devlink_params_register(ds, mv88e6xxx_devlink_params,
+					   ARRAY_SIZE(mv88e6xxx_devlink_params));
+}
+
+void mv88e6xxx_teardown_devlink_params(struct dsa_switch *ds)
+{
+	dsa_devlink_params_unregister(ds, mv88e6xxx_devlink_params,
+				      ARRAY_SIZE(mv88e6xxx_devlink_params));
+}
+
+enum mv88e6xxx_devlink_resource_id {
+	MV88E6XXX_RESOURCE_ID_ATU,
+	MV88E6XXX_RESOURCE_ID_ATU_BIN_0,
+	MV88E6XXX_RESOURCE_ID_ATU_BIN_1,
+	MV88E6XXX_RESOURCE_ID_ATU_BIN_2,
+	MV88E6XXX_RESOURCE_ID_ATU_BIN_3,
+};
+
+static u64 mv88e6xxx_devlink_atu_bin_get(struct mv88e6xxx_chip *chip,
+					 u16 bin)
+{
+	u16 occupancy = 0;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+
+	err = mv88e6xxx_g2_atu_stats_set(chip, MV88E6XXX_G2_ATU_STATS_MODE_ALL,
+					 bin);
+	if (err) {
+		dev_err(chip->dev, "failed to set ATU stats kind/bin\n");
+		goto unlock;
+	}
+
+	err = mv88e6xxx_g1_atu_get_next(chip, 0);
+	if (err) {
+		dev_err(chip->dev, "failed to perform ATU get next\n");
+		goto unlock;
+	}
+
+	err = mv88e6xxx_g2_atu_stats_get(chip, &occupancy);
+	if (err) {
+		dev_err(chip->dev, "failed to get ATU stats\n");
+		goto unlock;
+	}
+
+	occupancy &= MV88E6XXX_G2_ATU_STATS_MASK;
+
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+
+	return occupancy;
+}
+
+static u64 mv88e6xxx_devlink_atu_bin_0_get(void *priv)
+{
+	struct mv88e6xxx_chip *chip = priv;
+
+	return mv88e6xxx_devlink_atu_bin_get(chip,
+					     MV88E6XXX_G2_ATU_STATS_BIN_0);
+}
+
+static u64 mv88e6xxx_devlink_atu_bin_1_get(void *priv)
+{
+	struct mv88e6xxx_chip *chip = priv;
+
+	return mv88e6xxx_devlink_atu_bin_get(chip,
+					     MV88E6XXX_G2_ATU_STATS_BIN_1);
+}
+
+static u64 mv88e6xxx_devlink_atu_bin_2_get(void *priv)
+{
+	struct mv88e6xxx_chip *chip = priv;
+
+	return mv88e6xxx_devlink_atu_bin_get(chip,
+					     MV88E6XXX_G2_ATU_STATS_BIN_2);
+}
+
+static u64 mv88e6xxx_devlink_atu_bin_3_get(void *priv)
+{
+	struct mv88e6xxx_chip *chip = priv;
+
+	return mv88e6xxx_devlink_atu_bin_get(chip,
+					     MV88E6XXX_G2_ATU_STATS_BIN_3);
+}
+
+static u64 mv88e6xxx_devlink_atu_get(void *priv)
+{
+	return mv88e6xxx_devlink_atu_bin_0_get(priv) +
+		mv88e6xxx_devlink_atu_bin_1_get(priv) +
+		mv88e6xxx_devlink_atu_bin_2_get(priv) +
+		mv88e6xxx_devlink_atu_bin_3_get(priv);
+}
+
+int mv88e6xxx_setup_devlink_resources(struct dsa_switch *ds)
+{
+	struct devlink_resource_size_params size_params;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	devlink_resource_size_params_init(&size_params,
+					  mv88e6xxx_num_macs(chip),
+					  mv88e6xxx_num_macs(chip),
+					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
+
+	err = dsa_devlink_resource_register(ds, "ATU",
+					    mv88e6xxx_num_macs(chip),
+					    MV88E6XXX_RESOURCE_ID_ATU,
+					    DEVLINK_RESOURCE_ID_PARENT_TOP,
+					    &size_params);
+	if (err)
+		goto out;
+
+	devlink_resource_size_params_init(&size_params,
+					  mv88e6xxx_num_macs(chip) / 4,
+					  mv88e6xxx_num_macs(chip) / 4,
+					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
+
+	err = dsa_devlink_resource_register(ds, "ATU_bin_0",
+					    mv88e6xxx_num_macs(chip) / 4,
+					    MV88E6XXX_RESOURCE_ID_ATU_BIN_0,
+					    MV88E6XXX_RESOURCE_ID_ATU,
+					    &size_params);
+	if (err)
+		goto out;
+
+	err = dsa_devlink_resource_register(ds, "ATU_bin_1",
+					    mv88e6xxx_num_macs(chip) / 4,
+					    MV88E6XXX_RESOURCE_ID_ATU_BIN_1,
+					    MV88E6XXX_RESOURCE_ID_ATU,
+					    &size_params);
+	if (err)
+		goto out;
+
+	err = dsa_devlink_resource_register(ds, "ATU_bin_2",
+					    mv88e6xxx_num_macs(chip) / 4,
+					    MV88E6XXX_RESOURCE_ID_ATU_BIN_2,
+					    MV88E6XXX_RESOURCE_ID_ATU,
+					    &size_params);
+	if (err)
+		goto out;
+
+	err = dsa_devlink_resource_register(ds, "ATU_bin_3",
+					    mv88e6xxx_num_macs(chip) / 4,
+					    MV88E6XXX_RESOURCE_ID_ATU_BIN_3,
+					    MV88E6XXX_RESOURCE_ID_ATU,
+					    &size_params);
+	if (err)
+		goto out;
+
+	dsa_devlink_resource_occ_get_register(ds,
+					      MV88E6XXX_RESOURCE_ID_ATU,
+					      mv88e6xxx_devlink_atu_get,
+					      chip);
+
+	dsa_devlink_resource_occ_get_register(ds,
+					      MV88E6XXX_RESOURCE_ID_ATU_BIN_0,
+					      mv88e6xxx_devlink_atu_bin_0_get,
+					      chip);
+
+	dsa_devlink_resource_occ_get_register(ds,
+					      MV88E6XXX_RESOURCE_ID_ATU_BIN_1,
+					      mv88e6xxx_devlink_atu_bin_1_get,
+					      chip);
+
+	dsa_devlink_resource_occ_get_register(ds,
+					      MV88E6XXX_RESOURCE_ID_ATU_BIN_2,
+					      mv88e6xxx_devlink_atu_bin_2_get,
+					      chip);
+
+	dsa_devlink_resource_occ_get_register(ds,
+					      MV88E6XXX_RESOURCE_ID_ATU_BIN_3,
+					      mv88e6xxx_devlink_atu_bin_3_get,
+					      chip);
+
+	return 0;
+
+out:
+	dsa_devlink_resources_unregister(ds);
+	return err;
+}
+
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.h b/drivers/net/dsa/mv88e6xxx/devlink.h
new file mode 100644
index 000000000000..f6254e049653
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/devlink.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/* Marvell 88E6xxx Switch devlink support. */
+
+#ifndef _MV88E6XXX_DEVLINK_H
+#define _MV88E6XXX_DEVLINK_H
+
+int mv88e6xxx_setup_devlink_params(struct dsa_switch *ds);
+void mv88e6xxx_teardown_devlink_params(struct dsa_switch *ds);
+int mv88e6xxx_setup_devlink_resources(struct dsa_switch *ds);
+int mv88e6xxx_devlink_param_get(struct dsa_switch *ds, u32 id,
+				struct devlink_param_gset_ctx *ctx);
+int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
+				struct devlink_param_gset_ctx *ctx);
+
+#endif /* _MV88E6XXX_DEVLINK_H */
-- 
2.28.0

