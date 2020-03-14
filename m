Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9CA1856C9
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgCOB35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:29:57 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbgCOB3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=E+oRIX6+3T/I17avmLhYWPWQvrTJh8YRChnpaQo4qWc=; b=1Jsairvsx4J4JMvItHTLA6mEo+
        j/Rn4uWXILvoqO6BbHlxhjuIz+n8Kp1p7V2G9P1w/jvfuFV0ZRt5QC0azWTriZ4nFRIyBEzYqlOp8
        rUziR+EN/+979/7QKNA65BwLaEbi9F5QqtImp1t6F31XBiJn/W3vxkXD2sVE3fbDCiklc1SdvnMq2
        7K4bQBJUjTLiyVnGZgcN0sRNJS7oVJPcjmo4wLdX1JdK4bNz4ghnu/IGKJQDjfMM8QrvH8DIoI0jR
        L/4RYOupxUjgFraQte4r8y3bMcjRY7Zq9GncVXOJJHz+H/uNNyIsO+AepQVHDHkNfdgm0gu4zuNoW
        AGjV0QOw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:41712 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3pY-0006Bm-Mv; Sat, 14 Mar 2020 10:15:44 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3pX-0006Db-Hi; Sat, 14 Mar 2020 10:15:43 +0000
In-Reply-To: <20200314101431.GF25745@shell.armlinux.org.uk>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 4/8] net: dsa: mv88e6xxx: extend phylink to Serdes
 PHYs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jD3pX-0006Db-Hi@rmk-PC.armlinux.org.uk>
Date:   Sat, 14 Mar 2020 10:15:43 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the mv88e6xxx phylink implementation down to Serdes PHYs, which
handle the PCS layer of such links.

- Implement phylink PCS link state reading, so that we can provide
  ethtool with the linkmodes and link speed in the expected manner.
  Note: this will only be called for in-band negotiation, which is
  only supported by the serdes interfaces.
- Implement phylink PCS configuration, so that the in-band AN and
  advertisement can be configured.
- Implement phylink PCS negotiation restart, so that the in-band AN
  can be restarted.
- Implement phylink PCS link up, so that when operating out-of-band,
  the Serdes can be configured for the appropriate fixed speed mode.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 174 +++++++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h   |  14 +-
 drivers/net/dsa/mv88e6xxx/serdes.c | 342 ++++++++++++++++++++++++-----
 drivers/net/dsa/mv88e6xxx/serdes.h |  24 ++
 4 files changed, 480 insertions(+), 74 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 14a716779bc3..548a0c3edfac 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -419,9 +419,9 @@ static int mv88e6xxx_port_config_interface(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
-int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
-			     int speed, int duplex, int pause,
-			     phy_interface_t mode)
+static int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port,
+				    int link, int speed, int duplex, int pause,
+				    phy_interface_t mode)
 {
 	struct phylink_link_state state;
 	int err;
@@ -488,6 +488,81 @@ static int mv88e6xxx_phy_is_internal(struct dsa_switch *ds, int port)
 	return port < chip->info->num_internal_phys;
 }
 
