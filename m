Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE484CB312
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 03:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbfJDBfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 21:35:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60332 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbfJDBfo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 21:35:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/VRCnO9bPerhXPa31qQWj3HprlDU/6HcITp61N1Lsoo=; b=KwzqV6i2mTtlwZt2r125tycQ7G
        4fErNLqj4BrV95L2dUYFTt5sv11DvBZuR+lKu0ywdUo2tFFPCmg3blHRB1iF5qjMKfpHEAeARSLd1
        0ViM+cY/1yDROpCzr6UWFuFxcEkvhg2enFJEQjsNEEm13CQxM0Zl1fYEMknD28gAUSfY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGCVM-0007NQ-R2; Fri, 04 Oct 2019 03:35:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.
Date:   Fri,  4 Oct 2019 03:35:23 +0200
Message-Id: <20191004013523.28306-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191004013523.28306-1-andrew@lunn.ch>
References: <20191004013523.28306-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the marvell switches have bits controlling the hash algorithm
the ATU uses for MAC addresses. In some industrial settings, where all
the devices are from the same manufacture, and hence use the same OUI,
the default hashing algorithm is not optimal. Allow the other
algorithms to be selected via devlink.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c        | 136 +++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h        |   4 +
 drivers/net/dsa/mv88e6xxx/global1.h     |   3 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c |  30 ++++++
 4 files changed, 172 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6787d560e9e3..ebadcdba03df 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1370,6 +1370,22 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 	return mv88e6xxx_g1_atu_flush(chip, *fid, true);
 }
 
