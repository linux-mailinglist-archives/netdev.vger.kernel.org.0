Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A949121ABA0
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 01:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGIX3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 19:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbgGIX3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 19:29:32 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BEAC207F9;
        Thu,  9 Jul 2020 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594337371;
        bh=re81kyPTVLD+ns3rxRBQYBgjMrQpdiIxyCNO4RbyKhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOMRvq39JyqYQk0nZYoX8gmE6B3ue2sCljYbF9KmfBLdZvOmVPI0qmVXKl5cFEwfr
         hY3UPe/oEXf0f8oqzFPaXRLoMJEItysvoFeMSuCJVl+qdIXj/6PYfuV6tDTWcHAeze
         d2Rxw0qi0b3RxnvXohKfUagO0viQJRi+SD0K8UPM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, emil.s.tantilov@intel.com,
        alexander.h.duyck@linux.intel.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 05/10] netdevsim: add UDP tunnel port offload support
Date:   Thu,  9 Jul 2020 16:28:55 -0700
Message-Id: <20200709232900.105163-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709232900.105163-1-kuba@kernel.org>
References: <20200709232900.105163-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add UDP tunnel port handlers to our fake driver so we can test
the core infra.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/Makefile      |   2 +-
 drivers/net/netdevsim/dev.c         |   1 +
 drivers/net/netdevsim/netdev.c      |  12 +-
 drivers/net/netdevsim/netdevsim.h   |  19 +++
 drivers/net/netdevsim/udp_tunnels.c | 192 ++++++++++++++++++++++++++++
 5 files changed, 224 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/netdevsim/udp_tunnels.c

diff --git a/drivers/net/netdevsim/Makefile b/drivers/net/netdevsim/Makefile
index f4d8f62f28c2..4dfb389dbfd8 100644
--- a/drivers/net/netdevsim/Makefile
+++ b/drivers/net/netdevsim/Makefile
@@ -3,7 +3,7 @@
 obj-$(CONFIG_NETDEVSIM) += netdevsim.o
 
 netdevsim-objs := \
-	netdev.o dev.o fib.o bus.o health.o
+	netdev.o dev.o fib.o bus.o health.o udp_tunnels.o
 
 ifeq ($(CONFIG_BPF_SYSCALL),y)
 netdevsim-objs += \
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ec6b6f7818ac..dd8f997952ca 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -225,6 +225,7 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
+	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 }
 
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 2908e0a0d6e1..9d0d18026434 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -22,6 +22,7 @@
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
 #include <net/rtnetlink.h>
+#include <net/udp_tunnel.h>
 
 #include "netdevsim.h"
 
@@ -257,6 +258,8 @@ static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_setup_tc		= nsim_setup_tc,
 	.ndo_set_features	= nsim_set_features,
 	.ndo_bpf		= nsim_bpf,
+	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_get_devlink_port	= nsim_get_devlink_port,
 };
 
@@ -299,10 +302,14 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	SET_NETDEV_DEV(dev, &ns->nsim_bus_dev->dev);
 	dev->netdev_ops = &nsim_netdev_ops;
 
+	err = nsim_udp_tunnels_info_create(nsim_dev, dev);
+	if (err)
+		goto err_free_netdev;
+
 	rtnl_lock();
 	err = nsim_bpf_init(ns);
 	if (err)
-		goto err_free_netdev;
+		goto err_utn_destroy;
 
 	nsim_ipsec_init(ns);
 
@@ -317,6 +324,8 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	nsim_ipsec_teardown(ns);
 	nsim_bpf_uninit(ns);
 	rtnl_unlock();
+err_utn_destroy:
+	nsim_udp_tunnels_info_destroy(dev);
 err_free_netdev:
 	free_netdev(dev);
 	return ERR_PTR(err);
@@ -331,6 +340,7 @@ void nsim_destroy(struct netdevsim *ns)
 	nsim_ipsec_teardown(ns);
 	nsim_bpf_uninit(ns);
 	rtnl_unlock();
+	nsim_udp_tunnels_info_destroy(dev);
 	free_netdev(dev);
 }
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 4ded54a21e1e..d164052e0393 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -13,6 +13,7 @@
  * THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
  */
 
+#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -29,6 +30,7 @@
 
 #define NSIM_IPSEC_MAX_SA_COUNT		33
 #define NSIM_IPSEC_VALID		BIT(31)
