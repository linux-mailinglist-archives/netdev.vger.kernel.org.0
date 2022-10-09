Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A575F9790
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 06:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiJJE42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 00:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiJJE4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 00:56:19 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E963DF05;
        Sun,  9 Oct 2022 21:56:07 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 5818C1884520;
        Mon, 10 Oct 2022 04:56:03 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 30299250556B;
        Mon, 10 Oct 2022 04:56:03 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 0)
        id 241969EC0002; Mon, 10 Oct 2022 04:56:03 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 365249120FED;
        Sun,  9 Oct 2022 17:41:34 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v7 net-next 7/9] net: dsa: mv88e6xxx: mac-auth/MAB implementation
Date:   Sun,  9 Oct 2022 19:40:50 +0200
Message-Id: <20221009174052.1927483-8-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221009174052.1927483-1-netdev@kapio-technology.com>
References: <20221009174052.1927483-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implementation for the Marvell mv88e6xxx chip series,
is based on handling ATU miss violations occurring when packets
ingress on a port that is locked. The mac address triggering
the ATU miss violation will be added to the ATU with a zero-DPV,
and is then communicated through switchdev to the bridge module,
which adds a fdb entry with the fdb locked flag set. The entry
is kept according to the bridges ageing time, thus simulating a
dynamic entry.

Additionally the driver will set the sticky and masked flags, as
the driver does not support roaming and forwarding from any port
to a locked entry.

As this is essentially a form of CPU based learning, the amount
of locked entries will be limited by a hardcoded value for now,
so as to prevent DOS attacks.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 drivers/net/dsa/mv88e6xxx/Makefile      |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c        |  76 +++++--
 drivers/net/dsa/mv88e6xxx/chip.h        |  19 ++
 drivers/net/dsa/mv88e6xxx/global1.h     |   1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c |  12 +-
 drivers/net/dsa/mv88e6xxx/port.c        |  15 +-
 drivers/net/dsa/mv88e6xxx/port.h        |   6 +
 drivers/net/dsa/mv88e6xxx/switchdev.c   | 284 ++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/switchdev.h   |  37 +++
 9 files changed, 429 insertions(+), 22 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.h

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index c8eca2b6f959..be903a983780 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -15,3 +15,4 @@ mv88e6xxx-objs += port_hidden.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
 mv88e6xxx-objs += serdes.o
 mv88e6xxx-objs += smi.o
+mv88e6xxx-objs += switchdev.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 352121cce77e..71843fe87f77 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -42,6 +42,7 @@
 #include "ptp.h"
 #include "serdes.h"
 #include "smi.h"
+#include "switchdev.h"
 
 static void assert_reg_lock(struct mv88e6xxx_chip *chip)
 {
@@ -924,6 +925,13 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
 	if (err)
 		dev_err(chip->dev,
 			"p%d: failed to force MAC link down\n", port);
+	else
+		if (mv88e6xxx_port_is_locked(chip, port)) {
+			err = mv88e6xxx_atu_locked_entry_flush(ds, port);
+			if (err)
+				dev_err(chip->dev,
+					"p%d: failed to clear locked entries\n", port);
+		}
 }
 
 static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
@@ -1690,6 +1698,13 @@ static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	if (mv88e6xxx_port_is_locked(chip, port)) {
+		err = mv88e6xxx_atu_locked_entry_flush(ds, port);
+		if (err)
+			dev_err(chip->ds->dev, "p%d: failed to clear locked entries: %d\n",
+				port, err);
+	}
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_fast_age_fid(chip, port, 0);
 	mv88e6xxx_reg_unlock(chip);
@@ -1726,11 +1741,11 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
 	return err;
 }
 
-static int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
-			      int (*cb)(struct mv88e6xxx_chip *chip,
-					const struct mv88e6xxx_vtu_entry *entry,
-					void *priv),
-			      void *priv)
+int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
+		       int (*cb)(struct mv88e6xxx_chip *chip,
+				 const struct mv88e6xxx_vtu_entry *entry,
+				 void *priv),
+		       void *priv)
 {
 	struct mv88e6xxx_vtu_entry entry = {
 		.vid = mv88e6xxx_max_vid(chip),
@@ -2731,6 +2746,9 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 	if (fdb_flags)
 		return 0;
 
+	if (mv88e6xxx_port_is_locked(chip, port))
+		mv88e6xxx_atu_locked_entry_find_purge(ds, port, addr, vid);
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid,
 					   MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC);
@@ -2744,16 +2762,21 @@ static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
 				  u16 fdb_flags, struct dsa_db db)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
