Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A50C4AE16C
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 19:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385494AbiBHStO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Feb 2022 13:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385490AbiBHStM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 13:49:12 -0500
X-Greylist: delayed 32609 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 10:49:10 PST
Received: from inet10.abb.com (inet10.abb.com [138.225.1.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00F5C0612C0
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 10:49:10 -0800 (PST)
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 2189jDDk027527;
        Tue, 8 Feb 2022 10:45:13 +0100
Received: from ch10641.keymile.net.net (ch10641.keymile.net [172.31.40.7])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id A444565A3CB3;
        Tue,  8 Feb 2022 10:45:13 +0100 (CET)
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     netdev@vger.kernel.org
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [v4] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude configurable
Date:   Tue,  8 Feb 2022 10:44:55 +0100
Message-Id: <20220208094455.28870-1-holger.brunck@hitachienergy.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface. This patch
allows to configure the output swing to a desired value in the
phy-handle of the port. The value which is peak to peak has to be
specified in microvolts. As the chips only supports eight dedicated
values we return EINVAL if the value in the DTS does not match one of
these values.

CC: Andrew Lunn <andrew@lunn.ch>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Marek Behún <kabel@kernel.org>
Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
---
v4: - adapted for new dt-binding
      https://www.spinics.net/lists/netdev/msg793918.html
 drivers/net/dsa/mv88e6xxx/chip.c   | 22 +++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h   |  4 ++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 48 ++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  5 ++++
 4 files changed, 79 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 58ca684..2363529 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2857,7 +2857,10 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
+	struct device_node *phy_handle = NULL;
 	struct dsa_switch *ds = chip->ds;
+	struct dsa_port *dp;
+	int tx_amp;
 	int err;
 	u16 reg;
 
@@ -3011,6 +3014,22 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 			return err;
 	}
 
+	if (chip->info->ops->serdes_set_tx_p2p_amplitude) {
+		dp = dsa_to_port(ds, port);
+		if (dp)
+			phy_handle =  of_parse_phandle(dp->dn, "phy-handle", 0);
+
+		if (phy_handle &&
+		    !of_property_read_u32(phy_handle,
+					  "tx-p2p-microvolt",
+					  &tx_amp)) {
+			err = mv88e6352_serdes_set_tx_p2p_amplitude(chip, port,
+								    tx_amp);
+			if (err)
+				return err;
+		}
+	}
+
 	/* Port based VLAN map: give each port the same default address
 	 * database, and allow bidirectional communication between the
 	 * CPU and DSA port(s), and the other ports.
@@ -4073,6 +4092,7 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch *ds,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_p2p_amplitude = mv88e6352_serdes_set_tx_p2p_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
@@ -4353,6 +4373,7 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch *ds,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_p2p_amplitude = mv88e6352_serdes_set_tx_p2p_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -4759,6 +4780,7 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch *ds,
 	.serdes_get_stats = mv88e6352_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_p2p_amplitude = mv88e6352_serdes_set_tx_p2p_amplitude,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 8271b8a..3d56712 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -586,6 +586,10 @@ struct mv88e6xxx_ops {
 	void (*serdes_get_regs)(struct mv88e6xxx_chip *chip, int port,
 				void *_p);
 
+	/* SERDES SGMII/Fiber Output Amplitude */
+	int (*serdes_set_tx_p2p_amplitude)(struct mv88e6xxx_chip *chip,
+					   int port, int val);
+
 	/* Address Translation Unit operations */
 	int (*atu_get_hash)(struct mv88e6xxx_chip *chip, u8 *hash);
 	int (*atu_set_hash)(struct mv88e6xxx_chip *chip, u8 hash);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 2b05ead..c09c528 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1310,6 +1310,54 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	}
 }
 
+struct mv88e6352_serdes_p2p_to_val {
+	int mv;
+	u16 regval;
+};
+
+static struct mv88e6352_serdes_p2p_to_val mv88e6352_serdes_p2p_to_val[] = {
+	/* Mapping of configurable mikrovolt values to the register value */
+	{ 14000, 0},
+	{ 112000, 1},
+	{ 210000, 2},
+	{ 308000, 3},
+	{ 406000, 4},
+	{ 504000, 5},
+	{ 602000, 6},
+	{ 700000, 7},
+};
+
+int mv88e6352_serdes_set_tx_p2p_amplitude(struct mv88e6xxx_chip *chip, int port,
+					  int val)
+{
+	bool found = false;
+	u16 reg;
+	int err;
+	int i;
+
+	if (!mv88e6352_port_has_serdes(chip, port))
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6352_serdes_p2p_to_val); ++i) {
+		if (mv88e6352_serdes_p2p_to_val[i].mv == val) {
+			reg = mv88e6352_serdes_p2p_to_val[i].regval;
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
index 8dd8ed2..5602d94 100644
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
 
+int mv88e6352_serdes_set_tx_p2p_amplitude(struct mv88e6xxx_chip *chip, int port,
+					  int val);
+
 /* Return the (first) SERDES lane address a port is using, -errno otherwise. */
 static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 					    int port)
-- 
1.8.3.1

