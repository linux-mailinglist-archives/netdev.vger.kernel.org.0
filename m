Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052DB626BA5
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 21:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiKLUit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 15:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiKLUir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 15:38:47 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C5DE021;
        Sat, 12 Nov 2022 12:38:41 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 9C6D418836DC;
        Sat, 12 Nov 2022 20:38:39 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 934DD250030B;
        Sat, 12 Nov 2022 20:38:39 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 8571E91201E4; Sat, 12 Nov 2022 20:38:39 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 3242691201E3;
        Sat, 12 Nov 2022 20:38:39 +0000 (UTC)
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
Subject: [PATCH v8 net-next 2/2] net: dsa: mv88e6xxx: mac-auth/MAB implementation
Date:   Sat, 12 Nov 2022 21:37:48 +0100
Message-Id: <20221112203748.68995-3-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221112203748.68995-1-netdev@kapio-technology.com>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
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
SWITCHDEV_FDB_ADD_TO_BRIDGE event, that wil incurr the bridge module,
to add a locked FDB entry. This bridge FDB entry will not age out as
it has the extern_learn flag set.

Userspace daemons can listen to these events and either accept or deny
access for the host, by either replacing the locked FDB entry with a
simple entry or leave the locked entry.

If the host MAC address is already present on another port, a ATU
member violation will occur, but to no real effect. Statistics on these
violations can be shown with the command and example output of interest:

NIC statistics:
...
     atu_member_violation: 36
     atu_miss_violation: 23
...

Where ethX is the interface of the MAB enabled port.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 drivers/net/dsa/mv88e6xxx/Makefile      |  1 +
 drivers/net/dsa/mv88e6xxx/chip.c        | 19 ++++--
 drivers/net/dsa/mv88e6xxx/chip.h        | 10 ++++
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 10 +++-
 drivers/net/dsa/mv88e6xxx/port.h        |  6 ++
 drivers/net/dsa/mv88e6xxx/switchdev.c   | 77 +++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/switchdev.h   | 19 ++++++
 7 files changed, 135 insertions(+), 7 deletions(-)
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
index ccfa4751d3b7..efc0085a5616 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1726,11 +1726,11 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
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
@@ -6524,7 +6524,7 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 	const struct mv88e6xxx_ops *ops;
 
 	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-			   BR_BCAST_FLOOD | BR_PORT_LOCKED))
+			   BR_BCAST_FLOOD | BR_PORT_LOCKED | BR_PORT_MAB))
 		return -EINVAL;
 
 	ops = chip->info->ops;
@@ -6582,12 +6582,19 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 			goto out;
 	}
 
+	if (flags.mask & BR_PORT_MAB) {
+		chip->ports[port].mab = !!(flags.val & BR_PORT_MAB);
+		err = 0;
+	}
+
 	if (flags.mask & BR_PORT_LOCKED) {
 		bool locked = !!(flags.val & BR_PORT_LOCKED);
 
 		err = mv88e6xxx_port_set_lock(chip, port, locked);
 		if (err)
 			goto out;
+
+		chip->ports[port].locked = locked;
 	}
 out:
 	mv88e6xxx_reg_unlock(chip);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..3b951cd0e6f8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -280,6 +280,10 @@ struct mv88e6xxx_port {
 	unsigned int serdes_irq;
 	char serdes_irq_name[64];
 	struct devlink_region *region;
+
+	/* Locked port and MacAuth control flags */
+	bool locked;
+	bool mab;
 };
 
 enum mv88e6xxx_region_id {
@@ -802,6 +806,12 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
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
index 8a874b6fc8e1..0a57f4e7dd46 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -12,6 +12,7 @@
 
 #include "chip.h"
 #include "global1.h"
+#include "switchdev.h"
 
 /* Offset 0x01: ATU FID Register */
 
@@ -426,6 +427,8 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 	if (err)
 		goto out;
 
+	mv88e6xxx_reg_unlock(chip);
+
 	spid = entry.state;
 
 	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
@@ -446,6 +449,12 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 				    "ATU miss violation for %pM portvec %x spid %d\n",
 				    entry.mac, entry.portvec, spid);
 		chip->ports[spid].atu_miss_violation++;
+
+		if (fid && chip->ports[spid].mab)
+			err = mv88e6xxx_handle_violation(chip, spid, &entry,
+							 fid, MV88E6XXX_G1_ATU_OP_MISS_VIOLATION);
+		if (err)
+			goto out;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
@@ -454,7 +463,6 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 				    entry.mac, entry.portvec, spid);
 		chip->ports[spid].atu_full_violation++;
 	}
-	mv88e6xxx_reg_unlock(chip);
 
 	return IRQ_HANDLED;
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index aec9d4fd20e3..bd90a02865a0 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -377,6 +377,12 @@ int mv88e6xxx_port_set_pvid(struct mv88e6xxx_chip *chip, int port, u16 pvid);
 int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
 			    bool locked);
 
+static inline bool mv88e6xxx_port_is_locked(struct mv88e6xxx_chip *chip,
+					    int port)
+{
+	return chip->ports[port].locked;
+}
+
 int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
 				  u16 mode);
 int mv88e6095_port_tag_remap(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/switchdev.c b/drivers/net/dsa/mv88e6xxx/switchdev.c
new file mode 100644
index 000000000000..000778550532
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/switchdev.c
@@ -0,0 +1,77 @@
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
+#include "chip.h"
+#include "global1.h"
+
+struct mv88e6xxx_fid_search_ctx {
+	u16 fid_search;
+	u16 vid_found;
+};
+
+static int mv88e6xxx_find_vid(struct mv88e6xxx_chip *chip,
+			      const struct mv88e6xxx_vtu_entry *entry,
+			      void *priv)
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
+		.locked = true,
+	};
+	struct mv88e6xxx_fid_search_ctx ctx;
+	struct net_device *brport;
+	struct dsa_port *dp;
+	int err;
+
+	if (mv88e6xxx_is_invalid_port(chip, port))
+		return -ENODEV;
+
+	ctx.fid_search = fid;
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6xxx_vtu_walk(chip, mv88e6xxx_find_vid, &ctx);
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
+		dp = dsa_to_port(chip->ds, port);
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
+}
diff --git a/drivers/net/dsa/mv88e6xxx/switchdev.h b/drivers/net/dsa/mv88e6xxx/switchdev.h
new file mode 100644
index 000000000000..ccc10a9d4072
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/switchdev.h
@@ -0,0 +1,19 @@
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
+#include "chip.h"
+
+int mv88e6xxx_handle_violation(struct mv88e6xxx_chip *chip, int port,
+			       struct mv88e6xxx_atu_entry *entry,
+			       u16 fid, u16 type);
+
+#endif /* DRIVERS_NET_DSA_MV88E6XXX_SWITCHDEV_H_ */
-- 
2.34.1