+	bool locked_found = false;
+	int err = 0;
 
 	/* Ignore entries with flags set */
 	if (fdb_flags)
 		return 0;
 
-	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid, 0);
-	mv88e6xxx_reg_unlock(chip);
+	if (mv88e6xxx_port_is_locked(chip, port))
+		locked_found = mv88e6xxx_atu_locked_entry_find_purge(ds, port, addr, vid);
 
+	if (!locked_found) {
+		mv88e6xxx_reg_lock(chip);
+		err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid, 0);
+		mv88e6xxx_reg_unlock(chip);
+	}
 	return err;
 }
 
@@ -3849,11 +3872,18 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 static int mv88e6xxx_port_setup(struct dsa_switch *ds, int port)
 {
-	return mv88e6xxx_setup_devlink_regions_port(ds, port);
+	int err;
+
+	err = mv88e6xxx_setup_devlink_regions_port(ds, port);
+	if (!err)
+		return mv88e6xxx_init_violation_handler(ds, port);
+
+	return err;
 }
 
 static void mv88e6xxx_port_teardown(struct dsa_switch *ds, int port)
 {
+	mv88e6xxx_teardown_violation_handler(ds, port);
 	mv88e6xxx_teardown_devlink_regions_port(ds, port);
 }
 
@@ -6528,7 +6558,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 	const struct mv88e6xxx_ops *ops;
 
 	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-			   BR_BCAST_FLOOD | BR_PORT_LOCKED))
+			   BR_BCAST_FLOOD | BR_PORT_LOCKED | BR_PORT_MAB))
 		return -EINVAL;
 
 	ops = chip->info->ops;
@@ -6549,13 +6579,13 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err = -EOPNOTSUPP;
 
-	mv88e6xxx_reg_lock(chip);
-
 	if (flags.mask & BR_LEARNING) {
 		bool learning = !!(flags.val & BR_LEARNING);
 		u16 pav = learning ? (1 << port) : 0;
 
+		mv88e6xxx_reg_lock(chip);
 		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
+		mv88e6xxx_reg_unlock(chip);
 		if (err)
 			goto out;
 	}
@@ -6563,8 +6593,10 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 	if (flags.mask & BR_FLOOD) {
 		bool unicast = !!(flags.val & BR_FLOOD);
 
+		mv88e6xxx_reg_lock(chip);
 		err = chip->info->ops->port_set_ucast_flood(chip, port,
 							    unicast);
+		mv88e6xxx_reg_unlock(chip);
 		if (err)
 			goto out;
 	}
@@ -6572,8 +6604,10 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 	if (flags.mask & BR_MCAST_FLOOD) {
 		bool multicast = !!(flags.val & BR_MCAST_FLOOD);
 
+		mv88e6xxx_reg_lock(chip);
 		err = chip->info->ops->port_set_mcast_flood(chip, port,
 							    multicast);
+		mv88e6xxx_reg_unlock(chip);
 		if (err)
 			goto out;
 	}
@@ -6581,20 +6615,34 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 	if (flags.mask & BR_BCAST_FLOOD) {
 		bool broadcast = !!(flags.val & BR_BCAST_FLOOD);
 
+		mv88e6xxx_reg_lock(chip);
 		err = mv88e6xxx_port_broadcast_sync(chip, port, broadcast);
+		mv88e6xxx_reg_unlock(chip);
 		if (err)
 			goto out;
 	}
 
+	if (flags.mask & BR_PORT_MAB) {
+		chip->ports[port].mab = !!(flags.val & BR_PORT_MAB);
+
+		if (!chip->ports[port].mab)
+			err = mv88e6xxx_atu_locked_entry_flush(ds, port);
+		else
+			err = 0;
+	}
+
 	if (flags.mask & BR_PORT_LOCKED) {
 		bool locked = !!(flags.val & BR_PORT_LOCKED);
 
+		mv88e6xxx_reg_lock(chip);
 		err = mv88e6xxx_port_set_lock(chip, port, locked);
+		mv88e6xxx_reg_unlock(chip);
 		if (err)
 			goto out;
+
+		chip->ports[port].locked = locked;
 	}
 out:
