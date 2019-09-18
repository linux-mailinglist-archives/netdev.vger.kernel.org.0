Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975FFB6561
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 16:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbfIROC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 10:02:29 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54333 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfIROC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 10:02:29 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1iAaXM-0001VS-27; Wed, 18 Sep 2019 16:02:28 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1iAaXK-0007Zr-0W; Wed, 18 Sep 2019 16:02:26 +0200
Date:   Wed, 18 Sep 2019 16:02:25 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
Subject: dsa traffic priorization
Message-ID: <20190918140225.imqchybuf3cnknob@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:46:35 up 72 days, 19:56, 85 users,  load average: 0.16, 0.16,
 0.11
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
regular network traffic on another port. The customer wants to configure two things
on the switch: First Ethercat traffic shall be priorized over other network traffic
(effectively prioritizing traffic based on port). Second the ethernet controller
in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
port shall be rate limited.

For reference the patch below configures the switch to their needs. Now the question
is how this can be implemented in a way suitable for mainline. It looks like the per
port priority mapping for VLAN tagged packets could be done via ip link add link ...
ingress-qos-map QOS-MAP. How the default priority would be set is unclear to me.

The other part of the problem seems to be that the CPU port has no network device
representation in Linux, so there's no interface to configure the egress limits via tc.
This has been discussed before, but it seems there hasn't been any consensous regarding how
we want to proceed?

Sascha

-----------------------------8<-----------------------------------

 drivers/net/dsa/mv88e6xxx/chip.c | 54 +++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/port.c | 87 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h | 19 +++++++
 3 files changed, 159 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d0a97eb73a37..2a15cf259d04 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2090,7 +2090,9 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 {
         struct dsa_switch *ds = chip->ds;
         int err;
+        u16 addr;
         u16 reg;
+        u16 val;
 
         chip->ports[port].chip = chip;
         chip->ports[port].port = port;
@@ -2246,7 +2248,57 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
         /* Default VLAN ID and priority: don't set a default VLAN
          * ID, and set the default packet priority to zero.
          */
-        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_DEFAULT_VLAN, 0);
+        err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_DEFAULT_VLAN, 0);
+        if (err)
+                return err;
+
+#define SWITCH_CPU_PORT 5
+#define SWITCH_ETHERCAT_PORT 3
+
+        /* set the egress rate */
+        switch (port) {
+                case SWITCH_CPU_PORT:
+                        err = mv88e6xxx_port_set_egress_rate(chip, port,
+                                        MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_FRAME, 30000);
+                        break;
+                default:
+                        err = mv88e6xxx_port_set_egress_rate(chip, port,
+                                        MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_FRAME, 0);
+                        break;
+        }
+
+        if (err)
+                return err;
+
+        /* set the output queue usage */
+        switch (port) {
+                case SWITCH_CPU_PORT:
+                        err = mv88e6xxx_port_set_output_queue_schedule(chip, port,
+                                        MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_Q3_STRICT);
+                        break;
+                default:
+                        err = mv88e6xxx_port_set_output_queue_schedule(chip, port,
+                                        MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_NONE_STRICT);
+                        break;
+        }
+
+        if (err)
+                return err;
+
+        /* set the default QPri */
+        switch (port) {
+                case SWITCH_ETHERCAT_PORT:
+                        err = mv88e6xxx_port_set_default_qpri(chip, port, 3);
+                        break;
+                default:
+                        err = mv88e6xxx_port_set_default_qpri(chip, port, 2);
+                        break;
+        }
+
+        if (err)
+                return err;
+
+        return 0;
 }
 
 static int mv88e6xxx_port_enable(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 04309ef0a1cc..e03f24308f15 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1147,6 +1147,22 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
         return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
 }
 
+int mv88e6xxx_port_set_default_qpri(struct mv88e6xxx_chip *chip, int port, int qpri)
+{
+        u16 reg;
+        int err;
+
+        err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
+        if (err)
+                return err;
+
+        reg &= ~MV88E6XXX_PORT_CTL2_DEF_QPRI_MASK;
+        reg |= (qpri << 1) & MV88E6XXX_PORT_CTL2_DEF_QPRI_MASK;
+        reg |= MV88E6XXX_PORT_CTL2_USE_DEF_QPRI;
+
+        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
+}
+
 /* Offset 0x09: Port Rate Control */
 
 int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