+static int mv88e6xxx_serdes_pcs_get_state(struct dsa_switch *ds, int port,
+					  struct phylink_link_state *state)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	u8 lane;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (lane && chip->info->ops->serdes_pcs_get_state)
+		err = chip->info->ops->serdes_pcs_get_state(chip, port, lane,
+							    state);
+	else
+		err = -EOPNOTSUPP;
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static int mv88e6xxx_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
+				       unsigned int mode,
+				       phy_interface_t interface,
+				       const unsigned long *advertise)
+{
+	const struct mv88e6xxx_ops *ops = chip->info->ops;
+	u8 lane;
+
+	if (ops->serdes_pcs_config) {
+		lane = mv88e6xxx_serdes_get_lane(chip, port);
+		if (lane)
+			return ops->serdes_pcs_config(chip, port, lane, mode,
+						      interface, advertise);
+	}
+
+	return 0;
+}
+
+static void mv88e6xxx_serdes_pcs_an_restart(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	const struct mv88e6xxx_ops *ops;
+	int err = 0;
+	u8 lane;
+
+	ops = chip->info->ops;
+
+	if (ops->serdes_pcs_an_restart) {
+		mv88e6xxx_reg_lock(chip);
+		lane = mv88e6xxx_serdes_get_lane(chip, port);
+		if (lane)
+			err = ops->serdes_pcs_an_restart(chip, port, lane);
+		mv88e6xxx_reg_unlock(chip);
+
+		if (err)
+			dev_err(ds->dev, "p%d: failed to restart AN\n", port);
+	}
+}
+
+static int mv88e6xxx_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
+					unsigned int mode,
+					int speed, int duplex)
+{
+	const struct mv88e6xxx_ops *ops = chip->info->ops;
+	u8 lane;
+
+	if (!phylink_autoneg_inband(mode) && ops->serdes_pcs_link_up) {
+		lane = mv88e6xxx_serdes_get_lane(chip, port);
+		if (lane)
+			return ops->serdes_pcs_link_up(chip, port, lane,
+						       speed, duplex);
+	}
+
+	return 0;
+}
+
 static void mv88e6065_phylink_validate(struct mv88e6xxx_chip *chip, int port,
 				       unsigned long *mask,
 				       struct phylink_link_state *state)
@@ -592,22 +667,6 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
 	phylink_helper_basex_speed(state);
 }
 
-static int mv88e6xxx_link_state(struct dsa_switch *ds, int port,
-				struct phylink_link_state *state)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	mv88e6xxx_reg_lock(chip);
-	if (chip->info->ops->port_link_state)
-		err = chip->info->ops->port_link_state(chip, port, state);
-	else
-		err = -EOPNOTSUPP;
-	mv88e6xxx_reg_unlock(chip);
-
-	return err;
-}
-
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 				 unsigned int mode,
 				 const struct phylink_link_state *state)
@@ -629,6 +688,18 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 	 * gets in the way.
 	 */
 	err = mv88e6xxx_port_config_interface(chip, port, state->interface);
+	if (err && err != -EOPNOTSUPP)
+		goto err_unlock;
+
+	err = mv88e6xxx_serdes_pcs_config(chip, port, mode, state->interface,
+					  state->advertising);
+	/* FIXME: we should restart negotiation if something changed - which
+	 * is something we get if we convert to using phylinks PCS operations.
+	 */
+	if (err > 0)
+		err = 0;
+
+err_unlock:
 	mv88e6xxx_reg_unlock(chip);
 
 	if (err && err != -EOPNOTSUPP)
@@ -683,9 +754,14 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 		/* FIXME: for an automedia port, should we force the link
 		 * down here - what if the link comes up due to "other" media
 		 * while we're bringing the port up, how is the exclusivity
-		 * handled in the Marvell hardware? E.g. port 4 on 88E6532
+		 * handled in the Marvell hardware? E.g. port 2 on 88E6390
 		 * shared between internal PHY and Serdes.
 		 */
