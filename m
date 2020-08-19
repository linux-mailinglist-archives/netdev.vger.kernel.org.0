Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDD324A341
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgHSPi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:38:27 -0400
Received: from lists.nic.cz ([217.31.204.67]:52276 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgHSPiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 11:38:20 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTP id 8AF44140A94;
        Wed, 19 Aug 2020 17:38:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597851497; bh=mQ+Lb3nWO9UHY/hUdWAvXj0UsmEjHd7oDjKnulbnSIg=;
        h=From:To:Date;
        b=jq9IWh2u4X3g7/Xykqbhf7Y+C+hf5UlPAhOq8xHxqVB0BVCCRjL3ZiTuLV5hKqMT4
         s/SXz01C0NdrWF2j2JBuocPfF2IjiYHWQHk4gFDFq74nYR4UWi9kLsRLq7cn/gbIOr
         40n0M7/nKT1ICk7hPNWSlSiXVhsO7qujFhuQ/o4o=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 2/3] net: dsa: mv88e6xxx: return error instead of lane in .serdes_get_lane
Date:   Wed, 19 Aug 2020 17:38:15 +0200
Message-Id: <20200819153816.30834-3-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200819153816.30834-1-marek.behun@nic.cz>
References: <20200819153816.30834-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the .serdes_get_lane method gets the lane as the result of the
method, returning 0 if no SERDES is on given port.

This was okay till now, because on no mv88e6xxx switch were it possible
to have SERDES on port/lane 0. But it becomes incompatible with
88E6393X, on which the SERDES ports are ports 0, 9 and 10 with lanes
0, 9 and 10, respectively.

This patch therefore changes the .serdes_get_lane method API so that it
returns 0 on success (if a lane is found) and -ENODEV otherwise. The
lane itself is stored into a place pointed to by a parameter.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 33 +++++++------
 drivers/net/dsa/mv88e6xxx/chip.h   |  2 +-
 drivers/net/dsa/mv88e6xxx/port.c   | 10 ++--
 drivers/net/dsa/mv88e6xxx/serdes.c | 78 +++++++++++++++---------------
 drivers/net/dsa/mv88e6xxx/serdes.h | 16 +++---
 5 files changed, 72 insertions(+), 67 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7a71c9902e73e..0a5e2740a79db 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -487,13 +487,14 @@ static int mv88e6xxx_serdes_pcs_get_state(struct dsa_switch *ds, int port,
 	u8 lane;
 	int err;
 
+	if (!chip->info->ops->serdes_pcs_get_state)
+		return -EOPNOTSUPP;
+
 	mv88e6xxx_reg_lock(chip);
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane && chip->info->ops->serdes_pcs_get_state)
+	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+	if (!err)
 		err = chip->info->ops->serdes_pcs_get_state(chip, port, lane,
 							    state);
-	else
-		err = -EOPNOTSUPP;
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -505,11 +506,12 @@ static int mv88e6xxx_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				       const unsigned long *advertise)
 {
 	const struct mv88e6xxx_ops *ops = chip->info->ops;
+	int err;
 	u8 lane;
 
 	if (ops->serdes_pcs_config) {
-		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane)
+		err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+		if (!err)
 			return ops->serdes_pcs_config(chip, port, lane, mode,
 						      interface, advertise);
 	}
@@ -528,8 +530,8 @@ static void mv88e6xxx_serdes_pcs_an_restart(struct dsa_switch *ds, int port)
 
 	if (ops->serdes_pcs_an_restart) {
 		mv88e6xxx_reg_lock(chip);
-		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane)
+		err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+		if (!err)
 			err = ops->serdes_pcs_an_restart(chip, port, lane);
 		mv88e6xxx_reg_unlock(chip);
 
@@ -543,11 +545,12 @@ static int mv88e6xxx_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
 					int speed, int duplex)
 {
 	const struct mv88e6xxx_ops *ops = chip->info->ops;
+	int err;
 	u8 lane;
 
 	if (!phylink_autoneg_inband(mode) && ops->serdes_pcs_link_up) {
-		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane)
+		err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+		if (!err)
 			return ops->serdes_pcs_link_up(chip, port, lane,
 						       speed, duplex);
 	}
@@ -2423,12 +2426,12 @@ static irqreturn_t mv88e6xxx_serdes_irq_thread_fn(int irq, void *dev_id)
 	struct mv88e6xxx_port *mvp = dev_id;
 	struct mv88e6xxx_chip *chip = mvp->chip;
 	irqreturn_t ret = IRQ_NONE;
