Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D913545F562
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhKZTtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:49:05 -0500
Received: from spf.hitachienergy.com ([138.225.1.74]:33984 "EHLO
        inet10.abb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236248AbhKZTrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 14:47:04 -0500
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 1AQFh7ph005537;
        Fri, 26 Nov 2021 16:43:07 +0100
Received: from ch10641.keymile.net.net (ch10641.keymile.net [172.31.40.7])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id 785C065A4214;
        Fri, 26 Nov 2021 16:43:07 +0100 (CET)
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     netdev@vger.kernel.org
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output amplitude configurable
Date:   Fri, 26 Nov 2021 16:42:49 +0100
Message-Id: <20211126154249.2958-2-holger.brunck@hitachienergy.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface. This pat=
ch
allows to configure the output swing to a desired value in the
devicetree node of the switch.

CC: Andrew Lunn <andrew@lunn.ch>
CC: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 14 ++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h   |  3 +++
 drivers/net/dsa/mv88e6xxx/serdes.c | 14 ++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  4 ++++
 4 files changed, 35 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index f00cbf5753b9..5182128959a0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3173,9 +3173,11 @@ static void mv88e6xxx_teardown(struct dsa_switch *=
ds)
 static int mv88e6xxx_setup(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip =3D ds->priv;
+	struct device_node *np =3D chip->dev->of_node;
 	u8 cmode;
 	int err;
 	int i;
+	int out_amp;
=20
 	chip->ds =3D ds;
 	ds->slave_mii_bus =3D mv88e6xxx_default_mdio_bus(chip);
@@ -3292,6 +3294,15 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	if (err)
 		goto unlock;
=20
+	if (chip->info->ops->serdes_set_out_amplitude && np) {
+		if (!of_property_read_u32(np, "serdes-output-amplitude",
+					  &out_amp)) {
+			err =3D mv88e6352_serdes_set_out_amplitude(chip, out_amp);
+			if (err)
+				goto unlock;
+		}
+	}
+
 unlock:
 	mv88e6xxx_reg_unlock(chip);
=20
@@ -4076,6 +4087,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops =3D=
 {
 	.serdes_irq_status =3D mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len =3D mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs =3D mv88e6352_serdes_get_regs,
+	.serdes_set_out_amplitude =3D mv88e6352_serdes_set_out_amplitude,
 	.gpio_ops =3D &mv88e6352_gpio_ops,
 	.phylink_validate =3D mv88e6352_phylink_validate,
 };
@@ -4356,6 +4368,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops =3D=
 {
 	.serdes_irq_status =3D mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len =3D mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs =3D mv88e6352_serdes_get_regs,
+	.serdes_set_out_amplitude =3D mv88e6352_serdes_set_out_amplitude,
 	.gpio_ops =3D &mv88e6352_gpio_ops,
 	.avb_ops =3D &mv88e6352_avb_ops,
 	.ptp_ops =3D &mv88e6352_ptp_ops,
@@ -4762,6 +4775,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops =3D=
 {
 	.serdes_get_stats =3D mv88e6352_serdes_get_stats,
 	.serdes_get_regs_len =3D mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs =3D mv88e6352_serdes_get_regs,
+	.serdes_set_out_amplitude =3D mv88e6352_serdes_set_out_amplitude,
 	.phylink_validate =3D mv88e6352_phylink_validate,
 };
=20
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx=
/chip.h
index 8271b8aa7b71..d931039ee995 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -586,6 +586,9 @@ struct mv88e6xxx_ops {
 	void (*serdes_get_regs)(struct mv88e6xxx_chip *chip, int port,
 				void *_p);
=20
+	/* SERDES SGMII/Fiber Output Amplitude */
+	int (*serdes_set_out_amplitude)(struct mv88e6xxx_chip *chip, int val);
+
 	/* Address Translation Unit operations */
 	int (*atu_get_hash)(struct mv88e6xxx_chip *chip, u8 *hash);
 	int (*atu_set_hash)(struct mv88e6xxx_chip *chip, u8 hash);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6x=
xx/serdes.c
index 6ea003678798..835137595de5 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1271,6 +1271,20 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_ch=
ip *chip, int port, void *_p)
 	}
 }
=20
+int mv88e6352_serdes_set_out_amplitude(struct mv88e6xxx_chip *chip, int =
val)
+{
+	u16 reg;
+	int err;
+
+	err =3D mv88e6352_serdes_read(chip, MV88E6352_SERDES_SPEC_CTRL2, &reg);
+	if (err)
+		return err;
+
+	reg =3D (reg & MV88E6352_SERDES_OUT_AMP_MASK) | val;
+
+	return mv88e6352_serdes_write(chip, MV88E6352_SERDES_SPEC_CTRL2, reg);
+}
+
 static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, in=
t lane)
 {
 	u16 reg, pcs;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6x=
xx/serdes.h
index cbb3ba30caea..71dddc65b642 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -27,6 +27,8 @@
 #define MV88E6352_SERDES_INT_FIBRE_ENERGY	BIT(4)
 #define MV88E6352_SERDES_INT_STATUS	0x13
=20
+#define MV88E6352_SERDES_SPEC_CTRL2	0x1a
+#define MV88E6352_SERDES_OUT_AMP_MASK		0xfffc
=20
 #define MV88E6341_PORT5_LANE		0x15
=20
@@ -172,6 +174,8 @@ void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip =
*chip, int port, void *_p);
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)=
;
 void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, vo=
id *_p);
=20
+int mv88e6352_serdes_set_out_amplitude(struct mv88e6xxx_chip *chip, int =
val);
+
 /* Return the (first) SERDES lane address a port is using, -errno otherw=
ise. */
 static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 					    int port)
--=20
2.34.0