+		err = mv88e6xxx_serdes_pcs_link_up(chip, port, mode, speed,
+						   duplex);
+		if (err)
+			goto error;
+
 		if (ops->port_set_speed) {
 			err = ops->port_set_speed(chip, port, speed);
 			if (err && err != -EOPNOTSUPP)
@@ -3557,6 +3633,11 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
+	/* Check status register pause & lpa register */
+	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
@@ -3729,6 +3810,10 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
+	.serdes_pcs_get_state = mv88e6352_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6352_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6352_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6352_serdes_pcs_link_up,
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
@@ -3822,6 +3907,10 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
+	.serdes_pcs_get_state = mv88e6352_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6352_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6352_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6352_serdes_pcs_link_up,
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
@@ -3912,6 +4001,11 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
+	/* Check status register pause & lpa register */
+	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
@@ -3968,6 +4062,11 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
+	/* Check status register pause & lpa register */
+	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
@@ -4023,6 +4122,11 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
+	/* Check status register pause & lpa register */
+	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
@@ -4080,6 +4184,10 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
+	.serdes_pcs_get_state = mv88e6352_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6352_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6352_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6352_serdes_pcs_link_up,
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
@@ -4176,6 +4284,11 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
+	/* Check status register pause & lpa register */
+	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
@@ -4319,6 +4432,11 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6341_serdes_get_lane,
+	/* Check status register pause & lpa register */
+	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
@@ -4458,6 +4576,10 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
+	.serdes_pcs_get_state = mv88e6352_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6352_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6352_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6352_serdes_pcs_link_up,
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
@@ -4519,6 +4641,11 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390_serdes_get_lane,
+	/* Check status register pause & lpa register */
+	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
@@ -4579,6 +4706,10 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.vtu_loadpurge = mv88e6390_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
 	.serdes_get_lane = mv88e6390x_serdes_get_lane,
+	.serdes_pcs_get_state = mv88e6390_serdes_pcs_get_state,
+	.serdes_pcs_config = mv88e6390_serdes_pcs_config,
+	.serdes_pcs_an_restart = mv88e6390_serdes_pcs_an_restart,
+	.serdes_pcs_link_up = mv88e6390_serdes_pcs_link_up,
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
@@ -5457,8 +5588,9 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.setup			= mv88e6xxx_setup,
 	.teardown		= mv88e6xxx_teardown,
 	.phylink_validate	= mv88e6xxx_validate,
-	.phylink_mac_link_state	= mv88e6xxx_link_state,
+	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
+	.phylink_mac_an_restart	= mv88e6xxx_serdes_pcs_an_restart,
 	.phylink_mac_link_down	= mv88e6xxx_mac_link_down,
 	.phylink_mac_link_up	= mv88e6xxx_mac_link_up,
 	.get_strings		= mv88e6xxx_get_strings,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 851686b45414..93cc8b6a2bef 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -502,6 +502,17 @@ struct mv88e6xxx_ops {
 	/* SERDES lane mapping */
 	u8 (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port);
 
+	int (*serdes_pcs_get_state)(struct mv88e6xxx_chip *chip, int port,
+				    u8 lane, struct phylink_link_state *state);
+	int (*serdes_pcs_config)(struct mv88e6xxx_chip *chip, int port,
+				 u8 lane, unsigned int mode,
+				 phy_interface_t interface,
+				 const unsigned long *advertise);
+	int (*serdes_pcs_an_restart)(struct mv88e6xxx_chip *chip, int port,
+				     u8 lane);
+	int (*serdes_pcs_link_up)(struct mv88e6xxx_chip *chip, int port,
+				  u8 lane, int speed, int duplex);
+
 	/* SERDES interrupt handling */
 	unsigned int (*serdes_irq_mapping)(struct mv88e6xxx_chip *chip,
 					   int port);
@@ -669,9 +680,6 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 			u16 mask, u16 val);
 int mv88e6xxx_wait_bit(struct mv88e6xxx_chip *chip, int addr, int reg,
 		       int bit, int val);
-int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port, int link,
-			     int speed, int duplex, int pause,
-			     phy_interface_t mode);
 struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip);
 
 static inline void mv88e6xxx_reg_lock(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 37d7fd132f4e..6c7b031e614b 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -49,6 +49,52 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_phy_write(chip, lane, reg_c45, val);
 }
 
