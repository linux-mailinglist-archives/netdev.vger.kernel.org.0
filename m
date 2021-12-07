Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402B646C355
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 20:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240852AbhLGTLc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Dec 2021 14:11:32 -0500
Received: from spf.hitachienergy.com ([138.225.1.74]:53656 "EHLO
        inet10.abb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231668AbhLGTLb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 14:11:31 -0500
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 1B7J7jgk023127;
        Tue, 7 Dec 2021 20:07:45 +0100
Received: from ch10641.keymile.net.net (ch10641.keymile.net [172.31.40.7])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id 5137E65A5AE5;
        Tue,  7 Dec 2021 20:07:45 +0100 (CET)
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     netdev@vger.kernel.org
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output amplitude configurable
Date:   Tue,  7 Dec 2021 20:07:30 +0100
Message-Id: <20211207190730.3076-2-holger.brunck@hitachienergy.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c   | 18 ++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h   |  4 ++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 48 ++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  5 ++++
 4 files changed, 75 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f00cbf5..1d337dd8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2861,6 +2861,8 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
+	struct dsa_port *dp;
+	int tx_amp;
 	int err;
 	u16 reg;
 
@@ -3014,6 +3016,19 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 			return err;
 	}
 
+	if (chip->info->ops->serdes_set_tx_amplitude) {
+		dp = dsa_to_port(ds, port);
+		if (dp &&
+		    !of_property_read_u32(dp->dn,
+					  "serdes-tx-amplitude-millivolt",
+					  &tx_amp)) {
+			err = mv88e6352_serdes_set_tx_amplitude(chip, port,
+								tx_amp);
+			if (err)
+				return err;
+		}
+	}
+
 	/* Port based VLAN map: give each port the same default address
 	 * database, and allow bidirectional communication between the
 	 * CPU and DSA port(s), and the other ports.
@@ -4076,6 +4091,7 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch *ds,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
@@ -4356,6 +4372,7 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch *ds,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -4762,6 +4779,7 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch *ds,
 	.serdes_get_stats = mv88e6352_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 8271b8a..ef5fc26 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -586,6 +586,10 @@ struct mv88e6xxx_ops {
 	void (*serdes_get_regs)(struct mv88e6xxx_chip *chip, int port,
 				void *_p);
 
+	/* SERDES SGMII/Fiber Output Amplitude */
+	int (*serdes_set_tx_amplitude)(struct mv88e6xxx_chip *chip, int port,
+				       int val);
+
 	/* Address Translation Unit operations */
 	int (*atu_get_hash)(struct mv88e6xxx_chip *chip, u8 *hash);
 	int (*atu_set_hash)(struct mv88e6xxx_chip *chip, u8 hash);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 5527301..448535c 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1307,6 +1307,54 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
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
+int mv88e6352_serdes_set_tx_amplitude(struct mv88e6xxx_chip *chip, int port,
+				      int val)
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
 static int mv88e6393x_serdes_power_lane(struct mv88e6xxx_chip *chip, int lane,
 					bool on)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 8dd8ed2..526139c 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -27,6 +27,8 @@
 #define MV88E6352_SERDES_INT_FIBRE_ENERGY	BIT(4)
 #define MV88E6352_SERDES_INT_STATUS	0x13
 
+#define MV88E6352_SERDES_SPEC_CTRL2	0x1a
+#define MV88E6352_SERDES_OUT_AMP_MASK		0xfffc
 
 #define MV88E6341_PORT5_LANE		0x15
 
@@ -176,6 +178,9 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
 void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 
+int mv88e6352_serdes_set_tx_amplitude(struct mv88e6xxx_chip *chip, int port,
+				      int val);
+
 /* Return the (first) SERDES lane address a port is using, -errno otherwise. */
 static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 					    int port)
-- 
1.8.3.1

