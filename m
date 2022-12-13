Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2D264BB59
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 18:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbiLMRsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 12:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbiLMRsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 12:48:11 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2287813F07;
        Tue, 13 Dec 2022 09:48:08 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 4F4E618839C2;
        Tue, 13 Dec 2022 17:48:07 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 354A82500015;
        Tue, 13 Dec 2022 17:48:07 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 204B791201E3; Tue, 13 Dec 2022 17:48:07 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id C697091201E4;
        Tue, 13 Dec 2022 17:48:06 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB implementation
Date:   Tue, 13 Dec 2022 18:46:50 +0100
Message-Id: <20221213174650.670767-4-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221213174650.670767-1-netdev@kapio-technology.com>
References: <20221213174650.670767-1-netdev@kapio-technology.com>
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

This implementation for the Marvell mv88e6xxx chip series, is based on
handling ATU miss violations occurring when packets ingress on a port
that is locked with learning on. This will trigger a
SWITCHDEV_FDB_ADD_TO_BRIDGE event, which will result in the bridge module
adding a locked FDB entry. This bridge FDB entry will not age out as
it has the extern_learn flag set.

Userspace daemons can listen to these events and either accept or deny
access for the host, by either replacing the locked FDB entry with a
simple entry or leave the locked entry.

If the host MAC address is already present on another port, a ATU
member violation will occur, but to no real effect, and the packet will
be dropped in hardware. Statistics on these violations can be shown with
the command and example output of interest:

ethtool -S ethX
NIC statistics:
...
     atu_member_violation: 5
     atu_miss_violation: 23
...

Where ethX is the interface of the MAB enabled port.

Furthermore, as added vlan interfaces where the vid is not added to the
VTU will cause ATU miss violations reporting the FID as
MV88E6XXX_FID_STANDALONE, we need to check and skip the miss violations
handling in this case.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 drivers/net/dsa/mv88e6xxx/Makefile      |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c        | 18 ++++--
 drivers/net/dsa/mv88e6xxx/chip.h        | 15 +++++
 drivers/net/dsa/mv88e6xxx/global1_atu.c |  8 +++
 drivers/net/dsa/mv88e6xxx/switchdev.c   | 83 +++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/switchdev.h   | 19 ++++++
 6 files changed, 138 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.h

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index 49bf358b9c4f..1409e691ab77 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -15,6 +15,7 @@ mv88e6xxx-objs += port_hidden.o
 mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
 mv88e6xxx-objs += serdes.o
 mv88e6xxx-objs += smi.o
+mv88e6xxx-objs += switchdev.o
 mv88e6xxx-objs += trace.o
 
 # for tracing framework to find trace.h
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d5930b287db4..2682c2b29346 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1729,11 +1729,11 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
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
@@ -6527,7 +6527,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 	const struct mv88e6xxx_ops *ops;
 
 	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-			   BR_BCAST_FLOOD | BR_PORT_LOCKED))
+			   BR_BCAST_FLOOD | BR_PORT_LOCKED | BR_PORT_MAB))
 		return -EINVAL;
 
 	ops = chip->info->ops;
@@ -6585,6 +6585,12 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 			goto out;
 	}
 
