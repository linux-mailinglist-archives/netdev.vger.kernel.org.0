Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C0CAEEBF
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394002AbfIJPoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:44:32 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43804 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfIJPoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:44:32 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id BB6D328DA1D
From:   Robert Beckett <bob.beckett@collabora.com>
To:     netdev@vger.kernel.org
Cc:     Robert Beckett <bob.beckett@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/7] net: dsa: mv88e6xxx: add ability to set queue scheduling
Date:   Tue, 10 Sep 2019 16:41:50 +0100
Message-Id: <20190910154238.9155-5-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190910154238.9155-1-bob.beckett@collabora.com>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code to set Schedule for any port that specifies "schedule" in their
device tree node.
This allows port prioritization in conjunction with port default queue
priorities or packet priorities.

Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/port.c | 21 +++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  6 ++++++
 4 files changed, 53 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5005a35493e3..2bc22c59200c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2103,6 +2103,23 @@ static int mv88e6xxx_set_port_defqpri(struct mv88e6xxx_chip *chip, int port)
 	return chip->info->ops->port_set_defqpri(chip, port, (u16)pri);
 }
 
+static int mv88e6xxx_set_port_sched(struct mv88e6xxx_chip *chip, int port)
+{
+	struct dsa_switch *ds = chip->ds;
+	struct device_node *dn = ds->ports[port].dn;
+	int err;
+	u32 sched;
+
+	if (!dn || !chip->info->ops->port_set_sched)
+		return 0;
+
+	err = of_property_read_u32(dn, "schedule", &sched);
+	if (err < 0)
+		return 0;
+
+	return chip->info->ops->port_set_sched(chip, port, (u16)sched);
+}
+
 static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
@@ -2218,6 +2235,10 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
+	err = mv88e6xxx_set_port_sched(chip, port);
+	if (err)
+		return err;
+
 	if (chip->info->ops->port_pause_limit) {
 		err = chip->info->ops->port_pause_limit(chip, port, 0, 0);
 		if (err)
@@ -3130,6 +3151,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_set_sched = mv88e6xxx_port_set_sched,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3214,6 +3236,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_set_sched = mv88e6xxx_port_set_sched,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3432,6 +3455,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_set_sched = mv88e6xxx_port_set_sched,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
@@ -3776,6 +3800,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
 	.port_set_defqpri = mv88e6xxx_port_set_defqpri,
 	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_set_sched = mv88e6xxx_port_set_sched,
 	.port_pause_limit = mv88e6097_port_pause_limit,
 	.port_disable_learn_limit = mv88e6xxx_port_disable_learn_limit,
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 2d2c24f5a79d..ff3e35eceee0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -386,6 +386,7 @@ struct mv88e6xxx_ops {
 	int (*port_set_defqpri)(struct mv88e6xxx_chip *chip, int port, u16 pri);
 
 	int (*port_egress_rate_limiting)(struct mv88e6xxx_chip *chip, int port);
+	int (*port_set_sched)(struct mv88e6xxx_chip *chip, int port, u16 sched);
 	int (*port_pause_limit)(struct mv88e6xxx_chip *chip, int port, u8 in,
 				u8 out);
 	int (*port_disable_learn_limit)(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 3a45fcd5cd9c..236732fc598d 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1180,6 +1180,27 @@ int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
 				    0x0001);
 }
 
+/* Offset 0x0A: Egress Rate Control 2 */
+int mv88e6xxx_port_set_sched(struct mv88e6xxx_chip *chip, int port, u16 sched)
+{
+	u16 reg;
+	int err;
+
+	if (sched > MV88E6XXX_PORT_SCHED_STRICT_ALL)
+		return -EINVAL;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
+				  &reg);
+	if (err)
+		return err;
+
+	reg &= ~MV88E6XXX_PORT_SCHED_MASK;
+	reg |= sched << MV88E6XXX_PORT_SCHED_SHIFT;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2,
+				    reg);
+}
+
 /* Offset 0x0C: Port ATU Control */
 
 int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 03884bbaa762..710d6eccafae 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -11,6 +11,7 @@
 #ifndef _MV88E6XXX_PORT_H
 #define _MV88E6XXX_PORT_H
 
+#include <dt-bindings/net/dsa-mv88e6xxx.h>
 #include "chip.h"
 
 /* Offset 0x00: Port Status Register */
@@ -207,6 +208,10 @@
 
 /* Offset 0x0A: Egress Rate Control 2 */
 #define MV88E6XXX_PORT_EGRESS_RATE_CTL2		0x0a
+#define MV88E6XXX_PORT_SCHED_SHIFT		12
+#define MV88E6XXX_PORT_SCHED_MASK \
+	(0x3 << MV88E6XXX_PORT_SCHED_SHIFT)
+/* see MV88E6XXX_PORT_SCHED_* in include/dt-bindings/net/dsa-mv88e6xxx.h */
 
 /* Offset 0x0B: Port Association Vector */
 #define MV88E6XXX_PORT_ASSOC_VECTOR			0x0b
@@ -332,6 +337,7 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
 int mv88e6xxx_port_set_defqpri(struct mv88e6xxx_chip *chip, int port, u16 pri);
 int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
 int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
+int mv88e6xxx_port_set_sched(struct mv88e6xxx_chip *chip, int port, u16 sched);
 int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
 			       u8 out);
 int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
-- 
2.18.0