+static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
+					  u16 status, u16 lpa,
+					  struct phylink_link_state *state)
+{
+	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
+		state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+		state->duplex = status &
+				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
+			                         DUPLEX_FULL : DUPLEX_HALF;
+
+		if (status & MV88E6390_SGMII_PHY_STATUS_TX_PAUSE)
+			state->pause |= MLO_PAUSE_TX;
+		if (status & MV88E6390_SGMII_PHY_STATUS_RX_PAUSE)
+			state->pause |= MLO_PAUSE_RX;
+
+		switch (status & MV88E6390_SGMII_PHY_STATUS_SPEED_MASK) {
+		case MV88E6390_SGMII_PHY_STATUS_SPEED_1000:
+			if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
+				state->speed = SPEED_2500;
+			else
+				state->speed = SPEED_1000;
+			break;
+		case MV88E6390_SGMII_PHY_STATUS_SPEED_100:
+			state->speed = SPEED_100;
+			break;
+		case MV88E6390_SGMII_PHY_STATUS_SPEED_10:
+			state->speed = SPEED_10;
+			break;
+		default:
+			dev_err(chip->dev, "invalid PHY speed\n");
+			return -EINVAL;
+		}
+	} else {
+		state->link = false;
+	}
+
+	if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
+		mii_lpa_mod_linkmode_x(state->lp_advertising, lpa,
+				       ETHTOOL_LINK_MODE_2500baseX_Full_BIT);
+	else if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
+		mii_lpa_mod_linkmode_x(state->lp_advertising, lpa,
+				       ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
+
+	return 0;
+}
+
 int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 			   bool up)
 {
@@ -70,6 +116,120 @@ int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 	return err;
 }
 
+int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
+				u8 lane, unsigned int mode,
+				phy_interface_t interface,
+				const unsigned long *advertise)
+{
+	u16 adv, bmcr, val;
+	bool changed;
+	int err;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+		adv = 0x0001;
+		break;
+
+	case PHY_INTERFACE_MODE_1000BASEX:
+		adv = linkmode_adv_to_mii_adv_x(advertise,
+					ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
+		break;
+
+	default:
+		return 0;
+	}
+
+	err = mv88e6352_serdes_read(chip, MII_ADVERTISE, &val);
+	if (err)
+		return err;
+
+	changed = val != adv;
+	if (changed) {
+		err = mv88e6352_serdes_write(chip, MII_ADVERTISE, adv);
+		if (err)
+			return err;
+	}
+
+	err = mv88e6352_serdes_read(chip, MII_BMCR, &val);
+	if (err)
+		return err;
+
+	if (phylink_autoneg_inband(mode))
+		bmcr = val | BMCR_ANENABLE;
+	else
+		bmcr = val & ~BMCR_ANENABLE;
+
+	if (bmcr == val)
+		return changed;
+
+	return mv88e6352_serdes_write(chip, MII_BMCR, bmcr);
+}
+
+int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				   u8 lane, struct phylink_link_state *state)
+{
+	u16 lpa, status;
+	int err;
+
+	err = mv88e6352_serdes_read(chip, 0x11, &status);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes PHY status: %d\n", err);
+		return err;
+	}
+
+	err = mv88e6352_serdes_read(chip, MII_LPA, &lpa);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes PHY LPA: %d\n", err);
+		return err;
+	}
+
+	return mv88e6xxx_serdes_pcs_get_state(chip, status, lpa, state);
+}
+
+int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
+				    u8 lane)
+{
+	u16 bmcr;
+	int err;
+
+	err = mv88e6352_serdes_read(chip, MII_BMCR, &bmcr);
+	if (err)
+		return err;
+
+	return mv88e6352_serdes_write(chip, MII_BMCR, bmcr | BMCR_ANRESTART);
+}
+
+int mv88e6352_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
+				 u8 lane, int speed, int duplex)
+{
+	u16 val, bmcr;
+	int err;
+
+	err = mv88e6352_serdes_read(chip, MII_BMCR, &val);
+	if (err)
+		return err;
+
+	bmcr = val & ~(BMCR_SPEED100 | BMCR_FULLDPLX | BMCR_SPEED1000);
+	switch (speed) {
+	case SPEED_1000:
+		bmcr |= BMCR_SPEED1000;
+		break;
+	case SPEED_100:
+		bmcr |= BMCR_SPEED100;
+		break;
+	case SPEED_10:
+		break;
+	}
+
+	if (duplex == DUPLEX_FULL)
+		bmcr |= BMCR_FULLDPLX;
+
+	if (bmcr == val)
+		return 0;
+
+	return mv88e6352_serdes_write(chip, MII_BMCR, bmcr);
+}
+
 u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