-	int port = mvp->port;
+	int port = mvp->port, err;
 	u8 lane;
 
 	mv88e6xxx_reg_lock(chip);
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane)
+	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+	if (!err)
 		ret = mv88e6xxx_serdes_irq_status(chip, port, lane);
 	mv88e6xxx_reg_unlock(chip);
 
@@ -2493,8 +2496,8 @@ static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 	u8 lane;
 	int err;
 
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (!lane)
+	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+	if (err)
 		return 0;
 
 	if (on) {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 823ae89e5fcac..cc23810438dfe 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -494,7 +494,7 @@ struct mv88e6xxx_ops {
 			    bool up);
 
 	/* SERDES lane mapping */
-	u8 (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port);
+	int (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 
 	int (*serdes_pcs_get_state)(struct mv88e6xxx_chip *chip, int port,
 				    u8 lane, struct phylink_link_state *state);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 8128dc607cf46..9d5189f2474ce 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -429,8 +429,8 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	if (cmode == chip->ports[port].cmode && !force)
 		return 0;
 
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane) {
+	err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+	if (!err) {
 		if (chip->ports[port].serdes_irq) {
 			err = mv88e6xxx_serdes_irq_disable(chip, port, lane);
 			if (err)
@@ -458,9 +458,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 
 		chip->ports[port].cmode = cmode;
 
-		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (!lane)
-			return -ENODEV;
+		err = mv88e6xxx_serdes_get_lane(chip, port, &lane);
+		if (err)
+			return err;
 
 		err = mv88e6xxx_serdes_power_up(chip, port, lane);
 		if (err)
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 9c07b4f3d3454..9074d1097b614 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -230,25 +230,25 @@ int mv88e6352_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6352_serdes_write(chip, MII_BMCR, bmcr);
 }
 
-u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
 {
 	u8 cmode = chip->ports[port].cmode;
-	u8 lane = 0;
 
 	if ((cmode == MV88E6XXX_PORT_STS_CMODE_100BASEX) ||
 	    (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX) ||
-	    (cmode == MV88E6XXX_PORT_STS_CMODE_SGMII))
-		lane = 0xff; /* Unused */
+	    (cmode == MV88E6XXX_PORT_STS_CMODE_SGMII)) {
+		*lane = 0xff; /* Unused */
+		return 0;
+	}
 
-	return lane;
+	return -ENODEV;
 }
 
 static bool mv88e6352_port_has_serdes(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6xxx_serdes_get_lane(chip, port))
-		return true;
+	u8 lane;
 
-	return false;
+	return !mv88e6xxx_serdes_get_lane(chip, port, &lane);
 }
 
 struct mv88e6352_serdes_hw_stat {
@@ -411,60 +411,60 @@ void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	}
 }
 
-u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
 {
 	u8 cmode = chip->ports[port].cmode;
-	u8 lane = 0;
 
+	*lane = -1;
 	switch (port) {
 	case 5:
 		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-			lane = MV88E6341_PORT5_LANE;
+			*lane = MV88E6341_PORT5_LANE;
 		break;
 	}
 
-	return lane;
+	return *lane == -1 ? -ENODEV : 0;
 }
 
-u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
 {
 	u8 cmode = chip->ports[port].cmode;
-	u8 lane = 0;
 
+	*lane = -1;
 	switch (port) {
 	case 9:
 		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-			lane = MV88E6390_PORT9_LANE0;
+			*lane = MV88E6390_PORT9_LANE0;
 		break;
 	case 10:
 		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
-			lane = MV88E6390_PORT10_LANE0;
+			*lane = MV88E6390_PORT10_LANE0;
 		break;
 	}
 
-	return lane;
+	return *lane == -1 ? -ENODEV : 0;
 }
 
