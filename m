Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1836B782
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbhDZRF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235203AbhDZRFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:05:37 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5B3C06138C
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:04:54 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id y4so49137076lfl.10
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=yKMCo3mPhrZ7sJPdBS64GxI1OnhjCpUrX0VbNAl+h84=;
        b=LOlH96YAZjSjX+pTnrjjLbz1OUNxMfEVOSOcKxp/tsjp9n1t1Zjx0r5u8ihoOv00D5
         uCLzTk/gNmNw5JBPuzaFt8RPD+agNDnbRmg/8WyqjYxOHxrzsJgWEpq4B29cYLFNOa1T
         3G3/1FDJY2GkehMdncswfhP4hRa83LSWVIUsuekIKJeTOcZnuZVyOoWPHkGQlWJQ0O4D
         pIoSmdyZKlMTfIvADyFaFFpf3YlGaZ+Wml8kYwp/xUa6C0wIr4zMT/Pot5oFtxm1OD7u
         +m6h/XWUSCOB6K9OVCykPBKgxC+tLMK8i1ejQ6Njl4bVwI5SG5O92WDX3yhij2MyykCq
         ACmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=yKMCo3mPhrZ7sJPdBS64GxI1OnhjCpUrX0VbNAl+h84=;
        b=p7wEMFjKAgJ8iQSUu+8W6Ps8YjMXms7YVfFfKRz1FRP9xNgpThA/Zcz44bnzioVcvk
         w4URENNTYKPZd7twWvOAu7aYsLtJp4lDqJ1VU7rW4EdGobBt3qPXpfSB9e12ivd0ZOPB
         o+9NX7BhxKBusO6Z2mPu/Y3kkKqLnVzOKJm9d3lFXCKabVZ/KcHrRDPkhNn2ywH2MpxE
         YNBcOvv9YEfdE1bIzDzDvAuYkPR9KezNs2sz/C4sWkTW1JMIdWzPJxvbpBwglQ6BShxJ
         842Q2FTgasMbErlmgcA+/+zPtqqZfXEwirqtZk1yalTFU+DeJFaA8EFcRj5Ynzuqdsyc
         8PhQ==
X-Gm-Message-State: AOAM530mmGj9Z1LCWR9AW9v/sfIXaGj5kDTz0U9rWn5Vfq96VqeIVMpJ
        +6N6H36joEvPjIrNrv2vtOwe0Q==
X-Google-Smtp-Source: ABdhPJxqOTMcL7SlRN+5JOCgPnJrZNhi9qvc1VVqJ46aydzwhI2e/PhlwK/ZEoed314+ZEfESHPkkQ==
X-Received: by 2002:ac2:5f42:: with SMTP id 2mr6995959lfz.85.1619456693328;
        Mon, 26 Apr 2021 10:04:53 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c18sm59140ljd.66.2021.04.26.10.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 10:04:52 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        jiri@resnulli.us, idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [RFC net-next 7/9] net: dsa: mv88e6xxx: Allocate a virtual DSA port for each bridge
Date:   Mon, 26 Apr 2021 19:04:09 +0200
Message-Id: <20210426170411.1789186-8-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426170411.1789186-1-tobias@waldekranz.com>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the near future we want to offload transmission of both unicasts
and multicasts from a bridge by sending a single FORWARD and use the
switches' config to determine the destination(s). Much in the same way
as we have already relied on them to do between user ports in the
past.

As isolation between bridges must still be maintained, we need to pass
an identifier in the DSA tag that the switches can use to determine
the set of physical ports that make up a particular flooding domain.

Therefore: allocate a DSA device/port tuple that is not used by any
physical device to each bridge we are offloading. We can then in
upcoming changes use this tuple to setup cross-chip port based VLANs
to restrict the set of valid egress ports to only contain the ports
that are offloading the same bridge.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/Makefile |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c   |  11 +++
 drivers/net/dsa/mv88e6xxx/dst.c    | 127 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/dst.h    |  12 +++
 include/net/dsa.h                  |   5 ++
 5 files changed, 156 insertions(+)
 create mode 100644 drivers/net/dsa/mv88e6xxx/dst.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/dst.h

diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
index c8eca2b6f959..20e00695b28d 100644
--- a/drivers/net/dsa/mv88e6xxx/Makefile
+++ b/drivers/net/dsa/mv88e6xxx/Makefile
@@ -2,6 +2,7 @@
 obj-$(CONFIG_NET_DSA_MV88E6XXX) += mv88e6xxx.o
 mv88e6xxx-objs := chip.o
 mv88e6xxx-objs += devlink.o
+mv88e6xxx-objs += dst.o
 mv88e6xxx-objs += global1.o
 mv88e6xxx-objs += global1_atu.o
 mv88e6xxx-objs += global1_vtu.o
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index eca285aaf72f..06ef654472b7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -33,6 +33,7 @@
 
 #include "chip.h"
 #include "devlink.h"
+#include "dst.h"
 #include "global1.h"
 #include "global2.h"
 #include "hwtstamp.h"
@@ -2371,6 +2372,10 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	err = mv88e6xxx_dst_bridge_join(ds->dst, br);
+	if (err)
+		return err;
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_bridge_map(chip, br);
 	mv88e6xxx_reg_unlock(chip);
@@ -2388,6 +2393,8 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 	    mv88e6xxx_port_vlan_map(chip, port))
 		dev_err(ds->dev, "failed to remap in-chip Port VLAN\n");
 	mv88e6xxx_reg_unlock(chip);
+
+	mv88e6xxx_dst_bridge_leave(ds->dst, br);
 }
 
 static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
@@ -3027,6 +3034,10 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	mv88e6xxx_reg_lock(chip);
 