+	if (flags.mask & BR_PORT_MAB) {
+		bool mab = !!(flags.val & BR_PORT_MAB);
+
+		mv88e6xxx_port_set_mab(chip, port, mab);
+	}
+
 	if (flags.mask & BR_PORT_LOCKED) {
 		bool locked = !!(flags.val & BR_PORT_LOCKED);
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..f635a5bb47ce 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -280,6 +280,9 @@ struct mv88e6xxx_port {
 	unsigned int serdes_irq;
 	char serdes_irq_name[64];
 	struct devlink_region *region;
+
+	/* MacAuth Bypass control flag */
+	bool mab;
 };
 
 enum mv88e6xxx_region_id {
@@ -784,6 +787,12 @@ static inline bool mv88e6xxx_is_invalid_port(struct mv88e6xxx_chip *chip, int po
 	return (chip->info->invalid_port_mask & BIT(port)) != 0;
 }
 
+static inline void mv88e6xxx_port_set_mab(struct mv88e6xxx_chip *chip,
+					  int port, bool mab)
+{
+	chip->ports[port].mab = mab;
+}
+
 int mv88e6xxx_read(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
 int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
 int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
@@ -802,6 +811,12 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
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
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 34203e112eef..fc020161b7cf 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -12,6 +12,7 @@
 
 #include "chip.h"
 #include "global1.h"
+#include "switchdev.h"
 #include "trace.h"
 
 /* Offset 0x01: ATU FID Register */
@@ -443,6 +444,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 						   entry.portvec, entry.mac,
 						   fid);
 		chip->ports[spid].atu_miss_violation++;
+
+		if (fid != MV88E6XXX_FID_STANDALONE && chip->ports[spid].mab) {
+			err = mv88e6xxx_handle_miss_violation(chip, spid,
+							      &entry, fid);
+			if (err)
+				goto out;
+		}
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
diff --git a/drivers/net/dsa/mv88e6xxx/switchdev.c b/drivers/net/dsa/mv88e6xxx/switchdev.c
new file mode 100644
index 000000000000..4c346a884fb2
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/switchdev.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * switchdev.c
+ *
+ *	Authors:
+ *	Hans J. Schultz		<netdev@kapio-technology.com>
+ *
+ */
+
+#include <net/switchdev.h>
+#include "chip.h"
+#include "global1.h"
+#include "switchdev.h"
+
+struct mv88e6xxx_fid_search_ctx {
+	u16 fid_search;
+	u16 vid_found;
+};
+
+static int __mv88e6xxx_find_vid(struct mv88e6xxx_chip *chip,
+				const struct mv88e6xxx_vtu_entry *entry,
+				void *priv)
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
+static int mv88e6xxx_find_vid(struct mv88e6xxx_chip *chip, u16 fid, u16 *vid)
+{
+	struct mv88e6xxx_fid_search_ctx ctx;
+	int err;
+
+	ctx.fid_search = fid;
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_vtu_walk(chip, __mv88e6xxx_find_vid, &ctx);
+	mv88e6xxx_reg_unlock(chip);
+	if (err < 0)
+		return err;
+	if (err == 1)
+		*vid = ctx.vid_found;
+	else
+		return -ENOENT;
+
+	return 0;
+}
+
+int mv88e6xxx_handle_miss_violation(struct mv88e6xxx_chip *chip, int port,
+				    struct mv88e6xxx_atu_entry *entry, u16 fid)
+{
+	struct switchdev_notifier_fdb_info info = {
+		.addr = entry->mac,
+		.locked = true,
+	};
+	struct net_device *brport;
+	struct dsa_port *dp;
+	u16 vid;
+	int err;
+
+	err = mv88e6xxx_find_vid(chip, fid, &vid);
+	if (err)
+		return err;
+
+	info.vid = vid;
+	dp = dsa_to_port(chip->ds, port);
+
+	rtnl_lock();
+	brport = dsa_port_to_bridge_port(dp);
+	if (!brport) {
+		rtnl_unlock();
+		return -ENODEV;
+	}
+	err = call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
+				       brport, &info.info, NULL);
+	rtnl_unlock();
+
+	return err;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/switchdev.h b/drivers/net/dsa/mv88e6xxx/switchdev.h
new file mode 100644
index 000000000000..62214f9d62b0
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/switchdev.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * switchdev.h
+ *
+ *	Authors:
+ *	Hans J. Schultz		<netdev@kapio-technology.com>
+ *
+ */
+
+#ifndef _MV88E6XXX_SWITCHDEV_H_
+#define _MV88E6XXX_SWITCHDEV_H_
+
+#include "chip.h"
+
+int mv88e6xxx_handle_miss_violation(struct mv88e6xxx_chip *chip, int port,
+				    struct mv88e6xxx_atu_entry *entry,
+				    u16 fid);
+
+#endif /* _MV88E6XXX_SWITCHDEV_H_ */
-- 
2.34.1

