Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B88DB75C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503431AbfJQTVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:21:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfJQTVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 15:21:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mG6OILOSrlMaMazpIFACAKhtWN4ILzq0VyKfRD6HLmQ=; b=iWjdzb0V21vE/AF5n1R06aIV9L
        abhNXcoJzUuw9iNeh+bqjQ/fck1y3CA38S2f0UqDiKlqnxPS2QlSaajn+ulKnAr8jAq2cW3XB3n0i
        Ry9yN85IPo1IJAkzfqkDvkD9sBuB8uXhdT3HS/lD8nbbE3Oai0YRvhiSSN8rFkNZ9lJA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLBKd-0006CF-7h; Thu, 17 Oct 2019 21:21:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 2/2] net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.
Date:   Thu, 17 Oct 2019 21:20:55 +0200
Message-Id: <20191017192055.23770-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191017192055.23770-1-andrew@lunn.ch>
References: <20191017192055.23770-1-andrew@lunn.ch>
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
 .../networking/devlink-params-mv88e6xxx.txt   |   7 +
 MAINTAINERS                                   |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 131 +++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |   4 +
 drivers/net/dsa/mv88e6xxx/global1.h           |   3 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       |  32 +++++
 6 files changed, 177 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/devlink-params-mv88e6xxx.txt

diff --git a/Documentation/networking/devlink-params-mv88e6xxx.txt b/Documentation/networking/devlink-params-mv88e6xxx.txt
new file mode 100644
index 000000000000..9a515b438688
--- /dev/null
+++ b/Documentation/networking/devlink-params-mv88e6xxx.txt
@@ -0,0 +1,7 @@
+ATU_hash		[DEVICE, DRIVER-SPECIFIC]
+			Select one of four possible hashing algorithms for
+			MAC addresses in the Address Translation Unity.
+			A value of 3 seems to work better than the default of
+			1 when many MAC addresses have the same OUI.
+			Configuration mode: runtime
+			Type: u8. 0-3 valid.
diff --git a/MAINTAINERS b/MAINTAINERS
index b431e6d5f43f..ab1f6dd876a9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9740,6 +9740,7 @@ S:	Maintained
 F:	drivers/net/dsa/mv88e6xxx/
 F:	include/linux/platform_data/mv88e6xxx.h
 F:	Documentation/devicetree/bindings/net/dsa/marvell.txt
+F:	Documentation/networking/devlink-params-mv88e6xxx.txt
 
 MARVELL ARMADA DRM SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6787d560e9e3..404f6fc97e4c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1370,6 +1370,22 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 	return mv88e6xxx_g1_atu_flush(chip, *fid, true);
 }
 
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
 static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 					u16 vid_begin, u16 vid_end)
 {
@@ -2641,6 +2657,78 @@ static int mv88e6390_setup_errata(struct mv88e6xxx_chip *chip)
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
@@ -2757,7 +2845,11 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
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
@@ -3117,6 +3209,8 @@ static const struct mv88e6xxx_ops mv88e6123_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate = mv88e6185_phylink_validate,
@@ -3246,6 +3340,8 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6165_avb_ops,
@@ -3280,6 +3376,8 @@ static const struct mv88e6xxx_ops mv88e6165_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6165_avb_ops,
@@ -3322,6 +3420,8 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate = mv88e6185_phylink_validate,
@@ -3366,6 +3466,8 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
@@ -3409,6 +3511,8 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate = mv88e6185_phylink_validate,
@@ -3453,6 +3557,8 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
@@ -3538,6 +3644,8 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -3587,6 +3695,8 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -3635,6 +3745,8 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -3686,6 +3798,8 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
@@ -3777,6 +3891,8 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -3963,6 +4079,8 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.phylink_validate = mv88e6185_phylink_validate,
@@ -4003,6 +4121,8 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.avb_ops = &mv88e6352_avb_ops,
@@ -4049,6 +4169,8 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6352_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
@@ -4105,6 +4227,8 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -4158,6 +4282,8 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6390_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -4933,6 +5059,7 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
 	.setup			= mv88e6xxx_setup,
+	.teardown		= mv88e6xxx_teardown,
 	.phylink_validate	= mv88e6xxx_validate,
 	.phylink_mac_link_state	= mv88e6xxx_link_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
@@ -4975,6 +5102,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_txtstamp		= mv88e6xxx_port_txtstamp,
 	.port_rxtstamp		= mv88e6xxx_port_rxtstamp,
 	.get_ts_info		= mv88e6xxx_get_ts_info,
+	.devlink_param_get	= mv88e6xxx_devlink_param_get,
+	.devlink_param_set	= mv88e6xxx_devlink_param_set,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e9b1a1ac9a8e..52f7726cc099 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -497,6 +497,10 @@ struct mv88e6xxx_ops {
 	int (*serdes_get_stats)(struct mv88e6xxx_chip *chip,  int port,
 				uint64_t *data);
 
+	/* Address Translation Unit operations */
+	int (*atu_get_hash)(struct mv88e6xxx_chip *chip, u8 *hash);
+	int (*atu_set_hash)(struct mv88e6xxx_chip *chip, u8 hash);
+
 	/* VLAN Translation Unit operations */
 	int (*vtu_getnext)(struct mv88e6xxx_chip *chip,
 			   struct mv88e6xxx_vtu_entry *entry);
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 0870fcc8bfc8..9f2af711293b 100644
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
+int mv88e6165_g1_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash);
+int mv88e6165_g1_atu_set_hash(struct mv88e6xxx_chip *chip, u8 hash);
 
 int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			     struct mv88e6xxx_vtu_entry *entry);
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 792a96ef418f..d8a03bbba83c 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -73,6 +73,38 @@ int mv88e6xxx_g1_atu_set_age_time(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
+int mv88e6165_g1_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash)
+{
+	int err;
+	u16 val;
+
+	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_CTL, &val);
+	if (err)
+		return err;
+
+	*hash = val & MV88E6161_G1_ATU_CTL_HASH_MASK;
+
+	return 0;
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