@@ -538,71 +698,153 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 	return err;
 }
 
-static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
-					    int port, u8 lane)
+int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
+				u8 lane, unsigned int mode,
+				phy_interface_t interface,
+				const unsigned long *advertise)
 {
-	u8 cmode = chip->ports[port].cmode;
-	struct dsa_switch *ds = chip->ds;
-	int duplex = DUPLEX_UNKNOWN;
-	int speed = SPEED_UNKNOWN;
-	phy_interface_t mode;
-	int link, err;
-	u16 status;
+	u16 val, bmcr, adv;
+	bool changed;
+	int err;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+		adv = 0x0001;
+		break;
+
+	case PHY_INTERFACE_MODE_1000BASEX:
+		adv = linkmode_adv_to_mii_adv_x(advertise,
+					ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
+		break;
+
+	case PHY_INTERFACE_MODE_2500BASEX:
+		adv = linkmode_adv_to_mii_adv_x(advertise,
+					ETHTOOL_LINK_MODE_2500baseX_Full_BIT);
+		break;
+
+	default:
+		return 0;
+	}
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_SGMII_ADVERTISE, &val);
+	if (err)
+		return err;
+
+	changed = val != adv;
+	if (changed) {
+		err = mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+					     MV88E6390_SGMII_ADVERTISE, adv);
+		if (err)
+			return err;
+	}
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_SGMII_BMCR, &val);
+	if (err)
+		return err;
+
+	if (phylink_autoneg_inband(mode))
+		bmcr = val | BMCR_ANENABLE;
+	else
+		bmcr = val & ~BMCR_ANENABLE;
+
+	/* setting ANENABLE triggers a restart of negotiation */
+	if (bmcr == val)
+		return changed;
+
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6390_SGMII_BMCR, bmcr);
+}
+
+int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				   u8 lane, struct phylink_link_state *state)
+{
+	u16 lpa, status;
+	int err;
 
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
 				    MV88E6390_SGMII_PHY_STATUS, &status);
 	if (err) {
-		dev_err(chip->dev, "can't read SGMII PHY status: %d\n", err);
-		return;
+		dev_err(chip->dev, "can't read Serdes PHY status: %d\n", err);
+		return err;
 	}
 
-	link = status & MV88E6390_SGMII_PHY_STATUS_LINK ?
-	       LINK_FORCED_UP : LINK_FORCED_DOWN;
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_SGMII_LPA, &lpa);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes PHY LPA: %d\n", err);
+		return err;
+	}
 
-	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
-		duplex = status & MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
-			 DUPLEX_FULL : DUPLEX_HALF;
+	return mv88e6xxx_serdes_pcs_get_state(chip, status, lpa, state);
+}
 
