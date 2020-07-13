Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1DD21958D
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 03:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgGIBSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 21:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgGIBSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 21:18:48 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 594A3207CD;
        Thu,  9 Jul 2020 01:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594257526;
        bh=SW/80pSmjWlAFS5pbxRGYbv53MwyX0sPwm0qYgyvtIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXscQW3brYqV2umUzCo2ToaVrn2J0/795RzI9ewYxI0z71oR47QShGvvlC6+blqGo
         NY6/6KAWneepB2cziRbqMj83LrzVTpoWk/5DOTnrgrXXwdmCq5Qum/eWGNCLVVhoM0
         IJkjZVsi19Yfsq/RwlDzUqBYc/wAoEw0BGAo6bp8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 03/10] udp_tunnel: add central NIC RX port offload infrastructure
Date:   Wed,  8 Jul 2020 18:18:07 -0700
Message-Id: <20200709011814.4003186-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709011814.4003186-1-kuba@kernel.org>
References: <20200709011814.4003186-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cater to devices which:
 (a) may want to sleep in the callbacks;
 (b) only have IPv4 support;
 (c) need all the programming to happen while the netdev is up.

Drivers attach UDP tunnel offload info struct to their netdevs,
where they declare how many UDP ports of various tunnel types
they support. Core takes care of tracking which ports to offload.

Use a fixed-size array since this matches what almost all drivers
do, and avoids a complexity and uncertainty around memory allocations
in an atomic context.