+#define NSIM_UDP_TUNNEL_N_PORTS		4
 
 struct nsim_sa {
 	struct xfrm_state *xs;
@@ -72,12 +74,23 @@ struct netdevsim {
 
 	bool bpf_map_accept;
 	struct nsim_ipsec ipsec;
+	struct {
+		u32 inject_error;
+		u32 sleep;
+		u32 ports[2][NSIM_UDP_TUNNEL_N_PORTS];
+		struct debugfs_u32_array dfs_ports[2];
+	} udp_ports;
 };
 
 struct netdevsim *
 nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port);
 void nsim_destroy(struct netdevsim *ns);
 
+void nsim_udp_tunnels_debugfs_create(struct nsim_dev *nsim_dev);
+int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
+				 struct net_device *dev);
+void nsim_udp_tunnels_info_destroy(struct net_device *dev);
+
 #ifdef CONFIG_BPF_SYSCALL
 int nsim_bpf_dev_init(struct nsim_dev *nsim_dev);
 void nsim_bpf_dev_exit(struct nsim_dev *nsim_dev);
@@ -183,6 +196,12 @@ struct nsim_dev {
 	bool fail_trap_group_set;
 	bool fail_trap_policer_set;
 	bool fail_trap_policer_counter_get;
+	struct {
+		bool sync_all;
+		bool open_only;
+		bool ipv4_only;
+		u32 sleep;
+	} udp_ports;
 };
 
 static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
