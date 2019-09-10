Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A8AAEEB9
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393933AbfIJPnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:43:21 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43750 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfIJPnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:43:21 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 175B828D91B
From:   Robert Beckett <bob.beckett@collabora.com>
To:     netdev@vger.kernel.org
Cc:     Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/7] net: dsa: mv88e6xxx: add ability to set default queue priorities per port
Date:   Tue, 10 Sep 2019 16:41:48 +0100
Message-Id: <20190910154238.9155-3-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190910154238.9155-1-bob.beckett@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code to set DefQPri for any port that specifies "defqpri" in their
device tree node.
This allows setting the default output queue priority for all packets
entering the switch via the port that uses this, which is useful for
prioritizing traffic based on port.

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/port.c | 19 +++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  4 ++++
 4 files changed, 49 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d0a97eb73a37..5005a35493e3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2086,6 +2086,23 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 	return 0;
 }
 
+static int mv88e6xxx_set_port_defqpri(struct mv88e6xxx_chip *chip, int port)
+{
+	struct dsa_switch *ds = chip->ds;
+	struct device_node *dn = ds->ports[port].dn;
+	int err;
+	u32 pri;
+
+	if (!dn || !chip->info->ops->port_set_defqpri)
+		return 0;
+
+	err = of_property_read_u32(dn, "defqpri", &pri);
+	if (err < 0)
+		return 0;
+
+	return chip->info->ops->port_set_defqpri(chip, port, (u16)pri);
+}
+
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
@@ -2176,6 +2193,10 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 			return err;
 	}
 
+	err = mv88e6xxx_set_port_defqpri(chip, port);
+	if (err)
+		return err;
+
 	/* Port Association Vector: when learning source addresses
 	 * of packets, add the address to the address database using
 	 * a port bitmap that has only the bit for this port set and
@@ -3107,6 +3128,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
+	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3190,6 +3212,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
+	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3407,6 +3430,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
+	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
@@ -3750,6 +3774,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6351_port_set_ether_type,
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
+	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 4646e46d47f2..2d2c24f5a79d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -383,6 +383,7 @@ struct mv88e6xxx_ops {
 				   u16 etype);
 	int (*port_set_jumbo_size)(struct mv88e6xxx_chip *chip, int port,
 				   size_t size);
+	int (*port_set_defqpri)(struct mv88e6xxx_chip *chip, int port, u16 pri);
 
 	int (*port_egress_rate_limiting)(struct mv88e6xxx_chip *chip, int port);
 	int (*port_pause_limit)(struct mv88e6xxx_chip *chip, int port, u8 in,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 04309ef0a1cc..3a45fcd5cd9c 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1147,6 +1147,25 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
 }
 
+int mv88e6xxx_port_set_defqpri(struct mv88e6xxx_chip *chip, int port, u16 pri)
+{
+	u16 reg;
+	int err;
+
+	if (pri > 3)
+		return -EINVAL;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
+	if (err)
+		return err;
+
+	reg &= ~MV88E6XXX_PORT_CTL2_DEFQPRI_MASK;
+	reg |= pri << MV88E6XXX_PORT_CTL2_DEFQPRI_SHIFT;
+	reg |= MV88E6XXX_PORT_CTL2_USE_DEFQPRI;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
+}
+
 /* Offset 0x09: Port Rate Control */
 
 int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 8d5a6cd6fb19..03884bbaa762 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -197,6 +197,9 @@
 #define MV88E6XXX_PORT_CTL2_DEFAULT_FORWARD		0x0040
 #define MV88E6XXX_PORT_CTL2_EGRESS_MONITOR		0x0020
 #define MV88E6XXX_PORT_CTL2_INGRESS_MONITOR		0x0010
+#define MV88E6XXX_PORT_CTL2_USE_DEFQPRI		0x0008
+#define MV88E6XXX_PORT_CTL2_DEFQPRI_MASK		0x0006
+#define MV88E6XXX_PORT_CTL2_DEFQPRI_SHIFT		1
 #define MV88E6095_PORT_CTL2_CPU_PORT_MASK		0x000f
 
 /* Offset 0x09: Egress Rate Control */
@@ -326,6 +329,7 @@ int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
 				    bool message_port);
 int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 				  size_t size);
+int mv88e6xxx_port_set_defqpri(struct mv88e6xxx_chip *chip, int port, u16 pri);
 int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
 int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
 int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
-- 
2.18.0