-	mv88e6xxx_reg_unlock(chip);
 
 	return err;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..180fbcf596fa 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -280,6 +280,16 @@ struct mv88e6xxx_port {
 	unsigned int serdes_irq;
 	char serdes_irq_name[64];
 	struct devlink_region *region;
+
+	/* Locked port and MacAuth control flags */
+	bool locked;
+	bool mab;
+
+	/* List and maintenance of ATU locked entries */
+	struct mutex ale_list_lock;
+	struct list_head ale_list;
+	struct delayed_work ale_work;
+	int ale_cnt;
 };
 
 enum mv88e6xxx_region_id {
@@ -399,6 +409,9 @@ struct mv88e6xxx_chip {
 	int egress_dest_port;
 	int ingress_dest_port;
 
+	/* Keep the register written age time for easy access */
+	u8 age_time;
+
 	/* Per-port timestamping resources. */
 	struct mv88e6xxx_port_hwtstamp port_hwtstamp[DSA_MAX_PORTS];
 
@@ -802,6 +815,12 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
 	mutex_unlock(&chip->reg_lock);
 }
 
+int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
+		       int (*cb)(struct mv88e6xxx_chip *chip,
+				 const struct mv88e6xxx_vtu_entry *entry,
+				 void *priv),
+		       void *priv);
+
 int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
 
 #endif /* _MV88E6XXX_CHIP_H */
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 65958b2a0d3a..503fbf216670 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -136,6 +136,7 @@
 #define MV88E6XXX_G1_ATU_DATA_TRUNK				0x8000
 #define MV88E6XXX_G1_ATU_DATA_TRUNK_ID_MASK			0x00f0
 #define MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_MASK			0x3ff0
+#define MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_NO_EGRESS		0x0000
 #define MV88E6XXX_G1_ATU_DATA_STATE_MASK			0x000f
 #define MV88E6XXX_G1_ATU_DATA_STATE_UC_UNUSED			0x0000
 #define MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_1_OLDEST		0x0001
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index d9dfa1159cde..67907cd00b87 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -12,6 +12,8 @@
 
 #include "chip.h"
 #include "global1.h"
+#include "port.h"
+#include "switchdev.h"
 
 /* Offset 0x01: ATU FID Register */
 
@@ -54,6 +56,7 @@ int mv88e6xxx_g1_atu_set_age_time(struct mv88e6xxx_chip *chip,
 
 	/* Round to nearest multiple of coeff */
 	age_time = (msecs + coeff / 2) / coeff;
+	chip->age_time = age_time;
 
 	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_CTL, &val);
 	if (err)
@@ -426,6 +429,8 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 	if (err)
 		goto out;
 
+	mv88e6xxx_reg_unlock(chip);
+
 	spid = entry.state;
 
 	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
@@ -446,6 +451,12 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 				    "ATU miss violation for %pM portvec %x spid %d\n",
 				    entry.mac, entry.portvec, spid);
 		chip->ports[spid].atu_miss_violation++;
+
+		if (fid && chip->ports[spid].mab)
+			err = mv88e6xxx_handle_violation(chip, spid, &entry, fid,
+							 MV88E6XXX_G1_ATU_OP_MISS_VIOLATION);
+		if (err)
+			goto out;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
@@ -454,7 +465,6 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 				    entry.mac, entry.portvec, spid);
 		chip->ports[spid].atu_full_violation++;
 	}
-	mv88e6xxx_reg_unlock(chip);
 
 	return IRQ_HANDLED;
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 5c4195c635b0..67e457ce67ae 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -14,9 +14,11 @@
 #include <linux/phylink.h>
 
 #include "chip.h"
+#include "global1.h"
 #include "global2.h"
 #include "port.h"
 #include "serdes.h"
+#include "switchdev.h"
 
 int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int port, int reg,
 			u16 *val)
@@ -1240,13 +1242,12 @@ int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
 	if (err)
 		return err;
 
