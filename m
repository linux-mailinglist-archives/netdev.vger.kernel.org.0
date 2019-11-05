Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DBBEF1B6
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387486AbfKEAOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:14:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48940 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387472AbfKEAOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 19:14:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mIo52y49qliZPdV4pzuWcTIFoeMqO2ywpfWA2dsqGzo=; b=vapp9oMVPyyZ6uxG4nmjlUrTde
        sChzf69kOz1/d+GxSf7MCVTcgry5fTmra2URfupqAorO1ZwVoKpsMHn4bJ838B27geIZtwH496ImD
        p2jV97QZvUflKDOFRdE7sIbb5LaGPox4VPymIe+B2u6QVXYzO4fa3nm6X+ftmY0A1td8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRmTD-0007IA-55; Tue, 05 Nov 2019 01:13:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>, jiri@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 5/5] net: dsa: mv88e6xxx: Add ATU occupancy via devlink resources
Date:   Tue,  5 Nov 2019 01:13:01 +0100
Message-Id: <20191105001301.27966-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105001301.27966-1-andrew@lunn.ch>
References: <20191105001301.27966-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ATU can report how many entries it contains. It does this per bin,
there being 4 bins in total. Export the ATU as a devlink resource, and
provide a method the needed callback to get the resource occupancy.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 190 ++++++++++++++++++++++++++++++-
 1 file changed, 186 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 3540ca2e3b6f..0dbe6c8b9dc0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2720,9 +2720,179 @@ static void mv88e6xxx_teardown_devlink_params(struct dsa_switch *ds)
 				      ARRAY_SIZE(mv88e6xxx_devlink_params));
 }
 
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
+static int mv88e6xxx_setup_devlink_resources(struct dsa_switch *ds)
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
 static void mv88e6xxx_teardown(struct dsa_switch *ds)
 {
 	mv88e6xxx_teardown_devlink_params(ds);
+	dsa_devlink_resources_unregister(ds);
 }
 
 static int mv88e6xxx_setup(struct dsa_switch *ds)
@@ -2841,11 +3011,23 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 unlock:
 	mv88e6xxx_reg_unlock(chip);
 
-	/* Has to be called without holding the register lock, since
-	 * it takes the devlink lock, and we later take the locks in
-	 * the reverse order when getting/setting parameters.
+	if (err)
+		return err;
+
+	/* Have to be called without holding the register lock, since
+	 * they take the devlink lock, and we later take the locks in
+	 * the reverse order when getting/setting parameters or
+	 * resource occupancy.
 	 */
-	return mv88e6xxx_setup_devlink_params(ds);
+	err = mv88e6xxx_setup_devlink_resources(ds);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_setup_devlink_params(ds);
+	if (err)
+		dsa_devlink_resources_unregister(ds);
+
+	return err;
 }
 
 static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
-- 
2.23.0

