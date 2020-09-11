Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6F826768E
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgIKX3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgIKX3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:29:01 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186B022224;
        Fri, 11 Sep 2020 23:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599866940;
        bh=GGt7PvCDEsf52lRhq9s2ypxpmgVPz34EQaz5l/IAyU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljjZ/9xmeXBy84IQqYoeUFZx+zMeVd+FSj1FAonsD8yuem7G0vPGk0nCWiAIPADnW
         u+G8KuB4c4N9Vj7IHEHl8UcGXz5dp+h0QxaTGLk4jOzJrDbqLaibzAIrnLnWJkXxaS
         +dsDCco7ts0sFmMntYkm8Hf/j77LnwDQyXnX0dOo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/8] netdevsim: add pause frame stats
Date:   Fri, 11 Sep 2020 16:28:48 -0700
Message-Id: <20200911232853.1072362-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200911232853.1072362-1-kuba@kernel.org>
References: <20200911232853.1072362-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add minimal ethtool interface for testing ethtool pause stats.

v2: add missing static on nsim_ethtool_ops

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/Makefile    |  2 +-
 drivers/net/netdevsim/ethtool.c   | 64 +++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdev.c    |  1 +
 drivers/net/netdevsim/netdevsim.h | 11 ++++++
 4 files changed, 77 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/netdevsim/ethtool.c

diff --git a/drivers/net/netdevsim/Makefile b/drivers/net/netdevsim/Makefile
index 4dfb389dbfd8..ade086eed955 100644
--- a/drivers/net/netdevsim/Makefile
+++ b/drivers/net/netdevsim/Makefile
@@ -3,7 +3,7 @@
 obj-$(CONFIG_NETDEVSIM) += netdevsim.o
 
 netdevsim-objs := \
-	netdev.o dev.o fib.o bus.o health.o udp_tunnels.o
+	netdev.o dev.o ethtool.o fib.o bus.o health.o udp_tunnels.o
 
 ifeq ($(CONFIG_BPF_SYSCALL),y)
 netdevsim-objs += \
diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
new file mode 100644
index 000000000000..7a4c779b4c89
--- /dev/null
+++ b/drivers/net/netdevsim/ethtool.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include <linux/debugfs.h>
+#include <linux/ethtool.h>
+#include <linux/random.h>
+
+#include "netdevsim.h"
+
+static void
+nsim_get_pause_stats(struct net_device *dev,
+		     struct ethtool_pause_stats *pause_stats)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	if (ns->ethtool.report_stats_rx)
+		pause_stats->rx_pause_frames = 1;
+	if (ns->ethtool.report_stats_tx)
+		pause_stats->tx_pause_frames = 2;
+}
+
+static void
+nsim_get_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	pause->autoneg = 0; /* We don't support ksettings, so can't pretend */
+	pause->rx_pause = ns->ethtool.rx;
+	pause->tx_pause = ns->ethtool.tx;
+}
+
+static int
+nsim_set_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	if (pause->autoneg)
+		return -EINVAL;
+
+	ns->ethtool.rx = pause->rx_pause;
+	ns->ethtool.tx = pause->tx_pause;
+	return 0;
+}
+
+static const struct ethtool_ops nsim_ethtool_ops = {
+	.get_pause_stats	= nsim_get_pause_stats,
+	.get_pauseparam		= nsim_get_pauseparam,
+	.set_pauseparam		= nsim_set_pauseparam,
+};
+
+void nsim_ethtool_init(struct netdevsim *ns)
+{
+	struct dentry *ethtool, *dir;
+
+	ns->netdev->ethtool_ops = &nsim_ethtool_ops;
+
+	ethtool = debugfs_create_dir("ethtool", ns->nsim_dev->ddir);
+
+	dir = debugfs_create_dir("pause", ethtool);
+	debugfs_create_bool("report_stats_rx", 0600, dir,
+			    &ns->ethtool.report_stats_rx);
+	debugfs_create_bool("report_stats_tx", 0600, dir,
+			    &ns->ethtool.report_stats_tx);
+}
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 97cfb015a50b..7178468302c8 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -301,6 +301,7 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	ns->nsim_bus_dev = nsim_dev->nsim_bus_dev;
 	SET_NETDEV_DEV(dev, &ns->nsim_bus_dev->dev);
 	dev->netdev_ops = &nsim_netdev_ops;
+	nsim_ethtool_init(ns);
 
 	err = nsim_udp_tunnels_info_create(nsim_dev, dev);
 	if (err)
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 284f7092241d..0c86561e6d8d 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -50,6 +50,13 @@ struct nsim_ipsec {
 	u32 ok;
 };
 
+struct nsim_ethtool {
+	bool rx;
+	bool tx;
+	bool report_stats_rx;
+	bool report_stats_tx;
+};
+
 struct netdevsim {
 	struct net_device *netdev;
 	struct nsim_dev *nsim_dev;
@@ -80,12 +87,16 @@ struct netdevsim {
 		u32 ports[2][NSIM_UDP_TUNNEL_N_PORTS];
 		struct debugfs_u32_array dfs_ports[2];
 	} udp_ports;
+
+	struct nsim_ethtool ethtool;
 };
 
 struct netdevsim *
 nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port);
 void nsim_destroy(struct netdevsim *ns);
 
+void nsim_ethtool_init(struct netdevsim *ns);
+
 void nsim_udp_tunnels_debugfs_create(struct nsim_dev *nsim_dev);
 int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
 				 struct net_device *dev);
-- 
2.26.2