Make sure that tunnel drivers don't try to replay the ports when
new NIC netdev is registered. Automatic replays would mess up
reference counting, and will be removed completely once all drivers
are converted.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/geneve.c                         |   6 +-
 drivers/net/vxlan.c                          |   6 +-
 include/linux/netdevice.h                    |   8 +
 include/net/udp_tunnel.h                     | 125 +++
 net/ipv4/Makefile                            |   3 +-
 net/ipv4/{udp_tunnel.c => udp_tunnel_core.c} |   0
 net/ipv4/udp_tunnel_nic.c                    | 828 +++++++++++++++++++
 net/ipv4/udp_tunnel_stub.c                   |   7 +
 8 files changed, 978 insertions(+), 5 deletions(-)
 rename net/ipv4/{udp_tunnel.c => udp_tunnel_core.c} (100%)
 create mode 100644 net/ipv4/udp_tunnel_nic.c
 create mode 100644 net/ipv4/udp_tunnel_stub.c

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index e3d074008da2..49b00def2eef 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1796,9 +1796,11 @@ static int geneve_netdevice_event(struct notifier_block *unused,
 	    event == NETDEV_UDP_TUNNEL_DROP_INFO) {
 		geneve_offload_rx_ports(dev, event == NETDEV_UDP_TUNNEL_PUSH_INFO);
 	} else if (event == NETDEV_UNREGISTER) {
-		geneve_offload_rx_ports(dev, false);
+		if (!dev->udp_tunnel_nic_info)
+			geneve_offload_rx_ports(dev, false);
 	} else if (event == NETDEV_REGISTER) {
-		geneve_offload_rx_ports(dev, true);
+		if (!dev->udp_tunnel_nic_info)
+			geneve_offload_rx_ports(dev, true);
 	}
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 89d85dcb200e..a43c97b13924 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -4477,10 +4477,12 @@ static int vxlan_netdevice_event(struct notifier_block *unused,
 	struct vxlan_net *vn = net_generic(dev_net(dev), vxlan_net_id);
 
 	if (event == NETDEV_UNREGISTER) {
-		vxlan_offload_rx_ports(dev, false);
+		if (!dev->udp_tunnel_nic_info)
+			vxlan_offload_rx_ports(dev, false);
 		vxlan_handle_lowerdev_unregister(vn, dev);
 	} else if (event == NETDEV_REGISTER) {
-		vxlan_offload_rx_ports(dev, true);
+		if (!dev->udp_tunnel_nic_info)
+			vxlan_offload_rx_ports(dev, true);
 	} else if (event == NETDEV_UDP_TUNNEL_PUSH_INFO ||
 		   event == NETDEV_UDP_TUNNEL_DROP_INFO) {
 		vxlan_offload_rx_ports(dev, event == NETDEV_UDP_TUNNEL_PUSH_INFO);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 39e28e11863c..ac2cd3f49aba 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -65,6 +65,8 @@ struct wpan_dev;
 struct mpls_dev;
 /* UDP Tunnel offloads */
 struct udp_tunnel_info;
+struct udp_tunnel_nic_info;
+struct udp_tunnel_nic;
 struct bpf_prog;
 struct xdp_buff;
 
@@ -1836,6 +1838,10 @@ enum netdev_priv_flags {
  *
  *	@macsec_ops:    MACsec offloading ops
  *
+ *	@udp_tunnel_nic_info:	static structure describing the UDP tunnel
+ *				offload capabilities of the device
+ *	@udp_tunnel_nic:	UDP tunnel offload state
+ *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
  */
@@ -2134,6 +2140,8 @@ struct net_device {
 	/* MACsec management functions */
 	const struct macsec_ops *macsec_ops;
 #endif
+	const struct udp_tunnel_nic_info	*udp_tunnel_nic_info;
+	struct udp_tunnel_nic	*udp_tunnel_nic;
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 0615e25f041c..d0ff40d9cfd7 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -115,6 +115,7 @@ struct udp_tunnel_info {
 	unsigned short type;
 	sa_family_t sa_family;
 	__be16 port;
+	u8 hw_priv;
 };
 
 /* Notify network devices of offloadable types */
@@ -181,4 +182,128 @@ static inline void udp_tunnel_encap_enable(struct socket *sock)
 		udp_encap_enable();
 }
 
+#define UDP_TUNNEL_NIC_MAX_TABLES	4
+
+enum udp_tunnel_nic_info_flags {
+	/* Device callbacks may sleep */
+	UDP_TUNNEL_NIC_INFO_MAY_SLEEP	= BIT(0),
+	/* Device only supports offloads when it's open, all ports
+	 * will be removed before close and re-added after open.
+	 */
+	UDP_TUNNEL_NIC_INFO_OPEN_ONLY	= BIT(1),
+	/* Device supports only IPv4 tunnels */
+	UDP_TUNNEL_NIC_INFO_IPV4_ONLY	= BIT(2),
+};
+
+/**
+ * struct udp_tunnel_nic_info - driver UDP tunnel offload information
+ * @set_port:	callback for adding a new port
+ * @unset_port:	callback for removing a port
+ * @sync_table:	callback for syncing the entire port table at once
+ * @flags:	device flags from enum udp_tunnel_nic_info_flags
+ * @tables:	UDP port tables this device has
+ * @tables.n_entries:		number of entries in this table
+ * @tables.tunnel_types:	types of tunnels this table accepts
+ *
+ * Drivers are expected to provide either @set_port and @unset_port callbacks
+ * or the @sync_table callback. Callbacks are invoked with rtnl lock held.
+ *
+ * Known limitations:
+ *  - UDP tunnel port notifications are fundamentally best-effort -
+ *    it is likely the driver will both see skbs which use a UDP tunnel port,
+ *    while not being a tunneled skb, and tunnel skbs from other ports -
+ *    drivers should only use these ports for non-critical RX-side offloads,
+ *    e.g. the checksum offload;
+ *  - none of the devices care about the socket family at present, so we don't
+ *    track it. Please extend this code if you care.
+ */
+struct udp_tunnel_nic_info {
+	/* one-by-one */
+	int (*set_port)(struct net_device *dev,
+			unsigned int table, unsigned int entry,
+			struct udp_tunnel_info *ti);
+	int (*unset_port)(struct net_device *dev,
+			  unsigned int table, unsigned int entry,
+			  struct udp_tunnel_info *ti);
+
+	/* all at once */
+	int (*sync_table)(struct net_device *dev, unsigned int table);
+
+	unsigned int flags;
+
+	struct udp_tunnel_nic_table_info {
+		unsigned int n_entries;
+		unsigned int tunnel_types;
+	} tables[UDP_TUNNEL_NIC_MAX_TABLES];
+};
+
+/* UDP tunnel module dependencies
+ *
+ * Tunnel drivers are expected to have a hard dependency on the udp_tunnel
+ * module. NIC drivers are not, they just attach their
+ * struct udp_tunnel_nic_info to the netdev and wait for callbacks to come.
+ * Loading a tunnel driver will cause the udp_tunnel module to be loaded
+ * and only then will all the required state structures be allocated.
+ * Since we want a weak dependency from the drivers and the core to udp_tunnel
+ * we call things through the following stubs.
+ */
+struct udp_tunnel_nic_ops {
+	void (*get_port)(struct net_device *dev, unsigned int table,
+			 unsigned int idx, struct udp_tunnel_info *ti);
+	void (*set_port_priv)(struct net_device *dev, unsigned int table,
+			      unsigned int idx, u8 priv);
+	void (*add_port)(struct net_device *dev, struct udp_tunnel_info *ti);
+	void (*del_port)(struct net_device *dev, struct udp_tunnel_info *ti);
+	void (*reset_ntf)(struct net_device *dev);
+};
+
+extern const struct udp_tunnel_nic_ops *udp_tunnel_nic_ops;
+
+static inline void
+udp_tunnel_nic_get_port(struct net_device *dev, unsigned int table,
+			unsigned int idx, struct udp_tunnel_info *ti)
+{
+	if (udp_tunnel_nic_ops)
+		udp_tunnel_nic_ops->get_port(dev, table, idx, ti);
+}
+
+static inline void
+udp_tunnel_nic_set_port_priv(struct net_device *dev, unsigned int table,
+			     unsigned int idx, u8 priv)
+{
+	if (udp_tunnel_nic_ops)
+		udp_tunnel_nic_ops->set_port_priv(dev, table, idx, priv);
+}
+
+static inline void
+udp_tunnel_nic_add_port(struct net_device *dev, struct udp_tunnel_info *ti)
+{
+	if (udp_tunnel_nic_ops)
+		udp_tunnel_nic_ops->add_port(dev, ti);
+}
+
+static inline void
+udp_tunnel_nic_del_port(struct net_device *dev, struct udp_tunnel_info *ti)
+{
+	if (udp_tunnel_nic_ops)
+		udp_tunnel_nic_ops->del_port(dev, ti);
+}
+
+/**
+ * udp_tunnel_nic_reset_ntf() - device-originating reset notification
+ * @dev: network interface device structure
+ *
+ * Called by the driver to inform the core that the entire UDP tunnel port
+ * state has been lost, usually due to device reset. Core will assume device
+ * forgot all the ports and issue .set_port and .sync_table callbacks as
+ * necessary.
+ *
+ * This function must be called with rtnl lock held, and will issue all
+ * the callbacks before returning.
+ */
+static inline void udp_tunnel_nic_reset_ntf(struct net_device *dev)
+{
+	if (udp_tunnel_nic_ops)
+		udp_tunnel_nic_ops->reset_ntf(dev);
+}
 #endif
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 9e1a186a3671..5b77a46885b9 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -14,7 +14,7 @@ obj-y     := route.o inetpeer.o protocol.o \
 	     udp_offload.o arp.o icmp.o devinet.o af_inet.o igmp.o \
 	     fib_frontend.o fib_semantics.o fib_trie.o fib_notifier.o \
 	     inet_fragment.o ping.o ip_tunnel_core.o gre_offload.o \
-	     metrics.o netlink.o nexthop.o
+	     metrics.o netlink.o nexthop.o udp_tunnel_stub.o
 
 obj-$(CONFIG_BPFILTER) += bpfilter/
 
@@ -29,6 +29,7 @@ gre-y := gre_demux.o
 obj-$(CONFIG_NET_FOU) += fou.o
 obj-$(CONFIG_NET_IPGRE_DEMUX) += gre.o
 obj-$(CONFIG_NET_IPGRE) += ip_gre.o
+udp_tunnel-y := udp_tunnel_core.o udp_tunnel_nic.o
 obj-$(CONFIG_NET_UDP_TUNNEL) += udp_tunnel.o
 obj-$(CONFIG_NET_IPVTI) += ip_vti.o
 obj-$(CONFIG_SYN_COOKIES) += syncookies.o
diff --git a/net/ipv4/udp_tunnel.c b/net/ipv4/udp_tunnel_core.c
similarity index 100%
rename from net/ipv4/udp_tunnel.c
rename to net/ipv4/udp_tunnel_core.c
diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
new file mode 100644
index 000000000000..098fb0ebe998
--- /dev/null
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -0,0 +1,828 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright (c) 2020 Facebook Inc.
+
+#include <linux/netdevice.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <net/udp_tunnel.h>
+
+enum udp_tunnel_nic_table_entry_flags {
+	UDP_TUNNEL_NIC_ENTRY_ADD	= BIT(0),
+	UDP_TUNNEL_NIC_ENTRY_DEL	= BIT(1),
+	UDP_TUNNEL_NIC_ENTRY_OP_FAIL	= BIT(2),
+	UDP_TUNNEL_NIC_ENTRY_FROZEN	= BIT(3),
+};
+
+struct udp_tunnel_nic_table_entry {
+	__be16 port;
+	u8 type;
+	u8 use_cnt;
+	u8 flags;
+	u8 hw_priv;
+};
+
+/**
+ * struct udp_tunnel_nic - UDP tunnel port offload state
+ * @work:	async work for talking to hardware from process context
+ * @dev:	netdev pointer
+ * @need_sync:	at least one port start changed
+ * @need_replay: space was freed, we need a replay of all ports
+ * @work_pending: @work is currently scheduled
+ * @n_tables:	number of tables under @entries
+ * @missed:	bitmap of tables which overflown
+ * @entries:	table of tables of ports currently offloaded
+ */
+struct udp_tunnel_nic {
+	struct work_struct work;
+
+	struct net_device *dev;
+
+	u8 need_sync:1;
+	u8 need_replay:1;
+	u8 work_pending:1;
+
+	unsigned int n_tables;
+	unsigned long missed;
+	struct udp_tunnel_nic_table_entry **entries;
+};
+
+/* We ensure all work structs are done using driver state, but not the code.
+ * We need a workqueue we can flush before module gets removed.
+ */
+static struct workqueue_struct *udp_tunnel_nic_workqueue;
+
+static const char *udp_tunnel_nic_tunnel_type_name(unsigned int type)
+{
+	switch (type) {
+	case UDP_TUNNEL_TYPE_VXLAN:
+		return "vxlan";
+	case UDP_TUNNEL_TYPE_GENEVE:
+		return "geneve";
+	case UDP_TUNNEL_TYPE_VXLAN_GPE:
+		return "vxlan-gpe";
+	default:
+		return "unknown";
+	}
+}
+
+static bool
+udp_tunnel_nic_entry_is_free(struct udp_tunnel_nic_table_entry *entry)
+{
+	return entry->use_cnt == 0 && !entry->flags;
+}
+
+static bool
+udp_tunnel_nic_entry_is_frozen(struct udp_tunnel_nic_table_entry *entry)
+{
+	return entry->flags & UDP_TUNNEL_NIC_ENTRY_FROZEN;
+}
+
+static void
+udp_tunnel_nic_entry_freeze_used(struct udp_tunnel_nic_table_entry *entry)
+{
+	if (!udp_tunnel_nic_entry_is_free(entry))
+		entry->flags |= UDP_TUNNEL_NIC_ENTRY_FROZEN;
+}
+
+static void
+udp_tunnel_nic_entry_unfreeze(struct udp_tunnel_nic_table_entry *entry)
+{
+	entry->flags &= ~UDP_TUNNEL_NIC_ENTRY_FROZEN;
+}
+
+static bool
+udp_tunnel_nic_entry_is_queued(struct udp_tunnel_nic_table_entry *entry)
+{
+	return entry->flags & (UDP_TUNNEL_NIC_ENTRY_ADD |
+			       UDP_TUNNEL_NIC_ENTRY_DEL);
+}
+
+static void
+udp_tunnel_nic_entry_queue(struct udp_tunnel_nic *utn,
+			   struct udp_tunnel_nic_table_entry *entry,
+			   unsigned int flag)
+{
+	entry->flags |= flag;
+	utn->need_sync = 1;
+}
+
+static void
+udp_tunnel_nic_ti_from_entry(struct udp_tunnel_nic_table_entry *entry,
+			     struct udp_tunnel_info *ti)
+{
+	memset(ti, 0, sizeof(*ti));
+	ti->port = entry->port;
+	ti->type = entry->type;
+	ti->hw_priv = entry->hw_priv;
+}
+
+static bool
+udp_tunnel_nic_is_empty(struct net_device *dev, struct udp_tunnel_nic *utn)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	unsigned int i, j;
+
+	for (i = 0; i < utn->n_tables; i++)
+		for (j = 0; j < info->tables[i].n_entries; j++)
+			if (!udp_tunnel_nic_entry_is_free(&utn->entries[i][j]))
+				return false;
+	return true;
+}
+
+static bool
+udp_tunnel_nic_should_replay(struct net_device *dev, struct udp_tunnel_nic *utn)
+{
+	const struct udp_tunnel_nic_table_info *table;
+	unsigned int i, j;
+
+	if (!utn->missed)
+		return false;
+
+	for (i = 0; i < utn->n_tables; i++) {
+		table = &dev->udp_tunnel_nic_info->tables[i];
+		if (!test_bit(i, &utn->missed))
+			continue;
+
+		for (j = 0; j < table->n_entries; j++)
+			if (udp_tunnel_nic_entry_is_free(&utn->entries[i][j]))
+				return true;
+	}
+
+	return false;
+}
+
+static void
+__udp_tunnel_nic_get_port(struct net_device *dev, unsigned int table,
+			  unsigned int idx, struct udp_tunnel_info *ti)
+{
+	struct udp_tunnel_nic_table_entry *entry;
+	struct udp_tunnel_nic *utn;
+
+	utn = dev->udp_tunnel_nic;
+	entry = &utn->entries[table][idx];
+
+	/* This helper is used from .sync_table, we indicate empty entries
+	 * by zero'ed @ti. Drivers which need to know the details of a port
+	 * when it gets deleted should use the .set_port / .unset_port
+	 * callbacks.
+	 */
+	if (entry->use_cnt)
+		udp_tunnel_nic_ti_from_entry(entry, ti);
+	else
+		memset(ti, 0, sizeof(*ti));
+}
+
+static void
+__udp_tunnel_nic_set_port_priv(struct net_device *dev, unsigned int table,
+			       unsigned int idx, u8 priv)
+{
+	dev->udp_tunnel_nic->entries[table][idx].hw_priv = priv;
+}
+
+static void
+udp_tunnel_nic_entry_update_done(struct udp_tunnel_nic_table_entry *entry,
+				 int err)
+{
+	bool dodgy = entry->flags & UDP_TUNNEL_NIC_ENTRY_OP_FAIL;
+
+	WARN_ON_ONCE(entry->flags & UDP_TUNNEL_NIC_ENTRY_ADD &&
+		     entry->flags & UDP_TUNNEL_NIC_ENTRY_DEL);
+
+	if (entry->flags & UDP_TUNNEL_NIC_ENTRY_ADD &&
+	    (!err || (err == -EEXIST && dodgy)))
+		entry->flags &= ~UDP_TUNNEL_NIC_ENTRY_ADD;
+
+	if (entry->flags & UDP_TUNNEL_NIC_ENTRY_DEL &&
+	    (!err || (err == -ENOENT && dodgy)))
+		entry->flags &= ~UDP_TUNNEL_NIC_ENTRY_DEL;
+
+	if (!err)
+		entry->flags &= ~UDP_TUNNEL_NIC_ENTRY_OP_FAIL;
+	else
+		entry->flags |= UDP_TUNNEL_NIC_ENTRY_OP_FAIL;
+}
+
+static void
+udp_tunnel_nic_device_sync_one(struct net_device *dev,
+			       struct udp_tunnel_nic *utn,
+			       unsigned int table, unsigned int idx)
+{
+	struct udp_tunnel_nic_table_entry *entry;
+	struct udp_tunnel_info ti;
+	int err;
+
+	entry = &utn->entries[table][idx];
+	if (!udp_tunnel_nic_entry_is_queued(entry))
+		return;
+
+	udp_tunnel_nic_ti_from_entry(entry, &ti);
+	if (entry->flags & UDP_TUNNEL_NIC_ENTRY_ADD)
+		err = dev->udp_tunnel_nic_info->set_port(dev, table, idx, &ti);
+	else
+		err = dev->udp_tunnel_nic_info->unset_port(dev, table, idx,
+							   &ti);
+	udp_tunnel_nic_entry_update_done(entry, err);
+
+	if (err)
+		netdev_warn(dev,
+			    "UDP tunnel port sync failed port %d type %s: %d\n",
+			    be16_to_cpu(entry->port),
+			    udp_tunnel_nic_tunnel_type_name(entry->type),
+			    err);
+}
+
+static void
+udp_tunnel_nic_device_sync_by_port(struct net_device *dev,
+				   struct udp_tunnel_nic *utn)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	unsigned int i, j;
+
+	for (i = 0; i < utn->n_tables; i++)
+		for (j = 0; j < info->tables[i].n_entries; j++)
+			udp_tunnel_nic_device_sync_one(dev, utn, i, j);
+}
+
+static void
+udp_tunnel_nic_device_sync_by_table(struct net_device *dev,
+				    struct udp_tunnel_nic *utn)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	unsigned int i, j;
+	int err;
+
+	for (i = 0; i < utn->n_tables; i++) {
+		/* Find something that needs sync in this table */
+		for (j = 0; j < info->tables[i].n_entries; j++)
+			if (udp_tunnel_nic_entry_is_queued(&utn->entries[i][j]))
+				break;
+		if (j == info->tables[i].n_entries)
+			continue;
+
+		err = info->sync_table(dev, i);
+		if (err)
+			netdev_warn(dev, "UDP tunnel port sync failed for table %d: %d\n",
+				    i, err);
+
+		for (j = 0; j < info->tables[i].n_entries; j++) {
+			struct udp_tunnel_nic_table_entry *entry;
+
+			entry = &utn->entries[i][j];
+			if (udp_tunnel_nic_entry_is_queued(entry))
+				udp_tunnel_nic_entry_update_done(entry, err);
+		}
+	}
+}
+
+static void
+__udp_tunnel_nic_device_sync(struct net_device *dev, struct udp_tunnel_nic *utn)
+{
+	if (!utn->need_sync)
+		return;
+
+	if (dev->udp_tunnel_nic_info->sync_table)
+		udp_tunnel_nic_device_sync_by_table(dev, utn);
+	else
+		udp_tunnel_nic_device_sync_by_port(dev, utn);
+
+	utn->need_sync = 0;
+	/* Can't replay directly here, in case we come from the tunnel driver's
+	 * notification - trying to replay may deadlock inside tunnel driver.
+	 */
+	utn->need_replay = udp_tunnel_nic_should_replay(dev, utn);
+}
+
+static void
+udp_tunnel_nic_device_sync(struct net_device *dev, struct udp_tunnel_nic *utn)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	bool may_sleep;
+
+	if (!utn->need_sync)
+		return;
+
+	/* Drivers which sleep in the callback need to update from
+	 * the workqueue, if we come from the tunnel driver's notification.
+	 */
+	may_sleep = info->flags & UDP_TUNNEL_NIC_INFO_MAY_SLEEP;
+	if (!may_sleep)
+		__udp_tunnel_nic_device_sync(dev, utn);
+	if (may_sleep || utn->need_replay) {
+		queue_work(udp_tunnel_nic_workqueue, &utn->work);
+		utn->work_pending = 1;
+	}
+}
+
+static bool
+udp_tunnel_nic_table_is_capable(const struct udp_tunnel_nic_table_info *table,
+				struct udp_tunnel_info *ti)
+{
+	return table->tunnel_types & ti->type;
+}
+
+static bool
+udp_tunnel_nic_is_capable(struct net_device *dev, struct udp_tunnel_nic *utn,
+			  struct udp_tunnel_info *ti)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	unsigned int i;
+
+	/* Special case IPv4-only NICs */
+	if (info->flags & UDP_TUNNEL_NIC_INFO_IPV4_ONLY &&
+	    ti->sa_family != AF_INET)
+		return false;
+
+	for (i = 0; i < utn->n_tables; i++)
+		if (udp_tunnel_nic_table_is_capable(&info->tables[i], ti))
+			return true;
+	return false;
+}
+
+static int
+udp_tunnel_nic_has_collision(struct net_device *dev, struct udp_tunnel_nic *utn,
+			     struct udp_tunnel_info *ti)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	struct udp_tunnel_nic_table_entry *entry;
+	unsigned int i, j;
+
+	for (i = 0; i < utn->n_tables; i++)
+		for (j = 0; j < info->tables[i].n_entries; j++) {
+			entry =	&utn->entries[i][j];
+
+			if (!udp_tunnel_nic_entry_is_free(entry) &&
+			    entry->port == ti->port &&
+			    entry->type != ti->type) {
+				__set_bit(i, &utn->missed);
+				return true;
+			}
+		}
+	return false;
+}
+
+static void
+udp_tunnel_nic_entry_adj(struct udp_tunnel_nic *utn,
+			 unsigned int table, unsigned int idx, int use_cnt_adj)
+{
+	struct udp_tunnel_nic_table_entry *entry =  &utn->entries[table][idx];
+	bool dodgy = entry->flags & UDP_TUNNEL_NIC_ENTRY_OP_FAIL;
+	unsigned int from, to;
+
+	/* If not going from used to unused or vice versa - all done.
+	 * For dodgy entries make sure we try to sync again (queue the entry).
+	 */
+	entry->use_cnt += use_cnt_adj;
+	if (!dodgy && !entry->use_cnt == !(entry->use_cnt - use_cnt_adj))
+		return;
+
+	/* Cancel the op before it was sent to the device, if possible,
+	 * otherwise we'd need to take special care to issue commands
+	 * in the same order the ports arrived.
+	 */
+	if (use_cnt_adj < 0) {
+		from = UDP_TUNNEL_NIC_ENTRY_ADD;
+		to = UDP_TUNNEL_NIC_ENTRY_DEL;
+	} else {
+		from = UDP_TUNNEL_NIC_ENTRY_DEL;
+		to = UDP_TUNNEL_NIC_ENTRY_ADD;
+	}
+
+	if (entry->flags & from) {
+		entry->flags &= ~from;
+		if (!dodgy)
+			return;
+	}
+
+	udp_tunnel_nic_entry_queue(utn, entry, to);
+}
+
+static bool
+udp_tunnel_nic_entry_try_adj(struct udp_tunnel_nic *utn,
+			     unsigned int table, unsigned int idx,
+			     struct udp_tunnel_info *ti, int use_cnt_adj)
+{
+	struct udp_tunnel_nic_table_entry *entry =  &utn->entries[table][idx];
+
+	if (udp_tunnel_nic_entry_is_free(entry) ||
+	    entry->port != ti->port ||
+	    entry->type != ti->type)
+		return false;
+
+	if (udp_tunnel_nic_entry_is_frozen(entry))
+		return true;
+
+	udp_tunnel_nic_entry_adj(utn, table, idx, use_cnt_adj);
+	return true;
+}
+
+/* Try to find existing matching entry and adjust its use count, instead of
+ * adding a new one. Returns true if entry was found. In case of delete the
+ * entry may have gotten removed in the process, in which case it will be
+ * queued for removal.
+ */
+static bool
+udp_tunnel_nic_try_existing(struct net_device *dev, struct udp_tunnel_nic *utn,
+			    struct udp_tunnel_info *ti, int use_cnt_adj)
+{
+	const struct udp_tunnel_nic_table_info *table;
+	unsigned int i, j;
+
+	for (i = 0; i < utn->n_tables; i++) {
+		table = &dev->udp_tunnel_nic_info->tables[i];
+		if (!udp_tunnel_nic_table_is_capable(table, ti))
+			continue;
+
+		for (j = 0; j < table->n_entries; j++)
+			if (udp_tunnel_nic_entry_try_adj(utn, i, j, ti,
+							 use_cnt_adj))
+				return true;
+	}
+
+	return false;
+}
+
+static bool
+udp_tunnel_nic_add_existing(struct net_device *dev, struct udp_tunnel_nic *utn,
+			    struct udp_tunnel_info *ti)
+{
+	return udp_tunnel_nic_try_existing(dev, utn, ti, +1);
+}
+
+static bool
+udp_tunnel_nic_del_existing(struct net_device *dev, struct udp_tunnel_nic *utn,
+			    struct udp_tunnel_info *ti)
+{
+	return udp_tunnel_nic_try_existing(dev, utn, ti, -1);
+}
+
+static bool
+udp_tunnel_nic_add_new(struct net_device *dev, struct udp_tunnel_nic *utn,
+		       struct udp_tunnel_info *ti)
+{
+	const struct udp_tunnel_nic_table_info *table;
+	unsigned int i, j;
+
+	for (i = 0; i < utn->n_tables; i++) {
+		table = &dev->udp_tunnel_nic_info->tables[i];
+		if (!udp_tunnel_nic_table_is_capable(table, ti))
+			continue;
+
+		for (j = 0; j < table->n_entries; j++) {
+			struct udp_tunnel_nic_table_entry *entry;
+
+			entry = &utn->entries[i][j];
+			if (!udp_tunnel_nic_entry_is_free(entry))
+				continue;
+
+			entry->port = ti->port;
+			entry->type = ti->type;
+			entry->use_cnt = 1;
+			udp_tunnel_nic_entry_queue(utn, entry,
+						   UDP_TUNNEL_NIC_ENTRY_ADD);
+			return true;
+		}
+
+		/* The different table may still fit this port in, but there
+		 * are no devices currently which have multiple tables accepting
+		 * the same tunnel type, and false positives are okay.
+		 */
+		__set_bit(i, &utn->missed);
+	}
+
+	return false;
+}
+
+static void
+__udp_tunnel_nic_add_port(struct net_device *dev, struct udp_tunnel_info *ti)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	struct udp_tunnel_nic *utn;
+
+	utn = dev->udp_tunnel_nic;
+	if (!utn)
+		return;
+	if (!netif_running(dev) && info->flags & UDP_TUNNEL_NIC_INFO_OPEN_ONLY)
+		return;
+
+	if (!udp_tunnel_nic_is_capable(dev, utn, ti))
+		return;
+
+	/* It may happen that a tunnel of one type is removed and different
+	 * tunnel type tries to reuse its port before the device was informed.
+	 * Rely on utn->missed to re-add this port later.
+	 */
+	if (udp_tunnel_nic_has_collision(dev, utn, ti))
+		return;
+
+	if (!udp_tunnel_nic_add_existing(dev, utn, ti))
+		udp_tunnel_nic_add_new(dev, utn, ti);
+
+	udp_tunnel_nic_device_sync(dev, utn);
+}
+
+static void
+__udp_tunnel_nic_del_port(struct net_device *dev, struct udp_tunnel_info *ti)
+{
+	struct udp_tunnel_nic *utn;
+
+	utn = dev->udp_tunnel_nic;
+	if (!utn)
+		return;
+
+	if (!udp_tunnel_nic_is_capable(dev, utn, ti))
+		return;
+
+	udp_tunnel_nic_del_existing(dev, utn, ti);
+
+	udp_tunnel_nic_device_sync(dev, utn);
+}
+
+static void __udp_tunnel_nic_reset_ntf(struct net_device *dev)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	struct udp_tunnel_nic *utn;
+	unsigned int i, j;
+
+	ASSERT_RTNL();
+
+	utn = dev->udp_tunnel_nic;
+	if (!utn)
+		return;
+
+	utn->need_sync = false;
+	for (i = 0; i < utn->n_tables; i++)
+		for (j = 0; j < info->tables[i].n_entries; j++) {
+			struct udp_tunnel_nic_table_entry *entry;
+
+			entry = &utn->entries[i][j];
+
+			entry->flags &= ~(UDP_TUNNEL_NIC_ENTRY_DEL |
+					  UDP_TUNNEL_NIC_ENTRY_OP_FAIL);
+			/* We don't release rtnl across ops */
+			WARN_ON(entry->flags & UDP_TUNNEL_NIC_ENTRY_FROZEN);
+			if (!entry->use_cnt)
+				continue;
+
+			udp_tunnel_nic_entry_queue(utn, entry,
+						   UDP_TUNNEL_NIC_ENTRY_ADD);
+		}
+
+	__udp_tunnel_nic_device_sync(dev, utn);
+}
+
+static const struct udp_tunnel_nic_ops __udp_tunnel_nic_ops = {
+	.get_port	= __udp_tunnel_nic_get_port,
+	.set_port_priv	= __udp_tunnel_nic_set_port_priv,
+	.add_port	= __udp_tunnel_nic_add_port,
+	.del_port	= __udp_tunnel_nic_del_port,
+	.reset_ntf	= __udp_tunnel_nic_reset_ntf,
+};
+
+static void
+udp_tunnel_nic_flush(struct net_device *dev, struct udp_tunnel_nic *utn)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	unsigned int i, j;
+
+	for (i = 0; i < utn->n_tables; i++)
+		for (j = 0; j < info->tables[i].n_entries; j++) {
+			int adj_cnt = -utn->entries[i][j].use_cnt;
+
+			if (adj_cnt)
+				udp_tunnel_nic_entry_adj(utn, i, j, adj_cnt);
+		}
+
+	__udp_tunnel_nic_device_sync(dev, utn);
+
+	for (i = 0; i < utn->n_tables; i++)
+		memset(utn->entries[i], 0, array_size(info->tables[i].n_entries,
+						      sizeof(**utn->entries)));
+	WARN_ON(utn->need_sync);
+	utn->need_replay = 0;
+}
+
+static void
+udp_tunnel_nic_replay(struct net_device *dev, struct udp_tunnel_nic *utn)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	unsigned int i, j;
+
+	/* Freeze all the ports we are already tracking so that the replay
+	 * does not double up the refcount.
+	 */
+	for (i = 0; i < utn->n_tables; i++)
+		for (j = 0; j < info->tables[i].n_entries; j++)
+			udp_tunnel_nic_entry_freeze_used(&utn->entries[i][j]);
+	utn->missed = 0;
+	utn->need_replay = 0;
+
+	udp_tunnel_get_rx_info(dev);
+
+	for (i = 0; i < utn->n_tables; i++)
+		for (j = 0; j < info->tables[i].n_entries; j++)
+			udp_tunnel_nic_entry_unfreeze(&utn->entries[i][j]);
+}
+
+static void udp_tunnel_nic_device_sync_work(struct work_struct *work)
+{
+	struct udp_tunnel_nic *utn =
+		container_of(work, struct udp_tunnel_nic, work);
+
+	rtnl_lock();
+	utn->work_pending = 0;
+	__udp_tunnel_nic_device_sync(utn->dev, utn);
+
+	if (utn->need_replay)
+		udp_tunnel_nic_replay(utn->dev, utn);
+	rtnl_unlock();
+}
+
+static struct udp_tunnel_nic *
+udp_tunnel_nic_alloc(const struct udp_tunnel_nic_info *info,
+		     unsigned int n_tables)
+{
+	struct udp_tunnel_nic *utn;
+	unsigned int i;
+
+	utn = kzalloc(sizeof(*utn), GFP_KERNEL);
+	if (!utn)
+		return NULL;
+	utn->n_tables = n_tables;
+	INIT_WORK(&utn->work, udp_tunnel_nic_device_sync_work);
+
+	utn->entries = kmalloc_array(n_tables, sizeof(void *), GFP_KERNEL);
+	if (!utn->entries)
+		goto err_free_utn;
+
+	for (i = 0; i < n_tables; i++) {
+		utn->entries[i] = kcalloc(info->tables[i].n_entries,
+					  sizeof(*utn->entries[i]), GFP_KERNEL);
+		if (!utn->entries[i])
+			goto err_free_prev_entries;
+	}
+
+	return utn;
+
+err_free_prev_entries:
+	while (i--)
+		kfree(utn->entries[i]);
+	kfree(utn->entries);
+err_free_utn:
+	kfree(utn);
+	return NULL;
+}
+
+static int udp_tunnel_nic_register(struct net_device *dev)
+{
+	const struct udp_tunnel_nic_info *info = dev->udp_tunnel_nic_info;
+	struct udp_tunnel_nic *utn;
+	unsigned int n_tables, i;
+
+	BUILD_BUG_ON(sizeof(utn->missed) * BITS_PER_BYTE <
+		     UDP_TUNNEL_NIC_MAX_TABLES);
+
+	if (WARN_ON(!info->set_port != !info->unset_port) ||
+	    WARN_ON(!info->set_port == !info->sync_table) ||
+	    WARN_ON(!info->tables[0].n_entries))
+		return -EINVAL;
+
+	n_tables = 1;
+	for (i = 1; i < UDP_TUNNEL_NIC_MAX_TABLES; i++) {
+		if (!info->tables[i].n_entries)
+			continue;
+
+		n_tables++;
+		if (WARN_ON(!info->tables[i - 1].n_entries))
+			return -EINVAL;
+	}
+
+	utn = udp_tunnel_nic_alloc(info, n_tables);
+	if (!utn)
+		return -ENOMEM;
+
+	utn->dev = dev;
+	dev_hold(dev);
+	dev->udp_tunnel_nic = utn;
+
+	if (!(info->flags & UDP_TUNNEL_NIC_INFO_OPEN_ONLY))
+		udp_tunnel_get_rx_info(dev);
+
+	return 0;
+}
+
+static void
+udp_tunnel_nic_unregister(struct net_device *dev, struct udp_tunnel_nic *utn)
+{
+	unsigned int i;
+
+	/* Flush before we check work, so we don't waste time adding entries
+	 * from the work which we will boot immediately.
+	 */
+	udp_tunnel_nic_flush(dev, utn);
+
+	/* Wait for the work to be done using the state, netdev core will
+	 * retry unregister until we give up our reference on this device.
+	 */
+	if (utn->work_pending)
+		return;
+
+	for (i = 0; i < utn->n_tables; i++)
+		kfree(utn->entries[i]);
+	kfree(utn->entries);
+	kfree(utn);
+	dev->udp_tunnel_nic = NULL;
+	dev_put(dev);
+}
+
+static int
+udp_tunnel_nic_netdevice_event(struct notifier_block *unused,
+			       unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	const struct udp_tunnel_nic_info *info;
+	struct udp_tunnel_nic *utn;
+
+	info = dev->udp_tunnel_nic_info;
+	if (!info)
+		return NOTIFY_DONE;
+
+	if (event == NETDEV_REGISTER) {
+		int err;
+
+		err = udp_tunnel_nic_register(dev);
+		if (err)
+			netdev_WARN(dev, "failed to register for UDP tunnel offloads: %d", err);
+		return notifier_from_errno(err);
+	}
+	/* All other events will need the udp_tunnel_nic state */
+	utn = dev->udp_tunnel_nic;
+	if (!utn)
+		return NOTIFY_DONE;
+
+	if (event == NETDEV_UNREGISTER) {
+		udp_tunnel_nic_unregister(dev, utn);
+		return NOTIFY_OK;
+	}
+
+	/* All other events only matter if NIC has to be programmed open */
+	if (!(info->flags & UDP_TUNNEL_NIC_INFO_OPEN_ONLY))
+		return NOTIFY_DONE;
+
+	if (event == NETDEV_UP) {
+		WARN_ON(!udp_tunnel_nic_is_empty(dev, utn));
+		udp_tunnel_get_rx_info(dev);
+		return NOTIFY_OK;
+	}
+	if (event == NETDEV_GOING_DOWN) {
+		udp_tunnel_nic_flush(dev, utn);
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block udp_tunnel_nic_notifier_block __read_mostly = {
+	.notifier_call = udp_tunnel_nic_netdevice_event,
+};
+
+static int __init udp_tunnel_nic_init_module(void)
+{
+	int err;
+
+	udp_tunnel_nic_workqueue = alloc_workqueue("udp_tunnel_nic", 0, 0);
+	if (!udp_tunnel_nic_workqueue)
+		return -ENOMEM;
+
+	rtnl_lock();
+	udp_tunnel_nic_ops = &__udp_tunnel_nic_ops;
+	rtnl_unlock();
+
+	err = register_netdevice_notifier(&udp_tunnel_nic_notifier_block);
+	if (err)
+		goto err_unset_ops;
+
+	return 0;
+
+err_unset_ops:
+	rtnl_lock();
+	udp_tunnel_nic_ops = NULL;
+	rtnl_unlock();
+	destroy_workqueue(udp_tunnel_nic_workqueue);
+	return err;
+}
+late_initcall(udp_tunnel_nic_init_module);
+
+static void __exit udp_tunnel_nic_cleanup_module(void)
+{
+	unregister_netdevice_notifier(&udp_tunnel_nic_notifier_block);
+
+	rtnl_lock();
+	udp_tunnel_nic_ops = NULL;
+	rtnl_unlock();
+
+	destroy_workqueue(udp_tunnel_nic_workqueue);
+}
+module_exit(udp_tunnel_nic_cleanup_module);
+
+MODULE_LICENSE("GPL");
diff --git a/net/ipv4/udp_tunnel_stub.c b/net/ipv4/udp_tunnel_stub.c
new file mode 100644
index 000000000000..c4b2888f5fef
--- /dev/null
+++ b/net/ipv4/udp_tunnel_stub.c
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright (c) 2020 Facebook Inc.
+
+#include <net/udp_tunnel.h>
+
+const struct udp_tunnel_nic_ops *udp_tunnel_nic_ops;
+EXPORT_SYMBOL_GPL(udp_tunnel_nic_ops);
-- 
2.26.2

