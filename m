Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7F4465F1E
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 09:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355998AbhLBIJa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Dec 2021 03:09:30 -0500
Received: from spf.hitachienergy.com ([138.225.1.74]:55612 "EHLO
        inet10.abb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355995AbhLBIJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 03:09:29 -0500
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 1B285gkD018465;
        Thu, 2 Dec 2021 09:05:42 +0100
Received: from ch10641.keymile.net.net (ch10641.keymile.net [172.31.40.7])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id AA0CD65A4DCF;
        Thu,  2 Dec 2021 09:05:42 +0100 (CET)
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     netdev@vger.kernel.org
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [v2 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output amplitude configurable
Date:   Thu,  2 Dec 2021 09:05:27 +0100
Message-Id: <20211202080527.18520-2-holger.brunck@hitachienergy.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211202080527.18520-1-holger.brunck@hitachienergy.com>
References: <20211202080527.18520-1-holger.brunck@hitachienergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface. This patch
allows to configure the output swing to a desired value in the
devicetree node of the port. As the chips only supports eight dedicated
values we return EINVAL if the value in the DTS does not match.

CC: Andrew Lunn <andrew@lunn.ch>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Marek Behún <kabel@kernel.org>
Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 17 +++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h   |  4 +++
 drivers/net/dsa/mv88e6xxx/serdes.c | 48 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  5 ++++
 4 files changed, 74 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f00cbf5753b9..b61db6d2c18d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2861,6 +2861,8 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
+	struct dsa_port *dp;
+	int out_amp;
 	int err;
 	u16 reg;
 
@@ -3014,6 +3016,18 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 			return err;
 	}
 
+	if (chip->info->ops->serdes_set_out_amplitude) {
+		dp = dsa_to_port(ds, port);
+		if (dp &&
+		    !of_property_read_u32(dp->dn, "serdes-output-amplitude-mv",
+					  &out_amp)) {
+			err = mv88e6352_serdes_set_out_amplitude(chip, port,
+								 out_amp);
+			if (err)
+				return err;
+		}
+	}
+
 	/* Port based VLAN map: give each port the same default address
 	 * database, and allow bidirectional communication between the
 	 * CPU and DSA port(s), and the other ports.
@@ -4076,6 +4090,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_out_amplitude = mv88e6352_serdes_set_out_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
@@ -4356,6 +4371,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_out_amplitude = mv88e6352_serdes_set_out_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -4762,6 +4778,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_get_stats = mv88e6352_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_out_amplitude = mv88e6352_serdes_set_out_amplitude,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 8271b8aa7b71..745f6c32dd15 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -586,6 +586,10 @@ struct mv88e6xxx_ops {
 	void (*serdes_get_regs)(struct mv88e6xxx_chip *chip, int port,
 				void *_p);
 
+	/* SERDES SGMII/Fiber Output Amplitude */
+	int (*serdes_set_out_amplitude)(struct mv88e6xxx_chip *chip, int port,
+					int val);
+
 	/* Address Translation Unit operations */
 	int (*atu_get_hash)(struct mv88e6xxx_chip *chip, u8 *hash);
 	int (*atu_set_hash)(struct mv88e6xxx_chip *chip, u8 hash);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 6ea003678798..9abe6fa07b3b 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1271,6 +1271,54 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	}
 }
 
+struct mv88e6352_serdes_amp_to_val {
+	int mv;
+	u16 regval;
+};
+
+static struct mv88e6352_serdes_amp_to_val mv88e6352_serdes_amp_to_val[] = {
+	/* Mapping of configurable millivolt values to the register value */
+	{ 14, 0},
+	{ 112, 1},
+	{ 210, 2},
+	{ 308, 3},
+	{ 406, 4},
+	{ 504, 5},
+	{ 602, 6},
+	{ 700, 7},
+};
+
+int mv88e6352_serdes_set_out_amplitude(struct mv88e6xxx_chip *chip, int port,
+				       int val)
+{
+	bool found = false;
+	u16 reg;
+	int err;
+	int i;
+
+	if (!mv88e6352_port_has_serdes(chip, port))
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6352_serdes_amp_to_val); ++i) {
+		if (mv88e6352_serdes_amp_to_val[i].mv == val) {
+			reg = mv88e6352_serdes_amp_to_val[i].regval;
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return -EINVAL;
+
+	err = mv88e6352_serdes_read(chip, MV88E6352_SERDES_SPEC_CTRL2, &reg);
+	if (err)
+		return err;
+
+	reg = (reg & MV88E6352_SERDES_OUT_AMP_MASK) | val;
+
+	return mv88e6352_serdes_write(chip, MV88E6352_SERDES_SPEC_CTRL2, reg);
+}
+
 static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
 {
 	u16 reg, pcs;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index cbb3ba30caea..4bc39d06060b 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -27,6 +27,8 @@
 #define MV88E6352_SERDES_INT_FIBRE_ENERGY	BIT(4)
 #define MV88E6352_SERDES_INT_STATUS	0x13
 
+#define MV88E6352_SERDES_SPEC_CTRL2	0x1a
+#define MV88E6352_SERDES_OUT_AMP_MASK		0xfffc
 
 #define MV88E6341_PORT5_LANE		0x15
 
@@ -172,6 +174,9 @@ void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
 void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 
+int mv88e6352_serdes_set_out_amplitude(struct mv88e6xxx_chip *chip, int port,
+				       int val);
+
 /* Return the (first) SERDES lane address a port is using, -errno otherwise. */
 static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 					    int port)
-- 
2.34.0

