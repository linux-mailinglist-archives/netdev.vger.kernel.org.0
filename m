Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C15282BAE
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgJDQNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:13:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgJDQNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 12:13:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kP6dJ-0003ea-Ec; Sun, 04 Oct 2020 18:13:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 7/7] net: dsa: mv88e6xxx: Add per port devlink regions
Date:   Sun,  4 Oct 2020 18:12:57 +0200
Message-Id: <20201004161257.13945-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201004161257.13945-1-andrew@lunn.ch>
References: <20201004161257.13945-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a devlink region to return the per port registers.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/devlink.c | 109 +++++++++++++++++++++++++++-
 1 file changed, 105 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 81e1560db206..10cd1bfd81a0 100644
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
@@ -471,11 +507,59 @@ mv88e6xxx_teardown_devlink_regions_global(struct mv88e6xxx_chip *chip)
 		dsa_devlink_region_destroy(chip->regions[i]);
 }
 
-void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds)
+static void
+mv88e6xxx_teardown_devlink_regions_port(struct mv88e6xxx_chip *chip,
+					int port)
 {
-	struct mv88e6xxx_chip *chip = ds->priv;
+	dsa_devlink_region_destroy(chip->ports[port].region);
+}
 
-	mv88e6xxx_teardown_devlink_regions_global(chip);
+static int mv88e6xxx_setup_devlink_regions_port(struct dsa_switch *ds,
+						struct mv88e6xxx_chip *chip,
+						int port)
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
+static void
+mv88e6xxx_teardown_devlink_regions_ports(struct mv88e6xxx_chip *chip)
+{
+	int port;
+
+	for (port = 0; port < mv88e6xxx_num_ports(chip); port++)
+		mv88e6xxx_teardown_devlink_regions_port(chip, port);
+}
+
+static int mv88e6xxx_setup_devlink_regions_ports(struct dsa_switch *ds,
+						 struct mv88e6xxx_chip *chip)
+{
+	int port;
+	int err;
+
+	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
+		err = mv88e6xxx_setup_devlink_regions_port(ds, chip, port);
+		if (err)
+			goto out;
+	}
+
+	return 0;
+
+out:
+	while (port-- > 0)
+		mv88e6xxx_teardown_devlink_regions_port(chip, port);
+
+	return err;
 }
 
 static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
@@ -511,8 +595,25 @@ static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
 int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	err = mv88e6xxx_setup_devlink_regions_global(ds, chip);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_setup_devlink_regions_ports(ds, chip);
+	if (err)
+		mv88e6xxx_teardown_devlink_regions_global(chip);
 
-	return mv88e6xxx_setup_devlink_regions_global(ds, chip);
+	return err;
+}
+
+void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	mv88e6xxx_teardown_devlink_regions_ports(chip);
+	mv88e6xxx_teardown_devlink_regions_global(chip);
 }
 
 int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
-- 
2.28.0

