Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CBAEEC4
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436534AbfIJPpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:45:01 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43830 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfIJPpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:45:00 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 99BD328DA1D
From:   Robert Beckett <bob.beckett@collabora.com>
To:     netdev@vger.kernel.org
Cc:     Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6/7] net: dsa: mv88e6xxx: add egress rate limiting
Date:   Tue, 10 Sep 2019 16:41:52 +0100
Message-Id: <20190910154238.9155-7-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190910154238.9155-1-bob.beckett@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code for specifying egress rate limiting per port.
The rate can be specified as ethernet frames or bits per second.

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  72 ++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/chip.h |   3 +-
 drivers/net/dsa/mv88e6xxx/port.c | 106 ++++++++++++++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/port.h |  14 +++-
 4 files changed, 158 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2bc22c59200c..8c116496ab2f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2120,6 +2120,32 @@ static int mv88e6xxx_set_port_sched(struct mv88e6xxx_chip *chip, int port)
 	return chip->info->ops->port_set_sched(chip, port, (u16)sched);
 }
 
+static int mv88e6xxx_set_port_egress_rate_limiting(struct mv88e6xxx_chip *chip,
+						   int port)
+{
+	struct dsa_switch *ds = chip->ds;
+	struct device_node *dn = ds->ports[port].dn;
+	int err;
+	u32 mode, count;
+
+	if (!dn || !chip->info->ops->port_egress_rate_limiting)
+		return 0;
+
+	err = of_property_read_u32(dn, "egress-limit-mode", &mode);
+	if (err < 0)
+		goto disable;
+
+	err = of_property_read_u32(dn, "egress-limit-count", &count);
+	if (err < 0)
+		goto disable;
+
+	return chip->info->ops->port_egress_rate_limiting(chip, port, count,
+							  mode);
+
+disable:
+	return chip->info->ops->port_egress_rate_limiting(chip, port, 0, 0);
+}
+
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
@@ -2263,11 +2289,9 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 			return err;
 	}
 
-	if (chip->info->ops->port_egress_rate_limiting) {
-		err = chip->info->ops->port_egress_rate_limiting(chip, port);
-		if (err)
-			return err;
-	}
+	err = mv88e6xxx_set_port_egress_rate_limiting(chip, port);
+	if (err)
+		return err;
 
 	err = mv88e6xxx_setup_message_port(chip, port);
 	if (err)
@@ -2809,7 +2833,7 @@ static const struct mv88e6xxx_ops mv88e6085_ops = {
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -2879,7 +2903,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6095_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -2951,7 +2975,7 @@ static const struct mv88e6xxx_ops mv88e6131_ops = {
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_set_pause = mv88e6185_port_set_pause,
 	.port_link_state = mv88e6352_port_link_state,
@@ -2994,7 +3018,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3034,7 +3058,7 @@ static const struct mv88e6xxx_ops mv88e6161_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3108,7 +3132,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3150,7 +3174,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_set_sched = mv88e6xxx_port_set_sched,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3193,7 +3217,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3235,7 +3259,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_set_sched = mv88e6xxx_port_set_sched,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3275,7 +3299,7 @@ static const struct mv88e6xxx_ops mv88e6185_ops = {
 	.port_set_speed = mv88e6185_port_set_speed,
 	.port_set_frame_mode = mv88e6085_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6185_port_set_egress_floods,
-	.port_egress_rate_limiting = mv88e6095_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_set_upstream_port = mv88e6095_port_set_upstream_port,
 	.port_set_pause = mv88e6185_port_set_pause,
 	.port_link_state = mv88e6185_port_link_state,
@@ -3454,7 +3478,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_set_sched = mv88e6xxx_port_set_sched,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3587,7 +3611,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3630,7 +3654,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3673,7 +3697,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3716,7 +3740,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3755,7 +3779,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3799,7 +3823,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_set_sched = mv88e6xxx_port_set_sched,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3851,7 +3875,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3900,7 +3924,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
-	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_egress_rate_limiting = mv88e6xxx_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6390_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index ff3e35eceee0..75fbd5df4aae 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -385,7 +385,8 @@ struct mv88e6xxx_ops {
 				   size_t size);
 	int (*port_set_defqpri)(struct mv88e6xxx_chip *chip, int port, u16 pri);
 
-	int (*port_egress_rate_limiting)(struct mv88e6xxx_chip *chip, int port);
+	int (*port_egress_rate_limiting)(struct mv88e6xxx_chip *chip, int port,
+					 u32 count, u32 mode);
 	int (*port_set_sched)(struct mv88e6xxx_chip *chip, int port, u16 sched);
 	int (*port_pause_limit)(struct mv88e6xxx_chip *chip, int port, u8 in,
 				u8 out);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 236732fc598d..41418cfaca56 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1166,21 +1166,107 @@ int mv88e6xxx_port_set_defqpri(struct mv88e6xxx_chip *chip, int port, u16 pri)
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
 }
 
-/* Offset 0x09: Port Rate Control */
+/* Offset 0x09: Port Rate Control
+ * Offset 0x0A: Egress Rate Control 2
+ */
 
-int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
+#define Kb			1000
+#define Mb			(1000 * Kb)
+#define Gb			(1000ull * Mb)
+#define EGRESS_FRAME_RATE_MIN	7632
+#define EGRESS_FRAME_RATE_MAX	31250000
+#define EGRESS_BPS_RATE_MIN	(64 * Kb)
+#define EGRESS_BPS_RATE_MAX	(1 * Gb)
+#define EGRESS_RATE_PERIOD	32
+int mv88e6xxx_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port,
+					u32 count, u32 mode)
 {
-	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
-				    0x0000);
-}
+	u16 reg1, reg2;
+	int err;
 