-	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, &reg);
-	if (err)
-		return err;
-
-	reg &= ~MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
-	if (locked)
-		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
+	reg = 0;
+	if (locked) {
+		reg = (1 << port);
+		reg |= MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG |
+			MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT;
+	}
 
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_ASSOC_VECTOR, reg);
 }
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index cb04243f37c1..9475bc6e95a2 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -231,6 +231,7 @@
 #define MV88E6XXX_PORT_ASSOC_VECTOR_LOCKED_PORT		0x2000
 #define MV88E6XXX_PORT_ASSOC_VECTOR_IGNORE_WRONG	0x1000
 #define MV88E6XXX_PORT_ASSOC_VECTOR_REFRESH_LOCKED	0x0800
+#define MV88E6XXX_PORT_ASSOC_VECTOR_PAV_MASK		0x07ff
 
 /* Offset 0x0C: Port ATU Control */
 #define MV88E6XXX_PORT_ATU_CTL		0x0c
@@ -375,6 +376,11 @@ int mv88e6xxx_port_set_pvid(struct mv88e6xxx_chip *chip, int port, u16 pvid);
 int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
 			    bool locked);
 
+static inline bool mv88e6xxx_port_is_locked(struct mv88e6xxx_chip *chip, int port)
+{
+	return chip->ports[port].locked;
+}
+
 int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
 				  u16 mode);
 int mv88e6095_port_tag_remap(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/switchdev.c b/drivers/net/dsa/mv88e6xxx/switchdev.c
new file mode 100644
index 000000000000..327dbc0cfc3c
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/switchdev.c
@@ -0,0 +1,284 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * switchdev.c
+ *
+ *	Authors:
+ *	Hans J. Schultz		<hans.schultz@westermo.com>
+ *
+ */
+
+#include <net/switchdev.h>
+#include <linux/list.h>
+#include "chip.h"
+#include "global1.h"
+#include "switchdev.h"
+
+static void mv88e6xxx_atu_locked_entry_purge(struct mv88e6xxx_atu_locked_entry *ale,
+					     bool notify, bool take_nl_lock)
+{
+	struct switchdev_notifier_fdb_info info = {
+		.addr = ale->mac,
+		.vid = ale->vid,
+		.locked = true,
+		.offloaded = true,
+	};
+	struct mv88e6xxx_atu_entry entry;
+	struct net_device *brport;
+	struct dsa_port *dp;
+
+	entry.portvec = MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_NO_EGRESS;
+	entry.state = MV88E6XXX_G1_ATU_DATA_STATE_UC_UNUSED;
+	entry.trunk = false;
+	ether_addr_copy(entry.mac, ale->mac);
+
+	mv88e6xxx_reg_lock(ale->chip);
+	mv88e6xxx_g1_atu_loadpurge(ale->chip, ale->fid, &entry);
+	mv88e6xxx_reg_unlock(ale->chip);
+
+	dp = dsa_to_port(ale->chip->ds, ale->port);
+
+	if (notify) {
+		if (take_nl_lock)
+			rtnl_lock();
+		brport = dsa_port_to_bridge_port(dp);
+
+		if (brport) {
+			call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
+						 brport, &info.info, NULL);
+		} else {
+			dev_err(ale->chip->dev, "No bridge port for dsa port belonging to port %d\n",
+				ale->port);
+		}
+		if (take_nl_lock)
+			rtnl_unlock();
+	}
+
+	list_del(&ale->list);
+	kfree(ale);
+}
+
+static void mv88e6xxx_atu_locked_entry_cleanup(struct work_struct *work)
+{
+	struct mv88e6xxx_port *p = container_of(work, struct mv88e6xxx_port, ale_work.work);
+	struct mv88e6xxx_atu_locked_entry *ale, *tmp;
+
+	mutex_lock(&p->ale_list_lock);
+	list_for_each_entry_safe(ale, tmp, &p->ale_list, list) {
+		if (time_after(jiffies, ale->expires)) {
+			mv88e6xxx_atu_locked_entry_purge(ale, true, true);
+			p->ale_cnt--;
+		}
+	}
+	mutex_unlock(&p->ale_list_lock);
+
+	mod_delayed_work(system_long_wq, &p->ale_work, msecs_to_jiffies(100));
+}
+
+static int mv88e6xxx_new_atu_locked_entry(struct mv88e6xxx_chip *chip, const unsigned char *addr,
+					  int port, u16 fid, u16 vid,
+					  struct mv88e6xxx_atu_locked_entry **alep)
+{
+	struct mv88e6xxx_atu_locked_entry *ale;
+	unsigned long now, age_time;
+
+	ale = kmalloc(sizeof(*ale), GFP_ATOMIC);
+	if (!ale)
+		return -ENOMEM;
+
+	ether_addr_copy(ale->mac, addr);
+	ale->chip = chip;
+	ale->port = port;
+	ale->fid = fid;
+	ale->vid = vid;
+	now = jiffies;
+	age_time = chip->age_time * chip->info->age_time_coeff;
+	ale->expires = now + age_time;
+
+	*alep = ale;
+	return 0;
+}
+
+struct mv88e6xxx_fid_search_ctx {
+	u16 fid_search;
+	u16 vid_found;
+};
+
+static int mv88e6xxx_find_vid_on_matching_fid(struct mv88e6xxx_chip *chip,
+					      const struct mv88e6xxx_vtu_entry *entry,
+					      void *priv)
+{
+	struct mv88e6xxx_fid_search_ctx *ctx = priv;
+
+	if (ctx->fid_search == entry->fid) {
+		ctx->vid_found = entry->vid;
+		return 1;
+	}
+
+	return 0;
+}
+
+int mv88e6xxx_handle_violation(struct mv88e6xxx_chip *chip, int port,
+			       struct mv88e6xxx_atu_entry *entry,
+			       u16 fid, u16 type)
+{
+	struct switchdev_notifier_fdb_info info = {
+		.addr = entry->mac,
+		.vid = 0,
+		.is_local = true,
+		.locked = true,
+		.blackhole = true,
+		.offloaded = true,
+	};
+	struct mv88e6xxx_atu_locked_entry *ale;
+	struct mv88e6xxx_fid_search_ctx ctx;
+	struct net_device *brport;
+	struct mv88e6xxx_port *p;
+	struct dsa_port *dp;
+	int err;
+
+	if (!mv88e6xxx_is_invalid_port(chip, port))
+		p = &chip->ports[port];
+	else
+		return -ENODEV;
+
+	ctx.fid_search = fid;
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_vtu_walk(chip, mv88e6xxx_find_vid_on_matching_fid, &ctx);
+	mv88e6xxx_reg_unlock(chip);
+	if (err < 0)
+		return err;
+	if (err == 1)
+		info.vid = ctx.vid_found;
+	else
+		return -ENODATA;
+
+	switch (type) {
+	case MV88E6XXX_G1_ATU_OP_MISS_VIOLATION:
+		mutex_lock(&p->ale_list_lock);
+		if (p->ale_cnt >= ATU_LOCKED_ENTRIES_MAX)
+			goto exit;
+		mutex_unlock(&p->ale_list_lock);
+		entry->portvec = MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_NO_EGRESS;
+		entry->state = MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC;
+		entry->trunk = false;
+
+		mv88e6xxx_reg_lock(chip);
+		err = mv88e6xxx_g1_atu_loadpurge(chip, fid, entry);
+		if (err)
+			goto fail;
+		mv88e6xxx_reg_unlock(chip);
+
+		dp = dsa_to_port(chip->ds, port);
+		err = mv88e6xxx_new_atu_locked_entry(chip, entry->mac, port, fid,
+						     info.vid, &ale);
+		if (err)
+			return err;
+
+		mutex_lock(&p->ale_list_lock);
+		list_add(&ale->list, &p->ale_list);
+		p->ale_cnt++;
+		mutex_unlock(&p->ale_list_lock);
+
+		rtnl_lock();
+		brport = dsa_port_to_bridge_port(dp);
+		if (!brport) {
+			rtnl_unlock();
+			return -ENODEV;
+		}
+		err = call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
+					       brport, &info.info, NULL);
+		rtnl_unlock();
+		break;
+	}
+
+	return err;
+
+fail:
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+
+exit:
+	mutex_unlock(&p->ale_list_lock);
+	return 0;
+}
+
+bool mv88e6xxx_atu_locked_entry_find_purge(struct dsa_switch *ds, int port,
+					   const unsigned char *addr, u16 vid)
+{
+	struct mv88e6xxx_atu_locked_entry *ale, *tmp;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_port *p;
+	bool found = false;
+
+	p = &chip->ports[port];
+	mutex_lock(&p->ale_list_lock);
+	list_for_each_entry_safe(ale, tmp, &p->ale_list, list) {
+		if (ether_addr_equal(ale->mac, addr) == 0) {
+			if (ale->vid == vid) {
+				mv88e6xxx_atu_locked_entry_purge(ale, false, false);
+				p->ale_cnt--;
+				found = true;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&p->ale_list_lock);
+	return found;
+}
+
+int mv88e6xxx_atu_locked_entry_flush(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_atu_locked_entry *ale, *tmp;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_port *p;
+
+	if (!mv88e6xxx_is_invalid_port(chip, port))
+		p = &chip->ports[port];
+	else
+		return -ENODEV;
+
+	mutex_lock(&p->ale_list_lock);
+	list_for_each_entry_safe(ale, tmp, &p->ale_list, list) {
+		mv88e6xxx_atu_locked_entry_purge(ale, true, false);
+		p->ale_cnt--;
+	}
+	mutex_unlock(&p->ale_list_lock);
+
+	return 0;
+}
+
+int mv88e6xxx_init_violation_handler(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_port *p;
+
+	if (!mv88e6xxx_is_invalid_port(chip, port))
+		p = &chip->ports[port];
+	else
+		return -ENODEV;
+
+	INIT_LIST_HEAD(&p->ale_list);
+	mutex_init(&p->ale_list_lock);
+	p->ale_cnt = 0;
+	INIT_DELAYED_WORK(&p->ale_work, mv88e6xxx_atu_locked_entry_cleanup);
+	mod_delayed_work(system_long_wq, &p->ale_work, msecs_to_jiffies(500));
+
+	return 0;
+}
+
+int mv88e6xxx_teardown_violation_handler(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_port *p;
+
+	if (!mv88e6xxx_is_invalid_port(chip, port))
+		p = &chip->ports[port];
+	else
+		return -ENODEV;
+
+	cancel_delayed_work(&p->ale_work);
+	mv88e6xxx_atu_locked_entry_flush(ds, port);
+	mutex_destroy(&p->ale_list_lock);
+
+	return 0;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/switchdev.h b/drivers/net/dsa/mv88e6xxx/switchdev.h
new file mode 100644
index 000000000000..df2005c36f47
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/switchdev.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * switchdev.h
+ *
+ *	Authors:
+ *	Hans J. Schultz		<hans.schultz@westermo.com>
+ *
+ */
+
+#ifndef DRIVERS_NET_DSA_MV88E6XXX_SWITCHDEV_H_
+#define DRIVERS_NET_DSA_MV88E6XXX_SWITCHDEV_H_
+
+#include <net/switchdev.h>
+#include "chip.h"
+
+#define ATU_LOCKED_ENTRIES_MAX	64
+
+struct mv88e6xxx_atu_locked_entry {
+	struct		list_head list;
+	struct		mv88e6xxx_chip *chip;
+	int		port;
+	u8		mac[ETH_ALEN];
+	u16		fid;
+	u16		vid;
+	unsigned long	expires;
+};
+
+int mv88e6xxx_handle_violation(struct mv88e6xxx_chip *chip, int port,
+			       struct mv88e6xxx_atu_entry *entry,
+			       u16 fid, u16 type);
+bool mv88e6xxx_atu_locked_entry_find_purge(struct dsa_switch *ds, int port,
+					   const unsigned char *addr, u16 vid);
+int mv88e6xxx_atu_locked_entry_flush(struct dsa_switch *ds, int port);
+int mv88e6xxx_init_violation_handler(struct dsa_switch *ds, int port);
+int mv88e6xxx_teardown_violation_handler(struct dsa_switch *ds, int port);
+
+#endif /* DRIVERS_NET_DSA_MV88E6XXX_SWITCHDEV_H_ */
-- 
2.34.1