+	err = mv88e6xxx_dst_add_chip(chip);
+	if (err)
+		goto unlock;
+
 	if (chip->info->ops->setup_errata) {
 		err = chip->info->ops->setup_errata(chip);
 		if (err)
diff --git a/drivers/net/dsa/mv88e6xxx/dst.c b/drivers/net/dsa/mv88e6xxx/dst.c
new file mode 100644
index 000000000000..399a818063bf
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/dst.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * mv88e6xxx global DSA switch tree state
+ */
+
+#include <linux/bitmap.h>
+#include <linux/dsa/mv88e6xxx.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <net/dsa.h>
+
+#include "chip.h"
+#include "dst.h"
+#include "global2.h"
+
+struct mv88e6xxx_br {
+	struct list_head list;
+
+	struct net_device *brdev;
+	u8 dev;
+	u8 port;
+};
+
+struct mv88e6xxx_dst {
+	struct list_head bridges;
+
+	DECLARE_BITMAP(busy_ports, MV88E6XXX_MAX_PVT_ENTRIES);
+
+#define DEV_PORT_TO_BIT(_dev, _port)			\
+	((_dev) * MV88E6XXX_MAX_PVT_PORTS + (_port))
+#define DEV_FROM_BIT(_bit) ((_bit) / MV88E6XXX_MAX_PVT_PORTS)
+#define PORT_FROM_BIT(_bit) ((_bit) % (MV88E6XXX_MAX_PVT_PORTS))
+};
+
+int mv88e6xxx_dst_bridge_join(struct dsa_switch_tree *dst,
+			      struct net_device *brdev)
+{
+	struct mv88e6xxx_dst *mvdst = dst->priv;
+	struct mv88e6xxx_br *mvbr;
+	unsigned int bit;
+
+	list_for_each_entry(mvbr, &mvdst->bridges, list) {
+		if (mvbr->brdev == brdev)
+			return 0;
+	}
+
+	bit = find_first_zero_bit(mvdst->busy_ports,
+				  MV88E6XXX_MAX_PVT_ENTRIES);
+
+	if (bit >= MV88E6XXX_MAX_PVT_ENTRIES) {
+		pr_err("Unable to allocate virtual port for %s in DSA tree %d\n",
+		       netdev_name(brdev), dst->index);
+		return -ENOSPC;
+	}
+
+	mvbr = kzalloc(sizeof(*mvbr), GFP_KERNEL);
+	if (!mvbr)
+		return -ENOMEM;
+
+	mvbr->brdev = brdev;
+	mvbr->dev = DEV_FROM_BIT(bit);
+	mvbr->port = PORT_FROM_BIT(bit);
+
+	INIT_LIST_HEAD(&mvbr->list);
+	list_add_tail(&mvbr->list, &mvdst->bridges);
+	set_bit(bit, mvdst->busy_ports);
+	return 0;
+}
+
+void mv88e6xxx_dst_bridge_leave(struct dsa_switch_tree *dst,
+				struct net_device *brdev)
+{
+	struct mv88e6xxx_dst *mvdst = dst->priv;
+	struct mv88e6xxx_br *mvbr;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->bridge_dev == brdev)
+			return;
+	}
+
+	list_for_each_entry(mvbr, &mvdst->bridges, list) {
+		if (mvbr->brdev == brdev) {
+			clear_bit(DEV_PORT_TO_BIT(mvbr->dev, mvbr->port),
+				  mvdst->busy_ports);
+			list_del(&mvbr->list);
+			kfree(mvbr);
+			return;
+		}
+	}
+}
+
+static struct mv88e6xxx_dst *mv88e6xxx_dst_get(struct dsa_switch_tree *dst)
+{
+	struct mv88e6xxx_dst *mvdst;
+
+	if (dst->priv)
+		return dst->priv;
+
+	mvdst = kzalloc(sizeof(*mvdst), GFP_KERNEL);
+	if (!mvdst)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&mvdst->bridges);
+
+	bitmap_set(mvdst->busy_ports,
+		   DEV_PORT_TO_BIT(MV88E6XXX_G2_PVT_ADDR_DEV_TRUNK, 0),
+		   MV88E6XXX_MAX_PVT_PORTS);
+
+	dst->priv = mvdst;
+	return mvdst;
+}
+
+int mv88e6xxx_dst_add_chip(struct mv88e6xxx_chip *chip)
+{
+	struct dsa_switch_tree *dst = chip->ds->dst;
+	struct mv88e6xxx_dst *mvdst;
+
+	mvdst = mv88e6xxx_dst_get(dst);
+	if (IS_ERR(mvdst))
+		return PTR_ERR(mvdst);
+
+	bitmap_set(mvdst->busy_ports, DEV_PORT_TO_BIT(chip->ds->index, 0),
+		   MV88E6XXX_MAX_PVT_PORTS);
+	return 0;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/dst.h b/drivers/net/dsa/mv88e6xxx/dst.h
new file mode 100644
index 000000000000..3845a19192ef
--- /dev/null
+++ b/drivers/net/dsa/mv88e6xxx/dst.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _MV88E6XXX_DST_H
+#define _MV88E6XXX_DST_H
+
+int mv88e6xxx_dst_bridge_join(struct dsa_switch_tree *dst,
+			      struct net_device *brdev);
+void mv88e6xxx_dst_bridge_leave(struct dsa_switch_tree *dst,
+				struct net_device *brdev);
+int mv88e6xxx_dst_add_chip(struct mv88e6xxx_chip *chip);
+
+#endif /* _MV88E6XXX_DST_H */
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 77d4df819299..c01e74d6e134 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -172,6 +172,11 @@ struct dsa_switch_tree {
 	 */
 	struct net_device **lags;
 	unsigned int lags_len;
+
+	/* Give the switch driver somewhere to hang its tree-wide
+	 * private data structure.
+	 */
+	void *priv;
 };
 
 #define dsa_lags_foreach_id(_id, _dst)				\
-- 
2.25.1