-int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
-{
-	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
-				    0x0001);
+	/* quick exit for disabling */
+	if (count == 0) {
+		err = mv88e6xxx_port_read(chip, port,
+					  MV88E6XXX_PORT_EGRESS_RATE_CTL2,
+					  &reg2);
+		if (err)
+			return err;
+		reg2 &= ~MV88E6XXX_PORT_EGRESS_RATE_MASK;
+		err =  mv88e6xxx_port_write(chip, port,
+					    MV88E6XXX_PORT_EGRESS_RATE_CTL2,
+					    reg2);
+		return err;
+	}
+
+	if (mode > MV88E6XXX_PORT_EGRESS_COUNT_MODE_L3)
+		return -EINVAL;
+
+	if (mode == MV88E6XXX_PORT_EGRESS_COUNT_MODE_FRAMES &&
+	    (count < EGRESS_FRAME_RATE_MIN || count > EGRESS_FRAME_RATE_MAX))
+		return -EINVAL;
+
+	if (mode != MV88E6XXX_PORT_EGRESS_COUNT_MODE_FRAMES &&
+	    (count < EGRESS_BPS_RATE_MIN || count > EGRESS_BPS_RATE_MAX))
+		return -EINVAL;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
+				  &reg1);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
+				  &reg2);
+	if (err)
+		return err;
+
+	reg1 &= ~MV88E6XXX_PORT_EGRESS_DEC_MASK;
+	reg2 &= ~MV88E6XXX_PORT_EGRESS_COUNT_MODE_MASK;
+
+	if (mode == MV88E6XXX_PORT_EGRESS_COUNT_MODE_FRAMES) {
+		u32 val;
+
+		/* recommended to use dec of 1 for frame based */
+		reg1 |= 1 << MV88E6XXX_PORT_EGRESS_DEC_SHIFT;
+
+		reg2 |= mode << MV88E6XXX_PORT_EGRESS_COUNT_MODE_SHIFT;
+		reg2 &= ~MV88E6XXX_PORT_EGRESS_RATE_MASK;
+
+		val = NSEC_PER_SEC / (EGRESS_RATE_PERIOD * count);
+		if (NSEC_PER_SEC % (EGRESS_RATE_PERIOD * count))
+			val++;
+		reg2 |= (u16)(val << MV88E6XXX_PORT_EGRESS_RATE_SHIFT);
+	} else {
+		u16 egress_dec, egress_rate;
+		u64 dec_bytes, ns_bits;
+
+		if (count < (1 * Mb))
+			egress_dec = (u16)roundup(count, (64 * Kb));
+		else if (count < (100 * Mb))
+			egress_dec = (u16)roundup(count, (1 * Mb));
+		else
+			egress_dec = (u16)roundup(count, (10 * Mb));
+
+		reg1 |= egress_dec;
+
+		dec_bytes = 8ull * NSEC_PER_SEC * egress_dec;
+		ns_bits = 32ull * count;
+		egress_rate = (u16)div64_u64(dec_bytes, ns_bits);
+		reg2 |= egress_rate;
+	}
+
+	err =  mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL1,
+				    reg1);
+	if (err)
+		return err;
+
+	err =  mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
+				    reg2);
+	if (err)
+		return err;
+
+	return 0;
 }
 
-/* Offset 0x0A: Egress Rate Control 2 */
 int mv88e6xxx_port_set_sched(struct mv88e6xxx_chip *chip, int port, u16 sched)
 {
 	u16 reg;
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 710d6eccafae..724f839c570a 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -205,13 +205,23 @@
 
 /* Offset 0x09: Egress Rate Control */
 #define MV88E6XXX_PORT_EGRESS_RATE_CTL1		0x09
+#define MV88E6XXX_PORT_EGRESS_DEC_SHIFT		0
+#define MV88E6XXX_PORT_EGRESS_DEC_MASK		0x7f
 
 /* Offset 0x0A: Egress Rate Control 2 */
 #define MV88E6XXX_PORT_EGRESS_RATE_CTL2		0x0a
+#define MV88E6XXX_PORT_EGRESS_COUNT_MODE_SHIFT	14
+#define MV88E6XXX_PORT_EGRESS_COUNT_MODE_MASK	\
+	(0x3 << MV88E6XXX_PORT_EGRESS_COUNT_MODE_SHIFT)
+/* see MV88E6XXX_PORT_EGRESS_COUNT_* in
+ * include/dt-bindings/net/dsa-mv88e6xxx.h
+ */
 #define MV88E6XXX_PORT_SCHED_SHIFT		12
 #define MV88E6XXX_PORT_SCHED_MASK \
 	(0x3 << MV88E6XXX_PORT_SCHED_SHIFT)
 /* see MV88E6XXX_PORT_SCHED_* in include/dt-bindings/net/dsa-mv88e6xxx.h */
+#define MV88E6XXX_PORT_EGRESS_RATE_SHIFT	0
+#define MV88E6XXX_PORT_EGRESS_RATE_MASK		0xfff
 
 /* Offset 0x0B: Port Association Vector */
 #define MV88E6XXX_PORT_ASSOC_VECTOR			0x0b
@@ -335,8 +345,8 @@ int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
 int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 				  size_t size);
 int mv88e6xxx_port_set_defqpri(struct mv88e6xxx_chip *chip, int port, u16 pri);
-int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
-int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
+int mv88e6xxx_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port,
+					u32 count, u32 mode);
 int mv88e6xxx_port_set_sched(struct mv88e6xxx_chip *chip, int port, u16 sched);
 int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
 			       u8 out);
-- 
2.18.0