diff --git a/drivers/net/netdevsim/udp_tunnels.c b/drivers/net/netdevsim/udp_tunnels.c
new file mode 100644
index 000000000000..22c06a76033c
--- /dev/null
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright (c) 2020 Facebook Inc.
+
+#include <linux/debugfs.h>
+#include <linux/netdevice.h>
+#include <linux/slab.h>
+#include <net/udp_tunnel.h>
+
+#include "netdevsim.h"
+
+static int
+nsim_udp_tunnel_set_port(struct net_device *dev, unsigned int table,
+			 unsigned int entry, struct udp_tunnel_info *ti)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+	int ret;
+
+	ret = -ns->udp_ports.inject_error;
+	ns->udp_ports.inject_error = 0;
+
+	if (ns->udp_ports.sleep)
+		msleep(ns->udp_ports.sleep);
+
+	if (!ret) {
+		if (ns->udp_ports.ports[table][entry])
+			ret = -EBUSY;
+		else
+			ns->udp_ports.ports[table][entry] =
+				be16_to_cpu(ti->port) << 16 | ti->type;
+	}
+
+	netdev_info(dev, "set [%d, %d] type %d family %d port %d - %d\n",
+		    table, entry, ti->type, ti->sa_family, ntohs(ti->port),
+		    ret);
+	return ret;
+}
+
+static int
+nsim_udp_tunnel_unset_port(struct net_device *dev, unsigned int table,
+			   unsigned int entry, struct udp_tunnel_info *ti)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+	int ret;
+
+	ret = -ns->udp_ports.inject_error;
+	ns->udp_ports.inject_error = 0;
+
+	if (ns->udp_ports.sleep)
+		msleep(ns->udp_ports.sleep);
+	if (!ret) {
+		u32 val = be16_to_cpu(ti->port) << 16 | ti->type;
+
+		if (val == ns->udp_ports.ports[table][entry])
+			ns->udp_ports.ports[table][entry] = 0;
+		else
+			ret = -ENOENT;
+	}
+
+	netdev_info(dev, "unset [%d, %d] type %d family %d port %d - %d\n",
+		    table, entry, ti->type, ti->sa_family, ntohs(ti->port),
+		    ret);
+	return ret;
+}
+
+static int
+nsim_udp_tunnel_sync_table(struct net_device *dev, unsigned int table)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+	struct udp_tunnel_info ti;
+	unsigned int i;
+	int ret;
+
+	ret = -ns->udp_ports.inject_error;
+	ns->udp_ports.inject_error = 0;
+
+	for (i = 0; i < NSIM_UDP_TUNNEL_N_PORTS; i++) {
+		udp_tunnel_nic_get_port(dev, table, i, &ti);
+		ns->udp_ports.ports[table][i] =
+			be16_to_cpu(ti.port) << 16 | ti.type;
+	}
+
+	return ret;
+}
+
+static const struct udp_tunnel_nic_info nsim_udp_tunnel_info = {
+	.set_port	= nsim_udp_tunnel_set_port,
+	.unset_port	= nsim_udp_tunnel_unset_port,
+	.sync_table	= nsim_udp_tunnel_sync_table,
+
+	.tables = {
+		{
+			.n_entries	= NSIM_UDP_TUNNEL_N_PORTS,
+			.tunnel_types	= UDP_TUNNEL_TYPE_VXLAN,
+		},
+		{
+			.n_entries	= NSIM_UDP_TUNNEL_N_PORTS,
+			.tunnel_types	= UDP_TUNNEL_TYPE_GENEVE |
+					  UDP_TUNNEL_TYPE_VXLAN_GPE,
+		},
+	},
+};
+
+static ssize_t
+nsim_udp_tunnels_info_reset_write(struct file *file, const char __user *data,
+				  size_t count, loff_t *ppos)
+{
+	struct net_device *dev = file->private_data;
+	struct netdevsim *ns = netdev_priv(dev);
+
+	memset(&ns->udp_ports.ports, 0, sizeof(ns->udp_ports.ports));
+	rtnl_lock();
+	udp_tunnel_nic_reset_ntf(dev);
+	rtnl_unlock();
+
+	return count;
+}
+
+static const struct file_operations nsim_udp_tunnels_info_reset_fops = {
+	.open = simple_open,
+	.write = nsim_udp_tunnels_info_reset_write,
+	.llseek = generic_file_llseek,
+};
+
+int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
+				 struct net_device *dev)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+	struct udp_tunnel_nic_info *info;
+
+	debugfs_create_u32("udp_ports_inject_error", 0600,
+			   ns->nsim_dev_port->ddir,
+			   &ns->udp_ports.inject_error);
+
+	ns->udp_ports.dfs_ports[0].array = ns->udp_ports.ports[0];
+	ns->udp_ports.dfs_ports[0].n_elements = NSIM_UDP_TUNNEL_N_PORTS;
+	debugfs_create_u32_array("udp_ports_table0", 0400,
+				 ns->nsim_dev_port->ddir,
+				 &ns->udp_ports.dfs_ports[0]);
+
+	ns->udp_ports.dfs_ports[1].array = ns->udp_ports.ports[1];
+	ns->udp_ports.dfs_ports[1].n_elements = NSIM_UDP_TUNNEL_N_PORTS;
+	debugfs_create_u32_array("udp_ports_table1", 0400,
+				 ns->nsim_dev_port->ddir,
+				 &ns->udp_ports.dfs_ports[1]);
+
+	debugfs_create_file("udp_ports_reset", 0200, ns->nsim_dev_port->ddir,
+			    dev, &nsim_udp_tunnels_info_reset_fops);
+
+	/* Note: it's not normal to allocate the info struct like this!
+	 * Drivers are expected to use a static const one, here we're testing.
+	 */
+	info = kmemdup(&nsim_udp_tunnel_info, sizeof(nsim_udp_tunnel_info),
+		       GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+	ns->udp_ports.sleep = nsim_dev->udp_ports.sleep;
+
+	if (nsim_dev->udp_ports.sync_all) {
+		info->set_port = NULL;
+		info->unset_port = NULL;
+	} else {
+		info->sync_table = NULL;
+	}
+
+	if (ns->udp_ports.sleep)
+		info->flags |= UDP_TUNNEL_NIC_INFO_MAY_SLEEP;
+	if (nsim_dev->udp_ports.open_only)
+		info->flags |= UDP_TUNNEL_NIC_INFO_OPEN_ONLY;
+	if (nsim_dev->udp_ports.ipv4_only)
+		info->flags |= UDP_TUNNEL_NIC_INFO_IPV4_ONLY;
+
+	dev->udp_tunnel_nic_info = info;
+	return 0;
+}
+
+void nsim_udp_tunnels_info_destroy(struct net_device *dev)
+{
+	kfree(dev->udp_tunnel_nic_info);
+	dev->udp_tunnel_nic_info = NULL;
+}
+
+void nsim_udp_tunnels_debugfs_create(struct nsim_dev *nsim_dev)
+{
+	debugfs_create_bool("udp_ports_sync_all", 0600, nsim_dev->ddir,
+			    &nsim_dev->udp_ports.sync_all);
+	debugfs_create_bool("udp_ports_open_only", 0600, nsim_dev->ddir,
+			    &nsim_dev->udp_ports.open_only);
+	debugfs_create_bool("udp_ports_ipv4_only", 0600, nsim_dev->ddir,
+			    &nsim_dev->udp_ports.ipv4_only);
+	debugfs_create_u32("udp_ports_sleep", 0600, nsim_dev->ddir,
+			   &nsim_dev->udp_ports.sleep);
+}
-- 
2.26.2