-u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane)
 {
 	u8 cmode_port = chip->ports[port].cmode;
 	u8 cmode_port10 = chip->ports[10].cmode;
 	u8 cmode_port9 = chip->ports[9].cmode;
-	u8 lane = 0;
 
+	*lane = -1;
 	switch (port) {
 	case 2:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
-				lane = MV88E6390_PORT9_LANE1;
+				*lane = MV88E6390_PORT9_LANE1;
 		break;
 	case 3:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
@@ -472,7 +472,7 @@ u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
-				lane = MV88E6390_PORT9_LANE2;
+				*lane = MV88E6390_PORT9_LANE2;
 		break;
 	case 4:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
@@ -480,14 +480,14 @@ u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
-				lane = MV88E6390_PORT9_LANE3;
+				*lane = MV88E6390_PORT9_LANE3;
 		break;
 	case 5:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_SGMII ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
-				lane = MV88E6390_PORT10_LANE1;
+				*lane = MV88E6390_PORT10_LANE1;
 		break;
 	case 6:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
@@ -495,7 +495,7 @@ u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
-				lane = MV88E6390_PORT10_LANE2;
+				*lane = MV88E6390_PORT10_LANE2;
 		break;
 	case 7:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
@@ -503,7 +503,7 @@ u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
 			if (cmode_port == MV88E6XXX_PORT_STS_CMODE_1000BASEX)
-				lane = MV88E6390_PORT10_LANE3;
+				*lane = MV88E6390_PORT10_LANE3;
 		break;
 	case 9:
 		if (cmode_port9 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
@@ -511,7 +511,7 @@ u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_XAUI ||
 		    cmode_port9 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			lane = MV88E6390_PORT9_LANE0;
+			*lane = MV88E6390_PORT9_LANE0;
 		break;
 	case 10:
 		if (cmode_port10 == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
@@ -519,11 +519,11 @@ u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_XAUI ||
 		    cmode_port10 == MV88E6XXX_PORT_STS_CMODE_RXAUI)
-			lane = MV88E6390_PORT10_LANE0;
+			*lane = MV88E6390_PORT10_LANE0;
 		break;
 	}
 
-	return lane;
+	return *lane == -1 ? -ENODEV : 0;
 }
 
 /* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
@@ -532,7 +532,6 @@ static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
 {
 	u16 val, new_val;
 	int err;
-
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
 				    MV88E6390_10G_CTRL1, &val);
 
@@ -590,7 +589,9 @@ static struct mv88e6390_serdes_hw_stat mv88e6390_serdes_hw_stats[] = {
 
 int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+	u8 lane;
+
+	if (mv88e6390_serdes_get_lane(chip, port, &lane))
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
@@ -600,9 +601,10 @@ int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data)
 {
 	struct mv88e6390_serdes_hw_stat *stat;
+	u8 lane;
 	int i;
 
-	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+	if (mv88e6390_serdes_get_lane(chip, port, &lane))
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -635,11 +637,10 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 			       uint64_t *data)
 {
 	struct mv88e6390_serdes_hw_stat *stat;
-	int lane;
+	u8 lane;
 	int i;
 
-	lane = mv88e6390_serdes_get_lane(chip, port);
-	if (lane == 0)
+	if (mv88e6390_serdes_get_lane(chip, port, &lane))
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -976,7 +977,9 @@ static const u16 mv88e6390_serdes_regs[] = {
 
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6xxx_serdes_get_lane(chip, port) == 0)
+	u8 lane;
+
+	if (mv88e6xxx_serdes_get_lane(chip, port, &lane))
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_regs) * sizeof(u16);
@@ -985,12 +988,11 @@ int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
 void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 {
 	u16 *p = _p;
-	int lane;
 	u16 reg;
+	u8 lane;
 	int i;
 
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane == 0)
+	if (mv88e6xxx_serdes_get_lane(chip, port, &lane))
 		return;
 
 	for (i = 0 ; i < ARRAY_SIZE(mv88e6390_serdes_regs); i++) {
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 14315f26228a3..95d04dab8d251 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -73,10 +73,10 @@
 #define MV88E6390_PG_CONTROL		0xf010
 #define MV88E6390_PG_CONTROL_ENABLE_PC		BIT(0)
 
-u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
+int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
+int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
+int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, u8 *lane);
 int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				u8 lane, unsigned int mode,
 				phy_interface_t interface,
@@ -130,13 +130,13 @@ int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
 void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 
 /* Return the (first) SERDES lane address a port is using, 0 otherwise. */
-static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
-					   int port)
+static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
+					    int port, u8 *lane)
 {
 	if (!chip->info->ops->serdes_get_lane)
-		return 0;
+		return -EOPNOTSUPP;
 
-	return chip->info->ops->serdes_get_lane(chip, port);
+	return chip->info->ops->serdes_get_lane(chip, port, lane);
 }
 
 static inline int mv88e6xxx_serdes_power_up(struct mv88e6xxx_chip *chip,
-- 
2.26.2

