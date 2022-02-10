Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646C74B1490
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245346AbiBJRtC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Feb 2022 12:49:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245314AbiBJRtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:49:01 -0500
Received: from inet10.abb.com (spf.hitachienergy.com [138.225.1.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6830325CD
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:49:01 -0800 (PST)
Received: from gitsiv.ch.abb.com (gitsiv.keymile.net [10.41.156.251])
        by inet10.abb.com (8.14.7/8.14.7) with SMTP id 21AHmkmd030536;
        Thu, 10 Feb 2022 18:48:46 +0100
Received: from ch10641.keymile.net.net (ch10641.keymile.net [172.31.40.7])
        by gitsiv.ch.abb.com (Postfix) with ESMTP id F0C6165B93DC;
        Thu, 10 Feb 2022 18:48:45 +0100 (CET)
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [net-next 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude configurable
Date:   Thu, 10 Feb 2022 18:48:23 +0100
Message-Id: <20220210174823.15488-2-holger.brunck@hitachienergy.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220210174823.15488-1-holger.brunck@hitachienergy.com>
References: <20220210174823.15488-1-holger.brunck@hitachienergy.com>
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

Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 23 +++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h   |  4 ++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  5 +++++
 4 files changed, 70 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c54649c..4dd5cef 100644
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
@@ -4241,6 +4261,7 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch *ds,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_get_caps = mv88e6352_phylink_get_caps,
 };
@@ -4521,6 +4542,7 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch *ds,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -4927,6 +4949,7 @@ static int mv88e6xxx_set_eeprom(struct dsa_switch *ds,
 	.serdes_get_stats = mv88e6352_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.serdes_set_tx_amplitude = mv88e6352_serdes_set_tx_amplitude,
 	.phylink_get_caps = mv88e6352_phylink_get_caps,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 12aa637..30b92a2 100644
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
index 6a177bf..7b37d45 100644
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
index 8dd8ed2..29bb4e9 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -27,6 +27,8 @@
 #define MV88E6352_SERDES_INT_FIBRE_ENERGY	BIT(4)
 #define MV88E6352_SERDES_INT_STATUS	0x13
 
+#define MV88E6352_SERDES_SPEC_CTRL2	0x1a
+#define MV88E6352_SERDES_OUT_AMP_MASK		0x0007
 
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