+static int mv88e6xxx_atu_get_hash(struct mv88e6xxx_chip *chip)
+{
+	if (chip->info->ops->atu_get_hash)
+		return chip->info->ops->atu_get_hash(chip);
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
 static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 					u16 vid_begin, u16 vid_end)
 {
@@ -2641,6 +2657,83 @@ static int mv88e6390_setup_errata(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_software_reset(chip);
 }
 
+enum mv88e6xxx_devlink_param_id {
+	MV88E6XXX_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH,
+};
+
+static int mv88e6xxx_devlink_param_get(struct dsa_switch *ds, u32 id,
+				       struct devlink_param_gset_ctx *ctx)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err = 0;
+	int hash;
+
+	mv88e6xxx_reg_lock(chip);
+
+	switch (id) {
+	case MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH:
+		hash = mv88e6xxx_atu_get_hash(chip);
+		if (hash < 0) {
+			err = hash;
+			break;
+		}
+
+		ctx->val.vu8 = hash;
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
+				       struct devlink_param_gset_ctx *ctx)
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
+static int mv88e6xxx_setup_devlink_params(struct dsa_switch *ds)
+{
+	return dsa_devlink_params_register(ds, mv88e6xxx_devlink_params,
+					   ARRAY_SIZE(mv88e6xxx_devlink_params));
+}
+
+static void mv88e6xxx_teardown_devlink_params(struct dsa_switch *ds)
+{
+	dsa_devlink_params_unregister(ds, mv88e6xxx_devlink_params,
+				      ARRAY_SIZE(mv88e6xxx_devlink_params));
+}
+
+static void mv88e6xxx_teardown(struct dsa_switch *ds)
+{
+	mv88e6xxx_teardown_devlink_params(ds);
+}
+
 static int mv88e6xxx_setup(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
@@ -2757,7 +2850,11 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 unlock:
 	mv88e6xxx_reg_unlock(chip);
 
-	return err;
+	/* Has to be called without holding the register lock, since
+	 * it takes the devlink lock, and we later take the locks in
+	 * the reverse order when getting/setting parameters.
+	 */
+	return mv88e6xxx_setup_devlink_params(ds);
 }
 
 static int mv88e6xxx_mdio_read(struct mii_bus *bus, int phy, int reg)
@@ -3117,6 +3214,8 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate = mv88e6185_phylink_validate,
@@ -3246,6 +3345,8 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6165_avb_ops,
@@ -3280,6 +3381,8 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6165_avb_ops,
@@ -3322,6 +3425,8 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate = mv88e6185_phylink_validate,
@@ -3366,6 +3471,8 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
@@ -3409,6 +3516,8 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate = mv88e6185_phylink_validate,
@@ -3453,6 +3562,8 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
@@ -3538,6 +3649,8 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -3587,6 +3700,8 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -3635,6 +3750,8 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -3686,6 +3803,8 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
@@ -3777,6 +3896,8 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -3963,6 +4084,8 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate = mv88e6185_phylink_validate,
@@ -4003,6 +4126,8 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,
@@ -4049,6 +4174,8 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
@@ -4105,6 +4232,8 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -4158,6 +4287,8 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -4933,6 +5064,7 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
 	.setup			= mv88e6xxx_setup,
+	.teardown		= mv88e6xxx_teardown,
 	.phylink_validate	= mv88e6xxx_validate,
 	.phylink_mac_link_state	= mv88e6xxx_link_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
@@ -4975,6 +5107,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_txtstamp		= mv88e6xxx_port_txtstamp,
 	.port_rxtstamp		= mv88e6xxx_port_rxtstamp,
 	.get_ts_info		= mv88e6xxx_get_ts_info,
+	.devlink_param_get	= mv88e6xxx_devlink_param_get,
+	.devlink_param_set	= mv88e6xxx_devlink_param_set,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e9b1a1ac9a8e..2d8042d38366 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -497,6 +497,10 @@ struct mv88e6xxx_ops {
 	int (*serdes_get_stats)(struct mv88e6xxx_chip *chip,  int port,
 				uint64_t *data);
 
+	/* Address Translation Unit operations */
+	int (*atu_get_hash)(struct mv88e6xxx_chip *chip);
+	int (*atu_set_hash)(struct mv88e6xxx_chip *chip, u8 hash);
+
 	/* VLAN Translation Unit operations */
 	int (*vtu_getnext)(struct mv88e6xxx_chip *chip,
 			   struct mv88e6xxx_vtu_entry *entry);
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 0870fcc8bfc8..a2a9e0a78dd7 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -109,6 +109,7 @@
 /* Offset 0x0A: ATU Control Register */
 #define MV88E6XXX_G1_ATU_CTL		0x0a
 #define MV88E6XXX_G1_ATU_CTL_LEARN2ALL	0x0008
+#define MV88E6161_G1_ATU_CTL_HASH_MASK	0x3
 
 /* Offset 0x0B: ATU Operation Register */
 #define MV88E6XXX_G1_ATU_OP				0x0b
@@ -318,6 +319,8 @@ int mv88e6xxx_g1_atu_remove(struct mv88e6xxx_chip *chip, u16 fid, int port,
 			    bool all);
 int mv88e6xxx_g1_atu_prob_irq_setup(struct mv88e6xxx_chip *chip);
 void mv88e6xxx_g1_atu_prob_irq_free(struct mv88e6xxx_chip *chip);
+int mv88e6165_g1_atu_get_hash(struct mv88e6xxx_chip *chip);
+int mv88e6165_g1_atu_set_hash(struct mv88e6xxx_chip *chip, u8 hash);
 
 int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			     struct mv88e6xxx_vtu_entry *entry);
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 792a96ef418f..11496612e915 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -73,6 +73,36 @@ int mv88e6xxx_g1_atu_set_age_time(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
+int mv88e6165_g1_atu_get_hash(struct mv88e6xxx_chip *chip)
+{
+	int err;
+	u16 val;
+
+	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_CTL, &val);
+	if (err)
+		return err;
+
+	return val & MV88E6161_G1_ATU_CTL_HASH_MASK;
+}
+
+int mv88e6165_g1_atu_set_hash(struct mv88e6xxx_chip *chip, u8 hash)
+{
+	int err;
+	u16 val;
+
+	if (hash & ~MV88E6161_G1_ATU_CTL_HASH_MASK)
+		return -EINVAL;
+
+	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_CTL, &val);
+	if (err)
+		return err;
+
+	val &= ~MV88E6161_G1_ATU_CTL_HASH_MASK;
+	val |= hash;
+
+	return mv88e6xxx_g1_write(chip, MV88E6XXX_G1_ATU_CTL, val);
+}
+
 /* Offset 0x0B: ATU Operation Register */
 
 static int mv88e6xxx_g1_atu_op_wait(struct mv88e6xxx_chip *chip)
-- 
2.23.0