@@ -1161,6 +1177,77 @@ int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port)
                                     0x0001);
 }
 
+int mv88e6xxx_port_set_output_queue_schedule(struct mv88e6xxx_chip *chip, int port,
+                                             u16 schedule)
+{
+        u16 reg;
+        int err;
+
+        err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2, &reg);
+        if (err)
+                return err;
+
+        reg &= ~MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_MASK;
+        reg |= schedule;
+
+        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2, reg);
+}
+
+static int _mv88e6xxx_egress_rate_calc_frames(u32 rate, u16 *egress_rate_val)
+{
+        const volatile u32 scale_factor = (1000 * 1000 * 1000);
+        volatile u32 u;
+
+        if (rate > 1488000)
+                return EINVAL;
+
+        if (rate < 7600)
+                return EINVAL;
+
+        u = 32 * rate;
+        u = scale_factor / u; /* scale_factor used to convert 32s into 32ns */
+
+        *egress_rate_val = (u16)u;
+
+        return 0;
+}
+
+int mv88e6xxx_port_set_egress_rate(struct mv88e6xxx_chip *chip, int port, u16 type,
+                                   u32 rate)
+{
+        u16 reg;
+        int err;
+        u16 egress_rate_val;
+
+        err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2, &reg);
+        if (err)
+                return err;
+
+        reg &= ~MV88E6XXX_PORT_EGRESS_RATE_CTL2_RATE_MASK;
+
+        if (rate) {
+                reg &= ~MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_MASK;
+                reg |= type;
+
+                switch (type) {
+                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_FRAME:
+                                err = _mv88e6xxx_egress_rate_calc_frames(rate, &egress_rate_val);
+                                if (err)
+                                        return err;
+                                reg |= egress_rate_val & 0x0FFF;
+                                break;
+                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L1:
+                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L2:
+                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L3:
+                                return EINVAL; /* ToDo */
+                        default:
+                                return EINVAL;
+                }
+        }
+
+        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_RATE_CTL2, reg);
+}
+
 /* Offset 0x0C: Port ATU Control */
 
 int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 8d5a6cd6fb19..cdd057c52ab8 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -197,6 +197,8 @@
 #define MV88E6XXX_PORT_CTL2_DEFAULT_FORWARD                0x0040
 #define MV88E6XXX_PORT_CTL2_EGRESS_MONITOR                0x0020
 #define MV88E6XXX_PORT_CTL2_INGRESS_MONITOR                0x0010
+#define MV88E6XXX_PORT_CTL2_USE_DEF_QPRI        0x0008
+#define MV88E6XXX_PORT_CTL2_DEF_QPRI_MASK        0x0006
 #define MV88E6095_PORT_CTL2_CPU_PORT_MASK                0x000f
 
 /* Offset 0x09: Egress Rate Control */
@@ -204,6 +206,17 @@
 
 /* Offset 0x0A: Egress Rate Control 2 */
 #define MV88E6XXX_PORT_EGRESS_RATE_CTL2                0x0a
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_MASK 0xC000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_FRAME 0x0000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L1 0x4000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L2 0x8000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L3 0xC000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_MASK 0x3000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_NONE_STRICT 0x0000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_Q3_STRICT 0x1000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_Q3_Q2_STRICT 0x2000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_ALL_STRICT 0x3000
+#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_RATE_MASK 0x0FFF
 
 /* Offset 0x0B: Port Association Vector */
 #define MV88E6XXX_PORT_ASSOC_VECTOR                        0x0b
@@ -326,8 +339,14 @@ int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
                                     bool message_port);
 int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
                                   size_t size);
+int mv88e6xxx_port_set_default_qpri(struct mv88e6xxx_chip *chip, int port,
+                                  int qpri);
 int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
 int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, int port);
+int mv88e6xxx_port_set_output_queue_schedule(struct mv88e6xxx_chip *chip, int port,
+                                  u16 schedule);
+int mv88e6xxx_port_set_egress_rate(struct mv88e6xxx_chip *chip, int port,
+                                  u16 type, u32 rate);
 int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
                                u8 out);
 int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, u8 in,
-- 
2.23.0

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