-		switch (status & MV88E6390_SGMII_PHY_STATUS_SPEED_MASK) {
-		case MV88E6390_SGMII_PHY_STATUS_SPEED_1000:
-			if (cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-				speed = SPEED_2500;
-			else
-				speed = SPEED_1000;
-			break;
-		case MV88E6390_SGMII_PHY_STATUS_SPEED_100:
-			speed = SPEED_100;
-			break;
-		case MV88E6390_SGMII_PHY_STATUS_SPEED_10:
-			speed = SPEED_10;
-			break;
-		default:
-			dev_err(chip->dev, "invalid PHY speed\n");
-			return;
-		}
-	}
+int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
+				    u8 lane)
+{
+	u16 bmcr;
+	int err;
 
-	switch (cmode) {
-	case MV88E6XXX_PORT_STS_CMODE_SGMII:
-		mode = PHY_INTERFACE_MODE_SGMII;
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_SGMII_BMCR, &bmcr);
+	if (err)
+		return err;
+
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6390_SGMII_BMCR,
+				      bmcr | BMCR_ANRESTART);
+}
+
+int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
+				 u8 lane, int speed, int duplex)
+{
+	u16 val, bmcr;
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_SGMII_BMCR, &val);
+	if (err)
+		return err;
+
+	bmcr = val & ~(BMCR_SPEED100 | BMCR_FULLDPLX | BMCR_SPEED1000);
+	switch (speed) {
+	case SPEED_2500:
+	case SPEED_1000:
+		bmcr |= BMCR_SPEED1000;
 		break;
-	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
-		mode = PHY_INTERFACE_MODE_1000BASEX;
+	case SPEED_100:
+		bmcr |= BMCR_SPEED100;
 		break;
-	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		mode = PHY_INTERFACE_MODE_2500BASEX;
+	case SPEED_10:
 		break;
-	default:
-		mode = PHY_INTERFACE_MODE_NA;
 	}
 
-	err = mv88e6xxx_port_setup_mac(chip, port, link, speed, duplex,
-				       PAUSE_OFF, mode);
-	if (err)
-		dev_err(chip->dev, "can't propagate PHY settings to MAC: %d\n",
-			err);
-	else
-		dsa_port_phylink_mac_change(ds, port, link == LINK_FORCED_UP);
+	if (duplex == DUPLEX_FULL)
+		bmcr |= BMCR_FULLDPLX;
+
+	if (bmcr == val)
+		return 0;
+
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6390_SGMII_BMCR, bmcr);
+}
+
+static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
+					    int port, u8 lane)
+{
+	u16 status;
+	int err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_SGMII_PHY_STATUS, &status);
+	if (err) {
+		dev_err(chip->dev, "can't read SGMII PHY status: %d\n", err);
+		return;
+	}
+
+	dsa_port_phylink_mac_change(chip->ds, port,
+				!!(status & MV88E6390_SGMII_PHY_STATUS_LINK));
 }
 
 static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 15169a1cfd05..a0c95322987d 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -48,6 +48,8 @@
 
 /* 1000BASE-X and SGMII */
 #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
+#define MV88E6390_SGMII_ADVERTISE	(0x2000 + MII_ADVERTISE)
+#define MV88E6390_SGMII_LPA		(0x2000 + MII_LPA)
 #define MV88E6390_SGMII_INT_ENABLE	0xa001
 #define MV88E6390_SGMII_INT_SPEED_CHANGE	BIT(14)
 #define MV88E6390_SGMII_INT_DUPLEX_CHANGE	BIT(13)
@@ -66,6 +68,8 @@
 #define MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL	BIT(13)
 #define MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID BIT(11)
 #define MV88E6390_SGMII_PHY_STATUS_LINK		BIT(10)
+#define MV88E6390_SGMII_PHY_STATUS_TX_PAUSE	BIT(3)
+#define MV88E6390_SGMII_PHY_STATUS_RX_PAUSE	BIT(2)
 
 /* Packet generator pad packet checker */
 #define MV88E6390_PG_CONTROL		0xf010
@@ -75,6 +79,26 @@ u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
+				u8 lane, unsigned int mode,
+				phy_interface_t interface,
+				const unsigned long *advertise);
+int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
+				u8 lane, unsigned int mode,
+				phy_interface_t interface,
+				const unsigned long *advertise);
+int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				   u8 lane, struct phylink_link_state *state);
+int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				   u8 lane, struct phylink_link_state *state);
+int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
+				    u8 lane);
+int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
+				    u8 lane);
+int mv88e6352_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
+				 u8 lane, int speed, int duplex);
+int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
+				 u8 lane, int speed, int duplex);
 unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
-- 
2.20.1

