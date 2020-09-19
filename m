Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18414270E9C
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 16:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgISOn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 10:43:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45184 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgISOn5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 10:43:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJe5h-00FNaY-7N; Sat, 19 Sep 2020 16:43:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Chris Healy <cphealy@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next RFC v1 4/4] net: dsa: mv88e6xxx: Add per port devlink regions
Date:   Sat, 19 Sep 2020 16:43:32 +0200
Message-Id: <20200919144332.3665538-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919144332.3665538-1-andrew@lunn.ch>
References: <20200919144332.3665538-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a devlink region to return the per port registers.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  8 ++++
 drivers/net/dsa/mv88e6xxx/devlink.c | 61 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/devlink.h |  6 ++-
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9417412e5fce..3d2d813f7a79 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2741,10 +2741,16 @@ static int mv88e6xxx_port_enable(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	err = mv88e6xxx_setup_devlink_regions_port(ds, chip, port);
+	if (err)
+		return err;
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_serdes_power(chip, port, true);
 	mv88e6xxx_reg_unlock(chip);
 
+	if (err)
+		mv88e6xxx_teardown_devlink_regions_port(chip, port);
 	return err;
 }
 
@@ -2752,6 +2758,8 @@ static void mv88e6xxx_port_disable(struct dsa_switch *ds, int port)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
+	mv88e6xxx_teardown_devlink_regions_port(chip, port);
+
 	mv88e6xxx_reg_lock(chip);
 	if (mv88e6xxx_serdes_power(chip, port, false))
 		dev_err(chip->dev, "failed to power off SERDES\n");
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 81e1560db206..dc8a244aa154 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -415,6 +415,36 @@ static int mv88e6xxx_region_atu_snapshot(struct devlink *dl,
 	return err;
 }
 
+static int mv88e6xxx_region_port_snapshot(struct devlink_port *devlink_port,
+					  const struct devlink_port_region_ops *ops,
+					  struct netlink_ext_ack *extack,
+					  u8 **data)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(devlink_port);
+	int port = dsa_devlink_port_to_port(devlink_port);
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
+		err = mv88e6xxx_port_read(chip, port, i, &registers[i]);
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
 static struct mv88e6xxx_region_priv mv88e6xxx_region_global1_priv = {
 	.id = MV88E6XXX_REGION_GLOBAL1,
 };
@@ -443,6 +473,12 @@ static struct devlink_region_ops mv88e6xxx_region_atu_ops = {
 	.destructor = kfree,
 };
 
+static const struct devlink_port_region_ops mv88e6xxx_region_port_ops = {
+	.name = "port",
+	.snapshot = mv88e6xxx_region_port_snapshot,
+	.destructor = kfree,
+};
+
 struct mv88e6xxx_region {
 	struct devlink_region_ops *ops;
 	u64 size;
@@ -478,6 +514,31 @@ void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds)
 	mv88e6xxx_teardown_devlink_regions_global(chip);
 }
 
+int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds,
+					 struct mv88e6xxx_chip *chip,
+					 int port)
+{
+	struct devlink_region *region;
+
+	region = dsa_devlink_port_region_create(ds,
+						port,
+						&mv88e6xxx_region_port_ops, 1,
+						32 * sizeof(u16));
+	if (IS_ERR(region))
+		return PTR_ERR(region);
+
+	chip->ports[port].region = region;
+
+	return 0;
+}
+
+void mv88e6xxx_teardown_devlink_regions_port(struct mv88e6xxx_chip *chip,
+					     int port)
+{
+	if (chip->ports[port].region)
+		dsa_devlink_region_destroy(chip->ports[port].region);
+}
+
 static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
 						  struct mv88e6xxx_chip *chip)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.h b/drivers/net/dsa/mv88e6xxx/devlink.h
index 3d72db3dcf95..9302f0ee550d 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.h
+++ b/drivers/net/dsa/mv88e6xxx/devlink.h
@@ -14,7 +14,11 @@ int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
 				struct devlink_param_gset_ctx *ctx);
 int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds);
 void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds);
-
+int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds,
+					 struct mv88e6xxx_chip *chip,
+					 int port);
+void mv88e6xxx_teardown_devlink_regions_port(struct mv88e6xxx_chip *chip,
+					     int port);
 int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
 			       struct devlink_info_req *req,
 			       struct netlink_ext_ack *extack);
-- 
2.28.0

