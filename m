Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846194B08A8
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbiBJInf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Feb 2022 03:43:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbiBJInf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:43:35 -0500
Received: from inet10.abb.com (spf.hitachienergy.com [138.225.1.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB1118F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:43:34 -0800 (PST)
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 21A8hOp5007341;
        Thu, 10 Feb 2022 09:43:24 +0100
Received: from ch10641.keymile.net.net (ch10641.keymile.net [172.31.40.7])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id 0324D65B860B;
        Thu, 10 Feb 2022 09:43:23 +0100 (CET)
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     netdev@vger.kernel.org
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [v6] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude configurable
Date:   Thu, 10 Feb 2022 09:43:22 +0100
Message-Id: <20220210084322.15467-1-holger.brunck@hitachienergy.com>
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
changes for v6:
  - use function hook to call the implementation
  - drop p2p from function names
  - simplify error handling
changes for v5:
  - rebase on netdev-next
  - release phy_handle
  - fix register and mask handling
  - simplify mv88e6352_serdes_p2p_to_reg array
changes for v4:
  - adapted for new dt-binding
      https://www.spinics.net/lists/netdev/msg793918.html

 drivers/net/dsa/mv88e6xxx/chip.c   | 23 ++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h   |  4 ++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 38 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  5 ++++
 4 files changed, 70 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c54649c4c3a0..4dd5cef6328d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2987,7 +2987,10 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
+	struct device_node *phy_handle = NULL;
 	struct dsa_switch *ds = chip->ds;
+	struct dsa_port *dp;
+	int tx_amp;
 	int err;
 	u16 reg;
 
@@ -3178,6 +3181,23 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 			return err;
 	}
 
+	if (chip->info->ops->serdes_set_tx_amplitude) {
+		dp = dsa_to_port(ds, port);
+		if (dp)
+			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
+
+		if (phy_handle && !of_property_read_u32(phy_handle,
+							"tx-p2p-microvolt",
+							&tx_amp))
+			err = chip->info->ops->serdes_set_tx_amplitude(chip,
+								port, tx_amp);
+		if (phy_handle) {
+			of_node_put(phy_handle);
+			if (err)
+				return err;
+		}
+	}
+
 	/* Port based VLAN map: give each port the same default address
 	 * database, and allow bidirectional communication between the
 	 * CPU and DSA port(s), and the other ports.
@@ -4241,6 +4261,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_get_caps = mv88e6352_phylink_get_caps,
 };
@@ -4521,6 +4542,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -4927,6 +4949,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_get_stats = mv88e6352_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.phylink_get_caps = mv88e6352_phylink_get_caps,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 12aa637779f5..30b92a265613 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -588,6 +588,10 @@ struct mv88e6xxx_ops {
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
index 6a177bf654ee..7b37d45bc9fb 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1313,6 +1313,44 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	}
 }
 
+static const int mv88e6352_serdes_p2p_to_reg[] = {
+	/* Index of value in microvolts corresponds to the register value */
+	14000, 112000, 210000, 308000, 406000, 504000, 602000, 700000,
+};
+
+int mv88e6352_serdes_set_tx_amplitude(struct mv88e6xxx_chip *chip, int port,
+				      int val)
+{
+	bool found = false;
+	u16 ctrl, reg;
+	int err;
+	int i;
+
+	err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
+	if (err <= 0)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6352_serdes_p2p_to_reg); ++i) {
+		if (mv88e6352_serdes_p2p_to_reg[i] == val) {
+			reg = i;
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return -EINVAL;
+
+	err = mv88e6352_serdes_read(chip, MV88E6352_SERDES_SPEC_CTRL2, &ctrl);
+	if (err)
+		return err;
+
+	ctrl &= ~MV88E6352_SERDES_OUT_AMP_MASK;
+	ctrl |= reg;
+
+	return mv88e6352_serdes_write(chip, MV88E6352_SERDES_SPEC_CTRL2, ctrl);
+}
+
 static int mv88e6393x_serdes_power_lane(struct mv88e6xxx_chip *chip, int lane,
 					bool on)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 8dd8ed225b45..29bb4e91e2f6 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -27,6 +27,8 @@
 #define MV88E6352_SERDES_INT_FIBRE_ENERGY	BIT(4)
 #define MV88E6352_SERDES_INT_STATUS	0x13
 
+#define MV88E6352_SERDES_SPEC_CTRL2	0x1a
+#define MV88E6352_SERDES_OUT_AMP_MASK		0x0007
 
 #define MV88E6341_PORT5_LANE		0x15
 
@@ -176,6 +178,9 @@ void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
 void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 
+int mv88e6352_serdes_set_tx_amplitude(struct mv88e6xxx_chip *chip, int port,
+				      int val);
+
 /* Return the (first) SERDES lane address a port is using, -errno otherwise. */
 static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 					    int port)
-- 
2.34.0

